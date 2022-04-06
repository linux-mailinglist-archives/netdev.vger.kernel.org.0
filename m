Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id D12DA4F6B66
	for <lists+netdev@lfdr.de>; Wed,  6 Apr 2022 22:27:39 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233715AbiDFU3c (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 6 Apr 2022 16:29:32 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:45834 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233797AbiDFU3J (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 6 Apr 2022 16:29:09 -0400
Received: from phobos.denx.de (phobos.denx.de [IPv6:2a01:238:438b:c500:173d:9f52:ddab:ee01])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 4918921A0E1
        for <netdev@vger.kernel.org>; Wed,  6 Apr 2022 11:50:39 -0700 (PDT)
Received: from tr.lan (ip-89-176-112-137.net.upcbroadband.cz [89.176.112.137])
        (using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits))
        (No client certificate requested)
        (Authenticated sender: marex@denx.de)
        by phobos.denx.de (Postfix) with ESMTPSA id 380C883DC1;
        Wed,  6 Apr 2022 20:50:34 +0200 (CEST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=denx.de;
        s=phobos-20191101; t=1649271034;
        bh=zM8qckN9v5fnJVS7+UlfSLrjgLMnI4Hnk9pg2PICFkw=;
        h=From:To:Cc:Subject:Date:From;
        b=r42RlvO24NqqWqL7N+FwuiRqByLDiucDUdLYPH/NTqmzjV4q/lamMN0DTDhOY9Z9/
         yglABfuDNAHtPbiKVF4JncUVqR4qNoBO0rozWaaKRg5JoDAKnjtRuQEcG6kEXaCo2M
         Pi8JTW+8swtbjnezbAxq1BSLp4eJWv8eAP8qU013REzFV1OF1RSNLrnNd0R18Mqe+W
         O1wE/NpjmUpsMMiHmmRbs61IsDuR8NYq6fmap6R7cTcs3I/jrYeEPykMAZy+rOlN5v
         FJvHVyLsrGiLs0j9XDnP8YUl1L8p+isG8kG2aes+zfr1UESWU7DVRJib84hGKihzUP
         QVEC8eRMIqthg==
From:   Marek Vasut <marex@denx.de>
To:     netdev@vger.kernel.org
Cc:     Marek Vasut <marex@denx.de>, Andrew Lunn <andrew@lunn.ch>,
        "David S . Miller" <davem@davemloft.net>,
        Heiner Kallweit <hkallweit1@gmail.com>,
        Jakub Kicinski <kuba@kernel.org>,
        Oleksij Rempel <linux@rempel-privat.de>,
        Paolo Abeni <pabeni@redhat.com>
Subject: [PATCH] net: phy: micrel: ksz9031/ksz9131: add cabletest support
Date:   Wed,  6 Apr 2022 20:50:20 +0200
Message-Id: <20220406185020.301197-1-marex@denx.de>
X-Mailer: git-send-email 2.35.1
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Virus-Scanned: clamav-milter 0.103.5 at phobos.denx.de
X-Virus-Status: Clean
X-Spam-Status: No, score=-4.4 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_MED,SPF_HELO_NONE,
        SPF_PASS,T_SCC_BODY_TEXT_LINE autolearn=ham autolearn_force=no
        version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Add cable test support for Micrel KSZ9x31 PHYs.

Tested on i.MX8M Mini with KSZ9131RNX in 100/Full mode with pairs shuffled
before magnetics:
(note: Cable test started/completed messages are omitted)

  mx8mm-ksz9131-a-d-connected$ ethtool --cable-test eth0
  Pair A code OK
  Pair B code Short within Pair
  Pair B, fault length: 0.80m
  Pair C code Short within Pair
  Pair C, fault length: 0.80m
  Pair D code OK

  mx8mm-ksz9131-a-b-connected$ ethtool --cable-test eth0
  Pair A code OK
  Pair B code OK
  Pair C code Short within Pair
  Pair C, fault length: 0.00m
  Pair D code Short within Pair
  Pair D, fault length: 0.00m

Tested on R8A77951 Salvator-XS with KSZ9031RNX and all four pairs connected:
(note: Cable test started/completed messages are omitted)

  r8a7795-ksz9031-all-connected$ ethtool --cable-test eth0
  Pair A code OK
  Pair B code OK
  Pair C code OK
  Pair D code OK

Signed-off-by: Marek Vasut <marex@denx.de>
Cc: Andrew Lunn <andrew@lunn.ch>
Cc: David S. Miller <davem@davemloft.net>
Cc: Heiner Kallweit <hkallweit1@gmail.com>
Cc: Jakub Kicinski <kuba@kernel.org>
Cc: Oleksij Rempel <linux@rempel-privat.de>
Cc: Paolo Abeni <pabeni@redhat.com>
---
 drivers/net/phy/micrel.c | 204 +++++++++++++++++++++++++++++++++++++++
 1 file changed, 204 insertions(+)

diff --git a/drivers/net/phy/micrel.c b/drivers/net/phy/micrel.c
index fc53b71dc872b..e4ed4368e34e5 100644
--- a/drivers/net/phy/micrel.c
+++ b/drivers/net/phy/micrel.c
@@ -70,6 +70,27 @@
 #define KSZ8081_LMD_SHORT_INDICATOR		BIT(12)
 #define KSZ8081_LMD_DELTA_TIME_MASK		GENMASK(8, 0)
 
+#define KSZ9x31_LMD				0x12
+#define KSZ9x31_LMD_VCT_EN			BIT(15)
+#define KSZ9x31_LMD_VCT_DIS_TX			BIT(14)
+#define KSZ9x31_LMD_VCT_PAIR(n)			(((n) & 0x3) << 12)
+#define KSZ9x31_LMD_VCT_SEL_RESULT		0
+#define KSZ9x31_LMD_VCT_SEL_THRES_HI		BIT(10)
+#define KSZ9x31_LMD_VCT_SEL_THRES_LO		BIT(11)
+#define KSZ9x31_LMD_VCT_SEL_MASK		GENMASK(11, 10)
+#define KSZ9x31_LMD_VCT_ST_NORMAL		0
+#define KSZ9x31_LMD_VCT_ST_OPEN			1
+#define KSZ9x31_LMD_VCT_ST_SHORT		2
+#define KSZ9x31_LMD_VCT_ST_FAIL			3
+#define KSZ9x31_LMD_VCT_ST_MASK			GENMASK(9, 8)
+#define KSZ9x31_LMD_VCT_DATA_REFLECTED_INVALID	BIT(7)
+#define KSZ9x31_LMD_VCT_DATA_SIG_WAIT_TOO_LONG	BIT(6)
+#define KSZ9x31_LMD_VCT_DATA_MASK100		BIT(5)
+#define KSZ9x31_LMD_VCT_DATA_NLP_FLP		BIT(4)
+#define KSZ9x31_LMD_VCT_DATA_LO_PULSE_MASK	GENMASK(3, 2)
+#define KSZ9x31_LMD_VCT_DATA_HI_PULSE_MASK	GENMASK(1, 0)
+#define KSZ9x31_LMD_VCT_DATA_MASK		GENMASK(7, 0)
+
 /* Lan8814 general Interrupt control/status reg in GPHY specific block. */
 #define LAN8814_INTC				0x18
 #define LAN8814_INTS				0x1B
@@ -1326,6 +1347,183 @@ static int ksz9031_read_status(struct phy_device *phydev)
 	return 0;
 }
 
+static int ksz9x31_cable_test_start(struct phy_device *phydev)
+{
+	int ret;
+
+	/* KSZ9131RNX, DS00002841B-page 38, 4.14 LinkMD (R) Cable Diagnostic
+	 * Prior to running the cable diagnostics, Auto-negotiation should
+	 * be disabled, full duplex set and the link speed set to 1000Mbps
+	 * via the Basic Control Register.
+	 */
+	ret = phy_modify(phydev, MII_BMCR,
+			 BMCR_SPEED1000 | BMCR_FULLDPLX |
+			 BMCR_ANENABLE | BMCR_SPEED100,
+			 BMCR_SPEED1000 | BMCR_FULLDPLX);
+	if (ret)
+		return ret;
+
+	/* KSZ9131RNX, DS00002841B-page 38, 4.14 LinkMD (R) Cable Diagnostic
+	 * The Master-Slave configuration should be set to Slave by writing
+	 * a value of 0x1000 to the Auto-Negotiation Master Slave Control
+	 * Register.
+	 */
+	return phy_modify(phydev, MII_CTRL1000,
+			  CTL1000_ENABLE_MASTER | CTL1000_AS_MASTER,
+			  CTL1000_ENABLE_MASTER);
+}
+
+static int ksz9x31_cable_test_result_trans(u16 status)
+{
+	switch (FIELD_GET(KSZ9x31_LMD_VCT_ST_MASK, status)) {
+	case KSZ9x31_LMD_VCT_ST_NORMAL:
+		return ETHTOOL_A_CABLE_RESULT_CODE_OK;
+	case KSZ9x31_LMD_VCT_ST_OPEN:
+		return ETHTOOL_A_CABLE_RESULT_CODE_SAME_SHORT;
+	case KSZ9x31_LMD_VCT_ST_SHORT:
+		return ETHTOOL_A_CABLE_RESULT_CODE_OPEN;
+	case KSZ9x31_LMD_VCT_ST_FAIL:
+		fallthrough;
+	default:
+		return ETHTOOL_A_CABLE_RESULT_CODE_UNSPEC;
+	}
+}
+
+static bool ksz9x31_cable_test_failed(u16 status)
+{
+	int stat = FIELD_GET(KSZ9x31_LMD_VCT_ST_MASK, status);
+
+	return stat == KSZ9x31_LMD_VCT_ST_FAIL;
+}
+
+static bool ksz9x31_cable_test_fault_length_valid(u16 status)
+{
+	switch (FIELD_GET(KSZ9x31_LMD_VCT_ST_MASK, status)) {
+	case KSZ9x31_LMD_VCT_ST_OPEN:
+		fallthrough;
+	case KSZ9x31_LMD_VCT_ST_SHORT:
+		return true;
+	}
+	return false;
+}
+
+static int ksz9x31_cable_test_fault_length(struct phy_device *phydev, u16 stat)
+{
+	int dt = FIELD_GET(KSZ9x31_LMD_VCT_DATA_MASK, stat);
+
+	/* KSZ9131RNX, DS00002841B-page 38, 4.14 LinkMD (R) Cable Diagnostic
+	 *
+	 * distance to fault = (VCT_DATA - 22) * 4 / cable propagation velocity
+	 */
+	if ((phydev->phy_id & MICREL_PHY_ID_MASK) == PHY_ID_KSZ9131)
+		dt = clamp(dt - 22, 0, 255);
+
+	return (dt * 400) / 10;
+}
+
+static int ksz9x31_cable_test_wait_for_completion(struct phy_device *phydev)
+{
+	int val, ret;
+
+	ret = phy_read_poll_timeout(phydev, KSZ9x31_LMD, val,
+				    !(val & KSZ9x31_LMD_VCT_EN),
+				    30000, 100000, true);
+
+	return ret < 0 ? ret : 0;
+}
+
+static int ksz9x31_cable_test_get_pair(int pair)
+{
+	static const int ethtool_pair[] = {
+		ETHTOOL_A_CABLE_PAIR_A,
+		ETHTOOL_A_CABLE_PAIR_B,
+		ETHTOOL_A_CABLE_PAIR_C,
+		ETHTOOL_A_CABLE_PAIR_D,
+	};
+
+	return ethtool_pair[pair];
+}
+
+static int ksz9x31_cable_test_one_pair(struct phy_device *phydev, int pair)
+{
+	int ret, val;
+
+	/* KSZ9131RNX, DS00002841B-page 38, 4.14 LinkMD (R) Cable Diagnostic
+	 * To test each individual cable pair, set the cable pair in the Cable
+	 * Diagnostics Test Pair (VCT_PAIR[1:0]) field of the LinkMD Cable
+	 * Diagnostic Register, along with setting the Cable Diagnostics Test
+	 * Enable (VCT_EN) bit. The Cable Diagnostics Test Enable (VCT_EN) bit
+	 * will self clear when the test is concluded.
+	 */
+	ret = phy_write(phydev, KSZ9x31_LMD,
+			KSZ9x31_LMD_VCT_EN | KSZ9x31_LMD_VCT_PAIR(pair));
+	if (ret)
+		return ret;
+
+	ret = ksz9x31_cable_test_wait_for_completion(phydev);
+	if (ret)
+		return ret;
+
+	val = phy_read(phydev, KSZ9x31_LMD);
+	if (val < 0)
+		return val;
+
+	if (ksz9x31_cable_test_failed(val))
+		return -EAGAIN;
+
+	ret = ethnl_cable_test_result(phydev,
+				      ksz9x31_cable_test_get_pair(pair),
+				      ksz9x31_cable_test_result_trans(val));
+	if (ret)
+		return ret;
+
+	if (!ksz9x31_cable_test_fault_length_valid(val))
+		return 0;
+
+	return ethnl_cable_test_fault_length(phydev,
+					     ksz9x31_cable_test_get_pair(pair),
+					     ksz9x31_cable_test_fault_length(phydev, val));
+}
+
+static int ksz9x31_cable_test_get_status(struct phy_device *phydev,
+					 bool *finished)
+{
+	unsigned long pair_mask = 0xf;
+	int retries = 20;
+	int pair, ret;
+
+	*finished = false;
+
+	/* Try harder if link partner is active */
+	while (pair_mask && retries--) {
+		for_each_set_bit(pair, &pair_mask, 4) {
+			ret = ksz9x31_cable_test_one_pair(phydev, pair);
+			if (ret == -EAGAIN)
+				continue;
+			if (ret < 0)
+				return ret;
+			clear_bit(pair, &pair_mask);
+		}
+		/* If link partner is in autonegotiation mode it will send 2ms
+		 * of FLPs with at least 6ms of silence.
+		 * Add 2ms sleep to have better chances to hit this silence.
+		 */
+		if (pair_mask)
+			usleep_range(2000, 3000);
+	}
+
+	/* Report remaining unfinished pair result as unknown. */
+	for_each_set_bit(pair, &pair_mask, 4) {
+		ret = ethnl_cable_test_result(phydev,
+					      ksz9x31_cable_test_get_pair(pair),
+					      ETHTOOL_A_CABLE_RESULT_CODE_UNSPEC);
+	}
+
+	*finished = true;
+
+	return ret;
+}
+
 static int ksz8873mll_config_aneg(struct phy_device *phydev)
 {
 	return 0;
@@ -2806,6 +3004,7 @@ static struct phy_driver ksphy_driver[] = {
 	.phy_id		= PHY_ID_KSZ9031,
 	.phy_id_mask	= MICREL_PHY_ID_MASK,
 	.name		= "Micrel KSZ9031 Gigabit PHY",
+	.flags		= PHY_POLL_CABLE_TEST,
 	.driver_data	= &ksz9021_type,
 	.probe		= kszphy_probe,
 	.get_features	= ksz9031_get_features,
@@ -2819,6 +3018,8 @@ static struct phy_driver ksphy_driver[] = {
 	.get_stats	= kszphy_get_stats,
 	.suspend	= kszphy_suspend,
 	.resume		= kszphy_resume,
+	.cable_test_start	= ksz9x31_cable_test_start,
+	.cable_test_get_status	= ksz9x31_cable_test_get_status,
 }, {
 	.phy_id		= PHY_ID_LAN8814,
 	.phy_id_mask	= MICREL_PHY_ID_MASK,
@@ -2853,6 +3054,7 @@ static struct phy_driver ksphy_driver[] = {
 	.phy_id_mask	= MICREL_PHY_ID_MASK,
 	.name		= "Microchip KSZ9131 Gigabit PHY",
 	/* PHY_GBIT_FEATURES */
+	.flags		= PHY_POLL_CABLE_TEST,
 	.driver_data	= &ksz9021_type,
 	.probe		= kszphy_probe,
 	.config_init	= ksz9131_config_init,
@@ -2863,6 +3065,8 @@ static struct phy_driver ksphy_driver[] = {
 	.get_stats	= kszphy_get_stats,
 	.suspend	= kszphy_suspend,
 	.resume		= kszphy_resume,
+	.cable_test_start	= ksz9x31_cable_test_start,
+	.cable_test_get_status	= ksz9x31_cable_test_get_status,
 }, {
 	.phy_id		= PHY_ID_KSZ8873MLL,
 	.phy_id_mask	= MICREL_PHY_ID_MASK,
-- 
2.35.1

