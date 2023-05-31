Return-Path: <netdev+bounces-6792-lists+netdev=lfdr.de@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [139.178.88.99])
	by mail.lfdr.de (Postfix) with ESMTPS id 7D05E718033
	for <lists+netdev@lfdr.de>; Wed, 31 May 2023 14:46:58 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id 335F42814C7
	for <lists+netdev@lfdr.de>; Wed, 31 May 2023 12:46:57 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 4434214A93;
	Wed, 31 May 2023 12:45:54 +0000 (UTC)
X-Original-To: netdev@vger.kernel.org
Received: from lindbergh.monkeyblade.net (lindbergh.monkeyblade.net [23.128.96.19])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 3376814A89
	for <netdev@vger.kernel.org>; Wed, 31 May 2023 12:45:54 +0000 (UTC)
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.133.124])
	by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 7E858129
	for <netdev@vger.kernel.org>; Wed, 31 May 2023 05:45:52 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1685537151;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=W8aEdMrYnuprZg7eZCUzLy+kKHthZDT31VQbMyJsAn8=;
	b=RXkgFMV5Gg1uQ9/1SXfFNJnXLJcTMJ9q3VqY4E07Pcr8CuRFCWy8ih61qyBTijMUvrneJR
	pMA+l/6lBNFpNpxktZ7KzyTscVzHeV2ueLRrTwc9orPsG/7l86Q5Grt5SrzMPNIypJgyW7
	V5IKm8xLaCNTbg2Z51rixiaHQt9IWug=
Received: from mimecast-mx02.redhat.com (mx3-rdu2.redhat.com
 [66.187.233.73]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 us-mta-370-LbK9yftePiayyMeYHhVc5g-1; Wed, 31 May 2023 08:45:48 -0400
X-MC-Unique: LbK9yftePiayyMeYHhVc5g-1
Received: from smtp.corp.redhat.com (int-mx07.intmail.prod.int.rdu2.redhat.com [10.11.54.7])
	(using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by mimecast-mx02.redhat.com (Postfix) with ESMTPS id D0DF53825BA9;
	Wed, 31 May 2023 12:45:47 +0000 (UTC)
Received: from warthog.procyon.org.uk (unknown [10.42.28.182])
	by smtp.corp.redhat.com (Postfix) with ESMTP id F3555140E963;
	Wed, 31 May 2023 12:45:44 +0000 (UTC)
From: David Howells <dhowells@redhat.com>
To: netdev@vger.kernel.org
Cc: David Howells <dhowells@redhat.com>,
	Chuck Lever <chuck.lever@oracle.com>,
	Boris Pismenny <borisp@nvidia.com>,
	John Fastabend <john.fastabend@gmail.com>,
	Jakub Kicinski <kuba@kernel.org>,
	"David S. Miller" <davem@davemloft.net>,
	Eric Dumazet <edumazet@google.com>,
	Paolo Abeni <pabeni@redhat.com>,
	Willem de Bruijn <willemdebruijn.kernel@gmail.com>,
	David Ahern <dsahern@kernel.org>,
	Matthew Wilcox <willy@infradead.org>,
	Jens Axboe <axboe@kernel.dk>,
	linux-mm@kvack.org,
	linux-kernel@vger.kernel.org,
	bpf@vger.kernel.org
Subject: [PATCH net-next v2 4/6] tls/sw: Convert tls_sw_sendpage() to use MSG_SPLICE_PAGES
Date: Wed, 31 May 2023 13:45:26 +0100
Message-ID: <20230531124528.699123-5-dhowells@redhat.com>
In-Reply-To: <20230531124528.699123-1-dhowells@redhat.com>
References: <20230531124528.699123-1-dhowells@redhat.com>
Precedence: bulk
X-Mailing-List: netdev@vger.kernel.org
List-Id: <netdev.vger.kernel.org>
List-Subscribe: <mailto:netdev+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:netdev+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Scanned-By: MIMEDefang 3.1 on 10.11.54.7
X-Spam-Status: No, score=-2.3 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
	DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_NONE,
	SPF_HELO_NONE,SPF_NONE,T_SCC_BODY_TEXT_LINE autolearn=ham
	autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
	lindbergh.monkeyblade.net

Convert tls_sw_sendpage() and tls_sw_sendpage_locked() to use sendmsg()
with MSG_SPLICE_PAGES rather than directly splicing in the pages itself.

[!] Note that tls_sw_sendpage_locked() appears to have the wrong locking
    upstream.  I think the caller will only hold the socket lock, but it
    should hold tls_ctx->tx_lock too.

This allows ->sendpage() to be replaced by something that can handle
multiple multipage folios in a single transaction.

Signed-off-by: David Howells <dhowells@redhat.com>
cc: Chuck Lever <chuck.lever@oracle.com>
cc: Boris Pismenny <borisp@nvidia.com>
cc: John Fastabend <john.fastabend@gmail.com>
cc: Jakub Kicinski <kuba@kernel.org>
cc: Eric Dumazet <edumazet@google.com>
cc: "David S. Miller" <davem@davemloft.net>
cc: Paolo Abeni <pabeni@redhat.com>
cc: Jens Axboe <axboe@kernel.dk>
cc: Matthew Wilcox <willy@infradead.org>
cc: netdev@vger.kernel.org
cc: bpf@vger.kernel.org
---
 net/tls/tls_sw.c | 165 +++++++++--------------------------------------
 1 file changed, 31 insertions(+), 134 deletions(-)

diff --git a/net/tls/tls_sw.c b/net/tls/tls_sw.c
index 60d807b63f75..f63e4405cf34 100644
--- a/net/tls/tls_sw.c
+++ b/net/tls/tls_sw.c
@@ -961,7 +961,8 @@ static int tls_sw_sendmsg_splice(struct sock *sk, struct msghdr *msg,
 	return 0;
 }
 
-int tls_sw_sendmsg(struct sock *sk, struct msghdr *msg, size_t size)
+static int tls_sw_sendmsg_locked(struct sock *sk, struct msghdr *msg,
+				 size_t size)
 {
 	long timeo = sock_sndtimeo(sk, msg->msg_flags & MSG_DONTWAIT);
 	struct tls_context *tls_ctx = tls_get_ctx(sk);
@@ -984,15 +985,6 @@ int tls_sw_sendmsg(struct sock *sk, struct msghdr *msg, size_t size)
 	int ret = 0;
 	int pending;
 
-	if (msg->msg_flags & ~(MSG_MORE | MSG_DONTWAIT | MSG_NOSIGNAL |
-			       MSG_CMSG_COMPAT))
-		return -EOPNOTSUPP;
-
-	ret = mutex_lock_interruptible(&tls_ctx->tx_lock);
-	if (ret)
-		return ret;
-	lock_sock(sk);
-
 	if (unlikely(msg->msg_controllen)) {
 		ret = tls_process_cmsg(sk, msg, &record_type);
 		if (ret) {
@@ -1193,157 +1185,62 @@ int tls_sw_sendmsg(struct sock *sk, struct msghdr *msg, size_t size)
 
 send_end:
 	ret = sk_stream_error(sk, msg->msg_flags, ret);
-
-	release_sock(sk);
-	mutex_unlock(&tls_ctx->tx_lock);
 	return copied > 0 ? copied : ret;
 }
 
-static int tls_sw_do_sendpage(struct sock *sk, struct page *page,
-			      int offset, size_t size, int flags)
+int tls_sw_sendmsg(struct sock *sk, struct msghdr *msg, size_t size)
 {
-	long timeo = sock_sndtimeo(sk, flags & MSG_DONTWAIT);
 	struct tls_context *tls_ctx = tls_get_ctx(sk);
-	struct tls_sw_context_tx *ctx = tls_sw_ctx_tx(tls_ctx);
-	struct tls_prot_info *prot = &tls_ctx->prot_info;
-	unsigned char record_type = TLS_RECORD_TYPE_DATA;
-	struct sk_msg *msg_pl;
-	struct tls_rec *rec;
-	int num_async = 0;
-	ssize_t copied = 0;
-	bool full_record;
-	int record_room;
-	int ret = 0;
-	bool eor;
-
-	eor = !(flags & MSG_SENDPAGE_NOTLAST);
-	sk_clear_bit(SOCKWQ_ASYNC_NOSPACE, sk);
-
-	/* Call the sk_stream functions to manage the sndbuf mem. */
-	while (size > 0) {
-		size_t copy, required_size;
-
-		if (sk->sk_err) {
-			ret = -sk->sk_err;
-			goto sendpage_end;
-		}
-
-		if (ctx->open_rec)
-			rec = ctx->open_rec;
-		else
-			rec = ctx->open_rec = tls_get_rec(sk);
-		if (!rec) {
-			ret = -ENOMEM;
-			goto sendpage_end;
-		}
-
-		msg_pl = &rec->msg_plaintext;
-
-		full_record = false;
-		record_room = TLS_MAX_PAYLOAD_SIZE - msg_pl->sg.size;
-		copy = size;
-		if (copy >= record_room) {
-			copy = record_room;
-			full_record = true;
-		}
-
-		required_size = msg_pl->sg.size + copy + prot->overhead_size;
-
-		if (!sk_stream_memory_free(sk))
-			goto wait_for_sndbuf;
-alloc_payload:
-		ret = tls_alloc_encrypted_msg(sk, required_size);
-		if (ret) {
-			if (ret != -ENOSPC)
-				goto wait_for_memory;
-
-			/* Adjust copy according to the amount that was
-			 * actually allocated. The difference is due
-			 * to max sg elements limit
-			 */
-			copy -= required_size - msg_pl->sg.size;
-			full_record = true;
-		}
-
-		sk_msg_page_add(msg_pl, page, copy, offset);
-		sk_mem_charge(sk, copy);
-
-		offset += copy;
-		size -= copy;
-		copied += copy;
-
-		tls_ctx->pending_open_record_frags = true;
-		if (full_record || eor || sk_msg_full(msg_pl)) {
-			ret = bpf_exec_tx_verdict(msg_pl, sk, full_record,
-						  record_type, &copied, flags);
-			if (ret) {
-				if (ret == -EINPROGRESS)
-					num_async++;
-				else if (ret == -ENOMEM)
-					goto wait_for_memory;
-				else if (ret != -EAGAIN) {
-					if (ret == -ENOSPC)
-						ret = 0;
-					goto sendpage_end;
-				}
-			}
-		}
-		continue;
-wait_for_sndbuf:
-		set_bit(SOCK_NOSPACE, &sk->sk_socket->flags);
-wait_for_memory:
-		ret = sk_stream_wait_memory(sk, &timeo);
-		if (ret) {
-			if (ctx->open_rec)
-				tls_trim_both_msgs(sk, msg_pl->sg.size);
-			goto sendpage_end;
-		}
+	int ret;
 
-		if (ctx->open_rec)
-			goto alloc_payload;
-	}
+	if (msg->msg_flags & ~(MSG_MORE | MSG_DONTWAIT | MSG_NOSIGNAL |
+			       MSG_CMSG_COMPAT | MSG_SPLICE_PAGES |
+			       MSG_SENDPAGE_NOTLAST | MSG_SENDPAGE_NOPOLICY))
+		return -EOPNOTSUPP;
 
-	if (num_async) {
-		/* Transmit if any encryptions have completed */
-		if (test_and_clear_bit(BIT_TX_SCHEDULED, &ctx->tx_bitmask)) {
-			cancel_delayed_work(&ctx->tx_work.work);
-			tls_tx_records(sk, flags);
-		}
-	}
-sendpage_end:
-	ret = sk_stream_error(sk, flags, ret);
-	return copied > 0 ? copied : ret;
+	ret = mutex_lock_interruptible(&tls_ctx->tx_lock);
+	if (ret)
+		return ret;
+	lock_sock(sk);
+	ret = tls_sw_sendmsg_locked(sk, msg, size);
+	release_sock(sk);
+	mutex_unlock(&tls_ctx->tx_lock);
+	return ret;
 }
 
 int tls_sw_sendpage_locked(struct sock *sk, struct page *page,
 			   int offset, size_t size, int flags)
 {
+	struct bio_vec bvec;
+	struct msghdr msg = { .msg_flags = flags | MSG_SPLICE_PAGES, };
+
 	if (flags & ~(MSG_MORE | MSG_DONTWAIT | MSG_NOSIGNAL |
 		      MSG_SENDPAGE_NOTLAST | MSG_SENDPAGE_NOPOLICY |
 		      MSG_NO_SHARED_FRAGS))
 		return -EOPNOTSUPP;
+	if (flags & MSG_SENDPAGE_NOTLAST)
+		msg.msg_flags |= MSG_MORE;
 
-	return tls_sw_do_sendpage(sk, page, offset, size, flags);
+	bvec_set_page(&bvec, page, size, offset);
+	iov_iter_bvec(&msg.msg_iter, ITER_SOURCE, &bvec, 1, size);
+	return tls_sw_sendmsg_locked(sk, &msg, size);
 }
 
 int tls_sw_sendpage(struct sock *sk, struct page *page,
 		    int offset, size_t size, int flags)
 {
-	struct tls_context *tls_ctx = tls_get_ctx(sk);
-	int ret;
+	struct bio_vec bvec;
+	struct msghdr msg = { .msg_flags = flags | MSG_SPLICE_PAGES, };
 
 	if (flags & ~(MSG_MORE | MSG_DONTWAIT | MSG_NOSIGNAL |
 		      MSG_SENDPAGE_NOTLAST | MSG_SENDPAGE_NOPOLICY))
 		return -EOPNOTSUPP;
+	if (flags & MSG_SENDPAGE_NOTLAST)
+		msg.msg_flags |= MSG_MORE;
 
-	ret = mutex_lock_interruptible(&tls_ctx->tx_lock);
-	if (ret)
-		return ret;
-	lock_sock(sk);
-	ret = tls_sw_do_sendpage(sk, page, offset, size, flags);
-	release_sock(sk);
-	mutex_unlock(&tls_ctx->tx_lock);
-	return ret;
+	bvec_set_page(&bvec, page, size, offset);
+	iov_iter_bvec(&msg.msg_iter, ITER_SOURCE, &bvec, 1, size);
+	return tls_sw_sendmsg(sk, &msg, size);
 }
 
 static int


