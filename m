Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 52BC0430E3D
	for <lists+netdev@lfdr.de>; Mon, 18 Oct 2021 05:34:36 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232233AbhJRDgg (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sun, 17 Oct 2021 23:36:36 -0400
Received: from so254-9.mailgun.net ([198.61.254.9]:54157 "EHLO
        so254-9.mailgun.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231998AbhJRDgZ (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sun, 17 Oct 2021 23:36:25 -0400
DKIM-Signature: a=rsa-sha256; v=1; c=relaxed/relaxed; d=mg.codeaurora.org; q=dns/txt;
 s=smtp; t=1634528055; h=References: In-Reply-To: Message-Id: Date:
 Subject: Cc: To: From: Sender;
 bh=88Zz3/9SEDDndIMZBMxZol8jtPfitFklR0Redu2lM00=; b=PlHwG49YlYAR65J5RgZ2qsLJ0ZKrohPiuWcEOEz7xKd3v3w+2YYpMV+pTJdT1i5lNvleSLtP
 A6dNFkNTUPk9OV2qfNSShAhJOc19IJWVqxjybcGQIUZEcIZdkXeG8VxJputGRxCT0yfQYTJ+
 3enyymEJ29ChGRfJEZiJudUutaY=
X-Mailgun-Sending-Ip: 198.61.254.9
X-Mailgun-Sid: WyJiZjI2MiIsICJuZXRkZXZAdmdlci5rZXJuZWwub3JnIiwgImJlOWU0YSJd
Received: from smtp.codeaurora.org
 (ec2-35-166-182-171.us-west-2.compute.amazonaws.com [35.166.182.171]) by
 smtp-out-n04.prod.us-east-1.postgun.com with SMTP id
 616ceb36060523968985f936 (version=TLS1.2,
 cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256); Mon, 18 Oct 2021 03:34:14
 GMT
Sender: luoj=codeaurora.org@mg.codeaurora.org
Received: by smtp.codeaurora.org (Postfix, from userid 1001)
        id 2F32EC43460; Mon, 18 Oct 2021 03:34:14 +0000 (UTC)
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
        aws-us-west-2-caf-mail-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-2.9 required=2.0 tests=ALL_TRUSTED,BAYES_00,SPF_FAIL
        autolearn=no autolearn_force=no version=3.4.0
Received: from akronite-sh-dev02.qualcomm.com (unknown [180.166.53.21])
        (using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
        (No client certificate requested)
        (Authenticated sender: luoj)
        by smtp.codeaurora.org (Postfix) with ESMTPSA id 70787C43460;
        Mon, 18 Oct 2021 03:34:09 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.4.1 smtp.codeaurora.org 70787C43460
Authentication-Results: aws-us-west-2-caf-mail-1.web.codeaurora.org; dmarc=none (p=none dis=none) header.from=codeaurora.org
Authentication-Results: aws-us-west-2-caf-mail-1.web.codeaurora.org; spf=fail smtp.mailfrom=codeaurora.org
From:   Luo Jie <luoj@codeaurora.org>
To:     andrew@lunn.ch, hkallweit1@gmail.com, linux@armlinux.org.uk,
        davem@davemloft.net, kuba@kernel.org
Cc:     netdev@vger.kernel.org, linux-kernel@vger.kernel.org,
        sricharan@codeaurora.org, Luo Jie <luoj@codeaurora.org>
Subject: [PATCH v3 08/13] net: phy: add qca8081 config_aneg
Date:   Mon, 18 Oct 2021 11:33:28 +0800
Message-Id: <20211018033333.17677-9-luoj@codeaurora.org>
X-Mailer: git-send-email 2.17.1
In-Reply-To: <20211018033333.17677-1-luoj@codeaurora.org>
References: <20211018033333.17677-1-luoj@codeaurora.org>
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Reuse at803x phy driver config_aneg excepting
adding 2500M auto-negotiation.

Signed-off-by: Luo Jie <luoj@codeaurora.org>
---
 drivers/net/phy/at803x.c | 26 +++++++++++++++++++++++++-
 1 file changed, 25 insertions(+), 1 deletion(-)

diff --git a/drivers/net/phy/at803x.c b/drivers/net/phy/at803x.c
index 0c22ef735230..c124d3fe40fb 100644
--- a/drivers/net/phy/at803x.c
+++ b/drivers/net/phy/at803x.c
@@ -1084,7 +1084,30 @@ static int at803x_config_aneg(struct phy_device *phydev)
 			return ret;
 	}
 
-	return genphy_config_aneg(phydev);
+	/* Do not restart auto-negotiation by setting ret to 0 defautly,
+	 * when calling __genphy_config_aneg later.
+	 */
+	ret = 0;
+
+	if (phydev->drv->phy_id == QCA8081_PHY_ID) {
+		int phy_ctrl = 0;
+
+		/* The reg MII_BMCR also needs to be configured for force mode, the
+		 * genphy_config_aneg is also needed.
+		 */
+		if (phydev->autoneg == AUTONEG_DISABLE)
+			genphy_c45_pma_setup_forced(phydev);
+
+		if (linkmode_test_bit(ETHTOOL_LINK_MODE_2500baseT_Full_BIT, phydev->advertising))
+			phy_ctrl = MDIO_AN_10GBT_CTRL_ADV2_5G;
+
+		ret = phy_modify_mmd_changed(phydev, MDIO_MMD_AN, MDIO_AN_10GBT_CTRL,
+				MDIO_AN_10GBT_CTRL_ADV2_5G, phy_ctrl);
+		if (ret < 0)
+			return ret;
+	}
+
+	return __genphy_config_aneg(phydev, ret);
 }
 
 static int at803x_get_downshift(struct phy_device *phydev, u8 *d)
@@ -1503,6 +1526,7 @@ static struct phy_driver at803x_driver[] = {
 	.set_wol		= at803x_set_wol,
 	.get_wol		= at803x_get_wol,
 	.get_features		= at803x_get_features,
+	.config_aneg		= at803x_config_aneg,
 	.suspend		= genphy_suspend,
 	.resume			= genphy_resume,
 	.read_status		= qca808x_read_status,
-- 
The Qualcomm Innovation Center, Inc. is a member of the Code Aurora Forum,
a Linux Foundation Collaborative Project

