Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 7FCAE4F870E
	for <lists+netdev@lfdr.de>; Thu,  7 Apr 2022 20:25:51 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233348AbiDGS1t (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 7 Apr 2022 14:27:49 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:43428 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232949AbiDGS1s (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 7 Apr 2022 14:27:48 -0400
Received: from vps0.lunn.ch (vps0.lunn.ch [185.16.172.187])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 125802D8
        for <netdev@vger.kernel.org>; Thu,  7 Apr 2022 11:25:47 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed; d=lunn.ch;
        s=20171124; h=In-Reply-To:Content-Disposition:Content-Type:MIME-Version:
        References:Message-ID:Subject:Cc:To:From:Date:From:Sender:Reply-To:Subject:
        Date:Message-ID:To:Cc:MIME-Version:Content-Type:Content-Transfer-Encoding:
        Content-ID:Content-Description:Content-Disposition:In-Reply-To:References;
        bh=9h9+nALkwRHM4ptqhgrPwuAVRma1QzbhSn0dAJDrY70=; b=hYF+BNXVaTVPaV0n02//VL2k7r
        ZrqqlQEo5K3pbsb6DPC+a/Sr0XtDrAatNzgbDGs2Jkzr1N/phsdTwOtUs/YIXuxu6vrocIFRyzImR
        EFqjyPjaTzd1ditEQ5zI/N1J2zkFLfEUCnyjXE/k64dIh6h7Y+o1ErSaDH/uuvCYr3RE=;
Received: from andrew by vps0.lunn.ch with local (Exim 4.94.2)
        (envelope-from <andrew@lunn.ch>)
        id 1ncWpE-00EgwH-N9; Thu, 07 Apr 2022 20:25:44 +0200
Date:   Thu, 7 Apr 2022 20:25:44 +0200
From:   Andrew Lunn <andrew@lunn.ch>
To:     Lorenzo Bianconi <lorenzo@kernel.org>
Cc:     netdev@vger.kernel.org, lorenzo.bianconi@redhat.com,
        davem@davemloft.net, kuba@kernel.org, pabeni@redhat.com,
        thomas.petazzoni@bootlin.com, ilias.apalodimas@linaro.org,
        jbrouer@redhat.com, jdamato@fastly.com
Subject: Re: [RFC net-next 2/2] net: mvneta: add support for
 page_pool_get_stats
Message-ID: <Yk8sqA8sxutE+HRO@lunn.ch>
References: <cover.1649350165.git.lorenzo@kernel.org>
 <cd1bb62e5efe9d151fe96a5224add25122f5044a.1649350165.git.lorenzo@kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <cd1bb62e5efe9d151fe96a5224add25122f5044a.1649350165.git.lorenzo@kernel.org>
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,SPF_HELO_PASS,SPF_PASS,
        T_SCC_BODY_TEXT_LINE,URIBL_BLOCKED autolearn=ham autolearn_force=no
        version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

> +static void mvneta_ethtool_pp_stats(struct mvneta_port *pp, u64 *data)
> +{
> +	struct page_pool_stats stats = {};
> +	int i;
> +
> +	for (i = 0; i < rxq_number; i++) {
> +		struct page_pool *page_pool = pp->rxqs[i].page_pool;
> +		struct page_pool_stats pp_stats = {};
> +
> +		if (!page_pool_get_stats(page_pool, &pp_stats))
> +			continue;
> +
> +		stats.alloc_stats.fast += pp_stats.alloc_stats.fast;
> +		stats.alloc_stats.slow += pp_stats.alloc_stats.slow;
> +		stats.alloc_stats.slow_high_order +=
> +			pp_stats.alloc_stats.slow_high_order;
> +		stats.alloc_stats.empty += pp_stats.alloc_stats.empty;
> +		stats.alloc_stats.refill += pp_stats.alloc_stats.refill;
> +		stats.alloc_stats.waive += pp_stats.alloc_stats.waive;
> +		stats.recycle_stats.cached += pp_stats.recycle_stats.cached;
> +		stats.recycle_stats.cache_full +=
> +			pp_stats.recycle_stats.cache_full;
> +		stats.recycle_stats.ring += pp_stats.recycle_stats.ring;
> +		stats.recycle_stats.ring_full +=
> +			pp_stats.recycle_stats.ring_full;
> +		stats.recycle_stats.released_refcnt +=
> +			pp_stats.recycle_stats.released_refcnt;

We should be trying to remove this sort of code from the driver, and
put it all in the core.  It wants to be something more like:

	struct page_pool_stats stats = {};
	int i;

	for (i = 0; i < rxq_number; i++) {
		struct page_pool *page_pool = pp->rxqs[i].page_pool;

		if (!page_pool_get_stats(page_pool, &stats))
			continue;

	page_pool_ethtool_stats_get(data, &stats);

Let page_pool_get_stats() do the accumulate as it puts values in stats.

You probably should also rework the mellanox driver to use the same
code structure.

    Andrew

    
