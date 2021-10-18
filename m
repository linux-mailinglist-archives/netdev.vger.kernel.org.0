Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 73C48430E45
	for <lists+netdev@lfdr.de>; Mon, 18 Oct 2021 05:35:50 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232739AbhJRDhJ (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sun, 17 Oct 2021 23:37:09 -0400
Received: from m43-7.mailgun.net ([69.72.43.7]:47026 "EHLO m43-7.mailgun.net"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S232182AbhJRDgi (ORCPT <rfc822;netdev@vger.kernel.org>);
        Sun, 17 Oct 2021 23:36:38 -0400
DKIM-Signature: a=rsa-sha256; v=1; c=relaxed/relaxed; d=mg.codeaurora.org; q=dns/txt;
 s=smtp; t=1634528068; h=References: In-Reply-To: Message-Id: Date:
 Subject: Cc: To: From: Sender;
 bh=7BgjhW+OLQfOhbOZEXqCbTOamM6MjGLikMr/qpNeTgQ=; b=SwzQNJ/QS2D/p5ax4GQYF7ToHcJvvtbLXGGqaNvGeIlC8RAOqjwjEDecD04GJ3t1xdJbr9vh
 tbJKCbueO6z5P2TJnpB381XJjJwnbIM6PBVddb6esP7LIulPKSi+mYtEPntgkvuyjuwJOfW1
 DFpr2AAckLUAWJ9vWDWz+qUYciM=
X-Mailgun-Sending-Ip: 69.72.43.7
X-Mailgun-Sid: WyJiZjI2MiIsICJuZXRkZXZAdmdlci5rZXJuZWwub3JnIiwgImJlOWU0YSJd
Received: from smtp.codeaurora.org
 (ec2-35-166-182-171.us-west-2.compute.amazonaws.com [35.166.182.171]) by
 smtp-out-n02.prod.us-east-1.postgun.com with SMTP id
 616ceb3aab9da96e6462150b (version=TLS1.2,
 cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256); Mon, 18 Oct 2021 03:34:18
 GMT
Sender: luoj=codeaurora.org@mg.codeaurora.org
Received: by smtp.codeaurora.org (Postfix, from userid 1001)
        id E4850C4361B; Mon, 18 Oct 2021 03:34:17 +0000 (UTC)
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
        aws-us-west-2-caf-mail-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-2.9 required=2.0 tests=ALL_TRUSTED,BAYES_00,SPF_FAIL
        autolearn=no autolearn_force=no version=3.4.0
Received: from akronite-sh-dev02.qualcomm.com (unknown [180.166.53.21])
        (using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
        (No client certificate requested)
        (Authenticated sender: luoj)
        by smtp.codeaurora.org (Postfix) with ESMTPSA id D66D1C4360D;
        Mon, 18 Oct 2021 03:34:14 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.4.1 smtp.codeaurora.org D66D1C4360D
Authentication-Results: aws-us-west-2-caf-mail-1.web.codeaurora.org; dmarc=none (p=none dis=none) header.from=codeaurora.org
Authentication-Results: aws-us-west-2-caf-mail-1.web.codeaurora.org; spf=fail smtp.mailfrom=codeaurora.org
From:   Luo Jie <luoj@codeaurora.org>
To:     andrew@lunn.ch, hkallweit1@gmail.com, linux@armlinux.org.uk,
        davem@davemloft.net, kuba@kernel.org
Cc:     netdev@vger.kernel.org, linux-kernel@vger.kernel.org,
        sricharan@codeaurora.org, Luo Jie <luoj@codeaurora.org>
Subject: [PATCH v3 10/13] net: phy: add qca8081 config_init
Date:   Mon, 18 Oct 2021 11:33:30 +0800
Message-Id: <20211018033333.17677-11-luoj@codeaurora.org>
X-Mailer: git-send-email 2.17.1
In-Reply-To: <20211018033333.17677-1-luoj@codeaurora.org>
References: <20211018033333.17677-1-luoj@codeaurora.org>
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Add the qca8081 phy driver config_init function, which includes:
1. Enable fast restrain.
2. Add 802.3az configurations.
3. initialize ADC threshold as 100mv.

Signed-off-by: Luo Jie <luoj@codeaurora.org>
---
 drivers/net/phy/at803x.c | 119 +++++++++++++++++++++++++++++++++++++++
 1 file changed, 119 insertions(+)

diff --git a/drivers/net/phy/at803x.c b/drivers/net/phy/at803x.c
index c124d3fe40fb..8ab2084b9614 100644
--- a/drivers/net/phy/at803x.c
+++ b/drivers/net/phy/at803x.c
@@ -169,6 +169,51 @@
 #define AT803X_KEEP_PLL_ENABLED			BIT(0)
 #define AT803X_DISABLE_SMARTEEE			BIT(1)
 
+/* ADC threshold */
+#define QCA808X_PHY_DEBUG_ADC_THRESHOLD		0x2c80
+#define QCA808X_ADC_THRESHOLD_MASK		GENMASK(7, 0)
+#define QCA808X_ADC_THRESHOLD_80MV		0
+#define QCA808X_ADC_THRESHOLD_100MV		0xf0
+#define QCA808X_ADC_THRESHOLD_200MV		0x0f
+#define QCA808X_ADC_THRESHOLD_300MV		0xff
+
+/* CLD control */
+#define QCA808X_PHY_MMD3_ADDR_CLD_CTRL7		0x8007
+#define QCA808X_8023AZ_AFE_CTRL_MASK		GENMASK(8, 4)
+#define QCA808X_8023AZ_AFE_EN			0x90
+
+/* AZ control */
+#define QCA808X_PHY_MMD3_AZ_TRAINING_CTRL	0x8008
+#define QCA808X_MMD3_AZ_TRAINING_VAL		0x1c32
+
+#define QCA808X_PHY_MMD1_MSE_THRESHOLD_20DB	0x8014
+#define QCA808X_MSE_THRESHOLD_20DB_VALUE	0x529
+
+#define QCA808X_PHY_MMD1_MSE_THRESHOLD_17DB	0x800E
+#define QCA808X_MSE_THRESHOLD_17DB_VALUE	0x341
+
+#define QCA808X_PHY_MMD1_MSE_THRESHOLD_27DB	0x801E
+#define QCA808X_MSE_THRESHOLD_27DB_VALUE	0x419
+
+#define QCA808X_PHY_MMD1_MSE_THRESHOLD_28DB	0x8020
+#define QCA808X_MSE_THRESHOLD_28DB_VALUE	0x341
+
+#define QCA808X_PHY_MMD7_TOP_OPTION1		0x901c
+#define QCA808X_TOP_OPTION1_DATA		0x0
+
+#define QCA808X_PHY_MMD3_DEBUG_1		0xa100
+#define QCA808X_MMD3_DEBUG_1_VALUE		0x9203
+#define QCA808X_PHY_MMD3_DEBUG_2		0xa101
+#define QCA808X_MMD3_DEBUG_2_VALUE		0x48ad
+#define QCA808X_PHY_MMD3_DEBUG_3		0xa103
+#define QCA808X_MMD3_DEBUG_3_VALUE		0x1698
+#define QCA808X_PHY_MMD3_DEBUG_4		0xa105
+#define QCA808X_MMD3_DEBUG_4_VALUE		0x8001
+#define QCA808X_PHY_MMD3_DEBUG_5		0xa106
+#define QCA808X_MMD3_DEBUG_5_VALUE		0x1111
+#define QCA808X_PHY_MMD3_DEBUG_6		0xa011
+#define QCA808X_MMD3_DEBUG_6_VALUE		0x5f85
+
 MODULE_DESCRIPTION("Qualcomm Atheros AR803x and QCA808X PHY driver");
 MODULE_AUTHOR("Matus Ujhelyi");
 MODULE_LICENSE("GPL");
@@ -1379,6 +1424,79 @@ static int qca83xx_config_init(struct phy_device *phydev)
 	return 0;
 }
 
+static int qca808x_phy_fast_retrain_config(struct phy_device *phydev)
+{
+	int ret;
+
+	ret = phy_write_mmd(phydev, MDIO_MMD_AN, MDIO_AN_10GBT_CTRL,
+			MDIO_AN_10GBT_CTRL_ADV2_5G |
+			MDIO_AN_10GBT_CTRL_ADVFSRT2_5G |
+			MDIO_AN_10GBT_CTRL_ADVLPTIMING);
+	if (ret)
+		return ret;
+
+	ret = phy_write_mmd(phydev, MDIO_MMD_PMAPMD, MDIO_PMA_10GBR_FSRT_CSR,
+			MDIO_PMA_10GBR_FSRT_ENABLE);
+	if (ret)
+		return ret;
+
+	ret = phy_write_mmd(phydev, MDIO_MMD_AN, MDIO_AN_CTRL2, MDIO_AN_THP_BP2_5GT);
+	if (ret)
+		return ret;
+
+	phy_write_mmd(phydev, MDIO_MMD_AN, QCA808X_PHY_MMD7_TOP_OPTION1,
+			QCA808X_TOP_OPTION1_DATA);
+
+	phy_write_mmd(phydev, MDIO_MMD_PMAPMD, QCA808X_PHY_MMD1_MSE_THRESHOLD_20DB,
+			QCA808X_MSE_THRESHOLD_20DB_VALUE);
+	phy_write_mmd(phydev, MDIO_MMD_PMAPMD, QCA808X_PHY_MMD1_MSE_THRESHOLD_17DB,
+			QCA808X_MSE_THRESHOLD_17DB_VALUE);
+	phy_write_mmd(phydev, MDIO_MMD_PMAPMD, QCA808X_PHY_MMD1_MSE_THRESHOLD_27DB,
+			QCA808X_MSE_THRESHOLD_27DB_VALUE);
+	phy_write_mmd(phydev, MDIO_MMD_PMAPMD, QCA808X_PHY_MMD1_MSE_THRESHOLD_28DB,
+			QCA808X_MSE_THRESHOLD_28DB_VALUE);
+	phy_write_mmd(phydev, MDIO_MMD_PCS, QCA808X_PHY_MMD3_DEBUG_1,
+			QCA808X_MMD3_DEBUG_1_VALUE);
+	phy_write_mmd(phydev, MDIO_MMD_PCS, QCA808X_PHY_MMD3_DEBUG_4,
+			QCA808X_MMD3_DEBUG_4_VALUE);
+	phy_write_mmd(phydev, MDIO_MMD_PCS, QCA808X_PHY_MMD3_DEBUG_5,
+			QCA808X_MMD3_DEBUG_5_VALUE);
+	phy_write_mmd(phydev, MDIO_MMD_PCS, QCA808X_PHY_MMD3_DEBUG_3,
+			QCA808X_MMD3_DEBUG_3_VALUE);
+	phy_write_mmd(phydev, MDIO_MMD_PCS, QCA808X_PHY_MMD3_DEBUG_6,
+			QCA808X_MMD3_DEBUG_6_VALUE);
+	phy_write_mmd(phydev, MDIO_MMD_PCS, QCA808X_PHY_MMD3_DEBUG_2,
+			QCA808X_MMD3_DEBUG_2_VALUE);
+
+	return 0;
+}
+
+static int qca808x_config_init(struct phy_device *phydev)
+{
+	int ret;
+
+	/* Active adc&vga on 802.3az for the link 1000M and 100M */
+	ret = phy_modify_mmd(phydev, MDIO_MMD_PCS, QCA808X_PHY_MMD3_ADDR_CLD_CTRL7,
+			QCA808X_8023AZ_AFE_CTRL_MASK, QCA808X_8023AZ_AFE_EN);
+	if (ret)
+		return ret;
+
+	/* Adjust the threshold on 802.3az for the link 1000M */
+	ret = phy_write_mmd(phydev, MDIO_MMD_PCS,
+			QCA808X_PHY_MMD3_AZ_TRAINING_CTRL, QCA808X_MMD3_AZ_TRAINING_VAL);
+	if (ret)
+		return ret;
+
+	/* Config the fast retrain for the link 2500M */
+	ret = qca808x_phy_fast_retrain_config(phydev);
+	if (ret)
+		return ret;
+
+	/* Configure adc threshold as 100mv for the link 10M */
+	return at803x_debug_reg_mask(phydev, QCA808X_PHY_DEBUG_ADC_THRESHOLD,
+			QCA808X_ADC_THRESHOLD_MASK, QCA808X_ADC_THRESHOLD_100MV);
+}
+
 static int qca808x_read_status(struct phy_device *phydev)
 {
 	int ret;
@@ -1530,6 +1648,7 @@ static struct phy_driver at803x_driver[] = {
 	.suspend		= genphy_suspend,
 	.resume			= genphy_resume,
 	.read_status		= qca808x_read_status,
+	.config_init		= qca808x_config_init,
 }, };
 
 module_phy_driver(at803x_driver);
-- 
The Qualcomm Innovation Center, Inc. is a member of the Code Aurora Forum,
a Linux Foundation Collaborative Project

