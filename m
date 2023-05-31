Return-Path: <netdev+bounces-6793-lists+netdev=lfdr.de@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from ny.mirrors.kernel.org (ny.mirrors.kernel.org [147.75.199.223])
	by mail.lfdr.de (Postfix) with ESMTPS id DEFA3718039
	for <lists+netdev@lfdr.de>; Wed, 31 May 2023 14:47:27 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ny.mirrors.kernel.org (Postfix) with ESMTPS id 5D1CD1C20EA9
	for <lists+netdev@lfdr.de>; Wed, 31 May 2023 12:47:24 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id A357614AA6;
	Wed, 31 May 2023 12:45:56 +0000 (UTC)
X-Original-To: netdev@vger.kernel.org
Received: from lindbergh.monkeyblade.net (lindbergh.monkeyblade.net [23.128.96.19])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 994E614275
	for <netdev@vger.kernel.org>; Wed, 31 May 2023 12:45:56 +0000 (UTC)
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.133.124])
	by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 11D7C133
	for <netdev@vger.kernel.org>; Wed, 31 May 2023 05:45:54 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1685537154;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=uuYRuRqPrqYrWBy2myOfoGGw2Qio81ibrygQkKyKemI=;
	b=G09xyAbtaLd0YusgR+cF8uHNuSVjQQSuw1TsOzPj7hQdntCUi0JadTv4rYgXGARJSuDioR
	Fr5gGLzY1KcR0F9XnZMXtw9/gsFVvV8/zECc+g1yiEKURxPLYzvKPOR/yQCO+5YZp3S0Sw
	gbuUMpzuiIX8dPNmfV9Fuomq/deQrh0=
Received: from mimecast-mx02.redhat.com (mimecast-mx02.redhat.com
 [66.187.233.88]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 us-mta-54-R6gsZvE5P7aGqYDd_4hZXw-1; Wed, 31 May 2023 08:45:51 -0400
X-MC-Unique: R6gsZvE5P7aGqYDd_4hZXw-1
Received: from smtp.corp.redhat.com (int-mx06.intmail.prod.int.rdu2.redhat.com [10.11.54.6])
	(using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by mimecast-mx02.redhat.com (Postfix) with ESMTPS id 650F3811E7F;
	Wed, 31 May 2023 12:45:50 +0000 (UTC)
Received: from warthog.procyon.org.uk (unknown [10.42.28.182])
	by smtp.corp.redhat.com (Postfix) with ESMTP id 994162166B25;
	Wed, 31 May 2023 12:45:48 +0000 (UTC)
From: David Howells <dhowells@redhat.com>
To: netdev@vger.kernel.org
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
Subject: [PATCH net-next v2 5/6] tls/device: Support MSG_SPLICE_PAGES
Date: Wed, 31 May 2023 13:45:27 +0100
Message-ID: <20230531124528.699123-6-dhowells@redhat.com>
In-Reply-To: <20230531124528.699123-1-dhowells@redhat.com>
References: <20230531124528.699123-1-dhowells@redhat.com>
Precedence: bulk
X-Mailing-List: netdev@vger.kernel.org
List-Id: <netdev.vger.kernel.org>
List-Subscribe: <mailto:netdev+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:netdev+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Scanned-By: MIMEDefang 3.1 on 10.11.54.6
X-Spam-Status: No, score=-2.3 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
	DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_NONE,
	SPF_HELO_NONE,SPF_NONE,T_SCC_BODY_TEXT_LINE autolearn=unavailable
	autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
	lindbergh.monkeyblade.net

Make TLS's device sendmsg() support MSG_SPLICE_PAGES.  This causes pages to
be spliced from the source iterator if possible.

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
index a959572a816f..221fb30cba51 100644
--- a/net/tls/tls_device.c
+++ b/net/tls/tls_device.c
@@ -508,6 +508,29 @@ static int tls_push_data(struct sock *sk,
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
 
@@ -571,6 +594,9 @@ int tls_device_sendmsg(struct sock *sk, struct msghdr *msg, size_t size)
 	union tls_iter_offset iter;
 	int rc;
 
+	if (!tls_ctx->zerocopy_sendfile)
+		msg->msg_flags &= ~MSG_SPLICE_PAGES;
+
 	mutex_lock(&tls_ctx->tx_lock);
 	lock_sock(sk);
 


