Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id CF7C7430E3C
	for <lists+netdev@lfdr.de>; Mon, 18 Oct 2021 05:34:35 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231674AbhJRDgf (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sun, 17 Oct 2021 23:36:35 -0400
Received: from so254-9.mailgun.net ([198.61.254.9]:50900 "EHLO
        so254-9.mailgun.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231971AbhJRDgZ (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sun, 17 Oct 2021 23:36:25 -0400
DKIM-Signature: a=rsa-sha256; v=1; c=relaxed/relaxed; d=mg.codeaurora.org; q=dns/txt;
 s=smtp; t=1634528055; h=References: In-Reply-To: Message-Id: Date:
 Subject: Cc: To: From: Sender;
 bh=8QQUvrN7w+jTvccg31GTb7UfZraHqANBgFQBrSLPXmw=; b=ZJvyFxANYCsBPjLJfvFCZEBqMCxyuQu3Dh1WcjQz9cJwmFihcfAtBuTVwVdlzhQchlWmJY5e
 XKtxeDUjwv602Fy305CAP/KrZ6+926cU6D9d+0PB3YaxepKjd27HuaffJ+qpsI0P5V1qYigO
 kz1Dgpd9LP1zcAGt0lHpcidGy/I=
X-Mailgun-Sending-Ip: 198.61.254.9
X-Mailgun-Sid: WyJiZjI2MiIsICJuZXRkZXZAdmdlci5rZXJuZWwub3JnIiwgImJlOWU0YSJd
Received: from smtp.codeaurora.org
 (ec2-35-166-182-171.us-west-2.compute.amazonaws.com [35.166.182.171]) by
 smtp-out-n06.prod.us-west-2.postgun.com with SMTP id
 616ceb3630ce13d2b4e65f6a (version=TLS1.2,
 cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256); Mon, 18 Oct 2021 03:34:14
 GMT
Sender: luoj=codeaurora.org@mg.codeaurora.org
Received: by smtp.codeaurora.org (Postfix, from userid 1001)
        id E75FAC43619; Mon, 18 Oct 2021 03:34:13 +0000 (UTC)
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
        aws-us-west-2-caf-mail-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-2.9 required=2.0 tests=ALL_TRUSTED,BAYES_00,SPF_FAIL
        autolearn=no autolearn_force=no version=3.4.0
Received: from akronite-sh-dev02.qualcomm.com (unknown [180.166.53.21])
        (using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
        (No client certificate requested)
        (Authenticated sender: luoj)
        by smtp.codeaurora.org (Postfix) with ESMTPSA id C2186C4360D;
        Mon, 18 Oct 2021 03:34:06 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.4.1 smtp.codeaurora.org C2186C4360D
Authentication-Results: aws-us-west-2-caf-mail-1.web.codeaurora.org; dmarc=none (p=none dis=none) header.from=codeaurora.org
Authentication-Results: aws-us-west-2-caf-mail-1.web.codeaurora.org; spf=fail smtp.mailfrom=codeaurora.org
From:   Luo Jie <luoj@codeaurora.org>
To:     andrew@lunn.ch, hkallweit1@gmail.com, linux@armlinux.org.uk,
        davem@davemloft.net, kuba@kernel.org
Cc:     netdev@vger.kernel.org, linux-kernel@vger.kernel.org,
        sricharan@codeaurora.org, Luo Jie <luoj@codeaurora.org>
Subject: [PATCH v3 07/13] net: phy: add qca8081 get_features
Date:   Mon, 18 Oct 2021 11:33:27 +0800
Message-Id: <20211018033333.17677-8-luoj@codeaurora.org>
X-Mailer: git-send-email 2.17.1
In-Reply-To: <20211018033333.17677-1-luoj@codeaurora.org>
References: <20211018033333.17677-1-luoj@codeaurora.org>
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
index 42d3f8ccca94..0c22ef735230 100644
--- a/drivers/net/phy/at803x.c
+++ b/drivers/net/phy/at803x.c
@@ -719,6 +719,15 @@ static int at803x_get_features(struct phy_device *phydev)
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
 
@@ -1493,6 +1502,7 @@ static struct phy_driver at803x_driver[] = {
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

