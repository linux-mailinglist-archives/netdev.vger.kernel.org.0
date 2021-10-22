Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id F3E2543766D
	for <lists+netdev@lfdr.de>; Fri, 22 Oct 2021 14:07:34 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231440AbhJVMJ0 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 22 Oct 2021 08:09:26 -0400
Received: from m43-7.mailgun.net ([69.72.43.7]:12894 "EHLO m43-7.mailgun.net"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S231702AbhJVMJT (ORCPT <rfc822;netdev@vger.kernel.org>);
        Fri, 22 Oct 2021 08:09:19 -0400
DKIM-Signature: a=rsa-sha256; v=1; c=relaxed/relaxed; d=mg.codeaurora.org; q=dns/txt;
 s=smtp; t=1634904422; h=References: In-Reply-To: Message-Id: Date:
 Subject: Cc: To: From: Sender;
 bh=Vd9ZTnOvBMEj6w+gPOgDcyL3o423lZE0OiHNBsDeeXs=; b=kAogKNiFeqystg6SsMsMOFl38vWp590LZY8RueuM31miPX1vybn0cI2OfzRkgHCUXhqw44Ta
 Reim11EnprhkxSOOqZJD+DHtdItlj21MP+gjHxJou7E9OGj1YbOBEDCSkM8zKFUQBa3eY/D2
 qbJPoow0KzlbHVc5MEh9fB138U8=
X-Mailgun-Sending-Ip: 69.72.43.7
X-Mailgun-Sid: WyJiZjI2MiIsICJuZXRkZXZAdmdlci5rZXJuZWwub3JnIiwgImJlOWU0YSJd
Received: from smtp.codeaurora.org
 (ec2-35-166-182-171.us-west-2.compute.amazonaws.com [35.166.182.171]) by
 smtp-out-n01.prod.us-east-1.postgun.com with SMTP id
 6172a961b03398c06c06af5c (version=TLS1.2,
 cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256); Fri, 22 Oct 2021 12:06:57
 GMT
Sender: luoj=codeaurora.org@mg.codeaurora.org
Received: by smtp.codeaurora.org (Postfix, from userid 1001)
        id AE39AC4361C; Fri, 22 Oct 2021 12:06:56 +0000 (UTC)
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
        aws-us-west-2-caf-mail-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-2.9 required=2.0 tests=ALL_TRUSTED,BAYES_00,SPF_FAIL,
        URIBL_BLOCKED autolearn=no autolearn_force=no version=3.4.0
Received: from akronite-sh-dev02.qualcomm.com (unknown [180.166.53.21])
        (using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
        (No client certificate requested)
        (Authenticated sender: luoj)
        by smtp.codeaurora.org (Postfix) with ESMTPSA id C4F0CC4338F;
        Fri, 22 Oct 2021 12:06:53 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.4.1 smtp.codeaurora.org C4F0CC4338F
Authentication-Results: aws-us-west-2-caf-mail-1.web.codeaurora.org; dmarc=none (p=none dis=none) header.from=codeaurora.org
Authentication-Results: aws-us-west-2-caf-mail-1.web.codeaurora.org; spf=fail smtp.mailfrom=codeaurora.org
From:   Luo Jie <luoj@codeaurora.org>
To:     andrew@lunn.ch, hkallweit1@gmail.com, linux@armlinux.org.uk,
        davem@davemloft.net, kuba@kernel.org
Cc:     netdev@vger.kernel.org, linux-kernel@vger.kernel.org,
        sricharan@codeaurora.org, Luo Jie <luoj@codeaurora.org>
Subject: [PATCH v4 07/14] net: phy: add qca8081 get_features
Date:   Fri, 22 Oct 2021 20:06:17 +0800
Message-Id: <20211022120624.18069-8-luoj@codeaurora.org>
X-Mailer: git-send-email 2.17.1
In-Reply-To: <20211022120624.18069-1-luoj@codeaurora.org>
References: <20211022120624.18069-1-luoj@codeaurora.org>
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Reuse the at803x phy driver get_features excepting
adding 2500M capability.

Signed-off-by: Luo Jie <luoj@codeaurora.org>
---
 drivers/net/phy/at803x.c | 10 ++++++++++
 1 file changed, 10 insertions(+)

diff --git a/drivers/net/phy/at803x.c b/drivers/net/phy/at803x.c
index 738f5a84cca6..987497e39e50 100644
--- a/drivers/net/phy/at803x.c
+++ b/drivers/net/phy/at803x.c
@@ -736,6 +736,15 @@ static int at803x_get_features(struct phy_device *phydev)
 	if (err)
 		return err;
 
+	if (phydev->drv->phy_id == QCA8081_PHY_ID) {
+		err = phy_read_mmd(phydev, MDIO_MMD_PMAPMD, MDIO_PMA_NG_EXTABLE);
+		if (err < 0)
+			return err;
+
+		linkmode_mod_bit(ETHTOOL_LINK_MODE_2500baseT_Full_BIT, phydev->supported,
+				err & MDIO_PMA_NG_EXTABLE_2_5GBT);
+	}
+
 	if (phydev->drv->phy_id != ATH8031_PHY_ID)
 		return 0;
 
@@ -1542,6 +1551,7 @@ static struct phy_driver at803x_driver[] = {
 	.set_tunable		= at803x_set_tunable,
 	.set_wol		= at803x_set_wol,
 	.get_wol		= at803x_get_wol,
+	.get_features		= at803x_get_features,
 	.suspend		= genphy_suspend,
 	.resume			= genphy_resume,
 	.read_status		= qca808x_read_status,
-- 
The Qualcomm Innovation Center, Inc. is a member of the Code Aurora Forum,
a Linux Foundation Collaborative Project

