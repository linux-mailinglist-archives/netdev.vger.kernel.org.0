Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id E609C6F1CE6
	for <lists+netdev@lfdr.de>; Fri, 28 Apr 2023 18:52:34 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1346262AbjD1Qwc (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 28 Apr 2023 12:52:32 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:35186 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229523AbjD1Qwb (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 28 Apr 2023 12:52:31 -0400
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.129.124])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 3E1735B9A
        for <netdev@vger.kernel.org>; Fri, 28 Apr 2023 09:51:53 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1682700712;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=9UJtOJNRjK11X6Ax3/YkWZBfom69VzTQrdhUY1o0X2A=;
        b=NfjmJ/XLiOgrCEOdPGzsJG2fw5EFqEeoCNn2LNoTvYO2A4YVu144R5odSk2YK/9Zzh6Gs3
        qhhXLhvlNPxDqUeIrW3cdJ8pbNOQ9pBTaFSpjuT9+ObdEN5D02QNKqQHQztky7VobyGh/S
        nz44COvGRZcgyUIZ8ZcJVKizWxmaGHE=
Received: from mail-wm1-f72.google.com (mail-wm1-f72.google.com
 [209.85.128.72]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.3, cipher=TLS_AES_256_GCM_SHA384) id
 us-mta-37-3KHUOoG4N0-CV_62_xaCpw-1; Fri, 28 Apr 2023 12:51:51 -0400
X-MC-Unique: 3KHUOoG4N0-CV_62_xaCpw-1
Received: by mail-wm1-f72.google.com with SMTP id 5b1f17b1804b1-3f3157128b4so44655525e9.0
        for <netdev@vger.kernel.org>; Fri, 28 Apr 2023 09:51:50 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20221208; t=1682700710; x=1685292710;
        h=content-transfer-encoding:in-reply-to:subject:organization:from
         :references:cc:to:content-language:user-agent:mime-version:date
         :message-id:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=9UJtOJNRjK11X6Ax3/YkWZBfom69VzTQrdhUY1o0X2A=;
        b=CbEgL4wHKDjg7JpW/l4UnoYfjRP3EKFyLjiJeGAc41BDOJTpjd3DHBLVNWC11DReX9
         6Ub8xpWvBKu7qskgHVFDDROroRTk9rtFUkdFSsiSSyjCeqWwQ5MMvkwt2rezrpxCOvFx
         1E5lElgI6zi1tvFnDPh3l6shaaGwV4aqs8URmRsY2S3YvLdp+/ghYjs5LVu/xLyitcx3
         Tcux+xEDyNRwKjPeFW2/oCI3seZ1bKbh1a9LftY/jV/ckrmwaH4JjuFBJt5gXku997DK
         kF4Y5RM1FQsRQCSh9+w/VZvkBfB811W/hVfHmPMm/8ygT3elWzy7UaJush9VO6DDnIpr
         jPkA==
X-Gm-Message-State: AC+VfDxnP1W7+QaqffoFzqpk/hmte0kGPkKbFs875jXz+kgGmyykqg49
        44+1B7XVZBDHy5xLXEbJ5VV3NyWvlzBahzU+fcrkrPURZ+Cg1MnjgSbHMRwvh/T4wzQL0ld2kZ9
        D7rx6MlSwnIAJZ5wc
X-Received: by 2002:a05:600c:350c:b0:3ee:93d2:c915 with SMTP id h12-20020a05600c350c00b003ee93d2c915mr7076509wmq.6.1682700709865;
        Fri, 28 Apr 2023 09:51:49 -0700 (PDT)
X-Google-Smtp-Source: ACHHUZ60Cqp35VglescQbd9Qlua4PQaNkjEb7zMR9lmAYMkPHuIxZahgFKPYNKGQ/ziaWLb1VaUG8g==
X-Received: by 2002:a05:600c:350c:b0:3ee:93d2:c915 with SMTP id h12-20020a05600c350c00b003ee93d2c915mr7076499wmq.6.1682700709524;
        Fri, 28 Apr 2023 09:51:49 -0700 (PDT)
Received: from ?IPV6:2003:cb:c726:9300:1711:356:6550:7502? (p200300cbc72693001711035665507502.dip0.t-ipconnect.de. [2003:cb:c726:9300:1711:356:6550:7502])
        by smtp.gmail.com with ESMTPSA id k18-20020a05600c0b5200b003edf2dc7ca3sm24690362wmr.34.2023.04.28.09.51.47
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Fri, 28 Apr 2023 09:51:48 -0700 (PDT)
Message-ID: <173337c0-14f4-3246-15ff-7fbf03861c94@redhat.com>
Date:   Fri, 28 Apr 2023 18:51:46 +0200
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:102.0) Gecko/20100101
 Thunderbird/102.10.0
Content-Language: en-US
To:     Peter Xu <peterx@redhat.com>,
        "Kirill A . Shutemov" <kirill@shutemov.name>
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
References: <afcc124e-7a9b-879c-dfdf-200426b84e24@redhat.com>
 <ZEvZtIb2EDb/WudP@nvidia.com>
 <094d2074-5b69-5d61-07f7-9f962014fa68@redhat.com>
 <400da248-a14e-46a4-420a-a3e075291085@redhat.com>
 <077c4b21-8806-455f-be98-d7052a584259@lucifer.local>
 <62ec50da-5f73-559c-c4b3-bde4eb215e08@redhat.com>
 <6ddc7ac4-4091-632a-7b2c-df2005438ec4@redhat.com>
 <20230428160925.5medjfxkyvmzfyhq@box.shutemov.name>
 <39cc0f26-8fc2-79dd-2e84-62238d27fd98@redhat.com>
 <20230428162207.o3ejmcz7rzezpt6n@box.shutemov.name> <ZEv2196tk5yWvgW5@x1n>
From:   David Hildenbrand <david@redhat.com>
Organization: Red Hat
Subject: Re: [PATCH v5] mm/gup: disallow GUP writing to file-backed mappings
 by default
In-Reply-To: <ZEv2196tk5yWvgW5@x1n>
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

On 28.04.23 18:39, Peter Xu wrote:
> On Fri, Apr 28, 2023 at 07:22:07PM +0300, Kirill A . Shutemov wrote:
>> On Fri, Apr 28, 2023 at 06:13:03PM +0200, David Hildenbrand wrote:
>>> On 28.04.23 18:09, Kirill A . Shutemov wrote:
>>>> On Fri, Apr 28, 2023 at 05:43:52PM +0200, David Hildenbrand wrote:
>>>>> On 28.04.23 17:34, David Hildenbrand wrote:
>>>>>> On 28.04.23 17:33, Lorenzo Stoakes wrote:
>>>>>>> On Fri, Apr 28, 2023 at 05:23:29PM +0200, David Hildenbrand wrote:
>>>>>>>>>>
>>>>>>>>>> Security is the primary case where we have historically closed uAPI
>>>>>>>>>> items.
>>>>>>>>>
>>>>>>>>> As this patch
>>>>>>>>>
>>>>>>>>> 1) Does not tackle GUP-fast
>>>>>>>>> 2) Does not take care of !FOLL_LONGTERM
>>>>>>>>>
>>>>>>>>> I am not convinced by the security argument in regard to this patch.
>>>>>>>>>
>>>>>>>>>
>>>>>>>>> If we want to sells this as a security thing, we have to block it
>>>>>>>>> *completely* and then CC stable.
>>>>>>>>
>>>>>>>> Regarding GUP-fast, to fix the issue there as well, I guess we could do
>>>>>>>> something similar as I did in gup_must_unshare():
>>>>>>>>
>>>>>>>> If we're in GUP-fast (no VMA), and want to pin a !anon page writable,
>>>>>>>> fallback to ordinary GUP. IOW, if we don't know, better be safe.
>>>>>>>
>>>>>>> How do we determine it's non-anon in the first place? The check is on the
>>>>>>> VMA. We could do it by following page tables down to folio and checking
>>>>>>> folio->mapping for PAGE_MAPPING_ANON I suppose?
>>>>>>
>>>>>> PageAnon(page) can be called from GUP-fast after grabbing a reference.
>>>>>> See gup_must_unshare().
>>>>>
>>>>> IIRC, PageHuge() can also be called from GUP-fast and could special-case
>>>>> hugetlb eventually, as it's table while we hold a (temporary) reference.
>>>>> Shmem might be not so easy ...
>>>>
>>>> page->mapping->a_ops should be enough to whitelist whatever fs you want.
>>>>
>>>
>>> The issue is how to stabilize that from GUP-fast, such that we can safely
>>> dereference the mapping. Any idea?
>>>
>>> At least for anon page I know that page->mapping only gets cleared when
>>> freeing the page, and we don't dereference the mapping but only check a
>>> single flag stored alongside the mapping. Therefore, PageAnon() is fine in
>>> GUP-fast context.
>>
>> What codepath you are worry about that clears ->mapping on pages with
>> non-zero refcount?
>>
>> I can only think of truncate (and punch hole). READ_ONCE(page->mapping)
>> and fail GUP_fast if it is NULL should be fine, no?
>>
>> I guess we should consider if the inode can be freed from under us and the
>> mapping pointer becomes dangling. But I think we should be fine here too:
>> VMA pins inode and VMA cannot go away from under GUP.
> 
> Can vma still go away if during a fast-gup?
> 

So, after we grabbed the page and made sure the the PTE didn't change 
(IOW, the PTE was stable while we processed it), the page can get 
unmapped (but not freed, because we hold a reference) and the VMA can 
theoretically go away (and as far as I understand, nothing stops the 
file from getting deleted, truncated etc).

So we might be looking at folio->mapping and the VMA is no longer there. 
Maybe even the file is no longer there.

-- 
Thanks,

David / dhildenb

