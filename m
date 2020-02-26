Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 4373516FC0B
	for <lists+netdev@lfdr.de>; Wed, 26 Feb 2020 11:25:34 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727451AbgBZKZc (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 26 Feb 2020 05:25:32 -0500
Received: from pandora.armlinux.org.uk ([78.32.30.218]:45678 "EHLO
        pandora.armlinux.org.uk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726057AbgBZKZc (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 26 Feb 2020 05:25:32 -0500
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
        d=armlinux.org.uk; s=pandora-2019; h=Date:Sender:Message-Id:Content-Type:
        Content-Transfer-Encoding:MIME-Version:Subject:Cc:To:From:References:
        In-Reply-To:Reply-To:Content-ID:Content-Description:Resent-Date:Resent-From:
        Resent-Sender:Resent-To:Resent-Cc:Resent-Message-ID:List-Id:List-Help:
        List-Unsubscribe:List-Subscribe:List-Post:List-Owner:List-Archive;
        bh=fa4NZv5nNOs4Sh5tsn/w+0iIu7F1BQDsZ/B6zmpXUBw=; b=uC337MwnLANJpvKn7wCRJ9VEE0
        xrwwAA5FO8AG++rjE3Jn9E9NKWycVambU33HxPTu7WqP1Zou6wzw7hek0G1EKMzaTWq48gEiQtsow
        XH2M8YyTt1rwoKeASNMyikherHe89pzl9hKguOwhuGM2RbrYUZu2kBITchtUlJAy2wIbNuJDOwsmk
        Y60ypdmOcRWX8/9XS7VSBfvTCKjUwRJdfiLHwu7ALycfgWt/gR3X/jcMk3wE5i/0CUDuzG8qbrx5Q
        tsFDTFzIv0P0GIFBiiFP4aynm1cwcEVsCN4NORdjmUqkhT+MpXwgfTQTEooIQBrUbTtXAyZ0XGF0G
        26qd3bNg==;
Received: from e0022681537dd.dyn.armlinux.org.uk ([2001:4d48:ad52:3201:222:68ff:fe15:37dd]:53868 helo=rmk-PC.armlinux.org.uk)
        by pandora.armlinux.org.uk with esmtpsa (TLSv1.2:ECDHE-RSA-AES256-GCM-SHA384:256)
        (Exim 4.90_1)
        (envelope-from <rmk@armlinux.org.uk>)
        id 1j6tr9-0006ru-LO; Wed, 26 Feb 2020 10:23:56 +0000
Received: from rmk by rmk-PC.armlinux.org.uk with local (Exim 4.92)
        (envelope-from <rmk@armlinux.org.uk>)
        id 1j6tr5-0003GN-JK; Wed, 26 Feb 2020 10:23:51 +0000
In-Reply-To: <20200226102312.GX25745@shell.armlinux.org.uk>
References: <20200226102312.GX25745@shell.armlinux.org.uk>
From:   Russell King <rmk+kernel@armlinux.org.uk>
To:     Andrew Lunn <andrew@lunn.ch>,
        Florian Fainelli <f.fainelli@gmail.com>,
        Heiner Kallweit <hkallweit1@gmail.com>
Cc:     Alexandre Torgue <alexandre.torgue@st.com>,
        "David S. Miller" <davem@davemloft.net>,
        Felix Fietkau <nbd@nbd.name>,
        Giuseppe Cavallaro <peppe.cavallaro@st.com>,
        Hauke Mehrtens <hauke@hauke-m.de>,
        Ioana Ciornei <ioana.ciornei@nxp.com>,
        Jakub Kicinski <kuba@kernel.org>,
        John Crispin <john@phrozen.org>,
        Jonathan Corbet <corbet@lwn.net>,
        Jose Abreu <joabreu@synopsys.com>,
        linux-arm-kernel@lists.infradead.org, linux-doc@vger.kernel.org,
        linux-mediatek@lists.infradead.org,
        linux-stm32@st-md-mailman.stormreply.com,
        Mark Lee <Mark-MC.Lee@mediatek.com>,
        Matthias Brugger <matthias.bgg@gmail.com>,
        Maxime Coquelin <mcoquelin.stm32@gmail.com>,
        Michal Simek <michal.simek@xilinx.com>, netdev@vger.kernel.org,
        Nicolas Ferre <nicolas.ferre@microchip.com>,
        Radhey Shyam Pandey <radhey.shyam.pandey@xilinx.com>,
        Sean Wang <sean.wang@mediatek.com>,
        Thomas Petazzoni <thomas.petazzoni@bootlin.com>,
        Vivien Didelot <vivien.didelot@gmail.com>,
        Vladimir Oltean <olteanv@gmail.com>
Subject: [PATCH net-next v2 3/8] net: mv88e6xxx: use resolved link config in
 mac_link_up()
MIME-Version: 1.0
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
Content-Type: text/plain; charset="utf-8"
Message-Id: <E1j6tr5-0003GN-JK@rmk-PC.armlinux.org.uk>
Date:   Wed, 26 Feb 2020 10:23:51 +0000
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Use the resolved link configuration to set the MAC configuration when
mac_link_up() for non-internal-PHY ports.

Signed-off-by: Russell King <rmk+kernel@armlinux.org.uk>
---
 drivers/net/dsa/mv88e6xxx/chip.c | 75 +++++++++++++++++++++++++-------
 1 file changed, 59 insertions(+), 16 deletions(-)

diff --git a/drivers/net/dsa/mv88e6xxx/chip.c b/drivers/net/dsa/mv88e6xxx/chip.c
index fef3b5e0b291..4a4173e63fa5 100644
--- a/drivers/net/dsa/mv88e6xxx/chip.c
+++ b/drivers/net/dsa/mv88e6xxx/chip.c
@@ -632,25 +632,30 @@ static void mv88e6xxx_mac_config(struct dsa_switch *ds, int port,
 		dev_err(ds->dev, "p%d: failed to configure MAC\n", port);
 }
 
-static void mv88e6xxx_mac_link_force(struct dsa_switch *ds, int port, int link)
+static void mv88e6xxx_mac_link_down(struct dsa_switch *ds, int port,
+				    unsigned int mode,
+				    phy_interface_t interface)
 {
 	struct mv88e6xxx_chip *chip = ds->priv;
-	int err;
+	const struct mv88e6xxx_ops *ops;
+	int err = 0;
 
-	mv88e6xxx_reg_lock(chip);
-	err = chip->info->ops->port_set_link(chip, port, link);
-	mv88e6xxx_reg_unlock(chip);
+	ops = chip->info->ops;
 
-	if (err)
-		dev_err(chip->dev, "p%d: failed to force MAC link\n", port);
-}
+	/* Internal PHYs propagate their configuration directly to the MAC.
+	 * External PHYs depend on whether the PPU is enabled for this port.
+	 * FIXME: we should be using the PPU enable state here. What about
+	 * an automedia port?
+	 */
+	if (!mv88e6xxx_phy_is_internal(ds, port) && ops->port_set_link) {
+		mv88e6xxx_reg_lock(chip);
+		err = ops->port_set_link(chip, port, LINK_FORCED_DOWN);
+		mv88e6xxx_reg_unlock(chip);
 
-static void mv88e6xxx_mac_link_down(struct dsa_switch *ds, int port,
-				    unsigned int mode,
-				    phy_interface_t interface)
-{
-	if (mode == MLO_AN_FIXED)
-		mv88e6xxx_mac_link_force(ds, port, LINK_FORCED_DOWN);
+		if (err)
+			dev_err(chip->dev,
+				"p%d: failed to force MAC link down\n", port);
+	}
 }
 
 static void mv88e6xxx_mac_link_up(struct dsa_switch *ds, int port,
@@ -659,8 +664,46 @@ static void mv88e6xxx_mac_link_up(struct dsa_switch *ds, int port,
 				  int speed, int duplex,
 				  bool tx_pause, bool rx_pause)
 {
-	if (mode == MLO_AN_FIXED)
-		mv88e6xxx_mac_link_force(ds, port, LINK_FORCED_UP);
+	struct mv88e6xxx_chip *chip = ds->priv;
+	const struct mv88e6xxx_ops *ops;
+	int err = 0;
+
+	ops = chip->info->ops;
+
+	/* Internal PHYs propagate their configuration directly to the MAC.
+	 * External PHYs depend on whether the PPU is enabled for this port.
+	 * FIXME: we should be using the PPU enable state here. What about
+	 * an automedia port?
+	 */
+	if (!mv88e6xxx_phy_is_internal(ds, port)) {
+		mv88e6xxx_reg_lock(chip);
+		/* FIXME: for an automedia port, should we force the link
+		 * down here - what if the link comes up due to "other" media
+		 * while we're bringing the port up, how is the exclusivity
+		 * handled in the Marvell hardware? E.g. port 4 on 88E6532
+		 * shared between internal PHY and Serdes.
+		 */
+		if (ops->port_set_speed) {
+			err = ops->port_set_speed(chip, port, speed);
+			if (err && err != -EOPNOTSUPP)
+				goto error;
+		}
+
+		if (ops->port_set_duplex) {
+			err = ops->port_set_duplex(chip, port, duplex);
+			if (err && err != -EOPNOTSUPP)
+				goto error;
+		}
+
+		if (ops->port_set_link)
+			err = ops->port_set_link(chip, port, LINK_FORCED_UP);
+error:
+		mv88e6xxx_reg_unlock(chip);
+
+		if (err && err != -EOPNOTSUPP)
+			dev_err(ds->dev,
+				"p%d: failed to configure MAC link up\n", port);
+	}
 }
 
 static int mv88e6xxx_stats_snapshot(struct mv88e6xxx_chip *chip, int port)
-- 
2.20.1

