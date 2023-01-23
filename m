Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 0491D67871D
	for <lists+netdev@lfdr.de>; Mon, 23 Jan 2023 21:04:20 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232245AbjAWUER (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 23 Jan 2023 15:04:17 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:37394 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231867AbjAWUEQ (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 23 Jan 2023 15:04:16 -0500
Received: from dfw.source.kernel.org (dfw.source.kernel.org [139.178.84.217])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 76D7C30297;
        Mon, 23 Jan 2023 12:03:52 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id B9A5D6101E;
        Mon, 23 Jan 2023 20:03:21 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id E91EDC4339B;
        Mon, 23 Jan 2023 20:03:19 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1674504201;
        bh=ZHGRoFsn+EUQs1iGPUoTvzLYTnpaq6FISKkR45iFTro=;
        h=Date:From:To:Cc:Subject:In-Reply-To:References:From;
        b=qM6i+IIDqjcH4mojlWNvMQdFGCyzWZIhEo9WKN0AIWy6r1P2EzK6hmhI6K7e05/u+
         yuAlLEc1mXRUW3OD9VXgQFvd4UMYSVNaNeKBL5caMIs4NmZN1xhi1z4BEzf/Uf1akh
         U9iHLMURGhZBiFJ16l/rEiwQBx5/6PHFqZ1QrM76gWz99gXClgUt6pTraqfaKIH+ed
         1m5G4I0oj39ZAhs7MilDbE2YVziYHW01OnWMKI8Atjv2qoKla8pJ2OyjfVPqucNJcV
         I1bfIYUL9PJbPHao3HYvbFrsnC7Ee5/xWNiaHH0uamhQim2dA/dPNe70zuwN0fRol4
         KLd28kbao71Zg==
Date:   Mon, 23 Jan 2023 12:03:18 -0800
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
Subject: Re: [PATCH bpf-next 2/7] drivers: net: turn on XDP features
Message-ID: <20230123120318.358ef9a8@kernel.org>
In-Reply-To: <Y80iwBNd3tPvEbMd@lore-desk>
References: <cover.1674234430.git.lorenzo@kernel.org>
        <861224c406f78694530fde0d52c49d92e1e990a2.1674234430.git.lorenzo@kernel.org>
        <20230120191152.44d29bb1@kernel.org>
        <Y80iwBNd3tPvEbMd@lore-desk>
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

On Sun, 22 Jan 2023 12:49:20 +0100 Lorenzo Bianconi wrote:
> > Shouldn't these generate netlink notifications?  
> 
> ack, I would say we need to add NETDEV_XDP_FEAT_CHANGE case in
> netdev_genl_netdevice_event routine and maybe add a new
> NETDEV_XDP_FEAT_CHANGE flag in netdev_cmd. What do you think?

No strong preference between a full event or just a direct call until
we have another in-kernel user interested in the notification.
The changes are wrapped nicely in helpers, so we can change it later
easily.
