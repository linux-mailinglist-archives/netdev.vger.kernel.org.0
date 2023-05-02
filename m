Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id BDC676F4860
	for <lists+netdev@lfdr.de>; Tue,  2 May 2023 18:34:35 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234203AbjEBQec (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 2 May 2023 12:34:32 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:55922 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S234105AbjEBQeV (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 2 May 2023 12:34:21 -0400
Received: from mail-wr1-x42d.google.com (mail-wr1-x42d.google.com [IPv6:2a00:1450:4864:20::42d])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 8005A1BD6;
        Tue,  2 May 2023 09:34:19 -0700 (PDT)
Received: by mail-wr1-x42d.google.com with SMTP id ffacd0b85a97d-2f7db354092so2518925f8f.2;
        Tue, 02 May 2023 09:34:19 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20221208; t=1683045258; x=1685637258;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to;
        bh=JD+whRS851erhVVABMqdG0VTRc0I6Z1rUQ+rUiOFVdo=;
        b=LOnfftTmcJ81+iwcBByQXB7Ir64O4Y1k4pQkOcPV6TI0bAkgfp3UaIZJ+zuRf48mH+
         sKQ+qJFhhAT+ExIv4raZCe4Y7g6YIyog7zt61v/DO+Fa7aU1K2QXQwuKAeXJn8SIoYiB
         W4rnS2m03quL9SZbgo+gI56ky1WuHrcAT7sa4wKL20+7gCA8GdMCVBH1cDnLcEb6fDXA
         c27XUVFOEl1cVsIdPhrXIdFzaWhtobeae2CFGmZSQpcLNg81bdYOgyqtNdKwNp+4Ve3p
         UgEWWsgUHsHxSNWn8K/VU+Ldw1J4kZz6hnohQGiLK02HgtBSbtURRyI2GNirMOgnJNRQ
         Xo9Q==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20221208; t=1683045258; x=1685637258;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=JD+whRS851erhVVABMqdG0VTRc0I6Z1rUQ+rUiOFVdo=;
        b=Dece9Vz5wPLUHVgLqyDpFGQWlVv8o2HMu5YG49Mlm0ffjprVnC3qZb8zT6QJMR425L
         ZTG+CSOg7LXklGF/ZhEcZcEHLm2JB19son1WnZfpsqx64I2sKvPg77imQAOrOHG0OkwB
         pkHSllyu0RT1/L7mYlNKsHQ/QuoWjfYhVjfdyDwJc7aQUWB/G9Qb8LZwLENUphqR6s9D
         /kq9q5Gns1IxNc0rUcaNPqMV2SWylKRV1F72T9Ceql+H23e8sjJePtX1ZyStcl67gCoO
         14mu8wgXq8yQ19Sh1vxrPeviizBiriF7gcNEzg9bHc84N8d+DnfhJhPQ+Z8b6kQ6aL9N
         5OHQ==
X-Gm-Message-State: AC+VfDxZ2tnWkkp4+dZOZPs8vHUQOHa24rtTle0o5rV/CMyrKakPUyjo
        /2gAXynFGBWo8FrB5d++E1I=
X-Google-Smtp-Source: ACHHUZ71Yj6T5jkZc/shg2Kn5A9sybaTNToTec3q07n6D5PpB37fQKAx38VozXIWishADRjyKrMnbg==
X-Received: by 2002:adf:edcf:0:b0:306:2cd4:b01b with SMTP id v15-20020adfedcf000000b003062cd4b01bmr5305262wro.37.1683045257681;
        Tue, 02 May 2023 09:34:17 -0700 (PDT)
Received: from lucifer.home (host86-156-84-164.range86-156.btcentralplus.com. [86.156.84.164])
        by smtp.googlemail.com with ESMTPSA id b10-20020a5d550a000000b0030639a86f9dsm1789919wrv.51.2023.05.02.09.34.15
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 02 May 2023 09:34:17 -0700 (PDT)
From:   Lorenzo Stoakes <lstoakes@gmail.com>
To:     linux-mm@kvack.org, linux-kernel@vger.kernel.org,
        Andrew Morton <akpm@linux-foundation.org>
Cc:     Jason Gunthorpe <jgg@ziepe.ca>, Jens Axboe <axboe@kernel.dk>,
        Matthew Wilcox <willy@infradead.org>,
        Dennis Dalessandro <dennis.dalessandro@cornelisnetworks.com>,
        Leon Romanovsky <leon@kernel.org>,
        Christian Benvenuti <benve@cisco.com>,
        Nelson Escobar <neescoba@cisco.com>,
        Bernard Metzler <bmt@zurich.ibm.com>,
        Peter Zijlstra <peterz@infradead.org>,
        Ingo Molnar <mingo@redhat.com>,
        Arnaldo Carvalho de Melo <acme@kernel.org>,
        Mark Rutland <mark.rutland@arm.com>,
        Alexander Shishkin <alexander.shishkin@linux.intel.com>,
        Jiri Olsa <jolsa@kernel.org>,
        Namhyung Kim <namhyung@kernel.org>,
        Ian Rogers <irogers@google.com>,
        Adrian Hunter <adrian.hunter@intel.com>,
        Bjorn Topel <bjorn@kernel.org>,
        Magnus Karlsson <magnus.karlsson@intel.com>,
        Maciej Fijalkowski <maciej.fijalkowski@intel.com>,
        Jonathan Lemon <jonathan.lemon@gmail.com>,
        "David S . Miller" <davem@davemloft.net>,
        Eric Dumazet <edumazet@google.com>,
        Jakub Kicinski <kuba@kernel.org>,
        Paolo Abeni <pabeni@redhat.com>,
        Christian Brauner <brauner@kernel.org>,
        Richard Cochran <richardcochran@gmail.com>,
        Alexei Starovoitov <ast@kernel.org>,
        Daniel Borkmann <daniel@iogearbox.net>,
        Jesper Dangaard Brouer <hawk@kernel.org>,
        John Fastabend <john.fastabend@gmail.com>,
        linux-fsdevel@vger.kernel.org, linux-perf-users@vger.kernel.org,
        netdev@vger.kernel.org, bpf@vger.kernel.org,
        Oleg Nesterov <oleg@redhat.com>,
        Jason Gunthorpe <jgg@nvidia.com>,
        John Hubbard <jhubbard@nvidia.com>, Jan Kara <jack@suse.cz>,
        "Kirill A . Shutemov" <kirill@shutemov.name>,
        Pavel Begunkov <asml.silence@gmail.com>,
        Mika Penttila <mpenttil@redhat.com>,
        David Hildenbrand <david@redhat.com>,
        Dave Chinner <david@fromorbit.com>,
        Theodore Ts'o <tytso@mit.edu>, Peter Xu <peterx@redhat.com>,
        Matthew Rosato <mjrosato@linux.ibm.com>,
        "Paul E . McKenney" <paulmck@kernel.org>,
        Christian Borntraeger <borntraeger@linux.ibm.com>,
        Lorenzo Stoakes <lstoakes@gmail.com>
Subject: [PATCH v7 3/3] mm/gup: disallow FOLL_LONGTERM GUP-fast writing to file-backed mappings
Date:   Tue,  2 May 2023 17:34:05 +0100
Message-Id: <b3a4441cade9770e00d24f5ecb75c8f4481785a4.1683044162.git.lstoakes@gmail.com>
X-Mailer: git-send-email 2.40.1
In-Reply-To: <cover.1683044162.git.lstoakes@gmail.com>
References: <cover.1683044162.git.lstoakes@gmail.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,FREEMAIL_FROM,
        RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Writing to file-backed dirty-tracked mappings via GUP is inherently broken
as we cannot rule out folios being cleaned and then a GUP user writing to
them again and possibly marking them dirty unexpectedly.

This is especially egregious for long-term mappings (as indicated by the
use of the FOLL_LONGTERM flag), so we disallow this case in GUP-fast as
we have already done in the slow path.

We have access to less information in the fast path as we cannot examine
the VMA containing the mapping, however we can determine whether the folio
is anonymous and then whitelist known-good mappings - specifically hugetlb
and shmem mappings.

While we obtain a stable folio for this check, the mapping might not be, as
a truncate could nullify it at any time. Since doing so requires mappings
to be zapped, we can synchronise against a TLB shootdown operation.

For some architectures TLB shootdown is synchronised by IPI, against which
we are protected as the GUP-fast operation is performed with interrupts
disabled. Equally, we are protected from architectures which specify
CONFIG_MMU_GATHER_RCU_TABLE_FREE as the interrupts being disabled imply an
RCU lock as well.

We whitelist anonymous mappings (and those which otherwise do not have a
valid mapping), shmem and hugetlb mappings, none of which require dirty
tracking so are safe to long-term pin.

It's important to note that there are no APIs allowing users to specify
FOLL_FAST_ONLY for a PUP-fast let alone with FOLL_LONGTERM, so we can
always rely on the fact that if we fail to pin on the fast path, the code
will fall back to the slow path which can perform the more thorough check.

Suggested-by: David Hildenbrand <david@redhat.com>
Suggested-by: Kirill A . Shutemov <kirill@shutemov.name>
Suggested-by: Peter Zijlstra <peterz@infradead.org>
Signed-off-by: Lorenzo Stoakes <lstoakes@gmail.com>
---
 mm/gup.c | 62 ++++++++++++++++++++++++++++++++++++++++++++++++++++++--
 1 file changed, 60 insertions(+), 2 deletions(-)

diff --git a/mm/gup.c b/mm/gup.c
index 6e209ca10967..93b4aa39e5a5 100644
--- a/mm/gup.c
+++ b/mm/gup.c
@@ -18,6 +18,7 @@
 #include <linux/migrate.h>
 #include <linux/mm_inline.h>
 #include <linux/sched/mm.h>
+#include <linux/shmem_fs.h>
 
 #include <asm/mmu_context.h>
 #include <asm/tlbflush.h>
@@ -95,6 +96,52 @@ static inline struct folio *try_get_folio(struct page *page, int refs)
 	return folio;
 }
 
+/*
+ * Used in the GUP-fast path to determine whether a FOLL_PIN | FOLL_LONGTERM |
+ * FOLL_WRITE pin is permitted for a specific folio.
+ *
+ * This assumes the folio is stable and pinned.
+ *
+ * Writing to pinned file-backed dirty tracked folios is inherently problematic
+ * (see comment describing the writeable_file_mapping_allowed() function). We
+ * therefore try to avoid the most egregious case of a long-term mapping doing
+ * so.
+ *
+ * This function cannot be as thorough as that one as the VMA is not available
+ * in the fast path, so instead we whitelist known good cases.
+ */
+static bool folio_longterm_write_pin_allowed(struct folio *folio)
+{
+	struct address_space *mapping;
+
+	/*
+	 * GUP-fast disables IRQs - this prevents IPIs from causing page tables
+	 * to disappear from under us, as well as preventing RCU grace periods
+	 * from making progress (i.e. implying rcu_read_lock()).
+	 *
+	 * This means we can rely on the folio remaining stable for all
+	 * architectures, both those that set CONFIG_MMU_GATHER_RCU_TABLE_FREE
+	 * and those that do not.
+	 *
+	 * We get the added benefit that given inodes, and thus address_space,
+	 * objects are RCU freed, we can rely on the mapping remaining stable
+	 * here with no risk of a truncation or similar race.
+	 */
+	lockdep_assert_irqs_disabled();
+
+	/*
+	 * If no mapping can be found, this implies an anonymous or otherwise
+	 * non-file backed folio so in this instance we permit the pin.
+	 *
+	 * shmem and hugetlb mappings do not require dirty-tracking so we
+	 * explicitly whitelist these.
+	 *
+	 * Other non dirty-tracked folios will be picked up on the slow path.
+	 */
+	mapping = folio_mapping(folio);
+	return !mapping || shmem_mapping(mapping) || folio_test_hugetlb(folio);
+}
+
 /**
  * try_grab_folio() - Attempt to get or pin a folio.
  * @page:  pointer to page to be grabbed
@@ -123,6 +170,8 @@ static inline struct folio *try_get_folio(struct page *page, int refs)
  */
 struct folio *try_grab_folio(struct page *page, int refs, unsigned int flags)
 {
+	bool is_longterm = flags & FOLL_LONGTERM;
+
 	if (unlikely(!(flags & FOLL_PCI_P2PDMA) && is_pci_p2pdma_page(page)))
 		return NULL;
 
@@ -136,8 +185,7 @@ struct folio *try_grab_folio(struct page *page, int refs, unsigned int flags)
 		 * right zone, so fail and let the caller fall back to the slow
 		 * path.
 		 */
-		if (unlikely((flags & FOLL_LONGTERM) &&
-			     !is_longterm_pinnable_page(page)))
+		if (unlikely(is_longterm && !is_longterm_pinnable_page(page)))
 			return NULL;
 
 		/*
@@ -148,6 +196,16 @@ struct folio *try_grab_folio(struct page *page, int refs, unsigned int flags)
 		if (!folio)
 			return NULL;
 
+		/*
+		 * Can this folio be safely pinned? We need to perform this
+		 * check after the folio is stabilised.
+		 */
+		if ((flags & FOLL_WRITE) && is_longterm &&
+		    !folio_longterm_write_pin_allowed(folio)) {
+			folio_put_refs(folio, refs);
+			return NULL;
+		}
+
 		/*
 		 * When pinning a large folio, use an exact count to track it.
 		 *
-- 
2.40.1

