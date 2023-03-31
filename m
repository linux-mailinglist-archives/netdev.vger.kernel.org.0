Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 035916D24CA
	for <lists+netdev@lfdr.de>; Fri, 31 Mar 2023 18:12:08 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233070AbjCaQMF (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 31 Mar 2023 12:12:05 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:33534 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232810AbjCaQLT (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 31 Mar 2023 12:11:19 -0400
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.133.124])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 31A2021A82
        for <netdev@vger.kernel.org>; Fri, 31 Mar 2023 09:09:52 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1680278991;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=nhfSw6vyJXoYjtAsHCy4fHcMYpuQf7adDQC2jq05dOE=;
        b=NJNUWR002PtJC0kxyfnD/BQA0kCft6otOqu1ulPOGv7c20OMvtIdBKmaN41id/qURqttpx
        231pAltQK7B4Wst7MhAE+yEn1RTmtXEq9PlFa//RQ2DHjI9UV3UuSJi/YRB90B44HukTDM
        akyAfPfqIsBK41uKGNynGrt+49OkKPE=
Received: from mimecast-mx02.redhat.com (mimecast-mx02.redhat.com
 [66.187.233.88]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 us-mta-138-rSYPRKkjNEe0Qp7x83krYQ-1; Fri, 31 Mar 2023 12:09:48 -0400
X-MC-Unique: rSYPRKkjNEe0Qp7x83krYQ-1
Received: from smtp.corp.redhat.com (int-mx02.intmail.prod.int.rdu2.redhat.com [10.11.54.2])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mimecast-mx02.redhat.com (Postfix) with ESMTPS id 2AC8285A5A3;
        Fri, 31 Mar 2023 16:09:47 +0000 (UTC)
Received: from warthog.procyon.org.uk (unknown [10.33.36.18])
        by smtp.corp.redhat.com (Postfix) with ESMTP id 46B784020C82;
        Fri, 31 Mar 2023 16:09:45 +0000 (UTC)
From:   David Howells <dhowells@redhat.com>
To:     Matthew Wilcox <willy@infradead.org>,
        "David S. Miller" <davem@davemloft.net>,
        Eric Dumazet <edumazet@google.com>,
        Jakub Kicinski <kuba@kernel.org>,
        Paolo Abeni <pabeni@redhat.com>
Cc:     David Howells <dhowells@redhat.com>,
        Al Viro <viro@zeniv.linux.org.uk>,
        Christoph Hellwig <hch@infradead.org>,
        Jens Axboe <axboe@kernel.dk>, Jeff Layton <jlayton@kernel.org>,
        Christian Brauner <brauner@kernel.org>,
        Chuck Lever III <chuck.lever@oracle.com>,
        Linus Torvalds <torvalds@linux-foundation.org>,
        netdev@vger.kernel.org, linux-fsdevel@vger.kernel.org,
        linux-kernel@vger.kernel.org, linux-mm@kvack.org
Subject: [PATCH v3 09/55] tcp: Convert do_tcp_sendpages() to use MSG_SPLICE_PAGES
Date:   Fri, 31 Mar 2023 17:08:28 +0100
Message-Id: <20230331160914.1608208-10-dhowells@redhat.com>
In-Reply-To: <20230331160914.1608208-1-dhowells@redhat.com>
References: <20230331160914.1608208-1-dhowells@redhat.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Scanned-By: MIMEDefang 3.1 on 10.11.54.2
X-Spam-Status: No, score=-0.2 required=5.0 tests=DKIMWL_WL_HIGH,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_NONE,
        RCVD_IN_MSPIKE_H2,SPF_HELO_NONE,SPF_NONE autolearn=unavailable
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Convert do_tcp_sendpages() to use sendmsg() with MSG_SPLICE_PAGES rather
than directly splicing in the pages itself.  do_tcp_sendpages() can then be
inlined in subsequent patches into its callers.

This allows ->sendpage() to be replaced by something that can handle
multiple multipage folios in a single transaction.

Signed-off-by: David Howells <dhowells@redhat.com>
cc: Eric Dumazet <edumazet@google.com>
cc: "David S. Miller" <davem@davemloft.net>
cc: Jakub Kicinski <kuba@kernel.org>
cc: Paolo Abeni <pabeni@redhat.com>
cc: Jens Axboe <axboe@kernel.dk>
cc: Matthew Wilcox <willy@infradead.org>
cc: netdev@vger.kernel.org
---
 net/ipv4/tcp.c | 158 +++----------------------------------------------
 1 file changed, 7 insertions(+), 151 deletions(-)

diff --git a/net/ipv4/tcp.c b/net/ipv4/tcp.c
index 6ef0518eb706..edcf3a60c1b0 100644
--- a/net/ipv4/tcp.c
+++ b/net/ipv4/tcp.c
@@ -971,163 +971,19 @@ static int tcp_wmem_schedule(struct sock *sk, int copy)
 	return min(copy, sk->sk_forward_alloc);
 }
 
-static struct sk_buff *tcp_build_frag(struct sock *sk, int size_goal, int flags,
-				      struct page *page, int offset, size_t *size)
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
-		skb = tcp_stream_alloc_skb(sk, 0, sk->sk_allocation,
-					   tcp_rtx_and_write_queues_empty(sk));
-		if (!skb)
-			return NULL;
-
-#ifdef CONFIG_TLS_DEVICE
-		skb->decrypted = !!(flags & MSG_SENDPAGE_DECRYPTED);
-#endif
-		tcp_skb_entail(sk, skb);
-		copy = size_goal;
-	}
-
-	if (copy > *size)
-		copy = *size;
-
-	i = skb_shinfo(skb)->nr_frags;
-	can_coalesce = skb_can_coalesce(skb, i, page, offset);
-	if (!can_coalesce && i >= READ_ONCE(sysctl_max_skb_frags)) {
-		tcp_mark_push(tp, skb);
-		goto new_segment;
-	}
-	if (tcp_downgrade_zcopy_pure(sk, skb))
-		return NULL;
-
-	copy = tcp_wmem_schedule(sk, copy);
-	if (!copy)
-		return NULL;
-
-	if (can_coalesce) {
-		skb_frag_size_add(&skb_shinfo(skb)->frags[i - 1], copy);
-	} else {
-		get_page(page);
-		skb_fill_page_desc_noacc(skb, i, page, offset, copy);
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
-	struct tcp_sock *tp = tcp_sk(sk);
-	int mss_now, size_goal;
-	int err;
-	ssize_t copied;
-	long timeo = sock_sndtimeo(sk, flags & MSG_DONTWAIT);
-
-	if (IS_ENABLED(CONFIG_DEBUG_VM) &&
-	    WARN_ONCE(!sendpage_ok(page),
-		      "page must not be a Slab one and have page_count > 0"))
-		return -EINVAL;
-
-	/* Wait for a connection to finish. One exception is TCP Fast Open
-	 * (passive side) where data is allowed to be sent before a connection
-	 * is fully established.
-	 */
-	if (((1 << sk->sk_state) & ~(TCPF_ESTABLISHED | TCPF_CLOSE_WAIT)) &&
-	    !tcp_passive_fastopen(sk)) {
-		err = sk_stream_wait_connect(sk, &timeo);
-		if (err != 0)
-			goto out_err;
-	}
+	struct bio_vec bvec;
+	struct msghdr msg = { .msg_flags = flags | MSG_SPLICE_PAGES, };
 
-	sk_clear_bit(SOCKWQ_ASYNC_NOSPACE, sk);
+	bvec_set_page(&bvec, page, size, offset);
+	iov_iter_bvec(&msg.msg_iter, ITER_SOURCE, &bvec, 1, size);
 
-	mss_now = tcp_send_mss(sk, &size_goal, flags);
-	copied = 0;
+	if (flags & MSG_SENDPAGE_NOTLAST)
+		msg.msg_flags |= MSG_MORE;
 
-	err = -EPIPE;
-	if (sk->sk_err || (sk->sk_shutdown & SEND_SHUTDOWN))
-		goto out_err;
-
-	while (size > 0) {
-		struct sk_buff *skb;
-		size_t copy = size;
-
-		skb = tcp_build_frag(sk, size_goal, flags, page, offset, &copy);
-		if (!skb)
-			goto wait_for_space;
-
-		if (!copied)
-			TCP_SKB_CB(skb)->tcp_flags &= ~TCPHDR_PSH;
-
-		copied += copy;
-		offset += copy;
-		size -= copy;
-		if (!size)
-			goto out;
-
-		if (skb->len < size_goal || (flags & MSG_OOB))
-			continue;
-
-		if (forced_push(tp)) {
-			tcp_mark_push(tp, skb);
-			__tcp_push_pending_frames(sk, mss_now, TCP_NAGLE_PUSH);
-		} else if (skb == tcp_send_head(sk))
-			tcp_push_one(sk, mss_now);
-		continue;
-
-wait_for_space:
-		set_bit(SOCK_NOSPACE, &sk->sk_socket->flags);
-		tcp_push(sk, flags & ~MSG_MORE, mss_now,
-			 TCP_NAGLE_PUSH, size_goal);
-
-		err = sk_stream_wait_memory(sk, &timeo);
-		if (err != 0)
-			goto do_error;
-
-		mss_now = tcp_send_mss(sk, &size_goal, flags);
-	}
-
-out:
-	if (copied) {
-		tcp_tx_timestamp(sk, sk->sk_tsflags);
-		if (!(flags & MSG_SENDPAGE_NOTLAST))
-			tcp_push(sk, flags, mss_now, tp->nonagle, size_goal);
-	}
-	return copied;
-
-do_error:
-	tcp_remove_empty_skb(sk);
-	if (copied)
-		goto out;
-out_err:
-	/* make sure we wake any epoll edge trigger waiter */
-	if (unlikely(tcp_rtx_and_write_queues_empty(sk) && err == -EAGAIN)) {
-		sk->sk_write_space(sk);
-		tcp_chrono_stop(sk, TCP_CHRONO_SNDBUF_LIMITED);
-	}
-	return sk_stream_error(sk, flags, err);
+	return tcp_sendmsg_locked(sk, &msg, size);
 }
 EXPORT_SYMBOL_GPL(do_tcp_sendpages);
 

