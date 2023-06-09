Return-Path: <netdev+bounces-9489-lists+netdev=lfdr.de@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [IPv6:2604:1380:45e3:2400::1])
	by mail.lfdr.de (Postfix) with ESMTPS id 82BEA72963D
	for <lists+netdev@lfdr.de>; Fri,  9 Jun 2023 12:04:20 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id 3FE6D28183C
	for <lists+netdev@lfdr.de>; Fri,  9 Jun 2023 10:04:19 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id BA4E914A96;
	Fri,  9 Jun 2023 10:02:54 +0000 (UTC)
X-Original-To: netdev@vger.kernel.org
Received: from lindbergh.monkeyblade.net (lindbergh.monkeyblade.net [23.128.96.19])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id A85B914A93
	for <netdev@vger.kernel.org>; Fri,  9 Jun 2023 10:02:54 +0000 (UTC)
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.133.124])
	by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 88D1D4232
	for <netdev@vger.kernel.org>; Fri,  9 Jun 2023 03:02:52 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1686304971;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=3LFa2xxbJsqyZ30qpsSqRMBPDTmtcps3tB0X7zJ4/t0=;
	b=DqZfa9G0mwuz2JVrGa0zXke5A722IwNLxosNN96tjbgJLtWtXjulQwYgki3RmiY3gZ5u1K
	knpeoVhmgPwDIdWh/vAjqT5oKjhO17nBVtzb4hVIApScSNkzhowhx6OiQ/Gwb+ojp46QPh
	ZrVNZWho72YlXNWl0SsYklE4APoWMcY=
Received: from mimecast-mx02.redhat.com (mimecast-mx02.redhat.com
 [66.187.233.88]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 us-mta-104-0rQ0XTexPKWqfrAzgZR2CA-1; Fri, 09 Jun 2023 06:02:45 -0400
X-MC-Unique: 0rQ0XTexPKWqfrAzgZR2CA-1
Received: from smtp.corp.redhat.com (int-mx07.intmail.prod.int.rdu2.redhat.com [10.11.54.7])
	(using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by mimecast-mx02.redhat.com (Postfix) with ESMTPS id 7C0C485A5BE;
	Fri,  9 Jun 2023 10:02:44 +0000 (UTC)
Received: from warthog.procyon.org.uk (unknown [10.42.28.51])
	by smtp.corp.redhat.com (Postfix) with ESMTP id 22EF3145B965;
	Fri,  9 Jun 2023 10:02:42 +0000 (UTC)
From: David Howells <dhowells@redhat.com>
To: netdev@vger.kernel.org
Cc: David Howells <dhowells@redhat.com>,
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
	Tom Herbert <tom@herbertland.com>,
	Tom Herbert <tom@quantonium.net>
Subject: [PATCH net-next 6/6] kcm: Send multiple frags in one sendmsg()
Date: Fri,  9 Jun 2023 11:02:21 +0100
Message-ID: <20230609100221.2620633-7-dhowells@redhat.com>
In-Reply-To: <20230609100221.2620633-1-dhowells@redhat.com>
References: <20230609100221.2620633-1-dhowells@redhat.com>
Precedence: bulk
X-Mailing-List: netdev@vger.kernel.org
List-Id: <netdev.vger.kernel.org>
List-Subscribe: <mailto:netdev+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:netdev+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Scanned-By: MIMEDefang 3.1 on 10.11.54.7
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
	DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_NONE,
	RCVD_IN_MSPIKE_H5,RCVD_IN_MSPIKE_WL,SPF_HELO_NONE,SPF_NONE,
	T_SCC_BODY_TEXT_LINE autolearn=unavailable autolearn_force=no
	version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
	lindbergh.monkeyblade.net

Rewrite the AF_KCM transmission loop to send all the fragments in a single
skb or frag_list-skb in one sendmsg() with MSG_SPLICE_PAGES set.  The list
of fragments in each skb is conveniently a bio_vec[] that can just be
attached to a BVEC iter.

Note: I'm working out the size of each fragment-skb by adding up bv_len for
all the bio_vecs in skb->frags[] - but surely this information is recorded
somewhere?  For the skbs in head->frag_list, this is equal to
skb->data_len, but not for the head.  head->data_len includes all the tail
frags too.

Signed-off-by: David Howells <dhowells@redhat.com>
cc: Tom Herbert <tom@herbertland.com>
cc: Tom Herbert <tom@quantonium.net>
cc: "David S. Miller" <davem@davemloft.net>
cc: Eric Dumazet <edumazet@google.com>
cc: Jakub Kicinski <kuba@kernel.org>
cc: Paolo Abeni <pabeni@redhat.com>
cc: Jens Axboe <axboe@kernel.dk>
cc: Matthew Wilcox <willy@infradead.org>
cc: netdev@vger.kernel.org
---
 include/net/kcm.h |   2 +-
 net/kcm/kcmsock.c | 126 ++++++++++++++++++----------------------------
 2 files changed, 51 insertions(+), 77 deletions(-)

diff --git a/include/net/kcm.h b/include/net/kcm.h
index 2d704f8f4905..90279e5e09a5 100644
--- a/include/net/kcm.h
+++ b/include/net/kcm.h
@@ -47,9 +47,9 @@ struct kcm_stats {
 
 struct kcm_tx_msg {
 	unsigned int sent;
-	unsigned int fragidx;
 	unsigned int frag_offset;
 	unsigned int msg_flags;
+	bool started_tx;
 	struct sk_buff *frag_skb;
 	struct sk_buff *last_skb;
 };
diff --git a/net/kcm/kcmsock.c b/net/kcm/kcmsock.c
index 3bcac1453f10..d75d775e9462 100644
--- a/net/kcm/kcmsock.c
+++ b/net/kcm/kcmsock.c
@@ -581,12 +581,10 @@ static void kcm_report_tx_retry(struct kcm_sock *kcm)
  */
 static int kcm_write_msgs(struct kcm_sock *kcm)
 {
+	unsigned int total_sent = 0;
 	struct sock *sk = &kcm->sk;
 	struct kcm_psock *psock;
-	struct sk_buff *skb, *head;
-	struct kcm_tx_msg *txm;
-	unsigned short fragidx, frag_offset;
-	unsigned int sent, total_sent = 0;
+	struct sk_buff *head;
 	int ret = 0;
 
 	kcm->tx_wait_more = false;
@@ -600,78 +598,57 @@ static int kcm_write_msgs(struct kcm_sock *kcm)
 		if (skb_queue_empty(&sk->sk_write_queue))
 			return 0;
 
-		kcm_tx_msg(skb_peek(&sk->sk_write_queue))->sent = 0;
-
-	} else if (skb_queue_empty(&sk->sk_write_queue)) {
-		return 0;
+		kcm_tx_msg(skb_peek(&sk->sk_write_queue))->started_tx = false;
 	}
 
-	head = skb_peek(&sk->sk_write_queue);
-	txm = kcm_tx_msg(head);
-
-	if (txm->sent) {
-		/* Send of first skbuff in queue already in progress */
-		if (WARN_ON(!psock)) {
-			ret = -EINVAL;
-			goto out;
+retry:
+	while ((head = skb_peek(&sk->sk_write_queue))) {
+		struct msghdr msg = {
+			.msg_flags = MSG_DONTWAIT | MSG_SPLICE_PAGES,
+		};
+		struct kcm_tx_msg *txm = kcm_tx_msg(head);
+		struct sk_buff *skb;
+		unsigned int msize;
+		int i;
+
+		if (!txm->started_tx) {
+			psock = reserve_psock(kcm);
+			if (!psock)
+				goto out;
+			skb = head;
+			txm->frag_offset = 0;
+			txm->sent = 0;
+			txm->started_tx = true;
+		} else {
+			if (WARN_ON(!psock)) {
+				ret = -EINVAL;
+				goto out;
+			}
+			skb = txm->frag_skb;
 		}
-		sent = txm->sent;
-		frag_offset = txm->frag_offset;
-		fragidx = txm->fragidx;
-		skb = txm->frag_skb;
-
-		goto do_frag;
-	}
-
-try_again:
-	psock = reserve_psock(kcm);
-	if (!psock)
-		goto out;
-
-	do {
-		skb = head;
-		txm = kcm_tx_msg(head);
-		sent = 0;
 
-do_frag_list:
 		if (WARN_ON(!skb_shinfo(skb)->nr_frags)) {
 			ret = -EINVAL;
 			goto out;
 		}
 
-		for (fragidx = 0; fragidx < skb_shinfo(skb)->nr_frags;
-		     fragidx++) {
-			struct bio_vec bvec;
-			struct msghdr msg = {
-				.msg_flags = MSG_DONTWAIT | MSG_SPLICE_PAGES,
-			};
-			skb_frag_t *frag;
-
-			frag_offset = 0;
-do_frag:
-			frag = &skb_shinfo(skb)->frags[fragidx];
-			if (WARN_ON(!skb_frag_size(frag))) {
-				ret = -EINVAL;
-				goto out;
-			}
+		msize = 0;
+		for (i = 0; i < skb_shinfo(skb)->nr_frags; i++)
+			msize += skb_shinfo(skb)->frags[i].bv_len;
+
+		iov_iter_bvec(&msg.msg_iter, ITER_SOURCE,
+			      skb_shinfo(skb)->frags, skb_shinfo(skb)->nr_frags,
+			      msize);
+		iov_iter_advance(&msg.msg_iter, txm->frag_offset);
 
-			bvec_set_page(&bvec,
-				      skb_frag_page(frag),
-				      skb_frag_size(frag) - frag_offset,
-				      skb_frag_off(frag) + frag_offset);
-			iov_iter_bvec(&msg.msg_iter, ITER_SOURCE, &bvec, 1,
-				      bvec.bv_len);
+		do {
 			ret = sock_sendmsg(psock->sk->sk_socket, &msg);
 			if (ret <= 0) {
 				if (ret == -EAGAIN) {
 					/* Save state to try again when there's
 					 * write space on the socket
 					 */
-					txm->sent = sent;
-					txm->frag_offset = frag_offset;
-					txm->fragidx = fragidx;
 					txm->frag_skb = skb;
-
 					ret = 0;
 					goto out;
 				}
@@ -685,39 +662,36 @@ static int kcm_write_msgs(struct kcm_sock *kcm)
 						   true);
 				unreserve_psock(kcm);
 
-				txm->sent = 0;
+				txm->started_tx = false;
 				kcm_report_tx_retry(kcm);
 				ret = 0;
-
-				goto try_again;
+				goto retry;
 			}
 
-			sent += ret;
-			frag_offset += ret;
+			txm->sent += ret;
+			txm->frag_offset += ret;
 			KCM_STATS_ADD(psock->stats.tx_bytes, ret);
-			if (frag_offset < skb_frag_size(frag)) {
-				/* Not finished with this frag */
-				goto do_frag;
-			}
-		}
+		} while (msg.msg_iter.count > 0);
 
 		if (skb == head) {
 			if (skb_has_frag_list(skb)) {
-				skb = skb_shinfo(skb)->frag_list;
-				goto do_frag_list;
+				txm->frag_skb = skb_shinfo(skb)->frag_list;
+				txm->frag_offset = 0;
+				continue;
 			}
 		} else if (skb->next) {
-			skb = skb->next;
-			goto do_frag_list;
+			txm->frag_skb = skb->next;
+			txm->frag_offset = 0;
+			continue;
 		}
 
 		/* Successfully sent the whole packet, account for it. */
+		sk->sk_wmem_queued -= txm->sent;
+		total_sent += txm->sent;
 		skb_dequeue(&sk->sk_write_queue);
 		kfree_skb(head);
-		sk->sk_wmem_queued -= sent;
-		total_sent += sent;
 		KCM_STATS_INCR(psock->stats.tx_msgs);
-	} while ((head = skb_peek(&sk->sk_write_queue)));
+	}
 out:
 	if (!head) {
 		/* Done with all queued messages. */


