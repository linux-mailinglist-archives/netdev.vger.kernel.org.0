Return-Path: <netdev+bounces-49-lists+netdev=lfdr.de@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [IPv6:2604:1380:45e3:2400::1])
	by mail.lfdr.de (Postfix) with ESMTPS id 7430D6F4EC9
	for <lists+netdev@lfdr.de>; Wed,  3 May 2023 04:18:29 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id 17772280D59
	for <lists+netdev@lfdr.de>; Wed,  3 May 2023 02:18:28 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 01625805;
	Wed,  3 May 2023 02:18:26 +0000 (UTC)
X-Original-To: netdev@vger.kernel.org
Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 5D09B7E
	for <netdev@vger.kernel.org>; Wed,  3 May 2023 02:18:24 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 53C81C433D2;
	Wed,  3 May 2023 02:18:22 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
	s=korg; t=1683080304;
	bh=Xmt51HxGX9w7I26oXyzXEA9RUwzh1L+7hsYlH4OpXLE=;
	h=Date:From:To:Cc:Subject:In-Reply-To:References:From;
	b=f39fPxBDGnTUgpaTxjZQeKkZ/zVq1v4h9KI/nLBuGHAWPh0cfBRqLnxPBrGGeq5Xx
	 MuO0qydl1QN6zffGi617yVLvREx5SmNpZLWAiZcik9b+NZNIlX/3zDhzOPcC773irR
	 iOis4Hz6xH16ikl/K7F7qUn7Hj3rSznIi4h8HDeE=
Date: Tue, 2 May 2023 19:18:21 -0700
From: Andrew Morton <akpm@linux-foundation.org>
To: Lorenzo Stoakes <lstoakes@gmail.com>
Cc: linux-mm@kvack.org, linux-kernel@vger.kernel.org, Jason Gunthorpe
 <jgg@ziepe.ca>, Jens Axboe <axboe@kernel.dk>, Matthew Wilcox
 <willy@infradead.org>, Dennis Dalessandro
 <dennis.dalessandro@cornelisnetworks.com>, Leon Romanovsky
 <leon@kernel.org>, Christian Benvenuti <benve@cisco.com>, Nelson Escobar
 <neescoba@cisco.com>, Bernard Metzler <bmt@zurich.ibm.com>, Peter Zijlstra
 <peterz@infradead.org>, Ingo Molnar <mingo@redhat.com>, Arnaldo Carvalho de
 Melo <acme@kernel.org>, Mark Rutland <mark.rutland@arm.com>, Alexander
 Shishkin <alexander.shishkin@linux.intel.com>, Jiri Olsa
 <jolsa@kernel.org>, Namhyung Kim <namhyung@kernel.org>, Ian Rogers
 <irogers@google.com>, Adrian Hunter <adrian.hunter@intel.com>, Bjorn Topel
 <bjorn@kernel.org>, Magnus Karlsson <magnus.karlsson@intel.com>, Maciej
 Fijalkowski <maciej.fijalkowski@intel.com>, Jonathan Lemon
 <jonathan.lemon@gmail.com>, "David S . Miller" <davem@davemloft.net>, Eric
 Dumazet <edumazet@google.com>, Jakub Kicinski <kuba@kernel.org>, Paolo
 Abeni <pabeni@redhat.com>, Christian Brauner <brauner@kernel.org>, Richard
 Cochran <richardcochran@gmail.com>, Alexei Starovoitov <ast@kernel.org>,
 Daniel Borkmann <daniel@iogearbox.net>, Jesper Dangaard Brouer
 <hawk@kernel.org>, John Fastabend <john.fastabend@gmail.com>,
 linux-fsdevel@vger.kernel.org, linux-perf-users@vger.kernel.org,
 netdev@vger.kernel.org, bpf@vger.kernel.org, Oleg Nesterov
 <oleg@redhat.com>, Jason Gunthorpe <jgg@nvidia.com>, John Hubbard
 <jhubbard@nvidia.com>, Jan Kara <jack@suse.cz>, "Kirill A . Shutemov"
 <kirill@shutemov.name>, Pavel Begunkov <asml.silence@gmail.com>, Mika
 Penttila <mpenttil@redhat.com>, David Hildenbrand <david@redhat.com>, Dave
 Chinner <david@fromorbit.com>, Theodore Ts'o <tytso@mit.edu>, Peter Xu
 <peterx@redhat.com>, Matthew Rosato <mjrosato@linux.ibm.com>,
 "Paul E . McKenney" <paulmck@kernel.org>, Christian Borntraeger
 <borntraeger@linux.ibm.com>
Subject: Re: [PATCH v8 3/3] mm/gup: disallow FOLL_LONGTERM GUP-fast writing
 to file-backed mappings
Message-Id: <20230502191821.71c86a2c25f19fe342aa72db@linux-foundation.org>
In-Reply-To: <a690186fc37e1ea92556a7dbd0887fe201fcc709.1683067198.git.lstoakes@gmail.com>
References: <cover.1683067198.git.lstoakes@gmail.com>
	<a690186fc37e1ea92556a7dbd0887fe201fcc709.1683067198.git.lstoakes@gmail.com>
X-Mailer: Sylpheed 3.7.0 (GTK+ 2.24.33; x86_64-pc-linux-gnu)
Precedence: bulk
X-Mailing-List: netdev@vger.kernel.org
List-Id: <netdev.vger.kernel.org>
List-Subscribe: <mailto:netdev+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:netdev+unsubscribe@vger.kernel.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit

On Tue,  2 May 2023 23:51:35 +0100 Lorenzo Stoakes <lstoakes@gmail.com> wrote:

> Writing to file-backed dirty-tracked mappings via GUP is inherently broken
> as we cannot rule out folios being cleaned and then a GUP user writing to
> them again and possibly marking them dirty unexpectedly.
> 
> This is especially egregious for long-term mappings (as indicated by the
> use of the FOLL_LONGTERM flag), so we disallow this case in GUP-fast as
> we have already done in the slow path.
> 
> We have access to less information in the fast path as we cannot examine
> the VMA containing the mapping, however we can determine whether the folio
> is anonymous or belonging to a whitelisted filesystem - specifically
> hugetlb and shmem mappings.
> 
> We take special care to ensure that both the folio and mapping are safe to
> access when performing these checks and document folio_fast_pin_allowed()
> accordingly.
> 
> It's important to note that there are no APIs allowing users to specify
> FOLL_FAST_ONLY for a PUP-fast let alone with FOLL_LONGTERM, so we can
> always rely on the fact that if we fail to pin on the fast path, the code
> will fall back to the slow path which can perform the more thorough check.

arm allnoconfig said

mm/gup.c:115:13: warning: 'folio_fast_pin_allowed' defined but not used [-Wunused-function]
  115 | static bool folio_fast_pin_allowed(struct folio *folio, unsigned int flags)
      |             ^~~~~~~~~~~~~~~~~~~~~~

so I moved the definition inside CONFIG_ARCH_HAS_PTE_SPECIAL.



 mm/gup.c |  154 ++++++++++++++++++++++++++---------------------------
 1 file changed, 77 insertions(+), 77 deletions(-)

--- a/mm/gup.c~mm-gup-disallow-foll_longterm-gup-fast-writing-to-file-backed-mappings-fix
+++ a/mm/gup.c
@@ -96,83 +96,6 @@ retry:
 	return folio;
 }
 
-/*
- * Used in the GUP-fast path to determine whether a pin is permitted for a
- * specific folio.
- *
- * This call assumes the caller has pinned the folio, that the lowest page table
- * level still points to this folio, and that interrupts have been disabled.
- *
- * Writing to pinned file-backed dirty tracked folios is inherently problematic
- * (see comment describing the writable_file_mapping_allowed() function). We
- * therefore try to avoid the most egregious case of a long-term mapping doing
- * so.
- *
- * This function cannot be as thorough as that one as the VMA is not available
- * in the fast path, so instead we whitelist known good cases and if in doubt,
- * fall back to the slow path.
- */
-static bool folio_fast_pin_allowed(struct folio *folio, unsigned int flags)
-{
-	struct address_space *mapping;
-	unsigned long mapping_flags;
-
-	/*
-	 * If we aren't pinning then no problematic write can occur. A long term
-	 * pin is the most egregious case so this is the one we disallow.
-	 */
-	if ((flags & (FOLL_PIN | FOLL_LONGTERM | FOLL_WRITE)) !=
-	    (FOLL_PIN | FOLL_LONGTERM | FOLL_WRITE))
-		return true;
-
-	/* The folio is pinned, so we can safely access folio fields. */
-
-	/* Neither of these should be possible, but check to be sure. */
-	if (unlikely(folio_test_slab(folio) || folio_test_swapcache(folio)))
-		return false;
-
-	/* hugetlb mappings do not require dirty-tracking. */
-	if (folio_test_hugetlb(folio))
-		return true;
-
-	/*
-	 * GUP-fast disables IRQs. When IRQS are disabled, RCU grace periods
-	 * cannot proceed, which means no actions performed under RCU can
-	 * proceed either.
-	 *
-	 * inodes and thus their mappings are freed under RCU, which means the
-	 * mapping cannot be freed beneath us and thus we can safely dereference
-	 * it.
-	 */
-	lockdep_assert_irqs_disabled();
-
-	/*
-	 * However, there may be operations which _alter_ the mapping, so ensure
-	 * we read it once and only once.
-	 */
-	mapping = READ_ONCE(folio->mapping);
-
-	/*
-	 * The mapping may have been truncated, in any case we cannot determine
-	 * if this mapping is safe - fall back to slow path to determine how to
-	 * proceed.
-	 */
-	if (!mapping)
-		return false;
-
-	/* Anonymous folios are fine, other non-file backed cases are not. */
-	mapping_flags = (unsigned long)mapping & PAGE_MAPPING_FLAGS;
-	if (mapping_flags)
-		return mapping_flags == PAGE_MAPPING_ANON;
-
-	/*
-	 * At this point, we know the mapping is non-null and points to an
-	 * address_space object. The only remaining whitelisted file system is
-	 * shmem.
-	 */
-	return shmem_mapping(mapping);
-}
-
 /**
  * try_grab_folio() - Attempt to get or pin a folio.
  * @page:  pointer to page to be grabbed
@@ -2474,6 +2397,83 @@ static void __maybe_unused undo_dev_page
 
 #ifdef CONFIG_ARCH_HAS_PTE_SPECIAL
 /*
+ * Used in the GUP-fast path to determine whether a pin is permitted for a
+ * specific folio.
+ *
+ * This call assumes the caller has pinned the folio, that the lowest page table
+ * level still points to this folio, and that interrupts have been disabled.
+ *
+ * Writing to pinned file-backed dirty tracked folios is inherently problematic
+ * (see comment describing the writable_file_mapping_allowed() function). We
+ * therefore try to avoid the most egregious case of a long-term mapping doing
+ * so.
+ *
+ * This function cannot be as thorough as that one as the VMA is not available
+ * in the fast path, so instead we whitelist known good cases and if in doubt,
+ * fall back to the slow path.
+ */
+static bool folio_fast_pin_allowed(struct folio *folio, unsigned int flags)
+{
+	struct address_space *mapping;
+	unsigned long mapping_flags;
+
+	/*
+	 * If we aren't pinning then no problematic write can occur. A long term
+	 * pin is the most egregious case so this is the one we disallow.
+	 */
+	if ((flags & (FOLL_PIN | FOLL_LONGTERM | FOLL_WRITE)) !=
+	    (FOLL_PIN | FOLL_LONGTERM | FOLL_WRITE))
+		return true;
+
+	/* The folio is pinned, so we can safely access folio fields. */
+
+	/* Neither of these should be possible, but check to be sure. */
+	if (unlikely(folio_test_slab(folio) || folio_test_swapcache(folio)))
+		return false;
+
+	/* hugetlb mappings do not require dirty-tracking. */
+	if (folio_test_hugetlb(folio))
+		return true;
+
+	/*
+	 * GUP-fast disables IRQs. When IRQS are disabled, RCU grace periods
+	 * cannot proceed, which means no actions performed under RCU can
+	 * proceed either.
+	 *
+	 * inodes and thus their mappings are freed under RCU, which means the
+	 * mapping cannot be freed beneath us and thus we can safely dereference
+	 * it.
+	 */
+	lockdep_assert_irqs_disabled();
+
+	/*
+	 * However, there may be operations which _alter_ the mapping, so ensure
+	 * we read it once and only once.
+	 */
+	mapping = READ_ONCE(folio->mapping);
+
+	/*
+	 * The mapping may have been truncated, in any case we cannot determine
+	 * if this mapping is safe - fall back to slow path to determine how to
+	 * proceed.
+	 */
+	if (!mapping)
+		return false;
+
+	/* Anonymous folios are fine, other non-file backed cases are not. */
+	mapping_flags = (unsigned long)mapping & PAGE_MAPPING_FLAGS;
+	if (mapping_flags)
+		return mapping_flags == PAGE_MAPPING_ANON;
+
+	/*
+	 * At this point, we know the mapping is non-null and points to an
+	 * address_space object. The only remaining whitelisted file system is
+	 * shmem.
+	 */
+	return shmem_mapping(mapping);
+}
+
+/*
  * Fast-gup relies on pte change detection to avoid concurrent pgtable
  * operations.
  *
_


