Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 9308C460C82
	for <lists+netdev@lfdr.de>; Mon, 29 Nov 2021 03:00:19 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S236262AbhK2CDM (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sun, 28 Nov 2021 21:03:12 -0500
Received: from mail-dm6nam12on2100.outbound.protection.outlook.com ([40.107.243.100]:5222
        "EHLO NAM12-DM6-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S237230AbhK2CBK (ORCPT <rfc822;netdev@vger.kernel.org>);
        Sun, 28 Nov 2021 21:01:10 -0500
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=kazeyUV25LYpksdH0iR0RMJX93fvbFEG7JFJhwd6X/8/HvNnmMyJqOLHfSTcDfkRKKazXQVVJlacw1I0o1w5OKXTC8A6b1purp3mgoKEMuFogirE07jG10d/gf1FwbqDgHvZAejtPQzNdGrjtzkNVmnRatFcHPh9KViGtt0zJGolLQxDXOAQc56eWCd96/5G9nR4tg8B5ClcB/SKeImwEQLxxlKK0WhvixXg8l5fXzQ43suFPjzTXF3GAxtO7xbAdhmrpIrX3VOi4KSjVVXfr+1RsgoN56yMvIkHNDz5+g1ugZO6hInDEiA9CPEpE/Vu3NcCVqxFBcYOVp8tHR2ktg==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=CP9XDjMnA8A50o4nMnNI4GRkmkdUskkRw6IH8GWw3GE=;
 b=DN3i66HoHCOuX8lqhEi5mvHCV8/5sWpGyL/meUinIGJzYq36CntlqvVF+yKAyLR9ofk5droY3IkgHpW0Bsx46QDSaNAx8QLLsG//9/UtbW3RdjsNowL8nxV8nyqyjskjqEYmdtPHEo8FC+WeX8hlBkks1z59674TTnOYvG5OEdriG4r2DK7FnKVl22PNmlLjzVLHXV9fcXWvIXEPavYwAcL+7IwqP4Ji6ecEfDeZV5m7W3O1YV0+KkrnxGw88c/dKdfEhq+E3of5y5X0haXcTqUvdEXivNKtIdd/xvgPj6RwF2vtisOGa8DqdHzZ09leIY3ir5WHcRSK8a7ACnbZZQ==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=in-advantage.com; dmarc=pass action=none
 header.from=in-advantage.com; dkim=pass header.d=in-advantage.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=inadvantage.onmicrosoft.com; s=selector2-inadvantage-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=CP9XDjMnA8A50o4nMnNI4GRkmkdUskkRw6IH8GWw3GE=;
 b=zNgNnDUOAm2vGEETI2F1KVjvFLwnH2FuVYbky1E+ywqVgIrkVXY4JpIasWagCpcitco4niFSG2sX7bKW7Ymu7RRn6LjMBmcfGa52XyywtGi5sjzRmSeyDvgqyDk1fR3C1+BDohyeKfmXtPF06dYeI6RuBd1ptrwWPm2z8WKvUD4=
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=in-advantage.com;
Received: from MWHPR1001MB2351.namprd10.prod.outlook.com
 (2603:10b6:301:35::37) by MWHPR10MB1936.namprd10.prod.outlook.com
 (2603:10b6:300:10c::7) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4734.20; Mon, 29 Nov
 2021 01:57:49 +0000
Received: from MWHPR1001MB2351.namprd10.prod.outlook.com
 ([fe80::6430:b20:8805:cd9f]) by MWHPR1001MB2351.namprd10.prod.outlook.com
 ([fe80::6430:b20:8805:cd9f%5]) with mapi id 15.20.4734.023; Mon, 29 Nov 2021
 01:57:49 +0000
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
Subject: [PATCH v3 net-next 3/3] net: dsa: ocelot: felix: utilize shared mscc-miim driver for indirect MDIO access
Date:   Sun, 28 Nov 2021 17:57:37 -0800
Message-Id: <20211129015737.132054-4-colin.foster@in-advantage.com>
X-Mailer: git-send-email 2.25.1
In-Reply-To: <20211129015737.132054-1-colin.foster@in-advantage.com>
References: <20211129015737.132054-1-colin.foster@in-advantage.com>
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-ClientProxiedBy: MW4PR04CA0050.namprd04.prod.outlook.com
 (2603:10b6:303:6a::25) To MWHPR1001MB2351.namprd10.prod.outlook.com
 (2603:10b6:301:35::37)
MIME-Version: 1.0
Received: from localhost.localdomain (67.185.175.147) by MW4PR04CA0050.namprd04.prod.outlook.com (2603:10b6:303:6a::25) with Microsoft SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4734.20 via Frontend Transport; Mon, 29 Nov 2021 01:57:48 +0000
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: fd0e4b96-c736-451c-f3c2-08d9b2dba566
X-MS-TrafficTypeDiagnostic: MWHPR10MB1936:
X-Microsoft-Antispam-PRVS: <MWHPR10MB1936AFBEB60294A16273EBF9A4669@MWHPR10MB1936.namprd10.prod.outlook.com>
X-MS-Oob-TLC-OOBClassifiers: OLM:7219;
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: CzBXFEnqxEtsJrLc1pyV+kbEctPDKo1asmvsqXTEc/JHo7uVraRxXlzkKBmphXcDWBzW7+CzFR9yjM6kKMtHt1Smv1pHXOenwrG4XjVzwuqYq9YQ3gy1SlEMT+7dIp2yMlcttQbFgjPChaPKULi4fhz4Ueh671GlW7HhLiM+FQWQETm9AnQSJ5BbJbsTXmoNLfcQ8TNs/F79jIAFO3si3//GYVmF8ZUGIgmbK1aUGRxfaKZmOKg2ZOatz4ZqB2Cf6oiKcZcFRypcdVBVx0egrW13yswbuYi8Qq5Y3r+KcdrJzQBSx8cqG2sqqR/ezG9uQj7CDAcYHHPd4xewiyNffXGncyTKllOFY8m05rQauFD2AMLHRbfMyzqgkiFpWA7500zhRo0kngv0uHPApr1fRPf+lXx2O6Gs5kwxNxGJnlqkIo61AZpSW4GydoElzwHwUH1b4rDHltj44QkdLlXskdSGDkx7D5LB5oaNhEsBWtuIXUu+Jl6sAWFnS6r1CU+V+tsel0oETOf6waxoUoGYjBMFRu9jqBNVnBOGt5gw4iJU9kVGNs9FtEUdwpsyoQJMUkV/uNpnxHV4tsBvYb2mTap8cmcG0Q3144YQPBk04EoE11nst0aftugeJC/qRteml1KaaQadPmlCG1TlaG8xJT0ouzjg0AVaeGXp4VJbCvArERdnDyaJXuh3OUarrLdSw9SP8sBwdVs4NNW45atU5A==
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:MWHPR1001MB2351.namprd10.prod.outlook.com;PTR:;CAT:NONE;SFS:(346002)(376002)(136003)(39830400003)(366004)(396003)(83380400001)(52116002)(66946007)(6666004)(86362001)(316002)(44832011)(38350700002)(38100700002)(4326008)(26005)(508600001)(2616005)(8936002)(36756003)(2906002)(956004)(54906003)(8676002)(6506007)(186003)(66476007)(1076003)(6486002)(5660300002)(66556008)(7416002)(6512007);DIR:OUT;SFP:1102;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?us-ascii?Q?1Sg5bO5SyTGCFEXHCzqTQ8+jc/sNjBEn0ITsQbqspZARoE+eE2ELAvJ4lsKt?=
 =?us-ascii?Q?pOIrv0x2L5kR9grkjr88u29OhGVjrHXu0BPQHhAdDQ87y6uh7z4yq/jmyi3K?=
 =?us-ascii?Q?IpECYVCjB0KJNt0PZUR9PRLUnC9bqTxdIHApHCdVAFf5sUujFwxmWUdyf1Qc?=
 =?us-ascii?Q?WE//NdPZfxf9xHHewkOocP19Qccr/LSIHHdHgzZWvPhFq8ZtofySPPOBMfw5?=
 =?us-ascii?Q?3FQbjfPWKuwzSJf+djFqCN0YB5Zat/2XkOaJaoGEg89qF5Heu+3SkdP4AO00?=
 =?us-ascii?Q?OC1S7s3mFvZMwwNr0TkgzHhf6HjRTNiAufj2KgHPFMqJ/xNO6mFVV5vN3DNN?=
 =?us-ascii?Q?uaeb+dqmqfZaPERSvWYL47vA6RXPOo5HnRmXu378IdG7GcgqFx9VeyX5KKcW?=
 =?us-ascii?Q?nrQXCi3zapC8XQdFKbi8040OXFbPp9mlkglbihDJcfQxNUAX+rr1S0JZlGWp?=
 =?us-ascii?Q?aUH/xsPxXjr9DxWpjODecjrqhHZxBX447KbJ92ZE12tZ6x51Z/tL57DKcQ3a?=
 =?us-ascii?Q?O9UBGa54J7iSW0K9U7LfPPTNR30yY1L/9OEGG8MoShy9yXV8r28uNJ8gi4iS?=
 =?us-ascii?Q?CYQgedyS0ofzdfsSTT8r5Xhx/iaM89GDjKfiAWr3+PnS/x0kiYlheQYiw4oe?=
 =?us-ascii?Q?a3CvoABqJ/Ao5EgWvsobyfbTRRDjYZUjNpxfE5V60D9v5POtwIOGbbWxhylZ?=
 =?us-ascii?Q?heH7BBpDdi0j1PckQuXVSAWXE0fzfyJ4Ks7ooFg1tFxKS7K8ZBmcxIhSs0vG?=
 =?us-ascii?Q?1l3LS3AH+YF4Krrr6hREPZuang58Bu1BtsQmsdAXm+Po8rckOv9WDhwl3kEs?=
 =?us-ascii?Q?KD1t2p2Z4F8tXtAjmibdqdjm8U2rO+tFFIff74UR0vUA5BJt8Hy2ehu+m+ts?=
 =?us-ascii?Q?/fnsH38cVfj885okfZ3MUqO7C5lQ0vMzyGZudHMy71IrFU9ExzRj1ZtAmeu6?=
 =?us-ascii?Q?4q9ufivfxcERHAjibsb9ek2thvbKMw+EhHLHXOOEg/nBO+wBQcn0M3//0LJs?=
 =?us-ascii?Q?y1zjtgGMcEsn5RPCJK7CfDRkwBDdzeAouod609i6w6iZyXeLmMqJG/SGWvEw?=
 =?us-ascii?Q?GUoPp5AXJMzl2moaDz6aXoKEgVI2DiP7shFxAONiG5uqlfDohP+/DaKTk4jr?=
 =?us-ascii?Q?RMug23F8A6H7C1848XzB+GcT9cJsmpkX4hZRBk6VRGRwFlSOi1Zur2rd+yfq?=
 =?us-ascii?Q?Ey7uU/lzM+d9NBFhdjiuE0x0RNavRpA80cbQNIY+ByE5trDHWgsGqMZYixNG?=
 =?us-ascii?Q?QYvrIMZufHWsX/DpT2wYpBzKMF0AcEJSzj8BEtEfH70uXbM9j46tuPaQ5ndO?=
 =?us-ascii?Q?O513aejmCY/gzMHzqx2HA2/ReXXqImXtfPm/7NiIN7fUGla9Bintr7lVjCTi?=
 =?us-ascii?Q?KzU/y3VX/H4sFgzRP1UNym32uU7r3KaAwSFmYUT+9QZYZ6yjBZvIPzvX5nYI?=
 =?us-ascii?Q?KGRRpTFH8NUnwJHWti7Erav3pufjG7L/7KqPDwoUxM34Aiu4pmrihvG3Zc3l?=
 =?us-ascii?Q?hFRJajUN+56shBgknxlvxFz3Qo1KvnKoax71ZpOMh1YfucbNMqHb2IoYbLe0?=
 =?us-ascii?Q?21aCslIRPWisoYflMiX+FNHl7PI8ZmSpvaDR/d3VVEeLGCuqtXE9zel5IGbJ?=
 =?us-ascii?Q?1GBxgATKlGI5zabTwe1FTzsz9O40C6dJf8G1ElzR+V80fe+GufD8y+xPw1MU?=
 =?us-ascii?Q?oD5ONw=3D=3D?=
X-OriginatorOrg: in-advantage.com
X-MS-Exchange-CrossTenant-Network-Message-Id: fd0e4b96-c736-451c-f3c2-08d9b2dba566
X-MS-Exchange-CrossTenant-AuthSource: MWHPR1001MB2351.namprd10.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 29 Nov 2021 01:57:49.3934
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 48e842ca-fbd8-4633-a79d-0c955a7d3aae
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: tCVERA5zkY45vgmcT2LO+yVySGbtvorMvGpcHp25XZndsbLtpU43AyhwZeWb4KU2O5G3GcoPW80MOPp3n5uWK6SpAr+R4I3fUk0nzAUjEaY=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: MWHPR10MB1936
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Switch to a shared MDIO access implementation by way of the mdio-mscc-miim
driver.

Signed-off-by: Colin Foster <colin.foster@in-advantage.com>
Tested-by: Vladimir Oltean <vladimir.oltean@nxp.com>
---
 drivers/net/dsa/ocelot/Kconfig           |   1 +
 drivers/net/dsa/ocelot/seville_vsc9953.c | 102 ++---------------------
 drivers/net/mdio/mdio-mscc-miim.c        |  38 ++++++---
 include/linux/mdio/mdio-mscc-miim.h      |  19 +++++
 4 files changed, 56 insertions(+), 104 deletions(-)
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
index db124922c374..b9be889016ce 100644
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
@@ -1101,16 +1019,14 @@ static int vsc9953_mdio_bus_alloc(struct ocelot *ocelot)
 		return -ENOMEM;
 	}
 
-	bus = devm_mdiobus_alloc(dev);
-	if (!bus)
-		return -ENOMEM;
+	rc = mscc_miim_setup(dev, &bus, "VSC9953 internal MDIO bus",
+			     ocelot->targets[GCB],
+			     ocelot->map[GCB][GCB_MIIM_MII_STATUS & REG_MASK]);
 
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
index e016b32ad208..2d420c9d7520 100644
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
@@ -176,8 +187,8 @@ static const struct regmap_config mscc_miim_regmap_config = {
 	.reg_stride	= 4,
 };
 
-static int mscc_miim_setup(struct device *dev, struct mii_bus **pbus,
-			   struct regmap *mii_regmap)
+int mscc_miim_setup(struct device *dev, struct mii_bus **pbus, const char *name,
+		    struct regmap *mii_regmap, int status_offset)
 {
 	struct mscc_miim_dev *miim;
 	struct mii_bus *bus;
@@ -186,7 +197,7 @@ static int mscc_miim_setup(struct device *dev, struct mii_bus **pbus,
 	if (!bus)
 		return -ENOMEM;
 
-	bus->name = "mscc_miim";
+	bus->name = name;
 	bus->read = mscc_miim_read;
 	bus->write = mscc_miim_write;
 	bus->reset = mscc_miim_reset;
@@ -198,9 +209,13 @@ static int mscc_miim_setup(struct device *dev, struct mii_bus **pbus,
 	*pbus = bus;
 
 	miim->regs = mii_regmap;
+	miim->mii_status_offset = status_offset;
+
+	*pbus = bus;
 
 	return 0;
 }
+EXPORT_SYMBOL(mscc_miim_setup);
 
 static int mscc_miim_probe(struct platform_device *pdev)
 {
@@ -237,7 +252,7 @@ static int mscc_miim_probe(struct platform_device *pdev)
 		return PTR_ERR(phy_regmap);
 	}
 
-	ret = mscc_miim_setup(&pdev->dev, &bus, mii_regmap);
+	ret = mscc_miim_setup(&pdev->dev, &bus, "mscc_miim", mii_regmap, 0);
 	if (ret < 0) {
 		dev_err(&pdev->dev, "Unable to setup the MDIO bus\n");
 		return ret;
@@ -245,6 +260,7 @@ static int mscc_miim_probe(struct platform_device *pdev)
 
 	miim = bus->priv;
 	miim->phy_regs = phy_regmap;
+	miim->phy_reset_offset = 0;
 
 	ret = of_mdiobus_register(bus, pdev->dev.of_node);
 	if (ret < 0) {
diff --git a/include/linux/mdio/mdio-mscc-miim.h b/include/linux/mdio/mdio-mscc-miim.h
new file mode 100644
index 000000000000..5b4ed2c3cbb9
--- /dev/null
+++ b/include/linux/mdio/mdio-mscc-miim.h
@@ -0,0 +1,19 @@
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
+		    int status_offset);
+
+#endif
-- 
2.25.1

