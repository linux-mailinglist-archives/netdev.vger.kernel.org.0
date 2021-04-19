Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 6CB7C36480C
	for <lists+netdev@lfdr.de>; Mon, 19 Apr 2021 18:17:20 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S235536AbhDSQRU (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 19 Apr 2021 12:17:20 -0400
Received: from mail-eopbgr70040.outbound.protection.outlook.com ([40.107.7.40]:40420
        "EHLO EUR04-HE1-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S238575AbhDSQRJ (ORCPT <rfc822;netdev@vger.kernel.org>);
        Mon, 19 Apr 2021 12:17:09 -0400
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=KgROX5rxwOfy5cQ+vurq8PdhuRLQoi121mAMN26rK8fovev6zrkA2thZ2zGgbyjGpUIbqtni+8wyY+4tLo6juzJkHh3ISSYszritSNGyuqq/IxmnIOeQCvatXm2BTCynSdnCFSjXQQQLMQrdBQwuGHZKqnbBdssYCQPIWJzW1O94Yj5I8EdQ0oGTmicgy0h160Er5qqBRmEx2xoyuLGVBDQCAdlfdAA9ZGvTQOlO928b+ykdCPstCSq35YN7UUO6l/8LAUopdMFGsYop+NTcJE2U5x7r2YWS6DvY0Zmc4Yg88EAS3p3P0TuZISAv3h1hCpbMUXFXtz5quMOl73ucbQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=Os2h/1DLJ+POb0lVnS4v3I6iumgY6K+OSrJIRmGwMIU=;
 b=a3u4SehHid9/O9aCxTvcJoAzqHKPYr/RoX9yEpUMzLW3Mu0OIW1u8w2B6o84U6k43rBxuahjTyWlkRYvBBj0yD10YhlcEce8z/lGr9U8CyVhKmxhmxuzjtcHMoc9RwUU23N5+2aSnoWkGKrYsZtJJpv/kDYgIgL90MyNEIBN5c7T+lrbD1pDMBjPOqE0W2LOEUKX1XDR+5rpG0Tlzm5mpXJMQSxgKDG78E0GiDfi0mYHkA3pdIcwLvg28+9h85vO6lqWiUl2svEztQ/e/jn2cnlsBrSpLgtM/2CZHz9BPcrKh8BErjmVuz+or2HaCxAeJiQCPVwt4B326k/eR+rilg==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=oss.nxp.com; dmarc=pass action=none header.from=oss.nxp.com;
 dkim=pass header.d=oss.nxp.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=NXP1.onmicrosoft.com;
 s=selector2-NXP1-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=Os2h/1DLJ+POb0lVnS4v3I6iumgY6K+OSrJIRmGwMIU=;
 b=kh7RAWG4d6c3/Mk1tvld92bnCmLQthRSyiBmIM5z/oHVh2tZcHBPfrwh0KZXp36gMQOZVKq+E9ozjDiW77YseAhr5J3twTXH58CdKjZnj8F+JPHeSxVEiJB63hDfcHsibBusZw8ZuVspUij92MDr5eIolWSvebGwL4FjoQIbMyE=
Authentication-Results: lunn.ch; dkim=none (message not signed)
 header.d=none;lunn.ch; dmarc=none action=none header.from=oss.nxp.com;
Received: from VI1PR04MB5101.eurprd04.prod.outlook.com (2603:10a6:803:5f::31)
 by VI1PR04MB7102.eurprd04.prod.outlook.com (2603:10a6:800:124::12) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4042.21; Mon, 19 Apr
 2021 16:16:33 +0000
Received: from VI1PR04MB5101.eurprd04.prod.outlook.com
 ([fe80::1d18:6e9:995c:1945]) by VI1PR04MB5101.eurprd04.prod.outlook.com
 ([fe80::1d18:6e9:995c:1945%6]) with mapi id 15.20.4042.024; Mon, 19 Apr 2021
 16:16:33 +0000
From:   "Radu Pirea (NXP OSS)" <radu-nicolae.pirea@oss.nxp.com>
To:     andrew@lunn.ch, hkallweit1@gmail.com, linux@armlinux.org.uk,
        davem@davemloft.net, kuba@kernel.org
Cc:     netdev@vger.kernel.org, linux-kernel@vger.kernel.org,
        "Radu Pirea (NXP OSS)" <radu-nicolae.pirea@oss.nxp.com>
Subject: [PATCH v3 1/2] net: phy: add genphy_c45_pma_suspend/resume
Date:   Mon, 19 Apr 2021 19:13:59 +0300
Message-Id: <20210419161400.260703-2-radu-nicolae.pirea@oss.nxp.com>
X-Mailer: git-send-email 2.31.1
In-Reply-To: <20210419161400.260703-1-radu-nicolae.pirea@oss.nxp.com>
References: <20210419161400.260703-1-radu-nicolae.pirea@oss.nxp.com>
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-Originating-IP: [89.45.21.213]
X-ClientProxiedBy: VI1PR08CA0198.eurprd08.prod.outlook.com
 (2603:10a6:800:d2::28) To VI1PR04MB5101.eurprd04.prod.outlook.com
 (2603:10a6:803:5f::31)
MIME-Version: 1.0
X-MS-Exchange-MessageSentRepresentingType: 1
Received: from localhost.localdomain (89.45.21.213) by VI1PR08CA0198.eurprd08.prod.outlook.com (2603:10a6:800:d2::28) with Microsoft SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4042.16 via Frontend Transport; Mon, 19 Apr 2021 16:16:32 +0000
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: a77b9002-7d43-482a-460f-08d9034e7f46
X-MS-TrafficTypeDiagnostic: VI1PR04MB7102:
X-MS-Exchange-SharedMailbox-RoutingAgent-Processed: True
X-MS-Exchange-Transport-Forked: True
X-Microsoft-Antispam-PRVS: <VI1PR04MB7102505B0EC95155ECF0A27D9F499@VI1PR04MB7102.eurprd04.prod.outlook.com>
X-MS-Oob-TLC-OOBClassifiers: OLM:4125;
X-MS-Exchange-SenderADCheck: 1
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: Uh2oBUJ5Y51EEWv8BgjKBDfx8lUtYjvlkeyWrUgq3BVjT+LpfheYkC9TH9mx+k46wct++rcGoxDxoO8DuuYFjdJc3ApApYW9vv20fU9aIFbW5ovFVfQRaeehABjA0EQf9UdQefhNS45ZXRj+fh9CZ0RiBmB4kYiVFwrqkENqimKAglneoC19QpatP7o4xCbZhRILXKiKiGbx4+gFIyELHCi2vCeLlSH5Pf4pHmAl7coEypEpzrD6ikh7TZsnFTbiVvo1Y/pOU8xyfCZMy/NmKT9uHijtY7L8tddX3wS8gUFMNvP991BEmm+0lV/pigJF753ZzCCZtcN1du7oRfPx7ztnGGbU4NAnI2CAWer7R0og/L8rlMyzamLYJaCnoyFhBqVIaDS2Fso1mYl6iCs+BlQmlR/rrAbExjO81V0wD+bKaxmssazjakAd7YTqaWZJus3kjL6O6SgwOtwHW8gbCVEgQL/TQhqGGqt5gdDlq5dF8PsNTTxqnq46yxCmYk9eoUZL2Hwj8KagByy/O7o4DDBcAhVAp5ZBLXOJChg/LSYpdVcjoUREMxWIKzxJCIEWQ0ox88mdmkI/7yoJIpoZkNnPwJnuJg0f5+BoJKvej9DQbiocttJaZ0atmMniAfwE710Sytgdt3FdEqJDpVAk9746uet7L2XZrYCM9asX4zC08hFg6PnTo6RaR4Ll/NNEeM9iSnL0V6m74zhNvZ2/Hw==
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:VI1PR04MB5101.eurprd04.prod.outlook.com;PTR:;CAT:NONE;SFS:(4636009)(376002)(346002)(136003)(366004)(39850400004)(396003)(956004)(38100700002)(5660300002)(6506007)(8936002)(4326008)(1076003)(83380400001)(6666004)(66946007)(38350700002)(2906002)(6486002)(66476007)(186003)(8676002)(6512007)(316002)(2616005)(52116002)(86362001)(16526019)(26005)(66556008)(478600001)(69590400013)(41350200001);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData: =?us-ascii?Q?XFp6KJX888TBNAQel6MuS/QRTfYDK4t2sxzSXFbrCfB6rp/xTvYkd00XpTOM?=
 =?us-ascii?Q?DhOea8l2KDZxkNj5kLLKgxDptiW52BMupHTJvw0SbRse2pPzt9W6OSeoZZlM?=
 =?us-ascii?Q?wOtanUg8qZy6Xr7c5HdkVVi8PmKh3y67rr6xftkjQA/NksY96WF81mw3BtX1?=
 =?us-ascii?Q?V3vSmtnNnGaA80nOwyU+loUrQXmKGn2oCZle0blcs0xdwRCAQrn2KbpPFH5t?=
 =?us-ascii?Q?gLymBLKRoR3sfyx9Zt3An8gmxanBqRz5vqzEigofqAyffU79+Rc+mfl1F985?=
 =?us-ascii?Q?FW4EvmSx77mgmSiFytwQYkZr0OqQ/HyrXlfAvUUWRIispsiRcxVwnaRMl3fP?=
 =?us-ascii?Q?YTQ9ffozn5kIk4tWZPr1cGvTXAu8ONhFQEhU+fT4Coxo8NFEvfF5yPYC6yvC?=
 =?us-ascii?Q?IsnWW9AgKzMVYzihTU8GTfBpTU8XwdArMOPfxclfLSiXijGc5JK0sgbwzcYP?=
 =?us-ascii?Q?41ZS50AEcH+238L0xNWCxCl4qmFX10vuiZfFQBOiOqov+jLaHmL0AYWUNDE/?=
 =?us-ascii?Q?RQ+YhXeKFZw0Bp0iiP695EIUJvu3p9QJTCO8A6ZfAMRtlpWkYr5mf3DQr8O+?=
 =?us-ascii?Q?DNW8WlH9D4uUe+YuYFPDtzLjwdFJLegsk5HHFuCHWckZjidPpr84Hzmew4Qa?=
 =?us-ascii?Q?YtfD7zBS3l8kJAgYz4GeW0YiAfhJcE1VnBf67exA6/3UNQ4LFsBDjKC03vZg?=
 =?us-ascii?Q?UltTl5AQyFQNFwHUkEasLOVNLBi/3FmTfcQU71OZ9fWl61x5Q71AFWdov9uA?=
 =?us-ascii?Q?2/PBQRO6YYNozYv2udBnuS3omAIUhAAZTP9iM24vn0yDEz6rBWdygC4DqJ3j?=
 =?us-ascii?Q?F6O5GO6jTww10uwu5zDn4Q0X+BuVW2XpE8Vyh5/PYNjqBjRlLdHkr6y6adO7?=
 =?us-ascii?Q?RKbCNpDazdDR2yEtuQDLfcfzPUK6WRmOiw4MSxwgTQ2ztodUHkwyg16NKgtl?=
 =?us-ascii?Q?UqrXiZr+P9xVrYtYxjx8vZGSK05hSV02nW3g/KeeYLNm6JKAuZhtkO+cjwov?=
 =?us-ascii?Q?uzJJU7KmFqHEWSj/Hkq6+dE85nT0KUfVjucrCpk6E4G8HYPUUPsslTRbpCZS?=
 =?us-ascii?Q?/X3JAhovpKO4jqBWl52fLUTPB7R+ofH16drZ8ZX5KaKRdiD067RrsgNZeuTO?=
 =?us-ascii?Q?3ysOquxbgCSG6C1jP0WvlQ9iZKYEnTk+T3VgBbGEDXWwi+IxKK51xObm0AFf?=
 =?us-ascii?Q?giMbdXRplhF57ouPPtXOimd8DX6b0Ze2iVqgwkFrAgXmH26fQgC0fl8f46b5?=
 =?us-ascii?Q?6g38meznK8CTWEGXBz1jqLRDf61dfL/KVILH2TjEMctoH1bCqR1FUKpzhhUl?=
 =?us-ascii?Q?QjEiZLqvtifuacFmpgFFnyzW?=
X-OriginatorOrg: oss.nxp.com
X-MS-Exchange-CrossTenant-Network-Message-Id: a77b9002-7d43-482a-460f-08d9034e7f46
X-MS-Exchange-CrossTenant-AuthSource: VI1PR04MB5101.eurprd04.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 19 Apr 2021 16:16:33.0918
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 686ea1d3-bc2b-4c6f-a92c-d99c5c301635
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: EvWEq6bLuS0RQKdbDx9J6VQVuFYOe3T7kgrd0AC0knZNLtCU0yo/GxAN5rtTdrS4u/1sf/OXwJZkaon4spqaIBEYSafgiOMWc5v/ovxoK+Y=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: VI1PR04MB7102
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Add generic PMA suspend and resume callback functions for C45 PHYs.

Signed-off-by: Radu Pirea (NXP OSS) <radu-nicolae.pirea@oss.nxp.com>
Reviewed-by: Andrew Lunn <andrew@lunn.ch>
---
 drivers/net/phy/phy-c45.c | 43 +++++++++++++++++++++++++++++++++++++++
 include/linux/phy.h       |  2 ++
 2 files changed, 45 insertions(+)

diff --git a/drivers/net/phy/phy-c45.c b/drivers/net/phy/phy-c45.c
index 91e3acb9e397..f4816b7d31b3 100644
--- a/drivers/net/phy/phy-c45.c
+++ b/drivers/net/phy/phy-c45.c
@@ -8,6 +8,49 @@
 #include <linux/mii.h>
 #include <linux/phy.h>
 
+/**
+ * genphy_c45_pma_can_sleep - checks if the PMA have sleep support
+ * @phydev: target phy_device struct
+ */
+static bool genphy_c45_pma_can_sleep(struct phy_device *phydev)
+{
+	int stat1;
+
+	stat1 = phy_read_mmd(phydev, MDIO_MMD_PMAPMD, MDIO_STAT1);
+	if (stat1 < 0)
+		return false;
+
+	return !!(stat1 & MDIO_STAT1_LPOWERABLE);
+}
+
+/**
+ * genphy_c45_pma_resume - wakes up the PMA module
+ * @phydev: target phy_device struct
+ */
+int genphy_c45_pma_resume(struct phy_device *phydev)
+{
+	if (!genphy_c45_pma_can_sleep(phydev))
+		return -EOPNOTSUPP;
+
+	return phy_clear_bits_mmd(phydev, MDIO_MMD_PMAPMD, MDIO_CTRL1,
+				  MDIO_CTRL1_LPOWER);
+}
+EXPORT_SYMBOL_GPL(genphy_c45_pma_resume);
+
+/**
+ * genphy_c45_pma_suspend - suspends the PMA module
+ * @phydev: target phy_device struct
+ */
+int genphy_c45_pma_suspend(struct phy_device *phydev)
+{
+	if (!genphy_c45_pma_can_sleep(phydev))
+		return -EOPNOTSUPP;
+
+	return phy_set_bits_mmd(phydev, MDIO_MMD_PMAPMD, MDIO_CTRL1,
+				MDIO_CTRL1_LPOWER);
+}
+EXPORT_SYMBOL_GPL(genphy_c45_pma_suspend);
+
 /**
  * genphy_c45_pma_setup_forced - configures a forced speed
  * @phydev: target phy_device struct
diff --git a/include/linux/phy.h b/include/linux/phy.h
index 98fb441dd72e..e3d4d583463b 100644
--- a/include/linux/phy.h
+++ b/include/linux/phy.h
@@ -1535,6 +1535,8 @@ int genphy_c45_pma_read_abilities(struct phy_device *phydev);
 int genphy_c45_read_status(struct phy_device *phydev);
 int genphy_c45_config_aneg(struct phy_device *phydev);
 int genphy_c45_loopback(struct phy_device *phydev, bool enable);
+int genphy_c45_pma_resume(struct phy_device *phydev);
+int genphy_c45_pma_suspend(struct phy_device *phydev);
 
 /* Generic C45 PHY driver */
 extern struct phy_driver genphy_c45_driver;
-- 
2.31.1

