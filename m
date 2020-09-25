Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 850D22786F0
	for <lists+netdev@lfdr.de>; Fri, 25 Sep 2020 14:20:18 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728656AbgIYMTv (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 25 Sep 2020 08:19:51 -0400
Received: from mail-eopbgr60059.outbound.protection.outlook.com ([40.107.6.59]:28384
        "EHLO EUR04-DB3-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1728606AbgIYMTt (ORCPT <rfc822;netdev@vger.kernel.org>);
        Fri, 25 Sep 2020 08:19:49 -0400
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=HSZgJxYK4c3ODNGQyXh6oHK48m0Rpk4wg26IuHWA60+g45idrytWo+eid6MeJ4GqJKZXzh62NJ0vIrpSNwuKfHlTfQXy1C+vLBNQLqlID2/aXOGfaKOAKFgxhudIDfzsU4BIVnQFMBaicsOqDhZHEpsTlaOvMKuk72LJYrOPsCYS5EKLVuxPHKvsoip7qnv5soP54ED6iAoMj8Qp4OxPtpwzG9mIHjRPmc9RWHhm4OhNKiJ9m3u/wFcBlYdJBdT600z5snh9IaalX1WP/bM5V1j7+8wZj5NGLlr5wCKIoUe9CjQiYcMDUusAJeXrPlYV6hk5NiVFWDfQWZNgB5W7mA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=agZmzjZP17/GQ1WS5Z5+QM0kGrID4im+qb4xLcuv8ng=;
 b=mZw7P63RPFiauJ88uahg3stuv3UdWPaMJmSV5Ses59YqX0DmGGol297PsXVRgq+x87vOlvHz3MyPyPZyS9viMLg/6iT/fLenqK6DmLJmnaMzyeVJhQDJ99aTBZRDJ1a3gOQZ1G6mw7oDKDlwVI4WfyMVDq0gTaORI0f2iTZDw0ScdLespFA0tg+B2/Ox+jKViTPUVWnO6s/r0IvhvXKRVUNymyVHGZofEGaWwxuqSgVKrCJQ2hmXvZV2phG/srzPKyPLB5r8W9Adds8zaQMmBd/rHJqOIKjzCx5lTnmvO3ivQvisAEZgPrfnSBeuK9jmBzh2+6zri13HDViTSdknnQ==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=nxp.com; dmarc=pass action=none header.from=nxp.com; dkim=pass
 header.d=nxp.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=nxp.com; s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=agZmzjZP17/GQ1WS5Z5+QM0kGrID4im+qb4xLcuv8ng=;
 b=R8fq8Tfnqaav3dOnSUSRLkMSkdym+jZhucf+mDONV7TbPedvIL+jKNaErHZdb7JnAuuLDFVlxNdmLagOjx6+Yxi/O+RAXyl6jWAXUd+i4BeaDIhJCMQVTb0CKoE8JLv6+g9Cn//7TcLTvDEe9CaJ5/3pt7xzaleetsnHsdy1JGE=
Authentication-Results: davemloft.net; dkim=none (message not signed)
 header.d=none;davemloft.net; dmarc=none action=none header.from=nxp.com;
Received: from VI1PR04MB5696.eurprd04.prod.outlook.com (2603:10a6:803:e7::13)
 by VI1PR0402MB3550.eurprd04.prod.outlook.com (2603:10a6:803:3::17) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.3412.20; Fri, 25 Sep
 2020 12:19:30 +0000
Received: from VI1PR04MB5696.eurprd04.prod.outlook.com
 ([fe80::983b:73a7:cc93:e63d]) by VI1PR04MB5696.eurprd04.prod.outlook.com
 ([fe80::983b:73a7:cc93:e63d%3]) with mapi id 15.20.3412.024; Fri, 25 Sep 2020
 12:19:29 +0000
From:   Vladimir Oltean <vladimir.oltean@nxp.com>
To:     davem@davemloft.net
Cc:     alexandre.belloni@bootlin.com, andrew@lunn.ch,
        f.fainelli@gmail.com, vivien.didelot@gmail.com,
        horatiu.vultur@microchip.com, joergen.andreasen@microchip.com,
        allan.nielsen@microchip.com, alexandru.marginean@nxp.com,
        claudiu.manoil@nxp.com, netdev@vger.kernel.org,
        UNGLinuxDriver@microchip.com
Subject: [RFC PATCH net-next 10/14] net: mscc: ocelot: offload egress VLAN rewriting to VCAP ES0
Date:   Fri, 25 Sep 2020 15:18:51 +0300
Message-Id: <20200925121855.370863-11-vladimir.oltean@nxp.com>
X-Mailer: git-send-email 2.25.1
In-Reply-To: <20200925121855.370863-1-vladimir.oltean@nxp.com>
References: <20200925121855.370863-1-vladimir.oltean@nxp.com>
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-ClientProxiedBy: VE1PR08CA0007.eurprd08.prod.outlook.com
 (2603:10a6:803:104::20) To VI1PR04MB5696.eurprd04.prod.outlook.com
 (2603:10a6:803:e7::13)
MIME-Version: 1.0
X-MS-Exchange-MessageSentRepresentingType: 1
Received: from localhost.localdomain (188.25.217.212) by VE1PR08CA0007.eurprd08.prod.outlook.com (2603:10a6:803:104::20) with Microsoft SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.3412.20 via Frontend Transport; Fri, 25 Sep 2020 12:19:28 +0000
X-Mailer: git-send-email 2.25.1
X-Originating-IP: [188.25.217.212]
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-HT: Tenant
X-MS-Office365-Filtering-Correlation-Id: 2f90c984-b517-4499-ca10-08d8614d4014
X-MS-TrafficTypeDiagnostic: VI1PR0402MB3550:
X-MS-Exchange-Transport-Forked: True
X-Microsoft-Antispam-PRVS: <VI1PR0402MB35506234FB3749FE9BAAE95AE0360@VI1PR0402MB3550.eurprd04.prod.outlook.com>
X-MS-Oob-TLC-OOBClassifiers: OLM:7691;
X-MS-Exchange-SenderADCheck: 1
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: SX7TwABmlFx4n4Xxhg/BCAHrhIJwZLi/MMtp/egsCQYUUHQkJDu1CoNv3YBwsfh2nfqTXWTwWEFejgjObNc24tl+uD+/xSl6dorXFGwmXrwjDRngUkrBSftCL/oftfzIRhjiOgDTqr+yfv+aC7nkpKG6CGBRyoVG6LRFlYHjSkFxfIWvKSL8X5Ci5LMFEhbtdrV9xOk0DE9YhPaRkQ4LywaafjnvHU0pfjFMeOYVzh2pXt/4xw3qwz4XU5Va0ZZhn/JX88X30NhnqD/js250SCSMK3+hTdlXMgwmlfOKQ+D1dFvrlGciqzKynA7ZOP2ZC6wwS+Nx8gCGpN4xTfvG5lejiGJQ+njUoyzCYasAtlhb07sCtO4iXt+UXlZVsDw2
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:VI1PR04MB5696.eurprd04.prod.outlook.com;PTR:;CAT:NONE;SFS:(4636009)(136003)(396003)(366004)(376002)(39860400002)(346002)(66946007)(66556008)(36756003)(26005)(4326008)(8676002)(956004)(2616005)(30864003)(69590400008)(83380400001)(86362001)(66476007)(44832011)(52116002)(6916009)(6666004)(1076003)(6512007)(8936002)(6506007)(186003)(7416002)(5660300002)(6486002)(2906002)(316002)(478600001)(16526019);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData: cFz1H8+A7+0mivElj3g4JA+yXmln8q2+nYmzJE0gKGMRJtLhONnHkEGNK5Ql/WQwTQpcR70x9cU34sfMEQ1u+7cKMeFZ6FNRPAcUu9J6uJtsY4AardG1dQO1EjpQEdNbQHWDmVVLmCCcPhVvDCQ+smzLf3rnzwrKCVfSHLOs8LiSXZYKBawc6rJGBu8SGUokf13ufB/cH+egbRI4j/a+myn+8Cl2izXYHbkin1n3FNEKzPXisQFmtGxWhwzuql4IoNb/L7WnCDybNfdpGGG68j/JO5UUKqgRcK38JrajgQQJQ/dKdwDYvhp9Cur5pB7YoCOkZm1b8VZPIxk50NNLlnGivzpGJhQWcOgD3ZKaxWdAIvb76l2hou18iMQ6zL0LbDlS04OOG++dmVvRSSzkzvcuo9Y/6A2vHrQoM5Z5oSGzUdI0Dmc9Hd2krSHMMCQFxspwcddeOD1MdVrISJlbmC/ho9V3qQGds5nDbpfU7ooAQTJYhJs2HxePAZhx1b+3q9ylQqRFamSnBo3kCJ89hmzEmyQhAupnAMOmBOJBhRhOqXvGezWpAstPOoDnrq3ZxN6aTLv79F5tJX0OayBX2ZSSfMnbsgDBuFnp2TFRvpG4TgoKpmnBOIS0Z6olB5OeHdkusId+jEQwTIArnaOmmw==
X-OriginatorOrg: nxp.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 2f90c984-b517-4499-ca10-08d8614d4014
X-MS-Exchange-CrossTenant-AuthSource: VI1PR04MB5696.eurprd04.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 25 Sep 2020 12:19:29.0674
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 686ea1d3-bc2b-4c6f-a92c-d99c5c301635
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: t4XtNXZbTxr/lVH81kot6u/SdD+zgChhnWVw2bC8e2G58Yf0q7hMUCOxQggpaiBKjZz2/gnUotm0h1KRtinjVw==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: VI1PR0402MB3550
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Xiaoliang Yang <xiaoliang.yang_1@nxp.com>

VCAP ES0 is an egress VCAP working on all outgoing frames.
This patch added ES0 driver to support vlan push action of tc filter.
Usage:

tc filter add dev swp1 egress protocol 802.1Q flower indev swp0 skip_sw \
	vlan_id 1 vlan_prio 1 action vlan push id 2 priority 2

TODO: fill the VCAP properties, key and action offsets for VSC9953
Seville and VSC7514 Ocelot. Only tested on VSC9959 Felix.

Signed-off-by: Xiaoliang Yang <xiaoliang.yang_1@nxp.com>
Signed-off-by: Vladimir Oltean <vladimir.oltean@nxp.com>
---
 drivers/net/dsa/ocelot/felix_vsc9959.c    |  59 ++++++++++++
 drivers/net/ethernet/mscc/ocelot.c        |   4 +
 drivers/net/ethernet/mscc/ocelot_flower.c | 108 ++++++++++++++++++++--
 drivers/net/ethernet/mscc/ocelot_vcap.c   |  82 +++++++++++++++-
 drivers/net/ethernet/mscc/ocelot_vcap.h   |  39 ++++++++
 include/soc/mscc/ocelot.h                 |   1 +
 include/soc/mscc/ocelot_vcap.h            |  42 +++++++++
 7 files changed, 325 insertions(+), 10 deletions(-)

diff --git a/drivers/net/dsa/ocelot/felix_vsc9959.c b/drivers/net/dsa/ocelot/felix_vsc9959.c
index 869af4c994a4..e6e9e98ead30 100644
--- a/drivers/net/dsa/ocelot/felix_vsc9959.c
+++ b/drivers/net/dsa/ocelot/felix_vsc9959.c
@@ -21,6 +21,7 @@
 #define VSC9959_VCAP_PORT_CNT		6
 #define VSC9959_VCAP_IS1_CNT		256
 #define VSC9959_VCAP_IS1_ENTRY_WIDTH	376
+#define VSC9959_VCAP_ES0_CNT		1024
 #define VSC9959_TAS_GCL_ENTRY_MAX	63
 
 static const u32 vsc9959_ana_regmap[] = {
@@ -363,6 +364,7 @@ static const u32 *vsc9959_regmap[TARGET_MAX] = {
 	[QSYS]	= vsc9959_qsys_regmap,
 	[REW]	= vsc9959_rew_regmap,
 	[SYS]	= vsc9959_sys_regmap,
+	[S0]	= vsc9959_vcap_regmap,
 	[S1]	= vsc9959_vcap_regmap,
 	[S2]	= vsc9959_vcap_regmap,
 	[PTP]	= vsc9959_ptp_regmap,
@@ -397,6 +399,11 @@ static const struct resource vsc9959_target_io_res[TARGET_MAX] = {
 		.end	= 0x001ffff,
 		.name	= "sys",
 	},
+	[S0] = {
+		.start	= 0x0040000,
+		.end	= 0x00403ff,
+		.name	= "s0",
+	},
 	[S1] = {
 		.start	= 0x0050000,
 		.end	= 0x00503ff,
@@ -606,6 +613,38 @@ static const struct ocelot_stat_layout vsc9959_stats_layout[] = {
 	{ .offset = 0x111,	.name = "drop_green_prio_7", },
 };
 
+static struct vcap_field vsc9959_vcap_es0_keys[] = {
+	[VCAP_ES0_EGR_PORT]			= {  0,  3},
+	[VCAP_ES0_IGR_PORT]			= {  3,  3},
+	[VCAP_ES0_RSV]				= {  6,  2},
+	[VCAP_ES0_L2_MC]			= {  8,  1},
+	[VCAP_ES0_L2_BC]			= {  9,  1},
+	[VCAP_ES0_VID]				= { 10, 12},
+	[VCAP_ES0_DP]				= { 22,  1},
+	[VCAP_ES0_PCP]				= { 23,  3},
+};
+
+struct vcap_field vsc9959_vcap_es0_actions[] = {
+	[VCAP_ES0_ACT_PUSH_OUTER_TAG]		= {  0,  2},
+	[VCAP_ES0_ACT_PUSH_INNER_TAG]		= {  2,  1},
+	[VCAP_ES0_ACT_TAG_A_TPID_SEL]		= {  3,  2},
+	[VCAP_ES0_ACT_TAG_A_VID_SEL]		= {  5,  1},
+	[VCAP_ES0_ACT_TAG_A_PCP_SEL]		= {  6,  2},
+	[VCAP_ES0_ACT_TAG_A_DEI_SEL]		= {  8,  2},
+	[VCAP_ES0_ACT_TAG_B_TPID_SEL]		= { 10,  2},
+	[VCAP_ES0_ACT_TAG_B_VID_SEL]		= { 12,  1},
+	[VCAP_ES0_ACT_TAG_B_PCP_SEL]		= { 13,  2},
+	[VCAP_ES0_ACT_TAG_B_DEI_SEL]		= { 15,  2},
+	[VCAP_ES0_ACT_VID_A_VAL]		= { 17, 12},
+	[VCAP_ES0_ACT_PCP_A_VAL]		= { 29,  3},
+	[VCAP_ES0_ACT_DEI_A_VAL]		= { 32,  1},
+	[VCAP_ES0_ACT_VID_B_VAL]		= { 33, 12},
+	[VCAP_ES0_ACT_PCP_B_VAL]		= { 45,  3},
+	[VCAP_ES0_ACT_DEI_B_VAL]		= { 48,  1},
+	[VCAP_ES0_ACT_RSV]			= { 49, 23},
+	[VCAP_ES0_ACT_HIT_STICKY]		= { 72,  1},
+};
+
 static struct vcap_field vsc9959_vcap_is1_keys[] = {
 	[VCAP_IS1_HK_TYPE]			= {  0,   1},
 	[VCAP_IS1_HK_LOOKUP]			= {  1,   2},
@@ -779,6 +818,26 @@ static struct vcap_field vsc9959_vcap_is2_actions[] = {
 };
 
 static const struct vcap_props vsc9959_vcap_props[] = {
+	[VCAP_ES0] = {
+		.tg_width = 1,
+		.sw_count = 1,
+		.entry_count = VSC9959_VCAP_ES0_CNT,
+		.entry_width = 29,
+		.action_count = VSC9959_VCAP_ES0_CNT + 6,
+		.action_width = 72,
+		.action_type_width = 0,
+		.action_table = {
+			[ES0_ACTION_TYPE_NORMAL] = {
+				.width = 72,
+				.count = 1
+			},
+		},
+		.counter_words = 1,
+		.counter_width = 1,
+		.target = S0,
+		.keys = vsc9959_vcap_es0_keys,
+		.actions = vsc9959_vcap_es0_actions,
+	},
 	[VCAP_IS1] = {
 		.tg_width = 2,
 		.sw_count = 4,
diff --git a/drivers/net/ethernet/mscc/ocelot.c b/drivers/net/ethernet/mscc/ocelot.c
index 66921a932009..e4b0212d099f 100644
--- a/drivers/net/ethernet/mscc/ocelot.c
+++ b/drivers/net/ethernet/mscc/ocelot.c
@@ -114,6 +114,10 @@ static void ocelot_vcap_enable(struct ocelot *ocelot, int port)
 			 ANA_PORT_VCAP_S1_KEY_CFG_S1_KEY_IP6_CFG(2) |
 			 ANA_PORT_VCAP_S1_KEY_CFG_S1_KEY_IP4_CFG(2),
 			 ANA_PORT_VCAP_S1_KEY_CFG, port);
+
+	ocelot_rmw_gix(ocelot, REW_PORT_CFG_ES0_EN,
+		       REW_PORT_CFG_ES0_EN,
+		       REW_PORT_CFG, port);
 }
 
 static inline u32 ocelot_vlant_read_vlanaccess(struct ocelot *ocelot)
diff --git a/drivers/net/ethernet/mscc/ocelot_flower.c b/drivers/net/ethernet/mscc/ocelot_flower.c
index d9927fff8354..d01b235f5134 100644
--- a/drivers/net/ethernet/mscc/ocelot_flower.c
+++ b/drivers/net/ethernet/mscc/ocelot_flower.c
@@ -143,6 +143,7 @@ static int ocelot_flower_parse_action(struct flow_cls_offload *f, bool ingress,
 	struct netlink_ext_ack *extack = f->common.extack;
 	bool allow_missing_goto_target = false;
 	const struct flow_action_entry *a;
+	enum ocelot_tag_tpid_sel tpid;
 	int i, chain;
 	u64 rate;
 
@@ -277,6 +278,31 @@ static int ocelot_flower_parse_action(struct flow_cls_offload *f, bool ingress,
 				filter->type = OCELOT_VCAP_FILTER_PAG;
 			}
 			break;
+		case FLOW_ACTION_VLAN_PUSH:
+			if (filter->block_id != VCAP_ES0) {
+				NL_SET_ERR_MSG_MOD(extack,
+						   "VLAN push action can only be offloaded to VCAP ES0");
+				return -EOPNOTSUPP;
+			}
+			switch (a->vlan.proto) {
+			case (ntohs(ETH_P_8021Q)):
+				tpid = OCELOT_TAG_TPID_SEL_8021Q;
+				break;
+			case (ntohs(ETH_P_8021AD)):
+				tpid = OCELOT_TAG_TPID_SEL_8021AD;
+				break;
+			default:
+				NL_SET_ERR_MSG_MOD(extack,
+						   "Cannot push custom TPID");
+				return -EOPNOTSUPP;
+			}
+			filter->action.tag_a_tpid_sel = tpid;
+			filter->action.push_outer_tag = OCELOT_ES0_TAG;
+			filter->action.tag_a_vid_sel = 1;
+			filter->action.vid_a_val = a->vlan.vid;
+			filter->action.pcp_a_val = a->vlan.prio;
+			filter->type = OCELOT_VCAP_FILTER_OFFLOAD;
+			break;
 		default:
 			NL_SET_ERR_MSG_MOD(extack, "Cannot offload action");
 			return -EOPNOTSUPP;
@@ -302,17 +328,71 @@ static int ocelot_flower_parse_action(struct flow_cls_offload *f, bool ingress,
 	return 0;
 }
 
-static int ocelot_flower_parse(struct flow_cls_offload *f, bool ingress,
+static int ocelot_flower_parse_indev(struct ocelot *ocelot, int port,
+				     struct flow_cls_offload *f,
+				     struct ocelot_vcap_filter *filter)
+{
+	struct flow_rule *rule = flow_cls_offload_flow_rule(f);
+	const struct vcap_props *vcap = &ocelot->vcap[VCAP_ES0];
+	int key_length = vcap->keys[VCAP_ES0_IGR_PORT].length;
+	struct netlink_ext_ack *extack = f->common.extack;
+	struct net_device *dev, *indev;
+	struct flow_match_meta match;
+	int ingress_port;
+
+	flow_rule_match_meta(rule, &match);
+
+	if (!match.mask->ingress_ifindex)
+		return 0;
+
+	if (match.mask->ingress_ifindex != 0xFFFFFFFF) {
+		NL_SET_ERR_MSG_MOD(extack, "Unsupported ingress ifindex mask");
+		return -EOPNOTSUPP;
+	}
+
+	dev = ocelot->ops->port_to_netdev(ocelot, port);
+	if (!dev)
+		return -EINVAL;
+
+	indev = __dev_get_by_index(dev_net(dev), match.key->ingress_ifindex);
+	if (!indev) {
+		NL_SET_ERR_MSG_MOD(extack,
+				   "Can't find the ingress port to match on");
+		return -ENOENT;
+	}
+
+	ingress_port = ocelot->ops->netdev_to_port(indev);
+	if (ingress_port < 0) {
+		NL_SET_ERR_MSG_MOD(extack,
+				   "Can only offload an ocelot ingress port");
+		return -EOPNOTSUPP;
+	}
+	if (ingress_port == port) {
+		NL_SET_ERR_MSG_MOD(extack,
+				   "Ingress port is equal to the egress port");
+		return -EINVAL;
+	}
+
+	filter->ingress_port.value = port;
+	filter->ingress_port.mask = GENMASK(key_length - 1, 0);
+
+	return 0;
+}
+
+static int ocelot_flower_parse(struct ocelot *ocelot, int port, bool ingress,
+			       struct flow_cls_offload *f,
 			       struct ocelot_vcap_filter *filter)
 {
 	struct flow_rule *rule = flow_cls_offload_flow_rule(f);
 	struct flow_dissector *dissector = rule->match.dissector;
 	u16 proto = ntohs(f->common.protocol);
 	bool match_protocol = true;
+	int ret;
 
 	if (dissector->used_keys &
 	    ~(BIT(FLOW_DISSECTOR_KEY_CONTROL) |
 	      BIT(FLOW_DISSECTOR_KEY_BASIC) |
+	      BIT(FLOW_DISSECTOR_KEY_META) |
 	      BIT(FLOW_DISSECTOR_KEY_PORTS) |
 	      BIT(FLOW_DISSECTOR_KEY_VLAN) |
 	      BIT(FLOW_DISSECTOR_KEY_IPV4_ADDRS) |
@@ -321,6 +401,13 @@ static int ocelot_flower_parse(struct flow_cls_offload *f, bool ingress,
 		return -EOPNOTSUPP;
 	}
 
+	/* For VCAP ES0 (egress rewriter) we can match on the ingress port */
+	if (!ingress) {
+		ret = ocelot_flower_parse_indev(ocelot, port, f, filter);
+		if (ret)
+			return ret;
+	}
+
 	if (flow_rule_match_key(rule, FLOW_DISSECTOR_KEY_CONTROL)) {
 		struct flow_match_control match;
 
@@ -443,8 +530,8 @@ static int ocelot_flower_parse(struct flow_cls_offload *f, bool ingress,
 }
 
 static struct ocelot_vcap_filter
-*ocelot_vcap_filter_create(struct ocelot *ocelot, int port,
-			 struct flow_cls_offload *f)
+*ocelot_vcap_filter_create(struct ocelot *ocelot, int port, bool ingress,
+			   struct flow_cls_offload *f)
 {
 	struct ocelot_vcap_filter *filter;
 
@@ -452,7 +539,16 @@ static struct ocelot_vcap_filter
 	if (!filter)
 		return NULL;
 
-	filter->ingress_port_mask = BIT(port);
+	if (ingress) {
+		filter->ingress_port_mask = BIT(port);
+	} else {
+		const struct vcap_props *vcap = &ocelot->vcap[VCAP_ES0];
+		int key_length = vcap->keys[VCAP_ES0_EGR_PORT].length;
+
+		filter->egress_port.value = port;
+		filter->egress_port.mask = GENMASK(key_length - 1, 0);
+	}
+
 	return filter;
 }
 
@@ -486,11 +582,11 @@ int ocelot_cls_flower_replace(struct ocelot *ocelot, int port,
 		return -EOPNOTSUPP;
 	}
 
-	filter = ocelot_vcap_filter_create(ocelot, port, f);
+	filter = ocelot_vcap_filter_create(ocelot, port, ingress, f);
 	if (!filter)
 		return -ENOMEM;
 
-	ret = ocelot_flower_parse(f, ingress, filter);
+	ret = ocelot_flower_parse(ocelot, port, ingress, f, filter);
 	if (ret) {
 		kfree(filter);
 		return ret;
diff --git a/drivers/net/ethernet/mscc/ocelot_vcap.c b/drivers/net/ethernet/mscc/ocelot_vcap.c
index 3a011fe9e006..527b55199c0d 100644
--- a/drivers/net/ethernet/mscc/ocelot_vcap.c
+++ b/drivers/net/ethernet/mscc/ocelot_vcap.c
@@ -811,6 +811,75 @@ static void is1_entry_set(struct ocelot *ocelot, int ix,
 	vcap_row_cmd(ocelot, vcap, row, VCAP_CMD_WRITE, VCAP_SEL_ALL);
 }
 
+static void es0_action_set(struct ocelot *ocelot, struct vcap_data *data,
+			   const struct ocelot_vcap_filter *filter)
+{
+	const struct vcap_props *vcap = &ocelot->vcap[VCAP_ES0];
+	const struct ocelot_vcap_action *a = &filter->action;
+
+	vcap_action_set(vcap, data, VCAP_ES0_ACT_PUSH_OUTER_TAG,
+			a->push_outer_tag);
+	vcap_action_set(vcap, data, VCAP_ES0_ACT_PUSH_INNER_TAG,
+			a->push_inner_tag);
+	vcap_action_set(vcap, data, VCAP_ES0_ACT_TAG_A_VID_SEL,
+			a->tag_a_vid_sel);
+	vcap_action_set(vcap, data, VCAP_ES0_ACT_TAG_A_PCP_SEL,
+			a->tag_a_pcp_sel);
+	vcap_action_set(vcap, data, VCAP_ES0_ACT_VID_A_VAL, a->vid_a_val);
+	vcap_action_set(vcap, data, VCAP_ES0_ACT_PCP_A_VAL, a->pcp_a_val);
+	vcap_action_set(vcap, data, VCAP_ES0_ACT_TAG_B_VID_SEL,
+			a->tag_b_vid_sel);
+	vcap_action_set(vcap, data, VCAP_ES0_ACT_TAG_B_PCP_SEL,
+			a->tag_b_pcp_sel);
+	vcap_action_set(vcap, data, VCAP_ES0_ACT_VID_B_VAL, a->vid_b_val);
+	vcap_action_set(vcap, data, VCAP_ES0_ACT_PCP_B_VAL, a->pcp_b_val);
+}
+
+static void es0_entry_set(struct ocelot *ocelot, int ix,
+			  struct ocelot_vcap_filter *filter)
+{
+	const struct vcap_props *vcap = &ocelot->vcap[VCAP_ES0];
+	struct ocelot_vcap_key_vlan *tag = &filter->vlan;
+	struct ocelot_vcap_u64 payload;
+	struct vcap_data data;
+	int row = ix;
+
+	memset(&payload, 0, sizeof(payload));
+	memset(&data, 0, sizeof(data));
+
+	/* Read row */
+	vcap_row_cmd(ocelot, vcap, row, VCAP_CMD_READ, VCAP_SEL_ALL);
+	vcap_cache2entry(ocelot, vcap, &data);
+	vcap_cache2action(ocelot, vcap, &data);
+
+	data.tg_sw = VCAP_TG_FULL;
+	data.type = ES0_ACTION_TYPE_NORMAL;
+	vcap_data_offset_get(vcap, &data, ix);
+	data.tg = (data.tg & ~data.tg_mask);
+	if (filter->prio != 0)
+		data.tg |= data.tg_value;
+
+	vcap_key_set(vcap, &data, VCAP_ES0_IGR_PORT, filter->ingress_port.value,
+		     filter->ingress_port.mask);
+	vcap_key_set(vcap, &data, VCAP_ES0_EGR_PORT, filter->egress_port.value,
+		     filter->egress_port.mask);
+	vcap_key_bit_set(vcap, &data, VCAP_ES0_L2_MC, filter->dmac_mc);
+	vcap_key_bit_set(vcap, &data, VCAP_ES0_L2_BC, filter->dmac_bc);
+	vcap_key_set(vcap, &data, VCAP_ES0_VID,
+		     tag->vid.value, tag->vid.mask);
+	vcap_key_set(vcap, &data, VCAP_ES0_PCP,
+		     tag->pcp.value[0], tag->pcp.mask[0]);
+
+	es0_action_set(ocelot, &data, filter);
+	vcap_data_set(data.counter, data.counter_offset,
+		      vcap->counter_width, filter->stats.pkts);
+
+	/* Write row */
+	vcap_entry2cache(ocelot, vcap, &data);
+	vcap_action2cache(ocelot, vcap, &data);
+	vcap_row_cmd(ocelot, vcap, row, VCAP_CMD_WRITE, VCAP_SEL_ALL);
+}
+
 static void vcap_entry_get(struct ocelot *ocelot, int ix,
 			   struct ocelot_vcap_filter *filter)
 {
@@ -819,7 +888,11 @@ static void vcap_entry_get(struct ocelot *ocelot, int ix,
 	int row, count;
 	u32 cnt;
 
-	data.tg_sw = VCAP_TG_HALF;
+	if (filter->block_id == VCAP_ES0)
+		data.tg_sw = VCAP_TG_FULL;
+	else
+		data.tg_sw = VCAP_TG_HALF;
+
 	count = (1 << (data.tg_sw - 1));
 	row = (ix / count);
 	vcap_row_cmd(ocelot, vcap, row, VCAP_CMD_READ, VCAP_SEL_COUNTER);
@@ -838,6 +911,8 @@ static void vcap_entry_set(struct ocelot *ocelot, int ix,
 		return is1_entry_set(ocelot, ix, filter);
 	if (filter->block_id == VCAP_IS2)
 		return is2_entry_set(ocelot, ix, filter);
+	if (filter->block_id == VCAP_ES0)
+		return es0_entry_set(ocelot, ix, filter);
 }
 
 static int ocelot_vcap_policer_add(struct ocelot *ocelot, u32 pol_ix,
@@ -1193,9 +1268,6 @@ int ocelot_vcap_init(struct ocelot *ocelot)
 {
 	int i;
 
-	ocelot_vcap_init_one(ocelot, &ocelot->vcap[VCAP_IS1]);
-	ocelot_vcap_init_one(ocelot, &ocelot->vcap[VCAP_IS2]);
-
 	/* Create a policer that will drop the frames for the cpu.
 	 * This policer will be used as action in the acl rules to drop
 	 * frames.
@@ -1216,6 +1288,8 @@ int ocelot_vcap_init(struct ocelot *ocelot)
 
 		INIT_LIST_HEAD(&block->rules);
 		block->pol_lpr = OCELOT_POLICER_DISCARD - 1;
+
+		ocelot_vcap_init_one(ocelot, &ocelot->vcap[i]);
 	}
 
 	INIT_LIST_HEAD(&ocelot->dummy_rules);
diff --git a/drivers/net/ethernet/mscc/ocelot_vcap.h b/drivers/net/ethernet/mscc/ocelot_vcap.h
index 665b4c3aa200..73df734fc76c 100644
--- a/drivers/net/ethernet/mscc/ocelot_vcap.h
+++ b/drivers/net/ethernet/mscc/ocelot_vcap.h
@@ -78,6 +78,11 @@ struct ocelot_vcap_udp_tcp {
 	u16 mask;
 };
 
+struct ocelot_vcap_port {
+	u8 value;
+	u8 mask;
+};
+
 enum ocelot_vcap_key_type {
 	OCELOT_VCAP_KEY_ANY,
 	OCELOT_VCAP_KEY_ETYPE,
@@ -184,8 +189,38 @@ enum ocelot_mask_mode {
 	OCELOT_MASK_MODE_REDIRECT,
 };
 
+enum ocelot_es0_tag {
+	OCELOT_NO_ES0_TAG,
+	OCELOT_ES0_TAG,
+	OCELOT_FORCE_PORT_TAG,
+	OCELOT_FORCE_UNTAG,
+};
+
+enum ocelot_tag_tpid_sel {
+	OCELOT_TAG_TPID_SEL_8021Q,
+	OCELOT_TAG_TPID_SEL_8021AD,
+};
+
 struct ocelot_vcap_action {
 	union {
+		/* VCAP ES0 */
+		struct {
+			enum ocelot_es0_tag push_outer_tag;
+			enum ocelot_es0_tag push_inner_tag;
+			enum ocelot_tag_tpid_sel tag_a_tpid_sel;
+			int tag_a_vid_sel;
+			int tag_a_pcp_sel;
+			u16 vid_a_val;
+			u8 pcp_a_val;
+			u8 dei_a_val;
+			enum ocelot_tag_tpid_sel tag_b_tpid_sel;
+			int tag_b_vid_sel;
+			int tag_b_pcp_sel;
+			u16 vid_b_val;
+			u8 pcp_b_val;
+			u8 dei_b_val;
+		};
+
 		/* VCAP IS1 */
 		struct {
 			bool vid_replace_ena;
@@ -239,7 +274,11 @@ struct ocelot_vcap_filter {
 
 	struct ocelot_vcap_action action;
 	struct ocelot_vcap_stats stats;
+	/* For VCAP IS1 and IS2 */
 	unsigned long ingress_port_mask;
+	/* For VCAP ES0 */
+	struct ocelot_vcap_port ingress_port;
+	struct ocelot_vcap_port egress_port;
 
 	enum ocelot_vcap_bit dmac_mc;
 	enum ocelot_vcap_bit dmac_bc;
diff --git a/include/soc/mscc/ocelot.h b/include/soc/mscc/ocelot.h
index 1dcc98f22541..12b6e1835b4d 100644
--- a/include/soc/mscc/ocelot.h
+++ b/include/soc/mscc/ocelot.h
@@ -123,6 +123,7 @@ enum ocelot_target {
 	QSYS,
 	REW,
 	SYS,
+	S0,
 	S1,
 	S2,
 	HSIO,
diff --git a/include/soc/mscc/ocelot_vcap.h b/include/soc/mscc/ocelot_vcap.h
index 68a16c20a46a..40556c8a1922 100644
--- a/include/soc/mscc/ocelot_vcap.h
+++ b/include/soc/mscc/ocelot_vcap.h
@@ -356,4 +356,46 @@ enum vcap_is1_action_field {
 	VCAP_IS1_ACT_HIT_STICKY,
 };
 
+/* =================================================================
+ *  VCAP ES0
+ * =================================================================
+ */
+
+enum {
+	ES0_ACTION_TYPE_NORMAL,
+	ES0_ACTION_TYPE_MAX,
+};
+
+enum vcap_es0_key_field {
+	VCAP_ES0_EGR_PORT,
+	VCAP_ES0_IGR_PORT,
+	VCAP_ES0_RSV,
+	VCAP_ES0_L2_MC,
+	VCAP_ES0_L2_BC,
+	VCAP_ES0_VID,
+	VCAP_ES0_DP,
+	VCAP_ES0_PCP,
+};
+
+enum vcap_es0_action_field {
+	VCAP_ES0_ACT_PUSH_OUTER_TAG,
+	VCAP_ES0_ACT_PUSH_INNER_TAG,
+	VCAP_ES0_ACT_TAG_A_TPID_SEL,
+	VCAP_ES0_ACT_TAG_A_VID_SEL,
+	VCAP_ES0_ACT_TAG_A_PCP_SEL,
+	VCAP_ES0_ACT_TAG_A_DEI_SEL,
+	VCAP_ES0_ACT_TAG_B_TPID_SEL,
+	VCAP_ES0_ACT_TAG_B_VID_SEL,
+	VCAP_ES0_ACT_TAG_B_PCP_SEL,
+	VCAP_ES0_ACT_TAG_B_DEI_SEL,
+	VCAP_ES0_ACT_VID_A_VAL,
+	VCAP_ES0_ACT_PCP_A_VAL,
+	VCAP_ES0_ACT_DEI_A_VAL,
+	VCAP_ES0_ACT_VID_B_VAL,
+	VCAP_ES0_ACT_PCP_B_VAL,
+	VCAP_ES0_ACT_DEI_B_VAL,
+	VCAP_ES0_ACT_RSV,
+	VCAP_ES0_ACT_HIT_STICKY,
+};
+
 #endif /* _OCELOT_VCAP_H_ */
-- 
2.25.1

