Return-Path: <netdev+bounces-3643-lists+netdev=lfdr.de@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from ny.mirrors.kernel.org (ny.mirrors.kernel.org [147.75.199.223])
	by mail.lfdr.de (Postfix) with ESMTPS id 07FCF708253
	for <lists+netdev@lfdr.de>; Thu, 18 May 2023 15:13:10 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ny.mirrors.kernel.org (Postfix) with ESMTPS id DA2351C2111B
	for <lists+netdev@lfdr.de>; Thu, 18 May 2023 13:13:06 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 6467823C94;
	Thu, 18 May 2023 13:08:59 +0000 (UTC)
X-Original-To: netdev@vger.kernel.org
Received: from lindbergh.monkeyblade.net (lindbergh.monkeyblade.net [23.128.96.19])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 5882723C7E
	for <netdev@vger.kernel.org>; Thu, 18 May 2023 13:08:59 +0000 (UTC)
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.133.124])
	by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 9017A1FE5
	for <netdev@vger.kernel.org>; Thu, 18 May 2023 06:08:36 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1684415315;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=wF+2b4fBEfy00AN3VDBr6eYpnbX7vBgnsz0rKmJdTGo=;
	b=UxE+nE6r/pcY4E/4fVcQlBlZkY4oLYaDZYf3L4YS271fvIaYcu4iywEcRE8TFQI3pam/G3
	n7MW3vai2Z3PRjsSl6Sy6743WUWRV8S5nrrJWzEfWMWILG0tfsRv49ETXGv5YSa2sdFqsG
	KlnZ+XmMxEAjHREuvtMd92N4HPtgnrs=
Received: from mimecast-mx02.redhat.com (mimecast-mx02.redhat.com
 [66.187.233.88]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 us-mta-434-1jG8JoGMMZqLc75xYcIWrQ-1; Thu, 18 May 2023 09:08:32 -0400
X-MC-Unique: 1jG8JoGMMZqLc75xYcIWrQ-1
Received: from smtp.corp.redhat.com (int-mx03.intmail.prod.int.rdu2.redhat.com [10.11.54.3])
	(using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by mimecast-mx02.redhat.com (Postfix) with ESMTPS id 2CE1384AF32;
	Thu, 18 May 2023 13:08:31 +0000 (UTC)
Received: from warthog.procyon.org.uk (unknown [10.42.28.221])
	by smtp.corp.redhat.com (Postfix) with ESMTP id 09D6E1121314;
	Thu, 18 May 2023 13:08:27 +0000 (UTC)
From: David Howells <dhowells@redhat.com>
To: netdev@vger.kernel.org
Cc: David Howells <dhowells@redhat.com>,
	"David S. Miller" <davem@davemloft.net>,
	Eric Dumazet <edumazet@google.com>,
	Jakub Kicinski <kuba@kernel.org>,
	Paolo Abeni <pabeni@redhat.com>,
	Willem de Bruijn <willemdebruijn.kernel@gmail.com>,
	David Ahern <dsahern@kernel.org>,
	Matthew Wilcox <willy@infradead.org>,
	Al Viro <viro@zeniv.linux.org.uk>,
	Christoph Hellwig <hch@infradead.org>,
	Jens Axboe <axboe@kernel.dk>,
	Jeff Layton <jlayton@kernel.org>,
	Christian Brauner <brauner@kernel.org>,
	Chuck Lever III <chuck.lever@oracle.com>,
	Linus Torvalds <torvalds@linux-foundation.org>,
	linux-fsdevel@vger.kernel.org,
	linux-kernel@vger.kernel.org,
	linux-mm@kvack.org,
	Kuniyuki Iwashima <kuniyu@amazon.com>
Subject: [PATCH net-next v9 16/16] unix: Convert udp_sendpage() to use MSG_SPLICE_PAGES
Date: Thu, 18 May 2023 14:07:13 +0100
Message-Id: <20230518130713.1515729-17-dhowells@redhat.com>
In-Reply-To: <20230518130713.1515729-1-dhowells@redhat.com>
References: <20230518130713.1515729-1-dhowells@redhat.com>
Precedence: bulk
X-Mailing-List: netdev@vger.kernel.org
List-Id: <netdev.vger.kernel.org>
List-Subscribe: <mailto:netdev+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:netdev+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Scanned-By: MIMEDefang 3.1 on 10.11.54.3
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
	DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_NONE,
	RCVD_IN_MSPIKE_H2,SPF_HELO_NONE,SPF_NONE,T_SCC_BODY_TEXT_LINE
	autolearn=unavailable autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
	lindbergh.monkeyblade.net

Convert unix_stream_sendpage() to use sendmsg() with MSG_SPLICE_PAGES
rather than directly splicing in the pages itself.

This allows ->sendpage() to be replaced by something that can handle
multiple multipage folios in a single transaction.

Signed-off-by: David Howells <dhowells@redhat.com>
cc: "David S. Miller" <davem@davemloft.net>
cc: Eric Dumazet <edumazet@google.com>
cc: Jakub Kicinski <kuba@kernel.org>
cc: Paolo Abeni <pabeni@redhat.com>
cc: Kuniyuki Iwashima <kuniyu@amazon.com>
cc: Jens Axboe <axboe@kernel.dk>
cc: Matthew Wilcox <willy@infradead.org>
cc: netdev@vger.kernel.org
---
 net/unix/af_unix.c | 134 +++------------------------------------------
 1 file changed, 7 insertions(+), 127 deletions(-)

diff --git a/net/unix/af_unix.c b/net/unix/af_unix.c
index 976bc1c5e11b..115436ce1f8a 100644
--- a/net/unix/af_unix.c
+++ b/net/unix/af_unix.c
@@ -1839,24 +1839,6 @@ static void maybe_add_creds(struct sk_buff *skb, const struct socket *sock,
 	}
 }
 
-static int maybe_init_creds(struct scm_cookie *scm,
-			    struct socket *socket,
-			    const struct sock *other)
-{
-	int err;
-	struct msghdr msg = { .msg_controllen = 0 };
-
-	err = scm_send(socket, &msg, scm, false);
-	if (err)
-		return err;
-
-	if (unix_passcred_enabled(socket, other)) {
-		scm->pid = get_pid(task_tgid(current));
-		current_uid_gid(&scm->creds.uid, &scm->creds.gid);
-	}
-	return err;
-}
-
 static bool unix_skb_scm_eq(struct sk_buff *skb,
 			    struct scm_cookie *scm)
 {
@@ -2292,117 +2274,15 @@ static int unix_stream_sendmsg(struct socket *sock, struct msghdr *msg,
 static ssize_t unix_stream_sendpage(struct socket *socket, struct page *page,
 				    int offset, size_t size, int flags)
 {
-	int err;
-	bool send_sigpipe = false;
-	bool init_scm = true;
-	struct scm_cookie scm;
-	struct sock *other, *sk = socket->sk;
-	struct sk_buff *skb, *newskb = NULL, *tail = NULL;
-
-	if (flags & MSG_OOB)
-		return -EOPNOTSUPP;
+	struct bio_vec bvec;
+	struct msghdr msg = { .msg_flags = flags | MSG_SPLICE_PAGES };
 
-	other = unix_peer(sk);
-	if (!other || sk->sk_state != TCP_ESTABLISHED)
-		return -ENOTCONN;
-
-	if (false) {
-alloc_skb:
-		unix_state_unlock(other);
-		mutex_unlock(&unix_sk(other)->iolock);
-		newskb = sock_alloc_send_pskb(sk, 0, 0, flags & MSG_DONTWAIT,
-					      &err, 0);
-		if (!newskb)
-			goto err;
-	}
-
-	/* we must acquire iolock as we modify already present
-	 * skbs in the sk_receive_queue and mess with skb->len
-	 */
-	err = mutex_lock_interruptible(&unix_sk(other)->iolock);
-	if (err) {
-		err = flags & MSG_DONTWAIT ? -EAGAIN : -ERESTARTSYS;
-		goto err;
-	}
-
-	if (sk->sk_shutdown & SEND_SHUTDOWN) {
-		err = -EPIPE;
-		send_sigpipe = true;
-		goto err_unlock;
-	}
-
-	unix_state_lock(other);
+	if (flags & MSG_SENDPAGE_NOTLAST)
+		msg.msg_flags |= MSG_MORE;
 
-	if (sock_flag(other, SOCK_DEAD) ||
-	    other->sk_shutdown & RCV_SHUTDOWN) {
-		err = -EPIPE;
-		send_sigpipe = true;
-		goto err_state_unlock;
-	}
-
-	if (init_scm) {
-		err = maybe_init_creds(&scm, socket, other);
-		if (err)
-			goto err_state_unlock;
-		init_scm = false;
-	}
-
-	skb = skb_peek_tail(&other->sk_receive_queue);
-	if (tail && tail == skb) {
-		skb = newskb;
-	} else if (!skb || !unix_skb_scm_eq(skb, &scm)) {
-		if (newskb) {
-			skb = newskb;
-		} else {
-			tail = skb;
-			goto alloc_skb;
-		}
-	} else if (newskb) {
-		/* this is fast path, we don't necessarily need to
-		 * call to kfree_skb even though with newskb == NULL
-		 * this - does no harm
-		 */
-		consume_skb(newskb);
-		newskb = NULL;
-	}
-
-	if (skb_append_pagefrags(skb, page, offset, size, MAX_SKB_FRAGS)) {
-		tail = skb;
-		goto alloc_skb;
-	}
-
-	skb->len += size;
-	skb->data_len += size;
-	skb->truesize += size;
-	refcount_add(size, &sk->sk_wmem_alloc);
-
-	if (newskb) {
-		err = unix_scm_to_skb(&scm, skb, false);
-		if (err)
-			goto err_state_unlock;
-		spin_lock(&other->sk_receive_queue.lock);
-		__skb_queue_tail(&other->sk_receive_queue, newskb);
-		spin_unlock(&other->sk_receive_queue.lock);
-	}
-
-	unix_state_unlock(other);
-	mutex_unlock(&unix_sk(other)->iolock);
-
-	other->sk_data_ready(other);
-	scm_destroy(&scm);
-	return size;
-
-err_state_unlock:
-	unix_state_unlock(other);
-err_unlock:
-	mutex_unlock(&unix_sk(other)->iolock);
-err:
-	kfree_skb(newskb);
-	if (send_sigpipe && !(flags & MSG_NOSIGNAL))
-		send_sig(SIGPIPE, current, 0);
-	if (!init_scm)
-		scm_destroy(&scm);
-	return err;
+	bvec_set_page(&bvec, page, size, offset);
+	iov_iter_bvec(&msg.msg_iter, ITER_SOURCE, &bvec, 1, size);
+	return unix_stream_sendmsg(socket, &msg, size);
 }
 
 static int unix_seqpacket_sendmsg(struct socket *sock, struct msghdr *msg,


