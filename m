Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 2216F6D2528
	for <lists+netdev@lfdr.de>; Fri, 31 Mar 2023 18:17:13 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233413AbjCaQRK (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 31 Mar 2023 12:17:10 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:35420 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233390AbjCaQQs (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 31 Mar 2023 12:16:48 -0400
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.133.124])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 7ADBD2658B
        for <netdev@vger.kernel.org>; Fri, 31 Mar 2023 09:11:15 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1680279058;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=jPEZCXpX5VIblKmRhP3z5vIQLhv4QpeLvADltfz6mNU=;
        b=fmeCgH2tsoWlSXu2Wtr3wOcqEJpf8D4J4aZuCRlsKZjuGf468Jp/Z97UHt/Kx8G4FEp+mm
        8RgfvwS00LNHDejeiH3j1mum9MQ077nY8biSoqiKuz2ZyrlrUfHMxMKwL4Q+A8GOnrojDJ
        u3uldSatH2YAxvYVYO5EWgSnJabWFlQ=
Received: from mimecast-mx02.redhat.com (mimecast-mx02.redhat.com
 [66.187.233.88]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 us-mta-650-1RKJZrZKPJSsBYeQeItUoQ-1; Fri, 31 Mar 2023 12:10:56 -0400
X-MC-Unique: 1RKJZrZKPJSsBYeQeItUoQ-1
Received: from smtp.corp.redhat.com (int-mx03.intmail.prod.int.rdu2.redhat.com [10.11.54.3])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mimecast-mx02.redhat.com (Postfix) with ESMTPS id 504CB801206;
        Fri, 31 Mar 2023 16:10:55 +0000 (UTC)
Received: from warthog.procyon.org.uk (unknown [10.33.36.18])
        by smtp.corp.redhat.com (Postfix) with ESMTP id 3D9F71121314;
        Fri, 31 Mar 2023 16:10:53 +0000 (UTC)
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
        linux-kernel@vger.kernel.org, linux-mm@kvack.org,
        Tom Herbert <tom@herbertland.com>,
        Tom Herbert <tom@quantonium.net>
Subject: [PATCH v3 34/55] kcm: Convert kcm_sendpage() to use MSG_SPLICE_PAGES
Date:   Fri, 31 Mar 2023 17:08:53 +0100
Message-Id: <20230331160914.1608208-35-dhowells@redhat.com>
In-Reply-To: <20230331160914.1608208-1-dhowells@redhat.com>
References: <20230331160914.1608208-1-dhowells@redhat.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Scanned-By: MIMEDefang 3.1 on 10.11.54.3
X-Spam-Status: No, score=-0.2 required=5.0 tests=DKIMWL_WL_HIGH,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_NONE,
        RCVD_IN_MSPIKE_H2,SPF_HELO_NONE,SPF_NONE autolearn=unavailable
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Convert kcm_sendpage() to use sendmsg() with MSG_SPLICE_PAGES rather than
directly splicing in the pages itself.

This allows ->sendpage() to be replaced by something that can handle
multiple multipage folios in a single transaction.

Signed-off-by: David Howells <dhowells@redhat.com>
cc: Tom Herbert <tom@herbertland.com>
cc: Tom Herbert <tom@quantonium.net>
cc: Jakub Kicinski <kuba@kernel.org>
cc: Eric Dumazet <edumazet@google.com>
cc: "David S. Miller" <davem@davemloft.net>
cc: Paolo Abeni <pabeni@redhat.com>
cc: Jens Axboe <axboe@kernel.dk>
cc: Matthew Wilcox <willy@infradead.org>
cc: netdev@vger.kernel.org
---
 net/kcm/kcmsock.c | 161 ++++++----------------------------------------
 1 file changed, 18 insertions(+), 143 deletions(-)

diff --git a/net/kcm/kcmsock.c b/net/kcm/kcmsock.c
index 0a3f79d81595..d77d28fbf389 100644
--- a/net/kcm/kcmsock.c
+++ b/net/kcm/kcmsock.c
@@ -761,149 +761,6 @@ static void kcm_push(struct kcm_sock *kcm)
 		kcm_write_msgs(kcm);
 }
 
-static ssize_t kcm_sendpage(struct socket *sock, struct page *page,
-			    int offset, size_t size, int flags)
-
-{
-	struct sock *sk = sock->sk;
-	struct kcm_sock *kcm = kcm_sk(sk);
-	struct sk_buff *skb = NULL, *head = NULL;
-	long timeo = sock_sndtimeo(sk, flags & MSG_DONTWAIT);
-	bool eor;
-	int err = 0;
-	int i;
-
-	if (flags & MSG_SENDPAGE_NOTLAST)
-		flags |= MSG_MORE;
-
-	/* No MSG_EOR from splice, only look at MSG_MORE */
-	eor = !(flags & MSG_MORE);
-
-	lock_sock(sk);
-
-	sk_clear_bit(SOCKWQ_ASYNC_NOSPACE, sk);
-
-	err = -EPIPE;
-	if (sk->sk_err)
-		goto out_error;
-
-	if (kcm->seq_skb) {
-		/* Previously opened message */
-		head = kcm->seq_skb;
-		skb = kcm_tx_msg(head)->last_skb;
-		i = skb_shinfo(skb)->nr_frags;
-
-		if (skb_can_coalesce(skb, i, page, offset)) {
-			skb_frag_size_add(&skb_shinfo(skb)->frags[i - 1], size);
-			skb_shinfo(skb)->flags |= SKBFL_SHARED_FRAG;
-			goto coalesced;
-		}
-
-		if (i >= MAX_SKB_FRAGS) {
-			struct sk_buff *tskb;
-
-			tskb = alloc_skb(0, sk->sk_allocation);
-			while (!tskb) {
-				kcm_push(kcm);
-				err = sk_stream_wait_memory(sk, &timeo);
-				if (err)
-					goto out_error;
-			}
-
-			if (head == skb)
-				skb_shinfo(head)->frag_list = tskb;
-			else
-				skb->next = tskb;
-
-			skb = tskb;
-			skb->ip_summed = CHECKSUM_UNNECESSARY;
-			i = 0;
-		}
-	} else {
-		/* Call the sk_stream functions to manage the sndbuf mem. */
-		if (!sk_stream_memory_free(sk)) {
-			kcm_push(kcm);
-			set_bit(SOCK_NOSPACE, &sk->sk_socket->flags);
-			err = sk_stream_wait_memory(sk, &timeo);
-			if (err)
-				goto out_error;
-		}
-
-		head = alloc_skb(0, sk->sk_allocation);
-		while (!head) {
-			kcm_push(kcm);
-			err = sk_stream_wait_memory(sk, &timeo);
-			if (err)
-				goto out_error;
-		}
-
-		skb = head;
-		i = 0;
-	}
-
-	get_page(page);
-	skb_fill_page_desc_noacc(skb, i, page, offset, size);
-	skb_shinfo(skb)->flags |= SKBFL_SHARED_FRAG;
-
-coalesced:
-	skb->len += size;
-	skb->data_len += size;
-	skb->truesize += size;
-	sk->sk_wmem_queued += size;
-	sk_mem_charge(sk, size);
-
-	if (head != skb) {
-		head->len += size;
-		head->data_len += size;
-		head->truesize += size;
-	}
-
-	if (eor) {
-		bool not_busy = skb_queue_empty(&sk->sk_write_queue);
-
-		/* Message complete, queue it on send buffer */
-		__skb_queue_tail(&sk->sk_write_queue, head);
-		kcm->seq_skb = NULL;
-		KCM_STATS_INCR(kcm->stats.tx_msgs);
-
-		if (flags & MSG_BATCH) {
-			kcm->tx_wait_more = true;
-		} else if (kcm->tx_wait_more || not_busy) {
-			err = kcm_write_msgs(kcm);
-			if (err < 0) {
-				/* We got a hard error in write_msgs but have
-				 * already queued this message. Report an error
-				 * in the socket, but don't affect return value
-				 * from sendmsg
-				 */
-				pr_warn("KCM: Hard failure on kcm_write_msgs\n");
-				report_csk_error(&kcm->sk, -err);
-			}
-		}
-	} else {
-		/* Message not complete, save state */
-		kcm->seq_skb = head;
-		kcm_tx_msg(head)->last_skb = skb;
-	}
-
-	KCM_STATS_ADD(kcm->stats.tx_bytes, size);
-
-	release_sock(sk);
-	return size;
-
-out_error:
-	kcm_push(kcm);
-
-	err = sk_stream_error(sk, flags, err);
-
-	/* make sure we wake any epoll edge trigger waiter */
-	if (unlikely(skb_queue_len(&sk->sk_write_queue) == 0 && err == -EAGAIN))
-		sk->sk_write_space(sk);
-
-	release_sock(sk);
-	return err;
-}
-
 static int kcm_sendmsg(struct socket *sock, struct msghdr *msg, size_t len)
 {
 	struct sock *sk = sock->sk;
@@ -1143,6 +1000,24 @@ static int kcm_sendmsg(struct socket *sock, struct msghdr *msg, size_t len)
 	return err;
 }
 
+static ssize_t kcm_sendpage(struct socket *sock, struct page *page,
+			    int offset, size_t size, int flags)
+
+{
+	struct bio_vec bvec;
+	struct msghdr msg = { .msg_flags = flags | MSG_SPLICE_PAGES, };
+
+	if (flags & MSG_SENDPAGE_NOTLAST)
+		msg.msg_flags |= MSG_MORE;
+
+	if (flags & MSG_OOB)
+		return -EOPNOTSUPP;
+
+	bvec_set_page(&bvec, page, offset, size);
+	iov_iter_bvec(&msg.msg_iter, ITER_SOURCE, &bvec, 1, size);
+	return kcm_sendmsg(sock, &msg, size);
+}
+
 static int kcm_recvmsg(struct socket *sock, struct msghdr *msg,
 		       size_t len, int flags)
 {

