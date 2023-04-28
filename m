Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 4E25B6F1B82
	for <lists+netdev@lfdr.de>; Fri, 28 Apr 2023 17:27:37 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1346418AbjD1P1b (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 28 Apr 2023 11:27:31 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:43530 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1346414AbjD1P13 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 28 Apr 2023 11:27:29 -0400
Received: from mail-wm1-x333.google.com (mail-wm1-x333.google.com [IPv6:2a00:1450:4864:20::333])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id A81715FC2;
        Fri, 28 Apr 2023 08:27:05 -0700 (PDT)
Received: by mail-wm1-x333.google.com with SMTP id 5b1f17b1804b1-3f178da21afso68702205e9.1;
        Fri, 28 Apr 2023 08:27:05 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20221208; t=1682695624; x=1685287624;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:from:to:cc:subject:date:message-id:reply-to;
        bh=O2zx0Pesg+Vyas6wuwmYRVG5JjnsY56E7pVRSXIfHE4=;
        b=cdp7XfgABc/7D5mxfnUCjUF0HKES7kslOgk0gehVyS8aZJNmbLfd8aMFSQG2SgfPE0
         f4+/JCIBoAnMs628TMkTgL6NQdon+VF2sM5oZdOR7/njJt9HEIk0BLunTR72M7ainHZA
         +begVfnI9mxJZxl960pRhjm2TgVata9tJhY1fftnl6EIw7qKoJBmLdIliklKbmJ0j2NX
         HG/xfiwoc5+S0mBpe5ho1I7xHLVq1VdsGCu789DMI2VsFh+le0wQNfATrGg94Z2FXTBV
         rDOC9YmII3SElQi2zR4vcfSaASYMS6KGlGiqEkeSaV6XbeeXWchGt5CZAygJxgqgMGks
         hHLw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20221208; t=1682695624; x=1685287624;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to;
        bh=O2zx0Pesg+Vyas6wuwmYRVG5JjnsY56E7pVRSXIfHE4=;
        b=RM6JpX1J5C7QoTR2Um0sw7W245tTEIWz2xgxfp2ufmLvFmjtlbyd/+caiO11dSD2ZT
         ke4nUPZOHTH8KnPcdqQevVrvkle6D6/sNxKpzMz5wg5m92wk+03QdoapZryAcgCtEPip
         MmTEEgs44JcINJPJcFygK/BzXpqFPJl0MFeInUqac99oi9V7ii7xBY8q1mUZd53guiHS
         noBSPCvrfVup0La/fU8k0Z+Qk+86y8hi1trYV9eTXBwCmMJUD5UZcnJZ8hzJofnNKzWL
         CHymihHFUfOGXba/Un0V451mzgBbyClQ8y/l6WlpR6+dPO5O+VySi1y/WEZ+huPZB0rZ
         CJrQ==
X-Gm-Message-State: AC+VfDwKhKURzTliV93CiMbFNuHZMkVs4SEmzFOnr8ihMIn2zSIB30Pd
        AieisdJIqRF87ZBzx5pqpp4=
X-Google-Smtp-Source: ACHHUZ4nSeV5pmY8DEQTUOIP6WqtDBNgputeVkyz0n11mhByJU3H9BsMsl6n5qNSHIJkkV7VxKIDNw==
X-Received: by 2002:a05:600c:21d8:b0:3f1:8af9:55bd with SMTP id x24-20020a05600c21d800b003f18af955bdmr4712888wmj.26.1682695623736;
        Fri, 28 Apr 2023 08:27:03 -0700 (PDT)
Received: from localhost (host86-156-84-164.range86-156.btcentralplus.com. [86.156.84.164])
        by smtp.gmail.com with ESMTPSA id gw19-20020a05600c851300b003ef5bb63f13sm18359888wmb.10.2023.04.28.08.27.02
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 28 Apr 2023 08:27:02 -0700 (PDT)
Date:   Fri, 28 Apr 2023 16:27:02 +0100
From:   Lorenzo Stoakes <lstoakes@gmail.com>
To:     Jens Axboe <axboe@kernel.dk>
Cc:     David Hildenbrand <david@redhat.com>, linux-mm@kvack.org,
        linux-kernel@vger.kernel.org,
        Andrew Morton <akpm@linux-foundation.org>,
        Jason Gunthorpe <jgg@ziepe.ca>,
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
        David Howells <dhowells@redhat.com>,
        Christoph Hellwig <hch@lst.de>
Subject: Re: [PATCH v5] mm/gup: disallow GUP writing to file-backed mappings
 by default
Message-ID: <bc672b00-edc0-44af-bc48-adf89fcb1c7f@lucifer.local>
References: <6b73e692c2929dc4613af711bdf92e2ec1956a66.1682638385.git.lstoakes@gmail.com>
 <afcc124e-7a9b-879c-dfdf-200426b84e24@redhat.com>
 <f60722d4-1474-4876-9291-5450c7192bd3@lucifer.local>
 <a8561203-a4f3-4b3d-338a-06a60541bd6b@redhat.com>
 <447d0270-9c0e-23f4-3c62-33c3eff325af@kernel.dk>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <447d0270-9c0e-23f4-3c62-33c3eff325af@kernel.dk>
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,FREEMAIL_FROM,
        RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Fri, Apr 28, 2023 at 09:15:08AM -0600, Jens Axboe wrote:
> On 4/28/23 9:13?AM, David Hildenbrand wrote:
> >>> I know, Jason und John will disagree, but I don't think we want to be very
> >>> careful with changing the default.
> >>>
> >>> Sure, we could warn, or convert individual users using a flag (io_uring).
> >>> But maybe we should invest more energy on a fix?
> >>
> >> This is proactively blocking a cleanup (eliminating vmas) that I believe
> >> will be useful in moving things forward. I am not against an opt-in option
> >> (I have been responding to community feedback in adapting my approach),
> >> which is the way I implemented it all the way back then :)
> >
> > There are alternatives: just use a flag as Jason initially suggested
> > and use that in io_uring code. Then, you can also bail out on the
> > GUP-fast path as "cannot support it right now, never do GUP-fast".
>
> Since I've seen this brougth up a few times, what's the issue on the
> io_uring side? We already dropped the special vma checking, it's in -git
> right. Hence I don't believe there are any special cases left for
> io_uring at all, and we certainly don't allow real file backings either,
> never have done.

The purpose from my perspective is being able to have GUP perform the 'is the
file-backed mapping sane to GUP' check rather than you having to open code
it. There is nothing special beyond that.

Personally I think the best solution is an opt-in FOLL_SAFE_WRITE_FILE flag or
such that you call and drop the vma check you have.

That way we don't risk breaking anything, the vmas patch series can unblock, and
you don't have to have raw mm code in your bit :)

>
> --
> Jens Axboe
>
