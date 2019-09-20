Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 08003B8A36
	for <lists+netdev@lfdr.de>; Fri, 20 Sep 2019 06:49:18 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2437132AbfITEtQ (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 20 Sep 2019 00:49:16 -0400
Received: from a.mx.secunet.com ([62.96.220.36]:51668 "EHLO a.mx.secunet.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1729462AbfITEtP (ORCPT <rfc822;netdev@vger.kernel.org>);
        Fri, 20 Sep 2019 00:49:15 -0400
Received: from localhost (localhost [127.0.0.1])
        by a.mx.secunet.com (Postfix) with ESMTP id A9C45205EA;
        Fri, 20 Sep 2019 06:49:13 +0200 (CEST)
X-Virus-Scanned: by secunet
Received: from a.mx.secunet.com ([127.0.0.1])
        by localhost (a.mx.secunet.com [127.0.0.1]) (amavisd-new, port 10024)
        with ESMTP id i-61xUvCB7Ys; Fri, 20 Sep 2019 06:49:13 +0200 (CEST)
Received: from mail-essen-01.secunet.de (mail-essen-01.secunet.de [10.53.40.204])
        (using TLSv1 with cipher ECDHE-RSA-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by a.mx.secunet.com (Postfix) with ESMTPS id 1FE6620299;
        Fri, 20 Sep 2019 06:49:13 +0200 (CEST)
Received: from gauss2.secunet.de (10.182.7.193) by mail-essen-01.secunet.de
 (10.53.40.204) with Microsoft SMTP Server id 14.3.439.0; Fri, 20 Sep 2019
 06:49:13 +0200
Received: by gauss2.secunet.de (Postfix, from userid 1000)      id D0EEF3182612;
 Fri, 20 Sep 2019 06:49:12 +0200 (CEST)
From:   Steffen Klassert <steffen.klassert@secunet.com>
To:     <netdev@vger.kernel.org>
CC:     Steffen Klassert <steffen.klassert@secunet.com>,
        Willem de Bruijn <willemb@google.com>,
        Paolo Abeni <pabeni@redhat.com>,
        Subash Abhinov Kasiviswanathan <subashab@codeaurora.org>,
        Marcelo Ricardo Leitner <marcelo.leitner@gmail.com>
Subject: [PATCH RFC 4/5] net: Support GRO/GSO fraglist chaining.
Date:   Fri, 20 Sep 2019 06:49:04 +0200
Message-ID: <20190920044905.31759-5-steffen.klassert@secunet.com>
X-Mailer: git-send-email 2.17.1
In-Reply-To: <20190920044905.31759-1-steffen.klassert@secunet.com>
References: <20190920044905.31759-1-steffen.klassert@secunet.com>
MIME-Version: 1.0
Content-Type: text/plain
X-EXCLAIMER-MD-CONFIG: 2c86f778-e09b-4440-8b15-867914633a10
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

This patch adds the core functions to chain/unchain
GSO skbs at the frag_list pointer. This also adds
a new GSO type SKB_GSO_FRAGLIST and a is_flist
flag to napi_gro_cb which indicates that this
flow will be GROed by fraglist chaining.

Signed-off-by: Steffen Klassert <steffen.klassert@secunet.com>
---
 include/linux/netdevice.h |   4 +-
 include/linux/skbuff.h    |   2 +
 net/core/dev.c            |   2 +-
 net/core/skbuff.c         | 106 ++++++++++++++++++++++++++++++++++++++
 4 files changed, 112 insertions(+), 2 deletions(-)

diff --git a/include/linux/netdevice.h b/include/linux/netdevice.h
index 4917cf513bd1..d037e31a1acb 100644
--- a/include/linux/netdevice.h
+++ b/include/linux/netdevice.h
@@ -2306,7 +2306,8 @@ struct napi_gro_cb {
 	/* Number of gro_receive callbacks this packet already went through */
 	u8 recursion_counter:4;
 
-	/* 1 bit hole */
+	/* GRO is done by frag_list pointer chaining. */
+	u8	is_flist:1;
 
 	/* used to support CHECKSUM_COMPLETE for tunneling protocols */
 	__wsum	csum;
@@ -2656,6 +2657,7 @@ struct net_device *dev_get_by_napi_id(unsigned int napi_id);
 int netdev_get_name(struct net *net, char *name, int ifindex);
 int dev_restart(struct net_device *dev);
 int skb_gro_receive(struct sk_buff *p, struct sk_buff *skb);
+int skb_gro_receive_list(struct sk_buff *p, struct sk_buff *skb);
 
 static inline unsigned int skb_gro_offset(const struct sk_buff *skb)
 {
diff --git a/include/linux/skbuff.h b/include/linux/skbuff.h
index c72540813ea7..3d5fd0a0eea7 100644
--- a/include/linux/skbuff.h
+++ b/include/linux/skbuff.h
@@ -3511,6 +3511,8 @@ void skb_scrub_packet(struct sk_buff *skb, bool xnet);
 bool skb_gso_validate_network_len(const struct sk_buff *skb, unsigned int mtu);
 bool skb_gso_validate_mac_len(const struct sk_buff *skb, unsigned int len);
 struct sk_buff *skb_segment(struct sk_buff *skb, netdev_features_t features);
+struct sk_buff *skb_segment_list(struct sk_buff *skb, netdev_features_t features,
+				 unsigned int offset);
 struct sk_buff *skb_vlan_untag(struct sk_buff *skb);
 int skb_ensure_writable(struct sk_buff *skb, int write_len);
 int __skb_vlan_pop(struct sk_buff *skb, u16 *vlan_tci);
diff --git a/net/core/dev.c b/net/core/dev.c
index cc0bbec0f1d7..f2a66198154d 100644
--- a/net/core/dev.c
+++ b/net/core/dev.c
@@ -3109,7 +3109,7 @@ struct sk_buff *__skb_gso_segment(struct sk_buff *skb,
 
 	segs = skb_mac_gso_segment(skb, features);
 
-	if (unlikely(skb_needs_check(skb, tx_path) && !IS_ERR(segs)))
+	if (segs != skb && unlikely(skb_needs_check(skb, tx_path) && !IS_ERR(segs)))
 		skb_warn_bad_offload(skb);
 
 	return segs;
diff --git a/net/core/skbuff.c b/net/core/skbuff.c
index 2b40b5a9425b..3ff56677a6fb 100644
--- a/net/core/skbuff.c
+++ b/net/core/skbuff.c
@@ -3638,6 +3638,112 @@ static inline skb_frag_t skb_head_frag_to_page_desc(struct sk_buff *frag_skb)
 	return head_frag;
 }
 
+struct sk_buff *skb_segment_list(struct sk_buff *skb,
+				 netdev_features_t features,
+				 unsigned int offset)
+{
+	struct sk_buff *list_skb = skb_shinfo(skb)->frag_list;
+	unsigned int tnl_hlen = skb_tnl_header_len(skb);
+	unsigned int delta_truesize = 0;
+	unsigned int delta_len = 0;
+	struct sk_buff *tail = NULL;
+	struct sk_buff *nskb;
+
+	skb_push(skb, -skb_network_offset(skb) + offset);
+
+	skb_shinfo(skb)->frag_list = NULL;
+
+	do {
+		nskb = list_skb;
+		list_skb = list_skb->next;
+
+		if (!tail)
+			skb->next = nskb;
+		else
+			tail->next = nskb;
+
+		tail = nskb;
+
+		delta_len += nskb->len;
+		delta_truesize += nskb->truesize;
+
+		skb_push(nskb, -skb_network_offset(nskb) + offset);
+
+		if (!secpath_exists(nskb))
+			__skb_ext_copy(nskb, skb);
+
+		memcpy(nskb->cb, skb->cb, sizeof(skb->cb));
+
+		nskb->ip_summed = skb->ip_summed;
+		nskb->csum_valid = skb->csum_valid;
+		nskb->tstamp = skb->tstamp;
+		nskb->dev = skb->dev;
+		nskb->queue_mapping = skb->queue_mapping;
+
+		nskb->mac_len = skb->mac_len;
+		nskb->mac_header = skb->mac_header;
+		nskb->transport_header = skb->transport_header;
+		nskb->network_header = skb->network_header;
+		skb_dst_copy(nskb, skb);
+
+		skb_headers_offset_update(nskb, skb_headroom(nskb) - skb_headroom(skb));
+		skb_copy_from_linear_data_offset(skb, -tnl_hlen,
+						 nskb->data - tnl_hlen,
+						 offset + tnl_hlen);
+
+		if (skb_needs_linearize(nskb, features) &&
+		    __skb_linearize(nskb))
+			goto err_linearize;
+
+	} while (list_skb);
+
+	skb->truesize = skb->truesize - delta_truesize;
+	skb->data_len = skb->data_len - delta_len;
+	skb->len = skb->len - delta_len;
+
+	skb_gso_reset(skb);
+
+	skb->prev = tail;
+
+	if (skb_needs_linearize(skb, features) &&
+	    __skb_linearize(skb))
+		goto err_linearize;
+
+	skb_get(skb);
+
+	return skb;
+
+err_linearize:
+	kfree_skb_list(skb->next);
+	skb->next = NULL;
+	return ERR_PTR(-ENOMEM);
+}
+EXPORT_SYMBOL_GPL(skb_segment_list);
+
+int skb_gro_receive_list(struct sk_buff *p, struct sk_buff *skb)
+{
+	if (unlikely(p->len + skb->len >= 65536))
+		return -E2BIG;
+
+	if (NAPI_GRO_CB(p)->last == p)
+		skb_shinfo(p)->frag_list = skb;
+	else
+		NAPI_GRO_CB(p)->last->next = skb;
+
+	skb_pull(skb, skb_gro_offset(skb));
+
+	NAPI_GRO_CB(p)->last = skb;
+	NAPI_GRO_CB(p)->count++;
+	p->data_len += skb->len;
+	p->truesize += skb->truesize;
+	p->len += skb->len;
+
+	NAPI_GRO_CB(skb)->same_flow = 1;
+
+	return 0;
+}
+EXPORT_SYMBOL_GPL(skb_gro_receive_list);
+
 /**
  *	skb_segment - Perform protocol segmentation on skb.
  *	@head_skb: buffer to segment
-- 
2.17.1

