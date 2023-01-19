Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 1E76C673882
	for <lists+netdev@lfdr.de>; Thu, 19 Jan 2023 13:29:58 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230195AbjASM3p (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 19 Jan 2023 07:29:45 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:49298 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230152AbjASM2L (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 19 Jan 2023 07:28:11 -0500
Received: from EUR05-AM6-obe.outbound.protection.outlook.com (mail-am6eur05on2055.outbound.protection.outlook.com [40.107.22.55])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 273B375A07;
        Thu, 19 Jan 2023 04:28:08 -0800 (PST)
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=AIVnz/eu/Pb4DOpHFIuJvLzERKkJ9ss1BIKQ5m1k9XPAgBBbhvPQWjX1w0HF8eoP/3hXhoegdm8O/2smzLBmEekstZQoqJ+TvSYDtV8wrY0kIbKdFQOx9MJEztOQctkbbTmTzmEg8LS/1V6JWrRfCDQ7V9XqCTaYvKfklctsCXAnaK8zM9MRGiSuq1b8QuDn7QelsHj3nSL/TFcKwIFiiRbFR0cEWZir3eEbPnOpVnduOH7WGyK7oJxrGOmXBzSifcKqu1VR/6ZbR26sN5wJ1GxY1ktfwyS/GQNQx2TdL9tfx+5qMoue9fIsHAVNDWIZ4afF2wEqGFdvz7oBUpm0gA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=ZlCEvoaAPG8zFF+Mbd/9J6dxGXSWjWiWEeqfx02DbA0=;
 b=SrE1Ou7EHtofBzG1crdMNTY/WyU/fBDONM7isZ4zMJ4tQShLZ7FfIAaf129Bc835WX44jqCTT94CTTvUqE6Bue9PdhHphW6Hk0FsZ5EkQmUN2KeO7kliv29xurY/L6eVUr860zdYRr9xx+E4lSxnO/QiQ/dMoIea8SqfTUC/Dl8FhxqVkTiT8/m1zUoehKxulUqnK6DC7xo7Li1ot3J901nqFXQQph8Xa8puBGu0WTD6Rra8C5j3zZN8m+/F7CyBDj1QTf4istZApf6wscOU8s7fJuPomgFgr9aRZSwRtijUeHfU+aCij82L3WFhNCKUH0uoA8Io4rOtFkkxb4g8/Q==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=nxp.com; dmarc=pass action=none header.from=nxp.com; dkim=pass
 header.d=nxp.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=nxp.com; s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=ZlCEvoaAPG8zFF+Mbd/9J6dxGXSWjWiWEeqfx02DbA0=;
 b=dyoSZf5LmAd1NbzoEunwYD3TtFdNVK/nvhtVPz/jkVUg7tG1pcIPJAejS2fIx8vGZ7zXLl2maYXdPKOTUHVLk8mdoOmLXKBI1m+Sqhg1pzOhrQz+P3aRBCxzIioj6gcDrUupMQ7LPt+v4CUkv8jRNEb7MRbIws99otUnGjmeoQY=
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=nxp.com;
Received: from VI1PR04MB5136.eurprd04.prod.outlook.com (2603:10a6:803:55::19)
 by PAXPR04MB8206.eurprd04.prod.outlook.com (2603:10a6:102:1cb::12) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.6002.24; Thu, 19 Jan
 2023 12:28:04 +0000
Received: from VI1PR04MB5136.eurprd04.prod.outlook.com
 ([fe80::3cfb:3ae7:1686:a68b]) by VI1PR04MB5136.eurprd04.prod.outlook.com
 ([fe80::3cfb:3ae7:1686:a68b%4]) with mapi id 15.20.6002.024; Thu, 19 Jan 2023
 12:28:04 +0000
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
Subject: [PATCH v4 net-next 12/12] net: mscc: ocelot: add MAC Merge layer support for VSC9959
Date:   Thu, 19 Jan 2023 14:27:04 +0200
Message-Id: <20230119122705.73054-13-vladimir.oltean@nxp.com>
X-Mailer: git-send-email 2.34.1
In-Reply-To: <20230119122705.73054-1-vladimir.oltean@nxp.com>
References: <20230119122705.73054-1-vladimir.oltean@nxp.com>
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-ClientProxiedBy: AM8P189CA0020.EURP189.PROD.OUTLOOK.COM
 (2603:10a6:20b:218::25) To VI1PR04MB5136.eurprd04.prod.outlook.com
 (2603:10a6:803:55::19)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: VI1PR04MB5136:EE_|PAXPR04MB8206:EE_
X-MS-Office365-Filtering-Correlation-Id: fe5fff0a-f754-4cb7-01b5-08dafa189c84
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: HNV8K6iwEy/87eaOzA/7upvtTUCTBk0cpbBvMiC1x6l3R62vv8iPfzWFn9gXEizsXcH2nNerKNuT07RahTiKPrmdK+0Oi9rNa0kggrJ3nN6Jm+eLaswpQTTrQyeR5fDmJW1tMA8FCRPkPMj9DlHtTzKJCVHKasvWt2nPYGoGh38+SLo2VCFxtywvEUwFV3pECNSAJbT1hJ2hG8OSuGvpeGJ8CxdU0IcwiQiLSlL3TX152+bGKJ4kUfBsvLr+ciIEA9jNLj7wBZqOjUXj1+h72Jfysyqyvci+amASLaTnfVRH8CLHq/2+nxu2oPLce6Z63KfdvqtZm36rRD94LtGtQmaX62VAKKjMeysPiboBYHkwAg0PWXNIh5TwG8a42cORTijO1caJlpMVkZwik5RMZcLM1nB7BvtJDUrVLaLoV1gDtZzea+85Z3NUcG/voHAS5PuM39bxL4mROfcJ4Xv/4idygHkt2mLLUnFT9aN+YgGmyVkiWWViRd0xoX6b6d5zz0BDCI/D//0W2+ino0mF85JVN1siDsmK2SK2Q06xfusIe5yhErlE/kfMSpiLaixyqCe3WLtRX/CyBPjo2vvjj+Sk7wTVVUbKicZXvfKCPz0TzNP8+747NxwxflrfyPNIdTnyE2BBleCoBC5TygHdaCUsyiQi2PzcY+2lzxIgBnnVf7R15W5vwNwnaa+6gQ1i
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:VI1PR04MB5136.eurprd04.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230022)(4636009)(136003)(39860400002)(376002)(346002)(366004)(396003)(451199015)(6506007)(86362001)(44832011)(66556008)(7416002)(5660300002)(8936002)(2906002)(66476007)(30864003)(66946007)(38350700002)(38100700002)(316002)(52116002)(54906003)(4326008)(36756003)(478600001)(6486002)(6916009)(41300700001)(8676002)(186003)(1076003)(6512007)(83380400001)(2616005)(26005);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?us-ascii?Q?8gmT3QFppn+dp2pGOz4lWxEEJMI3bRDVL2znKdxrR2CfP6pXvDssE+A7qE8U?=
 =?us-ascii?Q?sV2D3J7azjkXiX7ILAH0ZTnr+tsdsa6a+8JbUD/+KxO/JJyOG2Gc6gM0A1MS?=
 =?us-ascii?Q?i2+BsKu4k86OvbXn/9SSUZi5cfNyOWMppUO6dK/yO6H3Nu80uWkfBJpwWFde?=
 =?us-ascii?Q?oFUl88CrIKyUu+Z+59N2V8omrAsU19VYW3P4d8f+tmpWCeA7YcV4NUccyNv+?=
 =?us-ascii?Q?qMPi9WbIrK0Pqyc42ZwgzKxDn2wbp+OjOD0zAySrjXS/AtPUFhri4yXdnugd?=
 =?us-ascii?Q?oM93cp3WZ94sITxvPPjd6emK12vAvWQ33RJjRFAS95qmwTB8LmAfTZU0pOT9?=
 =?us-ascii?Q?XoHcaXzYx20o05m/iUSKG7p9Ih+a45+c8hal3briE7/kCjT6220zS7fWHjpD?=
 =?us-ascii?Q?rjpzB6wZiQOU7BTo1DbuU2TFWmdUPuF8S28G2C6AFWDDNidHx3CoHMPKnTtA?=
 =?us-ascii?Q?AIrU0GE/HT40P9+z9GST/MZK+hUlVEEyeuf48R1U34E/21A9H7QVN8kKkQPr?=
 =?us-ascii?Q?FBUdpVXTeevBlznIhrNX6CIr7zYkOUID6bw7FWpa8P5nSKbg9NRzgTENUWqZ?=
 =?us-ascii?Q?lR5tgba97MV//tWxDP5WRUjFIFp9FYxLyG23LJFNqcaX2U/OyDJrUSQ3I5Mj?=
 =?us-ascii?Q?fyPYZzz49z6Wz/0M1rsLPHyYHu9x0nJ5OWay2Q5QlJHsaaVQb37+6q1P+Pff?=
 =?us-ascii?Q?YSFyu/sg6Iufh+S2FKUSmIKmUu4ReCAitIHgFnrsXzVdTc9gKIzPH1Ypd2rF?=
 =?us-ascii?Q?SG5cIRMk/YsC2fRm0vMv04HZAUwLsZfiS5F1kDo1a08pfGWOadbQpuEoVp+f?=
 =?us-ascii?Q?W1Qz0GBFb7DTh3zManl2lvDP/KnoeGFIImGSyfPpVYhUh3aSJDLR9gvvbnDR?=
 =?us-ascii?Q?ixkcIAzDHEHozOGvUBIdOK9y+sejIfcwMzh8fZogPsXKKMz0DGzo0hNfMTw0?=
 =?us-ascii?Q?5f/jXMy+b6DvnrRMLnyk8Kdxnx2KTXf+dFds90qh77asT0N+Tjql5YcuL0R6?=
 =?us-ascii?Q?hPa9J2VaQLNV7l655grNf+aAorY24p07guID8y+XGJ3oIqlMgoyKEOvs6vvX?=
 =?us-ascii?Q?XtivGLKX5clyzPq2zIK+q5ufi8SEgFcDqtLy1Yq0ejB2vCP/vOAkeRamxeZv?=
 =?us-ascii?Q?Ai6vrfATiYp5UuTSNCYYRwA1Uw0snlwerFZaYhtLOTK9N78hX5q2/x5ttMDQ?=
 =?us-ascii?Q?jrMpd7Kd3WQdFxc2ksUIaVuCQhUCRjVEn06sjXuinXuOf5C6ETw/6qRIxe8j?=
 =?us-ascii?Q?DXMzqslfJ4kfC2sQ4wxD5EANXSFDo6+RDTEbabLwq1T0mrhsfR1ltWMs7Lbq?=
 =?us-ascii?Q?1FSpgT44OzJ4MJlBOq+QYXyrmowJiXFI6CfcU1JEaiWMWlfCWnYxRvRUeK+A?=
 =?us-ascii?Q?qb9CvIn+m8iivsbujiRL0Hj6KYuhOHJ0f+QqRygJAB5dAdaO2wHvp8Gj2kGV?=
 =?us-ascii?Q?SvEW/57nSMG69Jr/o6+oc4oSG7qG1riNTPNR4L3+A3YRlc5Urvy7t78oYEBy?=
 =?us-ascii?Q?pmbyHDKqmEmPKe5Qeqhy3T6dCM4EALwUvdtLCYmGc3cQscEThJ3TfpcOiwVY?=
 =?us-ascii?Q?p2+am/OpvzSdkzgAcA/znDv3E0ewpVHuqws/a/XZbqXylmm1O5wakduzh7FX?=
 =?us-ascii?Q?YQ=3D=3D?=
X-OriginatorOrg: nxp.com
X-MS-Exchange-CrossTenant-Network-Message-Id: fe5fff0a-f754-4cb7-01b5-08dafa189c84
X-MS-Exchange-CrossTenant-AuthSource: VI1PR04MB5136.eurprd04.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 19 Jan 2023 12:28:04.1683
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 686ea1d3-bc2b-4c6f-a92c-d99c5c301635
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: cOWZzh/iL9kMP6Sy4X8yyrcq98fG5r93QzaxgkQDxP3s5wK52TLCm1l5PhhndkDix/XwZ/YRU3tcF6yurq54XQ==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: PAXPR04MB8206
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
v3->v4: add missing opening bracket in ocelot_port_mm_irq()
v2->v3:
- adapt to add_frag_size -> tx_min_frag_size rename
- populate rx_min_frag_size = ETH_ZLEN
- demote log level of distracting prints to debug
v1->v2: patch is new (v1 was written for enetc)

 drivers/net/dsa/ocelot/felix.c         |  19 +++
 drivers/net/dsa/ocelot/felix_vsc9959.c |  19 ++-
 drivers/net/ethernet/mscc/Makefile     |   1 +
 drivers/net/ethernet/mscc/ocelot.c     |  18 ++-
 drivers/net/ethernet/mscc/ocelot.h     |   2 +
 drivers/net/ethernet/mscc/ocelot_mm.c  | 214 +++++++++++++++++++++++++
 include/soc/mscc/ocelot.h              |  18 +++
 include/soc/mscc/ocelot_dev.h          |  23 +++
 8 files changed, 302 insertions(+), 12 deletions(-)
 create mode 100644 drivers/net/ethernet/mscc/ocelot_mm.c

diff --git a/drivers/net/dsa/ocelot/felix.c b/drivers/net/dsa/ocelot/felix.c
index 7867ca85410f..d21e7be2f8c7 100644
--- a/drivers/net/dsa/ocelot/felix.c
+++ b/drivers/net/dsa/ocelot/felix.c
@@ -2024,6 +2024,23 @@ static int felix_port_del_dscp_prio(struct dsa_switch *ds, int port, u8 dscp,
 	return ocelot_port_del_dscp_prio(ocelot, port, dscp, prio);
 }
 
+static int felix_get_mm(struct dsa_switch *ds, int port,
+			struct ethtool_mm_state *state)
+{
+	struct ocelot *ocelot = ds->priv;
+
+	return ocelot_port_get_mm(ocelot, port, state);
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
@@ -2039,6 +2056,8 @@ const struct dsa_switch_ops felix_switch_ops = {
 	.setup				= felix_setup,
 	.teardown			= felix_teardown,
 	.set_ageing_time		= felix_set_ageing_time,
+	.get_mm				= felix_get_mm,
+	.set_mm				= felix_set_mm,
 	.get_mm_stats			= felix_get_mm_stats,
 	.get_stats64			= felix_get_stats64,
 	.get_pause_stats		= felix_get_pause_stats,
diff --git a/drivers/net/dsa/ocelot/felix_vsc9959.c b/drivers/net/dsa/ocelot/felix_vsc9959.c
index 535512280f12..43dc8ed4854d 100644
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
@@ -2599,20 +2603,19 @@ static const struct felix_info felix_info_vsc9959 = {
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
index 000000000000..08820f2341a1
--- /dev/null
+++ b/drivers/net/ethernet/mscc/ocelot_mm.c
@@ -0,0 +1,214 @@
+// SPDX-License-Identifier: (GPL-2.0 OR MIT)
+/*
+ * Hardware library for MAC Merge Layer and Frame Preemption on TSN-capable
+ * switches (VSC9959)
+ *
+ * Copyright 2022-2023 NXP
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
+		dev_dbg(ocelot->dev,
+			"Port %d MAC Merge verification state %s\n",
+			port, mm_verify_state_to_string(verify_status));
+		mm->verify_status = verify_status;
+	}
+
+	if (val & DEV_MM_STAT_MM_STATUS_PRMPT_ACTIVE_STICKY) {
+		mm->tx_active = !!(val & DEV_MM_STAT_MM_STATUS_PRMPT_ACTIVE_STATUS);
+
+		dev_dbg(ocelot->dev, "Port %d TX preemption %s\n",
+			port, mm->tx_active ? "active" : "inactive");
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
+	err = ethtool_mm_frag_size_min_to_add(cfg->tx_min_frag_size,
+					      &add_frag_size, extack);
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
+		       QSYS_PREEMPTION_CFG_MM_ADD_FRAG_SIZE(add_frag_size),
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
+int ocelot_port_get_mm(struct ocelot *ocelot, int port,
+		       struct ethtool_mm_state *state)
+{
+	struct ocelot_port *ocelot_port = ocelot->ports[port];
+	struct ocelot_mm_state *mm;
+	u32 val, add_frag_size;
+
+	if (!ocelot->mm_supported)
+		return -EOPNOTSUPP;
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
+	state->tx_min_frag_size = ethtool_mm_frag_size_add_to_min(add_frag_size);
+	state->rx_min_frag_size = ETH_ZLEN;
+
+	state->verify_status = mm->verify_status;
+	state->tx_active = mm->tx_active;
+
+	mutex_unlock(&mm->lock);
+
+	return 0;
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
index 6de909d79896..afb11680a793 100644
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
+int ocelot_port_get_mm(struct ocelot *ocelot, int port,
+		       struct ethtool_mm_state *state);
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

