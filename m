Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 93831F6B27
	for <lists+netdev@lfdr.de>; Sun, 10 Nov 2019 20:47:37 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726925AbfKJTrg (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sun, 10 Nov 2019 14:47:36 -0500
Received: from pandora.armlinux.org.uk ([78.32.30.218]:49610 "EHLO
        pandora.armlinux.org.uk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726778AbfKJTrf (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sun, 10 Nov 2019 14:47:35 -0500
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
        d=armlinux.org.uk; s=pandora-2019; h=Sender:In-Reply-To:Content-Type:
        MIME-Version:References:Message-ID:Subject:Cc:To:From:Date:Reply-To:
        Content-Transfer-Encoding:Content-ID:Content-Description:Resent-Date:
        Resent-From:Resent-Sender:Resent-To:Resent-Cc:Resent-Message-ID:List-Id:
        List-Help:List-Unsubscribe:List-Subscribe:List-Post:List-Owner:List-Archive;
         bh=tR3H4KvBtaE/IafaL5KtA4e8CkwiaCUTo6BKMxJuOLY=; b=JLnN9IDMWoTGERd5m7jvfb1Db
        1cBZrczDntRD95u6OJ7AHxKGEgVpY8F1Tm1B0+d8kkW3JSIx0WufSqr1C3y60qi/H2a/ix1DGvEmr
        kvS4Vyeh3SNVdOPJztWZ8uBj/23EpudF1xOuL7FS2fIXyhgilfTpXmOYSz2tLmcehOpQHJ9JuqHXW
        JsfXlQaCaYv8yZG1GT5TnAfPKR9a53PkT99WJYfahj8M3MbthaUshoEZsox/xtAzRnDLiYZMItX3v
        E/hWLMhhkOXzDCvw3P21dOYIj2pQrvIGPhxeCPoLBI9Xb3YSmcvpxyuB3A6mr5y28i28sCHLdvCnw
        dcMRF07Cg==;
Received: from shell.armlinux.org.uk ([2002:4e20:1eda:1:5054:ff:fe00:4ec]:33752)
        by pandora.armlinux.org.uk with esmtpsa (TLSv1.2:ECDHE-RSA-AES256-GCM-SHA384:256)
        (Exim 4.90_1)
        (envelope-from <linux@armlinux.org.uk>)
        id 1iTtBI-0000r6-Qj; Sun, 10 Nov 2019 19:47:28 +0000
Received: from linux by shell.armlinux.org.uk with local (Exim 4.92)
        (envelope-from <linux@shell.armlinux.org.uk>)
        id 1iTtBF-0008CR-JP; Sun, 10 Nov 2019 19:47:25 +0000
Date:   Sun, 10 Nov 2019 19:47:25 +0000
From:   Russell King - ARM Linux admin <linux@armlinux.org.uk>
To:     Andrew Lunn <andrew@lunn.ch>
Cc:     Florian Fainelli <f.fainelli@gmail.com>,
        Heiner Kallweit <hkallweit1@gmail.com>,
        "David S. Miller" <davem@davemloft.net>, netdev@vger.kernel.org
Subject: Re: [PATCH net-next 00/17] Allow slow to initialise GPON modules to
 work
Message-ID: <20191110194725.GE25745@shell.armlinux.org.uk>
References: <20191110140530.GA25745@shell.armlinux.org.uk>
 <20191110175217.GL25889@lunn.ch>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20191110175217.GL25889@lunn.ch>
User-Agent: Mutt/1.10.1 (2018-07-13)
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Sun, Nov 10, 2019 at 06:52:17PM +0100, Andrew Lunn wrote:
> On Sun, Nov 10, 2019 at 02:05:30PM +0000, Russell King - ARM Linux admin wrote:
> > Some GPON modules take longer than the SFF MSA specified time to
> > initialise and respond to transactions on the I2C bus for either
> > both 0x50 and 0x51, or 0x51 bus addresses.  Technically these modules
> > are non-compliant with the SFP Multi-Source Agreement, they have
> > been around for some time, so are difficult to just ignore.
> 
> Hi Russell
> 
> We are seeing quite a few SFP/SFF which violate the spec. Do you think
> there is any value in naming and shaming in the kernel logs SFP which
> don't conform to the standard? If you need to wait longer than 1
> second for the EEPROM to become readable, print the vendor name from
> the EEPROM and warn it is not conforment. If the diagnostic page is
> not immediately available, again, print the vendor name warn it is not
> conforment?

I really don't think it will achieve anything.  Once something is
established in the market, it's difficult to get the vendor to change
it.

In some cases, it's not possible to change it without an entire
hardware redesign, and we're not going to achieve that by "naming and
shaming" when most places this will be used is in embedded devices
where hardly anyone looks at the kernel message log.

It is annoying that there are these modules that do not conform, but
we have many instances in the kernel of hardware that doesn't quite
conform, yet we still make it work.

I have another fun case with another module - a copper SFP+ module that
has a Broadcom Clause 45 NBASE-T PHY on it.  On reset, it quickly
becomes accessible via the I2C bus, but it hasn't finished
initialising.  We're soo quick in the kernel that we read the IDs and
bind the PHY driver for it, and attempt to set the advertisements - but
because the PHY hasn't finished initialising, the kernels
advertisements get overwritten by the PHY (presumably EEPROM loading,
or maybe via PHY firmware initialisation.)

I've stumbled over (very annoyingly) the fact that OpenWRT is carrying
a patch for the SFP code to deal with PHYs that need longer to
initialise - but there has been no upstream report of it afaics:

https://github.com/openwrt/openwrt/blob/master/target/linux/mvebu/patches-4.19/450-reprobe_sfp_phy.patch

That may be due to us not quite checking the TX_FAULT line correctly
(which these patches change) - we had assumed that the PHY would
always be available after 50ms, but the spec actually says that
modules are allowed 300ms to startup (even longer, 90s, for cooled
laser optical modules, which I haven't published the patches for.)
End of the startup is signalled by TX_FAULT being deasserted.  However,
the copper PHYs I've seen so far tie TX_FAULT to ground on the module,
and I have no cooled laser modules to test with.  Maybe all copper PHY
modules are non-compliant...

Also, remember that there is nothing in the EEPROM which tells us what
mode the host serdes should operate in - we work that out by best-
guessing today, and so far we're getting away with it.  There are,
however, copper SFP modules that are 1G only that use 1000BASE-X,
where the only difference from their 1G/100M/10M cousins is a different
part number and use SGMII by default.

What I'm basically saying is that relying on the "specification" is
all well and good, but if we implmented the letter of the spec, we
would only allow 1000BASE-X with SFP and 10GBASE-R with SFP+ cages,
and wouldn't have copper SFPs working.  Technically, the majority of
those on the market are non-compliant.

-- 
RMK's Patch system: https://www.armlinux.org.uk/developer/patches/
FTTC broadband for 0.8mile line in suburbia: sync at 12.1Mbps down 622kbps up
According to speedtest.net: 11.9Mbps down 500kbps up
