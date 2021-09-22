Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 0EDB3414C8E
	for <lists+netdev@lfdr.de>; Wed, 22 Sep 2021 16:57:49 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S236346AbhIVO7Q (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 22 Sep 2021 10:59:16 -0400
Received: from vps0.lunn.ch ([185.16.172.187]:54636 "EHLO vps0.lunn.ch"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S235014AbhIVO7P (ORCPT <rfc822;netdev@vger.kernel.org>);
        Wed, 22 Sep 2021 10:59:15 -0400
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed; d=lunn.ch;
        s=20171124; h=In-Reply-To:Content-Disposition:Content-Type:MIME-Version:
        References:Message-ID:Subject:Cc:To:From:Date:From:Sender:Reply-To:Subject:
        Date:Message-ID:To:Cc:MIME-Version:Content-Type:Content-Transfer-Encoding:
        Content-ID:Content-Description:Content-Disposition:In-Reply-To:References;
        bh=cb2MqIRsBK1xs3g/KAOlStoR5T3t07WzhJ2422FcwFE=; b=M0ynUSbAv5YRUL4YdJaik4+wXc
        WW+4pO0cAf4+lh5MXc17C+FpLOn7WYZtyG0XUk9PWwc606914+PdIh9Qnh6obHjSx3YSx8ZzxyaFG
        2BXW6vtzT2GUQuPiFiQ5C1IWxv5FPn7Uyow/DQpQSj4h+PjPFw6+1d6DlMWFyQtwt9qw=;
Received: from andrew by vps0.lunn.ch with local (Exim 4.94.2)
        (envelope-from <andrew@lunn.ch>)
        id 1mT3gs-007nQl-KY; Wed, 22 Sep 2021 16:57:42 +0200
Date:   Wed, 22 Sep 2021 16:57:42 +0200
From:   Andrew Lunn <andrew@lunn.ch>
To:     Asmaa Mnebhi <asmaa@nvidia.com>
Cc:     "andy.shevchenko@gmail.com" <andy.shevchenko@gmail.com>,
        "linux-gpio@vger.kernel.org" <linux-gpio@vger.kernel.org>,
        "netdev@vger.kernel.org" <netdev@vger.kernel.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "linux-acpi@vger.kernel.org" <linux-acpi@vger.kernel.org>,
        "kuba@kernel.org" <kuba@kernel.org>,
        "linus.walleij@linaro.org" <linus.walleij@linaro.org>,
        "bgolaszewski@baylibre.com" <bgolaszewski@baylibre.com>,
        "davem@davemloft.net" <davem@davemloft.net>,
        "rjw@rjwysocki.net" <rjw@rjwysocki.net>,
        David Thompson <davthompson@nvidia.com>
Subject: Re: [PATCH v2 1/2] gpio: mlxbf2: Introduce IRQ support
Message-ID: <YUtEZvkI7ZPzfffo@lunn.ch>
References: <20210920212227.19358-1-asmaa@nvidia.com>
 <20210920212227.19358-2-asmaa@nvidia.com>
 <YUpdjh8dtjz29TWU@lunn.ch>
 <CH2PR12MB38951F1A008AE68A6FE7ED96D7A29@CH2PR12MB3895.namprd12.prod.outlook.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <CH2PR12MB38951F1A008AE68A6FE7ED96D7A29@CH2PR12MB3895.namprd12.prod.outlook.com>
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Wed, Sep 22, 2021 at 02:16:40PM +0000, Asmaa Mnebhi wrote:
> 
> > +static int
> > +mlxbf2_gpio_irq_set_type(struct irq_data *irqd, unsigned int type) {
> > +
> > +	switch (type & IRQ_TYPE_SENSE_MASK) {
> > +	case IRQ_TYPE_EDGE_BOTH:
> > +		fall = true;
> > +		rise = true;
> > +		break;
> > +	case IRQ_TYPE_EDGE_RISING:
> > +		rise = true;
> > +		break;
> > +	case IRQ_TYPE_EDGE_FALLING:
> > +		fall = true;
> > +		break;
> > +	default:
> > +		return -EINVAL;
> > +	}
> 
> > What PHY are you using? I think every one i've looked at are 
> > level triggered, not edge. Using an edge interrupt might work 99% 
> > of the time, but when the timing is just wrong, you can loose an interrupt.
> > Which might mean phylib thinks the link is down, when it fact it is up. 
> > You will need to unplug and replug to recover from that.
> 
> It is the micrel PHY KSZ9031 so it is an active low level interrupt.
> Here, IRQ_TYPE_EDGE* macros are mainly used to decide whether to write the
> YU_GPIO_CAUSE_FALL_EN register vs the YU_GPIO_CAUSE_RISE_EN register.
> These 2 registers are used in both LEVEL/EDGE interrupts.

I assume you also have an YU_GPIO_CAUSE_LOW_EN and
YU_GPIO_CAUSE_HIGH_EN registers? These registers need to be set for
IRQ_TYPE_LEVEL_LOW and IRQ_TYPE_LEVEL_HIGH.

	Andrew
