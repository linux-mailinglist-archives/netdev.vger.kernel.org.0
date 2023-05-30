Return-Path: <netdev+bounces-6418-lists+netdev=lfdr.de@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from ny.mirrors.kernel.org (ny.mirrors.kernel.org [IPv6:2604:1380:45d1:ec00::1])
	by mail.lfdr.de (Postfix) with ESMTPS id A7D247163AE
	for <lists+netdev@lfdr.de>; Tue, 30 May 2023 16:19:49 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ny.mirrors.kernel.org (Postfix) with ESMTPS id 4941D1C20C18
	for <lists+netdev@lfdr.de>; Tue, 30 May 2023 14:19:46 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 3C48523C92;
	Tue, 30 May 2023 14:18:11 +0000 (UTC)
X-Original-To: netdev@vger.kernel.org
Received: from lindbergh.monkeyblade.net (lindbergh.monkeyblade.net [23.128.96.19])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 2DDF121072
	for <netdev@vger.kernel.org>; Tue, 30 May 2023 14:18:11 +0000 (UTC)
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.133.124])
	by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 1155D10E
	for <netdev@vger.kernel.org>; Tue, 30 May 2023 07:17:47 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1685456267;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=jPGukvQXP4Tai7PUqcbnIswr++Y11hB7rT1QDpn/afo=;
	b=UeXjrzxV66GybCvi9vJKcGG/yuMyyYhqQ5jkQXiJp7pZz9lK3EwVaRFf7bCVOp0nc2IS31
	LZxCAeLXXvHT+LBG8mlBfb0cbiwyPmaa6Th9kF/ClHw+ZJoq1Q9Q7gzKE37HQHc4dBG7C6
	c4PNXn0LVG43m4t7zo5dFK3yU7ioDsI=
Received: from mimecast-mx02.redhat.com (mx3-rdu2.redhat.com
 [66.187.233.73]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 us-mta-422-RSYDLXzDO6mBKtqBJIWETQ-1; Tue, 30 May 2023 10:17:43 -0400
X-MC-Unique: RSYDLXzDO6mBKtqBJIWETQ-1
Received: from smtp.corp.redhat.com (int-mx08.intmail.prod.int.rdu2.redhat.com [10.11.54.8])
	(using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by mimecast-mx02.redhat.com (Postfix) with ESMTPS id 4404B280BC52;
	Tue, 30 May 2023 14:17:31 +0000 (UTC)
Received: from warthog.procyon.org.uk (unknown [10.42.28.182])
	by smtp.corp.redhat.com (Postfix) with ESMTP id 10D55C154D3;
	Tue, 30 May 2023 14:17:28 +0000 (UTC)
From: David Howells <dhowells@redhat.com>
To: netdev@vger.kernel.org
Cc: David Howells <dhowells@redhat.com>,
	Herbert Xu <herbert@gondor.apana.org.au>,
	"David S. Miller" <davem@davemloft.net>,
	Eric Dumazet <edumazet@google.com>,
	Jakub Kicinski <kuba@kernel.org>,
	Paolo Abeni <pabeni@redhat.com>,
	Willem de Bruijn <willemdebruijn.kernel@gmail.com>,
	David Ahern <dsahern@kernel.org>,
	Matthew Wilcox <willy@infradead.org>,
	Jens Axboe <axboe@kernel.dk>,
	linux-crypto@vger.kernel.org,
	linux-mm@kvack.org,
	linux-kernel@vger.kernel.org
Subject: [PATCH net-next v2 05/10] crypto: af_alg: Pin pages rather than ref'ing if appropriate
Date: Tue, 30 May 2023 15:16:29 +0100
Message-ID: <20230530141635.136968-6-dhowells@redhat.com>
In-Reply-To: <20230530141635.136968-1-dhowells@redhat.com>
References: <20230530141635.136968-1-dhowells@redhat.com>
Precedence: bulk
X-Mailing-List: netdev@vger.kernel.org
List-Id: <netdev.vger.kernel.org>
List-Subscribe: <mailto:netdev+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:netdev+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Scanned-By: MIMEDefang 3.1 on 10.11.54.8
X-Spam-Status: No, score=-2.3 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
	DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_NONE,
	SPF_HELO_NONE,SPF_NONE,T_SCC_BODY_TEXT_LINE autolearn=ham
	autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
	lindbergh.monkeyblade.net

Convert AF_ALG to use iov_iter_extract_pages() instead of
iov_iter_get_pages().  This will pin pages or leave them unaltered rather
than getting a ref on them as appropriate to the iterator.

The pages need to be pinned for DIO-read rather than having refs taken on
them to prevent VM copy-on-write from malfunctioning during a concurrent
fork() (the result of the I/O would otherwise end up only visible to the
child process and not the parent).

Signed-off-by: David Howells <dhowells@redhat.com>
cc: Herbert Xu <herbert@gondor.apana.org.au>
cc: "David S. Miller" <davem@davemloft.net>
cc: Eric Dumazet <edumazet@google.com>
cc: Jakub Kicinski <kuba@kernel.org>
cc: Paolo Abeni <pabeni@redhat.com>
cc: Jens Axboe <axboe@kernel.dk>
cc: Matthew Wilcox <willy@infradead.org>
cc: linux-crypto@vger.kernel.org
cc: netdev@vger.kernel.org
---
 crypto/af_alg.c         | 10 +++++++---
 include/crypto/if_alg.h |  1 +
 2 files changed, 8 insertions(+), 3 deletions(-)

diff --git a/crypto/af_alg.c b/crypto/af_alg.c
index 5f7252a5b7b4..7caff10df643 100644
--- a/crypto/af_alg.c
+++ b/crypto/af_alg.c
@@ -533,14 +533,17 @@ static const struct net_proto_family alg_family = {
 
 int af_alg_make_sg(struct af_alg_sgl *sgl, struct iov_iter *iter, int len)
 {
+	struct page **pages = sgl->pages;
 	size_t off;
 	ssize_t n;
 	int npages, i;
 
-	n = iov_iter_get_pages2(iter, sgl->pages, len, ALG_MAX_PAGES, &off);
+	n = iov_iter_extract_pages(iter, &pages, len, ALG_MAX_PAGES, 0, &off);
 	if (n < 0)
 		return n;
 
+	sgl->need_unpin = iov_iter_extract_will_pin(iter);
+
 	npages = DIV_ROUND_UP(off + n, PAGE_SIZE);
 	if (WARN_ON(npages == 0))
 		return -EINVAL;
@@ -573,8 +576,9 @@ void af_alg_free_sg(struct af_alg_sgl *sgl)
 {
 	int i;
 
-	for (i = 0; i < sgl->npages; i++)
-		put_page(sgl->pages[i]);
+	if (sgl->need_unpin)
+		for (i = 0; i < sgl->npages; i++)
+			unpin_user_page(sgl->pages[i]);
 }
 EXPORT_SYMBOL_GPL(af_alg_free_sg);
 
diff --git a/include/crypto/if_alg.h b/include/crypto/if_alg.h
index 7e76623f9ec3..46494b33f5bc 100644
--- a/include/crypto/if_alg.h
+++ b/include/crypto/if_alg.h
@@ -59,6 +59,7 @@ struct af_alg_sgl {
 	struct scatterlist sg[ALG_MAX_PAGES + 1];
 	struct page *pages[ALG_MAX_PAGES];
 	unsigned int npages;
+	bool need_unpin;
 };
 
 /* TX SGL entry */


