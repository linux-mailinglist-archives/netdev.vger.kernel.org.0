Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 3F1D1102221
	for <lists+netdev@lfdr.de>; Tue, 19 Nov 2019 11:33:55 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726510AbfKSKdx (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 19 Nov 2019 05:33:53 -0500
Received: from ssl.serverraum.org ([176.9.125.105]:52809 "EHLO
        ssl.serverraum.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1725798AbfKSKdx (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 19 Nov 2019 05:33:53 -0500
Received: from ssl.serverraum.org (web.serverraum.org [172.16.0.2])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ssl.serverraum.org (Postfix) with ESMTPSA id 7187923E2B;
        Tue, 19 Nov 2019 11:33:47 +0100 (CET)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=walle.cc;
        s=mail2016061301; t=1574159631;
        bh=FE+nCTog6JG/XrrGCCy23+sHHkjJUb2aFw+z/UwteV0=;
        h=Date:From:To:Cc:Subject:In-Reply-To:From;
        b=F3kvby8GhdY4Vgv4ISfLTAintcZTiwxqsQ080Fv2Jx4kIQPqL5FAhRmblft6EeZaq
         mpqo3iCeWTjI984YYXspvdNZxdR4Z7UuzqkhTj1zH6OZ5aUM1gjTy7qTDlikTBfvZF
         Ms6ItlUA5T/1PPJc2zr5vP9PHc5rwrj2rREHOIbw=
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII;
 format=flowed
Content-Transfer-Encoding: 7bit
Date:   Tue, 19 Nov 2019 11:33:47 +0100
From:   Michael Walle <michael@walle.cc>
To:     hkallweit1@gmail.com
Cc:     andrew@lunn.ch, davem@davemloft.net, f.fainelli@gmail.com,
        linux@armlinux.org.uk, netdev@vger.kernel.org
Subject: Re: [PATCH net-next v2 2/3] net: phy: add callback for custom
 interrupt handler to struct phy_driver
In-Reply-To: <acb8507d-d5a3-2190-8d5c-988f1062f2e7@gmail.com>
Message-ID: <bd47f8e1ebc04fa98856ed8d89b91419@walle.cc>
X-Sender: michael@walle.cc
User-Agent: Roundcube Webmail/1.3.8
X-Virus-Scanned: clamav-milter 0.101.4 at web
X-Virus-Status: Clean
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org


Hi,

this is an old thread and I know its already applied. But I'd like to 
hear your opinion on the following problem below.

> The phylib interrupt handler handles link change events only currently.
> However PHY drivers may want to use other interrupt sources too,
> e.g. to report temperature monitoring events. Therefore add a callback
> to struct phy_driver allowing PHY drivers to implement a custom
> interrupt handler.
> 
> Signed-off-by: Heiner Kallweit <hkallweit1@gmail.com>
> Suggested-by: Russell King - ARM Linux admin <linux@armlinux.org.uk>
> Acked-by: Russell King <rmk+kernel@armlinux.org.uk>
> ---
>  drivers/net/phy/phy.c | 9 +++++++--
>  include/linux/phy.h   | 3 +++
>  2 files changed, 10 insertions(+), 2 deletions(-)
> 
> diff --git a/drivers/net/phy/phy.c b/drivers/net/phy/phy.c
> index d90d9863e..068f0a126 100644
> --- a/drivers/net/phy/phy.c
> +++ b/drivers/net/phy/phy.c
> @@ -772,8 +772,13 @@ static irqreturn_t phy_interrupt(int irq, void 
> *phy_dat)
>  	if (phydev->drv->did_interrupt && 
> !phydev->drv->did_interrupt(phydev))
>  		return IRQ_NONE;
> 
> -	/* reschedule state queue work to run as soon as possible */
> -	phy_trigger_machine(phydev);
> +	if (phydev->drv->handle_interrupt) {
> +		if (phydev->drv->handle_interrupt(phydev))
> +			goto phy_err;

There are PHYs which clears the interrupt already by reading the 
interrupt status register. To do something useful in handle_interrupt() 
I have to read the interrupt status register, thus clearing the pending 
interrupts.


> +	} else {
> +		/* reschedule state queue work to run as soon as possible */
> +		phy_trigger_machine(phydev);
> +	}
> 
>  	if (phy_clear_interrupt(phydev))
>  		goto phy_err;

But here the interrupts are cleared again, which means we might loose 
interrupt causes in between.

I could think of two different fixes:
  (1) handle_interrupt() has to take care to clear the interrupts and 
skip the phy_clear_interrupt() above.
  (2) handle_interrupt() might return a special return code which skips 
the phy_clear_interrupt

TBH, I'd prefer (1) but I don't know if it is allowed to change 
semantics afterwards. (Also, I've found no driver where 
handle_interrupt() is actually used for now?)

-michael
