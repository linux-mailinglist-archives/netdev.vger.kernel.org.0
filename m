Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 3B9DA3F1F6D
	for <lists+netdev@lfdr.de>; Thu, 19 Aug 2021 19:55:29 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233957AbhHSRz4 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 19 Aug 2021 13:55:56 -0400
Received: from mail-eopbgr00071.outbound.protection.outlook.com ([40.107.0.71]:49963
        "EHLO EUR02-AM5-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S233719AbhHSRzv (ORCPT <rfc822;netdev@vger.kernel.org>);
        Thu, 19 Aug 2021 13:55:51 -0400
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=k7G3hr2ti7oHCTCGtmRauwqog3XIUr86tEDEe5RHvxmNENhcGK0h4jqomefmBA/eDkfHAtLqcHJpOkUiFxylZbeAzo6rcH4FEMnRDcJDG7UbDUOBZRhVrWG+3mh+X9F0hdJOSSvwH0eEUOZ/g9UD5rAhtVDaXFY/GNsLYECPAZJ8sVBB/rVCJgaj07KPp8/TXb7nd0IJuCJM5EQBCRiz6hbwUvdhT0sHNKaoBODN+JzcGWS+0jiCZoWr61Bvl6+mVvarXG4Ppo61owJ5K8SvafEI7uQpwjeqNNGL/7D6W0Vf+/NWeq2tnNWI05+D1N34iFA+Ff3QUjPVCIG888m5KQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=XD36Voaw6OVULhBSYtzQS/CX+AB2KD5LbMYBGJNC9KY=;
 b=e9wGOoIP/4fO7rKmfR1krKJW9CSIQC9+yI1gOYtqS9L45Qq4XVITi+2dN0RIgK7SIRbAYT648szF/ija0frYqKCG/RGPmmPvxltSXFKSM0o0MZSWSQl7CeRS1Tkzccikwn5gh3y+R+kqNITwmT+26nzUjbzTW0AGu932AiDRzExJ+NIsfWHmxeC18frcvnXQ93x+TrR+iq/EqD2P+aFg9kkLmLIXKA9WtdV7JXxHd7QZd1X6/DXW//0cWKLmyU0waUhNbWMEei1yJWm83h0lJ0VEqPRx8G6au3fLm+zgWsFa3FGl7p2kXP51E8ae8l84gHnkdYbZ9BKpw556XmrLgQ==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=nxp.com; dmarc=pass action=none header.from=nxp.com; dkim=pass
 header.d=nxp.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=nxp.com; s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=XD36Voaw6OVULhBSYtzQS/CX+AB2KD5LbMYBGJNC9KY=;
 b=PGhApkXgFYJHZPSv3U5fZSfz9njbb2yVcWjzLZ4hSLU0eDqUb03/qDWTj2ZekHj460nUBk8GbZow8v0yGqbr0pl16oh87LqRH+eAJgW1KV5kFnr1MePsnPRhilI9lRVrjP50c2mVcr62FM2zcYAh83HMplxncJ52DU+yWGerfYY=
Authentication-Results: vger.kernel.org; dkim=none (message not signed)
 header.d=none;vger.kernel.org; dmarc=none action=none header.from=nxp.com;
Received: from VI1PR04MB5136.eurprd04.prod.outlook.com (2603:10a6:803:55::19)
 by VI1PR04MB4222.eurprd04.prod.outlook.com (2603:10a6:803:46::19) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4415.18; Thu, 19 Aug
 2021 17:55:11 +0000
Received: from VI1PR04MB5136.eurprd04.prod.outlook.com
 ([fe80::109:1995:3e6b:5bd0]) by VI1PR04MB5136.eurprd04.prod.outlook.com
 ([fe80::109:1995:3e6b:5bd0%2]) with mapi id 15.20.4436.019; Thu, 19 Aug 2021
 17:55:11 +0000
From:   Vladimir Oltean <vladimir.oltean@nxp.com>
To:     netdev@vger.kernel.org, Jakub Kicinski <kuba@kernel.org>,
        "David S. Miller" <davem@davemloft.net>
Cc:     Florian Fainelli <f.fainelli@gmail.com>,
        Andrew Lunn <andrew@lunn.ch>,
        Vivien Didelot <vivien.didelot@gmail.com>,
        Vladimir Oltean <olteanv@gmail.com>
Subject: [PATCH v2 net-next] net: dsa: track unique bridge numbers across all DSA switch trees
Date:   Thu, 19 Aug 2021 20:55:00 +0300
Message-Id: <20210819175500.2276709-1-vladimir.oltean@nxp.com>
X-Mailer: git-send-email 2.25.1
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-ClientProxiedBy: AM3PR07CA0133.eurprd07.prod.outlook.com
 (2603:10a6:207:8::19) To VI1PR04MB5136.eurprd04.prod.outlook.com
 (2603:10a6:803:55::19)
MIME-Version: 1.0
X-MS-Exchange-MessageSentRepresentingType: 1
Received: from localhost.localdomain (188.25.144.60) by AM3PR07CA0133.eurprd07.prod.outlook.com (2603:10a6:207:8::19) with Microsoft SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4436.9 via Frontend Transport; Thu, 19 Aug 2021 17:55:11 +0000
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: 9ea8dfd0-bbb1-4405-5976-08d9633a7daf
X-MS-TrafficTypeDiagnostic: VI1PR04MB4222:
X-Microsoft-Antispam-PRVS: <VI1PR04MB4222267C556D775FE1A3A42AE0C09@VI1PR04MB4222.eurprd04.prod.outlook.com>
X-MS-Oob-TLC-OOBClassifiers: OLM:8882;
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: vdSVvA1D+Mp6qzEqcBmc9qGuOm62i63B8+MWJI1ESAnJ78w62yMXIkvgXa1f+GpmVNK0BU3sr8VTzCEl5C9IO2ws/v9gkdPc2V0SpSDzBQ7oNRCwlNQD8TzX78KwWV15uoOFTJH2JchhA1ni5RzN2pfCDoBKfEro8Nklx0cT5v9V05GvB6rz176TmiVyhZ4DCTSfPOed6e9ntNq9mRFrVLc1gU7iHl101KVCLe3UXEzhK4y9Yya0E4CsEc67knIWj0yN6V3BYeIbAmcJll4JLsTc9F5Sh/ycmOS5HBZp51J2TwCoL+VdVIPtBbq0NlXsj1hpEU+XaUYMPgx5o3YrZLhL4I9qtjy9ek9gqcAySK0JEup8br3c9zih2CBKUzB/czJt03utPqZrLx7X4m5cKm5w6rX3ejjpMEHZ2Hloa6wn71QHxOrPqISmBGkQANkpRoc0TG2R8/yQo12n4HTFwAs6UQVwO/ZfkhYXbv/l48x4b9wHfXEgQJTvwahNJJEKlNq+LLVXph5raoOQR7t1HID9li9swRYTWItMuHn0Y7JyJxXPsZAcTfGclf4Z/FMMvQjMlqA2dHtOaYu7sYhojUVSYLLwbhBubbZQY816Rt1eZ3v15eGtAckOwsoh3SfAxoyc5VEwQtFY7Z+ULahTSOg1Ml2ms4iI6TRKfQjLSjDUWIuvm4trW2aQGAqN4u1MHBYBTpTA+iTm0Gk/FaT5fA==
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:VI1PR04MB5136.eurprd04.prod.outlook.com;PTR:;CAT:NONE;SFS:(4636009)(376002)(366004)(346002)(136003)(396003)(39850400004)(86362001)(26005)(83380400001)(316002)(66476007)(66946007)(66556008)(38350700002)(38100700002)(2906002)(8936002)(478600001)(8676002)(956004)(1076003)(52116002)(6666004)(54906003)(6486002)(2616005)(44832011)(4326008)(5660300002)(36756003)(6512007)(186003)(6506007)(110136005);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?us-ascii?Q?jvViRR6L8LMbNuiae4Nxrjjq3CbGhyWBzgPWwDKm48qBmB9YLnaLhJEHpkh3?=
 =?us-ascii?Q?ltVyM0CI/Vk5TjuCBxL8ERK0J6IMr9F0GTPjmCuR8oy8DDRutdqHB+OFfA0F?=
 =?us-ascii?Q?OO0v27HfMZZRv8Qo4eTI1BGXXXSgqhzQCi25aQ5dXx7tYvcQt2rngLyMom3b?=
 =?us-ascii?Q?0SOvP++RbvBoD1I6BokFvNEf5rtIR34f1AehEmOxdNGYIG4Z1+3gbDfkWKsW?=
 =?us-ascii?Q?M6qCdFGhmlQTPJOGe+L8iLLK6s12Z9SiHSulTLdYOQFcBvKmPr9cAMfNvfHg?=
 =?us-ascii?Q?CQCtj9dNXF6VnHSJ+UwWAhjiwoc0gNoUrpYcWUgwDtaxi8ceUqIZzvQOxepY?=
 =?us-ascii?Q?wg6ei12b7E8M5awpgCg4zvkLOKkWGKwZo1hp3aQSmNYR57QOH9t9ghvN0Bhn?=
 =?us-ascii?Q?eCnwmjj75VwWy8xTmJ0MSrwx1j3KEu2libPD7ZTZO70FxsaNFE7BrmNriUBl?=
 =?us-ascii?Q?O/uAfyiXrgm/87DVlxtCmMblijdY5V1WKqitiU5gZEIRnq7HHS69Ml7DreYV?=
 =?us-ascii?Q?d1QZs97QVerX+JorTYAfA+aFccmej7l3wiKP5WOKzv3eimVnOB+d0SFcH0cZ?=
 =?us-ascii?Q?aPL1oG5BvhDmQUeNz8COzxQ6YG+qyzN6H1qa6bBs5h8KieMhlMCYrLg33hF0?=
 =?us-ascii?Q?q0gagTXxsHyBubKTc1NzFvt70oUDNbJAwWC1luKrqj1KdJyTYk7Sv9Wpm1MF?=
 =?us-ascii?Q?6XY3vEl3BDA0jm4D6ZA/LOaougfCyIZ42k8UYz606C/SLJD+RUZbKsaGl3nJ?=
 =?us-ascii?Q?M28Tv4w1KAWztQo9ncb/PTXHvd8H/s7Ts0ejQ1Z1WyRlbW/TDUCPZ9DxtiS4?=
 =?us-ascii?Q?vM8V7smtc0jRweIitx7avRsfAT3LqFNbw0EwfATqw/j8TwYvkKSkSt8hPbav?=
 =?us-ascii?Q?3Vo/LNLbFfSjBv496hmVT763DKuO13eL23tLU50OzssymbYGPCrf65j4krvh?=
 =?us-ascii?Q?CnBclTp+FXhQ6aPdV4SFKhS4Zf4/xJpBTGZXlL6FmsjUM3yuAss+m8+RNfoB?=
 =?us-ascii?Q?lJ3/zi94Yoc0JhVIgrZDSYVsZDDvig+7TdYQ0udPfxyhu0oVgLPwaWitO2mC?=
 =?us-ascii?Q?lkC+wVTJ05/z6b6Az0mC41GE84578eOBinLj1Zrv1zEwneXLyOjvnoMBmWDF?=
 =?us-ascii?Q?VbQs3U5t1L1aVfedGpjIOnSnjBNdfoW+ZUQq2EOsU5IMLaVRyzQIzhZZ7sLt?=
 =?us-ascii?Q?3+OiNWXIe3/wmBd2weGg3EzapnOfCogBLKknJD/uftIiqrB8aAf30n9NIUwK?=
 =?us-ascii?Q?u1jqdO8EDdJkN+QNZvXAj8MW3lPHZiDQiM3LibWv7ck58qdbau3AVEHylQYy?=
 =?us-ascii?Q?89QmRloyZRZj2KiQ6qHGHd6u?=
X-OriginatorOrg: nxp.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 9ea8dfd0-bbb1-4405-5976-08d9633a7daf
X-MS-Exchange-CrossTenant-AuthSource: VI1PR04MB5136.eurprd04.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 19 Aug 2021 17:55:11.8531
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 686ea1d3-bc2b-4c6f-a92c-d99c5c301635
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: llNjS2hTXIM9CfsjSrWTn2EdcIC/jCWkFIXHFC5P4hFVIXGwCyE3kUse0P4DoXZ9CTGIB1TnmCZ01fAJIQ5SEg==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: VI1PR04MB4222
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Right now, cross-tree bridging setups work somewhat by mistake.

In the case of cross-tree bridging with sja1105, all switch instances
need to agree upon a common VLAN ID for forwarding a packet that belongs
to a certain bridging domain.

With TX forwarding offload, the VLAN ID is the bridge VLAN for
VLAN-aware bridging, and the tag_8021q TX forwarding offload VID
(a VLAN which has non-zero VBID bits) for VLAN-unaware bridging.

The VBID for VLAN-unaware bridging is derived from the dp->bridge_num
value calculated by DSA independently for each switch tree.

If ports from one tree join one bridge, and ports from another tree join
another bridge, DSA will assign them the same bridge_num, even though
the bridges are different. If cross-tree bridging is supported, this
is an issue.

Modify DSA to calculate the bridge_num globally across all switch trees.
This has the implication for a driver that the dp->bridge_num value that
DSA will assign to its ports might not be contiguous, if there are
boards with multiple DSA drivers instantiated. Additionally, all
bridge_num values eat up towards each switch's
ds->num_fwd_offloading_bridges maximum, which is potentially unfortunate,
and can be seen as a limitation introduced by this patch. However, that
is the lesser evil for now.

Signed-off-by: Vladimir Oltean <vladimir.oltean@nxp.com>
---
This was split from the larger "DSA FDB isolation" series, hence the v2
tag.

 include/net/dsa.h  |  8 +++-----
 net/dsa/dsa2.c     | 48 ++++++++++++++++++++++++++++++++++++++++++++++
 net/dsa/dsa_priv.h |  2 ++
 net/dsa/port.c     | 39 +++++--------------------------------
 4 files changed, 58 insertions(+), 39 deletions(-)

diff --git a/include/net/dsa.h b/include/net/dsa.h
index 0c2cba45fa79..c7ea0f61056f 100644
--- a/include/net/dsa.h
+++ b/include/net/dsa.h
@@ -155,9 +155,6 @@ struct dsa_switch_tree {
 
 	/* Track the largest switch index within a tree */
 	unsigned int last_switch;
-
-	/* Track the bridges with forwarding offload enabled */
-	unsigned long fwd_offloading_bridges;
 };
 
 #define dsa_lags_foreach_id(_id, _dst)				\
@@ -411,8 +408,9 @@ struct dsa_switch {
 	unsigned int		num_lag_ids;
 
 	/* Drivers that support bridge forwarding offload should set this to
-	 * the maximum number of bridges spanning the same switch tree that can
-	 * be offloaded.
+	 * the maximum number of bridges spanning the same switch tree (or all
+	 * trees, in the case of cross-tree bridging support) that can be
+	 * offloaded.
 	 */
 	unsigned int		num_fwd_offloading_bridges;
 
diff --git a/net/dsa/dsa2.c b/net/dsa/dsa2.c
index dcd67801eca4..1b2b25d7bd02 100644
--- a/net/dsa/dsa2.c
+++ b/net/dsa/dsa2.c
@@ -21,6 +21,9 @@
 static DEFINE_MUTEX(dsa2_mutex);
 LIST_HEAD(dsa_tree_list);
 
+/* Track the bridges with forwarding offload enabled */
+static unsigned long dsa_fwd_offloading_bridges;
+
 /**
  * dsa_tree_notify - Execute code for all switches in a DSA switch tree.
  * @dst: collection of struct dsa_switch devices to notify.
@@ -126,6 +129,51 @@ void dsa_lag_unmap(struct dsa_switch_tree *dst, struct net_device *lag)
 	}
 }
 
+static int dsa_bridge_num_find(const struct net_device *bridge_dev)
+{
+	struct dsa_switch_tree *dst;
+	struct dsa_port *dp;
+
+	/* When preparing the offload for a port, it will have a valid
+	 * dp->bridge_dev pointer but a not yet valid dp->bridge_num.
+	 * However there might be other ports having the same dp->bridge_dev
+	 * and a valid dp->bridge_num, so just ignore this port.
+	 */
+	list_for_each_entry(dst, &dsa_tree_list, list)
+		list_for_each_entry(dp, &dst->ports, list)
+			if (dp->bridge_dev == bridge_dev &&
+			    dp->bridge_num != -1)
+				return dp->bridge_num;
+
+	return -1;
+}
+
+int dsa_bridge_num_get(const struct net_device *bridge_dev, int max)
+{
+	int bridge_num = dsa_bridge_num_find(bridge_dev);
+
+	if (bridge_num < 0) {
+		/* First port that offloads TX forwarding for this bridge */
+		bridge_num = find_first_zero_bit(&dsa_fwd_offloading_bridges,
+						 DSA_MAX_NUM_OFFLOADING_BRIDGES);
+		if (bridge_num >= max)
+			return -1;
+
+		set_bit(bridge_num, &dsa_fwd_offloading_bridges);
+	}
+
+	return bridge_num;
+}
+
+void dsa_bridge_num_put(const struct net_device *bridge_dev, int bridge_num)
+{
+	/* Check if the bridge is still in use, otherwise it is time
+	 * to clean it up so we can reuse this bridge_num later.
+	 */
+	if (!dsa_bridge_num_find(bridge_dev))
+		clear_bit(bridge_num, &dsa_fwd_offloading_bridges);
+}
+
 struct dsa_switch *dsa_switch_find(int tree_index, int sw_index)
 {
 	struct dsa_switch_tree *dst;
diff --git a/net/dsa/dsa_priv.h b/net/dsa/dsa_priv.h
index b7a269e0513f..88aaf43b2da4 100644
--- a/net/dsa/dsa_priv.h
+++ b/net/dsa/dsa_priv.h
@@ -543,6 +543,8 @@ int dsa_tree_change_tag_proto(struct dsa_switch_tree *dst,
 			      struct net_device *master,
 			      const struct dsa_device_ops *tag_ops,
 			      const struct dsa_device_ops *old_tag_ops);
+int dsa_bridge_num_get(const struct net_device *bridge_dev, int max);
+void dsa_bridge_num_put(const struct net_device *bridge_dev, int bridge_num);
 
 /* tag_8021q.c */
 int dsa_tag_8021q_bridge_join(struct dsa_switch *ds,
diff --git a/net/dsa/port.c b/net/dsa/port.c
index 979042a64d1a..4fbe81ffb1ce 100644
--- a/net/dsa/port.c
+++ b/net/dsa/port.c
@@ -270,27 +270,9 @@ static void dsa_port_switchdev_unsync_attrs(struct dsa_port *dp)
 	 */
 }
 
-static int dsa_tree_find_bridge_num(struct dsa_switch_tree *dst,
-				    struct net_device *bridge_dev)
-{
-	struct dsa_port *dp;
-
-	/* When preparing the offload for a port, it will have a valid
-	 * dp->bridge_dev pointer but a not yet valid dp->bridge_num.
-	 * However there might be other ports having the same dp->bridge_dev
-	 * and a valid dp->bridge_num, so just ignore this port.
-	 */
-	list_for_each_entry(dp, &dst->ports, list)
-		if (dp->bridge_dev == bridge_dev && dp->bridge_num != -1)
-			return dp->bridge_num;
-
-	return -1;
-}
-
 static void dsa_port_bridge_tx_fwd_unoffload(struct dsa_port *dp,
 					     struct net_device *bridge_dev)
 {
-	struct dsa_switch_tree *dst = dp->ds->dst;
 	int bridge_num = dp->bridge_num;
 	struct dsa_switch *ds = dp->ds;
 
@@ -300,11 +282,7 @@ static void dsa_port_bridge_tx_fwd_unoffload(struct dsa_port *dp,
 
 	dp->bridge_num = -1;
 
-	/* Check if the bridge is still in use, otherwise it is time
-	 * to clean it up so we can reuse this bridge_num later.
-	 */
-	if (!dsa_tree_find_bridge_num(dst, bridge_dev))
-		clear_bit(bridge_num, &dst->fwd_offloading_bridges);
+	dsa_bridge_num_put(bridge_dev, bridge_num);
 
 	/* Notify the chips only once the offload has been deactivated, so
 	 * that they can update their configuration accordingly.
@@ -316,23 +294,16 @@ static void dsa_port_bridge_tx_fwd_unoffload(struct dsa_port *dp,
 static bool dsa_port_bridge_tx_fwd_offload(struct dsa_port *dp,
 					   struct net_device *bridge_dev)
 {
-	struct dsa_switch_tree *dst = dp->ds->dst;
 	struct dsa_switch *ds = dp->ds;
 	int bridge_num, err;
 
 	if (!ds->ops->port_bridge_tx_fwd_offload)
 		return false;
 
-	bridge_num = dsa_tree_find_bridge_num(dst, bridge_dev);
-	if (bridge_num < 0) {
-		/* First port that offloads TX forwarding for this bridge */
-		bridge_num = find_first_zero_bit(&dst->fwd_offloading_bridges,
-						 DSA_MAX_NUM_OFFLOADING_BRIDGES);
-		if (bridge_num >= ds->num_fwd_offloading_bridges)
-			return false;
-
-		set_bit(bridge_num, &dst->fwd_offloading_bridges);
-	}
+	bridge_num = dsa_bridge_num_get(bridge_dev,
+					ds->num_fwd_offloading_bridges);
+	if (bridge_num < 0)
+		return false;
 
 	dp->bridge_num = bridge_num;
 
-- 
2.25.1

