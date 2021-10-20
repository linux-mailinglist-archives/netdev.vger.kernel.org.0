Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 3716843497F
	for <lists+netdev@lfdr.de>; Wed, 20 Oct 2021 12:56:38 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230174AbhJTK6q (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 20 Oct 2021 06:58:46 -0400
Received: from mail-eopbgr130077.outbound.protection.outlook.com ([40.107.13.77]:17730
        "EHLO EUR01-HE1-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S230145AbhJTK6m (ORCPT <rfc822;netdev@vger.kernel.org>);
        Wed, 20 Oct 2021 06:58:42 -0400
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=iV7kjafEr7ODwX8qRHVc0uKm4b/dEjsgkZRlKKfMjqeDTSeSAHOQXeFxm6jecjWqOf6OGNd1fLJPhY/08xMD5vzh58wYrnUTyU1ylGDW/QDCKmwLXmhUdeX24pvH/cuF0INHSeuhbYXX2sm6i2HoAQuQJOvc51icYBYbJBRJSRY5GLEipVqYR8tVr1hxymUJlB2wZYEjRdwL/7+usRNdPU+Eww1vyLw1NVUcdj5tptfKF2IsjxpBxITDtOzScJRi82/07xSdYP483XZFq72T17X5lhIVQbVybK9b59xf8LBNfVEY0m3RYmU4tGbInXZqa8rrqFlvDYDJIK9/p3jDjA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=hHwjVHn42yPbtA5nFJkXeUPdzdxAfOxUC+6jxFM7JQI=;
 b=fqTyQJGBm0Xd7eoqo1gSArvW4mdimXAw2PbE13Czkgm2MpKRUfE7H8WQY2QDVvrbKmkhbnAWwZCTK4x0LYKv4dcUUC/JZ60dYrJoiqEYFXz7WgLv1yVNwX6ANq6t4su+kA83CNH1i9qcOfX2Fj9WWWw+X1ZjQMLwCUpoRSWWw3waooyW2ff0KXSa+1k1fofjQP8Llm0XLF7VFstaLPZ8aprX5LPGvusYLdArrjhiQmuwyJ00Zx1IQuAIvfA2eg02U9c5yoWrn1N/GYpiDpVOH/UbTYCd9V8rfoRLenvIo6JSh321BpZGsSo9IKPgVlJ/JXGTOW76/GZg+dSES0rOcw==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=nxp.com; dmarc=pass action=none header.from=nxp.com; dkim=pass
 header.d=nxp.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=nxp.com; s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=hHwjVHn42yPbtA5nFJkXeUPdzdxAfOxUC+6jxFM7JQI=;
 b=TL9KqOKz+N8GvTKiUYTFulckuctydWYcAk79vRM2Tz0vykD8uNx3WoklLjfoNISooVU2o0u4I55zprLrOjYgdk70o7tFmJnRTxkgRovDKrDx/GCBJTjS2/UTKjZVIpoBtCy3VeChMARkucOSBRewfDpdXFuelKjN3yA778V/6dA=
Authentication-Results: vger.kernel.org; dkim=none (message not signed)
 header.d=none;vger.kernel.org; dmarc=none action=none header.from=nxp.com;
Received: from VI1PR04MB5136.eurprd04.prod.outlook.com (2603:10a6:803:55::19)
 by VE1PR04MB6702.eurprd04.prod.outlook.com (2603:10a6:803:123::13) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4608.18; Wed, 20 Oct
 2021 10:56:26 +0000
Received: from VI1PR04MB5136.eurprd04.prod.outlook.com
 ([fe80::e157:3280:7bc3:18c4]) by VI1PR04MB5136.eurprd04.prod.outlook.com
 ([fe80::e157:3280:7bc3:18c4%5]) with mapi id 15.20.4608.018; Wed, 20 Oct 2021
 10:56:26 +0000
From:   Vladimir Oltean <vladimir.oltean@nxp.com>
To:     netdev@vger.kernel.org, Jakub Kicinski <kuba@kernel.org>,
        "David S. Miller" <davem@davemloft.net>, Po Liu <po.liu@nxp.com>
Cc:     Florian Fainelli <f.fainelli@gmail.com>,
        Andrew Lunn <andrew@lunn.ch>,
        Vivien Didelot <vivien.didelot@gmail.com>,
        Vladimir Oltean <olteanv@gmail.com>,
        Yangbo Lu <yangbo.lu@nxp.com>,
        Hongbo Wang <hongbo.wang@nxp.com>,
        Xiaoliang Yang <xiaoliang.yang_1@nxp.com>,
        Alexandre Belloni <alexandre.belloni@bootlin.com>,
        Claudiu Manoil <claudiu.manoil@nxp.com>,
        UNGLinuxDriver@microchip.com
Subject: [PATCH net-next 3/5] net: mscc: ocelot: allow a config where all bridge VLANs are egress-untagged
Date:   Wed, 20 Oct 2021 13:56:00 +0300
Message-Id: <20211020105602.770329-4-vladimir.oltean@nxp.com>
X-Mailer: git-send-email 2.25.1
In-Reply-To: <20211020105602.770329-1-vladimir.oltean@nxp.com>
References: <20211020105602.770329-1-vladimir.oltean@nxp.com>
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-ClientProxiedBy: AM3PR05CA0111.eurprd05.prod.outlook.com
 (2603:10a6:207:2::13) To VI1PR04MB5136.eurprd04.prod.outlook.com
 (2603:10a6:803:55::19)
MIME-Version: 1.0
Received: from localhost.localdomain (188.25.174.251) by AM3PR05CA0111.eurprd05.prod.outlook.com (2603:10a6:207:2::13) with Microsoft SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4628.16 via Frontend Transport; Wed, 20 Oct 2021 10:56:24 +0000
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: 87b57ced-8844-45c6-c657-08d993b8432e
X-MS-TrafficTypeDiagnostic: VE1PR04MB6702:
X-MS-Exchange-Transport-Forked: True
X-Microsoft-Antispam-PRVS: <VE1PR04MB67023524D1705B1AE9D46ACBE0BE9@VE1PR04MB6702.eurprd04.prod.outlook.com>
X-MS-Oob-TLC-OOBClassifiers: OLM:10000;
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: AuJ/wsIn+z04kPWZzMYMw1z1zJMLcQyHNYM1YveRrNCohFo8xqZh56iNGDLNAMxbSXipRcTArCvoKp6awXQPWeZ8L6KJrO8IJP1kixpzTMu+YSzEQsSBygdQEoDySY2D1M0wASGrvdGIUOYJq31ldIugC4t02pSlva3PVqkYBYuyqocgb/e+RM4xwAc4CNDihAGrSgAdrvD648D/AyacXQvFDhvM5R70Z9NIKAA68/qWHUeGqnWvxsOlhrJSalLXvngKENFgdct78Vc/u8ByKVEVJv3jWnugTAHonNn1ZWKUM0OEEdw8/6JC7S0IgRjwg14ODdgHGG1rJXAjUWxId8hMiQ+1KvAO5478yMaDMt3iCLjNDbtoA9dFOrfm+f9rNCEIb+xqjVdc2jbHJhfA/W8GJPIijXbgfXYdLwdYHKcfczJJ69flhX+ghYRIBp0RK68xqGr+3jkx35PLd12JLIPbcZX3DTkS4E61WWaP8qgzBUC23d+E9pl/fPXImB0xLmfJ1QAyCUxtlxSj4wlYzl5XpOSKZjWR+m+puoHaK2C0wOsYVAknR3TbNWeKgpcSeBu0Z1w01+k8nGWWO5NeZNxYswFcjPbBOyP4Y2C03A0RzDgvxWqn3lzRd+wmlbnCO13UPhhz7kt8o4g3nG+cwlWRITBvlNn7GWGXOgNDabV1maPUlN6A9cjIZvyxDZCxuLb3GbnAj5oDO/S43kClyA==
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:VI1PR04MB5136.eurprd04.prod.outlook.com;PTR:;CAT:NONE;SFS:(4636009)(366004)(6512007)(5660300002)(8676002)(1076003)(26005)(38100700002)(52116002)(83380400001)(54906003)(316002)(86362001)(4326008)(186003)(8936002)(66946007)(6666004)(6636002)(66476007)(110136005)(508600001)(44832011)(2906002)(956004)(66556008)(6506007)(2616005)(38350700002)(6486002)(36756003);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?us-ascii?Q?dQJTXcupoWOricZA2KwO5jebm/4qTHU1cEGp4RifhVz1LLLLsNwFC6M9pmA+?=
 =?us-ascii?Q?kPv66MkuWnugRM7NGzH8SbLzq3wRqwZhnno1JGKNKFbQPFLF1/KLgemZrH7a?=
 =?us-ascii?Q?6mcby9UaXOiYORqMcDmAGfaheHp0HjJmd/biBNI5ZZQkualnSWNzP6o54Ams?=
 =?us-ascii?Q?dzf2JW/HBVFwtaz2/Ykwx8E0BJ57dVcApHPjf7CuJJW5jjKr5nR849H3/GFN?=
 =?us-ascii?Q?NeHmqihAeXysHs7LH5koEM16C7FrrDYEGWXnA/0XU46At1bFNDCGfMt757Bc?=
 =?us-ascii?Q?qyuypBSiGhoBcY3VRbhpxySG0lyddkDvMnbIzfcz4iod3CM4IlEZVQfoxX6v?=
 =?us-ascii?Q?m1RDB08GOWWNcH2a85cVr3QgHpjfKqmgCG/954LAjU2riDV0Vrw1fa2EnnVb?=
 =?us-ascii?Q?KnK+PWHsd0KZksk9LthW6ONpWJXJfoHc5qf4qou8CyMczO4ZKBppVmImCBeI?=
 =?us-ascii?Q?vY6NptpkBnVxmwiJHF4KfzUhnSpEXS4Id61gi8ZHFlD5fVL6TmXbovY5cPsz?=
 =?us-ascii?Q?kAMJZx/nz1y2TpRs3bULfIx4JW6ozMmtscW/gvwA3cljlZHs0Q5yjcpASytx?=
 =?us-ascii?Q?L1uicpLA8+J2gYvEfB5cyVaLH+OgI253lRc+UzIy0xWtuOaEEcC43SxaF38V?=
 =?us-ascii?Q?KutF/EgB2vkNM4/tqKRGPqelDnlDJbZ8QLmHLmpTFP4gXbzvPw1wDqGA/yXr?=
 =?us-ascii?Q?c93vx/Q5nrys0BUsJsb5Vm6Cd/tA1YwStb1ftFA1h8KjI+V5U6CQpr3y5+1V?=
 =?us-ascii?Q?7D2O5+aY+NhIDerTg4+bb5aIl5tOBBZB2ECbR3ZIrhwsFHAC/fE+5dw9CqH7?=
 =?us-ascii?Q?6PcLmLROR+B9FRNxZnPlxj20m0qjdIEd/hfC0jmAXL4JaEZ/ed0tUipdBTNA?=
 =?us-ascii?Q?hdG5KsgBVVJ2Vb8YvicMeuZMYgMb3lMIMvS371JFEvMP5SADzs8k63xtOnHK?=
 =?us-ascii?Q?KH7u2YFBeEwLHPYEER6SCuk8Mmo2eMkjHwp2W1a3kKoh5DiUr5kMecISRl5X?=
 =?us-ascii?Q?ODlfBZ0CS+dit2McvJRri5ODMqfoRWglE5T7bYjytUgVGtDkbGl+y/z9H6KM?=
 =?us-ascii?Q?WPbovcLkgG8mLAmvgMjmTAYqDqu5+XQ/D8eSTX2wOJh3id/WMLT6ctevLqQO?=
 =?us-ascii?Q?rJbMwjnaicLaFCt3yfchHEnBah+2AMN8bFPbKTJ/m+YwaD/BWgt9+Np+DQtA?=
 =?us-ascii?Q?Z22kCf/SsHZf79s7jwjFZlYH6dpw/a2KyFym+xQGURF7F4rIDGgkeOzR3B+f?=
 =?us-ascii?Q?w5zok/YhJOdJpDWbzqtymjOF4CBP7o4nNFRGUDcChNEzT9m6W7/s7hy7mFFX?=
 =?us-ascii?Q?4pFRnk51wBZIxR5IcwiG72/0?=
X-OriginatorOrg: nxp.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 87b57ced-8844-45c6-c657-08d993b8432e
X-MS-Exchange-CrossTenant-AuthSource: VI1PR04MB5136.eurprd04.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 20 Oct 2021 10:56:26.2079
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 686ea1d3-bc2b-4c6f-a92c-d99c5c301635
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: ZaFVg1jGrK5pj0EDvNB5l9ajQI5Xr66WjmWFanwkItK8UKxs60NeoaWbnvECBDmspRroYOyfaXwl0+IcxZ9hcw==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: VE1PR04MB6702
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

At present, the ocelot driver accepts a single egress-untagged bridge
VLAN, meaning that this sequence of operations:

ip link add br0 type bridge vlan_filtering 1
ip link set swp0 master br0
bridge vlan add dev swp0 vid 2 pvid untagged

fails because the bridge automatically installs VID 1 as a pvid & untagged
VLAN, and vid 2 would be the second untagged VLAN on this port. It is
necessary to delete VID 1 before proceeding to add VID 2.

This limitation comes from the fact that we operate the port tag, when
it has an egress-untagged VID, in the OCELOT_PORT_TAG_NATIVE mode.
The ocelot switches do not have full flexibility and can either have one
single VID as egress-untagged, or all of them.

There are use cases for having all VLANs as egress-untagged as well, and
this patch adds support for that.

The change rewrites ocelot_port_set_native_vlan() into a more generic
ocelot_port_manage_port_tag() function. Because the software bridge's
state, transmitted to us via switchdev, can become very complex, we
don't attempt to track all possible state transitions, but instead take
a more declarative approach and just make ocelot_port_manage_port_tag()
figure out which more to operate in:

- port is VLAN-unaware: the classified VLAN (internal, unrelated to the
                        802.1Q header) is not inserted into packets on egress
- port is VLAN-aware:
  - port has tagged VLANs:
    -> port has no untagged VLAN: set up as pure trunk
    -> port has one untagged VLAN: set up as trunk port + native VLAN
    -> port has more than one untagged VLAN: this is an invalid config
       which is rejected by ocelot_vlan_prepare
  - port has no tagged VLANs
    -> set up as pure egress-untagged port

We don't keep the number of tagged and untagged VLANs, we just count the
structures we keep.

Signed-off-by: Vladimir Oltean <vladimir.oltean@nxp.com>
---
 drivers/net/ethernet/mscc/ocelot.c | 146 ++++++++++++++++++++++-------
 include/soc/mscc/ocelot.h          |   3 +-
 2 files changed, 113 insertions(+), 36 deletions(-)

diff --git a/drivers/net/ethernet/mscc/ocelot.c b/drivers/net/ethernet/mscc/ocelot.c
index c8c0b0f0dd59..bc033e62be97 100644
--- a/drivers/net/ethernet/mscc/ocelot.c
+++ b/drivers/net/ethernet/mscc/ocelot.c
@@ -162,29 +162,100 @@ static int ocelot_vlant_set_mask(struct ocelot *ocelot, u16 vid, u32 mask)
 	return ocelot_vlant_wait_for_completion(ocelot);
 }
 
-static void ocelot_port_set_native_vlan(struct ocelot *ocelot, int port,
-					struct ocelot_vlan native_vlan)
+static int ocelot_port_num_untagged_vlans(struct ocelot *ocelot, int port)
 {
-	struct ocelot_port *ocelot_port = ocelot->ports[port];
-	enum ocelot_port_tag_config tag_cfg;
+	struct ocelot_bridge_vlan *vlan;
+	int num_untagged = 0;
+
+	list_for_each_entry(vlan, &ocelot->vlans, list) {
+		if (!(vlan->portmask & BIT(port)))
+			continue;
 
-	ocelot_port->native_vlan = native_vlan;
+		if (vlan->untagged & BIT(port))
+			num_untagged++;
+	}
 
-	ocelot_rmw_gix(ocelot, REW_PORT_VLAN_CFG_PORT_VID(native_vlan.vid),
-		       REW_PORT_VLAN_CFG_PORT_VID_M,
-		       REW_PORT_VLAN_CFG, port);
+	return num_untagged;
+}
+
+static int ocelot_port_num_tagged_vlans(struct ocelot *ocelot, int port)
+{
+	struct ocelot_bridge_vlan *vlan;
+	int num_tagged = 0;
+
+	list_for_each_entry(vlan, &ocelot->vlans, list) {
+		if (!(vlan->portmask & BIT(port)))
+			continue;
+
+		if (!(vlan->untagged & BIT(port)))
+			num_tagged++;
+	}
+
+	return num_tagged;
+}
+
+/* We use native VLAN when we have to mix egress-tagged VLANs with exactly
+ * _one_ egress-untagged VLAN (_the_ native VLAN)
+ */
+static bool ocelot_port_uses_native_vlan(struct ocelot *ocelot, int port)
+{
+	return ocelot_port_num_tagged_vlans(ocelot, port) &&
+	       ocelot_port_num_untagged_vlans(ocelot, port) == 1;
+}
+
+static struct ocelot_bridge_vlan *
+ocelot_port_find_native_vlan(struct ocelot *ocelot, int port)
+{
+	struct ocelot_bridge_vlan *vlan;
+
+	list_for_each_entry(vlan, &ocelot->vlans, list)
+		if (vlan->portmask & BIT(port) && vlan->untagged & BIT(port))
+			return vlan;
+
+	return NULL;
+}
+
+/* Keep in sync REW_TAG_CFG_TAG_CFG and, if applicable,
+ * REW_PORT_VLAN_CFG_PORT_VID, with the bridge VLAN table and VLAN awareness
+ * state of the port.
+ */
+static void ocelot_port_manage_port_tag(struct ocelot *ocelot, int port)
+{
+	struct ocelot_port *ocelot_port = ocelot->ports[port];
+	enum ocelot_port_tag_config tag_cfg;
+	bool uses_native_vlan = false;
 
 	if (ocelot_port->vlan_aware) {
-		if (native_vlan.valid)
+		uses_native_vlan = ocelot_port_uses_native_vlan(ocelot, port);
+
+		if (uses_native_vlan)
 			tag_cfg = OCELOT_PORT_TAG_NATIVE;
+		else if (ocelot_port_num_untagged_vlans(ocelot, port))
+			tag_cfg = OCELOT_PORT_TAG_DISABLED;
 		else
 			tag_cfg = OCELOT_PORT_TAG_TRUNK;
 	} else {
 		tag_cfg = OCELOT_PORT_TAG_DISABLED;
 	}
+
 	ocelot_rmw_gix(ocelot, REW_TAG_CFG_TAG_CFG(tag_cfg),
 		       REW_TAG_CFG_TAG_CFG_M,
 		       REW_TAG_CFG, port);
+
+	if (uses_native_vlan) {
+		struct ocelot_bridge_vlan *native_vlan;
+
+		/* Not having a native VLAN is impossible, because
+		 * ocelot_port_num_untagged_vlans has returned 1.
+		 * So there is no use in checking for NULL here.
+		 */
+		native_vlan = ocelot_port_find_native_vlan(ocelot, port);
+
+		ocelot_rmw_gix(ocelot,
+			       REW_PORT_VLAN_CFG_PORT_VID(native_vlan->vid),
+			       REW_PORT_VLAN_CFG_PORT_VID_M,
+			       REW_PORT_VLAN_CFG, port);
+	}
 }
 
 /* Default vlan to clasify for untagged frames (may be zero) */
@@ -231,7 +302,8 @@ static struct ocelot_bridge_vlan *ocelot_bridge_vlan_find(struct ocelot *ocelot,
 	return NULL;
 }
 
-static int ocelot_vlan_member_add(struct ocelot *ocelot, int port, u16 vid)
+static int ocelot_vlan_member_add(struct ocelot *ocelot, int port, u16 vid,
+				  bool untagged)
 {
 	struct ocelot_bridge_vlan *vlan = ocelot_bridge_vlan_find(ocelot, vid);
 	unsigned long portmask;
@@ -245,6 +317,14 @@ static int ocelot_vlan_member_add(struct ocelot *ocelot, int port, u16 vid)
 			return err;
 
 		vlan->portmask = portmask;
+		/* Bridge VLANs can be overwritten with a different
+		 * egress-tagging setting, so make sure to override an untagged
+		 * with a tagged VID if that's going on.
+		 */
+		if (untagged)
+			vlan->untagged |= BIT(port);
+		else
+			vlan->untagged &= ~BIT(port);
 
 		return 0;
 	}
@@ -263,6 +343,8 @@ static int ocelot_vlan_member_add(struct ocelot *ocelot, int port, u16 vid)
 
 	vlan->vid = vid;
 	vlan->portmask = portmask;
+	if (untagged)
+		vlan->untagged = BIT(port);
 	INIT_LIST_HEAD(&vlan->list);
 	list_add_tail(&vlan->list, &ocelot->vlans);
 
@@ -324,7 +406,7 @@ int ocelot_port_vlan_filtering(struct ocelot *ocelot, int port,
 		       ANA_PORT_VLAN_CFG, port);
 
 	ocelot_port_set_pvid(ocelot, port, ocelot_port->pvid_vlan);
-	ocelot_port_set_native_vlan(ocelot, port, ocelot_port->native_vlan);
+	ocelot_port_manage_port_tag(ocelot, port);
 
 	return 0;
 }
@@ -333,14 +415,20 @@ EXPORT_SYMBOL(ocelot_port_vlan_filtering);
 int ocelot_vlan_prepare(struct ocelot *ocelot, int port, u16 vid, bool pvid,
 			bool untagged, struct netlink_ext_ack *extack)
 {
-	struct ocelot_port *ocelot_port = ocelot->ports[port];
-
-	/* Deny changing the native VLAN, but always permit deleting it */
-	if (untagged && ocelot_port->native_vlan.vid != vid &&
-	    ocelot_port->native_vlan.valid) {
-		NL_SET_ERR_MSG_MOD(extack,
-				   "Port already has a native VLAN");
-		return -EBUSY;
+	if (untagged) {
+		/* We are adding an egress-tagged VLAN */
+		if (ocelot_port_uses_native_vlan(ocelot, port)) {
+			NL_SET_ERR_MSG_MOD(extack,
+					   "Port with egress-tagged VLANs cannot have more than one egress-untagged (native) VLAN");
+			return -EBUSY;
+		}
+	} else {
+		/* We are adding an egress-tagged VLAN */
+		if (ocelot_port_num_untagged_vlans(ocelot, port) > 1) {
+			NL_SET_ERR_MSG_MOD(extack,
+					   "Port with more than one egress-untagged VLAN cannot have egress-tagged VLANs");
+			return -EBUSY;
+		}
 	}
 
 	return 0;
@@ -352,7 +440,7 @@ int ocelot_vlan_add(struct ocelot *ocelot, int port, u16 vid, bool pvid,
 {
 	int err;
 
-	err = ocelot_vlan_member_add(ocelot, port, vid);
+	err = ocelot_vlan_member_add(ocelot, port, vid, untagged);
 	if (err)
 		return err;
 
@@ -366,13 +454,7 @@ int ocelot_vlan_add(struct ocelot *ocelot, int port, u16 vid, bool pvid,
 	}
 
 	/* Untagged egress vlan clasification */
-	if (untagged) {
-		struct ocelot_vlan native_vlan;
-
-		native_vlan.vid = vid;
-		native_vlan.valid = true;
-		ocelot_port_set_native_vlan(ocelot, port, native_vlan);
-	}
+	ocelot_port_manage_port_tag(ocelot, port);
 
 	return 0;
 }
@@ -395,11 +477,7 @@ int ocelot_vlan_del(struct ocelot *ocelot, int port, u16 vid)
 	}
 
 	/* Egress */
-	if (ocelot_port->native_vlan.vid == vid) {
-		struct ocelot_vlan native_vlan = {0};
-
-		ocelot_port_set_native_vlan(ocelot, port, native_vlan);
-	}
+	ocelot_port_manage_port_tag(ocelot, port);
 
 	return 0;
 }
@@ -1725,12 +1803,12 @@ void ocelot_port_bridge_leave(struct ocelot *ocelot, int port,
 			      struct net_device *bridge)
 {
 	struct ocelot_port *ocelot_port = ocelot->ports[port];
-	struct ocelot_vlan pvid = {0}, native_vlan = {0};
+	struct ocelot_vlan pvid = {0};
 
 	ocelot_port->bridge = NULL;
 
 	ocelot_port_set_pvid(ocelot, port, pvid);
-	ocelot_port_set_native_vlan(ocelot, port, native_vlan);
+	ocelot_port_manage_port_tag(ocelot, port);
 	ocelot_apply_bridge_fwd_mask(ocelot);
 }
 EXPORT_SYMBOL(ocelot_port_bridge_leave);
diff --git a/include/soc/mscc/ocelot.h b/include/soc/mscc/ocelot.h
index 9f2ea7995075..b8b1ac943b44 100644
--- a/include/soc/mscc/ocelot.h
+++ b/include/soc/mscc/ocelot.h
@@ -571,6 +571,7 @@ struct ocelot_vlan {
 struct ocelot_bridge_vlan {
 	u16 vid;
 	unsigned long portmask;
+	unsigned long untagged;
 	struct list_head list;
 };
 
@@ -608,8 +609,6 @@ struct ocelot_port {
 	bool				vlan_aware;
 	/* VLAN that untagged frames are classified to, on ingress */
 	struct ocelot_vlan		pvid_vlan;
-	/* The VLAN ID that will be transmitted as untagged, on egress */
-	struct ocelot_vlan		native_vlan;
 
 	unsigned int			ptp_skbs_in_flight;
 	u8				ptp_cmd;
-- 
2.25.1

