Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 993A66F4A6A
	for <lists+netdev@lfdr.de>; Tue,  2 May 2023 21:34:39 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229572AbjEBTeh (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 2 May 2023 15:34:37 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:53432 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229452AbjEBTeg (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 2 May 2023 15:34:36 -0400
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.133.124])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 9A9861BF9
        for <netdev@vger.kernel.org>; Tue,  2 May 2023 12:33:51 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1683056030;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=L7V+bKkAFuye2MRxx4y1CCTYTgcYyMX5mEQB4XsE6J8=;
        b=Y3GEHXbVQKRxDGlnNmRFXBdRcLUpDpKn2OpNUlZGq9qiJsrrTAQvCRp1/TL8ieh377xWBd
        vE+/bTvLiGMQVWQ68CInEgG+D1M9K0DZ7hYRSLMML0AuHtCQnbwaFWhI9vTrnuIdj4YWoV
        wW3RBTnHbsP8mQUjIM3IfQXWJ2io6vo=
Received: from mail-wm1-f72.google.com (mail-wm1-f72.google.com
 [209.85.128.72]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.3, cipher=TLS_AES_256_GCM_SHA384) id
 us-mta-618-bRWr_HHtPguBgCRJqCGDvQ-1; Tue, 02 May 2023 15:33:49 -0400
X-MC-Unique: bRWr_HHtPguBgCRJqCGDvQ-1
Received: by mail-wm1-f72.google.com with SMTP id 5b1f17b1804b1-3f18c2b2110so13377515e9.3
        for <netdev@vger.kernel.org>; Tue, 02 May 2023 12:33:49 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20221208; t=1683056028; x=1685648028;
        h=content-transfer-encoding:in-reply-to:organization:from:references
         :cc:to:content-language:subject:user-agent:mime-version:date
         :message-id:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=L7V+bKkAFuye2MRxx4y1CCTYTgcYyMX5mEQB4XsE6J8=;
        b=NyYWU6wg8KLsYlmBqgP/efGOdgIRPq9KTz81omFLpayxMw4sjIBnPq3kT6aZr+mRWQ
         CvkYoYjou40zw+T6nIgnnMdjhSSWNPTk8jrR0w5hX5NJ/Kd8F0jODrfEcLA+hjsJ0Hsp
         RnEsyiCQq5gW3fVleHGcjfjg+/N2dgUnLacxeHNj3JcfxrhLcf9/BxB83HxZa5zjhqI9
         gCMOzh+yefHfXVbrC4Eheze/vTddoSzr0lVAb64+jpv2vntWmM5nSyIx3yrB9dUmsASN
         Xs3PYzSxSl2ZXW/HJk17vckqxGBAldZeqnU9BVBEaORVVdLG7OryS7VwUS3yiMdsze6J
         VKvw==
X-Gm-Message-State: AC+VfDxI1/avbBM11acevTYSSkuL11e88D9t+PqkKJWsRtsg/WvcOTUV
        t57yIaMCpTwXnN9FebGFEXciJQ8R8sa4kj/kCpV3ebmxeFDoxhW4IlZKSvKDDJ/vHd8xkWKo22G
        3W2Q1A2IO5AeG+neM
X-Received: by 2002:a1c:7718:0:b0:3ef:8b0:dbb1 with SMTP id t24-20020a1c7718000000b003ef08b0dbb1mr12952244wmi.7.1683056028356;
        Tue, 02 May 2023 12:33:48 -0700 (PDT)
X-Google-Smtp-Source: ACHHUZ4DkkBXktcp2fh05x309qPmU18lpfJUGbCKcyUtssYv4FJqdb9r1N5Pi5T6sFgBVeds17Epsw==
X-Received: by 2002:a1c:7718:0:b0:3ef:8b0:dbb1 with SMTP id t24-20020a1c7718000000b003ef08b0dbb1mr12952237wmi.7.1683056028021;
        Tue, 02 May 2023 12:33:48 -0700 (PDT)
Received: from ?IPV6:2003:cb:c700:2400:6b79:2aa:9602:7016? (p200300cbc70024006b7902aa96027016.dip0.t-ipconnect.de. [2003:cb:c700:2400:6b79:2aa:9602:7016])
        by smtp.gmail.com with ESMTPSA id 3-20020a05600c22c300b003f31d44f0cbsm15442227wmg.29.2023.05.02.12.33.45
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Tue, 02 May 2023 12:33:47 -0700 (PDT)
Message-ID: <434c60e6-7ac4-229b-5db0-5175afbcfff5@redhat.com>
Date:   Tue, 2 May 2023 21:33:45 +0200
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:102.0) Gecko/20100101
 Thunderbird/102.10.0
Subject: Re: [PATCH v7 3/3] mm/gup: disallow FOLL_LONGTERM GUP-fast writing to
 file-backed mappings
Content-Language: en-US
To:     Lorenzo Stoakes <lstoakes@gmail.com>,
        Jason Gunthorpe <jgg@nvidia.com>
Cc:     Peter Zijlstra <peterz@infradead.org>, linux-mm@kvack.org,
        linux-kernel@vger.kernel.org,
        Andrew Morton <akpm@linux-foundation.org>,
        Jens Axboe <axboe@kernel.dk>,
        Matthew Wilcox <willy@infradead.org>,
        Dennis Dalessandro <dennis.dalessandro@cornelisnetworks.com>,
        Leon Romanovsky <leon@kernel.org>,
        Christian Benvenuti <benve@cisco.com>,
        Nelson Escobar <neescoba@cisco.com>,
        Bernard Metzler <bmt@zurich.ibm.com>,
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
        Dave Chinner <david@fromorbit.com>,
        Theodore Ts'o <tytso@mit.edu>, Peter Xu <peterx@redhat.com>,
        Matthew Rosato <mjrosato@linux.ibm.com>,
        "Paul E . McKenney" <paulmck@kernel.org>,
        Christian Borntraeger <borntraeger@linux.ibm.com>,
        Mike Rapoport <rppt@linux.ibm.com>
References: <cover.1683044162.git.lstoakes@gmail.com>
 <b3a4441cade9770e00d24f5ecb75c8f4481785a4.1683044162.git.lstoakes@gmail.com>
 <1691115d-dba4-636b-d736-6a20359a67c3@redhat.com>
 <20230502172231.GH1597538@hirez.programming.kicks-ass.net>
 <406fd43a-a051-5fbe-6f66-a43f5e7e7573@redhat.com>
 <3a8c672d-4e6c-4705-9d6c-509d3733eb05@lucifer.local>
 <ZFFfhhwibxHKwDbZ@nvidia.com>
 <968fa174-6720-4adf-9107-c777ee0d8da4@lucifer.local>
From:   David Hildenbrand <david@redhat.com>
Organization: Red Hat
In-Reply-To: <968fa174-6720-4adf-9107-c777ee0d8da4@lucifer.local>
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

On 02.05.23 21:25, Lorenzo Stoakes wrote:
> On Tue, May 02, 2023 at 04:07:50PM -0300, Jason Gunthorpe wrote:
>> On Tue, May 02, 2023 at 07:17:14PM +0100, Lorenzo Stoakes wrote:
>>
>>> On a specific point - if mapping turns out to be NULL after we confirm
>>> stable PTE, I'd be inclined to reject and let the slow path take care of
>>> it, would you agree that that's the correct approach?
>>
>> I think in general if GUP fast detects any kind of race it should bail
>> to the slow path.
>>
>> The races it tries to resolve itself should have really safe and
>> obvious solutions.
>>
>> I think this comment is misleading:
>>
>>> +	/*
>>> +	 * GUP-fast disables IRQs - this prevents IPIs from causing page tables
>>> +	 * to disappear from under us, as well as preventing RCU grace periods
>>> +	 * from making progress (i.e. implying rcu_read_lock()).
>>
>> True, but that is not important here since we are not reading page
>> tables
>>
>>> +	 * This means we can rely on the folio remaining stable for all
>>> +	 * architectures, both those that set CONFIG_MMU_GATHER_RCU_TABLE_FREE
>>> +	 * and those that do not.
>>
>> Not really clear. We have a valid folio refcount here, that is all.
> 
> Some of this is a product of mixed signals from different commenters and
> my being perhaps a little _too_ willing to just go with the flow.
> 
> With interrupts disabled and IPI blocked, plus the assurances that
> interrupts being disabled implied the RCU version of page table
> manipulation is also blocked, my understanding was that remapping in this
> process to another page could not occur.
> 
> Of course the folio is 'stable' in the sense we have a refcount on it, but
> it is unlocked so things can change.
> 
> I'm guessing the RCU guarantees in the TLB logic are not as solid as IPI,
> because in the IPI case it seems to me you couldn't even clear the PTE
> entry before getting to the page table case.
> 
> Otherwise, I'm a bit uncertain actually as to how we can get to the point
> where the folio->mapping is being manipulated. Is this why?

I'll just stress again that I think there are cases where we unmap and 
free a page without synchronizing against GUP-fast using an IPI or RCU.

That's one of the reasons why we recheck if the PTE changed to back off, 
so I've been told.

I'm happy if someone proves me wrong and a page we just (temporarily) 
pinned cannot have been freed+reused in the meantime.

-- 
Thanks,

David / dhildenb

