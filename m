Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id BD0F3430E46
	for <lists+netdev@lfdr.de>; Mon, 18 Oct 2021 05:35:50 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232043AbhJRDhL (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sun, 17 Oct 2021 23:37:11 -0400
Received: from so254-9.mailgun.net ([198.61.254.9]:50329 "EHLO
        so254-9.mailgun.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231733AbhJRDgW (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sun, 17 Oct 2021 23:36:22 -0400
DKIM-Signature: a=rsa-sha256; v=1; c=relaxed/relaxed; d=mg.codeaurora.org; q=dns/txt;
 s=smtp; t=1634528052; h=References: In-Reply-To: Message-Id: Date:
 Subject: Cc: To: From: Sender;
 bh=Lo3W/Te7SVFoiKgMizE9XcNF5nGE8jBoH5W/RjHiz0M=; b=pmhpl7ue8vFdGImfPTSLyuPK7U3I99+ILCm1Svyw75m4M6Fzuw1jg4NfKQZPJFEwOxxZzUHF
 8KmVBfsTeeUjgAHerq8Hea7HdRssKiQ2WisowjsI4mV0McBg4jQ+FMlqhzvgunu+KQBz36Ut
 s+0byT0KWhP8Rz/7e2UBJ2XOLy8=
X-Mailgun-Sending-Ip: 198.61.254.9
X-Mailgun-Sid: WyJiZjI2MiIsICJuZXRkZXZAdmdlci5rZXJuZWwub3JnIiwgImJlOWU0YSJd
Received: from smtp.codeaurora.org
 (ec2-35-166-182-171.us-west-2.compute.amazonaws.com [35.166.182.171]) by
 smtp-out-n07.prod.us-east-1.postgun.com with SMTP id
 616ceb28835b7947c10777c6 (version=TLS1.2,
 cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256); Mon, 18 Oct 2021 03:34:00
 GMT
Sender: luoj=codeaurora.org@mg.codeaurora.org
Received: by smtp.codeaurora.org (Postfix, from userid 1001)
        id 472B1C43616; Mon, 18 Oct 2021 03:33:59 +0000 (UTC)
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
        aws-us-west-2-caf-mail-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-2.9 required=2.0 tests=ALL_TRUSTED,BAYES_00,SPF_FAIL
        autolearn=no autolearn_force=no version=3.4.0
Received: from akronite-sh-dev02.qualcomm.com (unknown [180.166.53.21])
        (using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
        (No client certificate requested)
        (Authenticated sender: luoj)
        by smtp.codeaurora.org (Postfix) with ESMTPSA id 7F85EC43460;
        Mon, 18 Oct 2021 03:33:55 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.4.1 smtp.codeaurora.org 7F85EC43460
Authentication-Results: aws-us-west-2-caf-mail-1.web.codeaurora.org; dmarc=none (p=none dis=none) header.from=codeaurora.org
Authentication-Results: aws-us-west-2-caf-mail-1.web.codeaurora.org; spf=fail smtp.mailfrom=codeaurora.org
From:   Luo Jie <luoj@codeaurora.org>
To:     andrew@lunn.ch, hkallweit1@gmail.com, linux@armlinux.org.uk,
        davem@davemloft.net, kuba@kernel.org
Cc:     netdev@vger.kernel.org, linux-kernel@vger.kernel.org,
        sricharan@codeaurora.org, Luo Jie <luoj@codeaurora.org>
Subject: [PATCH v3 03/13] net: phy: at803x: improve the WOL feature
Date:   Mon, 18 Oct 2021 11:33:23 +0800
Message-Id: <20211018033333.17677-4-luoj@codeaurora.org>
X-Mailer: git-send-email 2.17.1
In-Reply-To: <20211018033333.17677-1-luoj@codeaurora.org>
References: <20211018033333.17677-1-luoj@codeaurora.org>
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

The wol feature is controlled by the MMD3.8012 bit5,
need to set this bit when the wol function is enabled.

The reg18 bit0 is for enabling WOL interrupt, when wol
occurs, the wol interrupt status reg19 bit0 is set to 1.

Signed-off-by: Luo Jie <luoj@codeaurora.org>
---
 drivers/net/phy/at803x.c | 27 +++++++++++++++++++++------
 1 file changed, 21 insertions(+), 6 deletions(-)

diff --git a/drivers/net/phy/at803x.c b/drivers/net/phy/at803x.c
index c5e145ff5ec8..2f7d96bd1be8 100644
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
@@ -327,7 +329,6 @@ static int at803x_set_wol(struct phy_device *phydev,
 	struct net_device *ndev = phydev->attached_dev;
 	const u8 *mac;
 	int ret;
-	u32 value;
 	unsigned int i;
 	const unsigned int offsets[] = {
 		AT803X_LOC_MAC_ADDR_32_47_OFFSET,
@@ -348,18 +349,29 @@ static int at803x_set_wol(struct phy_device *phydev,
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
+	return phy_read(phydev, AT803X_INTR_STATUS);
 }
 
 static void at803x_get_wol(struct phy_device *phydev,
@@ -370,8 +382,11 @@ static void at803x_get_wol(struct phy_device *phydev,
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

