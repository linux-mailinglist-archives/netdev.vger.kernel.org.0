Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 4F6EF2CBC3
	for <lists+netdev@lfdr.de>; Tue, 28 May 2019 18:24:07 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726515AbfE1QYF (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 28 May 2019 12:24:05 -0400
Received: from pandora.armlinux.org.uk ([78.32.30.218]:40874 "EHLO
        pandora.armlinux.org.uk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726243AbfE1QYF (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 28 May 2019 12:24:05 -0400
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
        d=armlinux.org.uk; s=pandora-2019; h=Sender:In-Reply-To:Content-Type:
        MIME-Version:References:Message-ID:Subject:Cc:To:From:Date:Reply-To:
        Content-Transfer-Encoding:Content-ID:Content-Description:Resent-Date:
        Resent-From:Resent-Sender:Resent-To:Resent-Cc:Resent-Message-ID:List-Id:
        List-Help:List-Unsubscribe:List-Subscribe:List-Post:List-Owner:List-Archive;
         bh=j+NLxTpkLdOok7PHeXKxtJtOVRAPgihczjvzNazPu2w=; b=WRllWTBzxIMBW+rhV+eF6bSRk
        j+kUfKV6qcrodHnbJz2RPO3hQ+BtE44rxLQ+rewMut3mCaIs2ppgDHk2cUD2khdXIVFcy+T5WH8Nd
        FxYqFdcJwPosINoqTo4VhN8GNr0wIpFOI9Q2h1PmPdPCwdjOWGri6gEZ1A+s9sudJMjpGNpR6x3Gb
        KiEA11hoFdy9MjcutMDvlbXxGzBelvR0jgAzTrfNCzppctsv8vPmSvBuk+0rhooDrwoeRdeNvVwec
        NlKQ3rcL5kHZ/zxpG/LvWfrVzlKfcNR00DACLEpsROnijEOAP7u7uBbu2icMaL5R7HXU27GTttxes
        hPdRk1thQ==;
Received: from shell.armlinux.org.uk ([2002:4e20:1eda:1:5054:ff:fe00:4ec]:38344)
        by pandora.armlinux.org.uk with esmtpsa (TLSv1.2:ECDHE-RSA-AES256-GCM-SHA384:256)
        (Exim 4.90_1)
        (envelope-from <linux@armlinux.org.uk>)
        id 1hVetK-0006xu-Qv; Tue, 28 May 2019 17:23:58 +0100
Received: from linux by shell.armlinux.org.uk with local (Exim 4.89)
        (envelope-from <linux@shell.armlinux.org.uk>)
        id 1hVetI-0003le-Eo; Tue, 28 May 2019 17:23:56 +0100
Date:   Tue, 28 May 2019 17:23:56 +0100
From:   Russell King - ARM Linux admin <linux@armlinux.org.uk>
To:     Andrew Lunn <andrew@lunn.ch>
Cc:     Florian Fainelli <f.fainelli@gmail.com>,
        Heiner Kallweit <hkallweit1@gmail.com>,
        Maxime Chevallier <maxime.chevallier@bootlin.com>,
        "David S. Miller" <davem@davemloft.net>, netdev@vger.kernel.org
Subject: Re: [PATCH] net: phy: marvell10g: report if the PHY fails to boot
 firmware
Message-ID: <20190528162356.xjq53h4z7edvr3gl@shell.armlinux.org.uk>
References: <E1hVYVG-0005D8-8w@rmk-PC.armlinux.org.uk>
 <20190528154238.ifudfslyofk22xoe@shell.armlinux.org.uk>
 <20190528161139.GQ18059@lunn.ch>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20190528161139.GQ18059@lunn.ch>
User-Agent: NeoMutt/20170113 (1.7.2)
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Tue, May 28, 2019 at 06:11:39PM +0200, Andrew Lunn wrote:
> > One question: are we happy with failing the probe like this, or would it
> > be better to allow the probe to suceed?
> > 
> > As has been pointed out in the C45 MII access patch, we need the PHY
> > to bind to the network driver for the MII bus to be accessible to
> > userspace, so if we're going to have userspace tools to upload the
> > firmware, rather than using u-boot, we need the PHY to be present and
> > bound to the network interface.
> 
> Hi Russell
> 
> It is an interesting question. Failing the probe is the simple
> solution. If we don't fail the probe, we then need to allow the
> attach, but fail all normal operations, with a noisy kernel log.  That
> probably means adding a new state to the state machine, PHY_BROKEN.
> Enter that state if phy_start_aneg() returns an error?

Hi Andrew,

I don't think we need a new state - I think we can trap it in
the link_change_notify() method, and force phydev->state to
PHY_HALTED if it's in phy_is_started() mode.

Maybe something like:

	if (phy_is_started(phydev) && priv->firmware_failed) {
		dev_warn(&phydev->mdio.dev,
			 "PHY firmware failure: link forced down");
		phydev->state = PHY_HALTED;
	}

Or maybe we just need to do that if phydev->state == PHY_UP or
PHY_RESUMING (the two states entered from phy_start())?

Russell.

-- 
RMK's Patch system: https://www.armlinux.org.uk/developer/patches/
FTTC broadband for 0.8mile line in suburbia: sync at 12.1Mbps down 622kbps up
According to speedtest.net: 11.9Mbps down 500kbps up
