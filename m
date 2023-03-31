Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id C11E16D2513
	for <lists+netdev@lfdr.de>; Fri, 31 Mar 2023 18:15:26 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233374AbjCaQPY (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 31 Mar 2023 12:15:24 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:60600 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232900AbjCaQOA (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 31 Mar 2023 12:14:00 -0400
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.133.124])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 5CCE524405
        for <netdev@vger.kernel.org>; Fri, 31 Mar 2023 09:10:44 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1680279043;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=zbMUDKrdVAVwS+N9r9mW+fACtMcx+N9uUpcmjLnA2dk=;
        b=SI28YrODEiCWIcM4TaSEbIiCVwEvYeCLTDu2GVeVlGgAtSViPPl32b9jWD+1/p+TlggcfK
        hhMPyQXP2OvYUacuqeaW473crux4aftEUpWeYKUy92VQBhX/ZSk4cCYldHbqexBTX1Ztdt
        KbIvEvgW4zQRdIln6Clrn5FAGXRD8Eo=
Received: from mimecast-mx02.redhat.com (mx3-rdu2.redhat.com
 [66.187.233.73]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 us-mta-398-2LwuMPeSO5ywsd8zwlaphQ-1; Fri, 31 Mar 2023 12:10:38 -0400
X-MC-Unique: 2LwuMPeSO5ywsd8zwlaphQ-1
Received: from smtp.corp.redhat.com (int-mx10.intmail.prod.int.rdu2.redhat.com [10.11.54.10])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mimecast-mx02.redhat.com (Postfix) with ESMTPS id 48CE73802B94;
        Fri, 31 Mar 2023 16:10:36 +0000 (UTC)
Received: from warthog.procyon.org.uk (unknown [10.33.36.18])
        by smtp.corp.redhat.com (Postfix) with ESMTP id 35BAC492C3E;
        Fri, 31 Mar 2023 16:10:34 +0000 (UTC)
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
        Boris Pismenny <borisp@nvidia.com>,
        John Fastabend <john.fastabend@gmail.com>
Subject: [PATCH v3 27/55] tls/device: Support MSG_SPLICE_PAGES
Date:   Fri, 31 Mar 2023 17:08:46 +0100
Message-Id: <20230331160914.1608208-28-dhowells@redhat.com>
In-Reply-To: <20230331160914.1608208-1-dhowells@redhat.com>
References: <20230331160914.1608208-1-dhowells@redhat.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Scanned-By: MIMEDefang 3.1 on 10.11.54.10
X-Spam-Status: No, score=-0.2 required=5.0 tests=DKIMWL_WL_HIGH,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_NONE,
        RCVD_IN_MSPIKE_H2,SPF_HELO_NONE,SPF_NONE autolearn=unavailable
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Make TLS's device sendmsg() support MSG_SPLICE_PAGES.  This causes pages to
be spliced from the source iterator if possible and copied the data if not.

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
---
 net/tls/tls_device.c | 26 ++++++++++++++++++++++++++
 1 file changed, 26 insertions(+)

diff --git a/net/tls/tls_device.c b/net/tls/tls_device.c
index 6c593788dc25..f5c3b56ac1ce 100644
--- a/net/tls/tls_device.c
+++ b/net/tls/tls_device.c
@@ -508,7 +508,30 @@ static int tls_push_data(struct sock *sk,
 			zc_pfrag.offset = iter_offset.offset;
 			zc_pfrag.size = copy;
 			tls_append_frag(record, &zc_pfrag, copy);
+		} else if (copy && (flags & MSG_SPLICE_PAGES)) {
+			struct page_frag zc_pfrag;
+			struct page **pages = &zc_pfrag.page;
+			size_t off;
+
+			rc = iov_iter_extract_pages(iter_offset.msg_iter, &pages,
+						    copy, 1, 0, &off);
+			if (rc <= 0) {
+				if (rc == 0)
+					rc = -EIO;
+				goto handle_error;
+			}
+			copy = rc;
+
+			if (!sendpage_ok(zc_pfrag.page)) {
+				iov_iter_revert(iter_offset.msg_iter, copy);
+				goto no_zcopy_this_page;
+			}
+
+			zc_pfrag.offset = off;
+			zc_pfrag.size = copy;
+			tls_append_frag(record, &zc_pfrag, copy);
 		} else if (copy) {
+no_zcopy_this_page:
 			copy = min_t(size_t, copy, pfrag->size - pfrag->offset);
 
 			rc = tls_device_copy_data(page_address(pfrag->page) +
@@ -571,6 +594,9 @@ int tls_device_sendmsg(struct sock *sk, struct msghdr *msg, size_t size)
 	union tls_iter_offset iter;
 	int rc;
 
+	if (!tls_ctx->zerocopy_sendfile)
+		msg->msg_flags &= ~MSG_SPLICE_PAGES;
+
 	mutex_lock(&tls_ctx->tx_lock);
 	lock_sock(sk);
 

