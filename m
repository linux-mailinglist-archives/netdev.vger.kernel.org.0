Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 6922A6ECC24
	for <lists+netdev@lfdr.de>; Mon, 24 Apr 2023 14:38:56 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231681AbjDXMiw (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 24 Apr 2023 08:38:52 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:41720 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229696AbjDXMiv (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 24 Apr 2023 08:38:51 -0400
Received: from bombadil.infradead.org (bombadil.infradead.org [IPv6:2607:7c80:54:3::133])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 8E7D42D48;
        Mon, 24 Apr 2023 05:38:50 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
        d=infradead.org; s=bombadil.20210309; h=In-Reply-To:Content-Type:MIME-Version
        :References:Message-ID:Subject:Cc:To:From:Date:Sender:Reply-To:
        Content-Transfer-Encoding:Content-ID:Content-Description;
        bh=5OALIrDldLQfwHP9p2ndyFBK2lC4EsP1Af7zzRq70HI=; b=oxHS7/offNNywVCnbgn859E+Z8
        SYCfU4xYyhNEUEds393rO5wINqj82AoYAyZTELk7z80VjU8UPitXrHw03lV+WplVb4yALgivN41pN
        3aAEc5YC9KzREtP9upgcMYQc0N1KKAPLZ+z7FvfV1ViOfdWkXk1T7ngxz+2iNiYxm3PlS21Uq1hoM
        TtTu0HzL22OV0k6O9ljV5DFyhahABI4iimBMUVndpCMvOixeI4d5PXXRr7csMwBevz9x4TWq6CjF7
        5Alb3RSlH+Df1e2w7PqY2OImD79V0gvwKqS0t9scRcDw3V5AaSCNlNNQmQoVgNsajPeCH4lVvFWrB
        HpqlZJjQ==;
Received: from hch by bombadil.infradead.org with local (Exim 4.96 #2 (Red Hat Linux))
        id 1pqvSu-00GKZp-1o;
        Mon, 24 Apr 2023 12:38:44 +0000
Date:   Mon, 24 Apr 2023 05:38:44 -0700
From:   Christoph Hellwig <hch@infradead.org>
To:     Jason Gunthorpe <jgg@nvidia.com>
Cc:     Lorenzo Stoakes <lstoakes@gmail.com>,
        Christoph Hellwig <hch@infradead.org>, linux-mm@kvack.org,
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
        Oleg Nesterov <oleg@redhat.com>, Jan Kara <jack@suse.cz>,
        Chris Mason <clm@fb.com>, John Hubbard <jhubbard@nvidia.com>
Subject: Re: [PATCH v2] mm/gup: disallow GUP writing to file-backed mappings
 by default
Message-ID: <ZEZ4VCyfRNCZOO8/@infradead.org>
References: <c8ee7e02d3d4f50bb3e40855c53bda39eec85b7d.1682321768.git.lstoakes@gmail.com>
 <ZEZPXHN4OXIYhP+V@infradead.org>
 <90a54439-5d30-4711-8a86-eba816782a66@lucifer.local>
 <ZEZ117OMCi0dFXqY@nvidia.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <ZEZ117OMCi0dFXqY@nvidia.com>
X-SRS-Rewrite: SMTP reverse-path rewritten from <hch@infradead.org> by bombadil.infradead.org. See http://www.infradead.org/rpr.html
X-Spam-Status: No, score=-4.4 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_MED,SPF_HELO_NONE,
        SPF_NONE,T_SCC_BODY_TEXT_LINE autolearn=ham autolearn_force=no
        version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Mon, Apr 24, 2023 at 09:28:07AM -0300, Jason Gunthorpe wrote:
> On Mon, Apr 24, 2023 at 11:17:55AM +0100, Lorenzo Stoakes wrote:
> > On Mon, Apr 24, 2023 at 02:43:56AM -0700, Christoph Hellwig wrote:
> > > I'm pretty sure DIRECT I/O reads that write into file backed mappings
> > > are out there in the wild.
> 
> I wonder if that is really the case? I know people tried this with
> RDMA and it didn't get very far before testing uncovered data
> corruption and kernel crashes.. Maybe O_DIRECT has a much smaller race
> window so people can get away with it?

It absolutely causes all kinds of issues even with O_DIRECT.  I'd be
all for trying to disallow it as it simplies a lot of things, but I fear
it's not going to stick.

> So, my suggestion was to mark the places where we want to allow this,
> eg O_DIRECT, and block everwhere else. Lorenzo, I would significantly
> par back the list you have.

I think an opt-in is a good idea no matter how many places end up
needing it.  I'd prefer a less dramatic name and a better explanation
on why it should only be set when needed.

> I also suggest we force block it at some kernel lockdown level..
> 
> Alternatively, perhaps we abuse FOLL_LONGTERM and prevent it from
> working with filebacked pages since, I think, the ease of triggering a
> bug goes up the longer the pages are pinned.

FOLL_LONGTERM on file backed pages is a nightmare.  If you think you
can get away with prohibiting it for RDMA, and KVM doesn't need it
I'd be all for not allowing that at all.
