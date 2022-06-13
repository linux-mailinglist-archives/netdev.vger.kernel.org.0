Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id C9986549A2E
	for <lists+netdev@lfdr.de>; Mon, 13 Jun 2022 19:37:36 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S241900AbiFMRhF (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 13 Jun 2022 13:37:05 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:43572 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S241910AbiFMRfD (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 13 Jun 2022 13:35:03 -0400
Received: from pandora.armlinux.org.uk (pandora.armlinux.org.uk [IPv6:2001:4d48:ad52:32c8:5054:ff:fe00:142])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 4347B2707
        for <netdev@vger.kernel.org>; Mon, 13 Jun 2022 05:59:27 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
        d=armlinux.org.uk; s=pandora-2019; h=Sender:Content-Type:MIME-Version:
        Message-ID:Subject:Cc:To:From:Date:Reply-To:Content-Transfer-Encoding:
        Content-ID:Content-Description:Resent-Date:Resent-From:Resent-Sender:
        Resent-To:Resent-Cc:Resent-Message-ID:In-Reply-To:References:List-Id:
        List-Help:List-Unsubscribe:List-Subscribe:List-Post:List-Owner:List-Archive;
        bh=q+MTNmROFy1wzkgEQo+9hGENYx34HaeqWDMHB9jrkUk=; b=xUjaf2pJHsftfCOPqdoRA9GCNu
        mK9DH7aH5YDjEuVEWNxu/3jMKkZKZA5BvNyS28QUzs2RW2JtnIteBMW+uLCvPtRSoCTqJ3O+l/8pY
        F2GBXFlbg+Ei9i71Mq4Bp0Rvs1eDJZ6m+e9tg5h3JFsyTdFFVyiMQNpMhdY7zdKyLPozK4uZc+4KI
        MzuHnctHIfjYe5++mO0ytmGeViYQClq71p5FZT+kTQzlOOiwxiUlkGxVbufjrOtggoVm3vgzfEXpx
        YqeesQIkaOnKmAOG9DPfkXuOcZmZQvukAJuWsjq9i6aKwSmokV4y53ehr87pBTDTs4X1SySu2diB+
        EPrVihGw==;
Received: from shell.armlinux.org.uk ([fd8f:7570:feb6:1:5054:ff:fe00:4ec]:32850)
        by pandora.armlinux.org.uk with esmtpsa  (TLS1.3) tls TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384
        (Exim 4.94.2)
        (envelope-from <linux@armlinux.org.uk>)
        id 1o0jez-0001pu-RN; Mon, 13 Jun 2022 13:59:13 +0100
Received: from linux by shell.armlinux.org.uk with local (Exim 4.94.2)
        (envelope-from <linux@shell.armlinux.org.uk>)
        id 1o0jep-0006Z6-E8; Mon, 13 Jun 2022 13:59:03 +0100
Date:   Mon, 13 Jun 2022 13:59:03 +0100
From:   "Russell King (Oracle)" <linux@armlinux.org.uk>
To:     Andrew Lunn <andrew@lunn.ch>,
        Marek =?iso-8859-1?Q?Beh=FAn?= <kabel@kernel.org>
Cc:     "David S. Miller" <davem@davemloft.net>,
        Eric Dumazet <edumazet@google.com>,
        Florian Fainelli <f.fainelli@gmail.com>,
        Heiner Kallweit <hkallweit1@gmail.com>,
        Jakub Kicinski <kuba@kernel.org>, netdev@vger.kernel.org,
        Paolo Abeni <pabeni@redhat.com>,
        Robert Hancock <robert.hancock@calian.com>,
        Vivien Didelot <vivien.didelot@gmail.com>,
        Vladimir Oltean <olteanv@gmail.com>
Subject: [PATCH net-next 00/15] net: dsa: mv88e6xxx: convert to phylink pcs
Message-ID: <Yqc0lxn3ngWSuvdS@shell.armlinux.org.uk>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Sender: Russell King (Oracle) <linux@armlinux.org.uk>
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,SPF_HELO_NONE,SPF_NONE,
        T_SCC_BODY_TEXT_LINE autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Hi,

This series converts mv88e6xxx to use phylink pcs, which I believe is
the last DSA driver that needs to be converted before we can declare
the whole of DSA as non-phylink legacy.

Briefly:
Patches 1 and 2 introduce a new phylink_pcs_inband() helper to indicate
whether inband AN should be used. Note that the first patch fixes a bug
in the current c22 helper where the SGMII exchange with the PHY would
be disabled when AN is turned off on the PHY copper side.

Patch 3 gets rid of phylink's internal pcs_ops member, preferring
instead to always use the version in the phylink_pcs structure.
Changing this pointer is now no longer supported.

Patch 4 makes PCS polling slightly cleaner, avoiding the poll being
triggered while we're making changes to the configuration.

Patch 5 and 6 introduce several PCS methods that are fundamentally
necessary for mv88e6xxx to work around various issues - for example, in
some devices, the PCS must be powered down when the CMODE field in the
port control register is changed. In other devices, there are
workarounds that need to be performed.

Patch 7 adds unlocked mdiobus and mdiodev accessors to complement the
locking versions that are already there - which are needed for some of
the mv88e6xxx conversions.

Patch 8 prepares DSA as a whole, adding support for the phylink
mac_prepare() and mac_finish() methods. These two methods are used to
force the link down over a major reconfiguration event, which has been
found by people to be necessary on mv88e6xxx devices. These haven't
been required until now as everything has been done via the
mac_config() callback - which won't be true once we switch to
phylink_pcs.

Patch 9 implements patch 8 on this driver.

Patches 10 and 11 prepare mv88e6xxx for the conversion.

Patches 12 through to 14 convert each "serdes" to phylink_pcs.

Patch 15 cleans up after the conversion.

 drivers/net/dsa/mv88e6xxx/Makefile   |    3 +
 drivers/net/dsa/mv88e6xxx/chip.c     |  480 ++++----------
 drivers/net/dsa/mv88e6xxx/chip.h     |   25 +-
 drivers/net/dsa/mv88e6xxx/pcs-6185.c |  158 +++++
 drivers/net/dsa/mv88e6xxx/pcs-6352.c |  383 +++++++++++
 drivers/net/dsa/mv88e6xxx/pcs-639x.c |  834 ++++++++++++++++++++++++
 drivers/net/dsa/mv88e6xxx/port.c     |   30 -
 drivers/net/dsa/mv88e6xxx/serdes.c   | 1164 ++--------------------------------
 drivers/net/dsa/mv88e6xxx/serdes.h   |  110 +---
 drivers/net/phy/mdio_bus.c           |   24 +-
 drivers/net/phy/phylink.c            |  141 ++--
 include/linux/mdio.h                 |   26 +
 include/linux/phylink.h              |   44 ++
 include/net/dsa.h                    |    6 +
 net/dsa/port.c                       |   32 +
 15 files changed, 1826 insertions(+), 1634 deletions(-)

-- 
RMK's Patch system: https://www.armlinux.org.uk/developer/patches/
FTTP is here! 40Mbps down 10Mbps up. Decent connectivity at last!
