Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 7B0C82B030B
	for <lists+netdev@lfdr.de>; Thu, 12 Nov 2020 11:49:04 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727959AbgKLKtD (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 12 Nov 2020 05:49:03 -0500
Received: from us-smtp-delivery-124.mimecast.com ([63.128.21.124]:50733 "EHLO
        us-smtp-delivery-124.mimecast.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1726107AbgKLKtC (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 12 Nov 2020 05:49:02 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1605178140;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=/slgcmxs898KlGneKyZAERwtPDD5/j/VLmsu2rdJHPA=;
        b=V+Bdek7V3nMgzw1CpQYoVQLtwOEYudYLVM2PKwXMQmQvSja+B/NrreqeQif1Nq5O4GZFR2
        j7uYfV4SQYyKVKTCASKT4XoexmM8KXGpHT241DBzxFibRFbRwz5zxqSvAuSeEr7VSO8mgM
        UJ/5sr6mSJtWvWsWv8t5vMzsvA81sUY=
Received: from mimecast-mx01.redhat.com (mimecast-mx01.redhat.com
 [209.132.183.4]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-444-b2pPmcIiPlCqTH1zCpJQLw-1; Thu, 12 Nov 2020 05:48:58 -0500
X-MC-Unique: b2pPmcIiPlCqTH1zCpJQLw-1
Received: from smtp.corp.redhat.com (int-mx06.intmail.prod.int.phx2.redhat.com [10.5.11.16])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mimecast-mx01.redhat.com (Postfix) with ESMTPS id 830A41084D89;
        Thu, 12 Nov 2020 10:48:57 +0000 (UTC)
Received: from gerbillo.redhat.com (ovpn-112-208.ams2.redhat.com [10.36.112.208])
        by smtp.corp.redhat.com (Postfix) with ESMTP id 5B3245C3E1;
        Thu, 12 Nov 2020 10:48:56 +0000 (UTC)
From:   Paolo Abeni <pabeni@redhat.com>
To:     netdev@vger.kernel.org
Cc:     Eric Dumazet <edumazet@google.com>, mptcp@lists.01.org,
        Jakub Kicinski <kuba@kernel.org>
Subject: [PATCH net-next 01/13] tcp: factor out tcp_build_frag()
Date:   Thu, 12 Nov 2020 11:47:59 +0100
Message-Id: <8fcb0ad6f324008ccadfd1811d91b3145bbf95fd.1605175834.git.pabeni@redhat.com>
In-Reply-To: <cover.1605175834.git.pabeni@redhat.com>
References: <cover.1605175834.git.pabeni@redhat.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Scanned-By: MIMEDefang 2.79 on 10.5.11.16
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Will be needed by the next patch, as MPTCP needs to handle
directly the error/memory-allocation-needed path.

No functional changes intended.

Additionally let MPTCP code access the tcp_remove_empty_skb()
helper.

Signed-off-by: Paolo Abeni <pabeni@redhat.com>
---
 include/net/tcp.h |   3 ++
 net/ipv4/tcp.c    | 119 ++++++++++++++++++++++++++--------------------
 2 files changed, 70 insertions(+), 52 deletions(-)

diff --git a/include/net/tcp.h b/include/net/tcp.h
index 4aba0f069b05..374d0a2acc4b 100644
--- a/include/net/tcp.h
+++ b/include/net/tcp.h
@@ -322,6 +322,7 @@ void tcp_shutdown(struct sock *sk, int how);
 int tcp_v4_early_demux(struct sk_buff *skb);
 int tcp_v4_rcv(struct sk_buff *skb);
 
+void tcp_remove_empty_skb(struct sock *sk, struct sk_buff *skb);
 int tcp_v4_tw_remember_stamp(struct inet_timewait_sock *tw);
 int tcp_sendmsg(struct sock *sk, struct msghdr *msg, size_t size);
 int tcp_sendmsg_locked(struct sock *sk, struct msghdr *msg, size_t size);
@@ -329,6 +330,8 @@ int tcp_sendpage(struct sock *sk, struct page *page, int offset, size_t size,
 		 int flags);
 int tcp_sendpage_locked(struct sock *sk, struct page *page, int offset,
 			size_t size, int flags);
+struct sk_buff *tcp_build_frag(struct sock *sk, int size_goal, int flags,
+			       struct page *page, int offset, size_t *size);
 ssize_t do_tcp_sendpages(struct sock *sk, struct page *page, int offset,
 		 size_t size, int flags);
 int tcp_send_mss(struct sock *sk, int *size_goal, int flags);
diff --git a/net/ipv4/tcp.c b/net/ipv4/tcp.c
index b2bc3d7fe9e8..391705aaa80e 100644
--- a/net/ipv4/tcp.c
+++ b/net/ipv4/tcp.c
@@ -954,7 +954,7 @@ int tcp_send_mss(struct sock *sk, int *size_goal, int flags)
  * importantly be able to generate EPOLLOUT for Edge Trigger epoll()
  * users.
  */
-static void tcp_remove_empty_skb(struct sock *sk, struct sk_buff *skb)
+void tcp_remove_empty_skb(struct sock *sk, struct sk_buff *skb)
 {
 	if (skb && !skb->len) {
 		tcp_unlink_write_queue(skb, sk);
@@ -964,6 +964,68 @@ static void tcp_remove_empty_skb(struct sock *sk, struct sk_buff *skb)
 	}
 }
 
+struct sk_buff *tcp_build_frag(struct sock *sk, int size_goal, int flags,
+			       struct page *page, int offset, size_t *size)
+{
+	struct sk_buff *skb = tcp_write_queue_tail(sk);
+	struct tcp_sock *tp = tcp_sk(sk);
+	bool can_coalesce;
+	int copy, i;
+
+	if (!skb || (copy = size_goal - skb->len) <= 0 ||
+	    !tcp_skb_can_collapse_to(skb)) {
+new_segment:
+		if (!sk_stream_memory_free(sk))
+			return NULL;
+
+		skb = sk_stream_alloc_skb(sk, 0, sk->sk_allocation,
+				tcp_rtx_and_write_queues_empty(sk));
+		if (!skb)
+			return NULL;
+
+#ifdef CONFIG_TLS_DEVICE
+		skb->decrypted = !!(flags & MSG_SENDPAGE_DECRYPTED);
+#endif
+		skb_entail(sk, skb);
+		copy = size_goal;
+	}
+
+	if (copy > *size)
+		copy = *size;
+
+	i = skb_shinfo(skb)->nr_frags;
+	can_coalesce = skb_can_coalesce(skb, i, page, offset);
+	if (!can_coalesce && i >= sysctl_max_skb_frags) {
+		tcp_mark_push(tp, skb);
+		goto new_segment;
+	}
+	if (!sk_wmem_schedule(sk, copy))
+		return NULL;
+
+	if (can_coalesce) {
+		skb_frag_size_add(&skb_shinfo(skb)->frags[i - 1], copy);
+	} else {
+		get_page(page);
+		skb_fill_page_desc(skb, i, page, offset, copy);
+	}
+
+	if (!(flags & MSG_NO_SHARED_FRAGS))
+		skb_shinfo(skb)->tx_flags |= SKBTX_SHARED_FRAG;
+
+	skb->len += copy;
+	skb->data_len += copy;
+	skb->truesize += copy;
+	sk_wmem_queued_add(sk, copy);
+	sk_mem_charge(sk, copy);
+	skb->ip_summed = CHECKSUM_PARTIAL;
+	WRITE_ONCE(tp->write_seq, tp->write_seq + copy);
+	TCP_SKB_CB(skb)->end_seq += copy;
+	tcp_skb_pcount_set(skb, 0);
+
+	*size = copy;
+	return skb;
+}
+
 ssize_t do_tcp_sendpages(struct sock *sk, struct page *page, int offset,
 			 size_t size, int flags)
 {
@@ -999,60 +1061,13 @@ ssize_t do_tcp_sendpages(struct sock *sk, struct page *page, int offset,
 		goto out_err;
 
 	while (size > 0) {
-		struct sk_buff *skb = tcp_write_queue_tail(sk);
-		int copy, i;
-		bool can_coalesce;
-
-		if (!skb || (copy = size_goal - skb->len) <= 0 ||
-		    !tcp_skb_can_collapse_to(skb)) {
-new_segment:
-			if (!sk_stream_memory_free(sk))
-				goto wait_for_space;
-
-			skb = sk_stream_alloc_skb(sk, 0, sk->sk_allocation,
-					tcp_rtx_and_write_queues_empty(sk));
-			if (!skb)
-				goto wait_for_space;
-
-#ifdef CONFIG_TLS_DEVICE
-			skb->decrypted = !!(flags & MSG_SENDPAGE_DECRYPTED);
-#endif
-			skb_entail(sk, skb);
-			copy = size_goal;
-		}
+		struct sk_buff *skb;
+		size_t copy = size;
 
-		if (copy > size)
-			copy = size;
-
-		i = skb_shinfo(skb)->nr_frags;
-		can_coalesce = skb_can_coalesce(skb, i, page, offset);
-		if (!can_coalesce && i >= sysctl_max_skb_frags) {
-			tcp_mark_push(tp, skb);
-			goto new_segment;
-		}
-		if (!sk_wmem_schedule(sk, copy))
+		skb = tcp_build_frag(sk, size_goal, flags, page, offset, &copy);
+		if (!skb)
 			goto wait_for_space;
 
-		if (can_coalesce) {
-			skb_frag_size_add(&skb_shinfo(skb)->frags[i - 1], copy);
-		} else {
-			get_page(page);
-			skb_fill_page_desc(skb, i, page, offset, copy);
-		}
-
-		if (!(flags & MSG_NO_SHARED_FRAGS))
-			skb_shinfo(skb)->tx_flags |= SKBTX_SHARED_FRAG;
-
-		skb->len += copy;
-		skb->data_len += copy;
-		skb->truesize += copy;
-		sk_wmem_queued_add(sk, copy);
-		sk_mem_charge(sk, copy);
-		skb->ip_summed = CHECKSUM_PARTIAL;
-		WRITE_ONCE(tp->write_seq, tp->write_seq + copy);
-		TCP_SKB_CB(skb)->end_seq += copy;
-		tcp_skb_pcount_set(skb, 0);
-
 		if (!copied)
 			TCP_SKB_CB(skb)->tcp_flags &= ~TCPHDR_PSH;
 
-- 
2.26.2

