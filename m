Return-Path: <netdev+bounces-1773-lists+netdev=lfdr.de@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from ny.mirrors.kernel.org (ny.mirrors.kernel.org [IPv6:2604:1380:45d1:ec00::1])
	by mail.lfdr.de (Postfix) with ESMTPS id 42FB06FF1AD
	for <lists+netdev@lfdr.de>; Thu, 11 May 2023 14:39:06 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ny.mirrors.kernel.org (Postfix) with ESMTPS id 32E481C20FA3
	for <lists+netdev@lfdr.de>; Thu, 11 May 2023 12:39:03 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id C371F1F932;
	Thu, 11 May 2023 12:39:02 +0000 (UTC)
X-Original-To: netdev@vger.kernel.org
Received: from lindbergh.monkeyblade.net (lindbergh.monkeyblade.net [23.128.96.19])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id B82C465B
	for <netdev@vger.kernel.org>; Thu, 11 May 2023 12:39:02 +0000 (UTC)
Received: from vps0.lunn.ch (vps0.lunn.ch [156.67.10.101])
	by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 7E58AE5D;
	Thu, 11 May 2023 05:39:01 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed; d=lunn.ch;
	s=20171124; h=In-Reply-To:Content-Disposition:Content-Type:MIME-Version:
	References:Message-ID:Subject:Cc:To:From:Date:From:Sender:Reply-To:Subject:
	Date:Message-ID:To:Cc:MIME-Version:Content-Type:Content-Transfer-Encoding:
	Content-ID:Content-Description:Content-Disposition:In-Reply-To:References;
	bh=1l03jVhzSc8K+bqtlLwcVBBttDZZk3vsGUYwhQXaOIs=; b=Z8Y1fcozhlluNLRxuORx+lUMuA
	DB4RSZ/MYMzh6DK9fVtylMS40VGVQ2DcOvpSZU/+tFzwolr6xNWNX/r/KsW0XUVZgImH5mQOl5vz0
	nXc6BvOhg/IDssgrH7uXfkXdeOJ++iHKns5bmMn7EjC7xrx4Zam1WAcoxZsfEPmSG0nM=;
Received: from andrew by vps0.lunn.ch with local (Exim 4.94.2)
	(envelope-from <andrew@lunn.ch>)
	id 1px5ZL-00CYLU-16; Thu, 11 May 2023 14:38:51 +0200
Date: Thu, 11 May 2023 14:38:51 +0200
From: Andrew Lunn <andrew@lunn.ch>
To: Jiawen Wu <jiawenwu@trustnetic.com>
Cc: netdev@vger.kernel.org, jarkko.nikula@linux.intel.com,
	andriy.shevchenko@linux.intel.com, mika.westerberg@linux.intel.com,
	jsd@semihalf.com, Jose.Abreu@synopsys.com, hkallweit1@gmail.com,
	linux@armlinux.org.uk, linux-i2c@vger.kernel.org,
	linux-gpio@vger.kernel.org, mengyuanlou@net-swift.com
Subject: Re: [PATCH net-next v7 6/9] net: txgbe: Support GPIO to SFP socket
Message-ID: <f9e0da51-6c55-4768-aa27-437bb7f19888@lunn.ch>
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
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,SPF_HELO_PASS,SPF_PASS,
	T_SCC_BODY_TEXT_LINE autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
	lindbergh.monkeyblade.net

> +static int txgbe_gpio_set_type(struct irq_data *d, unsigned int type)
> +{
> +	struct gpio_chip *gc = irq_data_get_irq_chip_data(d);
> +	irq_hw_number_t hwirq = irqd_to_hwirq(d);
> +	struct wx *wx = gpiochip_get_data(gc);
> +	u32 level, polarity;
> +
> +	level = rd32(wx, WX_GPIO_INTTYPE_LEVEL);
> +	polarity = rd32(wx, WX_GPIO_POLARITY);
> +
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
> +		break;
> +	case IRQ_TYPE_LEVEL_HIGH:
> +		level &= ~BIT(hwirq);
> +		polarity |= BIT(hwirq);
> +		break;
> +	case IRQ_TYPE_LEVEL_LOW:
> +		level &= ~BIT(hwirq);
> +		polarity &= ~BIT(hwirq);
> +		break;
> +	}

You have two configuration bits, level and polarity, yet handle 5
different types?

> +	wr32m(wx, WX_GPIO_INTEN, BIT(hwirq), BIT(hwirq));
> +	wr32(wx, WX_GPIO_INTTYPE_LEVEL, level);
> +	if (type != IRQ_TYPE_EDGE_BOTH)
> +		wr32(wx, WX_GPIO_POLARITY, polarity);

If we are interested in both edges, then polarity is meaningless. So i
can understand not writing it. But how does the hardware know polarity
should not be used?

       Andrew

