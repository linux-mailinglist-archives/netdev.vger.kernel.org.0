Return-Path: <netdev+bounces-1884-lists+netdev=lfdr.de@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [IPv6:2604:1380:45e3:2400::1])
	by mail.lfdr.de (Postfix) with ESMTPS id D0CE16FF66E
	for <lists+netdev@lfdr.de>; Thu, 11 May 2023 17:49:58 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id 8E575281840
	for <lists+netdev@lfdr.de>; Thu, 11 May 2023 15:49:57 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id C4081629;
	Thu, 11 May 2023 15:49:39 +0000 (UTC)
X-Original-To: netdev@vger.kernel.org
Received: from lindbergh.monkeyblade.net (lindbergh.monkeyblade.net [23.128.96.19])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id B7EC6652
	for <netdev@vger.kernel.org>; Thu, 11 May 2023 15:49:39 +0000 (UTC)
Received: from vps0.lunn.ch (vps0.lunn.ch [156.67.10.101])
	by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 8CBEC4C3F;
	Thu, 11 May 2023 08:49:22 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed; d=lunn.ch;
	s=20171124; h=In-Reply-To:Content-Disposition:Content-Type:MIME-Version:
	References:Message-ID:Subject:Cc:To:From:Date:From:Sender:Reply-To:Subject:
	Date:Message-ID:To:Cc:MIME-Version:Content-Type:Content-Transfer-Encoding:
	Content-ID:Content-Description:Content-Disposition:In-Reply-To:References;
	bh=E7i+xfg7Zmreb4Vww4EYKdJmkpv928hvjj/hafEYQT0=; b=1M5qqDtAkcn+e6iqllMITj2Nmy
	U756c5EXwyGGyFDZlxHj9uDncFUTsXS7nQbZgXV8HxqdWcquRn7z9S0aRiIN/wNqbqfmobsA6UzcY
	ZwDulJZWQ/d6D9Y+7Y5p59yV531pEJb5aNNP1oQ8mvRs0uhFCTKosjuCtP55wP/XXr2k=;
Received: from andrew by vps0.lunn.ch with local (Exim 4.94.2)
	(envelope-from <andrew@lunn.ch>)
	id 1px8XW-00CZd1-2A; Thu, 11 May 2023 17:49:10 +0200
Date: Thu, 11 May 2023 17:49:10 +0200
From: Andrew Lunn <andrew@lunn.ch>
To: Pranavi Somisetty <pranavi.somisetty@amd.com>
Cc: nicolas.ferre@microchip.com, claudiu.beznea@microchip.com,
	davem@davemloft.net, edumazet@google.com, kuba@kernel.org,
	pabeni@redhat.com, richardcochran@gmail.com, linux@armlinux.org.uk,
	palmer@dabbelt.com, git@amd.com, michal.simek@amd.com,
	harini.katakam@amd.com, radhey.shyam.pandey@amd.com,
	netdev@vger.kernel.org, linux-kernel@vger.kernel.org,
	linux-riscv@lists.infradead.org
Subject: Re: [PATCH net-next v2 2/2] net: macb: Add support for partial store
 and forward
Message-ID: <3a3c6241-2134-42d0-8dd3-0c96d8e7300b@lunn.ch>
References: <20230511071214.18611-1-pranavi.somisetty@amd.com>
 <20230511071214.18611-3-pranavi.somisetty@amd.com>
Precedence: bulk
X-Mailing-List: netdev@vger.kernel.org
List-Id: <netdev.vger.kernel.org>
List-Subscribe: <mailto:netdev+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:netdev+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20230511071214.18611-3-pranavi.somisetty@amd.com>
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,SPF_HELO_PASS,SPF_PASS,
	T_SCC_BODY_TEXT_LINE autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
	lindbergh.monkeyblade.net

> +	if (GEM_BFEXT(PBUF_CUTTHRU, gem_readl(bp, DCFG6))) {
> +		if (bp->caps & MACB_CAPS_PARTIAL_STORE_FORWARD) {
> +			retval = of_property_read_u16(bp->pdev->dev.of_node,
> +						      "rx-watermark",
> +						      &bp->rx_watermark);
> +
> +			/* Disable partial store and forward in case of error or
> +			 * invalid watermark value
> +			 */
> +			wtrmrk_rst_val = (1 << (GEM_BFEXT(RX_PBUF_ADDR, gem_readl(bp, DCFG2)))) - 1;
> +			if (retval || bp->rx_watermark > wtrmrk_rst_val || !bp->rx_watermark) {
> +				if (bp->rx_watermark > wtrmrk_rst_val) {
> +					dev_info(&bp->pdev->dev, "Invalid watermark value\n");
> +					bp->rx_watermark = 0;

Please return -EINVAL. We want the DT author to fix their error.

> +				}
> +				dev_info(&bp->pdev->dev, "Not enabling partial store and forward\n");

The DT property is optional? So when it is missing, retval will be
-EINVAL. Please don't spam the logs in this case.

	 Andrew

