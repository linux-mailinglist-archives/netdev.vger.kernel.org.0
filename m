Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id A8B6818C404
	for <lists+netdev@lfdr.de>; Fri, 20 Mar 2020 01:01:12 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727232AbgCTABL (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 19 Mar 2020 20:01:11 -0400
Received: from mail-wm1-f66.google.com ([209.85.128.66]:52950 "EHLO
        mail-wm1-f66.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726827AbgCTABK (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 19 Mar 2020 20:01:10 -0400
Received: by mail-wm1-f66.google.com with SMTP id 11so4759771wmo.2
        for <netdev@vger.kernel.org>; Thu, 19 Mar 2020 17:01:09 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=from:to:cc:subject:date:message-id:in-reply-to:references;
        bh=qPG8YGhxYHBfJkR2D9FWBuX0u/NqlXH0badLhC1fdto=;
        b=Jku5q+LpoXailKkxgP5+FxbBJzkFzf3oF1+seOaV6yN7EJg9UGz7W9wyGpOHRZeeMY
         /DC2eVh7/bNDsHP5O9kcSKZobg3zuTfE+ntic9vnPJFAoU+BYq0s604PrTQPmlm6JB24
         Kf5Gu1XhdqNWu8jzqSq2EG7NdKtjYFDmLZ0h1EIJTsHTt9jaEDoZ8MMFrDEScksIrq1a
         VYUhvw1o22vcsc0PhEgwKCO5p5THFMzUntXLIroUdMSRMETWqj7FQN8HVbubkitZ/uOo
         oN7ECJ5PWb2m2KnSwT376CP6OJKxHXl/YInSzg/IlDc0eB/cP0AOCiOgSMaaXzvnIUU2
         qQMw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references;
        bh=qPG8YGhxYHBfJkR2D9FWBuX0u/NqlXH0badLhC1fdto=;
        b=qj4O2Lldv70E4KKYh72+M7eZsCf4y1Ry2DR9Fdh5/VRebJQvnXpWyD/njF1UAsS9zs
         9cOjf7Yr26OHHQJXZWv39ox14RwpMCEF3GKYrULBEieIDJilvLhJi5NGUzdCnHe9Nk2A
         ILxY2diPwsIXtyjQwBwhF0wQmP6/L3X27EB7xPqy7+EgaeatnOentknU6146dSxnnfjx
         LRZUN32DHIHJqW+cv7gessmEjgfHPHTxpjpWRldzlShzR7qmrgRyQAuUt2rVAfIYaqeu
         AaHgvxrL7KgR5+hZYhVRbGG0ekQM1JWV70Fa9ORAJyui7J0cOqBxPt4mdH5av7CgSZlL
         SIXg==
X-Gm-Message-State: ANhLgQ3c43mhQSuIxh0J3qfVCotx43cxqXFP1V5gqkAoDAMuXyKG40ND
        QlQFoFHFk6YiclKFIKqnax6u7O01vZbCpg==
X-Google-Smtp-Source: ADFU+vtgCygbzBxL0HjLbxVQcVJZsoklxzAp2CW3d5xVIMqOqr6mQ3t4EBLUml/Pt2W4/qnGpz6k5A==
X-Received: by 2002:a1c:e257:: with SMTP id z84mr6903203wmg.91.1584662468874;
        Thu, 19 Mar 2020 17:01:08 -0700 (PDT)
Received: from localhost.localdomain ([79.115.60.40])
        by smtp.gmail.com with ESMTPSA id t126sm5670418wmb.27.2020.03.19.17.01.07
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 19 Mar 2020 17:01:08 -0700 (PDT)
From:   Vladimir Oltean <olteanv@gmail.com>
To:     davem@davemloft.net
Cc:     netdev@vger.kernel.org, andrew@lunn.ch, f.fainelli@gmail.com,
        vivien.didelot@gmail.com
Subject: [PATCH net 1/3] net: dsa: tag_8021q: replace dsa_8021q_remove_header with __skb_vlan_pop
Date:   Fri, 20 Mar 2020 02:00:49 +0200
Message-Id: <20200320000051.28548-2-olteanv@gmail.com>
X-Mailer: git-send-email 2.17.1
In-Reply-To: <20200320000051.28548-1-olteanv@gmail.com>
References: <20200320000051.28548-1-olteanv@gmail.com>
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Vladimir Oltean <vladimir.oltean@nxp.com>

Not only did this wheel did not need reinventing, but there is also
an issue with it: It doesn't remove the VLAN header in a way that
preserves the L2 payload checksum when that is being provided by the DSA
master hw.  It should recalculate checksum both for the push, before
removing the header, and for the pull afterwards. But the current
implementation is quite dizzying, with pulls followed immediately
afterwards by pushes, the memmove is done before the push, etc.  This
makes a DSA master with RX checksumming offload to print stack traces
with the infamous 'hw csum failure' message.

So remove the dsa_8021q_remove_header function and replace it with
something that actually works with inet checksumming.

Fixes: d461933638ae ("net: dsa: tag_8021q: Create helper function for removing VLAN header")
Signed-off-by: Vladimir Oltean <olteanv@gmail.com>
---
 include/linux/dsa/8021q.h |  7 -------
 net/dsa/tag_8021q.c       | 43 ---------------------------------------
 net/dsa/tag_sja1105.c     | 19 ++++++++---------
 3 files changed, 9 insertions(+), 60 deletions(-)

diff --git a/include/linux/dsa/8021q.h b/include/linux/dsa/8021q.h
index 0aa803c451a3..c620d9139c28 100644
--- a/include/linux/dsa/8021q.h
+++ b/include/linux/dsa/8021q.h
@@ -28,8 +28,6 @@ int dsa_8021q_rx_switch_id(u16 vid);
 
 int dsa_8021q_rx_source_port(u16 vid);
 
-struct sk_buff *dsa_8021q_remove_header(struct sk_buff *skb);
-
 #else
 
 int dsa_port_setup_8021q_tagging(struct dsa_switch *ds, int index,
@@ -64,11 +62,6 @@ int dsa_8021q_rx_source_port(u16 vid)
 	return 0;
 }
 
-struct sk_buff *dsa_8021q_remove_header(struct sk_buff *skb)
-{
-	return NULL;
-}
-
 #endif /* IS_ENABLED(CONFIG_NET_DSA_TAG_8021Q) */
 
 #endif /* _NET_DSA_8021Q_H */
diff --git a/net/dsa/tag_8021q.c b/net/dsa/tag_8021q.c
index 2fb6c26294b5..b97ad93d1c1a 100644
--- a/net/dsa/tag_8021q.c
+++ b/net/dsa/tag_8021q.c
@@ -298,47 +298,4 @@ struct sk_buff *dsa_8021q_xmit(struct sk_buff *skb, struct net_device *netdev,
 }
 EXPORT_SYMBOL_GPL(dsa_8021q_xmit);
 
-/* In the DSA packet_type handler, skb->data points in the middle of the VLAN
- * tag, after tpid and before tci. This is because so far, ETH_HLEN
- * (DMAC, SMAC, EtherType) bytes were pulled.
- * There are 2 bytes of VLAN tag left in skb->data, and upper
- * layers expect the 'real' EtherType to be consumed as well.
- * Coincidentally, a VLAN header is also of the same size as
- * the number of bytes that need to be pulled.
- *
- * skb_mac_header                                      skb->data
- * |                                                       |
- * v                                                       v
- * |   |   |   |   |   |   |   |   |   |   |   |   |   |   |   |   |   |   |
- * +-----------------------+-----------------------+-------+-------+-------+
- * |    Destination MAC    |      Source MAC       |  TPID |  TCI  | EType |
- * +-----------------------+-----------------------+-------+-------+-------+
- * ^                                               |               |
- * |<--VLAN_HLEN-->to                              <---VLAN_HLEN--->
- * from            |
- *       >>>>>>>   v
- *       >>>>>>>   |   |   |   |   |   |   |   |   |   |   |   |   |   |   |
- *       >>>>>>>   +-----------------------+-----------------------+-------+
- *       >>>>>>>   |    Destination MAC    |      Source MAC       | EType |
- *                 +-----------------------+-----------------------+-------+
- *                 ^                                                       ^
- * (now part of    |                                                       |
- *  skb->head)     skb_mac_header                                  skb->data
- */
-struct sk_buff *dsa_8021q_remove_header(struct sk_buff *skb)
-{
-	u8 *from = skb_mac_header(skb);
-	u8 *dest = from + VLAN_HLEN;
-
-	memmove(dest, from, ETH_HLEN - VLAN_HLEN);
-	skb_pull(skb, VLAN_HLEN);
-	skb_push(skb, ETH_HLEN);
-	skb_reset_mac_header(skb);
-	skb_reset_mac_len(skb);
-	skb_pull_rcsum(skb, ETH_HLEN);
-
-	return skb;
-}
-EXPORT_SYMBOL_GPL(dsa_8021q_remove_header);
-
 MODULE_LICENSE("GPL v2");
diff --git a/net/dsa/tag_sja1105.c b/net/dsa/tag_sja1105.c
index 5366ea430349..d553bf36bd41 100644
--- a/net/dsa/tag_sja1105.c
+++ b/net/dsa/tag_sja1105.c
@@ -250,14 +250,14 @@ static struct sk_buff *sja1105_rcv(struct sk_buff *skb,
 {
 	struct sja1105_meta meta = {0};
 	int source_port, switch_id;
-	struct vlan_ethhdr *hdr;
+	struct ethhdr *hdr;
 	u16 tpid, vid, tci;
 	bool is_link_local;
 	bool is_tagged;
 	bool is_meta;
 
-	hdr = vlan_eth_hdr(skb);
-	tpid = ntohs(hdr->h_vlan_proto);
+	hdr = eth_hdr(skb);
+	tpid = ntohs(hdr->h_proto);
 	is_tagged = (tpid == ETH_P_SJA1105);
 	is_link_local = sja1105_is_link_local(skb);
 	is_meta = sja1105_is_meta_frame(skb);
@@ -266,7 +266,12 @@ static struct sk_buff *sja1105_rcv(struct sk_buff *skb,
 
 	if (is_tagged) {
 		/* Normal traffic path. */
-		tci = ntohs(hdr->h_vlan_TCI);
+		skb_push_rcsum(skb, ETH_HLEN);
+		__skb_vlan_pop(skb, &tci);
+		skb_pull_rcsum(skb, ETH_HLEN);
+		skb_reset_network_header(skb);
+		skb_reset_transport_header(skb);
+
 		vid = tci & VLAN_VID_MASK;
 		source_port = dsa_8021q_rx_source_port(vid);
 		switch_id = dsa_8021q_rx_switch_id(vid);
@@ -295,12 +300,6 @@ static struct sk_buff *sja1105_rcv(struct sk_buff *skb,
 		return NULL;
 	}
 
-	/* Delete/overwrite fake VLAN header, DSA expects to not find
-	 * it there, see dsa_switch_rcv: skb_push(skb, ETH_HLEN).
-	 */
-	if (is_tagged)
-		skb = dsa_8021q_remove_header(skb);
-
 	return sja1105_rcv_meta_state_machine(skb, &meta, is_link_local,
 					      is_meta);
 }
-- 
2.17.1

