Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 63E861C7655
	for <lists+netdev@lfdr.de>; Wed,  6 May 2020 18:31:09 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1730229AbgEFQa7 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 6 May 2020 12:30:59 -0400
Received: from fllv0015.ext.ti.com ([198.47.19.141]:51748 "EHLO
        fllv0015.ext.ti.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1730013AbgEFQaq (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 6 May 2020 12:30:46 -0400
Received: from fllv0035.itg.ti.com ([10.64.41.0])
        by fllv0015.ext.ti.com (8.15.2/8.15.2) with ESMTP id 046GUeIo087477;
        Wed, 6 May 2020 11:30:40 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=ti.com;
        s=ti-com-17Q1; t=1588782640;
        bh=cNCMPLTurvB38rEd2WObrxZ4bD8NhoZ6vGZvOSig6GQ=;
        h=From:To:Subject:Date:In-Reply-To:References;
        b=Slf/XJ9S5m6w9aeYjv6Dq0yXu2rzNy0z/vUBabh4myAZkD0gdkWY/Xv2j6XPXxrai
         aJTdrX0rAjc2caSXEzMd1QC8YucOhKWt4+fHGsJO3sRBhBqnN9wWQy6qkjh9iIlo+a
         LUCxgm/3+viZC1gj6yUkclWQql3w8FGk6RIGjxz4=
Received: from DFLE113.ent.ti.com (dfle113.ent.ti.com [10.64.6.34])
        by fllv0035.itg.ti.com (8.15.2/8.15.2) with ESMTP id 046GUeo9104803;
        Wed, 6 May 2020 11:30:40 -0500
Received: from DFLE105.ent.ti.com (10.64.6.26) by DFLE113.ent.ti.com
 (10.64.6.34) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_128_CBC_SHA256_P256) id 15.1.1979.3; Wed, 6 May
 2020 11:30:40 -0500
Received: from fllv0039.itg.ti.com (10.64.41.19) by DFLE105.ent.ti.com
 (10.64.6.26) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_128_CBC_SHA256_P256) id 15.1.1979.3 via
 Frontend Transport; Wed, 6 May 2020 11:30:40 -0500
Received: from uda0868495.fios-router.home (ileax41-snat.itg.ti.com [10.172.224.153])
        by fllv0039.itg.ti.com (8.15.2/8.15.2) with ESMTP id 046GUXDp119719;
        Wed, 6 May 2020 11:30:39 -0500
From:   Murali Karicheri <m-karicheri2@ti.com>
To:     <davem@davemloft.net>, <kuba@kernel.org>, <netdev@vger.kernel.org>,
        <linux-kernel@vger.kernel.org>, <linux-api@vger.kernel.org>,
        <nsekhar@ti.com>, <grygorii.strashko@ti.com>
Subject: [net-next RFC PATCH 12/13] net: prp: add packet handling support
Date:   Wed, 6 May 2020 12:30:32 -0400
Message-ID: <20200506163033.3843-13-m-karicheri2@ti.com>
X-Mailer: git-send-email 2.17.1
In-Reply-To: <20200506163033.3843-1-m-karicheri2@ti.com>
References: <20200506163033.3843-1-m-karicheri2@ti.com>
MIME-Version: 1.0
Content-Type: text/plain
X-EXCLAIMER-MD-CONFIG: e1e8a2fd-e40a-4ac6-ac9b-f7e9cc9ee180
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

DAN-P (Dual Attached Nodes PRP) nodes are expected to receive
traditional IP packets as well as PRP (Parallel Redundancy
Protocol) tagged (trailer) packets. This is because PRP network
can have traditional devices such as bridges/swiches or PC
attached to it and should be able to communicate.  This patch
adds logic to format L2 frames from network stack to add a
trailer and send it as duplicates over the slave interfaces
as per IEC 62439-3. At the ingress, it strips the trailer,
do duplicate detection and rejection and forward a stripped
frame up the network stack. As PRP device should accept frames
from Singly Attached Nodes (SAN) and mark the link where the
frame came from in the node table. As Supervisor frame LSDU
size is same for HSR and PRP, rename the constant for the same.

Signed-off-by: Murali Karicheri <m-karicheri2@ti.com>
---
 net/hsr-prp/hsr_prp_device.c   |  16 ++-
 net/hsr-prp/hsr_prp_forward.c  | 235 ++++++++++++++++++++++++++++-----
 net/hsr-prp/hsr_prp_framereg.c |  65 ++++++---
 net/hsr-prp/hsr_prp_framereg.h |   8 +-
 net/hsr-prp/hsr_prp_main.h     |  73 +++++++++-
 net/hsr-prp/hsr_prp_slave.c    |  38 ++++--
 6 files changed, 371 insertions(+), 64 deletions(-)

diff --git a/net/hsr-prp/hsr_prp_device.c b/net/hsr-prp/hsr_prp_device.c
index 3c463e185f64..4c6a7bb95e31 100644
--- a/net/hsr-prp/hsr_prp_device.c
+++ b/net/hsr-prp/hsr_prp_device.c
@@ -278,7 +278,7 @@ static void send_hsr_prp_supervision_frame(struct hsr_prp_port *master,
 	if (proto_ver == HSR_V1) {
 		hsr_tag = skb_put(skb, sizeof(struct hsr_tag));
 		hsr_tag->encap_proto = htons(ETH_P_PRP);
-		set_hsr_tag_LSDU_size(hsr_tag, HSR_V1_SUP_LSDUSIZE);
+		set_hsr_tag_LSDU_size(hsr_tag, HSR_PRP_V1_SUP_LSDUSIZE);
 	}
 
 	hsr_stag = skb_put(skb, sizeof(struct hsr_prp_sup_tag));
@@ -319,7 +319,7 @@ static void send_hsr_prp_supervision_frame(struct hsr_prp_port *master,
 		tail = skb_tail_pointer(skb) - HSR_PRP_HLEN;
 		rct = (struct prp_rct *)tail;
 		rct->PRP_suffix = htons(ETH_P_PRP);
-		set_prp_LSDU_size(rct, HSR_V1_SUP_LSDUSIZE);
+		set_prp_LSDU_size(rct, HSR_PRP_V1_SUP_LSDUSIZE);
 		rct->sequence_nr = htons(master->priv->sequence_nr);
 		master->priv->sequence_nr++;
 	}
@@ -483,10 +483,6 @@ int hsr_prp_dev_finalize(struct net_device *hsr_prp_dev,
 	struct hsr_prp_priv *priv;
 	int res;
 
-	/* PRP not supported yet */
-	if (protocol_version == PRP_V1)
-		return -EPROTONOSUPPORT;
-
 	priv = netdev_priv(hsr_prp_dev);
 	INIT_LIST_HEAD(&priv->ports);
 	INIT_LIST_HEAD(&priv->node_db);
@@ -501,6 +497,14 @@ int hsr_prp_dev_finalize(struct net_device *hsr_prp_dev,
 	if (res < 0)
 		return res;
 
+	priv->prot_version = protocol_version;
+	if (priv->prot_version == PRP_V1) {
+		/* For PRP, lan_id has most significant 3 bits holding
+		 * the net_id of PRP_LAN_ID
+		 */
+		priv->net_id = PRP_LAN_ID << 1;
+	}
+
 	spin_lock_init(&priv->seqnr_lock);
 	/* Overflow soon to find bugs easier: */
 	priv->sequence_nr = HSR_PRP_SEQNR_START;
diff --git a/net/hsr-prp/hsr_prp_forward.c b/net/hsr-prp/hsr_prp_forward.c
index d7e975919322..3305f0b8ac11 100644
--- a/net/hsr-prp/hsr_prp_forward.c
+++ b/net/hsr-prp/hsr_prp_forward.c
@@ -18,6 +18,7 @@ struct hsr_prp_node;
 struct hsr_prp_frame_info {
 	struct sk_buff *skb_std;
 	struct sk_buff *skb_hsr;
+	struct sk_buff *skb_prp;
 	struct hsr_prp_port *port_rcv;
 	struct hsr_prp_node *node_src;
 	u16 sequence_nr;
@@ -25,6 +26,7 @@ struct hsr_prp_frame_info {
 	bool is_vlan;
 	bool is_local_dest;
 	bool is_local_exclusive;
+	bool is_from_san;
 };
 
 /* The uses I can see for these HSR supervision frames are:
@@ -85,8 +87,8 @@ static bool is_supervision_frame(struct hsr_prp_priv *priv, struct sk_buff *skb)
 	return true;
 }
 
-static struct sk_buff *create_stripped_skb(struct sk_buff *skb_in,
-					   struct hsr_prp_frame_info *frame)
+static struct sk_buff *create_stripped_skb_hsr(struct sk_buff *skb_in,
+					       struct hsr_prp_frame_info *frame)
 {
 	struct sk_buff *skb;
 	int copylen;
@@ -118,22 +120,91 @@ static struct sk_buff *create_stripped_skb(struct sk_buff *skb_in,
 static struct sk_buff *frame_get_stripped_skb(struct hsr_prp_frame_info *frame,
 					      struct hsr_prp_port *port)
 {
-	if (!frame->skb_std)
-		frame->skb_std = create_stripped_skb(frame->skb_hsr, frame);
+	if (!frame->skb_std) {
+		if (frame->skb_hsr) {
+			frame->skb_std =
+				create_stripped_skb_hsr(frame->skb_hsr, frame);
+		} else if (frame->skb_prp) {
+			/* trim the skb by len - HSR_PRP_HLEN to exclude
+			 * RCT
+			 */
+			skb_trim(frame->skb_prp,
+				 frame->skb_prp->len - HSR_PRP_HLEN);
+			frame->skb_std =
+				__pskb_copy(frame->skb_prp,
+					    skb_headroom(frame->skb_prp),
+					    GFP_ATOMIC);
+
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
 
-static void hsr_fill_tag(struct sk_buff *skb, struct hsr_prp_frame_info *frame,
-			 struct hsr_prp_port *port, u8 proto_version)
+static void prp_set_lan_id(struct prp_rct *trailor,
+			   struct hsr_prp_port *port)
 {
-	struct hsr_ethhdr *hsr_ethhdr;
 	int lane_id;
-	int lsdu_size;
 
 	if (port->type == HSR_PRP_PT_SLAVE_A)
 		lane_id = 0;
 	else
 		lane_id = 1;
+	/* Add net_id in the upper 3 bits of lane_id */
+	lane_id |= port->priv->net_id;
+
+	set_prp_lan_id(trailor, lane_id);
+}
+
+/* Tailroom for PRP rct should have been created before calling this */
+static void prp_fill_rct(struct sk_buff *skb,
+			 struct hsr_prp_frame_info *frame,
+			 struct hsr_prp_port *port)
+{
+	struct prp_rct *trailor;
+	int lsdu_size;
+
+	if (!skb)
+		return;
+
+	if (frame->is_vlan)
+		skb_put_padto(skb, VLAN_ETH_ZLEN);
+	else
+		skb_put_padto(skb, ETH_ZLEN);
+
+	trailor = (struct prp_rct *)skb_put(skb, HSR_PRP_HLEN);
+	lsdu_size = skb->len - 14;
+	if (frame->is_vlan)
+		lsdu_size -= 4;
+	prp_set_lan_id(trailor, port);
+	set_prp_LSDU_size(trailor, lsdu_size);
+	trailor->sequence_nr = htons(frame->sequence_nr);
+	trailor->PRP_suffix = htons(ETH_P_PRP);
+}
+
+static void hsr_set_path_id(struct hsr_ethhdr *hsr_ethhdr,
+			    struct hsr_prp_port *port)
+{
+	int path_id;
+
+	if (port->type == HSR_PRP_PT_SLAVE_A)
+		path_id = 0;
+	else
+		path_id = 1;
+
+	set_hsr_tag_path(&hsr_ethhdr->hsr_tag, path_id);
+}
+
+static void hsr_fill_tag(struct sk_buff *skb, struct hsr_prp_frame_info *frame,
+			 struct hsr_prp_port *port, u8 proto_version)
+{
+	struct hsr_ethhdr *hsr_ethhdr;
+	int lsdu_size;
 
 	lsdu_size = skb->len - 14;
 	if (frame->is_vlan)
@@ -141,7 +212,7 @@ static void hsr_fill_tag(struct sk_buff *skb, struct hsr_prp_frame_info *frame,
 
 	hsr_ethhdr = (struct hsr_ethhdr *)skb_mac_header(skb);
 
-	set_hsr_tag_path(&hsr_ethhdr->hsr_tag, lane_id);
+	hsr_set_path_id(hsr_ethhdr, port);
 	set_hsr_tag_LSDU_size(&hsr_ethhdr->hsr_tag, lsdu_size);
 	hsr_ethhdr->hsr_tag.sequence_nr = htons(frame->sequence_nr);
 	hsr_ethhdr->hsr_tag.encap_proto = hsr_ethhdr->ethhdr.h_proto;
@@ -157,6 +228,14 @@ static struct sk_buff *create_tagged_skb(struct sk_buff *skb_o,
 	unsigned char *dst, *src;
 	struct sk_buff *skb;
 
+	if (port->priv->prot_version > HSR_V1) {
+		skb = skb_copy_expand(skb_o, 0,
+				      skb_tailroom(skb_o) + HSR_PRP_HLEN,
+				      GFP_ATOMIC);
+		prp_fill_rct(skb, frame, port);
+		return skb;
+	}
+
 	/* Create the new skb with enough headroom to fit the HSR tag */
 	skb = __pskb_copy(skb_o,
 			  skb_headroom(skb_o) + HSR_PRP_HLEN, GFP_ATOMIC);
@@ -187,8 +266,26 @@ static struct sk_buff *create_tagged_skb(struct sk_buff *skb_o,
 static struct sk_buff *frame_get_tagged_skb(struct hsr_prp_frame_info *frame,
 					    struct hsr_prp_port *port)
 {
-	if (frame->skb_hsr)
+	if (frame->skb_hsr) {
+		struct hsr_ethhdr *hsr_ethhdr =
+			(struct hsr_ethhdr *)skb_mac_header(frame->skb_hsr);
+
+		/* set the lane id properly */
+		hsr_set_path_id(hsr_ethhdr, port);
 		return skb_clone(frame->skb_hsr, GFP_ATOMIC);
+	}
+
+	if (frame->skb_prp) {
+		struct prp_rct *trailor = skb_get_PRP_rct(frame->skb_prp);
+
+		if (trailor) {
+			prp_set_lan_id(trailor, port);
+		} else {
+			WARN_ONCE(!trailor, "errored PRP skb");
+			return NULL;
+		}
+		return skb_clone(frame->skb_prp, GFP_ATOMIC);
+	}
 
 	if (port->type != HSR_PRP_PT_SLAVE_A &&
 	    port->type != HSR_PRP_PT_SLAVE_B) {
@@ -236,6 +333,7 @@ static int hsr_prp_xmit(struct sk_buff *skb, struct hsr_prp_port *port,
 /* Forward the frame through all devices except:
  * - Back through the receiving device
  * - If it's a HSR frame: through a device where it has passed before
+ * - if it's a PRP frame: through another PRP slave device (no bridge)
  * - To the local HSR master only if the frame is directly addressed to it, or
  *   a non-supervision multicast or broadcast frame.
  *
@@ -247,7 +345,7 @@ static int hsr_prp_xmit(struct sk_buff *skb, struct hsr_prp_port *port,
 static void hsr_prp_forward_do(struct hsr_prp_frame_info *frame)
 {
 	struct hsr_prp_port *port;
-	struct sk_buff *skb;
+	struct sk_buff *skb = NULL;
 
 	hsr_prp_for_each_port(frame->port_rcv->priv, port) {
 		/* Don't send frame back the way it came */
@@ -263,24 +361,46 @@ static void hsr_prp_forward_do(struct hsr_prp_frame_info *frame)
 		    frame->is_local_exclusive)
 			continue;
 
-		/* Don't send frame over port where it has been sent before */
-		if (hsr_prp_register_frame_out(port, frame->node_src,
+		/* Don't send frame over port where it has been sent before.
+		 * Also fro SAN, this shouldn't be done.
+		 */
+		if (!frame->is_from_san &&
+		    hsr_prp_register_frame_out(port, frame->node_src,
 					       frame->sequence_nr))
 			continue;
 
 		if (frame->is_supervision && port->type == HSR_PRP_PT_MASTER) {
-			hsr_prp_handle_sup_frame(frame->skb_hsr,
-						 frame->node_src,
-						 frame->port_rcv);
+			if (frame->skb_hsr)
+				skb = frame->skb_hsr;
+			else if (frame->skb_prp)
+				skb = frame->skb_prp;
+
+			if (skb)
+				hsr_prp_handle_sup_frame(skb,
+							 frame->node_src,
+							 frame->port_rcv);
 			continue;
 		}
 
+		if (port->priv->prot_version == PRP_V1 &&
+		    ((frame->port_rcv->type == HSR_PRP_PT_SLAVE_A &&
+		    port->type ==  HSR_PRP_PT_SLAVE_B) ||
+		    (frame->port_rcv->type == HSR_PRP_PT_SLAVE_B &&
+		    port->type ==  HSR_PRP_PT_SLAVE_A)))
+			continue;
+
 		if (port->type != HSR_PRP_PT_MASTER)
 			skb = frame_get_tagged_skb(frame, port);
 		else
 			skb = frame_get_stripped_skb(frame, port);
+
 		if (!skb) {
-			/* FIXME: Record the dropped frame? */
+			if (frame->port_rcv->type == HSR_PRP_PT_MASTER) {
+				struct net_device *master_dev =
+				hsr_prp_get_port(port->priv,
+						 HSR_PRP_PT_MASTER)->dev;
+				master_dev->stats.rx_dropped++;
+			}
 			continue;
 		}
 
@@ -314,34 +434,79 @@ static void check_local_dest(struct hsr_prp_priv *priv, struct sk_buff *skb,
 static int fill_frame_info(struct hsr_prp_frame_info *frame,
 			   struct sk_buff *skb, struct hsr_prp_port *port)
 {
+	struct hsr_prp_priv *priv = port->priv;
 	struct ethhdr *ethhdr;
+	struct hsr_vlan_ethhdr *vlan_hdr;
 	unsigned long irqflags;
+	__be16 proto;
 
+	memset(frame, 0, sizeof(*frame));
 	frame->is_supervision = is_supervision_frame(port->priv, skb);
-	frame->node_src = hsr_prp_get_node(port, skb, frame->is_supervision);
+	frame->node_src = hsr_prp_get_node(port, &priv->node_db, skb,
+					   frame->is_supervision,
+					   port->type);
 	if (!frame->node_src)
 		return -1; /* Unknown node and !is_supervision, or no mem */
 
 	ethhdr = (struct ethhdr *)skb_mac_header(skb);
 	frame->is_vlan = false;
-	if (ethhdr->h_proto == htons(ETH_P_8021Q)) {
+	proto = ethhdr->h_proto;
+
+	if (proto == htons(ETH_P_8021Q)) {
 		frame->is_vlan = true;
 		/* FIXME: */
 		WARN_ONCE(1, "HSR: VLAN not yet supported");
 	}
-	if (ethhdr->h_proto == htons(ETH_P_PRP) ||
-	    ethhdr->h_proto == htons(ETH_P_HSR)) {
-		frame->skb_std = NULL;
-		frame->skb_hsr = skb;
-		frame->sequence_nr = hsr_get_skb_sequence_nr(skb);
+
+	if (frame->is_vlan) {
+		vlan_hdr = (struct hsr_vlan_ethhdr *)ethhdr;
+		proto = vlan_hdr->vlanhdr.h_vlan_encapsulated_proto;
+	}
+
+	frame->is_from_san = false;
+	if (proto == htons(ETH_P_PRP) || proto == htons(ETH_P_HSR)) {
+		struct prp_rct *rct = skb_get_PRP_rct(skb);
+
+		if (rct &&
+		    prp_check_lsdu_size(skb, rct, frame->is_supervision)) {
+			frame->skb_hsr = NULL;
+			frame->skb_std = NULL;
+			frame->skb_prp = skb;
+			frame->sequence_nr = prp_get_skb_sequence_nr(rct);
+		} else {
+			frame->skb_std = NULL;
+			frame->skb_prp = NULL;
+			frame->skb_hsr = skb;
+			frame->sequence_nr = hsr_get_skb_sequence_nr(skb);
+		}
 	} else {
-		frame->skb_std = skb;
-		frame->skb_hsr = NULL;
-		/* Sequence nr for the master node */
-		spin_lock_irqsave(&port->priv->seqnr_lock, irqflags);
-		frame->sequence_nr = port->priv->sequence_nr;
-		port->priv->sequence_nr++;
-		spin_unlock_irqrestore(&port->priv->seqnr_lock, irqflags);
+		struct prp_rct *rct = skb_get_PRP_rct(skb);
+
+		if (rct &&
+		    prp_check_lsdu_size(skb, rct, frame->is_supervision) &&
+					port->priv->prot_version == PRP_V1) {
+			frame->skb_hsr = NULL;
+			frame->skb_std = NULL;
+			frame->skb_prp = skb;
+			frame->sequence_nr = prp_get_skb_sequence_nr(rct);
+			frame->is_from_san = false;
+		} else {
+			frame->skb_hsr = NULL;
+			frame->skb_prp = NULL;
+			frame->skb_std = skb;
+
+			if (port->type != HSR_PRP_PT_MASTER) {
+				frame->is_from_san = true;
+			} else {
+				/* Sequence nr for the master node */
+				spin_lock_irqsave(&port->priv->seqnr_lock,
+						  irqflags);
+				frame->sequence_nr = port->priv->sequence_nr;
+				port->priv->sequence_nr++;
+				spin_unlock_irqrestore(&port->priv->seqnr_lock,
+						       irqflags);
+			}
+		}
 	}
 
 	frame->port_rcv = port;
@@ -363,6 +528,12 @@ void hsr_prp_forward_skb(struct sk_buff *skb, struct hsr_prp_port *port)
 
 	if (fill_frame_info(&frame, skb, port) < 0)
 		goto out_drop;
+
+	/* Only accept packets for the protocol we have been configured */
+	if ((frame.skb_hsr && port->priv->prot_version == PRP_V1) ||
+	    (frame.skb_prp && port->priv->prot_version <= HSR_V1))
+		goto out_drop;
+
 	hsr_prp_register_frame_in(frame.node_src, port, frame.sequence_nr);
 	hsr_prp_forward_do(&frame);
 	/* Gets called for ingress frames as well as egress from master port.
@@ -375,6 +546,8 @@ void hsr_prp_forward_skb(struct sk_buff *skb, struct hsr_prp_port *port)
 
 	if (frame.skb_hsr)
 		kfree_skb(frame.skb_hsr);
+	if (frame.skb_prp)
+		kfree_skb(frame.skb_prp);
 	if (frame.skb_std)
 		kfree_skb(frame.skb_std);
 	return;
diff --git a/net/hsr-prp/hsr_prp_framereg.c b/net/hsr-prp/hsr_prp_framereg.c
index 42c673befe2c..ae12cd99868c 100644
--- a/net/hsr-prp/hsr_prp_framereg.c
+++ b/net/hsr-prp/hsr_prp_framereg.c
@@ -136,7 +136,8 @@ void hsr_prp_del_nodes(struct list_head *node_db)
 static struct hsr_prp_node *hsr_prp_add_node(struct hsr_prp_priv *priv,
 					     struct list_head *node_db,
 					     unsigned char addr[],
-					     u16 seq_out)
+					     u16 seq_out, bool san,
+					     enum hsr_prp_port_type rx_port)
 {
 	struct hsr_prp_node *new_node, *node;
 	unsigned long now;
@@ -156,6 +157,13 @@ static struct hsr_prp_node *hsr_prp_add_node(struct hsr_prp_priv *priv,
 		new_node->time_in[i] = now;
 	for (i = 0; i < HSR_PRP_PT_PORTS; i++)
 		new_node->seq_out[i] = seq_out;
+	if (san) {
+		/* Mark if the SAN node is over LAN_A or LAN_B */
+		if (rx_port == HSR_PRP_PT_SLAVE_A)
+			new_node->san_a = true;
+		else if (rx_port == HSR_PRP_PT_SLAVE_B)
+			new_node->san_b = true;
+	}
 
 	spin_lock_bh(&priv->list_lock);
 	list_for_each_entry_rcu(node, node_db, mac_list,
@@ -174,16 +182,28 @@ static struct hsr_prp_node *hsr_prp_add_node(struct hsr_prp_priv *priv,
 	return node;
 }
 
+static void hsr_prp_reset_san_flags(struct hsr_prp_node *node, bool is_sup)
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
 struct hsr_prp_node *hsr_prp_get_node(struct hsr_prp_port *port,
+				      struct list_head *node_db,
 				      struct sk_buff *skb,
-				      bool is_sup)
+				      bool is_sup,
+				      enum hsr_prp_port_type rx_port)
 {
-	struct list_head *node_db = &port->priv->node_db;
 	struct hsr_prp_priv *priv = port->priv;
 	struct hsr_prp_node *node;
 	struct ethhdr *ethhdr;
+	struct prp_rct *rct;
+	bool san = false;
 	u16 seq_out;
 
 	if (!skb_mac_header_was_set(skb))
@@ -192,14 +212,25 @@ struct hsr_prp_node *hsr_prp_get_node(struct hsr_prp_port *port,
 	ethhdr = (struct ethhdr *)skb_mac_header(skb);
 
 	list_for_each_entry_rcu(node, node_db, mac_list) {
-		if (ether_addr_equal(node->macaddress_A, ethhdr->h_source))
+		if (ether_addr_equal(node->macaddress_A, ethhdr->h_source)) {
+			/* reset the san_a/san_b if got a sv frame from
+			 * the node.
+			 */
+			hsr_prp_reset_san_flags(node, is_sup);
 			return node;
-		if (ether_addr_equal(node->macaddress_B, ethhdr->h_source))
+		}
+		if (ether_addr_equal(node->macaddress_B, ethhdr->h_source)) {
+			/* reset the san_a/san_b if got a sv frame from
+			 * the node.
+			 */
+			hsr_prp_reset_san_flags(node, is_sup);
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
@@ -207,15 +238,18 @@ struct hsr_prp_node *hsr_prp_get_node(struct hsr_prp_port *port,
 		 */
 		seq_out = hsr_get_skb_sequence_nr(skb) - 1;
 	} else {
-		/* this is called also for frames from master port and
-		 * so warn only for non master ports
-		 */
-		if (port->type != HSR_PRP_PT_MASTER)
-			WARN_ONCE(1, "%s: Non-HSR frame\n", __func__);
-		seq_out = HSR_PRP_SEQNR_START;
+		rct = skb_get_PRP_rct(skb);
+		if (rct && prp_check_lsdu_size(skb, rct, is_sup)) {
+			seq_out = prp_get_skb_sequence_nr(rct);
+		} else {
+			if (rx_port != HSR_PRP_PT_MASTER)
+				san = true;
+			seq_out = HSR_PRP_SEQNR_START;
+		}
 	}
 
-	return hsr_prp_add_node(priv, node_db, ethhdr->h_source, seq_out);
+	return hsr_prp_add_node(priv, node_db, ethhdr->h_source, seq_out,
+				san, rx_port);
 }
 
 /* Use the Supervision frame's info about an eventual macaddress_B for merging
@@ -253,7 +287,8 @@ void hsr_prp_handle_sup_frame(struct sk_buff *skb,
 	if (!node_real)
 		/* No frame received from AddrA of this node yet */
 		node_real = hsr_prp_add_node(priv, node_db, sp->macaddress_A,
-					     HSR_PRP_SEQNR_START - 1);
+					     HSR_PRP_SEQNR_START - 1, true,
+					     port_rcv->type);
 	if (!node_real)
 		goto done; /* No mem */
 	if (node_real == node_curr)
diff --git a/net/hsr-prp/hsr_prp_framereg.h b/net/hsr-prp/hsr_prp_framereg.h
index be52c55d9b6a..488823e8fecc 100644
--- a/net/hsr-prp/hsr_prp_framereg.h
+++ b/net/hsr-prp/hsr_prp_framereg.h
@@ -15,7 +15,10 @@ struct hsr_prp_node;
 void hsr_prp_del_self_node(struct hsr_prp_priv *priv);
 void hsr_prp_del_nodes(struct list_head *node_db);
 struct hsr_prp_node *hsr_prp_get_node(struct hsr_prp_port *port,
-				      struct sk_buff *skb, bool is_sup);
+				      struct list_head *node_db,
+				      struct sk_buff *skb,
+				      bool is_sup,
+				      enum hsr_prp_port_type rx_port);
 void hsr_prp_handle_sup_frame(struct sk_buff *skb,
 			      struct hsr_prp_node *node_curr,
 			      struct hsr_prp_port *port);
@@ -55,6 +58,9 @@ struct hsr_prp_node {
 	enum hsr_prp_port_type	addr_B_port;
 	unsigned long		time_in[HSR_PRP_PT_PORTS];
 	bool			time_in_stale[HSR_PRP_PT_PORTS];
+	/* if the node is a SAN */
+	bool			san_a;
+	bool			san_b;
 	u16			seq_out[HSR_PRP_PT_PORTS];
 	struct rcu_head		rcu_head;
 };
diff --git a/net/hsr-prp/hsr_prp_main.h b/net/hsr-prp/hsr_prp_main.h
index 17049d040226..0101c2669846 100644
--- a/net/hsr-prp/hsr_prp_main.h
+++ b/net/hsr-prp/hsr_prp_main.h
@@ -10,6 +10,7 @@
 
 #include <linux/netdevice.h>
 #include <linux/list.h>
+#include <linux/if_vlan.h>
 
 /* Time constants as specified in the HSR specification (IEC-62439-3 2010)
  * Table 8.
@@ -54,7 +55,7 @@ struct hsr_tag {
 
 #define HSR_PRP_HLEN	6
 
-#define HSR_V1_SUP_LSDUSIZE		52
+#define HSR_PRP_V1_SUP_LSDUSIZE		52
 
 /* The helper functions below assumes that 'path' occupies the 4 most
  * significant bits of the 16-bit field shared by 'path' and 'LSDU_size' (or
@@ -84,8 +85,13 @@ struct hsr_ethhdr {
 	struct hsr_tag	hsr_tag;
 } __packed;
 
-/* HSR Supervision Frame data types.
- * Field names as defined in the IEC:2010 standard for HSR.
+struct hsr_vlan_ethhdr {
+	struct vlan_ethhdr vlanhdr;
+	struct hsr_tag	hsr_tag;
+} __packed;
+
+/* HSR/PRP Supervision Frame data types.
+ * Field names as defined in the IEC:2012 standard for HSR.
  */
 struct hsr_prp_sup_tag {
 	__be16		path_and_HSR_ver;
@@ -141,6 +147,16 @@ struct prp_rct {
 	__be16		PRP_suffix;
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
@@ -172,6 +188,12 @@ struct hsr_prp_priv {
 #define HSR_V0	0
 #define HSR_V1	1
 #define PRP_V1	2
+#define PRP_LAN_ID	0x5     /* 0x1010 for A and 0x1011 for B. Bit 0 is set
+				 * based on SLAVE_A or SLAVE_B
+				 */
+	u8 net_id;		/* for PRP, it occupies most significant 3 bits
+				 * of lan_id
+				 */
 	unsigned char		sup_multicast_addr[ETH_ALEN];
 #ifdef	CONFIG_DEBUG_FS
 	struct dentry *node_tbl_root;
@@ -189,10 +211,55 @@ static inline u16 hsr_get_skb_sequence_nr(struct sk_buff *skb)
 {
 	struct hsr_ethhdr *hsr_ethhdr;
 
+	/* TODO will not work when vlan hdr is present */
 	hsr_ethhdr = (struct hsr_ethhdr *)skb_mac_header(skb);
+
 	return ntohs(hsr_ethhdr->hsr_tag.sequence_nr);
 }
 
+static inline struct prp_rct *skb_get_PRP_rct(struct sk_buff *skb)
+{
+	unsigned char *tail = skb_tail_pointer(skb) - HSR_PRP_HLEN;
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
+		expected_lsdu_size = HSR_PRP_V1_SUP_LSDUSIZE;
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
 void hsr_prp_debugfs_rename(struct net_device *dev);
 void hsr_prp_debugfs_init(struct hsr_prp_priv *priv, struct net_device *ndev);
diff --git a/net/hsr-prp/hsr_prp_slave.c b/net/hsr-prp/hsr_prp_slave.c
index 63a8dafa1f68..7c7559cd15ee 100644
--- a/net/hsr-prp/hsr_prp_slave.c
+++ b/net/hsr-prp/hsr_prp_slave.c
@@ -18,28 +18,50 @@ static rx_handler_result_t hsr_prp_handle_frame(struct sk_buff **pskb)
 {
 	struct sk_buff *skb = *pskb;
 	struct hsr_prp_port *port;
+	struct hsr_prp_priv *priv;
 	__be16 protocol;
 
-	if (!skb_mac_header_was_set(skb)) {
-		WARN_ONCE(1, "%s: skb invalid", __func__);
-		return RX_HANDLER_PASS;
-	}
-
 	port = hsr_prp_port_get_rcu(skb->dev);
 	if (!port)
 		goto finish_pass;
+	priv = port->priv;
 
-	if (hsr_prp_addr_is_self(port->priv, eth_hdr(skb)->h_source)) {
+	if (!skb_mac_header_was_set(skb)) {
+		WARN_ONCE(1, "%s: skb invalid", __func__);
+		goto finish_pass;
+	}
+
+	if (hsr_prp_addr_is_self(priv, eth_hdr(skb)->h_source)) {
 		/* Directly kill frames sent by ourselves */
 		kfree_skb(skb);
 		goto finish_consume;
 	}
 
+	/* For HSR, non tagged frames are expected, but for PRP
+	 * there could be non tagged frames as well.
+	 */
 	protocol = eth_hdr(skb)->h_proto;
-	if (protocol != htons(ETH_P_PRP) && protocol != htons(ETH_P_HSR))
+	if (protocol != htons(ETH_P_PRP) &&
+	    protocol != htons(ETH_P_HSR) &&
+	    port->priv->prot_version <= HSR_V1)
 		goto finish_pass;
 
-	skb_push(skb, ETH_HLEN);
+	/* Frame is a HSR or PRP frame or frame form a SAN. For
+	 * PRP, only supervisor frame will have a PRP protocol.
+	 */
+	if (protocol == htons(ETH_P_HSR) || protocol == htons(ETH_P_PRP))
+		skb_push(skb, ETH_HLEN);
+
+	/* Not sure why we have to do this as some frames
+	 * don't have the skb->data pointing to mac header for PRP case
+	 */
+	if (skb_mac_header(skb) != skb->data) {
+		skb_push(skb, ETH_HLEN);
+
+		/* do one more check and bail out */
+		if (skb_mac_header(skb) != skb->data)
+			goto finish_consume;
+	}
 
 	hsr_prp_forward_skb(skb, port);
 
-- 
2.17.1

