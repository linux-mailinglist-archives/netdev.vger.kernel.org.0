Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 14F63421733
	for <lists+netdev@lfdr.de>; Mon,  4 Oct 2021 21:17:07 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S238967AbhJDTSa (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 4 Oct 2021 15:18:30 -0400
Received: from mail-am6eur05on2057.outbound.protection.outlook.com ([40.107.22.57]:12353
        "EHLO EUR05-AM6-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S233226AbhJDTSN (ORCPT <rfc822;netdev@vger.kernel.org>);
        Mon, 4 Oct 2021 15:18:13 -0400
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=Gw3rzR+qH/UGaQStnSdRRtVy0YtVcn7kyRCrAEVdaH0gYWbeA5aObiRfG/4WOSbiKgebr+n85H4akX6KNbrzNC7hzWSN6qHmDxKnpktp8vz6I8d8dgrU/JUyjNO2EulsX3t99jN7czydUOZkDJDB3i/BLzhuHorgIrCn3j0hfIfk0rUTKVpDiT3aCC1Ajsd/1q6vLWj5WFnguaIXwGEWfL5Evu2uIKZ+Wx6NyX6lbrWYvZua00LG93WAqnRbWkxJHUarJyJX+BS0f/boi51thcoUhAIFVHjwUTJLLoAEtADP9LmrjeYvbV3d4x7AtaOCU//pAeAFxtzscReFFkFEaA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=iQpI/SKiZJcryo5tqQ5tICaSSYyykdGzHbcj4S8x5MU=;
 b=UDliIK4DEmYZ3DO/RoY7cxY1F61gS+JNuePcSUIKcPjntNMPDRFaGgfOJ1jxvPR8pJ7vDredp5AeUe2rVb7d9RoboIBCIkeLQe7GL30Jp7ZXyRlAECJtokAQxGEwT4R9gL0H9Gl9cetoRZbqVA2a/xpE9yQ7HGd8rGcMpQGP2h8xEoTDYD/YHwI8IkolcTWy+Cz6wgujRM/PeOegUVNhHubJKjOGcxTtREx6yBfJL9Fto2iylyQMkhtqUn+x6g3qRiovdRfFv56FWvxsnvod6m55GCMbn7u/G+Al/XPitpCCuroYcoVZ0w+dogu2HWFbQCRfnKjE+qx1y/i+nl64Jw==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=seco.com; dmarc=pass action=none header.from=seco.com;
 dkim=pass header.d=seco.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=secospa.onmicrosoft.com; s=selector2-secospa-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=iQpI/SKiZJcryo5tqQ5tICaSSYyykdGzHbcj4S8x5MU=;
 b=R34QqN+okyh+ZcRdXRYOi8IVNpeZTgr+VjD4703UKPebcerfZjRC3+FEqUJdbxEYnZkjbz9SGDfJijuk3vLoejjqrem2jtIWF07WnyoYEJEi0MtRuc4R1o85pHXKhnOxquULyVoE3x9TIfg6YH4B4YzzGh+hUx+lf9krf+tYawE=
Authentication-Results: vger.kernel.org; dkim=none (message not signed)
 header.d=none;vger.kernel.org; dmarc=none action=none header.from=seco.com;
Received: from DB7PR03MB4523.eurprd03.prod.outlook.com (2603:10a6:10:19::27)
 by DB6PR0301MB2183.eurprd03.prod.outlook.com (2603:10a6:4:47::7) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4566.22; Mon, 4 Oct
 2021 19:16:08 +0000
Received: from DB7PR03MB4523.eurprd03.prod.outlook.com
 ([fe80::a9aa:f363:66e:fadf]) by DB7PR03MB4523.eurprd03.prod.outlook.com
 ([fe80::a9aa:f363:66e:fadf%6]) with mapi id 15.20.4566.022; Mon, 4 Oct 2021
 19:16:08 +0000
From:   Sean Anderson <sean.anderson@seco.com>
To:     netdev@vger.kernel.org, "David S . Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>, linux-kernel@vger.kernel.org
Cc:     Andrew Lunn <andrew@lunn.ch>,
        Heiner Kallweit <hkallweit1@gmail.com>,
        Russell King <linux@armlinux.org.uk>,
        Sean Anderson <sean.anderson@seco.com>
Subject: [RFC net-next PATCH 13/16] net: phy: Export get_phy_c22_id
Date:   Mon,  4 Oct 2021 15:15:24 -0400
Message-Id: <20211004191527.1610759-14-sean.anderson@seco.com>
X-Mailer: git-send-email 2.25.1
In-Reply-To: <20211004191527.1610759-1-sean.anderson@seco.com>
References: <20211004191527.1610759-1-sean.anderson@seco.com>
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-ClientProxiedBy: MN2PR08CA0023.namprd08.prod.outlook.com
 (2603:10b6:208:239::28) To DB7PR03MB4523.eurprd03.prod.outlook.com
 (2603:10a6:10:19::27)
MIME-Version: 1.0
Received: from plantagenet.inhand.com (50.195.82.171) by MN2PR08CA0023.namprd08.prod.outlook.com (2603:10b6:208:239::28) with Microsoft SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4566.17 via Frontend Transport; Mon, 4 Oct 2021 19:16:07 +0000
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: 7d3f5270-1169-4c60-f3ff-08d9876b6b4d
X-MS-TrafficTypeDiagnostic: DB6PR0301MB2183:
X-MS-Exchange-Transport-Forked: True
X-Microsoft-Antispam-PRVS: <DB6PR0301MB21835ADAC05E5DE47F61982196AE9@DB6PR0301MB2183.eurprd03.prod.outlook.com>
X-MS-Oob-TLC-OOBClassifiers: OLM:446;
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: csXIrHgTdbS29XW9ld/JmT/W1yZ5QTogyMbAxe5/FqmO/qQVNO/fM8FkJvHr7iGPE+CIvRxOaaVej3kKkVQVXei4sqisV4GaxT1pwh46bEg7fDqmk/3+V8GEniBrgVhn1dB3HgJVBr7BpB0Znf6gOaM8Hk23AHwodrs2kkfDCIzCApvuX9ddmSOW7y7K+p3NHMEVd1AqlJ93fu3ZEBoK1FO4S8a41QYOHPNg3aDNhl5r20rRbuwGHSj4mkWambwsfbgSwfjSOaQN9bB9dakGYmhut7h11dFusMfRt5EghhQsZiZAWWIfY1o8JEiSicb1D9AER/xePTDsVjuECP3X+W1RfIwqvRGHCHeNiNnCRx5g6AYaZeMDNuUTlWBx4ct0fuJyHiWMD+so3AtP7UcB66opZvaAX0PFfP+OyFNwVPvS9hsmWv+V3b84l92Cr3WoENQV8t2mwNJ5X9Itm+yn0Xhtv8orBU7rBoPod+opLC+cFmfU+YCyArm8zWV4Wkk90CIgAuB73g/D2ozzi/h67y7a4SNGVKGzn2wnR9qtILTaiQqNzLlqbAAXNqCk7L6x/RXUplJBeSXUhQRsjeYKYTiR13dFAgCPGG3ZzDJ9nud9OQo6j/l2Y06HgH0ClXjkkW85v2B4oIa2y5izxv56YZ6F0bryz7xxHetBydCn9O6BvJZeoCcb1Bi/YI7iNsddYstUoOPFChYg5IjNrFch6g==
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:DB7PR03MB4523.eurprd03.prod.outlook.com;PTR:;CAT:NONE;SFS:(366004)(508600001)(186003)(83380400001)(2906002)(54906003)(5660300002)(1076003)(52116002)(26005)(66946007)(66476007)(66556008)(44832011)(8936002)(110136005)(6506007)(2616005)(107886003)(316002)(6486002)(6666004)(36756003)(8676002)(4326008)(956004)(38350700002)(6512007)(38100700002)(86362001);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?us-ascii?Q?nC/iYoJ6kSdaSvIKRUI9cJHR9jRarNxdo6Dvg4Y89JhrgkHJ+e6DWDWThjID?=
 =?us-ascii?Q?/3/IZEgfbI2iil92r9n/29TKBLyeLHFXfR9p/zp6Ozm0Y2ZKXJ5R3YHE0dav?=
 =?us-ascii?Q?op8YlL/MLTdUS6UvY6YUCMDWxutfXKzrAZJmbGDLnLnPFoSElHe+VP/ilA5E?=
 =?us-ascii?Q?13USWc4IE6iwnf00iiJAbrbnz33EWSsy+IaStK+a2tC5dqh0hqRImy9BdBP1?=
 =?us-ascii?Q?UmJtKdtDJKDFLkEfcA2NRlhGPLvLnI+ndIzls4X31rR6iwJ1REUMK5xxpfly?=
 =?us-ascii?Q?kYbrV/gUiJuUxu3LRBMxbIN+C8teA7/DWnYxwYACehdBFzuNO/gscxCy+sa5?=
 =?us-ascii?Q?wBE9j7y3/DQWApKVm5VFjlZypP5ubE7qgXk4jn220d8+C9xlodTpjEI8cPyI?=
 =?us-ascii?Q?528TzjHWkRwGe3ELbM07qw1apZzEtdWTPKCSiNBda6d36Ay7NM3xXs9DhO2j?=
 =?us-ascii?Q?db0gyulKiN5jV0QlRPE7GC7cMCsyfXtXKVU523XGMQBzqnXgpEfPfH9TCM15?=
 =?us-ascii?Q?vJK3LVYjrb5KhTpD8vmRszd1+ZfEg515VIR/xtCW4wvAUZ6fWetD5EzSKQbl?=
 =?us-ascii?Q?Q2Lso0wh/1LoTQLntzRTgxNJJwRHYHDd84CeP/M5QjNXjB1fl00xZQ7vvli2?=
 =?us-ascii?Q?MfLXo1yj61LnrnQUue91xcVybZ4T9rI6ELAipNjiFt4mXGuvilKiMu81Y3L4?=
 =?us-ascii?Q?TLHyeCU6Jj6gmQswD71G5Cz4c1pqgFVV4vaIF3NSmukcWTp76eD32mjWp7Zw?=
 =?us-ascii?Q?eAR3tvBHC9pMe7HAaA6ZjDGC/7lOivSaNtkIPA8kE9LrYxVccL/1NO+HMl3O?=
 =?us-ascii?Q?IRGVfJrd0Umb8csFB9hyafDGKOIsbDpPdsRNj9PsraukLV6BWh5kA31hBTsl?=
 =?us-ascii?Q?0NhjHrINWx8Yn/S+cmxFWQuehJ+VX3y2lRw9jdSQf0R3LMXSxX5f3WaeKUfL?=
 =?us-ascii?Q?bOi6Z+GaR3ijgvSx+N1tIYG775oJs9Ykf4DOsW3gGgayRSt9VyqTA0VMHKcI?=
 =?us-ascii?Q?UkLRKHBuY19XCHdjQbUq2EfDI10u4BNGWqmlWgTx7dROfmZYOhw+LuXgZ4w9?=
 =?us-ascii?Q?kOC4wrtYMgDyXe0nBgBa1NHcigfiB2Zv3gcijniv9LpEudDemb+7/j0NIXBN?=
 =?us-ascii?Q?k1HJJGppr/ENAjYuZpZEFTBVUVVbJ4Jf+EQpKIj1nJl6PF68XBATc2djUuP8?=
 =?us-ascii?Q?09runl+5Y46uc2cAnx2sVsrTdzdEQA24lqRHSklLmlxezlGmGSQv24qZzqpb?=
 =?us-ascii?Q?l7zyh8BkV7ndyDnFPWE+x0LOrAADB1hRHSvPXL1cFe1z6AnIKcj+FX4y/8DK?=
 =?us-ascii?Q?Vvzm9j+DnzzskKPsvc5eMD1n?=
X-OriginatorOrg: seco.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 7d3f5270-1169-4c60-f3ff-08d9876b6b4d
X-MS-Exchange-CrossTenant-AuthSource: DB7PR03MB4523.eurprd03.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 04 Oct 2021 19:16:08.4261
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: bebe97c3-6438-442e-ade3-ff17aa50e733
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: kb+AUXvTe3Hi7wgu+p5M6E60+Go4CBxjlTGQdXThK7EbZfOEfjllhBfl4C1lHnmQHfEr9B0aomd41LKXQTGijw==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: DB6PR0301MB2183
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

This function is useful when probing MDIO devices which present a
phy-like interface despite not using the Linux ethernet phy subsystem.

Signed-off-by: Sean Anderson <sean.anderson@seco.com>
---

 drivers/net/phy/phy_device.c | 3 ++-
 include/linux/phy.h          | 1 +
 2 files changed, 3 insertions(+), 1 deletion(-)

diff --git a/drivers/net/phy/phy_device.c b/drivers/net/phy/phy_device.c
index ba5ad86ec826..c75b189f1a3e 100644
--- a/drivers/net/phy/phy_device.c
+++ b/drivers/net/phy/phy_device.c
@@ -805,7 +805,7 @@ static int get_phy_c45_ids(struct mii_bus *bus, int addr,
  * valid, %-EIO on bus access error, or %-ENODEV if no device responds
  * or invalid ID.
  */
-static int get_phy_c22_id(struct mii_bus *bus, int addr, u32 *phy_id)
+int get_phy_c22_id(struct mii_bus *bus, int addr, u32 *phy_id)
 {
 	int phy_reg;
 
@@ -833,6 +833,7 @@ static int get_phy_c22_id(struct mii_bus *bus, int addr, u32 *phy_id)
 
 	return 0;
 }
+EXPORT_SYMBOL_GPL(get_phy_c22_id);
 
 /* Extract the phy ID from the compatible string of the form
  * ethernet-phy-idAAAA.BBBB.
diff --git a/include/linux/phy.h b/include/linux/phy.h
index 736e1d1a47c4..206049c0f587 100644
--- a/include/linux/phy.h
+++ b/include/linux/phy.h
@@ -1381,6 +1381,7 @@ struct phy_device *phy_device_create(struct mii_bus *bus, int addr, u32 phy_id,
 				     bool is_c45,
 				     struct phy_c45_device_ids *c45_ids);
 #if IS_ENABLED(CONFIG_PHYLIB)
+int get_phy_c22_id(struct mii_bus *bus, int addr, u32 *phy_id);
 int fwnode_get_phy_id(struct fwnode_handle *fwnode, u32 *phy_id);
 struct mdio_device *fwnode_mdio_find_device(struct fwnode_handle *fwnode);
 struct phy_device *fwnode_phy_find_device(struct fwnode_handle *phy_fwnode);
-- 
2.25.1

