Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 3FCCA3D9325
	for <lists+netdev@lfdr.de>; Wed, 28 Jul 2021 18:24:53 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230401AbhG1QYu (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 28 Jul 2021 12:24:50 -0400
Received: from us-smtp-delivery-124.mimecast.com ([170.10.133.124]:40892 "EHLO
        us-smtp-delivery-124.mimecast.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S229537AbhG1QYo (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 28 Jul 2021 12:24:44 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1627489482;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=ODP3Lmh29eQiV6enDZGG45Jje9Il0RtrlXidMbt/qVI=;
        b=eEIzndCK8sy3s7BF8S6HWucFz2msSDp0SAX584QKsqUazDc4RqQ8A1iql3WEyWNqtZNtlv
        q8FSYJvP51fu78TNHgAHuWzP97ANOoFHhhFRJ3Nkmf5RQIg0azKTcOXOh7C3VbzYqlgr4V
        sVr0W+tzKpDYZ79q2ojEudGxZxeGM+8=
Received: from mimecast-mx01.redhat.com (mimecast-mx01.redhat.com
 [209.132.183.4]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-366-hi2_Xf2UMhCvPGIWnkYzGA-1; Wed, 28 Jul 2021 12:24:40 -0400
X-MC-Unique: hi2_Xf2UMhCvPGIWnkYzGA-1
Received: from smtp.corp.redhat.com (int-mx06.intmail.prod.int.phx2.redhat.com [10.5.11.16])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mimecast-mx01.redhat.com (Postfix) with ESMTPS id A018A1084F40;
        Wed, 28 Jul 2021 16:24:39 +0000 (UTC)
Received: from gerbillo.redhat.com (ovpn-113-169.ams2.redhat.com [10.36.113.169])
        by smtp.corp.redhat.com (Postfix) with ESMTP id 88D6E5C1B4;
        Wed, 28 Jul 2021 16:24:38 +0000 (UTC)
From:   Paolo Abeni <pabeni@redhat.com>
To:     netdev@vger.kernel.org
Cc:     "David S. Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>,
        Eric Dumazet <edumazet@google.com>
Subject: [PATCH net-next 5/6] skbuff: allow 'slow_gro' for skb carring sock reference
Date:   Wed, 28 Jul 2021 18:24:03 +0200
Message-Id: <4864c71049779d924c1cf9d2cd8a86b064f8fd17.1627405778.git.pabeni@redhat.com>
In-Reply-To: <cover.1627405778.git.pabeni@redhat.com>
References: <cover.1627405778.git.pabeni@redhat.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Scanned-By: MIMEDefang 2.79 on 10.5.11.16
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

This change leverages the infrastructure introduced by the previous
patches to allow soft devices passing to the GRO engine owned skbs
without impacting the fast-path.

It's up to the GRO caller ensuring the slow_gro bit validity before
invoking the GRO engine. The new helper skb_prepare_for_gro() is
introduced for that goal.

On slow_gro, skbs are aggregated only with equal sk.
Additionally, skb truesize on GRO recycle and free is correctly
updated so that sk wmem is not changed by the GRO processing.

rfc-> v1:
 - fixed bad truesize on dev_gro_receive NAPI_FREE
 - use the existing state bit

Signed-off-by: Paolo Abeni <pabeni@redhat.com>
---
 include/net/sock.h |  9 +++++++++
 net/core/dev.c     |  2 ++
 net/core/skbuff.c  | 17 +++++++++++++----
 3 files changed, 24 insertions(+), 4 deletions(-)

diff --git a/include/net/sock.h b/include/net/sock.h
index f23cb259b0e2..ff1be7e7e90b 100644
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
+	skb->slow_gro = 1;
+}
+
 void sk_reset_timer(struct sock *sk, struct timer_list *timer,
 		    unsigned long expires);
 
diff --git a/net/core/dev.c b/net/core/dev.c
index 19565f7497ee..dcc87fcd64ba 100644
--- a/net/core/dev.c
+++ b/net/core/dev.c
@@ -6034,6 +6034,7 @@ static void gro_list_prepare(const struct list_head *head,
 			struct tc_skb_ext *p_ext;
 #endif
 
+			diffs |= p->sk != skb->sk;
 			diffs |= skb_metadata_dst_cmp(p, skb);
 			diffs |= skb_get_nfct(p) ^ skb_get_nfct(skb);
 
@@ -6311,6 +6312,7 @@ static void napi_reuse_skb(struct napi_struct *napi, struct sk_buff *skb)
 	skb_shinfo(skb)->gso_type = 0;
 	skb->truesize = SKB_TRUESIZE(skb_end_offset(skb));
 	if (unlikely(skb->slow_gro)) {
+		skb_orphan(skb);
 		skb_ext_reset(skb);
 		nf_reset_ct(skb);
 		skb->slow_gro = 0;
diff --git a/net/core/skbuff.c b/net/core/skbuff.c
index 8231cbddb6ed..9510cb0807bc 100644
--- a/net/core/skbuff.c
+++ b/net/core/skbuff.c
@@ -958,6 +958,7 @@ void napi_skb_free_stolen_head(struct sk_buff *skb)
 		nf_reset_ct(skb);
 		skb_dst_drop(skb);
 		skb_ext_put(skb);
+		skb_orphan(skb);
 		skb->slow_gro = 0;
 	}
 	napi_skb_cache_put(skb);
@@ -3898,6 +3899,9 @@ int skb_gro_receive_list(struct sk_buff *p, struct sk_buff *skb)
 	NAPI_GRO_CB(p)->last = skb;
 	NAPI_GRO_CB(p)->count++;
 	p->data_len += skb->len;
+
+	/* sk owenrship - if any - completely transferred to the aggregated packet */
+	skb->destructor = NULL;
 	p->truesize += skb->truesize;
 	p->len += skb->len;
 
@@ -4265,6 +4269,7 @@ int skb_gro_receive(struct sk_buff *p, struct sk_buff *skb)
 	unsigned int headlen = skb_headlen(skb);
 	unsigned int len = skb_gro_len(skb);
 	unsigned int delta_truesize;
+	unsigned int new_truesize;
 	struct sk_buff *lp;
 
 	if (unlikely(p->len + len >= 65536 || NAPI_GRO_CB(skb)->flush))
@@ -4296,10 +4301,10 @@ int skb_gro_receive(struct sk_buff *p, struct sk_buff *skb)
 		skb_frag_size_sub(frag, offset);
 
 		/* all fragments truesize : remove (head size + sk_buff) */
-		delta_truesize = skb->truesize -
-				 SKB_TRUESIZE(skb_end_offset(skb));
+		new_truesize = SKB_TRUESIZE(skb_end_offset(skb));
+		delta_truesize = skb->truesize - new_truesize;
 
-		skb->truesize -= skb->data_len;
+		skb->truesize = new_truesize;
 		skb->len -= skb->data_len;
 		skb->data_len = 0;
 
@@ -4328,12 +4333,16 @@ int skb_gro_receive(struct sk_buff *p, struct sk_buff *skb)
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

