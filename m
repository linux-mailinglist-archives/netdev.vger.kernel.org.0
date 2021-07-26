Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id EA32B3D6517
	for <lists+netdev@lfdr.de>; Mon, 26 Jul 2021 19:09:08 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S236392AbhGZQUC (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 26 Jul 2021 12:20:02 -0400
Received: from mail-eopbgr150080.outbound.protection.outlook.com ([40.107.15.80]:11331
        "EHLO EUR01-DB5-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S235824AbhGZQRa (ORCPT <rfc822;netdev@vger.kernel.org>);
        Mon, 26 Jul 2021 12:17:30 -0400
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=cB8ASVZHk9u0PyDOYA4dsao85OWbqc0ZrnBHAD2U6aum6SYOqLzyHmlYN+5FzJAPmUE0bAqPv/u0DEVRLtOzQL6UN46ie+3+lwWWNEBaPJywA8mUMLGcdvvPnxmWfl5qIugDu7LElfm+uTQXUtraFSbfvTTJdZOvXj6kPlwzF0agfnyiaevNug8OF9aNR17JCqGgx+0jhLTxH6VS4oTGvqjj78botg5mST15Dz+uDVEPm5EMT+9eA0b2GgGnBZelnrtuILq93zdsKM1G8FdBTaf+QTfiNh3ZZZkW0IiHiBsAFXekFIpMaY2N/HkLo9IaICkKKJTvLPPlAcO1KCkfZw==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=I0hKqBrV/CsYstl5r2Crrl89BSYJVqKE20JkVYu6G7M=;
 b=QllwncjZBA4h2KcXp4bklgnvZMcGU0SZX27D7hvN9AHVArf1+8sAb4W7rSRzNWh4dNqE1skit1TS6YdjUwybZkicjA8dXaxpn2O7Ttd3XfmxCXpSe93RskAEmv0TqMkg93DjpggyWxebzBCeTIRUX8NrA2DLGxZqCpy2ABRx4cNQNJVZBNWo73KHvM8MR3TkWVi09mO7buAPfMze89P+vT0M18RdlUHyGOqfodAv8DsqUvygPVDKv+qXYcAX4ysMfGI/KIfvBCUd9pN0W0r9qDpEKy8Yu5d7CfGMBTDp7ruH6PAucwJiob0LJKQoihasuD3ZZZSEcJb+b/laE6APTg==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=nxp.com; dmarc=pass action=none header.from=nxp.com; dkim=pass
 header.d=nxp.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=nxp.com; s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=I0hKqBrV/CsYstl5r2Crrl89BSYJVqKE20JkVYu6G7M=;
 b=WaixDc/D6T1Vo90/LUR08mrWoe9XWZz2pP73irjY6bBL9RIWqf4k7/lEn6UOq5Ayoci94vem8/fOPd/EC+JXGrq4IHrFLFtPwIi+nn/+8FizKyM0lJgvq51VYxtlUXsXZQ2aebQ3Hmb7BJzkZac2/mAvAdwaYWWkHBlu4o3Fm1Q=
Authentication-Results: vger.kernel.org; dkim=none (message not signed)
 header.d=none;vger.kernel.org; dmarc=none action=none header.from=nxp.com;
Received: from VI1PR04MB5136.eurprd04.prod.outlook.com (2603:10a6:803:55::19)
 by VE1PR04MB7328.eurprd04.prod.outlook.com (2603:10a6:800:1a5::11) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4352.25; Mon, 26 Jul
 2021 16:56:05 +0000
Received: from VI1PR04MB5136.eurprd04.prod.outlook.com
 ([fe80::109:1995:3e6b:5bd0]) by VI1PR04MB5136.eurprd04.prod.outlook.com
 ([fe80::109:1995:3e6b:5bd0%2]) with mapi id 15.20.4352.031; Mon, 26 Jul 2021
 16:56:05 +0000
From:   Vladimir Oltean <vladimir.oltean@nxp.com>
To:     netdev@vger.kernel.org, Jakub Kicinski <kuba@kernel.org>,
        "David S. Miller" <davem@davemloft.net>
Cc:     Florian Fainelli <f.fainelli@gmail.com>,
        Andrew Lunn <andrew@lunn.ch>,
        Vivien Didelot <vivien.didelot@gmail.com>
Subject: [PATCH net-next 7/9] net: dsa: sja1105: add support for imprecise RX
Date:   Mon, 26 Jul 2021 19:55:34 +0300
Message-Id: <20210726165536.1338471-8-vladimir.oltean@nxp.com>
X-Mailer: git-send-email 2.25.1
In-Reply-To: <20210726165536.1338471-1-vladimir.oltean@nxp.com>
References: <20210726165536.1338471-1-vladimir.oltean@nxp.com>
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-ClientProxiedBy: AM0PR05CA0078.eurprd05.prod.outlook.com
 (2603:10a6:208:136::18) To VI1PR04MB5136.eurprd04.prod.outlook.com
 (2603:10a6:803:55::19)
MIME-Version: 1.0
X-MS-Exchange-MessageSentRepresentingType: 1
Received: from localhost.localdomain (82.76.66.29) by AM0PR05CA0078.eurprd05.prod.outlook.com (2603:10a6:208:136::18) with Microsoft SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4352.26 via Frontend Transport; Mon, 26 Jul 2021 16:56:04 +0000
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: b7522c53-e918-48d6-049b-08d95056420a
X-MS-TrafficTypeDiagnostic: VE1PR04MB7328:
X-Microsoft-Antispam-PRVS: <VE1PR04MB73289F9763CDB7EA07A0167BE0E89@VE1PR04MB7328.eurprd04.prod.outlook.com>
X-MS-Oob-TLC-OOBClassifiers: OLM:10000;
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: Ma9qKrPpT1nn4A7WxfbXEdFfNEsDAstUnrjngZyxKQFOBBJ0U67Sc0fDPhN8Zi9/GWXo0e1B9HsDiL5TFavstxrWY3sBr8i1ygIulyIcQ0k5GOgr3DWJfjWdMCaxJRu5McG64G9a4GPgBIuAulMgx5bogBAt9tnx4VTF87c4b16PGdUtG/ojOwXz4dbB/nEpDnJau3qY8f7loM6JWfjF5kDE5pdLONgdtpep5TypFaBFfKC8GjpEIQgWHWRhMvy/ROQM6x6d4oY0KL5F5SE4srUKbWrNsT67hrXFk7qfukE6O2IMJJmlCloXNFvqFKPfkxoHDCwCMBkt/RtsHTBJwFsVALpon7AygJsOhI9pOC+zD66txKGHEDe4IKIl7dND9bTOqHqZ80h2o6JQS4C9PdBZfFbhXoR24/CMNlUJekRiYzmJ5o0PrRwfyRpTwPC4sZtq9/HwgMhwliP6HAjxK3dD0V8T8nPG2YPynj28dXwol6K8tA0mkXInWtnUXpGSPiscdTcsyxXWSM2gCZdGSOH+qWkJ3wGXNlwJeNHZq9OUtFV2k/owz/zqezBd3FqXvkcTsmAunc4u776xVxv+WZ7j62zzeKJhRJe7p50De0pNt3K7Q0U8cpTk33aib53G3oX/DY/+AIdGtwztDUz6WaaE9lJf8nNNTJpynyxqANsNcE59qs61RwHiu0x+AvvaIbh9eq/B/BGSaOXTpe8VeIuOnrfzd4NG5SFKLg/we7Q=
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:VI1PR04MB5136.eurprd04.prod.outlook.com;PTR:;CAT:NONE;SFS:(4636009)(396003)(376002)(39850400004)(136003)(346002)(366004)(36756003)(38350700002)(38100700002)(83380400001)(478600001)(44832011)(956004)(6666004)(86362001)(2616005)(2906002)(52116002)(8676002)(8936002)(66556008)(5660300002)(66946007)(54906003)(110136005)(66476007)(316002)(26005)(6512007)(6506007)(186003)(1076003)(4326008)(6486002)(83323001);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?us-ascii?Q?DGD6J6ocuAoXCJktFrP139bCzrFCwzaxJo6t+QtWAJtooz2Vv//CM/3JGNjJ?=
 =?us-ascii?Q?cddgT3umFZ2h3S3neQacnO7KhM98LkcfA9RONAc2SFo80RNy1cNpkSUIN29D?=
 =?us-ascii?Q?xGJiD/GPIvHy6yIfGwZeNVVMq8JPzp46Fco/CGgPqADX38BcBVKVY5KT8BnH?=
 =?us-ascii?Q?bpfHLYRI+2LwBZrukxhlBBB8JSjbAcF3XOWEZLQjh3Aus9ieH2QjJ1Y4uYdp?=
 =?us-ascii?Q?aSRlLzAB8evtTnX9qmUZxsTEDqgABOfeMvORFiGvrSqtQzz/SmhLhoZGMEdW?=
 =?us-ascii?Q?+5xhpNcEI9H0pI1bH6SfIP0Qx1wyxcQ5/z4nciYvy7rNUw7trX7tG6tbNfeL?=
 =?us-ascii?Q?91B5PUUiuQTS1+ykZYkW844vnLAP5RZIGqu3gj/7A5xoUCkWF0HfTSiR7OUW?=
 =?us-ascii?Q?v/rcngtOTPLEYIbKFgPT3936V3l4aPnmbslcesgwgLi/qESLurwqsIdXE49d?=
 =?us-ascii?Q?1fw49POYzwKVmzj9daLxK262SnByVUW0UJ6s19VW3bJxFrbgAvKfB6B/sWyt?=
 =?us-ascii?Q?yz9D76PfF44tgvSYS+2VMjy5+F57y9OrnDvCLSuKOmDJ+fsq0DGM8SXCsVi4?=
 =?us-ascii?Q?DqmhQJwk63nasETkIntWPRKlu+6u0ePsOHwkE96k6yM1qLVKhTX7SH/WxDXY?=
 =?us-ascii?Q?WSDdrIX1r8d1a0kZ7omwhX/ImmtFQr069VtVZQJSjx3QGBlpCBFI7TPYjxpS?=
 =?us-ascii?Q?mmoyiu0mbDaV7smpCD6K6ISMBWady9RFnf+tJSjDElfE+V30xX5YcwyjJvxT?=
 =?us-ascii?Q?eUVrq9iJOiCULqZX+X7K5RP3WHdCuYwx8C7UG22UL6B5uKCm/5uoLG6WkzUK?=
 =?us-ascii?Q?6I8nB51I/LeCWuYTUwCObQB/rWZs2rCF5GpTxSARo+wO3ntyE2isAr307nqK?=
 =?us-ascii?Q?OD10aCtttE2mcUMz8a8OxZQ44wHwCEQPwBY3rA6kDNfNDY+O3xK+qNXaVP4H?=
 =?us-ascii?Q?hAmJIaKfYy+axzf1l6u3MzXamrm8loBoHC7UNNbY/TDCBFxv2UQmn5FE6GDA?=
 =?us-ascii?Q?xKwH9IdHSPeRHs+zvzSSCmW2hrD9U9NWPVBOs60mGPzDR+4yKyqapSfVFPb7?=
 =?us-ascii?Q?auyLoCjZUAerGEkGpUprZuC2DenCyy5C1dCpDqAxcHQb0e9tuAHW3W8VQpY+?=
 =?us-ascii?Q?/rORMBrnft23GEYuU/iLHUM+nz9P8wToPrCc0FGVIGV/iDmewTTmKWQFSeS3?=
 =?us-ascii?Q?8qvWrEJON4UGaVcmnFvy68w9xVkFmGywqwDPobrMrI7bgT/daXBj/JsXYFDl?=
 =?us-ascii?Q?GOhtaqTlDfYWV7kz8cp+FQeeT3dbKiZp1EuvUOD2Lxn5NzpvAkoHMzy8qULS?=
 =?us-ascii?Q?yxLBZbyBNGdY+DZKWx/dFtOa?=
X-OriginatorOrg: nxp.com
X-MS-Exchange-CrossTenant-Network-Message-Id: b7522c53-e918-48d6-049b-08d95056420a
X-MS-Exchange-CrossTenant-AuthSource: VI1PR04MB5136.eurprd04.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 26 Jul 2021 16:56:05.6677
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 686ea1d3-bc2b-4c6f-a92c-d99c5c301635
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: rwcnQD1X+9aPPc3eVrD2qo0Qbcfx9GJyrKS9oq93ITvnk2ADWC19oyYItgmPvK3BNOd00+jb4VMbrRBIbk4hKQ==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: VE1PR04MB7328
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

This is already common knowledge by now, but the sja1105 does not have
hardware support for DSA tagging for data plane packets, and tag_8021q
sets up a unique pvid per port, transmitted as VLAN-tagged towards the
CPU, for the source port to be decoded nonetheless.

When the port is part of a VLAN-aware bridge, the pvid committed to
hardware is taken from the bridge and not from tag_8021q, so we need to
work with that the best we can.

Configure the switches to send all packets to the CPU as VLAN-tagged
(even ones that were originally untagged on the wire) and make use of
dsa_untag_bridge_pvid() to get rid of it before we send those packets up
the network stack.

With the classified VLAN used by hardware known to the tagger, we first
peek at the VID in an attempt to figure out if the packet was received
from a VLAN-unaware port (standalone or under a VLAN-unaware bridge),
case in which we can continue to call dsa_8021q_rcv(). If that is not
the case, the packet probably came from a VLAN-aware bridge. So we call
the DSA helper that finds for us a "designated bridge port" - one that
is a member of the VLAN ID from the packet, and is in the proper STP
state - basically these are all checks performed by br_handle_frame() in
the software RX data path.

The bridge will accept the packet as valid even if the source port was
maybe wrong. So it will maybe learn the MAC SA of the packet on the
wrong port, and its software FDB will be out of sync with the hardware
FDB. So replies towards this same MAC DA will not work, because the
bridge will send towards a different netdev.

This is where the bridge data plane offload ("imprecise TX") added by
the next patch comes in handy. The software FDB is wrong, true, but the
hardware FDB isn't, and by offloading the bridge forwarding plane we
have a chance to right a wrong, and have the hardware look up the FDB
for us for the reply packet. So it all cancels out.

Signed-off-by: Vladimir Oltean <vladimir.oltean@nxp.com>
---
 drivers/net/dsa/sja1105/sja1105_main.c |  8 ++-
 net/dsa/dsa_priv.h                     | 43 +++++++++++++
 net/dsa/tag_sja1105.c                  | 87 +++++++++++++-------------
 3 files changed, 93 insertions(+), 45 deletions(-)

diff --git a/drivers/net/dsa/sja1105/sja1105_main.c b/drivers/net/dsa/sja1105/sja1105_main.c
index ef63226fed2b..a6a671f0fca5 100644
--- a/drivers/net/dsa/sja1105/sja1105_main.c
+++ b/drivers/net/dsa/sja1105/sja1105_main.c
@@ -2201,6 +2201,7 @@ static int sja1105_bridge_vlan_add(struct dsa_switch *ds, int port,
 				   struct netlink_ext_ack *extack)
 {
 	struct sja1105_private *priv = ds->priv;
+	u16 flags = vlan->flags;
 	int rc;
 
 	/* Be sure to deny alterations to the configuration done by tag_8021q.
@@ -2211,7 +2212,11 @@ static int sja1105_bridge_vlan_add(struct dsa_switch *ds, int port,
 		return -EBUSY;
 	}
 
-	rc = sja1105_vlan_add(priv, port, vlan->vid, vlan->flags);
+	/* Always install bridge VLANs as egress-tagged on the CPU port. */
+	if (dsa_is_cpu_port(ds, port))
+		flags = 0;
+
+	rc = sja1105_vlan_add(priv, port, vlan->vid, flags);
 	if (rc)
 		return rc;
 
@@ -2361,6 +2366,7 @@ static int sja1105_setup(struct dsa_switch *ds)
 	 * TPID is ETH_P_SJA1105, and the VLAN ID is the port pvid.
 	 */
 	ds->vlan_filtering_is_global = true;
+	ds->untag_bridge_pvid = true;
 
 	/* Advertise the 8 egress queues */
 	ds->num_tx_queues = SJA1105_NUM_TC;
diff --git a/net/dsa/dsa_priv.h b/net/dsa/dsa_priv.h
index b1d9aa4d313c..da3ad02d6ceb 100644
--- a/net/dsa/dsa_priv.h
+++ b/net/dsa/dsa_priv.h
@@ -397,6 +397,49 @@ static inline struct sk_buff *dsa_untag_bridge_pvid(struct sk_buff *skb)
 	return skb;
 }
 
+/* For switches without hardware support for DSA tagging to be able
+ * to support termination through the bridge.
+ */
+static inline struct net_device *
+dsa_find_designated_bridge_port_by_vid(struct net_device *master, u16 vid)
+{
+	struct dsa_port *cpu_dp = master->dsa_ptr;
+	struct dsa_switch_tree *dst = cpu_dp->dst;
+	struct bridge_vlan_info vinfo;
+	struct net_device *slave;
+	struct dsa_port *dp;
+	int err;
+
+	list_for_each_entry(dp, &dst->ports, list) {
+		if (dp->type != DSA_PORT_TYPE_USER)
+			continue;
+
+		if (!dp->bridge_dev)
+			continue;
+
+		if (dp->stp_state != BR_STATE_LEARNING &&
+		    dp->stp_state != BR_STATE_FORWARDING)
+			continue;
+
+		/* Since the bridge might learn this packet, keep the CPU port
+		 * affinity with the port that will be used for the reply on
+		 * xmit.
+		 */
+		if (dp->cpu_dp != cpu_dp)
+			continue;
+
+		slave = dp->slave;
+
+		err = br_vlan_get_info_rcu(slave, vid, &vinfo);
+		if (err)
+			continue;
+
+		return slave;
+	}
+
+	return NULL;
+}
+
 /* switch.c */
 int dsa_switch_register_notifier(struct dsa_switch *ds);
 void dsa_switch_unregister_notifier(struct dsa_switch *ds);
diff --git a/net/dsa/tag_sja1105.c b/net/dsa/tag_sja1105.c
index 7c92c329a092..f142a933c5e2 100644
--- a/net/dsa/tag_sja1105.c
+++ b/net/dsa/tag_sja1105.c
@@ -115,40 +115,6 @@ static inline bool sja1105_is_meta_frame(const struct sk_buff *skb)
 	return true;
 }
 
-static bool sja1105_can_use_vlan_as_tags(const struct sk_buff *skb)
-{
-	struct vlan_ethhdr *hdr = vlan_eth_hdr(skb);
-	u16 vlan_tci;
-
-	if (hdr->h_vlan_proto == htons(ETH_P_SJA1105))
-		return true;
-
-	if (hdr->h_vlan_proto != htons(ETH_P_8021Q) &&
-	    !skb_vlan_tag_present(skb))
-		return false;
-
-	if (skb_vlan_tag_present(skb))
-		vlan_tci = skb_vlan_tag_get(skb);
-	else
-		vlan_tci = ntohs(hdr->h_vlan_TCI);
-
-	return vid_is_dsa_8021q(vlan_tci & VLAN_VID_MASK);
-}
-
-/* This is the first time the tagger sees the frame on RX.
- * Figure out if we can decode it.
- */
-static bool sja1105_filter(const struct sk_buff *skb, struct net_device *dev)
-{
-	if (sja1105_can_use_vlan_as_tags(skb))
-		return true;
-	if (sja1105_is_link_local(skb))
-		return true;
-	if (sja1105_is_meta_frame(skb))
-		return true;
-	return false;
-}
-
 /* Calls sja1105_port_deferred_xmit in sja1105_main.c */
 static struct sk_buff *sja1105_defer_xmit(struct sja1105_port *sp,
 					  struct sk_buff *skb)
@@ -371,15 +337,42 @@ static bool sja1110_skb_has_inband_control_extension(const struct sk_buff *skb)
 	return ntohs(eth_hdr(skb)->h_proto) == ETH_P_SJA1110;
 }
 
+/* Returns true for imprecise RX and sets the @vid.
+ * Returns false for precise RX and sets @source_port and @switch_id.
+ */
+static bool sja1105_vlan_rcv(struct sk_buff *skb, int *source_port,
+			     int *switch_id, u16 *vid)
+{
+	struct vlan_ethhdr *hdr = (struct vlan_ethhdr *)skb_mac_header(skb);
+	u16 vlan_tci;
+
+	if (skb_vlan_tag_present(skb))
+		vlan_tci = skb_vlan_tag_get(skb);
+	else
+		vlan_tci = ntohs(hdr->h_vlan_TCI);
+
+	if (vid_is_dsa_8021q_rxvlan(vlan_tci & VLAN_VID_MASK)) {
+		dsa_8021q_rcv(skb, source_port, switch_id);
+		return false;
+	}
+
+	/* Try our best with imprecise RX */
+	*vid = vlan_tci & VLAN_VID_MASK;
+
+	return true;
+}
+
 static struct sk_buff *sja1105_rcv(struct sk_buff *skb,
 				   struct net_device *netdev,
 				   struct packet_type *pt)
 {
+	int source_port = -1, switch_id = -1;
 	struct sja1105_meta meta = {0};
-	int source_port, switch_id;
+	bool imprecise_rx = false;
 	struct ethhdr *hdr;
 	bool is_link_local;
 	bool is_meta;
+	u16 vid;
 
 	hdr = eth_hdr(skb);
 	is_link_local = sja1105_is_link_local(skb);
@@ -389,7 +382,8 @@ static struct sk_buff *sja1105_rcv(struct sk_buff *skb,
 
 	if (sja1105_skb_has_tag_8021q(skb)) {
 		/* Normal traffic path. */
-		dsa_8021q_rcv(skb, &source_port, &switch_id);
+		imprecise_rx = sja1105_vlan_rcv(skb, &source_port, &switch_id,
+						&vid);
 	} else if (is_link_local) {
 		/* Management traffic path. Switch embeds the switch ID and
 		 * port ID into bytes of the destination MAC, courtesy of
@@ -408,7 +402,10 @@ static struct sk_buff *sja1105_rcv(struct sk_buff *skb,
 		return NULL;
 	}
 
-	skb->dev = dsa_master_find_slave(netdev, switch_id, source_port);
+	if (imprecise_rx)
+		skb->dev = dsa_find_designated_bridge_port_by_vid(netdev, vid);
+	else
+		skb->dev = dsa_master_find_slave(netdev, switch_id, source_port);
 	if (!skb->dev) {
 		netdev_warn(netdev, "Couldn't decode source port\n");
 		return NULL;
@@ -522,6 +519,8 @@ static struct sk_buff *sja1110_rcv(struct sk_buff *skb,
 				   struct packet_type *pt)
 {
 	int source_port = -1, switch_id = -1;
+	bool imprecise_rx = false;
+	u16 vid;
 
 	skb->offload_fwd_mark = 1;
 
@@ -534,13 +533,15 @@ static struct sk_buff *sja1110_rcv(struct sk_buff *skb,
 
 	/* Packets with in-band control extensions might still have RX VLANs */
 	if (likely(sja1105_skb_has_tag_8021q(skb)))
-		dsa_8021q_rcv(skb, &source_port, &switch_id);
+		imprecise_rx = sja1105_vlan_rcv(skb, &source_port, &switch_id,
+						&vid);
 
-	skb->dev = dsa_master_find_slave(netdev, switch_id, source_port);
+	if (imprecise_rx)
+		skb->dev = dsa_find_designated_bridge_port_by_vid(netdev, vid);
+	else
+		skb->dev = dsa_master_find_slave(netdev, switch_id, source_port);
 	if (!skb->dev) {
-		netdev_warn(netdev,
-			    "Couldn't decode source port %d and switch id %d\n",
-			    source_port, switch_id);
+		netdev_warn(netdev, "Couldn't decode source port\n");
 		return NULL;
 	}
 
@@ -576,7 +577,6 @@ static const struct dsa_device_ops sja1105_netdev_ops = {
 	.proto = DSA_TAG_PROTO_SJA1105,
 	.xmit = sja1105_xmit,
 	.rcv = sja1105_rcv,
-	.filter = sja1105_filter,
 	.needed_headroom = VLAN_HLEN,
 	.flow_dissect = sja1105_flow_dissect,
 	.promisc_on_master = true,
@@ -590,7 +590,6 @@ static const struct dsa_device_ops sja1110_netdev_ops = {
 	.proto = DSA_TAG_PROTO_SJA1110,
 	.xmit = sja1110_xmit,
 	.rcv = sja1110_rcv,
-	.filter = sja1105_filter,
 	.flow_dissect = sja1110_flow_dissect,
 	.needed_headroom = SJA1110_HEADER_LEN + VLAN_HLEN,
 	.needed_tailroom = SJA1110_RX_TRAILER_LEN + SJA1110_MAX_PADDING_LEN,
-- 
2.25.1

