Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id E152B3D146B
	for <lists+netdev@lfdr.de>; Wed, 21 Jul 2021 18:45:27 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234515AbhGUQEt (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 21 Jul 2021 12:04:49 -0400
Received: from us-smtp-delivery-124.mimecast.com ([170.10.133.124]:28412 "EHLO
        us-smtp-delivery-124.mimecast.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S233926AbhGUQEp (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 21 Jul 2021 12:04:45 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1626885921;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=1/4QUlF7KadB6eq2uDwV7KnaDGeCerDoHkUI4q0rWCA=;
        b=cRWAdXjslbdut8cQ2eEwOTVWo1qY+JrSqsAQHEjFxyZeQpl9vTYq8RrM/rTwxS9nPcGTyY
        htUNZdjmT2gRw6Pqr+e1eKr2rZvmbeyKhOjyejTn8FBQsvgz4rwIsg+rhniLIdC6x6QHCr
        Qoig5bHZzsJq/OpM0La5n02UvY14H4c=
Received: from mimecast-mx01.redhat.com (mimecast-mx01.redhat.com
 [209.132.183.4]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-600-oq9BTWweMdSi0VatEEYh8g-1; Wed, 21 Jul 2021 12:45:20 -0400
X-MC-Unique: oq9BTWweMdSi0VatEEYh8g-1
Received: from smtp.corp.redhat.com (int-mx01.intmail.prod.int.phx2.redhat.com [10.5.11.11])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mimecast-mx01.redhat.com (Postfix) with ESMTPS id 1710F107ACF5;
        Wed, 21 Jul 2021 16:45:19 +0000 (UTC)
Received: from gerbillo.redhat.com (ovpn-114-219.ams2.redhat.com [10.36.114.219])
        by smtp.corp.redhat.com (Postfix) with ESMTP id 30BDF797C0;
        Wed, 21 Jul 2021 16:45:17 +0000 (UTC)
From:   Paolo Abeni <pabeni@redhat.com>
To:     netdev@vger.kernel.org
Cc:     "David S. Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>,
        Florian Westphal <fw@strlen.de>,
        Eric Dumazet <edumazet@google.com>,
        linux-security-module@vger.kernel.org, selinux@vger.kernel.org
Subject: [PATCH RFC 5/9] skbuff: introduce has_sk state bit.
Date:   Wed, 21 Jul 2021 18:44:37 +0200
Message-Id: <aa71304ae4f1cfbcbcbe90667e6c5ec9e953ed6b.1626882513.git.pabeni@redhat.com>
In-Reply-To: <cover.1626882513.git.pabeni@redhat.com>
References: <cover.1626882513.git.pabeni@redhat.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Scanned-By: MIMEDefang 2.79 on 10.5.11.11
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

This change leverages the infrastructure introduced by the previous
patches to allow soft devices passing to the GRO engine owned skbs
without impacting the fast-path.

It's up to the GRO caller ensuring the bit validity before
invoking the GRO engine with the new helper skb_prepare_for_gro().

If the bit is set only skb with equal sk will be aggregated.
Additionally, skb truesize on GRO recycle and free is correctly
updated so that sk wmem is not changed by the GRO processing.

Signed-off-by: Paolo Abeni <pabeni@redhat.com>
---
 include/linux/skbuff.h |  2 ++
 include/net/sock.h     |  9 +++++++++
 net/core/dev.c         |  2 ++
 net/core/skbuff.c      | 13 +++++++++++--
 4 files changed, 24 insertions(+), 2 deletions(-)

diff --git a/include/linux/skbuff.h b/include/linux/skbuff.h
index 03be9a774c58..ea9fdcc7c7ca 100644
--- a/include/linux/skbuff.h
+++ b/include/linux/skbuff.h
@@ -691,6 +691,7 @@ typedef unsigned char *sk_buff_data_t;
  *	@_state: bitmap reporting the presence of some skb state info
  *	@has_nfct: @_state bit for nfct info
  *	@has_dst: @_state bit for dst pointer
+ *	@has_sk: @_state bit for sk pointer, only relevant at GRO time
  *	@active_extensions: @_state bits for active extensions (skb_ext_id types)
  *	@napi_id: id of the NAPI struct this skb came from
  *	@sender_cpu: (aka @napi_id) source CPU in XPS
@@ -872,6 +873,7 @@ struct sk_buff {
 		struct {
 			__u8	has_nfct:1;
 			__u8	has_dst:1;
+			__u8	has_sk:1;
 #ifdef CONFIG_SKB_EXTENSIONS
 			__u8	active_extensions:5;
 #endif
diff --git a/include/net/sock.h b/include/net/sock.h
index f23cb259b0e2..c1f2d896794b 100644
--- a/include/net/sock.h
+++ b/include/net/sock.h
@@ -2249,6 +2249,15 @@ static inline __must_check bool skb_set_owner_sk_safe(struct sk_buff *skb, struc
 	return false;
 }
 
+static inline void skb_prepare_for_gro(struct sk_buff *skb)
+{
+	if (skb->destructor != sock_wfree) {
+		skb_orphan(skb);
+		return;
+	}
+	skb->has_sk = 1;
+}
+
 void sk_reset_timer(struct sock *sk, struct timer_list *timer,
 		    unsigned long expires);
 
diff --git a/net/core/dev.c b/net/core/dev.c
index 70c24ed9ca67..2ef087958fc9 100644
--- a/net/core/dev.c
+++ b/net/core/dev.c
@@ -6022,6 +6022,7 @@ static void gro_list_prepare(const struct list_head *head,
 			struct tc_skb_ext *p_ext;
 #endif
 
+			diffs |= p->sk != skb->sk;
 			diffs |= skb_metadata_dst_cmp(p, skb);
 			diffs |= skb_get_nfct(p) ^ skb_get_nfct(skb);
 
@@ -6299,6 +6300,7 @@ static void napi_reuse_skb(struct napi_struct *napi, struct sk_buff *skb)
 	skb_shinfo(skb)->gso_type = 0;
 	skb->truesize = SKB_TRUESIZE(skb_end_offset(skb));
 	if (unlikely(skb->_state)) {
+		skb_orphan(skb);
 		skb_ext_reset(skb);
 		nf_reset_ct(skb);
 	}
diff --git a/net/core/skbuff.c b/net/core/skbuff.c
index befb49d1a756..9ed754da6e13 100644
--- a/net/core/skbuff.c
+++ b/net/core/skbuff.c
@@ -947,6 +947,7 @@ void napi_skb_free_stolen_head(struct sk_buff *skb)
 		nf_reset_ct(skb);
 		skb_dst_drop(skb);
 		skb_ext_put(skb);
+		skb_orphan(skb);
 	}
 	napi_skb_cache_put(skb);
 }
@@ -3884,6 +3885,9 @@ int skb_gro_receive_list(struct sk_buff *p, struct sk_buff *skb)
 	NAPI_GRO_CB(p)->last = skb;
 	NAPI_GRO_CB(p)->count++;
 	p->data_len += skb->len;
+
+	/* sk owenrship - if any - completely transferred to the aggregated packet */
+	skb->destructor = NULL;
 	p->truesize += skb->truesize;
 	p->len += skb->len;
 
@@ -4285,7 +4289,7 @@ int skb_gro_receive(struct sk_buff *p, struct sk_buff *skb)
 		delta_truesize = skb->truesize -
 				 SKB_TRUESIZE(skb_end_offset(skb));
 
-		skb->truesize -= skb->data_len;
+		/* napi_reuse_skb() will always re-init 'truesize' */
 		skb->len -= skb->data_len;
 		skb->data_len = 0;
 
@@ -4297,6 +4301,7 @@ int skb_gro_receive(struct sk_buff *p, struct sk_buff *skb)
 		struct page *page = virt_to_head_page(skb->head);
 		unsigned int first_size = headlen - offset;
 		unsigned int first_offset;
+		unsigned int new_truesize;
 
 		if (nr_frags + 1 + skbinfo->nr_frags > MAX_SKB_FRAGS)
 			goto merge;
@@ -4314,12 +4319,16 @@ int skb_gro_receive(struct sk_buff *p, struct sk_buff *skb)
 		memcpy(frag + 1, skbinfo->frags, sizeof(*frag) * skbinfo->nr_frags);
 		/* We dont need to clear skbinfo->nr_frags here */
 
-		delta_truesize = skb->truesize - SKB_DATA_ALIGN(sizeof(struct sk_buff));
+		new_truesize = SKB_TRUESIZE(sizeof(struct sk_buff));
+		delta_truesize = skb->truesize - new_truesize;
+		skb->truesize = new_truesize;
 		NAPI_GRO_CB(skb)->free = NAPI_GRO_FREE_STOLEN_HEAD;
 		goto done;
 	}
 
 merge:
+	/* sk owenrship - if any - completely transferred to the aggregated packet */
+	skb->destructor = NULL;
 	delta_truesize = skb->truesize;
 	if (offset > headlen) {
 		unsigned int eat = offset - headlen;
-- 
2.26.3

