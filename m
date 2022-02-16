Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 95A1D4B8B7B
	for <lists+netdev@lfdr.de>; Wed, 16 Feb 2022 15:33:15 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S235057AbiBPOdY (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 16 Feb 2022 09:33:24 -0500
Received: from mxb-00190b01.gslb.pphosted.com ([23.128.96.19]:58946 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S235082AbiBPOdA (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 16 Feb 2022 09:33:00 -0500
Received: from EUR05-DB8-obe.outbound.protection.outlook.com (mail-db8eur05on2068.outbound.protection.outlook.com [40.107.20.68])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 69BD71688CE
        for <netdev@vger.kernel.org>; Wed, 16 Feb 2022 06:32:46 -0800 (PST)
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=CkE6PJ6H56qdHGn/EH+mEiolrt8+MRtkgCGjtk2hTTie4/vfdwfv5YPiDWtKPrehkT4zF5x+hGjwwO3R8g+Fw2HDuO1WYvgKtQueBmk69OiHnnhrMhSVCkAG2xDE5dzxh03T6z/YXUeSbDMbqJOAJizPAcp78g7BVVTNEKX+Mu5uzbwBi8O77AXF88maWu0t7isU1EnWLTCiRvFDoWxPw/mxYAB3mZYsEOY9bix7VrOzi/p6pZVTMqVZOFv1txIoVUtCeHaNP2PBpcNZMHz1FA5NnUoFnCmhQv7iA/GivQooJeBSW2DOEa//kZt0VbwzBtbgXW9k5Mj8ufwIMsA1Lw==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=Nk/OCO3RpX7LVIOlE9uCFNNYiOuU4m4bSs8f91aKbiU=;
 b=mSPnBddhLqMZPPw2AbpU97qCFknHchHDC0gXMonbeFXbVGqkjjazZIzTfluD75w7yFxSmz77bDv7mfj4YYV2gyY3TKmsunY/bfHWOxeIXhfDSzj+ykfNPpmFGXBudQZnJ3iw34mC40L6Tc9VtG+Wt7b6tpDUrCvO0oMxOHrbImN7I+7VEJyNlSHz3C1BtKAEAGdBDMxr4/3Pj1yXxgRykctx7ailBE4+qCx8pMOyUX4HfJsOxShZEWES9txJFajDNdUgoju7AHN24vPs8myYXgfeiw2ADhhFWg6KO+XqvTK3l4NAJ7fWdiFa74xT83hRS+zbQviBfoFumJC4qV+YTw==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=nxp.com; dmarc=pass action=none header.from=nxp.com; dkim=pass
 header.d=nxp.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=nxp.com; s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=Nk/OCO3RpX7LVIOlE9uCFNNYiOuU4m4bSs8f91aKbiU=;
 b=KVKGk62LmH/uiBW7KptorU932AgPc+p4TmfZpLMWAqzbA1mdEc6OX653icn0YYVqCUUESesKKylIS19Hb7sBcKWsnDSHvDNPZ7cI4bkvgbY/gdg+FNcRKc/oV+Wf4sTkdi9WRat2+pQRAJQuCFQJOXf/eQNOkQJrpXdeDP0xeyw=
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=nxp.com;
Received: from VI1PR04MB5136.eurprd04.prod.outlook.com (2603:10a6:803:55::19)
 by VI1PR04MB6815.eurprd04.prod.outlook.com (2603:10a6:803:130::10) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4995.16; Wed, 16 Feb
 2022 14:32:43 +0000
Received: from VI1PR04MB5136.eurprd04.prod.outlook.com
 ([fe80::95cf:8c40:b887:a7b9]) by VI1PR04MB5136.eurprd04.prod.outlook.com
 ([fe80::95cf:8c40:b887:a7b9%4]) with mapi id 15.20.4951.019; Wed, 16 Feb 2022
 14:32:43 +0000
From:   Vladimir Oltean <vladimir.oltean@nxp.com>
To:     netdev@vger.kernel.org
Cc:     "David S. Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>, Andrew Lunn <andrew@lunn.ch>,
        Vivien Didelot <vivien.didelot@gmail.com>,
        Florian Fainelli <f.fainelli@gmail.com>,
        Claudiu Manoil <claudiu.manoil@nxp.com>,
        Alexandre Belloni <alexandre.belloni@bootlin.com>,
        Horatiu Vultur <horatiu.vultur@microchip.com>,
        UNGLinuxDriver@microchip.com,
        Xiaoliang Yang <xiaoliang.yang_1@nxp.com>,
        Yangbo Lu <yangbo.lu@nxp.com>, Michael Walle <michael@walle.cc>
Subject: [PATCH net-next 06/11] net: dsa: felix: use DSA port iteration helpers
Date:   Wed, 16 Feb 2022 16:30:09 +0200
Message-Id: <20220216143014.2603461-7-vladimir.oltean@nxp.com>
X-Mailer: git-send-email 2.25.1
In-Reply-To: <20220216143014.2603461-1-vladimir.oltean@nxp.com>
References: <20220216143014.2603461-1-vladimir.oltean@nxp.com>
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-ClientProxiedBy: AM0PR04CA0094.eurprd04.prod.outlook.com
 (2603:10a6:208:be::35) To VI1PR04MB5136.eurprd04.prod.outlook.com
 (2603:10a6:803:55::19)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: d25ce305-cc38-4b9e-b7ea-08d9f1593133
X-MS-TrafficTypeDiagnostic: VI1PR04MB6815:EE_
X-Microsoft-Antispam-PRVS: <VI1PR04MB68153BD4F7465997999CCA5BE0359@VI1PR04MB6815.eurprd04.prod.outlook.com>
X-MS-Oob-TLC-OOBClassifiers: OLM:6790;
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: Piy4XtVc0xqPLTVQhLwSmqcK1iEgmUjdWLtq63UbreJCTutim59Zcz1VKBUepB3r6YT8KXi4cMNdngqLyWUiEZ0ASwSeR7YW66VAH4zX8ATyzLsE0tqG0gVTNN7cW+dDv0Qs4PTbYXWTBXi2H2BHNIrxys5u0uiYMYo6R18olFCGsPRLCWqcyHDtnV9PF/i8H26xwOOUiRJZCpJRYCn0Tl3AmJgU6xHgv6eTc42emyEKDTzWDHdpUSboDxh0csbdqOx5kcPhnE8n575ledH9ykvH98cH6v+z8C1Qt+F9r/r10tAx3IG9RR6tqj2E7r7SPfcvak+xdy+iTwiNF8+2iSBbf5A8UIOtvVilYAjbImnKcujbgP9sJ55OJxewWAO5TQX0OstD21jR1PFhP2Vvu96SuJimBIT4/JgUuQCb+skpOlvzb71v+p1JvJsXkRR235u1W5e7sv67KMpN3or/sgHayyDCpMeHf5eblYly0Qdi+wWVdaVM05i1VuYMNymHR772wsuTmbeFcn/zEPMGTRERkBBBH2YnH2vqXvZb/YDWRrqWo2PJe/kALqsbGY/1qpZGIbizekfgKS8MbaQeMtTUwhZoVT0SKNSJszigC97yi73z2Az0aJJiOZHDvV9mn2S8A7JT0awlaR0ks6xYrwhZ/wv4nJDkFeK21HkXqdZYrvzA9m/MYhN6qjwHp8S5gkhIBOUYiSbnHim7tSPNYw==
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:VI1PR04MB5136.eurprd04.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230001)(4636009)(366004)(54906003)(8936002)(36756003)(5660300002)(44832011)(26005)(6916009)(7416002)(316002)(83380400001)(2616005)(186003)(6512007)(1076003)(6666004)(52116002)(66946007)(38350700002)(38100700002)(4326008)(2906002)(8676002)(66556008)(66476007)(86362001)(508600001)(6486002)(6506007);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?us-ascii?Q?FCltaRLGyjEbNwZmxH6jT+vR9pjaRd3t5FS3TpjI477EFrOkrHVDsPU6sM9U?=
 =?us-ascii?Q?sOGmyQiIoc6a/UXTlgVFGKDVCXCpSjc1+c2ThJoKIzYmHz6obpYjkihVdib/?=
 =?us-ascii?Q?fU71BbGseZUD+V3HTBD+O+E9DiB0Vo6u7uvH5t58H99nYzXi5f29aViBhKcj?=
 =?us-ascii?Q?G8yhJ2G9Fq5qzKosXXOEP0yX4fQ2jUIVr0oDsC6TTcqrMPFUQ1kis80SKsNm?=
 =?us-ascii?Q?A6FbY4jhbu+tjCwmrCUly2ekjveOkGLt1R5f2Ok8KtKtGGe3SZ1loz8xQYw2?=
 =?us-ascii?Q?oS2CCajj2KJkmSt5c7EZMAGV3668+fl7KroF24MW0dKLypIrNlHt4OJsakQJ?=
 =?us-ascii?Q?O6onFB4fwBCgX+GFg7g4UGq8W72mCtbg2dDFAasmBFdMIxZBg+gSKW5SmY9h?=
 =?us-ascii?Q?R/FaRw5MGArrFeXhOGqUaN8lE5ohjMOL3vP3kAgcV19DcEKwD0kbSVPMQq4M?=
 =?us-ascii?Q?6t7nKQGUM8DmGLS1v3Q+oTDNr6kiT3uOKBOnsYNhUqvDwdgb245vhsxzk/t3?=
 =?us-ascii?Q?/Wm0N5b+1bf/52qmzTQouzowFG2kpIkKNsPbKUtRj90zZmSSGZzyHOeV7RAa?=
 =?us-ascii?Q?B2bpW1D17bAlZJiVXTjZQOqodVKxRoWwsp5PWiylmGrfOD4AP81tqVc6pTXA?=
 =?us-ascii?Q?iM3tRw+iaDiqoGxlnQ44MoPMZz93vcX63q4r/NiX5OBAmtBS8ezvxiFcIpV3?=
 =?us-ascii?Q?e/obz+SR6MJUtbkTgAF5Du2edgfMyJHU+bPIuse4IEzIx0yRGt5qwoBzaQnB?=
 =?us-ascii?Q?ot6MErY4JHMO8P5SNcFyRu7GJJ3o6KCw0MXf8ubDpc4VYQV4Eb+ssAP2k3PK?=
 =?us-ascii?Q?tFD664BsVb/oIn9F8i3lp/ustB1DIN+5TP30w2M1gqAY66Gu69RvNo0qitW7?=
 =?us-ascii?Q?zV+DPqUT35v+aMXFKjJ9YPUEJNatMOMUXQuPnNc2zCmEgpxOBUwsvkVlxNsT?=
 =?us-ascii?Q?TTq2WR/Y8jQ+vwWVLHqSvky8UGN0h+HTc/1JOjot6018JS5Rcr5JtFhRCVA6?=
 =?us-ascii?Q?QBVtdcm3gcfT+PFaubHSXdDPI0GaTQs9B6kesgDHd+htQ6Ivc6nk0ZPDsWAt?=
 =?us-ascii?Q?htpA47NK9eZ7lmXnKDhXE+8TGenTy1HGb0Bufbj8oU1Dcpal2PZ1C+0mEKUs?=
 =?us-ascii?Q?lm7Z5zGa63APsln9XhAyjXYF+wwsZp3CEMb9i5yWQSqt8Tlaln7g0Z9VkeSD?=
 =?us-ascii?Q?6r2RSGremMPsVAgOcfko0bs3unLMbPkJn8uns5z419do4Uk9xUWeX5QmDQZ2?=
 =?us-ascii?Q?6u3Nfmq/hfiIvZcq8q9K9AS3CREu/XPDz3nIZEBloaxxqrQ5pLRBj3+TJkzT?=
 =?us-ascii?Q?89x7VorpovGc8rJ8CzRn7lrlrrcMV0WMQ0zu77G6Fx4F8xBg0++/yOIkTNoa?=
 =?us-ascii?Q?NriMxKc5Brb+MCgS+gzE8ggYzRBFkM6wsH4CI83Jz52K94Ex99Gx8T2rTmho?=
 =?us-ascii?Q?iwxlnI8T88Mr2MEUKDlAWmHpUFBbnfA1ZdxR228tEhhw/LJh5T/dgYnG+I/a?=
 =?us-ascii?Q?bMBJJdrXNy6HOYN43Ryi+uw0QsQOIjGx+0yYnuIoBxav2+Pu3MqfcLRWp6PT?=
 =?us-ascii?Q?YMAr7adPvce1oVXCJfV5/2RfydR1guLVDCOvpXJ7v/JK8x8LmOf4iX+kkGDw?=
 =?us-ascii?Q?PuiwrB4Kihv8p9DzS9THiX8=3D?=
X-OriginatorOrg: nxp.com
X-MS-Exchange-CrossTenant-Network-Message-Id: d25ce305-cc38-4b9e-b7ea-08d9f1593133
X-MS-Exchange-CrossTenant-AuthSource: VI1PR04MB5136.eurprd04.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 16 Feb 2022 14:32:43.0898
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 686ea1d3-bc2b-4c6f-a92c-d99c5c301635
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: gGkuFu8I3hfX9tvJcwm7p+nlDgu9au+fuNoIot4j1Anz9rkullXjXyUtctbOpi6X2zpmzGVA6Zb/nYMzawW5dQ==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: VI1PR04MB6815
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_NONE,
        RCVD_IN_MSPIKE_H2,SPF_HELO_PASS,SPF_PASS,T_SCC_BODY_TEXT_LINE
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Use the helpers that avoid the quadratic complexity associated with
calling dsa_to_port() indirectly: dsa_is_unused_port(),
dsa_is_cpu_port().

Signed-off-by: Vladimir Oltean <vladimir.oltean@nxp.com>
---
 drivers/net/dsa/ocelot/felix.c | 75 ++++++++++++----------------------
 1 file changed, 27 insertions(+), 48 deletions(-)

diff --git a/drivers/net/dsa/ocelot/felix.c b/drivers/net/dsa/ocelot/felix.c
index eae6da2d625d..549c41a0ebe0 100644
--- a/drivers/net/dsa/ocelot/felix.c
+++ b/drivers/net/dsa/ocelot/felix.c
@@ -278,7 +278,8 @@ static int felix_setup_mmio_filtering(struct felix *felix)
 	struct ocelot_vcap_filter *tagging_rule;
 	struct ocelot *ocelot = &felix->ocelot;
 	struct dsa_switch *ds = felix->ds;
-	int cpu = -1, port, ret;
+	struct dsa_port *dp;
+	int cpu = -1, ret;
 
 	tagging_rule = kzalloc(sizeof(struct ocelot_vcap_filter), GFP_KERNEL);
 	if (!tagging_rule)
@@ -290,11 +291,9 @@ static int felix_setup_mmio_filtering(struct felix *felix)
 		return -ENOMEM;
 	}
 
-	for (port = 0; port < ocelot->num_phys_ports; port++) {
-		if (dsa_is_cpu_port(ds, port)) {
-			cpu = port;
-			break;
-		}
+	dsa_switch_for_each_cpu_port(dp, ds) {
+		cpu = dp->index;
+		break;
 	}
 
 	if (cpu < 0) {
@@ -401,14 +400,12 @@ static int felix_setup_tag_8021q(struct dsa_switch *ds, int cpu)
 	struct ocelot *ocelot = ds->priv;
 	struct felix *felix = ocelot_to_felix(ocelot);
 	unsigned long cpu_flood;
-	int port, err;
+	struct dsa_port *dp;
+	int err;
 
 	felix_8021q_cpu_port_init(ocelot, cpu);
 
-	for (port = 0; port < ds->num_ports; port++) {
-		if (dsa_is_unused_port(ds, port))
-			continue;
-
+	dsa_switch_for_each_available_port(dp, ds) {
 		/* This overwrites ocelot_init():
 		 * Do not forward BPDU frames to the CPU port module,
 		 * for 2 reasons:
@@ -421,7 +418,7 @@ static int felix_setup_tag_8021q(struct dsa_switch *ds, int cpu)
 		 */
 		ocelot_write_gix(ocelot,
 				 ANA_PORT_CPU_FWD_BPDU_CFG_BPDU_REDIR_ENA(0),
-				 ANA_PORT_CPU_FWD_BPDU_CFG, port);
+				 ANA_PORT_CPU_FWD_BPDU_CFG, dp->index);
 	}
 
 	/* In tag_8021q mode, the CPU port module is unused, except for PTP
@@ -452,7 +449,8 @@ static void felix_teardown_tag_8021q(struct dsa_switch *ds, int cpu)
 {
 	struct ocelot *ocelot = ds->priv;
 	struct felix *felix = ocelot_to_felix(ocelot);
-	int err, port;
+	struct dsa_port *dp;
+	int err;
 
 	err = felix_teardown_mmio_filtering(felix);
 	if (err)
@@ -461,17 +459,14 @@ static void felix_teardown_tag_8021q(struct dsa_switch *ds, int cpu)
 
 	dsa_tag_8021q_unregister(ds);
 
-	for (port = 0; port < ds->num_ports; port++) {
-		if (dsa_is_unused_port(ds, port))
-			continue;
-
+	dsa_switch_for_each_available_port(dp, ds) {
 		/* Restore the logic from ocelot_init:
 		 * do not forward BPDU frames to the front ports.
 		 */
 		ocelot_write_gix(ocelot,
 				 ANA_PORT_CPU_FWD_BPDU_CFG_BPDU_REDIR_ENA(0xffff),
 				 ANA_PORT_CPU_FWD_BPDU_CFG,
-				 port);
+				 dp->index);
 	}
 
 	felix_8021q_cpu_port_deinit(ocelot, cpu);
@@ -1200,7 +1195,8 @@ static int felix_setup(struct dsa_switch *ds)
 {
 	struct ocelot *ocelot = ds->priv;
 	struct felix *felix = ocelot_to_felix(ocelot);
-	int port, err;
+	struct dsa_port *dp;
+	int err;
 
 	err = felix_init_structs(felix, ds->num_ports);
 	if (err)
@@ -1219,30 +1215,24 @@ static int felix_setup(struct dsa_switch *ds)
 		}
 	}
 
-	for (port = 0; port < ds->num_ports; port++) {
-		if (dsa_is_unused_port(ds, port))
-			continue;
-
-		ocelot_init_port(ocelot, port);
+	dsa_switch_for_each_available_port(dp, ds) {
+		ocelot_init_port(ocelot, dp->index);
 
 		/* Set the default QoS Classification based on PCP and DEI
 		 * bits of vlan tag.
 		 */
-		felix_port_qos_map_init(ocelot, port);
+		felix_port_qos_map_init(ocelot, dp->index);
 	}
 
 	err = ocelot_devlink_sb_register(ocelot);
 	if (err)
 		goto out_deinit_ports;
 
-	for (port = 0; port < ds->num_ports; port++) {
-		if (!dsa_is_cpu_port(ds, port))
-			continue;
-
+	dsa_switch_for_each_cpu_port(dp, ds) {
 		/* The initial tag protocol is NPI which always returns 0, so
 		 * there's no real point in checking for errors.
 		 */
-		felix_set_tag_protocol(ds, port, felix->tag_proto);
+		felix_set_tag_protocol(ds, dp->index, felix->tag_proto);
 		break;
 	}
 
@@ -1252,12 +1242,8 @@ static int felix_setup(struct dsa_switch *ds)
 	return 0;
 
 out_deinit_ports:
-	for (port = 0; port < ocelot->num_phys_ports; port++) {
-		if (dsa_is_unused_port(ds, port))
-			continue;
-
-		ocelot_deinit_port(ocelot, port);
-	}
+	dsa_switch_for_each_available_port(dp, ds)
+		ocelot_deinit_port(ocelot, dp->index);
 
 	ocelot_deinit_timestamp(ocelot);
 	ocelot_deinit(ocelot);
@@ -1273,22 +1259,15 @@ static void felix_teardown(struct dsa_switch *ds)
 {
 	struct ocelot *ocelot = ds->priv;
 	struct felix *felix = ocelot_to_felix(ocelot);
-	int port;
-
-	for (port = 0; port < ds->num_ports; port++) {
-		if (!dsa_is_cpu_port(ds, port))
-			continue;
+	struct dsa_port *dp;
 
-		felix_del_tag_protocol(ds, port, felix->tag_proto);
+	dsa_switch_for_each_cpu_port(dp, ds) {
+		felix_del_tag_protocol(ds, dp->index, felix->tag_proto);
 		break;
 	}
 
-	for (port = 0; port < ocelot->num_phys_ports; port++) {
-		if (dsa_is_unused_port(ds, port))
-			continue;
-
-		ocelot_deinit_port(ocelot, port);
-	}
+	dsa_switch_for_each_available_port(dp, ds)
+		ocelot_deinit_port(ocelot, dp->index);
 
 	ocelot_devlink_sb_unregister(ocelot);
 	ocelot_deinit_timestamp(ocelot);
-- 
2.25.1

