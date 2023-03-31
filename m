Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id C91E66D2526
	for <lists+netdev@lfdr.de>; Fri, 31 Mar 2023 18:17:09 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233131AbjCaQRH (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 31 Mar 2023 12:17:07 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:44980 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232960AbjCaQQq (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 31 Mar 2023 12:16:46 -0400
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.129.124])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id B220520D86
        for <netdev@vger.kernel.org>; Fri, 31 Mar 2023 09:11:19 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1680279059;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=KbTdePCQuY00Eh43/mGhCoyrcL0EDX5k9L0XaPYIsA0=;
        b=V/D2XRoIFA9r7qmx0SjmFTC3bStNtFTbCjsJU/uMlpDvCrKpCJJzh5QE5Q9qMdi40ojqdx
        K3Wy9bRrOontnKaP/1T2D4aOdLtf8tms0oT73A5YtkyLZxSSqZDbGJ83KNF7Y+vWL9J35B
        kj0hE7HxBlKV0kZP4MbOCfgi1+pkZHQ=
Received: from mimecast-mx02.redhat.com (mx3-rdu2.redhat.com
 [66.187.233.73]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 us-mta-615--qgn__EoP-eE5uusdvkQ2A-1; Fri, 31 Mar 2023 12:10:54 -0400
X-MC-Unique: -qgn__EoP-eE5uusdvkQ2A-1
Received: from smtp.corp.redhat.com (int-mx05.intmail.prod.int.rdu2.redhat.com [10.11.54.5])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mimecast-mx02.redhat.com (Postfix) with ESMTPS id 7FD543802AC1;
        Fri, 31 Mar 2023 16:10:52 +0000 (UTC)
Received: from warthog.procyon.org.uk (unknown [10.33.36.18])
        by smtp.corp.redhat.com (Postfix) with ESMTP id 63D4851FF;
        Fri, 31 Mar 2023 16:10:50 +0000 (UTC)
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
Subject: [PATCH v3 33/55] kcm: Support MSG_SPLICE_PAGES
Date:   Fri, 31 Mar 2023 17:08:52 +0100
Message-Id: <20230331160914.1608208-34-dhowells@redhat.com>
In-Reply-To: <20230331160914.1608208-1-dhowells@redhat.com>
References: <20230331160914.1608208-1-dhowells@redhat.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Scanned-By: MIMEDefang 3.1 on 10.11.54.5
X-Spam-Status: No, score=-0.2 required=5.0 tests=DKIMWL_WL_HIGH,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_NONE,
        RCVD_IN_MSPIKE_H2,SPF_HELO_NONE,SPF_NONE autolearn=unavailable
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Make AF_KCM sendmsg() support MSG_SPLICE_PAGES.  This causes pages to be
spliced from the source iterator if possible and copied otherwise.

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
 net/kcm/kcmsock.c | 89 ++++++++++++++++++++++++++++++++++++++---------
 1 file changed, 72 insertions(+), 17 deletions(-)

diff --git a/net/kcm/kcmsock.c b/net/kcm/kcmsock.c
index cfe828bd7fc6..0a3f79d81595 100644
--- a/net/kcm/kcmsock.c
+++ b/net/kcm/kcmsock.c
@@ -989,29 +989,84 @@ static int kcm_sendmsg(struct socket *sock, struct msghdr *msg, size_t len)
 			merge = false;
 		}
 
-		copy = min_t(int, msg_data_left(msg),
-			     pfrag->size - pfrag->offset);
+		if (msg->msg_flags & MSG_SPLICE_PAGES) {
+			struct page *page = NULL, **pages = &page;
+			size_t off;
+			bool put = false;
+			
+			err = iov_iter_extract_pages(&msg->msg_iter, &pages,
+						     INT_MAX, 1, 0, &off);
+			if (err <= 0) {
+				err = err ?: -EIO;
+				goto out_error;
+			}
+			copy = err;
 
-		if (!sk_wmem_schedule(sk, copy))
-			goto wait_for_memory;
+			if (skb_can_coalesce(skb, i, page, off)) {
+				skb_frag_size_add(&skb_shinfo(skb)->frags[i - 1], copy);
+				goto coalesced;
+			}
 
-		err = skb_copy_to_page_nocache(sk, &msg->msg_iter, skb,
-					       pfrag->page,
-					       pfrag->offset,
-					       copy);
-		if (err)
-			goto out_error;
+			if (!sk_wmem_schedule(sk, copy)) {
+				iov_iter_revert(&msg->msg_iter, copy);
+				goto wait_for_memory;
+			}
+
+			if (!sendpage_ok(page)) {
+				const void *p = kmap_local_page(page);
+				void *q;
 
-		/* Update the skb. */
-		if (merge) {
-			skb_frag_size_add(&skb_shinfo(skb)->frags[i - 1], copy);
+				q = page_frag_memdup(NULL, p + off, copy,
+						     sk->sk_allocation, ULONG_MAX);
+				kunmap_local(p);
+				if (!q) {
+					iov_iter_revert(&msg->msg_iter, copy);
+					err = -ENOMEM;
+					goto out_error;
+				}
+				page = virt_to_page(q);
+				off = offset_in_page(q);
+				put = true;
+			}
+
+			skb_fill_page_desc_noacc(skb, i, page, off, copy);
+			if (put)
+				put_page(page);
+coalesced:
+			skb_shinfo(skb)->flags |= SKBFL_SHARED_FRAG;
+			skb->len += copy;
+			skb->data_len += copy;
+			skb->truesize += copy;
+			sk->sk_wmem_queued += copy;
+			sk_mem_charge(sk, copy);
+
+			if (head != skb)
+				head->truesize += copy;
 		} else {
-			skb_fill_page_desc(skb, i, pfrag->page,
-					   pfrag->offset, copy);
-			get_page(pfrag->page);
+			copy = min_t(int, msg_data_left(msg),
+				     pfrag->size - pfrag->offset);
+			if (!sk_wmem_schedule(sk, copy))
+				goto wait_for_memory;
+
+			err = skb_copy_to_page_nocache(sk, &msg->msg_iter, skb,
+						       pfrag->page,
+						       pfrag->offset,
+						       copy);
+			if (err)
+				goto out_error;
+
+			/* Update the skb. */
+			if (merge) {
+				skb_frag_size_add(&skb_shinfo(skb)->frags[i - 1], copy);
+			} else {
+				skb_fill_page_desc(skb, i, pfrag->page,
+						   pfrag->offset, copy);
+				get_page(pfrag->page);
+			}
+
+			pfrag->offset += copy;
 		}
 
-		pfrag->offset += copy;
 		copied += copy;
 		if (head != skb) {
 			head->len += copy;

