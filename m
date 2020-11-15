Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 57D9A2B334D
	for <lists+netdev@lfdr.de>; Sun, 15 Nov 2020 11:06:16 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726897AbgKOKFF (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sun, 15 Nov 2020 05:05:05 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:37434 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726230AbgKOKFD (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sun, 15 Nov 2020 05:05:03 -0500
Received: from pandora.armlinux.org.uk (pandora.armlinux.org.uk [IPv6:2001:4d48:ad52:32c8:5054:ff:fe00:142])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 4674CC0613D1;
        Sun, 15 Nov 2020 02:05:03 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
        d=armlinux.org.uk; s=pandora-2019; h=Sender:In-Reply-To:
        Content-Transfer-Encoding:Content-Type:MIME-Version:References:Message-ID:
        Subject:Cc:To:From:Date:Reply-To:Content-ID:Content-Description:Resent-Date:
        Resent-From:Resent-Sender:Resent-To:Resent-Cc:Resent-Message-ID:List-Id:
        List-Help:List-Unsubscribe:List-Subscribe:List-Post:List-Owner:List-Archive;
         bh=xbB7JpUs0C23en3G8maFju9tp+wQdQlNV3DRGGRnitU=; b=R+Wcg18x0KXaGCdeD/7SwAgqZ
        yb9yLvBhCxF8qgX6G8YOU1A1+gBVv0rfN1pqLqEnzuJwhVUPJEdLzIP/TeDUe6Kn2bn3LqBMBTZI3
        5EkjYA707lZRJh8LnxfZm+0bmwGOH6IdX2+0s7xlvUaXhAXRAhTADnsyfB3HUDrfX6D0uyTljHAvc
        nDaS9bvAm9QcWgmZuOrZQqW53rdssuGjLZxffYHqqXN4Z5b+vzGB/GScRQ8uC/6vLVPBuUEQ1suaT
        mkiyzE+rwEcgQ1czmLjYKTLSivJfQxmYdeBDn95hFN+/cKn3s06XGxmySP903mSydWGAMPiIiLqfV
        qjKuq9X1w==;
Received: from shell.armlinux.org.uk ([fd8f:7570:feb6:1:5054:ff:fe00:4ec]:59938)
        by pandora.armlinux.org.uk with esmtpsa (TLS1.3:ECDHE_RSA_AES_256_GCM_SHA384:256)
        (Exim 4.92)
        (envelope-from <linux@armlinux.org.uk>)
        id 1keEtu-0006Om-Iz; Sun, 15 Nov 2020 10:04:50 +0000
Received: from linux by shell.armlinux.org.uk with local (Exim 4.92)
        (envelope-from <linux@shell.armlinux.org.uk>)
        id 1keEts-0006Lq-Ru; Sun, 15 Nov 2020 10:04:48 +0000
Date:   Sun, 15 Nov 2020 10:04:48 +0000
From:   Russell King - ARM Linux admin <linux@armlinux.org.uk>
To:     Andreas =?iso-8859-1?Q?F=E4rber?= <afaerber@suse.de>
Cc:     "David S . Miller" <davem@davemloft.net>,
        Thomas Petazzoni <thomas.petazzoni@bootlin.com>,
        Uwe =?iso-8859-1?Q?Kleine-K=F6nig?= <uwe@kleine-koenig.org>,
        Michal Hrusecki <Michal.Hrusecky@nic.cz>,
        Sascha Hauer <s.hauer@pengutronix.de>,
        Marek =?iso-8859-1?Q?Beh=FAn?= <kabel@kernel.org>,
        Andrew Lunn <andrew@lunn.ch>,
        Jason Cooper <jason@lakedaemon.net>,
        Gregory CLEMENT <gregory.clement@bootlin.com>,
        Jakub Kicinski <kuba@kernel.org>, netdev@vger.kernel.org,
        linux-kernel@vger.kernel.org, devicetree@vger.kernel.org,
        Rob Herring <robh@kernel.org>
Subject: Re: [PATCH net-next] net: mvneta: Fix validation of 2.5G HSGMII
 without comphy
Message-ID: <20201115100448.GG1551@shell.armlinux.org.uk>
References: <20201115004151.12899-1-afaerber@suse.de>
 <20201115010241.GF1551@shell.armlinux.org.uk>
 <4bf5376c-a7d1-17bf-1034-b793113b101e@suse.de>
MIME-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <4bf5376c-a7d1-17bf-1034-b793113b101e@suse.de>
User-Agent: Mutt/1.10.1 (2018-07-13)
Sender: Russell King - ARM Linux admin <linux@armlinux.org.uk>
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Sun, Nov 15, 2020 at 03:26:01AM +0100, Andreas Färber wrote:
> Hi Russell,
> 
> On 15.11.20 02:02, Russell King - ARM Linux admin wrote:
> > On Sun, Nov 15, 2020 at 01:41:51AM +0100, Andreas Färber wrote:
> >> Commit 1a642ca7f38992b086101fe204a1ae3c90ed8016 (net: ethernet: mvneta:
> >> Add 2500BaseX support for SoCs without comphy) added support for 2500BaseX.
> >>
> >> In case a comphy is not provided, mvneta_validate()'s check
> >>   state->interface == PHY_INTERFACE_MODE_2500BASEX
> >> could never be true (it would've returned with empty bitmask before),
> >> so that 2500baseT_Full and 2500baseX_Full do net get added to the mask.
> > 
> > This makes me nervous. It was intentional that if there is no comphy
> > configured in DT for SoCs such as Armada 388, then there is no support
> > to switch between 1G and 2.5G speed. Unfortunately, the configuration
> > of the comphy is up to the board to do, not the SoC .dtsi, so we can't
> > rely on there being a comphy on Armada 388 systems.
> 
> Please note that the if clause at the beginning of the validate function
> does not check for comphy at all. So even with comphy, if there is a
> code path that attempts to validate state 2500BASEX, it is broken, too.

I'm afraid you are mistaken.  phy_interface_mode_is_8023z() covers
both 1000BASEX and 2500BASEX.

> Do you consider the modification of both ifs (validate and power_up) as
> correct? Should they be split off from my main _NA change you discuss?

Sorry, don't understand this comment.

> > So, one of the side effects of this patch is it incorrectly opens up
> > the possibility of allowing 2.5G support on Armada 388 without a comphy
> > configured.
> > 
> > We really need a better way to solve this; just relying on the lack of
> > comphy and poking at a register that has no effect on Armada 388 to
> > select 2.5G speed while allowing 1G and 2.5G to be arbitarily chosen
> > doesn't sound like a good idea to me.
> [snip]
> 
> May I add that the comphy needs better documentation?
> 
> As a DT contributor I would need the binding to tell me that it's an
> enum with 2 meaning SGMII2. Not even the max of 2 is documented. The
> Linux driver talks of ports, but I don't see that term used in U-Boot,
> and U-Boot APIs appeared to pass very different args in the board code.

It would be nice if the comphy documentation described this parameter
in detail for all comphys, but alas it hasn't been.

This is described in the binding for Armada 38x
Documentation/devicetree/bindings/phy/phy-armada38x-comphy.txt:

- #phy-cells : from the generic phy bindings, must be 1. Defines the
               input port to use for a given comphy lane.

This came from the phy-mvebu-comphy.txt, which was maintained by
bootlin/free-electrons, and uses the same wording.

For the Armada 38x comphy, it is the internal port number for the
ethernet controller when the comphy is connected to ethernet. So,
0 is ethernet@70000, 1 is ethernet@30000, 2 is ethernet@34000. It
actually defines an index into a table in the comphy driver which is
used to look up the "Common PHYs Selectors Register" setting for each
comphy, and also describes the bit index in an undocumented
configuration register for the ethernet port. Look at Table 1479
in the public Armada-38x-Functional-Spec-U0A document (which can be
found via google.) You'll see it talks about XXX PortN. This is the
"N" value.

The Armada 38x comphy Linux driver does not support non-ethernet
interfaces (since this was all I needed it for) but the hardware does
support SATA and USB. The driver can be regarded as incomplete, but it
is not necessary for it to be complete. These are not described in the
DT for the SoC since historically they have not needed to be, since
u-boot does all the setup there - and to add them would require a lot
of effort to ensure that they were correct for every board. That's
dangerous to do when we don't have a driver making use of that
information; there would be no validation that it is correct.

> The binding also still needs to be converted to YAML before we can
> extend it with any better explanations. (And before you suggest it:
> Since I obviously don't fully understand that hardware, I'm the wrong
> person to attempt documenting it. The 38x comphy seems not mentioned in
> MAINTAINERS, only the 3700 one.)

I'm not sure how we'd better describe it TBH. It is the input port
number as described by the SoC documentation.

I suppose we could say:

	0 for ethernet@70000
	1 for ethernet@30000
	2 for ethernet@34000
	0 for usb@...
	1 for usb@...
	0 for pci@...
	1 for pci@...
	... etc ...

But then what if we have that IP re-used on a different SoC where the
devices are at different addresses in the SoC. So that would mean we
would need to list out the devices for every SoC in the comphy
documentation, which is hardly practical.

-- 
RMK's Patch system: https://www.armlinux.org.uk/developer/patches/
FTTP is here! 40Mbps down 10Mbps up. Decent connectivity at last!
