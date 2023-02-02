Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id CEB31688174
	for <lists+netdev@lfdr.de>; Thu,  2 Feb 2023 16:15:58 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232479AbjBBPP4 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 2 Feb 2023 10:15:56 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:59576 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232166AbjBBPPz (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 2 Feb 2023 10:15:55 -0500
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.129.124])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id EE42B234E9
        for <netdev@vger.kernel.org>; Thu,  2 Feb 2023 07:15:17 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1675350917;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=3mVIRCsoBvNLP2+6cVUlv2beBcs4GjkZr5MMjkDCtbM=;
        b=PH8wC+OcXvucnC+3oFpISB5WjfvwY1c8nedUC95mtbr6AD7xkdPhOhwLQTONcJ347VYZLy
        DhLeV8jPZz2QtqvC4BB9AcsDXBzA93GrHpFAgjn6t27Fe4uQOOfdtM/ZpkUXFIiTYBA1QN
        +d69Ix+EJ/WerJcBqXg3ZL9DNBW+KUY=
Received: from mimecast-mx02.redhat.com (mimecast-mx02.redhat.com
 [66.187.233.88]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 us-mta-85-kP-lbJsxPbmKGoPD32Zf1A-1; Thu, 02 Feb 2023 10:15:14 -0500
X-MC-Unique: kP-lbJsxPbmKGoPD32Zf1A-1
Received: from smtp.corp.redhat.com (int-mx04.intmail.prod.int.rdu2.redhat.com [10.11.54.4])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mimecast-mx02.redhat.com (Postfix) with ESMTPS id B7AF9100F906;
        Thu,  2 Feb 2023 15:15:11 +0000 (UTC)
Received: from warthog.procyon.org.uk (unknown [10.33.36.97])
        by smtp.corp.redhat.com (Postfix) with ESMTP id 0AC102026D4B;
        Thu,  2 Feb 2023 15:15:09 +0000 (UTC)
Organization: Red Hat UK Ltd. Registered Address: Red Hat UK Ltd, Amberley
        Place, 107-111 Peascod Street, Windsor, Berkshire, SI4 1TE, United
        Kingdom.
        Registered in England and Wales under Company Registration No. 3798903
From:   David Howells <dhowells@redhat.com>
In-Reply-To: <e8065d6a-d2f9-60aa-8541-8dfc8e9b608f@redhat.com>
References: <e8065d6a-d2f9-60aa-8541-8dfc8e9b608f@redhat.com> <000000000000b0b3c005f3a09383@google.com> <822863.1675327935@warthog.procyon.org.uk>
To:     David Hildenbrand <david@redhat.com>
Cc:     dhowells@redhat.com, jhubbard@nvidia.com,
        syzbot <syzbot+a440341a59e3b7142895@syzkaller.appspotmail.com>,
        davem@davemloft.net, edumazet@google.com, hch@lst.de,
        johannes@sipsolutions.net, kuba@kernel.org,
        linux-kernel@vger.kernel.org, linux-wireless@vger.kernel.org,
        netdev@vger.kernel.org, pabeni@redhat.com,
        syzkaller-bugs@googlegroups.com
Subject: Re: [syzbot] general protection fault in skb_dequeue (3)
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-ID: <1265628.1675350909.1@warthog.procyon.org.uk>
Content-Transfer-Encoding: quoted-printable
Date:   Thu, 02 Feb 2023 15:15:09 +0000
Message-ID: <1265629.1675350909@warthog.procyon.org.uk>
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

David Hildenbrand <david@redhat.com> wrote:

> At first, I wondered if that's related to shared anonymous pages getting
> pinned R/O that would trigger COW-unsharing ... but I don't even see whe=
re we
> are supposed to use FOLL_PIN vs. FOLL_GET here? IOW, we're not even supp=
osed
> to access user space memory (neither FOLL_GET nor FOLL_PIN) but still en=
d up
> with a change in behavior.

I'm not sure that using FOLL_PIN is part of the problem here.

sendfile() is creating a transient buffer attached to a pipe, doing a DIO =
read
into it (which uses iov_iter_extract_pages() to populate a bio) and then f=
eeds
the pages from the pipe one at a time using a BVEC-type iterator to a buff=
ered
write.

Note that iov_iter_extract_pages() does not pin/get pages when accessing a
BVEC, KVEC, XARRAY or PIPE iterator.  However, in this case, this should n=
ot
matter as the pipe is holding refs on the pages in the buffer.

I have found that the issue goes away if I add an extra get_page() into
iov_iter_extract_pipe_pages() and don't release it (the page is then leake=
d).

This makes me think that the problem might be due to the pages getting
recycled from the pipe before DIO has finished writing to them - but that
shouldn't be the case as the splice has to be synchronous - we can't mark =
data
in the pipe as 'produced' until we've finished reading it.

I've also turned on CONFIG_DEBUG_PAGE_REF with a twist of my own to use a =
page
flag to mark the pages of interest and only trace those pages (see attache=
d
patch) - and that consistently shows the pages being released after the bi=
o is
cleared.

Further, when it does arise, the issue only happens when two or more copie=
s of
the test program are run in parallel - which makes me wonder if truncate i=
s
implicated, except that that would have to happen inside the filesystem an=
d be
nothing to do with the pipe in the middle of sendfile().

David
--
commit 8ec9d7d951166d77e283079151b496632c290958
Author: David Howells <dhowells@redhat.com>
Date:   Fri Nov 13 13:21:01 2020 +0000

    mm: Add a page bit to trigger page_ref tracing
    =

    Add a facility to mark a page using an extra page bit so that the page=
 is
    flagged in tracing.  Also make it possible to restrict the tracepoint =
to
    only marked pages.  The mark is automatically removed when the page is
    freed.
    =

    Enable the followng:
    =

            CONFIG_DEBUG_PAGE_REF
            CONFIG_DEBUG_PAGE_MARK
            CONFIG_DEBUG_PAGE_REF_ONLY_MARKED
    =

    and then enable the page_ref tracepoints:
    =

            echo 1 >/sys/kernel/debug/tracing/events/page_ref/enable
    =

    and it shows the fate of pages created by readahead for the netfs help=
ers.
    =

    This also contains some bits to turn it on.  If you want to trace a
    filesystem other than XFS, you need to change the magic numbers in the
    patch.
    =

    Signed-off-by: David Howells <dhowells@redhat.com>

diff --git a/block/bio.c b/block/bio.c
index fc57f0aa098e..69b62ebf68ed 100644
--- a/block/bio.c
+++ b/block/bio.c
@@ -20,6 +20,7 @@
 #include <linux/blk-crypto.h>
 #include <linux/xarray.h>
 =

+#include <trace/events/page_ref.h>
 #include <trace/events/block.h>
 #include "blk.h"
 #include "blk-rq-qos.h"
@@ -1174,10 +1175,17 @@ void __bio_release_pages(struct bio *bio, bool mar=
k_dirty)
 	struct bio_vec *bvec;
 =

 	bio_for_each_segment_all(bvec, bio, iter_all) {
-		if (mark_dirty && !PageCompound(bvec->bv_page))
-			set_page_dirty_lock(bvec->bv_page);
-		bio_release_page(bio, bvec->bv_page);
+		if (PageDebugMark(bvec->bv_page))
+			trace_page_ref_set(bvec->bv_page, 999);
 	}
+
+	if (bio_flagged(bio, BIO_PAGE_REFFED) ||
+	    bio_flagged(bio, BIO_PAGE_PINNED))
+		bio_for_each_segment_all(bvec, bio, iter_all) {
+			if (mark_dirty && !PageCompound(bvec->bv_page))
+				set_page_dirty_lock(bvec->bv_page);
+			bio_release_page(bio, bvec->bv_page);
+		}
 }
 EXPORT_SYMBOL_GPL(__bio_release_pages);
 =

diff --git a/fs/splice.c b/fs/splice.c
index 5969b7a1d353..4c2f13f5d6d5 100644
--- a/fs/splice.c
+++ b/fs/splice.c
@@ -304,6 +304,7 @@ ssize_t generic_file_splice_read(struct file *in, loff=
_t *ppos,
 	int ret;
 =

 	iov_iter_pipe(&to, ITER_DEST, pipe, len);
+	to.debug =3D true;
 	init_sync_kiocb(&kiocb, in);
 	kiocb.ki_pos =3D *ppos;
 	ret =3D call_read_iter(in, &kiocb, &to);
diff --git a/include/linux/bio.h b/include/linux/bio.h
index b2c09997d79c..cafa26637067 100644
--- a/include/linux/bio.h
+++ b/include/linux/bio.h
@@ -484,8 +484,8 @@ void zero_fill_bio(struct bio *bio);
 =

 static inline void bio_release_pages(struct bio *bio, bool mark_dirty)
 {
-	if (bio_flagged(bio, BIO_PAGE_REFFED) ||
-	    bio_flagged(bio, BIO_PAGE_PINNED))
+	//if (bio_flagged(bio, BIO_PAGE_REFFED) ||
+	//    bio_flagged(bio, BIO_PAGE_PINNED))
 		__bio_release_pages(bio, mark_dirty);
 }
 =

diff --git a/include/linux/page-flags.h b/include/linux/page-flags.h
index 69e93a0c1277..80cbf784239e 100644
--- a/include/linux/page-flags.h
+++ b/include/linux/page-flags.h
@@ -138,6 +138,9 @@ enum pageflags {
 #endif
 #ifdef CONFIG_KASAN_HW_TAGS
 	PG_skip_kasan_poison,
+#endif
+#ifdef CONFIG_DEBUG_PAGE_MARK
+	PG_debug_mark,
 #endif
 	__NR_PAGEFLAGS,
 =

@@ -694,6 +697,15 @@ static __always_inline bool PageKsm(struct page *page=
)
 TESTPAGEFLAG_FALSE(Ksm, ksm)
 #endif
 =

+#ifdef CONFIG_DEBUG_PAGE_MARK
+/*
+ * Debug marks are just used for page_ref tracepoint control and display.
+ */
+PAGEFLAG(DebugMark, debug_mark, PF_ANY)
+#else
+TESTPAGEFLAG_FALSE(DebugMark, debug_mark)
+#endif
+
 u64 stable_page_flags(struct page *page);
 =

 /**
diff --git a/include/linux/page_ref.h b/include/linux/page_ref.h
index d7c2d33baa7f..7bc1a94d9cbb 100644
--- a/include/linux/page_ref.h
+++ b/include/linux/page_ref.h
@@ -24,7 +24,11 @@ DECLARE_TRACEPOINT(page_ref_unfreeze);
  *
  * See trace_##name##_enabled(void) in include/linux/tracepoint.h
  */
-#define page_ref_tracepoint_active(t) tracepoint_enabled(t)
+#ifndef CONFIG_DEBUG_PAGE_REF_ONLY_MARKED
+#define page_ref_tracepoint_active(p, t) tracepoint_enabled(t)
+#else
+#define page_ref_tracepoint_active(p, t) (tracepoint_enabled(t) && PageDe=
bugMark(p))
+#endif
 =

 extern void __page_ref_set(struct page *page, int v);
 extern void __page_ref_mod(struct page *page, int v);
@@ -36,7 +40,7 @@ extern void __page_ref_unfreeze(struct page *page, int v=
);
 =

 #else
 =

-#define page_ref_tracepoint_active(t) false
+#define page_ref_tracepoint_active(page, t) false
 =

 static inline void __page_ref_set(struct page *page, int v)
 {
@@ -97,7 +101,7 @@ static inline int page_count(const struct page *page)
 static inline void set_page_count(struct page *page, int v)
 {
 	atomic_set(&page->_refcount, v);
-	if (page_ref_tracepoint_active(page_ref_set))
+	if (page_ref_tracepoint_active(page, page_ref_set))
 		__page_ref_set(page, v);
 }
 =

@@ -118,7 +122,7 @@ static inline void init_page_count(struct page *page)
 static inline void page_ref_add(struct page *page, int nr)
 {
 	atomic_add(nr, &page->_refcount);
-	if (page_ref_tracepoint_active(page_ref_mod))
+	if (page_ref_tracepoint_active(page, page_ref_mod))
 		__page_ref_mod(page, nr);
 }
 =

@@ -130,7 +134,7 @@ static inline void folio_ref_add(struct folio *folio, =
int nr)
 static inline void page_ref_sub(struct page *page, int nr)
 {
 	atomic_sub(nr, &page->_refcount);
-	if (page_ref_tracepoint_active(page_ref_mod))
+	if (page_ref_tracepoint_active(page, page_ref_mod))
 		__page_ref_mod(page, -nr);
 }
 =

@@ -143,7 +147,7 @@ static inline int page_ref_sub_return(struct page *pag=
e, int nr)
 {
 	int ret =3D atomic_sub_return(nr, &page->_refcount);
 =

-	if (page_ref_tracepoint_active(page_ref_mod_and_return))
+	if (page_ref_tracepoint_active(page, page_ref_mod_and_return))
 		__page_ref_mod_and_return(page, -nr, ret);
 	return ret;
 }
@@ -156,7 +160,7 @@ static inline int folio_ref_sub_return(struct folio *f=
olio, int nr)
 static inline void page_ref_inc(struct page *page)
 {
 	atomic_inc(&page->_refcount);
-	if (page_ref_tracepoint_active(page_ref_mod))
+	if (page_ref_tracepoint_active(page, page_ref_mod))
 		__page_ref_mod(page, 1);
 }
 =

@@ -168,7 +172,7 @@ static inline void folio_ref_inc(struct folio *folio)
 static inline void page_ref_dec(struct page *page)
 {
 	atomic_dec(&page->_refcount);
-	if (page_ref_tracepoint_active(page_ref_mod))
+	if (page_ref_tracepoint_active(page, page_ref_mod))
 		__page_ref_mod(page, -1);
 }
 =

@@ -181,7 +185,7 @@ static inline int page_ref_sub_and_test(struct page *p=
age, int nr)
 {
 	int ret =3D atomic_sub_and_test(nr, &page->_refcount);
 =

-	if (page_ref_tracepoint_active(page_ref_mod_and_test))
+	if (page_ref_tracepoint_active(page, page_ref_mod_and_test))
 		__page_ref_mod_and_test(page, -nr, ret);
 	return ret;
 }
@@ -195,7 +199,7 @@ static inline int page_ref_inc_return(struct page *pag=
e)
 {
 	int ret =3D atomic_inc_return(&page->_refcount);
 =

-	if (page_ref_tracepoint_active(page_ref_mod_and_return))
+	if (page_ref_tracepoint_active(page, page_ref_mod_and_return))
 		__page_ref_mod_and_return(page, 1, ret);
 	return ret;
 }
@@ -209,7 +213,7 @@ static inline int page_ref_dec_and_test(struct page *p=
age)
 {
 	int ret =3D atomic_dec_and_test(&page->_refcount);
 =

-	if (page_ref_tracepoint_active(page_ref_mod_and_test))
+	if (page_ref_tracepoint_active(page, page_ref_mod_and_test))
 		__page_ref_mod_and_test(page, -1, ret);
 	return ret;
 }
@@ -223,7 +227,7 @@ static inline int page_ref_dec_return(struct page *pag=
e)
 {
 	int ret =3D atomic_dec_return(&page->_refcount);
 =

-	if (page_ref_tracepoint_active(page_ref_mod_and_return))
+	if (page_ref_tracepoint_active(page, page_ref_mod_and_return))
 		__page_ref_mod_and_return(page, -1, ret);
 	return ret;
 }
@@ -237,7 +241,7 @@ static inline bool page_ref_add_unless(struct page *pa=
ge, int nr, int u)
 {
 	bool ret =3D atomic_add_unless(&page->_refcount, nr, u);
 =

-	if (page_ref_tracepoint_active(page_ref_mod_unless))
+	if (page_ref_tracepoint_active(page, page_ref_mod_unless))
 		__page_ref_mod_unless(page, nr, ret);
 	return ret;
 }
@@ -317,7 +321,7 @@ static inline int page_ref_freeze(struct page *page, i=
nt count)
 {
 	int ret =3D likely(atomic_cmpxchg(&page->_refcount, count, 0) =3D=3D cou=
nt);
 =

-	if (page_ref_tracepoint_active(page_ref_freeze))
+	if (page_ref_tracepoint_active(page, page_ref_freeze))
 		__page_ref_freeze(page, count, ret);
 	return ret;
 }
@@ -333,7 +337,7 @@ static inline void page_ref_unfreeze(struct page *page=
, int count)
 	VM_BUG_ON(count =3D=3D 0);
 =

 	atomic_set_release(&page->_refcount, count);
-	if (page_ref_tracepoint_active(page_ref_unfreeze))
+	if (page_ref_tracepoint_active(page, page_ref_unfreeze))
 		__page_ref_unfreeze(page, count);
 }
 =

diff --git a/include/linux/uio.h b/include/linux/uio.h
index 514e3b7b06b8..89272c05d74d 100644
--- a/include/linux/uio.h
+++ b/include/linux/uio.h
@@ -45,6 +45,7 @@ struct iov_iter {
 	bool nofault;
 	bool data_source;
 	bool user_backed;
+	bool debug;
 	union {
 		size_t iov_offset;
 		int last_offset;
diff --git a/include/trace/events/mmflags.h b/include/trace/events/mmflags=
.h
index 412b5a46374c..5f3b9b0e4b53 100644
--- a/include/trace/events/mmflags.h
+++ b/include/trace/events/mmflags.h
@@ -103,6 +103,12 @@
 #define IF_HAVE_PG_SKIP_KASAN_POISON(flag,string)
 #endif
 =

+#ifdef CONFIG_DEBUG_PAGE_MARK
+#define IF_HAVE_PG_DEBUG_MARK(flag,string) ,{1UL << flag, string}
+#else
+#define IF_HAVE_PG_DEBUG_MARK(flag,string)
+#endif
+
 #define __def_pageflag_names						\
 	{1UL << PG_locked,		"locked"	},		\
 	{1UL << PG_waiters,		"waiters"	},		\
@@ -132,7 +138,8 @@ IF_HAVE_PG_IDLE(PG_young,		"young"		)		\
 IF_HAVE_PG_IDLE(PG_idle,		"idle"		)		\
 IF_HAVE_PG_ARCH_X(PG_arch_2,		"arch_2"	)		\
 IF_HAVE_PG_ARCH_X(PG_arch_3,		"arch_3"	)		\
-IF_HAVE_PG_SKIP_KASAN_POISON(PG_skip_kasan_poison, "skip_kasan_poison")
+IF_HAVE_PG_SKIP_KASAN_POISON(PG_skip_kasan_poison, "skip_kasan_poison")	\
+IF_HAVE_PG_DEBUG_MARK(PG_debug_mark,	"debug_mark"	)
 =

 #define show_page_flags(flags)						\
 	(flags) ? __print_flags(flags, "|",				\
diff --git a/lib/iov_iter.c b/lib/iov_iter.c
index d69a05950555..7ac030208a2c 100644
--- a/lib/iov_iter.c
+++ b/lib/iov_iter.c
@@ -10,9 +10,11 @@
 #include <linux/vmalloc.h>
 #include <linux/splice.h>
 #include <linux/compat.h>
+#include <linux/page-flags.h>
 #include <net/checksum.h>
 #include <linux/scatterlist.h>
 #include <linux/instrumented.h>
+#include <trace/events/page_ref.h>
 =

 #define PIPE_PARANOIA /* for now */
 =

@@ -1331,6 +1333,10 @@ static ssize_t pipe_get_pages(struct iov_iter *i,
 		struct page *page =3D append_pipe(i, left, &off);
 		if (!page)
 			break;
+		if (i->debug && !PageDebugMark(page)) {
+			//SetPageDebugMark(page);
+			get_page(page);
+		}
 		chunk =3D min_t(size_t, left, PAGE_SIZE - off);
 		get_page(*p++ =3D page);
 	}
@@ -1955,6 +1961,11 @@ static ssize_t iov_iter_extract_pipe_pages(struct i=
ov_iter *i,
 		struct page *page =3D append_pipe(i, left, &offset);
 		if (!page)
 			break;
+		if (i->debug && !PageDebugMark(page)) {
+			SetPageDebugMark(page);
+			trace_page_ref_set(page, 888);
+			//get_page(page);
+		}
 		chunk =3D min_t(size_t, left, PAGE_SIZE - offset);
 		left -=3D chunk;
 		*p++ =3D page;
diff --git a/mm/Kconfig.debug b/mm/Kconfig.debug
index fca699ad1fb0..111a946a676f 100644
--- a/mm/Kconfig.debug
+++ b/mm/Kconfig.debug
@@ -149,6 +149,23 @@ config DEBUG_PAGE_REF
 	  kernel code.  However the runtime performance overhead is virtually
 	  nil until the tracepoints are actually enabled.
 =

+config DEBUG_PAGE_MARK
+	bool "Reserve a page bit to mark pages to be debugged"
+	depends on DEBUG_PAGE_REF
+	help
+	  This option adds an extra page flag that can be used to mark pages
+	  for debugging.  The mark can be observed in the page_ref tracepoints.
+	  The mark isn't set on any pages without alteration of the code.  This
+	  is intended for filesystem debugging and code to set the mark must be
+	  added manually into the source.
+
+config DEBUG_PAGE_REF_ONLY_MARKED
+	bool "Only trace marked pages"
+	depends on DEBUG_PAGE_REF && DEBUG_PAGE_MARK
+	help
+	  This option restricts the page_ref tracepoints to only track marked
+	  pages.
+
 config DEBUG_RODATA_TEST
     bool "Testcase for the marking rodata read-only"
     depends on STRICT_KERNEL_RWX
diff --git a/mm/page_alloc.c b/mm/page_alloc.c
index 0745aedebb37..37f146e5b2eb 100644
--- a/mm/page_alloc.c
+++ b/mm/page_alloc.c
@@ -1102,6 +1102,9 @@ static inline void __free_one_page(struct page *page=
,
 =

 	VM_BUG_ON(!zone_is_initialized(zone));
 	VM_BUG_ON_PAGE(page->flags & PAGE_FLAGS_CHECK_AT_PREP, page);
+#ifdef CONFIG_DEBUG_PAGE_MARK
+	ClearPageDebugMark(page);
+#endif
 =

 	VM_BUG_ON(migratetype =3D=3D -1);
 	if (likely(!is_migrate_isolate(migratetype)))
diff --git a/mm/readahead.c b/mm/readahead.c
index b10f0cf81d80..c5558daf3a56 100644
--- a/mm/readahead.c
+++ b/mm/readahead.c
@@ -248,6 +248,10 @@ void page_cache_ra_unbounded(struct readahead_control=
 *ractl,
 		folio =3D filemap_alloc_folio(gfp_mask, 0);
 		if (!folio)
 			break;
+#define XFS_SUPER_MAGIC 0x58465342	/* "XFSB" */
+		if (mapping->host->i_sb->s_magic =3D=3D XFS_SUPER_MAGIC)
+			folio_set_debug_mark(folio);
+
 		if (filemap_add_folio(mapping, folio, index + i,
 					gfp_mask) < 0) {
 			folio_put(folio);
@@ -809,6 +813,7 @@ void readahead_expand(struct readahead_control *ractl,
 		page =3D __page_cache_alloc(gfp_mask);
 		if (!page)
 			return;
+		//SetPageDebugMark(page);
 		if (add_to_page_cache_lru(page, mapping, index, gfp_mask) < 0) {
 			put_page(page);
 			return;
@@ -832,6 +837,7 @@ void readahead_expand(struct readahead_control *ractl,
 		page =3D __page_cache_alloc(gfp_mask);
 		if (!page)
 			return;
+		//SetPageDebugMark(page);
 		if (add_to_page_cache_lru(page, mapping, index, gfp_mask) < 0) {
 			put_page(page);
 			return;

