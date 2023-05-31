Return-Path: <netdev+bounces-6767-lists+netdev=lfdr.de@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [139.178.88.99])
	by mail.lfdr.de (Postfix) with ESMTPS id 2FAB9717D7D
	for <lists+netdev@lfdr.de>; Wed, 31 May 2023 13:00:46 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id DF6D62813BE
	for <lists+netdev@lfdr.de>; Wed, 31 May 2023 11:00:44 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id F25BABE72;
	Wed, 31 May 2023 11:00:28 +0000 (UTC)
X-Original-To: netdev@vger.kernel.org
Received: from lindbergh.monkeyblade.net (lindbergh.monkeyblade.net [23.128.96.19])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id E3BACC2F9
	for <netdev@vger.kernel.org>; Wed, 31 May 2023 11:00:28 +0000 (UTC)
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.129.124])
	by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 63FB1126
	for <netdev@vger.kernel.org>; Wed, 31 May 2023 04:00:27 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1685530826;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=97CTgaKk+HjxMsHB1NZqYRmtg/935y1khOuMG78saNk=;
	b=KPOfJa7/7CMqbrFY+j7mCugiFgzNjnUh24Ll9O9G+Q1kwPBk3iLar3nC+yPDhEDhYdrknH
	Ck1WwJBuSrWfSL3lCEAd9jWjlsyEwaH5zq5OvHdcGzVzXRmsFbGy1BQtcueq8GEovdihQz
	rusYv0K5HowSQ8lwHJCwennT56PEeTo=
Received: from mimecast-mx02.redhat.com (mimecast-mx02.redhat.com
 [66.187.233.88]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 us-mta-513-3tfZ-SxcM6qaXos3TuNsaQ-1; Wed, 31 May 2023 07:00:21 -0400
X-MC-Unique: 3tfZ-SxcM6qaXos3TuNsaQ-1
Received: from smtp.corp.redhat.com (int-mx06.intmail.prod.int.rdu2.redhat.com [10.11.54.6])
	(using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by mimecast-mx02.redhat.com (Postfix) with ESMTPS id BA646101AA42;
	Wed, 31 May 2023 11:00:20 +0000 (UTC)
Received: from warthog.procyon.org.uk (unknown [10.42.28.182])
	by smtp.corp.redhat.com (Postfix) with ESMTP id E15D72166B25;
	Wed, 31 May 2023 11:00:18 +0000 (UTC)
From: David Howells <dhowells@redhat.com>
To: netdev@vger.kernel.org
Cc: David Howells <dhowells@redhat.com>,
	Ayush Sawal <ayush.sawal@chelsio.com>,
	"David S. Miller" <davem@davemloft.net>,
	Eric Dumazet <edumazet@google.com>,
	Jakub Kicinski <kuba@kernel.org>,
	Paolo Abeni <pabeni@redhat.com>,
	Willem de Bruijn <willemdebruijn.kernel@gmail.com>,
	David Ahern <dsahern@kernel.org>,
	Matthew Wilcox <willy@infradead.org>,
	Jens Axboe <axboe@kernel.dk>,
	Simon Horman <simon.horman@corigine.com>,
	linux-mm@kvack.org,
	linux-kernel@vger.kernel.org
Subject: [PATCH net-next v2 1/2] chelsio: Support MSG_SPLICE_PAGES
Date: Wed, 31 May 2023 12:00:07 +0100
Message-ID: <20230531110008.642903-2-dhowells@redhat.com>
In-Reply-To: <20230531110008.642903-1-dhowells@redhat.com>
References: <20230531110008.642903-1-dhowells@redhat.com>
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
	SPF_HELO_NONE,SPF_NONE,T_SCC_BODY_TEXT_LINE autolearn=ham
	autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
	lindbergh.monkeyblade.net

Make Chelsio's TLS offload sendmsg() support MSG_SPLICE_PAGES, splicing in
pages from the source iterator if possible and copying the data in
otherwise.

This allows ->sendpage() to be replaced by something that can handle
multiple multipage folios in a single transaction.

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
 .../ethernet/chelsio/inline_crypto/chtls/chtls_io.c  | 12 +++++++++++-
 1 file changed, 11 insertions(+), 1 deletion(-)

diff --git a/drivers/net/ethernet/chelsio/inline_crypto/chtls/chtls_io.c b/drivers/net/ethernet/chelsio/inline_crypto/chtls/chtls_io.c
index ae6b17b96bf1..1d08386ac916 100644
--- a/drivers/net/ethernet/chelsio/inline_crypto/chtls/chtls_io.c
+++ b/drivers/net/ethernet/chelsio/inline_crypto/chtls/chtls_io.c
@@ -1092,7 +1092,17 @@ int chtls_sendmsg(struct sock *sk, struct msghdr *msg, size_t size)
 		if (copy > size)
 			copy = size;
 
-		if (skb_tailroom(skb) > 0) {
+		if (msg->msg_flags & MSG_SPLICE_PAGES) {
+			err = skb_splice_from_iter(skb, &msg->msg_iter, copy,
+						   sk->sk_allocation);
+			if (err < 0) {
+				if (err == -EMSGSIZE)
+					goto new_buf;
+				goto do_fault;
+			}
+			copy = err;
+			sk_wmem_queued_add(sk, copy);
+		} else if (skb_tailroom(skb) > 0) {
 			copy = min(copy, skb_tailroom(skb));
 			if (is_tls_tx(csk))
 				copy = min_t(int, copy, csk->tlshws.txleft);


