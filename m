Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 991634C413E
	for <lists+netdev@lfdr.de>; Fri, 25 Feb 2022 10:24:32 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S239009AbiBYJXm (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 25 Feb 2022 04:23:42 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:46306 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S235990AbiBYJXi (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 25 Feb 2022 04:23:38 -0500
Received: from EUR05-AM6-obe.outbound.protection.outlook.com (mail-am6eur05on2086.outbound.protection.outlook.com [40.107.22.86])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 7A6631A6F8B
        for <netdev@vger.kernel.org>; Fri, 25 Feb 2022 01:23:06 -0800 (PST)
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=RTKSn8vgypq9K4FOPImz3FZAPPptQCWg8bt5QSL7NYm+gnkPUZv5rEnIvjb9o16B5B4YqucCU1vo2Xu4CNvOqOhVsajoKmwSg39IJYBVYvc08EVmXhWPbASMywdD5jLpzhnjzLyBgTY2zXni6IYXE0IYkLjSRRIKgPWyZsNkhSi5ErPjMdZSVR4HsHuMW1e7Fiu8opVGV4Ro5qWtycJTEHhjWJl7GHbEGQd/akKlrdZSNEqTBg5nwxmC5MjtWQ6um0L1WK72PdrSlVUhlfjjRNTafL0R5omu+3FCUTO0+YbazUCgTm0zGQVmIv7RpWpUj3IGUqXzy5ERIYfWv0sTMg==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=QPDCfTqlePqpxRweQSSuP0wibJNlcqo/DbxdkafEA54=;
 b=atI3bUefTB/VnO5BgJ4/Eq6s5T5a097Zw370HQf76GmuqpRZ2gBuD4Xg1LccDtSH3n/WMNnGqigmRYZneXSq17ikzSehEwX38w/+2/mRxowqcv9YXx2TIlgckiPScGD7y325gnU9G0lWHhYaUC+YlgXYrpT1jagUmGZeqQ0QJ0AZNy66xZylUWzw2O17pVJ4khCN0nGB7pvtXRxZnamaNvT987I+RXQE9X8N9ujRlDU0S2xtTE9d0LEqiqKD8HutnTen91WHVYAySmzWA8Mcf76DbWtm22fB/8h/rXsM5oSBy9KxayEV0sgATZjr5yG0Ed3zhj25Em4NOrlgmW1BnQ==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=nxp.com; dmarc=pass action=none header.from=nxp.com; dkim=pass
 header.d=nxp.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=nxp.com; s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=QPDCfTqlePqpxRweQSSuP0wibJNlcqo/DbxdkafEA54=;
 b=X6weodkq5HDlR9xhzs69GmUHHeJBKfRoXd7jdUo6JREwDO6wDh4fCp1NHr2r54qpWi2zZl2VQRPjA9sM4xUlkTc/ozUw1KvFd1G8JsT7jy43zLhJya9VS6BsXvwFP+CzQTMb7gxOJR6DJQB0w8VfPujHsJaDWCnLdJATNkfjGhY=
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=nxp.com;
Received: from VI1PR04MB5136.eurprd04.prod.outlook.com (2603:10a6:803:55::19)
 by VI1PR04MB5008.eurprd04.prod.outlook.com (2603:10a6:803:62::32) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.5017.25; Fri, 25 Feb
 2022 09:23:02 +0000
Received: from VI1PR04MB5136.eurprd04.prod.outlook.com
 ([fe80::95cf:8c40:b887:a7b9]) by VI1PR04MB5136.eurprd04.prod.outlook.com
 ([fe80::95cf:8c40:b887:a7b9%4]) with mapi id 15.20.4951.019; Fri, 25 Feb 2022
 09:23:02 +0000
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
Subject: [PATCH v2 net-next 01/10] net: dsa: tag_8021q: replace the SVL bridging with VLAN-unaware IVL bridging
Date:   Fri, 25 Feb 2022 11:22:16 +0200
Message-Id: <20220225092225.594851-2-vladimir.oltean@nxp.com>
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
X-MS-Office365-Filtering-Correlation-Id: f7916c38-b1c0-4eda-48b3-08d9f8406b9c
X-MS-TrafficTypeDiagnostic: VI1PR04MB5008:EE_
X-Microsoft-Antispam-PRVS: <VI1PR04MB50083BFBADEA7F184EFC255EE03E9@VI1PR04MB5008.eurprd04.prod.outlook.com>
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: FNNQ9eVqx8Cg50sSe+djqxhV/etGoM034UK+XS987vnMVQ4Rl4Giqn3RzuxqPR4tW+wUSJPxQbHxl5Jv9Xajexp3tW90UZi90lF0ZPfqh+3PZ8hzGgxZfoB+BV6SgHhMxtAzUMtoQmXM2eoN9VC7gkx3Eea+XnxNUXV8Xmj1fMTFlcqPVs+7BIKsYIossv9H3nVJtLc8wEj/iyC8mrlIJtzaGPDY2wA3Ol0xVmbvBt5zZxXeAALF4O1Qlc3K2rrwt5PVsg4z+DQehIc8JXfy2xzBT+fwuZQEgnH9tEo2nnQ3rWS1q2m+rUEQvUsE91C7eP73mF2nnwXgF+j18IPLVPiomCUB4Ikpn03ldG78GZJ+guwm/ZO8aZFn7QBlQzQ644N/n9fYWrLV3AgcgCctQWjQVsLLULnVfxQL9dj4/2b9csoYGu/Ic9pWQh2EO+Xz9r/DDJAFexlxBAk7bgSR9+WtBiVv8XIWw/SNyxssPkGlyybkSpRpukiB3ZOJj4jh0fY9uGukeXRXGWICAA1uWPeIdLHu4UvdfYKxhqsXzA0Dfc+uYvdZByW+12CISeJEUhBPmQSq3ybjx322nVOfexg1KrlyOM9wuNg9n7sYmSY86VwLgmrRiyVbnrI9ppGeDS2/eeFWLO7JzbrAJryay7x8Ze+3wv8+Y3sVToPnSnirMnm1B6Urs5eY0F9y3t8svtcOzN6gfnfCCNgzZStAbQ==
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:VI1PR04MB5136.eurprd04.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230001)(4636009)(366004)(4326008)(6666004)(38350700002)(38100700002)(54906003)(83380400001)(508600001)(6486002)(110136005)(30864003)(36756003)(5660300002)(52116002)(6512007)(7416002)(6506007)(8936002)(44832011)(316002)(2906002)(2616005)(1076003)(26005)(186003)(86362001)(66946007)(8676002)(66556008)(66476007);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?us-ascii?Q?VGos1nRVISE4RzWQWBZB8AbFjgohFMx2TFRq6Ty4+BErkOjc2J0cAzOWygIs?=
 =?us-ascii?Q?s8/OMuSmeI+riPn+n6Y6C6ZEpZ39VpwGPP4S+VXyX/ngZ4rt3djyt1I0cAws?=
 =?us-ascii?Q?MdPf7Cqve56HScZbr8Y8MF7FuIMqiSacHhWuK28NGbRdWRQbLJGY21gSlwLF?=
 =?us-ascii?Q?ok1sKt3Bm7mAGN/PgbSgtEyFpz9+xo8HHL6AcC94HdeQc2Bc0GHzTWPoAoDN?=
 =?us-ascii?Q?1kQRX3kKUFl137v+QV7W11fGUHzZECTs573/gKIrVQXjVyjl3bM4JbLkRDAH?=
 =?us-ascii?Q?zgmIAJhm17BDe9Mvj4Vh7sfQi6od+y14/zi7wCPzILuBse1gOW3GqWZ3zZqs?=
 =?us-ascii?Q?NOiQCL8xMhQyu4gk+iWFM7CF97xBBBw8ll6mTWU04CNsTHl6FHG51VoB7ukZ?=
 =?us-ascii?Q?EfmMYkqRSBa+83oJoR0WBmshwVxOuzKNojlkNZnfJ2aGEcsTT6XdxgPlFi6Q?=
 =?us-ascii?Q?Q47eBaN55rew5qjbRNxCRvgP0VklLbGqtl9IdKp7wPsY1w3yzPeerX6dIuxB?=
 =?us-ascii?Q?n0qvwRlPdkyVNJzSXiSSpsMEx1jkSqMa2mIFVyvrMV6BUxsGnMJaQ0dpMaYY?=
 =?us-ascii?Q?CgUIGUa+BYB8yrJEefrqDuojorEqugiW49gJmeCSwIh/CEHulW8BrPognr0k?=
 =?us-ascii?Q?n5AnRPImtm8XCdoJFc5DeAvlWSy28Umk8wi5g8nVWpcN9HOfjVJL1jMBEJBM?=
 =?us-ascii?Q?82krMnbirPrtrQJUj2fmWwLxy1GG6K81BzkY/e1GawtJ3s3doZikrfVoXihy?=
 =?us-ascii?Q?JXhsOPfhmZl6zGX4utTLjhOwBzPEpEpdwODwaYthIjy4od5CXPw1qVU/Un5X?=
 =?us-ascii?Q?VGNwPFFyFHmZJE1DCOi7NWcR9bKYDfkCJEo4bbOevW9Rw7ISmyPFCogewsqF?=
 =?us-ascii?Q?n3wVs9pN50JX3kJx3guwua1A9IiXe2g6H5AQmM28h+QALPNgY0wjwKooNd2G?=
 =?us-ascii?Q?+3HSfFMsT4xsleQHeYEYxrkR/xcKlLAXJIWdy+kP5jc+4BlpbgaWJjWW+Nn1?=
 =?us-ascii?Q?EZ6HugUDCWjbEnvhG69UWriEy1/8bngrAGrYhkWTYH+nD9nObLXU/W5UMekI?=
 =?us-ascii?Q?u3DtbHfoHjxXJT1lPdVdJE9DTgD16URmodCUXtr+ig/la6RWvTggE9zZuFGY?=
 =?us-ascii?Q?4nIYH0t3hSMBVJafkpJ2LeyMERO4omMANpBqWXLXeRTIaYpa+OMgDteg0kKA?=
 =?us-ascii?Q?3CyJBmJhMVjX6/rHrpBjZkh0kkqi7Hl8v873OHTLCwmpTtO6uoJIlrTbtSkf?=
 =?us-ascii?Q?Ekr6spB8iB3eGwf9YI7emZxp4IjkXfhvhNsdip0UfsEhOq57uLYjJCjKq8sD?=
 =?us-ascii?Q?4qAd+QQdFcdknV+35ZRY6VvlC7KgMiVk2CDC5yL2CP5L2H5UXGhGkldaOYFu?=
 =?us-ascii?Q?kqT+rTnwQQtLEfQ6VEpY4AV95F2oKd+YfjtQR9oIJyknqPZ2xRzeaDc9yfkJ?=
 =?us-ascii?Q?hnf99fdSBXZahu6BEbL1X8JQH+RnG3j+ZUesIvNkud5CKFGvZADzRBOhuBF5?=
 =?us-ascii?Q?ssMhUkCS46+PZdg/G34NpSFhzAGO9khGofEaLONxu86lL0W8TLTYNcmHlDzW?=
 =?us-ascii?Q?+HgKtlu1SQ0rocTPNUGOstyb2flDatCfWp+9JlByKCgUq53RBpEJZg6MbPcd?=
 =?us-ascii?Q?O8PVNJGFrPf7q4IjoBCPqVo=3D?=
X-OriginatorOrg: nxp.com
X-MS-Exchange-CrossTenant-Network-Message-Id: f7916c38-b1c0-4eda-48b3-08d9f8406b9c
X-MS-Exchange-CrossTenant-AuthSource: VI1PR04MB5136.eurprd04.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 25 Feb 2022 09:23:01.8354
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 686ea1d3-bc2b-4c6f-a92c-d99c5c301635
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: szDT8gVrFWKvwEd55fGKv6qBkUwd2Az6+0XIIMSSezZquyMDhudlCEh3frQ8XvMy9p2NYdkmLmMc0RCrlsK1kQ==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: VI1PR04MB5008
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_NONE,
        RCVD_IN_MSPIKE_H2,SPF_HELO_PASS,SPF_PASS,T_SCC_BODY_TEXT_LINE
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

For VLAN-unaware bridging, tag_8021q uses something perhaps a bit too
tied with the sja1105 switch: each port uses the same pvid which is also
used for standalone operation (a unique one from which the source port
and device ID can be retrieved when packets from that port are forwarded
to the CPU). Since each port has a unique pvid when performing
autonomous forwarding, the switch must be configured for Shared VLAN
Learning (SVL) such that the VLAN ID itself is ignored when performing
FDB lookups. Without SVL, packets would always be flooded, since FDB
lookup in the source port's VLAN would never find any entry.

First of all, to make tag_8021q more palatable to switches which might
not support Shared VLAN Learning, let's just use a common VLAN for all
ports that are under the same bridge.

Secondly, using Shared VLAN Learning means that FDB isolation can never
be enforced. But if all ports under the same VLAN-unaware bridge share
the same VLAN ID, it can.

The disadvantage is that the CPU port can no longer perform precise
source port identification for these packets. But at least we have a
mechanism which has proven to be adequate for that situation: imprecise
RX (dsa_find_designated_bridge_port_by_vid), which is what we use for
termination on VLAN-aware bridges.

The VLAN ID that VLAN-unaware bridges will use with tag_8021q is the
same one as we were previously using for imprecise TX (bridge TX
forwarding offload). It is already allocated, it is just a matter of
using it.

Note that because now all ports under the same bridge share the same
VLAN, the complexity of performing a tag_8021q bridge join decreases
dramatically. We no longer have to install the RX VLAN of a newly
joining port into the port membership of the existing bridge ports.
The newly joining port just becomes a member of the VLAN corresponding
to that bridge, and the other ports are already members of it from when
they joined the bridge themselves. So forwarding works properly.

This means that we can unhook dsa_tag_8021q_bridge_{join,leave} from the
cross-chip notifier level dsa_switch_bridge_{join,leave}. We can put
these calls directly into the sja1105 driver.

With this new mode of operation, a port controlled by tag_8021q can have
two pvids whereas before it could only have one. The pvid for standalone
operation is different from the pvid used for VLAN-unaware bridging.
This is done, again, so that FDB isolation can be enforced.
Let tag_8021q manage this by deleting the standalone pvid when a port
joins a bridge, and restoring it when it leaves it.

Signed-off-by: Vladimir Oltean <vladimir.oltean@nxp.com>
---
 drivers/net/dsa/sja1105/sja1105_main.c |   4 +-
 drivers/net/dsa/sja1105/sja1105_vl.c   |  15 ++-
 include/linux/dsa/8021q.h              |  12 +--
 net/dsa/dsa_priv.h                     |   4 -
 net/dsa/switch.c                       |   4 +-
 net/dsa/tag_8021q.c                    | 132 +++++++++----------------
 6 files changed, 70 insertions(+), 101 deletions(-)

diff --git a/drivers/net/dsa/sja1105/sja1105_main.c b/drivers/net/dsa/sja1105/sja1105_main.c
index b513713be610..1e43a7ef0f2e 100644
--- a/drivers/net/dsa/sja1105/sja1105_main.c
+++ b/drivers/net/dsa/sja1105/sja1105_main.c
@@ -2083,7 +2083,7 @@ static int sja1105_bridge_join(struct dsa_switch *ds, int port,
 	if (rc)
 		return rc;
 
-	rc = dsa_tag_8021q_bridge_tx_fwd_offload(ds, port, bridge);
+	rc = dsa_tag_8021q_bridge_join(ds, port, bridge);
 	if (rc) {
 		sja1105_bridge_member(ds, port, bridge, false);
 		return rc;
@@ -2097,7 +2097,7 @@ static int sja1105_bridge_join(struct dsa_switch *ds, int port,
 static void sja1105_bridge_leave(struct dsa_switch *ds, int port,
 				 struct dsa_bridge bridge)
 {
-	dsa_tag_8021q_bridge_tx_fwd_unoffload(ds, port, bridge);
+	dsa_tag_8021q_bridge_leave(ds, port, bridge);
 	sja1105_bridge_member(ds, port, bridge, false);
 }
 
diff --git a/drivers/net/dsa/sja1105/sja1105_vl.c b/drivers/net/dsa/sja1105/sja1105_vl.c
index f5dca6a9b0f9..14e6dd7fb103 100644
--- a/drivers/net/dsa/sja1105/sja1105_vl.c
+++ b/drivers/net/dsa/sja1105/sja1105_vl.c
@@ -296,6 +296,19 @@ static bool sja1105_vl_key_lower(struct sja1105_vl_lookup_entry *a,
 	return false;
 }
 
+/* FIXME: this should change when the bridge upper of the port changes. */
+static u16 sja1105_port_get_tag_8021q_vid(struct dsa_port *dp)
+{
+	unsigned long bridge_num;
+
+	if (!dp->bridge)
+		return dsa_tag_8021q_rx_vid(dp);
+
+	bridge_num = dsa_port_bridge_num_get(dp);
+
+	return dsa_8021q_bridge_tx_fwd_offload_vid(bridge_num);
+}
+
 static int sja1105_init_virtual_links(struct sja1105_private *priv,
 				      struct netlink_ext_ack *extack)
 {
@@ -395,7 +408,7 @@ static int sja1105_init_virtual_links(struct sja1105_private *priv,
 				vl_lookup[k].vlanprior = rule->key.vl.pcp;
 			} else {
 				struct dsa_port *dp = dsa_to_port(priv->ds, port);
-				u16 vid = dsa_tag_8021q_rx_vid(dp);
+				u16 vid = sja1105_port_get_tag_8021q_vid(dp);
 
 				vl_lookup[k].vlanid = vid;
 				vl_lookup[k].vlanprior = 0;
diff --git a/include/linux/dsa/8021q.h b/include/linux/dsa/8021q.h
index 939a1beaddf7..f47f227baa27 100644
--- a/include/linux/dsa/8021q.h
+++ b/include/linux/dsa/8021q.h
@@ -32,17 +32,17 @@ int dsa_tag_8021q_register(struct dsa_switch *ds, __be16 proto);
 
 void dsa_tag_8021q_unregister(struct dsa_switch *ds);
 
+int dsa_tag_8021q_bridge_join(struct dsa_switch *ds, int port,
+			      struct dsa_bridge bridge);
+
+void dsa_tag_8021q_bridge_leave(struct dsa_switch *ds, int port,
+				struct dsa_bridge bridge);
+
 struct sk_buff *dsa_8021q_xmit(struct sk_buff *skb, struct net_device *netdev,
 			       u16 tpid, u16 tci);
 
 void dsa_8021q_rcv(struct sk_buff *skb, int *source_port, int *switch_id);
 
-int dsa_tag_8021q_bridge_tx_fwd_offload(struct dsa_switch *ds, int port,
-					struct dsa_bridge bridge);
-
-void dsa_tag_8021q_bridge_tx_fwd_unoffload(struct dsa_switch *ds, int port,
-					   struct dsa_bridge bridge);
-
 u16 dsa_8021q_bridge_tx_fwd_offload_vid(unsigned int bridge_num);
 
 u16 dsa_tag_8021q_tx_vid(const struct dsa_port *dp);
diff --git a/net/dsa/dsa_priv.h b/net/dsa/dsa_priv.h
index 1ba93afdc874..7a1c98581f53 100644
--- a/net/dsa/dsa_priv.h
+++ b/net/dsa/dsa_priv.h
@@ -522,10 +522,6 @@ struct dsa_bridge *dsa_tree_bridge_find(struct dsa_switch_tree *dst,
 					const struct net_device *br);
 
 /* tag_8021q.c */
-int dsa_tag_8021q_bridge_join(struct dsa_switch *ds,
-			      struct dsa_notifier_bridge_info *info);
-int dsa_tag_8021q_bridge_leave(struct dsa_switch *ds,
-			       struct dsa_notifier_bridge_info *info);
 int dsa_switch_tag_8021q_vlan_add(struct dsa_switch *ds,
 				  struct dsa_notifier_tag_8021q_vlan_info *info);
 int dsa_switch_tag_8021q_vlan_del(struct dsa_switch *ds,
diff --git a/net/dsa/switch.c b/net/dsa/switch.c
index 0c2961cbc105..eb38beb10147 100644
--- a/net/dsa/switch.c
+++ b/net/dsa/switch.c
@@ -110,7 +110,7 @@ static int dsa_switch_bridge_join(struct dsa_switch *ds,
 			return err;
 	}
 
-	return dsa_tag_8021q_bridge_join(ds, info);
+	return 0;
 }
 
 static int dsa_switch_sync_vlan_filtering(struct dsa_switch *ds,
@@ -186,7 +186,7 @@ static int dsa_switch_bridge_leave(struct dsa_switch *ds,
 			return err;
 	}
 
-	return dsa_tag_8021q_bridge_leave(ds, info);
+	return 0;
 }
 
 /* Matches for all upstream-facing ports (the CPU port and all upstream-facing
diff --git a/net/dsa/tag_8021q.c b/net/dsa/tag_8021q.c
index 114f663332d0..c6555003f5df 100644
--- a/net/dsa/tag_8021q.c
+++ b/net/dsa/tag_8021q.c
@@ -110,6 +110,15 @@ int dsa_8021q_rx_source_port(u16 vid)
 }
 EXPORT_SYMBOL_GPL(dsa_8021q_rx_source_port);
 
+/* Returns the decoded VBID from the RX VID. */
+static int dsa_tag_8021q_rx_vbid(u16 vid)
+{
+	u16 vbid_hi = (vid & DSA_8021Q_VBID_HI_MASK) >> DSA_8021Q_VBID_HI_SHIFT;
+	u16 vbid_lo = (vid & DSA_8021Q_VBID_LO_MASK) >> DSA_8021Q_VBID_LO_SHIFT;
+
+	return (vbid_hi << 2) | vbid_lo;
+}
+
 bool vid_is_dsa_8021q_rxvlan(u16 vid)
 {
 	return (vid & DSA_8021Q_DIR_MASK) == DSA_8021Q_DIR_RX;
@@ -244,11 +253,17 @@ int dsa_switch_tag_8021q_vlan_add(struct dsa_switch *ds,
 			if (dsa_port_is_user(dp))
 				flags |= BRIDGE_VLAN_INFO_UNTAGGED;
 
+			/* Standalone VLANs are PVIDs */
 			if (vid_is_dsa_8021q_rxvlan(info->vid) &&
 			    dsa_8021q_rx_switch_id(info->vid) == ds->index &&
 			    dsa_8021q_rx_source_port(info->vid) == dp->index)
 				flags |= BRIDGE_VLAN_INFO_PVID;
 
+			/* And bridging VLANs are PVIDs too on user ports */
+			if (dsa_tag_8021q_rx_vbid(info->vid) &&
+			    dsa_port_is_user(dp))
+				flags |= BRIDGE_VLAN_INFO_PVID;
+
 			err = dsa_port_do_tag_8021q_vlan_add(dp, info->vid,
 							     flags);
 			if (err)
@@ -326,107 +341,52 @@ int dsa_switch_tag_8021q_vlan_del(struct dsa_switch *ds,
  * +-+-----+-+-----+-+-----+-+-----+-+    +-+-----+-+-----+-+-----+-+-----+-+
  *   swp0    swp1    swp2    swp3           swp0    swp1    swp2    swp3
  */
-static bool
-dsa_port_tag_8021q_bridge_match(struct dsa_port *dp,
-				struct dsa_notifier_bridge_info *info)
+int dsa_tag_8021q_bridge_join(struct dsa_switch *ds, int port,
+			      struct dsa_bridge bridge)
 {
-	/* Don't match on self */
-	if (dp->ds->dst->index == info->tree_index &&
-	    dp->ds->index == info->sw_index &&
-	    dp->index == info->port)
-		return false;
-
-	if (dsa_port_is_user(dp))
-		return dsa_port_offloads_bridge(dp, &info->bridge);
-
-	return false;
-}
-
-int dsa_tag_8021q_bridge_join(struct dsa_switch *ds,
-			      struct dsa_notifier_bridge_info *info)
-{
-	struct dsa_switch *targeted_ds;
-	struct dsa_port *targeted_dp;
-	struct dsa_port *dp;
-	u16 targeted_rx_vid;
+	struct dsa_port *dp = dsa_to_port(ds, port);
+	u16 standalone_vid, bridge_vid;
 	int err;
 
-	if (!ds->tag_8021q_ctx)
-		return 0;
-
-	targeted_ds = dsa_switch_find(info->tree_index, info->sw_index);
-	targeted_dp = dsa_to_port(targeted_ds, info->port);
-	targeted_rx_vid = dsa_tag_8021q_rx_vid(targeted_dp);
-
-	dsa_switch_for_each_port(dp, ds) {
-		u16 rx_vid = dsa_tag_8021q_rx_vid(dp);
-
-		if (!dsa_port_tag_8021q_bridge_match(dp, info))
-			continue;
+	/* Delete the standalone VLAN of the port and replace it with a
+	 * bridging VLAN
+	 */
+	standalone_vid = dsa_tag_8021q_rx_vid(dp);
+	bridge_vid = dsa_8021q_bridge_tx_fwd_offload_vid(bridge.num);
 
-		/* Install the RX VID of the targeted port in our VLAN table */
-		err = dsa_port_tag_8021q_vlan_add(dp, targeted_rx_vid, true);
-		if (err)
-			return err;
+	err = dsa_port_tag_8021q_vlan_add(dp, bridge_vid, true);
+	if (err)
+		return err;
 
-		/* Install our RX VID into the targeted port's VLAN table */
-		err = dsa_port_tag_8021q_vlan_add(targeted_dp, rx_vid, true);
-		if (err)
-			return err;
-	}
+	dsa_port_tag_8021q_vlan_del(dp, standalone_vid, false);
 
 	return 0;
 }
+EXPORT_SYMBOL_GPL(dsa_tag_8021q_bridge_join);
 
-int dsa_tag_8021q_bridge_leave(struct dsa_switch *ds,
-			       struct dsa_notifier_bridge_info *info)
+void dsa_tag_8021q_bridge_leave(struct dsa_switch *ds, int port,
+				struct dsa_bridge bridge)
 {
-	struct dsa_switch *targeted_ds;
-	struct dsa_port *targeted_dp;
-	struct dsa_port *dp;
-	u16 targeted_rx_vid;
-
-	if (!ds->tag_8021q_ctx)
-		return 0;
-
-	targeted_ds = dsa_switch_find(info->tree_index, info->sw_index);
-	targeted_dp = dsa_to_port(targeted_ds, info->port);
-	targeted_rx_vid = dsa_tag_8021q_rx_vid(targeted_dp);
-
-	dsa_switch_for_each_port(dp, ds) {
-		u16 rx_vid = dsa_tag_8021q_rx_vid(dp);
-
-		if (!dsa_port_tag_8021q_bridge_match(dp, info))
-			continue;
+	struct dsa_port *dp = dsa_to_port(ds, port);
+	u16 standalone_vid, bridge_vid;
+	int err;
 
-		/* Remove the RX VID of the targeted port from our VLAN table */
-		dsa_port_tag_8021q_vlan_del(dp, targeted_rx_vid, true);
+	/* Delete the bridging VLAN of the port and replace it with a
+	 * standalone VLAN
+	 */
+	standalone_vid = dsa_tag_8021q_rx_vid(dp);
+	bridge_vid = dsa_8021q_bridge_tx_fwd_offload_vid(bridge.num);
 
-		/* Remove our RX VID from the targeted port's VLAN table */
-		dsa_port_tag_8021q_vlan_del(targeted_dp, rx_vid, true);
+	err = dsa_port_tag_8021q_vlan_add(dp, standalone_vid, false);
+	if (err) {
+		dev_err(ds->dev,
+			"Failed to delete tag_8021q standalone VLAN %d from port %d: %pe\n",
+			standalone_vid, port, ERR_PTR(err));
 	}
 
-	return 0;
-}
-
-int dsa_tag_8021q_bridge_tx_fwd_offload(struct dsa_switch *ds, int port,
-					struct dsa_bridge bridge)
-{
-	u16 tx_vid = dsa_8021q_bridge_tx_fwd_offload_vid(bridge.num);
-
-	return dsa_port_tag_8021q_vlan_add(dsa_to_port(ds, port), tx_vid,
-					   true);
-}
-EXPORT_SYMBOL_GPL(dsa_tag_8021q_bridge_tx_fwd_offload);
-
-void dsa_tag_8021q_bridge_tx_fwd_unoffload(struct dsa_switch *ds, int port,
-					   struct dsa_bridge bridge)
-{
-	u16 tx_vid = dsa_8021q_bridge_tx_fwd_offload_vid(bridge.num);
-
-	dsa_port_tag_8021q_vlan_del(dsa_to_port(ds, port), tx_vid, true);
+	dsa_port_tag_8021q_vlan_del(dp, bridge_vid, true);
 }
-EXPORT_SYMBOL_GPL(dsa_tag_8021q_bridge_tx_fwd_unoffload);
+EXPORT_SYMBOL_GPL(dsa_tag_8021q_bridge_leave);
 
 /* Set up a port's tag_8021q RX and TX VLAN for standalone mode operation */
 static int dsa_tag_8021q_port_setup(struct dsa_switch *ds, int port)
-- 
2.25.1

