Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 14F6C6CDBEB
	for <lists+netdev@lfdr.de>; Wed, 29 Mar 2023 16:18:01 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231144AbjC2OR5 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 29 Mar 2023 10:17:57 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:52992 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230083AbjC2ORP (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 29 Mar 2023 10:17:15 -0400
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.133.124])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 62A624EFE
        for <netdev@vger.kernel.org>; Wed, 29 Mar 2023 07:15:28 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1680099292;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=vWPvILWC7NBdevnbDDsys9XJnr3/cfzKJoNpaM2CnAc=;
        b=Z+Or+Qi6RwNe+PDuwEcnwpl2myCjfjXUxTe5HYdLXhK3bGB8NgXj/x4TyBu5EdlJp7nV31
        mz/oqnV1fu6Rl7zGDSG9mdnXJu7W+/+r44aNZVh9DWchrV7V1AJFqb+YeVlyn67tdt6Mg3
        JY7UHbZa3awmtH2+bp56ltqwL5wxzIY=
Received: from mimecast-mx02.redhat.com (mimecast-mx02.redhat.com
 [66.187.233.88]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 us-mta-612-2VMedOL2PkqYySq_Hlwhxg-1; Wed, 29 Mar 2023 10:14:47 -0400
X-MC-Unique: 2VMedOL2PkqYySq_Hlwhxg-1
Received: from smtp.corp.redhat.com (int-mx06.intmail.prod.int.rdu2.redhat.com [10.11.54.6])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mimecast-mx02.redhat.com (Postfix) with ESMTPS id 76C28185A7A9;
        Wed, 29 Mar 2023 14:14:46 +0000 (UTC)
Received: from warthog.procyon.org.uk (unknown [10.33.36.18])
        by smtp.corp.redhat.com (Postfix) with ESMTP id 8174D2166B33;
        Wed, 29 Mar 2023 14:14:44 +0000 (UTC)
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
        Willem de Bruijn <willemdebruijn.kernel@gmail.com>
Subject: [RFC PATCH v2 17/48] ip, udp: Make sendmsg(MSG_SPLICE_PAGES) copy unspliceable data
Date:   Wed, 29 Mar 2023 15:13:23 +0100
Message-Id: <20230329141354.516864-18-dhowells@redhat.com>
In-Reply-To: <20230329141354.516864-1-dhowells@redhat.com>
References: <20230329141354.516864-1-dhowells@redhat.com>
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

If sendmsg() with MSG_SPLICE_PAGES encounters a page that shouldn't be
spliced - a slab page, for instance, or one with a zero count - make
__ip_append_data() copy it.

Signed-off-by: David Howells <dhowells@redhat.com>
cc: Willem de Bruijn <willemdebruijn.kernel@gmail.com>
cc: "David S. Miller" <davem@davemloft.net>
cc: Eric Dumazet <edumazet@google.com>
cc: Jakub Kicinski <kuba@kernel.org>
cc: Paolo Abeni <pabeni@redhat.com>
cc: Jens Axboe <axboe@kernel.dk>
cc: Matthew Wilcox <willy@infradead.org>
cc: netdev@vger.kernel.org
---
 net/ipv4/ip_output.c | 19 +++++++++++++++++++
 1 file changed, 19 insertions(+)

diff --git a/net/ipv4/ip_output.c b/net/ipv4/ip_output.c
index 07736da70eab..e4aeaab704c8 100644
--- a/net/ipv4/ip_output.c
+++ b/net/ipv4/ip_output.c
@@ -1263,6 +1263,7 @@ static int __ip_append_data(struct sock *sk,
 			struct msghdr *msg = from;
 			struct page *page = NULL, **pages = &page;
 			size_t off;
+			bool put = false;
 
 			copy = iov_iter_extract_pages(&msg->msg_iter, &pages,
 						      copy, 1, 0, &off);
@@ -1271,7 +1272,25 @@ static int __ip_append_data(struct sock *sk,
 				goto error;
 			}
 
+			if (!sendpage_ok(page)) {
+				const void *p = kmap_local_page(page);
+				void *q;
+
+				q = page_frag_memdup(NULL, p + off, copy,
+						     sk->sk_allocation, ULONG_MAX);
+				kunmap_local(p);
+				if (!q) {
+					err = copy ?: -ENOMEM;
+					goto error;
+				}
+				page = virt_to_page(q);
+				off = offset_in_page(q);
+				put = true;
+			}
+
 			err = skb_append_pagefrags(skb, page, off, copy);
+			if (put)
+				put_page(page);
 			if (err < 0)
 				goto error;
 

