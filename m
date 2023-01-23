Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 8355E6786FD
	for <lists+netdev@lfdr.de>; Mon, 23 Jan 2023 21:01:13 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232821AbjAWUBL (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 23 Jan 2023 15:01:11 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:33000 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232498AbjAWUBL (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 23 Jan 2023 15:01:11 -0500
Received: from ams.source.kernel.org (ams.source.kernel.org [145.40.68.75])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id D07013250A;
        Mon, 23 Jan 2023 12:01:06 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id 84836B80E90;
        Mon, 23 Jan 2023 20:01:05 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 0A959C433D2;
        Mon, 23 Jan 2023 20:01:02 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1674504064;
        bh=vqEimsY5LBzrTAQ7n4n4VvmHMDNV84XzmYU29KVrP4o=;
        h=Date:From:To:Cc:Subject:In-Reply-To:References:From;
        b=J0QoGS06LIl1BueKN5MFAcpX4Ogp8CU3WelsF2LwNSdERuAftghnW3CYLzYKWVjsP
         xmYh4JPOTbCxgDdKDLsDkCEH2WgmpxvdtzsGtQnxaOy3b9P+TKf63yK8lNYpNBczVP
         m5K6UGP/becSfip52jknwldqowODhQ2YPxvzkkcJziUY5WOQbtoQx9wXAByMbfGLt8
         1T8WYReqxfsXnq8fWpc3byv7cuYMIY5hd2WMDUh+O2HvNJU74UaNn2Ym5t+OnQ135q
         LKyCMduIKpK6k0SJZ6xNwuz1q+YmLJSLuMkfgnrfl7abQvT/HP8225kuw7TN2HJTbg
         qUSddea5BV1Yw==
Date:   Mon, 23 Jan 2023 12:01:01 -0800
From:   Jakub Kicinski <kuba@kernel.org>
To:     Lorenzo Bianconi <lorenzo@kernel.org>
Cc:     bpf@vger.kernel.org, netdev@vger.kernel.org, ast@kernel.org,
        daniel@iogearbox.net, andrii@kernel.org, davem@davemloft.net,
        hawk@kernel.org, pabeni@redhat.com, edumazet@google.com,
        toke@redhat.com, memxor@gmail.com, alardam@gmail.com,
        saeedm@nvidia.com, anthony.l.nguyen@intel.com, gospo@broadcom.com,
        vladimir.oltean@nxp.com, nbd@nbd.name, john@phrozen.org,
        leon@kernel.org, simon.horman@corigine.com, aelior@marvell.com,
        christophe.jaillet@wanadoo.fr, ecree.xilinx@gmail.com,
        mst@redhat.com, bjorn@kernel.org, magnus.karlsson@intel.com,
        maciej.fijalkowski@intel.com, intel-wired-lan@lists.osuosl.org,
        lorenzo.bianconi@redhat.com, niklas.soderlund@corigine.com
Subject: Re: [PATCH bpf-next 1/7] netdev-genl: create a simple family for
 netdev stuff
Message-ID: <20230123120101.555a3446@kernel.org>
In-Reply-To: <Y82//2EX6QQoZkV/@lore-desk>
References: <cover.1674234430.git.lorenzo@kernel.org>
        <272fa19f57de2d14e9666b4cd9b1ae8a61a94807.1674234430.git.lorenzo@kernel.org>
        <20230120191126.06c9d514@kernel.org>
        <Y82//2EX6QQoZkV/@lore-desk>
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
X-Spam-Status: No, score=-7.1 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Mon, 23 Jan 2023 00:00:15 +0100 Lorenzo Bianconi wrote:
> > FWIW I'm not 100% sure if we should scope the family to all of netdev
> > or just xdp. Same for the name of the op, should we call the op dev_get
> > or dev_xdp_get..  
> 
> is it likely we are going to add non-xdp info here in the near future? If not
> I would say we can target just xdp for the moment.

What brought it to mind for me was offloads like the NVMe/DDP for
instance. Whether that stuff should live in ethtool or a netdev
family is a bit unclear.

> > These defines don't belong in uAPI. Especially the use of BIT().  
> 
> since netdev xdp_features is a bitmask, can we use 'flags' as type for definitions in
> netdev.yaml so we can get rid of this BIT() definitions for both user and
> kernel space?

If you have no use for the bit numbers - definitely.
