Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 955AE6DE08B
	for <lists+netdev@lfdr.de>; Tue, 11 Apr 2023 18:10:57 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230017AbjDKQKt (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 11 Apr 2023 12:10:49 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:39690 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229924AbjDKQKr (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 11 Apr 2023 12:10:47 -0400
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.129.124])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 971CB272D
        for <netdev@vger.kernel.org>; Tue, 11 Apr 2023 09:09:30 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1681229369;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=yN2nDE+ENFPKsoCAxX3Et3Pc/YScpeBgJ5SXmU8JiBg=;
        b=BHrGCYwALLBx9zHY6/tXVIPMdNN34G6BBbTPuhMLWlsd+0K8q2mQQQT6xPlk+SkuPirTFN
        58HUqoCEmKLuHVF058qogpvJd5H6nMeOGjOF/kQOMB8kSwgCxG59BlJFZLmi6jY/rJRGxP
        ysIvbl+UuBlG6sZ/I/ZvvNWoifZF2us=
Received: from mimecast-mx02.redhat.com (mimecast-mx02.redhat.com
 [66.187.233.88]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 us-mta-673-JgBL6_p-OsWYijzjp0KjTQ-1; Tue, 11 Apr 2023 12:09:27 -0400
X-MC-Unique: JgBL6_p-OsWYijzjp0KjTQ-1
Received: from smtp.corp.redhat.com (int-mx02.intmail.prod.int.rdu2.redhat.com [10.11.54.2])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mimecast-mx02.redhat.com (Postfix) with ESMTPS id 3E43A185A7AC;
        Tue, 11 Apr 2023 16:09:26 +0000 (UTC)
Received: from warthog.procyon.org.uk (unknown [10.33.36.18])
        by smtp.corp.redhat.com (Postfix) with ESMTP id 2233A40BC797;
        Tue, 11 Apr 2023 16:09:24 +0000 (UTC)
From:   David Howells <dhowells@redhat.com>
To:     netdev@vger.kernel.org
Cc:     David Howells <dhowells@redhat.com>,
        "David S. Miller" <davem@davemloft.net>,
        Eric Dumazet <edumazet@google.com>,
        Jakub Kicinski <kuba@kernel.org>,
        Paolo Abeni <pabeni@redhat.com>,
        Willem de Bruijn <willemdebruijn.kernel@gmail.com>,
        David Ahern <dsahern@kernel.org>,
        Matthew Wilcox <willy@infradead.org>,
        Al Viro <viro@zeniv.linux.org.uk>,
        Christoph Hellwig <hch@infradead.org>,
        Jens Axboe <axboe@kernel.dk>, Jeff Layton <jlayton@kernel.org>,
        Christian Brauner <brauner@kernel.org>,
        Chuck Lever III <chuck.lever@oracle.com>,
        Linus Torvalds <torvalds@linux-foundation.org>,
        linux-fsdevel@vger.kernel.org, linux-kernel@vger.kernel.org,
        linux-mm@kvack.org
Subject: [PATCH net-next v6 05/18] net: Pass max frags into skb_append_pagefrags()
Date:   Tue, 11 Apr 2023 17:08:49 +0100
Message-Id: <20230411160902.4134381-6-dhowells@redhat.com>
In-Reply-To: <20230411160902.4134381-1-dhowells@redhat.com>
References: <20230411160902.4134381-1-dhowells@redhat.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Scanned-By: MIMEDefang 3.1 on 10.11.54.2
X-Spam-Status: No, score=-0.2 required=5.0 tests=DKIMWL_WL_HIGH,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_NONE,
        RCVD_IN_MSPIKE_H2,SPF_HELO_NONE,SPF_NONE autolearn=unavailable
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

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
index 82511b2f61ea..6e508274d2a5 100644
--- a/include/linux/skbuff.h
+++ b/include/linux/skbuff.h
@@ -1364,7 +1364,7 @@ static inline int skb_pad(struct sk_buff *skb, int pad)
 #define dev_kfree_skb(a)	consume_skb(a)
 
 int skb_append_pagefrags(struct sk_buff *skb, struct page *page,
-			 int offset, size_t size);
+			 int offset, size_t size, size_t max_frags);
 
 struct skb_seq_state {
 	__u32		lower_offset;
diff --git a/net/core/skbuff.c b/net/core/skbuff.c
index 3d05ed64b606..d96175f58ca4 100644
--- a/net/core/skbuff.c
+++ b/net/core/skbuff.c
@@ -4132,13 +4132,13 @@ unsigned int skb_find_text(struct sk_buff *skb, unsigned int from,
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
index 22a90a9392eb..bd002222cf2d 100644
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
index fb31e8a4409e..ea45dcc80232 100644
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

