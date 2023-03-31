Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 7045D6D24E6
	for <lists+netdev@lfdr.de>; Fri, 31 Mar 2023 18:12:47 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233228AbjCaQMd (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 31 Mar 2023 12:12:33 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:34646 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231981AbjCaQLo (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 31 Mar 2023 12:11:44 -0400
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.133.124])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 561671FD2C
        for <netdev@vger.kernel.org>; Fri, 31 Mar 2023 09:10:14 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1680279013;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=t1cUbUkat/Gf1dtGRXqhXt4i30LjR64ymk07qbS2yB8=;
        b=QB/XkKcwSCmDMDZ89e3D7GLaoPdL6NsXyaot9zQpUUXnILp9IrLDjoxx2vMH++LSH1kn/Y
        RrHE9JEPBm8z9QZNWsWbFs5Lka9B1iiaPM7mxYDP9dZ+0k0dQyMyjxfgD3lx20dTKTswKc
        nLjQgimmigJPQtZLugaWiMjNQIPSCKk=
Received: from mimecast-mx02.redhat.com (mimecast-mx02.redhat.com
 [66.187.233.88]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 us-mta-488-2g961z0wNy-7npZvx0P1sg-1; Fri, 31 Mar 2023 12:10:10 -0400
X-MC-Unique: 2g961z0wNy-7npZvx0P1sg-1
Received: from smtp.corp.redhat.com (int-mx03.intmail.prod.int.rdu2.redhat.com [10.11.54.3])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mimecast-mx02.redhat.com (Postfix) with ESMTPS id C8816185A78B;
        Fri, 31 Mar 2023 16:10:06 +0000 (UTC)
Received: from warthog.procyon.org.uk (unknown [10.33.36.18])
        by smtp.corp.redhat.com (Postfix) with ESMTP id CD6FD1121314;
        Fri, 31 Mar 2023 16:10:04 +0000 (UTC)
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
Subject: [PATCH v3 16/55] ip, udp: Make sendmsg(MSG_SPLICE_PAGES) copy unspliceable data
Date:   Fri, 31 Mar 2023 17:08:35 +0100
Message-Id: <20230331160914.1608208-17-dhowells@redhat.com>
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
index e2eaba817c1f..41a954ac9e1a 100644
--- a/net/ipv4/ip_output.c
+++ b/net/ipv4/ip_output.c
@@ -1004,13 +1004,32 @@ static int __ip_splice_pages(struct sock *sk, struct sk_buff *skb,
 	struct page *page = NULL, **pages = &page;
 	ssize_t copy = *pcopy;
 	size_t off;
+	bool put = false;
 	int err;
 
 	copy = iov_iter_extract_pages(&msg->msg_iter, &pages, copy, 1, 0, &off);
 	if (copy <= 0)
 		return copy ?: -EIO;
 
+	if (!sendpage_ok(page)) {
+		const void *p = kmap_local_page(page);
+		void *q;
+
+		q = page_frag_memdup(NULL, p + off, copy,
+				     sk->sk_allocation, ULONG_MAX);
+		kunmap_local(p);
+		if (!q) {
+			iov_iter_revert(&msg->msg_iter, copy);
+			return -ENOMEM;
+		}
+		page = virt_to_page(q);
+		off = offset_in_page(q);
+		put = true;
+	}
+
 	err = skb_append_pagefrags(skb, page, off, copy);
+	if (put)
+		put_page(page);
 	if (err < 0) {
 		iov_iter_revert(&msg->msg_iter, copy);
 		return err;

