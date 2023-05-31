Return-Path: <netdev+bounces-6768-lists+netdev=lfdr.de@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [IPv6:2604:1380:45e3:2400::1])
	by mail.lfdr.de (Postfix) with ESMTPS id AD402717D7F
	for <lists+netdev@lfdr.de>; Wed, 31 May 2023 13:01:04 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id 67A932814AF
	for <lists+netdev@lfdr.de>; Wed, 31 May 2023 11:01:03 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 7954DC2D0;
	Wed, 31 May 2023 11:00:40 +0000 (UTC)
X-Original-To: netdev@vger.kernel.org
Received: from lindbergh.monkeyblade.net (lindbergh.monkeyblade.net [23.128.96.19])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 61A06C8D3
	for <netdev@vger.kernel.org>; Wed, 31 May 2023 11:00:40 +0000 (UTC)
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.133.124])
	by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 34AE2135
	for <netdev@vger.kernel.org>; Wed, 31 May 2023 04:00:34 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1685530833;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=nBkFTCC6CO9wuSqa6TDRZsc4R0OnF4ofoS5g5iSEfa8=;
	b=Opt0Ee8M4ean1GiMKMJ1rm/UwbKZz+41YzoLmUAssuleGH/phQi/LdUCkNO541CU2aA0V3
	UdS/EDuinQJR8Ei02VxUDPXFCKXUiXRBcePXja8FWw10Oh5Om0965LUvVy+8cMSOpXp4oP
	g0vsMlaYtdo+Tk1+IlhsXN4Ufn9aDPE=
Received: from mimecast-mx02.redhat.com (mimecast-mx02.redhat.com
 [66.187.233.88]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 us-mta-26-W82jFm1ZNtOC3nNUdxtyIw-1; Wed, 31 May 2023 07:00:27 -0400
X-MC-Unique: W82jFm1ZNtOC3nNUdxtyIw-1
Received: from smtp.corp.redhat.com (int-mx05.intmail.prod.int.rdu2.redhat.com [10.11.54.5])
	(using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by mimecast-mx02.redhat.com (Postfix) with ESMTPS id 90765811E78;
	Wed, 31 May 2023 11:00:24 +0000 (UTC)
Received: from warthog.procyon.org.uk (unknown [10.42.28.182])
	by smtp.corp.redhat.com (Postfix) with ESMTP id 86FBF421C3;
	Wed, 31 May 2023 11:00:21 +0000 (UTC)
From: David Howells <dhowells@redhat.com>
To: netdev@vger.kernel.org
Cc: David Howells <dhowells@redhat.com>,
	Ayush Sawal <ayush.sawal@chelsio.com>,
	"David S. Miller" <davem@davemloft.net>,
	Eric Dumazet <edumazet@google.com>,
	Jakub Kicinski <kuba@kernel.org>,
	Paolo Abeni <pabeni@redhat.com>,
	Willem de Bruijn <willemdebruijn.kernel@gmail.com>,
	David Ahern <dsahern@kernel.org>,
	Matthew Wilcox <willy@infradead.org>,
	Jens Axboe <axboe@kernel.dk>,
	Simon Horman <simon.horman@corigine.com>,
	linux-mm@kvack.org,
	linux-kernel@vger.kernel.org
Subject: [PATCH net-next v2 2/2] chelsio: Convert chtls_sendpage() to use MSG_SPLICE_PAGES
Date: Wed, 31 May 2023 12:00:08 +0100
Message-ID: <20230531110008.642903-3-dhowells@redhat.com>
In-Reply-To: <20230531110008.642903-1-dhowells@redhat.com>
References: <20230531110008.642903-1-dhowells@redhat.com>
Precedence: bulk
X-Mailing-List: netdev@vger.kernel.org
List-Id: <netdev.vger.kernel.org>
List-Subscribe: <mailto:netdev+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:netdev+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Scanned-By: MIMEDefang 3.1 on 10.11.54.5
X-Spam-Status: No, score=-2.3 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
	DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_NONE,
	SPF_HELO_NONE,SPF_NONE,T_SCC_BODY_TEXT_LINE autolearn=unavailable
	autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
	lindbergh.monkeyblade.net

Convert chtls_sendpage() to use sendmsg() with MSG_SPLICE_PAGES rather than
directly splicing in the pages itself.

This allows ->sendpage() to be replaced by something that can handle
multiple multipage folios in a single transaction.

Signed-off-by: David Howells <dhowells@redhat.com>
cc: Ayush Sawal <ayush.sawal@chelsio.com>
cc: "David S. Miller" <davem@davemloft.net>
cc: Eric Dumazet <edumazet@google.com>
cc: Jakub Kicinski <kuba@kernel.org>
cc: Paolo Abeni <pabeni@redhat.com>
cc: Jens Axboe <axboe@kernel.dk>
cc: Matthew Wilcox <willy@infradead.org>
cc: netdev@vger.kernel.org
---

Notes:
    ver #2)
     - Do reverse-xmas tree variables.

 .../chelsio/inline_crypto/chtls/chtls_io.c    | 109 ++----------------
 1 file changed, 7 insertions(+), 102 deletions(-)

diff --git a/drivers/net/ethernet/chelsio/inline_crypto/chtls/chtls_io.c b/drivers/net/ethernet/chelsio/inline_crypto/chtls/chtls_io.c
index 1d08386ac916..5724bbbb6ee0 100644
--- a/drivers/net/ethernet/chelsio/inline_crypto/chtls/chtls_io.c
+++ b/drivers/net/ethernet/chelsio/inline_crypto/chtls/chtls_io.c
@@ -1240,110 +1240,15 @@ int chtls_sendmsg(struct sock *sk, struct msghdr *msg, size_t size)
 int chtls_sendpage(struct sock *sk, struct page *page,
 		   int offset, size_t size, int flags)
 {
-	struct chtls_sock *csk;
-	struct chtls_dev *cdev;
-	int mss, err, copied;
-	struct tcp_sock *tp;
-	long timeo;
-
-	tp = tcp_sk(sk);
-	copied = 0;
-	csk = rcu_dereference_sk_user_data(sk);
-	cdev = csk->cdev;
-	lock_sock(sk);
-	timeo = sock_sndtimeo(sk, flags & MSG_DONTWAIT);
+	struct msghdr msg = { .msg_flags = flags | MSG_SPLICE_PAGES, };
+	struct bio_vec bvec;
 
-	err = sk_stream_wait_connect(sk, &timeo);
-	if (!sk_in_state(sk, TCPF_ESTABLISHED | TCPF_CLOSE_WAIT) &&
-	    err != 0)
-		goto out_err;
-
-	mss = csk->mss;
-	csk_set_flag(csk, CSK_TX_MORE_DATA);
-
-	while (size > 0) {
-		struct sk_buff *skb = skb_peek_tail(&csk->txq);
-		int copy, i;
-
-		if (!skb || (ULP_SKB_CB(skb)->flags & ULPCB_FLAG_NO_APPEND) ||
-		    (copy = mss - skb->len) <= 0) {
-new_buf:
-			if (!csk_mem_free(cdev, sk))
-				goto wait_for_sndbuf;
+	if (flags & MSG_SENDPAGE_NOTLAST)
+		msg.msg_flags |= MSG_MORE;
 
-			if (is_tls_tx(csk)) {
-				skb = get_record_skb(sk,
-						     select_size(sk, size,
-								 flags,
-								 TX_TLSHDR_LEN),
-						     true);
-			} else {
-				skb = get_tx_skb(sk, 0);
-			}
-			if (!skb)
-				goto wait_for_memory;
-			copy = mss;
-		}
-		if (copy > size)
-			copy = size;
-
-		i = skb_shinfo(skb)->nr_frags;
-		if (skb_can_coalesce(skb, i, page, offset)) {
-			skb_frag_size_add(&skb_shinfo(skb)->frags[i - 1], copy);
-		} else if (i < MAX_SKB_FRAGS) {
-			get_page(page);
-			skb_fill_page_desc(skb, i, page, offset, copy);
-		} else {
-			tx_skb_finalize(skb);
-			push_frames_if_head(sk);
-			goto new_buf;
-		}
-
-		skb->len += copy;
-		if (skb->len == mss)
-			tx_skb_finalize(skb);
-		skb->data_len += copy;
-		skb->truesize += copy;
-		sk->sk_wmem_queued += copy;
-		tp->write_seq += copy;
-		copied += copy;
-		offset += copy;
-		size -= copy;
-
-		if (corked(tp, flags) &&
-		    (sk_stream_wspace(sk) < sk_stream_min_wspace(sk)))
-			ULP_SKB_CB(skb)->flags |= ULPCB_FLAG_NO_APPEND;
-
-		if (!size)
-			break;
-
-		if (unlikely(ULP_SKB_CB(skb)->flags & ULPCB_FLAG_NO_APPEND))
-			push_frames_if_head(sk);
-		continue;
-wait_for_sndbuf:
-		set_bit(SOCK_NOSPACE, &sk->sk_socket->flags);
-wait_for_memory:
-		err = csk_wait_memory(cdev, sk, &timeo);
-		if (err)
-			goto do_error;
-	}
-out:
-	csk_reset_flag(csk, CSK_TX_MORE_DATA);
-	if (copied)
-		chtls_tcp_push(sk, flags);
-done:
-	release_sock(sk);
-	return copied;
-
-do_error:
-	if (copied)
-		goto out;
-
-out_err:
-	if (csk_conn_inline(csk))
-		csk_reset_flag(csk, CSK_TX_MORE_DATA);
-	copied = sk_stream_error(sk, flags, err);
-	goto done;
+	bvec_set_page(&bvec, page, size, offset);
+	iov_iter_bvec(&msg.msg_iter, ITER_SOURCE, &bvec, 1, size);
+	return chtls_sendmsg(sk, &msg, size);
 }
 
 static void chtls_select_window(struct sock *sk)


