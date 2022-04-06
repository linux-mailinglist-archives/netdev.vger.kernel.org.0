Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 968A14F64BA
	for <lists+netdev@lfdr.de>; Wed,  6 Apr 2022 18:08:43 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S237271AbiDFQKQ (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 6 Apr 2022 12:10:16 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:49712 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S237256AbiDFQJN (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 6 Apr 2022 12:09:13 -0400
Received: from vps0.lunn.ch (vps0.lunn.ch [185.16.172.187])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id E3A64245074
        for <netdev@vger.kernel.org>; Wed,  6 Apr 2022 06:38:51 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed; d=lunn.ch;
        s=20171124; h=In-Reply-To:Content-Disposition:Content-Type:MIME-Version:
        References:Message-ID:Subject:Cc:To:From:Date:From:Sender:Reply-To:Subject:
        Date:Message-ID:To:Cc:MIME-Version:Content-Type:Content-Transfer-Encoding:
        Content-ID:Content-Description:Content-Disposition:In-Reply-To:References;
        bh=309vV6+q0pJrWbskIC3byRM0lpnGJaDG6/iASKjKfa4=; b=aYuzJUMzuedsqNT/MeLsZi6G8c
        HV697SGXP5mSzy8rjSBSNgFRBe1NV2NdkWVrf7sMoOPulkSog1ocFm2cTqlS9qXSOaK9EKRT3733n
        /HD2XFBc986DprGbtslS+uLHe61bi+pWP7YM8FaRwr/Nuk/e4DT7s03tCpsC5qyOJ8zc=;
Received: from andrew by vps0.lunn.ch with local (Exim 4.94.2)
        (envelope-from <andrew@lunn.ch>)
        id 1nc5s0-00ESKX-6a; Wed, 06 Apr 2022 15:38:48 +0200
Date:   Wed, 6 Apr 2022 15:38:48 +0200
From:   Andrew Lunn <andrew@lunn.ch>
To:     Lorenzo Bianconi <lorenzo@kernel.org>
Cc:     netdev@vger.kernel.org, lorenzo.bianconi@redhat.com,
        davem@davemloft.net, kuba@kernel.org, pabeni@redhat.com,
        thomas.petazzoni@bootlin.com, linux@armlinux.org.uk,
        jbrouer@redhat.com, ilias.apalodimas@linaro.org, jdamato@fastly.com
Subject: Re: [PATCH net-next] net: mvneta: add support for page_pool_get_stats
Message-ID: <Yk2X6KPyeN3z7OUW@lunn.ch>
References: <e4a3bb0fb407ead607b85f7f041f24b586c8b99d.1649190493.git.lorenzo@kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <e4a3bb0fb407ead607b85f7f041f24b586c8b99d.1649190493.git.lorenzo@kernel.org>
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,SPF_HELO_PASS,SPF_PASS,
        T_SCC_BODY_TEXT_LINE autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

> +static void mvneta_ethtool_update_pp_stats(struct mvneta_port *pp,
> +					   struct page_pool_stats *stats)
> +{
> +	int i;
> +
> +	memset(stats, 0, sizeof(*stats));
> +	for (i = 0; i < rxq_number; i++) {
> +		struct page_pool *page_pool = pp->rxqs[i].page_pool;
> +		struct page_pool_stats pp_stats = {};
> +
> +		if (!page_pool_get_stats(page_pool, &pp_stats))
> +			continue;
> +
> +		stats->alloc_stats.fast += pp_stats.alloc_stats.fast;
> +		stats->alloc_stats.slow += pp_stats.alloc_stats.slow;
> +		stats->alloc_stats.slow_high_order +=
> +			pp_stats.alloc_stats.slow_high_order;
> +		stats->alloc_stats.empty += pp_stats.alloc_stats.empty;
> +		stats->alloc_stats.refill += pp_stats.alloc_stats.refill;
> +		stats->alloc_stats.waive += pp_stats.alloc_stats.waive;
> +		stats->recycle_stats.cached += pp_stats.recycle_stats.cached;
> +		stats->recycle_stats.cache_full +=
> +			pp_stats.recycle_stats.cache_full;
> +		stats->recycle_stats.ring += pp_stats.recycle_stats.ring;
> +		stats->recycle_stats.ring_full +=
> +			pp_stats.recycle_stats.ring_full;
> +		stats->recycle_stats.released_refcnt +=
> +			pp_stats.recycle_stats.released_refcnt;

Am i right in saying, these are all software stats? They are also
generic for any receive queue using the page pool?

It seems odd the driver is doing the addition here. Why not pass stats
into page_pool_get_stats()? That will make it easier when you add
additional statistics?

I'm also wondering if ethtool -S is even the correct API. It should be
for hardware dependent statistics, those which change between
implementations. Where as these statistics should be generic. Maybe
they should be in /sys/class/net/ethX/statistics/ and the driver
itself is not even involved, the page pool code implements it?

       Andrew
