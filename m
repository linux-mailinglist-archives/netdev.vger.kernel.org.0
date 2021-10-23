Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id A0A1E438185
	for <lists+netdev@lfdr.de>; Sat, 23 Oct 2021 05:28:30 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232057AbhJWD1b (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 22 Oct 2021 23:27:31 -0400
Received: from so254-9.mailgun.net ([198.61.254.9]:11861 "EHLO
        so254-9.mailgun.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231408AbhJWD1L (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 22 Oct 2021 23:27:11 -0400
DKIM-Signature: a=rsa-sha256; v=1; c=relaxed/relaxed; d=mg.codeaurora.org; q=dns/txt;
 s=smtp; t=1634959493; h=References: In-Reply-To: Message-Id: Date:
 Subject: Cc: To: From: Sender;
 bh=hhkQtx6GPVOl2NoneqLBxumGzrhDd8i+gHLRAuM18TY=; b=hJj1a5bdQZOfV7BxVuoe4UNOncbWAMTvOa1ZWbLsO8PnynXTKrpoJYNQDtM7YlZMGnXTp4aS
 E0SmB2wJpa03bA1wkVio19mrffgX5GjSCKBKsHYYrP/+0jvxNCqHoUs9Urc3uwTnmuyqM/xP
 /A2nSy0dRvReId3b7Yx146UaAeI=
X-Mailgun-Sending-Ip: 198.61.254.9
X-Mailgun-Sid: WyJiZjI2MiIsICJuZXRkZXZAdmdlci5rZXJuZWwub3JnIiwgImJlOWU0YSJd
Received: from smtp.codeaurora.org
 (ec2-35-166-182-171.us-west-2.compute.amazonaws.com [35.166.182.171]) by
 smtp-out-n07.prod.us-west-2.postgun.com with SMTP id
 6173807edaa899cf74a47eea (version=TLS1.2,
 cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256); Sat, 23 Oct 2021 03:24:46
 GMT
Sender: luoj=codeaurora.org@mg.codeaurora.org
Received: by smtp.codeaurora.org (Postfix, from userid 1001)
        id CF849C4360D; Sat, 23 Oct 2021 03:24:46 +0000 (UTC)
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
        aws-us-west-2-caf-mail-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-2.9 required=2.0 tests=ALL_TRUSTED,BAYES_00,SPF_FAIL
        autolearn=no autolearn_force=no version=3.4.0
Received: from akronite-sh-dev02.qualcomm.com (unknown [180.166.53.21])
        (using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
        (No client certificate requested)
        (Authenticated sender: luoj)
        by smtp.codeaurora.org (Postfix) with ESMTPSA id 446EDC43618;
        Sat, 23 Oct 2021 03:24:44 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.4.1 smtp.codeaurora.org 446EDC43618
Authentication-Results: aws-us-west-2-caf-mail-1.web.codeaurora.org; dmarc=none (p=none dis=none) header.from=codeaurora.org
Authentication-Results: aws-us-west-2-caf-mail-1.web.codeaurora.org; spf=fail smtp.mailfrom=codeaurora.org
From:   Luo Jie <luoj@codeaurora.org>
To:     andrew@lunn.ch, hkallweit1@gmail.com, linux@armlinux.org.uk,
        davem@davemloft.net, kuba@kernel.org
Cc:     netdev@vger.kernel.org, linux-kernel@vger.kernel.org,
        sricharan@codeaurora.org, Luo Jie <luoj@codeaurora.org>
Subject: [PATCH v5 08/14] net: phy: add qca8081 config_aneg
Date:   Sat, 23 Oct 2021 11:24:06 +0800
Message-Id: <20211023032412.30479-9-luoj@codeaurora.org>
X-Mailer: git-send-email 2.17.1
In-Reply-To: <20211023032412.30479-1-luoj@codeaurora.org>
References: <20211023032412.30479-1-luoj@codeaurora.org>
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
index c4b7ac03cd35..70c1025e8e5d 100644
--- a/drivers/net/phy/at803x.c
+++ b/drivers/net/phy/at803x.c
@@ -1109,7 +1109,30 @@ static int at803x_config_aneg(struct phy_device *phydev)
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
@@ -1663,6 +1686,7 @@ static struct phy_driver at803x_driver[] = {
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

