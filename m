Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id C72B841F0FE
	for <lists+netdev@lfdr.de>; Fri,  1 Oct 2021 17:15:48 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1354983AbhJAPRb (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 1 Oct 2021 11:17:31 -0400
Received: from mail-db8eur05on2044.outbound.protection.outlook.com ([40.107.20.44]:29755
        "EHLO EUR05-DB8-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1354697AbhJAPRa (ORCPT <rfc822;netdev@vger.kernel.org>);
        Fri, 1 Oct 2021 11:17:30 -0400
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=QQdbZangbJRq4fdBuyCippeqUoJdT5CqAikkCb3ux7MG/26AJ/P0P/YiWCJ3c7UaQCNbh9O2KdcDCs1bbq/5DqKJa5zQPyKHuL3zkBOYtjfMVvS8ZmpSiGgJmRsKiU+t61L8v6dc92AlzO0/D0+hdYhvcfCtCTftWtyR6tR0v6Tt4kpFEJu8dJ+5ror0V0ueuoGzEPP6JMkRwGKUGUABLXP7laxs906mF9ZKGzO1wqQA1/f6z6WlN7wzoiTtiQZiFwgDYlD57hScv27Pka7dn5y0N54QPq3OkYHwCJwirH20eNp+issoaymGIOZfJDrnvIBHg5FGbwVKLkjrQ3aa0w==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=SXH4hmhqUCP/oEKZBlt0e8qD0qRE53V5U3RTB8H0Tz0=;
 b=VAAvjiko/HHYCuArEaDyx2vdbNjvSF9KE/jobU7QKI7xwlWD+SORRkiiQMoEwgV1AWfldP0U3sw1oG8PSW6fnFJKOZry0NDDfnCqQ6Jn7yPva/37/dmc9N3E+IXz7FA6IO7RqIIVBqwLxG8jwWxvwL+N/tZLwfGVvBlKCx1AgcT87c0p9I7WtFwesLpO8sV2Qmle4U8tO5F+sPwdxLLPPI73KjhkJtmyi6NsNBJiBugWEhffom3PS1bwukKZYGhNzLJjwAMIDBtt6WT7onk5cWjU4wBsBDHiHCXF+23xQWZvezsodxTfHO+F1+4iQNJts7QtEG+p8V9nXpZtfkiK7Q==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=nxp.com; dmarc=pass action=none header.from=nxp.com; dkim=pass
 header.d=nxp.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=nxp.com; s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=SXH4hmhqUCP/oEKZBlt0e8qD0qRE53V5U3RTB8H0Tz0=;
 b=PRSRlOhUth2YYOGn7hkFAeYItdBCtMOcrKLQ1eI8QTTtCSp376oTDa74buWHEXJ6LH/7As5fXTTizdvsZraSGipkAE+FQDkzcKWGCAykEd91DBwFva00CHFMLfTONu4yDzo21eLu1ffD2zPQN4nJMdZwKsmY6sdUYgaDjqcJwhc=
Authentication-Results: vger.kernel.org; dkim=none (message not signed)
 header.d=none;vger.kernel.org; dmarc=none action=none header.from=nxp.com;
Received: from VI1PR04MB5136.eurprd04.prod.outlook.com (2603:10a6:803:55::19)
 by VI1PR04MB4224.eurprd04.prod.outlook.com (2603:10a6:803:49::28) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4566.19; Fri, 1 Oct
 2021 15:15:43 +0000
Received: from VI1PR04MB5136.eurprd04.prod.outlook.com
 ([fe80::e157:3280:7bc3:18c4]) by VI1PR04MB5136.eurprd04.prod.outlook.com
 ([fe80::e157:3280:7bc3:18c4%5]) with mapi id 15.20.4544.025; Fri, 1 Oct 2021
 15:15:43 +0000
From:   Vladimir Oltean <vladimir.oltean@nxp.com>
To:     netdev@vger.kernel.org, Jakub Kicinski <kuba@kernel.org>,
        "David S. Miller" <davem@davemloft.net>
Cc:     Alexandre Belloni <alexandre.belloni@bootlin.com>,
        Florian Fainelli <f.fainelli@gmail.com>,
        Andrew Lunn <andrew@lunn.ch>,
        Vivien Didelot <vivien.didelot@gmail.com>,
        Claudiu Manoil <claudiu.manoil@nxp.com>,
        UNGLinuxDriver@microchip.com,
        Xiaoliang Yang <xiaoliang.yang_1@nxp.com>,
        Po Liu <po.liu@nxp.com>
Subject: [PATCH net-next 1/6] net: mscc: ocelot: support egress VLAN rewriting via VCAP ES0
Date:   Fri,  1 Oct 2021 18:15:26 +0300
Message-Id: <20211001151531.2840873-2-vladimir.oltean@nxp.com>
X-Mailer: git-send-email 2.25.1
In-Reply-To: <20211001151531.2840873-1-vladimir.oltean@nxp.com>
References: <20211001151531.2840873-1-vladimir.oltean@nxp.com>
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-ClientProxiedBy: AM0PR08CA0001.eurprd08.prod.outlook.com
 (2603:10a6:208:d2::14) To VI1PR04MB5136.eurprd04.prod.outlook.com
 (2603:10a6:803:55::19)
MIME-Version: 1.0
Received: from localhost.localdomain (188.26.53.217) by AM0PR08CA0001.eurprd08.prod.outlook.com (2603:10a6:208:d2::14) with Microsoft SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4566.14 via Frontend Transport; Fri, 1 Oct 2021 15:15:42 +0000
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: 105f38ea-6ba3-455a-fa5e-08d984ee5641
X-MS-TrafficTypeDiagnostic: VI1PR04MB4224:
X-MS-Exchange-Transport-Forked: True
X-Microsoft-Antispam-PRVS: <VI1PR04MB4224360DAEE7B2F889A50F70E0AB9@VI1PR04MB4224.eurprd04.prod.outlook.com>
X-MS-Oob-TLC-OOBClassifiers: OLM:10000;
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: NAEzHJwdkAueep5NW0ArGfesx7Ci7p76WpDKSRX/9Rn+0V8RXS2rKOJl1nBN5NmxKp6zwDJfmiooCqZ4Zvv1doXTSR8uq6l2Mkx59K5LetsT1zkiT8mTcogSBclcHG/a/g+cKkPsCKG1c02IMzc7egkI+w/9T+ksy55CR60E6XkmQIAwNA1kwaBuobbBhmGW76/UR3Dd8GF2XNMiiftkHqxZmDM144JljmOwBNCDSHV1eBHw9p/ye49VZa4K9b5vTej6UUmzDl2GDcf5qo6tL/f5IzWsA2gn0jdfpqmxveobfnPDdmYp4351jm9f92Ld3DkRmctWRDtB8pCc32Hs87MRAtHwe6sDE79cULlIjdb3zgP5n4rsucqS4eO4NEEKPBhLGPygrCnu1jTBqcWgVGu0RVvwliUJK1rLpBe5ebfvSCOkBN3U5b3gE46SO4vlCsR4KGzpYkJM2r8o+NDuoGHyarCJM+p+Lp4a9oqgn37jA4jYOr0PwkYTtfi7b9lDxS8Gem547j4vAhrXrDGE57dzWiCC5QAmpXgk+xSNEpikmlk8gC4vErZ6rj06aQt6JFsD7JT3ApVx/0MAjo7K9NoEhzkwNKclm3GZKhZX5B5P1Gk+SGq32sQN0dORJliqcJtzXZ2mynPj2xz+lRu2OGBhPacMvoLN/c3YZTNYB+FMW5fcGJLObvr2ZznGVZntZ37O6aV8bW3wm7TXOjQ1fg==
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:VI1PR04MB5136.eurprd04.prod.outlook.com;PTR:;CAT:NONE;SFS:(4636009)(366004)(316002)(6666004)(1076003)(5660300002)(6512007)(26005)(38350700002)(38100700002)(956004)(110136005)(8676002)(2616005)(36756003)(54906003)(52116002)(6506007)(8936002)(66946007)(508600001)(4326008)(83380400001)(186003)(2906002)(6486002)(66556008)(86362001)(44832011)(66476007);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?us-ascii?Q?FY5OE5LxepX23Q9s0rAMEvSUnm9sQVUfL0HVCaIQAkepusFf1GqGM9n/+FwJ?=
 =?us-ascii?Q?sZbYzYdv0eVdu66cZRD28EK4uHxjCeHE8O621yUbkuk6OnONHEzWzduVoyzS?=
 =?us-ascii?Q?oZueYOohfA9TI4pKFqSFyjSkNUL6zgq9OC7k0FLvOFXZrl4sQ/5obtU+nmhn?=
 =?us-ascii?Q?jU11Ec+zdqBKRfWxcDn0QLYZ+bjkiX15EgWwlB3kbWW5fA8Onrl7CfilPUcB?=
 =?us-ascii?Q?2uftry9ezHJGzVRDIrBwEZfcuan2hpEi2Jl+DmjS+xehJHbAk+qB67Fps5fj?=
 =?us-ascii?Q?Dd2tkVHo0Sylf8Pbwme0aS5cX1AscEMAKO86FGnJZfl7MpTH/bTEvpEbITcS?=
 =?us-ascii?Q?cKcwifB8aOtSiZ2/6xGXk0/fqvENF7lK6JR8mm80m3jdI4uTmJge5heaSWMN?=
 =?us-ascii?Q?9mrwyaANhh5N4uyAyYxMPEwEbEy3aduQU3OgzNWzUcfQtrCItXX/Xn3gK3h1?=
 =?us-ascii?Q?kXu4zScwTmDjyU3qm0wHqKPGDfdgpmlWfLNp49UZr9nDK2jn3fC+mqvY5w2/?=
 =?us-ascii?Q?xf3kQj1uEo+tV+eFH/bVNTpl3ZcltepzhiM/nm+S+4jvrAPaZvOkBMCBjqG8?=
 =?us-ascii?Q?jY7tvK0O5k2LQI3b+Jz+0/ufAFpRjIHBCRNZXfDf3bJaIJq650j5Zd9Ft/Pg?=
 =?us-ascii?Q?mcK27jbbeAZM++Ip+xr7PqoQNlUwBDO1GatkqpkvSdUiF8gPfnN6dBFT452P?=
 =?us-ascii?Q?qycVBgmGSCJeXKe0q/PsIiEK5twTeLJKwP2mbdurZevS2yKPxgbbsA79rkjQ?=
 =?us-ascii?Q?WlXol+3zNriza42fjQBGY7PWH7KC80+Fzg6fTQ0oorxhBMcduegDwVWAqeyi?=
 =?us-ascii?Q?vI/kP1FZ3uhFYhZ4rKJ9k+jaXfUVPOJlCkZ79hqcgcGfB4gBOMxsBm0Q57mT?=
 =?us-ascii?Q?YaThmw5OKwX0noJTcRZXo0K4Es30j0DwcO4x93kufqwn1b2HQuAf/l475V2d?=
 =?us-ascii?Q?IVnYajyQJZkVIz9p93HO+emZ6KXF1KO0eo+s0azW1NxI8IMMHvyahibbNMaP?=
 =?us-ascii?Q?k3BrU0Omxss2aJuaUtTVJUA+Jw4vOAozPHjp8jWPSWAss3HlYwW7W/LsysEZ?=
 =?us-ascii?Q?M0u6FuskPlN+hzpaXigeIeqQjqQJlKzr8kHop7kI5FaI10SquLPcgec1spXK?=
 =?us-ascii?Q?br/Vh4hH6yPNYRM06zewlcQNmB5AjT9MTcGE/JpHhJagIv8eih6LMqau1nWo?=
 =?us-ascii?Q?HLOEnkmvL0Cf9N72rVeGzKM7cX9mIRQuk3yDxYNMqLkucFwMtgGgznV7O2Bo?=
 =?us-ascii?Q?cNCIuDn/sRmw9ukttKBf5eK4vPLDcmJDMfkarSn975ftYSzcXCofqawd6wVM?=
 =?us-ascii?Q?3GeFu13RlnEEtOV0y3EX9ZA0?=
X-OriginatorOrg: nxp.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 105f38ea-6ba3-455a-fa5e-08d984ee5641
X-MS-Exchange-CrossTenant-AuthSource: VI1PR04MB5136.eurprd04.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 01 Oct 2021 15:15:43.5702
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 686ea1d3-bc2b-4c6f-a92c-d99c5c301635
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: vj1jlT/zZateQREZoah+A3mStrIZDuGngMjuwHv+dIrH+E79MEOmsxa14cZMlI8oOHClBPHdH/Of9IeAvhpfvQ==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: VI1PR04MB4224
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Currently the ocelot driver does support the 'vlan modify' action, but
in the ingress chain, and it is offloaded to VCAP IS1. This action
changes the classified VLAN before the packet enters the bridging
service, and the bridging works with the classified VLAN modified by
VCAP IS1.

That is good for some use cases, but there are others where the VLAN
must be modified at the stage of the egress port, after the packet has
exited the bridging service. One example is simulating IEEE 802.1CB
active stream identification filters ("active" means that not only the
rule matches on a packet flow, but it is also able to change some
headers). For example, a stream is replicated on two egress ports, but
they must have different VLAN IDs on egress ports A and B.

This seems like a task for the VCAP ES0, but that currently only
supports pushing the ES0 tag A, which is specified in the rule. Pushing
another VLAN header is not what we want, but rather overwriting the
existing one.

It looks like when we push the ES0 tag A, it is actually possible to not
only take the ES0 tag A's value from the rule itself (VID_A_VAL), but
derive it from the following formula:

ES0_TAG_A = Classified VID + VID_A_VAL

Otherwise said, ES0_TAG_A can be used to increment with a given value
the VLAN ID that the packet was already classified to, and the packet
will have this value as an outer VLAN tag. This new VLAN ID value then
gets stripped on egress (or not) according to the value of the native
VLAN from the bridging service.

While the hardware will happily increment the classified VLAN ID for all
packets that match the ES0 rule, in practice this would be rather
insane, so we only allow this kind of ES0 action if the ES0 filter
contains a VLAN ID too, so as to restrict the matching on a known
classified VLAN. If we program VID_A_VAL with the delta between the
desired final VLAN (ES0_TAG_A) and the classified VLAN, we obtain the
desired behavior.

It doesn't look like it is possible with the tc-vlan action to modify
the VLAN ID but not the PCP. In hardware it is possible to leave the PCP
to the classified value, but we unconditionally program it to overwrite
it with the PCP value from the rule.

Signed-off-by: Vladimir Oltean <vladimir.oltean@nxp.com>
---
 drivers/net/ethernet/mscc/ocelot_flower.c | 125 ++++++++++++++++++----
 include/soc/mscc/ocelot_vcap.h            |  10 ++
 2 files changed, 115 insertions(+), 20 deletions(-)

diff --git a/drivers/net/ethernet/mscc/ocelot_flower.c b/drivers/net/ethernet/mscc/ocelot_flower.c
index 8b843d3c9189..769a8159373e 100644
--- a/drivers/net/ethernet/mscc/ocelot_flower.c
+++ b/drivers/net/ethernet/mscc/ocelot_flower.c
@@ -142,17 +142,77 @@ ocelot_find_vcap_filter_that_points_at(struct ocelot *ocelot, int chain)
 	return NULL;
 }
 
+static int
+ocelot_flower_parse_ingress_vlan_modify(struct ocelot *ocelot, int port,
+					struct ocelot_vcap_filter *filter,
+					const struct flow_action_entry *a,
+					struct netlink_ext_ack *extack)
+{
+	struct ocelot_port *ocelot_port = ocelot->ports[port];
+
+	if (filter->goto_target != -1) {
+		NL_SET_ERR_MSG_MOD(extack,
+				   "Last action must be GOTO");
+		return -EOPNOTSUPP;
+	}
+
+	if (!ocelot_port->vlan_aware) {
+		NL_SET_ERR_MSG_MOD(extack,
+				   "Can only modify VLAN under VLAN aware bridge");
+		return -EOPNOTSUPP;
+	}
+
+	filter->action.vid_replace_ena = true;
+	filter->action.pcp_dei_ena = true;
+	filter->action.vid = a->vlan.vid;
+	filter->action.pcp = a->vlan.prio;
+	filter->type = OCELOT_VCAP_FILTER_OFFLOAD;
+
+	return 0;
+}
+
+static int
+ocelot_flower_parse_egress_vlan_modify(struct ocelot_vcap_filter *filter,
+				       const struct flow_action_entry *a,
+				       struct netlink_ext_ack *extack)
+{
+	enum ocelot_tag_tpid_sel tpid;
+
+	switch (ntohs(a->vlan.proto)) {
+	case ETH_P_8021Q:
+		tpid = OCELOT_TAG_TPID_SEL_8021Q;
+		break;
+	case ETH_P_8021AD:
+		tpid = OCELOT_TAG_TPID_SEL_8021AD;
+		break;
+	default:
+		NL_SET_ERR_MSG_MOD(extack,
+				   "Cannot modify custom TPID");
+		return -EOPNOTSUPP;
+	}
+
+	filter->action.tag_a_tpid_sel = tpid;
+	filter->action.push_outer_tag = OCELOT_ES0_TAG;
+	filter->action.tag_a_vid_sel = OCELOT_ES0_VID_PLUS_CLASSIFIED_VID;
+	filter->action.vid_a_val = a->vlan.vid;
+	filter->action.pcp_a_val = a->vlan.prio;
+	filter->action.tag_a_pcp_sel = OCELOT_ES0_PCP;
+	filter->type = OCELOT_VCAP_FILTER_OFFLOAD;
+
+	return 0;
+}
+
 static int ocelot_flower_parse_action(struct ocelot *ocelot, int port,
 				      bool ingress, struct flow_cls_offload *f,
 				      struct ocelot_vcap_filter *filter)
 {
-	struct ocelot_port *ocelot_port = ocelot->ports[port];
 	struct netlink_ext_ack *extack = f->common.extack;
 	bool allow_missing_goto_target = false;
 	const struct flow_action_entry *a;
 	enum ocelot_tag_tpid_sel tpid;
 	int i, chain, egress_port;
 	u64 rate;
+	int err;
 
 	if (!flow_action_basic_hw_stats_check(&f->rule->action,
 					      f->common.extack))
@@ -273,26 +333,20 @@ static int ocelot_flower_parse_action(struct ocelot *ocelot, int port,
 			filter->type = OCELOT_VCAP_FILTER_OFFLOAD;
 			break;
 		case FLOW_ACTION_VLAN_MANGLE:
-			if (filter->block_id != VCAP_IS1) {
-				NL_SET_ERR_MSG_MOD(extack,
-						   "VLAN modify action can only be offloaded to VCAP IS1");
-				return -EOPNOTSUPP;
-			}
-			if (filter->goto_target != -1) {
+			if (filter->block_id == VCAP_IS1) {
+				err = ocelot_flower_parse_ingress_vlan_modify(ocelot, port,
+									      filter, a,
+									      extack);
+			} else if (filter->block_id == VCAP_ES0) {
+				err = ocelot_flower_parse_egress_vlan_modify(filter, a,
+									     extack);
+			} else {
 				NL_SET_ERR_MSG_MOD(extack,
-						   "Last action must be GOTO");
-				return -EOPNOTSUPP;
+						   "VLAN modify action can only be offloaded to VCAP IS1 or ES0");
+				err = -EOPNOTSUPP;
 			}
-			if (!ocelot_port->vlan_aware) {
-				NL_SET_ERR_MSG_MOD(extack,
-						   "Can only modify VLAN under VLAN aware bridge");
-				return -EOPNOTSUPP;
-			}
-			filter->action.vid_replace_ena = true;
-			filter->action.pcp_dei_ena = true;
-			filter->action.vid = a->vlan.vid;
-			filter->action.pcp = a->vlan.prio;
-			filter->type = OCELOT_VCAP_FILTER_OFFLOAD;
+			if (err)
+				return err;
 			break;
 		case FLOW_ACTION_PRIORITY:
 			if (filter->block_id != VCAP_IS1) {
@@ -340,7 +394,7 @@ static int ocelot_flower_parse_action(struct ocelot *ocelot, int port,
 			}
 			filter->action.tag_a_tpid_sel = tpid;
 			filter->action.push_outer_tag = OCELOT_ES0_TAG;
-			filter->action.tag_a_vid_sel = 1;
+			filter->action.tag_a_vid_sel = OCELOT_ES0_VID;
 			filter->action.vid_a_val = a->vlan.vid;
 			filter->action.pcp_a_val = a->vlan.prio;
 			filter->type = OCELOT_VCAP_FILTER_OFFLOAD;
@@ -678,6 +732,31 @@ static int ocelot_vcap_dummy_filter_del(struct ocelot *ocelot,
 	return 0;
 }
 
+/* If we have an egress VLAN modification rule, we need to actually write the
+ * delta between the input VLAN (from the key) and the output VLAN (from the
+ * action), but the action was parsed first. So we need to patch the delta into
+ * the action here.
+ */
+static int
+ocelot_flower_patch_es0_vlan_modify(struct ocelot_vcap_filter *filter,
+				    struct netlink_ext_ack *extack)
+{
+	if (filter->block_id != VCAP_ES0 ||
+	    filter->action.tag_a_vid_sel != OCELOT_ES0_VID_PLUS_CLASSIFIED_VID)
+		return 0;
+
+	if (filter->vlan.vid.mask != VLAN_VID_MASK) {
+		NL_SET_ERR_MSG_MOD(extack,
+				   "VCAP ES0 VLAN rewriting needs a full VLAN in the key");
+		return -EOPNOTSUPP;
+	}
+
+	filter->action.vid_a_val -= filter->vlan.vid.value;
+	filter->action.vid_a_val &= VLAN_VID_MASK;
+
+	return 0;
+}
+
 int ocelot_cls_flower_replace(struct ocelot *ocelot, int port,
 			      struct flow_cls_offload *f, bool ingress)
 {
@@ -701,6 +780,12 @@ int ocelot_cls_flower_replace(struct ocelot *ocelot, int port,
 		return ret;
 	}
 
+	ret = ocelot_flower_patch_es0_vlan_modify(filter, extack);
+	if (ret) {
+		kfree(filter);
+		return ret;
+	}
+
 	/* The non-optional GOTOs for the TCAM skeleton don't need
 	 * to be actually offloaded.
 	 */
diff --git a/include/soc/mscc/ocelot_vcap.h b/include/soc/mscc/ocelot_vcap.h
index 4869ebbd438d..eeb1142aa1b1 100644
--- a/include/soc/mscc/ocelot_vcap.h
+++ b/include/soc/mscc/ocelot_vcap.h
@@ -576,6 +576,16 @@ enum ocelot_mask_mode {
 	OCELOT_MASK_MODE_REDIRECT,
 };
 
+enum ocelot_es0_vid_sel {
+	OCELOT_ES0_VID_PLUS_CLASSIFIED_VID = 0,
+	OCELOT_ES0_VID = 1,
+};
+
+enum ocelot_es0_pcp_sel {
+	OCELOT_CLASSIFIED_PCP = 0,
+	OCELOT_ES0_PCP = 1,
+};
+
 enum ocelot_es0_tag {
 	OCELOT_NO_ES0_TAG,
 	OCELOT_ES0_TAG,
-- 
2.25.1

