Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 9C4766F3F5F
	for <lists+netdev@lfdr.de>; Tue,  2 May 2023 10:41:20 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233876AbjEBIlQ (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 2 May 2023 04:41:16 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:47164 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233867AbjEBIlP (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 2 May 2023 04:41:15 -0400
Received: from casper.infradead.org (casper.infradead.org [IPv6:2001:8b0:10b:1236::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 600771BEF;
        Tue,  2 May 2023 01:41:12 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
        d=infradead.org; s=casper.20170209; h=In-Reply-To:Content-Type:MIME-Version:
        References:Message-ID:Subject:Cc:To:From:Date:Sender:Reply-To:
        Content-Transfer-Encoding:Content-ID:Content-Description;
        bh=gMkzwyLT/Xyxf8is/5S3+NSRKbTsmvleiqsCtxbzf8o=; b=lDgKY8pWgvaQIksEJVeLu2NKWR
        Jlz7kaZrEA+JA08BM+1VseVQkG441GBvgR24tACB+EBymntVCAzDbXHNJs1PdwckLuCJlKBb+QCyx
        nY3snqpW8fW+ykTn+5iqEC6yhVNvhO30scPF0Od5GxTNLIqtOuKQBQ3Y8tZ/aUANje1j7rD4QOWGm
        mK9OYMECjI/W9QFLwtxockb7D8sXqbrgXFHkY0udMrbB3iCKl2XYmFt4cVbywBY6fMcyDnepaIgTN
        /xT2sCi2HHWkHPLOoGNVEm439P3xjVSCTT4r9HimGel44cnWCXtAhsIEx24kI82KFIbVFnX4V6N7x
        aYOzgNfQ==;
Received: from j130084.upc-j.chello.nl ([24.132.130.84] helo=noisy.programming.kicks-ass.net)
        by casper.infradead.org with esmtpsa (Exim 4.94.2 #2 (Red Hat Linux))
        id 1ptlY8-00892R-Q5; Tue, 02 May 2023 08:39:52 +0000
Received: from hirez.programming.kicks-ass.net (hirez.programming.kicks-ass.net [192.168.1.225])
        (using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
         key-exchange X25519 server-signature RSA-PSS (4096 bits) server-digest SHA256)
        (Client did not present a certificate)
        by noisy.programming.kicks-ass.net (Postfix) with ESMTPS id C18EE3002BF;
        Tue,  2 May 2023 10:39:47 +0200 (CEST)
Received: by hirez.programming.kicks-ass.net (Postfix, from userid 1000)
        id 3061A23C5C347; Tue,  2 May 2023 10:39:47 +0200 (CEST)
Date:   Tue, 2 May 2023 10:39:47 +0200
From:   Peter Zijlstra <peterz@infradead.org>
To:     Jan Kara <jack@suse.cz>
Cc:     "Kirill A . Shutemov" <kirill@shutemov.name>,
        David Hildenbrand <david@redhat.com>,
        Peter Xu <peterx@redhat.com>,
        Lorenzo Stoakes <lstoakes@gmail.com>,
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
        John Hubbard <jhubbard@nvidia.com>,
        Pavel Begunkov <asml.silence@gmail.com>,
        Mika Penttila <mpenttil@redhat.com>,
        David Howells <dhowells@redhat.com>,
        Christoph Hellwig <hch@lst.de>
Subject: Re: [PATCH v5] mm/gup: disallow GUP writing to file-backed mappings
 by default
Message-ID: <20230502083947.GE1597476@hirez.programming.kicks-ass.net>
References: <6ddc7ac4-4091-632a-7b2c-df2005438ec4@redhat.com>
 <20230428160925.5medjfxkyvmzfyhq@box.shutemov.name>
 <39cc0f26-8fc2-79dd-2e84-62238d27fd98@redhat.com>
 <20230428162207.o3ejmcz7rzezpt6n@box.shutemov.name>
 <ZEv2196tk5yWvgW5@x1n>
 <173337c0-14f4-3246-15ff-7fbf03861c94@redhat.com>
 <20230428165623.pqchgi5gtfhxd5b5@box.shutemov.name>
 <1039c830-acec-d99b-b315-c2a6e26c34ca@redhat.com>
 <20230428234332.2vhprztuotlqir4x@box.shutemov.name>
 <20230502080016.4tgmqb4sy2ztfgrd@quack3>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20230502080016.4tgmqb4sy2ztfgrd@quack3>
X-Spam-Status: No, score=-4.4 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_MED,SPF_HELO_NONE,
        SPF_NONE,T_SCC_BODY_TEXT_LINE autolearn=ham autolearn_force=no
        version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Tue, May 02, 2023 at 10:00:16AM +0200, Jan Kara wrote:
> On Sat 29-04-23 02:43:32, Kirill A . Shutemov wrote:
> > I think I found relevant snippet of code that solves similar issue.
> > get_futex_key() uses RCU to stabilize page->mapping after GUP_fast:
> > 
> > 
> > 		/*
> > 		 * The associated futex object in this case is the inode and
> > 		 * the page->mapping must be traversed. Ordinarily this should
> > 		 * be stabilised under page lock but it's not strictly
> > 		 * necessary in this case as we just want to pin the inode, not
> > 		 * update the radix tree or anything like that.
> > 		 *
> > 		 * The RCU read lock is taken as the inode is finally freed
> > 		 * under RCU. If the mapping still matches expectations then the
> > 		 * mapping->host can be safely accessed as being a valid inode.
> > 		 */
> > 		rcu_read_lock();
> > 
> > 		if (READ_ONCE(page->mapping) != mapping) {
> > 			rcu_read_unlock();
> > 			put_page(page);
> > 
> > 			goto again;
> > 		}
> > 
> > 		inode = READ_ONCE(mapping->host);
> > 		if (!inode) {
> > 			rcu_read_unlock();
> > 			put_page(page);
> > 
> > 			goto again;
> > 		}
> > 
> > I think something similar can be used inside GUP_fast too.
> 
> Yeah, inodes (and thus struct address_space) is RCU protected these days so
> grabbing RCU lock in gup_fast() will get you enough protection for checking
> aops if you are careful (like the futex code is).

GUP_fast has IRQs disabled per definition, there is no need to then also
use rcu_read_lock().
