Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id CE2D1336C0C
	for <lists+netdev@lfdr.de>; Thu, 11 Mar 2021 07:22:08 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230426AbhCKGVi (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 11 Mar 2021 01:21:38 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:39270 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230236AbhCKGVG (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 11 Mar 2021 01:21:06 -0500
Received: from EUR04-HE1-obe.outbound.protection.outlook.com (mail-he1eur04on0612.outbound.protection.outlook.com [IPv6:2a01:111:f400:fe0d::612])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id C9E80C061760;
        Wed, 10 Mar 2021 22:21:05 -0800 (PST)
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=VL0NoYC8NpHMHPztvwwSh3wEqIj82A/1tTXzor+MkQZ+vIbqz4DtWnc5mqP9l4PqCNVv0wJiIML0ZOeqdi+Bs51b6adEZ48TIeOpfj/GeM9pXw8GzjW1DW8EYB37RG5PEWaOaX8Wv8uckw6nY0R3EdypF0uzFbSxhiWVUS3KCY0n8xo3W03iRtYI3ArzDJ24fF6A9W8hrC/KM4lTy0qnWmch7WFHHLPviEx/8Bgef09x9m5DCzO5jHyGFC0e8lvn7DuvXYkEClVLAB1zx6bWNEjExmHRzulIq5upRXVPX/6XKUCFykMgH0jXlV28I+xrcBNGGmQIDGOPu/EIp+24nQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=AyDtI2Azne/VIEWFO+kBwKlpm+Ru9nL1MKRh6DMTeRM=;
 b=enxw2uwwvJx2gW5M0+ad1WGr0nrmTyF6JonY2jQt0sFEZrJUgnv3n/00L+UrQJQ+OTK8gDUR1DFw4HgMchSsExMb3QgSKvZpGDoIuzfmrLj1wuNEAm5x8gMOC5o5ITRfcIKPO9gr/1Y6lJ3dhR0+9dwmLi1q73wo0yxrgfH5vThDB3GII+cKwBYm5mMO0DWryBOQCCq11jmYFZc72OZiq09OmcG0glPhb6SB+B1NlyV6Tc6KqVeBjSwKsfch7VrYrAgsccp7T7hcwZ9snd5MLQC/klIwBvqrpFsOoivgTIxh7zJ9yDp7lnO9ZnWGeCXxq8yvbfN/0neP5wpNetML5A==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=oss.nxp.com; dmarc=pass action=none header.from=oss.nxp.com;
 dkim=pass header.d=oss.nxp.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=NXP1.onmicrosoft.com;
 s=selector2-NXP1-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=AyDtI2Azne/VIEWFO+kBwKlpm+Ru9nL1MKRh6DMTeRM=;
 b=AchWl3IWXJa38DL4pqjBTPaMAJhCQ8DVAEkfOECyHcK5JRC445gPBHc2Dx2Ox8i7k6AoohN68EDmg8lfGgD1gpjFPDBSGxWF0rtjk+X4FgyiGw62xcYa584fWL8W8Zmyzbzs99m7QX8MkasYa1B9c5b1weEKfvRgl94uEdLU6qA=
Authentication-Results: arm.com; dkim=none (message not signed)
 header.d=none;arm.com; dmarc=none action=none header.from=oss.nxp.com;
Received: from AM0PR04MB5636.eurprd04.prod.outlook.com (2603:10a6:208:130::22)
 by AM0PR04MB5473.eurprd04.prod.outlook.com (2603:10a6:208:112::32) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.3912.26; Thu, 11 Mar
 2021 06:21:01 +0000
Received: from AM0PR04MB5636.eurprd04.prod.outlook.com
 ([fe80::1cd:7101:5570:cd79]) by AM0PR04MB5636.eurprd04.prod.outlook.com
 ([fe80::1cd:7101:5570:cd79%7]) with mapi id 15.20.3912.027; Thu, 11 Mar 2021
 06:21:01 +0000
From:   Calvin Johnson <calvin.johnson@oss.nxp.com>
To:     Grant Likely <grant.likely@arm.com>,
        "Rafael J . Wysocki" <rafael@kernel.org>,
        Jeremy Linton <jeremy.linton@arm.com>,
        Andrew Lunn <andrew@lunn.ch>,
        Andy Shevchenko <andy.shevchenko@gmail.com>,
        Florian Fainelli <f.fainelli@gmail.com>,
        Russell King - ARM Linux admin <linux@armlinux.org.uk>,
        Cristi Sovaiala <cristian.sovaiala@nxp.com>,
        Florin Laurentiu Chiculita <florinlaurentiu.chiculita@nxp.com>,
        Ioana Ciornei <ioana.ciornei@nxp.com>,
        Madalin Bucur <madalin.bucur@oss.nxp.com>,
        Heikki Krogerus <heikki.krogerus@linux.intel.com>,
        Marcin Wojtas <mw@semihalf.com>,
        Pieter Jansen Van Vuuren <pieter.jansenvv@bamboosystems.io>,
        Jon <jon@solid-run.com>, Saravana Kannan <saravanak@google.com>,
        Randy Dunlap <rdunlap@infradead.org>
Cc:     linux-arm-kernel@lists.infradead.org,
        Diana Madalina Craciun <diana.craciun@nxp.com>,
        linux-acpi@vger.kernel.org, linux-kernel@vger.kernel.org,
        linux.cj@gmail.com, netdev@vger.kernel.org,
        Laurentiu Tudor <laurentiu.tudor@nxp.com>,
        Calvin Johnson <calvin.johnson@oss.nxp.com>,
        "David S. Miller" <davem@davemloft.net>,
        Heiner Kallweit <hkallweit1@gmail.com>,
        Jakub Kicinski <kuba@kernel.org>
Subject: [net-next PATCH v7 02/16] net: phy: Introduce fwnode_mdio_find_device()
Date:   Thu, 11 Mar 2021 11:49:57 +0530
Message-Id: <20210311062011.8054-3-calvin.johnson@oss.nxp.com>
X-Mailer: git-send-email 2.17.1
In-Reply-To: <20210311062011.8054-1-calvin.johnson@oss.nxp.com>
References: <20210311062011.8054-1-calvin.johnson@oss.nxp.com>
Content-Type: text/plain
X-Originating-IP: [14.142.151.118]
X-ClientProxiedBy: HKAPR03CA0026.apcprd03.prod.outlook.com
 (2603:1096:203:c9::13) To AM0PR04MB5636.eurprd04.prod.outlook.com
 (2603:10a6:208:130::22)
MIME-Version: 1.0
X-MS-Exchange-MessageSentRepresentingType: 1
Received: from lsv03152.swis.in-blr01.nxp.com (14.142.151.118) by HKAPR03CA0026.apcprd03.prod.outlook.com (2603:1096:203:c9::13) with Microsoft SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.3955.9 via Frontend Transport; Thu, 11 Mar 2021 06:20:52 +0000
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-HT: Tenant
X-MS-Office365-Filtering-Correlation-Id: 50792285-bfa6-4eeb-d6da-08d8e455d72d
X-MS-TrafficTypeDiagnostic: AM0PR04MB5473:
X-MS-Exchange-SharedMailbox-RoutingAgent-Processed: True
X-MS-Exchange-Transport-Forked: True
X-Microsoft-Antispam-PRVS: <AM0PR04MB547362792ABE626CC0EE0679D2909@AM0PR04MB5473.eurprd04.prod.outlook.com>
X-MS-Oob-TLC-OOBClassifiers: OLM:6108;
X-MS-Exchange-SenderADCheck: 1
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: y3s9U3HySg7RzM0ulEKr32CZaqOVyH9eRG2XzHXDlO48UuqHoCQyq4iHN+XudnmwzJUy8bATATrkkfwxGN5ddUwMnXzvnH5jHnetpObspEJQsKhdWsloFKOyB8jtm6+STemPWiqIUg5MyplchFHJXPkWflHyqHBWXjlGi665MuoYTM3LQNVZXlCc/CqOZYEJHUcRdzaqYV1wGAnH0dlJcuhDb/Scq+8XW9DFyo/frize27Uh53IeZMhw+B7Hd3TFJWqka5HEIBpaUnw6rZhzCTD7Q4MCHWxjojgLLuEc1SJFtQdBxS/GnV9D+w/Hujk7xFmNSRD99bz6dvQSR/OspVG8qs75QYd/RQ4Et1+lalpmX7BnyFejknLsIIgcXhrOh3HEPpogx1jaqLZVJW47S4/fM2iAusplJc2ZRGeAc/+myo24lQ4bSVpfrzaPZrlo4tFJ7jYB366hmLClsc6l4El+0qEEHt9WEA8VSQLH9aH5y7g1V9eHleg2ST71hzpXu18K7RyoI+dsRJerfii/0pytq3uDTkMEmcoEuDF2nK6wzdnDAVnKSRezTEd+3Ly2bRAJXOnmupT9ahR/JMPiYsLHLPEgKHiEYuemF8ivZ1o=
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:AM0PR04MB5636.eurprd04.prod.outlook.com;PTR:;CAT:NONE;SFS:(4636009)(366004)(39860400002)(136003)(346002)(376002)(396003)(44832011)(186003)(54906003)(66476007)(52116002)(5660300002)(110136005)(1076003)(66946007)(2906002)(316002)(16526019)(6486002)(921005)(4326008)(478600001)(83380400001)(6506007)(26005)(2616005)(6512007)(8936002)(7416002)(55236004)(1006002)(8676002)(86362001)(66556008)(956004)(110426009);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData: =?us-ascii?Q?ezc+YpJFGzofJlgUOc7ts/z0za7LarbF6jDYXJfbQwiUWruyfH9pX+mxa5cA?=
 =?us-ascii?Q?GMVgrJDkaYq5M5XzJWrVGEjfx8FV5SjpuvNNJPugRrmpOTK5qxRk81mUAPjR?=
 =?us-ascii?Q?p9NxMR+uqi2yY5Gk4A8HOkKM2figjX4cnlM5UTrsqx9oABqz0FtQ0xIE8m2C?=
 =?us-ascii?Q?8xiui6oMZxGnKbg4Q5WtaUVUWxxmsNWq6i7Ko34OXs8iziD5Vl/sBYvRmoog?=
 =?us-ascii?Q?DwCtyrqpGK4drbu09CMQGnW8IqDihFAi3gMGDWdwg8hM8ZCcACc/LOB6KwTB?=
 =?us-ascii?Q?KfLvtu+iIGIG/etsbsgkjz5Z8qmbwNmnTfbHuVwIVP6JNE/onpsGsRhqMdGN?=
 =?us-ascii?Q?oZSthd0tuQ+T/AEPutmro4BlFJxKsN/m3XbLPwtjpGd+4ZfsRwksd4KoZBt3?=
 =?us-ascii?Q?MhjsuN1VgP3xIDXKhZBYijGqXMrFFUS5xyY6i8/1/abxsBvXjcNlvjm3ph7m?=
 =?us-ascii?Q?B7eZ915qP3i7cQmP1WqA+IgpGzaFZqk6UwxHgBvmXOT+p537biSV4qe3rKCR?=
 =?us-ascii?Q?V6O/FpH80pro8uL3JYoSj0dM28+5qQiGRBFqgOfqCZeASqYmO8gVlfFj+YcZ?=
 =?us-ascii?Q?W0Gh1xsGR1VV4xgvXHjIbda5iTd275AbCQf9LtpUvNQPGfkLI0s2T74c1S9/?=
 =?us-ascii?Q?aEu/qnKv5xkH3GnbPGc9KYFEGRob2hpO6x5YMRIs6A2J9O34yPbbHEDZFymG?=
 =?us-ascii?Q?SetmJ5rGFigcYtJsrO9nBE6Mp6EHEde1tSL6fNhxIUjlMAPeztJQzRJp6mP/?=
 =?us-ascii?Q?+aWTpdlZye78GTSc0sx5hp7GqOYMBo3lN5CJQxUrggKBUx+951Dh2nRCMnF5?=
 =?us-ascii?Q?yGzMK7p792/u1QfWNafN+DonrtCpoxQJaWDVMtraTklkJbp0jF6d8j/KTSVO?=
 =?us-ascii?Q?TxfYwmZ9vclS0WYpBID84jhOw9w3PgxMG/O1aeL0BCDGXBtSnyWxOv3ykYkA?=
 =?us-ascii?Q?BfxvRj9iX3gjxeyMnwBbVhyyhhbUs19NTXjiYRq6+ZcEL25U3Lu+y0FJ2l5t?=
 =?us-ascii?Q?AGd4ZVfiwUQTlhWU7LejXVGKV6H1Msju54MaC+kZLk4FNnrJrt9tiEjBZgfc?=
 =?us-ascii?Q?z49AKtu8gEQF+qdNy4hCqWA09PMlt+a3EwQ2mhK2Q4k+z0G5Jrv3DxT7DnOh?=
 =?us-ascii?Q?GccHgwQ1SpRITvibpS9OP29qiY2dxVBaTt5tckF4M4A950Pn0G0rRJUTL6dL?=
 =?us-ascii?Q?JY92y+2SgwOAYQSywBV5O76mfSdlAVIQPhoaatKU6QELfwNHXIzZJf0gV1IF?=
 =?us-ascii?Q?UXPnjLfp1uYiPWCRIy7Mn5gS5CypcZUMtTZPXaz/ssW8J12HMFNh/cDBo3v9?=
 =?us-ascii?Q?MPRpa84kWNXpTM/C5UtrFpkq?=
X-OriginatorOrg: oss.nxp.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 50792285-bfa6-4eeb-d6da-08d8e455d72d
X-MS-Exchange-CrossTenant-AuthSource: AM0PR04MB5636.eurprd04.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 11 Mar 2021 06:21:01.0811
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 686ea1d3-bc2b-4c6f-a92c-d99c5c301635
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: mWJ5ttTKy5vxg426gV+anJzMJllF+AQjYSgQ4iLcAenVKwJxMMIqaOsvQEdsvrFE5EWgw9hRBMtix6HDJ076Rg==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: AM0PR04MB5473
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Define fwnode_mdio_find_device() to get a pointer to the
mdio_device from fwnode passed to the function.

Refactor of_mdio_find_device() to use fwnode_mdio_find_device().

Signed-off-by: Calvin Johnson <calvin.johnson@oss.nxp.com>
---

Changes in v7:
- correct fwnode_mdio_find_device() description

Changes in v6:
- fix warning for function parameter of fwnode_mdio_find_device()

Changes in v5: None
Changes in v4: None
Changes in v3: None
Changes in v2: None

 drivers/net/mdio/of_mdio.c   | 11 +----------
 drivers/net/phy/phy_device.c | 23 +++++++++++++++++++++++
 include/linux/phy.h          |  6 ++++++
 3 files changed, 30 insertions(+), 10 deletions(-)

diff --git a/drivers/net/mdio/of_mdio.c b/drivers/net/mdio/of_mdio.c
index ea9d5855fb52..d5e0970b2561 100644
--- a/drivers/net/mdio/of_mdio.c
+++ b/drivers/net/mdio/of_mdio.c
@@ -347,16 +347,7 @@ EXPORT_SYMBOL(of_mdiobus_register);
  */
 struct mdio_device *of_mdio_find_device(struct device_node *np)
 {
-	struct device *d;
-
-	if (!np)
-		return NULL;
-
-	d = bus_find_device_by_of_node(&mdio_bus_type, np);
-	if (!d)
-		return NULL;
-
-	return to_mdio_device(d);
+	return fwnode_mdio_find_device(of_fwnode_handle(np));
 }
 EXPORT_SYMBOL(of_mdio_find_device);
 
diff --git a/drivers/net/phy/phy_device.c b/drivers/net/phy/phy_device.c
index cc38e326405a..daabb17bba00 100644
--- a/drivers/net/phy/phy_device.c
+++ b/drivers/net/phy/phy_device.c
@@ -2819,6 +2819,29 @@ static bool phy_drv_supports_irq(struct phy_driver *phydrv)
 	return phydrv->config_intr && phydrv->handle_interrupt;
 }
 
+/**
+ * fwnode_mdio_find_device - Given a fwnode, find the mdio_device
+ * @fwnode: pointer to the mdio_device's fwnode
+ *
+ * If successful, returns a pointer to the mdio_device with the embedded
+ * struct device refcount incremented by one, or NULL on failure.
+ * The caller should call put_device() on the mdio_device after its use.
+ */
+struct mdio_device *fwnode_mdio_find_device(struct fwnode_handle *fwnode)
+{
+	struct device *d;
+
+	if (!fwnode)
+		return NULL;
+
+	d = bus_find_device_by_fwnode(&mdio_bus_type, fwnode);
+	if (!d)
+		return NULL;
+
+	return to_mdio_device(d);
+}
+EXPORT_SYMBOL(fwnode_mdio_find_device);
+
 /**
  * phy_probe - probe and init a PHY device
  * @dev: device to probe and init
diff --git a/include/linux/phy.h b/include/linux/phy.h
index 1a12e4436b5b..f5eb1e3981a1 100644
--- a/include/linux/phy.h
+++ b/include/linux/phy.h
@@ -1366,11 +1366,17 @@ struct phy_device *phy_device_create(struct mii_bus *bus, int addr, u32 phy_id,
 				     bool is_c45,
 				     struct phy_c45_device_ids *c45_ids);
 #if IS_ENABLED(CONFIG_PHYLIB)
+struct mdio_device *fwnode_mdio_find_device(struct fwnode_handle *fwnode);
 struct phy_device *get_phy_device(struct mii_bus *bus, int addr, bool is_c45);
 int phy_device_register(struct phy_device *phy);
 void phy_device_free(struct phy_device *phydev);
 #else
 static inline
+struct mdio_device *fwnode_mdio_find_device(struct fwnode_handle *fwnode)
+{
+	return 0;
+}
+static inline
 struct phy_device *get_phy_device(struct mii_bus *bus, int addr, bool is_c45)
 {
 	return NULL;
-- 
2.17.1

