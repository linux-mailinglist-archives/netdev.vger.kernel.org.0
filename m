Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id BA0C46F488C
	for <lists+netdev@lfdr.de>; Tue,  2 May 2023 18:43:43 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233982AbjEBQnk (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 2 May 2023 12:43:40 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:35042 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S234257AbjEBQni (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 2 May 2023 12:43:38 -0400
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.133.124])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 84D671BF0
        for <netdev@vger.kernel.org>; Tue,  2 May 2023 09:42:50 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1683045769;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=dpO0j0fuAlZuSPU9fXnXLLOnBHWx4/eBeZNb665FeGo=;
        b=LpwUvUKTn6dkHShQyY7CiX9tkiBkYksUj0U+DwRg27ewzArZLSv2N+tapdZKPGHI662Hi9
        roT0K2ZmStl8UmprQ/zM7MLD2LmzrTeJBDPhx2bG9yw5ZOgTgQ9Q222Ms1v9EMatMUDZXn
        I9JzbGjVfPQBNcZeyuVt5EzApPrhUfo=
Received: from mail-wm1-f72.google.com (mail-wm1-f72.google.com
 [209.85.128.72]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.3, cipher=TLS_AES_256_GCM_SHA384) id
 us-mta-460-XdoPBIozNqCiK2CsyNy1xQ-1; Tue, 02 May 2023 12:42:48 -0400
X-MC-Unique: XdoPBIozNqCiK2CsyNy1xQ-1
Received: by mail-wm1-f72.google.com with SMTP id 5b1f17b1804b1-3f3157128b4so110163565e9.0
        for <netdev@vger.kernel.org>; Tue, 02 May 2023 09:42:48 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20221208; t=1683045767; x=1685637767;
        h=content-transfer-encoding:in-reply-to:organization:from:references
         :cc:to:content-language:subject:user-agent:mime-version:date
         :message-id:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=dpO0j0fuAlZuSPU9fXnXLLOnBHWx4/eBeZNb665FeGo=;
        b=FjWU0HDjaFnqxrzCLuCIq3iN9N7AY0jcHDnB4jDyFv3XZlSzcMfcbp7v9jWFGLx8/I
         FUSwVfMgtORYsJHzitu1p9IAGWDdK144P1/Pp6/SkQxwzja3XlVPsWh1w5X/B2vXTH5Q
         bvkLwjPlNfv/irr1XiwBB3GNlihtkjkHkZcbqcIKeKzy0ywy2KskinvTDSpZeMFM65eE
         T5POIK71+ehwfF2Mx4v4Kky5bGV4kFhMhtIh3cCXnA85i975jx+MBj5LuhNWPXbA2ncV
         BLBbnFbdj+XVPmEP9+L8bNtGhK1jHLd9WUxTysA5OAtJOtNlPd4jBt8j79tWzy+EGTWg
         8iXQ==
X-Gm-Message-State: AC+VfDwqHqanR/hm4MHgp5jylSypf9qNl/MRnLFR7xJerdLBTDUO6rUI
        ER7nQcMe9/TgD9c/kqqqknf5m6NQpqesHi7f1SS/y7aLsKA6SYRPLKxMTAFi2ntECy4BCbDPgH1
        llbHvOMUMii6j8CEy
X-Received: by 2002:a5d:68c5:0:b0:306:2c20:c4fb with SMTP id p5-20020a5d68c5000000b003062c20c4fbmr5554481wrw.2.1683045767269;
        Tue, 02 May 2023 09:42:47 -0700 (PDT)
X-Google-Smtp-Source: ACHHUZ78lwNkqI+m8OE8j/YlVV4qi/BTpTIcVJ+8rzfRbqfEcCWatqDcWBDzUV8LMYWKUuettICYWg==
X-Received: by 2002:a5d:68c5:0:b0:306:2c20:c4fb with SMTP id p5-20020a5d68c5000000b003062c20c4fbmr5554450wrw.2.1683045766894;
        Tue, 02 May 2023 09:42:46 -0700 (PDT)
Received: from ?IPV6:2003:cb:c700:2400:6b79:2aa:9602:7016? (p200300cbc70024006b7902aa96027016.dip0.t-ipconnect.de. [2003:cb:c700:2400:6b79:2aa:9602:7016])
        by smtp.gmail.com with ESMTPSA id u12-20020adfdd4c000000b0030635735a57sm2817098wrm.60.2023.05.02.09.42.43
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Tue, 02 May 2023 09:42:45 -0700 (PDT)
Message-ID: <d2ca4a03-dd7e-29d8-d932-4ee5a31e1ab2@redhat.com>
Date:   Tue, 2 May 2023 18:42:42 +0200
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:102.0) Gecko/20100101
 Thunderbird/102.10.0
Subject: Re: [PATCH v7 2/3] mm/gup: disallow FOLL_LONGTERM GUP-nonfast writing
 to file-backed mappings
Content-Language: en-US
To:     Lorenzo Stoakes <lstoakes@gmail.com>, linux-mm@kvack.org,
        linux-kernel@vger.kernel.org,
        Andrew Morton <akpm@linux-foundation.org>
Cc:     Jason Gunthorpe <jgg@ziepe.ca>, Jens Axboe <axboe@kernel.dk>,
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
 <f50f2b5794820a1f5dc597277a5f0a9a87d9d152.1683044162.git.lstoakes@gmail.com>
From:   David Hildenbrand <david@redhat.com>
Organization: Red Hat
In-Reply-To: <f50f2b5794820a1f5dc597277a5f0a9a87d9d152.1683044162.git.lstoakes@gmail.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-3.7 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,NICE_REPLY_A,
        RCVD_IN_DNSWL_NONE,RCVD_IN_MSPIKE_H2,SPF_HELO_NONE,SPF_NONE,
        T_SCC_BODY_TEXT_LINE autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On 02.05.23 18:34, Lorenzo Stoakes wrote:
> Writing to file-backed mappings which require folio dirty tracking using
> GUP is a fundamentally broken operation, as kernel write access to GUP
> mappings do not adhere to the semantics expected by a file system.
> 
> A GUP caller uses the direct mapping to access the folio, which does not
> cause write notify to trigger, nor does it enforce that the caller marks
> the folio dirty.
> 
> The problem arises when, after an initial write to the folio, writeback
> results in the folio being cleaned and then the caller, via the GUP
> interface, writes to the folio again.
> 
> As a result of the use of this secondary, direct, mapping to the folio no
> write notify will occur, and if the caller does mark the folio dirty, this
> will be done so unexpectedly.
> 
> For example, consider the following scenario:-
> 
> 1. A folio is written to via GUP which write-faults the memory, notifying
>     the file system and dirtying the folio.
> 2. Later, writeback is triggered, resulting in the folio being cleaned and
>     the PTE being marked read-only.
> 3. The GUP caller writes to the folio, as it is mapped read/write via the
>     direct mapping.
> 4. The GUP caller, now done with the page, unpins it and sets it dirty
>     (though it does not have to).
> 
> This results in both data being written to a folio without writenotify, and
> the folio being dirtied unexpectedly (if the caller decides to do so).
> 
> This issue was first reported by Jan Kara [1] in 2018, where the problem
> resulted in file system crashes.
> 
> This is only relevant when the mappings are file-backed and the underlying
> file system requires folio dirty tracking. File systems which do not, such
> as shmem or hugetlb, are not at risk and therefore can be written to
> without issue.
> 
> Unfortunately this limitation of GUP has been present for some time and
> requires future rework of the GUP API in order to provide correct write
> access to such mappings.
> 
> However, for the time being we introduce this check to prevent the most
> egregious case of this occurring, use of the FOLL_LONGTERM pin.
> 
> These mappings are considerably more likely to be written to after
> folios are cleaned and thus simply must not be permitted to do so.
> 
> This patch changes only the slow-path GUP functions, a following patch
> adapts the GUP-fast path along similar lines.
> 
> [1]:https://lore.kernel.org/linux-mm/20180103100430.GE4911@quack2.suse.cz/
> 
> Suggested-by: Jason Gunthorpe <jgg@nvidia.com>
> Signed-off-by: Lorenzo Stoakes <lstoakes@gmail.com>
> Reviewed-by: John Hubbard <jhubbard@nvidia.com>
> Reviewed-by: Mika Penttilä <mpenttil@redhat.com>
> Reviewed-by: Jan Kara <jack@suse.cz>
> Reviewed-by: Jason Gunthorpe <jgg@nvidia.com>
> ---
>   mm/gup.c | 43 ++++++++++++++++++++++++++++++++++++++++++-
>   1 file changed, 42 insertions(+), 1 deletion(-)
> 
> diff --git a/mm/gup.c b/mm/gup.c
> index ff689c88a357..6e209ca10967 100644
> --- a/mm/gup.c
> +++ b/mm/gup.c
> @@ -959,16 +959,53 @@ static int faultin_page(struct vm_area_struct *vma,
>   	return 0;
>   }
>   
> +/*
> + * Writing to file-backed mappings which require folio dirty tracking using GUP
> + * is a fundamentally broken operation, as kernel write access to GUP mappings
> + * do not adhere to the semantics expected by a file system.
> + *
> + * Consider the following scenario:-
> + *
> + * 1. A folio is written to via GUP which write-faults the memory, notifying
> + *    the file system and dirtying the folio.
> + * 2. Later, writeback is triggered, resulting in the folio being cleaned and
> + *    the PTE being marked read-only.
> + * 3. The GUP caller writes to the folio, as it is mapped read/write via the
> + *    direct mapping.
> + * 4. The GUP caller, now done with the page, unpins it and sets it dirty
> + *    (though it does not have to).
> + *
> + * This results in both data being written to a folio without writenotify, and
> + * the folio being dirtied unexpectedly (if the caller decides to do so).
> + */
> +static bool writeable_file_mapping_allowed(struct vm_area_struct *vma,
> +					   unsigned long gup_flags)
> +{
> +	/*
> +	 * If we aren't pinning then no problematic write can occur. A long term
> +	 * pin is the most egregious case so this is the case we disallow.
> +	 */
> +	if (!(gup_flags & (FOLL_PIN | FOLL_LONGTERM)))
> +		return true;

If you really want to keep FOLL_PIN here ... this has to be

if ((gup_flags & (FOLL_PIN | FOLL_LONGTERM)) != (FOLL_PIN | FOLL_LONGTERM))

or two separate checks.

Otherwise you'd also proceed if only FOLL_PIN is set.

Unless my tired eyes betrayed me.


-- 
Thanks,

David / dhildenb

