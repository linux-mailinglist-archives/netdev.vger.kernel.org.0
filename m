Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id DF7BA650B29
	for <lists+netdev@lfdr.de>; Mon, 19 Dec 2022 13:07:26 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231470AbiLSMHU (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 19 Dec 2022 07:07:20 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:55188 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231700AbiLSMHB (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 19 Dec 2022 07:07:01 -0500
Received: from smtp-out1.suse.de (smtp-out1.suse.de [IPv6:2001:67c:2178:6::1c])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id AC1BCCD2;
        Mon, 19 Dec 2022 04:06:59 -0800 (PST)
Received: from imap2.suse-dmz.suse.de (imap2.suse-dmz.suse.de [192.168.254.74])
        (using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
         key-exchange X25519 server-signature ECDSA (P-521) server-digest SHA512)
        (No client certificate requested)
        by smtp-out1.suse.de (Postfix) with ESMTPS id 5B91837873;
        Mon, 19 Dec 2022 12:06:58 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=suse.com; s=susede1;
        t=1671451618; h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
         mime-version:mime-version:content-type:content-type:
         in-reply-to:in-reply-to:references:references;
        bh=VRA2aH5S0Ze0sw4rTGnG/RKjsdW74LSqAB0FgYf7/K8=;
        b=rtQCYUPC8WG9/Y5v90R4udOxE0QwjIrtVYsJ2DeTM7KFOrFdLtyfRJ3ckh0cHle6ymJjvZ
        SLhg2vR3pHJTHuLh0PXwellD9PtLPD1FpdN1GIJjnCPWLz8KnsY1qk+FJLZsVigvT89Rhe
        5xoSAvalOeCWpZ5NgbA7bRkP9qRL3M8=
Received: from imap2.suse-dmz.suse.de (imap2.suse-dmz.suse.de [192.168.254.74])
        (using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
         key-exchange X25519 server-signature ECDSA (P-521) server-digest SHA512)
        (No client certificate requested)
        by imap2.suse-dmz.suse.de (Postfix) with ESMTPS id 4173113910;
        Mon, 19 Dec 2022 12:06:58 +0000 (UTC)
Received: from dovecot-director2.suse.de ([192.168.254.65])
        by imap2.suse-dmz.suse.de with ESMTPSA
        id vvTvD+JToGMtbwAAMHmgww
        (envelope-from <mhocko@suse.com>); Mon, 19 Dec 2022 12:06:58 +0000
Date:   Mon, 19 Dec 2022 13:06:57 +0100
From:   Michal Hocko <mhocko@suse.com>
To:     Mike Kravetz <mike.kravetz@oracle.com>
Cc:     linux-mm@kvack.org, linux-kernel@vger.kernel.org,
        linuxppc-dev@lists.ozlabs.org, linux-riscv@lists.infradead.org,
        linux-s390@vger.kernel.org, netdev@vger.kernel.org,
        David Hildenbrand <david@redhat.com>,
        Peter Xu <peterx@redhat.com>,
        Nadav Amit <nadav.amit@gmail.com>,
        Matthew Wilcox <willy@infradead.org>,
        Vlastimil Babka <vbabka@suse.cz>,
        Rik van Riel <riel@surriel.com>,
        Will Deacon <will@kernel.org>,
        Michael Ellerman <mpe@ellerman.id.au>,
        Palmer Dabbelt <palmer@dabbelt.com>,
        Christian Borntraeger <borntraeger@linux.ibm.com>,
        Dave Hansen <dave.hansen@linux.intel.com>,
        Christian Brauner <brauner@kernel.org>,
        Eric Dumazet <edumazet@google.com>,
        Andrew Morton <akpm@linux-foundation.org>
Subject: Re: [RFC PATCH] mm: remove zap_page_range and change callers to use
 zap_vma_page_range
Message-ID: <Y6A6KqXObGKxvDrX@dhcp22.suse.cz>
References: <20221216192012.13562-1-mike.kravetz@oracle.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20221216192012.13562-1-mike.kravetz@oracle.com>
X-Spam-Status: No, score=-4.4 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_MED,SPF_HELO_NONE,
        SPF_PASS autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Fri 16-12-22 11:20:12, Mike Kravetz wrote:
> zap_page_range was originally designed to unmap pages within an address
> range that could span multiple vmas.  While working on [1], it was
> discovered that all callers of zap_page_range pass a range entirely within
> a single vma.  In addition, the mmu notification call within zap_page
> range does not correctly handle ranges that span multiple vmas as calls
> should be vma specific.

Could you spend a sentence or two explaining what is wrong here?

> Instead of fixing zap_page_range, change all callers to use the new
> routine zap_vma_page_range.  zap_vma_page_range is just a wrapper around
> zap_page_range_single passing in NULL zap details.  The name is also
> more in line with other exported routines that operate within a vma.
> We can then remove zap_page_range.

I would stick with zap_page_range_single rather than adding a new
wrapper but nothing really critical.

> Also, change madvise_dontneed_single_vma to use this new routine.
> 
> [1] https://lore.kernel.org/linux-mm/20221114235507.294320-2-mike.kravetz@oracle.com/
> Suggested-by: Peter Xu <peterx@redhat.com>
> Signed-off-by: Mike Kravetz <mike.kravetz@oracle.com>

Other than that LGTM
Acked-by: Michal Hocko <mhocko@suse.com>

Thanks!

> ---
>  arch/arm64/kernel/vdso.c                |  4 ++--
>  arch/powerpc/kernel/vdso.c              |  2 +-
>  arch/powerpc/platforms/book3s/vas-api.c |  2 +-
>  arch/powerpc/platforms/pseries/vas.c    |  2 +-
>  arch/riscv/kernel/vdso.c                |  4 ++--
>  arch/s390/kernel/vdso.c                 |  2 +-
>  arch/s390/mm/gmap.c                     |  2 +-
>  arch/x86/entry/vdso/vma.c               |  2 +-
>  drivers/android/binder_alloc.c          |  2 +-
>  include/linux/mm.h                      |  7 ++++--
>  mm/madvise.c                            |  4 ++--
>  mm/memory.c                             | 30 -------------------------
>  mm/page-writeback.c                     |  2 +-
>  net/ipv4/tcp.c                          |  6 ++---
>  14 files changed, 22 insertions(+), 49 deletions(-)
> 
> diff --git a/arch/arm64/kernel/vdso.c b/arch/arm64/kernel/vdso.c
> index e59a32aa0c49..a7b10e182f78 100644
> --- a/arch/arm64/kernel/vdso.c
> +++ b/arch/arm64/kernel/vdso.c
> @@ -141,10 +141,10 @@ int vdso_join_timens(struct task_struct *task, struct time_namespace *ns)
>  		unsigned long size = vma->vm_end - vma->vm_start;
>  
>  		if (vma_is_special_mapping(vma, vdso_info[VDSO_ABI_AA64].dm))
> -			zap_page_range(vma, vma->vm_start, size);
> +			zap_vma_page_range(vma, vma->vm_start, size);
>  #ifdef CONFIG_COMPAT_VDSO
>  		if (vma_is_special_mapping(vma, vdso_info[VDSO_ABI_AA32].dm))
> -			zap_page_range(vma, vma->vm_start, size);
> +			zap_vma_page_range(vma, vma->vm_start, size);
>  #endif
>  	}
>  
> diff --git a/arch/powerpc/kernel/vdso.c b/arch/powerpc/kernel/vdso.c
> index 507f8228f983..479d70fe8c55 100644
> --- a/arch/powerpc/kernel/vdso.c
> +++ b/arch/powerpc/kernel/vdso.c
> @@ -123,7 +123,7 @@ int vdso_join_timens(struct task_struct *task, struct time_namespace *ns)
>  		unsigned long size = vma->vm_end - vma->vm_start;
>  
>  		if (vma_is_special_mapping(vma, &vvar_spec))
> -			zap_page_range(vma, vma->vm_start, size);
> +			zap_vma_page_range(vma, vma->vm_start, size);
>  	}
>  	mmap_read_unlock(mm);
>  
> diff --git a/arch/powerpc/platforms/book3s/vas-api.c b/arch/powerpc/platforms/book3s/vas-api.c
> index eb5bed333750..8f57388b760b 100644
> --- a/arch/powerpc/platforms/book3s/vas-api.c
> +++ b/arch/powerpc/platforms/book3s/vas-api.c
> @@ -414,7 +414,7 @@ static vm_fault_t vas_mmap_fault(struct vm_fault *vmf)
>  	/*
>  	 * When the LPAR lost credits due to core removal or during
>  	 * migration, invalidate the existing mapping for the current
> -	 * paste addresses and set windows in-active (zap_page_range in
> +	 * paste addresses and set windows in-active (zap_vma_page_range in
>  	 * reconfig_close_windows()).
>  	 * New mapping will be done later after migration or new credits
>  	 * available. So continue to receive faults if the user space
> diff --git a/arch/powerpc/platforms/pseries/vas.c b/arch/powerpc/platforms/pseries/vas.c
> index 4ad6e510d405..2aef8d9295a2 100644
> --- a/arch/powerpc/platforms/pseries/vas.c
> +++ b/arch/powerpc/platforms/pseries/vas.c
> @@ -760,7 +760,7 @@ static int reconfig_close_windows(struct vas_caps *vcap, int excess_creds,
>  		 * is done before the original mmap() and after the ioctl.
>  		 */
>  		if (vma)
> -			zap_page_range(vma, vma->vm_start,
> +			zap_vma_page_range(vma, vma->vm_start,
>  					vma->vm_end - vma->vm_start);
>  
>  		mmap_write_unlock(task_ref->mm);
> diff --git a/arch/riscv/kernel/vdso.c b/arch/riscv/kernel/vdso.c
> index e410275918ac..a405119da2c0 100644
> --- a/arch/riscv/kernel/vdso.c
> +++ b/arch/riscv/kernel/vdso.c
> @@ -127,10 +127,10 @@ int vdso_join_timens(struct task_struct *task, struct time_namespace *ns)
>  		unsigned long size = vma->vm_end - vma->vm_start;
>  
>  		if (vma_is_special_mapping(vma, vdso_info.dm))
> -			zap_page_range(vma, vma->vm_start, size);
> +			zap_vma_page_range(vma, vma->vm_start, size);
>  #ifdef CONFIG_COMPAT
>  		if (vma_is_special_mapping(vma, compat_vdso_info.dm))
> -			zap_page_range(vma, vma->vm_start, size);
> +			zap_vma_page_range(vma, vma->vm_start, size);
>  #endif
>  	}
>  
> diff --git a/arch/s390/kernel/vdso.c b/arch/s390/kernel/vdso.c
> index ff7bf4432229..eccfcd505403 100644
> --- a/arch/s390/kernel/vdso.c
> +++ b/arch/s390/kernel/vdso.c
> @@ -63,7 +63,7 @@ int vdso_join_timens(struct task_struct *task, struct time_namespace *ns)
>  
>  		if (!vma_is_special_mapping(vma, &vvar_mapping))
>  			continue;
> -		zap_page_range(vma, vma->vm_start, size);
> +		zap_vma_page_range(vma, vma->vm_start, size);
>  		break;
>  	}
>  	mmap_read_unlock(mm);
> diff --git a/arch/s390/mm/gmap.c b/arch/s390/mm/gmap.c
> index 74e1d873dce0..67d998152142 100644
> --- a/arch/s390/mm/gmap.c
> +++ b/arch/s390/mm/gmap.c
> @@ -722,7 +722,7 @@ void gmap_discard(struct gmap *gmap, unsigned long from, unsigned long to)
>  		if (is_vm_hugetlb_page(vma))
>  			continue;
>  		size = min(to - gaddr, PMD_SIZE - (gaddr & ~PMD_MASK));
> -		zap_page_range(vma, vmaddr, size);
> +		zap_vma_page_range(vma, vmaddr, size);
>  	}
>  	mmap_read_unlock(gmap->mm);
>  }
> diff --git a/arch/x86/entry/vdso/vma.c b/arch/x86/entry/vdso/vma.c
> index b8f3f9b9e53c..5aafbd19e869 100644
> --- a/arch/x86/entry/vdso/vma.c
> +++ b/arch/x86/entry/vdso/vma.c
> @@ -116,7 +116,7 @@ int vdso_join_timens(struct task_struct *task, struct time_namespace *ns)
>  		unsigned long size = vma->vm_end - vma->vm_start;
>  
>  		if (vma_is_special_mapping(vma, &vvar_mapping))
> -			zap_page_range(vma, vma->vm_start, size);
> +			zap_vma_page_range(vma, vma->vm_start, size);
>  	}
>  	mmap_read_unlock(mm);
>  
> diff --git a/drivers/android/binder_alloc.c b/drivers/android/binder_alloc.c
> index 4ad42b0f75cd..f7f10248c742 100644
> --- a/drivers/android/binder_alloc.c
> +++ b/drivers/android/binder_alloc.c
> @@ -1019,7 +1019,7 @@ enum lru_status binder_alloc_free_page(struct list_head *item,
>  	if (vma) {
>  		trace_binder_unmap_user_start(alloc, index);
>  
> -		zap_page_range(vma, page_addr, PAGE_SIZE);
> +		zap_vma_page_range(vma, page_addr, PAGE_SIZE);
>  
>  		trace_binder_unmap_user_end(alloc, index);
>  	}
> diff --git a/include/linux/mm.h b/include/linux/mm.h
> index 6b28eb9c6ea2..706efaf95783 100644
> --- a/include/linux/mm.h
> +++ b/include/linux/mm.h
> @@ -1980,10 +1980,13 @@ struct page *vm_normal_page_pmd(struct vm_area_struct *vma, unsigned long addr,
>  
>  void zap_vma_ptes(struct vm_area_struct *vma, unsigned long address,
>  		  unsigned long size);
> -void zap_page_range(struct vm_area_struct *vma, unsigned long address,
> -		    unsigned long size);
>  void zap_page_range_single(struct vm_area_struct *vma, unsigned long address,
>  			   unsigned long size, struct zap_details *details);
> +static inline void zap_vma_page_range(struct vm_area_struct *vma,
> +				 unsigned long address, unsigned long size)
> +{
> +	zap_page_range_single(vma, address, size, NULL);
> +}
>  void unmap_vmas(struct mmu_gather *tlb, struct maple_tree *mt,
>  		struct vm_area_struct *start_vma, unsigned long start,
>  		unsigned long end);
> diff --git a/mm/madvise.c b/mm/madvise.c
> index 87703a19bbef..3c4d9829d4e1 100644
> --- a/mm/madvise.c
> +++ b/mm/madvise.c
> @@ -787,7 +787,7 @@ static int madvise_free_single_vma(struct vm_area_struct *vma,
>   * Application no longer needs these pages.  If the pages are dirty,
>   * it's OK to just throw them away.  The app will be more careful about
>   * data it wants to keep.  Be sure to free swap resources too.  The
> - * zap_page_range_single call sets things up for shrink_active_list to actually
> + * zap_vma_page_range call sets things up for shrink_active_list to actually
>   * free these pages later if no one else has touched them in the meantime,
>   * although we could add these pages to a global reuse list for
>   * shrink_active_list to pick up before reclaiming other pages.
> @@ -805,7 +805,7 @@ static int madvise_free_single_vma(struct vm_area_struct *vma,
>  static long madvise_dontneed_single_vma(struct vm_area_struct *vma,
>  					unsigned long start, unsigned long end)
>  {
> -	zap_page_range_single(vma, start, end - start, NULL);
> +	zap_vma_page_range(vma, start, end - start);
>  	return 0;
>  }
>  
> diff --git a/mm/memory.c b/mm/memory.c
> index 5b2c137dfb2a..e953a0108278 100644
> --- a/mm/memory.c
> +++ b/mm/memory.c
> @@ -1687,36 +1687,6 @@ void unmap_vmas(struct mmu_gather *tlb, struct maple_tree *mt,
>  	mmu_notifier_invalidate_range_end(&range);
>  }
>  
> -/**
> - * zap_page_range - remove user pages in a given range
> - * @vma: vm_area_struct holding the applicable pages
> - * @start: starting address of pages to zap
> - * @size: number of bytes to zap
> - *
> - * Caller must protect the VMA list
> - */
> -void zap_page_range(struct vm_area_struct *vma, unsigned long start,
> -		unsigned long size)
> -{
> -	struct maple_tree *mt = &vma->vm_mm->mm_mt;
> -	unsigned long end = start + size;
> -	struct mmu_notifier_range range;
> -	struct mmu_gather tlb;
> -	MA_STATE(mas, mt, vma->vm_end, vma->vm_end);
> -
> -	lru_add_drain();
> -	mmu_notifier_range_init(&range, MMU_NOTIFY_CLEAR, 0, vma, vma->vm_mm,
> -				start, start + size);
> -	tlb_gather_mmu(&tlb, vma->vm_mm);
> -	update_hiwater_rss(vma->vm_mm);
> -	mmu_notifier_invalidate_range_start(&range);
> -	do {
> -		unmap_single_vma(&tlb, vma, start, range.end, NULL);
> -	} while ((vma = mas_find(&mas, end - 1)) != NULL);
> -	mmu_notifier_invalidate_range_end(&range);
> -	tlb_finish_mmu(&tlb);
> -}
> -
>  /**
>   * zap_page_range_single - remove user pages in a given range
>   * @vma: vm_area_struct holding the applicable pages
> diff --git a/mm/page-writeback.c b/mm/page-writeback.c
> index ad608ef2a243..bd9fe6ff6557 100644
> --- a/mm/page-writeback.c
> +++ b/mm/page-writeback.c
> @@ -2713,7 +2713,7 @@ void folio_account_cleaned(struct folio *folio, struct bdi_writeback *wb)
>   *
>   * The caller must hold lock_page_memcg().  Most callers have the folio
>   * locked.  A few have the folio blocked from truncation through other
> - * means (eg zap_page_range() has it mapped and is holding the page table
> + * means (eg zap_vma_page_range() has it mapped and is holding the page table
>   * lock).  This can also be called from mark_buffer_dirty(), which I
>   * cannot prove is always protected against truncate.
>   */
> diff --git a/net/ipv4/tcp.c b/net/ipv4/tcp.c
> index c567d5e8053e..afaad3cfed00 100644
> --- a/net/ipv4/tcp.c
> +++ b/net/ipv4/tcp.c
> @@ -2092,7 +2092,7 @@ static int tcp_zerocopy_vm_insert_batch_error(struct vm_area_struct *vma,
>  		maybe_zap_len = total_bytes_to_map -  /* All bytes to map */
>  				*length + /* Mapped or pending */
>  				(pages_remaining * PAGE_SIZE); /* Failed map. */
> -		zap_page_range(vma, *address, maybe_zap_len);
> +		zap_vma_page_range(vma, *address, maybe_zap_len);
>  		err = 0;
>  	}
>  
> @@ -2100,7 +2100,7 @@ static int tcp_zerocopy_vm_insert_batch_error(struct vm_area_struct *vma,
>  		unsigned long leftover_pages = pages_remaining;
>  		int bytes_mapped;
>  
> -		/* We called zap_page_range, try to reinsert. */
> +		/* We called zap_vma_page_range, try to reinsert. */
>  		err = vm_insert_pages(vma, *address,
>  				      pending_pages,
>  				      &pages_remaining);
> @@ -2234,7 +2234,7 @@ static int tcp_zerocopy_receive(struct sock *sk,
>  	total_bytes_to_map = avail_len & ~(PAGE_SIZE - 1);
>  	if (total_bytes_to_map) {
>  		if (!(zc->flags & TCP_RECEIVE_ZEROCOPY_FLAG_TLB_CLEAN_HINT))
> -			zap_page_range(vma, address, total_bytes_to_map);
> +			zap_vma_page_range(vma, address, total_bytes_to_map);
>  		zc->length = total_bytes_to_map;
>  		zc->recv_skip_hint = 0;
>  	} else {
> -- 
> 2.38.1

-- 
Michal Hocko
SUSE Labs
