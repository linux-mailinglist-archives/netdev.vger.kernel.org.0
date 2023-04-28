Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 129F56F1C30
	for <lists+netdev@lfdr.de>; Fri, 28 Apr 2023 18:04:07 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1345383AbjD1QEB (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 28 Apr 2023 12:04:01 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:35840 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1345164AbjD1QDw (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 28 Apr 2023 12:03:52 -0400
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.133.124])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 06E555B8C
        for <netdev@vger.kernel.org>; Fri, 28 Apr 2023 09:03:05 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1682697785;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=ygEgijBc1IgIq8cFGjEh4tdLm5WBe48ZCNtdfsoShbQ=;
        b=ATsISI1ysJmOJEVlgxfQ+k6OI2e/8Sz4Ofmnd14U5ZW1OiaKfirc/t8H2eZgQV0p6Fgdnz
        FWfsvTCC8JE1ZyAbiSUn3z6JuFuShAZ6OsKIrqz0/A0N61sblcnyrc+H1JlFfwERqqJLZg
        oA/ZbUmRcpp1ApA0wqHlurL4y1/ZWpI=
Received: from mail-wr1-f71.google.com (mail-wr1-f71.google.com
 [209.85.221.71]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.3, cipher=TLS_AES_256_GCM_SHA384) id
 us-mta-530-2h7hrVpCPAW-ilIamvTSmg-1; Fri, 28 Apr 2023 12:03:02 -0400
X-MC-Unique: 2h7hrVpCPAW-ilIamvTSmg-1
Received: by mail-wr1-f71.google.com with SMTP id ffacd0b85a97d-2ffa43cd733so5861818f8f.1
        for <netdev@vger.kernel.org>; Fri, 28 Apr 2023 09:03:00 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20221208; t=1682697779; x=1685289779;
        h=content-transfer-encoding:in-reply-to:organization:from:references
         :cc:to:content-language:subject:user-agent:mime-version:date
         :message-id:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=ygEgijBc1IgIq8cFGjEh4tdLm5WBe48ZCNtdfsoShbQ=;
        b=LpLN8K53xOQjjixxowvbqmGlXJYvFdIY23UtrNN2tmXCCGEtEvn0qQ2GLV0L3bE/oL
         32E8i4bGTLpyOloQoq5TyjYOStguwFYHBD+kkVUj6E2QxrJjz3mVbVRz+MZNGgLdBJ5d
         5gWJkIL3fE//md2IQPQj2z4SptQ6zlgMsZ8aPwlXsbsiDtSLq5clWuovZZU5c5egPphi
         d/SQBt/un3uUPzWMsA6V3Rmpn1wRRMWnyJBhMmRin6CM3wSGS0pSBo0Ek5U/5yzSxrkO
         wNshxoe5LID7XQWxS5gMUp1hfrMCY6NupEdHRm6QS8B9wQlSFO5r9h2d27iCZMO05g1/
         XOIQ==
X-Gm-Message-State: AC+VfDzowbvNfWHbXNhnsmRZrG7A634kAjDpvG9EBslhFBl8JBwF+X3U
        kwZ7k2o28rgPidkTE528uhS0rvzXg3GSnKxGg9N7S7jy+lOb+xp81/krlaeZqxVJkTiZop3eGz0
        SG8M7kwi9Rg0JMW5i
X-Received: by 2002:a5d:595a:0:b0:304:7237:729a with SMTP id e26-20020a5d595a000000b003047237729amr4261524wri.67.1682697779309;
        Fri, 28 Apr 2023 09:02:59 -0700 (PDT)
X-Google-Smtp-Source: ACHHUZ7Ku7Blfk4RQb9TUtQ5+s7GnYVImteWm54uw3a9dTygTNMWUmW0JJgkbiWnH2eUAqvpUaXDng==
X-Received: by 2002:a5d:595a:0:b0:304:7237:729a with SMTP id e26-20020a5d595a000000b003047237729amr4261467wri.67.1682697778920;
        Fri, 28 Apr 2023 09:02:58 -0700 (PDT)
Received: from ?IPV6:2003:cb:c726:9300:1711:356:6550:7502? (p200300cbc72693001711035665507502.dip0.t-ipconnect.de. [2003:cb:c726:9300:1711:356:6550:7502])
        by smtp.gmail.com with ESMTPSA id x8-20020a05600c21c800b003f2390bdd0csm16068630wmj.32.2023.04.28.09.02.56
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Fri, 28 Apr 2023 09:02:58 -0700 (PDT)
Message-ID: <0e6ef85d-d53a-c847-c70b-900eb925a413@redhat.com>
Date:   Fri, 28 Apr 2023 18:02:56 +0200
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:102.0) Gecko/20100101
 Thunderbird/102.10.0
Subject: Re: [PATCH v5] mm/gup: disallow GUP writing to file-backed mappings
 by default
Content-Language: en-US
To:     Peter Xu <peterx@redhat.com>
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
        "Kirill A . Shutemov" <kirill@shutemov.name>,
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
 <62ec50da-5f73-559c-c4b3-bde4eb215e08@redhat.com> <ZEvsx998gDFig/zq@x1n>
From:   David Hildenbrand <david@redhat.com>
Organization: Red Hat
In-Reply-To: <ZEvsx998gDFig/zq@x1n>
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

On 28.04.23 17:56, Peter Xu wrote:
> On Fri, Apr 28, 2023 at 05:34:35PM +0200, David Hildenbrand wrote:
>> On 28.04.23 17:33, Lorenzo Stoakes wrote:
>>> On Fri, Apr 28, 2023 at 05:23:29PM +0200, David Hildenbrand wrote:
>>>>>>
>>>>>> Security is the primary case where we have historically closed uAPI
>>>>>> items.
>>>>>
>>>>> As this patch
>>>>>
>>>>> 1) Does not tackle GUP-fast
>>>>> 2) Does not take care of !FOLL_LONGTERM
>>>>>
>>>>> I am not convinced by the security argument in regard to this patch.
>>>>>
>>>>>
>>>>> If we want to sells this as a security thing, we have to block it
>>>>> *completely* and then CC stable.
>>>>
>>>> Regarding GUP-fast, to fix the issue there as well, I guess we could do
>>>> something similar as I did in gup_must_unshare():
>>>>
>>>> If we're in GUP-fast (no VMA), and want to pin a !anon page writable,
>>>> fallback to ordinary GUP. IOW, if we don't know, better be safe.
>>>
>>> How do we determine it's non-anon in the first place? The check is on the
>>> VMA. We could do it by following page tables down to folio and checking
>>> folio->mapping for PAGE_MAPPING_ANON I suppose?
>>
>> PageAnon(page) can be called from GUP-fast after grabbing a reference. See
>> gup_must_unshare().
> 
> Hmm.. Is it a good idea at all to sacrifise all "!anon" fast-gups for this?
> People will silently got degrade even on legal pins on shmem/hugetlb, I
> think, which seems to be still a very major use case.
> 

Right. Optimizing for hugetlb should be easy. Shmem is problematic.

I once raised to John that PageAnonExclusive is essentially a "anon page 
is pinnable" flag. Too bad we don't have spare page flags ;)

-- 
Thanks,

David / dhildenb

