Return-Path: <netdev+bounces-9488-lists+netdev=lfdr.de@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from ny.mirrors.kernel.org (ny.mirrors.kernel.org [IPv6:2604:1380:45d1:ec00::1])
	by mail.lfdr.de (Postfix) with ESMTPS id B5654729639
	for <lists+netdev@lfdr.de>; Fri,  9 Jun 2023 12:03:51 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ny.mirrors.kernel.org (Postfix) with ESMTPS id 1353A1C210E6
	for <lists+netdev@lfdr.de>; Fri,  9 Jun 2023 10:03:48 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 7EDB714A8D;
	Fri,  9 Jun 2023 10:02:46 +0000 (UTC)
X-Original-To: netdev@vger.kernel.org
Received: from lindbergh.monkeyblade.net (lindbergh.monkeyblade.net [23.128.96.19])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 7339C13AE9
	for <netdev@vger.kernel.org>; Fri,  9 Jun 2023 10:02:46 +0000 (UTC)
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.133.124])
	by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 432A14222
	for <netdev@vger.kernel.org>; Fri,  9 Jun 2023 03:02:44 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1686304963;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=Q9KEcNHQNL0heWM2/AbZS5PCqRXLyTBij/nK3rNCY6c=;
	b=X8nfrF2jTCA86pDidBpJkLlIK4wsBnGDikffEPrNRJN0JfShM4nlJZ0XRZev4A5LeyEHTl
	7UaMUoTzw4n3rj5RV3anjOkDqaPThrCI/DrdMGRJcyPhJdcOveo9n4Y/pdA2BEEEeEfqUd
	Uc2UURQgAzD6L1dTTOgL3IUJVj3wQgI=
Received: from mimecast-mx02.redhat.com (mimecast-mx02.redhat.com
 [66.187.233.88]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 us-mta-274-aAfw7x-ZPUWuB_Kb0AVAug-1; Fri, 09 Jun 2023 06:02:39 -0400
X-MC-Unique: aAfw7x-ZPUWuB_Kb0AVAug-1
Received: from smtp.corp.redhat.com (int-mx07.intmail.prod.int.rdu2.redhat.com [10.11.54.7])
	(using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by mimecast-mx02.redhat.com (Postfix) with ESMTPS id AB5E680120A;
	Fri,  9 Jun 2023 10:02:38 +0000 (UTC)
Received: from warthog.procyon.org.uk (unknown [10.42.28.51])
	by smtp.corp.redhat.com (Postfix) with ESMTP id 582EB145B965;
	Fri,  9 Jun 2023 10:02:35 +0000 (UTC)
From: David Howells <dhowells@redhat.com>
To: netdev@vger.kernel.org
Cc: David Howells <dhowells@redhat.com>,
	Jakub Kicinski <kuba@kernel.org>,
	"David S. Miller" <davem@davemloft.net>,
	Eric Dumazet <edumazet@google.com>,
	Paolo Abeni <pabeni@redhat.com>,
	Willem de Bruijn <willemdebruijn.kernel@gmail.com>,
	David Ahern <dsahern@kernel.org>,
	Matthew Wilcox <willy@infradead.org>,
	Jens Axboe <axboe@kernel.dk>,
	linux-mm@kvack.org,
	linux-kernel@vger.kernel.org,
	John Fastabend <john.fastabend@gmail.com>,
	Jakub Sitnicki <jakub@cloudflare.com>,
	bpf@vger.kernel.org
Subject: [PATCH net-next 4/6] tcp_bpf: Make tcp_bpf_sendpage() go through tcp_bpf_sendmsg(MSG_SPLICE_PAGES)
Date: Fri,  9 Jun 2023 11:02:19 +0100
Message-ID: <20230609100221.2620633-5-dhowells@redhat.com>
In-Reply-To: <20230609100221.2620633-1-dhowells@redhat.com>
References: <20230609100221.2620633-1-dhowells@redhat.com>
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
	RCVD_IN_MSPIKE_H5,RCVD_IN_MSPIKE_WL,SPF_HELO_NONE,SPF_NONE,
	T_SCC_BODY_TEXT_LINE autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
	lindbergh.monkeyblade.net

Make tcp_bpf_sendpage() a wrapper around tcp_bpf_sendmsg(MSG_SPLICE_PAGES)
rather than a loop calling tcp_sendpage().  sendpage() will be removed in
the future.

Signed-off-by: David Howells <dhowells@redhat.com>
cc: John Fastabend <john.fastabend@gmail.com>
cc: Jakub Sitnicki <jakub@cloudflare.com>
cc: "David S. Miller" <davem@davemloft.net>
cc: Eric Dumazet <edumazet@google.com>
cc: Jakub Kicinski <kuba@kernel.org>
cc: Paolo Abeni <pabeni@redhat.com>
cc: Jens Axboe <axboe@kernel.dk>
cc: Matthew Wilcox <willy@infradead.org>
cc: bpf@vger.kernel.org
cc: netdev@vger.kernel.org
---
 net/ipv4/tcp_bpf.c | 49 +++++++++-------------------------------------
 1 file changed, 9 insertions(+), 40 deletions(-)

diff --git a/net/ipv4/tcp_bpf.c b/net/ipv4/tcp_bpf.c
index e75023ea052f..5a84053ac62b 100644
--- a/net/ipv4/tcp_bpf.c
+++ b/net/ipv4/tcp_bpf.c
@@ -568,49 +568,18 @@ static int tcp_bpf_sendmsg(struct sock *sk, struct msghdr *msg, size_t size)
 static int tcp_bpf_sendpage(struct sock *sk, struct page *page, int offset,
 			    size_t size, int flags)
 {
-	struct sk_msg tmp, *msg = NULL;
-	int err = 0, copied = 0;
-	struct sk_psock *psock;
-	bool enospc = false;
-
-	psock = sk_psock_get(sk);
-	if (unlikely(!psock))
-		return tcp_sendpage(sk, page, offset, size, flags);
+	struct bio_vec bvec;
+	struct msghdr msg = {
+		.msg_flags = flags | MSG_SPLICE_PAGES,
+	};
 
-	lock_sock(sk);
-	if (psock->cork) {
-		msg = psock->cork;
-	} else {
-		msg = &tmp;
-		sk_msg_init(msg);
-	}
+	bvec_set_page(&bvec, page, size, offset);
+	iov_iter_bvec(&msg.msg_iter, ITER_SOURCE, &bvec, 1, size);
 
-	/* Catch case where ring is full and sendpage is stalled. */
-	if (unlikely(sk_msg_full(msg)))
-		goto out_err;
-
-	sk_msg_page_add(msg, page, size, offset);
-	sk_mem_charge(sk, size);
-	copied = size;
-	if (sk_msg_full(msg))
-		enospc = true;
-	if (psock->cork_bytes) {
-		if (size > psock->cork_bytes)
-			psock->cork_bytes = 0;
-		else
-			psock->cork_bytes -= size;
-		if (psock->cork_bytes && !enospc)
-			goto out_err;
-		/* All cork bytes are accounted, rerun the prog. */
-		psock->eval = __SK_NONE;
-		psock->cork_bytes = 0;
-	}
+	if (flags & MSG_SENDPAGE_NOTLAST)
+		msg.msg_flags |= MSG_MORE;
 
-	err = tcp_bpf_send_verdict(sk, psock, msg, &copied, flags);
-out_err:
-	release_sock(sk);
-	sk_psock_put(sk, psock);
-	return copied ? copied : err;
+	return tcp_bpf_sendmsg(sk, &msg, size);
 }
 
 enum {


