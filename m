Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 69B826F1C62
	for <lists+netdev@lfdr.de>; Fri, 28 Apr 2023 18:14:03 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230481AbjD1QNz (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 28 Apr 2023 12:13:55 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:43444 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230464AbjD1QNy (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 28 Apr 2023 12:13:54 -0400
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.129.124])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id DD50B2137
        for <netdev@vger.kernel.org>; Fri, 28 Apr 2023 09:13:12 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1682698392;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=5xkaTJLSgSiHWckTCCg+jkvg+cPl3tpnSAiaPo9ljdQ=;
        b=FPrC3ztDWD1KOjNlK3bazKox8fCwYokb4luMoDlIK2/uaZA8FjG8tszaoCI7JTYWeY4MIK
        laUaMe6O1hQZQdTE9ols/k3RWR5xN3uOIqirhyrjgjEZgydx5CxLhwf0r2UzQwGpDDOKMN
        iwTynksT2Opbi4DKqJQP0PeJGAxv2RY=
Received: from mail-wm1-f71.google.com (mail-wm1-f71.google.com
 [209.85.128.71]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.3, cipher=TLS_AES_256_GCM_SHA384) id
 us-mta-103-almsGvBjOJGQQS7IyoK6UA-1; Fri, 28 Apr 2023 12:13:08 -0400
X-MC-Unique: almsGvBjOJGQQS7IyoK6UA-1
Received: by mail-wm1-f71.google.com with SMTP id 5b1f17b1804b1-3f1749c63c9so36357355e9.3
        for <netdev@vger.kernel.org>; Fri, 28 Apr 2023 09:13:07 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20221208; t=1682698387; x=1685290387;
        h=content-transfer-encoding:in-reply-to:organization:from:references
         :cc:to:content-language:subject:user-agent:mime-version:date
         :message-id:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=5xkaTJLSgSiHWckTCCg+jkvg+cPl3tpnSAiaPo9ljdQ=;
        b=TRAG4hPC+Iu+XrhsF/KXhAlJyq8gc1kg2b+RmpQzlt9059ZpbxktJqQZq6FQZJJfaK
         PGneCtjfNDDGaT3N4ZzTVj/19HZKbjk40xidza3JvVS+9QM/V51U0B0WhJPaCdzng+mh
         EpiDxusw2LJF6zHKWiS4/RbtFARBZBqVYbQPQ/GOgp2Hp8eTsAAS3E4B/bLFrQGvzGq1
         kOxBCMh+ScOB+5EiHFMRwzdE580kNvD2ECEUi2dfteWQFhs1zF66ppUny273J3fhvvDR
         mbonA0M6p9lup2y+xvJhojc9hwsiMuW/w6hHsv8nmw5JLPcc5Nfjyl3m3K2FoKcJenhl
         6slQ==
X-Gm-Message-State: AC+VfDwLmgOyBTkCwRtnv/rgXjV4/Z7VFsRaz8LoKORtZ2TYSlG66DzO
        6AgAbi0AA8FjvqsKe6iyrpcdLj+oIUEJZds9jF0uOEg4uMHamxjl8mU6plWGWBYUtX4yaaYqq5f
        T0V0PMgQVkwzaIlQa
X-Received: by 2002:a1c:cc0f:0:b0:3f1:718d:a21c with SMTP id h15-20020a1ccc0f000000b003f1718da21cmr4546926wmb.31.1682698386872;
        Fri, 28 Apr 2023 09:13:06 -0700 (PDT)
X-Google-Smtp-Source: ACHHUZ5UcVnruZKFM610WaYbD7KosGHJuT9juitvMObOnL1WWik01k7wINU0BT60S4IoSquURMFEKg==
X-Received: by 2002:a1c:cc0f:0:b0:3f1:718d:a21c with SMTP id h15-20020a1ccc0f000000b003f1718da21cmr4546897wmb.31.1682698386533;
        Fri, 28 Apr 2023 09:13:06 -0700 (PDT)
Received: from ?IPV6:2003:cb:c726:9300:1711:356:6550:7502? (p200300cbc72693001711035665507502.dip0.t-ipconnect.de. [2003:cb:c726:9300:1711:356:6550:7502])
        by smtp.gmail.com with ESMTPSA id c21-20020a7bc855000000b003f17300c7dcsm24667685wml.48.2023.04.28.09.13.04
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Fri, 28 Apr 2023 09:13:06 -0700 (PDT)
Message-ID: <39cc0f26-8fc2-79dd-2e84-62238d27fd98@redhat.com>
Date:   Fri, 28 Apr 2023 18:13:03 +0200
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:102.0) Gecko/20100101
 Thunderbird/102.10.0
Subject: Re: [PATCH v5] mm/gup: disallow GUP writing to file-backed mappings
 by default
Content-Language: en-US
To:     "Kirill A . Shutemov" <kirill@shutemov.name>
Cc:     Lorenzo Stoakes <lstoakes@gmail.com>,
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
References: <6b73e692c2929dc4613af711bdf92e2ec1956a66.1682638385.git.lstoakes@gmail.com>
 <afcc124e-7a9b-879c-dfdf-200426b84e24@redhat.com>
 <ZEvZtIb2EDb/WudP@nvidia.com>
 <094d2074-5b69-5d61-07f7-9f962014fa68@redhat.com>
 <400da248-a14e-46a4-420a-a3e075291085@redhat.com>
 <077c4b21-8806-455f-be98-d7052a584259@lucifer.local>
 <62ec50da-5f73-559c-c4b3-bde4eb215e08@redhat.com>
 <6ddc7ac4-4091-632a-7b2c-df2005438ec4@redhat.com>
 <20230428160925.5medjfxkyvmzfyhq@box.shutemov.name>
From:   David Hildenbrand <david@redhat.com>
Organization: Red Hat
In-Reply-To: <20230428160925.5medjfxkyvmzfyhq@box.shutemov.name>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
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

On 28.04.23 18:09, Kirill A . Shutemov wrote:
> On Fri, Apr 28, 2023 at 05:43:52PM +0200, David Hildenbrand wrote:
>> On 28.04.23 17:34, David Hildenbrand wrote:
>>> On 28.04.23 17:33, Lorenzo Stoakes wrote:
>>>> On Fri, Apr 28, 2023 at 05:23:29PM +0200, David Hildenbrand wrote:
>>>>>>>
>>>>>>> Security is the primary case where we have historically closed uAPI
>>>>>>> items.
>>>>>>
>>>>>> As this patch
>>>>>>
>>>>>> 1) Does not tackle GUP-fast
>>>>>> 2) Does not take care of !FOLL_LONGTERM
>>>>>>
>>>>>> I am not convinced by the security argument in regard to this patch.
>>>>>>
>>>>>>
>>>>>> If we want to sells this as a security thing, we have to block it
>>>>>> *completely* and then CC stable.
>>>>>
>>>>> Regarding GUP-fast, to fix the issue there as well, I guess we could do
>>>>> something similar as I did in gup_must_unshare():
>>>>>
>>>>> If we're in GUP-fast (no VMA), and want to pin a !anon page writable,
>>>>> fallback to ordinary GUP. IOW, if we don't know, better be safe.
>>>>
>>>> How do we determine it's non-anon in the first place? The check is on the
>>>> VMA. We could do it by following page tables down to folio and checking
>>>> folio->mapping for PAGE_MAPPING_ANON I suppose?
>>>
>>> PageAnon(page) can be called from GUP-fast after grabbing a reference.
>>> See gup_must_unshare().
>>
>> IIRC, PageHuge() can also be called from GUP-fast and could special-case
>> hugetlb eventually, as it's table while we hold a (temporary) reference.
>> Shmem might be not so easy ...
> 
> page->mapping->a_ops should be enough to whitelist whatever fs you want.
> 

The issue is how to stabilize that from GUP-fast, such that we can 
safely dereference the mapping. Any idea?

At least for anon page I know that page->mapping only gets cleared when 
freeing the page, and we don't dereference the mapping but only check a 
single flag stored alongside the mapping. Therefore, PageAnon() is fine 
in GUP-fast context.

-- 
Thanks,

David / dhildenb

