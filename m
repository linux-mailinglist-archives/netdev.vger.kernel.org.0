Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id B91265A4381
	for <lists+netdev@lfdr.de>; Mon, 29 Aug 2022 09:04:54 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229585AbiH2HEw (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 29 Aug 2022 03:04:52 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:47936 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229611AbiH2HEu (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 29 Aug 2022 03:04:50 -0400
Received: from ams.source.kernel.org (ams.source.kernel.org [145.40.68.75])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 67ED7B7C6
        for <netdev@vger.kernel.org>; Mon, 29 Aug 2022 00:04:50 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id DE0A0B80A4A
        for <netdev@vger.kernel.org>; Mon, 29 Aug 2022 07:04:48 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id CE450C433D6;
        Mon, 29 Aug 2022 07:04:46 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1661756687;
        bh=7kAKG4tB+2/9VJ+WudVFkQQDJCN/bW9VYWgzFjVS/hg=;
        h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
        b=pTtJ7g9MS+8tDQtFWmrtfjWRld8TduGd8RoA6fLIPPR06HRf8WBWw/STcrgAt2/rg
         06aA6xY+T/b8Dj/cQFGrUm963nSQXaz7RbOlUdsidj8rSH/V0BgUKsujvLDnUgUdXn
         89jMcHNja45Kvvi11cnNLGgr5RY/X+V0JGgg57NtGJjcahpM1aCH8mqiQiZ49Tf7DH
         VzIwbWjGSciU8+M92jNiRK6nd3AbAgWIQfo4kUXpiVD2TiTnAl7hLmIQSa69TkzGDu
         vSEDBiKvr0gOc8Ycxh6GqCjLqTT/z1OYtqs07ZKPq0482Ub0UR21MLFy6WZc0mSe8t
         WMPcToQ9prPlg==
Date:   Mon, 29 Aug 2022 10:04:43 +0300
From:   Leon Romanovsky <leon@kernel.org>
To:     Hyong Youb Kim <hyonkim@cisco.com>
Cc:     saeedm@nvidia.com, netdev@vger.kernel.org, kuba@kernel.org,
        davem@davemloft.net, aviadye@mellanox.com,
        steffen.klassert@secunet.com, Raed Salem <raeds@nvidia.com>
Subject: Re: [PATCH] net/mlx5e: Do not increment ESN when updating IPsec ESN
 state
Message-ID: <YwxlC5XrXchGWUUX@unreal>
References: <20220822052551.26903-1-hyonkim@cisco.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20220822052551.26903-1-hyonkim@cisco.com>
X-Spam-Status: No, score=-7.1 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Sun, Aug 21, 2022 at 10:25:51PM -0700, Hyong Youb Kim wrote:
> An offloaded SA stops receiving after about 2^32 + replay_window
> packets. For example, when SA reaches <seq-hi 0x1, seq 0x2c>, all
> subsequent packets get dropped with SA-icv-failure (integrity_failed).
> 
> To reproduce the bug:
> - ConnectX-6 Dx with crypto enabled (FW 22.30.1004)
> - ipsec.conf:
>   nic-offload = yes
>   replay-window = 32
>   esn = yes
>   salifetime=24h
> - Run netperf for a long time to send more than 2^32 packets
>   netperf -H <device-under-test> -t TCP_STREAM -l 20000
> 
> When 2^32 + replay_window packets are received, the replay window
> moves from the 2nd half of subspace (overlap=1) to the 1st half
> (overlap=0). The driver then updates the 'esn' value in NIC
> (i.e. seq_hi) as follows.
> 
>  seq_hi = xfrm_replay_seqhi(seq_bottom)
>  new esn in NIC = seq_hi + 1
> 
> The +1 increment is wrong, as seq_hi already contains the correct
> seq_hi. For example, when seq_hi=1, the driver actually tells NIC to
> use seq_hi=2 (esn). This incorrect esn value causes all subsequent
> packets to fail integrity checks (SA-icv-failure). So, do not
> increment.
> 
> Fixes: cb01008390bb ("net/mlx5: IPSec, Add support for ESN")
> Signed-off-by: Hyong Youb Kim <hyonkim@cisco.com>
> ---
>  drivers/net/ethernet/mellanox/mlx5/core/en_accel/ipsec.c | 3 ---
>  1 file changed, 3 deletions(-)
> 

Thanks,
Acked-by: Leon Romanovsky <leonro@nvidia.com>
