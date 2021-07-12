Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 8ED1B3C5F0F
	for <lists+netdev@lfdr.de>; Mon, 12 Jul 2021 17:22:28 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S235479AbhGLPZL (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 12 Jul 2021 11:25:11 -0400
Received: from mail-am6eur05on2085.outbound.protection.outlook.com ([40.107.22.85]:46304
        "EHLO EUR05-AM6-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S235436AbhGLPZJ (ORCPT <rfc822;netdev@vger.kernel.org>);
        Mon, 12 Jul 2021 11:25:09 -0400
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=GxIzXJbjc0GPkAgOdUbxz9vdtkkt6vdllLzIDHfmA7azJHag5ez+OV1hXRTlhHfDxmbxrPOaxOmbvZWDIHhuwR2Ko5UCa4XMapdN7GnLgN9OdXnhf67Qj0FFJrF+kDRyJiSiEGgfAVgBY5+c0TVBHh3odaXyHfRnVvKHVj6JK6KLmHQ7CTxrKvHLaNaxGFVmDUQfNXPQDWr3o8r0ARKz8CB2xZpNNwOJT/05RZhdFHo/Emgo2ZLb5WCsqmvTPGD/ChhTw5fF7Ft/7COIDjQYIIL8+QdyD6mbtid1ULXwdsQVStqYNsEZq3iQRdpxAOg5CdSpYWp778zQGIh4UiAmUA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=Fah/36WJB2qs/NHM3EDdImIAEJ4LXQoiVhitZdwMBmw=;
 b=bqzY4GoKrQn5d3Hwucm0aRrwawXtx4EWUBwhCu8wyrXZRFaki9JFLmv4737OZVo9ogsJlxYtPR9ECdVnLJAN85ZsIKobx1DMlthDrlqz58exNV1wt8DtZvVZ33haSv8jeedsXfAIheskTiuG6qUzKdzKwvAFMgBeux16dmkBtdv8Xka/AFW+FyLk3KflTnv8W5rkj70o1iqse6K6HyPiB98waSOGUlOTVapWFBPZJoOZ0cKs2DZqqOnlVKeQiYhaJAqox9GTf15ghnhuX4soBNBjfr5bt+S+0GOzae6zTsD982bUkEKdw8e+Mr8NPjY3TNNu7FxsUSNBzkUQZOVfDA==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=nxp.com; dmarc=pass action=none header.from=nxp.com; dkim=pass
 header.d=nxp.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=nxp.com; s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=Fah/36WJB2qs/NHM3EDdImIAEJ4LXQoiVhitZdwMBmw=;
 b=YkFi4MLDBk1odrQGKjWl8BvIKKHndC+S48KAvZQGU1fCTp89ijosLqJVRDq+a660CaUCwlQRL7B/kl2DKwADdswrcGP+piuc+rr/vtAczfD4gBFvJiKIq2hRbnpQJDAe2bRRj/vrNUzz0CZZ5zJ6xvK3cv6BP3ERf2AtYAroCak=
Authentication-Results: vger.kernel.org; dkim=none (message not signed)
 header.d=none;vger.kernel.org; dmarc=none action=none header.from=nxp.com;
Received: from VI1PR04MB5136.eurprd04.prod.outlook.com (2603:10a6:803:55::19)
 by VI1PR04MB6271.eurprd04.prod.outlook.com (2603:10a6:803:f7::23) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4308.20; Mon, 12 Jul
 2021 15:22:16 +0000
Received: from VI1PR04MB5136.eurprd04.prod.outlook.com
 ([fe80::b1a0:d654:a578:53ab]) by VI1PR04MB5136.eurprd04.prod.outlook.com
 ([fe80::b1a0:d654:a578:53ab%7]) with mapi id 15.20.4308.026; Mon, 12 Jul 2021
 15:22:16 +0000
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
        Grygorii Strashko <grygorii.strashko@ti.com>
Subject: [RFC PATCH v3 net-next 07/24] net: bridge: disambiguate offload_fwd_mark
Date:   Mon, 12 Jul 2021 18:21:25 +0300
Message-Id: <20210712152142.800651-8-vladimir.oltean@nxp.com>
X-Mailer: git-send-email 2.25.1
In-Reply-To: <20210712152142.800651-1-vladimir.oltean@nxp.com>
References: <20210712152142.800651-1-vladimir.oltean@nxp.com>
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-ClientProxiedBy: AM4PR0101CA0058.eurprd01.prod.exchangelabs.com
 (2603:10a6:200:41::26) To VI1PR04MB5136.eurprd04.prod.outlook.com
 (2603:10a6:803:55::19)
MIME-Version: 1.0
X-MS-Exchange-MessageSentRepresentingType: 1
Received: from localhost.localdomain (82.76.66.29) by AM4PR0101CA0058.eurprd01.prod.exchangelabs.com (2603:10a6:200:41::26) with Microsoft SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4308.20 via Frontend Transport; Mon, 12 Jul 2021 15:22:15 +0000
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: 34a17b79-3204-4241-8253-08d94548d4f6
X-MS-TrafficTypeDiagnostic: VI1PR04MB6271:
X-Microsoft-Antispam-PRVS: <VI1PR04MB62710F39F65D77B64B0CF163E0159@VI1PR04MB6271.eurprd04.prod.outlook.com>
X-MS-Oob-TLC-OOBClassifiers: OLM:9508;
X-MS-Exchange-SenderADCheck: 1
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: mHu5U7nXHBrdlu00Q0rKd3Y/DOy2hf/WPHMsU5jrCDIdZtIb0RKMQZjb4VXqbMRqbqEyywv22GLsnDpbfMDwf3GC/wq484ZBXzYqReM57VQeubcN35u4aVLtTP8WCDLE6yBO7osNtlD0DudxDMbW0PNOBT4EAauhztEarTgbSVr8MgEal6+gY2SSeCDIbAAyugrozpje2v3l6SVc8h5FDPLzWRKioJFUk0Ea33wJKpw2F3qqIHJyVL0HJHoGsgsPj9KUC/Jgia9XJD/KvWcAlWpn4lqwGb0dJ9EA9ysXsNzEPss9gb62nzc4ZCXbczyEgokmS8AKnWh4cII7lNDtebaxvxDg9/ItkAHA02zC8+LpcK8/9rE3Qt306yY8/uiHXrB0WtuGC6X0h6ccAT/dd41MCsoH1uDUayalWhDwUI6XK/PlnyioFKCPF9av+B7IdcAiaOUOQ+1IOnFcFxLaGQ+0tDfW3tWyq7CIrOA6PqlMd31K/3HPCpVLvdwtuqsoUlC5FUtB6o3tONXrfN38O+3/Q9RM3pW5V6Vdg04P6AR4f3g1zKJPgGXPaP0NffPnfY4xomkaaxCl/pxKEtPdg60Oz6jq06+ulTvu8zY01m79d2vfXLtlxyIpdudyjtSSDwi1Tro80ZJ/KRlXloClZBb56hXKUGJ1SNKdXSiG/3hS1PHWLKtG+0/VOOK1q4nbdLo0AsIg+0uWVT6ZsIEc2w==
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:VI1PR04MB5136.eurprd04.prod.outlook.com;PTR:;CAT:NONE;SFS:(4636009)(376002)(136003)(39850400004)(396003)(346002)(366004)(26005)(2906002)(66476007)(6666004)(83380400001)(66556008)(38100700002)(8676002)(38350700002)(66946007)(5660300002)(4326008)(54906003)(52116002)(7416002)(1076003)(110136005)(6506007)(316002)(86362001)(44832011)(478600001)(2616005)(956004)(6486002)(8936002)(36756003)(186003)(6512007);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?us-ascii?Q?f6YViTM7S7jj7dtR11h/PmeYlxrFrYmVitBDiwZPEcyNlggU2BOOyrFgtf2Q?=
 =?us-ascii?Q?twosQR20Bbdk+9n34Q7Egm+hgAJY5huNM7cD3dRlTk1NWkguyTU/cP+wtFoW?=
 =?us-ascii?Q?KNvC/P+11aWgOuw6nayFSEAYjfkwMEdnGGpB7riAfvMOkgha7WsJAxec5SsC?=
 =?us-ascii?Q?Ss/t6TDf/JpiAz2DRd0HgmCsnXbFVlGx8yhU2oX05t81Vmh4GHq8nikh7F1k?=
 =?us-ascii?Q?d7h09ezW/pCdwLxPr75ceFTp2tsTjLWu3ZqeMy4stuSzDOot9uLf01W3HYa/?=
 =?us-ascii?Q?1MSmQw9uDAJyscMMlDu1yooAMG4fs6d3t4zxI3pvLzqbn+hsFhhBHbnVwNh2?=
 =?us-ascii?Q?OK7psp8yPwwDBmBURuamguc+/QeLyxKVhe4gscj/Uiu383r9iElNptrhZlH3?=
 =?us-ascii?Q?pDJC62CtNTDppzbgb64SJ+HN57BHYNMSiEEeRgQBOi1tvykAFZJKdme4AfhS?=
 =?us-ascii?Q?mtzyAFtPsfxjJAmj3D7E99ktZsm0zvahcQJ9eqDPsRyEkPpQn+fTAOXTh9P+?=
 =?us-ascii?Q?SOfbfrLUPcX2utLRhaOqoINWwA6SF/MrlG9caucRVe83ak9M8eSet7JPc6Sk?=
 =?us-ascii?Q?0eU6pdHlvcNyF3SYi9UsGG9qYihwC5z0Do86np2L4rqowPPmeFC3zwr5JxXq?=
 =?us-ascii?Q?yCZv0tdqotPfaM7b6LybovUk2SvU7+fO+P+9/QvVi5foDXc2oa076sm4poax?=
 =?us-ascii?Q?roqnibesQEWxpS8aneuyA9hrdOXd9/iIMvfX6HwKIPX5LB19DV1+vpd/EBoW?=
 =?us-ascii?Q?Y482raX1eYUy7Cwko5xV+aMBS+hENppFkjkbsAu1dZoHZ6VZtQCZbweBY90v?=
 =?us-ascii?Q?9RqP1JwAnZZYgkxnJgWpFpSidydXc1PLw2FooKWRlXOYaDx/EEtI1HX9fHzZ?=
 =?us-ascii?Q?w6J2hfQ0DnLcfr7OtraG6S/d6R8hzxEBijhNiGlY8e4K08RkdM5PhFsbJxT6?=
 =?us-ascii?Q?DNdIEifJZMCFIr/q0LFSEKRhUZ3vxbarlKUMOLdFD5t8ODjiXNO+f2YZaTek?=
 =?us-ascii?Q?ESRXy8iNiICoCN432wErXE7tJNRhIB5TxgVbFZsgzRvZ9fcIUKZgirUSDC1q?=
 =?us-ascii?Q?vLDrVuYB4mjonZT6ZudM49yrkq/Aki/IAhVabyqlJT3l0qvkTj+lpdQb3spb?=
 =?us-ascii?Q?woLQznZYqKWhEspD7EfB61u9wU567IhCfKBGqsx+EZRrxBl+wWPQdnIF/4y+?=
 =?us-ascii?Q?n+NMhFlGuWJc7j4CHxoj6uLdHcw0fqd+o/QMbIAY5rSRvc2VowMDaRWIQMfr?=
 =?us-ascii?Q?jdI+peWcHkW2y1Dv5DV4Q2w8+HDSI0WOG1Nzt0zGGkItyZsFTMVuetTspl/L?=
 =?us-ascii?Q?P7y5ubHOqK4YuP1PgO9du/70?=
X-OriginatorOrg: nxp.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 34a17b79-3204-4241-8253-08d94548d4f6
X-MS-Exchange-CrossTenant-AuthSource: VI1PR04MB5136.eurprd04.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 12 Jul 2021 15:22:16.4531
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 686ea1d3-bc2b-4c6f-a92c-d99c5c301635
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: Dgwgmg0hNqi9Y7p6lWKyGj60wcIXo+ELOUTHQmjEPAOqOF0CSvlQbSX30VHB6py4c/NL1oJ8CrdzJ0RQlSKOIQ==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: VI1PR04MB6271
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

Signed-off-by: Tobias Waldekranz <tobias@waldekranz.com>
Signed-off-by: Vladimir Oltean <vladimir.oltean@nxp.com>
Reviewed-by: Grygorii Strashko <grygorii.strashko@ti.com>
---
 net/bridge/br_if.c        |  2 +-
 net/bridge/br_private.h   | 21 ++++++++++++++++-----
 net/bridge/br_switchdev.c | 16 ++++++++--------
 3 files changed, 25 insertions(+), 14 deletions(-)

diff --git a/net/bridge/br_if.c b/net/bridge/br_if.c
index f7d2f472ae24..73fa703f8df5 100644
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

