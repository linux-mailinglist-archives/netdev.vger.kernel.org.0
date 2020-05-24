Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id EC5AC1DFFD2
	for <lists+netdev@lfdr.de>; Sun, 24 May 2020 17:28:21 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2387694AbgEXP2R (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sun, 24 May 2020 11:28:17 -0400
Received: from vps0.lunn.ch ([185.16.172.187]:46964 "EHLO vps0.lunn.ch"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1729995AbgEXP2L (ORCPT <rfc822;netdev@vger.kernel.org>);
        Sun, 24 May 2020 11:28:11 -0400
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed; d=lunn.ch;
        s=20171124; h=Content-Transfer-Encoding:MIME-Version:References:In-Reply-To:
        Message-Id:Date:Subject:Cc:To:From:Sender:Reply-To:Content-Type:Content-ID:
        Content-Description:Resent-Date:Resent-From:Resent-Sender:Resent-To:Resent-Cc
        :Resent-Message-ID:List-Id:List-Help:List-Unsubscribe:List-Subscribe:
        List-Post:List-Owner:List-Archive;
        bh=IStcaG+IrrBh/OBhydGuAH0geZcmvhSxEQu87NRbEXs=; b=FV1u1uDhLG5NuPKHN5bNU4FLzV
        4ya8wFetKrKXtfS6QxQS0e4itmNalSv+gbeeKFNby+teKvcYJkpG1gBxPa0O+6LbZc808G52VJfgZ
        QGy/QNSAGL7VRfk2Jb6b4qnAB132gptEWJco7RV6gfuF3V2Q4QSvqhXWaXlN0/oB1Rnc=;
Received: from andrew by vps0.lunn.ch with local (Exim 4.93)
        (envelope-from <andrew@lunn.ch>)
        id 1jcsXl-00383Z-2f; Sun, 24 May 2020 17:28:05 +0200
From:   Andrew Lunn <andrew@lunn.ch>
To:     David Miller <davem@davemloft.net>
Cc:     netdev <netdev@vger.kernel.org>,
        Florian Fainelli <f.fainelli@gmail.com>,
        Heiner Kallweit <hkallweit1@gmail.com>,
        Chris Healy <cphealy@gmail.com>,
        Michal Kubecek <mkubecek@suse.cz>, Andrew Lunn <andrew@lunn.ch>
Subject: [PATCH v2 net-next 4/6] net: phy: marvell: Add support for amplitude graph
Date:   Sun, 24 May 2020 17:27:44 +0200
Message-Id: <20200524152747.745893-5-andrew@lunn.ch>
X-Mailer: git-send-email 2.26.2
In-Reply-To: <20200524152747.745893-1-andrew@lunn.ch>
References: <20200524152747.745893-1-andrew@lunn.ch>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

The Marvell PHYs can measure the amplitude of the returned signal for
a given distance. Implement this option of the cable test
infrastructure. When reporting the step, convert the distance into cm.

Signed-off-by: Andrew Lunn <andrew@lunn.ch>

v2:
Step based on the measurement resolution, and convert this to cm.
---
 drivers/net/phy/marvell.c | 232 +++++++++++++++++++++++++++++++++++++-
 1 file changed, 231 insertions(+), 1 deletion(-)

diff --git a/drivers/net/phy/marvell.c b/drivers/net/phy/marvell.c
index 4bc7febf9248..e597bee2e966 100644
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
@@ -164,6 +165,54 @@
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
+#define MII_VCT5_CTRL_TX_SAME_CHANNEL			(0x0 << 11)
+#define MII_VCT5_CTRL_TX0_CHANNEL			(0x4 << 11)
+#define MII_VCT5_CTRL_TX1_CHANNEL			(0x5 << 11)
+#define MII_VCT5_CTRL_TX2_CHANNEL			(0x6 << 11)
+#define MII_VCT5_CTRL_TX3_CHANNEL			(0x7 << 11)
+#define MII_VCT5_CTRL_SAMPLES_2				(0x0 << 8)
+#define MII_VCT5_CTRL_SAMPLES_4				(0x1 << 8)
+#define MII_VCT5_CTRL_SAMPLES_8				(0x2 << 8)
+#define MII_VCT5_CTRL_SAMPLES_16			(0x3 << 8)
+#define MII_VCT5_CTRL_SAMPLES_32			(0x4 << 8)
+#define MII_VCT5_CTRL_SAMPLES_64			(0x5 << 8)
+#define MII_VCT5_CTRL_SAMPLES_128			(0x6 << 8)
+#define MII_VCT5_CTRL_SAMPLES_DEFAULT			(0x6 << 8)
+#define MII_VCT5_CTRL_SAMPLES_256			(0x7 << 8)
+#define MII_VCT5_CTRL_SAMPLES_SHIFT			8
+#define MII_VCT5_CTRL_MODE_MAXIMUM_PEEK			(0x0 << 6)
+#define MII_VCT5_CTRL_MODE_FIRST_LAST_PEEK		(0x1 << 6)
+#define MII_VCT5_CTRL_MODE_OFFSET			(0x2 << 6)
+#define MII_VCT5_CTRL_SAMPLE_POINT			(0x3 << 6)
+#define MII_VCT5_CTRL_PEEK_HYST_DEFAULT			3
+
+#define MII_VCT5_SAMPLE_POINT_DISTANCE		0x18
+#define MII_VCT5_TX_PULSE_CTRL			0x1c
+#define MII_VCT5_TX_PULSE_CTRL_DONT_WAIT_LINK_DOWN	BIT(12)
+#define MII_VCT5_TX_PULSE_CTRL_PULSE_WIDTH_128nS	(0x0 << 10)
+#define MII_VCT5_TX_PULSE_CTRL_PULSE_WIDTH_96nS		(0x1 << 10)
+#define MII_VCT5_TX_PULSE_CTRL_PULSE_WIDTH_64nS		(0x2 << 10)
+#define MII_VCT5_TX_PULSE_CTRL_PULSE_WIDTH_32nS		(0x3 << 10)
+#define MII_VCT5_TX_PULSE_CTRL_PULSE_WIDTH_SHIFT	10
+#define MII_VCT5_TX_PULSE_CTRL_PULSE_AMPLITUDE_1000mV	(0x0 << 8)
+#define MII_VCT5_TX_PULSE_CTRL_PULSE_AMPLITUDE_750mV	(0x1 << 8)
+#define MII_VCT5_TX_PULSE_CTRL_PULSE_AMPLITUDE_500mV	(0x2 << 8)
+#define MII_VCT5_TX_PULSE_CTRL_PULSE_AMPLITUDE_250mV	(0x3 << 8)
+#define MII_VCT5_TX_PULSE_CTRL_PULSE_AMPLITUDE_SHIFT	8
+#define MII_VCT5_TX_PULSE_CTRL_MAX_AMP			BIT(7)
+#define MII_VCT5_TX_PULSE_CTRL_GT_140m_46_86mV		(0x6 << 0)
+
 #define MII_VCT7_PAIR_0_DISTANCE	0x10
 #define MII_VCT7_PAIR_1_DISTANCE	0x11
 #define MII_VCT7_PAIR_2_DISTANCE	0x12
@@ -220,6 +269,7 @@ struct marvell_priv {
 	u64 stats[ARRAY_SIZE(marvell_hw_stats)];
 	char *hwmon_name;
 	struct device *hwmon_dev;
+	bool cable_test_tdr;
 };
 
 static int marvell_read_page(struct phy_device *phydev)
@@ -1690,7 +1740,119 @@ static void marvell_get_stats(struct phy_device *phydev,
 		data[i] = marvell_get_stat(phydev, i);
 }
 
-static int marvell_vct7_cable_test_start(struct phy_device *phydev)
+static int marvell_vct5_wait_complete(struct phy_device *phydev)
+{
+	int i;
+	int val;
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
+static u32 marvell_vct5_distance2cm(int distance)
+{
+	return distance * 805 / 10;
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
+		MII_VCT5_CTRL_TX_SAME_CHANNEL |
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
+	ethnl_cable_test_amplitude(phydev, ETHTOOL_A_CABLE_PAIR_A, mV_pair0);
+	ethnl_cable_test_amplitude(phydev, ETHTOOL_A_CABLE_PAIR_B, mV_pair1);
+	ethnl_cable_test_amplitude(phydev, ETHTOOL_A_CABLE_PAIR_C, mV_pair2);
+	ethnl_cable_test_amplitude(phydev, ETHTOOL_A_CABLE_PAIR_D, mV_pair3);
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
+	return 0;
+}
+
+static int marvell_cable_test_start_common(struct phy_device *phydev)
 {
 	int bmcr, bmsr, ret;
 
@@ -1719,12 +1881,69 @@ static int marvell_vct7_cable_test_start(struct phy_device *phydev)
 	if (bmsr & BMSR_LSTATUS)
 		msleep(1500);
 
+	return 0;
+}
+
+static int marvell_vct7_cable_test_start(struct phy_device *phydev)
+{
+	struct marvell_priv *priv = phydev->priv;
+	int ret;
+
+	ret = marvell_cable_test_start_common(phydev);
+	if (ret)
+		return ret;
+
+	priv->cable_test_tdr = false;
+
+	/* Reset the VCT5 API control to defaults, otherwise
+	 * VCT7 does not work correctly.
+	 */
+	ret = phy_write_paged(phydev, MII_MARVELL_VCT5_PAGE,
+			      MII_VCT5_CTRL,
+			      MII_VCT5_CTRL_TX_SAME_CHANNEL |
+			      MII_VCT5_CTRL_SAMPLES_DEFAULT |
+			      MII_VCT5_CTRL_MODE_MAXIMUM_PEEK |
+			      MII_VCT5_CTRL_PEEK_HYST_DEFAULT);
+	if (ret)
+		return ret;
+
+	ret = phy_write_paged(phydev, MII_MARVELL_VCT5_PAGE,
+			      MII_VCT5_SAMPLE_POINT_DISTANCE, 0);
+	if (ret)
+		return ret;
+
 	return phy_write_paged(phydev, MII_MARVELL_VCT7_PAGE,
 			       MII_VCT7_CTRL,
 			       MII_VCT7_CTRL_RUN_NOW |
 			       MII_VCT7_CTRL_CENTIMETERS);
 }
 
+static int marvell_vct5_cable_test_tdr_start(struct phy_device *phydev)
+{
+	struct marvell_priv *priv = phydev->priv;
+	int ret;
+
+	/* Disable  VCT7 */
+	ret = phy_write_paged(phydev, MII_MARVELL_VCT7_PAGE,
+			      MII_VCT7_CTRL, 0);
+	if (ret)
+		return ret;
+
+	ret = marvell_cable_test_start_common(phydev);
+	if (ret)
+		return ret;
+
+	priv->cable_test_tdr = true;
+	ret = ethnl_cable_test_pulse(phydev, 1000);
+	if (ret)
+		return ret;
+
+	return ethnl_cable_test_step(phydev,
+				     marvell_vct5_distance2cm(0),
+				     marvell_vct5_distance2cm(100),
+				     marvell_vct5_distance2cm(1));
+}
+
 static int marvell_vct7_distance_to_length(int distance, bool meter)
 {
 	if (meter)
@@ -1828,8 +2047,15 @@ static int marvell_vct7_cable_test_report(struct phy_device *phydev)
 static int marvell_vct7_cable_test_get_status(struct phy_device *phydev,
 					      bool *finished)
 {
+	struct marvell_priv *priv = phydev->priv;
 	int ret;
 
+	if (priv->cable_test_tdr) {
+		ret = marvell_vct5_amplitude_graph(phydev);
+		*finished = true;
+		return ret;
+	}
+
 	*finished = false;
 
 	ret = phy_read_paged(phydev, MII_MARVELL_VCT7_PAGE,
@@ -2563,6 +2789,7 @@ static struct phy_driver marvell_drivers[] = {
 		.get_tunable = m88e1011_get_tunable,
 		.set_tunable = m88e1011_set_tunable,
 		.cable_test_start = marvell_vct7_cable_test_start,
+		.cable_test_tdr_start = marvell_vct5_cable_test_tdr_start,
 		.cable_test_get_status = marvell_vct7_cable_test_get_status,
 	},
 	{
@@ -2588,6 +2815,7 @@ static struct phy_driver marvell_drivers[] = {
 		.get_tunable = m88e1540_get_tunable,
 		.set_tunable = m88e1540_set_tunable,
 		.cable_test_start = marvell_vct7_cable_test_start,
+		.cable_test_tdr_start = marvell_vct5_cable_test_tdr_start,
 		.cable_test_get_status = marvell_vct7_cable_test_get_status,
 	},
 	{
@@ -2613,6 +2841,7 @@ static struct phy_driver marvell_drivers[] = {
 		.get_tunable = m88e1540_get_tunable,
 		.set_tunable = m88e1540_set_tunable,
 		.cable_test_start = marvell_vct7_cable_test_start,
+		.cable_test_tdr_start = marvell_vct5_cable_test_tdr_start,
 		.cable_test_get_status = marvell_vct7_cable_test_get_status,
 	},
 	{
@@ -2658,6 +2887,7 @@ static struct phy_driver marvell_drivers[] = {
 		.get_tunable = m88e1540_get_tunable,
 		.set_tunable = m88e1540_set_tunable,
 		.cable_test_start = marvell_vct7_cable_test_start,
+		.cable_test_tdr_start = marvell_vct5_cable_test_tdr_start,
 		.cable_test_get_status = marvell_vct7_cable_test_get_status,
 	},
 };
-- 
2.27.0.rc0

