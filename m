Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 4B7B26F4A1F
	for <lists+netdev@lfdr.de>; Tue,  2 May 2023 21:08:38 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229588AbjEBTIc (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 2 May 2023 15:08:32 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:43620 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229491AbjEBTIb (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 2 May 2023 15:08:31 -0400
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.129.124])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 8E1451BFA
        for <netdev@vger.kernel.org>; Tue,  2 May 2023 12:07:40 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1683054459;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=zGWUypSlNFUZ+/3q2aJ5NcsID04VpGZOZxH889+oKvA=;
        b=CGVpyhTUXRFHUkjVC8A2APEjmrP6TY6cLwd0dyZUWsAXk95lyFvmtbylmz3xBLPEsv/Ryl
        RVFdmhICO3zibkTbY8Nug6BGYR8G6elG1+jTfJ6V17jtsK+yaV/yNpn7f3KQNjURT6Ob7m
        I4ecOwvSaTIt5hjZRCLiesDvIc4tPcw=
Received: from mail-wr1-f71.google.com (mail-wr1-f71.google.com
 [209.85.221.71]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.3, cipher=TLS_AES_256_GCM_SHA384) id
 us-mta-351-5Y5delViOwerOESb76ckfw-1; Tue, 02 May 2023 15:07:38 -0400
X-MC-Unique: 5Y5delViOwerOESb76ckfw-1
Received: by mail-wr1-f71.google.com with SMTP id ffacd0b85a97d-306286b3573so1995627f8f.2
        for <netdev@vger.kernel.org>; Tue, 02 May 2023 12:07:38 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20221208; t=1683054457; x=1685646457;
        h=content-transfer-encoding:in-reply-to:organization:from:references
         :cc:to:content-language:subject:user-agent:mime-version:date
         :message-id:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=zGWUypSlNFUZ+/3q2aJ5NcsID04VpGZOZxH889+oKvA=;
        b=RyC+/1laa6WcoVWmEOCvQJ07MgV6md6ge2019urc/hVk6KtUDfVpkR+jWAZsiEeXCF
         O0H4H2iiZbEaUQKHhr947Y2jdob7+3uX51AHCTUQjzqF4YQ3KjsM6AbHA4TovPORLMLk
         d0yzssujJgYjJKu+yLlcbK63FQmgu7MGpaTmLc6gz4dpLUTKvN/u9YQId74BDL60Hvs5
         6oCwARy2FUQfvBgjDZqL2RgKOuTTIPSiX1677h6CTeu0dDmIMlXi2hmnrWU0yYNmmc7k
         0jkM5ETRdtGpjDmwaKvjMRrn45el706/xaaQqtjSBTzqn8QligGl7PyrsuoNWfh26XcH
         gZ3g==
X-Gm-Message-State: AC+VfDycc/O3F+0bHZ6NKQp+ItsBf/HFhLQFERrdkKELDT25QZHpQM9b
        SEEifORCZpfw0WRZ/BYHGeMBQKeCA5Szc6h562RMa82rfBMfEYltpgm8Ilc+lyCu2pThzV1/GAR
        tX1xDCw9A8SUaJ+jE
X-Received: by 2002:a5d:6850:0:b0:306:3a1c:daf3 with SMTP id o16-20020a5d6850000000b003063a1cdaf3mr1866202wrw.64.1683054457257;
        Tue, 02 May 2023 12:07:37 -0700 (PDT)
X-Google-Smtp-Source: ACHHUZ7+bxVLJbHb4fzO1H8M4bTiWPGLyxb72ysQR7FyMkByTzQ2GEygyTzZRvqjoL+7XafXPBD/Bg==
X-Received: by 2002:a5d:6850:0:b0:306:3a1c:daf3 with SMTP id o16-20020a5d6850000000b003063a1cdaf3mr1866155wrw.64.1683054456817;
        Tue, 02 May 2023 12:07:36 -0700 (PDT)
Received: from ?IPV6:2003:cb:c700:2400:6b79:2aa:9602:7016? (p200300cbc70024006b7902aa96027016.dip0.t-ipconnect.de. [2003:cb:c700:2400:6b79:2aa:9602:7016])
        by smtp.gmail.com with ESMTPSA id j3-20020a5d6183000000b002faaa9a1721sm31783536wru.58.2023.05.02.12.07.34
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Tue, 02 May 2023 12:07:36 -0700 (PDT)
Message-ID: <4c032450-7184-fdb9-7b50-670ff06fc225@redhat.com>
Date:   Tue, 2 May 2023 21:07:34 +0200
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:102.0) Gecko/20100101
 Thunderbird/102.10.0
Subject: Re: [PATCH v7 3/3] mm/gup: disallow FOLL_LONGTERM GUP-fast writing to
 file-backed mappings
Content-Language: en-US
To:     Lorenzo Stoakes <lstoakes@gmail.com>
Cc:     Peter Zijlstra <peterz@infradead.org>, linux-mm@kvack.org,
        linux-kernel@vger.kernel.org,
        Andrew Morton <akpm@linux-foundation.org>,
        Jason Gunthorpe <jgg@ziepe.ca>, Jens Axboe <axboe@kernel.dk>,
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
        Jason Gunthorpe <jgg@nvidia.com>,
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
From:   David Hildenbrand <david@redhat.com>
Organization: Red Hat
In-Reply-To: <3a8c672d-4e6c-4705-9d6c-509d3733eb05@lucifer.local>
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

On 02.05.23 20:17, Lorenzo Stoakes wrote:
> On Tue, May 02, 2023 at 07:34:06PM +0200, David Hildenbrand wrote:
>> On 02.05.23 19:22, Peter Zijlstra wrote:
>>> On Tue, May 02, 2023 at 07:13:49PM +0200, David Hildenbrand wrote:
>>>> [...]
>>>>
>>>>> +{
>>>>> +	struct address_space *mapping;
>>>>> +
>>>>> +	/*
>>>>> +	 * GUP-fast disables IRQs - this prevents IPIs from causing page tables
>>>>> +	 * to disappear from under us, as well as preventing RCU grace periods
>>>>> +	 * from making progress (i.e. implying rcu_read_lock()).
>>>>> +	 *
>>>>> +	 * This means we can rely on the folio remaining stable for all
>>>>> +	 * architectures, both those that set CONFIG_MMU_GATHER_RCU_TABLE_FREE
>>>>> +	 * and those that do not.
>>>>> +	 *
>>>>> +	 * We get the added benefit that given inodes, and thus address_space,
>>>>> +	 * objects are RCU freed, we can rely on the mapping remaining stable
>>>>> +	 * here with no risk of a truncation or similar race.
>>>>> +	 */
>>>>> +	lockdep_assert_irqs_disabled();
>>>>> +
>>>>> +	/*
>>>>> +	 * If no mapping can be found, this implies an anonymous or otherwise
>>>>> +	 * non-file backed folio so in this instance we permit the pin.
>>>>> +	 *
>>>>> +	 * shmem and hugetlb mappings do not require dirty-tracking so we
>>>>> +	 * explicitly whitelist these.
>>>>> +	 *
>>>>> +	 * Other non dirty-tracked folios will be picked up on the slow path.
>>>>> +	 */
>>>>> +	mapping = folio_mapping(folio);
>>>>> +	return !mapping || shmem_mapping(mapping) || folio_test_hugetlb(folio);
>>>>
>>>> "Folios in the swap cache return the swap mapping" -- you might disallow
>>>> pinning anonymous pages that are in the swap cache.
>>>>
>>>> I recall that there are corner cases where we can end up with an anon page
>>>> that's mapped writable but still in the swap cache ... so you'd fallback to
>>>> the GUP slow path (acceptable for these corner cases, I guess), however
>>>> especially the comment is a bit misleading then.
>>>>
>>>> So I'd suggest not dropping the folio_test_anon() check, or open-coding it
>>>> ... which will make this piece of code most certainly easier to get when
>>>> staring at folio_mapping(). Or to spell it out in the comment (usually I
>>>> prefer code over comments).
>>>
>>> So how stable is folio->mapping at this point? Can two subsequent reads
>>> get different values? (eg. an actual mapping and NULL)
>>>
>>> If so, folio_mapping() itself seems to be missing a READ_ONCE() to avoid
>>> the compiler from emitting the load multiple times.
>>
>> I can only talk about anon pages in this specific call order here (check
>> first, then test if the PTE changed in the meantime): we don't care if we
>> get two different values. If we get a different value the second time,
>> surely we (temporarily) pinned an anon page that is no longer mapped (freed
>> in the meantime). But in that case (even if we read garbage folio->mapping
>> and made the wrong call here), we'll detect afterwards that the PTE changed,
>> and unpin what we (temporarily) pinned. As folio_test_anon() only checks two
>> bits in folio->mapping it's fine, because we won't dereference garbage
>> folio->mapping.
>>
>> With folio_mapping() on !anon and READ_ONCE() ... good question. Kirill said
>> it would be fairly stable, but I suspect that it could change (especially if
>> we call it before validating if the PTE changed as I described further
>> below).
>>
>> Now, if we read folio->mapping after checking if the page we pinned is still
>> mapped (PTE unchanged), at least the page we pinned cannot be reused in the
>> meantime. I suspect that we can still read "NULL" on the second read. But
>> whatever we dereference from the first read should still be valid, even if
>> the second read would have returned NULL ("rcu freeing").
>>
> 
> On a specific point - if mapping turns out to be NULL after we confirm
> stable PTE, I'd be inclined to reject and let the slow path take care of
> it, would you agree that that's the correct approach?

If it's not an anon page and the mapping is NULL, I'd say simply 
fallback to the slow path.

-- 
Thanks,

David / dhildenb

