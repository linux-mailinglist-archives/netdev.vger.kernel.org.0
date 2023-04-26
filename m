Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id A23B56EEF50
	for <lists+netdev@lfdr.de>; Wed, 26 Apr 2023 09:31:01 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S239733AbjDZHa7 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 26 Apr 2023 03:30:59 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:38354 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S239596AbjDZHa5 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 26 Apr 2023 03:30:57 -0400
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.129.124])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 3FB3A35A0
        for <netdev@vger.kernel.org>; Wed, 26 Apr 2023 00:30:10 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1682494209;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=qLspASTGSiAR360dsQr/mZmbgGL5Gs/KZwVbTVVr1Hc=;
        b=UvF1sGjckXoEBhcXuQktM6sXaUDNfl76mCz73AxmJytRyQBFLLB5k/fVXU2YLglAlk9SlX
        6dSALVuUR02od972tmAN0hqTz5lRWQSlQGkUIHYe+eSMmsoOtuqNXAA24awepD27a7rFpy
        na2HS54NfPkMEHzLklh2+dY+arSwlrI=
Received: from mail-lf1-f71.google.com (mail-lf1-f71.google.com
 [209.85.167.71]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.3, cipher=TLS_AES_256_GCM_SHA384) id
 us-mta-401--ZF4cJitOcKXL8QmelGEPw-1; Wed, 26 Apr 2023 03:30:07 -0400
X-MC-Unique: -ZF4cJitOcKXL8QmelGEPw-1
Received: by mail-lf1-f71.google.com with SMTP id 2adb3069b0e04-4edc7ab63ccso3173391e87.3
        for <netdev@vger.kernel.org>; Wed, 26 Apr 2023 00:30:07 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20221208; t=1682494206; x=1685086206;
        h=content-transfer-encoding:in-reply-to:from:references:cc:to
         :content-language:subject:user-agent:mime-version:date:message-id
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=qLspASTGSiAR360dsQr/mZmbgGL5Gs/KZwVbTVVr1Hc=;
        b=bvsI2O4xGTtNdd+W/6aj03Ga87lgCCa0evx/IxNTr2O4xJpmbIK1A2dhgU0BV+LRCC
         aoO6pE5ogr/HzEL2NzmIBU7zcg7BclvJX+UEmFmR3GxiuWgYtiJFs5PCn/13JKGoytjk
         tqmkIodRRGiCVFc8W7bLDI6teIgDUHTvUwEsibDrhXhCE3tDgcV2SR6uif6qdxSGULG8
         Tg4DbnToO9f3x+YqvbnXKBdfWl2PAsFPGR+1VhEDM8JT+ZYwLrXeFw2htOkz8HxPmwHZ
         jiDweNeF95vnt8VKeGFPhqAvywqyTTI9l7+iMhnv6cwPljjLNcMoabUMpvWT6s/69O6o
         M9Qw==
X-Gm-Message-State: AAQBX9ffa0X5zXdYsl6j5LlPliQWv81wda9Xd9C9nNHvPlra11g8lNff
        vJYtWvPuXCxukRwxgJ/dY8IW0n6Mq4As/pxdWOOyUhX9MeIpHFkOnHYf9v7Z7Uz33tc05tP9tAC
        62D+HFOdwIPKcHAM=
X-Received: by 2002:a05:6512:926:b0:4ef:ebb2:afe0 with SMTP id f6-20020a056512092600b004efebb2afe0mr2981920lft.42.1682494206352;
        Wed, 26 Apr 2023 00:30:06 -0700 (PDT)
X-Google-Smtp-Source: AKy350YTqQZn3KVY6F+7bINc/LgeaavbJ1qPFgjrUawfxC7IL7luA2996opUteRvieyUOhaupPLzEQ==
X-Received: by 2002:a05:6512:926:b0:4ef:ebb2:afe0 with SMTP id f6-20020a056512092600b004efebb2afe0mr2981899lft.42.1682494205916;
        Wed, 26 Apr 2023 00:30:05 -0700 (PDT)
Received: from [192.168.1.121] (85-23-48-202.bb.dnainternet.fi. [85.23.48.202])
        by smtp.gmail.com with ESMTPSA id 5-20020ac25685000000b004ec7c0f2178sm2362493lfr.63.2023.04.26.00.30.03
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Wed, 26 Apr 2023 00:30:04 -0700 (PDT)
Message-ID: <831f0d02-7671-97bf-a968-e2e5bf92dfd7@redhat.com>
Date:   Wed, 26 Apr 2023 10:30:03 +0300
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:102.0) Gecko/20100101
 Thunderbird/102.10.0
Subject: Re: [PATCH v4] mm/gup: disallow GUP writing to file-backed mappings
 by default
Content-Language: en-US
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
        David Hildenbrand <david@redhat.com>
References: <3b92d56f55671a0389252379237703df6e86ea48.1682464032.git.lstoakes@gmail.com>
 <a68fa8f2-8619-63ff-3525-ede7ed1f0a9f@redhat.com>
 <5ffd7f32-d236-4da4-93f7-c2fe39a6e035@lucifer.local>
 <aa0d9a98-7dd1-0188-d382-5835cf1ddf3a@redhat.com>
 <b7f8daba-1250-4a45-895e-cbb20cc6c2dd@lucifer.local>
From:   =?UTF-8?Q?Mika_Penttil=c3=a4?= <mpenttil@redhat.com>
In-Reply-To: <b7f8daba-1250-4a45-895e-cbb20cc6c2dd@lucifer.local>
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



On 26.4.2023 10.20, Lorenzo Stoakes wrote:
> On Wed, Apr 26, 2023 at 10:10:14AM +0300, Mika Penttilä wrote:
>>
>>
>> On 26.4.2023 10.00, Lorenzo Stoakes wrote:
>>> On Wed, Apr 26, 2023 at 06:18:38AM +0300, Mika Penttilä wrote:
>>>> Hi,
>>>>
>>>>
>>>> On 26.4.2023 2.15, Lorenzo Stoakes wrote:
>>>>> GUP does not correctly implement write-notify semantics, nor does it
>>>>> guarantee that the underlying pages are correctly dirtied, which could lead
>>>>> to a kernel oops or data corruption when writing to file-backed mappings.
>>>>>
>>>>> This is only relevant when the mappings are file-backed and the underlying
>>>>> file system requires folio dirty tracking. File systems which do not, such
>>>>> as shmem or hugetlb, are not at risk and therefore can be written to
>>>>> without issue.
>>>>>
>>>>> Unfortunately this limitation of GUP has been present for some time and
>>>>> requires future rework of the GUP API in order to provide correct write
>>>>> access to such mappings.
>>>>>
>>>>> In the meantime, we add a check for the most broken GUP case -
>>>>> FOLL_LONGTERM - which really under no circumstances can safely access
>>>>> dirty-tracked file mappings.
>>>>>
>>>>> As part of this change we separate out vma_needs_dirty_tracking() as a
>>>>> helper function to determine this, which is distinct from
>>>>> vma_wants_writenotify() which is specific to determining which PTE flags to
>>>>> set.
>>>>>
>>>>> Suggested-by: Jason Gunthorpe <jgg@nvidia.com>
>>>>> Signed-off-by: Lorenzo Stoakes <lstoakes@gmail.com>
>>>>> ---
>>>>> v4:
>>>>> - Split out vma_needs_dirty_tracking() from vma_wants_writenotify() to reduce
>>>>>      duplication and update to use this in the GUP check. Note that both separately
>>>>>      check vm_ops_needs_writenotify() as the latter needs to test this before the
>>>>>      vm_pgprot_modify() test, resulting in vma_wants_writenotify() checking this
>>>>>      twice, however it is such a small check this should not be egregious.
>>>>>
>>>>> v3:
>>>>> - Rebased on latest mm-unstable as of 24th April 2023.
>>>>> - Explicitly check whether file system requires folio dirtying. Note that
>>>>>      vma_wants_writenotify() could not be used directly as it is very much focused
>>>>>      on determining if the PTE r/w should be set (e.g. assuming private mapping
>>>>>      does not require it as already set, soft dirty considerations).
>>>>> - Tested code against shmem and hugetlb mappings - confirmed that these are not
>>>>>      disallowed by the check.
>>>>> - Eliminate FOLL_ALLOW_BROKEN_FILE_MAPPING flag and instead perform check only
>>>>>      for FOLL_LONGTERM pins.
>>>>> - As a result, limit check to internal GUP code.
>>>>>     https://lore.kernel.org/all/23c19e27ef0745f6d3125976e047ee0da62569d4.1682406295.git.lstoakes@gmail.com/
>>>>>
>>>>> v2:
>>>>> - Add accidentally excluded ptrace_access_vm() use of
>>>>>      FOLL_ALLOW_BROKEN_FILE_MAPPING.
>>>>> - Tweak commit message.
>>>>> https://lore.kernel.org/all/c8ee7e02d3d4f50bb3e40855c53bda39eec85b7d.1682321768.git.lstoakes@gmail.com/
>>>>>
>>>>> v1:
>>>>> https://lore.kernel.org/all/f86dc089b460c80805e321747b0898fd1efe93d7.1682168199.git.lstoakes@gmail.com/
>>>>>
>>>>>     include/linux/mm.h |  1 +
>>>>>     mm/gup.c           | 26 +++++++++++++++++++++++++-
>>>>>     mm/mmap.c          | 37 ++++++++++++++++++++++++++++---------
>>>>>     3 files changed, 54 insertions(+), 10 deletions(-)
>>>>>
>>>>> diff --git a/include/linux/mm.h b/include/linux/mm.h
>>>>> index 37554b08bb28..f7da02fc89c6 100644
>>>>> --- a/include/linux/mm.h
>>>>> +++ b/include/linux/mm.h
>>>>> @@ -2433,6 +2433,7 @@ extern unsigned long move_page_tables(struct vm_area_struct *vma,
>>>>>     #define  MM_CP_UFFD_WP_ALL                 (MM_CP_UFFD_WP | \
>>>>>     					    MM_CP_UFFD_WP_RESOLVE)
>>>>> +bool vma_needs_dirty_tracking(struct vm_area_struct *vma);
>>>>>     int vma_wants_writenotify(struct vm_area_struct *vma, pgprot_t vm_page_prot);
>>>>>     static inline bool vma_wants_manual_pte_write_upgrade(struct vm_area_struct *vma)
>>>>>     {
>>>>> diff --git a/mm/gup.c b/mm/gup.c
>>>>> index 1f72a717232b..53652453037c 100644
>>>>> --- a/mm/gup.c
>>>>> +++ b/mm/gup.c
>>>>> @@ -959,16 +959,37 @@ static int faultin_page(struct vm_area_struct *vma,
>>>>>     	return 0;
>>>>>     }
>>>>> +/*
>>>>> + * Writing to file-backed mappings which require folio dirty tracking using GUP
>>>>> + * is a fundamentally broken operation as kernel write access to GUP mappings
>>>>> + * may not adhere to the semantics expected by a file system.
>>>>> + */
>>>>> +static inline bool can_write_file_mapping(struct vm_area_struct *vma,
>>>>> +					  unsigned long gup_flags)
>>>>> +{
>>>>> +	/* If we aren't pinning then no problematic write can occur. */
>>>>> +	if (!(gup_flags & (FOLL_GET | FOLL_PIN)))
>>>>> +		return true;
>>>>> +
>>>>> +	/* We limit this check to the most egregious case - a long term pin. */
>>>>> +	if (!(gup_flags & FOLL_LONGTERM))
>>>>> +		return true;
>>>>> +
>>>>> +	/* If the VMA requires dirty tracking then GUP will be problematic. */
>>>>> +	return vma_needs_dirty_tracking(vma);
>>>>> +}
>>>>> +
>>>>>     static int check_vma_flags(struct vm_area_struct *vma, unsigned long gup_flags)
>>>>>     {
>>>>>     	vm_flags_t vm_flags = vma->vm_flags;
>>>>>     	int write = (gup_flags & FOLL_WRITE);
>>>>>     	int foreign = (gup_flags & FOLL_REMOTE);
>>>>> +	bool vma_anon = vma_is_anonymous(vma);
>>>>>     	if (vm_flags & (VM_IO | VM_PFNMAP))
>>>>>     		return -EFAULT;
>>>>> -	if (gup_flags & FOLL_ANON && !vma_is_anonymous(vma))
>>>>> +	if ((gup_flags & FOLL_ANON) && !vma_anon)
>>>>>     		return -EFAULT;
>>>>>     	if ((gup_flags & FOLL_LONGTERM) && vma_is_fsdax(vma))
>>>>> @@ -978,6 +999,9 @@ static int check_vma_flags(struct vm_area_struct *vma, unsigned long gup_flags)
>>>>>     		return -EFAULT;
>>>>>     	if (write) {
>>>>> +		if (!vma_anon && !can_write_file_mapping(vma, gup_flags))
>>>>> +			return -EFAULT;
>>>>> +
>>>>>     		if (!(vm_flags & VM_WRITE)) {
>>>>>     			if (!(gup_flags & FOLL_FORCE))
>>>>>     				return -EFAULT;
>>>>> diff --git a/mm/mmap.c b/mm/mmap.c
>>>>> index 536bbb8fa0ae..aac638dd22cf 100644
>>>>> --- a/mm/mmap.c
>>>>> +++ b/mm/mmap.c
>>>>> @@ -1475,6 +1475,32 @@ SYSCALL_DEFINE1(old_mmap, struct mmap_arg_struct __user *, arg)
>>>>>     }
>>>>>     #endif /* __ARCH_WANT_SYS_OLD_MMAP */
>>>>> +/* Do VMA operations imply write notify is required? */
>>>>> +static inline bool vm_ops_needs_writenotify(
>>>>> +	const struct vm_operations_struct *vm_ops)
>>>>> +{
>>>>> +	return vm_ops && (vm_ops->page_mkwrite || vm_ops->pfn_mkwrite);
>>>>> +}
>>>>> +
>>>>> +/*
>>>>> + * Does this VMA require the underlying folios to have their dirty state
>>>>> + * tracked?
>>>>> + */
>>>>> +bool vma_needs_dirty_tracking(struct vm_area_struct *vma)
>>>>> +{
>>>>> +	/* Does the filesystem need to be notified? */
>>>>> +	if (vm_ops_needs_writenotify(vma->vm_ops))
>>>>> +		return true;
>>>>> +
>>>>> +	/* Specialty mapping? */
>>>>> +	if (vma->vm_flags & VM_PFNMAP)
>>>>> +		return false;
>>>>> +
>>>>> +	/* Can the mapping track the dirty pages? */
>>>>> +	return vma->vm_file && vma->vm_file->f_mapping &&
>>>>> +		mapping_can_writeback(vma->vm_file->f_mapping);
>>>>> +}
>>>>> +
>>>>
>>>> What would be the exact reproducer of the problem? AFAIK writenotify is
>>>> handled (by handle_mm_fault()) for non cow mappings (shared), where it only
>>>> matters.
>>>
>>> The issue is reproduced simply by page_to_virt(pinned_page)[0] = 'x' :)
>>>
>>> The problem is that no faulting actually occurs, so no writenotify, and no
>>
>>
>> Could you elaborate? GUP calls handle_mm_fault() that invokes the write
>> notify the pte is made first writable. Of course, virt(pinned_page)[0] = 'x'
>> is not supposed to fault while using the kernel mapping.
>>
> 
> The issue is how dirtying works. Typically for a dirty-tracking mapping the
> kernel makes the mapping read-only, then when a write fault occurs,
> writenotify is called and the folio is marked dirty. This way the file
> system knows which files to writeback, then after writeback it 'cleans'
> them, restoring the read-only mapping and relying on the NEXT write marking
> write notifying and marking the folio dirty again.
> 

I know how the dirty tracking works :). And gup itself actually triggers 
the _first_ fault on a read only pte.

So the problem is accessing the page after that, somewehere in future. I 
think this is something you should write on the description. Because, 
technically, GUP itself works and does invoke the write notify. So the 
misleading part is you say in the description it doesn't. While you mean 
a later write, from a driver or such, doesn't.



> If we GUP, _especially_ if it's long term, we run the risk of a write to
> the folio _after_ it has been cleaned and if the caller tries to do the
> 'right thing' and mark the folio dirty, it being marked dirty at an
> unexpected time which might race with other things and thus oops.
> 
> The issue is that this dirtying mechanism implicitly relies on the memory
> _only_ being accessed via user mappings, but we're providing another way to
> access that memory bypassing all that.
> 
> It's been a fundamental flaw in GUP for some time. This change tries to
> make things a little better by precluding the riskiest version of this
> which is the caller indicating that the pin is longterm (via
> FOLL_LONGTERM).
> 
> For an example of a user trying to sensibly avoid this, see io_pin_pages()
> in io_uring/rsrc.c. This is where io_uring tries to explicitly avoid this
> themselves, something that GUP should clearly be doing.
> 
> After this change, that code can be removed and we will live in a world
> where linux has a saner GUP :)
> 
> Of course we need to make more fundamental changes moving forward, the idea
> is this improves the situation and eliminates the need for the open-coded
> solution for io_uring which unblocks my other patch series which is also
> trying to make GUP more sane.
> 
> 
>>
>>
>>> PG_dirty tracking does either. Unexpected page dirtying can occur even
>>> after they are cleaned in folio_clear_dirty_for_io(), because the caller
>>> might manually mark the page dirty at an unexpected time as with the
>>> unpin_*dirty*() helpers.
>>>
>>> I think the long-term solution is to provide a different interface where
>>> pages are passed back briefly with locks held and with a manual invocation
>>> of writeprotect, or perhaps some kthread_use_mm() thing so we actually
>>> trigger the faulting logic, but in the meantime this change helps restore
>>> some sanity.
>>>
>>>>
>>>> GUP will only allow FOLL_FORCE without faulting for PageAnonExclusive pages.
>>>> So if you want something beyond normal cow semantics you have custom vm_ops
>>>> (and mmap() and fault())
>>>
>>> This has nothing to do with FOLL_FORCE.
>>>
>>>>
>>>> Also for longterm pinning gups vs fork vs swap there has been fixes by david
>>>> recently.
>>>
>>> I don't think these are relevant in any way to this issue.
>>>
>>>>
>>>>
>>>>
>>>>>     /*
>>>>>      * Some shared mappings will want the pages marked read-only
>>>>>      * to track write events. If so, we'll downgrade vm_page_prot
>>>>> @@ -1484,14 +1510,13 @@ SYSCALL_DEFINE1(old_mmap, struct mmap_arg_struct __user *, arg)
>>>>>     int vma_wants_writenotify(struct vm_area_struct *vma, pgprot_t vm_page_prot)
>>>>>     {
>>>>>     	vm_flags_t vm_flags = vma->vm_flags;
>>>>> -	const struct vm_operations_struct *vm_ops = vma->vm_ops;
>>>>>     	/* If it was private or non-writable, the write bit is already clear */
>>>>>     	if ((vm_flags & (VM_WRITE|VM_SHARED)) != ((VM_WRITE|VM_SHARED)))
>>>>>     		return 0;
>>>>>     	/* The backer wishes to know when pages are first written to? */
>>>>> -	if (vm_ops && (vm_ops->page_mkwrite || vm_ops->pfn_mkwrite))
>>>>> +	if (vm_ops_needs_writenotify(vma->vm_ops))
>>>>>     		return 1;
>>>>>     	/* The open routine did something to the protections that pgprot_modify
>>>>> @@ -1511,13 +1536,7 @@ int vma_wants_writenotify(struct vm_area_struct *vma, pgprot_t vm_page_prot)
>>>>>     	if (userfaultfd_wp(vma))
>>>>>     		return 1;
>>>>> -	/* Specialty mapping? */
>>>>> -	if (vm_flags & VM_PFNMAP)
>>>>> -		return 0;
>>>>> -
>>>>> -	/* Can the mapping track the dirty pages? */
>>>>> -	return vma->vm_file && vma->vm_file->f_mapping &&
>>>>> -		mapping_can_writeback(vma->vm_file->f_mapping);
>>>>> +	return vma_needs_dirty_tracking(vma);
>>>>>     }
>>>>>     /*
>>>>
>>>>
>>>> --Mika
>>>>
>>>
>>
>>
> 


--Mika

