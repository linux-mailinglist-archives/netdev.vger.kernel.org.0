Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 23C8347671D
	for <lists+netdev@lfdr.de>; Thu, 16 Dec 2021 01:47:36 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232542AbhLPArR (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 15 Dec 2021 19:47:17 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:53400 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232538AbhLPArQ (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 15 Dec 2021 19:47:16 -0500
Received: from mail-pf1-x449.google.com (mail-pf1-x449.google.com [IPv6:2607:f8b0:4864:20::449])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 4EB81C061574
        for <netdev@vger.kernel.org>; Wed, 15 Dec 2021 16:47:16 -0800 (PST)
Received: by mail-pf1-x449.google.com with SMTP id y128-20020a62ce86000000b004ba4a5ab3e2so109536pfg.2
        for <netdev@vger.kernel.org>; Wed, 15 Dec 2021 16:47:16 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20210112;
        h=date:in-reply-to:message-id:mime-version:references:subject:from:to
         :cc;
        bh=qDQT8NpqvTRhC7Nl6AaC4866C2rTVaFhtZpe8aBxuAM=;
        b=IGk3MhuryRKTIyRZY0uPzMrTFHvcD+0xRvBaut+gYSs6vbMRhOBVhdwW3Mj6NfBh3u
         rdHnw9yYg3SuBEtnRt3fg2GJyOLu3p0OWSlwJ95/7okgnCNlm+gJYmXZXPI56MylcQof
         QOW6bR/GQOwk35R18IFTMdYVaryW+88ZGiROcREpgMIWBfKgjpu7nZZOqQbMqDIw3wdZ
         xR2hxqeWvvRr3tgPWvRJ+rRUlpMNNrs3pxfRGd8AqjZ1RyJqEe9+fPkVPyFxc2FWQ85w
         Zp1U+voRjeEI2MPk2BjDJwEKunvxrCAH3mtIRIUNCnCkbTZWSfSEdOLW0LAlc2orQd8a
         5kYg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:date:in-reply-to:message-id:mime-version
         :references:subject:from:to:cc;
        bh=qDQT8NpqvTRhC7Nl6AaC4866C2rTVaFhtZpe8aBxuAM=;
        b=BpjTmsH/DMIOjHS0+mNrqa93t6RgZCOAifyPkzE0vZBgsbyUNe6T5WmDYnudEAZiND
         jjfQSjacCgTUPzIzWYlS3so/P2dCB0GmgMNxq8hpkBwqrG7H7/xT0AJ6r9zsg8FZpl1j
         Tt/EscXAru3K3n0TmWpGGCBezP1m92R0qhlnxCatw8ojo9ZuMZITYaKnBU1YFae8YfAY
         MnQNe9RuaScaujSWA1oFbITCuxAdrbn0eu9lYjMq7t6OzD+70eNpvsAirYfhalvwzmMZ
         yY/krj4RBImNnhrAXf5QihnMDmxYnNVxH0frZC050wdfWexRTyFbsmyrDyzjjixNnbL7
         ULOw==
X-Gm-Message-State: AOAM531Q6qXhC9tRXSw0Ktz5dcltSNKkUzKns7S/zg/DEMHh/h0oF6Gm
        MQqaV29suoy9oAtykInNliOrABZLwHL5J4xtmMX6K7eN12eh29KDR9EVg0CeijRskrcY0E1c9ZC
        r00Ks70U0sw3c0TJ1iDre2aURwdYi9yFZNU3594g6/sQk+PJ0KGZmug/f+AxtqCU+mkQ=
X-Google-Smtp-Source: ABdhPJyepMid8LZYKd4Q754semomEzRELiy6uxvd2Odn/ihPlXLst1L479U/p/3pWNllULxF25uj4td/HSvoEQ==
X-Received: from jeroendb.sea.corp.google.com ([2620:15c:100:202:964d:9084:bbdd:97a9])
 (user=jeroendb job=sendgmr) by 2002:a17:902:ec92:b0:146:86fd:24c7 with SMTP
 id x18-20020a170902ec9200b0014686fd24c7mr13788392plg.57.1639615635700; Wed,
 15 Dec 2021 16:47:15 -0800 (PST)
Date:   Wed, 15 Dec 2021 16:46:49 -0800
In-Reply-To: <20211216004652.1021911-1-jeroendb@google.com>
Message-Id: <20211216004652.1021911-6-jeroendb@google.com>
Mime-Version: 1.0
References: <20211216004652.1021911-1-jeroendb@google.com>
X-Mailer: git-send-email 2.34.1.173.g76aa8bc2d0-goog
Subject: [PATCH net-next 5/8] gve: Add optional metadata descriptor type GVE_TXD_MTD
From:   Jeroen de Borst <jeroendb@google.com>
To:     netdev@vger.kernel.org
Cc:     davem@davemloft.net, kuba@kernel.org,
        Willem de Bruijn <willemb@google.com>,
        David Awogbemila <awogbemila@google.com>
Content-Type: text/plain; charset="UTF-8"
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Willem de Bruijn <willemb@google.com>

Allow drivers to pass metadata along with packet data to the device.
Introduce a new metadata descriptor type

* GVE_TXD_MTD

This descriptor is optional. If present it immediate follows the
packet descriptor and precedes the segment descriptor.

This descriptor may be repeated. Multiple metadata descriptors may
follow. There are no immediate uses for this, this is for future
proofing. At present devices allow only 1 MTD descriptor.

The lower four bits of the type_flags field encode GVE_TXD_MTD.
The upper four bits of the type_flags field encodes a *sub*type.

Introduce one such metadata descriptor subtype

* GVE_MTD_SUBTYPE_PATH

This shares path information with the device for network failure
discovery and robust response:

Linux derives ipv6 flowlabel and ECMP multipath from sk->sk_txhash,
and updates this field on error with sk_rethink_txhash. Allow the host
stack to do the same. Pass the tx_hash value if set. Also communicate
whether the path hash is set, or more exactly, what its type is. Define
two common types

  GVE_MTD_PATH_HASH_NONE
  GVE_MTD_PATH_HASH_L4

Concrete examples of error conditions that are resolved are
mentioned in the commits that add sk_rethink_txhash calls. Such as
commit 7788174e8726 ("tcp: change IPv6 flow-label upon receiving
spurious retransmission").

Experimental results mirror what the theory suggests: where IPv6
FlowLabel is included in path selection (e.g., LAG/ECMP), flowlabel
rotation on TCP timeout avoids the vast majority of TCP disconnects
that would otherwise have occurred during link failures in long-haul
backbones, when an alternative path is available.

Rotation can be applied to various bad connection signals, such as
timeouts and spurious retransmissions. In aggregate, such flow level
signals can help locate network issues. Define initial common states:

  GVE_MTD_PATH_STATE_DEFAULT
  GVE_MTD_PATH_STATE_TIMEOUT
  GVE_MTD_PATH_STATE_CONGESTION
  GVE_MTD_PATH_STATE_RETRANSMIT

Signed-off-by: Willem de Bruijn <willemb@google.com>
Signed-off-by: David Awogbemila <awogbemila@google.com>
---
 drivers/net/ethernet/google/gve/gve.h      |  1 +
 drivers/net/ethernet/google/gve/gve_desc.h | 20 ++++++
 drivers/net/ethernet/google/gve/gve_tx.c   | 73 ++++++++++++++++------
 3 files changed, 74 insertions(+), 20 deletions(-)

diff --git a/drivers/net/ethernet/google/gve/gve.h b/drivers/net/ethernet/google/gve/gve.h
index b6bd8f679127..ed43b8ece5a2 100644
--- a/drivers/net/ethernet/google/gve/gve.h
+++ b/drivers/net/ethernet/google/gve/gve.h
@@ -229,6 +229,7 @@ struct gve_rx_ring {
 /* A TX desc ring entry */
 union gve_tx_desc {
 	struct gve_tx_pkt_desc pkt; /* first desc for a packet */
+	struct gve_tx_mtd_desc mtd; /* optional metadata descriptor */
 	struct gve_tx_seg_desc seg; /* subsequent descs for a packet */
 };
 
diff --git a/drivers/net/ethernet/google/gve/gve_desc.h b/drivers/net/ethernet/google/gve/gve_desc.h
index 4d225a18d8ce..f4ae9e19b844 100644
--- a/drivers/net/ethernet/google/gve/gve_desc.h
+++ b/drivers/net/ethernet/google/gve/gve_desc.h
@@ -33,6 +33,14 @@ struct gve_tx_pkt_desc {
 	__be64	seg_addr;  /* Base address (see note) of this segment */
 } __packed;
 
+struct gve_tx_mtd_desc {
+	u8      type_flags;     /* type is lower 4 bits, subtype upper  */
+	u8      path_state;     /* state is lower 4 bits, hash type upper */
+	__be16  reserved0;
+	__be32  path_hash;
+	__be64  reserved1;
+} __packed;
+
 struct gve_tx_seg_desc {
 	u8	type_flags;	/* type is lower 4 bits, flags upper	*/
 	u8	l3_offset;	/* TSO: 2 byte units to start of IPH	*/
@@ -46,6 +54,7 @@ struct gve_tx_seg_desc {
 #define	GVE_TXD_STD		(0x0 << 4) /* Std with Host Address	*/
 #define	GVE_TXD_TSO		(0x1 << 4) /* TSO with Host Address	*/
 #define	GVE_TXD_SEG		(0x2 << 4) /* Seg with Host Address	*/
+#define	GVE_TXD_MTD		(0x3 << 4) /* Metadata			*/
 
 /* GVE Transmit Descriptor Flags for Std Pkts */
 #define	GVE_TXF_L4CSUM	BIT(0)	/* Need csum offload */
@@ -54,6 +63,17 @@ struct gve_tx_seg_desc {
 /* GVE Transmit Descriptor Flags for TSO Segs */
 #define	GVE_TXSF_IPV6	BIT(1)	/* IPv6 TSO */
 
+/* GVE Transmit Descriptor Options for MTD Segs */
+#define GVE_MTD_SUBTYPE_PATH		0
+
+#define GVE_MTD_PATH_STATE_DEFAULT	0
+#define GVE_MTD_PATH_STATE_TIMEOUT	1
+#define GVE_MTD_PATH_STATE_CONGESTION	2
+#define GVE_MTD_PATH_STATE_RETRANSMIT	3
+
+#define GVE_MTD_PATH_HASH_NONE         (0x0 << 4)
+#define GVE_MTD_PATH_HASH_L4           (0x1 << 4)
+
 /* GVE Receive Packet Descriptor */
 /* The start of an ethernet packet comes 2 bytes into the rx buffer.
  * gVNIC adds this padding so that both the DMA and the L3/4 protocol header
diff --git a/drivers/net/ethernet/google/gve/gve_tx.c b/drivers/net/ethernet/google/gve/gve_tx.c
index a9cb241fedf4..4888bf05fbed 100644
--- a/drivers/net/ethernet/google/gve/gve_tx.c
+++ b/drivers/net/ethernet/google/gve/gve_tx.c
@@ -296,11 +296,14 @@ static inline int gve_skb_fifo_bytes_required(struct gve_tx_ring *tx,
 	return bytes;
 }
 
-/* The most descriptors we could need is MAX_SKB_FRAGS + 3 : 1 for each skb frag,
- * +1 for the skb linear portion, +1 for when tcp hdr needs to be in separate descriptor,
- * and +1 if the payload wraps to the beginning of the FIFO.
+/* The most descriptors we could need is MAX_SKB_FRAGS + 4 :
+ * 1 for each skb frag
+ * 1 for the skb linear portion
+ * 1 for when tcp hdr needs to be in separate descriptor
+ * 1 if the payload wraps to the beginning of the FIFO
+ * 1 for metadata descriptor
  */
-#define MAX_TX_DESC_NEEDED	(MAX_SKB_FRAGS + 3)
+#define MAX_TX_DESC_NEEDED	(MAX_SKB_FRAGS + 4)
 static void gve_tx_unmap_buf(struct device *dev, struct gve_tx_buffer_state *info)
 {
 	if (info->skb) {
@@ -395,6 +398,19 @@ static void gve_tx_fill_pkt_desc(union gve_tx_desc *pkt_desc,
 	pkt_desc->pkt.seg_addr = cpu_to_be64(addr);
 }
 
+static void gve_tx_fill_mtd_desc(union gve_tx_desc *mtd_desc,
+				 struct sk_buff *skb)
+{
+	BUILD_BUG_ON(sizeof(mtd_desc->mtd) != sizeof(mtd_desc->pkt));
+
+	mtd_desc->mtd.type_flags = GVE_TXD_MTD | GVE_MTD_SUBTYPE_PATH;
+	mtd_desc->mtd.path_state = GVE_MTD_PATH_STATE_DEFAULT |
+				   GVE_MTD_PATH_HASH_L4;
+	mtd_desc->mtd.path_hash = cpu_to_be32(skb->hash);
+	mtd_desc->mtd.reserved0 = 0;
+	mtd_desc->mtd.reserved1 = 0;
+}
+
 static void gve_tx_fill_seg_desc(union gve_tx_desc *seg_desc,
 				 struct sk_buff *skb, bool is_gso,
 				 u16 len, u64 addr)
@@ -426,6 +442,7 @@ static int gve_tx_add_skb_copy(struct gve_priv *priv, struct gve_tx_ring *tx, st
 	int pad_bytes, hlen, hdr_nfrags, payload_nfrags, l4_hdr_offset;
 	union gve_tx_desc *pkt_desc, *seg_desc;
 	struct gve_tx_buffer_state *info;
+	int mtd_desc_nr = !!skb->l4_hash;
 	bool is_gso = skb_is_gso(skb);
 	u32 idx = tx->req & tx->mask;
 	int payload_iov = 2;
@@ -457,7 +474,7 @@ static int gve_tx_add_skb_copy(struct gve_priv *priv, struct gve_tx_ring *tx, st
 					   &info->iov[payload_iov]);
 
 	gve_tx_fill_pkt_desc(pkt_desc, skb, is_gso, l4_hdr_offset,
-			     1 + payload_nfrags, hlen,
+			     1 + mtd_desc_nr + payload_nfrags, hlen,
 			     info->iov[hdr_nfrags - 1].iov_offset);
 
 	skb_copy_bits(skb, 0,
@@ -468,8 +485,13 @@ static int gve_tx_add_skb_copy(struct gve_priv *priv, struct gve_tx_ring *tx, st
 				info->iov[hdr_nfrags - 1].iov_len);
 	copy_offset = hlen;
 
+	if (mtd_desc_nr) {
+		next_idx = (tx->req + 1) & tx->mask;
+		gve_tx_fill_mtd_desc(&tx->desc[next_idx], skb);
+	}
+
 	for (i = payload_iov; i < payload_nfrags + payload_iov; i++) {
-		next_idx = (tx->req + 1 + i - payload_iov) & tx->mask;
+		next_idx = (tx->req + 1 + mtd_desc_nr + i - payload_iov) & tx->mask;
 		seg_desc = &tx->desc[next_idx];
 
 		gve_tx_fill_seg_desc(seg_desc, skb, is_gso,
@@ -485,16 +507,17 @@ static int gve_tx_add_skb_copy(struct gve_priv *priv, struct gve_tx_ring *tx, st
 		copy_offset += info->iov[i].iov_len;
 	}
 
-	return 1 + payload_nfrags;
+	return 1 + mtd_desc_nr + payload_nfrags;
 }
 
 static int gve_tx_add_skb_no_copy(struct gve_priv *priv, struct gve_tx_ring *tx,
 				  struct sk_buff *skb)
 {
 	const struct skb_shared_info *shinfo = skb_shinfo(skb);
-	int hlen, payload_nfrags, l4_hdr_offset;
-	union gve_tx_desc *pkt_desc, *seg_desc;
+	int hlen, num_descriptors, l4_hdr_offset;
+	union gve_tx_desc *pkt_desc, *mtd_desc, *seg_desc;
 	struct gve_tx_buffer_state *info;
+	int mtd_desc_nr = !!skb->l4_hash;
 	bool is_gso = skb_is_gso(skb);
 	u32 idx = tx->req & tx->mask;
 	u64 addr;
@@ -523,23 +546,30 @@ static int gve_tx_add_skb_no_copy(struct gve_priv *priv, struct gve_tx_ring *tx,
 	dma_unmap_len_set(info, len, len);
 	dma_unmap_addr_set(info, dma, addr);
 
-	payload_nfrags = shinfo->nr_frags;
+	num_descriptors = 1 + shinfo->nr_frags;
+	if (hlen < len)
+		num_descriptors++;
+	if (mtd_desc_nr)
+		num_descriptors++;
+
+	gve_tx_fill_pkt_desc(pkt_desc, skb, is_gso, l4_hdr_offset,
+			     num_descriptors, hlen, addr);
+
+	if (mtd_desc_nr) {
+		idx = (idx + 1) & tx->mask;
+		mtd_desc = &tx->desc[idx];
+		gve_tx_fill_mtd_desc(mtd_desc, skb);
+	}
+
 	if (hlen < len) {
 		/* For gso the rest of the linear portion of the skb needs to
 		 * be in its own descriptor.
 		 */
-		payload_nfrags++;
-		gve_tx_fill_pkt_desc(pkt_desc, skb, is_gso, l4_hdr_offset,
-				     1 + payload_nfrags, hlen, addr);
-
 		len -= hlen;
 		addr += hlen;
-		idx = (tx->req + 1) & tx->mask;
+		idx = (idx + 1) & tx->mask;
 		seg_desc = &tx->desc[idx];
 		gve_tx_fill_seg_desc(seg_desc, skb, is_gso, len, addr);
-	} else {
-		gve_tx_fill_pkt_desc(pkt_desc, skb, is_gso, l4_hdr_offset,
-				     1 + payload_nfrags, hlen, addr);
 	}
 
 	for (i = 0; i < shinfo->nr_frags; i++) {
@@ -560,11 +590,14 @@ static int gve_tx_add_skb_no_copy(struct gve_priv *priv, struct gve_tx_ring *tx,
 		gve_tx_fill_seg_desc(seg_desc, skb, is_gso, len, addr);
 	}
 
-	return 1 + payload_nfrags;
+	return num_descriptors;
 
 unmap_drop:
-	i += (payload_nfrags == shinfo->nr_frags ? 1 : 2);
+	i += num_descriptors - shinfo->nr_frags;
 	while (i--) {
+		/* Skip metadata descriptor, if set */
+		if (i == 1 && mtd_desc_nr == 1)
+			continue;
 		idx--;
 		gve_tx_unmap_buf(tx->dev, &tx->info[idx & tx->mask]);
 	}
-- 
2.34.1.173.g76aa8bc2d0-goog

