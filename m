Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id DAA0F46AAF2
	for <lists+netdev@lfdr.de>; Mon,  6 Dec 2021 22:49:41 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1355412AbhLFVxJ (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 6 Dec 2021 16:53:09 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:39598 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1354733AbhLFVxJ (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 6 Dec 2021 16:53:09 -0500
Received: from pandora.armlinux.org.uk (pandora.armlinux.org.uk [IPv6:2001:4d48:ad52:32c8:5054:ff:fe00:142])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 1F7D2C061746
        for <netdev@vger.kernel.org>; Mon,  6 Dec 2021 13:49:40 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
        d=armlinux.org.uk; s=pandora-2019; h=Sender:In-Reply-To:Content-Type:
        MIME-Version:References:Message-ID:Subject:Cc:To:From:Date:Reply-To:
        Content-Transfer-Encoding:Content-ID:Content-Description:Resent-Date:
        Resent-From:Resent-Sender:Resent-To:Resent-Cc:Resent-Message-ID:List-Id:
        List-Help:List-Unsubscribe:List-Subscribe:List-Post:List-Owner:List-Archive;
        bh=OE0/qu31m9JTTvdFBJ41lC4pqG2lsk9VaOD3Nq4uhCg=; b=bXEaL2/8n+zPZyiTigmTd0QluE
        cb36uP4s4Ys+2iJ6Glma6vyWmZGQnzJDbOAcg+ry0Bsfh7yg3Nz/L/vh/J3FcdOdPI/oDb/4vTNyp
        w+Ulzwa286QgMhdrgIYX4QPIjStx1DIc5+C9nbd2p8bJT6CWsHY5HJU0CSCmIhcYbMlHKP5h2CC8n
        wSjH4m/100BtzPMlxvmgKuvd5IzRmhbtQj3c8Wo4o/7W1uEImwpquNfP2S+tkP2oXZ3srgQwWmT57
        ppstyn46eWaRPUIUgy4+J7NsbBguu4umtyXP5MmnR07ufp1DliJvAlSNOZ8QJclPjkgN7YhmLETca
        J5wG5ZAg==;
Received: from shell.armlinux.org.uk ([fd8f:7570:feb6:1:5054:ff:fe00:4ec]:56120)
        by pandora.armlinux.org.uk with esmtpsa  (TLS1.3) tls TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384
        (Exim 4.94.2)
        (envelope-from <linux@armlinux.org.uk>)
        id 1muLrd-0005PQ-LD; Mon, 06 Dec 2021 21:49:37 +0000
Received: from linux by shell.armlinux.org.uk with local (Exim 4.94.2)
        (envelope-from <linux@shell.armlinux.org.uk>)
        id 1muLrd-0004gh-7o; Mon, 06 Dec 2021 21:49:37 +0000
Date:   Mon, 6 Dec 2021 21:49:37 +0000
From:   "Russell King (Oracle)" <linux@armlinux.org.uk>
To:     Vladimir Oltean <olteanv@gmail.com>
Cc:     Martyn Welch <martyn.welch@collabora.com>,
        Andrew Lunn <andrew@lunn.ch>,
        Vivien Didelot <vivien.didelot@gmail.com>,
        Florian Fainelli <f.fainelli@gmail.com>,
        netdev@vger.kernel.org, kernel@collabora.com
Subject: Re: mv88e6240 configuration broken for B850v3
Message-ID: <Ya6FcTIbyO+zXj7V@shell.armlinux.org.uk>
References: <20211206183147.km7nxcsadtdenfnp@skbuf>
 <339f76b66c063d5d3bed5c6827c44307da2e5b9f.camel@collabora.com>
 <20211206185008.7ei67jborz7tx5va@skbuf>
 <3d6c6226e47374cf92d604bc6c711e59d76e3175.camel@collabora.com>
 <20211206193730.oubyveywniyvptfk@skbuf>
 <Ya5tkXU3AXalFRg2@shell.armlinux.org.uk>
 <20211206202308.xoutfymjozfyhhkl@skbuf>
 <Ya53vXp7Wz5YPf7Y@shell.armlinux.org.uk>
 <20211206211341.ppllxa7ve2jdyzt4@skbuf>
 <Ya6ARQBGl2C4Z3il@shell.armlinux.org.uk>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <Ya6ARQBGl2C4Z3il@shell.armlinux.org.uk>
Sender: Russell King (Oracle) <linux@armlinux.org.uk>
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Mon, Dec 06, 2021 at 09:27:33PM +0000, Russell King (Oracle) wrote:
> We used to just rely on the PPU bit for making the decision, but when
> I introduced that helper, I forgot that the PPU bit doesn't exist on
> the 6250 family, which resulted in commit 4a3e0aeddf09. Looking at
> 4a3e0aeddf09, I now believe the fix there to be wrong. It should
> have made mv88e6xxx_port_ppu_updates() follow
> mv88e6xxx_phy_is_internal() for internal ports only for the 6250 family
> that has the link status bit in that position, especially as one can
> disable the PPU bit in DSA switches such as 6390, which for some ports
> stops the PHY being used and switches the port to serdes mode.
> "Internal" ports aren't always internal on these switches.

Here's the situation I'm concerned about. The 88E6390X has two serdes
each with four lanes. Let's just think about one serdes. Lane 0 is
assigned to port 9 and lane 1 to port 4. We don't need to consider
any others.

If the PHY_DETECT bit (effectively PPU poll enable) is set for port 4,
which is an "internal" port, then the port is in auto-media mode, and
the PPU will poll the internal PHY and the serdes, and configure
according to which has link.

If the PPU bit is clear, then the port is forced to serdes mode.
However, in this configuration, we end up with:

	mv88e6xxx_phy_is_internal(ds, port) = true
	mv88e6xxx_port_ppu_updates(chip, port) = false

which results in:

        if ((!mv88e6xxx_phy_is_internal(ds, port) &&
             !mv88e6xxx_port_ppu_updates(chip, port)) ||
            mode == MLO_AN_FIXED) {

being false since we have (!true && !false) || false. So, in actual
fact, when we have a PHY_DETECT bit, we _do_ need to take note of it
whether the port is "internal" or not. Essentially, that means that
for DSA switches that are not part of the 6250, we should be using
the PHY_DETECT bit.

For the 6250 family, the problem is that there's no PHY_DETECT bit,
and that's the link status. So I've started a separate discussion
with Maarten to find out which Marvell switch is being used and
whether an alterative approach would work for him.

-- 
RMK's Patch system: https://www.armlinux.org.uk/developer/patches/
FTTP is here! 40Mbps down 10Mbps up. Decent connectivity at last!
