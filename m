Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 6A1A6678AD6
	for <lists+netdev@lfdr.de>; Mon, 23 Jan 2023 23:38:38 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232560AbjAWWig (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 23 Jan 2023 17:38:36 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:46236 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229956AbjAWWif (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 23 Jan 2023 17:38:35 -0500
Received: from ams.source.kernel.org (ams.source.kernel.org [145.40.68.75])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 953992412D
        for <netdev@vger.kernel.org>; Mon, 23 Jan 2023 14:38:34 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id 49FB3B80EBB
        for <netdev@vger.kernel.org>; Mon, 23 Jan 2023 22:38:33 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 710B2C433EF;
        Mon, 23 Jan 2023 22:38:31 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1674513512;
        bh=zGtsi96lKIA7mIcdj4tHfh4gGANDLkW8j/WXHuUEWyw=;
        h=Date:From:To:Cc:Subject:In-Reply-To:References:From;
        b=kz8uzRcVDUesZYyCHWc1CPgcJPxMNPO+tIByn8ErJeDzRe4umA/GnW3gegeC6SVKw
         A3s4acWl4vAFGccu3s2rXbfRwn9jaffLNby5sqwDlW/gVSEKE3XAUkJCr7gkd3R8fT
         oedXzAjw77FJPO2YJfHbEXfM2/Z3UqoUncn2SBDsM8C333QHzAq/qiS1ZXc3WrZ2mG
         K9M7dBG5f1xFjWAC+CvhRVxa+1w2iBk5CjyWJC8etcp5JLOdGk3CZ1GfGfA+s8IdZt
         P7Ihtm39Gd8QEmOB4PMDnS2PYPIklVak8w2lFDTaxa27UIKs5qFxqHawk0EvTDhKY6
         genWhqbBiW0yA==
Date:   Mon, 23 Jan 2023 14:38:30 -0800
From:   Jakub Kicinski <kuba@kernel.org>
To:     Aurelien Aptel <aaptel@nvidia.com>
Cc:     linux-nvme@lists.infradead.org, netdev@vger.kernel.org,
        sagi@grimberg.me, hch@lst.de, kbusch@kernel.org, axboe@fb.com,
        chaitanyak@nvidia.com, davem@davemloft.net,
        aurelien.aptel@gmail.com, smalin@nvidia.com, malin1024@gmail.com,
        ogerlitz@nvidia.com, yorayz@nvidia.com, borisp@nvidia.com
Subject: Re: [PATCH v9 03/25] net/ethtool: add ULP_DDP_{GET,SET} operations
 for caps and stats
Message-ID: <20230123143830.60f436ef@kernel.org>
In-Reply-To: <253o7qprtcq.fsf@mtr-vdi-124.i-did-not-set--mail-host-address--so-tickle-me>
References: <20230117153535.1945554-1-aaptel@nvidia.com>
        <20230117153535.1945554-4-aaptel@nvidia.com>
        <20230119184147.161a8ff4@kernel.org>
        <253o7qprtcq.fsf@mtr-vdi-124.i-did-not-set--mail-host-address--so-tickle-me>
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

On Mon, 23 Jan 2023 20:36:21 +0200 Aurelien Aptel wrote:
> >> Compact statistics are nested as follows:
> >>
> >>     STATS (nest)
> >>         COUNT (u32)
> >>         COMPACT_VALUES (array of u64)  
> >
> > That's not how other per-cmd stats work, why are you inventing
> > new ways..  
> 
> As we commented in patch 2, dynamic strings are used for ethtool
> forward-compability (being able to list future stats, which we are
> planning) without updating or recompiling.

But this is not how they should be carried.

The string set is retrieved by a separate command, then you request
a string based on the attribute ID (global_stringset() + get_string() 
in ethtool CLI code).

That way long running code or code dumping muliple interfaces can load
strings once and dumps are kept smaller.

> >> +     int     (*get_ulp_ddp_stats)(struct net_device *dev, struct ethtool_ulp_ddp_stats *stats);
> >> +     int     (*set_ulp_ddp_capabilities)(struct net_device *dev, unsigned long *bits);  
> >
> > Why are these two callbacks not in struct ulp_ddp_dev_ops?  
> 
> We were trying to implement these callbacks in alignment with the
> existing ethtool commands, for this reason we implemented it in the
> ethtool API.

ethtool commands mostly talk to HW, note that the feature configuration
(ethtool -k/-K) does not use ethtool ops either.

> > Why does the ethtool API not expose limits?  
> 
> Originally, and before we started adding the netlink interface, we were
> not planning to include the ability to modify the limits as part of this
> series.  We do agree that it now makes sense, but we will add, some
> limits reflect hardware limitations while other could be tweaked by
> users.  Those limits will be per-device and per-protocol. We will
> suggest how to design it.

Alright, I was mostly curious, it's not a requirement for initial
support.
