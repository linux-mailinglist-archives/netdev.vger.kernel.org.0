Return-Path: <netdev+bounces-9009-lists+netdev=lfdr.de@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [IPv6:2604:1380:45e3:2400::1])
	by mail.lfdr.de (Postfix) with ESMTPS id 13C64726887
	for <lists+netdev@lfdr.de>; Wed,  7 Jun 2023 20:23:56 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id C3E86280C44
	for <lists+netdev@lfdr.de>; Wed,  7 Jun 2023 18:23:54 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 534E03923D;
	Wed,  7 Jun 2023 18:20:38 +0000 (UTC)
X-Original-To: netdev@vger.kernel.org
Received: from lindbergh.monkeyblade.net (lindbergh.monkeyblade.net [23.128.96.19])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 467653923B
	for <netdev@vger.kernel.org>; Wed,  7 Jun 2023 18:20:37 +0000 (UTC)
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.133.124])
	by lindbergh.monkeyblade.net (Postfix) with ESMTPS id EF46A2100
	for <netdev@vger.kernel.org>; Wed,  7 Jun 2023 11:20:34 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1686162034;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=4vaOjJ4V8cBQxw4FBR0piHsYWVs4rIzqgZ7rDnK+p44=;
	b=B/4/wTGG76x1SaJ72/IyMbos2lpiA89VOodyKBRR/SDWsypNAg24qph1bZENoLw6p3gRWt
	cB7T1RR82GOW6h7CQIUiy/6rp+FmGqxPPDzDZW9YItYU5oohRAQLxcP/eMMRDx1Op4ppQ4
	LN+FRazBMvysXUi1+JMYLqVVTG4x0VA=
Received: from mimecast-mx02.redhat.com (mimecast-mx02.redhat.com
 [66.187.233.88]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 us-mta-354-LRCuNYAMOOq4Tm5Pxw5q1A-1; Wed, 07 Jun 2023 14:20:25 -0400
X-MC-Unique: LRCuNYAMOOq4Tm5Pxw5q1A-1
Received: from smtp.corp.redhat.com (int-mx10.intmail.prod.int.rdu2.redhat.com [10.11.54.10])
	(using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by mimecast-mx02.redhat.com (Postfix) with ESMTPS id 5340480027F;
	Wed,  7 Jun 2023 18:20:24 +0000 (UTC)
Received: from warthog.procyon.org.uk (unknown [10.42.28.182])
	by smtp.corp.redhat.com (Postfix) with ESMTP id 87D23403367;
	Wed,  7 Jun 2023 18:20:22 +0000 (UTC)
From: David Howells <dhowells@redhat.com>
To: netdev@vger.kernel.org,
	Linus Torvalds <torvalds@linux-foundation.org>
Cc: David Howells <dhowells@redhat.com>,
	Chuck Lever <chuck.lever@oracle.com>,
	Boris Pismenny <borisp@nvidia.com>,
	John Fastabend <john.fastabend@gmail.com>,
	Jakub Kicinski <kuba@kernel.org>,
	"David S. Miller" <davem@davemloft.net>,
	Eric Dumazet <edumazet@google.com>,
	Paolo Abeni <pabeni@redhat.com>,
	Willem de Bruijn <willemdebruijn.kernel@gmail.com>,
	David Ahern <dsahern@kernel.org>,
	Matthew Wilcox <willy@infradead.org>,
	Jens Axboe <axboe@kernel.dk>,
	linux-mm@kvack.org,
	linux-kernel@vger.kernel.org
Subject: [PATCH net-next v6 13/14] tls/device: Support MSG_SPLICE_PAGES
Date: Wed,  7 Jun 2023 19:19:19 +0100
Message-ID: <20230607181920.2294972-14-dhowells@redhat.com>
In-Reply-To: <20230607181920.2294972-1-dhowells@redhat.com>
References: <20230607181920.2294972-1-dhowells@redhat.com>
Precedence: bulk
X-Mailing-List: netdev@vger.kernel.org
List-Id: <netdev.vger.kernel.org>
List-Subscribe: <mailto:netdev+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:netdev+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Scanned-By: MIMEDefang 3.1 on 10.11.54.10
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
	DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_NONE,
	SPF_HELO_NONE,SPF_NONE,T_SCC_BODY_TEXT_LINE autolearn=ham
	autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
	lindbergh.monkeyblade.net

Make TLS's device sendmsg() support MSG_SPLICE_PAGES.  This causes pages to
be spliced from the source iterator if possible.

This allows ->sendpage() to be replaced by something that can handle
multiple multipage folios in a single transaction.

Signed-off-by: David Howells <dhowells@redhat.com>
Reviewed-by: Jakub Kicinski <kuba@kernel.org>
cc: Chuck Lever <chuck.lever@oracle.com>
cc: Boris Pismenny <borisp@nvidia.com>
cc: John Fastabend <john.fastabend@gmail.com>
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
index 439be833dcf9..bb3bb523544e 100644
--- a/net/tls/tls_device.c
+++ b/net/tls/tls_device.c
@@ -509,6 +509,29 @@ static int tls_push_data(struct sock *sk,
 			tls_append_frag(record, &zc_pfrag, copy);
 
 			iter_offset.offset += copy;
+		} else if (copy && (flags & MSG_SPLICE_PAGES)) {
+			struct page_frag zc_pfrag;
+			struct page **pages = &zc_pfrag.page;
+			size_t off;
+
+			rc = iov_iter_extract_pages(iter_offset.msg_iter,
+						    &pages, copy, 1, 0, &off);
+			if (rc <= 0) {
+				if (rc == 0)
+					rc = -EIO;
+				goto handle_error;
+			}
+			copy = rc;
+
+			if (WARN_ON_ONCE(!sendpage_ok(zc_pfrag.page))) {
+				iov_iter_revert(iter_offset.msg_iter, copy);
+				rc = -EIO;
+				goto handle_error;
+			}
+
+			zc_pfrag.offset = off;
+			zc_pfrag.size = copy;
+			tls_append_frag(record, &zc_pfrag, copy);
 		} else if (copy) {
 			copy = min_t(size_t, copy, pfrag->size - pfrag->offset);
 
@@ -572,6 +595,9 @@ int tls_device_sendmsg(struct sock *sk, struct msghdr *msg, size_t size)
 	union tls_iter_offset iter;
 	int rc;
 
+	if (!tls_ctx->zerocopy_sendfile)
+		msg->msg_flags &= ~MSG_SPLICE_PAGES;
+
 	mutex_lock(&tls_ctx->tx_lock);
 	lock_sock(sk);
 


