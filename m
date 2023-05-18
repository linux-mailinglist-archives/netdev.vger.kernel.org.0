Return-Path: <netdev+bounces-3547-lists+netdev=lfdr.de@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [139.178.88.99])
	by mail.lfdr.de (Postfix) with ESMTPS id 39C60707D65
	for <lists+netdev@lfdr.de>; Thu, 18 May 2023 11:56:47 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id EA22F28184C
	for <lists+netdev@lfdr.de>; Thu, 18 May 2023 09:56:45 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id C1AE511CAB;
	Thu, 18 May 2023 09:56:43 +0000 (UTC)
X-Original-To: netdev@vger.kernel.org
Received: from lindbergh.monkeyblade.net (lindbergh.monkeyblade.net [23.128.96.19])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id AFF7C11CA7
	for <netdev@vger.kernel.org>; Thu, 18 May 2023 09:56:43 +0000 (UTC)
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.133.124])
	by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 546B810DC
	for <netdev@vger.kernel.org>; Thu, 18 May 2023 02:56:42 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1684403801;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=dazR50SKXuYIFVWThl0nrv2fyFSamN4MkmMLPefBMF0=;
	b=RbUL0olDUFx7YYSClC6lNrqRlxjzKBmyCh9Y6ObV71uP1ykrNJbcBbf2JArItGFiJBYyXd
	FEM/xYcjrZhfTxUZq8HKSA2droHO0H1ys1Lnby+K4VKZPu1SITPq3TRzkIy2bZrdDNHTbb
	5wj7xF4ro1fQHnac4F3h0SOlwEvEkzU=
Received: from mimecast-mx02.redhat.com (mimecast-mx02.redhat.com
 [66.187.233.88]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 us-mta-352-sNI4QCQWN4qCpwaF8aO8pg-1; Thu, 18 May 2023 05:56:35 -0400
X-MC-Unique: sNI4QCQWN4qCpwaF8aO8pg-1
Received: from smtp.corp.redhat.com (int-mx01.intmail.prod.int.rdu2.redhat.com [10.11.54.1])
	(using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by mimecast-mx02.redhat.com (Postfix) with ESMTPS id 07051800047;
	Thu, 18 May 2023 09:56:34 +0000 (UTC)
Received: from warthog.procyon.org.uk (unknown [10.42.28.221])
	by smtp.corp.redhat.com (Postfix) with ESMTP id 66B3640C2063;
	Thu, 18 May 2023 09:56:31 +0000 (UTC)
Organization: Red Hat UK Ltd. Registered Address: Red Hat UK Ltd, Amberley
	Place, 107-111 Peascod Street, Windsor, Berkshire, SI4 1TE, United
	Kingdom.
	Registered in England and Wales under Company Registration No. 3798903
From: David Howells <dhowells@redhat.com>
In-Reply-To: <20230515093345.396978-4-dhowells@redhat.com>
References: <20230515093345.396978-4-dhowells@redhat.com> <20230515093345.396978-1-dhowells@redhat.com>
To: Paolo Abeni <pabeni@redhat.com>
Cc: dhowells@redhat.com, netdev@vger.kernel.org,
    "David S. Miller" <davem@davemloft.net>,
    Eric Dumazet <edumazet@google.com>, Jakub Kicinski <kuba@kernel.org>,
    Willem de Bruijn <willemdebruijn.kernel@gmail.com>,
    David Ahern <dsahern@kernel.org>,
    Matthew Wilcox <willy@infradead.org>,
    Al Viro <viro@zeniv.linux.org.uk>,
    Christoph Hellwig <hch@infradead.org>, Jens Axboe <axboe@kernel.dk>,
    Jeff Layton <jlayton@kernel.org>,
    Christian Brauner <brauner@kernel.org>,
    Chuck Lever III <chuck.lever@oracle.com>,
    Linus Torvalds <torvalds@linux-foundation.org>,
    linux-fsdevel@vger.kernel.org, linux-kernel@vger.kernel.org,
    linux-mm@kvack.org
Subject: [PATCH net-next v8 03/16] net: Add a function to splice pages into an skbuff for MSG_SPLICE_PAGES
Precedence: bulk
X-Mailing-List: netdev@vger.kernel.org
List-Id: <netdev.vger.kernel.org>
List-Subscribe: <mailto:netdev+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:netdev+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-ID: <1347366.1684403790.1@warthog.procyon.org.uk>
Content-Transfer-Encoding: quoted-printable
Date: Thu, 18 May 2023 10:56:30 +0100
Message-ID: <1347367.1684403790@warthog.procyon.org.uk>
X-Scanned-By: MIMEDefang 3.1 on 10.11.54.1
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
	DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_NONE,
	RCVD_IN_MSPIKE_H2,SPF_HELO_NONE,SPF_NONE,T_SCC_BODY_TEXT_LINE
	autolearn=unavailable autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
	lindbergh.monkeyblade.net

    =

Add a function to handle MSG_SPLICE_PAGES being passed internally to
sendmsg().  Pages are spliced into the given socket buffer if possible and
copied in if not (e.g. they're slab pages or have a zero refcount).

Signed-off-by: David Howells <dhowells@redhat.com>
cc: Eric Dumazet <edumazet@google.com>
cc: "David S. Miller" <davem@davemloft.net>
cc: David Ahern <dsahern@kernel.org>
cc: Jakub Kicinski <kuba@kernel.org>
cc: Paolo Abeni <pabeni@redhat.com>
cc: Al Viro <viro@zeniv.linux.org.uk>
cc: Jens Axboe <axboe@kernel.dk>
cc: Matthew Wilcox <willy@infradead.org>
cc: netdev@vger.kernel.org

---
Notes:
    ver #8)
     - Order local variables in reverse xmas tree order.
     - Remove duplicate coalescence check.
     - Warn if sendpage_ok() fails.
    =

    ver #7)
     - Export function.
     - Never copy data, return -EIO if sendpage_ok() returns false.

 include/linux/skbuff.h |    3 +
 net/core/skbuff.c      |   88 +++++++++++++++++++++++++++++++++++++++++++=
++++++
 2 files changed, 91 insertions(+)

diff --git a/include/linux/skbuff.h b/include/linux/skbuff.h
index 4c0ad48e38ca..1c5f0ac6f8c3 100644
--- a/include/linux/skbuff.h
+++ b/include/linux/skbuff.h
@@ -5097,5 +5097,8 @@ static inline void skb_mark_for_recycle(struct sk_bu=
ff *skb)
 #endif
 }
 =

+ssize_t skb_splice_from_iter(struct sk_buff *skb, struct iov_iter *iter,
+			     ssize_t maxsize, gfp_t gfp);
+
 #endif	/* __KERNEL__ */
 #endif	/* _LINUX_SKBUFF_H */
diff --git a/net/core/skbuff.c b/net/core/skbuff.c
index 7f53dcb26ad3..f4a5b51aed22 100644
--- a/net/core/skbuff.c
+++ b/net/core/skbuff.c
@@ -6892,3 +6892,91 @@ nodefer:	__kfree_skb(skb);
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
+	kaddr =3D kmap_local_page(page);
+	csum =3D csum_partial(kaddr + offset, len, 0);
+	kunmap_local(kaddr);
+	skb->csum =3D csum_block_add(skb->csum, csum, skb->len);
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
+ * possible, copying them to fragments if not possible (such as if they'r=
e slab
+ * pages).
+ *
+ * Returns the amount of data spliced/copied or -EMSGSIZE if there's
+ * insufficient space in the buffer to transfer anything.
+ */
+ssize_t skb_splice_from_iter(struct sk_buff *skb, struct iov_iter *iter,
+			     ssize_t maxsize, gfp_t gfp)
+{
+	size_t frag_limit =3D READ_ONCE(sysctl_max_skb_frags);
+	struct page *pages[8], **ppages =3D pages;
+	ssize_t spliced =3D 0, ret =3D 0;
+	unsigned int i;
+
+	while (iter->count > 0) {
+		ssize_t space, nr;
+		size_t off, len;
+
+		ret =3D -EMSGSIZE;
+		space =3D frag_limit - skb_shinfo(skb)->nr_frags;
+		if (space < 0)
+			break;
+
+		/* We might be able to coalesce without increasing nr_frags */
+		nr =3D clamp_t(size_t, space, 1, ARRAY_SIZE(pages));
+
+		len =3D iov_iter_extract_pages(iter, &ppages, maxsize, nr, 0, &off);
+		if (len <=3D 0) {
+			ret =3D len ?: -EIO;
+			break;
+		}
+
+		i =3D 0;
+		do {
+			struct page *page =3D pages[i++];
+			size_t part =3D min_t(size_t, PAGE_SIZE - off, len);
+
+			ret =3D -EIO;
+			if (WARN_ON_ONCE(!sendpage_ok(page)))
+				goto out;
+
+			ret =3D skb_append_pagefrags(skb, page, off, part,
+						   frag_limit);
+			if (ret < 0) {
+				iov_iter_revert(iter, len);
+				goto out;
+			}
+
+			if (skb->ip_summed =3D=3D CHECKSUM_NONE)
+				skb_splice_csum_page(skb, page, off, part);
+
+			off =3D 0;
+			spliced +=3D part;
+			maxsize -=3D part;
+			len -=3D part;
+		} while (len > 0);
+
+		if (maxsize <=3D 0)
+			break;
+	}
+
+out:
+	skb_len_add(skb, spliced);
+	return spliced ?: ret;
+}
+EXPORT_SYMBOL(skb_splice_from_iter);


