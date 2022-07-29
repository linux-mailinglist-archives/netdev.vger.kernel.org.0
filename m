Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 0738A584E62
	for <lists+netdev@lfdr.de>; Fri, 29 Jul 2022 11:51:23 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S235098AbiG2JvU convert rfc822-to-8bit (ORCPT
        <rfc822;lists+netdev@lfdr.de>); Fri, 29 Jul 2022 05:51:20 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:50078 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230053AbiG2JvT (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 29 Jul 2022 05:51:19 -0400
Received: from eu-smtp-delivery-151.mimecast.com (eu-smtp-delivery-151.mimecast.com [185.58.86.151])
        by lindbergh.monkeyblade.net (Postfix) with ESMTP id 02B2E76960
        for <netdev@vger.kernel.org>; Fri, 29 Jul 2022 02:51:17 -0700 (PDT)
Received: from AcuMS.aculab.com (156.67.243.121 [156.67.243.121]) by
 relay.mimecast.com with ESMTP with STARTTLS (version=TLSv1.2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_CBC_SHA384) id
 uk-mta-193-F8GhUeCtPHuz_IVr8tViCQ-1; Fri, 29 Jul 2022 10:51:14 +0100
X-MC-Unique: F8GhUeCtPHuz_IVr8tViCQ-1
Received: from AcuMS.Aculab.com (fd9f:af1c:a25b:0:994c:f5c2:35d6:9b65) by
 AcuMS.aculab.com (fd9f:af1c:a25b:0:994c:f5c2:35d6:9b65) with Microsoft SMTP
 Server (TLS) id 15.0.1497.36; Fri, 29 Jul 2022 10:51:12 +0100
Received: from AcuMS.Aculab.com ([fe80::994c:f5c2:35d6:9b65]) by
 AcuMS.aculab.com ([fe80::994c:f5c2:35d6:9b65%12]) with mapi id
 15.00.1497.036; Fri, 29 Jul 2022 10:51:12 +0100
From:   David Laight <David.Laight@ACULAB.COM>
To:     'Michael Walle' <michael@walle.cc>,
        Ajay Singh <ajay.kathat@microchip.com>,
        Claudiu Beznea <claudiu.beznea@microchip.com>
CC:     Kalle Valo <kvalo@kernel.org>,
        "David S . Miller" <davem@davemloft.net>,
        Eric Dumazet <edumazet@google.com>,
        Jakub Kicinski <kuba@kernel.org>,
        "Paolo Abeni" <pabeni@redhat.com>,
        "linux-wireless@vger.kernel.org" <linux-wireless@vger.kernel.org>,
        "netdev@vger.kernel.org" <netdev@vger.kernel.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        Michael Walle <mwalle@kernel.org>
Subject: RE: [PATCH] wilc1000: fix DMA on stack objects
Thread-Topic: [PATCH] wilc1000: fix DMA on stack objects
Thread-Index: AQHYopWhqNxmqPlyb02i77gvPBc+j62VGWMQ
Date:   Fri, 29 Jul 2022 09:51:12 +0000
Message-ID: <0ed9ec85a55941fd93773825fe9d374c@AcuMS.aculab.com>
References: <20220728152037.386543-1-michael@walle.cc>
In-Reply-To: <20220728152037.386543-1-michael@walle.cc>
Accept-Language: en-GB, en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
x-ms-exchange-transport-fromentityheader: Hosted
x-originating-ip: [10.202.205.107]
MIME-Version: 1.0
Authentication-Results: relay.mimecast.com;
        auth=pass smtp.auth=C51A453 smtp.mailfrom=david.laight@aculab.com
X-Mimecast-Spam-Score: 0
X-Mimecast-Originator: aculab.com
Content-Language: en-US
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8BIT
X-Spam-Status: No, score=-2.6 required=5.0 tests=BAYES_00,RCVD_IN_DNSWL_LOW,
        SPF_HELO_NONE,SPF_PASS autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Michael Walle
> Sent: 28 July 2022 16:21
> 
> From: Michael Walle <mwalle@kernel.org>
> 
> Sometimes wilc_sdio_cmd53() is called with addresses pointing to an
> object on the stack. E.g. wilc_sdio_write_reg() will call it with an
> address pointing to one of its arguments. Detect whether the buffer
> address is not DMA-able in which case a bounce buffer is used. The bounce
> buffer itself is protected from parallel accesses by sdio_claim_host().
> 
> Fixes: 5625f965d764 ("wilc1000: move wilc driver out of staging")
> Signed-off-by: Michael Walle <mwalle@kernel.org>
> ---
> The bug itself probably goes back way more, but I don't know if it makes
> any sense to use an older commit for the Fixes tag. If so, please suggest
> one.
> 
> The bug leads to an actual error on an imx8mn SoC with 1GiB of RAM. But the
> error will also be catched by CONFIG_DEBUG_VIRTUAL:
> [    9.817512] virt_to_phys used for non-linear address: (____ptrval____) (0xffff80000a94bc9c)
> 
>  .../net/wireless/microchip/wilc1000/sdio.c    | 28 ++++++++++++++++---
>  1 file changed, 24 insertions(+), 4 deletions(-)
> 
> diff --git a/drivers/net/wireless/microchip/wilc1000/sdio.c
> b/drivers/net/wireless/microchip/wilc1000/sdio.c
> index 7962c11cfe84..e988bede880c 100644
> --- a/drivers/net/wireless/microchip/wilc1000/sdio.c
> +++ b/drivers/net/wireless/microchip/wilc1000/sdio.c
> @@ -27,6 +27,7 @@ struct wilc_sdio {
>  	bool irq_gpio;
>  	u32 block_size;
>  	int has_thrpt_enh3;
> +	u8 *dma_buffer;
>  };
> 
>  struct sdio_cmd52 {
> @@ -89,6 +90,9 @@ static int wilc_sdio_cmd52(struct wilc *wilc, struct sdio_cmd52 *cmd)
>  static int wilc_sdio_cmd53(struct wilc *wilc, struct sdio_cmd53 *cmd)
>  {
>  	struct sdio_func *func = container_of(wilc->dev, struct sdio_func, dev);
> +	struct wilc_sdio *sdio_priv = wilc->bus_data;
> +	bool need_bounce_buf = false;
> +	u8 *buf = cmd->buffer;
>  	int size, ret;
> 
>  	sdio_claim_host(func);
> @@ -100,12 +104,20 @@ static int wilc_sdio_cmd53(struct wilc *wilc, struct sdio_cmd53 *cmd)
>  	else
>  		size = cmd->count;
> 
> +	if ((!virt_addr_valid(buf) || object_is_on_stack(buf)) &&

How cheap are the above tests?
It might just be worth always doing the 'bounce'?

> +	    !WARN_ON_ONCE(size > WILC_SDIO_BLOCK_SIZE)) {

That WARN() ought to be an error return?
Or just assume that large buffers will dma-capable?

	David

> +		need_bounce_buf = true;
> +		buf = sdio_priv->dma_buffer;
> +	}
> +
>  	if (cmd->read_write) {  /* write */
> -		ret = sdio_memcpy_toio(func, cmd->address,
> -				       (void *)cmd->buffer, size);
> +		if (need_bounce_buf)
> +			memcpy(buf, cmd->buffer, size);
> +		ret = sdio_memcpy_toio(func, cmd->address, buf, size);
>  	} else {        /* read */
> -		ret = sdio_memcpy_fromio(func, (void *)cmd->buffer,
> -					 cmd->address,  size);
> +		ret = sdio_memcpy_fromio(func, buf, cmd->address, size);
> +		if (need_bounce_buf)
> +			memcpy(cmd->buffer, buf, size);
>  	}
> 
>  	sdio_release_host(func);
> @@ -127,6 +139,12 @@ static int wilc_sdio_probe(struct sdio_func *func,
>  	if (!sdio_priv)
>  		return -ENOMEM;
> 
> +	sdio_priv->dma_buffer = kzalloc(WILC_SDIO_BLOCK_SIZE, GFP_KERNEL);
> +	if (!sdio_priv->dma_buffer) {
> +		ret = -ENOMEM;
> +		goto free;
> +	}
> +
>  	ret = wilc_cfg80211_init(&wilc, &func->dev, WILC_HIF_SDIO,
>  				 &wilc_hif_sdio);
>  	if (ret)
> @@ -160,6 +178,7 @@ static int wilc_sdio_probe(struct sdio_func *func,
>  	irq_dispose_mapping(wilc->dev_irq_num);
>  	wilc_netdev_cleanup(wilc);
>  free:
> +	kfree(sdio_priv->dma_buffer);
>  	kfree(sdio_priv);
>  	return ret;
>  }
> @@ -171,6 +190,7 @@ static void wilc_sdio_remove(struct sdio_func *func)
> 
>  	clk_disable_unprepare(wilc->rtc_clk);
>  	wilc_netdev_cleanup(wilc);
> +	kfree(sdio_priv->dma_buffer);
>  	kfree(sdio_priv);
>  }
> 
> --
> 2.30.2

-
Registered Address Lakeside, Bramley Road, Mount Farm, Milton Keynes, MK1 1PT, UK
Registration No: 1397386 (Wales)

