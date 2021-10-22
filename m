Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id D977D437674
	for <lists+netdev@lfdr.de>; Fri, 22 Oct 2021 14:07:37 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232057AbhJVMJo (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 22 Oct 2021 08:09:44 -0400
Received: from m43-7.mailgun.net ([69.72.43.7]:28270 "EHLO m43-7.mailgun.net"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S232002AbhJVMJb (ORCPT <rfc822;netdev@vger.kernel.org>);
        Fri, 22 Oct 2021 08:09:31 -0400
DKIM-Signature: a=rsa-sha256; v=1; c=relaxed/relaxed; d=mg.codeaurora.org; q=dns/txt;
 s=smtp; t=1634904434; h=References: In-Reply-To: Message-Id: Date:
 Subject: Cc: To: From: Sender;
 bh=8TatcyQtHqdTwaiNa6sZozp1ZNwHznHI9aOJxRlhD8k=; b=TEWZzI6fogmDHDTdan6hTi4SnCOWa12uNDkbHmddbQDz3YGlmLTaTyZP3E2UnXzRJZR8hTe6
 naRKBtMat82NTtN2rXTcxTmuyXFthN/WIhESxcD57VXqKB5fLedC7mKxuaQY5THsDVe4Gq0m
 LSku1i9tRIxYVrk6JWtg3uM259Q=
X-Mailgun-Sending-Ip: 69.72.43.7
X-Mailgun-Sid: WyJiZjI2MiIsICJuZXRkZXZAdmdlci5rZXJuZWwub3JnIiwgImJlOWU0YSJd
Received: from smtp.codeaurora.org
 (ec2-35-166-182-171.us-west-2.compute.amazonaws.com [35.166.182.171]) by
 smtp-out-n02.prod.us-east-1.postgun.com with SMTP id
 6172a96fc75c436a30922b8a (version=TLS1.2,
 cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256); Fri, 22 Oct 2021 12:07:11
 GMT
Sender: luoj=codeaurora.org@mg.codeaurora.org
Received: by smtp.codeaurora.org (Postfix, from userid 1001)
        id D1B2CC43635; Fri, 22 Oct 2021 12:07:10 +0000 (UTC)
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
        aws-us-west-2-caf-mail-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-2.9 required=2.0 tests=ALL_TRUSTED,BAYES_00,SPF_FAIL,
        URIBL_BLOCKED autolearn=no autolearn_force=no version=3.4.0
Received: from akronite-sh-dev02.qualcomm.com (unknown [180.166.53.21])
        (using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
        (No client certificate requested)
        (Authenticated sender: luoj)
        by smtp.codeaurora.org (Postfix) with ESMTPSA id 4925FC4360D;
        Fri, 22 Oct 2021 12:07:07 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.4.1 smtp.codeaurora.org 4925FC4360D
Authentication-Results: aws-us-west-2-caf-mail-1.web.codeaurora.org; dmarc=none (p=none dis=none) header.from=codeaurora.org
Authentication-Results: aws-us-west-2-caf-mail-1.web.codeaurora.org; spf=fail smtp.mailfrom=codeaurora.org
From:   Luo Jie <luoj@codeaurora.org>
To:     andrew@lunn.ch, hkallweit1@gmail.com, linux@armlinux.org.uk,
        davem@davemloft.net, kuba@kernel.org
Cc:     netdev@vger.kernel.org, linux-kernel@vger.kernel.org,
        sricharan@codeaurora.org, Luo Jie <luoj@codeaurora.org>
Subject: [PATCH v4 12/14] net: phy: add qca8081 soft_reset and enable master/slave seed
Date:   Fri, 22 Oct 2021 20:06:22 +0800
Message-Id: <20211022120624.18069-13-luoj@codeaurora.org>
X-Mailer: git-send-email 2.17.1
In-Reply-To: <20211022120624.18069-1-luoj@codeaurora.org>
References: <20211022120624.18069-1-luoj@codeaurora.org>
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

qca8081 phy is a single port phy, configure
phy the lower seed value to make it linked as slave
mode easier.

Signed-off-by: Luo Jie <luoj@codeaurora.org>
---
 drivers/net/phy/at803x.c | 48 ++++++++++++++++++++++++++++++++++++++++
 1 file changed, 48 insertions(+)

diff --git a/drivers/net/phy/at803x.c b/drivers/net/phy/at803x.c
index 3096ed51dbae..f372f6ab78f6 100644
--- a/drivers/net/phy/at803x.c
+++ b/drivers/net/phy/at803x.c
@@ -215,6 +215,12 @@
 #define QCA808X_PHY_MMD3_DEBUG_6		0xa011
 #define QCA808X_MMD3_DEBUG_6_VALUE		0x5f85
 
+/* master/slave seed config */
+#define QCA808X_PHY_DEBUG_LOCAL_SEED		9
+#define QCA808X_MASTER_SLAVE_SEED_ENABLE	BIT(1)
+#define QCA808X_MASTER_SLAVE_SEED_CFG		GENMASK(12, 2)
+#define QCA808X_MASTER_SLAVE_SEED_RANGE		0x32
+
 MODULE_DESCRIPTION("Qualcomm Atheros AR803x and QCA808X PHY driver");
 MODULE_AUTHOR("Matus Ujhelyi");
 MODULE_LICENSE("GPL");
@@ -1476,6 +1482,26 @@ static int qca808x_phy_fast_retrain_config(struct phy_device *phydev)
 	return 0;
 }
 
+static int qca808x_phy_ms_random_seed_set(struct phy_device *phydev)
+{
+	u16 seed_value = (prandom_u32() % QCA808X_MASTER_SLAVE_SEED_RANGE);
+
+	return at803x_debug_reg_mask(phydev, QCA808X_PHY_DEBUG_LOCAL_SEED,
+			QCA808X_MASTER_SLAVE_SEED_CFG,
+			FIELD_PREP(QCA808X_MASTER_SLAVE_SEED_CFG, seed_value));
+}
+
+static int qca808x_phy_ms_seed_enable(struct phy_device *phydev, bool enable)
+{
+	u16 seed_enable = 0;
+
+	if (enable)
+		seed_enable = QCA808X_MASTER_SLAVE_SEED_ENABLE;
+
+	return at803x_debug_reg_mask(phydev, QCA808X_PHY_DEBUG_LOCAL_SEED,
+			QCA808X_MASTER_SLAVE_SEED_ENABLE, seed_enable);
+}
+
 static int qca808x_config_init(struct phy_device *phydev)
 {
 	int ret;
@@ -1497,6 +1523,16 @@ static int qca808x_config_init(struct phy_device *phydev)
 	if (ret)
 		return ret;
 
+	/* Configure lower ramdom seed to make phy linked as slave mode */
+	ret = qca808x_phy_ms_random_seed_set(phydev);
+	if (ret)
+		return ret;
+
+	/* Enable seed */
+	ret = qca808x_phy_ms_seed_enable(phydev, true);
+	if (ret)
+		return ret;
+
 	/* Configure adc threshold as 100mv for the link 10M */
 	return at803x_debug_reg_mask(phydev, QCA808X_PHY_DEBUG_ADC_THRESHOLD,
 			QCA808X_ADC_THRESHOLD_MASK, QCA808X_ADC_THRESHOLD_100MV);
@@ -1529,6 +1565,17 @@ static int qca808x_read_status(struct phy_device *phydev)
 	return 0;
 }
 
+static int qca808x_soft_reset(struct phy_device *phydev)
+{
+	int ret;
+
+	ret = genphy_soft_reset(phydev);
+	if (ret < 0)
+		return ret;
+
+	return qca808x_phy_ms_seed_enable(phydev, true);
+}
+
 static struct phy_driver at803x_driver[] = {
 {
 	/* Qualcomm Atheros AR8035 */
@@ -1686,6 +1733,7 @@ static struct phy_driver at803x_driver[] = {
 	.resume			= genphy_resume,
 	.read_status		= qca808x_read_status,
 	.config_init		= qca808x_config_init,
+	.soft_reset		= qca808x_soft_reset,
 }, };
 
 module_phy_driver(at803x_driver);
-- 
The Qualcomm Innovation Center, Inc. is a member of the Code Aurora Forum,
a Linux Foundation Collaborative Project

