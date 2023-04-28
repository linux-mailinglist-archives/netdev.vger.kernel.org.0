Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 323016F1E02
	for <lists+netdev@lfdr.de>; Fri, 28 Apr 2023 20:28:11 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1346471AbjD1S2H (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 28 Apr 2023 14:28:07 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:53424 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1346363AbjD1S2F (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 28 Apr 2023 14:28:05 -0400
Received: from outgoing.mit.edu (outgoing-auth-1.mit.edu [18.9.28.11])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 7506FE7C
        for <netdev@vger.kernel.org>; Fri, 28 Apr 2023 11:28:04 -0700 (PDT)
Received: from letrec.thunk.org ([76.150.80.181])
        (authenticated bits=0)
        (User authenticated as tytso@ATHENA.MIT.EDU)
        by outgoing.mit.edu (8.14.7/8.12.4) with ESMTP id 33SIPsvO024394
        (version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Fri, 28 Apr 2023 14:25:55 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=mit.edu; s=outgoing;
        t=1682706363; bh=+QeRTh3Q792/eFaJgfAgGyTYF+cryOwA6A0C+nRVDy8=;
        h=Date:From:To:Cc:Subject:References:In-Reply-To;
        b=AMh5xv+jG+n9laJ4e0qLg3l6ymmeae7bAXwqrq4kE8f9OTLDZec1GN/EZ4P11VjB7
         r7tdp+zdX1OwYKlDp+K5fMVWj0mHfs68d3QH3Ak6FfD/zOf0HeAfsuD0nOiJBObAD9
         oLIceXgN8fEn9ItUp1TEodH8IuHPQm/vCmstG89u0yJfAIVgz+nUoS5GMv0EvyLAy+
         wWf7gGYeXDT2RGdrlTOO9RatuD0Rdhg4poRc4X7OvNvkL0Hjb/gtXj+quB83D9R8UX
         4Y4y0g9DMWE0P4vfvb8BkRELNhxxIwazgFHVscRWZAnwkhiC8/6hz7tspIL09c5E2/
         FI/r3M817jUPA==
Received: by letrec.thunk.org (Postfix, from userid 15806)
        id 164EF8C01E0; Fri, 28 Apr 2023 14:25:53 -0400 (EDT)
Date:   Fri, 28 Apr 2023 14:25:53 -0400
From:   "Theodore Ts'o" <tytso@mit.edu>
To:     Jason Gunthorpe <jgg@nvidia.com>
Cc:     David Hildenbrand <david@redhat.com>,
        Lorenzo Stoakes <lstoakes@gmail.com>, linux-mm@kvack.org,
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
Message-ID: <ZEwPscQu68kx32zF@mit.edu>
References: <6b73e692c2929dc4613af711bdf92e2ec1956a66.1682638385.git.lstoakes@gmail.com>
 <afcc124e-7a9b-879c-dfdf-200426b84e24@redhat.com>
 <ZEvZtIb2EDb/WudP@nvidia.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <ZEvZtIb2EDb/WudP@nvidia.com>
X-Spam-Status: No, score=-4.0 required=5.0 tests=BAYES_00,DKIM_INVALID,
        DKIM_SIGNED,RCVD_IN_DNSWL_MED,SPF_HELO_NONE,SPF_NONE,
        T_SCC_BODY_TEXT_LINE autolearn=unavailable autolearn_force=no
        version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Fri, Apr 28, 2023 at 11:35:32AM -0300, Jason Gunthorpe wrote:
> 
> It has been years now, I think we need to admit a fix is still years
> away. Blocking the security problem may even motivate more people to
> work on a fix.

Do we think we can still trigger a kernel crash, or maybe even some
more exciting like an arbitrary buffer overrun, via the
process_vm_writev(2) system call into a file-backed mmap'ed region?

Maybe if someone can come up with an easy-to-expliot security proof of
aconcept, that doesn't require special RDMA hardware or some special
libvirt setup, we could finally get motivation to get it fixed, or at
least blocked?  :-)

We've only been talking about it for years, after all...

       	       	    	      		- Ted

> Security is the primary case where we have historically closed uAPI
> items.
> 
> Jason
