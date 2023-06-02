Return-Path: <netdev+bounces-7448-lists+netdev=lfdr.de@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [IPv6:2604:1380:45e3:2400::1])
	by mail.lfdr.de (Postfix) with ESMTPS id 8CEB672056F
	for <lists+netdev@lfdr.de>; Fri,  2 Jun 2023 17:08:46 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id 476FE2819F4
	for <lists+netdev@lfdr.de>; Fri,  2 Jun 2023 15:08:45 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id B7F5419E43;
	Fri,  2 Jun 2023 15:08:19 +0000 (UTC)
X-Original-To: netdev@vger.kernel.org
Received: from lindbergh.monkeyblade.net (lindbergh.monkeyblade.net [23.128.96.19])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id ABEFC258F
	for <netdev@vger.kernel.org>; Fri,  2 Jun 2023 15:08:19 +0000 (UTC)
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.129.124])
	by lindbergh.monkeyblade.net (Postfix) with ESMTPS id C548AE53
	for <netdev@vger.kernel.org>; Fri,  2 Jun 2023 08:08:13 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1685718493;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=GIUHoDHkYJ6R7Kj3TX2onke+6WDgXd+OHlld+dEFkxk=;
	b=CdLxbLWEEPieSZGkW/f44IAO3xhXW3Lmk90+SigQ8ke2/qfcNEIbQ3O1c/OLoUULEgIvdB
	TDCEorSiBxNlV6EwTudxDIsIFZE5TSHM1TPMPuTqmxVZlOc2sIybCZCbf0xlXo4kYRMDqi
	X8+Z+x7QQoWQONr4k1g+SJcZ2SOZu8E=
Received: from mimecast-mx02.redhat.com (mx3-rdu2.redhat.com
 [66.187.233.73]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 us-mta-575-BOuQHjwKMQyEta6FCH7Pyw-1; Fri, 02 Jun 2023 11:08:11 -0400
X-MC-Unique: BOuQHjwKMQyEta6FCH7Pyw-1
Received: from smtp.corp.redhat.com (int-mx09.intmail.prod.int.rdu2.redhat.com [10.11.54.9])
	(using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by mimecast-mx02.redhat.com (Postfix) with ESMTPS id CAA3D3C0BE44;
	Fri,  2 Jun 2023 15:08:10 +0000 (UTC)
Received: from warthog.procyon.org.uk (unknown [10.42.28.182])
	by smtp.corp.redhat.com (Postfix) with ESMTP id 8D922492B00;
	Fri,  2 Jun 2023 15:08:07 +0000 (UTC)
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
Subject: [PATCH net-next v3 02/11] tls: Allow MSG_SPLICE_PAGES but treat it as normal sendmsg
Date: Fri,  2 Jun 2023 16:07:43 +0100
Message-ID: <20230602150752.1306532-3-dhowells@redhat.com>
In-Reply-To: <20230602150752.1306532-1-dhowells@redhat.com>
References: <20230602150752.1306532-1-dhowells@redhat.com>
Precedence: bulk
X-Mailing-List: netdev@vger.kernel.org
List-Id: <netdev.vger.kernel.org>
List-Subscribe: <mailto:netdev+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:netdev+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Scanned-By: MIMEDefang 3.1 on 10.11.54.9
X-Spam-Status: No, score=-2.3 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
	DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_NONE,
	SPF_HELO_NONE,SPF_NONE,T_SCC_BODY_TEXT_LINE autolearn=ham
	autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
	lindbergh.monkeyblade.net

Allow MSG_SPLICE_PAGES to be specified to sendmsg() but treat it as normal
sendmsg for now.  This means the data will just be copied until
MSG_SPLICE_PAGES is handled.

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
 net/tls/tls_device.c | 3 ++-
 net/tls/tls_sw.c     | 2 +-
 2 files changed, 3 insertions(+), 2 deletions(-)

diff --git a/net/tls/tls_device.c b/net/tls/tls_device.c
index a959572a816f..9ef766e41c7a 100644
--- a/net/tls/tls_device.c
+++ b/net/tls/tls_device.c
@@ -447,7 +447,8 @@ static int tls_push_data(struct sock *sk,
 	long timeo;
 
 	if (flags &
-	    ~(MSG_MORE | MSG_DONTWAIT | MSG_NOSIGNAL | MSG_SENDPAGE_NOTLAST))
+	    ~(MSG_MORE | MSG_DONTWAIT | MSG_NOSIGNAL | MSG_SENDPAGE_NOTLAST |
+	      MSG_SPLICE_PAGES))
 		return -EOPNOTSUPP;
 
 	if (unlikely(sk->sk_err))
diff --git a/net/tls/tls_sw.c b/net/tls/tls_sw.c
index 6e6a7c37d685..cac1adc968e8 100644
--- a/net/tls/tls_sw.c
+++ b/net/tls/tls_sw.c
@@ -953,7 +953,7 @@ int tls_sw_sendmsg(struct sock *sk, struct msghdr *msg, size_t size)
 	int pending;
 
 	if (msg->msg_flags & ~(MSG_MORE | MSG_DONTWAIT | MSG_NOSIGNAL |
-			       MSG_CMSG_COMPAT))
+			       MSG_CMSG_COMPAT | MSG_SPLICE_PAGES))
 		return -EOPNOTSUPP;
 
 	ret = mutex_lock_interruptible(&tls_ctx->tx_lock);


