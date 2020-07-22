Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 2454A229A53
	for <lists+netdev@lfdr.de>; Wed, 22 Jul 2020 16:41:09 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1732690AbgGVOkf (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 22 Jul 2020 10:40:35 -0400
Received: from fllv0015.ext.ti.com ([198.47.19.141]:48440 "EHLO
        fllv0015.ext.ti.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1732593AbgGVOkc (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 22 Jul 2020 10:40:32 -0400
Received: from fllv0035.itg.ti.com ([10.64.41.0])
        by fllv0015.ext.ti.com (8.15.2/8.15.2) with ESMTP id 06MEeQJ3111108;
        Wed, 22 Jul 2020 09:40:26 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=ti.com;
        s=ti-com-17Q1; t=1595428826;
        bh=EMznoGWFT/Dki1fP9MgZbJ6DJPRxnMbCPu6IjCTc+tg=;
        h=From:To:Subject:Date:In-Reply-To:References;
        b=HTYowXMxHCf+W/GLe/FymuehI7c0wvAIBfPm0oFlrBwGYL/vhkxO0ugPCrr+BJu09
         w+0lKbefGDFhdbpOuZCnygy+l6LY6LccYbPDDtdw6reiuFZsOlDeDQSW/wksysjW3f
         /FH4/Tj6bIqoSQWKRr7Ff1uO2LjWHSDXvnOhQu14=
Received: from DLEE109.ent.ti.com (dlee109.ent.ti.com [157.170.170.41])
        by fllv0035.itg.ti.com (8.15.2/8.15.2) with ESMTP id 06MEeQGo112498;
        Wed, 22 Jul 2020 09:40:26 -0500
Received: from DLEE102.ent.ti.com (157.170.170.32) by DLEE109.ent.ti.com
 (157.170.170.41) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_128_CBC_SHA256_P256) id 15.1.1979.3; Wed, 22
 Jul 2020 09:40:26 -0500
Received: from fllv0039.itg.ti.com (10.64.41.19) by DLEE102.ent.ti.com
 (157.170.170.32) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_128_CBC_SHA256_P256) id 15.1.1979.3 via
 Frontend Transport; Wed, 22 Jul 2020 09:40:26 -0500
Received: from uda0868495.fios-router.home (ileax41-snat.itg.ti.com [10.172.224.153])
        by fllv0039.itg.ti.com (8.15.2/8.15.2) with ESMTP id 06MEeMLE043940;
        Wed, 22 Jul 2020 09:40:25 -0500
From:   Murali Karicheri <m-karicheri2@ti.com>
To:     <davem@davemloft.net>, <kuba@kernel.org>, <netdev@vger.kernel.org>,
        <linux-kernel@vger.kernel.org>, <linux-api@vger.kernel.org>,
        <nsekhar@ti.com>, <grygorii.strashko@ti.com>,
        <vinicius.gomes@intel.com>
Subject: [net-next v5 PATCH 6/7] net: prp: add packet handling support
Date:   Wed, 22 Jul 2020 10:40:21 -0400
Message-ID: <20200722144022.15746-7-m-karicheri2@ti.com>
X-Mailer: git-send-email 2.17.1
In-Reply-To: <20200722144022.15746-1-m-karicheri2@ti.com>
References: <20200722144022.15746-1-m-karicheri2@ti.com>
MIME-Version: 1.0
Content-Type: text/plain
X-EXCLAIMER-MD-CONFIG: e1e8a2fd-e40a-4ac6-ac9b-f7e9cc9ee180
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

DAN-P (Dual Attached Nodes PRP) nodes are expected to receive
traditional IP packets as well as PRP (Parallel Redundancy
Protocol) tagged (trailer) packets. PRP trailer is 6 bytes
of PRP protocol unit called RCT, Redundancy Control Trailer
(RCT) similar to HSR tag. PRP network can have traditional
devices such as bridges/switches or PC attached to it and
should be able to communicate. Regular Ethernet devices treat
the RCT as pads.  This patch adds logic to format L2 frames
from network stack to add a trailer (RCT) and send it as
duplicates over the slave interfaces when the protocol is
PRP as per IEC 62439-3. At the ingress, it strips the trailer,
do duplicate detection and rejection and forward a stripped
frame up the network stack. PRP device should accept frames
from Singly Attached Nodes (SAN) and thus the driver mark
the link where the frame came from in the node table.

Signed-off-by: Murali Karicheri <m-karicheri2@ti.com>
---
 net/hsr/hsr_device.c   |  20 ++-
 net/hsr/hsr_forward.c  | 272 ++++++++++++++++++++++++++++++++---------
 net/hsr/hsr_forward.h  |   7 ++
 net/hsr/hsr_framereg.c |  94 +++++++++++---
 net/hsr/hsr_framereg.h |  29 ++++-
 net/hsr/hsr_main.h     |  73 ++++++++++-
 net/hsr/hsr_slave.c    |  24 +++-
 net/hsr/hsr_slave.h    |   2 +
 8 files changed, 433 insertions(+), 88 deletions(-)

diff --git a/net/hsr/hsr_device.c b/net/hsr/hsr_device.c
index 022393bed40a..ab953a1a0d6c 100644
--- a/net/hsr/hsr_device.c
+++ b/net/hsr/hsr_device.c
@@ -443,10 +443,17 @@ static struct hsr_proto_ops hsr_ops = {
 	.create_tagged_frame = hsr_create_tagged_frame,
 	.get_untagged_frame = hsr_get_untagged_frame,
 	.fill_frame_info = hsr_fill_frame_info,
+	.invalid_dan_ingress_frame = hsr_invalid_dan_ingress_frame,
 };
 
 static struct hsr_proto_ops prp_ops = {
 	.send_sv_frame = send_prp_supervision_frame,
+	.create_tagged_frame = prp_create_tagged_frame,
+	.get_untagged_frame = prp_get_untagged_frame,
+	.drop_frame = prp_drop_frame,
+	.fill_frame_info = prp_fill_frame_info,
+	.handle_san_frame = prp_handle_san_frame,
+	.update_san_info = prp_update_san_info,
 };
 
 void hsr_dev_setup(struct net_device *dev)
@@ -508,15 +515,16 @@ int hsr_dev_finalize(struct net_device *hsr_dev, struct net_device *slave[2],
 
 	ether_addr_copy(hsr_dev->dev_addr, slave[0]->dev_addr);
 
-	/* currently PRP is not supported */
-	if (protocol_version == PRP_V1)
-		return -EPROTONOSUPPORT;
-
 	/* initialize protocol specific functions */
-	if (protocol_version == PRP_V1)
+	if (protocol_version == PRP_V1) {
+		/* For PRP, lan_id has most significant 3 bits holding
+		 * the net_id of PRP_LAN_ID
+		 */
+		hsr->net_id = PRP_LAN_ID << 1;
 		hsr->proto_ops = &prp_ops;
-	else
+	} else {
 		hsr->proto_ops = &hsr_ops;
+	}
 
 	/* Make sure we recognize frames from ourselves in hsr_rcv() */
 	res = hsr_create_self_node(hsr, hsr_dev->dev_addr,
diff --git a/net/hsr/hsr_forward.c b/net/hsr/hsr_forward.c
index 33e8136891bc..cadfccd7876e 100644
--- a/net/hsr/hsr_forward.c
+++ b/net/hsr/hsr_forward.c
@@ -17,18 +17,6 @@
 
 struct hsr_node;
 
-struct hsr_frame_info {
-	struct sk_buff *skb_std;
-	struct sk_buff *skb_hsr;
-	struct hsr_port *port_rcv;
-	struct hsr_node *node_src;
-	u16 sequence_nr;
-	bool is_supervision;
-	bool is_vlan;
-	bool is_local_dest;
-	bool is_local_exclusive;
-};
-
 /* The uses I can see for these HSR supervision frames are:
  * 1) Use the frames that are sent after node initialization ("HSR_TLV.Type =
  *    22") to reset any sequence_nr counters belonging to that node. Useful if
@@ -87,8 +75,8 @@ static bool is_supervision_frame(struct hsr_priv *hsr, struct sk_buff *skb)
 	return true;
 }
 
-static struct sk_buff *create_stripped_skb(struct sk_buff *skb_in,
-					   struct hsr_frame_info *frame)
+static struct sk_buff *create_stripped_skb_hsr(struct sk_buff *skb_in,
+					       struct hsr_frame_info *frame)
 {
 	struct sk_buff *skb;
 	int copylen;
@@ -119,35 +107,120 @@ static struct sk_buff *create_stripped_skb(struct sk_buff *skb_in,
 struct sk_buff *hsr_get_untagged_frame(struct hsr_frame_info *frame,
 				       struct hsr_port *port)
 {
-	if (!frame->skb_std)
-		frame->skb_std = create_stripped_skb(frame->skb_hsr, frame);
+	if (!frame->skb_std) {
+		if (frame->skb_hsr) {
+			frame->skb_std =
+				create_stripped_skb_hsr(frame->skb_hsr, frame);
+		} else {
+			/* Unexpected */
+			WARN_ONCE(1, "%s:%d: Unexpected frame received (port_src %s)\n",
+				  __FILE__, __LINE__, port->dev->name);
+			return NULL;
+		}
+	}
+
 	return skb_clone(frame->skb_std, GFP_ATOMIC);
 }
 
+struct sk_buff *prp_get_untagged_frame(struct hsr_frame_info *frame,
+				       struct hsr_port *port)
+{
+	if (!frame->skb_std) {
+		if (frame->skb_prp) {
+			/* trim the skb by len - HSR_HLEN to exclude RCT */
+			skb_trim(frame->skb_prp,
+				 frame->skb_prp->len - HSR_HLEN);
+			frame->skb_std =
+				__pskb_copy(frame->skb_prp,
+					    skb_headroom(frame->skb_prp),
+					    GFP_ATOMIC);
+		} else {
+			/* Unexpected */
+			WARN_ONCE(1, "%s:%d: Unexpected frame received (port_src %s)\n",
+				  __FILE__, __LINE__, port->dev->name);
+			return NULL;
+		}
+	}
+
+	return skb_clone(frame->skb_std, GFP_ATOMIC);
+}
+
+static void prp_set_lan_id(struct prp_rct *trailer,
+			   struct hsr_port *port)
+{
+	int lane_id;
+
+	if (port->type == HSR_PT_SLAVE_A)
+		lane_id = 0;
+	else
+		lane_id = 1;
+
+	/* Add net_id in the upper 3 bits of lane_id */
+	lane_id |= port->hsr->net_id;
+	set_prp_lan_id(trailer, lane_id);
+}
+
+/* Tailroom for PRP rct should have been created before calling this */
+static struct sk_buff *prp_fill_rct(struct sk_buff *skb,
+				    struct hsr_frame_info *frame,
+				    struct hsr_port *port)
+{
+	struct prp_rct *trailer;
+	int min_size = ETH_ZLEN;
+	int lsdu_size;
+
+	if (!skb)
+		return skb;
+
+	if (frame->is_vlan)
+		min_size = VLAN_ETH_ZLEN;
+
+	if (skb_put_padto(skb, min_size))
+		return NULL;
+
+	trailer = (struct prp_rct *)skb_put(skb, HSR_HLEN);
+	lsdu_size = skb->len - 14;
+	if (frame->is_vlan)
+		lsdu_size -= 4;
+	prp_set_lan_id(trailer, port);
+	set_prp_LSDU_size(trailer, lsdu_size);
+	trailer->sequence_nr = htons(frame->sequence_nr);
+	trailer->PRP_suffix = htons(ETH_P_PRP);
+
+	return skb;
+}
+
+static void hsr_set_path_id(struct hsr_ethhdr *hsr_ethhdr,
+			    struct hsr_port *port)
+{
+	int path_id;
+
+	if (port->type == HSR_PT_SLAVE_A)
+		path_id = 0;
+	else
+		path_id = 1;
+
+	set_hsr_tag_path(&hsr_ethhdr->hsr_tag, path_id);
+}
+
 static struct sk_buff *hsr_fill_tag(struct sk_buff *skb,
 				    struct hsr_frame_info *frame,
 				    struct hsr_port *port, u8 proto_version)
 {
 	struct hsr_ethhdr *hsr_ethhdr;
-	int lane_id;
 	int lsdu_size;
 
 	/* pad to minimum packet size which is 60 + 6 (HSR tag) */
 	if (skb_put_padto(skb, ETH_ZLEN + HSR_HLEN))
 		return NULL;
 
-	if (port->type == HSR_PT_SLAVE_A)
-		lane_id = 0;
-	else
-		lane_id = 1;
-
 	lsdu_size = skb->len - 14;
 	if (frame->is_vlan)
 		lsdu_size -= 4;
 
 	hsr_ethhdr = (struct hsr_ethhdr *)skb_mac_header(skb);
 
-	set_hsr_tag_path(&hsr_ethhdr->hsr_tag, lane_id);
+	hsr_set_path_id(hsr_ethhdr, port);
 	set_hsr_tag_LSDU_size(&hsr_ethhdr->hsr_tag, lsdu_size);
 	hsr_ethhdr->hsr_tag.sequence_nr = htons(frame->sequence_nr);
 	hsr_ethhdr->hsr_tag.encap_proto = hsr_ethhdr->ethhdr.h_proto;
@@ -157,16 +230,28 @@ static struct sk_buff *hsr_fill_tag(struct sk_buff *skb,
 	return skb;
 }
 
-static struct sk_buff *create_tagged_skb(struct sk_buff *skb_o,
-					 struct hsr_frame_info *frame,
-					 struct hsr_port *port)
+/* If the original frame was an HSR tagged frame, just clone it to be sent
+ * unchanged. Otherwise, create a private frame especially tagged for 'port'.
+ */
+struct sk_buff *hsr_create_tagged_frame(struct hsr_frame_info *frame,
+					struct hsr_port *port)
 {
-	int movelen;
 	unsigned char *dst, *src;
 	struct sk_buff *skb;
+	int movelen;
+
+	if (frame->skb_hsr) {
+		struct hsr_ethhdr *hsr_ethhdr =
+			(struct hsr_ethhdr *)skb_mac_header(frame->skb_hsr);
+
+		/* set the lane id properly */
+		hsr_set_path_id(hsr_ethhdr, port);
+		return skb_clone(frame->skb_hsr, GFP_ATOMIC);
+	}
 
 	/* Create the new skb with enough headroom to fit the HSR tag */
-	skb = __pskb_copy(skb_o, skb_headroom(skb_o) + HSR_HLEN, GFP_ATOMIC);
+	skb = __pskb_copy(frame->skb_std,
+			  skb_headroom(frame->skb_std) + HSR_HLEN, GFP_ATOMIC);
 	if (!skb)
 		return NULL;
 	skb_reset_mac_header(skb);
@@ -189,21 +274,29 @@ static struct sk_buff *create_tagged_skb(struct sk_buff *skb_o,
 	return hsr_fill_tag(skb, frame, port, port->hsr->prot_version);
 }
 
-/* If the original frame was an HSR tagged frame, just clone it to be sent
- * unchanged. Otherwise, create a private frame especially tagged for 'port'.
- */
-struct sk_buff *hsr_create_tagged_frame(struct hsr_frame_info *frame,
+struct sk_buff *prp_create_tagged_frame(struct hsr_frame_info *frame,
 					struct hsr_port *port)
 {
-	if (frame->skb_hsr)
-		return skb_clone(frame->skb_hsr, GFP_ATOMIC);
+	struct sk_buff *skb;
 
-	if (port->type != HSR_PT_SLAVE_A && port->type != HSR_PT_SLAVE_B) {
-		WARN_ONCE(1, "HSR: Bug: trying to create a tagged frame for a non-ring port");
-		return NULL;
+	if (frame->skb_prp) {
+		struct prp_rct *trailer = skb_get_PRP_rct(frame->skb_prp);
+
+		if (trailer) {
+			prp_set_lan_id(trailer, port);
+		} else {
+			WARN_ONCE(!trailer, "errored PRP skb");
+			return NULL;
+		}
+		return skb_clone(frame->skb_prp, GFP_ATOMIC);
 	}
 
-	return create_tagged_skb(frame->skb_std, frame, port);
+	skb = skb_copy_expand(frame->skb_std, 0,
+			      skb_tailroom(frame->skb_std) + HSR_HLEN,
+			      GFP_ATOMIC);
+	prp_fill_rct(skb, frame, port);
+
+	return skb;
 }
 
 static void hsr_deliver_master(struct sk_buff *skb, struct net_device *dev,
@@ -240,9 +333,18 @@ static int hsr_xmit(struct sk_buff *skb, struct hsr_port *port,
 	return dev_queue_xmit(skb);
 }
 
+bool prp_drop_frame(struct hsr_frame_info *frame, struct hsr_port *port)
+{
+	return ((frame->port_rcv->type == HSR_PT_SLAVE_A &&
+		 port->type ==  HSR_PT_SLAVE_B) ||
+		(frame->port_rcv->type == HSR_PT_SLAVE_B &&
+		 port->type ==  HSR_PT_SLAVE_A));
+}
+
 /* Forward the frame through all devices except:
  * - Back through the receiving device
  * - If it's a HSR frame: through a device where it has passed before
+ * - if it's a PRP frame: through another PRP slave device (no bridge)
  * - To the local HSR master only if the frame is directly addressed to it, or
  *   a non-supervision multicast or broadcast frame.
  *
@@ -270,25 +372,33 @@ static void hsr_forward_do(struct hsr_frame_info *frame)
 		if (port->type != HSR_PT_MASTER && frame->is_local_exclusive)
 			continue;
 
-		/* Don't send frame over port where it has been sent before */
-		if (hsr_register_frame_out(port, frame->node_src,
+		/* Don't send frame over port where it has been sent before.
+		 * Also fro SAN, this shouldn't be done.
+		 */
+		if (!frame->is_from_san &&
+		    hsr_register_frame_out(port, frame->node_src,
 					   frame->sequence_nr))
 			continue;
 
 		if (frame->is_supervision && port->type == HSR_PT_MASTER) {
-			hsr_handle_sup_frame(frame->skb_hsr,
-					     frame->node_src,
-					     frame->port_rcv);
+			hsr_handle_sup_frame(frame);
 			continue;
 		}
 
+		/* Check if frame is to be dropped. Eg. for PRP no forward
+		 * between ports.
+		 */
+		if (hsr->proto_ops->drop_frame &&
+		    hsr->proto_ops->drop_frame(frame, port))
+			continue;
+
 		if (port->type != HSR_PT_MASTER)
 			skb = hsr->proto_ops->create_tagged_frame(frame, port);
 		else
 			skb = hsr->proto_ops->get_untagged_frame(frame, port);
 
 		if (!skb) {
-			/* FIXME: Record the dropped frame? */
+			frame->port_rcv->dev->stats.rx_dropped++;
 			continue;
 		}
 
@@ -319,19 +429,20 @@ static void check_local_dest(struct hsr_priv *hsr, struct sk_buff *skb,
 	}
 }
 
-void hsr_fill_frame_info(__be16 proto, struct sk_buff *skb,
-			 struct hsr_frame_info *frame)
+static void handle_std_frame(struct sk_buff *skb,
+			     struct hsr_frame_info *frame)
 {
-	struct hsr_priv *hsr = frame->port_rcv->hsr;
+	struct hsr_port *port = frame->port_rcv;
+	struct hsr_priv *hsr = port->hsr;
 	unsigned long irqflags;
 
-	if (proto == htons(ETH_P_PRP) || proto == htons(ETH_P_HSR)) {
-		frame->skb_std = NULL;
-		frame->skb_hsr = skb;
-		frame->sequence_nr = hsr_get_skb_sequence_nr(skb);
+	frame->skb_hsr = NULL;
+	frame->skb_prp = NULL;
+	frame->skb_std = skb;
+
+	if (port->type != HSR_PT_MASTER) {
+		frame->is_from_san = true;
 	} else {
-		frame->skb_std = skb;
-		frame->skb_hsr = NULL;
 		/* Sequence nr for the master node */
 		spin_lock_irqsave(&hsr->seqnr_lock, irqflags);
 		frame->sequence_nr = hsr->sequence_nr;
@@ -340,29 +451,74 @@ void hsr_fill_frame_info(__be16 proto, struct sk_buff *skb,
 	}
 }
 
+void hsr_fill_frame_info(__be16 proto, struct sk_buff *skb,
+			 struct hsr_frame_info *frame)
+{
+	if (proto == htons(ETH_P_PRP) ||
+	    proto == htons(ETH_P_HSR)) {
+		/* HSR tagged frame :- Data or Supervision */
+		frame->skb_std = NULL;
+		frame->skb_prp = NULL;
+		frame->skb_hsr = skb;
+		frame->sequence_nr = hsr_get_skb_sequence_nr(skb);
+		return;
+	}
+
+	/* Standard frame or PRP from master port */
+	handle_std_frame(skb, frame);
+}
+
+void prp_fill_frame_info(__be16 proto, struct sk_buff *skb,
+			 struct hsr_frame_info *frame)
+{
+	/* Supervision frame */
+	struct prp_rct *rct = skb_get_PRP_rct(skb);
+
+	if (rct &&
+	    prp_check_lsdu_size(skb, rct, frame->is_supervision)) {
+		frame->skb_hsr = NULL;
+		frame->skb_std = NULL;
+		frame->skb_prp = skb;
+		frame->sequence_nr = prp_get_skb_sequence_nr(rct);
+		return;
+	}
+	handle_std_frame(skb, frame);
+}
+
 static int fill_frame_info(struct hsr_frame_info *frame,
 			   struct sk_buff *skb, struct hsr_port *port)
 {
 	struct hsr_priv *hsr = port->hsr;
+	struct hsr_vlan_ethhdr *vlan_hdr;
 	struct ethhdr *ethhdr;
 	__be16 proto;
 
+	memset(frame, 0, sizeof(*frame));
 	frame->is_supervision = is_supervision_frame(port->hsr, skb);
-	frame->node_src = hsr_get_node(port, skb, frame->is_supervision);
+	frame->node_src = hsr_get_node(port, &hsr->node_db, skb,
+				       frame->is_supervision,
+				       port->type);
 	if (!frame->node_src)
 		return -1; /* Unknown node and !is_supervision, or no mem */
 
 	ethhdr = (struct ethhdr *)skb_mac_header(skb);
 	frame->is_vlan = false;
-	if (ethhdr->h_proto == htons(ETH_P_8021Q)) {
+	proto = ethhdr->h_proto;
+
+	if (proto == htons(ETH_P_8021Q))
 		frame->is_vlan = true;
+
+	if (frame->is_vlan) {
+		vlan_hdr = (struct hsr_vlan_ethhdr *)ethhdr;
+		proto = vlan_hdr->vlanhdr.h_vlan_encapsulated_proto;
 		/* FIXME: */
 		netdev_warn_once(skb->dev, "VLAN not yet supported");
 	}
-	proto = ethhdr->h_proto;
+
+	frame->is_from_san = false;
 	frame->port_rcv = port;
 	hsr->proto_ops->fill_frame_info(proto, skb, frame);
-	check_local_dest(hsr, skb, frame);
+	check_local_dest(port->hsr, skb, frame);
 
 	return 0;
 }
@@ -380,6 +536,7 @@ void hsr_forward_skb(struct sk_buff *skb, struct hsr_port *port)
 
 	if (fill_frame_info(&frame, skb, port) < 0)
 		goto out_drop;
+
 	hsr_register_frame_in(frame.node_src, port, frame.sequence_nr);
 	hsr_forward_do(&frame);
 	/* Gets called for ingress frames as well as egress from master port.
@@ -391,6 +548,7 @@ void hsr_forward_skb(struct sk_buff *skb, struct hsr_port *port)
 	}
 
 	kfree_skb(frame.skb_hsr);
+	kfree_skb(frame.skb_prp);
 	kfree_skb(frame.skb_std);
 	return;
 
diff --git a/net/hsr/hsr_forward.h b/net/hsr/hsr_forward.h
index 893207792d56..618140d484ad 100644
--- a/net/hsr/hsr_forward.h
+++ b/net/hsr/hsr_forward.h
@@ -14,10 +14,17 @@
 #include "hsr_main.h"
 
 void hsr_forward_skb(struct sk_buff *skb, struct hsr_port *port);
+struct sk_buff *prp_create_tagged_frame(struct hsr_frame_info *frame,
+					struct hsr_port *port);
 struct sk_buff *hsr_create_tagged_frame(struct hsr_frame_info *frame,
 					struct hsr_port *port);
 struct sk_buff *hsr_get_untagged_frame(struct hsr_frame_info *frame,
 				       struct hsr_port *port);
+struct sk_buff *prp_get_untagged_frame(struct hsr_frame_info *frame,
+				       struct hsr_port *port);
+bool prp_drop_frame(struct hsr_frame_info *frame, struct hsr_port *port);
+void prp_fill_frame_info(__be16 proto, struct sk_buff *skb,
+			 struct hsr_frame_info *frame);
 void hsr_fill_frame_info(__be16 proto, struct sk_buff *skb,
 			 struct hsr_frame_info *frame);
 #endif /* __HSR_FORWARD_H */
diff --git a/net/hsr/hsr_framereg.c b/net/hsr/hsr_framereg.c
index 13b2190e6556..5c97de459905 100644
--- a/net/hsr/hsr_framereg.c
+++ b/net/hsr/hsr_framereg.c
@@ -127,6 +127,19 @@ void hsr_del_nodes(struct list_head *node_db)
 		kfree(node);
 }
 
+void prp_handle_san_frame(bool san, enum hsr_port_type port,
+			  struct hsr_node *node)
+{
+	/* Mark if the SAN node is over LAN_A or LAN_B */
+	if (port == HSR_PT_SLAVE_A) {
+		node->san_a = true;
+		return;
+	}
+
+	if (port == HSR_PT_SLAVE_B)
+		node->san_b = true;
+}
+
 /* Allocate an hsr_node and add it to node_db. 'addr' is the node's address_A;
  * seq_out is used to initialize filtering of outgoing duplicate frames
  * originating from the newly added node.
@@ -134,7 +147,8 @@ void hsr_del_nodes(struct list_head *node_db)
 static struct hsr_node *hsr_add_node(struct hsr_priv *hsr,
 				     struct list_head *node_db,
 				     unsigned char addr[],
-				     u16 seq_out)
+				     u16 seq_out, bool san,
+				     enum hsr_port_type rx_port)
 {
 	struct hsr_node *new_node, *node;
 	unsigned long now;
@@ -155,6 +169,9 @@ static struct hsr_node *hsr_add_node(struct hsr_priv *hsr,
 	for (i = 0; i < HSR_PT_PORTS; i++)
 		new_node->seq_out[i] = seq_out;
 
+	if (san && hsr->proto_ops->handle_san_frame)
+		hsr->proto_ops->handle_san_frame(san, rx_port, new_node);
+
 	spin_lock_bh(&hsr->list_lock);
 	list_for_each_entry_rcu(node, node_db, mac_list,
 				lockdep_is_held(&hsr->list_lock)) {
@@ -172,15 +189,26 @@ static struct hsr_node *hsr_add_node(struct hsr_priv *hsr,
 	return node;
 }
 
+void prp_update_san_info(struct hsr_node *node, bool is_sup)
+{
+	if (!is_sup)
+		return;
+
+	node->san_a = false;
+	node->san_b = false;
+}
+
 /* Get the hsr_node from which 'skb' was sent.
  */
-struct hsr_node *hsr_get_node(struct hsr_port *port, struct sk_buff *skb,
-			      bool is_sup)
+struct hsr_node *hsr_get_node(struct hsr_port *port, struct list_head *node_db,
+			      struct sk_buff *skb, bool is_sup,
+			      enum hsr_port_type rx_port)
 {
-	struct list_head *node_db = &port->hsr->node_db;
 	struct hsr_priv *hsr = port->hsr;
 	struct hsr_node *node;
 	struct ethhdr *ethhdr;
+	struct prp_rct *rct;
+	bool san = false;
 	u16 seq_out;
 
 	if (!skb_mac_header_was_set(skb))
@@ -189,14 +217,21 @@ struct hsr_node *hsr_get_node(struct hsr_port *port, struct sk_buff *skb,
 	ethhdr = (struct ethhdr *)skb_mac_header(skb);
 
 	list_for_each_entry_rcu(node, node_db, mac_list) {
-		if (ether_addr_equal(node->macaddress_A, ethhdr->h_source))
+		if (ether_addr_equal(node->macaddress_A, ethhdr->h_source)) {
+			if (hsr->proto_ops->update_san_info)
+				hsr->proto_ops->update_san_info(node, is_sup);
 			return node;
-		if (ether_addr_equal(node->macaddress_B, ethhdr->h_source))
+		}
+		if (ether_addr_equal(node->macaddress_B, ethhdr->h_source)) {
+			if (hsr->proto_ops->update_san_info)
+				hsr->proto_ops->update_san_info(node, is_sup);
 			return node;
+		}
 	}
 
-	/* Everyone may create a node entry, connected node to a HSR device. */
-
+	/* Everyone may create a node entry, connected node to a HSR/PRP
+	 * device.
+	 */
 	if (ethhdr->h_proto == htons(ETH_P_PRP) ||
 	    ethhdr->h_proto == htons(ETH_P_HSR)) {
 		/* Use the existing sequence_nr from the tag as starting point
@@ -204,31 +239,47 @@ struct hsr_node *hsr_get_node(struct hsr_port *port, struct sk_buff *skb,
 		 */
 		seq_out = hsr_get_skb_sequence_nr(skb) - 1;
 	} else {
-		/* this is called also for frames from master port and
-		 * so warn only for non master ports
-		 */
-		if (port->type != HSR_PT_MASTER)
-			WARN_ONCE(1, "%s: Non-HSR frame\n", __func__);
-		seq_out = HSR_SEQNR_START;
+		rct = skb_get_PRP_rct(skb);
+		if (rct && prp_check_lsdu_size(skb, rct, is_sup)) {
+			seq_out = prp_get_skb_sequence_nr(rct);
+		} else {
+			if (rx_port != HSR_PT_MASTER)
+				san = true;
+			seq_out = HSR_SEQNR_START;
+		}
 	}
 
-	return hsr_add_node(hsr, node_db, ethhdr->h_source, seq_out);
+	return hsr_add_node(hsr, node_db, ethhdr->h_source, seq_out,
+			    san, rx_port);
 }
 
 /* Use the Supervision frame's info about an eventual macaddress_B for merging
  * nodes that has previously had their macaddress_B registered as a separate
  * node.
  */
-void hsr_handle_sup_frame(struct sk_buff *skb, struct hsr_node *node_curr,
-			  struct hsr_port *port_rcv)
+void hsr_handle_sup_frame(struct hsr_frame_info *frame)
 {
+	struct hsr_node *node_curr = frame->node_src;
+	struct hsr_port *port_rcv = frame->port_rcv;
 	struct hsr_priv *hsr = port_rcv->hsr;
 	struct hsr_sup_payload *hsr_sp;
 	struct hsr_node *node_real;
+	struct sk_buff *skb = NULL;
 	struct list_head *node_db;
 	struct ethhdr *ethhdr;
 	int i;
 
+	/* Here either frame->skb_hsr or frame->skb_prp should be
+	 * valid as supervision frame always will have protocol
+	 * header info.
+	 */
+	if (frame->skb_hsr)
+		skb = frame->skb_hsr;
+	else if (frame->skb_prp)
+		skb = frame->skb_prp;
+	if (!skb)
+		return;
+
 	ethhdr = (struct ethhdr *)skb_mac_header(skb);
 
 	/* Leave the ethernet header. */
@@ -249,7 +300,8 @@ void hsr_handle_sup_frame(struct sk_buff *skb, struct hsr_node *node_curr,
 	if (!node_real)
 		/* No frame received from AddrA of this node yet */
 		node_real = hsr_add_node(hsr, node_db, hsr_sp->macaddress_A,
-					 HSR_SEQNR_START - 1);
+					 HSR_SEQNR_START - 1, true,
+					 port_rcv->type);
 	if (!node_real)
 		goto done; /* No mem */
 	if (node_real == node_curr)
@@ -275,7 +327,11 @@ void hsr_handle_sup_frame(struct sk_buff *skb, struct hsr_node *node_curr,
 	kfree_rcu(node_curr, rcu_head);
 
 done:
-	skb_push(skb, sizeof(struct hsrv1_ethhdr_sp));
+	/* PRP uses v0 header */
+	if (ethhdr->h_proto == htons(ETH_P_HSR))
+		skb_push(skb, sizeof(struct hsrv1_ethhdr_sp));
+	else
+		skb_push(skb, sizeof(struct hsrv0_ethhdr_sp));
 }
 
 /* 'skb' is a frame meant for this host, that is to be passed to upper layers.
diff --git a/net/hsr/hsr_framereg.h b/net/hsr/hsr_framereg.h
index c06447780d05..86b43f539f2c 100644
--- a/net/hsr/hsr_framereg.h
+++ b/net/hsr/hsr_framereg.h
@@ -14,12 +14,26 @@
 
 struct hsr_node;
 
+struct hsr_frame_info {
+	struct sk_buff *skb_std;
+	struct sk_buff *skb_hsr;
+	struct sk_buff *skb_prp;
+	struct hsr_port *port_rcv;
+	struct hsr_node *node_src;
+	u16 sequence_nr;
+	bool is_supervision;
+	bool is_vlan;
+	bool is_local_dest;
+	bool is_local_exclusive;
+	bool is_from_san;
+};
+
 void hsr_del_self_node(struct hsr_priv *hsr);
 void hsr_del_nodes(struct list_head *node_db);
-struct hsr_node *hsr_get_node(struct hsr_port *port, struct sk_buff *skb,
-			      bool is_sup);
-void hsr_handle_sup_frame(struct sk_buff *skb, struct hsr_node *node_curr,
-			  struct hsr_port *port);
+struct hsr_node *hsr_get_node(struct hsr_port *port, struct list_head *node_db,
+			      struct sk_buff *skb, bool is_sup,
+			      enum hsr_port_type rx_port);
+void hsr_handle_sup_frame(struct hsr_frame_info *frame);
 bool hsr_addr_is_self(struct hsr_priv *hsr, unsigned char *addr);
 
 void hsr_addr_subst_source(struct hsr_node *node, struct sk_buff *skb);
@@ -49,6 +63,10 @@ int hsr_get_node_data(struct hsr_priv *hsr,
 		      int *if2_age,
 		      u16 *if2_seq);
 
+void prp_handle_san_frame(bool san, enum hsr_port_type port,
+			  struct hsr_node *node);
+void prp_update_san_info(struct hsr_node *node, bool is_sup);
+
 struct hsr_node {
 	struct list_head	mac_list;
 	unsigned char		macaddress_A[ETH_ALEN];
@@ -57,6 +75,9 @@ struct hsr_node {
 	enum hsr_port_type	addr_B_port;
 	unsigned long		time_in[HSR_PT_PORTS];
 	bool			time_in_stale[HSR_PT_PORTS];
+	/* if the node is a SAN */
+	bool			san_a;
+	bool			san_b;
 	u16			seq_out[HSR_PT_PORTS];
 	struct rcu_head		rcu_head;
 };
diff --git a/net/hsr/hsr_main.h b/net/hsr/hsr_main.h
index 14f442c57a84..7dc92ce5a134 100644
--- a/net/hsr/hsr_main.h
+++ b/net/hsr/hsr_main.h
@@ -12,6 +12,7 @@
 
 #include <linux/netdevice.h>
 #include <linux/list.h>
+#include <linux/if_vlan.h>
 
 /* Time constants as specified in the HSR specification (IEC-62439-3 2010)
  * Table 8.
@@ -86,7 +87,12 @@ struct hsr_ethhdr {
 	struct hsr_tag	hsr_tag;
 } __packed;
 
-/* HSR Supervision Frame data types.
+struct hsr_vlan_ethhdr {
+	struct vlan_ethhdr vlanhdr;
+	struct hsr_tag	hsr_tag;
+} __packed;
+
+/* HSR/PRP Supervision Frame data types.
  * Field names as defined in the IEC:2010 standard for HSR.
  */
 struct hsr_sup_tag {
@@ -142,6 +148,16 @@ struct prp_rct {
 	__be16          PRP_suffix;
 } __packed;
 
+static inline u16 get_prp_LSDU_size(struct prp_rct *rct)
+{
+	return ntohs(rct->lan_id_and_LSDU_size) & 0x0FFF;
+}
+
+static inline void set_prp_lan_id(struct prp_rct *rct, u16 lan_id)
+{
+	rct->lan_id_and_LSDU_size = htons((ntohs(rct->lan_id_and_LSDU_size) &
+					  0x0FFF) | (lan_id << 12));
+}
 static inline void set_prp_LSDU_size(struct prp_rct *rct, u16 LSDU_size)
 {
 	rct->lan_id_and_LSDU_size = htons((ntohs(rct->lan_id_and_LSDU_size) &
@@ -163,16 +179,22 @@ enum hsr_version {
 };
 
 struct hsr_frame_info;
+struct hsr_node;
 
 struct hsr_proto_ops {
 	/* format and send supervision frame */
 	void (*send_sv_frame)(struct hsr_port *port, unsigned long *interval);
+	void (*handle_san_frame)(bool san, enum hsr_port_type port,
+				 struct hsr_node *node);
+	bool (*drop_frame)(struct hsr_frame_info *frame, struct hsr_port *port);
 	struct sk_buff * (*get_untagged_frame)(struct hsr_frame_info *frame,
 					       struct hsr_port *port);
 	struct sk_buff * (*create_tagged_frame)(struct hsr_frame_info *frame,
 						struct hsr_port *port);
 	void (*fill_frame_info)(__be16 proto, struct sk_buff *skb,
 				struct hsr_frame_info *frame);
+	bool (*invalid_dan_ingress_frame)(__be16 protocol);
+	void (*update_san_info)(struct hsr_node *node, bool is_sup);
 };
 
 struct hsr_priv {
@@ -189,6 +211,12 @@ struct hsr_priv {
 	spinlock_t seqnr_lock;	/* locking for sequence_nr */
 	spinlock_t list_lock;	/* locking for node list */
 	struct hsr_proto_ops	*proto_ops;
+#define PRP_LAN_ID	0x5     /* 0x1010 for A and 0x1011 for B. Bit 0 is set
+				 * based on SLAVE_A or SLAVE_B
+				 */
+	u8 net_id;		/* for PRP, it occupies most significant 3 bits
+				 * of lan_id
+				 */
 	unsigned char		sup_multicast_addr[ETH_ALEN];
 #ifdef	CONFIG_DEBUG_FS
 	struct dentry *node_tbl_root;
@@ -209,6 +237,49 @@ static inline u16 hsr_get_skb_sequence_nr(struct sk_buff *skb)
 	return ntohs(hsr_ethhdr->hsr_tag.sequence_nr);
 }
 
+static inline struct prp_rct *skb_get_PRP_rct(struct sk_buff *skb)
+{
+	unsigned char *tail = skb_tail_pointer(skb) - HSR_HLEN;
+
+	struct prp_rct *rct = (struct prp_rct *)tail;
+
+	if (rct->PRP_suffix == htons(ETH_P_PRP))
+		return rct;
+
+	return NULL;
+}
+
+/* Assume caller has confirmed this skb is PRP suffixed */
+static inline u16 prp_get_skb_sequence_nr(struct prp_rct *rct)
+{
+	return ntohs(rct->sequence_nr);
+}
+
+static inline u16 get_prp_lan_id(struct prp_rct *rct)
+{
+	return ntohs(rct->lan_id_and_LSDU_size) >> 12;
+}
+
+/* assume there is a valid rct */
+static inline bool prp_check_lsdu_size(struct sk_buff *skb,
+				       struct prp_rct *rct,
+				       bool is_sup)
+{
+	struct ethhdr *ethhdr;
+	int expected_lsdu_size;
+
+	if (is_sup) {
+		expected_lsdu_size = HSR_V1_SUP_LSDUSIZE;
+	} else {
+		ethhdr = (struct ethhdr *)skb_mac_header(skb);
+		expected_lsdu_size = skb->len - 14;
+		if (ethhdr->h_proto == htons(ETH_P_8021Q))
+			expected_lsdu_size -= 4;
+	}
+
+	return (expected_lsdu_size == get_prp_LSDU_size(rct));
+}
+
 #if IS_ENABLED(CONFIG_DEBUG_FS)
 void hsr_debugfs_rename(struct net_device *dev);
 void hsr_debugfs_init(struct hsr_priv *priv, struct net_device *hsr_dev);
diff --git a/net/hsr/hsr_slave.c b/net/hsr/hsr_slave.c
index b5c0834de338..36d5fcf09c61 100644
--- a/net/hsr/hsr_slave.c
+++ b/net/hsr/hsr_slave.c
@@ -16,12 +16,22 @@
 #include "hsr_forward.h"
 #include "hsr_framereg.h"
 
+bool hsr_invalid_dan_ingress_frame(__be16 protocol)
+{
+	return (protocol != htons(ETH_P_PRP) && protocol != htons(ETH_P_HSR));
+}
+
 static rx_handler_result_t hsr_handle_frame(struct sk_buff **pskb)
 {
 	struct sk_buff *skb = *pskb;
 	struct hsr_port *port;
+	struct hsr_priv *hsr;
 	__be16 protocol;
 
+	/* Packets from dev_loopback_xmit() do not have L2 header, bail out */
+	if (unlikely(skb->pkt_type == PACKET_LOOPBACK))
+		return RX_HANDLER_PASS;
+
 	if (!skb_mac_header_was_set(skb)) {
 		WARN_ONCE(1, "%s: skb invalid", __func__);
 		return RX_HANDLER_PASS;
@@ -30,6 +40,7 @@ static rx_handler_result_t hsr_handle_frame(struct sk_buff **pskb)
 	port = hsr_port_get_rcu(skb->dev);
 	if (!port)
 		goto finish_pass;
+	hsr = port->hsr;
 
 	if (hsr_addr_is_self(port->hsr, eth_hdr(skb)->h_source)) {
 		/* Directly kill frames sent by ourselves */
@@ -37,12 +48,23 @@ static rx_handler_result_t hsr_handle_frame(struct sk_buff **pskb)
 		goto finish_consume;
 	}
 
+	/* For HSR, only tagged frames are expected, but for PRP
+	 * there could be non tagged frames as well from Single
+	 * attached nodes (SANs).
+	 */
 	protocol = eth_hdr(skb)->h_proto;
-	if (protocol != htons(ETH_P_PRP) && protocol != htons(ETH_P_HSR))
+	if (hsr->proto_ops->invalid_dan_ingress_frame &&
+	    hsr->proto_ops->invalid_dan_ingress_frame(protocol))
 		goto finish_pass;
 
 	skb_push(skb, ETH_HLEN);
 
+	if (skb_mac_header(skb) != skb->data) {
+		WARN_ONCE(1, "%s:%d: Malformed frame at source port %s)\n",
+			  __func__, __LINE__, port->dev->name);
+		goto finish_consume;
+	}
+
 	hsr_forward_skb(skb, port);
 
 finish_consume:
diff --git a/net/hsr/hsr_slave.h b/net/hsr/hsr_slave.h
index 9708a4f0ec09..edc4612bb009 100644
--- a/net/hsr/hsr_slave.h
+++ b/net/hsr/hsr_slave.h
@@ -32,4 +32,6 @@ static inline struct hsr_port *hsr_port_get_rcu(const struct net_device *dev)
 				rcu_dereference(dev->rx_handler_data) : NULL;
 }
 
+bool hsr_invalid_dan_ingress_frame(__be16 protocol);
+
 #endif /* __HSR_SLAVE_H */
-- 
2.17.1

