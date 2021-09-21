Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 54C9A413D98
	for <lists+netdev@lfdr.de>; Wed, 22 Sep 2021 00:32:50 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S235999AbhIUWeR (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 21 Sep 2021 18:34:17 -0400
Received: from vps0.lunn.ch ([185.16.172.187]:53112 "EHLO vps0.lunn.ch"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S229804AbhIUWeQ (ORCPT <rfc822;netdev@vger.kernel.org>);
        Tue, 21 Sep 2021 18:34:16 -0400
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed; d=lunn.ch;
        s=20171124; h=In-Reply-To:Content-Disposition:Content-Type:MIME-Version:
        References:Message-ID:Subject:Cc:To:From:Date:From:Sender:Reply-To:Subject:
        Date:Message-ID:To:Cc:MIME-Version:Content-Type:Content-Transfer-Encoding:
        Content-ID:Content-Description:Content-Disposition:In-Reply-To:References;
        bh=0zt4dGRGiG2hvtuVUNLMzRo7RRgH5y2zRAjMPF4/mZ4=; b=rX2dOnix6rYqsIYA3/nuthQK2r
        UWcdOdNLieKt7OMdGjRITzszHutb/aJ19yviZacxH3tsz7OVSlNP5uAwQU/5y0yiW64N3vWb2NMr1
        e0XPIiZs7RLLRmxgyyhykkyP+gEhIU4t3MaOhKyTq6EWcvui8rvydLE2dZ8QsWa2WFP4=;
Received: from andrew by vps0.lunn.ch with local (Exim 4.94.2)
        (envelope-from <andrew@lunn.ch>)
        id 1mSoJi-007hKx-3C; Wed, 22 Sep 2021 00:32:46 +0200
Date:   Wed, 22 Sep 2021 00:32:46 +0200
From:   Andrew Lunn <andrew@lunn.ch>
To:     Asmaa Mnebhi <asmaa@nvidia.com>
Cc:     andy.shevchenko@gmail.com, linux-gpio@vger.kernel.org,
        netdev@vger.kernel.org, linux-kernel@vger.kernel.org,
        linux-acpi@vger.kernel.org, kuba@kernel.org,
        linus.walleij@linaro.org, bgolaszewski@baylibre.com,
        davem@davemloft.net, rjw@rjwysocki.net, davthompson@nvidia.com
Subject: Re: [PATCH v2 1/2] gpio: mlxbf2: Introduce IRQ support
Message-ID: <YUpdjh8dtjz29TWU@lunn.ch>
References: <20210920212227.19358-1-asmaa@nvidia.com>
 <20210920212227.19358-2-asmaa@nvidia.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20210920212227.19358-2-asmaa@nvidia.com>
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
> +		fall = true;
> +		rise = true;
> +		break;
> +	case IRQ_TYPE_EDGE_RISING:
> +		rise = true;
> +		break;
> +	case IRQ_TYPE_EDGE_FALLING:
> +		fall = true;
> +		break;
> +	default:
> +		return -EINVAL;
> +	}

What PHY are you using? I think every one i've looked at are level
triggered, not edge. Using an edge interrupt might work 99% of the
time, but when the timing is just wrong, you can loose an interrupt.
Which might mean phylib thinks the link is down, when it fact it is
up. You will need to unplug and replug to recover from that.

    Andrew
