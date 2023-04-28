Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 4FA5D6F1C15
	for <lists+netdev@lfdr.de>; Fri, 28 Apr 2023 17:58:20 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1345959AbjD1P6R (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 28 Apr 2023 11:58:17 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:33830 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1346039AbjD1P6P (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 28 Apr 2023 11:58:15 -0400
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.129.124])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 77A8A2D67
        for <netdev@vger.kernel.org>; Fri, 28 Apr 2023 08:57:31 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1682697450;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         in-reply-to:in-reply-to:references:references;
        bh=zf2i3kVXtlVgFFMbGoUpKI0IDlebsU5o6nl1WehrK4Y=;
        b=PZtBlTha/gN4jgySxCGZgZ1dWz9FLKxKy6g+Mr9gzznS1IgKL49h9r77n1hlf/E7UA2v1f
        CfAFZ85tN1g9d6D+uQtjLl8xm5oR5w12CFo7NdKn+7zUIxPqOpqAsF8okUZOV7ZGDYI9cp
        tJfs+EjpAYrP0CZ5QCP3+nWUbhFBBLU=
Received: from mail-qk1-f197.google.com (mail-qk1-f197.google.com
 [209.85.222.197]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.3, cipher=TLS_AES_256_GCM_SHA384) id
 us-mta-271-U71gL_fsOBqUM9xrAY7NFQ-1; Fri, 28 Apr 2023 11:57:04 -0400
X-MC-Unique: U71gL_fsOBqUM9xrAY7NFQ-1
Received: by mail-qk1-f197.google.com with SMTP id af79cd13be357-7514dd96de3so1781185a.1
        for <netdev@vger.kernel.org>; Fri, 28 Apr 2023 08:57:00 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20221208; t=1682697420; x=1685289420;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to;
        bh=zf2i3kVXtlVgFFMbGoUpKI0IDlebsU5o6nl1WehrK4Y=;
        b=DIUQKA+F6e8BZb/kHeEJL5ojbjs3RxJ3iiCNSZfO8Wt5NyRcSphhymvxPYjohORoFS
         6FHMeBmTkuJYu0nF7x6z2RT8cDLs+8QfqgebgfIb4zgTqUCtlOQYTF+klB20WrDUTvIa
         6tudc/Q6ncZjXUTS2pqA9h2yshJJTTdUlh6frR4y70OF/wITlWZVqqT0q3hjASHrUZKu
         yfjbLwygkOg1YVEGO476wj5R6Y+rUWpFSk31HaATcGbtNKpn9vza/r0qaWPjmUpNDEVd
         UeTNVndG4A9BFVaTpenGeslsMsHbnD15LI1Fdpj1BPKrXlRxGoxij5dVr2istbNd786c
         cI9A==
X-Gm-Message-State: AC+VfDwFJrH31CSsfiEC6F1tmO/mca9NVKV6nYlzqCrfD9j5DyaCwNQw
        ZKU3xf6KKzaTON6RBRnKEnWDsuCf789JdqnujGA10epjYI9uSQacMsmBm9anzjFpB8qrGZtQ2AK
        fsu36v47bKoYtRu2n
X-Received: by 2002:a05:622a:1047:b0:3f0:a887:7d2c with SMTP id f7-20020a05622a104700b003f0a8877d2cmr5184817qte.6.1682697419790;
        Fri, 28 Apr 2023 08:56:59 -0700 (PDT)
X-Google-Smtp-Source: ACHHUZ5Ehg//He+hcp0mx8gVUNQ8HJe0s0NcsM4chiANUARw7z3NEuycfTLFrEHAF1k8Z5nqwT+zkQ==
X-Received: by 2002:a05:622a:1047:b0:3f0:a887:7d2c with SMTP id f7-20020a05622a104700b003f0a8877d2cmr5184790qte.6.1682697419513;
        Fri, 28 Apr 2023 08:56:59 -0700 (PDT)
Received: from x1n (bras-base-aurron9127w-grc-40-70-52-229-124.dsl.bell.ca. [70.52.229.124])
        by smtp.gmail.com with ESMTPSA id o16-20020ac872d0000000b003ef5ba0702fsm6392726qtp.7.2023.04.28.08.56.56
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 28 Apr 2023 08:56:58 -0700 (PDT)
Date:   Fri, 28 Apr 2023 11:56:55 -0400
From:   Peter Xu <peterx@redhat.com>
To:     David Hildenbrand <david@redhat.com>
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
Subject: Re: [PATCH v5] mm/gup: disallow GUP writing to file-backed mappings
 by default
Message-ID: <ZEvsx998gDFig/zq@x1n>
References: <6b73e692c2929dc4613af711bdf92e2ec1956a66.1682638385.git.lstoakes@gmail.com>
 <afcc124e-7a9b-879c-dfdf-200426b84e24@redhat.com>
 <ZEvZtIb2EDb/WudP@nvidia.com>
 <094d2074-5b69-5d61-07f7-9f962014fa68@redhat.com>
 <400da248-a14e-46a4-420a-a3e075291085@redhat.com>
 <077c4b21-8806-455f-be98-d7052a584259@lucifer.local>
 <62ec50da-5f73-559c-c4b3-bde4eb215e08@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
In-Reply-To: <62ec50da-5f73-559c-c4b3-bde4eb215e08@redhat.com>
X-Spam-Status: No, score=-2.3 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_NONE,
        RCVD_IN_MSPIKE_H2,SPF_HELO_NONE,SPF_NONE,T_SCC_BODY_TEXT_LINE
        autolearn=unavailable autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Fri, Apr 28, 2023 at 05:34:35PM +0200, David Hildenbrand wrote:
> On 28.04.23 17:33, Lorenzo Stoakes wrote:
> > On Fri, Apr 28, 2023 at 05:23:29PM +0200, David Hildenbrand wrote:
> > > > > 
> > > > > Security is the primary case where we have historically closed uAPI
> > > > > items.
> > > > 
> > > > As this patch
> > > > 
> > > > 1) Does not tackle GUP-fast
> > > > 2) Does not take care of !FOLL_LONGTERM
> > > > 
> > > > I am not convinced by the security argument in regard to this patch.
> > > > 
> > > > 
> > > > If we want to sells this as a security thing, we have to block it
> > > > *completely* and then CC stable.
> > > 
> > > Regarding GUP-fast, to fix the issue there as well, I guess we could do
> > > something similar as I did in gup_must_unshare():
> > > 
> > > If we're in GUP-fast (no VMA), and want to pin a !anon page writable,
> > > fallback to ordinary GUP. IOW, if we don't know, better be safe.
> > 
> > How do we determine it's non-anon in the first place? The check is on the
> > VMA. We could do it by following page tables down to folio and checking
> > folio->mapping for PAGE_MAPPING_ANON I suppose?
> 
> PageAnon(page) can be called from GUP-fast after grabbing a reference. See
> gup_must_unshare().

Hmm.. Is it a good idea at all to sacrifise all "!anon" fast-gups for this?
People will silently got degrade even on legal pins on shmem/hugetlb, I
think, which seems to be still a very major use case.

-- 
Peter Xu

