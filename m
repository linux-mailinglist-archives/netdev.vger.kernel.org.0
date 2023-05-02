Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id EA9E46F4908
	for <lists+netdev@lfdr.de>; Tue,  2 May 2023 19:17:43 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234348AbjEBRRm (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 2 May 2023 13:17:42 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:54902 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S234409AbjEBRRb (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 2 May 2023 13:17:31 -0400
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.133.124])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 814E1F5
        for <netdev@vger.kernel.org>; Tue,  2 May 2023 10:16:43 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1683047802;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=FxFefL2TaEuqaJkcFu7xJC55lri7raM2nXvu+Ph57wY=;
        b=NskkJKtDbddPg8p7HSo0SbpNY11EMgMs/LYk7ZRHA58Tm1eCMGp34dTebNhSbqXwWXtn6N
        Lh9bxIE7l3DHtG6W86O3FmA2O5WN8myyrfXnuSsxwmI9JjzbtIriQWR1iHCg/FTt8ehRw9
        JGLKe+lqWqzrP6VbS6idmaoJEV4rAdM=
Received: from mail-wm1-f72.google.com (mail-wm1-f72.google.com
 [209.85.128.72]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.3, cipher=TLS_AES_256_GCM_SHA384) id
 us-mta-468-8SvlmIVFMF6Nfs63yFdRbA-1; Tue, 02 May 2023 13:16:41 -0400
X-MC-Unique: 8SvlmIVFMF6Nfs63yFdRbA-1
Received: by mail-wm1-f72.google.com with SMTP id 5b1f17b1804b1-3f315735edeso110619425e9.1
        for <netdev@vger.kernel.org>; Tue, 02 May 2023 10:16:41 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20221208; t=1683047800; x=1685639800;
        h=content-transfer-encoding:in-reply-to:organization:from:references
         :cc:to:content-language:subject:user-agent:mime-version:date
         :message-id:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=FxFefL2TaEuqaJkcFu7xJC55lri7raM2nXvu+Ph57wY=;
        b=lLuMAlmQO52FsTt1RI5gqkdx5/Yfv6bsW9VNz7rVTazB+J3c1DpP+zefFndqvAdLS2
         tmmBpN+papsR+GNoZ3EME0mKzKmHroiSRq/AE2rQq+P54/C0RU99aKnN9J9VlmNbAmfr
         uBDW2ZjuAAP6XiXY9Ag67dEtFHX8C1N9gutZXOoSvBMEaQ2/e53LNDKGjuraqMeOxe0E
         lfFSJNPi4eaCK3Vyc8/dUXi6kaZ7LIWma0YFQ6llLOnCo8/fF9m4WCmMOAqrJ368O5Kp
         YDoN06iX2hipGnRpN1Hr26c0gbOeqJUWrHcDrj9/u98iy4EefRZ+BA5+Siy7OvJKa5KD
         XNiw==
X-Gm-Message-State: AC+VfDyD0gy+b5XGyfYOE6p4rJEXGCHWf326MuDfHt0UQegUsNszkFUK
        Uc0ilSrizxYNoQHi93pomRIYj6JQjoHPeQhq81766GVi76B05zCNQVnlgIbWPxebtxcNj1UgB0O
        px6chmtfpikLufWYq
X-Received: by 2002:a05:600c:190e:b0:3f1:96a8:3560 with SMTP id j14-20020a05600c190e00b003f196a83560mr16415047wmq.10.1683047800112;
        Tue, 02 May 2023 10:16:40 -0700 (PDT)
X-Google-Smtp-Source: ACHHUZ7oCTXDG5XgtbjQb7PsM2Y4y6C+rc08d37MchNAu0yZOIk2vbjILr1cpDOC4wKU8cadt3Eyqg==
X-Received: by 2002:a05:600c:190e:b0:3f1:96a8:3560 with SMTP id j14-20020a05600c190e00b003f196a83560mr16414984wmq.10.1683047799651;
        Tue, 02 May 2023 10:16:39 -0700 (PDT)
Received: from ?IPV6:2003:cb:c700:2400:6b79:2aa:9602:7016? (p200300cbc70024006b7902aa96027016.dip0.t-ipconnect.de. [2003:cb:c700:2400:6b79:2aa:9602:7016])
        by smtp.gmail.com with ESMTPSA id y5-20020a1c4b05000000b003e91b9a92c9sm35873689wma.24.2023.05.02.10.16.37
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Tue, 02 May 2023 10:16:39 -0700 (PDT)
Message-ID: <03e591ce-debc-bba1-c55e-ce590cc1f38d@redhat.com>
Date:   Tue, 2 May 2023 19:16:36 +0200
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:102.0) Gecko/20100101
 Thunderbird/102.10.0
Subject: Re: [PATCH v7 1/3] mm/mmap: separate writenotify and dirty tracking
 logic
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
        Dave Chinner <david@fromorbit.com>,
        Theodore Ts'o <tytso@mit.edu>, Peter Xu <peterx@redhat.com>,
        Matthew Rosato <mjrosato@linux.ibm.com>,
        "Paul E . McKenney" <paulmck@kernel.org>,
        Christian Borntraeger <borntraeger@linux.ibm.com>
References: <cover.1683044162.git.lstoakes@gmail.com>
 <72a90af5a9e4445a33ae44efa710f112c2694cb1.1683044162.git.lstoakes@gmail.com>
 <56696a72-24fa-958e-e6a1-7a17c9e54081@redhat.com>
 <f777a151-edfc-4882-8aca-9a926179c5bb@lucifer.local>
 <bf04a98a-9de6-4532-a36c-59572d22dd7c@lucifer.local>
From:   David Hildenbrand <david@redhat.com>
Organization: Red Hat
In-Reply-To: <bf04a98a-9de6-4532-a36c-59572d22dd7c@lucifer.local>
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

On 02.05.23 19:09, Lorenzo Stoakes wrote:
> On Tue, May 02, 2023 at 05:53:46PM +0100, Lorenzo Stoakes wrote:
>> On Tue, May 02, 2023 at 06:38:53PM +0200, David Hildenbrand wrote:
>>> On 02.05.23 18:34, Lorenzo Stoakes wrote:
>>>> vma_wants_writenotify() is specifically intended for setting PTE page table
>>>> flags, accounting for existing PTE flag state and whether that might
>>>> already be read-only while mixing this check with a check whether the
>>>> filesystem performs dirty tracking.
>>>>
>>>> Separate out the notions of dirty tracking and a PTE write notify checking
>>>> in order that we can invoke the dirty tracking check from elsewhere.
>>>>
>>>> Note that this change introduces a very small duplicate check of the
>>>> separated out vm_ops_needs_writenotify(). This is necessary to avoid making
>>>> vma_needs_dirty_tracking() needlessly complicated (e.g. passing a
>>>> check_writenotify flag or having it assume this check was already
>>>> performed). This is such a small check that it doesn't seem too egregious
>>>> to do this.
>>>>
>>>> Signed-off-by: Lorenzo Stoakes <lstoakes@gmail.com>
>>>> Reviewed-by: John Hubbard <jhubbard@nvidia.com>
>>>> Reviewed-by: Mika Penttilä <mpenttil@redhat.com>
>>>> Reviewed-by: Jan Kara <jack@suse.cz>
>>>> Reviewed-by: Jason Gunthorpe <jgg@nvidia.com>
>>>> ---
>>>>    include/linux/mm.h |  1 +
>>>>    mm/mmap.c          | 36 +++++++++++++++++++++++++++---------
>>>>    2 files changed, 28 insertions(+), 9 deletions(-)
>>>>
>>>> diff --git a/include/linux/mm.h b/include/linux/mm.h
>>>> index 27ce77080c79..7b1d4e7393ef 100644
>>>> --- a/include/linux/mm.h
>>>> +++ b/include/linux/mm.h
>>>> @@ -2422,6 +2422,7 @@ extern unsigned long move_page_tables(struct vm_area_struct *vma,
>>>>    #define  MM_CP_UFFD_WP_ALL                 (MM_CP_UFFD_WP | \
>>>>    					    MM_CP_UFFD_WP_RESOLVE)
>>>> +bool vma_needs_dirty_tracking(struct vm_area_struct *vma);
>>>>    int vma_wants_writenotify(struct vm_area_struct *vma, pgprot_t vm_page_prot);
>>>>    static inline bool vma_wants_manual_pte_write_upgrade(struct vm_area_struct *vma)
>>>>    {
>>>> diff --git a/mm/mmap.c b/mm/mmap.c
>>>> index 5522130ae606..295c5f2e9bd9 100644
>>>> --- a/mm/mmap.c
>>>> +++ b/mm/mmap.c
>>>> @@ -1475,6 +1475,31 @@ SYSCALL_DEFINE1(old_mmap, struct mmap_arg_struct __user *, arg)
>>>>    }
>>>>    #endif /* __ARCH_WANT_SYS_OLD_MMAP */
>>>> +/* Do VMA operations imply write notify is required? */
>>>> +static bool vm_ops_needs_writenotify(const struct vm_operations_struct *vm_ops)
>>>> +{
>>>> +	return vm_ops && (vm_ops->page_mkwrite || vm_ops->pfn_mkwrite);
>>>> +}
>>>> +
>>>> +/*
>>>> + * Does this VMA require the underlying folios to have their dirty state
>>>> + * tracked?
>>>> + */
>>>> +bool vma_needs_dirty_tracking(struct vm_area_struct *vma)
>>>> +{
>>>
>>> Sorry for not noticing this earlier, but ...
>>
>> pints_owed++

Having tired eyes and jumping back and forth between tasks really seems 
to start getting expensive ;)

>>
>>>
>>> what about MAP_PRIVATE mappings? When we write, we populate an anon page,
>>> which will work as expected ... because we don't have to notify the fs?
>>>
>>> I think you really also want the "If it was private or non-writable, the
>>> write bit is already clear */" part as well and remove "false" in that case.
>>>
>>
>> Not sure a 'write bit is already clear' case is relevant to checking
>> whether a filesystem dirty tracks? That seems specific entirely to the page
>> table bits.
>>
>> That's why I didn't include it,
>>
>> A !VM_WRITE shouldn't be GUP-writable except for FOLL_FORCE, and that
>> surely could be problematic if VM_MAYWRITE later?
>>
>> Thinking about it though a !VM_SHARE should probably can be safely assumed
>> to not be dirty-trackable, so we probably do need to add a check for
>> !VM_SHARED -> !vma_needs_dirty_tracking
>>
> 
> On second thoughts, we explicitly check FOLL_FORCE && !is_cow_mapping() in
> check_vma_flags() so that case cannot occur.
> 
> So actually yes we should probably include this on the basis of that and
> the fact that a FOLL_WRITE operation will CoW the MAP_PRIVATE mapping.
> 

Yes, we only allow to FOLL_FORCE write to (exclusive) anonymous pages 
that are mapped read-only. If it's not that, we trigger a (fake) write 
fault.


-- 
Thanks,

David / dhildenb

