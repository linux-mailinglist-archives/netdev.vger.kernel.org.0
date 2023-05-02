Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 8244E6F499B
	for <lists+netdev@lfdr.de>; Tue,  2 May 2023 20:17:40 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234222AbjEBSRg (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 2 May 2023 14:17:36 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:54958 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229586AbjEBSRe (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 2 May 2023 14:17:34 -0400
Received: from mail-wr1-x42a.google.com (mail-wr1-x42a.google.com [IPv6:2a00:1450:4864:20::42a])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 768D01BFC;
        Tue,  2 May 2023 11:17:17 -0700 (PDT)
Received: by mail-wr1-x42a.google.com with SMTP id ffacd0b85a97d-2fde2879eabso3903389f8f.1;
        Tue, 02 May 2023 11:17:17 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20221208; t=1683051436; x=1685643436;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:from:to:cc:subject:date:message-id:reply-to;
        bh=R3bHT20tkh2F79+SFx041a+gGb7WqEwkVCZSdSx9/lw=;
        b=ABZvkaFx4jKAf56HV0DtLrke19279svzYn5R3maOZMPNdxk0ObOArzxg1z10J93D2a
         yLqJcK/Q43aIz0gAQN6GUv32LLd4ihSJH2F3lDhmH6FsxDa2erMpPikt/SxAVgopgXh/
         kePR/OzazJRcy7NYIKiVq0ZpgVDTP1xoUDJqWPO64eI6859mQ7bOQbyBJ1ugVRvqeNck
         ybXXGPgAtjCcK3M5B0rdV9P+ADK+khmo7zHMhxkuQ2Fp77MhaAhxZbRtET12rtM07E52
         ixbhgq27zTpHgcZGNlvbBdyVkC5sSxn0J2bqVU/ZNhFeOPyhwZpIeArFjZC3/h2p331x
         RF/w==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20221208; t=1683051436; x=1685643436;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to;
        bh=R3bHT20tkh2F79+SFx041a+gGb7WqEwkVCZSdSx9/lw=;
        b=BtrwGqy8+TKHBEv4BA5rkYRfc0wvAKYboRvHvKZMiEdX7zofKWvVUopEcH15jMJtaI
         qZtMgv0dccwIj5oJG3DL1Fxk8d7IQuWxXtXGrQs604L0L5Hp2LkJPyODxijX9WkL8RHX
         kSlBTKMlJ4EyekRJyh2qsMK4WoKb7KmcZU0s+MCXuk446241EE3eAWCi4zxcRx0kajEW
         e4D5NH9g733Lp77wLGH5Mv4EdbrdNAVl5R69tFzfpOjKeNqzNn+V8kAL2xlKwaVynHKd
         y4ehAgXiGMLE56H/hVj4fxdiU6Z5TgAzsp3UzmomHoQhbVIAp1SukbbqmpgglepeljFM
         Xlzw==
X-Gm-Message-State: AC+VfDxY2cnTczuUwgig0FXR8RvfhtMNFCgkucuFnli/MQCVzaJo6ft7
        8VDugpLtyRbifdF0WuWnv5c=
X-Google-Smtp-Source: ACHHUZ5PfpjRwsbkRTjC3oEfUSuMXhuAYSi7RouJe4rf6mD72BqoN0/2utYW1uSDsC/8YUwsJgFW7w==
X-Received: by 2002:adf:f147:0:b0:2fd:98a8:e800 with SMTP id y7-20020adff147000000b002fd98a8e800mr13943385wro.7.1683051435620;
        Tue, 02 May 2023 11:17:15 -0700 (PDT)
Received: from localhost (host86-156-84-164.range86-156.btcentralplus.com. [86.156.84.164])
        by smtp.gmail.com with ESMTPSA id h3-20020a5d5043000000b002c70ce264bfsm31561902wrt.76.2023.05.02.11.17.14
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 02 May 2023 11:17:14 -0700 (PDT)
Date:   Tue, 2 May 2023 19:17:14 +0100
From:   Lorenzo Stoakes <lstoakes@gmail.com>
To:     David Hildenbrand <david@redhat.com>
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
Subject: Re: [PATCH v7 3/3] mm/gup: disallow FOLL_LONGTERM GUP-fast writing
 to file-backed mappings
Message-ID: <3a8c672d-4e6c-4705-9d6c-509d3733eb05@lucifer.local>
References: <cover.1683044162.git.lstoakes@gmail.com>
 <b3a4441cade9770e00d24f5ecb75c8f4481785a4.1683044162.git.lstoakes@gmail.com>
 <1691115d-dba4-636b-d736-6a20359a67c3@redhat.com>
 <20230502172231.GH1597538@hirez.programming.kicks-ass.net>
 <406fd43a-a051-5fbe-6f66-a43f5e7e7573@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <406fd43a-a051-5fbe-6f66-a43f5e7e7573@redhat.com>
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,FREEMAIL_FROM,
        RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Tue, May 02, 2023 at 07:34:06PM +0200, David Hildenbrand wrote:
> On 02.05.23 19:22, Peter Zijlstra wrote:
> > On Tue, May 02, 2023 at 07:13:49PM +0200, David Hildenbrand wrote:
> > > [...]
> > >
> > > > +{
> > > > +	struct address_space *mapping;
> > > > +
> > > > +	/*
> > > > +	 * GUP-fast disables IRQs - this prevents IPIs from causing page tables
> > > > +	 * to disappear from under us, as well as preventing RCU grace periods
> > > > +	 * from making progress (i.e. implying rcu_read_lock()).
> > > > +	 *
> > > > +	 * This means we can rely on the folio remaining stable for all
> > > > +	 * architectures, both those that set CONFIG_MMU_GATHER_RCU_TABLE_FREE
> > > > +	 * and those that do not.
> > > > +	 *
> > > > +	 * We get the added benefit that given inodes, and thus address_space,
> > > > +	 * objects are RCU freed, we can rely on the mapping remaining stable
> > > > +	 * here with no risk of a truncation or similar race.
> > > > +	 */
> > > > +	lockdep_assert_irqs_disabled();
> > > > +
> > > > +	/*
> > > > +	 * If no mapping can be found, this implies an anonymous or otherwise
> > > > +	 * non-file backed folio so in this instance we permit the pin.
> > > > +	 *
> > > > +	 * shmem and hugetlb mappings do not require dirty-tracking so we
> > > > +	 * explicitly whitelist these.
> > > > +	 *
> > > > +	 * Other non dirty-tracked folios will be picked up on the slow path.
> > > > +	 */
> > > > +	mapping = folio_mapping(folio);
> > > > +	return !mapping || shmem_mapping(mapping) || folio_test_hugetlb(folio);
> > >
> > > "Folios in the swap cache return the swap mapping" -- you might disallow
> > > pinning anonymous pages that are in the swap cache.
> > >
> > > I recall that there are corner cases where we can end up with an anon page
> > > that's mapped writable but still in the swap cache ... so you'd fallback to
> > > the GUP slow path (acceptable for these corner cases, I guess), however
> > > especially the comment is a bit misleading then.
> > >
> > > So I'd suggest not dropping the folio_test_anon() check, or open-coding it
> > > ... which will make this piece of code most certainly easier to get when
> > > staring at folio_mapping(). Or to spell it out in the comment (usually I
> > > prefer code over comments).
> >
> > So how stable is folio->mapping at this point? Can two subsequent reads
> > get different values? (eg. an actual mapping and NULL)
> >
> > If so, folio_mapping() itself seems to be missing a READ_ONCE() to avoid
> > the compiler from emitting the load multiple times.
>
> I can only talk about anon pages in this specific call order here (check
> first, then test if the PTE changed in the meantime): we don't care if we
> get two different values. If we get a different value the second time,
> surely we (temporarily) pinned an anon page that is no longer mapped (freed
> in the meantime). But in that case (even if we read garbage folio->mapping
> and made the wrong call here), we'll detect afterwards that the PTE changed,
> and unpin what we (temporarily) pinned. As folio_test_anon() only checks two
> bits in folio->mapping it's fine, because we won't dereference garbage
> folio->mapping.
>
> With folio_mapping() on !anon and READ_ONCE() ... good question. Kirill said
> it would be fairly stable, but I suspect that it could change (especially if
> we call it before validating if the PTE changed as I described further
> below).
>
> Now, if we read folio->mapping after checking if the page we pinned is still
> mapped (PTE unchanged), at least the page we pinned cannot be reused in the
> meantime. I suspect that we can still read "NULL" on the second read. But
> whatever we dereference from the first read should still be valid, even if
> the second read would have returned NULL ("rcu freeing").
>

On a specific point - if mapping turns out to be NULL after we confirm
stable PTE, I'd be inclined to reject and let the slow path take care of
it, would you agree that that's the correct approach?

I guess you could take that to mean that the page is no longer mapped so is
safe, but it feels like refusing it would be the safe course.


> --
> Thanks,
>
> David / dhildenb
>
