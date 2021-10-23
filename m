Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 9123343817C
	for <lists+netdev@lfdr.de>; Sat, 23 Oct 2021 05:24:44 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229968AbhJWD07 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 22 Oct 2021 23:26:59 -0400
Received: from m43-7.mailgun.net ([69.72.43.7]:21269 "EHLO m43-7.mailgun.net"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S230452AbhJWD0w (ORCPT <rfc822;netdev@vger.kernel.org>);
        Fri, 22 Oct 2021 23:26:52 -0400
DKIM-Signature: a=rsa-sha256; v=1; c=relaxed/relaxed; d=mg.codeaurora.org; q=dns/txt;
 s=smtp; t=1634959474; h=References: In-Reply-To: Message-Id: Date:
 Subject: Cc: To: From: Sender;
 bh=NHBkFIkEUxs4F4vGpoDsXf5AEAu7yjRN/uadj2lZmns=; b=aqj2ES+zQ/S8m+7uYVA8SOqjoW0nRgev06PtBQZsRjh3feb4hatr/GImXx1+sxePbnELBHfR
 3TbCDrsObdjs2AnjtSNlm7+L7hXH7qM1RLQYOCeTyQ9d4dLN5fxJ0DqgM9VX8yb10UvRz0bz
 11r7vVBjAtWxsxUYMY25jnFb8WU=
X-Mailgun-Sending-Ip: 69.72.43.7
X-Mailgun-Sid: WyJiZjI2MiIsICJuZXRkZXZAdmdlci5rZXJuZWwub3JnIiwgImJlOWU0YSJd
Received: from smtp.codeaurora.org
 (ec2-35-166-182-171.us-west-2.compute.amazonaws.com [35.166.182.171]) by
 smtp-out-n04.prod.us-east-1.postgun.com with SMTP id
 61738071c75c436a3094bc00 (version=TLS1.2,
 cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256); Sat, 23 Oct 2021 03:24:33
 GMT
Sender: luoj=codeaurora.org@mg.codeaurora.org
Received: by smtp.codeaurora.org (Postfix, from userid 1001)
        id 46BE5C43616; Sat, 23 Oct 2021 03:24:33 +0000 (UTC)
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
        aws-us-west-2-caf-mail-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-2.9 required=2.0 tests=ALL_TRUSTED,BAYES_00,SPF_FAIL
        autolearn=no autolearn_force=no version=3.4.0
Received: from akronite-sh-dev02.qualcomm.com (unknown [180.166.53.21])
        (using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
        (No client certificate requested)
        (Authenticated sender: luoj)
        by smtp.codeaurora.org (Postfix) with ESMTPSA id 3FCD1C43618;
        Sat, 23 Oct 2021 03:24:30 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.4.1 smtp.codeaurora.org 3FCD1C43618
Authentication-Results: aws-us-west-2-caf-mail-1.web.codeaurora.org; dmarc=none (p=none dis=none) header.from=codeaurora.org
Authentication-Results: aws-us-west-2-caf-mail-1.web.codeaurora.org; spf=fail smtp.mailfrom=codeaurora.org
From:   Luo Jie <luoj@codeaurora.org>
To:     andrew@lunn.ch, hkallweit1@gmail.com, linux@armlinux.org.uk,
        davem@davemloft.net, kuba@kernel.org
Cc:     netdev@vger.kernel.org, linux-kernel@vger.kernel.org,
        sricharan@codeaurora.org, Luo Jie <luoj@codeaurora.org>
Subject: [PATCH v5 03/14] net: phy: at803x: improve the WOL feature
Date:   Sat, 23 Oct 2021 11:24:01 +0800
Message-Id: <20211023032412.30479-4-luoj@codeaurora.org>
X-Mailer: git-send-email 2.17.1
In-Reply-To: <20211023032412.30479-1-luoj@codeaurora.org>
References: <20211023032412.30479-1-luoj@codeaurora.org>
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

The wol feature is controlled by the MMD3.8012 bit5,
need to set this bit when the wol function is enabled.

The reg18 bit0 is for enabling WOL interrupt, when wol
occurs, the wol interrupt status reg19 bit0 is set to 1.

Call phy_trigger_machine if there are any other interrupt
pending in the function set_wol.

Signed-off-by: Luo Jie <luoj@codeaurora.org>
---
 drivers/net/phy/at803x.c | 45 +++++++++++++++++++++++++++++++++-------
 1 file changed, 38 insertions(+), 7 deletions(-)

diff --git a/drivers/net/phy/at803x.c b/drivers/net/phy/at803x.c
index cf25cd428ffa..1363f12ba659 100644
--- a/drivers/net/phy/at803x.c
+++ b/drivers/net/phy/at803x.c
@@ -70,6 +70,8 @@
 #define AT803X_CDT_STATUS_DELTA_TIME_MASK	GENMASK(7, 0)
 #define AT803X_LED_CONTROL			0x18
 
+#define AT803X_PHY_MMD3_WOL_CTRL		0x8012
+#define AT803X_WOL_EN				BIT(5)
 #define AT803X_LOC_MAC_ADDR_0_15_OFFSET		0x804C
 #define AT803X_LOC_MAC_ADDR_16_31_OFFSET	0x804B
 #define AT803X_LOC_MAC_ADDR_32_47_OFFSET	0x804A
@@ -335,8 +337,7 @@ static int at803x_set_wol(struct phy_device *phydev,
 {
 	struct net_device *ndev = phydev->attached_dev;
 	const u8 *mac;
-	int ret;
-	u32 value;
+	int ret, irq_enabled;
 	unsigned int i;
 	const unsigned int offsets[] = {
 		AT803X_LOC_MAC_ADDR_32_47_OFFSET,
@@ -357,18 +358,45 @@ static int at803x_set_wol(struct phy_device *phydev,
 			phy_write_mmd(phydev, MDIO_MMD_PCS, offsets[i],
 				      mac[(i * 2) + 1] | (mac[(i * 2)] << 8));
 
+		/* Enable WOL function */
+		ret = phy_modify_mmd(phydev, MDIO_MMD_PCS, AT803X_PHY_MMD3_WOL_CTRL,
+				0, AT803X_WOL_EN);
+		if (ret)
+			return ret;
+		/* Enable WOL interrupt */
 		ret = phy_modify(phydev, AT803X_INTR_ENABLE, 0, AT803X_INTR_ENABLE_WOL);
 		if (ret)
 			return ret;
-		value = phy_read(phydev, AT803X_INTR_STATUS);
 	} else {
+		/* Disable WoL function */
+		ret = phy_modify_mmd(phydev, MDIO_MMD_PCS, AT803X_PHY_MMD3_WOL_CTRL,
+				AT803X_WOL_EN, 0);
+		if (ret)
+			return ret;
+		/* Disable WOL interrupt */
 		ret = phy_modify(phydev, AT803X_INTR_ENABLE, AT803X_INTR_ENABLE_WOL, 0);
 		if (ret)
 			return ret;
-		value = phy_read(phydev, AT803X_INTR_STATUS);
 	}
 
-	return ret;
+	/* Clear WOL status */
+	ret = phy_read(phydev, AT803X_INTR_STATUS);
+	if (ret < 0)
+		return ret;
+
+	/* Check if there are other interrupts except for WOL triggered when PHY is
+	 * in interrupt mode, only the interrupts enabled by AT803X_INTR_ENABLE can
+	 * be passed up to the interrupt PIN.
+	 */
+	irq_enabled = phy_read(phydev, AT803X_INTR_ENABLE);
+	if (irq_enabled < 0)
+		return irq_enabled;
+
+	irq_enabled &= ~AT803X_INTR_ENABLE_WOL;
+	if (ret & irq_enabled && !phy_polling_mode(phydev))
+		phy_trigger_machine(phydev);
+
+	return 0;
 }
 
 static void at803x_get_wol(struct phy_device *phydev,
@@ -379,8 +407,11 @@ static void at803x_get_wol(struct phy_device *phydev,
 	wol->supported = WAKE_MAGIC;
 	wol->wolopts = 0;
 
-	value = phy_read(phydev, AT803X_INTR_ENABLE);
-	if (value & AT803X_INTR_ENABLE_WOL)
+	value = phy_read_mmd(phydev, MDIO_MMD_PCS, AT803X_PHY_MMD3_WOL_CTRL);
+	if (value < 0)
+		return;
+
+	if (value & AT803X_WOL_EN)
 		wol->wolopts |= WAKE_MAGIC;
 }
 
-- 
The Qualcomm Innovation Center, Inc. is a member of the Code Aurora Forum,
a Linux Foundation Collaborative Project

