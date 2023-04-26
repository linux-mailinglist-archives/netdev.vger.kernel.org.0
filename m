Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id A6C226EF062
	for <lists+netdev@lfdr.de>; Wed, 26 Apr 2023 10:42:04 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S239919AbjDZIl7 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 26 Apr 2023 04:41:59 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:53040 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S239464AbjDZIl5 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 26 Apr 2023 04:41:57 -0400
Received: from mail-wm1-x32b.google.com (mail-wm1-x32b.google.com [IPv6:2a00:1450:4864:20::32b])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 576793C1F;
        Wed, 26 Apr 2023 01:41:55 -0700 (PDT)
Received: by mail-wm1-x32b.google.com with SMTP id 5b1f17b1804b1-3f1cfed93e2so40348445e9.3;
        Wed, 26 Apr 2023 01:41:55 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20221208; t=1682498514; x=1685090514;
        h=in-reply-to:content-transfer-encoding:content-disposition
         :mime-version:references:message-id:subject:cc:to:from:date:from:to
         :cc:subject:date:message-id:reply-to;
        bh=ArnfC+A36KVaoJFRoRkLOWAFxiyb01QcwAzoyNZQfrk=;
        b=n9wa3FOCIYkEV0LwxjD7q+MJsqrZ/xLRGpZrfpm1L41Qr0+7o4/6/ZYD3BlbEcftEO
         TWzgVeMf+XcQ9HsFH1vuDYssuU38PJbkjpIsGzwFEbwFCxKe2ZxojqC72bKxomHDmIz1
         ay801JAtzkZglQqSXez+EB2JvaC/I7cUlvzIIvgZSWJZs9weW1ABvcyD5u63Q7mIkki6
         NRPaCiSqUjxrZoe54A9PXGWESh3VCD77XzFDvAwQdpuwjTppXlqu1YvSuLi/m5BtM6YY
         xlJl3a4CxRtLkhLlWSNRXKvWu1vgt+ugy9vY0Wy2ASvgNice9SZVxwotBJabFXuk4qjl
         bI5w==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20221208; t=1682498514; x=1685090514;
        h=in-reply-to:content-transfer-encoding:content-disposition
         :mime-version:references:message-id:subject:cc:to:from:date
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=ArnfC+A36KVaoJFRoRkLOWAFxiyb01QcwAzoyNZQfrk=;
        b=YDzQ8taQ/HxY7KP1222ajKQ7hRqmvKGiNq7SgPDaDenvfQJaCD+Qmz66aBifskidli
         AN0kwt3Cg7w5o9W2cPWz8yWHIw3GMga9ILzgn12jXlXRBHCu4qxUPUpUWGZkkxfCTFPw
         kMmMX1kWqI5HWgsWVC7QHWPZIelnqikxiqSQJduHOumrZJD3geoS0Q1YLIjGUYJizJSr
         9YOqiK/RHCL69TCdIDcTg3hnxruSAqsQLctuC3bwbgfT6WQP5WQv5lpT/GCmXy+wZEn6
         Ff7eIX5JRWfi3MJioiYhpDNcYpS8afRkIcjHyLqOmqcnK0ee7RqzfcfB7cKpmq88Kquc
         XqEQ==
X-Gm-Message-State: AAQBX9cmd5cVsly/BEnpoynABUkHpVkJvfMep395e1KzyHVGT4/kVInq
        9GLhVonkrFh3cHEa3TLGcYw=
X-Google-Smtp-Source: AKy350Z5NR02Z8oNrVzXCbdERtnNyDO/QN/D6Phr2ymfd0ldQFATBh9gLJnkGVzoLJVNHjNxs5dl8A==
X-Received: by 2002:a05:600c:2201:b0:3f1:806d:33ad with SMTP id z1-20020a05600c220100b003f1806d33admr11101118wml.6.1682498513622;
        Wed, 26 Apr 2023 01:41:53 -0700 (PDT)
Received: from localhost (ip-185-104-136-48.ptr.icomera.net. [185.104.136.48])
        by smtp.gmail.com with ESMTPSA id t13-20020a7bc3cd000000b003f173c566b5sm17344264wmj.5.2023.04.26.01.41.52
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 26 Apr 2023 01:41:52 -0700 (PDT)
Date:   Wed, 26 Apr 2023 09:41:51 +0100
From:   Lorenzo Stoakes <lstoakes@gmail.com>
To:     Mika =?iso-8859-1?Q?Penttil=E4?= <mpenttil@redhat.com>
Cc:     linux-mm@kvack.org, linux-kernel@vger.kernel.org,
        Andrew Morton <akpm@linux-foundation.org>,
        Jason Gunthorpe <jgg@ziepe.ca>, Jens Axboe <axboe@kernel.dk>,
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
        David Hildenbrand <david@redhat.com>
Subject: Re: [PATCH v4] mm/gup: disallow GUP writing to file-backed mappings
 by default
Message-ID: <ZEjjz_zqynWj0Kcc@murray>
References: <3b92d56f55671a0389252379237703df6e86ea48.1682464032.git.lstoakes@gmail.com>
 <a68fa8f2-8619-63ff-3525-ede7ed1f0a9f@redhat.com>
 <5ffd7f32-d236-4da4-93f7-c2fe39a6e035@lucifer.local>
 <aa0d9a98-7dd1-0188-d382-5835cf1ddf3a@redhat.com>
 <b7f8daba-1250-4a45-895e-cbb20cc6c2dd@lucifer.local>
 <831f0d02-7671-97bf-a968-e2e5bf92dfd7@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <831f0d02-7671-97bf-a968-e2e5bf92dfd7@redhat.com>
X-Spam-Status: No, score=1.2 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,FREEMAIL_FROM,
        RCVD_IN_DNSWL_NONE,RCVD_IN_SBL_CSS,SPF_HELO_NONE,SPF_PASS,
        T_SCC_BODY_TEXT_LINE autolearn=no autolearn_force=no version=3.4.6
X-Spam-Level: *
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Wed, Apr 26, 2023 at 10:30:03AM +0300, Mika Penttilä wrote:

[snip]

> > The issue is how dirtying works. Typically for a dirty-tracking mapping the
> > kernel makes the mapping read-only, then when a write fault occurs,
> > writenotify is called and the folio is marked dirty. This way the file
> > system knows which files to writeback, then after writeback it 'cleans'
> > them, restoring the read-only mapping and relying on the NEXT write marking
> > write notifying and marking the folio dirty again.
> >
>
> I know how the dirty tracking works :). And gup itself actually triggers the
> _first_ fault on a read only pte.

I'm sure you don't mean to, but this comes off as sarcastic, 'I know how X
works :)' is not a helpful comment. However, equally apologies if I seemed
patronising, not intentional, I am just trying to be as clear as possible,
which always risks sounding that way :)

Regardless, this is a very good point! I think I was a little too implicit
in the whole 'at any time the kernel chooses to write to this writenotify
won't happen', and you are absolutely right in that we are not clear enough
about that.

>
> So the problem is accessing the page after that, somewehere in future. I
> think this is something you should write on the description. Because,
> technically, GUP itself works and does invoke the write notify. So the
> misleading part is you say in the description it doesn't. While you mean a
> later write, from a driver or such, doesn't.
>

Ack, agreed this would be a useful improvement. Will fix on next spin!

[snip]
