Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 43B2640E820
	for <lists+netdev@lfdr.de>; Thu, 16 Sep 2021 20:00:18 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1353993AbhIPRiA (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 16 Sep 2021 13:38:00 -0400
Received: from vps0.lunn.ch ([185.16.172.187]:44556 "EHLO vps0.lunn.ch"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1344330AbhIPRfp (ORCPT <rfc822;netdev@vger.kernel.org>);
        Thu, 16 Sep 2021 13:35:45 -0400
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed; d=lunn.ch;
        s=20171124; h=In-Reply-To:Content-Disposition:Content-Type:MIME-Version:
        References:Message-ID:Subject:Cc:To:From:Date:From:Sender:Reply-To:Subject:
        Date:Message-ID:To:Cc:MIME-Version:Content-Type:Content-Transfer-Encoding:
        Content-ID:Content-Description:Content-Disposition:In-Reply-To:References;
        bh=PTXGEnB9DiyWtB63yQyALlfETOKew7D8vM+rEURPg4c=; b=sKtAMXHFMpblRZ4ZRcrz3Vsxv/
        WIbEKb+DoWjYcKLVSx2GGZcWy2SuVFnCAAPPQ/+cKa0xYfKEl/bkvwqKeRQkBbHmMFjWROzU8FXCu
        aovJgT/IyReR4tuKGEsosFtUANPUkUPRNIyohpH04+CGUpMdtHYKSjMnN8KlrAqk3zWU=;
Received: from andrew by vps0.lunn.ch with local (Exim 4.94.2)
        (envelope-from <andrew@lunn.ch>)
        id 1mQvHA-006x1E-ST; Thu, 16 Sep 2021 19:34:20 +0200
Date:   Thu, 16 Sep 2021 19:34:20 +0200
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
Subject: Re: [PATCH v1 1/2] gpio: mlxbf2: Introduce IRQ support
Message-ID: <YUOAHMmaSf2gs6ho@lunn.ch>
References: <20210915222847.10239-1-asmaa@nvidia.com>
 <20210915222847.10239-2-asmaa@nvidia.com>
 <YUNPO9/YacBNr/yQ@lunn.ch>
 <CH2PR12MB3895D5E16EAA1D3E5796C177D7DC9@CH2PR12MB3895.namprd12.prod.outlook.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <CH2PR12MB3895D5E16EAA1D3E5796C177D7DC9@CH2PR12MB3895.namprd12.prod.outlook.com>
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Thu, Sep 16, 2021 at 03:48:51PM +0000, Asmaa Mnebhi wrote:
> > +	/* Enable PHY interrupt by setting the priority level */
> 
> This should be an abstract driver for a collection of GPIO lines.
> Yes, one of these GPIOs is used for the PHY, but the GPIO driver does not care. So please remove this comment.
> Asmaa>> Done
> 
> > +	val = readl(gs->gpio_io + YU_GPIO_CAUSE_OR_EVTEN0);
> > +	val |= BIT(offset);
> > +	writel(val, gs->gpio_io + YU_GPIO_CAUSE_OR_EVTEN0);
> 
> What exactly does this do? It appears to clear the interrupt, if i understand mlxbf2_gpio_irq_handler(). I don't know the GPIO framework well enough to know if this is correct. It does mean if the interrupt signal is active but masked, and you enable it, you appear to loose the interrupt? Maybe you want the interrupt to fire as soon as it is enabled?
> 
> Asmaa>>
> YU_GPIO_CAUSE_OR_CLRCAUSE - Makes sure the interrupt is initially cleared. Otherwise, we will not receive further interrupts.

If the interrupt status bit is set, as soon as you unmask the
interrupt, the hardware should fire the interrupt. At least, that is
how interrupt controllers usually work.

A typical pattern is that the interrupt fires. You mask it, ack it,
and then do what is needed to actually handle the interrupt. While
doing the handling, the hardware can indicate the interrupt again. But
since it is masked nothing happened. This avoids your interrupt handler
going recursive. Once the handler has finished, the interrupt is
unmasked. At this point it actually fires, triggering the interrupt
handler again.

Please also get your email client fixed. I wrap my emails at around 75
characters. Your mailer has destroyed it. Your text should also be
wrapped at about 75 characters.

	Andrew
