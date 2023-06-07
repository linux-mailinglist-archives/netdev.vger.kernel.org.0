Return-Path: <netdev+bounces-8897-lists+netdev=lfdr.de@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from ny.mirrors.kernel.org (ny.mirrors.kernel.org [IPv6:2604:1380:45d1:ec00::1])
	by mail.lfdr.de (Postfix) with ESMTPS id A97C372635B
	for <lists+netdev@lfdr.de>; Wed,  7 Jun 2023 16:53:17 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ny.mirrors.kernel.org (Postfix) with ESMTPS id D26C71C20E08
	for <lists+netdev@lfdr.de>; Wed,  7 Jun 2023 14:53:13 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 7618C1ACB8;
	Wed,  7 Jun 2023 14:53:14 +0000 (UTC)
X-Original-To: netdev@vger.kernel.org
Received: from lindbergh.monkeyblade.net (lindbergh.monkeyblade.net [23.128.96.19])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 6A39C8C1D
	for <netdev@vger.kernel.org>; Wed,  7 Jun 2023 14:53:14 +0000 (UTC)
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.133.124])
	by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 906671734
	for <netdev@vger.kernel.org>; Wed,  7 Jun 2023 07:53:12 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1686149591;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=YYh07r9nLp9Gj3Ft6ZNJdfT/+HiAyQEDDAL/yG5YQDg=;
	b=cEtjXv2w1O8iUe9OPCjuxnRPe+N2mY5ypshO6+oKunVSVDscru9z2Y0MGkIWEvRZh1uJzU
	rE8y76owgDKI4qMszbeuaQz6RqRJfsnjIozDEcq6GQsDT/t9wQdiPyycWmWs8mXGiXw4Kc
	XF15stTM8XNiLcOvbAZlJbKQiC0AH4w=
Received: from mimecast-mx02.redhat.com (mimecast-mx02.redhat.com
 [66.187.233.88]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 us-mta-134-blPYcdEnN0m5yZ91Tl7iqQ-1; Wed, 07 Jun 2023 10:06:44 -0400
X-MC-Unique: blPYcdEnN0m5yZ91Tl7iqQ-1
Received: from smtp.corp.redhat.com (int-mx09.intmail.prod.int.rdu2.redhat.com [10.11.54.9])
	(using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by mimecast-mx02.redhat.com (Postfix) with ESMTPS id E47528028B1;
	Wed,  7 Jun 2023 14:06:42 +0000 (UTC)
Received: from warthog.procyon.org.uk (unknown [10.42.28.182])
	by smtp.corp.redhat.com (Postfix) with ESMTP id C031E4021AA;
	Wed,  7 Jun 2023 14:06:39 +0000 (UTC)
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
	Tom Herbert <tom@herbertland.com>,
	Tom Herbert <tom@quantonium.net>,
	Cong Wang <cong.wang@bytedance.com>
Subject: [PATCH net-next v5 09/14] kcm: Use splice_eof() to flush
Date: Wed,  7 Jun 2023 15:05:54 +0100
Message-ID: <20230607140559.2263470-10-dhowells@redhat.com>
In-Reply-To: <20230607140559.2263470-1-dhowells@redhat.com>
References: <20230607140559.2263470-1-dhowells@redhat.com>
Precedence: bulk
X-Mailing-List: netdev@vger.kernel.org
List-Id: <netdev.vger.kernel.org>
List-Subscribe: <mailto:netdev+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:netdev+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Scanned-By: MIMEDefang 3.1 on 10.11.54.9
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
	DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_NONE,
	SPF_HELO_NONE,SPF_NONE,T_SCC_BODY_TEXT_LINE autolearn=unavailable
	autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
	lindbergh.monkeyblade.net

Allow splice to undo the effects of MSG_MORE after prematurely ending a
splice/sendfile due to getting an EOF condition (->splice_read() returned
0) after splice had called sendmsg() with MSG_MORE set when the user didn't
set MSG_MORE.

Suggested-by: Linus Torvalds <torvalds@linux-foundation.org>
Link: https://lore.kernel.org/r/CAHk-=wh=V579PDYvkpnTobCLGczbgxpMgGmmhqiTyE34Cpi5Gg@mail.gmail.com/
Signed-off-by: David Howells <dhowells@redhat.com>
cc: Tom Herbert <tom@herbertland.com>
cc: Tom Herbert <tom@quantonium.net>
cc: Cong Wang <cong.wang@bytedance.com>
cc: Jakub Kicinski <kuba@kernel.org>
cc: Eric Dumazet <edumazet@google.com>
cc: "David S. Miller" <davem@davemloft.net>
cc: Paolo Abeni <pabeni@redhat.com>
cc: Jens Axboe <axboe@kernel.dk>
cc: Matthew Wilcox <willy@infradead.org>
cc: netdev@vger.kernel.org
---
 net/kcm/kcmsock.c | 15 +++++++++++++++
 1 file changed, 15 insertions(+)

diff --git a/net/kcm/kcmsock.c b/net/kcm/kcmsock.c
index ba22af16b96d..d0d8c54562d6 100644
--- a/net/kcm/kcmsock.c
+++ b/net/kcm/kcmsock.c
@@ -968,6 +968,19 @@ static int kcm_sendmsg(struct socket *sock, struct msghdr *msg, size_t len)
 	return err;
 }
 
+static void kcm_splice_eof(struct socket *sock)
+{
+	struct sock *sk = sock->sk;
+	struct kcm_sock *kcm = kcm_sk(sk);
+
+	if (skb_queue_empty(&sk->sk_write_queue))
+		return;
+
+	lock_sock(sk);
+	kcm_write_msgs(kcm);
+	release_sock(sk);
+}
+
 static ssize_t kcm_sendpage(struct socket *sock, struct page *page,
 			    int offset, size_t size, int flags)
 
@@ -1773,6 +1786,7 @@ static const struct proto_ops kcm_dgram_ops = {
 	.sendmsg =	kcm_sendmsg,
 	.recvmsg =	kcm_recvmsg,
 	.mmap =		sock_no_mmap,
+	.splice_eof =	kcm_splice_eof,
 	.sendpage =	kcm_sendpage,
 };
 
@@ -1794,6 +1808,7 @@ static const struct proto_ops kcm_seqpacket_ops = {
 	.sendmsg =	kcm_sendmsg,
 	.recvmsg =	kcm_recvmsg,
 	.mmap =		sock_no_mmap,
+	.splice_eof =	kcm_splice_eof,
 	.sendpage =	kcm_sendpage,
 	.splice_read =	kcm_splice_read,
 };


