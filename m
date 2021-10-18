Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 8783D430E43
	for <lists+netdev@lfdr.de>; Mon, 18 Oct 2021 05:35:49 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232204AbhJRDhH (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sun, 17 Oct 2021 23:37:07 -0400
Received: from m43-7.mailgun.net ([69.72.43.7]:34706 "EHLO m43-7.mailgun.net"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S232243AbhJRDgh (ORCPT <rfc822;netdev@vger.kernel.org>);
        Sun, 17 Oct 2021 23:36:37 -0400
DKIM-Signature: a=rsa-sha256; v=1; c=relaxed/relaxed; d=mg.codeaurora.org; q=dns/txt;
 s=smtp; t=1634528066; h=References: In-Reply-To: Message-Id: Date:
 Subject: Cc: To: From: Sender;
 bh=HeRig6MrrKDt5zqmiIWS9j52TyDTMcQTX2mWfD+2RT0=; b=kQ+AAo3PD7aSdL/gymaoXwSWLA2B8zN8Mq635EoGFeAY51GleBjldGH7dFdAUo2N2FzzRFyY
 5mhgIMecgj5FmMfLTcVZyzTWqnxzrOSavnGRgbfJ/biD+9CA2PJl86IsVnDm1UGgn2DAVTmR
 SIHs8OyrgvDJT5QlC1nAScEV+QA=
X-Mailgun-Sending-Ip: 69.72.43.7
X-Mailgun-Sid: WyJiZjI2MiIsICJuZXRkZXZAdmdlci5rZXJuZWwub3JnIiwgImJlOWU0YSJd
Received: from smtp.codeaurora.org
 (ec2-35-166-182-171.us-west-2.compute.amazonaws.com [35.166.182.171]) by
 smtp-out-n02.prod.us-west-2.postgun.com with SMTP id
 616ceb42f3e5b80f1fc96c53 (version=TLS1.2,
 cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256); Mon, 18 Oct 2021 03:34:26
 GMT
Sender: luoj=codeaurora.org@mg.codeaurora.org
Received: by smtp.codeaurora.org (Postfix, from userid 1001)
        id 338C4C4361C; Mon, 18 Oct 2021 03:34:26 +0000 (UTC)
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
        aws-us-west-2-caf-mail-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-2.9 required=2.0 tests=ALL_TRUSTED,BAYES_00,SPF_FAIL
        autolearn=no autolearn_force=no version=3.4.0
Received: from akronite-sh-dev02.qualcomm.com (unknown [180.166.53.21])
        (using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
        (No client certificate requested)
        (Authenticated sender: luoj)
        by smtp.codeaurora.org (Postfix) with ESMTPSA id 7D35FC43618;
        Mon, 18 Oct 2021 03:34:22 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.4.1 smtp.codeaurora.org 7D35FC43618
Authentication-Results: aws-us-west-2-caf-mail-1.web.codeaurora.org; dmarc=none (p=none dis=none) header.from=codeaurora.org
Authentication-Results: aws-us-west-2-caf-mail-1.web.codeaurora.org; spf=fail smtp.mailfrom=codeaurora.org
From:   Luo Jie <luoj@codeaurora.org>
To:     andrew@lunn.ch, hkallweit1@gmail.com, linux@armlinux.org.uk,
        davem@davemloft.net, kuba@kernel.org
Cc:     netdev@vger.kernel.org, linux-kernel@vger.kernel.org,
        sricharan@codeaurora.org, Luo Jie <luoj@codeaurora.org>
Subject: [PATCH v3 13/13] net: phy: add qca8081 cdt feature
Date:   Mon, 18 Oct 2021 11:33:33 +0800
Message-Id: <20211018033333.17677-14-luoj@codeaurora.org>
X-Mailer: git-send-email 2.17.1
In-Reply-To: <20211018033333.17677-1-luoj@codeaurora.org>
References: <20211018033333.17677-1-luoj@codeaurora.org>
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

To perform CDT of qca8081 phy:
1. disable hibernation.
2. force phy working in MDI mode.
3. force phy working in 1000BASE-T mode.
4. configure the related thresholds.

Signed-off-by: Luo Jie <luoj@codeaurora.org>
---
 drivers/net/phy/at803x.c | 193 ++++++++++++++++++++++++++++++++++++++-
 1 file changed, 190 insertions(+), 3 deletions(-)

diff --git a/drivers/net/phy/at803x.c b/drivers/net/phy/at803x.c
index 77aaf9e72781..f0928300b0d2 100644
--- a/drivers/net/phy/at803x.c
+++ b/drivers/net/phy/at803x.c
@@ -220,6 +220,32 @@
 #define QCA808X_MASTER_SLAVE_SEED_CFG		GENMASK(12, 2)
 #define QCA808X_MASTER_SLAVE_SEED_RANGE		0x32
 
+/* Hibernation yields lower power consumpiton in contrast with normal operation mode.
+ * when the copper cable is unplugged, the PHY enters into hibernation mode in about 10s.
+ */
+#define QCA808X_DBG_AN_TEST			0xb
+#define QCA808X_HIBERNATION_EN			BIT(15)
+
+#define QCA808X_CDT_ENABLE_TEST			BIT(15)
+#define QCA808X_CDT_INTER_CHECK_DIS		BIT(13)
+#define QCA808X_CDT_LENGTH_UNIT			BIT(10)
+
+#define QCA808X_MMD3_CDT_STATUS			0x8064
+#define QCA808X_MMD3_CDT_DIAG_PAIR_A		0x8065
+#define QCA808X_MMD3_CDT_DIAG_PAIR_B		0x8066
+#define QCA808X_MMD3_CDT_DIAG_PAIR_C		0x8067
+#define QCA808X_MMD3_CDT_DIAG_PAIR_D		0x8068
+#define QCA808X_CDT_DIAG_LENGTH			GENMASK(7, 0)
+
+#define QCA808X_CDT_CODE_PAIR_A			GENMASK(15, 12)
+#define QCA808X_CDT_CODE_PAIR_B			GENMASK(11, 8)
+#define QCA808X_CDT_CODE_PAIR_C			GENMASK(7, 4)
+#define QCA808X_CDT_CODE_PAIR_D			GENMASK(3, 0)
+#define QCA808X_CDT_STATUS_STAT_FAIL		0
+#define QCA808X_CDT_STATUS_STAT_NORMAL		1
+#define QCA808X_CDT_STATUS_STAT_OPEN		2
+#define QCA808X_CDT_STATUS_STAT_SHORT		3
+
 MODULE_DESCRIPTION("Qualcomm Atheros AR803x and QCA808X PHY driver");
 MODULE_AUTHOR("Matus Ujhelyi");
 MODULE_LICENSE("GPL");
@@ -1294,8 +1320,14 @@ static int at803x_cdt_start(struct phy_device *phydev, int pair)
 {
 	u16 cdt;
 
-	cdt = FIELD_PREP(AT803X_CDT_MDI_PAIR_MASK, pair) |
-	      AT803X_CDT_ENABLE_TEST;
+	/* qca8081 takes the different bit 15 to enable CDT test */
+	if (phydev->drv->phy_id == QCA8081_PHY_ID)
+		cdt = QCA808X_CDT_ENABLE_TEST |
+			QCA808X_CDT_LENGTH_UNIT |
+			QCA808X_CDT_INTER_CHECK_DIS;
+	else
+		cdt = FIELD_PREP(AT803X_CDT_MDI_PAIR_MASK, pair) |
+			AT803X_CDT_ENABLE_TEST;
 
 	return phy_write(phydev, AT803X_CDT, cdt);
 }
@@ -1303,10 +1335,16 @@ static int at803x_cdt_start(struct phy_device *phydev, int pair)
 static int at803x_cdt_wait_for_completion(struct phy_device *phydev)
 {
 	int val, ret;
+	u16 cdt_en;
+
+	if (phydev->drv->phy_id == QCA8081_PHY_ID)
+		cdt_en = QCA808X_CDT_ENABLE_TEST;
+	else
+		cdt_en = AT803X_CDT_ENABLE_TEST;
 
 	/* One test run takes about 25ms */
 	ret = phy_read_poll_timeout(phydev, AT803X_CDT, val,
-				    !(val & AT803X_CDT_ENABLE_TEST),
+				    !(val & cdt_en),
 				    30000, 100000, true);
 
 	return ret < 0 ? ret : 0;
@@ -1586,6 +1624,153 @@ static int qca808x_soft_reset(struct phy_device *phydev)
 	return qca808x_phy_ms_seed_enable(phydev, true);
 }
 
+static bool qca808x_cdt_fault_length_valid(int cdt_code)
+{
+	switch (cdt_code) {
+	case QCA808X_CDT_STATUS_STAT_SHORT:
+	case QCA808X_CDT_STATUS_STAT_OPEN:
+		return true;
+	default:
+		return false;
+	}
+}
+
+static int qca808x_cable_test_result_trans(int cdt_code)
+{
+	switch (cdt_code) {
+	case QCA808X_CDT_STATUS_STAT_NORMAL:
+		return ETHTOOL_A_CABLE_RESULT_CODE_OK;
+	case QCA808X_CDT_STATUS_STAT_SHORT:
+		return ETHTOOL_A_CABLE_RESULT_CODE_SAME_SHORT;
+	case QCA808X_CDT_STATUS_STAT_OPEN:
+		return ETHTOOL_A_CABLE_RESULT_CODE_OPEN;
+	case QCA808X_CDT_STATUS_STAT_FAIL:
+	default:
+		return ETHTOOL_A_CABLE_RESULT_CODE_UNSPEC;
+	}
+}
+
+static int qca808x_cdt_fault_length(struct phy_device *phydev, int pair)
+{
+	int val;
+	u32 cdt_length_reg = 0;
+
+	switch (pair) {
+	case ETHTOOL_A_CABLE_PAIR_A:
+		cdt_length_reg = QCA808X_MMD3_CDT_DIAG_PAIR_A;
+		break;
+	case ETHTOOL_A_CABLE_PAIR_B:
+		cdt_length_reg = QCA808X_MMD3_CDT_DIAG_PAIR_B;
+		break;
+	case ETHTOOL_A_CABLE_PAIR_C:
+		cdt_length_reg = QCA808X_MMD3_CDT_DIAG_PAIR_C;
+		break;
+	case ETHTOOL_A_CABLE_PAIR_D:
+		cdt_length_reg = QCA808X_MMD3_CDT_DIAG_PAIR_D;
+		break;
+	default:
+		return -EINVAL;
+	}
+
+	val = phy_read_mmd(phydev, MDIO_MMD_PCS, cdt_length_reg);
+	if (val < 0)
+		return val;
+
+	return (FIELD_GET(QCA808X_CDT_DIAG_LENGTH, val) * 824) / 10;
+}
+
+static int qca808x_cable_test_start(struct phy_device *phydev)
+{
+	int ret;
+
+	/* perform CDT with the following configs:
+	 * 1. disable hibernation.
+	 * 2. force PHY working in MDI mode.
+	 * 3. for PHY working in 1000BaseT.
+	 * 4. configure the threshold.
+	 */
+
+	ret = at803x_debug_reg_mask(phydev, QCA808X_DBG_AN_TEST, QCA808X_HIBERNATION_EN, 0);
+	if (ret < 0)
+		return ret;
+
+	ret = at803x_config_mdix(phydev, ETH_TP_MDI);
+	if (ret < 0)
+		return ret;
+
+	/* Force 1000base-T needs to configure PMA/PMD and MII_BMCR */
+	phydev->duplex = DUPLEX_FULL;
+	phydev->speed = SPEED_1000;
+	ret = genphy_c45_pma_setup_forced(phydev);
+	if (ret < 0)
+		return ret;
+
+	ret = genphy_setup_forced(phydev);
+	if (ret < 0)
+		return ret;
+
+	/* configure the thresholds for open, short, pair ok test */
+	phy_write_mmd(phydev, MDIO_MMD_PCS, 0x8074, 0xc040);
+	phy_write_mmd(phydev, MDIO_MMD_PCS, 0x8076, 0xc040);
+	phy_write_mmd(phydev, MDIO_MMD_PCS, 0x8077, 0xa060);
+	phy_write_mmd(phydev, MDIO_MMD_PCS, 0x8078, 0xc050);
+	phy_write_mmd(phydev, MDIO_MMD_PCS, 0x807a, 0xc060);
+	phy_write_mmd(phydev, MDIO_MMD_PCS, 0x807e, 0xb060);
+
+	return 0;
+}
+
+static int qca808x_cable_test_get_status(struct phy_device *phydev, bool *finished)
+{
+	int ret, val;
+	int pair_a, pair_b, pair_c, pair_d;
+
+	*finished = false;
+
+	ret = at803x_cdt_start(phydev, 0);
+	if (ret)
+		return ret;
+
+	ret = at803x_cdt_wait_for_completion(phydev);
+	if (ret)
+		return ret;
+
+	val = phy_read_mmd(phydev, MDIO_MMD_PCS, QCA808X_MMD3_CDT_STATUS);
+	if (val < 0)
+		return val;
+
+	pair_a = FIELD_GET(QCA808X_CDT_CODE_PAIR_A, val);
+	pair_b = FIELD_GET(QCA808X_CDT_CODE_PAIR_B, val);
+	pair_c = FIELD_GET(QCA808X_CDT_CODE_PAIR_C, val);
+	pair_d = FIELD_GET(QCA808X_CDT_CODE_PAIR_D, val);
+
+	ethnl_cable_test_result(phydev, ETHTOOL_A_CABLE_PAIR_A,
+				qca808x_cable_test_result_trans(pair_a));
+	ethnl_cable_test_result(phydev, ETHTOOL_A_CABLE_PAIR_B,
+				qca808x_cable_test_result_trans(pair_b));
+	ethnl_cable_test_result(phydev, ETHTOOL_A_CABLE_PAIR_C,
+				qca808x_cable_test_result_trans(pair_c));
+	ethnl_cable_test_result(phydev, ETHTOOL_A_CABLE_PAIR_D,
+				qca808x_cable_test_result_trans(pair_d));
+
+	if (qca808x_cdt_fault_length_valid(pair_a))
+		ethnl_cable_test_fault_length(phydev, ETHTOOL_A_CABLE_PAIR_A,
+				qca808x_cdt_fault_length(phydev, ETHTOOL_A_CABLE_PAIR_A));
+	if (qca808x_cdt_fault_length_valid(pair_b))
+		ethnl_cable_test_fault_length(phydev, ETHTOOL_A_CABLE_PAIR_B,
+				qca808x_cdt_fault_length(phydev, ETHTOOL_A_CABLE_PAIR_B));
+	if (qca808x_cdt_fault_length_valid(pair_c))
+		ethnl_cable_test_fault_length(phydev, ETHTOOL_A_CABLE_PAIR_C,
+				qca808x_cdt_fault_length(phydev, ETHTOOL_A_CABLE_PAIR_C));
+	if (qca808x_cdt_fault_length_valid(pair_d))
+		ethnl_cable_test_fault_length(phydev, ETHTOOL_A_CABLE_PAIR_D,
+				qca808x_cdt_fault_length(phydev, ETHTOOL_A_CABLE_PAIR_D));
+
+	*finished = true;
+
+	return 0;
+}
+
 static struct phy_driver at803x_driver[] = {
 {
 	/* Qualcomm Atheros AR8035 */
@@ -1712,6 +1897,8 @@ static struct phy_driver at803x_driver[] = {
 	.read_status		= qca808x_read_status,
 	.config_init		= qca808x_config_init,
 	.soft_reset		= qca808x_soft_reset,
+	.cable_test_start	= qca808x_cable_test_start,
+	.cable_test_get_status	= qca808x_cable_test_get_status,
 }, };
 
 module_phy_driver(at803x_driver);
-- 
The Qualcomm Innovation Center, Inc. is a member of the Code Aurora Forum,
a Linux Foundation Collaborative Project

