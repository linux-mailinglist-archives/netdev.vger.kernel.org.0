Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 70D5A66D318
	for <lists+netdev@lfdr.de>; Tue, 17 Jan 2023 00:23:00 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S235343AbjAPXW5 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 16 Jan 2023 18:22:57 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:33912 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S235474AbjAPXUu (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 16 Jan 2023 18:20:50 -0500
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.133.124])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id A26BA3457C
        for <netdev@vger.kernel.org>; Mon, 16 Jan 2023 15:13:06 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1673910731;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=kr0mxDWcfk97y+SD+0NWqgRc5pNq3uh0Z5vIhOFCaC0=;
        b=RP5z+FoNqVVDhprJ6d/PduSTcXBQBKl+IbCY8cyFnT1nKgsytOAFLV9F+pvDDnlYn16rSw
        brBOPlsrneJDGuB8/gANXWS8o2w3WqfkvNJPyZuHKD9LCS0rE/FtR92PCWqPp+173v3H0+
        /3j+uyzt0mTPcm/wrJgEogGWdEi9QJE=
Received: from mimecast-mx02.redhat.com (mx3-rdu2.redhat.com
 [66.187.233.73]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 us-mta-70-WiODrIuvPam5N8R9hwNvnA-1; Mon, 16 Jan 2023 18:12:05 -0500
X-MC-Unique: WiODrIuvPam5N8R9hwNvnA-1
Received: from smtp.corp.redhat.com (int-mx07.intmail.prod.int.rdu2.redhat.com [10.11.54.7])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mimecast-mx02.redhat.com (Postfix) with ESMTPS id 0F5C03C0F660;
        Mon, 16 Jan 2023 23:12:05 +0000 (UTC)
Received: from warthog.procyon.org.uk (unknown [10.33.36.23])
        by smtp.corp.redhat.com (Postfix) with ESMTP id 8DEF914171B8;
        Mon, 16 Jan 2023 23:12:02 +0000 (UTC)
Organization: Red Hat UK Ltd. Registered Address: Red Hat UK Ltd, Amberley
        Place, 107-111 Peascod Street, Windsor, Berkshire, SI4 1TE, United
        Kingdom.
        Registered in England and Wales under Company Registration No. 3798903
Subject: [PATCH v6 33/34] net: [RFC][WIP] Mark each skb_frags as to how they
 should be cleaned up
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
Date:   Mon, 16 Jan 2023 23:12:02 +0000
Message-ID: <167391072201.2311931.4013360052592980054.stgit@warthog.procyon.org.uk>
In-Reply-To: <167391047703.2311931.8115712773222260073.stgit@warthog.procyon.org.uk>
References: <167391047703.2311931.8115712773222260073.stgit@warthog.procyon.org.uk>
User-Agent: StGit/1.5
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
X-Scanned-By: MIMEDefang 3.1 on 10.11.54.7
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_NONE,
        RCVD_IN_MSPIKE_H2,SPF_HELO_NONE,SPF_NONE autolearn=unavailable
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

 [!] NOTE: This patch is mostly for illustrative/discussion purposes and
     makes an incomplete change and the networking code may not compile
     thereafter.

There are a couple of problems with pasting foreign pages into sk_buffs
with zerocopy that are analogous to the problems with direct I/O:

 (1) Pages derived from kernel buffers, such as KVEC iterators should not
     have refs taken on them.  Rather, the caller should do whatever it
     needs to to retain the memory.

 (2) Pages derived from userspace buffers must not have refs taken on them
     if they're going to be written to (analogous to direct I/O read) as
     this may cause a malfunction of the VM CoW mechanism with a concurrent
     fork.  Rather, they should have pins taken on them (FOLL_PIN).  This
     will affect zerocopy-recvmsg where that is exists (eg. TLS, I think,
     though that might be decrypt-offload).

This is further complicated by the possibility of a sk_buff containing data
from mixed sources - for example a network filesystem might generate a
message consisting of some metadata from a kernel buffer (which should not
be pinned) and some data from userspace (which should have a ref taken).

To this end, each page fragment attached to a sk_buff needs labelling with
the appropriate cleanup to be applied.  Do this by:

 (1) Replace struct bio_vec as the basis of skb_frag_t with a new struct
     skb_frag.  This has an offset and a length, as before, plus a
     'page_and_mode' member that contains the cleanup mode in the bottom
     two bits and the page pointer in the remaining bits.

     (FOLL_GET and FOLL_PIN got renumbered to bits 0 and 1 in an earlier
     patch).

 (2) The cleanup mode can be one of FOLL_GET (put a ref on the page),
     FOLL_PIN (unpin the page) or 0 (do nothing).

 (3) skb_frag_page() is used to access the page pointer as before.

 (4) __skb_frag_set_page() and skb_frag_set_page() acquire an extra
     argument to indicate the cleanup mode.

 (5) The cleanup mode is set to FOLL_GET on everything for the moment.

 (6) __skb_frag_ref() will call try_grab_page(), passing the cleanup mode
     to indicate whether an extra ref, an extra pin or nothing is required.

     [!] NOTE: If the cleanup mode was 0, this skbuff will also not pin the
     page and the caller needs to be aware of that.

 (7) __skb_frag_unref() will call page_put_unpin() to do the appropriate
     cleanup, based on the mode.

Signed-off-by: David Howells <dhowells@redhat.com>
cc: "David S. Miller" <davem@davemloft.net>
cc: Eric Dumazet <edumazet@google.com>
cc: Jakub Kicinski <kuba@kernel.org>
cc: Paolo Abeni <pabeni@redhat.com>
cc: netdev@vger.kernel.org
---

 drivers/net/tun.c      |    2 -
 include/linux/skbuff.h |  124 ++++++++++++++++++++++++++++++------------------
 io_uring/net.c         |    2 -
 net/bpf/test_run.c     |    2 -
 net/core/datagram.c    |    3 +
 net/core/gro.c         |    2 -
 net/core/skbuff.c      |   16 +++---
 net/ipv4/ip_output.c   |    2 -
 net/ipv4/tcp.c         |    4 +-
 net/ipv6/esp6.c        |    5 +-
 net/ipv6/ip6_output.c  |    2 -
 net/packet/af_packet.c |    2 -
 net/xfrm/xfrm_ipcomp.c |    2 -
 13 files changed, 101 insertions(+), 67 deletions(-)

diff --git a/drivers/net/tun.c b/drivers/net/tun.c
index a7d17c680f4a..6c467c5163b2 100644
--- a/drivers/net/tun.c
+++ b/drivers/net/tun.c
@@ -1496,7 +1496,7 @@ static struct sk_buff *tun_napi_alloc_frags(struct tun_file *tfile,
 		}
 		page = virt_to_head_page(frag);
 		skb_fill_page_desc(skb, i - 1, page,
-				   frag - page_address(page), fragsz);
+				   frag - page_address(page), fragsz, FOLL_GET);
 	}
 
 	return skb;
diff --git a/include/linux/skbuff.h b/include/linux/skbuff.h
index 4c8492401a10..a1a77909509b 100644
--- a/include/linux/skbuff.h
+++ b/include/linux/skbuff.h
@@ -357,7 +357,51 @@ extern int sysctl_max_skb_frags;
  */
 #define GSO_BY_FRAGS	0xFFFF
 
-typedef struct bio_vec skb_frag_t;
+struct skb_frag {
+	unsigned long	page_and_mode;	/* page pointer | cleanup_mode (0/FOLL_GET/PIN) */
+	unsigned int	len;
+	unsigned int	offset;
+};
+typedef struct skb_frag skb_frag_t;
+
+/**
+ * skb_frag_cleanup() - Returns the cleanup mode for an skb fragment
+ * @frag: skb fragment
+ *
+ * Returns the cleanup mode associated with @frag.  It will be FOLL_GET,
+ * FOLL_PUT or 0.
+ */
+static inline unsigned int skb_frag_cleanup(const skb_frag_t *frag)
+{
+	return frag->page_and_mode & 3;
+}
+
+/**
+ * skb_frag_page() - Returns the page in an skb fragment
+ * @frag: skb fragment
+ *
+ * Returns the &struct page associated with @frag.
+ */
+static inline struct page *skb_frag_page(const skb_frag_t *frag)
+{
+	return (struct page *)(frag->page_and_mode & ~3);
+}
+
+/**
+ * __skb_frag_set_page() - Sets the page in an skb fragment
+ * @frag: skb fragment
+ * @page: The page to set
+ * @cleanup_mode: The cleanup mode to set (0, FOLL_GET, FOLL_PIN)
+ *
+ * Sets the fragment @frag to contain @page with the specified method of
+ * cleaning it up.
+ */
+static inline void __skb_frag_set_page(skb_frag_t *frag, struct page *page,
+				       unsigned int cleanup_mode)
+{
+	cleanup_mode &= FOLL_GET | FOLL_PIN;
+	frag->page_and_mode = (unsigned long)page | cleanup_mode;
+}
 
 /**
  * skb_frag_size() - Returns the size of a skb fragment
@@ -365,7 +409,7 @@ typedef struct bio_vec skb_frag_t;
  */
 static inline unsigned int skb_frag_size(const skb_frag_t *frag)
 {
-	return frag->bv_len;
+	return frag->len;
 }
 
 /**
@@ -375,7 +419,7 @@ static inline unsigned int skb_frag_size(const skb_frag_t *frag)
  */
 static inline void skb_frag_size_set(skb_frag_t *frag, unsigned int size)
 {
-	frag->bv_len = size;
+	frag->len = size;
 }
 
 /**
@@ -385,7 +429,7 @@ static inline void skb_frag_size_set(skb_frag_t *frag, unsigned int size)
  */
 static inline void skb_frag_size_add(skb_frag_t *frag, int delta)
 {
-	frag->bv_len += delta;
+	frag->len += delta;
 }
 
 /**
@@ -395,7 +439,7 @@ static inline void skb_frag_size_add(skb_frag_t *frag, int delta)
  */
 static inline void skb_frag_size_sub(skb_frag_t *frag, int delta)
 {
-	frag->bv_len -= delta;
+	frag->len -= delta;
 }
 
 /**
@@ -2388,7 +2432,8 @@ static inline unsigned int skb_pagelen(const struct sk_buff *skb)
 
 static inline void __skb_fill_page_desc_noacc(struct skb_shared_info *shinfo,
 					      int i, struct page *page,
-					      int off, int size)
+					      int off, int size,
+					      unsigned int cleanup_mode)
 {
 	skb_frag_t *frag = &shinfo->frags[i];
 
@@ -2397,9 +2442,9 @@ static inline void __skb_fill_page_desc_noacc(struct skb_shared_info *shinfo,
 	 * that not all callers have unique ownership of the page but rely
 	 * on page_is_pfmemalloc doing the right thing(tm).
 	 */
-	frag->bv_page		  = page;
-	frag->bv_offset		  = off;
+	__skb_frag_set_page(frag, page, cleanup_mode);
 	skb_frag_size_set(frag, size);
+	frag->offset = off;
 }
 
 /**
@@ -2421,6 +2466,7 @@ static inline void skb_len_add(struct sk_buff *skb, int delta)
  * @page: the page to use for this fragment
  * @off: the offset to the data with @page
  * @size: the length of the data
+ * @cleanup_mode: The cleanup mode to set (0, FOLL_GET, FOLL_PIN)
  *
  * Initialises the @i'th fragment of @skb to point to &size bytes at
  * offset @off within @page.
@@ -2428,9 +2474,11 @@ static inline void skb_len_add(struct sk_buff *skb, int delta)
  * Does not take any additional reference on the fragment.
  */
 static inline void __skb_fill_page_desc(struct sk_buff *skb, int i,
-					struct page *page, int off, int size)
+					struct page *page, int off, int size,
+					unsigned int cleanup_mode)
 {
-	__skb_fill_page_desc_noacc(skb_shinfo(skb), i, page, off, size);
+	__skb_fill_page_desc_noacc(skb_shinfo(skb), i, page, off, size,
+				   cleanup_mode);
 	page = compound_head(page);
 	if (page_is_pfmemalloc(page))
 		skb->pfmemalloc	= true;
@@ -2443,6 +2491,7 @@ static inline void __skb_fill_page_desc(struct sk_buff *skb, int i,
  * @page: the page to use for this fragment
  * @off: the offset to the data with @page
  * @size: the length of the data
+ * @cleanup_mode: The cleanup mode to set (0, FOLL_GET, FOLL_PIN)
  *
  * As per __skb_fill_page_desc() -- initialises the @i'th fragment of
  * @skb to point to @size bytes at offset @off within @page. In
@@ -2451,9 +2500,10 @@ static inline void __skb_fill_page_desc(struct sk_buff *skb, int i,
  * Does not take any additional reference on the fragment.
  */
 static inline void skb_fill_page_desc(struct sk_buff *skb, int i,
-				      struct page *page, int off, int size)
+				      struct page *page, int off, int size,
+				      unsigned int cleanup_mode)
 {
-	__skb_fill_page_desc(skb, i, page, off, size);
+	__skb_fill_page_desc(skb, i, page, off, size, cleanup_mode);
 	skb_shinfo(skb)->nr_frags = i + 1;
 }
 
@@ -2464,17 +2514,18 @@ static inline void skb_fill_page_desc(struct sk_buff *skb, int i,
  * @page: the page to use for this fragment
  * @off: the offset to the data with @page
  * @size: the length of the data
+ * @cleanup_mode: The cleanup mode to set (0, FOLL_GET, FOLL_PIN)
  *
  * Variant of skb_fill_page_desc() which does not deal with
  * pfmemalloc, if page is not owned by us.
  */
 static inline void skb_fill_page_desc_noacc(struct sk_buff *skb, int i,
 					    struct page *page, int off,
-					    int size)
+					    int size, unsigned int cleanup_mode)
 {
 	struct skb_shared_info *shinfo = skb_shinfo(skb);
 
-	__skb_fill_page_desc_noacc(shinfo, i, page, off, size);
+	__skb_fill_page_desc_noacc(shinfo, i, page, off, size, cleanup_mode);
 	shinfo->nr_frags = i + 1;
 }
 
@@ -3301,7 +3352,7 @@ static inline void skb_propagate_pfmemalloc(const struct page *page,
  */
 static inline unsigned int skb_frag_off(const skb_frag_t *frag)
 {
-	return frag->bv_offset;
+	return frag->offset;
 }
 
 /**
@@ -3311,7 +3362,7 @@ static inline unsigned int skb_frag_off(const skb_frag_t *frag)
  */
 static inline void skb_frag_off_add(skb_frag_t *frag, int delta)
 {
-	frag->bv_offset += delta;
+	frag->offset += delta;
 }
 
 /**
@@ -3321,7 +3372,7 @@ static inline void skb_frag_off_add(skb_frag_t *frag, int delta)
  */
 static inline void skb_frag_off_set(skb_frag_t *frag, unsigned int offset)
 {
-	frag->bv_offset = offset;
+	frag->offset = offset;
 }
 
 /**
@@ -3332,18 +3383,7 @@ static inline void skb_frag_off_set(skb_frag_t *frag, unsigned int offset)
 static inline void skb_frag_off_copy(skb_frag_t *fragto,
 				     const skb_frag_t *fragfrom)
 {
-	fragto->bv_offset = fragfrom->bv_offset;
-}
-
-/**
- * skb_frag_page - retrieve the page referred to by a paged fragment
- * @frag: the paged fragment
- *
- * Returns the &struct page associated with @frag.
- */
-static inline struct page *skb_frag_page(const skb_frag_t *frag)
-{
-	return frag->bv_page;
+	fragto->offset = fragfrom->offset;
 }
 
 /**
@@ -3354,7 +3394,9 @@ static inline struct page *skb_frag_page(const skb_frag_t *frag)
  */
 static inline void __skb_frag_ref(skb_frag_t *frag)
 {
-	get_page(skb_frag_page(frag));
+	struct page *page = skb_frag_page(frag);
+
+	try_grab_page(page, skb_frag_cleanup(frag));
 }
 
 /**
@@ -3385,7 +3427,7 @@ static inline void __skb_frag_unref(skb_frag_t *frag, bool recycle)
 	if (recycle && page_pool_return_skb_page(page))
 		return;
 #endif
-	put_page(page);
+	page_put_unpin(page, skb_frag_cleanup(frag));
 }
 
 /**
@@ -3439,19 +3481,7 @@ static inline void *skb_frag_address_safe(const skb_frag_t *frag)
 static inline void skb_frag_page_copy(skb_frag_t *fragto,
 				      const skb_frag_t *fragfrom)
 {
-	fragto->bv_page = fragfrom->bv_page;
-}
-
-/**
- * __skb_frag_set_page - sets the page contained in a paged fragment
- * @frag: the paged fragment
- * @page: the page to set
- *
- * Sets the fragment @frag to contain @page.
- */
-static inline void __skb_frag_set_page(skb_frag_t *frag, struct page *page)
-{
-	frag->bv_page = page;
+	fragto->page_and_mode = fragfrom->page_and_mode;
 }
 
 /**
@@ -3459,13 +3489,15 @@ static inline void __skb_frag_set_page(skb_frag_t *frag, struct page *page)
  * @skb: the buffer
  * @f: the fragment offset
  * @page: the page to set
+ * @cleanup_mode: The cleanup mode to set (0, FOLL_GET, FOLL_PIN)
  *
  * Sets the @f'th fragment of @skb to contain @page.
  */
 static inline void skb_frag_set_page(struct sk_buff *skb, int f,
-				     struct page *page)
+				     struct page *page,
+				     unsigned int cleanup_mode)
 {
-	__skb_frag_set_page(&skb_shinfo(skb)->frags[f], page);
+	__skb_frag_set_page(&skb_shinfo(skb)->frags[f], page, cleanup_mode);
 }
 
 bool skb_page_frag_refill(unsigned int sz, struct page_frag *pfrag, gfp_t prio);
diff --git a/io_uring/net.c b/io_uring/net.c
index fbc34a7c2743..1d3e24404d75 100644
--- a/io_uring/net.c
+++ b/io_uring/net.c
@@ -1043,7 +1043,7 @@ static int io_sg_from_iter(struct sock *sk, struct sk_buff *skb,
 		copied += v.bv_len;
 		truesize += PAGE_ALIGN(v.bv_len + v.bv_offset);
 		__skb_fill_page_desc_noacc(shinfo, frag++, v.bv_page,
-					   v.bv_offset, v.bv_len);
+					   v.bv_offset, v.bv_len, FOLL_GET);
 		bvec_iter_advance_single(from->bvec, &bi, v.bv_len);
 	}
 	if (bi.bi_size)
diff --git a/net/bpf/test_run.c b/net/bpf/test_run.c
index 2723623429ac..9ed2de52e1be 100644
--- a/net/bpf/test_run.c
+++ b/net/bpf/test_run.c
@@ -1370,7 +1370,7 @@ int bpf_prog_test_run_xdp(struct bpf_prog *prog, const union bpf_attr *kattr,
 			}
 
 			frag = &sinfo->frags[sinfo->nr_frags++];
-			__skb_frag_set_page(frag, page);
+			__skb_frag_set_page(frag, page, FOLL_GET);
 
 			data_len = min_t(u32, kattr->test.data_size_in - size,
 					 PAGE_SIZE);
diff --git a/net/core/datagram.c b/net/core/datagram.c
index 9f0914b781ad..122bfb144d32 100644
--- a/net/core/datagram.c
+++ b/net/core/datagram.c
@@ -678,7 +678,8 @@ int __zerocopy_sg_from_iter(struct msghdr *msg, struct sock *sk,
 				page_ref_sub(last_head, refs);
 				refs = 0;
 			}
-			skb_fill_page_desc_noacc(skb, frag++, head, start, size);
+			skb_fill_page_desc_noacc(skb, frag++, head, start, size,
+						 FOLL_GET);
 		}
 		if (refs)
 			page_ref_sub(last_head, refs);
diff --git a/net/core/gro.c b/net/core/gro.c
index fd8c6a7e8d3e..dfbf2279ce5c 100644
--- a/net/core/gro.c
+++ b/net/core/gro.c
@@ -228,7 +228,7 @@ int skb_gro_receive(struct sk_buff *p, struct sk_buff *skb)
 
 		pinfo->nr_frags = nr_frags + 1 + skbinfo->nr_frags;
 
-		__skb_frag_set_page(frag, page);
+		__skb_frag_set_page(frag, page, FOLL_GET);
 		skb_frag_off_set(frag, first_offset);
 		skb_frag_size_set(frag, first_size);
 
diff --git a/net/core/skbuff.c b/net/core/skbuff.c
index 4a0eb5593275..a6a21a27ebb4 100644
--- a/net/core/skbuff.c
+++ b/net/core/skbuff.c
@@ -765,7 +765,7 @@ EXPORT_SYMBOL(__napi_alloc_skb);
 void skb_add_rx_frag(struct sk_buff *skb, int i, struct page *page, int off,
 		     int size, unsigned int truesize)
 {
-	skb_fill_page_desc(skb, i, page, off, size);
+	skb_fill_page_desc(skb, i, page, off, size, FOLL_GET);
 	skb->len += size;
 	skb->data_len += size;
 	skb->truesize += truesize;
@@ -1666,10 +1666,10 @@ int skb_copy_ubufs(struct sk_buff *skb, gfp_t gfp_mask)
 
 	/* skb frags point to kernel buffers */
 	for (i = 0; i < new_frags - 1; i++) {
-		__skb_fill_page_desc(skb, i, head, 0, PAGE_SIZE);
+		__skb_fill_page_desc(skb, i, head, 0, PAGE_SIZE, FOLL_GET);
 		head = (struct page *)page_private(head);
 	}
-	__skb_fill_page_desc(skb, new_frags - 1, head, 0, d_off);
+	__skb_fill_page_desc(skb, new_frags - 1, head, 0, d_off, FOLL_GET);
 	skb_shinfo(skb)->nr_frags = new_frags;
 
 release:
@@ -3389,7 +3389,7 @@ skb_zerocopy(struct sk_buff *to, struct sk_buff *from, int len, int hlen)
 		if (plen) {
 			page = virt_to_head_page(from->head);
 			offset = from->data - (unsigned char *)page_address(page);
-			__skb_fill_page_desc(to, 0, page, offset, plen);
+			__skb_fill_page_desc(to, 0, page, offset, plen, FOLL_GET);
 			get_page(page);
 			j = 1;
 			len -= plen;
@@ -4040,7 +4040,7 @@ int skb_append_pagefrags(struct sk_buff *skb, struct page *page,
 	} else if (i < MAX_SKB_FRAGS) {
 		skb_zcopy_downgrade_managed(skb);
 		get_page(page);
-		skb_fill_page_desc_noacc(skb, i, page, offset, size);
+		skb_fill_page_desc_noacc(skb, i, page, offset, size, FOLL_GET);
 	} else {
 		return -EMSGSIZE;
 	}
@@ -4077,7 +4077,7 @@ static inline skb_frag_t skb_head_frag_to_page_desc(struct sk_buff *frag_skb)
 	struct page *page;
 
 	page = virt_to_head_page(frag_skb->head);
-	__skb_frag_set_page(&head_frag, page);
+	__skb_frag_set_page(&head_frag, page, FOLL_GET);
 	skb_frag_off_set(&head_frag, frag_skb->data -
 			 (unsigned char *)page_address(page));
 	skb_frag_size_set(&head_frag, skb_headlen(frag_skb));
@@ -5521,7 +5521,7 @@ bool skb_try_coalesce(struct sk_buff *to, struct sk_buff *from,
 		offset = from->data - (unsigned char *)page_address(page);
 
 		skb_fill_page_desc(to, to_shinfo->nr_frags,
-				   page, offset, skb_headlen(from));
+				   page, offset, skb_headlen(from), FOLL_GET);
 		*fragstolen = true;
 	} else {
 		if (to_shinfo->nr_frags +
@@ -6221,7 +6221,7 @@ struct sk_buff *alloc_skb_with_frags(unsigned long header_len,
 fill_page:
 		chunk = min_t(unsigned long, data_len,
 			      PAGE_SIZE << order);
-		skb_fill_page_desc(skb, i, page, 0, chunk);
+		skb_fill_page_desc(skb, i, page, 0, chunk, FOLL_GET);
 		data_len -= chunk;
 		npages -= 1 << order;
 	}
diff --git a/net/ipv4/ip_output.c b/net/ipv4/ip_output.c
index 922c87ef1ab5..43ea2e7aeeea 100644
--- a/net/ipv4/ip_output.c
+++ b/net/ipv4/ip_output.c
@@ -1221,7 +1221,7 @@ static int __ip_append_data(struct sock *sk,
 					goto error;
 
 				__skb_fill_page_desc(skb, i, pfrag->page,
-						     pfrag->offset, 0);
+						     pfrag->offset, 0, FOLL_GET);
 				skb_shinfo(skb)->nr_frags = ++i;
 				get_page(pfrag->page);
 			}
diff --git a/net/ipv4/tcp.c b/net/ipv4/tcp.c
index c567d5e8053e..2cb88e67e152 100644
--- a/net/ipv4/tcp.c
+++ b/net/ipv4/tcp.c
@@ -1016,7 +1016,7 @@ static struct sk_buff *tcp_build_frag(struct sock *sk, int size_goal, int flags,
 		skb_frag_size_add(&skb_shinfo(skb)->frags[i - 1], copy);
 	} else {
 		get_page(page);
-		skb_fill_page_desc_noacc(skb, i, page, offset, copy);
+		skb_fill_page_desc_noacc(skb, i, page, offset, copy, FOLL_GET);
 	}
 
 	if (!(flags & MSG_NO_SHARED_FRAGS))
@@ -1385,7 +1385,7 @@ int tcp_sendmsg_locked(struct sock *sk, struct msghdr *msg, size_t size)
 				skb_frag_size_add(&skb_shinfo(skb)->frags[i - 1], copy);
 			} else {
 				skb_fill_page_desc(skb, i, pfrag->page,
-						   pfrag->offset, copy);
+						   pfrag->offset, copy, FOLL_GET);
 				page_ref_inc(pfrag->page);
 			}
 			pfrag->offset += copy;
diff --git a/net/ipv6/esp6.c b/net/ipv6/esp6.c
index 14ed868680c6..13e9d36e132e 100644
--- a/net/ipv6/esp6.c
+++ b/net/ipv6/esp6.c
@@ -529,7 +529,7 @@ int esp6_output_head(struct xfrm_state *x, struct sk_buff *skb, struct esp_info
 			nfrags = skb_shinfo(skb)->nr_frags;
 
 			__skb_fill_page_desc(skb, nfrags, page, pfrag->offset,
-					     tailen);
+					     tailen, FOLL_GET);
 			skb_shinfo(skb)->nr_frags = ++nfrags;
 
 			pfrag->offset = pfrag->offset + allocsize;
@@ -635,7 +635,8 @@ int esp6_output_tail(struct xfrm_state *x, struct sk_buff *skb, struct esp_info
 		page = pfrag->page;
 		get_page(page);
 		/* replace page frags in skb with new page */
-		__skb_fill_page_desc(skb, 0, page, pfrag->offset, skb->data_len);
+		__skb_fill_page_desc(skb, 0, page, pfrag->offset, skb->data_len,
+				     FOLL_GET);
 		pfrag->offset = pfrag->offset + allocsize;
 		spin_unlock_bh(&x->lock);
 
diff --git a/net/ipv6/ip6_output.c b/net/ipv6/ip6_output.c
index 60fd91bb5171..117fb2bdad02 100644
--- a/net/ipv6/ip6_output.c
+++ b/net/ipv6/ip6_output.c
@@ -1780,7 +1780,7 @@ static int __ip6_append_data(struct sock *sk,
 					goto error;
 
 				__skb_fill_page_desc(skb, i, pfrag->page,
-						     pfrag->offset, 0);
+						     pfrag->offset, 0, FOLL_GET);
 				skb_shinfo(skb)->nr_frags = ++i;
 				get_page(pfrag->page);
 			}
diff --git a/net/packet/af_packet.c b/net/packet/af_packet.c
index b5ab98ca2511..15c9f17ce7d8 100644
--- a/net/packet/af_packet.c
+++ b/net/packet/af_packet.c
@@ -2630,7 +2630,7 @@ static int tpacket_fill_skb(struct packet_sock *po, struct sk_buff *skb,
 		data += len;
 		flush_dcache_page(page);
 		get_page(page);
-		skb_fill_page_desc(skb, nr_frags, page, offset, len);
+		skb_fill_page_desc(skb, nr_frags, page, offset, len, FOLL_GET);
 		to_write -= len;
 		offset = 0;
 		len_max = PAGE_SIZE;
diff --git a/net/xfrm/xfrm_ipcomp.c b/net/xfrm/xfrm_ipcomp.c
index 80143360bf09..8e9574e00cd0 100644
--- a/net/xfrm/xfrm_ipcomp.c
+++ b/net/xfrm/xfrm_ipcomp.c
@@ -74,7 +74,7 @@ static int ipcomp_decompress(struct xfrm_state *x, struct sk_buff *skb)
 		if (!page)
 			return -ENOMEM;
 
-		__skb_frag_set_page(frag, page);
+		__skb_frag_set_page(frag, page, FOLL_GET);
 
 		len = PAGE_SIZE;
 		if (dlen < len)


