Return-Path: <netdev+bounces-2574-lists+netdev=lfdr.de@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [139.178.88.99])
	by mail.lfdr.de (Postfix) with ESMTPS id B62BF7028AF
	for <lists+netdev@lfdr.de>; Mon, 15 May 2023 11:34:41 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id 712912811A4
	for <lists+netdev@lfdr.de>; Mon, 15 May 2023 09:34:40 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id A621AC15A;
	Mon, 15 May 2023 09:34:08 +0000 (UTC)
X-Original-To: netdev@vger.kernel.org
Received: from lindbergh.monkeyblade.net (lindbergh.monkeyblade.net [23.128.96.19])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 9AC6BC136
	for <netdev@vger.kernel.org>; Mon, 15 May 2023 09:34:08 +0000 (UTC)
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.129.124])
	by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 501961BD
	for <netdev@vger.kernel.org>; Mon, 15 May 2023 02:34:06 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1684143245;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=Oms7mbQShTpY01zvjwYgDwHWlSZDYU/BDFTf+CWwguM=;
	b=Svz8Nusvc6Jz+VL+mVDymWLB96HbnijpKbfMzufuHUGfttbgkVuWSEmqyFaQKsW3sLwysX
	JY2Scx+qsOFuCTUML/aCDGGa064/tv7NNK/4jN8lNUg6xA+cDYGNd4dr90lXTe5kaDdohD
	62kWDLykbE0AW8kpcQD093KFRbV24Ao=
Received: from mimecast-mx02.redhat.com (mx3-rdu2.redhat.com
 [66.187.233.73]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 us-mta-445-AkM32TIKNTGBQP3iQjlccw-1; Mon, 15 May 2023 05:34:00 -0400
X-MC-Unique: AkM32TIKNTGBQP3iQjlccw-1
Received: from smtp.corp.redhat.com (int-mx01.intmail.prod.int.rdu2.redhat.com [10.11.54.1])
	(using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by mimecast-mx02.redhat.com (Postfix) with ESMTPS id B58403C0CF00;
	Mon, 15 May 2023 09:33:59 +0000 (UTC)
Received: from warthog.procyon.org.uk (unknown [10.42.28.221])
	by smtp.corp.redhat.com (Postfix) with ESMTP id 08F5040C206F;
	Mon, 15 May 2023 09:33:56 +0000 (UTC)
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
	Al Viro <viro@zeniv.linux.org.uk>,
	Christoph Hellwig <hch@infradead.org>,
	Jens Axboe <axboe@kernel.dk>,
	Jeff Layton <jlayton@kernel.org>,
	Christian Brauner <brauner@kernel.org>,
	Chuck Lever III <chuck.lever@oracle.com>,
	Linus Torvalds <torvalds@linux-foundation.org>,
	linux-fsdevel@vger.kernel.org,
	linux-kernel@vger.kernel.org,
	linux-mm@kvack.org
Subject: [PATCH net-next v7 02/16] net: Pass max frags into skb_append_pagefrags()
Date: Mon, 15 May 2023 10:33:31 +0100
Message-Id: <20230515093345.396978-3-dhowells@redhat.com>
In-Reply-To: <20230515093345.396978-1-dhowells@redhat.com>
References: <20230515093345.396978-1-dhowells@redhat.com>
Precedence: bulk
X-Mailing-List: netdev@vger.kernel.org
List-Id: <netdev.vger.kernel.org>
List-Subscribe: <mailto:netdev+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:netdev+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Scanned-By: MIMEDefang 3.1 on 10.11.54.1
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
	DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_NONE,
	SPF_HELO_NONE,SPF_NONE,T_SCC_BODY_TEXT_LINE autolearn=ham
	autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
	lindbergh.monkeyblade.net

Pass the maximum number of fragments into skb_append_pagefrags() rather
than using MAX_SKB_FRAGS so that it can be used from code that wants to
specify sysctl_max_skb_frags.

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
 include/linux/skbuff.h | 2 +-
 net/core/skbuff.c      | 4 ++--
 net/ipv4/ip_output.c   | 3 ++-
 net/unix/af_unix.c     | 2 +-
 4 files changed, 6 insertions(+), 5 deletions(-)

diff --git a/include/linux/skbuff.h b/include/linux/skbuff.h
index 00e8c435fa1a..4c0ad48e38ca 100644
--- a/include/linux/skbuff.h
+++ b/include/linux/skbuff.h
@@ -1383,7 +1383,7 @@ static inline int skb_pad(struct sk_buff *skb, int pad)
 #define dev_kfree_skb(a)	consume_skb(a)
 
 int skb_append_pagefrags(struct sk_buff *skb, struct page *page,
-			 int offset, size_t size);
+			 int offset, size_t size, size_t max_frags);
 
 struct skb_seq_state {
 	__u32		lower_offset;
diff --git a/net/core/skbuff.c b/net/core/skbuff.c
index 6724a84ebb09..7f53dcb26ad3 100644
--- a/net/core/skbuff.c
+++ b/net/core/skbuff.c
@@ -4188,13 +4188,13 @@ unsigned int skb_find_text(struct sk_buff *skb, unsigned int from,
 EXPORT_SYMBOL(skb_find_text);
 
 int skb_append_pagefrags(struct sk_buff *skb, struct page *page,
-			 int offset, size_t size)
+			 int offset, size_t size, size_t max_frags)
 {
 	int i = skb_shinfo(skb)->nr_frags;
 
 	if (skb_can_coalesce(skb, i, page, offset)) {
 		skb_frag_size_add(&skb_shinfo(skb)->frags[i - 1], size);
-	} else if (i < MAX_SKB_FRAGS) {
+	} else if (i < max_frags) {
 		skb_zcopy_downgrade_managed(skb);
 		get_page(page);
 		skb_fill_page_desc_noacc(skb, i, page, offset, size);
diff --git a/net/ipv4/ip_output.c b/net/ipv4/ip_output.c
index 61892268e8a6..52fc840898d8 100644
--- a/net/ipv4/ip_output.c
+++ b/net/ipv4/ip_output.c
@@ -1450,7 +1450,8 @@ ssize_t	ip_append_page(struct sock *sk, struct flowi4 *fl4, struct page *page,
 		if (len > size)
 			len = size;
 
-		if (skb_append_pagefrags(skb, page, offset, len)) {
+		if (skb_append_pagefrags(skb, page, offset, len,
+					 MAX_SKB_FRAGS)) {
 			err = -EMSGSIZE;
 			goto error;
 		}
diff --git a/net/unix/af_unix.c b/net/unix/af_unix.c
index cc695c9f09ec..dd55506b4632 100644
--- a/net/unix/af_unix.c
+++ b/net/unix/af_unix.c
@@ -2349,7 +2349,7 @@ static ssize_t unix_stream_sendpage(struct socket *socket, struct page *page,
 		newskb = NULL;
 	}
 
-	if (skb_append_pagefrags(skb, page, offset, size)) {
+	if (skb_append_pagefrags(skb, page, offset, size, MAX_SKB_FRAGS)) {
 		tail = skb;
 		goto alloc_skb;
 	}


