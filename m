Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 15BDE6F3AE8
	for <lists+netdev@lfdr.de>; Tue,  2 May 2023 01:14:23 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233251AbjEAXOT (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 1 May 2023 19:14:19 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:46658 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233268AbjEAXOL (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 1 May 2023 19:14:11 -0400
Received: from mail-wm1-x332.google.com (mail-wm1-x332.google.com [IPv6:2a00:1450:4864:20::332])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id D32E430D6;
        Mon,  1 May 2023 16:14:05 -0700 (PDT)
Received: by mail-wm1-x332.google.com with SMTP id 5b1f17b1804b1-3f173af665fso17773825e9.3;
        Mon, 01 May 2023 16:14:05 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20221208; t=1682982845; x=1685574845;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to;
        bh=wRhgM2f/NNBjKearO/NDkRN71s+dJvkB6KmKE0+fglE=;
        b=h3d1JCm3iW2z0aACklXgWWCO4MKQczbrEYZLhV5UTGlqwNU8+x2a69SksVV6fFkkpP
         9OJUQfPoggG8g3z5O3KVuR98nqBLvmYUuaC0a4izUN5LxTigM0Z0rh99VXcLo8b/U6B/
         5tnFNzZJL7o+g+IwfpqOsNe/86z3439mfh6kYR5oFwkYBWpY69ip3Uymuu57feZ35hKV
         kckLQGI1b0jAAXB3APjiwpkcOah/gHMq6g7Jqn8tOBUWE/LrW5oyBd/4Heqdw5T5AljL
         ngo4witQc1CDkb3PRIuQiYsupzYeglyFVKiBv2m7g+XftXRrWSLTJcyuI7O9xCwgRkmf
         lC5g==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20221208; t=1682982845; x=1685574845;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=wRhgM2f/NNBjKearO/NDkRN71s+dJvkB6KmKE0+fglE=;
        b=YyXM1oEXh4S8jzFqHRn775ddbQiGKaZo6/xhy5Cl4tPq/Xy9roGrG6KyV17MAI/y6A
         zsefGEaEoX9wsgPYRM60GAfTfp6XTMh8P4TQ2uxXeWU0/rv/IgCttMD/k+WwOYjzy1g7
         RLVL5gKfvyfMoWxxPmqGxY1GfXNli3G82iOW8ecXpJaptkQFngEFU08b6cEXyAutzVcz
         v9vhG0jyH4yWbo9FFMSaFq83UU5C4vCbrZ3TedOd3L84d+DxxPLMWgxHnrXVUZrQQrGT
         J6RbvwOzO2QZI8/x16AfDs+anQIdmWDmFto0rP/icf/fS18cfY1pYQl37AbRRL1KDuIf
         UPUA==
X-Gm-Message-State: AC+VfDz3+Rz1XtpEKdMDsnaRsEqWf5ojuyTQD2tx2Lsrbm0g7tPq8Yq1
        JOFmG0OUTyV/bdchZyqCZEw=
X-Google-Smtp-Source: ACHHUZ5YTZK8t09/4JtEs4EDGQIt2XfYUtCcZjnm3hRXzBTIlHBQPbU9q8wthFbfrn9ldV69FnkQ7Q==
X-Received: by 2002:a7b:c408:0:b0:3eb:42fc:fb30 with SMTP id k8-20020a7bc408000000b003eb42fcfb30mr10475842wmi.32.1682982845060;
        Mon, 01 May 2023 16:14:05 -0700 (PDT)
Received: from lucifer.home (host86-156-84-164.range86-156.btcentralplus.com. [86.156.84.164])
        by smtp.googlemail.com with ESMTPSA id v9-20020a05600c444900b003f173be2ccfsm48948904wmn.2.2023.05.01.16.14.02
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 01 May 2023 16:14:04 -0700 (PDT)
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
        Lorenzo Stoakes <lstoakes@gmail.com>
Subject: [PATCH v6 3/3] mm/gup: disallow FOLL_LONGTERM GUP-fast writing to file-backed mappings
Date:   Tue,  2 May 2023 00:11:49 +0100
Message-Id: <dee4f4ad6532b0f94d073da263526de334d5d7e0.1682981880.git.lstoakes@gmail.com>
X-Mailer: git-send-email 2.40.1
In-Reply-To: <cover.1682981880.git.lstoakes@gmail.com>
References: <cover.1682981880.git.lstoakes@gmail.com>
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
disabled. However, other architectures which specify
CONFIG_MMU_GATHER_RCU_TABLE_FREE use an RCU lock for this operation.

In these instances, we acquire an RCU lock while performing our checks. If
we cannot get a stable mapping, we fall back to the slow path, as otherwise
we'd have to walk the page tables again and it's simpler and more effective
to just fall back.

It's important to note that there are no APIs allowing users to specify
FOLL_FAST_ONLY for a PUP-fast let alone with FOLL_LONGTERM, so we can
always rely on the fact that if we fail to pin on the fast path, the code
will fall back to the slow path which can perform the more thorough check.

Suggested-by: David Hildenbrand <david@redhat.com>
Suggested-by: Kirill A . Shutemov <kirill@shutemov.name>
Signed-off-by: Lorenzo Stoakes <lstoakes@gmail.com>
---
 mm/gup.c | 87 ++++++++++++++++++++++++++++++++++++++++++++++++++++++--
 1 file changed, 85 insertions(+), 2 deletions(-)

diff --git a/mm/gup.c b/mm/gup.c
index 0f09dec0906c..431618048a03 100644
--- a/mm/gup.c
+++ b/mm/gup.c
@@ -18,6 +18,7 @@
 #include <linux/migrate.h>
 #include <linux/mm_inline.h>
 #include <linux/sched/mm.h>
+#include <linux/shmem_fs.h>
 
 #include <asm/mmu_context.h>
 #include <asm/tlbflush.h>
@@ -95,6 +96,77 @@ static inline struct folio *try_get_folio(struct page *page, int refs)
 	return folio;
 }
 
+#ifdef CONFIG_MMU_GATHER_RCU_TABLE_FREE
+static bool stabilise_mapping_rcu(struct folio *folio)
+{
+	struct address_space *mapping = READ_ONCE(folio->mapping);
+
+	rcu_read_lock();
+
+	return mapping == READ_ONCE(folio->mapping);
+}
+
+static void unlock_rcu(void)
+{
+	rcu_read_unlock();
+}
+#else
+static bool stabilise_mapping_rcu(struct folio *)
+{
+	return true;
+}
+
+static void unlock_rcu(void)
+{
+}
+#endif
+
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
+ *
+ * The folio is stable, but the mapping might not be. When truncating for
+ * instance, a zap is performed which triggers TLB shootdown. IRQs are disabled
+ * so we are safe from an IPI, but some architectures use an RCU lock for this
+ * operation, so we acquire an RCU lock to ensure the mapping is stable.
+ */
+static bool folio_longterm_write_pin_allowed(struct folio *folio)
+{
+	bool ret;
+
+	/* hugetlb mappings do not require dirty tracking. */
+	if (folio_test_hugetlb(folio))
+		return true;
+
+	if (stabilise_mapping_rcu(folio)) {
+		struct address_space *mapping = folio_mapping(folio);
+
+		/*
+		 * Neither anonymous nor shmem-backed folios require
+		 * dirty tracking.
+		 */
+		ret = folio_test_anon(folio) ||
+			(mapping && shmem_mapping(mapping));
+	} else {
+		/* If the mapping is unstable, fallback to the slow path. */
+		ret = false;
+	}
+
+	unlock_rcu();
+
+	return ret;
+}
+
 /**
  * try_grab_folio() - Attempt to get or pin a folio.
  * @page:  pointer to page to be grabbed
@@ -123,6 +195,8 @@ static inline struct folio *try_get_folio(struct page *page, int refs)
  */
 struct folio *try_grab_folio(struct page *page, int refs, unsigned int flags)
 {
+	bool is_longterm = flags & FOLL_LONGTERM;
+
 	if (unlikely(!(flags & FOLL_PCI_P2PDMA) && is_pci_p2pdma_page(page)))
 		return NULL;
 
@@ -136,8 +210,7 @@ struct folio *try_grab_folio(struct page *page, int refs, unsigned int flags)
 		 * right zone, so fail and let the caller fall back to the slow
 		 * path.
 		 */
-		if (unlikely((flags & FOLL_LONGTERM) &&
-			     !is_longterm_pinnable_page(page)))
+		if (unlikely(is_longterm && !is_longterm_pinnable_page(page)))
 			return NULL;
 
 		/*
@@ -148,6 +221,16 @@ struct folio *try_grab_folio(struct page *page, int refs, unsigned int flags)
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

