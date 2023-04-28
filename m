Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 284196F1D21
	for <lists+netdev@lfdr.de>; Fri, 28 Apr 2023 19:03:30 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S240073AbjD1RD2 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 28 Apr 2023 13:03:28 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:42416 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229780AbjD1RDZ (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 28 Apr 2023 13:03:25 -0400
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.133.124])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 6F07965B0
        for <netdev@vger.kernel.org>; Fri, 28 Apr 2023 10:02:29 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1682701348;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=zN+hlinWDo7HPckU96nAsQkShApM93gzKFjoIDnOxkE=;
        b=NojjS2VEjlGzwAbO565WIMKXXrJfXYhvW1BFZQHF3rqYbbxaEB+10Gucls1s1gwn2gorPz
        RY5j7RKcwKDR3nojuoNBCq6dTvOdpWOF0TdlIRsouRRy7WR8YNs4neXYIbXCHoFlHVq6Qp
        RM36GJiHU6DHn0CrfWn0MT8KYDbDkOI=
Received: from mail-wr1-f72.google.com (mail-wr1-f72.google.com
 [209.85.221.72]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.3, cipher=TLS_AES_256_GCM_SHA384) id
 us-mta-94-suKwr6M3OyiDy7jUb48GxQ-1; Fri, 28 Apr 2023 13:02:27 -0400
X-MC-Unique: suKwr6M3OyiDy7jUb48GxQ-1
Received: by mail-wr1-f72.google.com with SMTP id ffacd0b85a97d-2f831f6e175so5741945f8f.2
        for <netdev@vger.kernel.org>; Fri, 28 Apr 2023 10:02:26 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20221208; t=1682701346; x=1685293346;
        h=content-transfer-encoding:in-reply-to:organization:from:references
         :cc:to:content-language:subject:user-agent:mime-version:date
         :message-id:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=zN+hlinWDo7HPckU96nAsQkShApM93gzKFjoIDnOxkE=;
        b=ZBmpNt79kClpClZ3aQyY132pBHfhYfsf6waBHzkTyAY7Xs2sV8lO36QZOuzgLFAwNE
         y1cCHN4t26ePfpuS9ojIoZxyV+5zr2pMnZNeVR1IPDWG3RR9XXesN5dtt4zY2v79cPK8
         2PQ4oUamEQ8LBeUnUJz/4bNDMoKlpnQslg9TkbWbB0R/nfFuIvNfJBZrqem/ChtO7IR6
         VWBJEDDch5LwUKJiPfwwrM4cYbPSvuE0MeBvD0Xz6Jq5yK6r7zrxMMnmjEEzZJ8mXojC
         vU+pqNEtToRoATrYvRdf/p2+Iease0R3976i53lGwLeSppOL22LxxOtLjR8hRg5siA/Z
         IEbg==
X-Gm-Message-State: AC+VfDy8nnYiSLzJL8QGHfvaeArXG18C0Fn1+51OrA3bDAyOl+y4vvK/
        Kn28CEo2rgZgPcPLzL4MojTAxGBnavOezz6Ufum2/lUcFwtOJtXfVLkuTK2LpnoopigXmv9stue
        oxkKuIt66RNCTYp4c
X-Received: by 2002:a5d:40cd:0:b0:2ff:3a63:ed61 with SMTP id b13-20020a5d40cd000000b002ff3a63ed61mr4380625wrq.13.1682701345895;
        Fri, 28 Apr 2023 10:02:25 -0700 (PDT)
X-Google-Smtp-Source: ACHHUZ5IGpmPcW+sW5hDbaIE0RZbDfpW/KW7f3SgvaJbedb3u6P7PhLZRwvYbDxXsxQPtSCsSBa1uw==
X-Received: by 2002:a5d:40cd:0:b0:2ff:3a63:ed61 with SMTP id b13-20020a5d40cd000000b002ff3a63ed61mr4380577wrq.13.1682701345525;
        Fri, 28 Apr 2023 10:02:25 -0700 (PDT)
Received: from ?IPV6:2003:cb:c726:9300:1711:356:6550:7502? (p200300cbc72693001711035665507502.dip0.t-ipconnect.de. [2003:cb:c726:9300:1711:356:6550:7502])
        by smtp.gmail.com with ESMTPSA id d13-20020adfe88d000000b002e55cc69169sm21510251wrm.38.2023.04.28.10.02.23
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Fri, 28 Apr 2023 10:02:24 -0700 (PDT)
Message-ID: <1039c830-acec-d99b-b315-c2a6e26c34ca@redhat.com>
Date:   Fri, 28 Apr 2023 19:02:22 +0200
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:102.0) Gecko/20100101
 Thunderbird/102.10.0
Subject: Re: [PATCH v5] mm/gup: disallow GUP writing to file-backed mappings
 by default
Content-Language: en-US
To:     "Kirill A . Shutemov" <kirill@shutemov.name>
Cc:     Peter Xu <peterx@redhat.com>, Lorenzo Stoakes <lstoakes@gmail.com>,
        Jason Gunthorpe <jgg@nvidia.com>, linux-mm@kvack.org,
        linux-kernel@vger.kernel.org,
        Andrew Morton <akpm@linux-foundation.org>,
        Jens Axboe <axboe@kernel.dk>,
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
        John Hubbard <jhubbard@nvidia.com>, Jan Kara <jack@suse.cz>,
        Pavel Begunkov <asml.silence@gmail.com>,
        Mika Penttila <mpenttil@redhat.com>,
        David Howells <dhowells@redhat.com>,
        Christoph Hellwig <hch@lst.de>
References: <094d2074-5b69-5d61-07f7-9f962014fa68@redhat.com>
 <400da248-a14e-46a4-420a-a3e075291085@redhat.com>
 <077c4b21-8806-455f-be98-d7052a584259@lucifer.local>
 <62ec50da-5f73-559c-c4b3-bde4eb215e08@redhat.com>
 <6ddc7ac4-4091-632a-7b2c-df2005438ec4@redhat.com>
 <20230428160925.5medjfxkyvmzfyhq@box.shutemov.name>
 <39cc0f26-8fc2-79dd-2e84-62238d27fd98@redhat.com>
 <20230428162207.o3ejmcz7rzezpt6n@box.shutemov.name> <ZEv2196tk5yWvgW5@x1n>
 <173337c0-14f4-3246-15ff-7fbf03861c94@redhat.com>
 <20230428165623.pqchgi5gtfhxd5b5@box.shutemov.name>
From:   David Hildenbrand <david@redhat.com>
Organization: Red Hat
In-Reply-To: <20230428165623.pqchgi5gtfhxd5b5@box.shutemov.name>
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

On 28.04.23 18:56, Kirill A . Shutemov wrote:
> On Fri, Apr 28, 2023 at 06:51:46PM +0200, David Hildenbrand wrote:
>> On 28.04.23 18:39, Peter Xu wrote:
>>> On Fri, Apr 28, 2023 at 07:22:07PM +0300, Kirill A . Shutemov wrote:
>>>> On Fri, Apr 28, 2023 at 06:13:03PM +0200, David Hildenbrand wrote:
>>>>> On 28.04.23 18:09, Kirill A . Shutemov wrote:
>>>>>> On Fri, Apr 28, 2023 at 05:43:52PM +0200, David Hildenbrand wrote:
>>>>>>> On 28.04.23 17:34, David Hildenbrand wrote:
>>>>>>>> On 28.04.23 17:33, Lorenzo Stoakes wrote:
>>>>>>>>> On Fri, Apr 28, 2023 at 05:23:29PM +0200, David Hildenbrand wrote:
>>>>>>>>>>>>
>>>>>>>>>>>> Security is the primary case where we have historically closed uAPI
>>>>>>>>>>>> items.
>>>>>>>>>>>
>>>>>>>>>>> As this patch
>>>>>>>>>>>
>>>>>>>>>>> 1) Does not tackle GUP-fast
>>>>>>>>>>> 2) Does not take care of !FOLL_LONGTERM
>>>>>>>>>>>
>>>>>>>>>>> I am not convinced by the security argument in regard to this patch.
>>>>>>>>>>>
>>>>>>>>>>>
>>>>>>>>>>> If we want to sells this as a security thing, we have to block it
>>>>>>>>>>> *completely* and then CC stable.
>>>>>>>>>>
>>>>>>>>>> Regarding GUP-fast, to fix the issue there as well, I guess we could do
>>>>>>>>>> something similar as I did in gup_must_unshare():
>>>>>>>>>>
>>>>>>>>>> If we're in GUP-fast (no VMA), and want to pin a !anon page writable,
>>>>>>>>>> fallback to ordinary GUP. IOW, if we don't know, better be safe.
>>>>>>>>>
>>>>>>>>> How do we determine it's non-anon in the first place? The check is on the
>>>>>>>>> VMA. We could do it by following page tables down to folio and checking
>>>>>>>>> folio->mapping for PAGE_MAPPING_ANON I suppose?
>>>>>>>>
>>>>>>>> PageAnon(page) can be called from GUP-fast after grabbing a reference.
>>>>>>>> See gup_must_unshare().
>>>>>>>
>>>>>>> IIRC, PageHuge() can also be called from GUP-fast and could special-case
>>>>>>> hugetlb eventually, as it's table while we hold a (temporary) reference.
>>>>>>> Shmem might be not so easy ...
>>>>>>
>>>>>> page->mapping->a_ops should be enough to whitelist whatever fs you want.
>>>>>>
>>>>>
>>>>> The issue is how to stabilize that from GUP-fast, such that we can safely
>>>>> dereference the mapping. Any idea?
>>>>>
>>>>> At least for anon page I know that page->mapping only gets cleared when
>>>>> freeing the page, and we don't dereference the mapping but only check a
>>>>> single flag stored alongside the mapping. Therefore, PageAnon() is fine in
>>>>> GUP-fast context.
>>>>
>>>> What codepath you are worry about that clears ->mapping on pages with
>>>> non-zero refcount?
>>>>
>>>> I can only think of truncate (and punch hole). READ_ONCE(page->mapping)
>>>> and fail GUP_fast if it is NULL should be fine, no?
>>>>
>>>> I guess we should consider if the inode can be freed from under us and the
>>>> mapping pointer becomes dangling. But I think we should be fine here too:
>>>> VMA pins inode and VMA cannot go away from under GUP.
>>>
>>> Can vma still go away if during a fast-gup?
>>>
>>
>> So, after we grabbed the page and made sure the the PTE didn't change (IOW,
>> the PTE was stable while we processed it), the page can get unmapped (but
>> not freed, because we hold a reference) and the VMA can theoretically go
>> away (and as far as I understand, nothing stops the file from getting
>> deleted, truncated etc).
>>
>> So we might be looking at folio->mapping and the VMA is no longer there.
>> Maybe even the file is no longer there.
> 
> No. VMA cannot get away before PTEs are unmapped and TLB is flushed. And
> TLB flushing is serialized against GUP_fast().


The whole CONFIG_MMU_GATHER_RCU_TABLE_FREE handling makes the situation 
more complicated.

-- 
Thanks,

David / dhildenb

