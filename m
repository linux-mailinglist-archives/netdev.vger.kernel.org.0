Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 0690A1DFFCE
	for <lists+netdev@lfdr.de>; Sun, 24 May 2020 17:28:20 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2387617AbgEXP2L (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sun, 24 May 2020 11:28:11 -0400
Received: from vps0.lunn.ch ([185.16.172.187]:46956 "EHLO vps0.lunn.ch"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1729338AbgEXP2K (ORCPT <rfc822;netdev@vger.kernel.org>);
        Sun, 24 May 2020 11:28:10 -0400
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed; d=lunn.ch;
        s=20171124; h=Content-Transfer-Encoding:MIME-Version:References:In-Reply-To:
        Message-Id:Date:Subject:Cc:To:From:Sender:Reply-To:Content-Type:Content-ID:
        Content-Description:Resent-Date:Resent-From:Resent-Sender:Resent-To:Resent-Cc
        :Resent-Message-ID:List-Id:List-Help:List-Unsubscribe:List-Subscribe:
        List-Post:List-Owner:List-Archive;
        bh=pFMIwsmyqfs8N5Z4kYoFF07v8mfZ/gMINCUXrIyM458=; b=N2Bw9E3pQjWgpvE7UC+OQfoTqd
        U4D9VC17CJSZOu3Sk1iq7loOKHMlVp2Wv15S0GJmxCZXJG6RTxaFZvyML8ii0wdWaXo5WkgIpFdNe
        GyE3LclQOMCf1ME3Q/a1XDgIbWX8FIypltodcIBmcSdOpcCyWbvRsspJHojNKQO5lvfk=;
Received: from andrew by vps0.lunn.ch with local (Exim 4.93)
        (envelope-from <andrew@lunn.ch>)
        id 1jcsXl-00383j-5h; Sun, 24 May 2020 17:28:05 +0200
From:   Andrew Lunn <andrew@lunn.ch>
To:     David Miller <davem@davemloft.net>
Cc:     netdev <netdev@vger.kernel.org>,
        Florian Fainelli <f.fainelli@gmail.com>,
        Heiner Kallweit <hkallweit1@gmail.com>,
        Chris Healy <cphealy@gmail.com>,
        Michal Kubecek <mkubecek@suse.cz>, Andrew Lunn <andrew@lunn.ch>
Subject: [PATCH v2 net-next 6/6] net : phy: marvell: Speedup TDR data retrieval by only changing page once
Date:   Sun, 24 May 2020 17:27:46 +0200
Message-Id: <20200524152747.745893-7-andrew@lunn.ch>
X-Mailer: git-send-email 2.26.2
In-Reply-To: <20200524152747.745893-1-andrew@lunn.ch>
References: <20200524152747.745893-1-andrew@lunn.ch>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Getting the TDR data requires a large number of MDIO bus
transactions. The number can however be reduced if the page is only
changed once. Add the needed locking to allow this, and make use of
unlocked read/write methods where needed.

Signed-off-by: Andrew Lunn <andrew@lunn.ch>
---
 drivers/net/phy/marvell.c | 56 +++++++++++++++++++++++++++++----------
 1 file changed, 42 insertions(+), 14 deletions(-)

diff --git a/drivers/net/phy/marvell.c b/drivers/net/phy/marvell.c
index 7e1d95337a28..e9e9d5e688ed 100644
--- a/drivers/net/phy/marvell.c
+++ b/drivers/net/phy/marvell.c
@@ -214,6 +214,11 @@
 #define MII_VCT5_TX_PULSE_CTRL_MAX_AMP			BIT(7)
 #define MII_VCT5_TX_PULSE_CTRL_GT_140m_46_86mV		(0x6 << 0)
 
+/* For TDR measurements less than 11 meters, a short pulse should be
+ * used.
+ */
+#define TDR_SHORT_CABLE_LENGTH	11
+
 #define MII_VCT7_PAIR_0_DISTANCE	0x10
 #define MII_VCT7_PAIR_1_DISTANCE	0x11
 #define MII_VCT7_PAIR_2_DISTANCE	0x12
@@ -1751,15 +1756,12 @@ static int marvell_vct5_wait_complete(struct phy_device *phydev)
 	int val;
 
 	for (i = 0; i < 32; i++) {
-		val = phy_read_paged(phydev, MII_MARVELL_VCT5_PAGE,
-				     MII_VCT5_CTRL);
+		val = __phy_read(phydev, MII_VCT5_CTRL);
 		if (val < 0)
 			return val;
 
 		if (val & MII_VCT5_CTRL_COMPLETE)
 			return 0;
-
-		usleep_range(1000, 2000);
 	}
 
 	phydev_err(phydev, "Timeout while waiting for cable test to finish\n");
@@ -1773,7 +1775,7 @@ static int marvell_vct5_amplitude(struct phy_device *phydev, int pair)
 	int reg;
 
 	reg = MII_VCT5_TX_RX_MDI0_COUPLING + pair;
-	val = phy_read_paged(phydev, MII_MARVELL_VCT5_PAGE, reg);
+	val = __phy_read(phydev, reg);
 
 	if (val < 0)
 		return 0;
@@ -1805,9 +1807,8 @@ static int marvell_vct5_amplitude_distance(struct phy_device *phydev,
 	int mV;
 	int i;
 
-	err = phy_write_paged(phydev, MII_MARVELL_VCT5_PAGE,
-			      MII_VCT5_SAMPLE_POINT_DISTANCE,
-			      distance);
+	err = __phy_write(phydev, MII_VCT5_SAMPLE_POINT_DISTANCE,
+			  distance);
 	if (err)
 		return err;
 
@@ -1816,8 +1817,7 @@ static int marvell_vct5_amplitude_distance(struct phy_device *phydev,
 		MII_VCT5_CTRL_SAMPLES_DEFAULT |
 		MII_VCT5_CTRL_SAMPLE_POINT |
 		MII_VCT5_CTRL_PEEK_HYST_DEFAULT;
-	err = phy_write_paged(phydev, MII_MARVELL_VCT5_PAGE,
-			      MII_VCT5_CTRL, reg);
+	err = __phy_write(phydev, MII_VCT5_CTRL, reg);
 	if (err)
 		return err;
 
@@ -1840,29 +1840,57 @@ static int marvell_vct5_amplitude_graph(struct phy_device *phydev)
 {
 	struct marvell_priv *priv = phydev->priv;
 	int distance;
+	u16 width;
+	int page;
 	int err;
 	u16 reg;
 
+	if (priv->first <= TDR_SHORT_CABLE_LENGTH)
+		width = MII_VCT5_TX_PULSE_CTRL_PULSE_WIDTH_32nS;
+	else
+		width = MII_VCT5_TX_PULSE_CTRL_PULSE_WIDTH_128nS;
+
 	reg = MII_VCT5_TX_PULSE_CTRL_GT_140m_46_86mV |
 		MII_VCT5_TX_PULSE_CTRL_DONT_WAIT_LINK_DOWN |
-		MII_VCT5_TX_PULSE_CTRL_MAX_AMP |
-		MII_VCT5_TX_PULSE_CTRL_PULSE_WIDTH_32nS;
+		MII_VCT5_TX_PULSE_CTRL_MAX_AMP | width;
 
 	err = phy_write_paged(phydev, MII_MARVELL_VCT5_PAGE,
 			      MII_VCT5_TX_PULSE_CTRL, reg);
 	if (err)
 		return err;
 
+	/* Reading the TDR data is very MDIO heavy. We need to optimize
+	 * access to keep the time to a minimum. So lock the bus once,
+	 * and don't release it until complete. We can then avoid having
+	 * to change the page for every access, greatly speeding things
+	 * up.
+	 */
+	page = phy_select_page(phydev, MII_MARVELL_VCT5_PAGE);
+	if (page < 0)
+		return page;
+
 	for (distance = priv->first;
 	     distance <= priv->last;
 	     distance += priv->step) {
 		err = marvell_vct5_amplitude_distance(phydev, distance,
 						      priv->pair);
 		if (err)
-			return err;
+			goto restore_page;
+
+		if (distance > TDR_SHORT_CABLE_LENGTH &&
+		    width == MII_VCT5_TX_PULSE_CTRL_PULSE_WIDTH_32nS) {
+			width = MII_VCT5_TX_PULSE_CTRL_PULSE_WIDTH_128nS;
+			reg = MII_VCT5_TX_PULSE_CTRL_GT_140m_46_86mV |
+				MII_VCT5_TX_PULSE_CTRL_DONT_WAIT_LINK_DOWN |
+				MII_VCT5_TX_PULSE_CTRL_MAX_AMP | width;
+			err = __phy_write(phydev, MII_VCT5_TX_PULSE_CTRL, reg);
+			if (err)
+				goto restore_page;
+		}
 	}
 
-	return 0;
+restore_page:
+	return phy_restore_page(phydev, page, err);
 }
 
 static int marvell_cable_test_start_common(struct phy_device *phydev)
-- 
2.27.0.rc0

