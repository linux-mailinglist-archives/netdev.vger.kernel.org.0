Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 529473BA896
	for <lists+netdev@lfdr.de>; Sat,  3 Jul 2021 13:58:46 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230256AbhGCMBJ (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sat, 3 Jul 2021 08:01:09 -0400
Received: from mail-eopbgr20063.outbound.protection.outlook.com ([40.107.2.63]:47491
        "EHLO EUR02-VE1-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S230231AbhGCMBE (ORCPT <rfc822;netdev@vger.kernel.org>);
        Sat, 3 Jul 2021 08:01:04 -0400
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=R6JTPvUN5dXa8u+zrlj1g9QCRP8AC7VZtmy51DnYPZCR1x1X0XzJWr53kv8z+ssm92Wn1VS98aGieK/pGDr9jnviwJEXfEs4lqIguOJIH7Cg8vrqKi07ddmvYaQ5J0wRn3PnZwb/noWO8ROdbfTUOw0TsNtER/cugY3Fb5tvH+NjalADzv7Tx7U5sLmN3NvT+Zq+ibou8FY09y3BKpiViETTFme0bxqtuw96sSDq9X1RErj1X6Of3JRY//ZyV9aOngpkP1v+Timtk916Ga0svrgAazF8q+9FT6eNrc7nwKOux0pIHxso+FfLZ3BYylqKOnr3i7rTmOfwDrtjJK8ylw==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=vzrmRMFH55T/ycNRCVZN7/f2Fva2SypalG7KrtWnBFU=;
 b=fdaTGJxC8niX9GqP+MZB8CZNzDE2OSq4886xUaEii8LfUY9h+W7phsAyU+pv1gnsSVrdAoIY+LSvyGICjDF8NlpHhFRhy1vwr6kdd1cQHAfRet/CuU2JbMzz1i1tW/5d61D9ggvsO4wzUznufPrdZRmhJpbgrkB8bcfFJQLDYR8AtwRloe0KGfF4+xMX35wKPYBq3ImYvg2TZnCNkTFsJsV/IJOqc6MXFCv8MuKsZjWn+8AJbxI863ZjoLGMFPF1JYyoV9BSrZPSKr5zWk1vmflZBDMIKFaZsLDG5B2TGT+8qehWvLexXIS8R+eMr4UXJ6LPkio8r1fiWJ6fKUFIxw==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=nxp.com; dmarc=pass action=none header.from=nxp.com; dkim=pass
 header.d=nxp.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=nxp.com; s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=vzrmRMFH55T/ycNRCVZN7/f2Fva2SypalG7KrtWnBFU=;
 b=cYzWzvG/+SxMcWL0LzviySjZGnuVQT6Ujw3Idz/4jzNDpiR/PniZBvRlQdnDwgR20XhbU9HqDXkBT5QaxoN0m2lWYE9O5oa0h6P1/aESoa2IAh7PbkHJb2w24DdsHqsmAqezpuyYgaTZlyuJvYueBjch6cACoVP6vObxG+ZIhYk=
Authentication-Results: vger.kernel.org; dkim=none (message not signed)
 header.d=none;vger.kernel.org; dmarc=none action=none header.from=nxp.com;
Received: from VI1PR04MB5136.eurprd04.prod.outlook.com (2603:10a6:803:55::19)
 by VI1PR0401MB2509.eurprd04.prod.outlook.com (2603:10a6:800:56::11) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4287.22; Sat, 3 Jul
 2021 11:58:29 +0000
Received: from VI1PR04MB5136.eurprd04.prod.outlook.com
 ([fe80::b1a0:d654:a578:53ab]) by VI1PR04MB5136.eurprd04.prod.outlook.com
 ([fe80::b1a0:d654:a578:53ab%7]) with mapi id 15.20.4287.031; Sat, 3 Jul 2021
 11:58:29 +0000
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
Subject: [RFC PATCH v2 net-next 02/10] net: bridge: disambiguate offload_fwd_mark
Date:   Sat,  3 Jul 2021 14:56:57 +0300
Message-Id: <20210703115705.1034112-3-vladimir.oltean@nxp.com>
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
Received: from localhost.localdomain (188.26.224.68) by PR3P189CA0081.EURP189.PROD.OUTLOOK.COM (2603:10a6:102:b4::26) with Microsoft SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4287.23 via Frontend Transport; Sat, 3 Jul 2021 11:58:28 +0000
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: fd94ad1a-8d80-4fd9-6a62-08d93e19df3d
X-MS-TrafficTypeDiagnostic: VI1PR0401MB2509:
X-Microsoft-Antispam-PRVS: <VI1PR0401MB2509BFF7C76BFBF827817F38E01E9@VI1PR0401MB2509.eurprd04.prod.outlook.com>
X-MS-Oob-TLC-OOBClassifiers: OLM:9508;
X-MS-Exchange-SenderADCheck: 1
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: muXEHepXIYwlyG9ezU3q9FLXHVUyVwZojR0r1QPwa5BdZUha3tsQShwx6Rudk3b6QeTFrsY9f3dBSkPXYe7RrBUCa/Z7EzJeqMdsZd6g/4aDs3xuXmCRhmNr64aZ4dImoSyLu5dLteejk9IyZ+mRMMjy9/Y6cC+q8DUY1Bf/Hz9O5m71oJpZn2dktWtwFseVtuoyHwIal9vZrX2VQ08my3tN61YrpNSw2vgHgozju5VLaVendgkHhw9if2/v+QWwx2BalOpkzj1vD/4vFf9OPpNYdjoI4EWN5AQbD8Uh9OI9pfSRx6C67RlX4FdUjbB9p3ll819N9ylxLlDBW89TirKX5MdT0YDxkUvxZgB/BSARVlOJ/ry8epWz+OYcPsVpHfeerVuQtnWQ6s3qxj+n90Jqfy3UXsWoJQYMzpft135Py372/NfJY3XitJqwcesmlZtQttSfXkhwE7QU1yxDVFs2AMpqfc/iDHNr/yDcQns8Zu/CgiBOnurXSq0llgiihcmioPtr8BsLImiPKzJ9ExzxBijkEUHxsDBxp+l0cKqLVHu7N7xzepi/+O/tQu9Szm3jVxfq2zCJJIfPaFr6mVJmAywKx9YvTl6UfrHlVn3Hbg8vT4PMgslB/P3BE/vO1WrxZ5iBXO1/tEYe6jAVwpqVbwutyhJ5+AzTsxRPksBp2OOmNvXxnE6n8F+w8MPM1banpPcbEVkHPsH8/b/LbV3rtTw9KI2yNq2U49/6k0AjgAQRLV8ZP3buQuStZ88q
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:VI1PR04MB5136.eurprd04.prod.outlook.com;PTR:;CAT:NONE;SFS:(4636009)(396003)(376002)(366004)(346002)(136003)(39850400004)(6506007)(2906002)(4326008)(36756003)(2616005)(44832011)(956004)(6666004)(478600001)(7416002)(5660300002)(110136005)(66946007)(26005)(52116002)(1076003)(8676002)(8936002)(316002)(54906003)(66476007)(66556008)(6486002)(38100700002)(16526019)(38350700002)(186003)(83380400001)(86362001)(6512007)(69590400013);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?us-ascii?Q?3BQtmk++LXB+tPdvwaNSllpkn5gAXq1IFp3HGVvJFCnD6KCnVPfDb9Ul4ZD9?=
 =?us-ascii?Q?BYLXr16Um7xhTf6QXsa6duwWmbP3oAkEYGqV6X4awpaa3HdTFdwhQMxsWpIT?=
 =?us-ascii?Q?YuB65+4j7mtw95aCpve+yAiIOOEndP1AUivO4NNj+gaNuHHzd59rMEVUK06V?=
 =?us-ascii?Q?Sxeqpn7YKGyCoYX9nzx5Zr6adDa+wuG0PgPj4uNfA0jWBSOz1cuQ2bkW71r8?=
 =?us-ascii?Q?h9rrlGd0N2k18+CowgTPOqug+a2ta7T7ObuOBDn7CkYqlWegQlDGrAEF2Xch?=
 =?us-ascii?Q?+FhKh3IO0USEztiIMKOQCKKYNXXiIrkaxVVv+jdSSJQahf4/T7waGRehgbEi?=
 =?us-ascii?Q?/QAPGBzL/UrV2AtMNHx/u/bpV/8x+dbRYFkYoJlA79tndsg/qmSmGL76D6Jd?=
 =?us-ascii?Q?tTacrLA98KVeEkMgygQpxdSg/kdkONQ+mzEyKfXaPvwkFtzH1avoW513DKCq?=
 =?us-ascii?Q?Xb2tVReMHLkH3AMWpdE33gbKnmZqCDHWfwQiWcZ9OGAPVaP+samrIW8C3g2I?=
 =?us-ascii?Q?ixYCH3JfADi4Hn+Nm4fa7AfQJ2VOsxb6n2xyfoLTOPkkSJ8uOlIsSmT1RHnl?=
 =?us-ascii?Q?yTTnfkdIhRSZlVoZ8JOit6wSCgy8HKiAgiOpcZHUmHc3nrydp58BfQxtSuGo?=
 =?us-ascii?Q?YPRPMBoU6hBK11RqX8ZouxO+gLYoeam0HYmOKisPw/K+7C2rDNq5rt2GOsWC?=
 =?us-ascii?Q?AcNQ/AUdY94qcDJbrVaVbZMtcvW7JKEV8nvI9QfhC4/q6zqPFilPLubwm0a2?=
 =?us-ascii?Q?FxmWMFPHKIrDqCxMxCK4RBaRuE0oPIvkx1mlDo+2rtYVmvqMB+6yZI9Jf2Ov?=
 =?us-ascii?Q?hfkqMzUh1k90LgEoQGmDVMUxqMJuBVby2NvCyOuppmYsQ2+ACAuyMSxPKijM?=
 =?us-ascii?Q?GvsFYUBNTnsuWE72bwKHWmsDfU+SkkdNVA41LKQChF3ZzMlDNqg9p2utYEvz?=
 =?us-ascii?Q?dEomrPimidZNd2N7OYfKRBYfnOT3Rduuc6i3baXg9MKIlb8gKRBIPS4D/CQt?=
 =?us-ascii?Q?V8Hv3rhLTkyQeIDWPimPCwWDjpwQqHubxJzu7aqR1XGL0S/XUA/4ggfQWawi?=
 =?us-ascii?Q?kQAU7vNPtX42B0W+B/ql18LGhlbkq2tIlTkaDt7PzJvjiiqu2HatefjyDZ+f?=
 =?us-ascii?Q?NiYrscE0m4RhyfTAUKrPtiwjexEevLQVkdw7++EQ9hDaAmz74a485JvDom4r?=
 =?us-ascii?Q?ymz8ygbHRsq5OjfeKfuOBlnLUh0BdqZD+yKh8GVoZyIYtwwkBVsNwvoXzJRF?=
 =?us-ascii?Q?JVJkmOdHDK97aiuuKAa96GTCFVCCWmlWK01TrVjt0fiGSwjBY8OykaHhWaVv?=
 =?us-ascii?Q?yfbD1QPaaT8AJXWknbGYDEmm?=
X-OriginatorOrg: nxp.com
X-MS-Exchange-CrossTenant-Network-Message-Id: fd94ad1a-8d80-4fd9-6a62-08d93e19df3d
X-MS-Exchange-CrossTenant-AuthSource: VI1PR04MB5136.eurprd04.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 03 Jul 2021 11:58:29.2113
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 686ea1d3-bc2b-4c6f-a92c-d99c5c301635
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: 3s9s9h5HeK2iK2AuyyviKUEjhBoL3chspdpdXM4H1Qcs9mvefGyL70HUBhibGFbajFSPI8TVmwoges+xlXdnyQ==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: VI1PR0401MB2509
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

Signed-off-by: Tobias Waldekranz <tobias@waldekranz.com>
Signed-off-by: Vladimir Oltean <vladimir.oltean@nxp.com>
---
 net/bridge/br_if.c        |  2 +-
 net/bridge/br_private.h   | 10 +++++-----
 net/bridge/br_switchdev.c | 16 ++++++++--------
 3 files changed, 14 insertions(+), 14 deletions(-)

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
index 2b48b204205e..e16879caaaf3 100644
--- a/net/bridge/br_private.h
+++ b/net/bridge/br_private.h
@@ -329,7 +329,7 @@ struct net_bridge_port {
 	struct netpoll			*np;
 #endif
 #ifdef CONFIG_NET_SWITCHDEV
-	int				offload_fwd_mark;
+	int				hwdom;
 #endif
 	u16				group_fwd_mask;
 	u16				backup_redirected_cnt;
@@ -476,7 +476,7 @@ struct net_bridge {
 	u32				auto_cnt;
 
 #ifdef CONFIG_NET_SWITCHDEV
-	int offload_fwd_mark;
+	int last_hwdom;
 #endif
 	struct hlist_head		fdb_list;
 
@@ -506,7 +506,7 @@ struct br_input_skb_cb {
 #endif
 
 #ifdef CONFIG_NET_SWITCHDEV
-	int offload_fwd_mark;
+	int src_hwdom;
 #endif
 };
 
@@ -1645,7 +1645,7 @@ static inline void br_sysfs_delbr(struct net_device *dev) { return; }
 
 /* br_switchdev.c */
 #ifdef CONFIG_NET_SWITCHDEV
-int nbp_switchdev_mark_set(struct net_bridge_port *p);
+int nbp_switchdev_hwdom_set(struct net_bridge_port *p);
 void nbp_switchdev_frame_mark(const struct net_bridge_port *p,
 			      struct sk_buff *skb);
 bool nbp_switchdev_allowed_egress(const struct net_bridge_port *p,
@@ -1665,7 +1665,7 @@ static inline void br_switchdev_frame_unmark(struct sk_buff *skb)
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

