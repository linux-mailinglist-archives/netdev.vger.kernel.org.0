Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 1A769242C66
	for <lists+netdev@lfdr.de>; Wed, 12 Aug 2020 17:54:47 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726533AbgHLPyp (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 12 Aug 2020 11:54:45 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:59668 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726447AbgHLPyo (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 12 Aug 2020 11:54:44 -0400
Received: from pandora.armlinux.org.uk (pandora.armlinux.org.uk [IPv6:2001:4d48:ad52:32c8:5054:ff:fe00:142])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id E1341C061383
        for <netdev@vger.kernel.org>; Wed, 12 Aug 2020 08:54:43 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
        d=armlinux.org.uk; s=pandora-2019; h=Sender:In-Reply-To:Content-Type:
        MIME-Version:References:Message-ID:Subject:Cc:To:From:Date:Reply-To:
        Content-Transfer-Encoding:Content-ID:Content-Description:Resent-Date:
        Resent-From:Resent-Sender:Resent-To:Resent-Cc:Resent-Message-ID:List-Id:
        List-Help:List-Unsubscribe:List-Subscribe:List-Post:List-Owner:List-Archive;
         bh=HSnflPq1ek/tN7VeyZ4HogMiuXcaZ5099FbnYHB7wg0=; b=Vl5zimVAkuEte4Xft/QcuWfcI
        uT115N9B+bLyw5WPvdgh6wKBzKkYr8bc4VnRTZzUrBuz0PIgIc9AZS6RzQ7KETE4qGNrtA7lOpE13
        BaRlTlnjiKCyIm70iSVpILPMLmJdAZeGqzcw51duOcHUaAP51T6IGf+XzGUXKDgxrFLC6rFV3XZ/2
        Nhx7XqZwaoaY0kiyIZr0Z0i/gLdCJ53xJdqlwNS1ssceL7IMdzBktxCO1r0bsRL7u0AN91twMV3/C
        joPtkJ9gRAME5UTdsUOcEGHrVL3RKIkyW/q2Z81PKeDCSm3iibF96X06zyinKYntPB13+PAoXqMGT
        cJEDjXmbw==;
Received: from shell.armlinux.org.uk ([fd8f:7570:feb6:1:5054:ff:fe00:4ec]:51612)
        by pandora.armlinux.org.uk with esmtpsa (TLS1.3:ECDHE_RSA_AES_256_GCM_SHA384:256)
        (Exim 4.92)
        (envelope-from <linux@armlinux.org.uk>)
        id 1k5t5N-0002r3-LR; Wed, 12 Aug 2020 16:54:41 +0100
Received: from linux by shell.armlinux.org.uk with local (Exim 4.92)
        (envelope-from <linux@shell.armlinux.org.uk>)
        id 1k5t5N-0003vw-90; Wed, 12 Aug 2020 16:54:41 +0100
Date:   Wed, 12 Aug 2020 16:54:41 +0100
From:   Russell King - ARM Linux admin <linux@armlinux.org.uk>
To:     Andrew Lunn <andrew@lunn.ch>
Cc:     Marek =?iso-8859-1?Q?Beh=FAn?= <marek.behun@nic.cz>,
        Maxime Chevallier <maxime.chevallier@bootlin.com>,
        Baruch Siach <baruch@tkos.co.il>,
        Chris Healy <cphealy@gmail.com>,
        Florian Fainelli <f.fainelli@gmail.com>, netdev@vger.kernel.org
Subject: Re: [PATCH RFC russell-king 3/4] net: phy: marvell10g: change
 MACTYPE according to phydev->interface
Message-ID: <20200812155441.GR1551@shell.armlinux.org.uk>
References: <20200810220645.19326-1-marek.behun@nic.cz>
 <20200810220645.19326-4-marek.behun@nic.cz>
 <20200811152144.GN1551@shell.armlinux.org.uk>
 <20200812164431.34cf569f@dellmb.labs.office.nic.cz>
 <20200812150054.GP1551@shell.armlinux.org.uk>
 <20200812154436.GH2141651@lunn.ch>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20200812154436.GH2141651@lunn.ch>
User-Agent: Mutt/1.10.1 (2018-07-13)
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Wed, Aug 12, 2020 at 05:44:36PM +0200, Andrew Lunn wrote:
> > I'm aware of that problem.  I have some experimental patches which add
> > PHY interface mode bitmaps to the MAC, PHY, and SFP module parsing
> > functions.  I have stumbled on some problems though - it's going to be
> > another API change (and people are already whinging about the phylink
> > API changing "too quickly", were too quickly seems to be defined as
> > once in three years), and in some cases, DSA, it's extremely hard to
> > work out how to properly set such a bitmap due to DSA's layered
> > approach.
> 
> Hi Russell
> 
> If DSAs layering is causing real problems, we could rip it out, and
> let the driver directly interact with phylink. I'm not opposed to
> that.

The reason I mentioned it is because I have this unpublished patch
(beware, whitespace damaged due to copy-n-pasted):

diff --git a/net/dsa/slave.c b/net/dsa/slave.c
index c1967e08b017..ba32492f3ec0 100644
--- a/net/dsa/slave.c
+++ b/net/dsa/slave.c
@@ -1629,6 +1629,12 @@ static int dsa_slave_phy_setup(struct net_device *slave_dev)

        dp->pl_config.dev = &slave_dev->dev;
        dp->pl_config.type = PHYLINK_NETDEV;
+       __set_bit(PHY_INTERFACE_MODE_SGMII,
+                 dp->pl_config.supported_interfaces);
+       __set_bit(PHY_INTERFACE_MODE_2500BASEX,
+                 dp->pl_config.supported_interfaces);
+       __set_bit(PHY_INTERFACE_MODE_1000BASEX,
+                 dp->pl_config.supported_interfaces);

        /* The get_fixed_state callback takes precedence over polling the
         * link GPIO in PHYLINK (see phylink_get_fixed_state).  Only set

Which clearly is a gross hack - this code certainly has no idea about
what interfaces the port itself supports.  How do we get around that
with DSA layering?

We could add yet-another-driver-call down into the DSA driver for it
to fill in that information and keep the current structure.  However,
is that really the best solution - to have lots of fine grained driver
calls?

DSA feels to be very cumbersome and awkward to modify at least to me.
Almost everything seems to be "add another driver call" at the DSA
layer, followed by "add another sub-driver call" at the mv88e6xxx
layer.

-- 
RMK's Patch system: https://www.armlinux.org.uk/developer/patches/
FTTP is here! 40Mbps down 10Mbps up. Decent connectivity at last!
