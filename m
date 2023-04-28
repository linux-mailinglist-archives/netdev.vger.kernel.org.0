Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 828C76F1B3E
	for <lists+netdev@lfdr.de>; Fri, 28 Apr 2023 17:14:14 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1346353AbjD1PON (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 28 Apr 2023 11:14:13 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:33020 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1346339AbjD1POG (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 28 Apr 2023 11:14:06 -0400
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.129.124])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 2224A12D
        for <netdev@vger.kernel.org>; Fri, 28 Apr 2023 08:13:16 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1682694795;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=depf0vqfZUKkwnLh+yDxi5hRj+V4M9FQr1DR9klBV44=;
        b=eneQ0ZjzLmvUjok1aBj+Y5ce6TuIJDtqfwB0iIavh1ohKdq3tVPPxHXLr2SHCeVBSmx0WW
        vnePtS+CE1kwqs1qR/nhFsslHaONMyRSrkCibkimaTpZ1fNTFAT04VB9g/wW68NTaZVjNS
        eiXAfeP9qJuuB4qwvmCkWOmdu4ESfxM=
Received: from mail-wm1-f69.google.com (mail-wm1-f69.google.com
 [209.85.128.69]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.3, cipher=TLS_AES_256_GCM_SHA384) id
 us-mta-447-10QIvNkKOLWzvXOqqMDAHA-1; Fri, 28 Apr 2023 11:13:14 -0400
X-MC-Unique: 10QIvNkKOLWzvXOqqMDAHA-1
Received: by mail-wm1-f69.google.com with SMTP id 5b1f17b1804b1-3f173bd0d1bso64312375e9.3
        for <netdev@vger.kernel.org>; Fri, 28 Apr 2023 08:13:11 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20221208; t=1682694791; x=1685286791;
        h=content-transfer-encoding:in-reply-to:organization:from:references
         :cc:to:content-language:subject:user-agent:mime-version:date
         :message-id:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=depf0vqfZUKkwnLh+yDxi5hRj+V4M9FQr1DR9klBV44=;
        b=L2rLNueoRKI5IEQiz5OBk7bF7heLOVXHxSQxSLekAfqk2oVcqfqrNqhur2o1YTsJaR
         rVlDunKcsQm9omcT9DNXt30Hc/jauadsmJu6Yol0XVSvEiMV6QWcnEpJwkRpLIPfYKS4
         UlAVk3cjF0CyXG8mQhPUPDqidgre9PlWUAEM7DBoTpSaLYXGpsgrJZzrn2wO7NvDYcri
         4rpFyfqZ9oZdaM7Y1OPNX9VjicfMdnh+1o7nY78S62HD8dvF49ZfAOarMT5YuZJmzL5y
         lPif//lM4MlAFnlzDz9D0Jq+4aH+K4D0eLJt7tEXtY75v9PcUj9UZo8pJgDQ581y4ryQ
         sokw==
X-Gm-Message-State: AC+VfDwDaPJ9b7KdMJK79KO+2D8nU0TuGHwvKfCKDwsonLAVGN3w0ZC+
        pjyzUlNDkaOnRBTza7roLqscut78kk4vMmsmxxpYIPE8FylfEPYbDhQnpdqqjP1Mn0r/6/XAx7k
        fqN3tKbuO3FkqOD1D
X-Received: by 2002:a7b:cb8f:0:b0:3f1:885f:2e52 with SMTP id m15-20020a7bcb8f000000b003f1885f2e52mr4523105wmi.16.1682694790744;
        Fri, 28 Apr 2023 08:13:10 -0700 (PDT)
X-Google-Smtp-Source: ACHHUZ5A46oc6/5KsPhnjzI9jqw0Qx/rYGoBNxjyg10n7h76H5Gcv8U/7NgNFGUbNeZYthhJy5Najw==
X-Received: by 2002:a7b:cb8f:0:b0:3f1:885f:2e52 with SMTP id m15-20020a7bcb8f000000b003f1885f2e52mr4523060wmi.16.1682694790337;
        Fri, 28 Apr 2023 08:13:10 -0700 (PDT)
Received: from ?IPV6:2003:cb:c726:9300:1711:356:6550:7502? (p200300cbc72693001711035665507502.dip0.t-ipconnect.de. [2003:cb:c726:9300:1711:356:6550:7502])
        by smtp.gmail.com with ESMTPSA id k18-20020a05600c0b5200b003edf2dc7ca3sm24464915wmr.34.2023.04.28.08.13.08
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Fri, 28 Apr 2023 08:13:09 -0700 (PDT)
Message-ID: <a8561203-a4f3-4b3d-338a-06a60541bd6b@redhat.com>
Date:   Fri, 28 Apr 2023 17:13:07 +0200
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:102.0) Gecko/20100101
 Thunderbird/102.10.0
Subject: Re: [PATCH v5] mm/gup: disallow GUP writing to file-backed mappings
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
        Mika Penttila <mpenttil@redhat.com>,
        David Howells <dhowells@redhat.com>,
        Christoph Hellwig <hch@lst.de>
References: <6b73e692c2929dc4613af711bdf92e2ec1956a66.1682638385.git.lstoakes@gmail.com>
 <afcc124e-7a9b-879c-dfdf-200426b84e24@redhat.com>
 <f60722d4-1474-4876-9291-5450c7192bd3@lucifer.local>
From:   David Hildenbrand <david@redhat.com>
Organization: Red Hat
In-Reply-To: <f60722d4-1474-4876-9291-5450c7192bd3@lucifer.local>
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

[...]

>> This change has the potential to break existing setups. Simple example:
>> libvirt domains configured for file-backed VM memory that also has a vfio
>> device configured. It can easily be configured by users (evolving VM
>> configuration, copy-paste etc.). And it works from a VM perspective, because
>> the guest memory is essentially stale once the VM is shutdown and the pages
>> were unpinned. At least we're not concerned about stale data on disk.
>>
>> With your changes, such VMs would no longer start, breaking existing user
>> setups with a kernel update.
> 
> Which vfio vm_ops are we talking about? vfio_pci_mmap_ops for example
> doesn't specify page_mkwrite or pfn_mkwrite. Unless you mean some arbitrary
> file system in the guest?

Sorry, you define a VM to have its memory backed by VM memory and, at 
the same time, define a vfio-pci device for your VM, which will end up 
long-term pinning the VM memory.

> 
> I may well be missing context on this so forgive me if I'm being a little
> dumb here, but it'd be good to get a specific example.

I was giving to little details ;)

[...]

>>
>> I know, Jason und John will disagree, but I don't think we want to be very
>> careful with changing the default.
>>
>> Sure, we could warn, or convert individual users using a flag (io_uring).
>> But maybe we should invest more energy on a fix?
> 
> This is proactively blocking a cleanup (eliminating vmas) that I believe
> will be useful in moving things forward. I am not against an opt-in option
> (I have been responding to community feedback in adapting my approach),
> which is the way I implemented it all the way back then :)

There are alternatives: just use a flag as Jason initially suggested and 
use that in io_uring code. Then, you can also bail out on the GUP-fast 
path as "cannot support it right now, never do GUP-fast".

IMHO, this patch is not a prereq.

> 
> But given we know this is both entirely broken and a potential security
> issue, and FOLL_LONGTERM is about as egregious as you can get (user
> explicitly saying they'll hold write access indefinitely) I feel it is an
> important improvement and makes clear that this is not an acceptable usage.
> 
> I see Jason has said more on this also :)
> 
>>
>>
>>
>>
>>> Suggested-by: Jason Gunthorpe <jgg@nvidia.com>
>>> Signed-off-by: Lorenzo Stoakes <lstoakes@gmail.com>
>>> ---
>>>    include/linux/mm.h |  1 +
>>>    mm/gup.c           | 41 ++++++++++++++++++++++++++++++++++++++++-
>>>    mm/mmap.c          | 36 +++++++++++++++++++++++++++---------
>>>    3 files changed, 68 insertions(+), 10 deletions(-)
>>>
>>> diff --git a/include/linux/mm.h b/include/linux/mm.h
>>> index 37554b08bb28..f7da02fc89c6 100644
>>> --- a/include/linux/mm.h
>>> +++ b/include/linux/mm.h
>>> @@ -2433,6 +2433,7 @@ extern unsigned long move_page_tables(struct vm_area_struct *vma,
>>>    #define  MM_CP_UFFD_WP_ALL                 (MM_CP_UFFD_WP | \
>>>    					    MM_CP_UFFD_WP_RESOLVE)
>>>
>>> +bool vma_needs_dirty_tracking(struct vm_area_struct *vma);
>>>    int vma_wants_writenotify(struct vm_area_struct *vma, pgprot_t vm_page_prot);
>>>    static inline bool vma_wants_manual_pte_write_upgrade(struct vm_area_struct *vma)
>>>    {
>>> diff --git a/mm/gup.c b/mm/gup.c
>>> index 1f72a717232b..d36a5db9feb1 100644
>>> --- a/mm/gup.c
>>> +++ b/mm/gup.c
>>> @@ -959,16 +959,51 @@ static int faultin_page(struct vm_area_struct *vma,
>>>    	return 0;
>>>    }
>>>
>>> +/*
>>> + * Writing to file-backed mappings which require folio dirty tracking using GUP
>>> + * is a fundamentally broken operation, as kernel write access to GUP mappings
>>> + * do not adhere to the semantics expected by a file system.
>>> + *
>>> + * Consider the following scenario:-
>>> + *
>>> + * 1. A folio is written to via GUP which write-faults the memory, notifying
>>> + *    the file system and dirtying the folio.
>>> + * 2. Later, writeback is triggered, resulting in the folio being cleaned and
>>> + *    the PTE being marked read-only.
>>> + * 3. The GUP caller writes to the folio, as it is mapped read/write via the
>>> + *    direct mapping.
>>> + * 4. The GUP caller, now done with the page, unpins it and sets it dirty
>>> + *    (though it does not have to).
>>> + *
>>> + * This results in both data being written to a folio without writenotify, and
>>> + * the folio being dirtied unexpectedly (if the caller decides to do so).
>>> + */
>>> +static bool writeable_file_mapping_allowed(struct vm_area_struct *vma,
>>> +					   unsigned long gup_flags)
>>> +{
>>> +	/* If we aren't pinning then no problematic write can occur. */
>>> +	if (!(gup_flags & (FOLL_GET | FOLL_PIN)))
>>> +		return true;
>>
>> FOLL_LONGTERM only applies to FOLL_PIN. This check can be dropped.
> 
> I understand that of course (well maybe not of course, but I mean I do, I
> have oodles of diagrams referencing this int he book :) This is intended to
> document the fact that the check isn't relevant if we don't pin at all,
> e.g. reading this you see:-
> 
> - (implicit) if not writing or anon we're good
> - if not pin we're good
> - ok we are only currently checking one especially egregious case
> - finally, perform the dirty tracking check.
> 
> So this is intentional.
> 
>>
>>> +
>>> +	/* We limit this check to the most egregious case - a long term pin. */
>>> +	if (!(gup_flags & FOLL_LONGTERM))
>>> +		return true;
>>> +
>>> +	/* If the VMA requires dirty tracking then GUP will be problematic. */
>>> +	return vma_needs_dirty_tracking(vma);
>>> +}
>>> +
>>>    static int check_vma_flags(struct vm_area_struct *vma, unsigned long gup_flags)
>>>    {
>>>    	vm_flags_t vm_flags = vma->vm_flags;
>>>    	int write = (gup_flags & FOLL_WRITE);
>>>    	int foreign = (gup_flags & FOLL_REMOTE);
>>> +	bool vma_anon = vma_is_anonymous(vma);
>>>
>>>    	if (vm_flags & (VM_IO | VM_PFNMAP))
>>>    		return -EFAULT;
>>>
>>> -	if (gup_flags & FOLL_ANON && !vma_is_anonymous(vma))
>>> +	if ((gup_flags & FOLL_ANON) && !vma_anon)
>>>    		return -EFAULT;
>>>
>>>    	if ((gup_flags & FOLL_LONGTERM) && vma_is_fsdax(vma))
>>> @@ -978,6 +1013,10 @@ static int check_vma_flags(struct vm_area_struct *vma, unsigned long gup_flags)
>>>    		return -EFAULT;
>>>
>>>    	if (write) {
>>> +		if (!vma_anon &&
>>> +		    !writeable_file_mapping_allowed(vma, gup_flags))
>>> +			return -EFAULT;
>>> +
>>>    		if (!(vm_flags & VM_WRITE)) {
>>>    			if (!(gup_flags & FOLL_FORCE))
>>>    				return -EFAULT;
>>> diff --git a/mm/mmap.c b/mm/mmap.c
>>> index 536bbb8fa0ae..7b6344d1832a 100644
>>> --- a/mm/mmap.c
>>
>>
>> I'm probably missing something, why don't we have to handle GUP-fast (having
>> said that, it's hard to handle ;) )? The sequence you describe above should
>> apply to GUP-fast as well, no?
>>
>> 1) Pin writable mapped page using GUP-fast
>> 2) Trigger writeback
>> 3) Write to page via pin
>> 4) Unpin and set dirty
> 
> You're right, and this is an excellent point. I worry about other GUP use
> cases too, but we're a bit out of luck there because we don't get to check
> the VMA _at all_ (which opens yet another Pandora's box about how safe it
> is to do unlocked pinning :)
> 
> But again, this comes down to the fact we're trying to make things
> _incrementally__ better rather than throwing our hands up and saying one
> day my ship will come in...

That's not how security fixes are supposed to work IMHO, sorry.

-- 
Thanks,

David / dhildenb

