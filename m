Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 6F6DF3D6518
	for <lists+netdev@lfdr.de>; Mon, 26 Jul 2021 19:09:09 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S237226AbhGZQUG (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 26 Jul 2021 12:20:06 -0400
Received: from mail-eopbgr00054.outbound.protection.outlook.com ([40.107.0.54]:5443
        "EHLO EUR02-AM5-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S235362AbhGZQRf (ORCPT <rfc822;netdev@vger.kernel.org>);
        Mon, 26 Jul 2021 12:17:35 -0400
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=Vn0nSFDtBVsRswhv2NKktfFbzqwo0wVtQQw0K2pmIXdLarNbaHu9tWq9JnfrlF2WmuuiZAx9s0s/o4Jy0ql4VGSJoIEQZffJZHHSl3VDgI5WYRMNsjqrEkoMiC8Xd3XYr/CyTlJSF0buTsyXa3sGMm24b08Wz5WdPvk71HBt9gU51dSDiOB6WTMOizKXZLEAAyOF64dm14AECZH4765sLGwagvg5w/giKIe64o+6VLATtLfyAzBW6Wiu00gez6KZTpGrIlRCIRR3U8IOKTVxf1j4RjQChK4aE1eiB+o2A87s3Egc4AvX38R0R2k1dNhwmVtxsrulCohDThiXr8z+Aw==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=bgE7F7mCSpuKklzYDJmABGj3KAFByeZRY1ulcmGRyJM=;
 b=N8iMsb/4PBZYYGtZw1q7rqyLVCgEybLTiLw1udf2/+GkxF1nN6p0Z6G5bm8cIciYswr5NPbvu4QHouxbWfF490lb/FWyieG/4l/T3ZbAQwwH+vNVwxMG7p24FJ0EXhkhPgIHUeflUPdDaDYg7SR9Piv05R5N4GBouFt1PUg3QfyrgvbS0O7Y4kE6u3Up3tO9OM7ycpsMV9wbOCc5XnLqHGa6S+E09/JpiVlqp218T+SVU919QGmDFgsjFWkG+HNFyaFkFvOU3oK/IgIKzPKQaQzyZSMdd+UTWsU1ka5vRfr1WJDKT8I+EinqwZcxQxiaIAcyq+LzsBGoIItJWrDNSQ==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=nxp.com; dmarc=pass action=none header.from=nxp.com; dkim=pass
 header.d=nxp.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=nxp.com; s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=bgE7F7mCSpuKklzYDJmABGj3KAFByeZRY1ulcmGRyJM=;
 b=mkCmibZN6yetav9f2GExo9jUOOj/OweYI/SUem9Hofk4rxnW0QIWzeY8AFOXGhqilqmanKkxOau7xDfftXWaHVRGzqAlaUAGjQO267LoRUdMMfT8yz0OZ6v8vntThSQyTK2QbB+EiF0KPPr39yJdrcvO6LbwV8KYQS9mEP2rdCk=
Authentication-Results: vger.kernel.org; dkim=none (message not signed)
 header.d=none;vger.kernel.org; dmarc=none action=none header.from=nxp.com;
Received: from VI1PR04MB5136.eurprd04.prod.outlook.com (2603:10a6:803:55::19)
 by VE1PR04MB7328.eurprd04.prod.outlook.com (2603:10a6:800:1a5::11) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4352.25; Mon, 26 Jul
 2021 16:56:06 +0000
Received: from VI1PR04MB5136.eurprd04.prod.outlook.com
 ([fe80::109:1995:3e6b:5bd0]) by VI1PR04MB5136.eurprd04.prod.outlook.com
 ([fe80::109:1995:3e6b:5bd0%2]) with mapi id 15.20.4352.031; Mon, 26 Jul 2021
 16:56:06 +0000
From:   Vladimir Oltean <vladimir.oltean@nxp.com>
To:     netdev@vger.kernel.org, Jakub Kicinski <kuba@kernel.org>,
        "David S. Miller" <davem@davemloft.net>
Cc:     Florian Fainelli <f.fainelli@gmail.com>,
        Andrew Lunn <andrew@lunn.ch>,
        Vivien Didelot <vivien.didelot@gmail.com>
Subject: [PATCH net-next 8/9] net: dsa: sja1105: add bridge TX data plane offload based on tag_8021q
Date:   Mon, 26 Jul 2021 19:55:35 +0300
Message-Id: <20210726165536.1338471-9-vladimir.oltean@nxp.com>
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
Received: from localhost.localdomain (82.76.66.29) by AM0PR05CA0078.eurprd05.prod.outlook.com (2603:10a6:208:136::18) with Microsoft SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4352.26 via Frontend Transport; Mon, 26 Jul 2021 16:56:05 +0000
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: b79a27f5-e0d9-4304-6bcb-08d950564293
X-MS-TrafficTypeDiagnostic: VE1PR04MB7328:
X-Microsoft-Antispam-PRVS: <VE1PR04MB73289ED1C63789DA6BC849BCE0E89@VE1PR04MB7328.eurprd04.prod.outlook.com>
X-MS-Oob-TLC-OOBClassifiers: OLM:10000;
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: SMzQzbBr9V98fdVulHCEYOU4o9QLpawO0Y8eS7eX8gV+dffbGvzRhiVTM1W7uxe9TS07S9385QEeNd/Th7+GcSkdvumGiKD7Zw0BTzdrcbHKSmMd6baP/jcQf+FLICB/Gr3bQXiS96Pik+IdDzmJQDDf/Cb84AbgXh+ro3pGQmXlydZ1W7qfYsXBKey3EvYIM05aUys1ztLA1v1GZD6bkr4UCQfdmSpnjQFwBKvcniT0R02UOFuQgBYshl2QhlwtaHNy6DoxIF0KJAjgONm7iT6Ou0kvi+eksNQC9xi8qgsHut9+HcdtWSIrxWxCVdraLESXhLw8zDEfeZMwLKqQXHTfrvvlFIYUFzUhC8w/ffN/1FxzxaPsa5S+H80yrjDJBSb3b+yMxJPD2XtQ4kSAf1S/vlhO7FDKwC3v3suIrR6fjyHfLvezHK6oEsXDpv4vT5U6CXsgBSvPJCC75kJuKn7nziPSV5QIlgycP4esSaV3ZsHkJOz7LbfGhBIrF6c3zx/1uDYIvuWPgHYiFJ6Maq+9TsrcVjw7o+1IvChvj+v+qk9txA+MlC/yedbtel7LwcvpfBzJ+twaXvRRhUVzDD8Bqocu8oTBAXJf/So/07x1jCKOUOoAWaKYOMog8WEKu8Z/yVyK534F0bjuPZTd6DXCvOZK5LScvnDoZsYT+LLd0LNqYxUaCWCjlWr1ltsutWEVEQp9GCZwAvZ96wTXcg==
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:VI1PR04MB5136.eurprd04.prod.outlook.com;PTR:;CAT:NONE;SFS:(4636009)(396003)(376002)(39850400004)(136003)(346002)(366004)(36756003)(38350700002)(38100700002)(83380400001)(478600001)(44832011)(956004)(6666004)(86362001)(2616005)(2906002)(52116002)(8676002)(8936002)(66556008)(5660300002)(66946007)(54906003)(110136005)(66476007)(316002)(26005)(6512007)(6506007)(186003)(1076003)(4326008)(6486002);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?us-ascii?Q?LpVeBHO+syCAwHKJKLFiDw4bLNsF0ZiIa+Y37BG5mKQOQDUxHEoQbu7ToT9H?=
 =?us-ascii?Q?rlokL3OIHXrEldpXk3Jz3OnBygSUpxbj1O9vuyNDY1WA5v6lX1Fy4a9tJScF?=
 =?us-ascii?Q?7IevUEt2QGety+LqBKu45327Ct1PqmpjY9iPa7hxo0LF0EQZIVW14mFXibb9?=
 =?us-ascii?Q?Sxs1IGknrODW0eYTjy3TOoWeA0yRUAiw21cvgs4jikuimSyEtTHFUr8kU4bT?=
 =?us-ascii?Q?YG9VFT0S3VCmfaDIArAvMJi8lUj+XDmjTM7dGGMRCG8OfX4W2z8bYvhiGYqR?=
 =?us-ascii?Q?+SKeg974ObqKnwP53xDkS4hom15awy2cvpOBxNeogBeppzP20aWlcKDZDyBk?=
 =?us-ascii?Q?BqvYYo3OCjnzLqA1ahtcUSEVU7Z/1kotil+SX0tbi/KxsE/i0qkT60Mos+WI?=
 =?us-ascii?Q?8Mpedh4cM1/xkWkoXR2WSBpPuKUIbnCa9gmhzfi4hBr9Dzk7lUwLJKTH8nuw?=
 =?us-ascii?Q?QS5atjvstrffA+yPRMwnGSIVCLHkt+3OaiR4GcE/Lm4kISBNcICl1EY22gCP?=
 =?us-ascii?Q?WIUZrnMHB9U3Fgc6z6HJefV1hp0JmfHj8yh8lgFQugQHZ6VQsib7c6KNVaHV?=
 =?us-ascii?Q?5kS6iZ5QR2x2/0AWiFLVx49pS51B6rjNoDEhsT2n7pXxiNvlgkY7DKDMD/uS?=
 =?us-ascii?Q?feqXhAC5D/iaKjZA44D7zu81+zmYIFQ2chy409VPXkdMMWMQOAYvGYoPtaUR?=
 =?us-ascii?Q?gHJ96LBgc6K0VXSRijvBc4jygVyU0xXQYhMRWKCfeG40dpiG87GaaNt9FUNf?=
 =?us-ascii?Q?FeFb2OrtjXGJuF3FeRjJhM87HIyCuo5qGjDtpDHbFnLBi+xhG2a6ERGkEP8a?=
 =?us-ascii?Q?ZxWonQpMPdP96kZgv6hEuXM9De8vH/T4HZN9H/mxAuA6xBTTU0vVvp/dhRFk?=
 =?us-ascii?Q?zbinb/W7jICqIziXfUoL/K4/rMhSVK4yvjdlJ9/qW7OPaOuekMcpD+3uqyCd?=
 =?us-ascii?Q?Iwer/x1x/wasnHox22g6iv5lPpmCIAv0Jg7iBIGjATgXoi2k0HMEuVNwNzoM?=
 =?us-ascii?Q?4n3hn/IVjSJ2Ed+mX2xRPTTqByKlEjlG1ZnCmTEGyFlnUmqnsQI+WlUaac1H?=
 =?us-ascii?Q?Z6Xn7f/rG4NZINYERDSsJr0huHiiA7lEIF9K3NibYJQeHXcr6SuQCaAaOLVb?=
 =?us-ascii?Q?cCuG7hVJOqfMrvA2d1PQp2lkrPeLUvf+lyYnpvlWJ69mjreDjVbtgQWwnLuk?=
 =?us-ascii?Q?5o0NwaCmJCZI+VuO5HMjwGS9z/wogzCaTmGfFoxuNyT9zptkFw1yEhjZbaJn?=
 =?us-ascii?Q?jLNPprzsh/ugDFCWE8XAzycGUcpR7bpaiqq3ZLsjj1DdF8bc9JyVys6zZ9su?=
 =?us-ascii?Q?whTQv1PwJ8aJtpfDNpBLjkqS?=
X-OriginatorOrg: nxp.com
X-MS-Exchange-CrossTenant-Network-Message-Id: b79a27f5-e0d9-4304-6bcb-08d950564293
X-MS-Exchange-CrossTenant-AuthSource: VI1PR04MB5136.eurprd04.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 26 Jul 2021 16:56:06.5931
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 686ea1d3-bc2b-4c6f-a92c-d99c5c301635
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: YNxfqq6qj3oYzfA4SD3tlae6wZ/wj1+9u2dW8zKhvfOUENyJA28ERJpl5YJtH+iKLKfTUDpnoPNLAbkocs+M+w==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: VE1PR04MB7328
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

The main desire for having this feature in sja1105 is to support network
stack termination for traffic coming from a VLAN-aware bridge.

For sja1105, offloading the bridge data plane means sending packets
as-is, with the proper VLAN tag, to the chip. The chip will look up its
FDB and forward them to the correct destination port.

But we support bridge data plane offload even for VLAN-unaware bridges,
and the implementation there is different. In fact, VLAN-unaware
bridging is governed by tag_8021q, so it makes sense to have the
.bridge_fwd_offload_add() implementation fully within tag_8021q.
The key difference is that we only support 1 VLAN-aware bridge, but we
support multiple VLAN-unaware bridges. So we need to make sure that the
forwarding domain is not crossed by packets injected from the stack.

For this, we introduce the concept of a tag_8021q TX VLAN for bridge
forwarding offload. As opposed to the regular TX VLANs which contain
only 2 ports (the user port and the CPU port), a bridge data plane TX
VLAN is "multicast" (or "imprecise"): it contains all the ports that are
part of a certain bridge, and the hardware will select where the packet
goes within this "imprecise" forwarding domain.

Each VLAN-unaware bridge has its own "imprecise" TX VLAN, so we make use
of the unique "bridge_num" provided by DSA for the data plane offload.
We use the same 3 bits from the tag_8021q VLAN ID format to encode this
bridge number.

Note that these 3 bit positions have been used before for sub-VLANs in
best-effort VLAN filtering mode. The difference is that for best-effort,
the sub-VLANs were only valid on RX (and it was documented that the
sub-VLAN field needed to be transmitted as zero). Whereas for the bridge
data plane offload, these 3 bits are only valid on TX.

Signed-off-by: Vladimir Oltean <vladimir.oltean@nxp.com>
---
 drivers/net/dsa/sja1105/sja1105_main.c |  4 +++
 include/linux/dsa/8021q.h              | 10 ++++++
 net/dsa/tag_8021q.c                    | 48 +++++++++++++++++++++++---
 net/dsa/tag_sja1105.c                  | 31 +++++++++++++++++
 4 files changed, 89 insertions(+), 4 deletions(-)

diff --git a/drivers/net/dsa/sja1105/sja1105_main.c b/drivers/net/dsa/sja1105/sja1105_main.c
index a6a671f0fca5..da042e211dda 100644
--- a/drivers/net/dsa/sja1105/sja1105_main.c
+++ b/drivers/net/dsa/sja1105/sja1105_main.c
@@ -2367,6 +2367,8 @@ static int sja1105_setup(struct dsa_switch *ds)
 	 */
 	ds->vlan_filtering_is_global = true;
 	ds->untag_bridge_pvid = true;
+	/* tag_8021q has 3 bits for the VBID, and the value 0 is reserved */
+	ds->num_fwd_offloading_bridges = 7;
 
 	/* Advertise the 8 egress queues */
 	ds->num_tx_queues = SJA1105_NUM_TC;
@@ -2880,6 +2882,8 @@ static const struct dsa_switch_ops sja1105_switch_ops = {
 	.tag_8021q_vlan_add	= sja1105_dsa_8021q_vlan_add,
 	.tag_8021q_vlan_del	= sja1105_dsa_8021q_vlan_del,
 	.port_prechangeupper	= sja1105_prechangeupper,
+	.port_bridge_tx_fwd_offload = dsa_tag_8021q_bridge_tx_fwd_offload,
+	.port_bridge_tx_fwd_unoffload = dsa_tag_8021q_bridge_tx_fwd_unoffload,
 };
 
 static const struct of_device_id sja1105_dt_ids[];
diff --git a/include/linux/dsa/8021q.h b/include/linux/dsa/8021q.h
index ec5abfcdefd1..c7fa4a3498fe 100644
--- a/include/linux/dsa/8021q.h
+++ b/include/linux/dsa/8021q.h
@@ -35,6 +35,16 @@ struct sk_buff *dsa_8021q_xmit(struct sk_buff *skb, struct net_device *netdev,
 
 void dsa_8021q_rcv(struct sk_buff *skb, int *source_port, int *switch_id);
 
+int dsa_tag_8021q_bridge_tx_fwd_offload(struct dsa_switch *ds, int port,
+					struct net_device *br,
+					int bridge_num);
+
+void dsa_tag_8021q_bridge_tx_fwd_unoffload(struct dsa_switch *ds, int port,
+					   struct net_device *br,
+					   int bridge_num);
+
+u16 dsa_8021q_bridge_tx_fwd_offload_vid(int bridge_num);
+
 u16 dsa_8021q_tx_vid(struct dsa_switch *ds, int port);
 
 u16 dsa_8021q_rx_vid(struct dsa_switch *ds, int port);
diff --git a/net/dsa/tag_8021q.c b/net/dsa/tag_8021q.c
index 51dcde7db26b..654697ebb6f3 100644
--- a/net/dsa/tag_8021q.c
+++ b/net/dsa/tag_8021q.c
@@ -17,7 +17,7 @@
  *
  * | 11  | 10  |  9  |  8  |  7  |  6  |  5  |  4  |  3  |  2  |  1  |  0  |
  * +-----------+-----+-----------------+-----------+-----------------------+
- * |    DIR    | RSV |    SWITCH_ID    |    RSV    |          PORT         |
+ * |    DIR    | VBID|    SWITCH_ID    |   VBID    |          PORT         |
  * +-----------+-----+-----------------+-----------+-----------------------+
  *
  * DIR - VID[11:10]:
@@ -30,9 +30,10 @@
  * SWITCH_ID - VID[8:6]:
  *	Index of switch within DSA tree. Must be between 0 and 7.
  *
- * RSV - VID[5:4]:
- *	To be used for further expansion of PORT or for other purposes.
- *	Must be transmitted as zero and ignored on receive.
+ * VBID - { VID[9], VID[5:4] }:
+ *	Virtual bridge ID. If between 1 and 7, packet targets the broadcast
+ *	domain of a bridge. If transmitted as zero, packet targets a single
+ *	port. Field only valid on transmit, must be ignored on receive.
  *
  * PORT - VID[3:0]:
  *	Index of switch port. Must be between 0 and 15.
@@ -50,11 +51,30 @@
 #define DSA_8021Q_SWITCH_ID(x)		(((x) << DSA_8021Q_SWITCH_ID_SHIFT) & \
 						 DSA_8021Q_SWITCH_ID_MASK)
 
+#define DSA_8021Q_VBID_HI_SHIFT		9
+#define DSA_8021Q_VBID_HI_MASK		GENMASK(9, 9)
+#define DSA_8021Q_VBID_LO_SHIFT		4
+#define DSA_8021Q_VBID_LO_MASK		GENMASK(5, 4)
+#define DSA_8021Q_VBID_HI(x)		(((x) & GENMASK(2, 2)) >> 2)
+#define DSA_8021Q_VBID_LO(x)		((x) & GENMASK(1, 0))
+#define DSA_8021Q_VBID(x)		\
+		(((DSA_8021Q_VBID_LO(x) << DSA_8021Q_VBID_LO_SHIFT) & \
+		  DSA_8021Q_VBID_LO_MASK) | \
+		 ((DSA_8021Q_VBID_HI(x) << DSA_8021Q_VBID_HI_SHIFT) & \
+		  DSA_8021Q_VBID_HI_MASK))
+
 #define DSA_8021Q_PORT_SHIFT		0
 #define DSA_8021Q_PORT_MASK		GENMASK(3, 0)
 #define DSA_8021Q_PORT(x)		(((x) << DSA_8021Q_PORT_SHIFT) & \
 						 DSA_8021Q_PORT_MASK)
 
+u16 dsa_8021q_bridge_tx_fwd_offload_vid(int bridge_num)
+{
+	/* The VBID value of 0 is reserved for precise TX */
+	return DSA_8021Q_DIR_TX | DSA_8021Q_VBID(bridge_num + 1);
+}
+EXPORT_SYMBOL_GPL(dsa_8021q_bridge_tx_fwd_offload_vid);
+
 /* Returns the VID to be inserted into the frame from xmit for switch steering
  * instructions on egress. Encodes switch ID and port ID.
  */
@@ -387,6 +407,26 @@ int dsa_tag_8021q_bridge_leave(struct dsa_switch *ds,
 	return 0;
 }
 
+int dsa_tag_8021q_bridge_tx_fwd_offload(struct dsa_switch *ds, int port,
+					struct net_device *br,
+					int bridge_num)
+{
+	u16 tx_vid = dsa_8021q_bridge_tx_fwd_offload_vid(bridge_num);
+
+	return dsa_port_tag_8021q_vlan_add(dsa_to_port(ds, port), tx_vid);
+}
+EXPORT_SYMBOL_GPL(dsa_tag_8021q_bridge_tx_fwd_offload);
+
+void dsa_tag_8021q_bridge_tx_fwd_unoffload(struct dsa_switch *ds, int port,
+					   struct net_device *br,
+					   int bridge_num)
+{
+	u16 tx_vid = dsa_8021q_bridge_tx_fwd_offload_vid(bridge_num);
+
+	dsa_port_tag_8021q_vlan_del(dsa_to_port(ds, port), tx_vid);
+}
+EXPORT_SYMBOL_GPL(dsa_tag_8021q_bridge_tx_fwd_unoffload);
+
 /* Set up a port's tag_8021q RX and TX VLAN for standalone mode operation */
 static int dsa_tag_8021q_port_setup(struct dsa_switch *ds, int port)
 {
diff --git a/net/dsa/tag_sja1105.c b/net/dsa/tag_sja1105.c
index f142a933c5e2..cddee4b499d8 100644
--- a/net/dsa/tag_sja1105.c
+++ b/net/dsa/tag_sja1105.c
@@ -133,6 +133,31 @@ static u16 sja1105_xmit_tpid(struct sja1105_port *sp)
 	return sp->xmit_tpid;
 }
 
+static struct sk_buff *sja1105_imprecise_xmit(struct sk_buff *skb,
+					      struct net_device *netdev)
+{
+	struct dsa_port *dp = dsa_slave_to_port(netdev);
+	struct net_device *br = dp->bridge_dev;
+	u16 tx_vid;
+
+	/* If the port is under a VLAN-aware bridge, just slide the
+	 * VLAN-tagged packet into the FDB and hope for the best.
+	 * This works because we support a single VLAN-aware bridge
+	 * across the entire dst, and its VLANs cannot be shared with
+	 * any standalone port.
+	 */
+	if (br_vlan_enabled(br))
+		return skb;
+
+	/* If the port is under a VLAN-unaware bridge, use an imprecise
+	 * TX VLAN that targets the bridge's entire broadcast domain,
+	 * instead of just the specific port.
+	 */
+	tx_vid = dsa_8021q_bridge_tx_fwd_offload_vid(dp->bridge_num);
+
+	return dsa_8021q_xmit(skb, netdev, sja1105_xmit_tpid(dp->priv), tx_vid);
+}
+
 static struct sk_buff *sja1105_xmit(struct sk_buff *skb,
 				    struct net_device *netdev)
 {
@@ -141,6 +166,9 @@ static struct sk_buff *sja1105_xmit(struct sk_buff *skb,
 	u16 queue_mapping = skb_get_queue_mapping(skb);
 	u8 pcp = netdev_txq_to_tc(netdev, queue_mapping);
 
+	if (skb->offload_fwd_mark)
+		return sja1105_imprecise_xmit(skb, netdev);
+
 	/* Transmitting management traffic does not rely upon switch tagging,
 	 * but instead SPI-installed management routes. Part 2 of this
 	 * is the .port_deferred_xmit driver callback.
@@ -165,6 +193,9 @@ static struct sk_buff *sja1110_xmit(struct sk_buff *skb,
 	__be16 *tx_header;
 	int trailer_pos;
 
+	if (skb->offload_fwd_mark)
+		return sja1105_imprecise_xmit(skb, netdev);
+
 	/* Transmitting control packets is done using in-band control
 	 * extensions, while data packets are transmitted using
 	 * tag_8021q TX VLANs.
-- 
2.25.1

