Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 7EA566D8446
	for <lists+netdev@lfdr.de>; Wed,  5 Apr 2023 18:56:43 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233900AbjDEQ4j (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 5 Apr 2023 12:56:39 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:60376 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233393AbjDEQ4K (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 5 Apr 2023 12:56:10 -0400
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.129.124])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 834255BB7
        for <netdev@vger.kernel.org>; Wed,  5 Apr 2023 09:54:11 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1680713650;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=5sjNMjWipBo1Z72oEKiWWK/H6upfHkIbrOvJ4ujx2jY=;
        b=XPMs70IoLNtx6GDjmlFrz+KoljN1ACaEjd+DtviiJ8XPnl3frWkzaOvXu/mPW4ez00BdVS
        vUm7iI4jl0+wRDqyLBV7v2ShissRTl93sICSzkjfKTezcPZ/NClLlPHUyOjAM8zcDQZTlv
        agEBWAHJ6kcwxezr/lS60d17K/eoPMc=
Received: from mimecast-mx02.redhat.com (mimecast-mx02.redhat.com
 [66.187.233.88]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 us-mta-511-Ya2LXt7-OzuHeZYmbpex1g-1; Wed, 05 Apr 2023 12:54:07 -0400
X-MC-Unique: Ya2LXt7-OzuHeZYmbpex1g-1
Received: from smtp.corp.redhat.com (int-mx08.intmail.prod.int.rdu2.redhat.com [10.11.54.8])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mimecast-mx02.redhat.com (Postfix) with ESMTPS id 00159885622;
        Wed,  5 Apr 2023 16:54:05 +0000 (UTC)
Received: from warthog.procyon.org.uk (unknown [10.33.36.18])
        by smtp.corp.redhat.com (Postfix) with ESMTP id F2A0AC1602A;
        Wed,  5 Apr 2023 16:54:03 +0000 (UTC)
From:   David Howells <dhowells@redhat.com>
To:     netdev@vger.kernel.org
Cc:     David Howells <dhowells@redhat.com>,
        "David S. Miller" <davem@davemloft.net>,
        Eric Dumazet <edumazet@google.com>,
        Jakub Kicinski <kuba@kernel.org>,
        Paolo Abeni <pabeni@redhat.com>,
        Willem de Bruijn <willemdebruijn.kernel@gmail.com>,
        Matthew Wilcox <willy@infradead.org>,
        Al Viro <viro@zeniv.linux.org.uk>,
        Christoph Hellwig <hch@infradead.org>,
        Jens Axboe <axboe@kernel.dk>, Jeff Layton <jlayton@kernel.org>,
        Christian Brauner <brauner@kernel.org>,
        Chuck Lever III <chuck.lever@oracle.com>,
        Linus Torvalds <torvalds@linux-foundation.org>,
        linux-fsdevel@vger.kernel.org, linux-kernel@vger.kernel.org,
        linux-mm@kvack.org
Subject: [PATCH net-next v4 07/20] tcp: Make sendmsg(MSG_SPLICE_PAGES) copy unspliceable data
Date:   Wed,  5 Apr 2023 17:53:26 +0100
Message-Id: <20230405165339.3468808-8-dhowells@redhat.com>
In-Reply-To: <20230405165339.3468808-1-dhowells@redhat.com>
References: <20230405165339.3468808-1-dhowells@redhat.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Scanned-By: MIMEDefang 3.1 on 10.11.54.8
X-Spam-Status: No, score=-0.2 required=5.0 tests=DKIMWL_WL_HIGH,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_NONE,
        RCVD_IN_MSPIKE_H2,SPF_HELO_NONE,SPF_NONE autolearn=unavailable
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

If sendmsg() with MSG_SPLICE_PAGES encounters a page that shouldn't be
spliced - a slab page, for instance, or one with a zero count - make
tcp_sendmsg() copy it.

Signed-off-by: David Howells <dhowells@redhat.com>
cc: Eric Dumazet <edumazet@google.com>
cc: "David S. Miller" <davem@davemloft.net>
cc: Jakub Kicinski <kuba@kernel.org>
cc: Paolo Abeni <pabeni@redhat.com>
cc: Jens Axboe <axboe@kernel.dk>
cc: Matthew Wilcox <willy@infradead.org>
cc: netdev@vger.kernel.org
---
 net/ipv4/tcp.c | 28 +++++++++++++++++++++++++---
 1 file changed, 25 insertions(+), 3 deletions(-)

diff --git a/net/ipv4/tcp.c b/net/ipv4/tcp.c
index 510bacc7ce7b..238a8ad6527c 100644
--- a/net/ipv4/tcp.c
+++ b/net/ipv4/tcp.c
@@ -1418,10 +1418,10 @@ int tcp_sendmsg_locked(struct sock *sk, struct msghdr *msg, size_t size)
 				goto do_error;
 			copy = err;
 		} else if (zc == 2) {
-			/* Splice in data. */
+			/* Splice in data if we can; copy if we can't. */
 			struct page *page = NULL, **pages = &page;
 			size_t off = 0, part;
-			bool can_coalesce;
+			bool can_coalesce, put = false;
 			int i = skb_shinfo(skb)->nr_frags;
 
 			copy = iov_iter_extract_pages(&msg->msg_iter, &pages,
@@ -1448,12 +1448,34 @@ int tcp_sendmsg_locked(struct sock *sk, struct msghdr *msg, size_t size)
 				goto wait_for_space;
 			copy = part;
 
+			if (!sendpage_ok(page)) {
+				const void *p = kmap_local_page(page);
+				void *q;
+
+				q = page_frag_memdup(NULL, p + off, copy,
+						     sk->sk_allocation, ULONG_MAX);
+				kunmap_local(p);
+				if (!q) {
+					iov_iter_revert(&msg->msg_iter, copy);
+					err = copy ?: -ENOMEM;
+					goto do_error;
+				}
+				page = virt_to_page(q);
+				off = offset_in_page(q);
+				put = true;
+				can_coalesce = false;
+			}
+
 			if (can_coalesce) {
 				skb_frag_size_add(&skb_shinfo(skb)->frags[i - 1], copy);
 			} else {
-				get_page(page);
+				if (!put)
+					get_page(page);
+				put = false;
 				skb_fill_page_desc_noacc(skb, i, page, off, copy);
 			}
+			if (put)
+				put_page(page);
 			page = NULL;
 
 			if (!(flags & MSG_NO_SHARED_FRAGS))

