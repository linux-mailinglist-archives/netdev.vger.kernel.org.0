Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id B78E66D251E
	for <lists+netdev@lfdr.de>; Fri, 31 Mar 2023 18:16:21 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233395AbjCaQQT (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 31 Mar 2023 12:16:19 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:33050 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233385AbjCaQPi (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 31 Mar 2023 12:15:38 -0400
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.133.124])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 7264C24431
        for <netdev@vger.kernel.org>; Fri, 31 Mar 2023 09:10:52 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1680279051;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=wy1bl7/wKEZT2hBAqmE7Plq7HNXSqd6J/GoEc2iata8=;
        b=JA3ZD2plQ2Z/EZnGdembztG1+rF7E4nmEd/n6yK6VRnOSfRKvuScy47XMbnjeT/F1Kv5+X
        tRGyiFJM+EOdehCuBNEqrIUYlZfsOpWP673w/ZFA6ACZ4MgJU+T3rCGCnSXzQB3KeOj/sT
        WLyxot8H3vrpKmhglXHKfe7U2d9YaGQ=
Received: from mimecast-mx02.redhat.com (mx3-rdu2.redhat.com
 [66.187.233.73]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 us-mta-408-TWrdWqY9OgKCvKHcSyW2Nw-1; Fri, 31 Mar 2023 12:10:48 -0400
X-MC-Unique: TWrdWqY9OgKCvKHcSyW2Nw-1
Received: from smtp.corp.redhat.com (int-mx06.intmail.prod.int.rdu2.redhat.com [10.11.54.6])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mimecast-mx02.redhat.com (Postfix) with ESMTPS id 1E33329ABA17;
        Fri, 31 Mar 2023 16:10:47 +0000 (UTC)
Received: from warthog.procyon.org.uk (unknown [10.33.36.18])
        by smtp.corp.redhat.com (Postfix) with ESMTP id 223762166B33;
        Fri, 31 Mar 2023 16:10:45 +0000 (UTC)
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
Subject: [PATCH v3 31/55] chelsio: Support MSG_SPLICE_PAGES
Date:   Fri, 31 Mar 2023 17:08:50 +0100
Message-Id: <20230331160914.1608208-32-dhowells@redhat.com>
In-Reply-To: <20230331160914.1608208-1-dhowells@redhat.com>
References: <20230331160914.1608208-1-dhowells@redhat.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Scanned-By: MIMEDefang 3.1 on 10.11.54.6
X-Spam-Status: No, score=-0.2 required=5.0 tests=DKIMWL_WL_HIGH,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_NONE,
        RCVD_IN_MSPIKE_H2,SPF_HELO_NONE,SPF_NONE autolearn=unavailable
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Make Chelsio's TLS offload sendmsg() support MSG_SPLICE_PAGES, splicing in
pages from the source iterator if possible and copying the data in
otherwise.

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
 .../chelsio/inline_crypto/chtls/chtls_io.c    | 60 ++++++++++++++++++-
 1 file changed, 59 insertions(+), 1 deletion(-)

diff --git a/drivers/net/ethernet/chelsio/inline_crypto/chtls/chtls_io.c b/drivers/net/ethernet/chelsio/inline_crypto/chtls/chtls_io.c
index ae6b17b96bf1..ca3daf5df95c 100644
--- a/drivers/net/ethernet/chelsio/inline_crypto/chtls/chtls_io.c
+++ b/drivers/net/ethernet/chelsio/inline_crypto/chtls/chtls_io.c
@@ -1092,7 +1092,65 @@ int chtls_sendmsg(struct sock *sk, struct msghdr *msg, size_t size)
 		if (copy > size)
 			copy = size;
 
-		if (skb_tailroom(skb) > 0) {
+		if (msg->msg_flags & MSG_SPLICE_PAGES) {
+			struct page *page, **pages = &page;
+			ssize_t part;
+			size_t off, spliced = 0;
+			bool put = false;
+			int i;
+
+			do {
+				i = skb_shinfo(skb)->nr_frags;
+				part = iov_iter_extract_pages(&msg->msg_iter, &pages,
+							      copy - spliced, 1, 0, &off);
+				if (part <= 0) {
+					err = part ?: -EIO;
+					goto do_fault;
+				}
+
+				if (!sendpage_ok(page)) {
+					const void *p = kmap_local_page(page);
+					void *q;
+
+					q = page_frag_memdup(NULL, p + off, part,
+							     sk->sk_allocation, ULONG_MAX);
+					kunmap_local(p);
+					if (!q) {
+						iov_iter_revert(&msg->msg_iter, part);
+						return -ENOMEM;
+					}
+					page = virt_to_page(q);
+					off = offset_in_page(q);
+					put = true;
+				}
+
+				if (skb_can_coalesce(skb, i, page, off)) {
+					skb_frag_size_add(&skb_shinfo(skb)->frags[i - 1], part);
+					spliced += part;
+					if (put)
+						put_page(page);
+				} else if (i < MAX_SKB_FRAGS) {
+					if (!put)
+						get_page(page);
+					skb_fill_page_desc(skb, i, page, off, spliced);
+					spliced += part;
+					put = false;
+				} else {
+					if (put)
+						put_page(page);
+					if (!spliced)
+						goto new_buf;
+					break;
+				}
+			} while (spliced < copy);
+
+			copy = spliced;
+			skb->len += copy;
+			skb->data_len += copy;
+			skb->truesize += copy;
+			sk->sk_wmem_queued += copy;
+			
+		} else if (skb_tailroom(skb) > 0) {
 			copy = min(copy, skb_tailroom(skb));
 			if (is_tls_tx(csk))
 				copy = min_t(int, copy, csk->tlshws.txleft);

