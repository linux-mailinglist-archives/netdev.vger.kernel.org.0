Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id F010D4C542C
	for <lists+netdev@lfdr.de>; Sat, 26 Feb 2022 07:19:07 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230034AbiBZGTZ (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sat, 26 Feb 2022 01:19:25 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:57346 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230012AbiBZGTY (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sat, 26 Feb 2022 01:19:24 -0500
Received: from dfw.source.kernel.org (dfw.source.kernel.org [139.178.84.217])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id DB01BEA7;
        Fri, 25 Feb 2022 22:18:50 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 7520060BAA;
        Sat, 26 Feb 2022 06:18:50 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 6BB15C340E9;
        Sat, 26 Feb 2022 06:18:49 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1645856329;
        bh=cvyzwbI5HARqFp7JbFizipx8dXGTknMqqqUTGAQ4dbY=;
        h=Date:From:To:Cc:Subject:In-Reply-To:References:From;
        b=X/VL0230OLIO4M5oLHzzJZKdCAgFnLTWXxQroiwJhIVEMCN5kXXkuci+WfosgEEV8
         1sUzZ872pdaUYm6oNcWM5AbtEdPVi+/GQhqQea0yUfgoYY/YLvEstlhVvt1yR0Ls6m
         HSLadE9rtPuBw2gpIuu3Kxuc5E7LaP0RSy8s2I0SJnd4YDJszTVbf1yc0lZfXdgRCI
         WdX2WmHUR0z0GRd7fB44mFgXlKERNyqSOO9AWjRnm4B7W5n+xLzaLGH4n3aRmOtk0J
         9cApo5K6KMk+DDhbxfQvj+q1rcmS3EypZcDiQ9RQ+WHPOArPx6BldhjW+O3vQgvpwB
         W3kf42TomE4Ow==
Date:   Fri, 25 Feb 2022 22:18:48 -0800
From:   Jakub Kicinski <kuba@kernel.org>
To:     Felix Fietkau <nbd@nbd.name>
Cc:     netdev@vger.kernel.org, John Crispin <john@phrozen.org>,
        Sean Wang <sean.wang@mediatek.com>,
        Mark Lee <Mark-MC.Lee@mediatek.com>,
        "David S. Miller" <davem@davemloft.net>,
        Matthias Brugger <matthias.bgg@gmail.com>,
        linux-kernel@vger.kernel.org, linux-arm-kernel@lists.infradead.org,
        linux-mediatek@lists.infradead.org
Subject: Re: [PATCH 03/11] net: ethernet: mtk_eth_soc: add support for
 Wireless Ethernet Dispatch (WED)
Message-ID: <20220225221848.7c7be7f6@kicinski-fedora-PC1C0HJN.hsd1.ca.comcast.net>
In-Reply-To: <20220225101811.72103-4-nbd@nbd.name>
References: <20220225101811.72103-1-nbd@nbd.name>
        <20220225101811.72103-4-nbd@nbd.name>
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
X-Spam-Status: No, score=-7.1 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Fri, 25 Feb 2022 11:18:02 +0100 Felix Fietkau wrote:
> +	page_list = kcalloc(n_pages, sizeof(*page_list), GFP_KERNEL);
> +	if (!page_list)
> +		return -ENOMEM;
> +
> +	dev->buf_ring.size = ring_size;
> +	dev->buf_ring.pages = page_list;
> +
> +	desc = dma_alloc_coherent(dev->hw->dev, ring_size * sizeof(*desc),
> +				  &desc_phys, GFP_KERNEL);
> +	if (!desc)
> +		return -ENOMEM;
> +
> +	dev->buf_ring.desc = desc;
> +	dev->buf_ring.desc_phys = desc_phys;
> +
> +	for (i = 0, page_idx = 0; i < ring_size; i += MTK_WED_BUF_PER_PAGE) {
> +		dma_addr_t page_phys, buf_phys;
> +		struct page *page;
> +		void *buf;
> +		int s;
> +
> +		page = __dev_alloc_pages(GFP_KERNEL, 0);
> +		if (!page)
> +			return -ENOMEM;

I haven't looked at the code, yet, but this sure looks leaky.
