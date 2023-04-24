Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 4AE276ED21D
	for <lists+netdev@lfdr.de>; Mon, 24 Apr 2023 18:10:00 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232152AbjDXQJ5 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 24 Apr 2023 12:09:57 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:37850 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232171AbjDXQJ4 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 24 Apr 2023 12:09:56 -0400
Received: from smtp-out2.suse.de (smtp-out2.suse.de [195.135.220.29])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 7F98E6E8A;
        Mon, 24 Apr 2023 09:09:54 -0700 (PDT)
Received: from imap2.suse-dmz.suse.de (imap2.suse-dmz.suse.de [192.168.254.74])
        (using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
         key-exchange X25519 server-signature ECDSA (P-521) server-digest SHA512)
        (No client certificate requested)
        by smtp-out2.suse.de (Postfix) with ESMTPS id 0253B1FD93;
        Mon, 24 Apr 2023 16:09:53 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=suse.cz; s=susede2_rsa;
        t=1682352593; h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
         mime-version:mime-version:content-type:content-type:
         in-reply-to:in-reply-to:references:references;
        bh=G2ImUS04APy2MAgMawbg8Ib6n8F1sIQ15789HFafhkA=;
        b=NqUEPwjREOyz9qmyUmpZGNIEi2xV23u/XMYIMhhx5hx9GpSoIZgdTAQosjnZ5BrFfnagd2
        g/YxJrAD2RujH4F6/YC8BAHHa5DWq9MzLEFvcfKImvUXLJZK7KV+41rkd8v6RBVgnqQew1
        yuwraYu6Q+raScqoE1vm2RMDk1wpc0g=
DKIM-Signature: v=1; a=ed25519-sha256; c=relaxed/relaxed; d=suse.cz;
        s=susede2_ed25519; t=1682352593;
        h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
         mime-version:mime-version:content-type:content-type:
         in-reply-to:in-reply-to:references:references;
        bh=G2ImUS04APy2MAgMawbg8Ib6n8F1sIQ15789HFafhkA=;
        b=OkKOuLfxehkKOWUP3CnI5jOhdU/BTHi3RVidNC2ezZjy63WrefGIsxWpLEJs7Hlq+4/rcZ
        de8HjSU8zJLB5EDQ==
Received: from imap2.suse-dmz.suse.de (imap2.suse-dmz.suse.de [192.168.254.74])
        (using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
         key-exchange X25519 server-signature ECDSA (P-521) server-digest SHA512)
        (No client certificate requested)
        by imap2.suse-dmz.suse.de (Postfix) with ESMTPS id D87C513780;
        Mon, 24 Apr 2023 16:09:52 +0000 (UTC)
Received: from dovecot-director2.suse.de ([192.168.254.65])
        by imap2.suse-dmz.suse.de with ESMTPSA
        id UUzQNNCpRmRjfgAAMHmgww
        (envelope-from <jack@suse.cz>); Mon, 24 Apr 2023 16:09:52 +0000
Received: by quack3.suse.cz (Postfix, from userid 1000)
        id 20932A0729; Mon, 24 Apr 2023 18:09:52 +0200 (CEST)
Date:   Mon, 24 Apr 2023 18:09:52 +0200
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
        John Hubbard <jhubbard@nvidia.com>
Subject: Re: [PATCH] mm/gup: disallow GUP writing to file-backed mappings by
 default
Message-ID: <20230424160952.bvii2ahgxss2chev@quack3>
References: <f86dc089b460c80805e321747b0898fd1efe93d7.1682168199.git.lstoakes@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <f86dc089b460c80805e321747b0898fd1efe93d7.1682168199.git.lstoakes@gmail.com>
X-Spam-Status: No, score=-4.4 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_MED,SPF_HELO_NONE,
        SPF_PASS,T_SCC_BODY_TEXT_LINE autolearn=ham autolearn_force=no
        version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Sat 22-04-23 14:37:05, Lorenzo Stoakes wrote:
> It isn't safe to write to file-backed mappings as GUP does not ensure that
> the semantics associated with such a write are performed correctly, for
> instance filesystems which rely upon write-notify will not be correctly
> notified.

I agree that this is currently subtly broken. But we also know from the bug
reports there are definitely users of this functionality out in the wild.
After all that was the reason why John Hubbard (added to CC) added
FOLL_PIN functionality to the kernel - so that filesystems can recognize
the pages may be modified behind their back and act accordingly.

So I'm maybe missing a bigger picture why we would like a change like this.
Because we still need to teach filesystems to handle pinned pages for the
usecases you don't forbid and for which we know there are users and then
what's the benefit of this patch?

								Honza

> There are exceptions to this - shmem and hugetlb mappings are (in effect)
> anonymous mappings by other names so we do permit this operation in these
> cases.
> 
> In addition, if no pinning takes place (neither FOLL_GET nor FOLL_PIN is
> specified and neither flags gets implicitly set) then no writing can occur
> so we do not perform the check in this instance.
> 
> This is an important exception, as populate_vma_page_range() invokes
> __get_user_pages() in this way (and thus so does __mm_populate(), used by
> MAP_POPULATE mmap() and mlock() invocations).
> 
> There are GUP users within the kernel that do nevertheless rely upon this
> behaviour, so we introduce the FOLL_ALLOW_BROKEN_FILE_MAPPING flag to
> explicitly permit this kind of GUP access.
> 
> This is required in order to not break userspace in instances where the
> uAPI might permit file-mapped addresses - a number of RDMA users require
> this for instance, as do the process_vm_[read/write]v() system calls,
> /proc/$pid/mem, ptrace and SDT uprobes. Each of these callers have been
> updated to use this flag.
> 
> Making this change is an important step towards a more reliable GUP, and
> explicitly indicates which callers might encouter issues moving forward.
> 
> Suggested-by: Jason Gunthorpe <jgg@ziepe.ca>
> Signed-off-by: Lorenzo Stoakes <lstoakes@gmail.com>
> ---
>  drivers/infiniband/hw/qib/qib_user_pages.c |  3 +-
>  drivers/infiniband/hw/usnic/usnic_uiom.c   |  2 +-
>  drivers/infiniband/sw/siw/siw_mem.c        |  3 +-
>  fs/proc/base.c                             |  3 +-
>  include/linux/mm_types.h                   |  8 +++++
>  kernel/events/uprobes.c                    |  3 +-
>  mm/gup.c                                   | 36 +++++++++++++++++++++-
>  mm/memory.c                                |  3 +-
>  mm/process_vm_access.c                     |  2 +-
>  net/xdp/xdp_umem.c                         |  2 +-
>  10 files changed, 56 insertions(+), 9 deletions(-)
> 
> diff --git a/drivers/infiniband/hw/qib/qib_user_pages.c b/drivers/infiniband/hw/qib/qib_user_pages.c
> index f693bc753b6b..b9019dad8008 100644
> --- a/drivers/infiniband/hw/qib/qib_user_pages.c
> +++ b/drivers/infiniband/hw/qib/qib_user_pages.c
> @@ -110,7 +110,8 @@ int qib_get_user_pages(unsigned long start_page, size_t num_pages,
>  	for (got = 0; got < num_pages; got += ret) {
>  		ret = pin_user_pages(start_page + got * PAGE_SIZE,
>  				     num_pages - got,
> -				     FOLL_LONGTERM | FOLL_WRITE,
> +				     FOLL_LONGTERM | FOLL_WRITE |
> +				     FOLL_ALLOW_BROKEN_FILE_MAPPING,
>  				     p + got, NULL);
>  		if (ret < 0) {
>  			mmap_read_unlock(current->mm);
> diff --git a/drivers/infiniband/hw/usnic/usnic_uiom.c b/drivers/infiniband/hw/usnic/usnic_uiom.c
> index 2a5cac2658ec..33cf79b248a9 100644
> --- a/drivers/infiniband/hw/usnic/usnic_uiom.c
> +++ b/drivers/infiniband/hw/usnic/usnic_uiom.c
> @@ -85,7 +85,7 @@ static int usnic_uiom_get_pages(unsigned long addr, size_t size, int writable,
>  				int dmasync, struct usnic_uiom_reg *uiomr)
>  {
>  	struct list_head *chunk_list = &uiomr->chunk_list;
> -	unsigned int gup_flags = FOLL_LONGTERM;
> +	unsigned int gup_flags = FOLL_LONGTERM | FOLL_ALLOW_BROKEN_FILE_MAPPING;
>  	struct page **page_list;
>  	struct scatterlist *sg;
>  	struct usnic_uiom_chunk *chunk;
> diff --git a/drivers/infiniband/sw/siw/siw_mem.c b/drivers/infiniband/sw/siw/siw_mem.c
> index f51ab2ccf151..bc3e8c0898e5 100644
> --- a/drivers/infiniband/sw/siw/siw_mem.c
> +++ b/drivers/infiniband/sw/siw/siw_mem.c
> @@ -368,7 +368,8 @@ struct siw_umem *siw_umem_get(u64 start, u64 len, bool writable)
>  	struct mm_struct *mm_s;
>  	u64 first_page_va;
>  	unsigned long mlock_limit;
> -	unsigned int foll_flags = FOLL_LONGTERM;
> +	unsigned int foll_flags =
> +		FOLL_LONGTERM | FOLL_ALLOW_BROKEN_FILE_MAPPING;
>  	int num_pages, num_chunks, i, rv = 0;
>  
>  	if (!can_do_mlock())
> diff --git a/fs/proc/base.c b/fs/proc/base.c
> index 96a6a08c8235..3e3f5ea9849f 100644
> --- a/fs/proc/base.c
> +++ b/fs/proc/base.c
> @@ -855,7 +855,8 @@ static ssize_t mem_rw(struct file *file, char __user *buf,
>  	if (!mmget_not_zero(mm))
>  		goto free;
>  
> -	flags = FOLL_FORCE | (write ? FOLL_WRITE : 0);
> +	flags = FOLL_FORCE | FOLL_ALLOW_BROKEN_FILE_MAPPING |
> +		(write ? FOLL_WRITE : 0);
>  
>  	while (count > 0) {
>  		size_t this_len = min_t(size_t, count, PAGE_SIZE);
> diff --git a/include/linux/mm_types.h b/include/linux/mm_types.h
> index 3fc9e680f174..e76637b4c78f 100644
> --- a/include/linux/mm_types.h
> +++ b/include/linux/mm_types.h
> @@ -1185,6 +1185,14 @@ enum {
>  	FOLL_PCI_P2PDMA = 1 << 10,
>  	/* allow interrupts from generic signals */
>  	FOLL_INTERRUPTIBLE = 1 << 11,
> +	/*
> +	 * By default we disallow write access to known broken file-backed
> +	 * memory mappings (i.e. anything other than hugetlb/shmem
> +	 * mappings). Some code may rely upon being able to access this
> +	 * regardless for legacy reasons, thus we provide a flag to indicate
> +	 * this.
> +	 */
> +	FOLL_ALLOW_BROKEN_FILE_MAPPING = 1 << 12,
>  
>  	/* See also internal only FOLL flags in mm/internal.h */
>  };
> diff --git a/kernel/events/uprobes.c b/kernel/events/uprobes.c
> index 59887c69d54c..ec330d3b0218 100644
> --- a/kernel/events/uprobes.c
> +++ b/kernel/events/uprobes.c
> @@ -373,7 +373,8 @@ __update_ref_ctr(struct mm_struct *mm, unsigned long vaddr, short d)
>  		return -EINVAL;
>  
>  	ret = get_user_pages_remote(mm, vaddr, 1,
> -			FOLL_WRITE, &page, &vma, NULL);
> +				    FOLL_WRITE | FOLL_ALLOW_BROKEN_FILE_MAPPING,
> +				    &page, &vma, NULL);
>  	if (unlikely(ret <= 0)) {
>  		/*
>  		 * We are asking for 1 page. If get_user_pages_remote() fails,
> diff --git a/mm/gup.c b/mm/gup.c
> index 1f72a717232b..68d5570c0bae 100644
> --- a/mm/gup.c
> +++ b/mm/gup.c
> @@ -959,16 +959,46 @@ static int faultin_page(struct vm_area_struct *vma,
>  	return 0;
>  }
>  
> +/*
> + * Writing to file-backed mappings using GUP is a fundamentally broken operation
> + * as kernel write access to GUP mappings may not adhere to the semantics
> + * expected by a file system.
> + *
> + * In most instances we disallow this broken behaviour, however there are some
> + * exceptions to this enforced here.
> + */
> +static inline bool can_write_file_mapping(struct vm_area_struct *vma,
> +					  unsigned long gup_flags)
> +{
> +	struct file *file = vma->vm_file;
> +
> +	/* If we aren't pinning then no problematic write can occur. */
> +	if (!(gup_flags & (FOLL_GET | FOLL_PIN)))
> +		return true;
> +
> +	/* Special mappings should pose no problem. */
> +	if (!file)
> +		return true;
> +
> +	/* Has the caller explicitly indicated this case is acceptable? */
> +	if (gup_flags & FOLL_ALLOW_BROKEN_FILE_MAPPING)
> +		return true;
> +
> +	/* shmem and hugetlb mappings do not have problematic semantics. */
> +	return vma_is_shmem(vma) || is_file_hugepages(file);
> +}
> +
>  static int check_vma_flags(struct vm_area_struct *vma, unsigned long gup_flags)
>  {
>  	vm_flags_t vm_flags = vma->vm_flags;
>  	int write = (gup_flags & FOLL_WRITE);
>  	int foreign = (gup_flags & FOLL_REMOTE);
> +	bool vma_anon = vma_is_anonymous(vma);
>  
>  	if (vm_flags & (VM_IO | VM_PFNMAP))
>  		return -EFAULT;
>  
> -	if (gup_flags & FOLL_ANON && !vma_is_anonymous(vma))
> +	if ((gup_flags & FOLL_ANON) && !vma_anon)
>  		return -EFAULT;
>  
>  	if ((gup_flags & FOLL_LONGTERM) && vma_is_fsdax(vma))
> @@ -978,6 +1008,10 @@ static int check_vma_flags(struct vm_area_struct *vma, unsigned long gup_flags)
>  		return -EFAULT;
>  
>  	if (write) {
> +		if (!vma_anon &&
> +		    WARN_ON_ONCE(!can_write_file_mapping(vma, gup_flags)))
> +			return -EFAULT;
> +
>  		if (!(vm_flags & VM_WRITE)) {
>  			if (!(gup_flags & FOLL_FORCE))
>  				return -EFAULT;
> diff --git a/mm/memory.c b/mm/memory.c
> index 146bb94764f8..e3d535991548 100644
> --- a/mm/memory.c
> +++ b/mm/memory.c
> @@ -5683,7 +5683,8 @@ int access_process_vm(struct task_struct *tsk, unsigned long addr,
>  	if (!mm)
>  		return 0;
>  
> -	ret = __access_remote_vm(mm, addr, buf, len, gup_flags);
> +	ret = __access_remote_vm(mm, addr, buf, len,
> +				 gup_flags | FOLL_ALLOW_BROKEN_FILE_MAPPING);
>  
>  	mmput(mm);
>  
> diff --git a/mm/process_vm_access.c b/mm/process_vm_access.c
> index 78dfaf9e8990..ef126c08e89c 100644
> --- a/mm/process_vm_access.c
> +++ b/mm/process_vm_access.c
> @@ -81,7 +81,7 @@ static int process_vm_rw_single_vec(unsigned long addr,
>  	ssize_t rc = 0;
>  	unsigned long max_pages_per_loop = PVM_MAX_KMALLOC_PAGES
>  		/ sizeof(struct pages *);
> -	unsigned int flags = 0;
> +	unsigned int flags = FOLL_ALLOW_BROKEN_FILE_MAPPING;
>  
>  	/* Work out address and page range required */
>  	if (len == 0)
> diff --git a/net/xdp/xdp_umem.c b/net/xdp/xdp_umem.c
> index 02207e852d79..b93cfcaccb0d 100644
> --- a/net/xdp/xdp_umem.c
> +++ b/net/xdp/xdp_umem.c
> @@ -93,7 +93,7 @@ void xdp_put_umem(struct xdp_umem *umem, bool defer_cleanup)
>  
>  static int xdp_umem_pin_pages(struct xdp_umem *umem, unsigned long address)
>  {
> -	unsigned int gup_flags = FOLL_WRITE;
> +	unsigned int gup_flags = FOLL_WRITE | FOLL_ALLOW_BROKEN_FILE_MAPPING;
>  	long npgs;
>  	int err;
>  
> -- 
> 2.40.0
> 
-- 
Jan Kara <jack@suse.com>
SUSE Labs, CR
