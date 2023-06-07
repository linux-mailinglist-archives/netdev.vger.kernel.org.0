Return-Path: <netdev+bounces-8890-lists+netdev=lfdr.de@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from ny.mirrors.kernel.org (ny.mirrors.kernel.org [147.75.199.223])
	by mail.lfdr.de (Postfix) with ESMTPS id 03071726316
	for <lists+netdev@lfdr.de>; Wed,  7 Jun 2023 16:41:43 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ny.mirrors.kernel.org (Postfix) with ESMTPS id 5FCA81C20DBB
	for <lists+netdev@lfdr.de>; Wed,  7 Jun 2023 14:41:39 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 0457D168CC;
	Wed,  7 Jun 2023 14:41:40 +0000 (UTC)
X-Original-To: netdev@vger.kernel.org
Received: from lindbergh.monkeyblade.net (lindbergh.monkeyblade.net [23.128.96.19])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id E61BD8C1D
	for <netdev@vger.kernel.org>; Wed,  7 Jun 2023 14:41:39 +0000 (UTC)
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.129.124])
	by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 4524D172E
	for <netdev@vger.kernel.org>; Wed,  7 Jun 2023 07:41:38 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1686148897;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=axbQ2fmWT7oadEpv+RKPywBYD27/saJPi8A/5AZqeFc=;
	b=ggvvRXV0g5zfkv2ScHvyLqQcYBEBE+IO7FM3x+z1PIXueWOjG9M4zkW15z3FP2keY4Y5wZ
	x7Tw/tAOz/cwsupe864qtNCaxOYdmS9pGSTefa8YNrxdthPBoSn5u31fIgKlqY39terj+/
	+jhbaFUnnoQxOTfd00eTOrS4yEywOrk=
Received: from mimecast-mx02.redhat.com (mx3-rdu2.redhat.com
 [66.187.233.73]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 us-mta-135-O41qDC5EPpCAaVWMZOdERQ-1; Wed, 07 Jun 2023 10:06:42 -0400
X-MC-Unique: O41qDC5EPpCAaVWMZOdERQ-1
Received: from smtp.corp.redhat.com (int-mx10.intmail.prod.int.rdu2.redhat.com [10.11.54.10])
	(using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by mimecast-mx02.redhat.com (Postfix) with ESMTPS id 6EF1E1C02D26;
	Wed,  7 Jun 2023 14:06:38 +0000 (UTC)
Received: from warthog.procyon.org.uk (unknown [10.42.28.182])
	by smtp.corp.redhat.com (Postfix) with ESMTP id E5062403367;
	Wed,  7 Jun 2023 14:06:34 +0000 (UTC)
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
	linux-kernel@vger.kernel.org,
	Ayush Sawal <ayush.sawal@chelsio.com>
Subject: [PATCH net-next v5 08/14] chelsio/chtls: Use splice_eof() to flush
Date: Wed,  7 Jun 2023 15:05:53 +0100
Message-ID: <20230607140559.2263470-9-dhowells@redhat.com>
In-Reply-To: <20230607140559.2263470-1-dhowells@redhat.com>
References: <20230607140559.2263470-1-dhowells@redhat.com>
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
	SPF_HELO_NONE,SPF_NONE,T_SCC_BODY_TEXT_LINE autolearn=unavailable
	autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
	lindbergh.monkeyblade.net

Allow splice to end a Chelsio TLS record after prematurely ending a
splice/sendfile due to getting an EOF condition (->splice_read() returned
0) after splice had called sendmsg() with MSG_MORE set when the user didn't
set MSG_MORE.

Suggested-by: Linus Torvalds <torvalds@linux-foundation.org>
Link: https://lore.kernel.org/r/CAHk-=wh=V579PDYvkpnTobCLGczbgxpMgGmmhqiTyE34Cpi5Gg@mail.gmail.com/
Signed-off-by: David Howells <dhowells@redhat.com>
cc: Ayush Sawal <ayush.sawal@chelsio.com>
cc: "David S. Miller" <davem@davemloft.net>
cc: Eric Dumazet <edumazet@google.com>
cc: Jakub Kicinski <kuba@kernel.org>
cc: Paolo Abeni <pabeni@redhat.com>
cc: Jens Axboe <axboe@kernel.dk>
cc: Matthew Wilcox <willy@infradead.org>
cc: netdev@vger.kernel.org
---
 drivers/net/ethernet/chelsio/inline_crypto/chtls/chtls.h | 1 +
 .../net/ethernet/chelsio/inline_crypto/chtls/chtls_io.c  | 9 +++++++++
 .../ethernet/chelsio/inline_crypto/chtls/chtls_main.c    | 1 +
 3 files changed, 11 insertions(+)

diff --git a/drivers/net/ethernet/chelsio/inline_crypto/chtls/chtls.h b/drivers/net/ethernet/chelsio/inline_crypto/chtls/chtls.h
index 41714203ace8..da4818d2c856 100644
--- a/drivers/net/ethernet/chelsio/inline_crypto/chtls/chtls.h
+++ b/drivers/net/ethernet/chelsio/inline_crypto/chtls/chtls.h
@@ -568,6 +568,7 @@ void chtls_destroy_sock(struct sock *sk);
 int chtls_sendmsg(struct sock *sk, struct msghdr *msg, size_t size);
 int chtls_recvmsg(struct sock *sk, struct msghdr *msg,
 		  size_t len, int flags, int *addr_len);
+void chtls_splice_eof(struct socket *sock);
 int chtls_sendpage(struct sock *sk, struct page *page,
 		   int offset, size_t size, int flags);
 int send_tx_flowc_wr(struct sock *sk, int compl,
diff --git a/drivers/net/ethernet/chelsio/inline_crypto/chtls/chtls_io.c b/drivers/net/ethernet/chelsio/inline_crypto/chtls/chtls_io.c
index 5724bbbb6ee0..e08ac960c967 100644
--- a/drivers/net/ethernet/chelsio/inline_crypto/chtls/chtls_io.c
+++ b/drivers/net/ethernet/chelsio/inline_crypto/chtls/chtls_io.c
@@ -1237,6 +1237,15 @@ int chtls_sendmsg(struct sock *sk, struct msghdr *msg, size_t size)
 	goto done;
 }
 
+void chtls_splice_eof(struct socket *sock)
+{
+	struct sock *sk = sock->sk;
+
+	lock_sock(sk);
+	chtls_tcp_push(sk, 0);
+	release_sock(sk);
+}
+
 int chtls_sendpage(struct sock *sk, struct page *page,
 		   int offset, size_t size, int flags)
 {
diff --git a/drivers/net/ethernet/chelsio/inline_crypto/chtls/chtls_main.c b/drivers/net/ethernet/chelsio/inline_crypto/chtls/chtls_main.c
index 1e55b12fee51..6b6787eafd2f 100644
--- a/drivers/net/ethernet/chelsio/inline_crypto/chtls/chtls_main.c
+++ b/drivers/net/ethernet/chelsio/inline_crypto/chtls/chtls_main.c
@@ -606,6 +606,7 @@ static void __init chtls_init_ulp_ops(void)
 	chtls_cpl_prot.destroy		= chtls_destroy_sock;
 	chtls_cpl_prot.shutdown		= chtls_shutdown;
 	chtls_cpl_prot.sendmsg		= chtls_sendmsg;
+	chtls_cpl_prot.splice_eof	= chtls_splice_eof;
 	chtls_cpl_prot.sendpage		= chtls_sendpage;
 	chtls_cpl_prot.recvmsg		= chtls_recvmsg;
 	chtls_cpl_prot.setsockopt	= chtls_setsockopt;


