Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id E04E05285C8
	for <lists+netdev@lfdr.de>; Mon, 16 May 2022 15:48:21 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S239626AbiEPNsT (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 16 May 2022 09:48:19 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:32926 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S237525AbiEPNsR (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 16 May 2022 09:48:17 -0400
Received: from gandalf.ozlabs.org (gandalf.ozlabs.org [150.107.74.76])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id A34883914C;
        Mon, 16 May 2022 06:48:15 -0700 (PDT)
Received: from authenticated.ozlabs.org (localhost [127.0.0.1])
        (using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
         key-exchange ECDHE (P-256) server-signature RSA-PSS (4096 bits) server-digest SHA256)
        (No client certificate requested)
        by mail.ozlabs.org (Postfix) with ESMTPSA id 4L20vB6skwz4xZ5;
        Mon, 16 May 2022 23:48:06 +1000 (AEST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=ellerman.id.au;
        s=201909; t=1652708890;
        bh=IoEgFN1b2dRBNPBgpQ3TrV8TAD3LrZl3dnKWhxyBcE8=;
        h=From:To:Cc:Subject:In-Reply-To:References:Date:From;
        b=eOCT8tTgO0HB3LTSAxu5VPZmIDCja3jmYMxo19810CBMQQW4VUwng4Vi307xbkQp3
         NtGdL+eJoxbZnFWifwb7kCOChKLsaCuGHJ7kenALzxiy/5D+lDIzS/Pa9H71ujoCuJ
         1PcimRASMi9dPMp1ajYEAnJJ845+xdMAWXVLExUxp7rHLl+PjV+9dDRmB7YTQb3gCn
         dg31DcWS+4zmI+yfmKkMWaecSijwxwHugdByRa5Px62h2UGh7tUSMCsI1YSl6uu9u9
         OL7ZW1+kKqSCaifOCHd32fjcMBnXMDsj8J86SFvZdwAx4giXzsNaNy7F1zFwFwAeyT
         iQLit7nUMYGng==
From:   Michael Ellerman <mpe@ellerman.id.au>
To:     Andy Shevchenko <andriy.shevchenko@linux.intel.com>,
        Andy Shevchenko <andriy.shevchenko@linux.intel.com>,
        Wolfram Sang <wsa@kernel.org>,
        Marc Kleine-Budde <mkl@pengutronix.de>,
        Damien Le Moal <damien.lemoal@opensource.wdc.com>,
        Mark Brown <broonie@kernel.org>,
        chris.packham@alliedtelesis.co.nz,
        Sergey Shtylyov <s.shtylyov@omp.ru>,
        "David S. Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        Jiri Slaby <jirislaby@kernel.org>,
        linuxppc-dev@lists.ozlabs.org, linux-kernel@vger.kernel.org,
        linux-ide@vger.kernel.org, linux-i2c@vger.kernel.org,
        linux-can@vger.kernel.org, netdev@vger.kernel.org,
        linux-spi@vger.kernel.org, linux-serial@vger.kernel.org
Cc:     Benjamin Herrenschmidt <benh@kernel.crashing.org>,
        Paul Mackerras <paulus@samba.org>,
        Anatolij Gustschin <agust@denx.de>,
        Wolfgang Grandegger <wg@grandegger.com>,
        Eric Dumazet <edumazet@google.com>,
        Paolo Abeni <pabeni@redhat.com>,
        Pantelis Antoniou <pantelis.antoniou@gmail.com>
Subject: Re: [PATCH v2 4/4] powerpc/52xx: Convert to use fwnode API
In-Reply-To: <20220507100147.5802-4-andriy.shevchenko@linux.intel.com>
References: <20220507100147.5802-1-andriy.shevchenko@linux.intel.com>
 <20220507100147.5802-4-andriy.shevchenko@linux.intel.com>
Date:   Mon, 16 May 2022 23:48:05 +1000
Message-ID: <877d6l7fmy.fsf@mpe.ellerman.id.au>
MIME-Version: 1.0
Content-Type: text/plain
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,SPF_HELO_PASS,SPF_PASS,
        T_SCC_BODY_TEXT_LINE autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Andy Shevchenko <andriy.shevchenko@linux.intel.com> writes:
> We may convert the GPT driver to use fwnode API for the sake
> of consistency of the used APIs inside the driver.

I'm not sure about this one.

It's more consistent to use fwnode in this driver, but it's very
inconsistent with the rest of the powerpc code. We have basically no
uses of the fwnode APIs at the moment.

It seems like a pretty straight-forward conversion, but there could
easily be a bug in there, I don't have any way to test it. Do you?

cheers



> diff --git a/arch/powerpc/platforms/52xx/mpc52xx_gpt.c b/arch/powerpc/platforms/52xx/mpc52xx_gpt.c
> index ae47fdcc8a96..58c3651034bd 100644
> --- a/arch/powerpc/platforms/52xx/mpc52xx_gpt.c
> +++ b/arch/powerpc/platforms/52xx/mpc52xx_gpt.c
> @@ -53,10 +53,9 @@
>  #include <linux/interrupt.h>
>  #include <linux/io.h>
>  #include <linux/list.h>
> +#include <linux/mod_devicetable.h>
> +#include <linux/module.h>
>  #include <linux/mutex.h>
> -#include <linux/of.h>
> -#include <linux/of_platform.h>
> -#include <linux/of_gpio.h>
>  #include <linux/kernel.h>
>  #include <linux/property.h>
>  #include <linux/slab.h>
> @@ -64,7 +63,7 @@
>  #include <linux/watchdog.h>
>  #include <linux/miscdevice.h>
>  #include <linux/uaccess.h>
> -#include <linux/module.h>
> +
>  #include <asm/div64.h>
>  #include <asm/mpc52xx.h>
>  
> @@ -235,18 +234,17 @@ static const struct irq_domain_ops mpc52xx_gpt_irq_ops = {
>  	.xlate = mpc52xx_gpt_irq_xlate,
>  };
>  
> -static void
> -mpc52xx_gpt_irq_setup(struct mpc52xx_gpt_priv *gpt, struct device_node *node)
> +static void mpc52xx_gpt_irq_setup(struct mpc52xx_gpt_priv *gpt)
>  {
>  	int cascade_virq;
>  	unsigned long flags;
>  	u32 mode;
>  
> -	cascade_virq = irq_of_parse_and_map(node, 0);
> -	if (!cascade_virq)
> +	cascade_virq = platform_get_irq(to_platform_device(gpt->dev), 0);
> +	if (cascade_virq < 0)
>  		return;
>  
> -	gpt->irqhost = irq_domain_add_linear(node, 1, &mpc52xx_gpt_irq_ops, gpt);
> +	gpt->irqhost = irq_domain_create_linear(dev_fwnode(gpt->dev), 1, &mpc52xx_gpt_irq_ops, gpt);
>  	if (!gpt->irqhost) {
>  		dev_err(gpt->dev, "irq_domain_add_linear() failed\n");
>  		return;
> @@ -670,8 +668,7 @@ static int mpc52xx_gpt_wdt_init(void)
>  	return err;
>  }
>  
> -static int mpc52xx_gpt_wdt_setup(struct mpc52xx_gpt_priv *gpt,
> -				 const u32 *period)
> +static int mpc52xx_gpt_wdt_setup(struct mpc52xx_gpt_priv *gpt, const u32 period)
>  {
>  	u64 real_timeout;
>  
> @@ -679,14 +676,14 @@ static int mpc52xx_gpt_wdt_setup(struct mpc52xx_gpt_priv *gpt,
>  	mpc52xx_gpt_wdt = gpt;
>  
>  	/* configure the wdt if the device tree contained a timeout */
> -	if (!period || *period == 0)
> +	if (period == 0)
>  		return 0;
>  
> -	real_timeout = (u64) *period * 1000000000ULL;
> +	real_timeout = (u64)period * 1000000000ULL;
>  	if (mpc52xx_gpt_do_start(gpt, real_timeout, 0, 1))
>  		dev_warn(gpt->dev, "starting as wdt failed\n");
>  	else
> -		dev_info(gpt->dev, "watchdog set to %us timeout\n", *period);
> +		dev_info(gpt->dev, "watchdog set to %us timeout\n", period);
>  	return 0;
>  }
>  
> @@ -697,8 +694,7 @@ static int mpc52xx_gpt_wdt_init(void)
>  	return 0;
>  }
>  
> -static inline int mpc52xx_gpt_wdt_setup(struct mpc52xx_gpt_priv *gpt,
> -					const u32 *period)
> +static inline int mpc52xx_gpt_wdt_setup(struct mpc52xx_gpt_priv *gpt, const u32 period)
>  {
>  	return 0;
>  }
> @@ -726,25 +722,26 @@ static int mpc52xx_gpt_probe(struct platform_device *ofdev)
>  	dev_set_drvdata(&ofdev->dev, gpt);
>  
>  	mpc52xx_gpt_gpio_setup(gpt);
> -	mpc52xx_gpt_irq_setup(gpt, ofdev->dev.of_node);
> +	mpc52xx_gpt_irq_setup(gpt);
>  
>  	mutex_lock(&mpc52xx_gpt_list_mutex);
>  	list_add(&gpt->list, &mpc52xx_gpt_list);
>  	mutex_unlock(&mpc52xx_gpt_list_mutex);
>  
>  	/* check if this device could be a watchdog */
> -	if (of_get_property(ofdev->dev.of_node, "fsl,has-wdt", NULL) ||
> -	    of_get_property(ofdev->dev.of_node, "has-wdt", NULL)) {
> -		const u32 *on_boot_wdt;
> +	if (device_property_present(gpt->dev, "fsl,has-wdt") ||
> +	    device_property_present(gpt->dev, "has-wdt")) {
> +		u32 on_boot_wdt = 0;
> +		int ret;
>  
>  		gpt->wdt_mode = MPC52xx_GPT_CAN_WDT;
> -		on_boot_wdt = of_get_property(ofdev->dev.of_node,
> -					      "fsl,wdt-on-boot", NULL);
> -		if (on_boot_wdt) {
> +		ret = device_property_read_u32(gpt->dev, "fsl,wdt-on-boot", &on_boot_wdt);
> +		if (ret) {
> +			dev_info(gpt->dev, "can function as watchdog\n");
> +		} else {
>  			dev_info(gpt->dev, "used as watchdog\n");
>  			gpt->wdt_mode |= MPC52xx_GPT_IS_WDT;
> -		} else
> -			dev_info(gpt->dev, "can function as watchdog\n");
> +		}
>  		mpc52xx_gpt_wdt_setup(gpt, on_boot_wdt);
>  	}
>  
> -- 
> 2.35.1
