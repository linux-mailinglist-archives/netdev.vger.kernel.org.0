Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 727E32EF351
	for <lists+netdev@lfdr.de>; Fri,  8 Jan 2021 14:43:54 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727956AbhAHNnX (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 8 Jan 2021 08:43:23 -0500
Received: from vps0.lunn.ch ([185.16.172.187]:57036 "EHLO vps0.lunn.ch"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1727657AbhAHNnW (ORCPT <rfc822;netdev@vger.kernel.org>);
        Fri, 8 Jan 2021 08:43:22 -0500
Received: from andrew by vps0.lunn.ch with local (Exim 4.94)
        (envelope-from <andrew@lunn.ch>)
        id 1kxs2J-00GuNh-PA; Fri, 08 Jan 2021 14:42:39 +0100
Date:   Fri, 8 Jan 2021 14:42:39 +0100
From:   Andrew Lunn <andrew@lunn.ch>
To:     Florian Fainelli <f.fainelli@gmail.com>
Cc:     Brian Silverman <silvermanbri@gmail.com>, netdev@vger.kernel.org
Subject: Re: MDIO over I2C driver driver probe dependency issue
Message-ID: <X/hhT4Sz9FU4kiDe@lunn.ch>
References: <CAJKO-jaewzeB2X-hZ4EiZiyvaKqH=B0CrhvC_buqfMTcns-b-w@mail.gmail.com>
 <4606bd55-55a6-1e81-a23b-f06230ffdb52@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <4606bd55-55a6-1e81-a23b-f06230ffdb52@gmail.com>
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Thu, Jan 07, 2021 at 07:05:21PM -0800, Florian Fainelli wrote:
> 
> 
> On 1/7/2021 6:22 PM, Brian Silverman wrote:
> > I've written a very small generic MDIO driver that uses the existing
> > mdio-i2c.c library in drivers/net/phy.  The driver allows
> > communication to the PHY's MDIO interface as using I2C, as supported by
> > PHYs like the BCM54616S.  This is working on my hardware.  
> > 
> > The one issue I have is that I2C is not up and available (i.e. probed)
> > at the time that the MDIO interface comes up.  To fix this, I've changed
> > the device order in drivers/Makefile to put "obj-y += i2c/"
> > before "obj-y += net/".
> > 
> > While that works, I prefer not to have to keep that difference from
> > mainline Linux.  Also, I don't understand why i2c drivers occur
> > arbitrarily late in the Makefile - surely there are other devices
> > drivers that need i2c to be enabled when they are probed?
> > 
> > Is there a way to do this that doesn't change probe order?  Or is there
> > a way to change probe order without patching mainline Linux?
> 
> Linux supports probe deferral so when a consumer of a resource finds
> that said resource's provider is not available, it should return
> -EPROBE_DEFER which puts the driver's probe routine onto a list of
> driver's probe function to retry at a later time.
> 
> In your case the GEM Ethernet driver should get an -EPROBE_DEFER while
> the Ethernet PHY device tree node is looked up via
> phylink_of_phy_connect() because the mdio-i2c-gen i2c client has not had
> a chance to register the MDIO bus yet. Have you figured out the call
> path that does not work for you?

Just adding to this. The way the current mdio-i2c code is used, we
have already talked to the SFP to get its EEPROM contents. So we know
I2C works at the time the mdio-i2c bus is instantiated.

You are using the code slightly differently which might be why the
code is not correctly handling EPROBE_DEFER where it should. Patches
to add this are likely to be accepted.

   Andrew
