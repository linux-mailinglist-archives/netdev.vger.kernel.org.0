Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 90010222187
	for <lists+netdev@lfdr.de>; Thu, 16 Jul 2020 13:34:17 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728030AbgGPLeL (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 16 Jul 2020 07:34:11 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:48790 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726350AbgGPLeK (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 16 Jul 2020 07:34:10 -0400
Received: from pandora.armlinux.org.uk (pandora.armlinux.org.uk [IPv6:2001:4d48:ad52:32c8:5054:ff:fe00:142])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 2D688C061755
        for <netdev@vger.kernel.org>; Thu, 16 Jul 2020 04:34:10 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
        d=armlinux.org.uk; s=pandora-2019; h=Sender:In-Reply-To:Content-Type:
        MIME-Version:References:Message-ID:Subject:Cc:To:From:Date:Reply-To:
        Content-Transfer-Encoding:Content-ID:Content-Description:Resent-Date:
        Resent-From:Resent-Sender:Resent-To:Resent-Cc:Resent-Message-ID:List-Id:
        List-Help:List-Unsubscribe:List-Subscribe:List-Post:List-Owner:List-Archive;
         bh=4gC+5JZbxr+9/x+Relkjytf4FXot8UzGGi8EDDLGMi8=; b=oQhuZqXyeL22pDnQHS43wOQgJ
        RT4/gvHwGMjNh2h2kx1iCPY1n9LkwnPCGn65KECjXnI8nVTeGGrWpFlrhlSrICMRDwSgIdlhf1jCm
        KUknZzEYr30xYxNF4LUK+8xrTwfmfzcn9ous7PhTOSkje1jAeIzM8GHh3fDQn7Ff+Y1rg5OISIZJy
        hnVVY6zGSFP5degPT+UCO4M969uYuafNAdbxqkdVu0SuG8JxWzEvBRR7o995cswSeLWyX0B0pbNuu
        5noTX/BHdEMkfjzUmWq7nbPH1lIFbDS0ZRO/8tuQLRkqcKzTqS0jfrMl6HWZuH5/n3X96vkS3XwjD
        fa51aptew==;
Received: from shell.armlinux.org.uk ([fd8f:7570:feb6:1:5054:ff:fe00:4ec]:40212)
        by pandora.armlinux.org.uk with esmtpsa (TLS1.3:ECDHE_RSA_AES_256_GCM_SHA384:256)
        (Exim 4.92)
        (envelope-from <linux@armlinux.org.uk>)
        id 1jw29G-0007qF-An; Thu, 16 Jul 2020 12:33:58 +0100
Received: from linux by shell.armlinux.org.uk with local (Exim 4.92)
        (envelope-from <linux@shell.armlinux.org.uk>)
        id 1jw29C-0000qr-Sf; Thu, 16 Jul 2020 12:33:54 +0100
Date:   Thu, 16 Jul 2020 12:33:54 +0100
From:   Russell King - ARM Linux admin <linux@armlinux.org.uk>
To:     Andrew Lunn <andrew@lunn.ch>
Cc:     Richard Cochran <richardcochran@gmail.com>,
        Florian Fainelli <f.fainelli@gmail.com>,
        Heiner Kallweit <hkallweit1@gmail.com>,
        "David S. Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>, netdev@vger.kernel.org
Subject: Re: [PATCH RFC net-next] net: phy: add Marvell PHY PTP support
Message-ID: <20200716113354.GS1605@shell.armlinux.org.uk>
References: <E1jvNlE-0001Y0-47@rmk-PC.armlinux.org.uk>
 <20200715183843.GA1256692@lunn.ch>
 <20200715185619.GJ1551@shell.armlinux.org.uk>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20200715185619.GJ1551@shell.armlinux.org.uk>
User-Agent: Mutt/1.10.1 (2018-07-13)
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Wed, Jul 15, 2020 at 07:56:19PM +0100, Russell King - ARM Linux admin wrote:
> On Wed, Jul 15, 2020 at 08:38:43PM +0200, Andrew Lunn wrote:
> > > Getting the Kconfig for this correct has been a struggle - particularly
> > > the combination where PTP support is modular.  It's rather odd to have
> > > the Marvell PTP support asked before the Marvell PHY support.  I
> > > couldn't work out any other reasonable way to ensure that we always
> > > have a valid configuration, without leading to stupidities such as
> > > having the PTP and Marvell PTP support modular, but non-functional
> > > because Marvell PHY is built-in.
> > 
> > Hi Russell
> > 
> > How much object code is this adding? All the other PHYs which support
> > PTP just make it part of the PHY driver, not a standalone module. That
> > i guess simplifies the conditions. 
> 
> Taking an arm64 build, the PHY driver is 16k and the PTP driver comes
> in just under 8k.
> 
> > Looking at DSDT, it lists
> > 
> >         case MAD_88E1340S:
> >         case MAD_88E1340:
> >         case MAD_88E1340M:
> >         case MAD_SWG65G : 
> > 	case MAD_88E151x:
> > 
> > as being MAD_PHY_PTP_TAI_CAPABLE;
> > 
> > and
> > 
> > 	case MAD_88E1548
> >         case MAD_88E1680:
> >         case MAD_88E1680M:
> > 
> > as MAD_PHY_1STEP_PTP_CAPABLE;
> > 
> > So maybe we can wire this up to a few more PHYs to 'lower' the
> > overhead a bit?
> 
> That's interesting, the 1548 information (covering 1543 and 1545 as
> well) I have doesn't mention anything about PTP.
> 
> > > It seems that the Marvell PHY PTP is very similar to that found in
> > > their DSA chips, which suggests maybe we should share the code, but
> > > different access methods would be required.
> > 
> > That makes the Kconfig even more complex :-(
> 
> We already have that complexity due to the fact that we are interacting
> with two subsystems.  The 88e6xxx Kconfig entry has:
> 
> config NET_DSA_MV88E6XXX_PTP
>         bool "PTP support for Marvell 88E6xxx"
>         default n
>         depends on NET_DSA_MV88E6XXX_GLOBAL2
>         depends on PTP_1588_CLOCK
>         imply NETWORK_PHY_TIMESTAMPING
> 
> and I've been wondering what that means when PTP_1588_CLOCK=m while
> NET_DSA_MV88E6XXX_GLOBAL2=y and NET_DSA_MV88E6XXX=y.  If this is
> selectable, then it seems to be misleading the user - you can't have
> the PTP subsystem modular, and have PTP drivers built-in to the
> kernel.
> 
> Yes, we have the inteligence to be able to make the various PTP calls
> be basically no-ops, but it's not nice.

Sure enough:

CONFIG_NET_DSA_MV88E6XXX=y
CONFIG_NET_DSA_MV88E6XXX_GLOBAL2=y
CONFIG_NET_DSA_MV88E6XXX_PTP=y
CONFIG_PTP_1588_CLOCK=m

is a possible configuration, but all the PTP calls from mv88e6xxx are
stubbed out (since the IS_REACHABLE() in linux/ptp_clock_kernel.h is
false.)

The DP83640 PHY works around this by introducing a hard dependency on
PTP:

config DP83640_PHY
	tristate "Driver for the National Semiconductor DP83640 PHYTER"
	depends on NETWORK_PHY_TIMESTAMPING
	depends on PHYLIB
	depends on PTP_1588_CLOCK

A possible solution to this would be for the PTP core code to be a
separate Kconfig symbol that is not offered to the user, but is
selected by the various drivers and Kconfig entries that need that
support.  That way, it would automatically be modular or built-in
as required by its users.

PTP_1588_CLOCK could then be used as a global enable for PTP support
where appropriate.  We can also avoid all the Kconfig complexity
introduced by having two independent subsystems either of which could
be modular.

-- 
RMK's Patch system: https://www.armlinux.org.uk/developer/patches/
FTTP is here! 40Mbps down 10Mbps up. Decent connectivity at last!
