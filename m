Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 8E3803CFB37
	for <lists+netdev@lfdr.de>; Tue, 20 Jul 2021 15:52:29 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S239129AbhGTNLh (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 20 Jul 2021 09:11:37 -0400
Received: from mail-eopbgr10049.outbound.protection.outlook.com ([40.107.1.49]:24800
        "EHLO EUR02-HE1-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S239098AbhGTNHx (ORCPT <rfc822;netdev@vger.kernel.org>);
        Tue, 20 Jul 2021 09:07:53 -0400
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=PQOlzMNsimDmkUUEustYZ3zf8mnEauss32iL/oTrkpfrNhLAbB2HlkecsmOAVrP5fzE/e6AsPBaVIoLbWqnQGL6KsAYCpGtEj0ipDgRx3hjwaew67XhtSCM2BIq3o2S5QA2xtBivrBv32PGj9tVHTA/D6amgLD3pPlLIg5l0jJOR0hSasvDOw6EOtYlQ44LVL9I3iaBa3XLEKgO6ZGMRAkqpghBPAS0btfYKtocTaVF5dUg8vjGQm2Z7xTaX7YkfAfpjT7gWLy4BHcRgSbISBcMp0aQqwXEDZndt52dVVn4af4wd310j7ydkw7VDi+PDhMXhN3I8m6Z4eCww/2Js9w==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=GrxAjNxUmPWDlOsTBN6DS1y0wyzpGljlkA0E9o0nORw=;
 b=LARfdbrwY5uHEwwbRd9VqKgTEN1i/nHxK6jGMupVrx8GYeC70a0WeKOprFGVm0JrYY7StSONKFJRbPNQ2n66mc6c3ocoaBC/K4y2FWE7/20pfgt79uNI4kqw+lyPFrPkbKISx6DNWxGvGhr/I1ejBLFdfx65qsOYcqGJeVigo6NJc5f30A2C8OcqFS1Yen7Fcb0lSi6Z+cR/qGCbb22ZcGK3hYllV05Z+Iko3x2wXhtVlUBzIjIt0kuPpS8ac25sNztf7M08h6/JPADsgiOErU1/R8jZtnvX064XqDtNnwrScNpWKpHWP5O5bCfRMmOHP3+UZ2pfVhyEl4b0BHsapg==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=nxp.com; dmarc=pass action=none header.from=nxp.com; dkim=pass
 header.d=nxp.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=nxp.com; s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=GrxAjNxUmPWDlOsTBN6DS1y0wyzpGljlkA0E9o0nORw=;
 b=QCbkz5a8urqzDuItXXRn2a9Ue1Kq0Xs1ZjPZEy9jrxcp0qYc/DgaV6diEaTgwmT+olmjoZh3Ab7OTMhSp1vJzpgwrNdhPtjJ/qbjVWJG3FjUOfgw+a0uiis+2BAPlTXuNfNPGsNUbH6F9Qry5ue5VQC9PPRSFi2rX1P5uaKpqKA=
Authentication-Results: vger.kernel.org; dkim=none (message not signed)
 header.d=none;vger.kernel.org; dmarc=none action=none header.from=nxp.com;
Received: from VI1PR04MB5136.eurprd04.prod.outlook.com (2603:10a6:803:55::19)
 by VI1PR0402MB3551.eurprd04.prod.outlook.com (2603:10a6:803:a::11) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4331.29; Tue, 20 Jul
 2021 13:47:21 +0000
Received: from VI1PR04MB5136.eurprd04.prod.outlook.com
 ([fe80::109:1995:3e6b:5bd0]) by VI1PR04MB5136.eurprd04.prod.outlook.com
 ([fe80::109:1995:3e6b:5bd0%2]) with mapi id 15.20.4331.034; Tue, 20 Jul 2021
 13:47:21 +0000
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
        Grygorii Strashko <grygorii.strashko@ti.com>,
        Marek Behun <kabel@blackhole.sk>,
        DENG Qingfang <dqfext@gmail.com>
Subject: [PATCH v5 net-next 07/10] net: bridge: disambiguate offload_fwd_mark
Date:   Tue, 20 Jul 2021 16:46:52 +0300
Message-Id: <20210720134655.892334-8-vladimir.oltean@nxp.com>
X-Mailer: git-send-email 2.25.1
In-Reply-To: <20210720134655.892334-1-vladimir.oltean@nxp.com>
References: <20210720134655.892334-1-vladimir.oltean@nxp.com>
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-ClientProxiedBy: PR3P191CA0002.EURP191.PROD.OUTLOOK.COM
 (2603:10a6:102:54::7) To VI1PR04MB5136.eurprd04.prod.outlook.com
 (2603:10a6:803:55::19)
MIME-Version: 1.0
X-MS-Exchange-MessageSentRepresentingType: 1
Received: from localhost.localdomain (82.76.66.29) by PR3P191CA0002.EURP191.PROD.OUTLOOK.COM (2603:10a6:102:54::7) with Microsoft SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4242.19 via Frontend Transport; Tue, 20 Jul 2021 13:47:20 +0000
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: 1e9450d7-6570-429e-e725-08d94b84e5bd
X-MS-TrafficTypeDiagnostic: VI1PR0402MB3551:
X-Microsoft-Antispam-PRVS: <VI1PR0402MB355142CC3C357297EDA8E369E0E29@VI1PR0402MB3551.eurprd04.prod.outlook.com>
X-MS-Oob-TLC-OOBClassifiers: OLM:9508;
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: ioppDGAare6w/JcFnBpPkJTgOiqF/LZzEDJSFviKNBG8OyWUtXejLh2A+oz8vvpgef4YolzGAzuM5ScxCY8s2qsgTXmwzqTp9hnXzeScodefF2pwOXXMTxMXHXKtaYZs18gU2JHcdWm/tO0vjO/o6zlvyT+5RvDjM4j8cs4jDCo4soCCthsds1D1PFHYHC/Le+qOX2kNAZJMYpR24SNxSJp2FYX5m/rWylnHTSv8keOrWuYht9n25KG2BwoSV/wY3CCf2otC8Mpy2MAJ3HceyXMoLh2kdcnlTtfBqy+XhxvUEHXnq17OWTY3Jx3VDF4HL7goPxVgrmK9K91f4ySC/1bMpC/HcoMil8u4snsxSbYd74Lgonh/WS24JTd8854kVKZaOpqPgvGleExxDhhvRA3w/WHE/bNFXE3U1/t5Gxeu52S/EltH6oW32xJM2iBi57FJliUB+I7VJW2c6WfWMmX/QQ5IYBhLvN78FGWO9dWwNTVT1Ca+VaznvnnZeDPbATqooOYY/hXFVtEVvx9rkMglMQtobRtUgvfoSmV+olfkT3Dj2O1p5MKZsnpptNzA2dKt3TO9G6tLEaXvVXLLST5S6fdL6FpDeVwGj6Bz0SO1ZSyjIvmCTJxwbcH2M8MBIPq50YEon/SpQgUXf2hz9Stvmt5eOxdrDjJmPrr6LhIrq5WHnyB/WcHTA/FplQAefBpdlUUj3WGQdH+ibL1sGQ==
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:VI1PR04MB5136.eurprd04.prod.outlook.com;PTR:;CAT:NONE;SFS:(4636009)(376002)(346002)(39860400002)(396003)(136003)(366004)(478600001)(44832011)(316002)(38100700002)(2616005)(956004)(5660300002)(6486002)(54906003)(1076003)(38350700002)(2906002)(66946007)(6512007)(7416002)(110136005)(86362001)(83380400001)(66476007)(8936002)(186003)(4326008)(66556008)(6506007)(6666004)(26005)(36756003)(8676002)(52116002);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?us-ascii?Q?xA/xCdq6+JMN+9LY+Rk5TAPyN0N40r5ifWQEq0xjPLgPhEeEbt0kiRrTk754?=
 =?us-ascii?Q?JjjxeMjVhZ4CViSDYyXPsGU3zvza8+bo+Zeu1qEUozFbotxkdiTuEZzE9774?=
 =?us-ascii?Q?a/S1tS/HA+Ad5+HnZeaV2E4JkI5hrf9vGL9WXJi73DJxgKekAXeo0123ZHlE?=
 =?us-ascii?Q?5nDtRDVow1ikwq+WBffg/r9mq08dnzaDeS6dOnYqEE9N+D/x3qmpOSmzTYWz?=
 =?us-ascii?Q?vjtph5yUdsltusPXhapcL990q52ag/dcsKX/t2q87s6aEZUuCayFapFoZdvB?=
 =?us-ascii?Q?H6tHhPodOlZJEmav/lrTLfLul5QqmiT/B1cqCzx6LqknBUJpU4jXXCUZ+zq8?=
 =?us-ascii?Q?KwVSw58doC4dgGPCAv18DpmscFveoJVxrN5H/3VHZWdQPjjdHM3i/iSLvefF?=
 =?us-ascii?Q?jtT7QfBxcF3O+hcDY+uRKa5tieTsvBxVmq/2hTOMIFqfT1sD1rn6aKWGYOUx?=
 =?us-ascii?Q?HyNuJj6IctI9W7/Yudh6D3WsI5wY1FK8Ml9BbslO1jEmHo+2yeGXL4jpZxoY?=
 =?us-ascii?Q?hlheiXuMiNH64pGh81Ni7v4DQoC5H8CELKfp1b1yCsK9h7g80M0c4wcI0V83?=
 =?us-ascii?Q?0rPUGZT1ki05sVSBk1eQK+Px+mQsISWKGyCubIM76SUfWjRzipyoFU/BM1yT?=
 =?us-ascii?Q?KW+ALug5Qt4jMuZR5QPRp08zPIkvVzHTO5KHWHNbNRF9d2VV6yrm/iwH1s01?=
 =?us-ascii?Q?L7rAezGhST2mKZfWBgcoKzjOsGMqsB7OnDKUEVXqz/Pk6KzJwYG+UOOySbF0?=
 =?us-ascii?Q?ojWMex9ELom68LWde/CkL4nrXXBTqisoUkvvny2Cpp/nmDmBO2Cvlbl/PCjs?=
 =?us-ascii?Q?AWwfKj17aO7to9jnmmTuzQaMnFQJJ7jKCvGLtfNPl6ApVpzuNPZjdxHh5c02?=
 =?us-ascii?Q?knCs0cvykQBdIMvTzQlS7LKJL/Lig0aubfS1j8RcDR0GzzqJ+peip2jJWdVW?=
 =?us-ascii?Q?UjeKqmxqgKu1bMnpldH3uvF1maOqzH/EMP/3k5vi0RG5iC2xxuoauby2RJug?=
 =?us-ascii?Q?LzvXFSeD86egbGUqqVPkvbZtXKwCRrSOxxTYHm1MURkIi70CjVeKXxZlBpIR?=
 =?us-ascii?Q?8Pi+/H0oJeB9XbF54aBfnkah8J56GaSyMBF3I1rwntWUPkX+q+6WQefHDbJn?=
 =?us-ascii?Q?DQiJo4FA7iIKmhGhm4MhckTFY9L/ru21iaR6ev2Zw/Yjccz+XHD8Pz1kShze?=
 =?us-ascii?Q?mkpAfN49VKbJoMTWyy1FKehPXKAL5xmm5Fi6B9YqHBMxMs2yVtzlcApDSPrg?=
 =?us-ascii?Q?sb3YOirJNm0qcr9OHqhE3La93GYRmj4kv4cj64QXsuogAOeK5lOHmmvZLn9B?=
 =?us-ascii?Q?UGbUX1x9oBqc7Mm2WadkpUks?=
X-OriginatorOrg: nxp.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 1e9450d7-6570-429e-e725-08d94b84e5bd
X-MS-Exchange-CrossTenant-AuthSource: VI1PR04MB5136.eurprd04.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 20 Jul 2021 13:47:21.3509
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 686ea1d3-bc2b-4c6f-a92c-d99c5c301635
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: Of3Aid9bl1/iocEnOtQxYHXt5tmgQfX2qwT0YsqWmHWNQMeLuf572CnjZsPK8MHnE4t43y9QqJQ3FUVEGospYQ==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: VI1PR0402MB3551
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Tobias Waldekranz <tobias@waldekranz.com>

Before this change, four related - but distinct - concepts where named
offload_fwd_mark:

- skb->offload_fwd_mark: Set by the switchdev driver if the underlying
  hardware has already forwarded this frame to the other ports in the
  same hardware domain.

- nbp->offload_fwd_mark: An idetifier used to group ports that share
  the same hardware forwarding domain.

- br->offload_fwd_mark: Counter used to make sure that unique IDs are
  used in cases where a bridge contains ports from multiple hardware
  domains.

- skb->cb->offload_fwd_mark: The hardware domain on which the frame
  ingressed and was forwarded.

Introduce the term "hardware forwarding domain" ("hwdom") in the
bridge to denote a set of ports with the following property:

    If an skb with skb->offload_fwd_mark set, is received on a port
    belonging to hwdom N, that frame has already been forwarded to all
    other ports in hwdom N.

By decoupling the name from "offload_fwd_mark", we can extend the
term's definition in the future - e.g. to add constraints that
describe expected egress behavior - without overloading the meaning of
"offload_fwd_mark".

- nbp->offload_fwd_mark thus becomes nbp->hwdom.

- br->offload_fwd_mark becomes br->last_hwdom.

- skb->cb->offload_fwd_mark becomes skb->cb->src_hwdom. The slight
  change in naming here mandates a slight change in behavior of the
  nbp_switchdev_frame_mark() function. Previously, it only set this
  value in skb->cb for packets with skb->offload_fwd_mark true (ones
  which were forwarded in hardware). Whereas now we always track the
  incoming hwdom for all packets coming from a switchdev (even for the
  packets which weren't forwarded in hardware, such as STP BPDUs, IGMP
  reports etc). As all uses of skb->cb->offload_fwd_mark were already
  gated behind checks of skb->offload_fwd_mark, this will not introduce
  any functional change, but it paves the way for future changes where
  the ingressing hwdom must be known for frames coming from a switchdev
  regardless of whether they were forwarded in hardware or not
  (basically, if the skb comes from a switchdev, skb->cb->src_hwdom now
  always tracks which one).

  A typical example where this is relevant: the switchdev has a fixed
  configuration to trap STP BPDUs, but STP is not running on the bridge
  and the group_fwd_mask allows them to be forwarded. Say we have this
  setup:

        br0
       / | \
      /  |  \
  swp0 swp1 swp2

  A BPDU comes in on swp0 and is trapped to the CPU; the driver does not
  set skb->offload_fwd_mark. The bridge determines that the frame should
  be forwarded to swp{1,2}. It is imperative that forward offloading is
  _not_ allowed in this case, as the source hwdom is already "poisoned".

  Recording the source hwdom allows this case to be handled properly.

v2->v3: added code comments
v3->v5: none

Signed-off-by: Tobias Waldekranz <tobias@waldekranz.com>
Signed-off-by: Vladimir Oltean <vladimir.oltean@nxp.com>
Reviewed-by: Grygorii Strashko <grygorii.strashko@ti.com>
Reviewed-by: Florian Fainelli <f.fainelli@gmail.com>
---
 net/bridge/br_if.c        |  2 +-
 net/bridge/br_private.h   | 21 ++++++++++++++++-----
 net/bridge/br_switchdev.c | 16 ++++++++--------
 3 files changed, 25 insertions(+), 14 deletions(-)

diff --git a/net/bridge/br_if.c b/net/bridge/br_if.c
index 6e4a32354a13..838a277e3cf7 100644
--- a/net/bridge/br_if.c
+++ b/net/bridge/br_if.c
@@ -643,7 +643,7 @@ int br_add_if(struct net_bridge *br, struct net_device *dev,
 	if (err)
 		goto err5;
 
-	err = nbp_switchdev_mark_set(p);
+	err = nbp_switchdev_hwdom_set(p);
 	if (err)
 		goto err6;
 
diff --git a/net/bridge/br_private.h b/net/bridge/br_private.h
index 2b48b204205e..54e29a8576a1 100644
--- a/net/bridge/br_private.h
+++ b/net/bridge/br_private.h
@@ -329,7 +329,10 @@ struct net_bridge_port {
 	struct netpoll			*np;
 #endif
 #ifdef CONFIG_NET_SWITCHDEV
-	int				offload_fwd_mark;
+	/* Identifier used to group ports that share the same switchdev
+	 * hardware domain.
+	 */
+	int				hwdom;
 #endif
 	u16				group_fwd_mask;
 	u16				backup_redirected_cnt;
@@ -476,7 +479,10 @@ struct net_bridge {
 	u32				auto_cnt;
 
 #ifdef CONFIG_NET_SWITCHDEV
-	int offload_fwd_mark;
+	/* Counter used to make sure that hardware domains get unique
+	 * identifiers in case a bridge spans multiple switchdev instances.
+	 */
+	int				last_hwdom;
 #endif
 	struct hlist_head		fdb_list;
 
@@ -506,7 +512,12 @@ struct br_input_skb_cb {
 #endif
 
 #ifdef CONFIG_NET_SWITCHDEV
-	int offload_fwd_mark;
+	/* The switchdev hardware domain from which this packet was received.
+	 * If skb->offload_fwd_mark was set, then this packet was already
+	 * forwarded by hardware to the other ports in the source hardware
+	 * domain, otherwise it wasn't.
+	 */
+	int src_hwdom;
 #endif
 };
 
@@ -1645,7 +1656,7 @@ static inline void br_sysfs_delbr(struct net_device *dev) { return; }
 
 /* br_switchdev.c */
 #ifdef CONFIG_NET_SWITCHDEV
-int nbp_switchdev_mark_set(struct net_bridge_port *p);
+int nbp_switchdev_hwdom_set(struct net_bridge_port *p);
 void nbp_switchdev_frame_mark(const struct net_bridge_port *p,
 			      struct sk_buff *skb);
 bool nbp_switchdev_allowed_egress(const struct net_bridge_port *p,
@@ -1665,7 +1676,7 @@ static inline void br_switchdev_frame_unmark(struct sk_buff *skb)
 	skb->offload_fwd_mark = 0;
 }
 #else
-static inline int nbp_switchdev_mark_set(struct net_bridge_port *p)
+static inline int nbp_switchdev_hwdom_set(struct net_bridge_port *p)
 {
 	return 0;
 }
diff --git a/net/bridge/br_switchdev.c b/net/bridge/br_switchdev.c
index d3adee0f91f9..833fd30482c2 100644
--- a/net/bridge/br_switchdev.c
+++ b/net/bridge/br_switchdev.c
@@ -8,20 +8,20 @@
 
 #include "br_private.h"
 
-static int br_switchdev_mark_get(struct net_bridge *br, struct net_device *dev)
+static int br_switchdev_hwdom_get(struct net_bridge *br, struct net_device *dev)
 {
 	struct net_bridge_port *p;
 
 	/* dev is yet to be added to the port list. */
 	list_for_each_entry(p, &br->port_list, list) {
 		if (netdev_port_same_parent_id(dev, p->dev))
-			return p->offload_fwd_mark;
+			return p->hwdom;
 	}
 
-	return ++br->offload_fwd_mark;
+	return ++br->last_hwdom;
 }
 
-int nbp_switchdev_mark_set(struct net_bridge_port *p)
+int nbp_switchdev_hwdom_set(struct net_bridge_port *p)
 {
 	struct netdev_phys_item_id ppid = { };
 	int err;
@@ -35,7 +35,7 @@ int nbp_switchdev_mark_set(struct net_bridge_port *p)
 		return err;
 	}
 
-	p->offload_fwd_mark = br_switchdev_mark_get(p->br, p->dev);
+	p->hwdom = br_switchdev_hwdom_get(p->br, p->dev);
 
 	return 0;
 }
@@ -43,15 +43,15 @@ int nbp_switchdev_mark_set(struct net_bridge_port *p)
 void nbp_switchdev_frame_mark(const struct net_bridge_port *p,
 			      struct sk_buff *skb)
 {
-	if (skb->offload_fwd_mark && !WARN_ON_ONCE(!p->offload_fwd_mark))
-		BR_INPUT_SKB_CB(skb)->offload_fwd_mark = p->offload_fwd_mark;
+	if (p->hwdom)
+		BR_INPUT_SKB_CB(skb)->src_hwdom = p->hwdom;
 }
 
 bool nbp_switchdev_allowed_egress(const struct net_bridge_port *p,
 				  const struct sk_buff *skb)
 {
 	return !skb->offload_fwd_mark ||
-	       BR_INPUT_SKB_CB(skb)->offload_fwd_mark != p->offload_fwd_mark;
+	       BR_INPUT_SKB_CB(skb)->src_hwdom != p->hwdom;
 }
 
 /* Flags that can be offloaded to hardware */
-- 
2.25.1

