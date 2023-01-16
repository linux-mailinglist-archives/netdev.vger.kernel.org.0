Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id BD89166D31A
	for <lists+netdev@lfdr.de>; Tue, 17 Jan 2023 00:23:02 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S235525AbjAPXW7 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 16 Jan 2023 18:22:59 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:33932 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S235476AbjAPXUy (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 16 Jan 2023 18:20:54 -0500
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.129.124])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 93A0E34C0D
        for <netdev@vger.kernel.org>; Mon, 16 Jan 2023 15:13:09 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1673910737;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=RemqltCjkZ1MEJ2va2p40ZyP53eaWFY2Pd4/PSibIZ0=;
        b=cnnH2XvGgcoqN+6981YDSPcnZXuFASZM8j5Mh/FZp/KFeSyVu7bZOlLac6bYkzEgaz6Yw0
        pg/1iV+eCAucB0spfESg1Yu2xiCSxsCEwZ95sk2vObc1PhqYDEaGRd/bXhSo6f48DCbGH7
        T6pLcgdZJ+1KmPO18lNVD3e5O53dSjc=
Received: from mimecast-mx02.redhat.com (mx3-rdu2.redhat.com
 [66.187.233.73]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 us-mta-631-QixFgPowM6ytp9eOTe22RA-1; Mon, 16 Jan 2023 18:12:13 -0500
X-MC-Unique: QixFgPowM6ytp9eOTe22RA-1
Received: from smtp.corp.redhat.com (int-mx04.intmail.prod.int.rdu2.redhat.com [10.11.54.4])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mimecast-mx02.redhat.com (Postfix) with ESMTPS id 8248E1C0432A;
        Mon, 16 Jan 2023 23:12:12 +0000 (UTC)
Received: from warthog.procyon.org.uk (unknown [10.33.36.23])
        by smtp.corp.redhat.com (Postfix) with ESMTP id B86192026D4B;
        Mon, 16 Jan 2023 23:12:10 +0000 (UTC)
Organization: Red Hat UK Ltd. Registered Address: Red Hat UK Ltd, Amberley
        Place, 107-111 Peascod Street, Windsor, Berkshire, SI4 1TE, United
        Kingdom.
        Registered in England and Wales under Company Registration No. 3798903
Subject: [PATCH v6 34/34] net: [RFC][WIP] Make __zerocopy_sg_from_iter()
 correctly pin or leave pages unref'd
From:   David Howells <dhowells@redhat.com>
To:     Al Viro <viro@zeniv.linux.org.uk>
Cc:     "David S. Miller" <davem@davemloft.net>,
        Eric Dumazet <edumazet@google.com>,
        Jakub Kicinski <kuba@kernel.org>,
        Paolo Abeni <pabeni@redhat.com>, netdev@vger.kernel.org,
        dhowells@redhat.com, Christoph Hellwig <hch@infradead.org>,
        Matthew Wilcox <willy@infradead.org>,
        Jens Axboe <axboe@kernel.dk>, Jan Kara <jack@suse.cz>,
        Jeff Layton <jlayton@kernel.org>,
        Logan Gunthorpe <logang@deltatee.com>,
        linux-fsdevel@vger.kernel.org, linux-block@vger.kernel.org,
        linux-kernel@vger.kernel.org
Date:   Mon, 16 Jan 2023 23:12:10 +0000
Message-ID: <167391073019.2311931.11127613443740355536.stgit@warthog.procyon.org.uk>
In-Reply-To: <167391047703.2311931.8115712773222260073.stgit@warthog.procyon.org.uk>
References: <167391047703.2311931.8115712773222260073.stgit@warthog.procyon.org.uk>
User-Agent: StGit/1.5
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
X-Scanned-By: MIMEDefang 3.1 on 10.11.54.4
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_NONE,
        RCVD_IN_MSPIKE_H2,SPF_HELO_NONE,SPF_NONE autolearn=unavailable
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Make __zerocopy_sg_from_iter() call iov_iter_extract_pages() to get pages
that have been ref'd, pinned or left alone as appropriate.  As this is only
used for source buffers, pinning isn't an option, but being unref'd is.

The way __zerocopy_sg_from_iter() merges fragments is also altered, such
that fragments must also match their cleanup modes to be merged.

An extra helper and wrapper, folio_put_unpin_sub() and page_put_unpin_sub()
are added to allow multiple refs to be put/unpinned.

Signed-off-by: David Howells <dhowells@redhat.com>
cc: "David S. Miller" <davem@davemloft.net>
cc: Eric Dumazet <edumazet@google.com>
cc: Jakub Kicinski <kuba@kernel.org>
cc: Paolo Abeni <pabeni@redhat.com>
cc: netdev@vger.kernel.org
---

 include/linux/mm.h  |    2 ++
 mm/gup.c            |   25 +++++++++++++++++++++++++
 net/core/datagram.c |   23 +++++++++++++----------
 3 files changed, 40 insertions(+), 10 deletions(-)

diff --git a/include/linux/mm.h b/include/linux/mm.h
index f14edb192394..e3923b89c75e 100644
--- a/include/linux/mm.h
+++ b/include/linux/mm.h
@@ -1368,7 +1368,9 @@ static inline bool is_cow_mapping(vm_flags_t flags)
 #endif
 
 void folio_put_unpin(struct folio *folio, unsigned int flags);
+void folio_put_unpin_sub(struct folio *folio, unsigned int flags, unsigned int refs);
 void page_put_unpin(struct page *page, unsigned int flags);
+void page_put_unpin_sub(struct page *page, unsigned int flags, unsigned int refs);
 
 /*
  * The identification function is mainly used by the buddy allocator for
diff --git a/mm/gup.c b/mm/gup.c
index 3ee4b4c7e0cb..49dd27ba6c13 100644
--- a/mm/gup.c
+++ b/mm/gup.c
@@ -213,6 +213,31 @@ void page_put_unpin(struct page *page, unsigned int flags)
 }
 EXPORT_SYMBOL_GPL(page_put_unpin);
 
+/**
+ * folio_put_unpin_sub - Unpin/put a folio as appropriate
+ * @folio: The folio to release
+ * @flags: gup flags indicating the mode of release (FOLL_*)
+ * @refs: Number of refs/pins to drop
+ *
+ * Release a folio according to the flags.  If FOLL_GET is set, the folio has a
+ * ref dropped; if FOLL_PIN is set, it is unpinned; otherwise it is left
+ * unaltered.
+ */
+void folio_put_unpin_sub(struct folio *folio, unsigned int flags,
+			 unsigned int refs)
+{
+	if (flags & (FOLL_GET | FOLL_PIN))
+		gup_put_folio(folio, refs, flags);
+}
+EXPORT_SYMBOL_GPL(folio_put_unpin_sub);
+
+void page_put_unpin_sub(struct page *page, unsigned int flags,
+			unsigned int refs)
+{
+	folio_put_unpin_sub(page_folio(page), flags, refs);
+}
+EXPORT_SYMBOL_GPL(page_put_unpin_sub);
+
 /**
  * try_grab_page() - elevate a page's refcount by a flag-dependent amount
  * @page:    pointer to page to be grabbed
diff --git a/net/core/datagram.c b/net/core/datagram.c
index 122bfb144d32..63ea1f8817e0 100644
--- a/net/core/datagram.c
+++ b/net/core/datagram.c
@@ -614,6 +614,7 @@ int __zerocopy_sg_from_iter(struct msghdr *msg, struct sock *sk,
 			    struct sk_buff *skb, struct iov_iter *from,
 			    size_t length)
 {
+	unsigned int cleanup_mode = iov_iter_extract_mode(from, FOLL_SOURCE_BUF);
 	int frag;
 
 	if (msg && msg->msg_ubuf && msg->sg_from_iter)
@@ -622,7 +623,7 @@ int __zerocopy_sg_from_iter(struct msghdr *msg, struct sock *sk,
 	frag = skb_shinfo(skb)->nr_frags;
 
 	while (length && iov_iter_count(from)) {
-		struct page *pages[MAX_SKB_FRAGS];
+		struct page *pages[MAX_SKB_FRAGS], **ppages = pages;
 		struct page *last_head = NULL;
 		size_t start;
 		ssize_t copied;
@@ -632,9 +633,9 @@ int __zerocopy_sg_from_iter(struct msghdr *msg, struct sock *sk,
 		if (frag == MAX_SKB_FRAGS)
 			return -EMSGSIZE;
 
-		copied = iov_iter_get_pages(from, pages, length,
-					    MAX_SKB_FRAGS - frag, &start,
-					    FOLL_SOURCE_BUF);
+		copied = iov_iter_extract_pages(from, &ppages, length,
+						MAX_SKB_FRAGS - frag,
+						FOLL_SOURCE_BUF, &start);
 		if (copied < 0)
 			return -EFAULT;
 
@@ -662,12 +663,14 @@ int __zerocopy_sg_from_iter(struct msghdr *msg, struct sock *sk,
 				skb_frag_t *last = &skb_shinfo(skb)->frags[frag - 1];
 
 				if (head == skb_frag_page(last) &&
+				    cleanup_mode == skb_frag_cleanup(last) &&
 				    start == skb_frag_off(last) + skb_frag_size(last)) {
 					skb_frag_size_add(last, size);
 					/* We combined this page, we need to release
-					 * a reference. Since compound pages refcount
-					 * is shared among many pages, batch the refcount
-					 * adjustments to limit false sharing.
+					 * a reference or a pin.  Since compound pages
+					 * refcount is shared among many pages, batch
+					 * the refcount adjustments to limit false
+					 * sharing.
 					 */
 					last_head = head;
 					refs++;
@@ -675,14 +678,14 @@ int __zerocopy_sg_from_iter(struct msghdr *msg, struct sock *sk,
 				}
 			}
 			if (refs) {
-				page_ref_sub(last_head, refs);
+				page_put_unpin_sub(last_head, cleanup_mode, refs);
 				refs = 0;
 			}
 			skb_fill_page_desc_noacc(skb, frag++, head, start, size,
-						 FOLL_GET);
+						 cleanup_mode);
 		}
 		if (refs)
-			page_ref_sub(last_head, refs);
+			page_put_unpin_sub(last_head, cleanup_mode, refs);
 	}
 	return 0;
 }


