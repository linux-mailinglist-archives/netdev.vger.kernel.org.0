Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 05F5E64F7D3
	for <lists+netdev@lfdr.de>; Sat, 17 Dec 2022 06:30:25 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230260AbiLQFaW (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sat, 17 Dec 2022 00:30:22 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:38766 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230028AbiLQFaT (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sat, 17 Dec 2022 00:30:19 -0500
Received: from dfw.source.kernel.org (dfw.source.kernel.org [139.178.84.217])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 5CC252B243
        for <netdev@vger.kernel.org>; Fri, 16 Dec 2022 21:30:18 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id DDE9260B3B
        for <netdev@vger.kernel.org>; Sat, 17 Dec 2022 05:30:17 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPS id 448D5C433F0;
        Sat, 17 Dec 2022 05:30:17 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1671255017;
        bh=DsEHTDwRxdu7tPubQns6ZbHQAfRsuG0WEAhR7OHRAWs=;
        h=Subject:From:Date:References:In-Reply-To:To:Cc:From;
        b=kfPSjm1n6gtKwhH+enGtTaKmMX3m+pSPrVZCF14g09sM/Eerh136iRhFt9QNV7N2x
         dwa8WZXnJDt+q41t8EA2cOL+CxUUE/QKaTrZCVVgrrEQPq61QFOPwub6w+fJxd2Lu/
         4MCjrg8v2nlXdpRKsOnziP95Bg5unSejPIyVFKnJgJlxA2/bUNhV+JXGd3rUClN9lB
         xTNlIAHF4RxVDck00izOxg/ZhfN222KN5BvCEummHYesU3HrcS5P1cWECnBzAJgyWy
         1OyZfvtmuZyzDVwN0VXIRYxU9z6URdSTgBsjLE9Tcm+tHqYXFH5cIS9Bwh7NeFKGj9
         9lGtnTQsSdEAQ==
Received: from aws-us-west-2-korg-oddjob-1.ci.codeaurora.org (localhost.localdomain [127.0.0.1])
        by aws-us-west-2-korg-oddjob-1.ci.codeaurora.org (Postfix) with ESMTP id 213CAE4D00F;
        Sat, 17 Dec 2022 05:30:17 +0000 (UTC)
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Subject: Re: [PATCH net v2] skbuff: Account for tail adjustment during pull
 operations
From:   patchwork-bot+netdevbpf@kernel.org
Message-Id: <167125501713.1986.8547046931497858959.git-patchwork-notify@kernel.org>
Date:   Sat, 17 Dec 2022 05:30:17 +0000
References: <1671084718-24796-1-git-send-email-quic_subashab@quicinc.com>
In-Reply-To: <1671084718-24796-1-git-send-email-quic_subashab@quicinc.com>
To:     Subash Abhinov Kasiviswanathan <quic_subashab@quicinc.com>
Cc:     davem@davemloft.net, edumazet@google.com, kuba@kernel.org,
        pabeni@redhat.com, shmulik@metanetworks.com, willemb@google.com,
        alexanderduyck@fb.com, netdev@vger.kernel.org,
        daniel@iogearbox.net, quic_stranche@quicinc.com
X-Spam-Status: No, score=-7.1 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Hello:

This patch was applied to netdev/net.git (master)
by Jakub Kicinski <kuba@kernel.org>:

On Wed, 14 Dec 2022 23:11:58 -0700 you wrote:
> Extending the tail can have some unexpected side effects if a program uses
> a helper like BPF_FUNC_skb_pull_data to read partial content beyond the
> head skb headlen when all the skbs in the gso frag_list are linear with no
> head_frag -
> 
>   kernel BUG at net/core/skbuff.c:4219!
>   pc : skb_segment+0xcf4/0xd2c
>   lr : skb_segment+0x63c/0xd2c
>   Call trace:
>    skb_segment+0xcf4/0xd2c
>    __udp_gso_segment+0xa4/0x544
>    udp4_ufo_fragment+0x184/0x1c0
>    inet_gso_segment+0x16c/0x3a4
>    skb_mac_gso_segment+0xd4/0x1b0
>    __skb_gso_segment+0xcc/0x12c
>    udp_rcv_segment+0x54/0x16c
>    udp_queue_rcv_skb+0x78/0x144
>    udp_unicast_rcv_skb+0x8c/0xa4
>    __udp4_lib_rcv+0x490/0x68c
>    udp_rcv+0x20/0x30
>    ip_protocol_deliver_rcu+0x1b0/0x33c
>    ip_local_deliver+0xd8/0x1f0
>    ip_rcv+0x98/0x1a4
>    deliver_ptype_list_skb+0x98/0x1ec
>    __netif_receive_skb_core+0x978/0xc60
> 
> [...]

Here is the summary with links:
  - [net,v2] skbuff: Account for tail adjustment during pull operations
    https://git.kernel.org/netdev/net/c/2d7afdcbc9d3

You are awesome, thank you!
-- 
Deet-doot-dot, I am a bot.
https://korg.docs.kernel.org/patchwork/pwbot.html


