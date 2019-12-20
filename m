Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 6E8421277DF
	for <lists+netdev@lfdr.de>; Fri, 20 Dec 2019 10:18:26 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727233AbfLTJSY (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 20 Dec 2019 04:18:24 -0500
Received: from vps0.lunn.ch ([185.16.172.187]:34712 "EHLO vps0.lunn.ch"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726111AbfLTJSY (ORCPT <rfc822;netdev@vger.kernel.org>);
        Fri, 20 Dec 2019 04:18:24 -0500
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed; d=lunn.ch;
        s=20171124; h=In-Reply-To:Content-Type:MIME-Version:References:Message-ID:
        Subject:Cc:To:From:Date:Sender:Reply-To:Content-Transfer-Encoding:Content-ID:
        Content-Description:Resent-Date:Resent-From:Resent-Sender:Resent-To:Resent-Cc
        :Resent-Message-ID:List-Id:List-Help:List-Unsubscribe:List-Subscribe:
        List-Post:List-Owner:List-Archive;
        bh=7oAc3KbOfStV10Pw+JK23/DHmUM3WMxbidUMaHV1jAQ=; b=zvyFHNu32mCutlOCcWLFjodOCF
        rHUfp3O/n8/V+L9vE+ieyFriv9Z2PmM5Unf1xk2SfIOAPibXTJ7yCS0PNU2stXLpYrZRwzaBF+25B
        kvj67SP8Sd5sIoOWrz2ZWALZtnOKuw+OqosV6dZmhtVRV2tKfeGkrANG2jqz8vOdofS0=;
Received: from andrew by vps0.lunn.ch with local (Exim 4.93)
        (envelope-from <andrew@lunn.ch>)
        id 1iiEQI-0006eo-Ls; Fri, 20 Dec 2019 10:18:14 +0100
Date:   Fri, 20 Dec 2019 10:18:14 +0100
From:   Andrew Lunn <andrew@lunn.ch>
To:     Russell King - ARM Linux admin <linux@armlinux.org.uk>
Cc:     David Miller <davem@davemloft.net>, f.fainelli@gmail.com,
        hkallweit1@gmail.com, netdev@vger.kernel.org
Subject: Re: [PATCH net] net: phy: make phy_error() report which PHY has
 failed
Message-ID: <20191220091814.GA24174@lunn.ch>
References: <E1ihCLZ-0001Vo-Nw@rmk-PC.armlinux.org.uk>
 <20191219.125010.1105219757379875134.davem@davemloft.net>
 <20191219214537.GF25745@shell.armlinux.org.uk>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20191219214537.GF25745@shell.armlinux.org.uk>
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Thu, Dec 19, 2019 at 09:45:37PM +0000, Russell King - ARM Linux admin wrote:
> On Thu, Dec 19, 2019 at 12:50:10PM -0800, David Miller wrote:
> > From: Russell King <rmk+kernel@armlinux.org.uk>
> > Date: Tue, 17 Dec 2019 12:53:05 +0000
> > 
> > > phy_error() is called from phy_interrupt() or phy_state_machine(), and
> > > uses WARN_ON() to print a backtrace. The backtrace is not useful when
> > > reporting a PHY error.
> > > 
> > > However, a system may contain multiple ethernet PHYs, and phy_error()
> > > gives no clue which one caused the problem.
> > > 
> > > Replace WARN_ON() with a call to phydev_err() so that we can see which
> > > PHY had an error, and also inform the user that we are halting the PHY.
> > > 
> > > Fixes: fa7b28c11bbf ("net: phy: print stack trace in phy_error")
> > > Signed-off-by: Russell King <rmk+kernel@armlinux.org.uk>
> > 
> > I think I agree with Heiner that it is valuable to know whether the
> > error occurred from the interrupt handler or the state machine (and
> > if the state machine, where that got called from).
> 
> Would you accept, then, passing a string to indicate where phy_error()
> was called from, which would do the same job without tainting the
> kernel for something that becomes a _normal_ event when removing a
> SFP?

I'm actually wondering what purpose phy_error has, and if the SFP is
using it correctly.

It is currently used when the phy driver interrupts handling returns
an error, or phy_start_aneg returns an error.

In general, with a traditional MDIO bus, you cannot tell when the
device has disappeared. Writes just disappear into the bit bucket, and
reads return 0xffff. If an error is returned by the MDIO bus driver,
it is because the mechanisms surrounding the bus have returned an
error. A needed clock has been turned off, the system is too busy to
service the interrupt in a timely manor etc. An error indicates a bug
of some sort, bad power management, or timers too short.

SFPs, with their MDIO bus tunnelled over i2c are however a little
different. i2c does allow you to know the device has gone, and return
-EIO.

We might want to consider the question, should the MDIO over i2c code
actually be tossing this EIO error, and returning 0xffff on read, no
error on write? It makes the emulation more true? Only return an error
for power management or timeouts, similar to traditional MDIO? Maybe
print a rate limited warning when dropping an EIO error?

Phylink is going to notice the PHY has disappeared soon anyway, so is
there any value in returning an error when the module has been
unplugged?

      Andrew
