Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 7CB314F96BD
	for <lists+netdev@lfdr.de>; Fri,  8 Apr 2022 15:33:36 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S236290AbiDHNfR (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 8 Apr 2022 09:35:17 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:57596 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232120AbiDHNfQ (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 8 Apr 2022 09:35:16 -0400
Received: from vps0.lunn.ch (vps0.lunn.ch [185.16.172.187])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 67AE91F7604
        for <netdev@vger.kernel.org>; Fri,  8 Apr 2022 06:33:13 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed; d=lunn.ch;
        s=20171124; h=In-Reply-To:Content-Disposition:Content-Type:MIME-Version:
        References:Message-ID:Subject:Cc:To:From:Date:From:Sender:Reply-To:Subject:
        Date:Message-ID:To:Cc:MIME-Version:Content-Type:Content-Transfer-Encoding:
        Content-ID:Content-Description:Content-Disposition:In-Reply-To:References;
        bh=5o8g+vs7tjMj2AC5KlN/kDE4AcLAHavx4e2QyJSznh4=; b=jsKxvlOYmp/6mE/hYPGzxBXk7E
        jwH5S3nrhJUpUMjAxrxYIsBMRStWV3btmvLwkLX+e1fwyd2GyiMhtWlQtIlfBfC5yndedA/h7D51L
        3lv1IHL5ipgPqN+KLeKTI+3NvqIZ1nYS2Gl00ojcwmR00FYaDW0FP6tIZ1ApGyEU3JEk=;
Received: from andrew by vps0.lunn.ch with local (Exim 4.94.2)
        (envelope-from <andrew@lunn.ch>)
        id 1ncoje-00EpkW-1a; Fri, 08 Apr 2022 15:33:10 +0200
Date:   Fri, 8 Apr 2022 15:33:10 +0200
From:   Andrew Lunn <andrew@lunn.ch>
To:     Lorenzo Bianconi <lorenzo@kernel.org>
Cc:     netdev@vger.kernel.org, lorenzo.bianconi@redhat.com,
        davem@davemloft.net, kuba@kernel.org, pabeni@redhat.com,
        thomas.petazzoni@bootlin.com, ilias.apalodimas@linaro.org,
        jbrouer@redhat.com, jdamato@fastly.com
Subject: Re: [PATCH v2 net-next 1/2] net: page_pool: introduce ethtool stats
Message-ID: <YlA5low6p+Hh1jBu@lunn.ch>
References: <cover.1649405981.git.lorenzo@kernel.org>
 <63efff0da4235bfa2e326848545eb90c211e5db1.1649405981.git.lorenzo@kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <63efff0da4235bfa2e326848545eb90c211e5db1.1649405981.git.lorenzo@kernel.org>
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,SPF_HELO_PASS,SPF_PASS,
        T_SCC_BODY_TEXT_LINE,URIBL_BLOCKED autolearn=ham autolearn_force=no
        version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

> +/* List of page_pool stats exported through ethtool. */
> +enum {
> +	PP_ETHTOOL_ALLOC_FAST,
> +	PP_ETHTOOL_ALLOC_SLOW,
> +	PP_ETHTOOL_ALLOC_SLOW_HIGH_ORDER,
> +	PP_ETHTOOL_ALLOC_EMPTY,
> +	PP_ETHTOOL_ALLOC_REFILL,
> +	PP_ETHTOOL_ALLOC_WAIVE,
> +	PP_ETHTOOL_RECYCLE_CACHED,
> +	PP_ETHTOOL_RECYCLE_CACHE_FULL,
> +	PP_ETHTOOL_RECYCLE_RING,
> +	PP_ETHTOOL_RECYCLE_RING_FULL,
> +	PP_ETHTOOL_RECYCLE_RELEASED_REF,
> +	PP_ETHTOOL_STATS_MAX,

> +u64 *page_pool_ethtool_stats_get(u64 *data, struct page_pool_stats *stats)
> +{
> +	int i;
> +
> +	for (i = 0; i < PP_ETHTOOL_STATS_MAX; i++) {
> +		switch (i) {
> +		case PP_ETHTOOL_ALLOC_FAST:
> +			*data++ = stats->alloc_stats.fast;
> +			break;
> +		case PP_ETHTOOL_ALLOC_SLOW:
> +			*data++ = stats->alloc_stats.slow;
> +			break;
> +		case PP_ETHTOOL_ALLOC_SLOW_HIGH_ORDER:
> +			*data++ = stats->alloc_stats.slow_high_order;
> +			break;
> +		case PP_ETHTOOL_ALLOC_EMPTY:

What is the purpose of this enum? The order should be fixed, so just do:

			*data++ = stats->alloc_stats.fast;
			*data++ = stats->alloc_stats.slow;
			*data++ = stats->alloc_stats.slow_high_order;

and don't use the enum.

    Andrew
