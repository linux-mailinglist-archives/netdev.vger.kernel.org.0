Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id AFEA616BD9F
	for <lists+netdev@lfdr.de>; Tue, 25 Feb 2020 10:42:36 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729809AbgBYJlU (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 25 Feb 2020 04:41:20 -0500
Received: from pandora.armlinux.org.uk ([78.32.30.218]:55568 "EHLO
        pandora.armlinux.org.uk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1729033AbgBYJlS (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 25 Feb 2020 04:41:18 -0500
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
        d=armlinux.org.uk; s=pandora-2019; h=Date:Sender:Message-Id:Content-Type:
        Content-Transfer-Encoding:MIME-Version:Subject:Cc:To:From:References:
        In-Reply-To:Reply-To:Content-ID:Content-Description:Resent-Date:Resent-From:
        Resent-Sender:Resent-To:Resent-Cc:Resent-Message-ID:List-Id:List-Help:
        List-Unsubscribe:List-Subscribe:List-Post:List-Owner:List-Archive;
        bh=jiP34lO1U2EOjRP+R8rbkehhBwrfBY+V5xaU3X9MBpI=; b=pFGy7DwYmkP+2TZ9k50w3+B69t
        hepkfRWTXum/qfGMv8o6UDch9kkyXDdtYGaQjWxGUy6G+hiaQ4ZxgePy/nOKTFJ5Upmd/QR20Cv4J
        vzBp4B+H9QUpgU5hzpcDtbYS3u+AWPz94XDDXcAVgX6D0WIK0wGbaL65hof9h/Wk0g8dViWJecQwx
        SLB45vAjEZOvBVVBHvaYRuZJMLxoaymwxmnhIQHvpeITqmHyLI3hYA63dN6oRa16r+ZT5kVS6/hgY
        vylfJ5lIf0DBAMTHoLK7QnRZAUz8HwPyWgXrvUC7tPRm+dzmvJ7cJhvw+v5kPZza5eF3iw0yybE6j
        pWPFV60Q==;
Received: from e0022681537dd.dyn.armlinux.org.uk ([2001:4d48:ad52:3201:222:68ff:fe15:37dd]:51286 helo=rmk-PC.armlinux.org.uk)
        by pandora.armlinux.org.uk with esmtpsa (TLSv1.2:ECDHE-RSA-AES256-GCM-SHA384:256)
        (Exim 4.90_1)
        (envelope-from <rmk@armlinux.org.uk>)
        id 1j6WgM-0008PS-Ld; Tue, 25 Feb 2020 09:39:15 +0000
Received: from rmk by rmk-PC.armlinux.org.uk with local (Exim 4.92)
        (envelope-from <rmk@armlinux.org.uk>)
        id 1j6WgG-0000TJ-CC; Tue, 25 Feb 2020 09:39:08 +0000
In-Reply-To: <20200225093703.GS25745@shell.armlinux.org.uk>
References: <20200225093703.GS25745@shell.armlinux.org.uk>
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
Subject: [PATCH net-next 5/8] net: dpaa2-mac: use resolved link config in
 mac_link_up()
MIME-Version: 1.0
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
Content-Type: text/plain; charset="utf-8"
Message-Id: <E1j6WgG-0000TJ-CC@rmk-PC.armlinux.org.uk>
Date:   Tue, 25 Feb 2020 09:39:08 +0000
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Convert the DPAA2 ethernet driver to use the finalised link parameters
in mac_link_up() rather than the parameters in mac_config(), which are
more suited to the needs of the DPAA2 MC firmware than those available
via mac_config().

Signed-off-by: Russell King <rmk+kernel@armlinux.org.uk>
---
 .../net/ethernet/freescale/dpaa2/dpaa2-mac.c  | 54 +++++++++++--------
 .../net/ethernet/freescale/dpaa2/dpaa2-mac.h  |  1 +
 2 files changed, 33 insertions(+), 22 deletions(-)

diff --git a/drivers/net/ethernet/freescale/dpaa2/dpaa2-mac.c b/drivers/net/ethernet/freescale/dpaa2/dpaa2-mac.c
index 3a75c5b58f95..3ee236c5fc37 100644
--- a/drivers/net/ethernet/freescale/dpaa2/dpaa2-mac.c
+++ b/drivers/net/ethernet/freescale/dpaa2/dpaa2-mac.c
@@ -123,35 +123,16 @@ static void dpaa2_mac_config(struct phylink_config *config, unsigned int mode,
 	struct dpmac_link_state *dpmac_state = &mac->state;
 	int err;
 
-	if (state->speed != SPEED_UNKNOWN)
-		dpmac_state->rate = state->speed;
-
-	if (state->duplex != DUPLEX_UNKNOWN) {
-		if (!state->duplex)
-			dpmac_state->options |= DPMAC_LINK_OPT_HALF_DUPLEX;
-		else
-			dpmac_state->options &= ~DPMAC_LINK_OPT_HALF_DUPLEX;
-	}
-
 	if (state->an_enabled)
 		dpmac_state->options |= DPMAC_LINK_OPT_AUTONEG;
 	else
 		dpmac_state->options &= ~DPMAC_LINK_OPT_AUTONEG;
 
-	if (state->pause & MLO_PAUSE_RX)
-		dpmac_state->options |= DPMAC_LINK_OPT_PAUSE;
-	else
-		dpmac_state->options &= ~DPMAC_LINK_OPT_PAUSE;
-
-	if (!!(state->pause & MLO_PAUSE_RX) ^ !!(state->pause & MLO_PAUSE_TX))
-		dpmac_state->options |= DPMAC_LINK_OPT_ASYM_PAUSE;
-	else
-		dpmac_state->options &= ~DPMAC_LINK_OPT_ASYM_PAUSE;
-
 	err = dpmac_set_link_state(mac->mc_io, 0,
 				   mac->mc_dev->mc_handle, dpmac_state);
 	if (err)
-		netdev_err(mac->net_dev, "dpmac_set_link_state() = %d\n", err);
+		netdev_err(mac->net_dev, "%s: dpmac_set_link_state() = %d\n",
+			   __func__, err);
 }
 
 static void dpaa2_mac_link_up(struct phylink_config *config,
@@ -165,10 +146,37 @@ static void dpaa2_mac_link_up(struct phylink_config *config,
 	int err;
 
 	dpmac_state->up = 1;
+
+	if (mac->if_link_type == DPMAC_LINK_TYPE_PHY) {
+		/* If the DPMAC is configured for PHY mode, we need
+		 * to pass the link parameters to the MC firmware.
+		 */
+		dpmac_state->rate = speed;
+
+		if (duplex == DUPLEX_HALF)
+			dpmac_state->options |= DPMAC_LINK_OPT_HALF_DUPLEX;
+		else if (duplex == DUPLEX_FULL)
+			dpmac_state->options &= ~DPMAC_LINK_OPT_HALF_DUPLEX;
+
+		/* This is lossy; the firmware really should take the pause
+		 * enablement status rather than pause/asym pause status.
+		 */
+		if (rx_pause)
+			dpmac_state->options |= DPMAC_LINK_OPT_PAUSE;
+		else
+			dpmac_state->options &= ~DPMAC_LINK_OPT_PAUSE;
+
+		if (rx_pause ^ tx_pause)
+			dpmac_state->options |= DPMAC_LINK_OPT_ASYM_PAUSE;
+		else
+			dpmac_state->options &= ~DPMAC_LINK_OPT_ASYM_PAUSE;
+	}
+
 	err = dpmac_set_link_state(mac->mc_io, 0,
 				   mac->mc_dev->mc_handle, dpmac_state);
 	if (err)
-		netdev_err(mac->net_dev, "dpmac_set_link_state() = %d\n", err);
+		netdev_err(mac->net_dev, "%s: dpmac_set_link_state() = %d\n",
+			   __func__, err);
 }
 
 static void dpaa2_mac_link_down(struct phylink_config *config,
@@ -241,6 +249,8 @@ int dpaa2_mac_connect(struct dpaa2_mac *mac)
 		goto err_close_dpmac;
 	}
 
+	mac->if_link_type = attr.link_type;
+
 	dpmac_node = dpaa2_mac_get_node(attr.id);
 	if (!dpmac_node) {
 		netdev_err(net_dev, "No dpmac@%d node found.\n", attr.id);
diff --git a/drivers/net/ethernet/freescale/dpaa2/dpaa2-mac.h b/drivers/net/ethernet/freescale/dpaa2/dpaa2-mac.h
index 4da8079b9155..2130d9c7d40e 100644
--- a/drivers/net/ethernet/freescale/dpaa2/dpaa2-mac.h
+++ b/drivers/net/ethernet/freescale/dpaa2/dpaa2-mac.h
@@ -20,6 +20,7 @@ struct dpaa2_mac {
 	struct phylink_config phylink_config;
 	struct phylink *phylink;
 	phy_interface_t if_mode;
+	enum dpmac_link_type if_link_type;
 };
 
 bool dpaa2_mac_is_type_fixed(struct fsl_mc_device *dpmac_dev,
-- 
2.20.1

