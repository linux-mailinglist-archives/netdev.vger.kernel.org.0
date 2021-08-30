Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 2091E3FB45F
	for <lists+netdev@lfdr.de>; Mon, 30 Aug 2021 13:10:02 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S236554AbhH3LJK (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 30 Aug 2021 07:09:10 -0400
Received: from so254-9.mailgun.net ([198.61.254.9]:35170 "EHLO
        so254-9.mailgun.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S236522AbhH3LJE (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 30 Aug 2021 07:09:04 -0400
DKIM-Signature: a=rsa-sha256; v=1; c=relaxed/relaxed; d=mg.codeaurora.org; q=dns/txt;
 s=smtp; t=1630321691; h=References: In-Reply-To: Message-Id: Date:
 Subject: Cc: To: From: Sender;
 bh=D9LwRJ/Z7ug6AG8NlZV3FH3wQJPBdJPRe+4j8HRukTs=; b=CXwaivdIBxpBX9zta/vjukyyZDhszjB9mgoyTloyj9FnUNGPUqlhsdBMPIhPNrRP0TLvOyq/
 htdfVh25Ns0Suuc0CIr8dO5d/Kda18FA0Yr3L4Ca3gbwn35jIMUrH4Oi5L5eqKVpanC4fcY+
 TWE3RvolYof6LYwjoi8l3ciA4JQ=
X-Mailgun-Sending-Ip: 198.61.254.9
X-Mailgun-Sid: WyJiZjI2MiIsICJuZXRkZXZAdmdlci5rZXJuZWwub3JnIiwgImJlOWU0YSJd
Received: from smtp.codeaurora.org
 (ec2-35-166-182-171.us-west-2.compute.amazonaws.com [35.166.182.171]) by
 smtp-out-n02.prod.us-east-1.postgun.com with SMTP id
 612cbc066fc2cf7ad9cad41d (version=TLS1.2,
 cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256); Mon, 30 Aug 2021 11:07:50
 GMT
Sender: luoj=codeaurora.org@mg.codeaurora.org
Received: by smtp.codeaurora.org (Postfix, from userid 1001)
        id 44642C43460; Mon, 30 Aug 2021 11:07:49 +0000 (UTC)
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
        aws-us-west-2-caf-mail-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-2.9 required=2.0 tests=ALL_TRUSTED,BAYES_00,SPF_FAIL,
        URIBL_BLOCKED autolearn=no autolearn_force=no version=3.4.0
Received: from akronite-sh-dev02.qualcomm.com (unknown [180.166.53.21])
        (using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
        (No client certificate requested)
        (Authenticated sender: luoj)
        by smtp.codeaurora.org (Postfix) with ESMTPSA id 68C3CC43618;
        Mon, 30 Aug 2021 11:07:46 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.4.1 smtp.codeaurora.org 68C3CC43618
Authentication-Results: aws-us-west-2-caf-mail-1.web.codeaurora.org; dmarc=none (p=none dis=none) header.from=codeaurora.org
Authentication-Results: aws-us-west-2-caf-mail-1.web.codeaurora.org; spf=fail smtp.mailfrom=codeaurora.org
From:   Luo Jie <luoj@codeaurora.org>
To:     andrew@lunn.ch, hkallweit1@gmail.com, linux@armlinux.org.uk,
        davem@davemloft.net, kuba@kernel.org
Cc:     netdev@vger.kernel.org, linux-kernel@vger.kernel.org,
        sricharan@codeaurora.org, Luo Jie <luoj@codeaurora.org>
Subject: [PATCH v1 1/3] net: phy: improve the wol feature of at803x
Date:   Mon, 30 Aug 2021 19:07:31 +0800
Message-Id: <20210830110733.8964-2-luoj@codeaurora.org>
X-Mailer: git-send-email 2.17.1
In-Reply-To: <20210830110733.8964-1-luoj@codeaurora.org>
References: <20210830110733.8964-1-luoj@codeaurora.org>
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

wol is controlled by bit 5 of reg 3.8012, which should be
configured by set_wol of phy_driver.

Signed-off-by: Luo Jie <luoj@codeaurora.org>
---
 drivers/net/phy/at803x.c | 50 +++++++++++++++++++++++-----------------
 1 file changed, 29 insertions(+), 21 deletions(-)

diff --git a/drivers/net/phy/at803x.c b/drivers/net/phy/at803x.c
index 5d62b85a4024..ecae26f11aa4 100644
--- a/drivers/net/phy/at803x.c
+++ b/drivers/net/phy/at803x.c
@@ -70,10 +70,14 @@
 #define AT803X_CDT_STATUS_DELTA_TIME_MASK	GENMASK(7, 0)
 #define AT803X_LED_CONTROL			0x18
 
-#define AT803X_DEVICE_ADDR			0x03
+/* WOL control */
+#define AT803X_PHY_MMD3_WOL_CTRL		0x8012
+#define AT803X_WOL_EN				BIT(5)
+
 #define AT803X_LOC_MAC_ADDR_0_15_OFFSET		0x804C
 #define AT803X_LOC_MAC_ADDR_16_31_OFFSET	0x804B
 #define AT803X_LOC_MAC_ADDR_32_47_OFFSET	0x804A
+
 #define AT803X_REG_CHIP_CONFIG			0x1f
 #define AT803X_BT_BX_REG_SEL			0x8000
 
@@ -328,12 +332,6 @@ static int at803x_set_wol(struct phy_device *phydev,
 	struct net_device *ndev = phydev->attached_dev;
 	const u8 *mac;
 	int ret;
-	u32 value;
-	unsigned int i, offsets[] = {
-		AT803X_LOC_MAC_ADDR_32_47_OFFSET,
-		AT803X_LOC_MAC_ADDR_16_31_OFFSET,
-		AT803X_LOC_MAC_ADDR_0_15_OFFSET,
-	};
 
 	if (!ndev)
 		return -ENODEV;
@@ -344,23 +342,30 @@ static int at803x_set_wol(struct phy_device *phydev,
 		if (!is_valid_ether_addr(mac))
 			return -EINVAL;
 
-		for (i = 0; i < 3; i++)
-			phy_write_mmd(phydev, AT803X_DEVICE_ADDR, offsets[i],
-				      mac[(i * 2) + 1] | (mac[(i * 2)] << 8));
+		phy_write_mmd(phydev, MDIO_MMD_PCS, AT803X_LOC_MAC_ADDR_32_47_OFFSET,
+				mac[1] | (mac[0] << 8));
+		phy_write_mmd(phydev, MDIO_MMD_PCS, AT803X_LOC_MAC_ADDR_16_31_OFFSET,
+				mac[3] | (mac[2] << 8));
+		phy_write_mmd(phydev, MDIO_MMD_PCS, AT803X_LOC_MAC_ADDR_0_15_OFFSET,
+				mac[5] | (mac[4] << 8));
 
-		value = phy_read(phydev, AT803X_INTR_ENABLE);
-		value |= AT803X_INTR_ENABLE_WOL;
-		ret = phy_write(phydev, AT803X_INTR_ENABLE, value);
+		/* clear the pending interrupt */
+		phy_read(phydev, AT803X_INTR_STATUS);
+
+		ret = phy_modify(phydev, AT803X_INTR_ENABLE, 0, AT803X_INTR_ENABLE_WOL);
 		if (ret)
 			return ret;
-		value = phy_read(phydev, AT803X_INTR_STATUS);
+
+		ret = phy_modify_mmd(phydev, MDIO_MMD_PCS, AT803X_PHY_MMD3_WOL_CTRL,
+				0, AT803X_WOL_EN);
+
 	} else {
-		value = phy_read(phydev, AT803X_INTR_ENABLE);
-		value &= (~AT803X_INTR_ENABLE_WOL);
-		ret = phy_write(phydev, AT803X_INTR_ENABLE, value);
+		ret = phy_modify(phydev, AT803X_INTR_ENABLE, AT803X_INTR_ENABLE_WOL, 0);
 		if (ret)
 			return ret;
-		value = phy_read(phydev, AT803X_INTR_STATUS);
+
+		ret = phy_modify_mmd(phydev, MDIO_MMD_PCS, AT803X_PHY_MMD3_WOL_CTRL,
+				AT803X_WOL_EN, 0);
 	}
 
 	return ret;
@@ -369,13 +374,16 @@ static int at803x_set_wol(struct phy_device *phydev,
 static void at803x_get_wol(struct phy_device *phydev,
 			   struct ethtool_wolinfo *wol)
 {
-	u32 value;
+	int ret;
 
 	wol->supported = WAKE_MAGIC;
 	wol->wolopts = 0;
 
-	value = phy_read(phydev, AT803X_INTR_ENABLE);
-	if (value & AT803X_INTR_ENABLE_WOL)
+	ret = phy_read_mmd(phydev, MDIO_MMD_PCS, AT803X_PHY_MMD3_WOL_CTRL);
+	if (ret < 0)
+		return;
+
+	if (ret & AT803X_WOL_EN)
 		wol->wolopts |= WAKE_MAGIC;
 }
 
-- 
The Qualcomm Innovation Center, Inc. is a member of the Code Aurora Forum,
a Linux Foundation Collaborative Project

