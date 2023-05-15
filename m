Return-Path: <netdev+bounces-2569-lists+netdev=lfdr.de@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from ny.mirrors.kernel.org (ny.mirrors.kernel.org [IPv6:2604:1380:45d1:ec00::1])
	by mail.lfdr.de (Postfix) with ESMTPS id 4691C702893
	for <lists+netdev@lfdr.de>; Mon, 15 May 2023 11:29:49 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ny.mirrors.kernel.org (Postfix) with ESMTPS id 4CACD1C2095B
	for <lists+netdev@lfdr.de>; Mon, 15 May 2023 09:29:46 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 9E4C3C136;
	Mon, 15 May 2023 09:29:46 +0000 (UTC)
X-Original-To: netdev@vger.kernel.org
Received: from lindbergh.monkeyblade.net (lindbergh.monkeyblade.net [23.128.96.19])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 93A5E883A
	for <netdev@vger.kernel.org>; Mon, 15 May 2023 09:29:46 +0000 (UTC)
Received: from fgw20-7.mail.saunalahti.fi (fgw20-7.mail.saunalahti.fi [62.142.5.81])
	by lindbergh.monkeyblade.net (Postfix) with ESMTPS id BEE3EFD
	for <netdev@vger.kernel.org>; Mon, 15 May 2023 02:29:36 -0700 (PDT)
Received: from localhost (88-113-26-95.elisa-laajakaista.fi [88.113.26.95])
	by fgw20.mail.saunalahti.fi (Halon) with ESMTP
	id 0016b2ae-f303-11ed-b3cf-005056bd6ce9;
	Mon, 15 May 2023 12:29:34 +0300 (EEST)
From: andy.shevchenko@gmail.com
Date: Mon, 15 May 2023 12:29:32 +0300
To: Jiawen Wu <jiawenwu@trustnetic.com>
Cc: netdev@vger.kernel.org, jarkko.nikula@linux.intel.com,
	andriy.shevchenko@linux.intel.com, mika.westerberg@linux.intel.com,
	jsd@semihalf.com, Jose.Abreu@synopsys.com, andrew@lunn.ch,
	hkallweit1@gmail.com, linux@armlinux.org.uk,
	linux-i2c@vger.kernel.org, linux-gpio@vger.kernel.org,
	mengyuanlou@net-swift.com,
	Piotr Raczynski <piotr.raczynski@intel.com>
Subject: Re: [PATCH net-next v8 4/9] net: txgbe: Register I2C platform device
Message-ID: <ZGH7fHlq0Ao_Mr3U@surfacebook>
References: <20230515063200.301026-1-jiawenwu@trustnetic.com>
 <20230515063200.301026-5-jiawenwu@trustnetic.com>
Precedence: bulk
X-Mailing-List: netdev@vger.kernel.org
List-Id: <netdev.vger.kernel.org>
List-Subscribe: <mailto:netdev+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:netdev+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20230515063200.301026-5-jiawenwu@trustnetic.com>
X-Spam-Status: No, score=0.7 required=5.0 tests=BAYES_00,DKIM_ADSP_CUSTOM_MED,
	FORGED_GMAIL_RCVD,FREEMAIL_FROM,NML_ADSP_CUSTOM_MED,SPF_HELO_NONE,
	SPF_SOFTFAIL,T_SCC_BODY_TEXT_LINE autolearn=no autolearn_force=no
	version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
	lindbergh.monkeyblade.net

Mon, May 15, 2023 at 02:31:55PM +0800, Jiawen Wu kirjoitti:
> Register the platform device to use Designware I2C bus master driver.
> Use regmap to read/write I2C device region from given base offset.

...

> +#include <linux/platform_device.h>
>  #include <linux/gpio/property.h>
> +#include <linux/regmap.h>

Perhaps keeping this ordered?

>  #include <linux/clkdev.h>
>  #include <linux/clk-provider.h>
>  #include <linux/i2c.h>

...

> +static const struct regmap_config i2c_regmap_config = {
> +	.reg_bits = 32,
> +	.val_bits = 32,
> +	.reg_read = txgbe_i2c_read,
> +	.reg_write = txgbe_i2c_write,

	fast_io = true;

? (Note, I haven't checked if IO accessors are really fast)

> +};

...

> +	i2c_regmap = devm_regmap_init(&pdev->dev, NULL, wx,
> +				      &i2c_regmap_config);

This is exactly a single line (80 characters), why to have two?

> +	if (IS_ERR(i2c_regmap)) {
> +		wx_err(wx, "failed to init regmap\n");
> +		return PTR_ERR(i2c_regmap);
> +	}

...

> +	res = DEFINE_RES_IRQ(pdev->irq);
> +	info.res = &res;

You can do

	info.res = &DEFINE_RES_IRQ(pdev->irq);

-- 
With Best Regards,
Andy Shevchenko



