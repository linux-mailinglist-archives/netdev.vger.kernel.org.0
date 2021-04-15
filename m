Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id E9BBB3605AA
	for <lists+netdev@lfdr.de>; Thu, 15 Apr 2021 11:28:59 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231879AbhDOJ3C (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 15 Apr 2021 05:29:02 -0400
Received: from mail-db8eur05on2043.outbound.protection.outlook.com ([40.107.20.43]:18241
        "EHLO EUR05-DB8-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S231697AbhDOJ3A (ORCPT <rfc822;netdev@vger.kernel.org>);
        Thu, 15 Apr 2021 05:29:00 -0400
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=fZKL/wzCYTasKzF9RZK3042HkKqE1Raban1Wg4rVzdcX0k3KiPCwN+kT6f5gGm86w4h1c/NraFOCtxiKQ+8Kp0jGrT6J4HwfryutgDWZmFXj2E82Rx74LwFYr3QMzWNOHaC0XFnEfImj0nE7liscNliYiAhY6pXT5te+ItlsiRIiCiJ6kaITAw3D/3s9UBVmjPGhuRFGJkg4uADYK5GoFrEnKxntaG9h/Q6A/CcXGyMYV96M3os1lQFrriNE/usw9ObLaQiw5uy7r+C36wP7dj8xX7FbIyw3vJp51VXpkwiOA+ojqtsW1OsAVEpWCIyBV06qqHTdrHeKPqKT6cK9Kg==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=BH0q8jJpd4xP5w896ivHrEQhmI/rmFhdBxp0AhQb+z8=;
 b=a6x3Hdmwju6k8WJuoc9KPhZsyBlOAVDpybcrAs+dUuzrUqTvwRgPNJDYalE3VSWMgOEK9PvAwxBfRaM/YtN+dIRYC6hfULf1cScHYcfRgQc/8Xm6+zieo3vUmE9pG63GsauOhhOINVoUOf9GkVNBzz8grO/DsTCflpNmBEMNZ5iZ4bk899FEGraI+UUkbf2g6VpKwAUsN0+4Fm13kKca92SqQjC+qyFEt8z3i/BTMqlLTzZjFjjS/yxLLb5Bgh8LO0jcKC7GcfNLZ43VUN1UEKKrlbw17CteMLMcr2y9koyvQY99tBxbXIN1qYETFbGeSm5tyj2txaLrzhz7q0Ym5g==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=oss.nxp.com; dmarc=pass action=none header.from=oss.nxp.com;
 dkim=pass header.d=oss.nxp.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=NXP1.onmicrosoft.com;
 s=selector2-NXP1-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=BH0q8jJpd4xP5w896ivHrEQhmI/rmFhdBxp0AhQb+z8=;
 b=PkdhmavEumBCgmtBBRJI57fA6NAjbyDFZ20QVqO1/YoAP1ocI2n8TQ+Nv2huV+0J+t3kjIGDqOEZSsCpxD4P4Z2t6yIeRifif37steENWT3dAMN/spmd6439MBjp7H5yhk1DTb+EWJhD30MQ8y4QGccGZj67502pXGtVV/koiGs=
Authentication-Results: lunn.ch; dkim=none (message not signed)
 header.d=none;lunn.ch; dmarc=none action=none header.from=oss.nxp.com;
Received: from VI1PR04MB5101.eurprd04.prod.outlook.com (2603:10a6:803:5f::31)
 by VI1PR04MB7200.eurprd04.prod.outlook.com (2603:10a6:800:12d::23) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4042.16; Thu, 15 Apr
 2021 09:28:36 +0000
Received: from VI1PR04MB5101.eurprd04.prod.outlook.com
 ([fe80::1d18:6e9:995c:1945]) by VI1PR04MB5101.eurprd04.prod.outlook.com
 ([fe80::1d18:6e9:995c:1945%6]) with mapi id 15.20.4020.022; Thu, 15 Apr 2021
 09:28:35 +0000
From:   "Radu Pirea (NXP OSS)" <radu-nicolae.pirea@oss.nxp.com>
To:     andrew@lunn.ch, hkallweit1@gmail.com, linux@armlinux.org.uk,
        davem@davemloft.net, kuba@kernel.org
Cc:     netdev@vger.kernel.org, linux-kernel@vger.kernel.org,
        "Radu Pirea (NXP OSS)" <radu-nicolae.pirea@oss.nxp.com>
Subject: [PATCH v2 1/2] net: phy: add genphy_c45_pma_suspend/resume
Date:   Thu, 15 Apr 2021 12:25:37 +0300
Message-Id: <20210415092538.78398-2-radu-nicolae.pirea@oss.nxp.com>
X-Mailer: git-send-email 2.31.1
In-Reply-To: <20210415092538.78398-1-radu-nicolae.pirea@oss.nxp.com>
References: <20210415092538.78398-1-radu-nicolae.pirea@oss.nxp.com>
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-Originating-IP: [89.45.21.213]
X-ClientProxiedBy: AM0PR02CA0177.eurprd02.prod.outlook.com
 (2603:10a6:20b:28e::14) To VI1PR04MB5101.eurprd04.prod.outlook.com
 (2603:10a6:803:5f::31)
MIME-Version: 1.0
X-MS-Exchange-MessageSentRepresentingType: 1
Received: from localhost.localdomain (89.45.21.213) by AM0PR02CA0177.eurprd02.prod.outlook.com (2603:10a6:20b:28e::14) with Microsoft SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4042.16 via Frontend Transport; Thu, 15 Apr 2021 09:28:35 +0000
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: be5d96ba-cb99-4d05-2776-08d8fff0d831
X-MS-TrafficTypeDiagnostic: VI1PR04MB7200:
X-MS-Exchange-SharedMailbox-RoutingAgent-Processed: True
X-MS-Exchange-Transport-Forked: True
X-Microsoft-Antispam-PRVS: <VI1PR04MB7200DF158DBA8748BCDD3F6B9F4D9@VI1PR04MB7200.eurprd04.prod.outlook.com>
X-MS-Oob-TLC-OOBClassifiers: OLM:4125;
X-MS-Exchange-SenderADCheck: 1
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: Y6bDN5iE60g5IY4NCbcHOV9NNtEvYqZ8+X9ipEFnNPefd887RXxSxqN+ss4R3G/LO4Cj/gciysivUdzTV0iofXydkStEv7ipsXrzxjfozWaUhgflPelRJvtjbFqpLw+4DAUj8vm3bvT8gXWhcW7IFcx6mFj8VhXCpakFESOK+j+hFrKwA664ReX/3R3PrdU3Z07qSAfKPW15P0Yb8yygosZpbvOxCqEE88VWzrdzNehZodH3RM+slXk4NA/9qeeZWpf+jHdjHCPU5L2xfnWtuLS0J71fBD7l26vr8yKGBTut4nBk6dTficTr5VnTh257fHgxpCBOCkwVby7bcCCwBY3YXtMXhtjvu8bGgIUBhV2AI7jCjudHdPVZipH9peklETnVe2EHqPP54mYkApUtPjjJlXjSoOXk/th3h4OZ5NgIoHOrk8nb2SeeRzhW+cT0nKfwd8JkL3X48fdQSYDRGxVb8rf0N6WEpPoej0GPf0pTNYdqAKg3oDLHGSROZiut1sQfQNDnz+4KaQ7rzBxWKq9mi8qLe1Bnpr0MAtmFn/qHTFbpTdNBPInm5JHtFxBiVnJUrj2j3h0izE74oc7mb5p/fdp33Z/hxSGdTAM0y8NZlYz2gfJnCIhJAC1HYAbCrgrQ4oeFf+7xzADoi/e2e2Qvvm3B3EFCss4itvHYNVIsY8dp0uJCMPk6Pvw2U7Zs5MbYkryqt919GLAADUm7vg==
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:VI1PR04MB5101.eurprd04.prod.outlook.com;PTR:;CAT:NONE;SFS:(4636009)(136003)(39860400002)(366004)(376002)(346002)(396003)(8936002)(2906002)(5660300002)(52116002)(4326008)(956004)(66556008)(6486002)(316002)(66946007)(2616005)(83380400001)(478600001)(69590400012)(66476007)(38350700002)(16526019)(86362001)(1076003)(38100700002)(26005)(186003)(8676002)(6506007)(6512007)(41350200001);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData: o8oDUAlgVDDMFhGjsP3Hud78PVjsOXTVeKTedokIgUt/7Sb6UPJcC+8H3P2D5qm8rA0Za+Y9ysDZ0ZMluKyn+mo5l+uVUay58ixsdC2+U771bj836xJ8pGhVJWqUXsLDNCadaTd9mTq1RLaGRLULX6Ot3M+vBbVoOZTjylH/qACNuu9l39JYhqnQtE30QxYyuM4ZYhUkv8IU/KqgS4bOjWJ0ZET4fyznNvZQE8/V5UXBmz8a2clKtG72wwjjQPLVO4l6axLb+3yfA5mDdoFm8hjzrPIPnETYkTwCPnAkADHPQ63JjqJ3lEc5w/0+kYsaLJvQRAHPxaRge8EfZAy0NLcu/ycsUEWWQBn8nHaXoV34fE5QXJHSqYj8nfUAACiVNMHGZ2E2sr0dMNOXtZFytPdpAt71V2aXDMUebiG4e+EBibKqePlAPSjKtrAiwiLHqiont6eZloDWUUFHQLS948TLhfA9StloUVuKSA0CE2e5kOP9vJcKqBFKcG7zahR3g17GxVj4Xuepm1sOUK7jUGwp/Q0PnXDdTuVThOgNLr/5Pgj/Ha7+NrhcRBS1OBGrdd1fZHBTCyr7TVeIVkRi8CX1vCj9ERoxsO8SiFffDFGP0ehE0E/YbHCCxcuEDdkiP/0Sf7Y/6WEXmOufsplb2u4I1s8JpLbcDo/nI3fNv24u0IeePAROD2mDEuQIiLUpaIhHOkrlBd1v8Pr/UxhprLsMrKk5p9HBTddtiNnHWHtkNXVyxkctq6cHf5pOUxjl
X-OriginatorOrg: oss.nxp.com
X-MS-Exchange-CrossTenant-Network-Message-Id: be5d96ba-cb99-4d05-2776-08d8fff0d831
X-MS-Exchange-CrossTenant-AuthSource: VI1PR04MB5101.eurprd04.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 15 Apr 2021 09:28:35.8828
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 686ea1d3-bc2b-4c6f-a92c-d99c5c301635
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: 1svMFMKmbZm+f5Tkzu71qkUfM++73JSc+jIdsVz9OlK+ZsUrhWVYc7QC1LPVLQWFq/O11fs8PHxCCHZ7tBwXkS47Qd6K4KkmdBw3xaVgyWE=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: VI1PR04MB7200
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Add generic PMA suspend and resume callback functions for C45 PHYs.

Signed-off-by: Radu Pirea (NXP OSS) <radu-nicolae.pirea@oss.nxp.com>
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

