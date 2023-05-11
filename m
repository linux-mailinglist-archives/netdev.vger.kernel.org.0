Return-Path: <netdev+bounces-1951-lists+netdev=lfdr.de@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [139.178.88.99])
	by mail.lfdr.de (Postfix) with ESMTPS id CE0816FFB6B
	for <lists+netdev@lfdr.de>; Thu, 11 May 2023 22:45:42 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id 8A5BE2817F9
	for <lists+netdev@lfdr.de>; Thu, 11 May 2023 20:45:41 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 8E67DA939;
	Thu, 11 May 2023 20:45:39 +0000 (UTC)
X-Original-To: netdev@vger.kernel.org
Received: from lindbergh.monkeyblade.net (lindbergh.monkeyblade.net [23.128.96.19])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 82B678F56
	for <netdev@vger.kernel.org>; Thu, 11 May 2023 20:45:39 +0000 (UTC)
Received: from fgw20-7.mail.saunalahti.fi (fgw20-7.mail.saunalahti.fi [62.142.5.81])
	by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 28F2F1FF1
	for <netdev@vger.kernel.org>; Thu, 11 May 2023 13:45:37 -0700 (PDT)
Received: from localhost (88-113-26-95.elisa-laajakaista.fi [88.113.26.95])
	by fgw20.mail.saunalahti.fi (Halon) with ESMTP
	id c56bfb84-f03c-11ed-b3cf-005056bd6ce9;
	Thu, 11 May 2023 23:45:33 +0300 (EEST)
From: andy.shevchenko@gmail.com
Date: Thu, 11 May 2023 23:45:31 +0300
To: Jiawen Wu <jiawenwu@trustnetic.com>
Cc: netdev@vger.kernel.org, jarkko.nikula@linux.intel.com,
	andriy.shevchenko@linux.intel.com, mika.westerberg@linux.intel.com,
	jsd@semihalf.com, Jose.Abreu@synopsys.com, andrew@lunn.ch,
	hkallweit1@gmail.com, linux@armlinux.org.uk,
	linux-i2c@vger.kernel.org, linux-gpio@vger.kernel.org,
	mengyuanlou@net-swift.com
Subject: Re: [PATCH net-next v7 6/9] net: txgbe: Support GPIO to SFP socket
Message-ID: <ZF1T62BnVFgR33w0@surfacebook>
References: <20230509022734.148970-1-jiawenwu@trustnetic.com>
 <20230509022734.148970-7-jiawenwu@trustnetic.com>
Precedence: bulk
X-Mailing-List: netdev@vger.kernel.org
List-Id: <netdev.vger.kernel.org>
List-Subscribe: <mailto:netdev+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:netdev+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20230509022734.148970-7-jiawenwu@trustnetic.com>
X-Spam-Status: No, score=0.7 required=5.0 tests=BAYES_00,DKIM_ADSP_CUSTOM_MED,
	FORGED_GMAIL_RCVD,FREEMAIL_FROM,NML_ADSP_CUSTOM_MED,SPF_HELO_NONE,
	SPF_SOFTFAIL,T_SCC_BODY_TEXT_LINE autolearn=no autolearn_force=no
	version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
	lindbergh.monkeyblade.net

Tue, May 09, 2023 at 10:27:31AM +0800, Jiawen Wu kirjoitti:
> Register GPIO chip and handle GPIO IRQ for SFP socket.

...

> +#include <linux/gpio/consumer.h>

What for?

> +#include <linux/gpio/machine.h>
> +#include <linux/gpio/driver.h>

...

> +static int txgbe_gpio_get(struct gpio_chip *chip, unsigned int offset)
> +{
> +	struct wx *wx = gpiochip_get_data(chip);
> +	struct txgbe *txgbe = wx->priv;
> +	int val;
> +
> +	val = rd32m(wx, WX_GPIO_EXT, BIT(offset));
> +
> +	txgbe->gpio_orig &= ~BIT(offset);
> +	txgbe->gpio_orig |= val;

This can use standard pattern in conjunction with simple rd32() call:

	txgbe->gpio_orig = (txgbe->gpio_orig & ~BIT(offset)) | (val & BIT(offset));

otherwise it's not immediately obvious that val can have only one bit set.

> +	return !!(val & BIT(offset));
> +}

...

> +static int txgbe_gpio_direction_out(struct gpio_chip *chip, unsigned int offset,
> +				    int val)
> +{
> +	struct wx *wx = gpiochip_get_data(chip);
> +	u32 mask;
> +
> +	mask = BIT(offset) | BIT(offset - 1);
> +	if (val)
> +		wr32m(wx, WX_GPIO_DR, mask, mask);
> +	else
> +		wr32m(wx, WX_GPIO_DR, mask, 0);
> +
> +	wr32m(wx, WX_GPIO_DDR, BIT(offset), BIT(offset));

Can you explain, what prevents to have this flow to be interleaved by other API
calls, like ->direction_in()? Didn't you missed proper locking schema?

> +	return 0;
> +}

...

> +	switch (type) {
> +	case IRQ_TYPE_EDGE_BOTH:
> +		level |= BIT(hwirq);
> +		break;
> +	case IRQ_TYPE_EDGE_RISING:
> +		level |= BIT(hwirq);
> +		polarity |= BIT(hwirq);
> +		break;
> +	case IRQ_TYPE_EDGE_FALLING:
> +		level |= BIT(hwirq);

> +		polarity &= ~BIT(hwirq);

This...

> +		break;
> +	case IRQ_TYPE_LEVEL_HIGH:
> +		level &= ~BIT(hwirq);

...and this can be done outside of the switch-case. Then you simply set certain
bits where it's needed.

> +		polarity |= BIT(hwirq);
> +		break;
> +	case IRQ_TYPE_LEVEL_LOW:
> +		level &= ~BIT(hwirq);
> +		polarity &= ~BIT(hwirq);
> +		break;

default?

> +	}

...

> +	/* workaround for hysteretic gpio interrupts */

GPIO

...

> +	gc->can_sleep = false;

Useless, kzalloc() already sets this to 0.

...

> +	girq->num_parents = 1;
> +	girq->parents = devm_kcalloc(&pdev->dev, 1, sizeof(*girq->parents),

Use girq->num_parents instead of explicit 1 in this call.

> +				     GFP_KERNEL);

Also with 

	struct device *dev = &pdev->dev;

this (and others) can be modified as

	girq->parents = devm_kcalloc(dev, girq->num_parents, sizeof(*girq->parents),

> +	if (!girq->parents)
> +		return -ENOMEM;


...

> +#define TXGBE_PX_MISC_IEN_MASK ( \
> +				TXGBE_PX_MISC_ETH_LKDN | \
> +				TXGBE_PX_MISC_DEV_RST | \
> +				TXGBE_PX_MISC_ETH_EVENT | \
> +				TXGBE_PX_MISC_ETH_LK | \
> +				TXGBE_PX_MISC_ETH_AN | \
> +				TXGBE_PX_MISC_INT_ERR | \
> +				TXGBE_PX_MISC_GPIO)

Wouldn't be better

#define TXGBE_PX_MISC_IEN_MASK				  \
	(TXGBE_PX_MISC_ETH_LKDN | TXGBE_PX_MISC_ETH_LK |  \
	 TXGBE_PX_MISC_ETH_EVENT | TXGBE_PX_MISC_ETH_AN | \
	 TXGBE_PX_MISC_DEV_RST | TXGBE_PX_MISC_INT_ERR |  \
	 TXGBE_PX_MISC_GPIO)

?

-- 
With Best Regards,
Andy Shevchenko



