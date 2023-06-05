Return-Path: <netdev+bounces-8001-lists+netdev=lfdr.de@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [139.178.88.99])
	by mail.lfdr.de (Postfix) with ESMTPS id E12B072264D
	for <lists+netdev@lfdr.de>; Mon,  5 Jun 2023 14:48:28 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id 9B6CC2812C9
	for <lists+netdev@lfdr.de>; Mon,  5 Jun 2023 12:48:27 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 4D37019BBE;
	Mon,  5 Jun 2023 12:46:36 +0000 (UTC)
X-Original-To: netdev@vger.kernel.org
Received: from lindbergh.monkeyblade.net (lindbergh.monkeyblade.net [23.128.96.19])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 41B2F18AF4
	for <netdev@vger.kernel.org>; Mon,  5 Jun 2023 12:46:36 +0000 (UTC)
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.129.124])
	by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 38621FA
	for <netdev@vger.kernel.org>; Mon,  5 Jun 2023 05:46:34 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1685969193;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=W0FWRRqlHW2dml6zeyANP94ZNOMoghLMR9ZqTCxdb24=;
	b=ZmXjLkUqIViZ1v3uV3oYe8ThAujivfwlJagek8G7dsR9R8g+t3auPBG/YqZsxin5phOrnb
	55iW89JTkh4AJKikZwehYGVZ3N+LkTdw/sALiFS7JL4f/kHM+rgkSJ/eBq9+cEnaDCM1+z
	QLPk5VHX62ha2DPCuhKipJpHXi9nGaU=
Received: from mimecast-mx02.redhat.com (mimecast-mx02.redhat.com
 [66.187.233.88]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 us-mta-217-qmCbG5JcO_-fBCTGdBFm8w-1; Mon, 05 Jun 2023 08:46:30 -0400
X-MC-Unique: qmCbG5JcO_-fBCTGdBFm8w-1
Received: from smtp.corp.redhat.com (int-mx02.intmail.prod.int.rdu2.redhat.com [10.11.54.2])
	(using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by mimecast-mx02.redhat.com (Postfix) with ESMTPS id 9153980120A;
	Mon,  5 Jun 2023 12:46:29 +0000 (UTC)
Received: from warthog.procyon.org.uk (unknown [10.42.28.182])
	by smtp.corp.redhat.com (Postfix) with ESMTP id 73B754087C62;
	Mon,  5 Jun 2023 12:46:27 +0000 (UTC)
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
Subject: [PATCH net-next v4 08/11] tls/sw: Support MSG_SPLICE_PAGES
Date: Mon,  5 Jun 2023 13:45:57 +0100
Message-ID: <20230605124600.1722160-9-dhowells@redhat.com>
In-Reply-To: <20230605124600.1722160-1-dhowells@redhat.com>
References: <20230605124600.1722160-1-dhowells@redhat.com>
Precedence: bulk
X-Mailing-List: netdev@vger.kernel.org
List-Id: <netdev.vger.kernel.org>
List-Subscribe: <mailto:netdev+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:netdev+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Scanned-By: MIMEDefang 3.1 on 10.11.54.2
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
	DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_NONE,
	SPF_HELO_NONE,SPF_NONE,T_SCC_BODY_TEXT_LINE autolearn=ham
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
index 7a6bb670073f..b85f92be7c9d 100644
--- a/net/tls/tls_sw.c
+++ b/net/tls/tls_sw.c
@@ -929,6 +929,38 @@ static int tls_sw_push_pending_record(struct sock *sk, int flags)
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
@@ -1018,6 +1050,17 @@ int tls_sw_sendmsg(struct sock *sk, struct msghdr *msg, size_t size)
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
 
@@ -1080,8 +1123,9 @@ int tls_sw_sendmsg(struct sock *sk, struct msghdr *msg, size_t size)
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


