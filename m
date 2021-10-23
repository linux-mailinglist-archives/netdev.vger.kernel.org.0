Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 58A474382F1
	for <lists+netdev@lfdr.de>; Sat, 23 Oct 2021 11:56:39 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232526AbhJWJ6q (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sat, 23 Oct 2021 05:58:46 -0400
Received: from m43-7.mailgun.net ([69.72.43.7]:63274 "EHLO m43-7.mailgun.net"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S231732AbhJWJ6F (ORCPT <rfc822;netdev@vger.kernel.org>);
        Sat, 23 Oct 2021 05:58:05 -0400
DKIM-Signature: a=rsa-sha256; v=1; c=relaxed/relaxed; d=mg.codeaurora.org; q=dns/txt;
 s=smtp; t=1634982946; h=References: In-Reply-To: Message-Id: Date:
 Subject: Cc: To: From: Sender;
 bh=VvWNLqPUD/ffsqcY9IXsMuvidL/zUK3rPrlUhC0hWyU=; b=hV+kVOE9v2wlTKPTlTtT8ayjvNtcVhZHvDhdlEv1BlkclnUiFiAB1reBgl/I3tjfmBD514+o
 LX382tFhStxD6Q9vBsc1lVcONi07jZ/+1KXNtmNWL8yA65bATKGJD3FqVV52646myTX/1Mzb
 Ugni7yXfwlwXrPSzA7r2Wr6yYVo=
X-Mailgun-Sending-Ip: 69.72.43.7
X-Mailgun-Sid: WyJiZjI2MiIsICJuZXRkZXZAdmdlci5rZXJuZWwub3JnIiwgImJlOWU0YSJd
Received: from smtp.codeaurora.org
 (ec2-35-166-182-171.us-west-2.compute.amazonaws.com [35.166.182.171]) by
 smtp-out-n06.prod.us-west-2.postgun.com with SMTP id
 6173dc205baa84c77bb9bdb8 (version=TLS1.2,
 cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256); Sat, 23 Oct 2021 09:55:43
 GMT
Sender: luoj=codeaurora.org@mg.codeaurora.org
Received: by smtp.codeaurora.org (Postfix, from userid 1001)
        id BD2ECC14909; Sat, 23 Oct 2021 09:55:43 +0000 (UTC)
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
        aws-us-west-2-caf-mail-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-2.9 required=2.0 tests=ALL_TRUSTED,BAYES_00,SPF_FAIL
        autolearn=no autolearn_force=no version=3.4.0
Received: from akronite-sh-dev02.qualcomm.com (unknown [180.166.53.21])
        (using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
        (No client certificate requested)
        (Authenticated sender: luoj)
        by smtp.codeaurora.org (Postfix) with ESMTPSA id 2943AC4314D;
        Sat, 23 Oct 2021 09:55:39 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.4.1 smtp.codeaurora.org 2943AC4314D
Authentication-Results: aws-us-west-2-caf-mail-1.web.codeaurora.org; dmarc=none (p=none dis=none) header.from=codeaurora.org
Authentication-Results: aws-us-west-2-caf-mail-1.web.codeaurora.org; spf=fail smtp.mailfrom=codeaurora.org
From:   Luo Jie <luoj@codeaurora.org>
To:     andrew@lunn.ch, hkallweit1@gmail.com, linux@armlinux.org.uk,
        davem@davemloft.net, kuba@kernel.org
Cc:     netdev@vger.kernel.org, linux-kernel@vger.kernel.org,
        sricharan@codeaurora.org, Luo Jie <luoj@codeaurora.org>
Subject: [PATCH v6 12/14] net: phy: add qca8081 soft_reset and enable master/slave seed
Date:   Sat, 23 Oct 2021 17:54:51 +0800
Message-Id: <20211023095453.22615-13-luoj@codeaurora.org>
X-Mailer: git-send-email 2.17.1
In-Reply-To: <20211023095453.22615-1-luoj@codeaurora.org>
References: <20211023095453.22615-1-luoj@codeaurora.org>
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
index da710523b7c4..1418db4f2091 100644
--- a/drivers/net/phy/at803x.c
+++ b/drivers/net/phy/at803x.c
@@ -223,6 +223,12 @@
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
@@ -1569,6 +1575,26 @@ static int qca808x_phy_fast_retrain_config(struct phy_device *phydev)
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
@@ -1590,6 +1616,16 @@ static int qca808x_config_init(struct phy_device *phydev)
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
@@ -1622,6 +1658,17 @@ static int qca808x_read_status(struct phy_device *phydev)
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
@@ -1797,6 +1844,7 @@ static struct phy_driver at803x_driver[] = {
 	.resume			= genphy_resume,
 	.read_status		= qca808x_read_status,
 	.config_init		= qca808x_config_init,
+	.soft_reset		= qca808x_soft_reset,
 }, };
 
 module_phy_driver(at803x_driver);
-- 
The Qualcomm Innovation Center, Inc. is a member of the Code Aurora Forum,
a Linux Foundation Collaborative Project

