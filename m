Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 917F86F10FB
	for <lists+netdev@lfdr.de>; Fri, 28 Apr 2023 06:22:09 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1345289AbjD1EWH (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 28 Apr 2023 00:22:07 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:36698 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1345264AbjD1EV7 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 28 Apr 2023 00:21:59 -0400
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.133.124])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 9D54D273E
        for <netdev@vger.kernel.org>; Thu, 27 Apr 2023 21:21:11 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1682655670;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=HUpymbe2RGMA86yPaoLtY13w/BGrFU5diMfKlivoc0Q=;
        b=QGUiAcKgR8rRzEofNB2zJi5OJ5aeJz0B/ZFghU8niLpgU61m7YHPaPNxaiIr/slqRH4Qy5
        LXmgvT02Qq69o8g0ZbkFgkRDCeRb5PMoPyk1798oDkIuvVpB3mijvbhBCl3qoau9R4lAe8
        oGyhpMkxaC2QGMaVKmKWsfIPIS7T0Dk=
Received: from mail-lf1-f72.google.com (mail-lf1-f72.google.com
 [209.85.167.72]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.3, cipher=TLS_AES_256_GCM_SHA384) id
 us-mta-534-1ZRd195hPueD0cUa73ZbXQ-1; Fri, 28 Apr 2023 00:21:08 -0400
X-MC-Unique: 1ZRd195hPueD0cUa73ZbXQ-1
Received: by mail-lf1-f72.google.com with SMTP id 2adb3069b0e04-4f00d41e0a7so4088902e87.1
        for <netdev@vger.kernel.org>; Thu, 27 Apr 2023 21:21:08 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20221208; t=1682655667; x=1685247667;
        h=content-transfer-encoding:in-reply-to:from:references:cc:to
         :content-language:subject:user-agent:mime-version:date:message-id
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=HUpymbe2RGMA86yPaoLtY13w/BGrFU5diMfKlivoc0Q=;
        b=bxeQeNDmX3trqgxiURR1Lfx8hcRN/oDdaf8Jeq/rAEH7tuS9F3l6g10BM5LjZsDgfW
         U1deF1Dlb5j3p9BUqAGhoTOAXHkSCZNb6jXzSLlKovXns7HNSx1avCqOMi3xJqYDlBFv
         toj7WidaR+2nvUhVCP09FqVc9tCAya2lYeLhCh+/hfgljs0lyFR6ZXkSPWtLumdoqlm9
         RRdTmYQIlMPV54ggU8rCK5whBhRs6rq/Mwwk5jYa1qH7DbpeaJt38oaCYRq1hg2Zdx+b
         4QAslsw5/XkFdQHuE94V2pWNOm2xvdMnhn1ASulF9cCfkcLnUBEJ1Li6nyN+PiA3Qsg6
         CAdA==
X-Gm-Message-State: AC+VfDyJuovRP29oShyO7t+MPIRdOJ/V6q/SzNlJ/cGxapAOzrOAJL4L
        rhf3qebm3p8PiDCPhDPZgvOUzQxiw3mjLkO/zuFEnF4BktL5F0h7j2OBlh7n1zPW9e2BnwT6+Ix
        f/RIdLb4NOcgWSFo=
X-Received: by 2002:a2e:9f05:0:b0:2ab:2c7c:507f with SMTP id u5-20020a2e9f05000000b002ab2c7c507fmr1057062ljk.15.1682655667265;
        Thu, 27 Apr 2023 21:21:07 -0700 (PDT)
X-Google-Smtp-Source: ACHHUZ4xYYyesjptJcHcm8yBwlV8SIBaW191/q6NabvCec2b1etZ3S1kKdDOZy7gcBfgds3uQvPBSw==
X-Received: by 2002:a2e:9f05:0:b0:2ab:2c7c:507f with SMTP id u5-20020a2e9f05000000b002ab2c7c507fmr1057046ljk.15.1682655666887;
        Thu, 27 Apr 2023 21:21:06 -0700 (PDT)
Received: from [192.168.1.121] (85-23-48-202.bb.dnainternet.fi. [85.23.48.202])
        by smtp.gmail.com with ESMTPSA id j21-20020a2e8255000000b002ab0d1c9412sm1953021ljh.139.2023.04.27.21.21.05
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Thu, 27 Apr 2023 21:21:06 -0700 (PDT)
Message-ID: <3024df40-4c20-867d-8b88-b32aaa04501d@redhat.com>
Date:   Fri, 28 Apr 2023 07:21:04 +0300
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:102.0) Gecko/20100101
 Thunderbird/102.10.0
Subject: Re: [PATCH v5] mm/gup: disallow GUP writing to file-backed mappings
 by default
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
        netdev@vger.kernel.org, bpf@vger.kernel.org,
        Oleg Nesterov <oleg@redhat.com>,
        Jason Gunthorpe <jgg@nvidia.com>,
        John Hubbard <jhubbard@nvidia.com>, Jan Kara <jack@suse.cz>,
        "Kirill A . Shutemov" <kirill@shutemov.name>,
        Pavel Begunkov <asml.silence@gmail.com>
References: <6b73e692c2929dc4613af711bdf92e2ec1956a66.1682638385.git.lstoakes@gmail.com>
From:   =?UTF-8?Q?Mika_Penttil=c3=a4?= <mpenttil@redhat.com>
In-Reply-To: <6b73e692c2929dc4613af711bdf92e2ec1956a66.1682638385.git.lstoakes@gmail.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-3.7 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,NICE_REPLY_A,
        RCVD_IN_DNSWL_NONE,RCVD_IN_MSPIKE_H2,SPF_HELO_NONE,SPF_NONE,
        T_SCC_BODY_TEXT_LINE autolearn=unavailable autolearn_force=no
        version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org



On 28.4.2023 2.42, Lorenzo Stoakes wrote:
> Writing to file-backed mappings which require folio dirty tracking using
> GUP is a fundamentally broken operation, as kernel write access to GUP
> mappings do not adhere to the semantics expected by a file system.
> 
> A GUP caller uses the direct mapping to access the folio, which does not
> cause write notify to trigger, nor does it enforce that the caller marks
> the folio dirty.
> 
> The problem arises when, after an initial write to the folio, writeback
> results in the folio being cleaned and then the caller, via the GUP
> interface, writes to the folio again.
> 
> As a result of the use of this secondary, direct, mapping to the folio no
> write notify will occur, and if the caller does mark the folio dirty, this
> will be done so unexpectedly.
> 
> For example, consider the following scenario:-
> 
> 1. A folio is written to via GUP which write-faults the memory, notifying
>     the file system and dirtying the folio.
> 2. Later, writeback is triggered, resulting in the folio being cleaned and
>     the PTE being marked read-only.
> 3. The GUP caller writes to the folio, as it is mapped read/write via the
>     direct mapping.
> 4. The GUP caller, now done with the page, unpins it and sets it dirty
>     (though it does not have to).
> 
> This results in both data being written to a folio without writenotify, and
> the folio being dirtied unexpectedly (if the caller decides to do so).
> 
> This issue was first reported by Jan Kara [1] in 2018, where the problem
> resulted in file system crashes.
> 
> This is only relevant when the mappings are file-backed and the underlying
> file system requires folio dirty tracking. File systems which do not, such
> as shmem or hugetlb, are not at risk and therefore can be written to
> without issue.
> 
> Unfortunately this limitation of GUP has been present for some time and
> requires future rework of the GUP API in order to provide correct write
> access to such mappings.
> 
> However, for the time being we introduce this check to prevent the most
> egregious case of this occurring, use of the FOLL_LONGTERM pin.
> 
> These mappings are considerably more likely to be written to after
> folios are cleaned and thus simply must not be permitted to do so.
> 
> As part of this change we separate out vma_needs_dirty_tracking() as a
> helper function to determine this which is distinct from
> vma_wants_writenotify() which is specific to determining which PTE flags to
> set.
> 
> [1]:https://lore.kernel.org/linux-mm/20180103100430.GE4911@quack2.suse.cz/
> 
> Suggested-by: Jason Gunthorpe <jgg@nvidia.com>
> Signed-off-by: Lorenzo Stoakes <lstoakes@gmail.com>
> ---
>   include/linux/mm.h |  1 +
>   mm/gup.c           | 41 ++++++++++++++++++++++++++++++++++++++++-
>   mm/mmap.c          | 36 +++++++++++++++++++++++++++---------
>   3 files changed, 68 insertions(+), 10 deletions(-)
> 
Thanks Lorenzo for the added patch descriptions!

Reviewed-by: Mika Penttilä <mpenttil@redhat.com>



> diff --git a/include/linux/mm.h b/include/linux/mm.h
> index 37554b08bb28..f7da02fc89c6 100644
> --- a/include/linux/mm.h
> +++ b/include/linux/mm.h
> @@ -2433,6 +2433,7 @@ extern unsigned long move_page_tables(struct vm_area_struct *vma,
>   #define  MM_CP_UFFD_WP_ALL                 (MM_CP_UFFD_WP | \
>   					    MM_CP_UFFD_WP_RESOLVE)
> 
> +bool vma_needs_dirty_tracking(struct vm_area_struct *vma);
>   int vma_wants_writenotify(struct vm_area_struct *vma, pgprot_t vm_page_prot);
>   static inline bool vma_wants_manual_pte_write_upgrade(struct vm_area_struct *vma)
>   {
> diff --git a/mm/gup.c b/mm/gup.c
> index 1f72a717232b..d36a5db9feb1 100644
> --- a/mm/gup.c
> +++ b/mm/gup.c
> @@ -959,16 +959,51 @@ static int faultin_page(struct vm_area_struct *vma,
>   	return 0;
>   }
> 
> +/*
> + * Writing to file-backed mappings which require folio dirty tracking using GUP
> + * is a fundamentally broken operation, as kernel write access to GUP mappings
> + * do not adhere to the semantics expected by a file system.
> + *
> + * Consider the following scenario:-
> + *
> + * 1. A folio is written to via GUP which write-faults the memory, notifying
> + *    the file system and dirtying the folio.
> + * 2. Later, writeback is triggered, resulting in the folio being cleaned and
> + *    the PTE being marked read-only.
> + * 3. The GUP caller writes to the folio, as it is mapped read/write via the
> + *    direct mapping.
> + * 4. The GUP caller, now done with the page, unpins it and sets it dirty
> + *    (though it does not have to).
> + *
> + * This results in both data being written to a folio without writenotify, and
> + * the folio being dirtied unexpectedly (if the caller decides to do so).
> + */
> +static bool writeable_file_mapping_allowed(struct vm_area_struct *vma,
> +					   unsigned long gup_flags)
> +{
> +	/* If we aren't pinning then no problematic write can occur. */
> +	if (!(gup_flags & (FOLL_GET | FOLL_PIN)))
> +		return true;
> +
> +	/* We limit this check to the most egregious case - a long term pin. */
> +	if (!(gup_flags & FOLL_LONGTERM))
> +		return true;
> +
> +	/* If the VMA requires dirty tracking then GUP will be problematic. */
> +	return vma_needs_dirty_tracking(vma);
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
> @@ -978,6 +1013,10 @@ static int check_vma_flags(struct vm_area_struct *vma, unsigned long gup_flags)
>   		return -EFAULT;
> 
>   	if (write) {
> +		if (!vma_anon &&
> +		    !writeable_file_mapping_allowed(vma, gup_flags))
> +			return -EFAULT;
> +
>   		if (!(vm_flags & VM_WRITE)) {
>   			if (!(gup_flags & FOLL_FORCE))
>   				return -EFAULT;
> diff --git a/mm/mmap.c b/mm/mmap.c
> index 536bbb8fa0ae..7b6344d1832a 100644
> --- a/mm/mmap.c
> +++ b/mm/mmap.c
> @@ -1475,6 +1475,31 @@ SYSCALL_DEFINE1(old_mmap, struct mmap_arg_struct __user *, arg)
>   }
>   #endif /* __ARCH_WANT_SYS_OLD_MMAP */
> 
> +/* Do VMA operations imply write notify is required? */
> +static bool vm_ops_needs_writenotify(const struct vm_operations_struct *vm_ops)
> +{
> +	return vm_ops && (vm_ops->page_mkwrite || vm_ops->pfn_mkwrite);
> +}
> +
> +/*
> + * Does this VMA require the underlying folios to have their dirty state
> + * tracked?
> + */
> +bool vma_needs_dirty_tracking(struct vm_area_struct *vma)
> +{
> +	/* Does the filesystem need to be notified? */
> +	if (vm_ops_needs_writenotify(vma->vm_ops))
> +		return true;
> +
> +	/* Specialty mapping? */
> +	if (vma->vm_flags & VM_PFNMAP)
> +		return false;
> +
> +	/* Can the mapping track the dirty pages? */
> +	return vma->vm_file && vma->vm_file->f_mapping &&
> +		mapping_can_writeback(vma->vm_file->f_mapping);
> +}
> +
>   /*
>    * Some shared mappings will want the pages marked read-only
>    * to track write events. If so, we'll downgrade vm_page_prot
> @@ -1484,14 +1509,13 @@ SYSCALL_DEFINE1(old_mmap, struct mmap_arg_struct __user *, arg)
>   int vma_wants_writenotify(struct vm_area_struct *vma, pgprot_t vm_page_prot)
>   {
>   	vm_flags_t vm_flags = vma->vm_flags;
> -	const struct vm_operations_struct *vm_ops = vma->vm_ops;
> 
>   	/* If it was private or non-writable, the write bit is already clear */
>   	if ((vm_flags & (VM_WRITE|VM_SHARED)) != ((VM_WRITE|VM_SHARED)))
>   		return 0;
> 
>   	/* The backer wishes to know when pages are first written to? */
> -	if (vm_ops && (vm_ops->page_mkwrite || vm_ops->pfn_mkwrite))
> +	if (vm_ops_needs_writenotify(vma->vm_ops))
>   		return 1;
> 
>   	/* The open routine did something to the protections that pgprot_modify
> @@ -1511,13 +1535,7 @@ int vma_wants_writenotify(struct vm_area_struct *vma, pgprot_t vm_page_prot)
>   	if (userfaultfd_wp(vma))
>   		return 1;
> 
> -	/* Specialty mapping? */
> -	if (vm_flags & VM_PFNMAP)
> -		return 0;
> -
> -	/* Can the mapping track the dirty pages? */
> -	return vma->vm_file && vma->vm_file->f_mapping &&
> -		mapping_can_writeback(vma->vm_file->f_mapping);
> +	return vma_needs_dirty_tracking(vma);
>   }
> 
>   /*
> --
> 2.40.0
> 

