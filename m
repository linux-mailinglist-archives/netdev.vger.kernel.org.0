Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id BF54C6EC229
	for <lists+netdev@lfdr.de>; Sun, 23 Apr 2023 22:02:30 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229641AbjDWUCZ (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sun, 23 Apr 2023 16:02:25 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:42576 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229473AbjDWUCY (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sun, 23 Apr 2023 16:02:24 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [IPv6:2604:1380:4641:c500::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 8C098E63;
        Sun, 23 Apr 2023 13:02:23 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 28D4D60F77;
        Sun, 23 Apr 2023 20:02:23 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id CD654C433D2;
        Sun, 23 Apr 2023 20:02:13 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1682280142;
        bh=MXq/43kCze2RO9lP4ptWyt16cAC97gbSKdjUyiZkGe0=;
        h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
        b=TeydC14vXjAcezSvOpLJ6lAgoD7kv4M6u2qpkMik63uNVRdyPydMRXOgOZl8horI+
         dPMUTeoPcKNY3usBHvTn9wt3MN+OugsRnGr0IsC1oFmhWdpfSaV1Z2ZOlTUucNyFnI
         Dc7xJ3MsVgfv/9IzUKl8JIOxIGjmFLwo53Sw9q11W9QUhGzAN8aJtxFQ6cy32G+/6J
         sPWBqLbzeBzmMfJt637Yg3UjirQwtj3SDotLldKjhF9Q47+El15XA9ePt5cvIKvHTl
         ZLtLr/8hQ5GEStE0bg3XDleDq07tryjP50bYayKFt8JtmZOdkh1eS+Qu0bUY77irUf
         0LMKZJajGU/pQ==
Date:   Sun, 23 Apr 2023 22:02:11 +0200
From:   Simon Horman <horms@kernel.org>
To:     Lorenzo Stoakes <lstoakes@gmail.com>
Cc:     Simon Horman <simon.horman@corigine.com>, linux-mm@kvack.org,
        linux-kernel@vger.kernel.org,
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
        netdev@vger.kernel.org, bpf@vger.kernel.org
Subject: Re: [PATCH] mm/gup: disallow GUP writing to file-backed mappings by
 default
Message-ID: <ZEWOwz/82AKHGrXW@kernel.org>
References: <f86dc089b460c80805e321747b0898fd1efe93d7.1682168199.git.lstoakes@gmail.com>
 <ZEWHsbxhQlrSqnSC@corigine.com>
 <a6ceb82a-1766-4229-ba33-b6f25e111561@lucifer.local>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <a6ceb82a-1766-4229-ba33-b6f25e111561@lucifer.local>
X-Spam-Status: No, score=-4.6 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_MED,
        SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Sun, Apr 23, 2023 at 08:40:53PM +0100, Lorenzo Stoakes wrote:
> On Sun, Apr 23, 2023 at 09:32:01PM +0200, Simon Horman wrote:
> > On Sat, Apr 22, 2023 at 02:37:05PM +0100, Lorenzo Stoakes wrote:
> > > It isn't safe to write to file-backed mappings as GUP does not ensure that
> > > the semantics associated with such a write are performed correctly, for
> > > instance filesystems which rely upon write-notify will not be correctly
> > > notified.
> > >
> > > There are exceptions to this - shmem and hugetlb mappings are (in effect)
> > > anonymous mappings by other names so we do permit this operation in these
> > > cases.
> > >
> > > In addition, if no pinning takes place (neither FOLL_GET nor FOLL_PIN is
> > > specified and neither flags gets implicitly set) then no writing can occur
> > > so we do not perform the check in this instance.
> > >
> > > This is an important exception, as populate_vma_page_range() invokes
> > > __get_user_pages() in this way (and thus so does __mm_populate(), used by
> > > MAP_POPULATE mmap() and mlock() invocations).
> > >
> > > There are GUP users within the kernel that do nevertheless rely upon this
> > > behaviour, so we introduce the FOLL_ALLOW_BROKEN_FILE_MAPPING flag to
> > > explicitly permit this kind of GUP access.
> > >
> > > This is required in order to not break userspace in instances where the
> > > uAPI might permit file-mapped addresses - a number of RDMA users require
> > > this for instance, as do the process_vm_[read/write]v() system calls,
> > > /proc/$pid/mem, ptrace and SDT uprobes. Each of these callers have been
> > > updated to use this flag.
> > >
> > > Making this change is an important step towards a more reliable GUP, and
> > > explicitly indicates which callers might encouter issues moving forward.
> >
> > nit: s/encouter/encounter/
> >
> 
> Ack, I always seem to leave at least one or two easter egg spelling
> mistakes in :)

:)

> Will fix up on next respin (in unlikely event of no further review,
> hopefully Andrew would pick up!)
> 
