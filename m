Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 9E70B6EC41D
	for <lists+netdev@lfdr.de>; Mon, 24 Apr 2023 05:44:10 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229521AbjDXDoJ (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sun, 23 Apr 2023 23:44:09 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:36314 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231135AbjDXDn4 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sun, 23 Apr 2023 23:43:56 -0400
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.133.124])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 3394A2D77
        for <netdev@vger.kernel.org>; Sun, 23 Apr 2023 20:42:24 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1682307704;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=x0/Gqmlp5F3e84VZzqWw27RJ/qxOUG7Vcqc9AjwjGKg=;
        b=KYyv99JZmktWbjUthqTGeoSPYMVkY4AVnxfgd8DkjupbY7IXN4cF3sj3kQbZX+AVy4CBfX
        Z2nqyFeuy0jR3R5CUqyEhDOiuiThNuAgQJ9/ugnxbzwGZX+vm0yNPdvEJCCNy9RY7E+jJh
        lhNA/WtjOhZhHm842Vq9ekaHXnNXF/Y=
Received: from mail-lf1-f70.google.com (mail-lf1-f70.google.com
 [209.85.167.70]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.3, cipher=TLS_AES_256_GCM_SHA384) id
 us-mta-48-4IqcfYPQMpaD_3FRefQOHw-1; Sun, 23 Apr 2023 23:41:42 -0400
X-MC-Unique: 4IqcfYPQMpaD_3FRefQOHw-1
Received: by mail-lf1-f70.google.com with SMTP id 2adb3069b0e04-4ecb06abc1aso1715342e87.3
        for <netdev@vger.kernel.org>; Sun, 23 Apr 2023 20:41:42 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20221208; t=1682307701; x=1684899701;
        h=content-transfer-encoding:in-reply-to:from:references:cc:to
         :content-language:subject:user-agent:mime-version:date:message-id
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=x0/Gqmlp5F3e84VZzqWw27RJ/qxOUG7Vcqc9AjwjGKg=;
        b=lWkDGSwldyGhuwWz4tRdzDmYdaHUOoG8XySGj4Br+jcnmUKozZ+vsDKhfZFdCk3G5o
         3e64bSQQpH1yJhdkXcyd2p/mJxk3k7iHuFi+JFRYBgddqfLKMG7EEIN0haF8u1po696Y
         2EWZ+fwmGeM0jwQWREq5vd5QFhMfnVRSENNQSTWo6WwsLNfUBDZXL9zNJRoiAH6kF/6Y
         09+ALOGNTdw4AlKG0j87SxWDb6fAjq6dmpp56TOJVfnQSEceqkl0pkdXktanEaM+qWh2
         hVrPQBmmzSppTvYuuYEsBBID9qHU2F6ZEfL9R9mmheyfmazNqIepcB0WFLo2vJx0DOF/
         mcFg==
X-Gm-Message-State: AAQBX9cXZaPBHdZ5fNfRujhhMStH1XdyJWaXbfsgvYooYa4v4SOQca81
        cAD4SwksFdJr3xRYxrSMxZiZlBQnyvQjJo3ZmlXasZGoAPeb9iHQQqCPmqaHNN8Xe1b/0CWq4R5
        /8tU0K4+xQJQPtHE=
X-Received: by 2002:a19:c503:0:b0:4db:513b:6ef4 with SMTP id w3-20020a19c503000000b004db513b6ef4mr2801667lfe.11.1682307701252;
        Sun, 23 Apr 2023 20:41:41 -0700 (PDT)
X-Google-Smtp-Source: AKy350akLmVLz77aNwLtIlKSi4nJUWSFQY6BgoD/WOht8xio4frsi16eCfgOgUB/LaSrLLzhy5Ej9A==
X-Received: by 2002:a19:c503:0:b0:4db:513b:6ef4 with SMTP id w3-20020a19c503000000b004db513b6ef4mr2801666lfe.11.1682307700896;
        Sun, 23 Apr 2023 20:41:40 -0700 (PDT)
Received: from [192.168.1.121] (85-23-48-202.bb.dnainternet.fi. [85.23.48.202])
        by smtp.gmail.com with ESMTPSA id a5-20020a056512374500b004db3d57c3a8sm1510791lfs.96.2023.04.23.20.41.39
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Sun, 23 Apr 2023 20:41:40 -0700 (PDT)
Message-ID: <4b599782-3512-a177-c5b5-c562a22886c7@redhat.com>
Date:   Mon, 24 Apr 2023 06:41:38 +0300
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:102.0) Gecko/20100101
 Thunderbird/102.10.0
Subject: Re: [PATCH] mm/gup: disallow GUP writing to file-backed mappings by
 default
Content-Language: en-US
To:     Lorenzo Stoakes <lstoakes@gmail.com>, linux-mm@kvack.org,
        linux-kernel@vger.kernel.org,
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
        netdev@vger.kernel.org, bpf@vger.kernel.org
References: <f86dc089b460c80805e321747b0898fd1efe93d7.1682168199.git.lstoakes@gmail.com>
From:   =?UTF-8?Q?Mika_Penttil=c3=a4?= <mpenttil@redhat.com>
In-Reply-To: <f86dc089b460c80805e321747b0898fd1efe93d7.1682168199.git.lstoakes@gmail.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
X-Spam-Status: No, score=-4.4 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,NICE_REPLY_A,
        RCVD_IN_DNSWL_NONE,RCVD_IN_MSPIKE_H2,SPF_HELO_NONE,SPF_NONE,
        T_SCC_BODY_TEXT_LINE autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org


Hi,


On 22.4.2023 16.37, Lorenzo Stoakes wrote:
> It isn't safe to write to file-backed mappings as GUP does not ensure that
> the semantics associated with such a write are performed correctly, for
> instance filesystems which rely upon write-notify will not be correctly
> notified.
> 
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
>   drivers/infiniband/hw/qib/qib_user_pages.c |  3 +-
>   drivers/infiniband/hw/usnic/usnic_uiom.c   |  2 +-
>   drivers/infiniband/sw/siw/siw_mem.c        |  3 +-
>   fs/proc/base.c                             |  3 +-
>   include/linux/mm_types.h                   |  8 +++++
>   kernel/events/uprobes.c                    |  3 +-
>   mm/gup.c                                   | 36 +++++++++++++++++++++-
>   mm/memory.c                                |  3 +-
>   mm/process_vm_access.c                     |  2 +-
>   net/xdp/xdp_umem.c                         |  2 +-
>   10 files changed, 56 insertions(+), 9 deletions(-)
> 
> diff --git a/drivers/infiniband/hw/qib/qib_user_pages.c b/drivers/infiniband/hw/qib/qib_user_pages.c
> index f693bc753b6b..b9019dad8008 100644
> --- a/drivers/infiniband/hw/qib/qib_user_pages.c
> +++ b/drivers/infiniband/hw/qib/qib_user_pages.c
> @@ -110,7 +110,8 @@ int qib_get_user_pages(unsigned long start_page, size_t num_pages,
>   	for (got = 0; got < num_pages; got += ret) {
>   		ret = pin_user_pages(start_page + got * PAGE_SIZE,
>   				     num_pages - got,
> -				     FOLL_LONGTERM | FOLL_WRITE,
> +				     FOLL_LONGTERM | FOLL_WRITE |
> +				     FOLL_ALLOW_BROKEN_FILE_MAPPING,
>   				     p + got, NULL);
>   		if (ret < 0) {
>   			mmap_read_unlock(current->mm);
> diff --git a/drivers/infiniband/hw/usnic/usnic_uiom.c b/drivers/infiniband/hw/usnic/usnic_uiom.c
> index 2a5cac2658ec..33cf79b248a9 100644
> --- a/drivers/infiniband/hw/usnic/usnic_uiom.c
> +++ b/drivers/infiniband/hw/usnic/usnic_uiom.c
> @@ -85,7 +85,7 @@ static int usnic_uiom_get_pages(unsigned long addr, size_t size, int writable,
>   				int dmasync, struct usnic_uiom_reg *uiomr)
>   {
>   	struct list_head *chunk_list = &uiomr->chunk_list;
> -	unsigned int gup_flags = FOLL_LONGTERM;
> +	unsigned int gup_flags = FOLL_LONGTERM | FOLL_ALLOW_BROKEN_FILE_MAPPING;
>   	struct page **page_list;
>   	struct scatterlist *sg;
>   	struct usnic_uiom_chunk *chunk;
> diff --git a/drivers/infiniband/sw/siw/siw_mem.c b/drivers/infiniband/sw/siw/siw_mem.c
> index f51ab2ccf151..bc3e8c0898e5 100644
> --- a/drivers/infiniband/sw/siw/siw_mem.c
> +++ b/drivers/infiniband/sw/siw/siw_mem.c
> @@ -368,7 +368,8 @@ struct siw_umem *siw_umem_get(u64 start, u64 len, bool writable)
>   	struct mm_struct *mm_s;
>   	u64 first_page_va;
>   	unsigned long mlock_limit;
> -	unsigned int foll_flags = FOLL_LONGTERM;
> +	unsigned int foll_flags =
> +		FOLL_LONGTERM | FOLL_ALLOW_BROKEN_FILE_MAPPING;
>   	int num_pages, num_chunks, i, rv = 0;
>   
>   	if (!can_do_mlock())
> diff --git a/fs/proc/base.c b/fs/proc/base.c
> index 96a6a08c8235..3e3f5ea9849f 100644
> --- a/fs/proc/base.c
> +++ b/fs/proc/base.c
> @@ -855,7 +855,8 @@ static ssize_t mem_rw(struct file *file, char __user *buf,
>   	if (!mmget_not_zero(mm))
>   		goto free;
>   
> -	flags = FOLL_FORCE | (write ? FOLL_WRITE : 0);
> +	flags = FOLL_FORCE | FOLL_ALLOW_BROKEN_FILE_MAPPING |
> +		(write ? FOLL_WRITE : 0);
>   
>   	while (count > 0) {
>   		size_t this_len = min_t(size_t, count, PAGE_SIZE);
> diff --git a/include/linux/mm_types.h b/include/linux/mm_types.h
> index 3fc9e680f174..e76637b4c78f 100644
> --- a/include/linux/mm_types.h
> +++ b/include/linux/mm_types.h
> @@ -1185,6 +1185,14 @@ enum {
>   	FOLL_PCI_P2PDMA = 1 << 10,
>   	/* allow interrupts from generic signals */
>   	FOLL_INTERRUPTIBLE = 1 << 11,
> +	/*
> +	 * By default we disallow write access to known broken file-backed
> +	 * memory mappings (i.e. anything other than hugetlb/shmem
> +	 * mappings). Some code may rely upon being able to access this
> +	 * regardless for legacy reasons, thus we provide a flag to indicate
> +	 * this.
> +	 */
> +	FOLL_ALLOW_BROKEN_FILE_MAPPING = 1 << 12,
>   
>   	/* See also internal only FOLL flags in mm/internal.h */
>   };
> diff --git a/kernel/events/uprobes.c b/kernel/events/uprobes.c
> index 59887c69d54c..ec330d3b0218 100644
> --- a/kernel/events/uprobes.c
> +++ b/kernel/events/uprobes.c
> @@ -373,7 +373,8 @@ __update_ref_ctr(struct mm_struct *mm, unsigned long vaddr, short d)
>   		return -EINVAL;
>   
>   	ret = get_user_pages_remote(mm, vaddr, 1,
> -			FOLL_WRITE, &page, &vma, NULL);
> +				    FOLL_WRITE | FOLL_ALLOW_BROKEN_FILE_MAPPING,
> +				    &page, &vma, NULL);
>   	if (unlikely(ret <= 0)) {
>   		/*
>   		 * We are asking for 1 page. If get_user_pages_remote() fails,
> diff --git a/mm/gup.c b/mm/gup.c
> index 1f72a717232b..68d5570c0bae 100644
> --- a/mm/gup.c
> +++ b/mm/gup.c
> @@ -959,16 +959,46 @@ static int faultin_page(struct vm_area_struct *vma,
>   	return 0;
>   }
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
>   static int check_vma_flags(struct vm_area_struct *vma, unsigned long gup_flags)
>   {
>   	vm_flags_t vm_flags = vma->vm_flags;
>   	int write = (gup_flags & FOLL_WRITE);
>   	int foreign = (gup_flags & FOLL_REMOTE);
> +	bool vma_anon = vma_is_anonymous(vma);
>   
>   	if (vm_flags & (VM_IO | VM_PFNMAP))
>   		return -EFAULT;
>   
> -	if (gup_flags & FOLL_ANON && !vma_is_anonymous(vma))
> +	if ((gup_flags & FOLL_ANON) && !vma_anon)
>   		return -EFAULT;
>   
>   	if ((gup_flags & FOLL_LONGTERM) && vma_is_fsdax(vma))
> @@ -978,6 +1008,10 @@ static int check_vma_flags(struct vm_area_struct *vma, unsigned long gup_flags)
>   		return -EFAULT;
>   
>   	if (write) {
> +		if (!vma_anon &&
> +		    WARN_ON_ONCE(!can_write_file_mapping(vma, gup_flags)))
> +			return -EFAULT;
> +
>   		if (!(vm_flags & VM_WRITE)) {
>   			if (!(gup_flags & FOLL_FORCE))
>   				return -EFAULT;
> diff --git a/mm/memory.c b/mm/memory.c
> index 146bb94764f8..e3d535991548 100644
> --- a/mm/memory.c
> +++ b/mm/memory.c
> @@ -5683,7 +5683,8 @@ int access_process_vm(struct task_struct *tsk, unsigned long addr,
>   	if (!mm)
>   		return 0;
>   
> -	ret = __access_remote_vm(mm, addr, buf, len, gup_flags);
> +	ret = __access_remote_vm(mm, addr, buf, len,
> +				 gup_flags | FOLL_ALLOW_BROKEN_FILE_MAPPING);
>   
>   	mmput(mm);
>   
> diff --git a/mm/process_vm_access.c b/mm/process_vm_access.c
> index 78dfaf9e8990..ef126c08e89c 100644
> --- a/mm/process_vm_access.c
> +++ b/mm/process_vm_access.c
> @@ -81,7 +81,7 @@ static int process_vm_rw_single_vec(unsigned long addr,
>   	ssize_t rc = 0;
>   	unsigned long max_pages_per_loop = PVM_MAX_KMALLOC_PAGES
>   		/ sizeof(struct pages *);
> -	unsigned int flags = 0;
> +	unsigned int flags = FOLL_ALLOW_BROKEN_FILE_MAPPING;
>   
>   	/* Work out address and page range required */
>   	if (len == 0)
> diff --git a/net/xdp/xdp_umem.c b/net/xdp/xdp_umem.c
> index 02207e852d79..b93cfcaccb0d 100644
> --- a/net/xdp/xdp_umem.c
> +++ b/net/xdp/xdp_umem.c
> @@ -93,7 +93,7 @@ void xdp_put_umem(struct xdp_umem *umem, bool defer_cleanup)
>   
>   static int xdp_umem_pin_pages(struct xdp_umem *umem, unsigned long address)
>   {
> -	unsigned int gup_flags = FOLL_WRITE;
> +	unsigned int gup_flags = FOLL_WRITE | FOLL_ALLOW_BROKEN_FILE_MAPPING;
>   	long npgs;
>   	int err;
>   

Not sure about this in general, but seemss at least ptrace 
(ptrace_access_vm()) seems to be broken here..


--Mika


