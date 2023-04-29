Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 97B306F2721
	for <lists+netdev@lfdr.de>; Sun, 30 Apr 2023 01:09:48 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231218AbjD2XJo (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sat, 29 Apr 2023 19:09:44 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:43086 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231192AbjD2XJm (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sat, 29 Apr 2023 19:09:42 -0400
Received: from mail-wm1-x333.google.com (mail-wm1-x333.google.com [IPv6:2a00:1450:4864:20::333])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 7EDED1BEE;
        Sat, 29 Apr 2023 16:09:39 -0700 (PDT)
Received: by mail-wm1-x333.google.com with SMTP id 5b1f17b1804b1-3f178da21afso6427875e9.1;
        Sat, 29 Apr 2023 16:09:39 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20221208; t=1682809778; x=1685401778;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:from:to:cc:subject:date:message-id:reply-to;
        bh=F3yt7UWon4YwEktTTztF8j+ALULlII1l8bpdeotbMIE=;
        b=aM/o79DZGGXZspHFc4p8GMX+nu7QMX99JKJhhxXKo61f3MrWXsOdN707iEKFkIbMGC
         OKY3gvOkEMlcn+HYHQi9nyd3DteDCKvE1BXdeXWWP2BMENxGQzfIcISgJ1PVhjAeUtOu
         yrGdS4iHcNOSgiAQFjChwtBWIbLtqlzdii4S//Zh5uO8z4bwuFNTn1rkKGIpyjRkO+4O
         KdJq7iyPkR3CooD9QB/2GcD7Gwn3CiLoCbiRUjNeeQtVRSFFdX4msVJOkeGGklmB3025
         t1QM4nVsGcB9gDv93CD5m68kkPhTWhLTLqYJ1WKWu80HVJEAIPwlxwycB2mQcsWFnwAe
         6pMg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20221208; t=1682809778; x=1685401778;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to;
        bh=F3yt7UWon4YwEktTTztF8j+ALULlII1l8bpdeotbMIE=;
        b=kUbaK++bh2zbixwklASaZNhuQ2jUVYg9cLRhwnSeftqyihw7+2y1yMLP+SBtFlu8tB
         tscO4MtTtOvCM/KOPerE/cT1uPAqD7nFyy4lQDUUd+dp63aHMcCUPsyyBc/Ru7yX/ZBi
         3NroEXvTXivdrGh175ziuyG+w5Uv9rpSIj4OfIhcljR+B5qho7wzc8B8YLsY0wMPX4dh
         P8Q14ZQkNc40+r0JpAVloEF/uQisog9Uwl76d8hpgfqfOJfZi8TUZ9/jf+80fhMt4sp+
         k/deGhGBYjJkQsu8EHhkk+wvfj/5j2i9LK6Tl7eq7ZPYGVJSpeJDRpGzCFaPTi8KOE1B
         ru3g==
X-Gm-Message-State: AC+VfDxJWKqsrTAJwJKhgXotdMRHnPVbi/hiUKxxs6I+m2d+7zExFywb
        aMKkLKBNvED0forN9dqUJOFhyXePRhzSRw==
X-Google-Smtp-Source: ACHHUZ7Z4WHld4Risglrn3ZR0XC+6byvRHKMG+s3r0djAjM2ZZ1g4RneczYz1ypDalKVc6ebQ+bOjg==
X-Received: by 2002:a7b:c4c2:0:b0:3f1:9a5a:b444 with SMTP id g2-20020a7bc4c2000000b003f19a5ab444mr7334384wmk.15.1682809777551;
        Sat, 29 Apr 2023 16:09:37 -0700 (PDT)
Received: from localhost ([2a00:23c5:dc8c:8701:1663:9a35:5a7b:1d76])
        by smtp.gmail.com with ESMTPSA id k36-20020a05600c1ca400b003f1733feb3dsm32301239wms.0.2023.04.29.16.09.36
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Sat, 29 Apr 2023 16:09:36 -0700 (PDT)
Date:   Sun, 30 Apr 2023 00:09:35 +0100
From:   Lorenzo Stoakes <lstoakes@gmail.com>
To:     Jason Gunthorpe <jgg@nvidia.com>
Cc:     Theodore Ts'o <tytso@mit.edu>,
        David Hildenbrand <david@redhat.com>, linux-mm@kvack.org,
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
Message-ID: <08ff7961-7e86-40b3-8e25-1592526c94d4@lucifer.local>
References: <6b73e692c2929dc4613af711bdf92e2ec1956a66.1682638385.git.lstoakes@gmail.com>
 <afcc124e-7a9b-879c-dfdf-200426b84e24@redhat.com>
 <ZEvZtIb2EDb/WudP@nvidia.com>
 <ZEwPscQu68kx32zF@mit.edu>
 <ZEwVbPM2OPSeY21R@nvidia.com>
 <ZEybNZ7Rev+XM4GU@mit.edu>
 <ZE2ht9AGx321j0+s@nvidia.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <ZE2ht9AGx321j0+s@nvidia.com>
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,FREEMAIL_FROM,
        RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Sat, Apr 29, 2023 at 08:01:11PM -0300, Jason Gunthorpe wrote:
> On Sat, Apr 29, 2023 at 12:21:09AM -0400, Theodore Ts'o wrote:
>
> > In any case, the file system maintainers' position (mine and I doubt
> > Dave Chinner's position has changed) is that if you write to
> > file-backed mappings via GUP/RDMA/process_vm_writev, and it causes
> > silent data corruption, you get to keep both pieces, and don't go
> > looking for us for anything other than sympathy...
>
> This alone is enough reason to block it. I'm tired of this round and
> round and I think we should just say enough, the mm will work to
> enforce this view point. Files can only be written through PTEs.
>
> If this upsets people they can work on fixing it, but at least we
> don't have these kernel problems and inconsistencies to deal with.
>

Indeed, I think there is a broad consensus that FOLL_LONGTERM is such an
egregious case that this is the way forward.

I will respin with the discussed GUP-fast changes relatively soon and then
we can see where that takes us :)

> Jason
