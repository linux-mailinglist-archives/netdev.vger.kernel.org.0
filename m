Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 52619666032
	for <lists+netdev@lfdr.de>; Wed, 11 Jan 2023 17:18:58 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234361AbjAKQS0 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 11 Jan 2023 11:18:26 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:57868 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S237663AbjAKQRw (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 11 Jan 2023 11:17:52 -0500
Received: from EUR01-HE1-obe.outbound.protection.outlook.com (mail-he1eur01on2054.outbound.protection.outlook.com [40.107.13.54])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id DE7C81C427;
        Wed, 11 Jan 2023 08:17:38 -0800 (PST)
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=Z1SF7dI41bdSFZUNM44FmCtu8dTyxqZHySdf60bcOW69U4DkZPJDsM4RdgdebXlpoJb0HCNmo7uw0C7r1l2IQ6jip9N8Myl2ec5ijP1zitmFkOpRJHiC0p+lCk1lFHOrrZ4dqkA6WTl36DSvpuabC5NQPLrI3ewCGBkudk/fUmv+5rux9/DwuUeTPnQ0oCYGfo6wsShTTk6eMROTPj9NLD1dql19fw5c196Z6GnmcDsLKD82xPwj7ZZ3sLyZ2aivSUDDl755RFUXIblU72cQkH01zyqNBZH7EhkhHyVq0VmcCi8feXa5wUCr9WEslETna5SOuaz8LH2v0IogjA42xw==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=UE/+6tIP0KPsj9ih+4K+tEDsNMOH2Vrl400u9wUDDAs=;
 b=ITfpOgzCK/Yv6TsHBEhCId3Piu1c5CpI2es1FqVwlltR3i7OiKvJuupUTHMbT++kExgIW7oXva4seTioEqolGAvTcocFZhXA6m7mJNCthUd3Tg59rmxcD5XtMpB2y0WqYNtjZiQMm1HdCu62wSCQTfFgzdnP34wL69FOn4eULdFUUaSeEC+jM+/z3+a0vDEyYpiHNDgkK9FuPCOY6kqJg6iZq+nKijPOUL/PSPUb5fE7CTOa2o3uhhHabkx4PsUlr9RJ5xFpamp7yDevX1kCcoKOnU52usv03QMSw+ya7uVv9ws/iOPuugosYNbrgYSGycOGqxuawwzzBjk8vE6tcw==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=nxp.com; dmarc=pass action=none header.from=nxp.com; dkim=pass
 header.d=nxp.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=nxp.com; s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=UE/+6tIP0KPsj9ih+4K+tEDsNMOH2Vrl400u9wUDDAs=;
 b=hDFOjiuiHpGw8K/b39IXRfV98Vx4jb+bYVCE6As8ixaaAA7a37iyodmeb8x5X+17yuMFcJJFYJ71GaGrI4uW9WMZmKfEHFap6tXI7BCA4ApPEvOnb2tpFRcpMEIAdNQu3AzQyYegc3fFosadRxm+j0SNEBDtDegMJ/7cutTUVj0=
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=nxp.com;
Received: from VI1PR04MB5136.eurprd04.prod.outlook.com (2603:10a6:803:55::19)
 by PA4PR04MB7549.eurprd04.prod.outlook.com (2603:10a6:102:e0::21) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.5986.18; Wed, 11 Jan
 2023 16:17:34 +0000
Received: from VI1PR04MB5136.eurprd04.prod.outlook.com
 ([fe80::3cfb:3ae7:1686:a68b]) by VI1PR04MB5136.eurprd04.prod.outlook.com
 ([fe80::3cfb:3ae7:1686:a68b%4]) with mapi id 15.20.5986.018; Wed, 11 Jan 2023
 16:17:34 +0000
From:   Vladimir Oltean <vladimir.oltean@nxp.com>
To:     netdev@vger.kernel.org
Cc:     linux-kernel@vger.kernel.org,
        "David S. Miller" <davem@davemloft.net>,
        Eric Dumazet <edumazet@google.com>,
        Jakub Kicinski <kuba@kernel.org>,
        Paolo Abeni <pabeni@redhat.com>,
        Michal Kubecek <mkubecek@suse.cz>,
        Claudiu Manoil <claudiu.manoil@nxp.com>,
        Vinicius Costa Gomes <vinicius.gomes@intel.com>,
        Xiaoliang Yang <xiaoliang.yang_1@nxp.com>,
        Kurt Kanzenbach <kurt@linutronix.de>,
        Rui Sousa <rui.sousa@nxp.com>,
        Ferenc Fejes <ferenc.fejes@ericsson.com>,
        Pranavi Somisetty <pranavi.somisetty@amd.com>,
        Harini Katakam <harini.katakam@amd.com>,
        Colin Foster <colin.foster@in-advantage.com>,
        UNGLinuxDriver@microchip.com,
        Alexandre Belloni <alexandre.belloni@bootlin.com>,
        Andrew Lunn <andrew@lunn.ch>,
        Florian Fainelli <f.fainelli@gmail.com>
Subject: [PATCH v2 net-next 12/12] net: mscc: ocelot: add MAC Merge layer support for VSC9959
Date:   Wed, 11 Jan 2023 18:17:06 +0200
Message-Id: <20230111161706.1465242-13-vladimir.oltean@nxp.com>
X-Mailer: git-send-email 2.34.1
In-Reply-To: <20230111161706.1465242-1-vladimir.oltean@nxp.com>
References: <20230111161706.1465242-1-vladimir.oltean@nxp.com>
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-ClientProxiedBy: BE1P281CA0163.DEUP281.PROD.OUTLOOK.COM
 (2603:10a6:b10:67::8) To VI1PR04MB5136.eurprd04.prod.outlook.com
 (2603:10a6:803:55::19)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: VI1PR04MB5136:EE_|PA4PR04MB7549:EE_
X-MS-Office365-Filtering-Correlation-Id: 7312278e-67c5-491a-5dc4-08daf3ef58e7
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: wxqIr6Ay30Bh+0A28Kl6gi5wXYPahAJD1nBV2XaYmfXNewRYCq9E4PsvFIE/XxL1clFFsvuWzTbBn7hIAMysS+Wv3OB1ly5PsL5kM75X34DCy1g5hpefd9wPqCzct24jPfme/OceqFyrmL8vo2ibFKruYTtrjx64ZZRzHEcDrsjbDgvn6et/v68q1NZXnL2JTLzVcMpuUcdD9g0m9z8tUfTmZIkAiXv7fE2SO95nVv0lCohv1cYOln7pU4+2gpwABNgkf+fDuzib7z8W6RNycnsdxSWNQKwFo7vGkZJHKzNdtXZBeBkIcF8pRMYTJKuIxETKw1i5j5hBshHjRlzCUIUz4dCNtCoTxJfhLONSE5RmRelgf5Bzsvjs/5qXehHyqaIM+ZCko2tZAe+UGIxBZ8NgSq5eX/GlpFHLlYsR9AR/7lee5N2VVpAksyo8abfafRjVe9EftO9G2vXS4Ly9uwWxCuieVDq7YOrkJLFBAjMcu6orPkTFPOUoal4n1+jyBcG9/cug66k44bRSIVVyr34tRMTNcXr2U5OajpxUCgp2HS6Fr4aTfPykBufRG7PCJzIT4nl9RKYprxz3lIXkrRz9LHw4jXDFIgqbUU+2eTM83kzN6KoPDXuDn+t92JbhQVmJEVpcbOVMGE7BBuufr5/HaJKC4SMzZdlnmeST9Rrt6rkXej4hziq+47WjSsEg
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:VI1PR04MB5136.eurprd04.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230022)(4636009)(376002)(346002)(366004)(136003)(39860400002)(396003)(451199015)(36756003)(38100700002)(8936002)(186003)(2906002)(41300700001)(7416002)(5660300002)(52116002)(6916009)(4326008)(66476007)(8676002)(66556008)(66946007)(316002)(54906003)(44832011)(38350700002)(6512007)(30864003)(26005)(2616005)(1076003)(86362001)(83380400001)(478600001)(6486002)(6506007)(6666004);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?us-ascii?Q?+xkqDV0tl5F/ztyVARwUY1FUKXpfRaGfXrLFEYAzJNBnxjyJKyWiYJiTv9Fg?=
 =?us-ascii?Q?z96IKQivyEU8FnIn47YZOxAQcC7GGoMU12hf8UAOKAsEXZrStSqI52gQ9wX1?=
 =?us-ascii?Q?XJzMs4FX7TrDsaPkQwGrLsAf8kgaYLG4miENF+yHyUGZS2pa2jTfG2KT+cd8?=
 =?us-ascii?Q?VkjaqtrTMz2vae7t7RQtx5UIpwPq+deP5dBo8ZAQ5eewLVEdZrx2CxWnX+c/?=
 =?us-ascii?Q?IW5FWbzKPmwMOli7bRqJU3fWBLKgVunWGbuxsTivz9nx81pETSfPriJmf+RB?=
 =?us-ascii?Q?lRXmoYplbN6exZkN2VSqDig/VkJ0bfn3SlkwjlJNJ08AqRntmgh1gocTI0B4?=
 =?us-ascii?Q?YAzD8Kr1q78us2Xpmr7LyFOl/o3qi5pRTqkXzo5yopOhpqZo0TqapJNkzFMj?=
 =?us-ascii?Q?MBWErRd6IfBzafOK7I1BcpkleO2H6+4cP3ud3/6cRraHyHr8vhFI+eVO+5UQ?=
 =?us-ascii?Q?41fiTE2qsuTtYa8lF2CCZ1d/6/6eBO5yUrMfwDoNqQ2o6trP/9hLqvGtJtLf?=
 =?us-ascii?Q?5YLAYhaXNciSmoT3ymxtlnpVai02MFgwDSnLUgqswzxYSZ1jWMQKGhTq5pz1?=
 =?us-ascii?Q?mDleltlKx71/7qjGQTIWIb/GzepFJLXx8DKGXzEdU7phWxgrojLgg6xOviJa?=
 =?us-ascii?Q?GTEbkdl8q3/c/8v6QTz2ZptE6JxxCMR6MoYxdjQeCVM2jJp8yK1WkxDpSHlF?=
 =?us-ascii?Q?f93Pqgu1shqZ2r7uTdZE/rvPMpX1HvQwZqzl18r8uaAHtQnnw7UjbRYytvtT?=
 =?us-ascii?Q?/cbW2J6btyiYSIAsmE5vM3BEiFdzYZsLWQgs8xtfvBzR2w4bFociV0mhaF36?=
 =?us-ascii?Q?DDI53z+REM1YJjLDunTSNCt9/psVBvFlJ2KDtmPxT57zZImPuFTbDUGJm5k2?=
 =?us-ascii?Q?/1zQPWJq5tWSNmJfydADluhLJQXTGBsN48c2FsozjhUJbgKQ1KDb2nrwULCg?=
 =?us-ascii?Q?uBV+a+VsMruMhhY3KmZ7XEexv3XB65AEogDngaxBzpi5ba/GXIqLV8dOfrHC?=
 =?us-ascii?Q?7Q8deDatwYk7gXG0J51u7p3RvKA/aqhG23I6zIbP5Foq+C3U+4B8FaUzSkKD?=
 =?us-ascii?Q?q00qGc1csgqX1RnTNWESFFAJhsjO51XdrXOTfmjiynLqfXMhZOmwRTHb4yRa?=
 =?us-ascii?Q?jicej4i4ZzOmLzNHQ0avb3Srkz8Ax6JxbwmVNV1k8vZUQJzBJeaavE1xU6Sq?=
 =?us-ascii?Q?jPTag369C0l2m2DXI1Txk40nkgZYBFjgaKZcuIqAoTfnI+a6DwgXUXUgqy7W?=
 =?us-ascii?Q?zIFy0VDxzfO7OEQ+Bt1ADLKfu4PbS7pqgbXb4hFrNe8+qPZ3H1WKTqBLDFKk?=
 =?us-ascii?Q?d+RBuMeGrSn72lyXDQGIOMkUIzxgsuLhD6aXvSjU4rQLH0c2BVAfbaNIq23k?=
 =?us-ascii?Q?Ix3CE11n38oBEmziABfvQ2xyK7gjWHz6qkNxvvuS9rUmOiBgH6VP2CK+EOSH?=
 =?us-ascii?Q?c6O8UpOez27XvbqT7ZY9EkEJX8toozjs1jL84PfRAgu0b3v968rSkaVtyAGk?=
 =?us-ascii?Q?ghk1QzcSdhmUFQ3mzMkpFned3KWNubOTZ4mRzvaR5dARCSmZfk3mqlJzT8+B?=
 =?us-ascii?Q?mIh0bqqVDZf4GYJ1PhVz/lzvV87/hJZ9PnVWE8TBcwogPAtYteDntg7+rjJM?=
 =?us-ascii?Q?9g=3D=3D?=
X-OriginatorOrg: nxp.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 7312278e-67c5-491a-5dc4-08daf3ef58e7
X-MS-Exchange-CrossTenant-AuthSource: VI1PR04MB5136.eurprd04.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 11 Jan 2023 16:17:34.4387
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 686ea1d3-bc2b-4c6f-a92c-d99c5c301635
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: 04iuEA2OHlG57ilLNuKw/C+Ywv6BGmo070T6qTBWP1mmjRj4yu6nMeXptbW47wgMTYBQYY21OdErFd5mgnxTDg==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: PA4PR04MB7549
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_NONE,
        RCVD_IN_MSPIKE_H2,SPF_HELO_PASS,SPF_PASS autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Felix (VSC9959) has a DEV_GMII:MM_CONFIG block composed of 2 registers
(ENABLE_CONFIG and VERIF_CONFIG). Because the MAC Merge statistics and
pMAC statistics are already in the Ocelot switch lib even if just Felix
supports them, I'm adding support for the whole MAC Merge layer in the
common Ocelot library too.

There is an interrupt (shared with the PTP interrupt) which signals
changes to the MM verification state. This is done because the
preemptible traffic classes should be committed to hardware only once
the verification procedure has declared the link partner of being
capable of receiving preemptible frames.

We implement ethtool getters and setters for the MAC Merge layer state.
The "TX enabled" and "verify status" are taken from the IRQ handler,
using a mutex to ensure serialized access.

Signed-off-by: Vladimir Oltean <vladimir.oltean@nxp.com>
---
v1->v2: patch is new (v1 was written for enetc)

 drivers/net/dsa/ocelot/felix.c         |  19 +++
 drivers/net/dsa/ocelot/felix_vsc9959.c |  19 ++-
 drivers/net/ethernet/mscc/Makefile     |   1 +
 drivers/net/ethernet/mscc/ocelot.c     |  18 ++-
 drivers/net/ethernet/mscc/ocelot.h     |   2 +
 drivers/net/ethernet/mscc/ocelot_mm.c  | 213 +++++++++++++++++++++++++
 include/soc/mscc/ocelot.h              |  18 +++
 include/soc/mscc/ocelot_dev.h          |  23 +++
 8 files changed, 301 insertions(+), 12 deletions(-)
 create mode 100644 drivers/net/ethernet/mscc/ocelot_mm.c

diff --git a/drivers/net/dsa/ocelot/felix.c b/drivers/net/dsa/ocelot/felix.c
index 09f839dc9e64..336ad7263042 100644
--- a/drivers/net/dsa/ocelot/felix.c
+++ b/drivers/net/dsa/ocelot/felix.c
@@ -2066,6 +2066,23 @@ static int felix_port_del_dscp_prio(struct dsa_switch *ds, int port, u8 dscp,
 	return ocelot_port_del_dscp_prio(ocelot, port, dscp, prio);
 }
 
+static void felix_get_mm(struct dsa_switch *ds, int port,
+			 struct ethtool_mm_state *state)
+{
+	struct ocelot *ocelot = ds->priv;
+
+	ocelot_port_get_mm(ocelot, port, state);
+}
+
+static int felix_set_mm(struct dsa_switch *ds, int port,
+			struct ethtool_mm_cfg *cfg,
+			struct netlink_ext_ack *extack)
+{
+	struct ocelot *ocelot = ds->priv;
+
+	return ocelot_port_set_mm(ocelot, port, cfg, extack);
+}
+
 static void felix_get_mm_stats(struct dsa_switch *ds, int port,
 			       struct ethtool_mm_stats *stats)
 {
@@ -2081,6 +2098,8 @@ const struct dsa_switch_ops felix_switch_ops = {
 	.setup				= felix_setup,
 	.teardown			= felix_teardown,
 	.set_ageing_time		= felix_set_ageing_time,
+	.get_mm				= felix_get_mm,
+	.set_mm				= felix_set_mm,
 	.get_mm_stats			= felix_get_mm_stats,
 	.get_stats64			= felix_get_stats64,
 	.get_pause_stats		= felix_get_pause_stats,
diff --git a/drivers/net/dsa/ocelot/felix_vsc9959.c b/drivers/net/dsa/ocelot/felix_vsc9959.c
index 260d861c7072..e7020f9081f9 100644
--- a/drivers/net/dsa/ocelot/felix_vsc9959.c
+++ b/drivers/net/dsa/ocelot/felix_vsc9959.c
@@ -6,6 +6,7 @@
 #include <soc/mscc/ocelot_qsys.h>
 #include <soc/mscc/ocelot_vcap.h>
 #include <soc/mscc/ocelot_ana.h>
+#include <soc/mscc/ocelot_dev.h>
 #include <soc/mscc/ocelot_ptp.h>
 #include <soc/mscc/ocelot_sys.h>
 #include <net/tc_act/tc_gate.h>
@@ -476,6 +477,9 @@ static const u32 vsc9959_dev_gmii_regmap[] = {
 	REG(DEV_MAC_FC_MAC_LOW_CFG,		0x3c),
 	REG(DEV_MAC_FC_MAC_HIGH_CFG,		0x40),
 	REG(DEV_MAC_STICKY,			0x44),
+	REG(DEV_MM_ENABLE_CONFIG,		0x48),
+	REG(DEV_MM_VERIF_CONFIG,		0x4C),
+	REG(DEV_MM_STATUS,			0x50),
 	REG_RESERVED(PCS1G_CFG),
 	REG_RESERVED(PCS1G_MODE_CFG),
 	REG_RESERVED(PCS1G_SD_CFG),
@@ -2602,20 +2606,19 @@ static const struct felix_info felix_info_vsc9959 = {
 	.tas_guard_bands_update	= vsc9959_tas_guard_bands_update,
 };
 
+/* The INTB interrupt is shared between for PTP TX timestamp availability
+ * notification and MAC Merge status change on each port.
+ */
 static irqreturn_t felix_irq_handler(int irq, void *data)
 {
 	struct ocelot *ocelot = (struct ocelot *)data;
-
-	/* The INTB interrupt is used for both PTP TX timestamp interrupt
-	 * and preemption status change interrupt on each port.
-	 *
-	 * - Get txtstamp if have
-	 * - TODO: handle preemption. Without handling it, driver may get
-	 *   interrupt storm.
-	 */
+	int port;
 
 	ocelot_get_txtstamp(ocelot);
 
+	for (port = 0; port < ocelot->num_phys_ports; port++)
+		ocelot_port_mm_irq(ocelot, port);
+
 	return IRQ_HANDLED;
 }
 
diff --git a/drivers/net/ethernet/mscc/Makefile b/drivers/net/ethernet/mscc/Makefile
index 5d435a565d4c..16987b72dfc0 100644
--- a/drivers/net/ethernet/mscc/Makefile
+++ b/drivers/net/ethernet/mscc/Makefile
@@ -5,6 +5,7 @@ mscc_ocelot_switch_lib-y := \
 	ocelot_devlink.o \
 	ocelot_flower.o \
 	ocelot_io.o \
+	ocelot_mm.o \
 	ocelot_police.o \
 	ocelot_ptp.o \
 	ocelot_stats.o \
diff --git a/drivers/net/ethernet/mscc/ocelot.c b/drivers/net/ethernet/mscc/ocelot.c
index da56f9bfeaf0..c060b03f7e27 100644
--- a/drivers/net/ethernet/mscc/ocelot.c
+++ b/drivers/net/ethernet/mscc/ocelot.c
@@ -2738,10 +2738,8 @@ int ocelot_init(struct ocelot *ocelot)
 		return -ENOMEM;
 
 	ret = ocelot_stats_init(ocelot);
-	if (ret) {
-		destroy_workqueue(ocelot->owq);
-		return ret;
-	}
+	if (ret)
+		goto err_stats_init;
 
 	INIT_LIST_HEAD(&ocelot->multicast);
 	INIT_LIST_HEAD(&ocelot->pgids);
@@ -2756,6 +2754,12 @@ int ocelot_init(struct ocelot *ocelot)
 	if (ocelot->ops->psfp_init)
 		ocelot->ops->psfp_init(ocelot);
 
+	if (ocelot->mm_supported) {
+		ret = ocelot_mm_init(ocelot);
+		if (ret)
+			goto err_mm_init;
+	}
+
 	for (port = 0; port < ocelot->num_phys_ports; port++) {
 		/* Clear all counters (5 groups) */
 		ocelot_write(ocelot, SYS_STAT_CFG_STAT_VIEW(port) |
@@ -2853,6 +2857,12 @@ int ocelot_init(struct ocelot *ocelot)
 				 ANA_CPUQ_8021_CFG, i);
 
 	return 0;
+
+err_mm_init:
+	ocelot_stats_deinit(ocelot);
+err_stats_init:
+	destroy_workqueue(ocelot->owq);
+	return ret;
 }
 EXPORT_SYMBOL(ocelot_init);
 
diff --git a/drivers/net/ethernet/mscc/ocelot.h b/drivers/net/ethernet/mscc/ocelot.h
index 70dbd9c4e512..e9a0179448bf 100644
--- a/drivers/net/ethernet/mscc/ocelot.h
+++ b/drivers/net/ethernet/mscc/ocelot.h
@@ -109,6 +109,8 @@ void ocelot_mirror_put(struct ocelot *ocelot);
 int ocelot_stats_init(struct ocelot *ocelot);
 void ocelot_stats_deinit(struct ocelot *ocelot);
 
+int ocelot_mm_init(struct ocelot *ocelot);
+
 extern struct notifier_block ocelot_netdevice_nb;
 extern struct notifier_block ocelot_switchdev_nb;
 extern struct notifier_block ocelot_switchdev_blocking_nb;
diff --git a/drivers/net/ethernet/mscc/ocelot_mm.c b/drivers/net/ethernet/mscc/ocelot_mm.c
new file mode 100644
index 000000000000..99c774f56aa8
--- /dev/null
+++ b/drivers/net/ethernet/mscc/ocelot_mm.c
@@ -0,0 +1,213 @@
+// SPDX-License-Identifier: (GPL-2.0 OR MIT)
+/*
+ * Hardware library for MAC Merge Layer and Frame Preemption on TSN-capable
+ * switches (VSC9959)
+ *
+ * Copyright 2022 NXP
+ */
+#include <linux/ethtool.h>
+#include <soc/mscc/ocelot.h>
+#include <soc/mscc/ocelot_dev.h>
+#include <soc/mscc/ocelot_qsys.h>
+
+#include "ocelot.h"
+
+static const char *
+mm_verify_state_to_string(enum ethtool_mm_verify_status state)
+{
+	switch (state) {
+	case ETHTOOL_MM_VERIFY_STATUS_INITIAL:
+		return "INITIAL";
+	case ETHTOOL_MM_VERIFY_STATUS_VERIFYING:
+		return "VERIFYING";
+	case ETHTOOL_MM_VERIFY_STATUS_SUCCEEDED:
+		return "SUCCEEDED";
+	case ETHTOOL_MM_VERIFY_STATUS_FAILED:
+		return "FAILED";
+	case ETHTOOL_MM_VERIFY_STATUS_DISABLED:
+		return "DISABLED";
+	default:
+		return "UNKNOWN";
+	}
+}
+
+static enum ethtool_mm_verify_status ocelot_mm_verify_status(u32 val)
+{
+	switch (DEV_MM_STAT_MM_STATUS_PRMPT_VERIFY_STATE_X(val)) {
+	case 0:
+		return ETHTOOL_MM_VERIFY_STATUS_INITIAL;
+	case 1:
+		return ETHTOOL_MM_VERIFY_STATUS_VERIFYING;
+	case 2:
+		return ETHTOOL_MM_VERIFY_STATUS_SUCCEEDED;
+	case 3:
+		return ETHTOOL_MM_VERIFY_STATUS_FAILED;
+	case 4:
+		return ETHTOOL_MM_VERIFY_STATUS_DISABLED;
+	default:
+		return ETHTOOL_MM_VERIFY_STATUS_UNKNOWN;
+	}
+}
+
+void ocelot_port_mm_irq(struct ocelot *ocelot, int port)
+{
+	struct ocelot_port *ocelot_port = ocelot->ports[port];
+	struct ocelot_mm_state *mm = &ocelot->mm[port];
+	enum ethtool_mm_verify_status verify_status;
+	u32 val;
+
+	mutex_lock(&mm->lock);
+
+	val = ocelot_port_readl(ocelot_port, DEV_MM_STATUS);
+
+	verify_status = ocelot_mm_verify_status(val);
+	if (mm->verify_status != verify_status) {
+		dev_info(ocelot->dev,
+			 "Port %d MAC Merge verification state %s\n",
+			 port, mm_verify_state_to_string(verify_status));
+		mm->verify_status = verify_status;
+	}
+
+	if (val & DEV_MM_STAT_MM_STATUS_PRMPT_ACTIVE_STICKY) {
+		mm->tx_active = !!(val & DEV_MM_STAT_MM_STATUS_PRMPT_ACTIVE_STATUS);
+
+		dev_info(ocelot->dev, "Port %d TX preemption %s\n",
+			 port, mm->tx_active ? "active" : "inactive");
+	}
+
+	if (val & DEV_MM_STAT_MM_STATUS_UNEXP_RX_PFRM_STICKY) {
+		dev_err(ocelot->dev,
+			"Unexpected P-frame received on port %d while verification was unsuccessful or not yet verified\n",
+			port);
+	}
+
+	if (val & DEV_MM_STAT_MM_STATUS_UNEXP_TX_PFRM_STICKY) {
+		dev_err(ocelot->dev,
+			"Unexpected P-frame requested to be transmitted on port %d while verification was unsuccessful or not yet verified, or MM_TX_ENA=0\n",
+			port);
+	}
+
+	ocelot_port_writel(ocelot_port, val, DEV_MM_STATUS);
+
+	mutex_unlock(&mm->lock);
+}
+EXPORT_SYMBOL_GPL(ocelot_port_mm_irq);
+
+int ocelot_port_set_mm(struct ocelot *ocelot, int port,
+		       struct ethtool_mm_cfg *cfg,
+		       struct netlink_ext_ack *extack)
+{
+	struct ocelot_port *ocelot_port = ocelot->ports[port];
+	u32 mm_enable = 0, verify_disable = 0, add_frag_size;
+	struct ocelot_mm_state *mm;
+	int err;
+
+	if (!ocelot->mm_supported)
+		return -EOPNOTSUPP;
+
+	mm = &ocelot->mm[port];
+
+	err = ethtool_mm_add_frag_size_oct_to_std(cfg->add_frag_size,
+						  &add_frag_size,
+						  extack);
+	if (err)
+		return err;
+
+	if (cfg->pmac_enabled)
+		mm_enable |= DEV_MM_CONFIG_ENABLE_CONFIG_MM_RX_ENA;
+
+	if (cfg->tx_enabled)
+		mm_enable |= DEV_MM_CONFIG_ENABLE_CONFIG_MM_TX_ENA;
+
+	if (!cfg->verify_enabled)
+		verify_disable = DEV_MM_CONFIG_VERIF_CONFIG_PRM_VERIFY_DIS;
+
+	mutex_lock(&mm->lock);
+
+	ocelot_port_rmwl(ocelot_port, mm_enable,
+			 DEV_MM_CONFIG_ENABLE_CONFIG_MM_TX_ENA |
+			 DEV_MM_CONFIG_ENABLE_CONFIG_MM_RX_ENA,
+			 DEV_MM_ENABLE_CONFIG);
+
+	ocelot_port_rmwl(ocelot_port, verify_disable |
+			 DEV_MM_CONFIG_VERIF_CONFIG_PRM_VERIFY_TIME(cfg->verify_time),
+			 DEV_MM_CONFIG_VERIF_CONFIG_PRM_VERIFY_DIS |
+			 DEV_MM_CONFIG_VERIF_CONFIG_PRM_VERIFY_TIME_M,
+			 DEV_MM_VERIF_CONFIG);
+
+	ocelot_rmw_rix(ocelot,
+		       QSYS_PREEMPTION_CFG_MM_ADD_FRAG_SIZE(cfg->add_frag_size),
+		       QSYS_PREEMPTION_CFG_MM_ADD_FRAG_SIZE_M,
+		       QSYS_PREEMPTION_CFG,
+		       port);
+
+	mutex_unlock(&mm->lock);
+
+	return 0;
+}
+EXPORT_SYMBOL_GPL(ocelot_port_set_mm);
+
+void ocelot_port_get_mm(struct ocelot *ocelot, int port,
+			struct ethtool_mm_state *state)
+{
+	struct ocelot_port *ocelot_port = ocelot->ports[port];
+	struct ocelot_mm_state *mm;
+	u32 val, add_frag_size;
+
+	if (!ocelot->mm_supported)
+		return;
+
+	mm = &ocelot->mm[port];
+
+	mutex_lock(&mm->lock);
+
+	val = ocelot_port_readl(ocelot_port, DEV_MM_ENABLE_CONFIG);
+	state->pmac_enabled = !!(val & DEV_MM_CONFIG_ENABLE_CONFIG_MM_RX_ENA);
+	state->tx_enabled = !!(val & DEV_MM_CONFIG_ENABLE_CONFIG_MM_TX_ENA);
+
+	val = ocelot_port_readl(ocelot_port, DEV_MM_VERIF_CONFIG);
+	state->verify_time = DEV_MM_CONFIG_VERIF_CONFIG_PRM_VERIFY_TIME_X(val);
+	state->max_verify_time = 128;
+
+	val = ocelot_read_rix(ocelot, QSYS_PREEMPTION_CFG, port);
+	add_frag_size = QSYS_PREEMPTION_CFG_MM_ADD_FRAG_SIZE_X(val);
+	state->add_frag_size = ethtool_mm_add_frag_size_std_to_oct(add_frag_size);
+
+	state->verify_status = mm->verify_status;
+	state->supported = ocelot->mm_supported;
+	state->tx_active = mm->tx_active;
+
+	mutex_unlock(&mm->lock);
+}
+EXPORT_SYMBOL_GPL(ocelot_port_get_mm);
+
+int ocelot_mm_init(struct ocelot *ocelot)
+{
+	struct ocelot_port *ocelot_port;
+	struct ocelot_mm_state *mm;
+	int port;
+
+	if (!ocelot->mm_supported)
+		return 0;
+
+	ocelot->mm = devm_kcalloc(ocelot->dev, ocelot->num_phys_ports,
+				  sizeof(*ocelot->mm), GFP_KERNEL);
+	if (!ocelot->mm)
+		return -ENOMEM;
+
+	for (port = 0; port < ocelot->num_phys_ports; port++) {
+		u32 val;
+
+		mm = &ocelot->mm[port];
+		mutex_init(&mm->lock);
+		ocelot_port = ocelot->ports[port];
+
+		/* Update initial status variable for the
+		 * verification state machine
+		 */
+		val = ocelot_port_readl(ocelot_port, DEV_MM_STATUS);
+		mm->verify_status = ocelot_mm_verify_status(val);
+	}
+
+	return 0;
+}
diff --git a/include/soc/mscc/ocelot.h b/include/soc/mscc/ocelot.h
index 6de909d79896..81c4ff9a3405 100644
--- a/include/soc/mscc/ocelot.h
+++ b/include/soc/mscc/ocelot.h
@@ -515,6 +515,9 @@ enum ocelot_reg {
 	DEV_MAC_FC_MAC_LOW_CFG,
 	DEV_MAC_FC_MAC_HIGH_CFG,
 	DEV_MAC_STICKY,
+	DEV_MM_ENABLE_CONFIG,
+	DEV_MM_VERIF_CONFIG,
+	DEV_MM_STATUS,
 	PCS1G_CFG,
 	PCS1G_MODE_CFG,
 	PCS1G_SD_CFG,
@@ -739,6 +742,12 @@ struct ocelot_mirror {
 	int to;
 };
 
+struct ocelot_mm_state {
+	struct mutex lock;
+	enum ethtool_mm_verify_status verify_status;
+	bool tx_active;
+};
+
 struct ocelot_port;
 
 struct ocelot_port {
@@ -864,6 +873,8 @@ struct ocelot {
 	spinlock_t			ptp_clock_lock;
 	struct ptp_pin_desc		ptp_pins[OCELOT_PTP_PINS_NUM];
 
+	struct ocelot_mm_state		*mm;
+
 	struct ocelot_fdma		*fdma;
 };
 
@@ -1122,6 +1133,13 @@ int ocelot_vcap_policer_add(struct ocelot *ocelot, u32 pol_ix,
 			    struct ocelot_policer *pol);
 int ocelot_vcap_policer_del(struct ocelot *ocelot, u32 pol_ix);
 
+void ocelot_port_mm_irq(struct ocelot *ocelot, int port);
+int ocelot_port_set_mm(struct ocelot *ocelot, int port,
+		       struct ethtool_mm_cfg *cfg,
+		       struct netlink_ext_ack *extack);
+void ocelot_port_get_mm(struct ocelot *ocelot, int port,
+			struct ethtool_mm_state *state);
+
 #if IS_ENABLED(CONFIG_BRIDGE_MRP)
 int ocelot_mrp_add(struct ocelot *ocelot, int port,
 		   const struct switchdev_obj_mrp *mrp);
diff --git a/include/soc/mscc/ocelot_dev.h b/include/soc/mscc/ocelot_dev.h
index 0c6021f02fee..fcf02baa76b2 100644
--- a/include/soc/mscc/ocelot_dev.h
+++ b/include/soc/mscc/ocelot_dev.h
@@ -93,6 +93,29 @@
 #define DEV_MAC_STICKY_TX_FRM_LEN_OVR_STICKY              BIT(1)
 #define DEV_MAC_STICKY_TX_ABORT_STICKY                    BIT(0)
 
+#define DEV_MM_CONFIG_ENABLE_CONFIG_MM_RX_ENA             BIT(0)
+#define DEV_MM_CONFIG_ENABLE_CONFIG_MM_TX_ENA             BIT(4)
+#define DEV_MM_CONFIG_ENABLE_CONFIG_KEEP_S_AFTER_D        BIT(8)
+
+#define DEV_MM_CONFIG_VERIF_CONFIG_PRM_VERIFY_DIS         BIT(0)
+#define DEV_MM_CONFIG_VERIF_CONFIG_PRM_VERIFY_TIME(x)     (((x) << 4) & GENMASK(11, 4))
+#define DEV_MM_CONFIG_VERIF_CONFIG_PRM_VERIFY_TIME_M      GENMASK(11, 4)
+#define DEV_MM_CONFIG_VERIF_CONFIG_PRM_VERIFY_TIME_X(x)   (((x) & GENMASK(11, 4)) >> 4)
+#define DEV_MM_CONFIG_VERIF_CONFIG_VERIF_TIMER_UNITS(x)   (((x) << 12) & GENMASK(13, 12))
+#define DEV_MM_CONFIG_VERIF_CONFIG_VERIF_TIMER_UNITS_M    GENMASK(13, 12)
+#define DEV_MM_CONFIG_VERIF_CONFIG_VERIF_TIMER_UNITS_X(x) (((x) & GENMASK(13, 12)) >> 12)
+
+#define DEV_MM_STAT_MM_STATUS_PRMPT_ACTIVE_STATUS         BIT(0)
+#define DEV_MM_STAT_MM_STATUS_PRMPT_ACTIVE_STICKY         BIT(4)
+#define DEV_MM_STAT_MM_STATUS_PRMPT_VERIFY_STATE(x)       (((x) << 8) & GENMASK(10, 8))
+#define DEV_MM_STAT_MM_STATUS_PRMPT_VERIFY_STATE_M        GENMASK(10, 8)
+#define DEV_MM_STAT_MM_STATUS_PRMPT_VERIFY_STATE_X(x)     (((x) & GENMASK(10, 8)) >> 8)
+#define DEV_MM_STAT_MM_STATUS_UNEXP_RX_PFRM_STICKY        BIT(12)
+#define DEV_MM_STAT_MM_STATUS_UNEXP_TX_PFRM_STICKY        BIT(16)
+#define DEV_MM_STAT_MM_STATUS_MM_RX_FRAME_STATUS          BIT(20)
+#define DEV_MM_STAT_MM_STATUS_MM_TX_FRAME_STATUS          BIT(24)
+#define DEV_MM_STAT_MM_STATUS_MM_TX_PRMPT_STATUS          BIT(28)
+
 #define PCS1G_CFG_LINK_STATUS_TYPE                        BIT(4)
 #define PCS1G_CFG_AN_LINK_CTRL_ENA                        BIT(1)
 #define PCS1G_CFG_PCS_ENA                                 BIT(0)
-- 
2.34.1

