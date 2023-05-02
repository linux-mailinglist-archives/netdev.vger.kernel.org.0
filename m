Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 1F55E6F428F
	for <lists+netdev@lfdr.de>; Tue,  2 May 2023 13:20:49 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233934AbjEBLUq (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 2 May 2023 07:20:46 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:35742 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233001AbjEBLUo (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 2 May 2023 07:20:44 -0400
Received: from smtp-out1.suse.de (smtp-out1.suse.de [195.135.220.28])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 1E6E6C9;
        Tue,  2 May 2023 04:20:42 -0700 (PDT)
Received: from imap2.suse-dmz.suse.de (imap2.suse-dmz.suse.de [192.168.254.74])
        (using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
         key-exchange X25519 server-signature ECDSA (P-521) server-digest SHA512)
        (No client certificate requested)
        by smtp-out1.suse.de (Postfix) with ESMTPS id 251F8221C9;
        Tue,  2 May 2023 11:20:41 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=suse.cz; s=susede2_rsa;
        t=1683026441; h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
         mime-version:mime-version:content-type:content-type:
         in-reply-to:in-reply-to:references:references;
        bh=MpPuNSWgK/7ryswocH3gm7MC7NLdbgJF3Tog/deaqXU=;
        b=FdgT06jmkt76JiDp89k2lLBR4Za6kEs60Z4PQ/GwSBJGdSBPXtgx2dexDviPaM/oiE8qbr
        elXjk1gwO2tK6EK9f5pQOWlFMXwuqPIfMLu0d6ufc0dhDPT8Gs2U7Urusn0kJAerOp9Wy3
        9b8C9tUtdbmlYnqr102VwKEed3WH4AA=
DKIM-Signature: v=1; a=ed25519-sha256; c=relaxed/relaxed; d=suse.cz;
        s=susede2_ed25519; t=1683026441;
        h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
         mime-version:mime-version:content-type:content-type:
         in-reply-to:in-reply-to:references:references;
        bh=MpPuNSWgK/7ryswocH3gm7MC7NLdbgJF3Tog/deaqXU=;
        b=Nh41YCYpsFyI9UEcrXx2iMXGMiuPC3Kv3YI62qfLFgG0JYAfWAnT24JhuRainiwrbyIljZ
        6ces92cuYfmivwCw==
Received: from imap2.suse-dmz.suse.de (imap2.suse-dmz.suse.de [192.168.254.74])
        (using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
         key-exchange X25519 server-signature ECDSA (P-521) server-digest SHA512)
        (No client certificate requested)
        by imap2.suse-dmz.suse.de (Postfix) with ESMTPS id EE558134FB;
        Tue,  2 May 2023 11:20:40 +0000 (UTC)
Received: from dovecot-director2.suse.de ([192.168.254.65])
        by imap2.suse-dmz.suse.de with ESMTPSA
        id DyMkOgjyUGRWFAAAMHmgww
        (envelope-from <jack@suse.cz>); Tue, 02 May 2023 11:20:40 +0000
Received: by quack3.suse.cz (Postfix, from userid 1000)
        id 246BDA0735; Tue,  2 May 2023 13:20:40 +0200 (CEST)
Date:   Tue, 2 May 2023 13:20:40 +0200
From:   Jan Kara <jack@suse.cz>
To:     Lorenzo Stoakes <lstoakes@gmail.com>
Cc:     linux-mm@kvack.org, linux-kernel@vger.kernel.org,
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
        Theodore Ts'o <tytso@mit.edu>, Peter Xu <peterx@redhat.com>
Subject: Re: [PATCH v6 3/3] mm/gup: disallow FOLL_LONGTERM GUP-fast writing
 to file-backed mappings
Message-ID: <20230502112040.zkyogi46f3zl33he@quack3>
References: <cover.1682981880.git.lstoakes@gmail.com>
 <dee4f4ad6532b0f94d073da263526de334d5d7e0.1682981880.git.lstoakes@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <dee4f4ad6532b0f94d073da263526de334d5d7e0.1682981880.git.lstoakes@gmail.com>
X-Spam-Status: No, score=-4.4 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_MED,SPF_HELO_NONE,
        SPF_PASS,T_SCC_BODY_TEXT_LINE autolearn=ham autolearn_force=no
        version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Tue 02-05-23 00:11:49, Lorenzo Stoakes wrote:
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
> is anonymous and then whitelist known-good mappings - specifically hugetlb
> and shmem mappings.
> 
> While we obtain a stable folio for this check, the mapping might not be, as
> a truncate could nullify it at any time. Since doing so requires mappings
> to be zapped, we can synchronise against a TLB shootdown operation.
> 
> For some architectures TLB shootdown is synchronised by IPI, against which
> we are protected as the GUP-fast operation is performed with interrupts
> disabled. However, other architectures which specify
> CONFIG_MMU_GATHER_RCU_TABLE_FREE use an RCU lock for this operation.
> 
> In these instances, we acquire an RCU lock while performing our checks. If
> we cannot get a stable mapping, we fall back to the slow path, as otherwise
> we'd have to walk the page tables again and it's simpler and more effective
> to just fall back.
> 
> It's important to note that there are no APIs allowing users to specify
> FOLL_FAST_ONLY for a PUP-fast let alone with FOLL_LONGTERM, so we can
> always rely on the fact that if we fail to pin on the fast path, the code
> will fall back to the slow path which can perform the more thorough check.
> 
> Suggested-by: David Hildenbrand <david@redhat.com>
> Suggested-by: Kirill A . Shutemov <kirill@shutemov.name>
> Signed-off-by: Lorenzo Stoakes <lstoakes@gmail.com>
> ---
>  mm/gup.c | 87 ++++++++++++++++++++++++++++++++++++++++++++++++++++++--
>  1 file changed, 85 insertions(+), 2 deletions(-)
> 
> diff --git a/mm/gup.c b/mm/gup.c
> index 0f09dec0906c..431618048a03 100644
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
> @@ -95,6 +96,77 @@ static inline struct folio *try_get_folio(struct page *page, int refs)
>  	return folio;
>  }
>  
> +#ifdef CONFIG_MMU_GATHER_RCU_TABLE_FREE
> +static bool stabilise_mapping_rcu(struct folio *folio)
> +{
> +	struct address_space *mapping = READ_ONCE(folio->mapping);
> +
> +	rcu_read_lock();
> +
> +	return mapping == READ_ONCE(folio->mapping);
> +}
> +
> +static void unlock_rcu(void)
> +{
> +	rcu_read_unlock();
> +}
> +#else
> +static bool stabilise_mapping_rcu(struct folio *)
> +{
> +	return true;
> +}
> +
> +static void unlock_rcu(void)
> +{
> +}
> +#endif

So I wonder is this complexity worth it over just using rcu_read_lock()
unconditionally? It is just a compilation barrier AFAIK...

Also stabilise_mapping_rcu() seems to be a bit of a misnomer since the
mapping is not stable after the function is called. Also the return value
seems a bit pointless to me since we have to check folio_mapping() for
being != NULL anyway. All in all I'd say that:

	struct address_space *mapping;

	/* Make sure mapping cannot be freed under our hands */
	rcu_read_lock();
	mapping = folio_mapping(folio);
	ret = folio_test_anon(folio) || (mapping && shmem_mapping(mapping));
	rcu_read_unlock();

looks more comprehensible...

								Honza

> +
> +/*
> + * Used in the GUP-fast path to determine whether a FOLL_PIN | FOLL_LONGTERM |
> + * FOLL_WRITE pin is permitted for a specific folio.
> + *
> + * This assumes the folio is stable and pinned.
> + *
> + * Writing to pinned file-backed dirty tracked folios is inherently problematic
> + * (see comment describing the writeable_file_mapping_allowed() function). We
> + * therefore try to avoid the most egregious case of a long-term mapping doing
> + * so.
> + *
> + * This function cannot be as thorough as that one as the VMA is not available
> + * in the fast path, so instead we whitelist known good cases.
> + *
> + * The folio is stable, but the mapping might not be. When truncating for
> + * instance, a zap is performed which triggers TLB shootdown. IRQs are disabled
> + * so we are safe from an IPI, but some architectures use an RCU lock for this
> + * operation, so we acquire an RCU lock to ensure the mapping is stable.
> + */
> +static bool folio_longterm_write_pin_allowed(struct folio *folio)
> +{
> +	bool ret;
> +
> +	/* hugetlb mappings do not require dirty tracking. */
> +	if (folio_test_hugetlb(folio))
> +		return true;
> +
> +	if (stabilise_mapping_rcu(folio)) {
> +		struct address_space *mapping = folio_mapping(folio);
> +
> +		/*
> +		 * Neither anonymous nor shmem-backed folios require
> +		 * dirty tracking.
> +		 */
> +		ret = folio_test_anon(folio) ||
> +			(mapping && shmem_mapping(mapping));
> +	} else {
> +		/* If the mapping is unstable, fallback to the slow path. */
> +		ret = false;
> +	}
> +
> +	unlock_rcu();
> +
> +	return ret;
> +}
> +
>  /**
>   * try_grab_folio() - Attempt to get or pin a folio.
>   * @page:  pointer to page to be grabbed
> @@ -123,6 +195,8 @@ static inline struct folio *try_get_folio(struct page *page, int refs)
>   */
>  struct folio *try_grab_folio(struct page *page, int refs, unsigned int flags)
>  {
> +	bool is_longterm = flags & FOLL_LONGTERM;
> +
>  	if (unlikely(!(flags & FOLL_PCI_P2PDMA) && is_pci_p2pdma_page(page)))
>  		return NULL;
>  
> @@ -136,8 +210,7 @@ struct folio *try_grab_folio(struct page *page, int refs, unsigned int flags)
>  		 * right zone, so fail and let the caller fall back to the slow
>  		 * path.
>  		 */
> -		if (unlikely((flags & FOLL_LONGTERM) &&
> -			     !is_longterm_pinnable_page(page)))
> +		if (unlikely(is_longterm && !is_longterm_pinnable_page(page)))
>  			return NULL;
>  
>  		/*
> @@ -148,6 +221,16 @@ struct folio *try_grab_folio(struct page *page, int refs, unsigned int flags)
>  		if (!folio)
>  			return NULL;
>  
> +		/*
> +		 * Can this folio be safely pinned? We need to perform this
> +		 * check after the folio is stabilised.
> +		 */
> +		if ((flags & FOLL_WRITE) && is_longterm &&
> +		    !folio_longterm_write_pin_allowed(folio)) {
> +			folio_put_refs(folio, refs);
> +			return NULL;
> +		}
> +
>  		/*
>  		 * When pinning a large folio, use an exact count to track it.
>  		 *
> -- 
> 2.40.1
> 
-- 
Jan Kara <jack@suse.com>
SUSE Labs, CR
