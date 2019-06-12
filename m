Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 3DD2B42BCF
	for <lists+netdev@lfdr.de>; Wed, 12 Jun 2019 18:07:43 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2409458AbfFLQHm (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 12 Jun 2019 12:07:42 -0400
Received: from vps0.lunn.ch ([185.16.172.187]:49396 "EHLO vps0.lunn.ch"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S2406284AbfFLQHl (ORCPT <rfc822;netdev@vger.kernel.org>);
        Wed, 12 Jun 2019 12:07:41 -0400
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed; d=lunn.ch;
        s=20171124; h=References:In-Reply-To:Message-Id:Date:Subject:Cc:To:From:
        Sender:Reply-To:MIME-Version:Content-Type:Content-Transfer-Encoding:
        Content-ID:Content-Description:Resent-Date:Resent-From:Resent-Sender:
        Resent-To:Resent-Cc:Resent-Message-ID:List-Id:List-Help:List-Unsubscribe:
        List-Subscribe:List-Post:List-Owner:List-Archive;
        bh=nXKG6RM8D2yHWHLzF/NK+o51mdU+BdGMydMjDE514lU=; b=bWDQAm+ir5ur55qNUtZXRoUkO8
        XGO7uGpXS4dI3sILmuRvLGF5gphGg84PRrcF/xVZawWsebUqV6mQtD6/TujJ6B/l4TDEG63E0zG7v
        KPfVSVZq/MV44CTmmqv/kx4MxGs8xqywOhLBxfOY6G3BwD6Ch9UmFW8m/Oc7n56H9Chw=;
Received: from andrew by vps0.lunn.ch with local (Exim 4.89)
        (envelope-from <andrew@lunn.ch>)
        id 1hb5lD-00069k-E9; Wed, 12 Jun 2019 18:06:03 +0200
From:   Andrew Lunn <andrew@lunn.ch>
To:     netdev <netdev@vger.kernel.org>
Cc:     Florian Fainelli <f.fainelli@gmail.com>,
        Heiner Kallweit <hkallweit1@gmail.com>,
        Raju.Lakkaraju@microchip.com, Andrew Lunn <andrew@lunn.ch>
Subject: [PATCH RFC 12/13] net: phy: marvell: Add support for amplitude graph
Date:   Wed, 12 Jun 2019 18:05:33 +0200
Message-Id: <20190612160534.23533-13-andrew@lunn.ch>
X-Mailer: git-send-email 2.11.0
In-Reply-To: <20190612160534.23533-1-andrew@lunn.ch>
References: <20190612160534.23533-1-andrew@lunn.ch>
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

The Marvell PHYs can measure the amplitude of the returned signal for
a given distance. Implement this option of the cable test
infrastructure.

Signed-off-by: Andrew Lunn <andrew@lunn.ch>
---
 drivers/net/phy/marvell.c | 178 +++++++++++++++++++++++++++++++++++++-
 1 file changed, 175 insertions(+), 3 deletions(-)

diff --git a/drivers/net/phy/marvell.c b/drivers/net/phy/marvell.c
index 11a19c354533..5f200ad51326 100644
--- a/drivers/net/phy/marvell.c
+++ b/drivers/net/phy/marvell.c
@@ -42,6 +42,7 @@
 #define MII_MARVELL_FIBER_PAGE		0x01
 #define MII_MARVELL_MSCR_PAGE		0x02
 #define MII_MARVELL_LED_PAGE		0x03
+#define MII_MARVELL_VCT5_PAGE		0x05
 #define MII_MARVELL_MISC_TEST_PAGE	0x06
 #define MII_MARVELL_VCT7_PAGE		0x07
 #define MII_MARVELL_WOL_PAGE		0x11
@@ -158,6 +159,46 @@
 #define MII_88E1510_GEN_CTRL_REG_1_MODE_SGMII	0x1	/* SGMII to copper */
 #define MII_88E1510_GEN_CTRL_REG_1_RESET	0x8000	/* Soft reset */
 
+#define MII_VCT5_TX_RX_MDI0_COUPLING	0x10
+#define MII_VCT5_TX_RX_MDI1_COUPLING	0x11
+#define MII_VCT5_TX_RX_MDI2_COUPLING	0x12
+#define MII_VCT5_TX_RX_MDI3_COUPLING	0x13
+#define MII_VCT5_TX_RX_AMPLITUDE_MASK	0x7f00
+#define MII_VCT5_TX_RX_AMPLITUDE_SHIFT	8
+#define MII_VCT5_TX_RX_COUPLING_POSITIVE_REFLECTION	BIT(15)
+
+#define MII_VCT5_CTRL				0x17
+#define MII_VCT5_CTRL_ENABLE				BIT(15)
+#define MII_VCT5_CTRL_COMPLETE				BIT(14)
+#define MII_VCT5_CTRL_SAME_CHANNEL			(0 << 11)
+#define MII_VCT5_CTRL_TX0_CHANNEL			(1 << 11)
+#define MII_VCT5_CTRL_TX1_CHANNEL			(2 << 11)
+#define MII_VCT5_CTRL_TX2_CHANNEL			(3 << 11)
+#define MII_VCT5_CTRL_TX3_CHANNEL			(4 << 11)
+#define MII_VCT5_CTRL_SAMPLES_2				(0 << 8)
+#define MII_VCT5_CTRL_SAMPLES_4				(1 << 8)
+#define MII_VCT5_CTRL_SAMPLES_8				(2 << 8)
+#define MII_VCT5_CTRL_SAMPLES_16			(3 << 8)
+#define MII_VCT5_CTRL_SAMPLES_32			(4 << 8)
+#define MII_VCT5_CTRL_SAMPLES_64			(5 << 8)
+#define MII_VCT5_CTRL_SAMPLES_126			(5 << 8)
+#define MII_VCT5_CTRL_SAMPLES_DEFAULT			(6 << 8)
+#define MII_VCT5_CTRL_MODE_MAXIMUM_PEEK			(0 << 6)
+#define MII_VCT5_CTRL_MODE_FIRST_LAST_PEEK		(1 << 6)
+#define MII_VCT5_CTRL_MODE_OFFSET			(2 << 6)
+#define MII_VCT5_CTRL_SAMPLE_POINT			(3 << 6)
+#define MII_VCT5_CTRL_PEEK_HYST_DEFAULT			3
+
+#define MII_VCT5_SAMPLE_POINT_DISTANCE		0x18
+#define MII_VCT5_TX_PULSE_CTRL			0x1c
+#define MII_VCT5_TX_PULSE_CTRL_DONT_WAIT_LINK_DOWN	BIT(12)
+#define MII_VCT5_TX_PULSE_CTRL_PULSE_WIDTH_128nS	(0 << 10)
+#define MII_VCT5_TX_PULSE_CTRL_PULSE_WIDTH_96nS		(1 << 10)
+#define MII_VCT5_TX_PULSE_CTRL_PULSE_WIDTH_64nS		(2 << 10)
+#define MII_VCT5_TX_PULSE_CTRL_PULSE_WIDTH_32nS		(3 << 10)
+#define MII_VCT5_TX_PULSE_CTRL_MAX_AMP			BIT(7)
+#define MII_VCT5_TX_PULSE_CTRL_GT_140m_46_86mV		(6 << 0)
+
 #define MII_VCT7_PAIR_0_DISTANCE	0x10
 #define MII_VCT7_PAIR_1_DISTANCE	0x11
 #define MII_VCT7_PAIR_2_DISTANCE	0x12
@@ -224,6 +265,7 @@ struct marvell_priv {
 	u64 stats[ARRAY_SIZE(marvell_hw_stats)];
 	char *hwmon_name;
 	struct device *hwmon_dev;
+	int cable_test_options;
 };
 
 static int marvell_read_page(struct phy_device *phydev)
@@ -1667,14 +1709,131 @@ static void marvell_get_stats(struct phy_device *phydev,
 		data[i] = marvell_get_stat(phydev, i);
 }
 
+static int marvell_vct5_wait_complete(struct phy_device *phydev)
+{
+	int i;
+	u16 val;
+
+	for (i = 0; i < 32; i++) {
+		val = phy_read_paged(phydev, MII_MARVELL_VCT5_PAGE,
+				     MII_VCT5_CTRL);
+		if (val < 0)
+			return val;
+
+		if (val & MII_VCT5_CTRL_COMPLETE)
+			return 0;
+
+		usleep_range(1000, 2000);
+	}
+
+	phydev_err(phydev, "Timeout while waiting for cable test to finish\n");
+	return -ETIMEDOUT;
+}
+
+static int marvell_vct5_amplitude(struct phy_device *phydev, int pair)
+{
+	int amplitude;
+	int val;
+	int reg;
+
+	reg = MII_VCT5_TX_RX_MDI0_COUPLING + pair;
+	val = phy_read_paged(phydev, MII_MARVELL_VCT5_PAGE, reg);
+
+	if (val < 0)
+		return 0;
+
+	amplitude = (val & MII_VCT5_TX_RX_AMPLITUDE_MASK) >>
+		MII_VCT5_TX_RX_AMPLITUDE_SHIFT;
+
+	if (!(val & MII_VCT5_TX_RX_COUPLING_POSITIVE_REFLECTION))
+		amplitude = -amplitude;
+
+	return 1000 * amplitude / 128;
+}
+
+static int marvell_vct5_amplitude_distance(struct phy_device *phydev,
+					   int distance)
+{
+	int mV_pair0, mV_pair1, mV_pair2, mV_pair3;
+	u16 reg;
+	int err;
+
+	err = phy_write_paged(phydev, MII_MARVELL_VCT5_PAGE,
+			      MII_VCT5_SAMPLE_POINT_DISTANCE,
+			      distance);
+	if (err)
+		return err;
+
+	reg = MII_VCT5_CTRL_ENABLE |
+		MII_VCT5_CTRL_SAME_CHANNEL |
+		MII_VCT5_CTRL_SAMPLES_DEFAULT |
+		MII_VCT5_CTRL_SAMPLE_POINT |
+		MII_VCT5_CTRL_PEEK_HYST_DEFAULT;
+	err = phy_write_paged(phydev, MII_MARVELL_VCT5_PAGE,
+			      MII_VCT5_CTRL, reg);
+	if (err)
+		return err;
+
+	err = marvell_vct5_wait_complete(phydev);
+	if (err)
+		return err;
+
+	mV_pair0 = marvell_vct5_amplitude(phydev, 0);
+	mV_pair1 = marvell_vct5_amplitude(phydev, 1);
+	mV_pair2 = marvell_vct5_amplitude(phydev, 2);
+	mV_pair3 = marvell_vct5_amplitude(phydev, 3);
+
+	phy_cable_test_amplitude(phydev, distance, ETHTOOL_A_CABLE_PAIR_0,
+				 mV_pair0);
+	phy_cable_test_amplitude(phydev, distance, ETHTOOL_A_CABLE_PAIR_1,
+				 mV_pair1);
+	phy_cable_test_amplitude(phydev, distance, ETHTOOL_A_CABLE_PAIR_2,
+				 mV_pair2);
+	phy_cable_test_amplitude(phydev, distance, ETHTOOL_A_CABLE_PAIR_3,
+				 mV_pair3);
+
+	return 0;
+}
+
+static int marvell_vct5_amplitude_graph(struct phy_device *phydev)
+{
+	int distance;
+	int err;
+	u16 reg;
+
+	/* Disable  VCT7 */
+	err = phy_write_paged(phydev, MII_MARVELL_VCT7_PAGE,
+			      MII_VCT7_CTRL, 0);
+
+	/* Allow the cable time to become idle */
+	msleep(1500);
+
+	reg = MII_VCT5_TX_PULSE_CTRL_GT_140m_46_86mV |
+		MII_VCT5_TX_PULSE_CTRL_DONT_WAIT_LINK_DOWN |
+		MII_VCT5_TX_PULSE_CTRL_MAX_AMP |
+		MII_VCT5_TX_PULSE_CTRL_PULSE_WIDTH_32nS;
+
+	err = phy_write_paged(phydev, MII_MARVELL_VCT5_PAGE,
+			      MII_VCT5_TX_PULSE_CTRL, reg);
+	if (err)
+		return err;
+
+	for (distance = 0; distance <= 100; distance++) {
+		err = marvell_vct5_amplitude_distance(phydev, distance);
+		if (err)
+			return err;
+	}
+
+	/* 1000 mV pulse is used */
+	return phy_cable_test_pulse(phydev, 1000);
+}
+
 static int marvell_vct7_cable_test_start(struct phy_device *phydev,
 					 int options)
 {
+	struct marvell_priv *priv = phydev->priv;
 	int bmcr, bmsr, ret;
 
-	if (options)
-		return -EOPNOTSUPP;
-
 	/* If auto-negotiation is enabled, but not complete, the
 	   cable test never completes. So disable auto-neg.
 	*/
@@ -1697,6 +1856,12 @@ static int marvell_vct7_cable_test_start(struct phy_device *phydev,
 			return ret;
 	}
 
+	priv->cable_test_options = options;
+
+	if (options & PHY_CABLE_TEST_AMPLITUDE_GRAPH) {
+		return 0;
+	}
+
 	return phy_write_paged(phydev, MII_MARVELL_VCT7_PAGE,
 			       MII_VCT7_CTRL,
 			       MII_VCT7_CTRL_RUN_NOW |
@@ -1806,8 +1971,15 @@ static int marvell_vct7_cable_test_report(struct phy_device *phydev)
 static int marvell_vct7_cable_test_get_status(struct phy_device *phydev,
 					      bool *finished)
 {
+	struct marvell_priv *priv = phydev->priv;
 	int ret;
 
+	if (priv->cable_test_options & PHY_CABLE_TEST_AMPLITUDE_GRAPH) {
+		ret = marvell_vct5_amplitude_graph(phydev);
+		*finished = true;
+		return ret;
+	}
+
 	*finished = false;
 
 	ret = phy_read_paged(phydev, MII_MARVELL_VCT7_PAGE,
-- 
2.20.1

