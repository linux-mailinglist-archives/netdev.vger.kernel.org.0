Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 718B062FA34
	for <lists+netdev@lfdr.de>; Fri, 18 Nov 2022 17:27:04 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S241855AbiKRQ1B (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 18 Nov 2022 11:27:01 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:47174 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S241968AbiKRQ0w (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 18 Nov 2022 11:26:52 -0500
Received: from aposti.net (aposti.net [89.234.176.197])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 7209B922CD;
        Fri, 18 Nov 2022 08:26:50 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=crapouillou.net;
        s=mail; t=1668788808; h=from:from:sender:reply-to:subject:subject:date:date:
         message-id:message-id:to:to:cc:cc:mime-version:mime-version:
         content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=eqga8JTYTp2zVjGVTJnxG4hmTKEKUsQWc87jKX+8+W4=;
        b=dHWu9iuXvZDg25+OqM+9EVX2BdEp+pky56+F8HD1J9i6Qljl+AaCZIFWJsXNtenbehYrFC
        kFoyGkqCsXMJsT8dkN/whlGB5BIS+oFtwSU+thKRVpLNl3LshaUlECXztG/ZUNF+8PqohC
        LcyjXPitlqimuZT2iW2JZRGeV3NVwH4=
Date:   Fri, 18 Nov 2022 16:26:38 +0000
From:   Paul Cercueil <paul@crapouillou.net>
Subject: Re: [PATCH 1/3] net: davicom: dm9000: switch to using gpiod API
To:     Dmitry Torokhov <dmitry.torokhov@gmail.com>
Cc:     "David S. Miller" <davem@davemloft.net>,
        Andrew Lunn <andrew@lunn.ch>,
        Heiner Kallweit <hkallweit1@gmail.com>,
        Linus Walleij <linus.walleij@linaro.org>,
        Bartosz Golaszewski <brgl@bgdev.pl>, netdev@vger.kernel.org,
        linux-kernel@vger.kernel.org
Message-Id: <EOXJLR.T44BFQBJ4YLG1@crapouillou.net>
In-Reply-To: <Y3ernUQfdWMBtO9z@google.com>
References: <20220906204922.3789922-1-dmitry.torokhov@gmail.com>
        <88VJLR.GYSEKGBPLGZC1@crapouillou.net> <Y3ernUQfdWMBtO9z@google.com>
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



Le ven. 18 nov. 2022 =E0 07:58:21 -0800, Dmitry Torokhov=20
<dmitry.torokhov@gmail.com> a =E9crit :
> Hi Paul,
>=20
> On Fri, Nov 18, 2022 at 03:33:44PM +0000, Paul Cercueil wrote:
>>  Hi Dmitry,
>>=20
>>  Le mar. 6 sept. 2022 =E0 13:49:20 -0700, Dmitry Torokhov
>>  <dmitry.torokhov@gmail.com> a =E9crit :
>>  > This patch switches the driver away from legacy gpio/of_gpio API=20
>> to
>>  > gpiod API, and removes use of of_get_named_gpio_flags() which I=20
>> want to
>>  > make private to gpiolib.
>>  >
>>  > Signed-off-by: Dmitry Torokhov <dmitry.torokhov@gmail.com>
>>  > ---
>>  >  drivers/net/ethernet/davicom/dm9000.c | 26=20
>> ++++++++++++++------------
>>  >  1 file changed, 14 insertions(+), 12 deletions(-)
>>  >
>>  > diff --git a/drivers/net/ethernet/davicom/dm9000.c
>>  > b/drivers/net/ethernet/davicom/dm9000.c
>>  > index 77229e53b04e..c85a6ebd79fc 100644
>>  > --- a/drivers/net/ethernet/davicom/dm9000.c
>>  > +++ b/drivers/net/ethernet/davicom/dm9000.c
>>  > @@ -28,8 +28,7 @@
>>  >  #include <linux/irq.h>
>>  >  #include <linux/slab.h>
>>  >  #include <linux/regulator/consumer.h>
>>  > -#include <linux/gpio.h>
>>  > -#include <linux/of_gpio.h>
>>  > +#include <linux/gpio/consumer.h>
>>  >
>>  >  #include <asm/delay.h>
>>  >  #include <asm/irq.h>
>>  > @@ -1421,8 +1420,7 @@ dm9000_probe(struct platform_device *pdev)
>>  >  	int iosize;
>>  >  	int i;
>>  >  	u32 id_val;
>>  > -	int reset_gpios;
>>  > -	enum of_gpio_flags flags;
>>  > +	struct gpio_desc *reset_gpio;
>>  >  	struct regulator *power;
>>  >  	bool inv_mac_addr =3D false;
>>  >  	u8 addr[ETH_ALEN];
>>  > @@ -1442,20 +1440,24 @@ dm9000_probe(struct platform_device *pdev)
>>  >  		dev_dbg(dev, "regulator enabled\n");
>>  >  	}
>>  >
>>  > -	reset_gpios =3D of_get_named_gpio_flags(dev->of_node,=20
>> "reset-gpios", 0,
>>  > -					      &flags);
>>  > -	if (gpio_is_valid(reset_gpios)) {
>>  > -		ret =3D devm_gpio_request_one(dev, reset_gpios, flags,
>>  > -					    "dm9000_reset");
>>  > +	reset_gpio =3D devm_gpiod_get_optional(dev, "reset",=20
>> GPIOD_OUT_HIGH);
>>  > +	ret =3D PTR_ERR_OR_ZERO(reset_gpio);
>>  > +	if (ret) {
>>  > +		dev_err(dev, "failed to request reset gpio: %d\n", ret);
>>  > +		goto out_regulator_disable;
>>  > +	}
>>  > +
>>  > +	if (reset_gpio) {
>>  > +		ret =3D gpiod_set_consumer_name(reset_gpio, "dm9000_reset");
>>  >  		if (ret) {
>>  > -			dev_err(dev, "failed to request reset gpio %d: %d\n",
>>  > -				reset_gpios, ret);
>>  > +			dev_err(dev, "failed to set reset gpio name: %d\n",
>>  > +				ret);
>>  >  			goto out_regulator_disable;
>>  >  		}
>>  >
>>  >  		/* According to manual PWRST# Low Period Min 1ms */
>>  >  		msleep(2);
>>  > -		gpio_set_value(reset_gpios, 1);
>>  > +		gpiod_set_value_cansleep(reset_gpio, 0);
>>=20
>>  Why is that 1 magically turned into a 0?
>=20
> Because gpiod uses logical states (think active/inactive), not=20
> absolute
> ones. Here we are deasserting the reset line.
>=20
>>=20
>>  On my CI20 board I can't get the DM9000 chip to probe correctly=20
>> with this
>>  patch (it fails to read the ID).
>>  If I revert this patch then everything works fine.
>=20
> Sorry, it is my fault of course: I missed that board has incorrect
> annotation for the reset line. I will send out the patch below
> (formatted properly of course):

So in *theory* you wouldn't fix it like that, because the driver should=20
work with old Device Tree files, even if it had a broken property, as=20
long as it used to work in the past.

The ci20.dts file however is always built into the kernel and I'm not=20
aware of anybody doing things differently. As long as you make that=20
explicit in your commit message I think Rob won't mind.

If he does, or if more boards are affected, an alternative is to switch=20
the polarity of the GPIO in the driver, like so:

if (of_machine_is_compatible("mips,ci20") &&
    gpiod_is_active_low(reset_gpio)) {
	gpiod_toggle_active_low(reset_gpio);
}

Cheers,
-Paul

> diff --git a/arch/mips/boot/dts/ingenic/ci20.dts=20
> b/arch/mips/boot/dts/ingenic/ci20.dts
> index 37c46720c719..f38c39572a9e 100644
> --- a/arch/mips/boot/dts/ingenic/ci20.dts
> +++ b/arch/mips/boot/dts/ingenic/ci20.dts
> @@ -438,7 +438,7 @@ dm9000@6 {
>  		ingenic,nemc-tAW =3D <50>;
>  		ingenic,nemc-tSTRV =3D <100>;
>=20
> -		reset-gpios =3D <&gpf 12 GPIO_ACTIVE_HIGH>;
> +		reset-gpios =3D <&gpf 12 GPIO_ACTIVE_LOW>;
>  		vcc-supply =3D <&eth0_power>;
>=20
>  		interrupt-parent =3D <&gpe>;
>=20
>=20
> Thanks.
>=20
> --
> Dmitry


