Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 7F04B3BA8A1
	for <lists+netdev@lfdr.de>; Sat,  3 Jul 2021 13:59:06 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230382AbhGCMB1 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sat, 3 Jul 2021 08:01:27 -0400
Received: from mail-eopbgr20063.outbound.protection.outlook.com ([40.107.2.63]:47491
        "EHLO EUR02-VE1-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S230209AbhGCMBS (ORCPT <rfc822;netdev@vger.kernel.org>);
        Sat, 3 Jul 2021 08:01:18 -0400
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=l+nRUFLnzWBjzeQaLOz6r0OACAuZ9qYjiZIkUZCGb/Veb67+dhKoxeX2WeXnqOJBNzeLPepZCeqOLo/cobUVr4JF2Zlg9S+HTq7pkruV8i6kFOREGB8vp4hNrjmo7Fvy2I6THgBqd5vPFPbexalxzT60mQXZVdWcm5LhCFU4zmbXqq8uoA2W9npuMEEsJ3x4HVkjnapwA7IPQsMgxW3J2GhcWQgjzsAHeSDQ0BMl0w7Q5yl3rmQJCXQi3xGItEf0q41C5FgasOhzdQYfSOkzQrxSYpmPqWoObL+NCplIkXUzzzEzeGYSO6DUBx8Avy8WC7amAgKV19Qd7Wo4r/OCnA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=DduN+q9h+tIBuMlP1SW0pq2bUKwwt+2igei15Vdqnek=;
 b=LjhiR5l6lqayj/MaPkqQaPOTuAmzpcpivFQkwCyIG4Y4sP0Wi+RXki5M4WCj6twJsxMDuOKMSy9tyQsb7/gURik0IeXVe/lWmNzB5/jTGP/h4vvDFBac5tj10SLRCNmAA/CZyzxURDCK5qLDkyFq5apCPEAbrUWKM6OCztyfEJwB+fP19dTEQdKIzdFC27HRbUjFVrbN6TJxyJvvO4BQ8FBAA6IRulW3cxWN8h7ewO35/Z2VOzrAJfq6aCROZloND1we/w7qTT8MljoyEGnh4JSWPw7EPvBFcV9VYwjBpf758jGavYa4JQjb4EZ1ynLFlCJF3WBBDRvKXUYifwBgmQ==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=nxp.com; dmarc=pass action=none header.from=nxp.com; dkim=pass
 header.d=nxp.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=nxp.com; s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=DduN+q9h+tIBuMlP1SW0pq2bUKwwt+2igei15Vdqnek=;
 b=h1R8WAbjiWvWq25/oggMOeUnCjqHWODUSRzmUj2aS7Pwk0PDOiTwzdc4bL27Mcsy09WBLtnoRHLDf3uF5pYHtMr8GusObDT21jeh7Up21r1RMQxt2svnZxp7DHtKUuvmYXc1buS1IARGL53Sghl5VCxO2qIqXN6ZKIhRiZB7qL4=
Authentication-Results: vger.kernel.org; dkim=none (message not signed)
 header.d=none;vger.kernel.org; dmarc=none action=none header.from=nxp.com;
Received: from VI1PR04MB5136.eurprd04.prod.outlook.com (2603:10a6:803:55::19)
 by VI1PR0401MB2509.eurprd04.prod.outlook.com (2603:10a6:800:56::11) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4287.22; Sat, 3 Jul
 2021 11:58:40 +0000
Received: from VI1PR04MB5136.eurprd04.prod.outlook.com
 ([fe80::b1a0:d654:a578:53ab]) by VI1PR04MB5136.eurprd04.prod.outlook.com
 ([fe80::b1a0:d654:a578:53ab%7]) with mapi id 15.20.4287.031; Sat, 3 Jul 2021
 11:58:40 +0000
From:   Vladimir Oltean <vladimir.oltean@nxp.com>
To:     netdev@vger.kernel.org, Jakub Kicinski <kuba@kernel.org>,
        "David S. Miller" <davem@davemloft.net>
Cc:     Andrew Lunn <andrew@lunn.ch>,
        Florian Fainelli <f.fainelli@gmail.com>,
        Vivien Didelot <vivien.didelot@gmail.com>,
        Jiri Pirko <jiri@resnulli.us>,
        Ido Schimmel <idosch@idosch.org>,
        Tobias Waldekranz <tobias@waldekranz.com>,
        Roopa Prabhu <roopa@nvidia.com>,
        Nikolay Aleksandrov <nikolay@nvidia.com>,
        Stephen Hemminger <stephen@networkplumber.org>,
        bridge@lists.linux-foundation.org,
        Alexander Duyck <alexander.duyck@gmail.com>
Subject: [RFC PATCH v2 net-next 10/10] net: dsa: tag_dsa: offload the bridge forwarding process
Date:   Sat,  3 Jul 2021 14:57:05 +0300
Message-Id: <20210703115705.1034112-11-vladimir.oltean@nxp.com>
X-Mailer: git-send-email 2.25.1
In-Reply-To: <20210703115705.1034112-1-vladimir.oltean@nxp.com>
References: <20210703115705.1034112-1-vladimir.oltean@nxp.com>
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-Originating-IP: [188.26.224.68]
X-ClientProxiedBy: PR3P189CA0081.EURP189.PROD.OUTLOOK.COM
 (2603:10a6:102:b4::26) To VI1PR04MB5136.eurprd04.prod.outlook.com
 (2603:10a6:803:55::19)
MIME-Version: 1.0
X-MS-Exchange-MessageSentRepresentingType: 1
Received: from localhost.localdomain (188.26.224.68) by PR3P189CA0081.EURP189.PROD.OUTLOOK.COM (2603:10a6:102:b4::26) with Microsoft SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4287.23 via Frontend Transport; Sat, 3 Jul 2021 11:58:39 +0000
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: 5cd5d110-5c19-4662-0763-08d93e19e627
X-MS-TrafficTypeDiagnostic: VI1PR0401MB2509:
X-Microsoft-Antispam-PRVS: <VI1PR0401MB2509BD2E080CF6F080AD40B5E01E9@VI1PR0401MB2509.eurprd04.prod.outlook.com>
X-MS-Oob-TLC-OOBClassifiers: OLM:8882;
X-MS-Exchange-SenderADCheck: 1
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: oxsFHy9I+zX5H/aZhuo6AD18Jtb+Pz0oV/H4kEAME5PQ5mrLcnI0DGGqjfr2WfJtGWvQIzfLVnV81Dm3eqX+e8LqRUORCod6gLi0CFia3DqdKRFmqujLn1zCB0tYHsRZ1IigEXVoK3vqZivHxWqeP3R+rpQjiegn2vr730/QoQPHT5ENqzxbBYsJNR1XBQehZEOjoosEkzlL5O5pH8qQXLPGv8AfAkcgOLjgqGBDqEbbEqdDk8e+f8COyFNFVb5AVEbzZbpR5X0zPr0Zv/XMmNvnF7rE/+sfG7CSm+F2XK3JyTkjLUw45BF/ZmlfrlOHX1rMNACHs88TttGmxVPtRDBGuAb1Q5o9D+CtY4SB4DfqdOy3nyci0v5m5FgLs8h3d6H+iVIgJQNV9utLGF/yEiRUOYrVVAb+F0b+/NmYJRfdeRvWrfsDW/p/vP/tIsEgnUrVOB/WjSC2rNmovGkTry265toQ/zP3Xf/CCLd/knYubaRF+ucyCimcw10lrRZtFRVpYm7sd8AwiBlHeeN1CCENELSOIQf1q2BhQshNwH/iuSrUq966yRh1w/cm16kYO7R75fEJVkGN3z7Nk3O02G3xhB7Gd+mZBNMqS12HtZyHBtNnMx+HQUsJrFM16aG4Jxo9rkWJEqGv5q+waKNy7t/tKajrPAPJdokE4TWgwwU/MVmilf1MfM1Nay/AFTomkLDe9VG2g8z1g40hIBglGX5Qjl1Q8Fknt5sdfCKcDHK3QGpyEgljUrhpBO+hoO4O
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:VI1PR04MB5136.eurprd04.prod.outlook.com;PTR:;CAT:NONE;SFS:(4636009)(396003)(376002)(366004)(346002)(136003)(39850400004)(6506007)(2906002)(4326008)(36756003)(2616005)(44832011)(956004)(6666004)(478600001)(7416002)(5660300002)(110136005)(66946007)(26005)(52116002)(1076003)(8676002)(8936002)(316002)(54906003)(66476007)(66556008)(6486002)(38100700002)(16526019)(38350700002)(186003)(83380400001)(86362001)(6512007)(69590400013);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?us-ascii?Q?X09kkgn7HcJI1Q3EPd6fkVEM+Gr6zhppT7MuDfQkUKE52VoyHriev0UIz1fF?=
 =?us-ascii?Q?uD842OwK9TF0x97FBz/Ef4kn2KSYpgtcIDnS0b5NCwXdU9dubuWD5u3V1J4E?=
 =?us-ascii?Q?eApYTz0vXlS7CyaynDqQKqIQP25/0FFYzf3aYPwNcO8DNqeyz4JniNVa+OCc?=
 =?us-ascii?Q?0+2Cat1uMseXDZmfeMT1hyG2HetvhN6ExxkJrVOri6KTSeHqspk/aAgyiZZJ?=
 =?us-ascii?Q?9LcvLxMmJFBjqVZSg/9kPQ6xB83ulCIKMqrphTNoHzLXzzQeDiXZ1m2GuQ/W?=
 =?us-ascii?Q?AVSQEOyaq/xI4mHCmnVaVae45YfOG68++c497FLhyZ9PsfdEgvC+7EWDc90s?=
 =?us-ascii?Q?WsLyrcjosP5UgSp1Pf/EXMdmtEBmomPVXYvxtaAW+TKNrntSl6CAtH2pRbER?=
 =?us-ascii?Q?zSR5L77DaghyDBgllKKmwZf4xEX8S68K8+TOVEwbxJJhagNAkGdJspfZ5/OY?=
 =?us-ascii?Q?dHZ4NYCcLqsOkEpsVgOxEQIPKm8bOkgcUGgmC4BxQ86d1uFtcIg7Wg5kb9HA?=
 =?us-ascii?Q?xy8ptHDYAi9qsqcR+kCTLSvtB5/w+pQaLze5vonxGuGsRTuEMCeIcGH5/W1M?=
 =?us-ascii?Q?zF0vXuMb8Iut3nvsOUQeBobVV2xwMh7M8iWl3jw5/ijm3H6yBkQUTrP960fs?=
 =?us-ascii?Q?dmDUdPRpP40V4HRiSl0F228iRe3r9OHfFOsF8Ly3L4J/M9jJBwgaVjHoJfKb?=
 =?us-ascii?Q?+h5ZkQ2amIay6Cd2xYa+CjMPfg2MTInxcGhgw7En6PYHChMop9jIRvpRcLW2?=
 =?us-ascii?Q?SJAlH1zfG7Z3q5nAWFZQdYiRPXP5FgENyxqLfnwo9gEt/FlAKw3ofdSibm/k?=
 =?us-ascii?Q?Ydm5/3oVta0xwuiT/PXBKTg8y/CSRAyCWAlOxrMQTg75Ic+NiFMM3D5YwBFV?=
 =?us-ascii?Q?/wMyFWFkF0QnHlRK0eYjySofNeVlZ1cKR/TJPUvr9KBlmYMWr+BOXb8oQg97?=
 =?us-ascii?Q?aFCQAtsO21/74D5yiUxvbwrgDvH6o6gZTPROHmpsmAoBJqLG1NY0g/g3ZbSc?=
 =?us-ascii?Q?zqzcxsbGs08ONX641jHzNGBXyZ6ESaI5rTMcRHn3Ys8rq7jmP3tYplYT3Fdr?=
 =?us-ascii?Q?X3QkMFXKmfo1sif1+2CN5FX7jEmITtLMME5Uxe+a87gUnyrV6r34vmzrMcaa?=
 =?us-ascii?Q?3p2TdzS6wBRB/csowt2OKPmPnEvaa6Wg1ri/zm+LlD9kb0DlufqcRPTWonQ6?=
 =?us-ascii?Q?tXoyxeeUvfIK07hDLDXaJFoVgdCe6w+pZBeTAEr2n1oDP0O8Kz2zRNDamWcX?=
 =?us-ascii?Q?ePbqGS1XnzcgUJxo0RbmiWXeTpb9vyuni/f3JYW/6HydTdmP9iC3fqn1PrTC?=
 =?us-ascii?Q?9Zvlla3tVO6WWjYpykD9SBcE?=
X-OriginatorOrg: nxp.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 5cd5d110-5c19-4662-0763-08d93e19e627
X-MS-Exchange-CrossTenant-AuthSource: VI1PR04MB5136.eurprd04.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 03 Jul 2021 11:58:40.7906
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 686ea1d3-bc2b-4c6f-a92c-d99c5c301635
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: evVRshzTH5E4BID7UqPv0Aq7Cb8ry+Kvb566lAnCINi/K53WC/wb1psEG9YYkF95t8QVyVZ0CsSKxmrkmhZ3YA==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: VI1PR0401MB2509
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Tobias Waldekranz <tobias@waldekranz.com>

Allow the DSA tagger to generate FORWARD frames for offloaded skbs
sent from a bridge that we offload, allowing the switch to handle any
frame replication that may be required. This also means that source
address learning takes place on packets sent from the CPU, meaning
that return traffic no longer needs to be flooded as unknown unicast.

Signed-off-by: Tobias Waldekranz <tobias@waldekranz.com>
Signed-off-by: Vladimir Oltean <vladimir.oltean@nxp.com>
---
 net/dsa/dsa_priv.h | 11 +++++++++
 net/dsa/tag_dsa.c  | 60 +++++++++++++++++++++++++++++++++++++++-------
 2 files changed, 63 insertions(+), 8 deletions(-)

diff --git a/net/dsa/dsa_priv.h b/net/dsa/dsa_priv.h
index c577338b5bb7..c070157cd967 100644
--- a/net/dsa/dsa_priv.h
+++ b/net/dsa/dsa_priv.h
@@ -389,6 +389,17 @@ static inline struct sk_buff *dsa_untag_bridge_pvid(struct sk_buff *skb)
 	return skb;
 }
 
+static inline struct net_device *
+dsa_slave_get_sb_dev(const struct net_device *dev, struct sk_buff *skb)
+{
+	u16 queue_mapping = skb_get_queue_mapping(skb);
+	struct netdev_queue *txq;
+
+	txq = netdev_get_tx_queue(dev, queue_mapping);
+
+	return txq->sb_dev;
+}
+
 /* switch.c */
 int dsa_switch_register_notifier(struct dsa_switch *ds);
 void dsa_switch_unregister_notifier(struct dsa_switch *ds);
diff --git a/net/dsa/tag_dsa.c b/net/dsa/tag_dsa.c
index a822355afc90..9151ed141b3e 100644
--- a/net/dsa/tag_dsa.c
+++ b/net/dsa/tag_dsa.c
@@ -125,8 +125,49 @@ enum dsa_code {
 static struct sk_buff *dsa_xmit_ll(struct sk_buff *skb, struct net_device *dev,
 				   u8 extra)
 {
+	struct net_device *sb_dev = dsa_slave_get_sb_dev(dev, skb);
 	struct dsa_port *dp = dsa_slave_to_port(dev);
+	u8 tag_dev, tag_port;
+	enum dsa_cmd cmd;
 	u8 *dsa_header;
+	u16 pvid = 0;
+	int err;
+
+	if (sb_dev) {
+		/* Don't bother finding the accel_priv corresponding with this
+		 * subordinate device, we know it's the bridge becase we can't
+		 * offload anything else, so just search for it under the port,
+		 * we know it's the same.
+		 */
+		struct dsa_bridge_fwd_accel_priv *accel_priv = dp->accel_priv;
+		struct dsa_switch_tree *dst = dp->ds->dst;
+
+		cmd = DSA_CMD_FORWARD;
+
+		/* When offloading forwarding for a bridge, inject FORWARD
+		 * packets on behalf of a virtual switch device with an index
+		 * past the physical switches.
+		 */
+		tag_dev = dst->last_switch + 1 + accel_priv->bridge_num;
+		tag_port = 0;
+
+		/* If we are offloading forwarding for a VLAN-unaware bridge,
+		 * inject packets to hardware using the bridge's pvid, since
+		 * that's where the packets ingressed from.
+		 */
+		if (!br_vlan_enabled(sb_dev)) {
+			/* Safe because __dev_queue_xmit() runs under
+			 * rcu_read_lock_bh()
+			 */
+			err = br_vlan_get_pvid_rcu(sb_dev, &pvid);
+			if (err)
+				return NULL;
+		}
+	} else {
+		cmd = DSA_CMD_FROM_CPU;
+		tag_dev = dp->ds->index;
+		tag_port = dp->index;
+	}
 
 	if (skb->protocol == htons(ETH_P_8021Q)) {
 		if (extra) {
@@ -134,10 +175,10 @@ static struct sk_buff *dsa_xmit_ll(struct sk_buff *skb, struct net_device *dev,
 			memmove(skb->data, skb->data + extra, 2 * ETH_ALEN);
 		}
 
-		/* Construct tagged FROM_CPU DSA tag from 802.1Q tag. */
+		/* Construct tagged DSA tag from 802.1Q tag. */
 		dsa_header = skb->data + 2 * ETH_ALEN + extra;
-		dsa_header[0] = (DSA_CMD_FROM_CPU << 6) | 0x20 | dp->ds->index;
-		dsa_header[1] = dp->index << 3;
+		dsa_header[0] = (cmd << 6) | 0x20 | tag_dev;
+		dsa_header[1] = tag_port << 3;
 
 		/* Move CFI field from byte 2 to byte 1. */
 		if (dsa_header[2] & 0x10) {
@@ -148,12 +189,13 @@ static struct sk_buff *dsa_xmit_ll(struct sk_buff *skb, struct net_device *dev,
 		skb_push(skb, DSA_HLEN + extra);
 		memmove(skb->data, skb->data + DSA_HLEN + extra, 2 * ETH_ALEN);
 
-		/* Construct untagged FROM_CPU DSA tag. */
+		/* Construct untagged DSA tag. */
 		dsa_header = skb->data + 2 * ETH_ALEN + extra;
-		dsa_header[0] = (DSA_CMD_FROM_CPU << 6) | dp->ds->index;
-		dsa_header[1] = dp->index << 3;
-		dsa_header[2] = 0x00;
-		dsa_header[3] = 0x00;
+
+		dsa_header[0] = (cmd << 6) | tag_dev;
+		dsa_header[1] = tag_port << 3;
+		dsa_header[2] = pvid >> 8;
+		dsa_header[3] = pvid & 0xff;
 	}
 
 	return skb;
@@ -304,6 +346,7 @@ static const struct dsa_device_ops dsa_netdev_ops = {
 	.xmit	  = dsa_xmit,
 	.rcv	  = dsa_rcv,
 	.needed_headroom = DSA_HLEN,
+	.bridge_fwd_offload = true,
 };
 
 DSA_TAG_DRIVER(dsa_netdev_ops);
@@ -347,6 +390,7 @@ static const struct dsa_device_ops edsa_netdev_ops = {
 	.xmit	  = edsa_xmit,
 	.rcv	  = edsa_rcv,
 	.needed_headroom = EDSA_HLEN,
+	.bridge_fwd_offload = true,
 };
 
 DSA_TAG_DRIVER(edsa_netdev_ops);
-- 
2.25.1

