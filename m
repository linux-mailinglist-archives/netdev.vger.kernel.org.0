Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 7B42B37255F
	for <lists+netdev@lfdr.de>; Tue,  4 May 2021 07:11:57 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229883AbhEDFMo (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 4 May 2021 01:12:44 -0400
Received: from mail-bn7nam10on2138.outbound.protection.outlook.com ([40.107.92.138]:55168
        "EHLO NAM10-BN7-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S229738AbhEDFMn (ORCPT <rfc822;netdev@vger.kernel.org>);
        Tue, 4 May 2021 01:12:43 -0400
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=ZdwpCZcwwDzv4gf1JJ50oWDT4VA4iEDD1WmOQM7UeUfdnEUusmmH1zUbif82E4Px1+0EohuC/MF8CVcdqhq2bpwkufcVmkpoYZonjs6SoAPcaJDcqdZIY1BMH1n1RPiTkZrL/s2YIN2tBPVJkRpVokxCsbkLtR5Cjy5QC+hXioWpxCxMdDomQM4ANC/c0dqCHf2/BdrkSIH7UIJhYJWrsgkXSfdEPkpJcJsSJLunnIYplTSDiDP6CYDTIXe1CLK7uJh9y5s5kuGqdCEekMlxbWI4g5keh9HSYLPhcbpgHcSdBgLgfKXgmZOtexJzhYwTm84CN+HjNAL3C5r3ol1kIg==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=kSwj4DZ09k6Gghy5y+t0p/F8049PF7ZT1lucpZFidD0=;
 b=EYPCW0A0C8MpFUsylrzE8MtSY8IecnqMFbimsIQU2aho1XLvKz9ImtkJYiIOXZqUiJQGYdfNgHufZlorzO3p5HygGr1vQPQkij2mCYMIjvsAXRetbenEiSr16ZkxXoaYxKsHzR/k7KdjY7WYVzDUhcWKrKMBArpiw0WnSq7Hx9cbeKryhNF4JVU2eUkOln9IjXYBdefpuY68HuFdhmohjjI89obdosDmTud0uhsN7VurD2VcH40pYLY21E+Q/INqZuEJzZOgpg9AQufJiuWJGDj9MCpe2a+jDM7ONZ1gVCl/5NqCweA8mTgaoqjxULSWdtlGJ/B6cZ4bbCRsJXZUaw==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=in-advantage.com; dmarc=pass action=none
 header.from=in-advantage.com; dkim=pass header.d=in-advantage.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=inadvantage.onmicrosoft.com; s=selector2-inadvantage-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=kSwj4DZ09k6Gghy5y+t0p/F8049PF7ZT1lucpZFidD0=;
 b=mz3DOSk78yIe9deKaBofv65ABdGWlHPCNxYRM76wohzC+wJaq1ZbqzDowp5QmWuLC6BNIh4llLG8eectAjKZQRn9wu9wHbQrM6R2fu/cKUeXAS9LjbLqZtGvZwu+MrXGOdXpP4spA7UDX5fIJNUaLspFByeMQaKRwb5yZd2fVNI=
Authentication-Results: in-advantage.com; dkim=none (message not signed)
 header.d=none;in-advantage.com; dmarc=none action=none
 header.from=in-advantage.com;
Received: from MWHSPR01MB355.namprd10.prod.outlook.com (2603:10b6:301:6c::37)
 by MWHPR1001MB2399.namprd10.prod.outlook.com (2603:10b6:301:30::31) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4065.25; Tue, 4 May
 2021 05:11:45 +0000
Received: from MWHSPR01MB355.namprd10.prod.outlook.com
 ([fe80::c559:f270:c9b5:a928]) by MWHSPR01MB355.namprd10.prod.outlook.com
 ([fe80::c559:f270:c9b5:a928%6]) with mapi id 15.20.4065.039; Tue, 4 May 2021
 05:11:45 +0000
From:   Colin Foster <colin.foster@in-advantage.com>
To:     colin.foster@in-advantage.com
Cc:     Rob Herring <robh+dt@kernel.org>,
        Vladimir Oltean <vladimir.oltean@nxp.com>,
        Claudiu Manoil <claudiu.manoil@nxp.com>,
        Alexandre Belloni <alexandre.belloni@bootlin.com>,
        UNGLinuxDriver@microchip.com (supporter:OCELOT ETHERNET SWITCH DRIVER),
        Andrew Lunn <andrew@lunn.ch>,
        Vivien Didelot <vivien.didelot@gmail.com>,
        Florian Fainelli <f.fainelli@gmail.com>,
        "David S. Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>,
        Russell King <linux@armlinux.org.uk>,
        devicetree@vger.kernel.org (open list:OPEN FIRMWARE AND FLATTENED
        DEVICE TREE BINDINGS), linux-kernel@vger.kernel.org (open list),
        netdev@vger.kernel.org (open list:OCELOT ETHERNET SWITCH DRIVER)
Subject: [RFC PATCH vN net-next 1/2] net: mscc: ocelot: add support for non-mmio regmaps
Date:   Mon,  3 May 2021 22:11:26 -0700
Message-Id: <20210504051130.1207550-1-colin.foster@in-advantage.com>
X-Mailer: git-send-email 2.25.1
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-Originating-IP: [67.185.175.147]
X-ClientProxiedBy: CO2PR04CA0133.namprd04.prod.outlook.com (2603:10b6:104::11)
 To MWHSPR01MB355.namprd10.prod.outlook.com (2603:10b6:301:6c::37)
MIME-Version: 1.0
X-MS-Exchange-MessageSentRepresentingType: 1
Received: from localhost.localdomain (67.185.175.147) by CO2PR04CA0133.namprd04.prod.outlook.com (2603:10b6:104::11) with Microsoft SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4087.39 via Frontend Transport; Tue, 4 May 2021 05:11:44 +0000
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: 68f34629-a1ef-46f9-65dd-08d90ebb1c36
X-MS-TrafficTypeDiagnostic: MWHPR1001MB2399:
X-MS-Exchange-Transport-Forked: True
X-Microsoft-Antispam-PRVS: <MWHPR1001MB23997ACAF8026D62067D7233A45A9@MWHPR1001MB2399.namprd10.prod.outlook.com>
X-MS-Oob-TLC-OOBClassifiers: OLM:6108;
X-MS-Exchange-SenderADCheck: 1
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: azLePOdDgLYya8iHenq6ndyb+sqnzSFHSVL/pbCkZJYBChYdVCWYHxyUiFa/EpY4shQasrmhlWbkWCmYnJnxSVjCTqjHFMAaEUhR6o3IrmHlHhwXva/ROF6w18LreQmnUr52pugD8e0VZ/vcwHIgNvSuph1N0LQiVUqLoMHCWLjsnwYRfSoJBhgemwuAHafXNKQQ+l3cDpWSrwv4cgqZxzRTLr09QOtgDcBvUBFgpsorK67cNQ+PDO9htP7DWJMavdHJ3ZQqxLF6FJBSfQctdxmnj/TsYXkUPmwKZbOQgtBRpDc3C6civMZH/EvKIwfi0e0PKb5ZdgRGUDCQ4PJtFJkrtqm2OoMdyjvIcwGDsCQw9qGIQVAsnvR3VUVc0+ljfKsmH7yDh+FmWPFEskVSOb+RZSlPZJtWgeGWZfz+DzlBF8C9SI2eIWDSxy13K1DIG9bpjtIyivpX3ySFKoGe8hgfBXQ6jTZ04RErz0/1TZSh1cM4y00ECC7cTad9qqmhOxYON8Gu531V3GSr623K/QmNq0n8V6tMs1P4DY0N5v4ddyVqKmy2pVEQx9G6iDZWKCnUG+M8nL7MqU+K4HpE1xk5x3qvWBFvzGeQ6OImUpnJjMRbwqFsUk37mA1LA2we5NA6amzpVDh7TjPi5dV3NpgeNN6HVxDiXMI8qpbEX6b5NGE1Sz6azWlDc+OuAWvr
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:MWHSPR01MB355.namprd10.prod.outlook.com;PTR:;CAT:NONE;SFS:(366004)(136003)(396003)(376002)(39830400003)(346002)(66946007)(86362001)(5660300002)(44832011)(36756003)(66476007)(956004)(52116002)(66556008)(6666004)(4326008)(478600001)(2616005)(6506007)(2906002)(34206002)(54906003)(6512007)(1076003)(316002)(6486002)(7416002)(16526019)(26005)(37006003)(38350700002)(8676002)(38100700002)(186003)(8936002)(83380400001)(69590400013);DIR:OUT;SFP:1102;
X-MS-Exchange-AntiSpam-MessageData: =?us-ascii?Q?JA6TMxaw9fcYVDaZpKQsh3k222uRLPmBFp/5TfRCCZFtYNakzbYveBM4ZBY9?=
 =?us-ascii?Q?K8XqiiVJIpgFI/3l1RzwG8ZCojuRTFd7UVjEElECfKm8DHj//STCh9xH3r4N?=
 =?us-ascii?Q?Q2G9cki4nOJqf3j5knrxmRlb2lCkcEletd5OOWWy1jM9hakZ5gvOGi0peOek?=
 =?us-ascii?Q?0y3jTVPDULGDGwY+BPVwtB2OSVIT/GvN6PbLZacx7DH8m/K/qG01eb6H5pDa?=
 =?us-ascii?Q?iQvu4ShLnRpTCbkzSmRNE1I7Qg8SwI97E+TsxYCKBtDs5zeKGkM2SqXy6ozO?=
 =?us-ascii?Q?MuguXdvFihEVyVDTTU4Dgzh/2HqgBoL4bZuCDRDBAYVCX85EB8vLPQtXGnF0?=
 =?us-ascii?Q?VXY5sEBtC+bc2H74SvxoT94UF/zQI8fYFSpkSQEGQRIJ5SsgneMX0msHra0X?=
 =?us-ascii?Q?rFRVd1ekvWmCtpGP5t0xRGfHa8EnKRTAPNQvUSqaPrP8nzDXueykphdOj7On?=
 =?us-ascii?Q?5ZPF6ZkerJPfTivCvYugU4lG3vMmP47HpemvHwBcxHkz4C6l15M8lB9x+17x?=
 =?us-ascii?Q?iB2YBGktYYsUHADFgwWidngMM6xylxJCUcHAoIKa+0LH1ql8q9R5Dao4528z?=
 =?us-ascii?Q?1efJ8OfxH/7Z0ulMKuKvQUm1v4VO71QVjqOhDPWsRg66D2vk5rz07uTBYqwA?=
 =?us-ascii?Q?N/B0KrOkhh5OWwIWAp0cIYtcdgR2gFvoNybq9et1iyy0MOHt8Ly1eCtcXfXD?=
 =?us-ascii?Q?gdX4b7IFVJAilzej5gbwiNXYfOaEcgjYp2BK1Bw976yz3UlzT/cW0EdSUxYx?=
 =?us-ascii?Q?p+HXOZEgP0dJRLiNj0S1KqCZI6sGTrTEZ7x8vHTjG6BlJNR0oTQZ48ID0eLI?=
 =?us-ascii?Q?cYEj4HPDjfjow0/uteYjHObJ0qvIo6X9LcojP5hfBID4st41B1Wbaja2Qqpf?=
 =?us-ascii?Q?7/7qlPzJNjK1h4Kh3V9Q5jlmBxoPr8YSUJoY6hXRciBY2obJioHmBpmiazxp?=
 =?us-ascii?Q?/KhtZWDpgc44/z1P2X1GWtGA9DotLES9t3lo1hyCO1wUZKbrxMX5UQrmNq2X?=
 =?us-ascii?Q?XFia9jLvNtJOXYcS5BGpSWrJXCYWgIfPS6w7eC0I+qANLnaFnv3MVHrlFhMZ?=
 =?us-ascii?Q?kYFG7jaxMkNuXx21nlWjXL1dGRbs3GKxISrUQ2zqTQdB/Bn9uhscBXyUbwTt?=
 =?us-ascii?Q?qenBl9La6Aux0/2kkfu+v9bIBT59HCNyKZ9vaS3CWqJWFZwqu+cP3UiTMHGD?=
 =?us-ascii?Q?ETT+Ox3OU2DIRew3JXBJqCxBB7NFftP3OOHok2g3iTkQbu/gURy6N+fucuye?=
 =?us-ascii?Q?wgRDnCsqfEy1LLQ6vEqSd9dRxAvGRwamtboLrgl4d4rbajo0XBJUkSz4fVA7?=
 =?us-ascii?Q?rdfX2TJk5J+T+SI0G4C53ZRO?=
X-OriginatorOrg: in-advantage.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 68f34629-a1ef-46f9-65dd-08d90ebb1c36
X-MS-Exchange-CrossTenant-AuthSource: MWHSPR01MB355.namprd10.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 04 May 2021 05:11:44.9243
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 48e842ca-fbd8-4633-a79d-0c955a7d3aae
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: 0kE/vW1TXDOIBMRXYItRPKhNlziE8GFin/QG8r8yJRKSEBUCf7jmxKtKdqEYRnIkkrbnXXjUl37zi7iXUawAkxTGQRerEhfiBvlyeQPE+UI=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: MWHPR1001MB2399
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Control for external VSC75XX chips can be performed via non-mmio
interfaces, e.g. SPI. Adding the offets array (one per target) and
the offset element per port allows the ability to track this
location that would otherwise be found in the MMIO regmap resource.

Tracking this offset in the ocelot driver and allowing the
ocelot_regmap_init function to be overloaded with a device-specific
initializer. This driver could update the *offset element to handle the
value that would otherwise be mapped via resource *res->start.

Signed-off-by: Colin Foster <colin.foster@in-advantage.com>
---
 drivers/net/dsa/ocelot/felix.c           |  6 ++++--
 drivers/net/dsa/ocelot/felix.h           |  2 ++
 drivers/net/dsa/ocelot/felix_vsc9959.c   |  1 +
 drivers/net/dsa/ocelot/seville_vsc9953.c |  1 +
 drivers/net/ethernet/mscc/ocelot_io.c    | 27 +++++++++++++++++-------
 include/soc/mscc/ocelot.h                |  5 ++++-
 6 files changed, 31 insertions(+), 11 deletions(-)

diff --git a/drivers/net/dsa/ocelot/felix.c b/drivers/net/dsa/ocelot/felix.c
index 628afb47b579..71aa11b209e8 100644
--- a/drivers/net/dsa/ocelot/felix.c
+++ b/drivers/net/dsa/ocelot/felix.c
@@ -1122,7 +1122,8 @@ static int felix_init_structs(struct felix *felix, int num_phys_ports)
 		res.start += felix->switch_base;
 		res.end += felix->switch_base;
 
-		target = ocelot_regmap_init(ocelot, &res);
+		target = felix->info->init_regmap(ocelot, &res,
+						  &ocelot->offsets[i]);
 		if (IS_ERR(target)) {
 			dev_err(ocelot->dev,
 				"Failed to map device memory space\n");
@@ -1159,7 +1160,8 @@ static int felix_init_structs(struct felix *felix, int num_phys_ports)
 		res.start += felix->switch_base;
 		res.end += felix->switch_base;
 
-		target = ocelot_regmap_init(ocelot, &res);
+		target = felix->info->init_regmap(ocelot, &res,
+						  &ocelot_port->offset);
 		if (IS_ERR(target)) {
 			dev_err(ocelot->dev,
 				"Failed to map memory space for port %d\n",
diff --git a/drivers/net/dsa/ocelot/felix.h b/drivers/net/dsa/ocelot/felix.h
index 4d96cad815d5..03ae576e018a 100644
--- a/drivers/net/dsa/ocelot/felix.h
+++ b/drivers/net/dsa/ocelot/felix.h
@@ -47,6 +47,8 @@ struct felix_info {
 				 enum tc_setup_type type, void *type_data);
 	void	(*port_sched_speed_set)(struct ocelot *ocelot, int port,
 					u32 speed);
+	struct regmap *(*init_regmap)(struct ocelot *ocelot,
+				      struct resource *res, u32 *offset);
 };
 
 extern const struct dsa_switch_ops felix_switch_ops;
diff --git a/drivers/net/dsa/ocelot/felix_vsc9959.c b/drivers/net/dsa/ocelot/felix_vsc9959.c
index 5ff623ee76a6..87178345116b 100644
--- a/drivers/net/dsa/ocelot/felix_vsc9959.c
+++ b/drivers/net/dsa/ocelot/felix_vsc9959.c
@@ -1362,6 +1362,7 @@ static const struct felix_info felix_info_vsc9959 = {
 	.prevalidate_phy_mode	= vsc9959_prevalidate_phy_mode,
 	.port_setup_tc		= vsc9959_port_setup_tc,
 	.port_sched_speed_set	= vsc9959_sched_speed_set,
+	.init_regmap		= ocelot_regmap_init,
 };
 
 static irqreturn_t felix_irq_handler(int irq, void *data)
diff --git a/drivers/net/dsa/ocelot/seville_vsc9953.c b/drivers/net/dsa/ocelot/seville_vsc9953.c
index 84f93a874d50..d88a9729222c 100644
--- a/drivers/net/dsa/ocelot/seville_vsc9953.c
+++ b/drivers/net/dsa/ocelot/seville_vsc9953.c
@@ -1181,6 +1181,7 @@ static const struct felix_info seville_info_vsc9953 = {
 	.mdio_bus_free		= vsc9953_mdio_bus_free,
 	.phylink_validate	= vsc9953_phylink_validate,
 	.prevalidate_phy_mode	= vsc9953_prevalidate_phy_mode,
+	.init_regmap		= ocelot_regmap_init,
 };
 
 static int seville_probe(struct platform_device *pdev)
diff --git a/drivers/net/ethernet/mscc/ocelot_io.c b/drivers/net/ethernet/mscc/ocelot_io.c
index ea4e83410fe4..8f314639faff 100644
--- a/drivers/net/ethernet/mscc/ocelot_io.c
+++ b/drivers/net/ethernet/mscc/ocelot_io.c
@@ -18,7 +18,8 @@ u32 __ocelot_read_ix(struct ocelot *ocelot, u32 reg, u32 offset)
 	WARN_ON(!target);
 
 	regmap_read(ocelot->targets[target],
-		    ocelot->map[target][reg & REG_MASK] + offset, &val);
+		    ocelot->offsets[target] +
+			    ocelot->map[target][reg & REG_MASK] + offset, &val);
 	return val;
 }
 EXPORT_SYMBOL(__ocelot_read_ix);
@@ -30,7 +31,8 @@ void __ocelot_write_ix(struct ocelot *ocelot, u32 val, u32 reg, u32 offset)
 	WARN_ON(!target);
 
 	regmap_write(ocelot->targets[target],
-		     ocelot->map[target][reg & REG_MASK] + offset, val);
+		     ocelot->offsets[target] +
+			     ocelot->map[target][reg & REG_MASK] + offset, val);
 }
 EXPORT_SYMBOL(__ocelot_write_ix);
 
@@ -42,7 +44,8 @@ void __ocelot_rmw_ix(struct ocelot *ocelot, u32 val, u32 mask, u32 reg,
 	WARN_ON(!target);
 
 	regmap_update_bits(ocelot->targets[target],
-			   ocelot->map[target][reg & REG_MASK] + offset,
+			   ocelot->offsets[target] +
+				   ocelot->map[target][reg & REG_MASK] + offset,
 			   mask, val);
 }
 EXPORT_SYMBOL(__ocelot_rmw_ix);
@@ -55,7 +58,8 @@ u32 ocelot_port_readl(struct ocelot_port *port, u32 reg)
 
 	WARN_ON(!target);
 
-	regmap_read(port->target, ocelot->map[target][reg & REG_MASK], &val);
+	regmap_read(port->target,
+		    port->offset + ocelot->map[target][reg & REG_MASK], &val);
 	return val;
 }
 EXPORT_SYMBOL(ocelot_port_readl);
@@ -67,7 +71,8 @@ void ocelot_port_writel(struct ocelot_port *port, u32 val, u32 reg)
 
 	WARN_ON(!target);
 
-	regmap_write(port->target, ocelot->map[target][reg & REG_MASK], val);
+	regmap_write(port->target,
+		     port->offset + ocelot->map[target][reg & REG_MASK], val);
 }
 EXPORT_SYMBOL(ocelot_port_writel);
 
@@ -85,7 +90,8 @@ u32 __ocelot_target_read_ix(struct ocelot *ocelot, enum ocelot_target target,
 	u32 val;
 
 	regmap_read(ocelot->targets[target],
-		    ocelot->map[target][reg] + offset, &val);
+		    ocelot->offsets[target] + ocelot->map[target][reg] + offset,
+		    &val);
 	return val;
 }
 
@@ -93,7 +99,9 @@ void __ocelot_target_write_ix(struct ocelot *ocelot, enum ocelot_target target,
 			      u32 val, u32 reg, u32 offset)
 {
 	regmap_write(ocelot->targets[target],
-		     ocelot->map[target][reg] + offset, val);
+		     ocelot->offsets[target] + ocelot->map[target][reg] +
+			     offset,
+		     val);
 }
 
 int ocelot_regfields_init(struct ocelot *ocelot,
@@ -136,10 +144,13 @@ static struct regmap_config ocelot_regmap_config = {
 	.reg_stride	= 4,
 };
 
-struct regmap *ocelot_regmap_init(struct ocelot *ocelot, struct resource *res)
+struct regmap *ocelot_regmap_init(struct ocelot *ocelot, struct resource *res,
+				  u32 *offset)
 {
 	void __iomem *regs;
 
+	*offset = 0;
+
 	regs = devm_ioremap_resource(ocelot->dev, res);
 	if (IS_ERR(regs))
 		return ERR_CAST(regs);
diff --git a/include/soc/mscc/ocelot.h b/include/soc/mscc/ocelot.h
index 425ff29d9389..ad45c1af4be9 100644
--- a/include/soc/mscc/ocelot.h
+++ b/include/soc/mscc/ocelot.h
@@ -591,6 +591,7 @@ struct ocelot_port {
 	struct ocelot			*ocelot;
 
 	struct regmap			*target;
+	u32				offset;
 
 	bool				vlan_aware;
 	/* VLAN that untagged frames are classified to, on ingress */
@@ -621,6 +622,7 @@ struct ocelot {
 	const struct ocelot_ops		*ops;
 	struct regmap			*targets[TARGET_MAX];
 	struct regmap_field		*regfields[REGFIELD_MAX];
+	u32				offsets[TARGET_MAX];
 	const u32 *const		*map;
 	const struct ocelot_stat_layout	*stats_layout;
 	unsigned int			num_stats;
@@ -780,7 +782,8 @@ static inline void ocelot_drain_cpu_queue(struct ocelot *ocelot, int grp)
 /* Hardware initialization */
 int ocelot_regfields_init(struct ocelot *ocelot,
 			  const struct reg_field *const regfields);
-struct regmap *ocelot_regmap_init(struct ocelot *ocelot, struct resource *res);
+struct regmap *ocelot_regmap_init(struct ocelot *ocelot, struct resource *res,
+				  u32 *offset);
 int ocelot_init(struct ocelot *ocelot);
 void ocelot_deinit(struct ocelot *ocelot);
 void ocelot_init_port(struct ocelot *ocelot, int port);
-- 
2.25.1

