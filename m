Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id D07B84382DF
	for <lists+netdev@lfdr.de>; Sat, 23 Oct 2021 11:56:13 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232285AbhJWJ6Q (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sat, 23 Oct 2021 05:58:16 -0400
Received: from so254-9.mailgun.net ([198.61.254.9]:16753 "EHLO
        so254-9.mailgun.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231803AbhJWJ5u (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sat, 23 Oct 2021 05:57:50 -0400
DKIM-Signature: a=rsa-sha256; v=1; c=relaxed/relaxed; d=mg.codeaurora.org; q=dns/txt;
 s=smtp; t=1634982931; h=References: In-Reply-To: Message-Id: Date:
 Subject: Cc: To: From: Sender;
 bh=wx0o/+FDlE5lrjOxVv1UP3CP7rS1Bx+HM110kv/93QQ=; b=OS7WYO/gfwwP1WCF7K6+m9sFdYYOsHToK9ZerWvvZHnY0tuPtxDmpNY3i4OMBCMjsptm7+Y0
 gatXNMPjkHEZz1J8sUAF0nebaH8trKidSdxN1Vs+wI7KT5SKtIBEVziuEL+OWaIKgRMEV1No
 ZJM4MbW08pX7LPv+qd+T1wcPPXo=
X-Mailgun-Sending-Ip: 198.61.254.9
X-Mailgun-Sid: WyJiZjI2MiIsICJuZXRkZXZAdmdlci5rZXJuZWwub3JnIiwgImJlOWU0YSJd
Received: from smtp.codeaurora.org
 (ec2-35-166-182-171.us-west-2.compute.amazonaws.com [35.166.182.171]) by
 smtp-out-n01.prod.us-east-1.postgun.com with SMTP id
 6173dc0c59612e01009f2617 (version=TLS1.2,
 cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256); Sat, 23 Oct 2021 09:55:24
 GMT
Sender: luoj=codeaurora.org@mg.codeaurora.org
Received: by smtp.codeaurora.org (Postfix, from userid 1001)
        id B491BC43637; Sat, 23 Oct 2021 09:55:23 +0000 (UTC)
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
        aws-us-west-2-caf-mail-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-2.9 required=2.0 tests=ALL_TRUSTED,BAYES_00,SPF_FAIL
        autolearn=no autolearn_force=no version=3.4.0
Received: from akronite-sh-dev02.qualcomm.com (unknown [180.166.53.21])
        (using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
        (No client certificate requested)
        (Authenticated sender: luoj)
        by smtp.codeaurora.org (Postfix) with ESMTPSA id 35E0EC4360D;
        Sat, 23 Oct 2021 09:55:19 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.4.1 smtp.codeaurora.org 35E0EC4360D
Authentication-Results: aws-us-west-2-caf-mail-1.web.codeaurora.org; dmarc=none (p=none dis=none) header.from=codeaurora.org
Authentication-Results: aws-us-west-2-caf-mail-1.web.codeaurora.org; spf=fail smtp.mailfrom=codeaurora.org
From:   Luo Jie <luoj@codeaurora.org>
To:     andrew@lunn.ch, hkallweit1@gmail.com, linux@armlinux.org.uk,
        davem@davemloft.net, kuba@kernel.org
Cc:     netdev@vger.kernel.org, linux-kernel@vger.kernel.org,
        sricharan@codeaurora.org, Luo Jie <luoj@codeaurora.org>
Subject: [PATCH v6 05/14] net: phy: add qca8081 ethernet phy driver
Date:   Sat, 23 Oct 2021 17:54:44 +0800
Message-Id: <20211023095453.22615-6-luoj@codeaurora.org>
X-Mailer: git-send-email 2.17.1
In-Reply-To: <20211023095453.22615-1-luoj@codeaurora.org>
References: <20211023095453.22615-1-luoj@codeaurora.org>
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

qca8081 is a single port ethernet phy chip that supports
10/100/1000/2500 Mbps mode.

Add the basic phy driver features, and reuse the at803x
phy driver functions.

Signed-off-by: Luo Jie <luoj@codeaurora.org>
---
 drivers/net/phy/at803x.c | 17 ++++++++++++++++-
 1 file changed, 16 insertions(+), 1 deletion(-)

diff --git a/drivers/net/phy/at803x.c b/drivers/net/phy/at803x.c
index 3465f2bb6356..aae27fe3e1e1 100644
--- a/drivers/net/phy/at803x.c
+++ b/drivers/net/phy/at803x.c
@@ -158,6 +158,8 @@
 #define ATH8035_PHY_ID				0x004dd072
 #define AT8030_PHY_ID_MASK			0xffffffef
 
+#define QCA8081_PHY_ID				0x004dd101
+
 #define QCA8327_A_PHY_ID			0x004dd033
 #define QCA8327_B_PHY_ID			0x004dd034
 #define QCA8337_PHY_ID				0x004dd036
@@ -173,7 +175,7 @@
 #define AT803X_KEEP_PLL_ENABLED			BIT(0)
 #define AT803X_DISABLE_SMARTEEE			BIT(1)
 
-MODULE_DESCRIPTION("Qualcomm Atheros AR803x PHY driver");
+MODULE_DESCRIPTION("Qualcomm Atheros AR803x and QCA808X PHY driver");
 MODULE_AUTHOR("Matus Ujhelyi");
 MODULE_LICENSE("GPL");
 
@@ -1591,6 +1593,18 @@ static struct phy_driver at803x_driver[] = {
 	.get_stats		= at803x_get_stats,
 	.suspend		= qca83xx_suspend,
 	.resume			= qca83xx_resume,
+}, {
+	/* Qualcomm QCA8081 */
+	PHY_ID_MATCH_EXACT(QCA8081_PHY_ID),
+	.name			= "Qualcomm QCA8081",
+	.config_intr		= at803x_config_intr,
+	.handle_interrupt	= at803x_handle_interrupt,
+	.get_tunable		= at803x_get_tunable,
+	.set_tunable		= at803x_set_tunable,
+	.set_wol		= at803x_set_wol,
+	.get_wol		= at803x_get_wol,
+	.suspend		= genphy_suspend,
+	.resume			= genphy_resume,
 }, };
 
 module_phy_driver(at803x_driver);
@@ -1605,6 +1619,7 @@ static struct mdio_device_id __maybe_unused atheros_tbl[] = {
 	{ PHY_ID_MATCH_EXACT(QCA8327_A_PHY_ID) },
 	{ PHY_ID_MATCH_EXACT(QCA8327_B_PHY_ID) },
 	{ PHY_ID_MATCH_EXACT(QCA9561_PHY_ID) },
+	{ PHY_ID_MATCH_EXACT(QCA8081_PHY_ID) },
 	{ }
 };
 
-- 
The Qualcomm Innovation Center, Inc. is a member of the Code Aurora Forum,
a Linux Foundation Collaborative Project

