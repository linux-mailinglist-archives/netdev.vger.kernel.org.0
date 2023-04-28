Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 229946F1BA0
	for <lists+netdev@lfdr.de>; Fri, 28 Apr 2023 17:34:22 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1346089AbjD1PeR (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 28 Apr 2023 11:34:17 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:48258 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230353AbjD1PeQ (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 28 Apr 2023 11:34:16 -0400
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.129.124])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 1E3302135
        for <netdev@vger.kernel.org>; Fri, 28 Apr 2023 08:33:25 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1682696004;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=dSjZwblrXYrI17LF7vaCsB4gxXrQr3Q411sjTrw5ys8=;
        b=e8okawyonhAS7Vr97eDdSqpkdZOMhSLnkQT2JhML/w5iBOgd9BKYcz5RhZ9u1cDcvNB8th
        q2RTB1eimyea+p35H4TVe93+1rXRHwAhvgPIJq7ZKfCNny5mLmxMgP7GUbmGg5Pr8zGSlc
        /uBM0lm8kr9y806Tu25PbpGx2mhDA8g=
Received: from mail-wr1-f69.google.com (mail-wr1-f69.google.com
 [209.85.221.69]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.3, cipher=TLS_AES_256_GCM_SHA384) id
 us-mta-137-ytoKXAE7P0u43rESUoZLuw-1; Fri, 28 Apr 2023 11:33:21 -0400
X-MC-Unique: ytoKXAE7P0u43rESUoZLuw-1
Received: by mail-wr1-f69.google.com with SMTP id ffacd0b85a97d-2f96ecfb40cso3726681f8f.3
        for <netdev@vger.kernel.org>; Fri, 28 Apr 2023 08:33:21 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20221208; t=1682696000; x=1685288000;
        h=content-transfer-encoding:in-reply-to:subject:organization:from
         :references:cc:to:content-language:user-agent:mime-version:date
         :message-id:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=dSjZwblrXYrI17LF7vaCsB4gxXrQr3Q411sjTrw5ys8=;
        b=Zg6zwgTPRkIIk8c96Km8nuqwOSXMHGLz3AefoZvFSJV7O/bZlqlwpOR2av39ZJdit6
         sIFUZNohapaxqYbQrqXLMOnQXZftxLcavRWc3TYZJ0zXOML9zwGIARzNP7taW+g7/E/8
         a6GXdyXMNgP8+unyAVVCsPAz/L4EaNb0vzhxs2cStVQl6lUFsVaFAsmyMiABvXNEsTmy
         TKTwTzXgfPtU/QOFz7RyrYLRxFq+nLpCODNOwPn8k77wcJKm7NxLfciH5ADhY3wzQoMk
         isdF3I+WQcOoNUAqvCa3M9B5i7sLhzzM6pCEG5w7sUNPjUprGzxrAIsb+B/ylN6Xd4cl
         zl1A==
X-Gm-Message-State: AC+VfDySo93KkpAKvqQy1Wu+CkP/8QE/gJRdU9oiEhVwr6ZckHzNQzAV
        Qansf4bGq8JqTq7RxU2wTl67/OACd/jFisMJcHoSeblNSQHuTb9+rSSQQ+sA+gHoRYPV5bGDRfE
        CzHG4cIJdioDEF4+P
X-Received: by 2002:a05:6000:10a:b0:2ef:baa1:f3fc with SMTP id o10-20020a056000010a00b002efbaa1f3fcmr3927399wrx.19.1682696000502;
        Fri, 28 Apr 2023 08:33:20 -0700 (PDT)
X-Google-Smtp-Source: ACHHUZ5qBlx/MUCSDYG5S1p3Ul0rH1G5mKOjb2w1crVTy9E5oFA3VcAUsN+qhkNZ11OAz6KvAekzFA==
X-Received: by 2002:a05:6000:10a:b0:2ef:baa1:f3fc with SMTP id o10-20020a056000010a00b002efbaa1f3fcmr3927354wrx.19.1682696000029;
        Fri, 28 Apr 2023 08:33:20 -0700 (PDT)
Received: from ?IPV6:2003:cb:c726:9300:1711:356:6550:7502? (p200300cbc72693001711035665507502.dip0.t-ipconnect.de. [2003:cb:c726:9300:1711:356:6550:7502])
        by smtp.gmail.com with ESMTPSA id n3-20020a7bcbc3000000b003f175b360e5sm24900038wmi.0.2023.04.28.08.33.17
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Fri, 28 Apr 2023 08:33:19 -0700 (PDT)
Message-ID: <a501219c-f75a-4467-fefe-bd571e84f99e@redhat.com>
Date:   Fri, 28 Apr 2023 17:33:17 +0200
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:102.0) Gecko/20100101
 Thunderbird/102.10.0
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
        Mika Penttila <mpenttil@redhat.com>,
        David Howells <dhowells@redhat.com>,
        Christoph Hellwig <hch@lst.de>
References: <6b73e692c2929dc4613af711bdf92e2ec1956a66.1682638385.git.lstoakes@gmail.com>
 <afcc124e-7a9b-879c-dfdf-200426b84e24@redhat.com>
 <f60722d4-1474-4876-9291-5450c7192bd3@lucifer.local>
 <a8561203-a4f3-4b3d-338a-06a60541bd6b@redhat.com>
 <49ebb100-afd2-4810-b901-1a0f51f45cfc@lucifer.local>
From:   David Hildenbrand <david@redhat.com>
Organization: Red Hat
Subject: Re: [PATCH v5] mm/gup: disallow GUP writing to file-backed mappings
 by default
In-Reply-To: <49ebb100-afd2-4810-b901-1a0f51f45cfc@lucifer.local>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
X-Spam-Status: No, score=-3.7 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,NICE_REPLY_A,
        RCVD_IN_DNSWL_NONE,RCVD_IN_MSPIKE_H2,SPF_HELO_NONE,SPF_NONE,
        T_SCC_BODY_TEXT_LINE autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On 28.04.23 17:24, Lorenzo Stoakes wrote:
> On Fri, Apr 28, 2023 at 05:13:07PM +0200, David Hildenbrand wrote:
>> [...]
>>
>>>> This change has the potential to break existing setups. Simple example:
>>>> libvirt domains configured for file-backed VM memory that also has a vfio
>>>> device configured. It can easily be configured by users (evolving VM
>>>> configuration, copy-paste etc.). And it works from a VM perspective, because
>>>> the guest memory is essentially stale once the VM is shutdown and the pages
>>>> were unpinned. At least we're not concerned about stale data on disk.
>>>>
>>>> With your changes, such VMs would no longer start, breaking existing user
>>>> setups with a kernel update.
>>>
>>> Which vfio vm_ops are we talking about? vfio_pci_mmap_ops for example
>>> doesn't specify page_mkwrite or pfn_mkwrite. Unless you mean some arbitrary
>>> file system in the guest?
>>
>> Sorry, you define a VM to have its memory backed by VM memory and, at the
>> same time, define a vfio-pci device for your VM, which will end up long-term
>> pinning the VM memory.
> 

"memory backed by file memory", I guess you figured that out :)

> Ah ack. Jason seemed concerned that this was already a broken case, I guess
> that's one for you two to hash out...
> 
>>
>>>
>>> I may well be missing context on this so forgive me if I'm being a little
>>> dumb here, but it'd be good to get a specific example.
>>
>> I was giving to little details ;)
>>
>> [...]
>>
>>>>
>>>> I know, Jason und John will disagree, but I don't think we want to be very
>>>> careful with changing the default.
>>>>
>>>> Sure, we could warn, or convert individual users using a flag (io_uring).
>>>> But maybe we should invest more energy on a fix?
>>>
>>> This is proactively blocking a cleanup (eliminating vmas) that I believe
>>> will be useful in moving things forward. I am not against an opt-in option
>>> (I have been responding to community feedback in adapting my approach),
>>> which is the way I implemented it all the way back then :)
>>
>> There are alternatives: just use a flag as Jason initially suggested and use
>> that in io_uring code. Then, you can also bail out on the GUP-fast path as
>> "cannot support it right now, never do GUP-fast".
> 
> I already implemented the alternatives (look back through revisions to see :)
> and there were objections for various reasons.
> 
> Personally my preference is to provide a FOLL_SAFE_FILE_WRITE flag or such and
> replace the FOLL_LONGTERM check with this (that'll automatically get rejected
> for GUP-fast so the GUP-fast conundrum wouldn't be a thing either).
> 
> GUP-fast is a problem as you say,, but it feels like a fundamental issue with
> GUP-fast as a whole since you don't get to look at a VMA since you can't take
> the mmap_lock. You could just look at the folio->mapping once you've walked the
> page tables and say 'I'm out' if FOLL_WRITE and it's non-anon if that's what
> you're suggesting?

See my other reply, kind-of yes. Like we do with gup_must_unshare(). I'm 
only concerned about how to keep GUP-fast working on hugetlb and shmem.

> 
> I'm not against that change but this being incremental, I think that would be a
> further increment.

If we want to fix a security issue, as Jason said, incremental is IMHO 
the wrong approach.

It's often too tempting to ignore the hard part and fix the easy part, 
making the hard part an increment for the future that nobody will really 
implement ... because it's hard.
[...]

>>>
>>> But given we know this is both entirely broken and a potential security
>>> issue, and FOLL_LONGTERM is about as egregious as you can get (user
>>> explicitly saying they'll hold write access indefinitely) I feel it is an
>>> important improvement and makes clear that this is not an acceptable usage.
>>>
>>> I see Jason has said more on this also :)
>>>
>>>>
>>>>
>>>>
>>>>
>>>>> Suggested-by: Jason Gunthorpe <jgg@nvidia.com>
>>>>> Signed-off-by: Lorenzo Stoakes <lstoakes@gmail.com>
>>>>> ---
>>>>>     include/linux/mm.h |  1 +
>>>>>     mm/gup.c           | 41 ++++++++++++++++++++++++++++++++++++++++-
>>>>>     mm/mmap.c          | 36 +++++++++++++++++++++++++++---------
>>>>>     3 files changed, 68 insertions(+), 10 deletions(-)
>>>>>
>>>>> diff --git a/include/linux/mm.h b/include/linux/mm.h
>>>>> index 37554b08bb28..f7da02fc89c6 100644
>>>>> --- a/include/linux/mm.h
>>>>> +++ b/include/linux/mm.h
>>>>> @@ -2433,6 +2433,7 @@ extern unsigned long move_page_tables(struct vm_area_struct *vma,
>>>>>     #define  MM_CP_UFFD_WP_ALL                 (MM_CP_UFFD_WP | \
>>>>>     					    MM_CP_UFFD_WP_RESOLVE)
>>>>>
>>>>> +bool vma_needs_dirty_tracking(struct vm_area_struct *vma);
>>>>>     int vma_wants_writenotify(struct vm_area_struct *vma, pgprot_t vm_page_prot);
>>>>>     static inline bool vma_wants_manual_pte_write_upgrade(struct vm_area_struct *vma)
>>>>>     {
>>>>> diff --git a/mm/gup.c b/mm/gup.c
>>>>> index 1f72a717232b..d36a5db9feb1 100644
>>>>> --- a/mm/gup.c
>>>>> +++ b/mm/gup.c
>>>>> @@ -959,16 +959,51 @@ static int faultin_page(struct vm_area_struct *vma,
>>>>>     	return 0;
>>>>>     }
>>>>>
>>>>> +/*
>>>>> + * Writing to file-backed mappings which require folio dirty tracking using GUP
>>>>> + * is a fundamentally broken operation, as kernel write access to GUP mappings
>>>>> + * do not adhere to the semantics expected by a file system.
>>>>> + *
>>>>> + * Consider the following scenario:-
>>>>> + *
>>>>> + * 1. A folio is written to via GUP which write-faults the memory, notifying
>>>>> + *    the file system and dirtying the folio.
>>>>> + * 2. Later, writeback is triggered, resulting in the folio being cleaned and
>>>>> + *    the PTE being marked read-only.
>>>>> + * 3. The GUP caller writes to the folio, as it is mapped read/write via the
>>>>> + *    direct mapping.
>>>>> + * 4. The GUP caller, now done with the page, unpins it and sets it dirty
>>>>> + *    (though it does not have to).
>>>>> + *
>>>>> + * This results in both data being written to a folio without writenotify, and
>>>>> + * the folio being dirtied unexpectedly (if the caller decides to do so).
>>>>> + */
>>>>> +static bool writeable_file_mapping_allowed(struct vm_area_struct *vma,
>>>>> +					   unsigned long gup_flags)
>>>>> +{
>>>>> +	/* If we aren't pinning then no problematic write can occur. */
>>>>> +	if (!(gup_flags & (FOLL_GET | FOLL_PIN)))
>>>>> +		return true;
>>>>
>>>> FOLL_LONGTERM only applies to FOLL_PIN. This check can be dropped.
>>>
>>> I understand that of course (well maybe not of course, but I mean I do, I
>>> have oodles of diagrams referencing this int he book :) This is intended to
>>> document the fact that the check isn't relevant if we don't pin at all,
>>> e.g. reading this you see:-
>>>
>>> - (implicit) if not writing or anon we're good
>>> - if not pin we're good
>>> - ok we are only currently checking one especially egregious case
>>> - finally, perform the dirty tracking check.
>>>
>>> So this is intentional.
>>>
>>>>
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
>>>>>
>>>>>     	if (vm_flags & (VM_IO | VM_PFNMAP))
>>>>>     		return -EFAULT;
>>>>>
>>>>> -	if (gup_flags & FOLL_ANON && !vma_is_anonymous(vma))
>>>>> +	if ((gup_flags & FOLL_ANON) && !vma_anon)
>>>>>     		return -EFAULT;
>>>>>
>>>>>     	if ((gup_flags & FOLL_LONGTERM) && vma_is_fsdax(vma))
>>>>> @@ -978,6 +1013,10 @@ static int check_vma_flags(struct vm_area_struct *vma, unsigned long gup_flags)
>>>>>     		return -EFAULT;
>>>>>
>>>>>     	if (write) {
>>>>> +		if (!vma_anon &&
>>>>> +		    !writeable_file_mapping_allowed(vma, gup_flags))
>>>>> +			return -EFAULT;
>>>>> +
>>>>>     		if (!(vm_flags & VM_WRITE)) {
>>>>>     			if (!(gup_flags & FOLL_FORCE))
>>>>>     				return -EFAULT;
>>>>> diff --git a/mm/mmap.c b/mm/mmap.c
>>>>> index 536bbb8fa0ae..7b6344d1832a 100644
>>>>> --- a/mm/mmap.c
>>>>
>>>>
>>>> I'm probably missing something, why don't we have to handle GUP-fast (having
>>>> said that, it's hard to handle ;) )? The sequence you describe above should
>>>> apply to GUP-fast as well, no?
>>>>
>>>> 1) Pin writable mapped page using GUP-fast
>>>> 2) Trigger writeback
>>>> 3) Write to page via pin
>>>> 4) Unpin and set dirty
>>>
>>> You're right, and this is an excellent point. I worry about other GUP use
>>> cases too, but we're a bit out of luck there because we don't get to check
>>> the VMA _at all_ (which opens yet another Pandora's box about how safe it
>>> is to do unlocked pinning :)
>>>
>>> But again, this comes down to the fact we're trying to make things
>>> _incrementally__ better rather than throwing our hands up and saying one
>>> day my ship will come in...
>>
>> That's not how security fixes are supposed to work IMHO, sorry.
> 
> Sure, but I don't think the 'let things continue to be terribly broken for X
> more years' is also a great approach.

Not at all, people (including me) were simply not aware that it is that 
much of an (security) issue because I never saw any real bug reports (or 
CVE numbers) and only herd John talk about possible fixes a year ago :)

So I'm saying we either try to block it completely or finally look into 
fixing it for good. I'm not a friend of anything in between.

You don't gain a lot of security by locking the front door but knowingly 
leaving the back door unlocked.

> 
> Personally I come at this from the 'I just want my vmas patch series' unblocked
> perspective :) and feel there's a functional aspect here too.

I know, it always gets messy when touching such sensible topics :P

-- 
Thanks,

David / dhildenb

