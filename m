Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 6BD6145E177
	for <lists+netdev@lfdr.de>; Thu, 25 Nov 2021 21:16:21 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1357118AbhKYUT2 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 25 Nov 2021 15:19:28 -0500
Received: from mail-dm6nam10on2124.outbound.protection.outlook.com ([40.107.93.124]:37441
        "EHLO NAM10-DM6-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S242697AbhKYUR2 (ORCPT <rfc822;netdev@vger.kernel.org>);
        Thu, 25 Nov 2021 15:17:28 -0500
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=JDouimtZQwCuvytI02FFhG8+5MFFfAJxe+lpyfF63gip8m9NTD16Tc3gDpm9D2tmfHPA3WChz+Y8292wFtTx81o1p+C6M2GktR5Zi2ZUti8guVG2J3ZZV3uOpn26nInFPKqs89QgnXS8l7cus5qt+TSHyU7eLWrnlQdSwAD4akM3gfllLJUMFbeYkORiuIqwM14QsMGVKxgDyE7v4F7OdGWK2PxAaPInJR3L7F773HY5JQJCwvK+Gept8y2jHUTbuCLM9gGuvtS0hPgDsHDxAN3LgVkXAHpCR84hbdY7E3DYNYFuejDg67L6MAXUolL/gXdt7Y8VM1dTnPTa9bH27Q==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=2HrD+yoM9CSpvXSUPjzyN40zllFE2ocs6R1NvCOzDZQ=;
 b=lzM+KpSR71ofMhgcCYd6c3rEiz0c/yceSCtdO9abfXyV3W2vqZvp6mBAz9WA01S+GLGKG+GZLFNbfFVyMn5Ylf0wAJ8pTeBaomRL7DGQaIgxJlha9ArYrEvXBShyHJeHvg3n0uZVni0Z28amJIaOAvgD87FrogfViXLORPuJtrE04ColZ18jWZGwGPmNZu7CBDY+huLcOZDfGitvVp4j6iClmzBYWp7vlyfMHtwDjiA4Bm//9pVyXc0NRkKtoeCGHAKPvzN1WYBV7sCUJpKg/SvPQkIqLpcwJFB7ElgA8iJUF4gcM35Dp39gRdCuz3VLhGup/hQXlFyZo4gkEz0dfg==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=in-advantage.com; dmarc=pass action=none
 header.from=in-advantage.com; dkim=pass header.d=in-advantage.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=inadvantage.onmicrosoft.com; s=selector2-inadvantage-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=2HrD+yoM9CSpvXSUPjzyN40zllFE2ocs6R1NvCOzDZQ=;
 b=b87OmYjQITor9WTnUDmZux1OaEef7OKx26BsElLJSVdsoVfVwFTcJmn8RVR2aR62jAnuYnhFdJoPEy21SMCYMblNSOcNdpaGzQcX0fiJYgdEZFMjlA0Tw5six7QzITgUm/3bf2dM1DiwaU4xAOWxDx8Ff7tzzJ8GgKEhty3fuC0=
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=in-advantage.com;
Received: from MWHPR1001MB2351.namprd10.prod.outlook.com
 (2603:10b6:301:35::37) by CO1PR10MB5521.namprd10.prod.outlook.com
 (2603:10b6:303:160::22) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4734.23; Thu, 25 Nov
 2021 20:13:14 +0000
Received: from MWHPR1001MB2351.namprd10.prod.outlook.com
 ([fe80::6430:b20:8805:cd9f]) by MWHPR1001MB2351.namprd10.prod.outlook.com
 ([fe80::6430:b20:8805:cd9f%5]) with mapi id 15.20.4734.022; Thu, 25 Nov 2021
 20:13:14 +0000
From:   Colin Foster <colin.foster@in-advantage.com>
To:     linux-kernel@vger.kernel.org, netdev@vger.kernel.org
Cc:     Vladimir Oltean <vladimir.oltean@nxp.com>,
        Claudiu Manoil <claudiu.manoil@nxp.com>,
        Alexandre Belloni <alexandre.belloni@bootlin.com>,
        UNGLinuxDriver@microchip.com, Andrew Lunn <andrew@lunn.ch>,
        Vivien Didelot <vivien.didelot@gmail.com>,
        Florian Fainelli <f.fainelli@gmail.com>,
        "David S. Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>,
        Heiner Kallweit <hkallweit1@gmail.com>,
        Russell King <linux@armlinux.org.uk>
Subject: [PATCH v2 net-next 3/3] net: dsa: ocelot: felix: utilize shared mscc-miim driver for indirect MDIO access
Date:   Thu, 25 Nov 2021 12:13:01 -0800
Message-Id: <20211125201301.3748513-4-colin.foster@in-advantage.com>
X-Mailer: git-send-email 2.25.1
In-Reply-To: <20211125201301.3748513-1-colin.foster@in-advantage.com>
References: <20211125201301.3748513-1-colin.foster@in-advantage.com>
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-ClientProxiedBy: MWHPR18CA0071.namprd18.prod.outlook.com
 (2603:10b6:300:39::33) To MWHPR1001MB2351.namprd10.prod.outlook.com
 (2603:10b6:301:35::37)
MIME-Version: 1.0
Received: from localhost.localdomain (67.185.175.147) by MWHPR18CA0071.namprd18.prod.outlook.com (2603:10b6:300:39::33) with Microsoft SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4734.22 via Frontend Transport; Thu, 25 Nov 2021 20:13:13 +0000
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: 85417c0a-2a21-4668-d6ef-08d9b05002e1
X-MS-TrafficTypeDiagnostic: CO1PR10MB5521:
X-Microsoft-Antispam-PRVS: <CO1PR10MB5521979E409A5DA44F0E0A79A4629@CO1PR10MB5521.namprd10.prod.outlook.com>
X-MS-Oob-TLC-OOBClassifiers: OLM:7219;
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: XDYloJJ+FVbJDDbjPKwCMG5PmUWkoUyBd3Nwk++fV//QSCM9bZhd+siFLvuwzhS+LnA8gwOw21fE2Q29GAfIP5Yw0BZpr9aQJEBAQJGiytAFMHU1rWCTFNbaatbMQPj7+vb4Mc9aIrACiPiHbZGcwny1S/DFv/cVZxoCr344I0aWTf7zHRw8QdC6ghRijcimZ78eoeXdUrPHDs+p1K4RhUCJ3g/e3z74PD/13OTHBaPklNW1xgpmuRW/6/dFQ/mfmpHOiovI05Pt9kWHPoszz4T9qaRYbfXAu0Sb/ZCAYIk7wT3YitTcJ7iCuG/MymoA4DP7fU7VO/raYq1FBuzlrSCfxLKwRIER5qSWofumr6YsI33pX4IX2Zbnl7KJvdnJUAFT+ltNRNDcRZSOnvpoQtXplQkBuhCBSXUJl8dLeNSGUsIPEk3rydtAoUZpiAkOj+BKkkSKi2M/Q3OXBRXncs+rFWtetZh9uxAQhktOB0cK0+XjkV8heypyEZKU/46dNXAQpn3P2yMmEBsHbsf/pdb4OY0L2JtvF2pPSox65aB7lPegxIRm1QuW2ntSVGY1NxVlxGf9ioMSKWbhm/aiFPF3qyyShFnYC2P1BnRgHOZGjNqL092zEWUp0KCvdC53DAWQKb7DoO9l4msroRGlVK0P7PZ3KI2GgTs28LDEzsLkVJcbKeaOR2xqo8c5LVlqRDqdk5WXNOOn00eTJVq8tw==
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:MWHPR1001MB2351.namprd10.prod.outlook.com;PTR:;CAT:NONE;SFS:(396003)(366004)(136003)(39830400003)(376002)(346002)(8936002)(44832011)(5660300002)(6512007)(38100700002)(8676002)(508600001)(86362001)(6666004)(6486002)(7416002)(186003)(26005)(38350700002)(2906002)(36756003)(316002)(30864003)(66946007)(6506007)(54906003)(4326008)(2616005)(1076003)(956004)(52116002)(83380400001)(66476007)(66556008);DIR:OUT;SFP:1102;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?us-ascii?Q?QTIxmWfxlrx2fNVoMcQBryHtoVKySoH22uuPbURqddWKJ8PVIZRwcCAwtOK9?=
 =?us-ascii?Q?r6NUWzTsF0rprr5yk61qttFawm3ht4hjD3XaBBznAuUKWdtodRJJShnmbPer?=
 =?us-ascii?Q?QKRQ1rolhU8M+lnVCkkeQclNUaXhU1MHiv0dtsYx8kJC4EWOOo/fgMRQT/Uy?=
 =?us-ascii?Q?3riXWrUJEsdrF/rODmdar7X5ov8MNw7W/IxPAWZzcK7IJZxgwHGx2fu6YSDG?=
 =?us-ascii?Q?Lbk+pFhPTKgqFJqwECknryg5QY0cfJaAclUbjAMjeU90QgCJyh9BVej2pZVb?=
 =?us-ascii?Q?C3blStf//65jYATffZ6RwF3nbWd2g5p3NBvaynxtplKJiSkdyn6waV3CSnMJ?=
 =?us-ascii?Q?tUY5p8FWKPPFI3alXR4sKx0S4x/cJvDGX5MkpSs5nuzJpQ2GHyfGe6Mo0jRp?=
 =?us-ascii?Q?0NB5FFs/yKenDck58TvHhe+nyvHKOYcmO7fYZ+kyEMedlQGHCAMWdii9lhmG?=
 =?us-ascii?Q?A6ao+Md8Kj2c/4eDzj+TkHNWXsd22mlsUwfyMkzKs23Xl66d5O4qQQ2efsRE?=
 =?us-ascii?Q?odtXQzlXuGXXxWsWKWMe5IIZwineu/Y+yER9p2q0l9ortUSuVsVDAPB9upGm?=
 =?us-ascii?Q?cHs9ZWHdiMpQ0y2gXZ1Jx46XSk4PDuY7oNCkc3eClvs1Vok9qmL2fYnQLf2i?=
 =?us-ascii?Q?bxL89/VbJn+ka51lzf901oUE5rcomgE2h8gJ7KoIrSOIZLmrkSeEsdCR5Wqr?=
 =?us-ascii?Q?ZgzFTtoIpdt2dJryo75M4nHCcCKiSMDjN2ajTtSGCuYiirtb+DJIM7F//xNy?=
 =?us-ascii?Q?608o1htbA19ErTjmEJWXbAND9GcFqEQS0kyk1jISWedhYuHhH69CrcCODv8q?=
 =?us-ascii?Q?x5Q3q2tmzFBFAhJ5UWHymvs8Ekq1+2iN+0Hs8zFWcdY7Ha4D/Nw2vi6zC7O1?=
 =?us-ascii?Q?7u9rRy1yEhBO/md0BQFidF8ztiX55ICvy3GWn2M4qXM3r+SPBz3qFryAWSE2?=
 =?us-ascii?Q?KLyvWdOiMxMjeMsnE1BVtjyHwDD4hwaAW4g3iEr1J6YQnHEMHNgglsdej6Qu?=
 =?us-ascii?Q?hRdD7k137lfXc1qy84N52R6OmENn2jO0j1Q0pVeoVbOF9mgrCQI5azORuef/?=
 =?us-ascii?Q?7JnNS0g6gn6bNTbeE8Kf9GV8NdhP0q3NPPAtkqmwu3iq2gO2PQ6Quq0FXJYF?=
 =?us-ascii?Q?qv6R9JiTneVVR+/Kr4xoZ+JbcxWD0BPJ3I9FRXOpG8LIta/0Z97OBLJb/Y8+?=
 =?us-ascii?Q?czsFW2JR+eGqldu1Xxk11612nawJg0bCHVdVhxYVNgAqXTeNM3UCQRbSdmcB?=
 =?us-ascii?Q?kdE+j4ZW5yRwQ5zF7QqCrQjARHnktRYrH8oiK8R5TKYp/hl4dhja4dTE9hPJ?=
 =?us-ascii?Q?NAhfUeb6tGc56OyH2x8iepeLIRfm/FCECiwyS8SjDOBrPJ9+5pkRMPBvi72G?=
 =?us-ascii?Q?xI/CFJp1X4j9pbirZWIzfVpqG/NnAenSEfwmnxqmobdX6jG6Zrh58tvrAMi9?=
 =?us-ascii?Q?bf9xrpjHg6c6uDcCCC+kpU2N1spatUWkgo/+Mom23LzWAIjOw00IIYM+tFxn?=
 =?us-ascii?Q?XbS7gdLw+i93cGRUOGPyUEMyZzBX6u7jGYIIlwxAduB2JNdJffeO3ovscKGP?=
 =?us-ascii?Q?E6YMq4WMTq1z++RJGkXdVuVPwSPOLDR0D2D8WhtqULGyx4HxZ1a/7gTefR6g?=
 =?us-ascii?Q?pluTMdTXEEEbrCQwuSsb5PC4cZUDwMZcknPPX+Z6AYlO+cszwTug4Nl7+Fun?=
 =?us-ascii?Q?J1I6lw=3D=3D?=
X-OriginatorOrg: in-advantage.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 85417c0a-2a21-4668-d6ef-08d9b05002e1
X-MS-Exchange-CrossTenant-AuthSource: MWHPR1001MB2351.namprd10.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 25 Nov 2021 20:13:14.7459
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 48e842ca-fbd8-4633-a79d-0c955a7d3aae
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: WN7yqXgmIpAbx5kMsCUcpIL7kmiAAB2mmsTXa6sOg7LhjQvOSfvwWseQhdQ2/5rPnDIocEh0IeuK6z2+MO/uxm7mM86+mdXIVPwDRK1byZg=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: CO1PR10MB5521
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Switch to a shared MDIO access implementation by way of the mdio-mscc-miim
driver.

Signed-off-by: Colin Foster <colin.foster@in-advantage.com>
---
 drivers/net/dsa/ocelot/Kconfig           |   1 +
 drivers/net/dsa/ocelot/seville_vsc9953.c | 103 +++--------------------
 drivers/net/mdio/mdio-mscc-miim.c        |  40 ++++++---
 include/linux/mdio/mdio-mscc-miim.h      |  20 +++++
 include/soc/mscc/ocelot.h                |   1 +
 5 files changed, 61 insertions(+), 104 deletions(-)
 create mode 100644 include/linux/mdio/mdio-mscc-miim.h

diff --git a/drivers/net/dsa/ocelot/Kconfig b/drivers/net/dsa/ocelot/Kconfig
index 9948544ba1c4..220b0b027b55 100644
--- a/drivers/net/dsa/ocelot/Kconfig
+++ b/drivers/net/dsa/ocelot/Kconfig
@@ -21,6 +21,7 @@ config NET_DSA_MSCC_SEVILLE
 	depends on NET_VENDOR_MICROSEMI
 	depends on HAS_IOMEM
 	depends on PTP_1588_CLOCK_OPTIONAL
+	select MDIO_MSCC_MIIM
 	select MSCC_OCELOT_SWITCH_LIB
 	select NET_DSA_TAG_OCELOT_8021Q
 	select NET_DSA_TAG_OCELOT
diff --git a/drivers/net/dsa/ocelot/seville_vsc9953.c b/drivers/net/dsa/ocelot/seville_vsc9953.c
index db124922c374..41ec60a1fc96 100644
--- a/drivers/net/dsa/ocelot/seville_vsc9953.c
+++ b/drivers/net/dsa/ocelot/seville_vsc9953.c
@@ -6,19 +6,14 @@
 #include <soc/mscc/ocelot_vcap.h>
 #include <soc/mscc/ocelot_sys.h>
 #include <soc/mscc/ocelot.h>
+#include <linux/mdio/mdio-mscc-miim.h>
+#include <linux/of_mdio.h>
 #include <linux/of_platform.h>
 #include <linux/pcs-lynx.h>
 #include <linux/dsa/ocelot.h>
 #include <linux/iopoll.h>
-#include <linux/of_mdio.h>
 #include "felix.h"
 
-#define MSCC_MIIM_CMD_OPR_WRITE			BIT(1)
-#define MSCC_MIIM_CMD_OPR_READ			BIT(2)
-#define MSCC_MIIM_CMD_WRDATA_SHIFT		4
-#define MSCC_MIIM_CMD_REGAD_SHIFT		20
-#define MSCC_MIIM_CMD_PHYAD_SHIFT		25
-#define MSCC_MIIM_CMD_VLD			BIT(31)
 #define VSC9953_VCAP_POLICER_BASE		11
 #define VSC9953_VCAP_POLICER_MAX		31
 #define VSC9953_VCAP_POLICER_BASE2		120
@@ -862,7 +857,6 @@ static struct vcap_props vsc9953_vcap_props[] = {
 #define VSC9953_INIT_TIMEOUT			50000
 #define VSC9953_GCB_RST_SLEEP			100
 #define VSC9953_SYS_RAMINIT_SLEEP		80
-#define VCS9953_MII_TIMEOUT			10000
 
 static int vsc9953_gcb_soft_rst_status(struct ocelot *ocelot)
 {
@@ -882,82 +876,6 @@ static int vsc9953_sys_ram_init_status(struct ocelot *ocelot)
 	return val;
 }
 
-static int vsc9953_gcb_miim_pending_status(struct ocelot *ocelot)
-{
-	int val;
-
-	ocelot_field_read(ocelot, GCB_MIIM_MII_STATUS_PENDING, &val);
-
-	return val;
-}
-
-static int vsc9953_gcb_miim_busy_status(struct ocelot *ocelot)
-{
-	int val;
-
-	ocelot_field_read(ocelot, GCB_MIIM_MII_STATUS_BUSY, &val);
-
-	return val;
-}
-
-static int vsc9953_mdio_write(struct mii_bus *bus, int phy_id, int regnum,
-			      u16 value)
-{
-	struct ocelot *ocelot = bus->priv;
-	int err, cmd, val;
-
-	/* Wait while MIIM controller becomes idle */
-	err = readx_poll_timeout(vsc9953_gcb_miim_pending_status, ocelot,
-				 val, !val, 10, VCS9953_MII_TIMEOUT);
-	if (err) {
-		dev_err(ocelot->dev, "MDIO write: pending timeout\n");
-		goto out;
-	}
-
-	cmd = MSCC_MIIM_CMD_VLD | (phy_id << MSCC_MIIM_CMD_PHYAD_SHIFT) |
-	      (regnum << MSCC_MIIM_CMD_REGAD_SHIFT) |
-	      (value << MSCC_MIIM_CMD_WRDATA_SHIFT) |
-	      MSCC_MIIM_CMD_OPR_WRITE;
-
-	ocelot_write(ocelot, cmd, GCB_MIIM_MII_CMD);
-
-out:
-	return err;
-}
-
-static int vsc9953_mdio_read(struct mii_bus *bus, int phy_id, int regnum)
-{
-	struct ocelot *ocelot = bus->priv;
-	int err, cmd, val;
-
-	/* Wait until MIIM controller becomes idle */
-	err = readx_poll_timeout(vsc9953_gcb_miim_pending_status, ocelot,
-				 val, !val, 10, VCS9953_MII_TIMEOUT);
-	if (err) {
-		dev_err(ocelot->dev, "MDIO read: pending timeout\n");
-		goto out;
-	}
-
-	/* Write the MIIM COMMAND register */
-	cmd = MSCC_MIIM_CMD_VLD | (phy_id << MSCC_MIIM_CMD_PHYAD_SHIFT) |
-	      (regnum << MSCC_MIIM_CMD_REGAD_SHIFT) | MSCC_MIIM_CMD_OPR_READ;
-
-	ocelot_write(ocelot, cmd, GCB_MIIM_MII_CMD);
-
-	/* Wait while read operation via the MIIM controller is in progress */
-	err = readx_poll_timeout(vsc9953_gcb_miim_busy_status, ocelot,
-				 val, !val, 10, VCS9953_MII_TIMEOUT);
-	if (err) {
-		dev_err(ocelot->dev, "MDIO read: busy timeout\n");
-		goto out;
-	}
-
-	val = ocelot_read(ocelot, GCB_MIIM_MII_DATA);
-
-	err = val & 0xFFFF;
-out:
-	return err;
-}
 
 /* CORE_ENA is in SYS:SYSTEM:RESET_CFG
  * MEM_INIT is in SYS:SYSTEM:RESET_CFG
@@ -1101,16 +1019,15 @@ static int vsc9953_mdio_bus_alloc(struct ocelot *ocelot)
 		return -ENOMEM;
 	}
 
-	bus = devm_mdiobus_alloc(dev);
-	if (!bus)
-		return -ENOMEM;
+	rc = mscc_miim_setup(dev, &bus, "VSC9953 internal MDIO bus",
+			     ocelot->targets[GCB],
+			     ocelot->map[GCB][GCB_MIIM_MII_STATUS & REG_MASK],
+			     NULL, 0);
 
-	bus->name = "VSC9953 internal MDIO bus";
-	bus->read = vsc9953_mdio_read;
-	bus->write = vsc9953_mdio_write;
-	bus->parent = dev;
-	bus->priv = ocelot;
-	snprintf(bus->id, MII_BUS_ID_SIZE, "%s-imdio", dev_name(dev));
+	if (rc) {
+		dev_err(dev, "failed to setup MDIO bus\n");
+		return rc;
+	}
 
 	/* Needed in order to initialize the bus mutex lock */
 	rc = of_mdiobus_register(bus, NULL);
diff --git a/drivers/net/mdio/mdio-mscc-miim.c b/drivers/net/mdio/mdio-mscc-miim.c
index 5a9c0b311bdb..9eed6b597f21 100644
--- a/drivers/net/mdio/mdio-mscc-miim.c
+++ b/drivers/net/mdio/mdio-mscc-miim.c
@@ -10,6 +10,7 @@
 #include <linux/io.h>
 #include <linux/iopoll.h>
 #include <linux/kernel.h>
+#include <linux/mdio/mdio-mscc-miim.h>
 #include <linux/module.h>
 #include <linux/of_mdio.h>
 #include <linux/phy.h>
@@ -37,7 +38,9 @@
 
 struct mscc_miim_dev {
 	struct regmap *regs;
+	int mii_status_offset;
 	struct regmap *phy_regs;
+	int phy_reset_offset;
 };
 
 /* When high resolution timers aren't built-in: we can't use usleep_range() as
@@ -56,7 +59,8 @@ static int mscc_miim_status(struct mii_bus *bus)
 	struct mscc_miim_dev *miim = bus->priv;
 	int val, ret;
 
-	ret = regmap_read(miim->regs, MSCC_MIIM_REG_STATUS, &val);
+	ret = regmap_read(miim->regs,
+			  MSCC_MIIM_REG_STATUS + miim->mii_status_offset, &val);
 	if (ret < 0) {
 		WARN_ONCE(1, "mscc miim status read error %d\n", ret);
 		return ret;
@@ -93,7 +97,9 @@ static int mscc_miim_read(struct mii_bus *bus, int mii_id, int regnum)
 	if (ret)
 		goto out;
 
-	ret = regmap_write(miim->regs, MSCC_MIIM_REG_CMD, MSCC_MIIM_CMD_VLD |
+	ret = regmap_write(miim->regs,
+			   MSCC_MIIM_REG_CMD + miim->mii_status_offset,
+			   MSCC_MIIM_CMD_VLD |
 			   (mii_id << MSCC_MIIM_CMD_PHYAD_SHIFT) |
 			   (regnum << MSCC_MIIM_CMD_REGAD_SHIFT) |
 			   MSCC_MIIM_CMD_OPR_READ);
@@ -107,8 +113,8 @@ static int mscc_miim_read(struct mii_bus *bus, int mii_id, int regnum)
 	if (ret)
 		goto out;
 
-	ret = regmap_read(miim->regs, MSCC_MIIM_REG_DATA, &val);
-
+	ret = regmap_read(miim->regs,
+			  MSCC_MIIM_REG_DATA + miim->mii_status_offset, &val);
 	if (ret < 0) {
 		WARN_ONCE(1, "mscc miim read data reg error %d\n", ret);
 		goto out;
@@ -134,7 +140,9 @@ static int mscc_miim_write(struct mii_bus *bus, int mii_id,
 	if (ret < 0)
 		goto out;
 
-	ret = regmap_write(miim->regs, MSCC_MIIM_REG_CMD, MSCC_MIIM_CMD_VLD |
+	ret = regmap_write(miim->regs,
+			   MSCC_MIIM_REG_CMD + miim->mii_status_offset,
+			   MSCC_MIIM_CMD_VLD |
 			   (mii_id << MSCC_MIIM_CMD_PHYAD_SHIFT) |
 			   (regnum << MSCC_MIIM_CMD_REGAD_SHIFT) |
 			   (value << MSCC_MIIM_CMD_WRDATA_SHIFT) |
@@ -149,16 +157,19 @@ static int mscc_miim_write(struct mii_bus *bus, int mii_id,
 static int mscc_miim_reset(struct mii_bus *bus)
 {
 	struct mscc_miim_dev *miim = bus->priv;
+	int offset = miim->phy_reset_offset;
 	int ret;
 
 	if (miim->phy_regs) {
-		ret = regmap_write(miim->phy_regs, MSCC_PHY_REG_PHY_CFG, 0);
+		ret = regmap_write(miim->phy_regs,
+				   MSCC_PHY_REG_PHY_CFG + offset, 0);
 		if (ret < 0) {
 			WARN_ONCE(1, "mscc reset set error %d\n", ret);
 			return ret;
 		}
 
-		ret = regmap_write(miim->phy_regs, MSCC_PHY_REG_PHY_CFG, 0x1ff);
+		ret = regmap_write(miim->phy_regs,
+				   MSCC_PHY_REG_PHY_CFG + offset, 0x1ff);
 		if (ret < 0) {
 			WARN_ONCE(1, "mscc reset clear error %d\n", ret);
 			return ret;
@@ -176,8 +187,9 @@ static const struct regmap_config mscc_miim_regmap_config = {
 	.reg_stride	= 4,
 };
 
-static int mscc_miim_setup(struct device *dev, struct mii_bus **pbus,
-			   struct regmap *mii_regmap, struct regmap *phy_regmap)
+int mscc_miim_setup(struct device *dev, struct mii_bus **pbus, const char *name,
+		    struct regmap *mii_regmap, int status_offset,
+		    struct regmap *phy_regmap, int reset_offset)
 {
 	struct mscc_miim_dev *miim;
 	struct mii_bus *bus;
@@ -186,7 +198,7 @@ static int mscc_miim_setup(struct device *dev, struct mii_bus **pbus,
 	if (!bus)
 		return -ENOMEM;
 
-	bus->name = "mscc_miim";
+	bus->name = name;
 	bus->read = mscc_miim_read;
 	bus->write = mscc_miim_write;
 	bus->reset = mscc_miim_reset;
@@ -198,10 +210,15 @@ static int mscc_miim_setup(struct device *dev, struct mii_bus **pbus,
 	*pbus = bus;
 
 	miim->regs = mii_regmap;
+	miim->mii_status_offset = status_offset;
 	miim->phy_regs = phy_regmap;
+	miim->phy_reset_offset = reset_offset;
+
+	*pbus = bus;
 
 	return 0;
 }
+EXPORT_SYMBOL(mscc_miim_setup);
 
 static int mscc_miim_probe(struct platform_device *pdev)
 {
@@ -238,7 +255,8 @@ static int mscc_miim_probe(struct platform_device *pdev)
 		return PTR_ERR(dev->phy_regs);
 	}
 
-	ret = mscc_miim_setup(&pdev->dev, &bus, mii_regmap, phy_regmap);
+	ret = mscc_miim_setup(&pdev->dev, &bus, "mscc_miim", mii_regmap, 0,
+			      phy_regmap, 0);
 	if (ret < 0) {
 		dev_err(&pdev->dev, "Unable to setup the MDIO bus\n");
 		return ret;
diff --git a/include/linux/mdio/mdio-mscc-miim.h b/include/linux/mdio/mdio-mscc-miim.h
new file mode 100644
index 000000000000..69a023cf8991
--- /dev/null
+++ b/include/linux/mdio/mdio-mscc-miim.h
@@ -0,0 +1,20 @@
+/* SPDX-License-Identifier: (GPL-2.0 OR MIT) */
+/*
+ * Driver for the MDIO interface of Microsemi network switches.
+ *
+ * Author: Colin Foster <colin.foster@in-advantage.com>
+ * Copyright (C) 2021 Innovative Advantage
+ */
+#ifndef MDIO_MSCC_MIIM_H
+#define MDIO_MSCC_MIIM_H
+
+#include <linux/device.h>
+#include <linux/phy.h>
+#include <linux/regmap.h>
+
+int mscc_miim_setup(struct device *device, struct mii_bus **bus,
+		    const char *name, struct regmap *mii_regmap,
+		    int status_offset, struct regmap *phy_regmap,
+		    int reset_offset);
+
+#endif
diff --git a/include/soc/mscc/ocelot.h b/include/soc/mscc/ocelot.h
index 89d17629efe5..9d6fe8ce9dd1 100644
--- a/include/soc/mscc/ocelot.h
+++ b/include/soc/mscc/ocelot.h
@@ -398,6 +398,7 @@ enum ocelot_reg {
 	GCB_MIIM_MII_STATUS,
 	GCB_MIIM_MII_CMD,
 	GCB_MIIM_MII_DATA,
+	GCB_PHY_PHY_CFG,
 	DEV_CLOCK_CFG = DEV_GMII << TARGET_OFFSET,
 	DEV_PORT_MISC,
 	DEV_EVENTS,
-- 
2.25.1

