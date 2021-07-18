Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id A748C3CCB22
	for <lists+netdev@lfdr.de>; Sun, 18 Jul 2021 23:47:11 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233532AbhGRVtc (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sun, 18 Jul 2021 17:49:32 -0400
Received: from mail-eopbgr140071.outbound.protection.outlook.com ([40.107.14.71]:24552
        "EHLO EUR01-VE1-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S233563AbhGRVtV (ORCPT <rfc822;netdev@vger.kernel.org>);
        Sun, 18 Jul 2021 17:49:21 -0400
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=k5F4iCkDN7Pl+5Bym9gNYlO2YmFfBVJXYrA1WGFerUq6N4G7x5Xf8cD4dg+evlJMIyVuvKOK8b3a0hMgQEBlv+XaPk++6BOpC7zq7mSsUczmk6d3NGaMzpys3g8+C/5dUHvqvppn1NtVIR5Nj+prtUQIdh4fse2gZSVupahyPJoxmURAlnG3ECMuY67hlFsdQohyCsAt+JenzlxuO7lm3xXutq62nHCWWgpb2n9Hcdx90Ia4QlvN4ed9raCA0OZWJgx5RaBSPYGGY2h4CUlZVxlj9Sv7Twlpi/tX8NbNVClC750cL+792gXrwL3qM5LqObVqy1NCceItPcCSQzr2/Q==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=ukqt+HYE9y3YrhYVbgPeu9XqvAiMT26ki+ee7+B7mZo=;
 b=JBtpgPJPgD4TwUYsgwsUU4mRQss2vWa64x/Y1rKMs1p4lLwovKVzTU22yTf2h4jXwuwmFeYSMtm7scty9Wl3pltSwGDhxZnLNL7EzZsATBeYsswLJCsGxaXvUqyfY9G+NhU/Yf8ZSpGA4+Eh7T+b+QasAkKOAfZvTQaXkhB28ZXdRNfsg5HV7m9nnJfxjBfyDvNoCi0vv/+G4awQ+mGGYPRaFaEKkx6nadA//RGQlexTwU+Fr0K6jVgCEmPbIfH5+n/NKb7XcsvTvmMIC18xDcIx7wjPZVGSUdmgxPvh8D9imF3zX2Kj/OjHuk7z6bMVetPCYJZ9l5uSV4DDAZLkhw==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=nxp.com; dmarc=pass action=none header.from=nxp.com; dkim=pass
 header.d=nxp.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=nxp.com; s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=ukqt+HYE9y3YrhYVbgPeu9XqvAiMT26ki+ee7+B7mZo=;
 b=C5yQVYk8ZUGEzr6g5mZJtBJwhQw1jS4JhtiTSqqTwcRndZeqvRS92wxgtNs53wR2IguWw1UDrDhmLHV9QjFEqvAgpduTfv+BQbmvCfUlLsTBZcqZ2trpjLSwIx3sOo+oo0IUgRHYySBMFHkCyZV/xuOclQU4qVNlMt0vEFnum0s=
Authentication-Results: vger.kernel.org; dkim=none (message not signed)
 header.d=none;vger.kernel.org; dmarc=none action=none header.from=nxp.com;
Received: from VI1PR04MB5136.eurprd04.prod.outlook.com (2603:10a6:803:55::19)
 by VE1PR04MB7325.eurprd04.prod.outlook.com (2603:10a6:800:1af::14) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4331.29; Sun, 18 Jul
 2021 21:46:15 +0000
Received: from VI1PR04MB5136.eurprd04.prod.outlook.com
 ([fe80::109:1995:3e6b:5bd0]) by VI1PR04MB5136.eurprd04.prod.outlook.com
 ([fe80::109:1995:3e6b:5bd0%2]) with mapi id 15.20.4331.032; Sun, 18 Jul 2021
 21:46:15 +0000
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
Subject: [PATCH v4 net-next 07/15] net: bridge: disambiguate offload_fwd_mark
Date:   Mon, 19 Jul 2021 00:44:26 +0300
Message-Id: <20210718214434.3938850-8-vladimir.oltean@nxp.com>
X-Mailer: git-send-email 2.25.1
In-Reply-To: <20210718214434.3938850-1-vladimir.oltean@nxp.com>
References: <20210718214434.3938850-1-vladimir.oltean@nxp.com>
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-ClientProxiedBy: VI1PR0602CA0014.eurprd06.prod.outlook.com
 (2603:10a6:800:bc::24) To VI1PR04MB5136.eurprd04.prod.outlook.com
 (2603:10a6:803:55::19)
MIME-Version: 1.0
X-MS-Exchange-MessageSentRepresentingType: 1
Received: from localhost.localdomain (82.76.66.29) by VI1PR0602CA0014.eurprd06.prod.outlook.com (2603:10a6:800:bc::24) with Microsoft SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4331.21 via Frontend Transport; Sun, 18 Jul 2021 21:46:15 +0000
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: a3244e93-b4fd-4791-0b41-08d94a3577f3
X-MS-TrafficTypeDiagnostic: VE1PR04MB7325:
X-Microsoft-Antispam-PRVS: <VE1PR04MB73251FECDEBF53B84A4F94A9E0E09@VE1PR04MB7325.eurprd04.prod.outlook.com>
X-MS-Oob-TLC-OOBClassifiers: OLM:9508;
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: 1k5sTX0Im410TAeeUhtCV/toaqeBIYIMhaHuIDuNR7LuaWAIt49x0aOOiADG8RKdk4TWcEybZP+ccJPXOro7xZnZ5WNVCBdaTfbaLtz1afA92MjgTtr7fKIns8magHu8dgYhSozvty45C36/DC8X+xdUOTYnt2MiIaQI5DER5MM5eYIvRuow+AkXkC8bccQ5vpJ+OmMIe4c14/cnLQhmriV1NeGKdUbilprmS4gVnvbGvNGUnGnsI0CqOHXOHQ70T542hGwXcnaAsohN73qfPj476wX2XW/T0UwskDv2t2r+bfKN28e5b64fbtjbbXW5pTwakb3zAmyZc9dMK5HNtmzRPCLoSE6wHYyzF8dwWHFtIL269r4UFMK1HysP6TwV3Jlfpqt1YKMKct2S8dlIBeOTU7Uyh/wI2hMc2/mwiOUfuj4i+EuzINSTdzJMYno+m1ppTt8oIDjq16gyKI9ftfHq50mu1kVW01RUPrxszOfYc19WxSQ8KcrmMN/jWEL+rY5lYgUs0kN1PuJUYnX5a08HCV1MSCyxSnJxOeCnhqBsZJoS4AF10XzhcXn/bXAHiKRcIR81bPVxkhQg9glf5g3h6cabLcGbe8fM8m7x3kuRXw0DzVMJBooJ/NyVVzlqYwygVbNw4ZbTG6snnRzo9wQYJjflOct8+JsCJXhiCJekY6YFFvRk1ON8QRkAnSKLQTJxvGuwW+VQaEfyFcMuMg==
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:VI1PR04MB5136.eurprd04.prod.outlook.com;PTR:;CAT:NONE;SFS:(4636009)(376002)(136003)(396003)(366004)(39850400004)(346002)(6666004)(110136005)(8936002)(6506007)(8676002)(86362001)(54906003)(186003)(26005)(66946007)(66556008)(83380400001)(66476007)(52116002)(2906002)(1076003)(316002)(7416002)(5660300002)(478600001)(36756003)(6512007)(6486002)(44832011)(4326008)(956004)(38350700002)(2616005)(38100700002);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?us-ascii?Q?09AeLBIf1izISDKtyDSD+Vyr5X7DUs6b7/+3dLKvoWtQjZiC1qL+Pve2KAKm?=
 =?us-ascii?Q?IMm0HMMpYjDe6bAtxQ3rS3/JJFE7iwFTGBYAKBpYMY0LQnAtxErQqUS0sLnU?=
 =?us-ascii?Q?6GCaELSNny+TRCXshbS4aW+xckdCqcvNxp22al9CcxZSfUa2pEsXhsVTaz1V?=
 =?us-ascii?Q?zMWAiBC3NGvULX7WS4vE3hYVLjkZ3LZXX1tdL1T/Gs8KH1S45EpwAuFhxn+h?=
 =?us-ascii?Q?/TfSyEZpuiyTqb4J8wwA3li22GoIcnJBRYO+9VsePwlH9T1ptkSQibCZHO6b?=
 =?us-ascii?Q?qc+tGeGjaILdyzX2lqrUWFGpd4G4IaOY1Q8MCdV4D1tXOC5Sx2HY4hkdQa1l?=
 =?us-ascii?Q?8l6sx0rH+UJ/rP2GvqzdUC0Xt/YnqrLu0i+GBVznDwCT4Ht59KNn5K73i3Jw?=
 =?us-ascii?Q?1UIHrBHMI6oMaQ6uSq1rS3QyNBYDJp4etXgURwlnw3q0uEdyIOhj5nEsU6RO?=
 =?us-ascii?Q?LUVWuqRmNBPDv6q7fWbETIbZvoSHEDvMCBxCx3it/f05Wp/5ca7eudr7bT51?=
 =?us-ascii?Q?M5gcVW2EIC6XQJoR3Nj33JAXWkWXo789WqikfAayXZa6oGlBn3oFQCeNTCV2?=
 =?us-ascii?Q?/eX0D802tk9Q8w3nGq1QOlmc8K0XMxNBCTwhV9fW2V1k/Zwuw6fptoQoUrBv?=
 =?us-ascii?Q?d/xqchVOkdr+QU+JII7BcTSEvVoNZA4e/HfHWFFiQat1rYrQNryfY6vrJLEk?=
 =?us-ascii?Q?dyxBotlZf155WxjsKOSFCRb9x8GrX6ntLp2wLkovjrG/BUayHBIHYVFzJFdU?=
 =?us-ascii?Q?NI1tKgVzurabkExzH0HWoSdBr/JKH5dGIG4qG9mTkck8ISVXKtdYBstID9nV?=
 =?us-ascii?Q?RpoM4BYwVST7St86eDm8qLF+sd+KZ7B2P6J+HYmYwqoiWNI1064yPxwUG8ur?=
 =?us-ascii?Q?XbSBL+VGpRT/JA4min5Y4uGUUuIwvs4bDgtS0p7YSSz2jqorbFSc6yWx1KD2?=
 =?us-ascii?Q?kcROmi+J+VVPgoKhA9sxwEiNmuUXZNITArzta4oouvepkXLXT5FZcVMd9s8C?=
 =?us-ascii?Q?DbmAnlP00nyUokWncWqGBYVnQGlY97yH4tE8+6VCKBJ/ee4T/j5bTZLAyrfi?=
 =?us-ascii?Q?Wnz6DnxDeVGD/UWTOKFvbIFRJfgNqp/GPTXWYCiyx6eo6zy8tQq3rsbfb6nG?=
 =?us-ascii?Q?KwaVQLdh8k6hXAy4D65HwsfZZ9mw1/3cTToT5nqT7dUNCvbEfEQ6r0dfsQCd?=
 =?us-ascii?Q?XLebA4OERSCwN+s5+SHbRY6yh0cfcSAJbXjwAPpszU5vk4UyTu3w5+7aONBC?=
 =?us-ascii?Q?nAFeeexpiSV54tS1OqGahOLXFqyeFHp7JfSgu9qqPbhbt67t0VgCmCOt22oe?=
 =?us-ascii?Q?Gs8m9qWrBruA5fDMHsakiD8g?=
X-OriginatorOrg: nxp.com
X-MS-Exchange-CrossTenant-Network-Message-Id: a3244e93-b4fd-4791-0b41-08d94a3577f3
X-MS-Exchange-CrossTenant-AuthSource: VI1PR04MB5136.eurprd04.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 18 Jul 2021 21:46:15.7153
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 686ea1d3-bc2b-4c6f-a92c-d99c5c301635
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: USw3YFP68BUPnieRVUwDZmBEfwNWL7rrnWH7ZYpOcyXyQQrbXJE44uR20kuO4ZkH+BPaKvG2Vy58YS4pZunVgQ==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: VE1PR04MB7325
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
v3->v4: none

Signed-off-by: Tobias Waldekranz <tobias@waldekranz.com>
Signed-off-by: Vladimir Oltean <vladimir.oltean@nxp.com>
Reviewed-by: Grygorii Strashko <grygorii.strashko@ti.com>
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

