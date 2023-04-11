Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 30C256DE096
	for <lists+netdev@lfdr.de>; Tue, 11 Apr 2023 18:11:23 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230325AbjDKQLT (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 11 Apr 2023 12:11:19 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:39308 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229924AbjDKQKu (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 11 Apr 2023 12:10:50 -0400
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.129.124])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id A0E864206
        for <netdev@vger.kernel.org>; Tue, 11 Apr 2023 09:09:35 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1681229374;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=rzqtbLu7PzckfDCHcN9H9EFIWHgmlYZvGgMWnBPjkms=;
        b=T2LR0Dt3KPCmW6bkQKzykidciao4FuHmtpCHGXQnBF2rdKYq8Cga5jtlonqESrewaUmz8t
        ckAcuXWJKsCoWRPffs4NMWN1m2/fKhPtKwfbyuDdoXXDk4uvj1RCi+QSA89D+QV+L8HOAI
        4Vn8IF36fAEOfF7xRoaN1uAD1HmeStY=
Received: from mimecast-mx02.redhat.com (mimecast-mx02.redhat.com
 [66.187.233.88]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 us-mta-361-5X01tIs_NgyU79LDUXo_dg-1; Tue, 11 Apr 2023 12:09:31 -0400
X-MC-Unique: 5X01tIs_NgyU79LDUXo_dg-1
Received: from smtp.corp.redhat.com (int-mx01.intmail.prod.int.rdu2.redhat.com [10.11.54.1])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mimecast-mx02.redhat.com (Postfix) with ESMTPS id 168421010424;
        Tue, 11 Apr 2023 16:09:29 +0000 (UTC)
Received: from warthog.procyon.org.uk (unknown [10.33.36.18])
        by smtp.corp.redhat.com (Postfix) with ESMTP id EE86140C83A9;
        Tue, 11 Apr 2023 16:09:26 +0000 (UTC)
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
Subject: [PATCH net-next v6 06/18] net: Add a function to splice pages into an skbuff for MSG_SPLICE_PAGES
Date:   Tue, 11 Apr 2023 17:08:50 +0100
Message-Id: <20230411160902.4134381-7-dhowells@redhat.com>
In-Reply-To: <20230411160902.4134381-1-dhowells@redhat.com>
References: <20230411160902.4134381-1-dhowells@redhat.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Scanned-By: MIMEDefang 3.1 on 10.11.54.1
X-Spam-Status: No, score=-0.2 required=5.0 tests=DKIMWL_WL_HIGH,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_NONE,
        RCVD_IN_MSPIKE_H2,SPF_HELO_NONE,SPF_NONE autolearn=unavailable
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Add a function to handle MSG_SPLICE_PAGES being passed internally to
sendmsg().  Pages are spliced into the given socket buffer if possible and
copied in if not (ie. they're slab pages or have a zero refcount).

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
 include/linux/skbuff.h |   3 ++
 net/core/skbuff.c      | 110 +++++++++++++++++++++++++++++++++++++++++
 2 files changed, 113 insertions(+)

diff --git a/include/linux/skbuff.h b/include/linux/skbuff.h
index 6e508274d2a5..add43417b798 100644
--- a/include/linux/skbuff.h
+++ b/include/linux/skbuff.h
@@ -5070,5 +5070,8 @@ static inline void skb_mark_for_recycle(struct sk_buff *skb)
 }
 #endif
 
+ssize_t skb_splice_from_iter(struct sk_buff *skb, struct iov_iter *iter,
+			     ssize_t maxsize, gfp_t gfp);
+
 #endif	/* __KERNEL__ */
 #endif	/* _LINUX_SKBUFF_H */
diff --git a/net/core/skbuff.c b/net/core/skbuff.c
index d96175f58ca4..c90fc48a63a5 100644
--- a/net/core/skbuff.c
+++ b/net/core/skbuff.c
@@ -6838,3 +6838,113 @@ nodefer:	__kfree_skb(skb);
 	if (unlikely(kick) && !cmpxchg(&sd->defer_ipi_scheduled, 0, 1))
 		smp_call_function_single_async(cpu, &sd->defer_csd);
 }
+
+static void skb_splice_csum_page(struct sk_buff *skb, struct page *page,
+				 size_t offset, size_t len)
+{
+	const char *kaddr;
+	__wsum csum;
+
+	kaddr = kmap_local_page(page);
+	csum = csum_partial(kaddr + offset, len, 0);
+	kunmap_local(kaddr);
+	skb->csum = csum_block_add(skb->csum, csum, skb->len);
+}
+
+/**
+ * skb_splice_from_iter - Splice (or copy) pages to skbuff
+ * @skb: The buffer to add pages to
+ * @iter: Iterator representing the pages to be added
+ * @maxsize: Maximum amount of pages to be added
+ * @gfp: Allocation flags
+ *
+ * This is a common helper function for supporting MSG_SPLICE_PAGES.  It
+ * extracts pages from an iterator and adds them to the socket buffer if
+ * possible, copying them to fragments if not possible (such as if they're slab
+ * pages).
+ *
+ * Returns the amount of data spliced/copied or -EMSGSIZE if there's
+ * insufficient space in the buffer to transfer anything.
+ */
+ssize_t skb_splice_from_iter(struct sk_buff *skb, struct iov_iter *iter,
+			     ssize_t maxsize, gfp_t gfp)
+{
+	struct page *pages[8], **ppages = pages;
+	unsigned int i;
+	ssize_t spliced = 0, ret = 0;
+	size_t frag_limit = READ_ONCE(sysctl_max_skb_frags);
+
+	while (iter->count > 0) {
+		ssize_t space, nr;
+		size_t off, len;
+
+		ret = -EMSGSIZE;
+		space = frag_limit - skb_shinfo(skb)->nr_frags;
+		if (space < 0)
+			break;
+
+		/* We might be able to coalesce without increasing nr_frags */
+		nr = clamp_t(size_t, space, 1, ARRAY_SIZE(pages));
+
+		len = iov_iter_extract_pages(iter, &ppages, maxsize, nr, 0, &off);
+		if (len <= 0) {
+			ret = len ?: -EIO;
+			break;
+		}
+
+		if (space == 0 &&
+		    !skb_can_coalesce(skb, skb_shinfo(skb)->nr_frags,
+				      pages[0], off)) {
+			iov_iter_revert(iter, len);
+			break;
+		}
+
+		i = 0;
+		do {
+			struct page *page = pages[i++];
+			size_t part = min_t(size_t, PAGE_SIZE - off, len);
+			bool put = false;
+
+			if (!sendpage_ok(page)) {
+				const void *p = kmap_local_page(page);
+				void *q;
+
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
+			}
+
+			ret = skb_append_pagefrags(skb, page, off, part,
+						   frag_limit);
+			if (put)
+				put_page(page);
+			if (ret < 0) {
+				iov_iter_revert(iter, len);
+				goto out;
+			}
+
+			if (skb->ip_summed == CHECKSUM_NONE)
+				skb_splice_csum_page(skb, page, off, part);
+
+			off = 0;
+			spliced += part;
+			maxsize -= part;
+			len -= part;
+		} while (len > 0);
+
+		if (maxsize <= 0)
+			break;
+	}
+
+out:
+	skb_len_add(skb, spliced);
+	return spliced ?: ret;
+}

