Return-Path: <netdev+bounces-8882-lists+netdev=lfdr.de@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [139.178.88.99])
	by mail.lfdr.de (Postfix) with ESMTPS id 3D3337262E3
	for <lists+netdev@lfdr.de>; Wed,  7 Jun 2023 16:33:38 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id EBC62281421
	for <lists+netdev@lfdr.de>; Wed,  7 Jun 2023 14:33:36 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 6DBF214296;
	Wed,  7 Jun 2023 14:32:58 +0000 (UTC)
X-Original-To: netdev@vger.kernel.org
Received: from lindbergh.monkeyblade.net (lindbergh.monkeyblade.net [23.128.96.19])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 63B908C1D
	for <netdev@vger.kernel.org>; Wed,  7 Jun 2023 14:32:58 +0000 (UTC)
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.129.124])
	by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 9E98E1BEF
	for <netdev@vger.kernel.org>; Wed,  7 Jun 2023 07:32:56 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1686148375;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=mOKXaftBBhMTIlFKfwLIH8NhxIpiz+rLzmWYl6SoU0k=;
	b=J07mOMpyq8B20fZrjMWuPZiMnNzRVsyeLEBl2HnYKVri9doRqd6TPf73pH+WUmKvkeHpce
	QB1Kx4lQoFBYQgADIhlThtpb3n9wgGsGMX40uC9T3WA8v8N1L+oxGD63FL6OuiR5pXflkj
	niXQtbRp3Y0STjngD4mZwsok0YZOjRk=
Received: from mimecast-mx02.redhat.com (mx3-rdu2.redhat.com
 [66.187.233.73]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 us-mta-581-691rPYokOqqZ4ufsxb1e3w-1; Wed, 07 Jun 2023 10:06:51 -0400
X-MC-Unique: 691rPYokOqqZ4ufsxb1e3w-1
Received: from smtp.corp.redhat.com (int-mx07.intmail.prod.int.rdu2.redhat.com [10.11.54.7])
	(using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by mimecast-mx02.redhat.com (Postfix) with ESMTPS id E32302999B2E;
	Wed,  7 Jun 2023 14:06:50 +0000 (UTC)
Received: from warthog.procyon.org.uk (unknown [10.42.28.182])
	by smtp.corp.redhat.com (Postfix) with ESMTP id 91F90140E954;
	Wed,  7 Jun 2023 14:06:48 +0000 (UTC)
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
Subject: [PATCH net-next v5 11/14] tls/sw: Support MSG_SPLICE_PAGES
Date: Wed,  7 Jun 2023 15:05:56 +0100
Message-ID: <20230607140559.2263470-12-dhowells@redhat.com>
In-Reply-To: <20230607140559.2263470-1-dhowells@redhat.com>
References: <20230607140559.2263470-1-dhowells@redhat.com>
Precedence: bulk
X-Mailing-List: netdev@vger.kernel.org
List-Id: <netdev.vger.kernel.org>
List-Subscribe: <mailto:netdev+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:netdev+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Scanned-By: MIMEDefang 3.1 on 10.11.54.7
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
	DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_NONE,
	SPF_HELO_NONE,SPF_NONE,T_SCC_BODY_TEXT_LINE autolearn=unavailable
	autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
	lindbergh.monkeyblade.net

Make TLS's sendmsg() support MSG_SPLICE_PAGES.  This causes pages to be
spliced from the source iterator if possible.

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

Notes:
    ver #2)
     - "rls_" should be "tls_".

 net/tls/tls_sw.c | 46 +++++++++++++++++++++++++++++++++++++++++++++-
 1 file changed, 45 insertions(+), 1 deletion(-)

diff --git a/net/tls/tls_sw.c b/net/tls/tls_sw.c
index a2fb0256ff1c..fcbaf594c300 100644
--- a/net/tls/tls_sw.c
+++ b/net/tls/tls_sw.c
@@ -931,6 +931,38 @@ static int tls_sw_push_pending_record(struct sock *sk, int flags)
 				   &copied, flags);
 }
 
+static int tls_sw_sendmsg_splice(struct sock *sk, struct msghdr *msg,
+				 struct sk_msg *msg_pl, size_t try_to_copy,
+				 ssize_t *copied)
+{
+	struct page *page = NULL, **pages = &page;
+
+	do {
+		ssize_t part;
+		size_t off;
+		bool put = false;
+
+		part = iov_iter_extract_pages(&msg->msg_iter, &pages,
+					      try_to_copy, 1, 0, &off);
+		if (part <= 0)
+			return part ?: -EIO;
+
+		if (WARN_ON_ONCE(!sendpage_ok(page))) {
+			iov_iter_revert(&msg->msg_iter, part);
+			return -EIO;
+		}
+
+		sk_msg_page_add(msg_pl, page, part, off);
+		sk_mem_charge(sk, part);
+		if (put)
+			put_page(page);
+		*copied += part;
+		try_to_copy -= part;
+	} while (try_to_copy && !sk_msg_full(msg_pl));
+
+	return 0;
+}
+
 int tls_sw_sendmsg(struct sock *sk, struct msghdr *msg, size_t size)
 {
 	long timeo = sock_sndtimeo(sk, msg->msg_flags & MSG_DONTWAIT);
@@ -1020,6 +1052,17 @@ int tls_sw_sendmsg(struct sock *sk, struct msghdr *msg, size_t size)
 			full_record = true;
 		}
 
+		if (try_to_copy && (msg->msg_flags & MSG_SPLICE_PAGES)) {
+			ret = tls_sw_sendmsg_splice(sk, msg, msg_pl,
+						    try_to_copy, &copied);
+			if (ret < 0)
+				goto send_end;
+			tls_ctx->pending_open_record_frags = true;
+			if (full_record || eor || sk_msg_full(msg_pl))
+				goto copied;
+			continue;
+		}
+
 		if (!is_kvec && (full_record || eor) && !async_capable) {
 			u32 first = msg_pl->sg.end;
 
@@ -1082,8 +1125,9 @@ int tls_sw_sendmsg(struct sock *sk, struct msghdr *msg, size_t size)
 		/* Open records defined only if successfully copied, otherwise
 		 * we would trim the sg but not reset the open record frags.
 		 */
-		tls_ctx->pending_open_record_frags = true;
 		copied += try_to_copy;
+copied:
+		tls_ctx->pending_open_record_frags = true;
 		if (full_record || eor) {
 			ret = bpf_exec_tx_verdict(msg_pl, sk, full_record,
 						  record_type, &copied,


