Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id D68146F22DE
	for <lists+netdev@lfdr.de>; Sat, 29 Apr 2023 06:23:09 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230367AbjD2EXE (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sat, 29 Apr 2023 00:23:04 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:54768 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231126AbjD2EXA (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sat, 29 Apr 2023 00:23:00 -0400
Received: from outgoing.mit.edu (outgoing-auth-1.mit.edu [18.9.28.11])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 036BC30C5
        for <netdev@vger.kernel.org>; Fri, 28 Apr 2023 21:22:58 -0700 (PDT)
Received: from letrec.thunk.org ([76.150.80.181])
        (authenticated bits=0)
        (User authenticated as tytso@ATHENA.MIT.EDU)
        by outgoing.mit.edu (8.14.7/8.12.4) with ESMTP id 33T4LADR028231
        (version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Sat, 29 Apr 2023 00:21:11 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=mit.edu; s=outgoing;
        t=1682742083; bh=x35IJH2Kq57CenRp9XDYUfeb7XaZg8EW3MY2fyeE+60=;
        h=Date:From:To:Cc:Subject:References:In-Reply-To;
        b=XS8yR23bvao+hUGNsieKp+k9HHEALUC5GU00GcmAg3HvyJBiEA4Pf7P/ZI4AVQ/4m
         DLsCymUXNURENk/BhLWJGBnSPN3z+hE+GUlBzE0/vn++JMO6ZbYi47/vZ6sz69dJPP
         dD4T4XIq7/aIS7FJ5s0yWFeUKKqC16QwHnalBpfk4TSzBNznHp5ekdmDaJZYJAWvEo
         aRNHWwjxwsCOYFn3dqKsxnWxYbJpYvC97hHCygeOb8wNnIIYN4XmlXjK2edXAQqOOc
         NPi52OLJIF7HFuTRa1DdZThhZTGTOzIODXOHAGl9VpSeq/INVRfHPhguvb7UhY4OSr
         wmO4iJOBFZj8g==
Received: by letrec.thunk.org (Postfix, from userid 15806)
        id A53098C01B4; Sat, 29 Apr 2023 00:21:09 -0400 (EDT)
Date:   Sat, 29 Apr 2023 00:21:09 -0400
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
Message-ID: <ZEybNZ7Rev+XM4GU@mit.edu>
References: <6b73e692c2929dc4613af711bdf92e2ec1956a66.1682638385.git.lstoakes@gmail.com>
 <afcc124e-7a9b-879c-dfdf-200426b84e24@redhat.com>
 <ZEvZtIb2EDb/WudP@nvidia.com>
 <ZEwPscQu68kx32zF@mit.edu>
 <ZEwVbPM2OPSeY21R@nvidia.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <ZEwVbPM2OPSeY21R@nvidia.com>
X-Spam-Status: No, score=-4.0 required=5.0 tests=BAYES_00,DKIM_INVALID,
        DKIM_SIGNED,RCVD_IN_DNSWL_MED,SPF_HELO_NONE,SPF_NONE,
        T_SCC_BODY_TEXT_LINE autolearn=unavailable autolearn_force=no
        version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Fri, Apr 28, 2023 at 03:50:20PM -0300, Jason Gunthorpe wrote:
> > Do we think we can still trigger a kernel crash, or maybe even some
> > more exciting like an arbitrary buffer overrun, via the
> > process_vm_writev(2) system call into a file-backed mmap'ed region?

I paged back into my memory the details, and (un)fortunately(?) it
probably can't be turned into high severity security exploit; it's
"just" a silent case of data loss.  (Which is *so* much better.... :-)

There was a reliable reproducer which was found by Syzkaller, that
didn't require any kind of exotic hardware or setup[1], and we
ultimately kluged a workaround in commit cc5095747edf ("ext4: don't
BUG if someone dirty pages without asking ext4 first").

[1] https://lore.kernel.org/all/Yg0m6IjcNmfaSokM@google.com/

Commit cc5095747edf had the (un)fortunate(?) side effect that GUP
writes to ext4 file-backed mappings no longer would cause random
low-probability crashes on large installations using RDMA, which has
apparently removed some of the motivation of really fixing the problem
instead of papering over it.  The good news is that I'm no longer
getting complaints from syzbot for this issue, and *I* don't have to
support anyone trying to use RDMA into file-backed mappings.  :-)

In any case, the file system maintainers' position (mine and I doubt
Dave Chinner's position has changed) is that if you write to
file-backed mappings via GUP/RDMA/process_vm_writev, and it causes
silent data corruption, you get to keep both pieces, and don't go
looking for us for anything other than sympathy...

						- Ted
