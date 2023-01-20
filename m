Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 5FEE4674C06
	for <lists+netdev@lfdr.de>; Fri, 20 Jan 2023 06:20:09 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231161AbjATFUB (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 20 Jan 2023 00:20:01 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:52918 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231362AbjATFTj (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 20 Jan 2023 00:19:39 -0500
Received: from ams.source.kernel.org (ams.source.kernel.org [IPv6:2604:1380:4601:e00::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 057BE7DFAF
        for <netdev@vger.kernel.org>; Thu, 19 Jan 2023 21:09:09 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id 69712B827EF
        for <netdev@vger.kernel.org>; Fri, 20 Jan 2023 02:41:51 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 6C92CC433EF;
        Fri, 20 Jan 2023 02:41:49 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1674182510;
        bh=Xz3zatQSz9Zcksn94QOu5jr/WEbK8BuajgZW6wIcs3s=;
        h=Date:From:To:Cc:Subject:In-Reply-To:References:From;
        b=aQHvf3FVNyva9VA/VyBlM6rzTMscEufsjMg8ZrOT2eMbjuSnY1gtpQ2IIx8oUylPH
         BI33JMf2jn9fyLm/dZ58ofY03rB8eFCVdiZYKn7LtWN0f6yCcZ5sKC9H/OS2obIl7J
         B1D6l7ZhZA67TztQNPJhbl0ZgzpKyU5YZs1qxBqB3MDUvp5X+6LOdDx42Y1yVc7LOt
         q7Wg3Ovcq7wF3ASANIcq5UoVlZGJr4fqaQcHXRth9gvA6XE7KWigK9yKNzb9tGjawA
         k1tEwThswizAB8yNWJnyEW/HSvhdd8U+XzxTH4ha+a/12OOJ8LFeo8T1dl4y3UW3Gp
         xdx5bMU3LMGew==
Date:   Thu, 19 Jan 2023 18:41:47 -0800
From:   Jakub Kicinski <kuba@kernel.org>
To:     Aurelien Aptel <aaptel@nvidia.com>
Cc:     linux-nvme@lists.infradead.org, netdev@vger.kernel.org,
        sagi@grimberg.me, hch@lst.de, kbusch@kernel.org, axboe@fb.com,
        chaitanyak@nvidia.com, davem@davemloft.net,
        aurelien.aptel@gmail.com, smalin@nvidia.com, malin1024@gmail.com,
        ogerlitz@nvidia.com, yorayz@nvidia.com, borisp@nvidia.com
Subject: Re: [PATCH v9 03/25] net/ethtool: add ULP_DDP_{GET,SET} operations
 for caps and stats
Message-ID: <20230119184147.161a8ff4@kernel.org>
In-Reply-To: <20230117153535.1945554-4-aaptel@nvidia.com>
References: <20230117153535.1945554-1-aaptel@nvidia.com>
        <20230117153535.1945554-4-aaptel@nvidia.com>
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

On Tue, 17 Jan 2023 17:35:13 +0200 Aurelien Aptel wrote:
> This commit adds:
> 
> - 2 new netlink messages:
>   * ULP_DDP_GET: returns a bitset of supported and active capabilities
>   * ULP_DDP_SET: tries to activate requested bitset and returns results
> 
> - 2 new netdev ethtool_ops operations:
>   * ethtool_ops->get_ulp_ddp_stats(): retrieve device statistics
>   * ethtool_ops->set_ulp_ddp_capabilities(): try to apply
>     capability changes
> 
> ULP DDP capabilities handling is similar to netdev features
> handling.
> 
> If a ULP_DDP_GET message has requested statistics via the
> ETHTOOL_FLAG_STATS header flag, then per-device statistics are

s/per-device// ?

> returned to userspace.
> 
> Similar to netdev features, ULP_DDP_GET capabilities and statistics
> can be returned in a verbose (default) or compact form (if
> ETHTOOL_FLAG_COMPACT_BITSET is set in header flags).
> 
> Verbose statistics are nested as follows:
> 
>     STATS (nest)
>         COUNT (u32)
>         MAP (nest)
>             ITEM (nest)
>                 NAME (strz)
>                 VAL  (u64)
>             ...
> Compact statistics are nested as follows:
> 
>     STATS (nest)
>         COUNT (u32)
>         COMPACT_VALUES (array of u64)

That's not how other per-cmd stats work, why are you inventing 
new ways..

> +	int	(*get_ulp_ddp_stats)(struct net_device *dev, struct ethtool_ulp_ddp_stats *stats);
> +	int	(*set_ulp_ddp_capabilities)(struct net_device *dev, unsigned long *bits);

Why are these two callbacks not in struct ulp_ddp_dev_ops?

Why does the ethtool API not expose limits?

