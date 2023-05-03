Return-Path: <netdev+bounces-144-lists+netdev=lfdr.de@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from ny.mirrors.kernel.org (ny.mirrors.kernel.org [147.75.199.223])
	by mail.lfdr.de (Postfix) with ESMTPS id 2CEE06F56D0
	for <lists+netdev@lfdr.de>; Wed,  3 May 2023 13:02:37 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ny.mirrors.kernel.org (Postfix) with ESMTPS id 1BEE01C20EB1
	for <lists+netdev@lfdr.de>; Wed,  3 May 2023 11:02:34 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 693ECD30E;
	Wed,  3 May 2023 11:02:33 +0000 (UTC)
X-Original-To: netdev@vger.kernel.org
Received: from lindbergh.monkeyblade.net (lindbergh.monkeyblade.net [23.128.96.19])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 5B4921870
	for <netdev@vger.kernel.org>; Wed,  3 May 2023 11:02:33 +0000 (UTC)
Received: from smtp-out1.suse.de (smtp-out1.suse.de [195.135.220.28])
	by lindbergh.monkeyblade.net (Postfix) with ESMTPS id EFAC059DB
	for <netdev@vger.kernel.org>; Wed,  3 May 2023 04:02:02 -0700 (PDT)
Received: from imap2.suse-dmz.suse.de (imap2.suse-dmz.suse.de [192.168.254.74])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (P-521) server-digest SHA512)
	(No client certificate requested)
	by smtp-out1.suse.de (Postfix) with ESMTPS id 74B812264D;
	Wed,  3 May 2023 11:01:46 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=suse.cz; s=susede2_rsa;
	t=1683111706; h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
	 mime-version:mime-version:content-type:content-type:
	 in-reply-to:in-reply-to:references:references;
	bh=z8jwtQHJUM/AAWsjtHIjrtk50jYN3yDn+0AjU75Gl8I=;
	b=YnHHB9XleIkwOgka1vGP8aJr57QABiFIYqyQyRc190pWEehlsHxHHfLtXMcwYmaPOpl+wN
	PF7SwfH0/Fl3otDZ0ORMKPi1ufHEJI+u1wXNthvFYPJ19qsDYxRolPgvwjfiYKrU2fop0C
	HIwPUQffZm/HAW8bbxEbbw1BFC9A3qE=
DKIM-Signature: v=1; a=ed25519-sha256; c=relaxed/relaxed; d=suse.cz;
	s=susede2_ed25519; t=1683111706;
	h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
	 mime-version:mime-version:content-type:content-type:
	 in-reply-to:in-reply-to:references:references;
	bh=z8jwtQHJUM/AAWsjtHIjrtk50jYN3yDn+0AjU75Gl8I=;
	b=LbUksBymq3p4Gn1YivZps62g/RWguxmOUm3+x9IlBwCcn/cItgSEOeSSPICJnwGxuZWzIC
	oNqeocndKtvnM6AA==
Received: from imap2.suse-dmz.suse.de (imap2.suse-dmz.suse.de [192.168.254.74])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (P-521) server-digest SHA512)
	(No client certificate requested)
	by imap2.suse-dmz.suse.de (Postfix) with ESMTPS id 591D713584;
	Wed,  3 May 2023 11:01:46 +0000 (UTC)
Received: from dovecot-director2.suse.de ([192.168.254.65])
	by imap2.suse-dmz.suse.de with ESMTPSA
	id 4JOsFRo/UmRtSgAAMHmgww
	(envelope-from <jack@suse.cz>); Wed, 03 May 2023 11:01:46 +0000
Received: by quack3.suse.cz (Postfix, from userid 1000)
	id DC334A0744; Wed,  3 May 2023 13:01:45 +0200 (CEST)
Date: Wed, 3 May 2023 13:01:45 +0200
From: Jan Kara <jack@suse.cz>
To: Lorenzo Stoakes <lstoakes@gmail.com>
Cc: linux-mm@kvack.org, linux-kernel@vger.kernel.org,
	Andrew Morton <akpm@linux-foundation.org>,
	Jason Gunthorpe <jgg@ziepe.ca>, Jens Axboe <axboe@kernel.dk>,
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
	Jiri Olsa <jolsa@kernel.org>, Namhyung Kim <namhyung@kernel.org>,
	Ian Rogers <irogers@google.com>,
	Adrian Hunter <adrian.hunter@intel.com>,
	Bjorn Topel <bjorn@kernel.org>,
	Magnus Karlsson <magnus.karlsson@intel.com>,
	Maciej Fijalkowski <maciej.fijalkowski@intel.com>,
	Jonathan Lemon <jonathan.lemon@gmail.com>,
	"David S . Miller" <davem@davemloft.net>,
	Eric Dumazet <edumazet@google.com>,
	Jakub Kicinski <kuba@kernel.org>, Paolo Abeni <pabeni@redhat.com>,
	Christian Brauner <brauner@kernel.org>,
	Richard Cochran <richardcochran@gmail.com>,
	Alexei Starovoitov <ast@kernel.org>,
	Daniel Borkmann <daniel@iogearbox.net>,
	Jesper Dangaard Brouer <hawk@kernel.org>,
	John Fastabend <john.fastabend@gmail.com>,
	linux-fsdevel@vger.kernel.org, linux-perf-users@vger.kernel.org,
	netdev@vger.kernel.org, bpf@vger.kernel.org,
	Oleg Nesterov <oleg@redhat.com>, Jason Gunthorpe <jgg@nvidia.com>,
	John Hubbard <jhubbard@nvidia.com>, Jan Kara <jack@suse.cz>,
	"Kirill A . Shutemov" <kirill@shutemov.name>,
	Pavel Begunkov <asml.silence@gmail.com>,
	Mika Penttila <mpenttil@redhat.com>,
	David Hildenbrand <david@redhat.com>,
	Dave Chinner <david@fromorbit.com>, Theodore Ts'o <tytso@mit.edu>,
	Peter Xu <peterx@redhat.com>,
	Matthew Rosato <mjrosato@linux.ibm.com>,
	"Paul E . McKenney" <paulmck@kernel.org>,
	Christian Borntraeger <borntraeger@linux.ibm.com>
Subject: Re: [PATCH v8 3/3] mm/gup: disallow FOLL_LONGTERM GUP-fast writing
 to file-backed mappings
Message-ID: <20230503110145.74q5sm5psv7o7nrd@quack3>
References: <cover.1683067198.git.lstoakes@gmail.com>
 <a690186fc37e1ea92556a7dbd0887fe201fcc709.1683067198.git.lstoakes@gmail.com>
Precedence: bulk
X-Mailing-List: netdev@vger.kernel.org
List-Id: <netdev.vger.kernel.org>
List-Subscribe: <mailto:netdev+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:netdev+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <a690186fc37e1ea92556a7dbd0887fe201fcc709.1683067198.git.lstoakes@gmail.com>
X-Spam-Status: No, score=-4.4 required=5.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_MED,SPF_HELO_NONE,
	SPF_PASS,T_SCC_BODY_TEXT_LINE,URIBL_BLOCKED autolearn=unavailable
	autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
	lindbergh.monkeyblade.net

On Tue 02-05-23 23:51:35, Lorenzo Stoakes wrote:
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
> 
> Suggested-by: David Hildenbrand <david@redhat.com>
> Suggested-by: Kirill A . Shutemov <kirill@shutemov.name>
> Suggested-by: Peter Zijlstra <peterz@infradead.org>
> Signed-off-by: Lorenzo Stoakes <lstoakes@gmail.com>

The patch looks good to me now. Feel free to add:

Reviewed-by: Jan Kara <jack@suse.cz>

								Honza

> ---
>  mm/gup.c | 102 +++++++++++++++++++++++++++++++++++++++++++++++++++++++
>  1 file changed, 102 insertions(+)
> 
> diff --git a/mm/gup.c b/mm/gup.c
> index 0ea9ebec9547..1ab369b5d889 100644
> --- a/mm/gup.c
> +++ b/mm/gup.c
> @@ -18,6 +18,7 @@
>  #include <linux/migrate.h>
>  #include <linux/mm_inline.h>
>  #include <linux/sched/mm.h>
> +#include <linux/shmem_fs.h>
>  
>  #include <asm/mmu_context.h>
>  #include <asm/tlbflush.h>
> @@ -95,6 +96,83 @@ static inline struct folio *try_get_folio(struct page *page, int refs)
>  	return folio;
>  }
>  
> +/*
> + * Used in the GUP-fast path to determine whether a pin is permitted for a
> + * specific folio.
> + *
> + * This call assumes the caller has pinned the folio, that the lowest page table
> + * level still points to this folio, and that interrupts have been disabled.
> + *
> + * Writing to pinned file-backed dirty tracked folios is inherently problematic
> + * (see comment describing the writable_file_mapping_allowed() function). We
> + * therefore try to avoid the most egregious case of a long-term mapping doing
> + * so.
> + *
> + * This function cannot be as thorough as that one as the VMA is not available
> + * in the fast path, so instead we whitelist known good cases and if in doubt,
> + * fall back to the slow path.
> + */
> +static bool folio_fast_pin_allowed(struct folio *folio, unsigned int flags)
> +{
> +	struct address_space *mapping;
> +	unsigned long mapping_flags;
> +
> +	/*
> +	 * If we aren't pinning then no problematic write can occur. A long term
> +	 * pin is the most egregious case so this is the one we disallow.
> +	 */
> +	if ((flags & (FOLL_PIN | FOLL_LONGTERM | FOLL_WRITE)) !=
> +	    (FOLL_PIN | FOLL_LONGTERM | FOLL_WRITE))
> +		return true;
> +
> +	/* The folio is pinned, so we can safely access folio fields. */
> +
> +	/* Neither of these should be possible, but check to be sure. */
> +	if (unlikely(folio_test_slab(folio) || folio_test_swapcache(folio)))
> +		return false;
> +
> +	/* hugetlb mappings do not require dirty-tracking. */
> +	if (folio_test_hugetlb(folio))
> +		return true;
> +
> +	/*
> +	 * GUP-fast disables IRQs. When IRQS are disabled, RCU grace periods
> +	 * cannot proceed, which means no actions performed under RCU can
> +	 * proceed either.
> +	 *
> +	 * inodes and thus their mappings are freed under RCU, which means the
> +	 * mapping cannot be freed beneath us and thus we can safely dereference
> +	 * it.
> +	 */
> +	lockdep_assert_irqs_disabled();
> +
> +	/*
> +	 * However, there may be operations which _alter_ the mapping, so ensure
> +	 * we read it once and only once.
> +	 */
> +	mapping = READ_ONCE(folio->mapping);
> +
> +	/*
> +	 * The mapping may have been truncated, in any case we cannot determine
> +	 * if this mapping is safe - fall back to slow path to determine how to
> +	 * proceed.
> +	 */
> +	if (!mapping)
> +		return false;
> +
> +	/* Anonymous folios are fine, other non-file backed cases are not. */
> +	mapping_flags = (unsigned long)mapping & PAGE_MAPPING_FLAGS;
> +	if (mapping_flags)
> +		return mapping_flags == PAGE_MAPPING_ANON;
> +
> +	/*
> +	 * At this point, we know the mapping is non-null and points to an
> +	 * address_space object. The only remaining whitelisted file system is
> +	 * shmem.
> +	 */
> +	return shmem_mapping(mapping);
> +}
> +
>  /**
>   * try_grab_folio() - Attempt to get or pin a folio.
>   * @page:  pointer to page to be grabbed
> @@ -2464,6 +2542,11 @@ static int gup_pte_range(pmd_t pmd, pmd_t *pmdp, unsigned long addr,
>  			goto pte_unmap;
>  		}
>  
> +		if (!folio_fast_pin_allowed(folio, flags)) {
> +			gup_put_folio(folio, 1, flags);
> +			goto pte_unmap;
> +		}
> +
>  		if (!pte_write(pte) && gup_must_unshare(NULL, flags, page)) {
>  			gup_put_folio(folio, 1, flags);
>  			goto pte_unmap;
> @@ -2656,6 +2739,11 @@ static int gup_hugepte(pte_t *ptep, unsigned long sz, unsigned long addr,
>  		return 0;
>  	}
>  
> +	if (!folio_fast_pin_allowed(folio, flags)) {
> +		gup_put_folio(folio, refs, flags);
> +		return 0;
> +	}
> +
>  	if (!pte_write(pte) && gup_must_unshare(NULL, flags, &folio->page)) {
>  		gup_put_folio(folio, refs, flags);
>  		return 0;
> @@ -2722,6 +2810,10 @@ static int gup_huge_pmd(pmd_t orig, pmd_t *pmdp, unsigned long addr,
>  		return 0;
>  	}
>  
> +	if (!folio_fast_pin_allowed(folio, flags)) {
> +		gup_put_folio(folio, refs, flags);
> +		return 0;
> +	}
>  	if (!pmd_write(orig) && gup_must_unshare(NULL, flags, &folio->page)) {
>  		gup_put_folio(folio, refs, flags);
>  		return 0;
> @@ -2762,6 +2854,11 @@ static int gup_huge_pud(pud_t orig, pud_t *pudp, unsigned long addr,
>  		return 0;
>  	}
>  
> +	if (!folio_fast_pin_allowed(folio, flags)) {
> +		gup_put_folio(folio, refs, flags);
> +		return 0;
> +	}
> +
>  	if (!pud_write(orig) && gup_must_unshare(NULL, flags, &folio->page)) {
>  		gup_put_folio(folio, refs, flags);
>  		return 0;
> @@ -2797,6 +2894,11 @@ static int gup_huge_pgd(pgd_t orig, pgd_t *pgdp, unsigned long addr,
>  		return 0;
>  	}
>  
> +	if (!folio_fast_pin_allowed(folio, flags)) {
> +		gup_put_folio(folio, refs, flags);
> +		return 0;
> +	}
> +
>  	*nr += refs;
>  	folio_set_referenced(folio);
>  	return 1;
> -- 
> 2.40.1
> 
-- 
Jan Kara <jack@suse.com>
SUSE Labs, CR

