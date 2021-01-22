Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 0AA42300ACD
	for <lists+netdev@lfdr.de>; Fri, 22 Jan 2021 19:19:39 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729160AbhAVPp7 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 22 Jan 2021 10:45:59 -0500
Received: from mail-eopbgr70042.outbound.protection.outlook.com ([40.107.7.42]:4995
        "EHLO EUR04-HE1-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1729112AbhAVPow (ORCPT <rfc822;netdev@vger.kernel.org>);
        Fri, 22 Jan 2021 10:44:52 -0500
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=nMx0ddB3IiCP0JVCvjW/Wk2yEtt7jWgLuwNEULsrup1wczRpFpdzPoXZnoHYh3VrpdgbVBsiHjvls30fi0i8hKjSTIN3XTpv7pRl/iKiqGmmdKNTCwQ9EjLDcRaojGyyFPPexbFdAmOYSWZgEBdSe4XvjAAuIiSzTTEPklq/oIMvs9uzrb3BgPu60t67TzUxBE7g4DyNlZn7d14UgxIwGSDcr9E/gpaptinXr5r6o9THZAE7vjQylEh6ZIesHA7Png8zmGbJeLndSbgVsmDCcqyVTIKihapmXoE233clE6LDZTWnebaTXaT8UfBZXMvrie+7Vy8MWBGsaIyDqewOwQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=W7tfLxUdi6KJH3b07Jdvt+VxOekfG6MptStdiZcuLv4=;
 b=acvfSue/wS4wbRb802jApNH8si5kUclbapyqRVMDBdhTG1JpURbof8Lsp6em+HPTCreooAlDSuYYGROZGUsku9jmZUXbfiaBtog2ku5NLQmjV2Z+l+ClRnw3zmrEQpNFslLWIFnt1N21ocvQI0KZQemcvvCYTFLmwKUYI91IvwiLG+DcovYMRPYTrxq64RHP7E0iSKtmg9pltnT7Jgohp6NNvg5GYO0YNdf/ibvN5R65xCkYHSgNV5qrmXR+eqO9vJSSfaNE7heC+9L861vBQcjw+jSedmDsnhfxnR4tsqEA6uy9HxclwdMIoLuWEIO+pRIn4K3eNDeR+ZM5QeecjQ==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=oss.nxp.com; dmarc=pass action=none header.from=oss.nxp.com;
 dkim=pass header.d=oss.nxp.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=NXP1.onmicrosoft.com;
 s=selector2-NXP1-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=W7tfLxUdi6KJH3b07Jdvt+VxOekfG6MptStdiZcuLv4=;
 b=LHARkbHRi4OE0lPifltqOU4dfb3rSqJr9IAeiLF0ZwoVJT4imr9byAN0X2OAQAOYi9CJWrlZzzjO7lqOesq3Mxv3OCSAFpgj3oKP0ZHpFL8kCkmVjemjMqKOB60MLgxnrhuFCmYfpcUE7JHHoju1sw7h318L53n6itkJZ5Yc79A=
Authentication-Results: arm.com; dkim=none (message not signed)
 header.d=none;arm.com; dmarc=none action=none header.from=oss.nxp.com;
Received: from AM0PR04MB5636.eurprd04.prod.outlook.com (2603:10a6:208:130::22)
 by AM0PR0402MB3443.eurprd04.prod.outlook.com (2603:10a6:208:1b::15) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.3784.12; Fri, 22 Jan
 2021 15:43:55 +0000
Received: from AM0PR04MB5636.eurprd04.prod.outlook.com
 ([fe80::e90e:b1d6:18a2:2d42]) by AM0PR04MB5636.eurprd04.prod.outlook.com
 ([fe80::e90e:b1d6:18a2:2d42%5]) with mapi id 15.20.3784.015; Fri, 22 Jan 2021
 15:43:55 +0000
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
Cc:     linux.cj@gmail.com, Diana Madalina Craciun <diana.craciun@nxp.com>,
        linux-acpi@vger.kernel.org, linux-arm-kernel@lists.infradead.org,
        linux-kernel@vger.kernel.org, netdev@vger.kernel.org,
        Laurentiu Tudor <laurentiu.tudor@nxp.com>,
        Calvin Johnson <calvin.johnson@oss.nxp.com>,
        "David S. Miller" <davem@davemloft.net>,
        Heiner Kallweit <hkallweit1@gmail.com>,
        Jakub Kicinski <kuba@kernel.org>
Subject: [net-next PATCH v4 02/15] net: phy: Introduce fwnode_mdio_find_device()
Date:   Fri, 22 Jan 2021 21:12:47 +0530
Message-Id: <20210122154300.7628-3-calvin.johnson@oss.nxp.com>
X-Mailer: git-send-email 2.17.1
In-Reply-To: <20210122154300.7628-1-calvin.johnson@oss.nxp.com>
References: <20210122154300.7628-1-calvin.johnson@oss.nxp.com>
Content-Type: text/plain
X-Originating-IP: [14.142.151.118]
X-ClientProxiedBy: SG2PR06CA0117.apcprd06.prod.outlook.com
 (2603:1096:1:1d::19) To AM0PR04MB5636.eurprd04.prod.outlook.com
 (2603:10a6:208:130::22)
MIME-Version: 1.0
X-MS-Exchange-MessageSentRepresentingType: 1
Received: from lsv03152.swis.in-blr01.nxp.com (14.142.151.118) by SG2PR06CA0117.apcprd06.prod.outlook.com (2603:1096:1:1d::19) with Microsoft SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.3784.12 via Frontend Transport; Fri, 22 Jan 2021 15:43:48 +0000
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-HT: Tenant
X-MS-Office365-Filtering-Correlation-Id: 7f4dec28-bd52-4202-00f7-08d8beec864f
X-MS-TrafficTypeDiagnostic: AM0PR0402MB3443:
X-MS-Exchange-SharedMailbox-RoutingAgent-Processed: True
X-MS-Exchange-Transport-Forked: True
X-Microsoft-Antispam-PRVS: <AM0PR0402MB3443B0B73C096767CB15E439D2A00@AM0PR0402MB3443.eurprd04.prod.outlook.com>
X-MS-Oob-TLC-OOBClassifiers: OLM:5797;
X-MS-Exchange-SenderADCheck: 1
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: QaoeTDlIZzB7ZmVehbuEMNVX+rwwKmYSUTpgJtKvMWjkTJcYlfygHgI6Bvzy/IQRig4cu9eaWiAfbHQdut2nae6ews+xT8Mhve7cRun0aK4t9UrMrEhn/EnzUJJF1dEInJ9RQ1BOPWNrH5HsgqfABpIRO1CM7yq+Uvri/FkmhLT6MGGnvObCdqx51EHDr4JtVT1eNEc6LFtRBgur/a3MH2bjiq2qHXOt1YkZDgpGAMmiDhLY16J3tnNjIDW+Gunh9vufjk8wNGy8Z3a7XVVU7jPdcd9rWo31JG99DMCj5sVsx+W0FwLFNTWswQ/b45jSRm7FIBkWSBynh46fjfF4r13m62iaOXSYUwuu/JDTO6tv7VtA+G+6iANB9oJkqMKbM7jIJ0r6OxRi2Fr1OwLyU46TeQrCdQiTWBWyiAZbLIV4OTLFx3dVk1OQ8Rmb5iZa5Tj9/I3hQz8rUNuB+Rw0HA==
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:AM0PR04MB5636.eurprd04.prod.outlook.com;PTR:;CAT:NONE;SFS:(4636009)(376002)(346002)(136003)(396003)(39850400004)(366004)(2906002)(6506007)(921005)(6512007)(186003)(5660300002)(1006002)(16526019)(52116002)(54906003)(956004)(55236004)(8676002)(66556008)(8936002)(83380400001)(66476007)(2616005)(66946007)(1076003)(478600001)(26005)(110136005)(86362001)(316002)(7416002)(4326008)(6486002)(44832011)(110426009);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData: =?us-ascii?Q?89gigSkZ84tJVYv4HphGfLUX1MvGmCUy+G+g6MlB/iCtqfElzHuGZdeC1kGO?=
 =?us-ascii?Q?tnvzl4hyE8HeG5wyeYbHnVQt+RIZsgIeZjfSPMHtzRZwffoM+Mqstdfe9KKr?=
 =?us-ascii?Q?t8c7X5IFQcYxmHWXfWgeS2+qUdrMFWk0UMfj9IXuDvK8DAn5QtYMAqTH5pAy?=
 =?us-ascii?Q?UsR/7K82JE//Vk3zL5Ym6ql0nHEgP33dzBHgJKnsJtjb3wtt1jOQ6M3R8uE1?=
 =?us-ascii?Q?Ax/XuHQuTNfUK8lt7L5TFw2IsZUanDOkOtgFja9p2Cr3rlN46Ge3XHC4F6sX?=
 =?us-ascii?Q?sBIyG4XX99/BTEydXEnm6qwOFkCXW1IlwMuiLE/iKkqfa5zR9I1doRFw+tpm?=
 =?us-ascii?Q?aqj9T1JSSt31L5ZRDJ8J5ASaeZtxemKNFRFx+OHc3tXsycVVZ7S72zlNcqeD?=
 =?us-ascii?Q?u0FJ32+1lS1F5FAoMdOsfYX8jeW1r+wDRxNKiZh8XRnAyTfNP08U6Pc0Pu3+?=
 =?us-ascii?Q?K4NDV7a6ugDZRb7J3twjFo1bqpvLXE5vkGXzih1knezlDKq4tqVvhwgLMiPy?=
 =?us-ascii?Q?oC2HKRsl0y8mcq9nr/YOj/99K6GYSGagzXKt8AQebTTH3ZncFQGxMAszOdls?=
 =?us-ascii?Q?YUKVvjnpgPch1O59tTTYNpkIsUdLx5BmDLPYB5+oVenC3WDwcdHMiw5mA/w4?=
 =?us-ascii?Q?l/W5y8h5Eiu2n1xLpOOxSDw6KIgXk8Tn9NCOksboJSeGaWq/j3qIpYPHeKl3?=
 =?us-ascii?Q?34vcv0dzUVC4DJOUb70vUe9xi+rWZzbMRXNCWbEAidffWXQIzye1D0UQFAsL?=
 =?us-ascii?Q?uhPPYtcQKtnmtM8W3Loj5KRqRAMTZBAGdY7wI/1tG5UWm4QSIeMQ35N98wVM?=
 =?us-ascii?Q?IX+lsDEziJ7pFdkXCp/ek69yPF6/aeJeOxkYQgKx1bpeGtzTMQbR56FtGRuk?=
 =?us-ascii?Q?RvH6ToYbMPExwy7KX8ue1cXQvKugatf+vgZlVywB+mfwmqIeYOvX38SmTKAl?=
 =?us-ascii?Q?ljPsTdVIwHo994OeQ+MEEw6YvbbhvGGh7EINGVo31CYSq4ZXs7iEXQje2hgS?=
 =?us-ascii?Q?odmP2NYEU6dLSpuywI5mzXFE754biyQ7k/uZ60WEUTQxhtyvOml8R5bycE4E?=
 =?us-ascii?Q?XasFVJPP?=
X-OriginatorOrg: oss.nxp.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 7f4dec28-bd52-4202-00f7-08d8beec864f
X-MS-Exchange-CrossTenant-AuthSource: AM0PR04MB5636.eurprd04.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 22 Jan 2021 15:43:55.0407
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 686ea1d3-bc2b-4c6f-a92c-d99c5c301635
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: lcWCNaInnj2TlefX7zb1OOrYEn5/N7f/VCPwF5I6ctjhV9UqYNo/4a+LywcXRzCW76yCGIbF7y5ClX6pj1O0aA==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: AM0PR0402MB3443
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Define fwnode_mdio_find_device() to get a pointer to the
mdio_device from fwnode passed to the function.

Signed-off-by: Calvin Johnson <calvin.johnson@oss.nxp.com>
---

Changes in v4: None
Changes in v3: None
Changes in v2: None

 drivers/net/mdio/of_mdio.c   | 11 +----------
 drivers/net/phy/phy_device.c | 23 +++++++++++++++++++++++
 include/linux/phy.h          |  6 ++++++
 3 files changed, 30 insertions(+), 10 deletions(-)

diff --git a/drivers/net/mdio/of_mdio.c b/drivers/net/mdio/of_mdio.c
index 4daf94bb56a5..7bd33b930116 100644
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
index 8447e56ba572..06e0ddcca8c9 100644
--- a/drivers/net/phy/phy_device.c
+++ b/drivers/net/phy/phy_device.c
@@ -2829,6 +2829,29 @@ static bool phy_drv_supports_irq(struct phy_driver *phydrv)
 	return phydrv->config_intr && phydrv->handle_interrupt;
 }
 
+/**
+ * fwnode_mdio_find_device - Given a fwnode, find the mdio_device
+ * @np: pointer to the mdio_device's fwnode
+ *
+ * If successful, returns a pointer to the mdio_device with the embedded
+ * struct device refcount incremented by one, or NULL on failure.
+ * The caller should call put_device() on the mdio_device after its use
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
index bc323fbdd21e..8314051d384a 100644
--- a/include/linux/phy.h
+++ b/include/linux/phy.h
@@ -1349,11 +1349,17 @@ struct phy_device *phy_device_create(struct mii_bus *bus, int addr, u32 phy_id,
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

