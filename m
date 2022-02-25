Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 558654C4147
	for <lists+netdev@lfdr.de>; Fri, 25 Feb 2022 10:24:36 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S239028AbiBYJYO (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 25 Feb 2022 04:24:14 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:47454 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S239022AbiBYJXv (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 25 Feb 2022 04:23:51 -0500
Received: from EUR04-HE1-obe.outbound.protection.outlook.com (mail-eopbgr70078.outbound.protection.outlook.com [40.107.7.78])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id D54A41A904C
        for <netdev@vger.kernel.org>; Fri, 25 Feb 2022 01:23:18 -0800 (PST)
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=kaycBXiba2ywvvdQqwWErwsjQgEfbgVrIcdrlaffG8Ee0ygZFkmBRnbMKO/Ov3N7CdTqBpL29QtamIBK8Us87btR11wWAF/aGO05Kv/MwjfRaS6JM+IDh3+ANwJfpR1IiMmw66TMyswgolzGbIjEw6lkaQMYNyTJkRHQr3ECHwTrks86KzhHvhQG9ib06MlrEily4V62MtC7A0ANQ/ywpcaA+zHpT7yanPTLpIIMcGwAFuQifR0qcqY2bf2sqd48kcZbIhQab6Uo9sRP5c4b3NLTVB2xHDEw3vm8zBoKqeF/hlBQQJKoTDfnAXjqTdUBrJZRNWRe0Kqcz5YqUO8hfg==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=8GIqQ3bcffn/3x/XyYWSxCGxzpgkDytYrnqDSy9RKmI=;
 b=RCI1eO7zApQHEH7Ge8bc8WoQp/ge4G2iEfJFcPU+fGq87kVFZqyYkJmNs2irgvSNE4j2ZScsXVVYPJGh+CUoioMqgOq1/FIc0r/HmiDHldE5zbTxFAnbDeXRoVRlntcWewEFjQIKqpINznwmVSPNLJVj9fqmbSw/bivesbFubvPnBScb88a6huYO+LvFFf7hiP8yEqW8DA/i2cwPJhiph7ZSS3irr+N3+Z+obWl0rCk/ncg2VTlAurWmzBJ6zDj0wj9sp8o+mEFGAfdbnlHWk+xla3/E/KyiAy97AtHjUBtzls2FrtFtKNmaO6P0QukVcTbR2R7gG+x8KVD6OkuCsQ==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=nxp.com; dmarc=pass action=none header.from=nxp.com; dkim=pass
 header.d=nxp.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=nxp.com; s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=8GIqQ3bcffn/3x/XyYWSxCGxzpgkDytYrnqDSy9RKmI=;
 b=dZFvujNpZI1JLymg+I7Q8KpFHPI/33M0VIPpUHfhcsFPgsHeJpTer52mr/ZvsnilAHt7VEKX1BkCNWresqHGilt2dqMKuyiJhva7SAir0cFobH+CJXK0rPM5oMQfiR25Jz3GwE9LDG8lIUXWftsfsblGC6JJHCf8ZZY1gkNADEw=
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=nxp.com;
Received: from VI1PR04MB5136.eurprd04.prod.outlook.com (2603:10a6:803:55::19)
 by DBBPR04MB7658.eurprd04.prod.outlook.com (2603:10a6:10:20d::24) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.5017.25; Fri, 25 Feb
 2022 09:23:10 +0000
Received: from VI1PR04MB5136.eurprd04.prod.outlook.com
 ([fe80::95cf:8c40:b887:a7b9]) by VI1PR04MB5136.eurprd04.prod.outlook.com
 ([fe80::95cf:8c40:b887:a7b9%4]) with mapi id 15.20.4951.019; Fri, 25 Feb 2022
 09:23:10 +0000
From:   Vladimir Oltean <vladimir.oltean@nxp.com>
To:     netdev@vger.kernel.org, Jakub Kicinski <kuba@kernel.org>,
        "David S. Miller" <davem@davemloft.net>
Cc:     Florian Fainelli <f.fainelli@gmail.com>,
        Andrew Lunn <andrew@lunn.ch>,
        Vivien Didelot <vivien.didelot@gmail.com>,
        Vladimir Oltean <olteanv@gmail.com>,
        Kurt Kanzenbach <kurt@linutronix.de>,
        Hauke Mehrtens <hauke@hauke-m.de>,
        Woojung Huh <woojung.huh@microchip.com>,
        UNGLinuxDriver@microchip.com, Sean Wang <sean.wang@mediatek.com>,
        Landen Chao <Landen.Chao@mediatek.com>,
        DENG Qingfang <dqfext@gmail.com>,
        Claudiu Manoil <claudiu.manoil@nxp.com>,
        Alexandre Belloni <alexandre.belloni@bootlin.com>,
        Linus Walleij <linus.walleij@linaro.org>,
        =?UTF-8?q?Alvin=20=C5=A0ipraga?= <alsi@bang-olufsen.dk>,
        George McCollister <george.mccollister@gmail.com>
Subject: [PATCH v2 net-next 09/10] net: dsa: sja1105: enforce FDB isolation
Date:   Fri, 25 Feb 2022 11:22:24 +0200
Message-Id: <20220225092225.594851-10-vladimir.oltean@nxp.com>
X-Mailer: git-send-email 2.25.1
In-Reply-To: <20220225092225.594851-1-vladimir.oltean@nxp.com>
References: <20220225092225.594851-1-vladimir.oltean@nxp.com>
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-ClientProxiedBy: VI1PR02CA0065.eurprd02.prod.outlook.com
 (2603:10a6:802:14::36) To VI1PR04MB5136.eurprd04.prod.outlook.com
 (2603:10a6:803:55::19)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: 496ef237-1846-438e-6bc3-08d9f84070a8
X-MS-TrafficTypeDiagnostic: DBBPR04MB7658:EE_
X-Microsoft-Antispam-PRVS: <DBBPR04MB765807E35D0B67DACF8785BFE03E9@DBBPR04MB7658.eurprd04.prod.outlook.com>
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: WhyX6scDB7Ats/ittoKqKzb9VPODFkcqhRrmsCE1D9pi5ihOhQkYlhX1yFv0ky8MfW3iCH8zbwPCs5CDPlDXa790/mHl1n92RsW2q+FfhNw4SbLJgdJLpjLMW0sm9bA9/zzs4aAiQK6awgtVx5F7SGErT0bWpw7EmswF1sVCDvBSVJDaO/dlDwbILnbcqVvH2ZJJfRbPwD39DZ5/F7b8QZC28KpCqScZpQmnneXedFys7tQ7VWcwhqHDKv0XfXV6XJOyY69hcuyLm4snzcH3BIv+FJ7z/yC9uzST4U8YnP803MSTuM9nHdpxyXrWn2ujCYgAzYHsUSbixqVNjBvVGDy+ftgJz/arItGvQ3AWublZAOrbrH3Mi9NaHdNw22Mj2Qvu62OWrX26Aq8JiSuc08RDFg61FM+8I/Ydyqlg2jlCgxWh2xqwVCgoZxxgXn5tV5vMo0y/X1auDcnRx2X3sqJ3ETks+mOTFjctXG2CVrrlnU2Y+G2bF7LWAAhVC2KXCSMTTLN46/yKYFh34Ny8lscLT2h7BtjDOOT4ll1W3RFW+fXVZ6aQEFoFkUnbqv08PoxdeBasSJjoeuJ9ALVOplXVpo7lTeYpCxVVbn/+JvaET9lKWXP1iyUq1FpffPpEcYRk77VOhDrKv5Pzy8LoKUWKXILcBT4dYKDh47b+fX/kmzwlBfbs3c3GcphMwf8v15wfxrnil2aTCOyKyTNcOg==
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:VI1PR04MB5136.eurprd04.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230001)(4636009)(366004)(508600001)(54906003)(4326008)(316002)(38100700002)(8676002)(110136005)(6486002)(6666004)(38350700002)(86362001)(8936002)(6506007)(52116002)(36756003)(66946007)(7416002)(26005)(186003)(66556008)(66476007)(1076003)(6512007)(44832011)(83380400001)(5660300002)(2906002)(2616005);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?us-ascii?Q?2X2f6q72SIu1gHwWyuknn0vh2huCAGfaw1KCSH8q4tEGTrdex/bxHNlaRcRQ?=
 =?us-ascii?Q?wQIlu28Idt3ZyVC5RikCCbuaPIeiLEG59puM8u+3sCnSt8O0ugFckoV81mEx?=
 =?us-ascii?Q?ERYntPImDf1wbAjt0gvOq5EKMr1CArwohaIaee27MZToKF89tSLDCuNdxe2y?=
 =?us-ascii?Q?979r6jciNTVCLqC/enbEWcdy9UiJBqwaYO2ogDo5i7mL4XHJQSgn/5JvaF5I?=
 =?us-ascii?Q?fwI+qCtl470IZKgXD2jWVWO35jkYkIWyXMGUbvqsftD4Uu9M1SHtJo4t5hgi?=
 =?us-ascii?Q?XFGIkx1N+/0jSDs06zpiBjNqwkO9yndghpNUeBWfFMApM+8gnqOf+1PuF9dz?=
 =?us-ascii?Q?trl71tzcAtSqASEPK4qrWSEhZ40sd0DnX9J2yMFSPN3lDGuJhk57S02NP2wI?=
 =?us-ascii?Q?/JQvhcfeoVeFw3dMDsP7evm6MdIgo6nIMTcwYP/wlXT7BWKFEzPl+1jaaxP2?=
 =?us-ascii?Q?JLkKDDs4UvbMzoZmzRQ1BHwa0h09nECdHzrlLTR4ivWYFPIZn4qFN8RG8TML?=
 =?us-ascii?Q?S/2Ip4i5Bizsb/BwvbGKGRlHPf/tV4REG8ZXgU9N136/BpecxNs7W7zmK5ct?=
 =?us-ascii?Q?b71JnC7ABC2lUrAJuFx5VsIyxbJs/pOudFe+h2FxlA/rOckPX8J8ur217o9n?=
 =?us-ascii?Q?GP+/O6Pi3Kg+SzjB0thVkavQuAu0mO+9efgu/FkEoOdrDUz4WxPVI90rRQbF?=
 =?us-ascii?Q?RKC6alCXD1rYnUcJzXsPPlY3QTGliSQgXhpHAoUd9SQv7pEWOKK87XOrFnXY?=
 =?us-ascii?Q?GcVcJp9Ufw2F6x2u528ST/v067rOHutMAt1uyLriMJdkV2Aw71+wTzwPsBFa?=
 =?us-ascii?Q?D45+i5tbSEArdBTMyweUL9YwIrkXwpaLiQmfDdBmDTLBnBjE5iT9fgbeEA2n?=
 =?us-ascii?Q?unOOtOw3TycIZxhJSazNBEOfNwkzvvoOpKJAktYR/KB3QMcEVw9PjFOSIR6C?=
 =?us-ascii?Q?zWVBDFDZiBARWhAPMwKO7TRmcEQ/Ald1gTUHEv3/zUmngOm/PZPSUAA50yeI?=
 =?us-ascii?Q?BblTa2GNowlLiM2V4mHVkNkV/ZQmBCGoAtMQGO6nDaYfpVzAZErNoh7VxlHH?=
 =?us-ascii?Q?MXm/x0tijiW5s1rvdJUKieaZqFWfkkDPrYQfbdDwpkH/+UHPrUngBEEMtval?=
 =?us-ascii?Q?wemPJHmYm8+GbGVrLVZqLdYnPCTCxkboSP1S9LR5iAOIhjh/Ske7CpZjaV9f?=
 =?us-ascii?Q?Lb+ks+ulyv+EBDPDeWifpGFrJP5CkJ1yxJJ4f0+NeLttWQxhNAelQguecKfU?=
 =?us-ascii?Q?OBI8QBKWQHr19Pe9ln1uVo4vqFycSgPgUOPP4aHu6z5kePv5NXL1z7fBPdrJ?=
 =?us-ascii?Q?oZ2IFmWxNqYLL0cdmiyEQj9kaGfWrNroX3fPiZv73gNCLJ2ioVH7i698dtDI?=
 =?us-ascii?Q?w30KIF6AeTyBsA6vHUgc6FTWU4DGVstzo5ce6KRjGi3GIFJm1qOktqpt2qIR?=
 =?us-ascii?Q?QqBLwLcB4j1Q6GSKubPTdv64jiOT8dvxTlO/ecm+6A5QLIwp38bsmE7j02tT?=
 =?us-ascii?Q?7DZKTaNjQg9ou5ayGhZoRtAvlAR5hh/wX1+iB+IbpZk7ftMvlHDQWtSqW/YS?=
 =?us-ascii?Q?Vp6j/0VCQkjgUF6tKn4dtkJKmk8ObvErDjrGr2gzHFVWNBdp6er97bNOj0Bp?=
 =?us-ascii?Q?w5mmI5ywEOXHXa46wEdlRV0=3D?=
X-OriginatorOrg: nxp.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 496ef237-1846-438e-6bc3-08d9f84070a8
X-MS-Exchange-CrossTenant-AuthSource: VI1PR04MB5136.eurprd04.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 25 Feb 2022 09:23:10.3504
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 686ea1d3-bc2b-4c6f-a92c-d99c5c301635
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: kmq0lop7njaZ+HS4Y8l/N6YRU+UzIosTyd1JHtwrQrfpSBns60Ixbm24r0CxlxYJOpmz7STski0ct4HpilUE8Q==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: DBBPR04MB7658
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_NONE,
        RCVD_IN_MSPIKE_H2,SPF_HELO_PASS,SPF_PASS,T_SCC_BODY_TEXT_LINE
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

For sja1105, to enforce FDB isolation simply means to turn on
Independent VLAN Learning unconditionally, and to remap VLAN-unaware FDB
and MDB entries towards the private VLAN allocated by tag_8021q for each
bridge.

Standalone ports each have their own standalone tag_8021q VLAN. No
learning happens in that VLAN due to:
- learning being disabled on standalone user ports
- learning being disabled on the CPU port (we use
  assisted_learning_on_cpu_port which only installs bridge FDBs)

VLAN-aware ports learn FDB entries with the bridge VLANs.

VLAN-unaware bridge ports learn with the tag_8021q VLAN for bridging.

Signed-off-by: Vladimir Oltean <vladimir.oltean@nxp.com>
---
 drivers/net/dsa/sja1105/sja1105_main.c | 59 +++++++++++++-------------
 1 file changed, 30 insertions(+), 29 deletions(-)

diff --git a/drivers/net/dsa/sja1105/sja1105_main.c b/drivers/net/dsa/sja1105/sja1105_main.c
index 13bb05241d53..1d7d31a1d27b 100644
--- a/drivers/net/dsa/sja1105/sja1105_main.c
+++ b/drivers/net/dsa/sja1105/sja1105_main.c
@@ -393,10 +393,8 @@ static int sja1105_init_l2_lookup_params(struct sja1105_private *priv)
 		.start_dynspc = 0,
 		/* 2^8 + 2^5 + 2^3 + 2^2 + 2^1 + 1 in Koopman notation */
 		.poly = 0x97,
-		/* This selects between Independent VLAN Learning (IVL) and
-		 * Shared VLAN Learning (SVL)
-		 */
-		.shared_learn = true,
+		/* Always use Independent VLAN Learning (IVL) */
+		.shared_learn = false,
 		/* Don't discard management traffic based on ENFPORT -
 		 * we don't perform SMAC port enforcement anyway, so
 		 * what we are setting here doesn't matter.
@@ -1824,6 +1822,19 @@ static int sja1105_fdb_add(struct dsa_switch *ds, int port,
 {
 	struct sja1105_private *priv = ds->priv;
 
+	if (!vid) {
+		switch (db.type) {
+		case DSA_DB_PORT:
+			vid = dsa_tag_8021q_standalone_vid(db.dp);
+			break;
+		case DSA_DB_BRIDGE:
+			vid = dsa_tag_8021q_bridge_vid(db.bridge.num);
+			break;
+		default:
+			return -EOPNOTSUPP;
+		}
+	}
+
 	return priv->info->fdb_add_cmd(ds, port, addr, vid);
 }
 
@@ -1833,13 +1844,25 @@ static int sja1105_fdb_del(struct dsa_switch *ds, int port,
 {
 	struct sja1105_private *priv = ds->priv;
 
+	if (!vid) {
+		switch (db.type) {
+		case DSA_DB_PORT:
+			vid = dsa_tag_8021q_standalone_vid(db.dp);
+			break;
+		case DSA_DB_BRIDGE:
+			vid = dsa_tag_8021q_bridge_vid(db.bridge.num);
+			break;
+		default:
+			return -EOPNOTSUPP;
+		}
+	}
+
 	return priv->info->fdb_del_cmd(ds, port, addr, vid);
 }
 
 static int sja1105_fdb_dump(struct dsa_switch *ds, int port,
 			    dsa_fdb_dump_cb_t *cb, void *data)
 {
-	struct dsa_port *dp = dsa_to_port(ds, port);
 	struct sja1105_private *priv = ds->priv;
 	struct device *dev = ds->dev;
 	int i;
@@ -1876,7 +1899,7 @@ static int sja1105_fdb_dump(struct dsa_switch *ds, int port,
 		u64_to_ether_addr(l2_lookup.macaddr, macaddr);
 
 		/* We need to hide the dsa_8021q VLANs from the user. */
-		if (!dsa_port_is_vlan_filtering(dp))
+		if (vid_is_dsa_8021q(l2_lookup.vlanid))
 			l2_lookup.vlanid = 0;
 		rc = cb(macaddr, l2_lookup.vlanid, l2_lookup.lockeds, data);
 		if (rc)
@@ -2370,7 +2393,6 @@ sja1105_get_tag_protocol(struct dsa_switch *ds, int port,
 int sja1105_vlan_filtering(struct dsa_switch *ds, int port, bool enabled,
 			   struct netlink_ext_ack *extack)
 {
-	struct sja1105_l2_lookup_params_entry *l2_lookup_params;
 	struct sja1105_general_params_entry *general_params;
 	struct sja1105_private *priv = ds->priv;
 	struct sja1105_table *table;
@@ -2408,28 +2430,6 @@ int sja1105_vlan_filtering(struct dsa_switch *ds, int port, bool enabled,
 	general_params->incl_srcpt1 = enabled;
 	general_params->incl_srcpt0 = enabled;
 
-	/* VLAN filtering => independent VLAN learning.
-	 * No VLAN filtering (or best effort) => shared VLAN learning.
-	 *
-	 * In shared VLAN learning mode, untagged traffic still gets
-	 * pvid-tagged, and the FDB table gets populated with entries
-	 * containing the "real" (pvid or from VLAN tag) VLAN ID.
-	 * However the switch performs a masked L2 lookup in the FDB,
-	 * effectively only looking up a frame's DMAC (and not VID) for the
-	 * forwarding decision.
-	 *
-	 * This is extremely convenient for us, because in modes with
-	 * vlan_filtering=0, dsa_8021q actually installs unique pvid's into
-	 * each front panel port. This is good for identification but breaks
-	 * learning badly - the VID of the learnt FDB entry is unique, aka
-	 * no frames coming from any other port are going to have it. So
-	 * for forwarding purposes, this is as though learning was broken
-	 * (all frames get flooded).
-	 */
-	table = &priv->static_config.tables[BLK_IDX_L2_LOOKUP_PARAMS];
-	l2_lookup_params = table->entries;
-	l2_lookup_params->shared_learn = !enabled;
-
 	for (port = 0; port < ds->num_ports; port++) {
 		if (dsa_is_unused_port(ds, port))
 			continue;
@@ -3115,6 +3115,7 @@ static int sja1105_setup(struct dsa_switch *ds)
 	 */
 	ds->vlan_filtering_is_global = true;
 	ds->untag_bridge_pvid = true;
+	ds->fdb_isolation = true;
 	/* tag_8021q has 3 bits for the VBID, and the value 0 is reserved */
 	ds->max_num_bridges = 7;
 
-- 
2.25.1

