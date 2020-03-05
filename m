Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 352C917A57A
	for <lists+netdev@lfdr.de>; Thu,  5 Mar 2020 13:44:06 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726674AbgCEMmz (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 5 Mar 2020 07:42:55 -0500
Received: from pandora.armlinux.org.uk ([78.32.30.218]:40000 "EHLO
        pandora.armlinux.org.uk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1725993AbgCEMmy (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 5 Mar 2020 07:42:54 -0500
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
        d=armlinux.org.uk; s=pandora-2019; h=Date:Sender:Message-Id:Content-Type:
        Content-Transfer-Encoding:MIME-Version:Subject:Cc:To:From:References:
        In-Reply-To:Reply-To:Content-ID:Content-Description:Resent-Date:Resent-From:
        Resent-Sender:Resent-To:Resent-Cc:Resent-Message-ID:List-Id:List-Help:
        List-Unsubscribe:List-Subscribe:List-Post:List-Owner:List-Archive;
        bh=ufOxf3MwJMOSG/hTPq9978ut/ioVqhnx9bPmefE5Nx4=; b=g7N97tBxAXQhTytbEVoUr62ky0
        ni4CARhBlZFwAKv7QwFqf8+gX8GLzPMwbng026gbUJ5K2aaOB+ssdq33QZjZvfF+y7xj2bNyYKqcU
        6gjqTlVRD7TYBRjU9uO2yq7o8hURKQ4ZysNqpAJ6FDtnTQEsSqfoHErP/M9ho31wbntdrQ7l0EtAr
        fZRqwZNTJ4/vOQ1202RHOZr0/Sd+60en9L0nfsbnb2JQcG28vm6D1Nas5CjMAIp/6mw146VCcOSzU
        DY6fGc2F3Bio/UvPqTahH59Yh2VX2PxYDqvKfMSUXOK8tPGC3eO4TbfbaecPetAvNsEWhITg+AfI9
        1BHD+hNA==;
Received: from e0022681537dd.dyn.armlinux.org.uk ([fd8f:7570:feb6:1:222:68ff:fe15:37dd]:58762 helo=rmk-PC.armlinux.org.uk)
        by pandora.armlinux.org.uk with esmtpsa (TLSv1.2:ECDHE-RSA-AES256-GCM-SHA384:256)
        (Exim 4.90_1)
        (envelope-from <rmk@armlinux.org.uk>)
        id 1j9ppn-0006Rd-6b; Thu, 05 Mar 2020 12:42:39 +0000
Received: from rmk by rmk-PC.armlinux.org.uk with local (Exim 4.92)
        (envelope-from <rmk@armlinux.org.uk>)
        id 1j9ppk-00072U-PD; Thu, 05 Mar 2020 12:42:36 +0000
In-Reply-To: <20200305124139.GB25745@shell.armlinux.org.uk>
References: <20200305124139.GB25745@shell.armlinux.org.uk>
From:   Russell King <rmk+kernel@armlinux.org.uk>
To:     Andrew Lunn <andrew@lunn.ch>,
        Florian Fainelli <f.fainelli@gmail.com>,
        Heiner Kallweit <hkallweit1@gmail.com>
Cc:     "David S. Miller" <davem@davemloft.net>, netdev@vger.kernel.org,
        Vivien Didelot <vivien.didelot@gmail.com>
Subject: [PATCH net-next 07/10] net: dsa: mv88e6xxx: fix Serdes link changes
MIME-Version: 1.0
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
Content-Type: text/plain; charset="utf-8"
Message-Id: <E1j9ppk-00072U-PD@rmk-PC.armlinux.org.uk>
Date:   Thu, 05 Mar 2020 12:42:36 +0000
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

phylink_mac_change() is supposed to be called with a 'false' argument
if the link has gone down since it was last reported up; this is to
ensure that link events along with renegotiation events are always
correctly reported to userspace.

Read the BMSR once when we have an interrupt, and report the link
latched status to phylink via phylink_mac_change().  phylink will deal
automatically with re-reading the link state once it has processed the
link-down event.

Signed-off-by: Russell King <rmk+kernel@armlinux.org.uk>
---
 drivers/net/dsa/mv88e6xxx/serdes.c | 33 +++++++++++-------------------
 drivers/net/dsa/mv88e6xxx/serdes.h |  1 +
 2 files changed, 13 insertions(+), 21 deletions(-)

diff --git a/drivers/net/dsa/mv88e6xxx/serdes.c b/drivers/net/dsa/mv88e6xxx/serdes.c
index 6c7b031e614b..2098f19b534d 100644
--- a/drivers/net/dsa/mv88e6xxx/serdes.c
+++ b/drivers/net/dsa/mv88e6xxx/serdes.c
@@ -340,26 +340,17 @@ int mv88e6352_serdes_get_stats(struct mv88e6xxx_chip *chip, int port,
 
 static void mv88e6352_serdes_irq_link(struct mv88e6xxx_chip *chip, int port)
 {
-	struct dsa_switch *ds = chip->ds;
-	u16 status;
-	bool up;
+	u16 bmsr;
 	int err;
 
-	err = mv88e6352_serdes_read(chip, MII_BMSR, &status);
-	if (err)
-		return;
-
-	/* Status must be read twice in order to give the current link
-	 * status. Otherwise the change in link status since the last
-	 * read of the register is returned.
-	 */
-	err = mv88e6352_serdes_read(chip, MII_BMSR, &status);
-	if (err)
+	/* If the link has dropped, we want to know about it. */
+	err = mv88e6352_serdes_read(chip, MII_BMSR, &bmsr);
+	if (err) {
+		dev_err(chip->dev, "can't read Serdes BMSR: %d\n", err);
 		return;
+	}
 
-	up = status & BMSR_LSTATUS;
-
-	dsa_port_phylink_mac_change(ds, port, up);
+	dsa_port_phylink_mac_change(chip->ds, port, !!(bmsr & BMSR_LSTATUS));
 }
 
 irqreturn_t mv88e6352_serdes_irq_status(struct mv88e6xxx_chip *chip, int port,
@@ -833,18 +824,18 @@ int mv88e6390_serdes_pcs_link_up(struct mv88e6xxx_chip *chip, int port,
 static void mv88e6390_serdes_irq_link_sgmii(struct mv88e6xxx_chip *chip,
 					    int port, u8 lane)
 {
-	u16 status;
+	u16 bmsr;
 	int err;
 
+	/* If the link has dropped, we want to know about it. */
 	err = mv88e6390_serdes_read(chip, lane, MDIO_MMD_PHYXS,
-				    MV88E6390_SGMII_PHY_STATUS, &status);
+				    MV88E6390_SGMII_BMSR, &bmsr);
 	if (err) {
-		dev_err(chip->dev, "can't read SGMII PHY status: %d\n", err);
+		dev_err(chip->dev, "can't read Serdes BMSR: %d\n", err);
 		return;
 	}
 
-	dsa_port_phylink_mac_change(chip->ds, port,
-				!!(status & MV88E6390_SGMII_PHY_STATUS_LINK));
+	dsa_port_phylink_mac_change(chip->ds, port, !!(bmsr & BMSR_LSTATUS));
 }
 
 static int mv88e6390_serdes_irq_enable_sgmii(struct mv88e6xxx_chip *chip,
diff --git a/drivers/net/dsa/mv88e6xxx/serdes.h b/drivers/net/dsa/mv88e6xxx/serdes.h
index a0c95322987d..7990cadba4c2 100644
--- a/drivers/net/dsa/mv88e6xxx/serdes.h
+++ b/drivers/net/dsa/mv88e6xxx/serdes.h
@@ -48,6 +48,7 @@
 
 /* 1000BASE-X and SGMII */
 #define MV88E6390_SGMII_BMCR		(0x2000 + MII_BMCR)
+#define MV88E6390_SGMII_BMSR		(0x2000 + MII_BMSR)
 #define MV88E6390_SGMII_ADVERTISE	(0x2000 + MII_ADVERTISE)
 #define MV88E6390_SGMII_LPA		(0x2000 + MII_LPA)
 #define MV88E6390_SGMII_INT_ENABLE	0xa001
-- 
2.20.1

