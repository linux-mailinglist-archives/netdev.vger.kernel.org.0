Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id D6E3F63FA49
	for <lists+netdev@lfdr.de>; Thu,  1 Dec 2022 23:06:51 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229757AbiLAWGt (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 1 Dec 2022 17:06:49 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:53164 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229473AbiLAWGs (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 1 Dec 2022 17:06:48 -0500
Received: from vps0.lunn.ch (vps0.lunn.ch [156.67.10.101])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 2CD40C3FFF
        for <netdev@vger.kernel.org>; Thu,  1 Dec 2022 14:06:47 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed; d=lunn.ch;
        s=20171124; h=In-Reply-To:Content-Disposition:Content-Type:MIME-Version:
        References:Message-ID:Subject:Cc:To:From:Date:From:Sender:Reply-To:Subject:
        Date:Message-ID:To:Cc:MIME-Version:Content-Type:Content-Transfer-Encoding:
        Content-ID:Content-Description:Content-Disposition:In-Reply-To:References;
        bh=Tuyx0hxqCJRvjVXQCxJboFXdr4CploED6aHOX2q1/pk=; b=uUW+lXeqE4KoyMBh667ABI1XPl
        uX8MSB4NYtU1MlZJQkib60LOyQuRPG7xAlPS4H93qVKIzT+g/j1g9up/7lKXS4A4x5ajeTXORWWmH
        IMdmq4yLog1FY8wr0SqvR1V6kCKRGqLqOi0ssUiwBe3PH0K+80j6PH+B5Tg3fvP2TZuc=;
Received: from andrew by vps0.lunn.ch with local (Exim 4.94.2)
        (envelope-from <andrew@lunn.ch>)
        id 1p0rhW-0046Lv-Hl; Thu, 01 Dec 2022 23:06:38 +0100
Date:   Thu, 1 Dec 2022 23:06:38 +0100
From:   Andrew Lunn <andrew@lunn.ch>
To:     Michael Walle <michael@walle.cc>
Cc:     Heiner Kallweit <hkallweit1@gmail.com>,
        Russell King <linux@armlinux.org.uk>,
        Horatiu Vultur <horatiu.vultur@microchip.com>,
        netdev@vger.kernel.org, Xu Liang <lxu@maxlinear.com>
Subject: Re: GPY215 PHY interrupt issue
Message-ID: <Y4klbgDIuxHXaWrC@lunn.ch>
References: <fd1352e543c9d815a7a327653baacda7@walle.cc>
 <Y4DcoTmU3nWqMHIp@lunn.ch>
 <baa468f15c6e00c0f29a31253c54383c@walle.cc>
 <Y4S4EfChuo0wmX2k@lunn.ch>
 <c69e1d1d897dd7500b59c49f0873e7dd@walle.cc>
 <Y4jOMocoLneO8xoD@lunn.ch>
 <158870dd20a5e30cda9f17009aa0c6c8@walle.cc>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <158870dd20a5e30cda9f17009aa0c6c8@walle.cc>
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,SPF_HELO_PASS,SPF_PASS
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Thu, Dec 01, 2022 at 10:31:19PM +0100, Michael Walle wrote:
> Am 2022-12-01 16:54, schrieb Andrew Lunn:
> > > So, switching the line to GPIO input doesn't help here, which also
> > > means the interrupt line will be stuck the whole time.
> > 
> > Sounds like they totally messed up the design somehow.
> > 
> > Since we are into horrible hack territory.....
> > 
> > I assume you are using the Link state change interrupt? LSTC?
> 
> Yes, but recently I've found it that it also happens with
> the speed change interrupt (during link-up). By pure luck (or
> bad luck really?) I discovered that when I reduce the MDIO
> frequency I get a similar behavior for the interrupt line
> at link-up with the LSPC interrupt. I don't think it has
> something to do with the frequency but with changed timing.

So at a wild guess, there is some sort of race condition between the
2.5MHz ish MDIO clock and the rest of the system which is probably
clocked at 25Mhz.

We have to hope this is limited to just interrupts! Not any MDIO bus
transaction.

> +	/* The PHY might leave the interrupt line asserted even after PHY_ISTAT
> +	* is read. To avoid interrupt storms, delay the interrupt handling as
> +	* long as the PHY drives the interrupt line. An internal bus read will
> +	* stall as long as the interrupt line is asserted, thus just read a
> +	* random register here.
> +	* Because we cannot access the internal bus at all while the interrupt
> +	* is driven by the PHY, there is no way to make the interrupt line
> +	* unstuck (e.g. by changing the pinmux to GPIO input) during that time
> +	* frame. Therefore, polling is the best we can do and won't do any more
> +	* harm.
> +	* It was observed that this bug happens on link state and link speed
> +	* changes on a GPY215B and GYP215C independent of the firmware version
> +	* (which doesn't mean that this list is exhaustive).
> +	*/
> +	if (needs_mdint_wa && (reg & (PHY_IMASK_LSTC | PHY_IMASK_LSPC)))
> +		gpy_mbox_read(phydev, REG_GPIO0_OUT);
> +
>  	phy_trigger_machine(phydev);
> 
>  	return IRQ_HANDLED;

So this delayed exiting the interrupt handler until the line actually
return to normal. And during that time, the interrupt is disabled. And
hence the storm is avoided.

I'm assuming gpy_mbox_read() has a timeout, so if the PHY completely
jams, it does exit? If that happens, maybe call phy_error() to
indicate the PHY is dead. And don't return IRQ_HANDLED, but
IRQ_NONE. I think the IRQ core should notice the storm for an
interrupt which nobody cares about and disable the interrupt.
Probably not much you can do after that, but at least the machine
won't be totally dead.

> It seems like at least these two are :/ So with the code above
> we could avoid the interrupt storm but we can't do anything about
> the blocked interrupt line. I'm unsure if that is acceptable or
> if we'd have to disable interrupts on this PHY altogether and
> fallback to polling.

It probably depends on your system design. If this is the only PHY and
the storm can be avoided, it is probably O.K. If you have other PHYs
sharing the line, and those PHYs are doing time sensitive stuff like
PTP, maybe polling would be better.

Maybe add a kconfig symbol CONFIG_MAXLINEAR_GPHY_BROKEN_INTERRUPTS and
make all the interrupt code conditional on this? Hopefully distros
won't enable it, but the option is there to buy into the behaviour if
you want?

      Andrew
