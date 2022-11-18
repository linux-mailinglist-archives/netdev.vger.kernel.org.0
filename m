Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id A846C62F955
	for <lists+netdev@lfdr.de>; Fri, 18 Nov 2022 16:34:02 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S242285AbiKRPeA (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 18 Nov 2022 10:34:00 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:49902 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S242302AbiKRPd5 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 18 Nov 2022 10:33:57 -0500
Received: from aposti.net (aposti.net [89.234.176.197])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id F1C7527153;
        Fri, 18 Nov 2022 07:33:55 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=crapouillou.net;
        s=mail; t=1668785634; h=from:from:sender:reply-to:subject:subject:date:date:
         message-id:message-id:to:to:cc:cc:mime-version:mime-version:
         content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=H99gifSUAX63SHB4wCOwUdzC9A4Qilfu6shSvTJT/Do=;
        b=GCiLfoGCsrJV1b8eakZkdc7V+eN/S88H24/XYoaqACaFIbKl+QvmUfkTvecq+5zc1vYnHp
        1UQJ2nBjiJRoc5sWCyiys+8cMAWuYq/IZIRPZIR8W+jGDjOfgDALYZa7TV/YO/H/EV8ve8
        28qttYGe/6cZzWvE+o2a5FEuKSiunHc=
Date:   Fri, 18 Nov 2022 15:33:44 +0000
From:   Paul Cercueil <paul@crapouillou.net>
Subject: Re: [PATCH 1/3] net: davicom: dm9000: switch to using gpiod API
To:     Dmitry Torokhov <dmitry.torokhov@gmail.com>
Cc:     "David S. Miller" <davem@davemloft.net>,
        Andrew Lunn <andrew@lunn.ch>,
        Heiner Kallweit <hkallweit1@gmail.com>,
        Linus Walleij <linus.walleij@linaro.org>,
        Bartosz Golaszewski <brgl@bgdev.pl>, netdev@vger.kernel.org,
        linux-kernel@vger.kernel.org
Message-Id: <88VJLR.GYSEKGBPLGZC1@crapouillou.net>
In-Reply-To: <20220906204922.3789922-1-dmitry.torokhov@gmail.com>
References: <20220906204922.3789922-1-dmitry.torokhov@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1; format=flowed
Content-Transfer-Encoding: quoted-printable
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,SPF_HELO_PASS,SPF_PASS
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Hi Dmitry,

Le mar. 6 sept. 2022 =E0 13:49:20 -0700, Dmitry Torokhov=20
<dmitry.torokhov@gmail.com> a =E9crit :
> This patch switches the driver away from legacy gpio/of_gpio API to
> gpiod API, and removes use of of_get_named_gpio_flags() which I want=20
> to
> make private to gpiolib.
>=20
> Signed-off-by: Dmitry Torokhov <dmitry.torokhov@gmail.com>
> ---
>  drivers/net/ethernet/davicom/dm9000.c | 26 ++++++++++++++------------
>  1 file changed, 14 insertions(+), 12 deletions(-)
>=20
> diff --git a/drivers/net/ethernet/davicom/dm9000.c=20
> b/drivers/net/ethernet/davicom/dm9000.c
> index 77229e53b04e..c85a6ebd79fc 100644
> --- a/drivers/net/ethernet/davicom/dm9000.c
> +++ b/drivers/net/ethernet/davicom/dm9000.c
> @@ -28,8 +28,7 @@
>  #include <linux/irq.h>
>  #include <linux/slab.h>
>  #include <linux/regulator/consumer.h>
> -#include <linux/gpio.h>
> -#include <linux/of_gpio.h>
> +#include <linux/gpio/consumer.h>
>=20
>  #include <asm/delay.h>
>  #include <asm/irq.h>
> @@ -1421,8 +1420,7 @@ dm9000_probe(struct platform_device *pdev)
>  	int iosize;
>  	int i;
>  	u32 id_val;
> -	int reset_gpios;
> -	enum of_gpio_flags flags;
> +	struct gpio_desc *reset_gpio;
>  	struct regulator *power;
>  	bool inv_mac_addr =3D false;
>  	u8 addr[ETH_ALEN];
> @@ -1442,20 +1440,24 @@ dm9000_probe(struct platform_device *pdev)
>  		dev_dbg(dev, "regulator enabled\n");
>  	}
>=20
> -	reset_gpios =3D of_get_named_gpio_flags(dev->of_node, "reset-gpios",=20
> 0,
> -					      &flags);
> -	if (gpio_is_valid(reset_gpios)) {
> -		ret =3D devm_gpio_request_one(dev, reset_gpios, flags,
> -					    "dm9000_reset");
> +	reset_gpio =3D devm_gpiod_get_optional(dev, "reset", GPIOD_OUT_HIGH);
> +	ret =3D PTR_ERR_OR_ZERO(reset_gpio);
> +	if (ret) {
> +		dev_err(dev, "failed to request reset gpio: %d\n", ret);
> +		goto out_regulator_disable;
> +	}
> +
> +	if (reset_gpio) {
> +		ret =3D gpiod_set_consumer_name(reset_gpio, "dm9000_reset");
>  		if (ret) {
> -			dev_err(dev, "failed to request reset gpio %d: %d\n",
> -				reset_gpios, ret);
> +			dev_err(dev, "failed to set reset gpio name: %d\n",
> +				ret);
>  			goto out_regulator_disable;
>  		}
>=20
>  		/* According to manual PWRST# Low Period Min 1ms */
>  		msleep(2);
> -		gpio_set_value(reset_gpios, 1);
> +		gpiod_set_value_cansleep(reset_gpio, 0);

Why is that 1 magically turned into a 0?

On my CI20 board I can't get the DM9000 chip to probe correctly with=20
this patch (it fails to read the ID).
If I revert this patch then everything works fine.

Cheers,
-Paul

>  		/* Needs 3ms to read eeprom when PWRST is deasserted */
>  		msleep(4);
>  	}
> --
> 2.37.2.789.g6183377224-goog
>=20


