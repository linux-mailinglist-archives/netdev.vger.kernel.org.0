Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 12A4240FCBF
	for <lists+netdev@lfdr.de>; Fri, 17 Sep 2021 17:39:45 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S244103AbhIQPlF (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 17 Sep 2021 11:41:05 -0400
Received: from us-smtp-delivery-124.mimecast.com ([170.10.133.124]:36627 "EHLO
        us-smtp-delivery-124.mimecast.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S243377AbhIQPkg (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 17 Sep 2021 11:40:36 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1631893154;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=MET/cio3IrOSRaBgyuoIC3TW47jET2T5el6yYg5y+y0=;
        b=VwcZYGIanP5uF0rd4nRYcDbTOlQYRb/Jr94NH/+fJ6Oa/cJtqXvA21Y0rQwE422FHvx3Fm
        8Qu/7lEQ4SUudp6/8n7pgXI7SgXr4pK0MqY2qS4EW6ntnM1ClOQR1FRaMMnZ5tAIf4gLnB
        bLQd7EKToNtom3NFxxqfmHwoJig4lU8=
Received: from mimecast-mx01.redhat.com (mimecast-mx01.redhat.com
 [209.132.183.4]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-296-9cd6dl6xMcGTkXhxR-sJWg-1; Fri, 17 Sep 2021 11:39:12 -0400
X-MC-Unique: 9cd6dl6xMcGTkXhxR-sJWg-1
Received: from smtp.corp.redhat.com (int-mx01.intmail.prod.int.phx2.redhat.com [10.5.11.11])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mimecast-mx01.redhat.com (Postfix) with ESMTPS id 85BBA101F010;
        Fri, 17 Sep 2021 15:39:11 +0000 (UTC)
Received: from gerbillo.redhat.com (unknown [10.39.192.44])
        by smtp.corp.redhat.com (Postfix) with ESMTP id E118E18B5E;
        Fri, 17 Sep 2021 15:39:09 +0000 (UTC)
From:   Paolo Abeni <pabeni@redhat.com>
To:     netdev@vger.kernel.org
Cc:     "David S. Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>,
        Mat Martineau <mathew.j.martineau@linux.intel.com>,
        Ayush Sawal <ayush.sawal@chelsio.com>,
        Eric Dumazet <edumazet@google.com>, mptcp@lists.linux.dev
Subject: [RFC PATCH 4/5] Partially revert "tcp: factor out tcp_build_frag()"
Date:   Fri, 17 Sep 2021 17:38:39 +0200
Message-Id: <aa710c161dda06ce999e760fed7dcbe66497b28f.1631888517.git.pabeni@redhat.com>
In-Reply-To: <cover.1631888517.git.pabeni@redhat.com>
References: <cover.1631888517.git.pabeni@redhat.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Scanned-By: MIMEDefang 2.79 on 10.5.11.11
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

This is a partial revert for commit b796d04bd014 ("tcp:
factor out tcp_build_frag()").

MPTCP was the only user of the tcp_build_frag helper, and after
the previous patch MPTCP does not use the mentioned helper anymore.
Let's avoid exposing TCP internals.

The revert is partial, as tcp_remove_empty_skb(), exposed
by the same commit is still required.

Acked-by: Mat Martineau <mathew.j.martineau@linux.intel.com>
Signed-off-by: Paolo Abeni <pabeni@redhat.com>
---
 include/net/tcp.h |   2 -
 net/ipv4/tcp.c    | 117 ++++++++++++++++++++--------------------------
 2 files changed, 51 insertions(+), 68 deletions(-)

diff --git a/include/net/tcp.h b/include/net/tcp.h
index dc52ea8adfc7..91f4397c4c08 100644
--- a/include/net/tcp.h
+++ b/include/net/tcp.h
@@ -330,8 +330,6 @@ int tcp_sendpage(struct sock *sk, struct page *page, int offset, size_t size,
 		 int flags);
 int tcp_sendpage_locked(struct sock *sk, struct page *page, int offset,
 			size_t size, int flags);
-struct sk_buff *tcp_build_frag(struct sock *sk, int size_goal, int flags,
-			       struct page *page, int offset, size_t *size);
 ssize_t do_tcp_sendpages(struct sock *sk, struct page *page, int offset,
 		 size_t size, int flags);
 int tcp_send_mss(struct sock *sk, int *size_goal, int flags);
diff --git a/net/ipv4/tcp.c b/net/ipv4/tcp.c
index 7a3e632b0048..caf0c50d86bc 100644
--- a/net/ipv4/tcp.c
+++ b/net/ipv4/tcp.c
@@ -963,68 +963,6 @@ void tcp_remove_empty_skb(struct sock *sk, struct sk_buff *skb)
 	}
 }
 
-struct sk_buff *tcp_build_frag(struct sock *sk, int size_goal, int flags,
-			       struct page *page, int offset, size_t *size)
-{
-	struct sk_buff *skb = tcp_write_queue_tail(sk);
-	struct tcp_sock *tp = tcp_sk(sk);
-	bool can_coalesce;
-	int copy, i;
-
-	if (!skb || (copy = size_goal - skb->len) <= 0 ||
-	    !tcp_skb_can_collapse_to(skb)) {
-new_segment:
-		if (!sk_stream_memory_free(sk))
-			return NULL;
-
-		skb = sk_stream_alloc_skb(sk, 0, sk->sk_allocation,
-					  tcp_rtx_and_write_queues_empty(sk));
-		if (!skb)
-			return NULL;
-
-#ifdef CONFIG_TLS_DEVICE
-		skb->decrypted = !!(flags & MSG_SENDPAGE_DECRYPTED);
-#endif
-		skb_entail(sk, skb);
-		copy = size_goal;
-	}
-
-	if (copy > *size)
-		copy = *size;
-
-	i = skb_shinfo(skb)->nr_frags;
-	can_coalesce = skb_can_coalesce(skb, i, page, offset);
-	if (!can_coalesce && i >= sysctl_max_skb_frags) {
-		tcp_mark_push(tp, skb);
-		goto new_segment;
-	}
-	if (!sk_wmem_schedule(sk, copy))
-		return NULL;
-
-	if (can_coalesce) {
-		skb_frag_size_add(&skb_shinfo(skb)->frags[i - 1], copy);
-	} else {
-		get_page(page);
-		skb_fill_page_desc(skb, i, page, offset, copy);
-	}
-
-	if (!(flags & MSG_NO_SHARED_FRAGS))
-		skb_shinfo(skb)->flags |= SKBFL_SHARED_FRAG;
-
-	skb->len += copy;
-	skb->data_len += copy;
-	skb->truesize += copy;
-	sk_wmem_queued_add(sk, copy);
-	sk_mem_charge(sk, copy);
-	skb->ip_summed = CHECKSUM_PARTIAL;
-	WRITE_ONCE(tp->write_seq, tp->write_seq + copy);
-	TCP_SKB_CB(skb)->end_seq += copy;
-	tcp_skb_pcount_set(skb, 0);
-
-	*size = copy;
-	return skb;
-}
-
 ssize_t do_tcp_sendpages(struct sock *sk, struct page *page, int offset,
 			 size_t size, int flags)
 {
@@ -1060,13 +998,60 @@ ssize_t do_tcp_sendpages(struct sock *sk, struct page *page, int offset,
 		goto out_err;
 
 	while (size > 0) {
-		struct sk_buff *skb;
-		size_t copy = size;
+		struct sk_buff *skb = tcp_write_queue_tail(sk);
+		int copy, i;
+		bool can_coalesce;
 
-		skb = tcp_build_frag(sk, size_goal, flags, page, offset, &copy);
-		if (!skb)
+		if (!skb || (copy = size_goal - skb->len) <= 0 ||
+		    !tcp_skb_can_collapse_to(skb)) {
+new_segment:
+			if (!sk_stream_memory_free(sk))
+				goto wait_for_space;
+
+			skb = sk_stream_alloc_skb(sk, 0, sk->sk_allocation,
+					tcp_rtx_and_write_queues_empty(sk));
+			if (!skb)
+				goto wait_for_space;
+
+#ifdef CONFIG_TLS_DEVICE
+			skb->decrypted = !!(flags & MSG_SENDPAGE_DECRYPTED);
+#endif
+			skb_entail(sk, skb);
+			copy = size_goal;
+		}
+
+		if (copy > size)
+			copy = size;
+
+		i = skb_shinfo(skb)->nr_frags;
+		can_coalesce = skb_can_coalesce(skb, i, page, offset);
+		if (!can_coalesce && i >= sysctl_max_skb_frags) {
+			tcp_mark_push(tp, skb);
+			goto new_segment;
+		}
+		if (!sk_wmem_schedule(sk, copy))
 			goto wait_for_space;
 
+		if (can_coalesce) {
+			skb_frag_size_add(&skb_shinfo(skb)->frags[i - 1], copy);
+		} else {
+			get_page(page);
+			skb_fill_page_desc(skb, i, page, offset, copy);
+		}
+
+		if (!(flags & MSG_NO_SHARED_FRAGS))
+			skb_shinfo(skb)->flags |= SKBFL_SHARED_FRAG;
+
+		skb->len += copy;
+		skb->data_len += copy;
+		skb->truesize += copy;
+		sk_wmem_queued_add(sk, copy);
+		sk_mem_charge(sk, copy);
+		skb->ip_summed = CHECKSUM_PARTIAL;
+		WRITE_ONCE(tp->write_seq, tp->write_seq + copy);
+		TCP_SKB_CB(skb)->end_seq += copy;
+		tcp_skb_pcount_set(skb, 0);
+
 		if (!copied)
 			TCP_SKB_CB(skb)->tcp_flags &= ~TCPHDR_PSH;
 
-- 
2.26.3

