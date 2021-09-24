Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id B663D417122
	for <lists+netdev@lfdr.de>; Fri, 24 Sep 2021 13:46:38 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1343631AbhIXLsG (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 24 Sep 2021 07:48:06 -0400
Received: from vps0.lunn.ch ([185.16.172.187]:58340 "EHLO vps0.lunn.ch"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1343616AbhIXLsF (ORCPT <rfc822;netdev@vger.kernel.org>);
        Fri, 24 Sep 2021 07:48:05 -0400
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed; d=lunn.ch;
        s=20171124; h=In-Reply-To:Content-Disposition:Content-Type:MIME-Version:
        References:Message-ID:Subject:Cc:To:From:Date:From:Sender:Reply-To:Subject:
        Date:Message-ID:To:Cc:MIME-Version:Content-Type:Content-Transfer-Encoding:
        Content-ID:Content-Description:Content-Disposition:In-Reply-To:References;
        bh=UzsLt3xZrcdCbRMw2FzE9HC9AeBbekuzTOT8ERCqy/8=; b=WVNMLEeUfb0kxmL4bPEipwM3GB
        kJTy+hyt7NAoSACpY2RyhR8MvcOqJSgCPjNLHyQP7pCCBrqd7V5/2wYoszrhaYanmZL0Tn/F7UjuW
        +rRxBvsShYrY0Sq0vTVcrSgRbq0HrlsTRAJQsGRSjocQ+HJSYkf+B9wbs1S3s2u0WhCY=;
Received: from andrew by vps0.lunn.ch with local (Exim 4.94.2)
        (envelope-from <andrew@lunn.ch>)
        id 1mTjeu-0085Ih-P6; Fri, 24 Sep 2021 13:46:28 +0200
Date:   Fri, 24 Sep 2021 13:46:28 +0200
From:   Andrew Lunn <andrew@lunn.ch>
To:     Asmaa Mnebhi <asmaa@nvidia.com>
Cc:     andy.shevchenko@gmail.com, linux-gpio@vger.kernel.org,
        netdev@vger.kernel.org, linux-kernel@vger.kernel.org,
        linux-acpi@vger.kernel.org, kuba@kernel.org,
        linus.walleij@linaro.org, bgolaszewski@baylibre.com,
        davem@davemloft.net, rjw@rjwysocki.net, davthompson@nvidia.com
Subject: Re: [PATCH v3 1/2] gpio: mlxbf2: Introduce IRQ support
Message-ID: <YU26lIUayYXU/x9l@lunn.ch>
References: <20210923202216.16091-1-asmaa@nvidia.com>
 <20210923202216.16091-2-asmaa@nvidia.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20210923202216.16091-2-asmaa@nvidia.com>
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

> +static int
> +mlxbf2_gpio_irq_set_type(struct irq_data *irqd, unsigned int type)
> +{
> +	struct gpio_chip *gc = irq_data_get_irq_chip_data(irqd);
> +	struct mlxbf2_gpio_context *gs = gpiochip_get_data(gc);
> +	int offset = irqd_to_hwirq(irqd);
> +	unsigned long flags;
> +	bool fall = false;
> +	bool rise = false;
> +	u32 val;
> +
> +	switch (type & IRQ_TYPE_SENSE_MASK) {
> +	case IRQ_TYPE_EDGE_BOTH:
> +	case IRQ_TYPE_LEVEL_MASK:
> +		fall = true;
> +		rise = true;
> +		break;
> +	case IRQ_TYPE_EDGE_RISING:
> +	case IRQ_TYPE_LEVEL_HIGH:
> +		rise = true;
> +		break;
> +	case IRQ_TYPE_EDGE_FALLING:
> +	case IRQ_TYPE_LEVEL_LOW:
> +		fall = true;
> +		break;
> +	default:
> +		return -EINVAL;
> +	}

I'm still not convinced this is correct. Rising edge is different to
high. Rising edge only ever interrupts once, level keeps interrupting
until the source is cleared. You cannot store the four different
options in two bits.

Linus, have you seen anything like this before?

       Andrew
