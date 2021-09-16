Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 5041940DC57
	for <lists+netdev@lfdr.de>; Thu, 16 Sep 2021 16:06:04 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S238342AbhIPOHN (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 16 Sep 2021 10:07:13 -0400
Received: from vps0.lunn.ch ([185.16.172.187]:44234 "EHLO vps0.lunn.ch"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S235474AbhIPOHM (ORCPT <rfc822;netdev@vger.kernel.org>);
        Thu, 16 Sep 2021 10:07:12 -0400
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed; d=lunn.ch;
        s=20171124; h=In-Reply-To:Content-Disposition:Content-Type:MIME-Version:
        References:Message-ID:Subject:Cc:To:From:Date:From:Sender:Reply-To:Subject:
        Date:Message-ID:To:Cc:MIME-Version:Content-Type:Content-Transfer-Encoding:
        Content-ID:Content-Description:Content-Disposition:In-Reply-To:References;
        bh=8q+3bGjP97pZnvJgbNzp1eoHg35qG/qJ8mr6nBvLOCg=; b=WmZUuNz/HYoiHOxGlBT2eeFxl5
        /a3TLcTIn0tMRszOVMoNN/NK9cugmc2x96ntVDd8dBVdlm5fbIk+odJpGjex4WYGxyk5uiu7bHY8g
        2oFXBxLMtISOdsyh5tTnEaOX7KqpUya2gdbXElEi/1dnT+AeyiE9e9gp58SeyLleffzs=;
Received: from andrew by vps0.lunn.ch with local (Exim 4.94.2)
        (envelope-from <andrew@lunn.ch>)
        id 1mQs1L-006uuE-Gu; Thu, 16 Sep 2021 16:05:47 +0200
Date:   Thu, 16 Sep 2021 16:05:47 +0200
From:   Andrew Lunn <andrew@lunn.ch>
To:     Asmaa Mnebhi <asmaa@nvidia.com>
Cc:     andy.shevchenko@gmail.com, linux-gpio@vger.kernel.org,
        netdev@vger.kernel.org, linux-kernel@vger.kernel.org,
        linux-acpi@vger.kernel.org, kuba@kernel.org,
        linus.walleij@linaro.org, bgolaszewski@baylibre.com,
        davem@davemloft.net, rjw@rjwysocki.net, davthompson@nvidia.com
Subject: Re: [PATCH v1 1/2] gpio: mlxbf2: Introduce IRQ support
Message-ID: <YUNPO9/YacBNr/yQ@lunn.ch>
References: <20210915222847.10239-1-asmaa@nvidia.com>
 <20210915222847.10239-2-asmaa@nvidia.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20210915222847.10239-2-asmaa@nvidia.com>
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

> +static void mlxbf2_gpio_irq_enable(struct irq_data *irqd)
> +{
> +	struct gpio_chip *gc = irq_data_get_irq_chip_data(irqd);
> +	struct mlxbf2_gpio_context *gs = gpiochip_get_data(gc);
> +	int offset = irqd_to_hwirq(irqd);
> +	unsigned long flags;
> +	u32 val;
> +
> +	spin_lock_irqsave(&gs->gc.bgpio_lock, flags);
> +	val = readl(gs->gpio_io + YU_GPIO_CAUSE_OR_CLRCAUSE);
> +	val |= BIT(offset);
> +	writel(val, gs->gpio_io + YU_GPIO_CAUSE_OR_CLRCAUSE);
> +
> +	/* Enable PHY interrupt by setting the priority level */

This should be an abstract driver for a collection of GPIO lines.
Yes, one of these GPIOs is used for the PHY, but the GPIO driver does
not care. So please remove this comment.

> +	val = readl(gs->gpio_io + YU_GPIO_CAUSE_OR_EVTEN0);
> +	val |= BIT(offset);
> +	writel(val, gs->gpio_io + YU_GPIO_CAUSE_OR_EVTEN0);

What exactly does this do? It appears to clear the interrupt, if i
understand mlxbf2_gpio_irq_handler(). I don't know the GPIO framework
well enough to know if this is correct. It does mean if the interrupt
signal is active but masked, and you enable it, you appear to loose
the interrupt? Maybe you want the interrupt to fire as soon as it is
enabled?

> +static irqreturn_t mlxbf2_gpio_irq_handler(int irq, void *ptr)
> +{
> +	struct mlxbf2_gpio_context *gs = ptr;
> +	struct gpio_chip *gc = &gs->gc;
> +	unsigned long pending;
> +	u32 level;
> +
> +	pending = readl(gs->gpio_io + YU_GPIO_CAUSE_OR_CAUSE_EVTEN0);
> +	writel(pending, gs->gpio_io + YU_GPIO_CAUSE_OR_CLRCAUSE);
> +
> +	for_each_set_bit(level, &pending, gc->ngpio) {
> +		int gpio_irq = irq_find_mapping(gc->irq.domain, level);
> +		generic_handle_irq(gpio_irq);
> +	}
> +
> +	return IRQ_RETVAL(pending);
> +}
> +
> +static void mlxbf2_gpio_irq_mask(struct irq_data *irqd) {
> +	mlxbf2_gpio_irq_disable(irqd);
> +}
> +
> +static void mlxbf2_gpio_irq_unmask(struct irq_data *irqd) {
> +	mlxbf2_gpio_irq_enable(irqd);
> +}

Do these two functions have any value?

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

This looks wrong. You cannot map a level interrupt into an edge. It
looks like your hardware only supports edges. If asked to do level,
return -EINVAL.

> +	default:
> +		break;
> +	}
> +
> +	/* The INT_N interrupt level is active low.
> +	 * So enable cause fall bit to detect when GPIO
> +	 * state goes low.
> +	 */

I don't understand this comment.

  Andrew
