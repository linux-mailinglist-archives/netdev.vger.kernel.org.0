Return-Path: <netdev+bounces-5097-lists+netdev=lfdr.de@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from ny.mirrors.kernel.org (ny.mirrors.kernel.org [147.75.199.223])
	by mail.lfdr.de (Postfix) with ESMTPS id 2ADF570FA72
	for <lists+netdev@lfdr.de>; Wed, 24 May 2023 17:37:01 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ny.mirrors.kernel.org (Postfix) with ESMTPS id E4C671C20E34
	for <lists+netdev@lfdr.de>; Wed, 24 May 2023 15:36:57 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id CBE3219E54;
	Wed, 24 May 2023 15:34:36 +0000 (UTC)
X-Original-To: netdev@vger.kernel.org
Received: from lindbergh.monkeyblade.net (lindbergh.monkeyblade.net [23.128.96.19])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id C0D2619E4A
	for <netdev@vger.kernel.org>; Wed, 24 May 2023 15:34:36 +0000 (UTC)
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.133.124])
	by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 6B1F0E45
	for <netdev@vger.kernel.org>; Wed, 24 May 2023 08:34:11 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1684942431;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=PZf0byHPp2E2QKGUTDTD+TlMjPhCnr7dpojTO1v28qY=;
	b=jMe27C3Np/I2gzysISYtsidfsABFS/Oe3J7cD71OzrFBB8Co8CRk8oyj0RY23WHT068uoR
	Sj5jb43h6I2GWSdhE0c3vghlAqfiTV3ufzq/zzxifopcKUYe0zT0aWpj+mtkXIeFNslhJR
	ASLAuPqKfQoPvfRAX11SEcCqZg24pIU=
Received: from mimecast-mx02.redhat.com (mimecast-mx02.redhat.com
 [66.187.233.88]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 us-mta-26-wF7-Cb2KPtKxfSJZIAw0Dg-1; Wed, 24 May 2023 11:33:46 -0400
X-MC-Unique: wF7-Cb2KPtKxfSJZIAw0Dg-1
Received: from smtp.corp.redhat.com (int-mx02.intmail.prod.int.rdu2.redhat.com [10.11.54.2])
	(using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by mimecast-mx02.redhat.com (Postfix) with ESMTPS id E46EB811E85;
	Wed, 24 May 2023 15:33:45 +0000 (UTC)
Received: from warthog.procyon.org.uk (unknown [10.39.192.68])
	by smtp.corp.redhat.com (Postfix) with ESMTP id 4289240C6EC4;
	Wed, 24 May 2023 15:33:44 +0000 (UTC)
From: David Howells <dhowells@redhat.com>
To: netdev@vger.kernel.org
Cc: David Howells <dhowells@redhat.com>,
	"David S. Miller" <davem@davemloft.net>,
	Eric Dumazet <edumazet@google.com>,
	Jakub Kicinski <kuba@kernel.org>,
	Paolo Abeni <pabeni@redhat.com>,
	Willem de Bruijn <willemdebruijn.kernel@gmail.com>,
	David Ahern <dsahern@kernel.org>,
	Matthew Wilcox <willy@infradead.org>,
	Jens Axboe <axboe@kernel.dk>,
	linux-mm@kvack.org,
	linux-kernel@vger.kernel.org
Subject: [PATCH net-next 08/12] net: Copy slab data for sendmsg(MSG_SPLICE_PAGES)
Date: Wed, 24 May 2023 16:33:07 +0100
Message-Id: <20230524153311.3625329-9-dhowells@redhat.com>
In-Reply-To: <20230524153311.3625329-1-dhowells@redhat.com>
References: <20230524153311.3625329-1-dhowells@redhat.com>
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
	RCVD_IN_MSPIKE_H2,SPF_HELO_NONE,SPF_NONE,T_SCC_BODY_TEXT_LINE
	autolearn=unavailable autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
	lindbergh.monkeyblade.net

If sendmsg() is passed MSG_SPLICE_PAGES and is given a buffer that contains
some data that's resident in the slab, copy/coalesce it rather than
returning EIO.

Signed-off-by: David Howells <dhowells@redhat.com>
cc: Eric Dumazet <edumazet@google.com>
cc: "David S. Miller" <davem@davemloft.net>
cc: David Ahern <dsahern@kernel.org>
cc: Jakub Kicinski <kuba@kernel.org>
cc: Paolo Abeni <pabeni@redhat.com>
cc: Jens Axboe <axboe@kernel.dk>
cc: Matthew Wilcox <willy@infradead.org>
cc: netdev@vger.kernel.org
---
 include/linux/skbuff.h |  3 +++
 net/core/skbuff.c      | 33 ++++++++++++++++++++++++++++++---
 2 files changed, 33 insertions(+), 3 deletions(-)

diff --git a/include/linux/skbuff.h b/include/linux/skbuff.h
index e11a765fe7fa..11d98990f5f1 100644
--- a/include/linux/skbuff.h
+++ b/include/linux/skbuff.h
@@ -5084,6 +5084,9 @@ static inline void skb_mark_for_recycle(struct sk_buff *skb)
 #endif
 }
 
+ssize_t skb_splice_from_iter(struct sk_buff *skb, struct iov_iter *iter,
+			     ssize_t maxsize, gfp_t gfp);
+
 ssize_t skb_splice_from_iter(struct sk_buff *skb, struct iov_iter *iter,
 			     ssize_t maxsize, gfp_t gfp);
 
diff --git a/net/core/skbuff.c b/net/core/skbuff.c
index c2840b0dcad9..a16499b9942b 100644
--- a/net/core/skbuff.c
+++ b/net/core/skbuff.c
@@ -6927,17 +6927,44 @@ ssize_t skb_splice_from_iter(struct sk_buff *skb, struct iov_iter *iter,
 			break;
 		}
 
+		if (space == 0 &&
+		    !skb_can_coalesce(skb, skb_shinfo(skb)->nr_frags,
+				      pages[0], off)) {
+			iov_iter_revert(iter, len);
+			break;
+		}
+
 		i = 0;
 		do {
 			struct page *page = pages[i++];
 			size_t part = min_t(size_t, PAGE_SIZE - off, len);
-
-			ret = -EIO;
-			if (WARN_ON_ONCE(!sendpage_ok(page)))
+			bool put = false;
+
+			if (PageSlab(page)) {
+				const void *p;
+				void *q;
+
+				p = kmap_local_page(page);
+				q = page_frag_memdup(NULL, p + off, part, gfp,
+						     ULONG_MAX);
+				kunmap_local(p);
+				if (!q) {
+					iov_iter_revert(iter, len);
+					ret = -ENOMEM;
+					goto out;
+				}
+				page = virt_to_page(q);
+				off = offset_in_page(q);
+				put = true;
+			} else if (WARN_ON_ONCE(!sendpage_ok(page))) {
+				ret = -EIO;
 				goto out;
+			}
 
 			ret = skb_append_pagefrags(skb, page, off, part,
 						   frag_limit);
+			if (put)
+				put_page(page);
 			if (ret < 0) {
 				iov_iter_revert(iter, len);
 				goto out;


