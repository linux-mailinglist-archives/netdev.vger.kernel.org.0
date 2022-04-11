Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 091894FBB70
	for <lists+netdev@lfdr.de>; Mon, 11 Apr 2022 13:57:56 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1344001AbiDKL7c (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 11 Apr 2022 07:59:32 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:59900 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1345667AbiDKL7a (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 11 Apr 2022 07:59:30 -0400
Received: from vps0.lunn.ch (vps0.lunn.ch [185.16.172.187])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 498DC35DCD
        for <netdev@vger.kernel.org>; Mon, 11 Apr 2022 04:57:15 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed; d=lunn.ch;
        s=20171124; h=In-Reply-To:Content-Disposition:Content-Type:MIME-Version:
        References:Message-ID:Subject:Cc:To:From:Date:From:Sender:Reply-To:Subject:
        Date:Message-ID:To:Cc:MIME-Version:Content-Type:Content-Transfer-Encoding:
        Content-ID:Content-Description:Content-Disposition:In-Reply-To:References;
        bh=frSCs2WFDALmTFpgrJn8pMHiz7ySI98nPqrbEDas8MQ=; b=YSKG5tsZ1BVa4nwo7nsXJJJMhN
        bpmQbfOv7602uZnWgGzq6sV4IIIumzpK7JyimZs4/NoTLf42a9EuAiP5q6aLdzExTaGCHAaZ14zH6
        /tFP5K2SLastpOjvgC5JPSzQdLhOtivKb1Y1glVIWEcFgG6mnwFdlyV1/kXG3YQOjIi4=;
Received: from andrew by vps0.lunn.ch with local (Exim 4.94.2)
        (envelope-from <andrew@lunn.ch>)
        id 1ndsfP-00FFX9-7w; Mon, 11 Apr 2022 13:57:11 +0200
Date:   Mon, 11 Apr 2022 13:57:11 +0200
From:   Andrew Lunn <andrew@lunn.ch>
To:     Lorenzo Bianconi <lorenzo@kernel.org>
Cc:     netdev@vger.kernel.org, lorenzo.bianconi@redhat.com,
        davem@davemloft.net, kuba@kernel.org, pabeni@redhat.com,
        thomas.petazzoni@bootlin.com, linux@armlinux.org.uk,
        jbrouer@redhat.com, ilias.apalodimas@linaro.org, jdamato@fastly.com
Subject: Re: [PATCH v3 net-next 1/2] net: page_pool: introduce ethtool stats
Message-ID: <YlQXl2a6vctIxXuP@lunn.ch>
References: <cover.1649528984.git.lorenzo@kernel.org>
 <628c0a6d9bdbc547c93fcd4ae2e84d08af7bc8e1.1649528984.git.lorenzo@kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <628c0a6d9bdbc547c93fcd4ae2e84d08af7bc8e1.1649528984.git.lorenzo@kernel.org>
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,SPF_HELO_PASS,SPF_PASS,
        T_SCC_BODY_TEXT_LINE autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

> diff --git a/include/net/page_pool.h b/include/net/page_pool.h
> index ea5fb70e5101..94b2d666db03 100644
> --- a/include/net/page_pool.h
> +++ b/include/net/page_pool.h
> @@ -117,6 +117,10 @@ struct page_pool_stats {
>  	struct page_pool_recycle_stats recycle_stats;
>  };
>  
> +int page_pool_ethtool_stats_get_count(void);
> +u8 *page_pool_ethtool_stats_get_strings(u8 *data);
> +u64 *page_pool_ethtool_stats_get(u64 *data, struct page_pool_stats *stats);
> +
>  /*
>   * Drivers that wish to harvest page pool stats and report them to users
>   * (perhaps via ethtool, debugfs, or another mechanism) can allocate a

You could also add stub function here for when the page pool
statistics are disabled. We can then avoid all the messy #ifdef in the
drivers.

> +u64 *page_pool_ethtool_stats_get(u64 *data, struct page_pool_stats *stats)
> +{
> +	int i;
> +
> +	for (i = 0; i < ARRAY_SIZE(pp_stats); i++) {
> +		*data++ = stats->alloc_stats.fast;
> +		*data++ = stats->alloc_stats.slow;
> +		*data++ = stats->alloc_stats.slow_high_order;
> +		*data++ = stats->alloc_stats.empty;
> +		*data++ = stats->alloc_stats.refill;
> +		*data++ = stats->alloc_stats.waive;
> +		*data++ = stats->recycle_stats.cached;
> +		*data++ = stats->recycle_stats.cache_full;
> +		*data++ = stats->recycle_stats.ring;
> +		*data++ = stats->recycle_stats.ring_full;
> +		*data++ = stats->recycle_stats.released_refcnt;
> +	}
> +
> +	return data;

What is the purpose of the loop?

     Andrew
