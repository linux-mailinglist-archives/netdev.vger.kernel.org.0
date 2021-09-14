Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 8746E40BBB3
	for <lists+netdev@lfdr.de>; Wed, 15 Sep 2021 00:36:54 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S235595AbhINWiI (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 14 Sep 2021 18:38:08 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:40848 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232371AbhINWiH (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 14 Sep 2021 18:38:07 -0400
Received: from mout-p-102.mailbox.org (mout-p-102.mailbox.org [IPv6:2001:67c:2050::465:102])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 729F9C061574;
        Tue, 14 Sep 2021 15:36:49 -0700 (PDT)
Received: from smtp202.mailbox.org (smtp202.mailbox.org [IPv6:2001:67c:2050:105:465:1:4:0])
        (using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
         key-exchange ECDHE (P-384) server-signature RSA-PSS (4096 bits) server-digest SHA256)
        (No client certificate requested)
        by mout-p-102.mailbox.org (Postfix) with ESMTPS id 4H8J9q15TVzQk2Y;
        Wed, 15 Sep 2021 00:36:47 +0200 (CEST)
X-Virus-Scanned: amavisd-new at heinlein-support.de
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=hauke-m.de; s=MBO0001;
        t=1631659005;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=8tJHrCkhKx2jagoghoX9CfvN7F39Cy3mU2Fy0DKaySM=;
        b=TTaclUudg2b8m4/TyA2GoWLhOexn1MYLNfEcjaRRtAjO5T5a3jCWhqDSbdNXfKJu4Pik5N
        SnWU+9g6stE71inKIwDWVP9fhBWKCLcxJsBOrL72mjlNPvvC2UNIkB40t5+gHjglNH9wT3
        uwuBZwP9m7gixy3eFx0GJZUCAr5pdEJKCVlEpeIuZ2UZUImWpdLFbuymN6ySdPJOEVbcsN
        RPcQfbgsitKSj3IEjPcxPUrMUSbl73m6cIg8tHYdpp0YF062F/TNduhs8PZg1YeqA3FC/s
        ywrmdVu3uyYEKT6Gr1U7oVGIzqKCTKN1fEYZr4F/AxjfEPydNGv1xwXil7VT+w==
Subject: Re: [PATCH net-next 5/8] net: lantiq: configure the burst length in
 ethernet drivers
To:     Aleksander Jan Bajkowski <olek2@wp.pl>, john@phrozen.org,
        tsbogend@alpha.franken.de, maz@kernel.org, ralf@linux-mips.org,
        ralph.hempel@lantiq.com, davem@davemloft.net, kuba@kernel.org,
        robh+dt@kernel.org, dev@kresin.me, arnd@arndb.de, jgg@ziepe.ca,
        netdev@vger.kernel.org, devicetree@vger.kernel.org,
        linux-mips@vger.kernel.org, linux-kernel@vger.kernel.org
References: <20210914212105.76186-1-olek2@wp.pl>
 <20210914212105.76186-5-olek2@wp.pl>
From:   Hauke Mehrtens <hauke@hauke-m.de>
Message-ID: <cdfd53e7-ea43-60a4-7150-11ad166ba2d1@hauke-m.de>
Date:   Wed, 15 Sep 2021 00:36:37 +0200
MIME-Version: 1.0
In-Reply-To: <20210914212105.76186-5-olek2@wp.pl>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Language: en-US
Content-Transfer-Encoding: 7bit
X-Rspamd-Queue-Id: 8B11526D
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On 9/14/21 11:21 PM, Aleksander Jan Bajkowski wrote:
> Configure the burst length in Ethernet drivers. This improves
> Ethernet performance by 58%. According to the vendor BSP,
> 8W burst length is supported by ar9 and newer SoCs.
> 
> The NAT benchmark results on xRX200 (Down/Up):
> * 2W: 330 Mb/s
> * 4W: 432 Mb/s    372 Mb/s
> * 8W: 520 Mb/s    389 Mb/s
> 
> Tested on xRX200 and xRX330.
> 
> Signed-off-by: Aleksander Jan Bajkowski <olek2@wp.pl>
> ---
>   drivers/net/ethernet/lantiq_etop.c   | 21 ++++++++++++++++++---
>   drivers/net/ethernet/lantiq_xrx200.c | 21 ++++++++++++++++++---
>   2 files changed, 36 insertions(+), 6 deletions(-)
> 
.....
> diff --git a/drivers/net/ethernet/lantiq_xrx200.c b/drivers/net/ethernet/lantiq_xrx200.c
> index fb78f17d734f..5d96248ce83b 100644
> --- a/drivers/net/ethernet/lantiq_xrx200.c
> +++ b/drivers/net/ethernet/lantiq_xrx200.c
> @@ -71,6 +71,9 @@ struct xrx200_priv {
>   	struct net_device *net_dev;
>   	struct device *dev;
>   
> +	int tx_burst_len;
> +	int rx_burst_len;
> +
>   	__iomem void *pmac_reg;
>   };
>   
> @@ -316,8 +319,8 @@ static netdev_tx_t xrx200_start_xmit(struct sk_buff *skb,
>   	if (unlikely(dma_mapping_error(priv->dev, mapping)))
>   		goto err_drop;
>   
> -	/* dma needs to start on a 16 byte aligned address */
> -	byte_offset = mapping % 16;
> +	/* dma needs to start on a burst length value aligned address */
> +	byte_offset = mapping % (priv->tx_burst_len * 4);
>   
>   	desc->addr = mapping - byte_offset;
>   	/* Make sure the address is written before we give it to HW */
> @@ -369,7 +372,7 @@ static int xrx200_dma_init(struct xrx200_priv *priv)
>   	int ret = 0;
>   	int i;
>   
> -	ltq_dma_init_port(DMA_PORT_ETOP);
> +	ltq_dma_init_port(DMA_PORT_ETOP, priv->tx_burst_len, rx_burst_len);
>   
>   	ch_rx->dma.nr = XRX200_DMA_RX;
>   	ch_rx->dma.dev = priv->dev;
> @@ -478,6 +481,18 @@ static int xrx200_probe(struct platform_device *pdev)
>   	if (err)
>   		eth_hw_addr_random(net_dev);
>   
> +	err = device_property_read_u32(dev, "lantiq,tx-burst-length", &priv->tx_burst_len);
> +	if (err < 0) {
> +		dev_err(dev, "unable to read tx-burst-length property\n");
> +		return err;
> +	}
> +
> +	err = device_property_read_u32(dev, "lantiq,rx-burst-length", &priv->rx_burst_len);
> +	if (err < 0) {
> +		dev_err(dev, "unable to read rx-burst-length property\n");
> +		return err;
> +	}
> +

I would prefer if you would hard code these values to 8 for the xrx200 
driver. All SoCs with this IP block should support this.

>   	/* bring up the dma engine and IP core */
>   	err = xrx200_dma_init(priv);
>   	if (err)
> 

Hauke
