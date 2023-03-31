Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 873656D2521
	for <lists+netdev@lfdr.de>; Fri, 31 Mar 2023 18:16:42 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233367AbjCaQQk (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 31 Mar 2023 12:16:40 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:44230 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233376AbjCaQQT (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 31 Mar 2023 12:16:19 -0400
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.129.124])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 9144025563
        for <netdev@vger.kernel.org>; Fri, 31 Mar 2023 09:11:07 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1680279055;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=4EhmophDUNRsJifv6aZ6zofwzEVulzOQZ9lN1G4MZvA=;
        b=h07aeNnDhSGMegthEzl8xPTK6lZf9ePgMm+uxYZGcWp9MYGjv0Pnje4USsEXZe2Ri4e5h0
        anZdjdpBtKcafNgtNdVfS8Dlu9YZiRYS1PosKDuATnNqdZLAcIrvSwYLb4V6dJx1N3dFsQ
        xeyJ8ApqkFYfkIPtNSJBAVp4hyRIGK0=
Received: from mimecast-mx02.redhat.com (mimecast-mx02.redhat.com
 [66.187.233.88]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 us-mta-377-HVkLcFjMPH6uSNSWjZfLnw-1; Fri, 31 Mar 2023 12:10:51 -0400
X-MC-Unique: HVkLcFjMPH6uSNSWjZfLnw-1
Received: from smtp.corp.redhat.com (int-mx07.intmail.prod.int.rdu2.redhat.com [10.11.54.7])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mimecast-mx02.redhat.com (Postfix) with ESMTPS id C56DE185A791;
        Fri, 31 Mar 2023 16:10:49 +0000 (UTC)
Received: from warthog.procyon.org.uk (unknown [10.33.36.18])
        by smtp.corp.redhat.com (Postfix) with ESMTP id CBA5914171B6;
        Fri, 31 Mar 2023 16:10:47 +0000 (UTC)
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
        Ayush Sawal <ayush.sawal@chelsio.com>
Subject: [PATCH v3 32/55] chelsio: Convert chtls_sendpage() to use MSG_SPLICE_PAGES
Date:   Fri, 31 Mar 2023 17:08:51 +0100
Message-Id: <20230331160914.1608208-33-dhowells@redhat.com>
In-Reply-To: <20230331160914.1608208-1-dhowells@redhat.com>
References: <20230331160914.1608208-1-dhowells@redhat.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Scanned-By: MIMEDefang 3.1 on 10.11.54.7
X-Spam-Status: No, score=-0.2 required=5.0 tests=DKIMWL_WL_HIGH,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_NONE,
        RCVD_IN_MSPIKE_H2,SPF_HELO_NONE,SPF_NONE autolearn=unavailable
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

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
 .../chelsio/inline_crypto/chtls/chtls_io.c    | 109 ++----------------
 1 file changed, 7 insertions(+), 102 deletions(-)

diff --git a/drivers/net/ethernet/chelsio/inline_crypto/chtls/chtls_io.c b/drivers/net/ethernet/chelsio/inline_crypto/chtls/chtls_io.c
index ca3daf5df95c..5c397cb57300 100644
--- a/drivers/net/ethernet/chelsio/inline_crypto/chtls/chtls_io.c
+++ b/drivers/net/ethernet/chelsio/inline_crypto/chtls/chtls_io.c
@@ -1288,110 +1288,15 @@ int chtls_sendmsg(struct sock *sk, struct msghdr *msg, size_t size)
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
+	struct bio_vec bvec;
+	struct msghdr msg = { .msg_flags = flags | MSG_SPLICE_PAGES, };
 
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
+	bvec_set_page(&bvec, page, offset, size);
+	iov_iter_bvec(&msg.msg_iter, ITER_SOURCE, &bvec, 1, size);
+	return chtls_sendmsg(sk, &msg, size);
 }
 
 static void chtls_select_window(struct sock *sk)

