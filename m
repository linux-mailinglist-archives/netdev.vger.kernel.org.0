Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 27E5C1856AC
	for <lists+netdev@lfdr.de>; Sun, 15 Mar 2020 02:28:58 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726613AbgCOB2z (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sat, 14 Mar 2020 21:28:55 -0400
Received: from pandora.armlinux.org.uk ([78.32.30.218]:55780 "EHLO
        pandora.armlinux.org.uk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1725962AbgCOB2y (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sat, 14 Mar 2020 21:28:54 -0400
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
        d=armlinux.org.uk; s=pandora-2019; h=Sender:In-Reply-To:Content-Type:
        MIME-Version:References:Message-ID:Subject:Cc:To:From:Date:Reply-To:
        Content-Transfer-Encoding:Content-ID:Content-Description:Resent-Date:
        Resent-From:Resent-Sender:Resent-To:Resent-Cc:Resent-Message-ID:List-Id:
        List-Help:List-Unsubscribe:List-Subscribe:List-Post:List-Owner:List-Archive;
         bh=UGBufWbYvrmkwZrPGgicPt6Hy6K6TsTr3dcMbTR9N1Y=; b=FXFMF5BWRzoxEKYID3vwmM/+u
        z0MFDVitEn8IGEyfQO2bZUomhrQamO14ftoWV/LwXO8n8qpYOV6dSyWdDi2wHrAGlV+ezW42mWJR6
        VkHAvGymy6XLyZDhFXeTM+c/7hSxE70PXzMJ4RZkJZqWkrmLo3uwk+wEOv2T61pxGVlfIe/dxkknD
        E5E3bOLJ2OHbQQucHfKgrNWY6x7RX88MPinxdxukPZvoCjYHm69TRBQYgYsstBn4RI+sWCzk/qfXk
        0IZSFDdC7yZpnVC1G+R/ai6A9jkdD7MGVgyRc3yOdpz+EIuTSR1QSQvFKt5dUa48Pu+TpsUnaN6sr
        aX63hzbFw==;
Received: from shell.armlinux.org.uk ([2001:4d48:ad52:3201:5054:ff:fe00:4ec]:53084)
        by pandora.armlinux.org.uk with esmtpsa (TLSv1.2:ECDHE-RSA-AES256-GCM-SHA384:256)
        (Exim 4.90_1)
        (envelope-from <linux@armlinux.org.uk>)
        id 1jDFWg-0006qM-FO; Sat, 14 Mar 2020 22:45:02 +0000
Received: from linux by shell.armlinux.org.uk with local (Exim 4.92)
        (envelope-from <linux@shell.armlinux.org.uk>)
        id 1jDFWd-0000Ew-AQ; Sat, 14 Mar 2020 22:44:59 +0000
Date:   Sat, 14 Mar 2020 22:44:59 +0000
From:   Russell King - ARM Linux admin <linux@armlinux.org.uk>
To:     Andrew Lunn <andrew@lunn.ch>
Cc:     Florian Fainelli <f.fainelli@gmail.com>,
        Heiner Kallweit <hkallweit1@gmail.com>,
        "David S. Miller" <davem@davemloft.net>, netdev@vger.kernel.org
Subject: Re: [PATCH REPOST3 net-next 0/3] net: add phylink support for PCS
Message-ID: <20200314224459.GL25745@shell.armlinux.org.uk>
References: <20200314103102.GJ25745@shell.armlinux.org.uk>
 <20200314220018.GH8622@lunn.ch>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20200314220018.GH8622@lunn.ch>
User-Agent: Mutt/1.10.1 (2018-07-13)
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Sat, Mar 14, 2020 at 11:00:18PM +0100, Andrew Lunn wrote:
> On Sat, Mar 14, 2020 at 10:31:02AM +0000, Russell King - ARM Linux admin wrote:
> > Depends on "net: mii clause 37 helpers".
> > 
> > This series adds support for IEEE 802.3 register set compliant PCS
> > for phylink.  In order to do this, we:
> > 
> > 1. add accessors for modifying a MDIO device register, and use them in
> >    phylib, rather than duplicating the code from phylib.
> > 2. add support for decoding the advertisement from clause 22 compatible
> >    register sets for clause 37 advertisements and SGMII advertisements.
> > 3. add support for clause 45 register sets for 10GBASE-R PCS.
> 
> Hi Russell
> 
> How big is the patchset which actually makes use of this code? It is
> normal to add helpers and at least one user in the same patchset. But
> if that would make the patchset too big, there could be some leeway.

The minimum is three patches:

arm64: dts: lx2160a: add PCS MDIO nodes
dpaa2-mac: add 1000BASE-X/SGMII PCS support
dpaa2-mac: add 10GBASE-R PCS support

but for it to actually be usable on hardware, it needs more than that:

arm64: dts: lx2160a-clearfog-itx: add SFP support

and, at the moment, depending on whether you want 1G or 10G speeds,
changes to the board firmware to select the serdes group mode.

The DTS patches can't go through netdev obviously, and it may be
too late to get them queued through the proper channels.

-- 
RMK's Patch system: https://www.armlinux.org.uk/developer/patches/
FTTC broadband for 0.8mile line in suburbia: sync at 10.2Mbps down 587kbps up
