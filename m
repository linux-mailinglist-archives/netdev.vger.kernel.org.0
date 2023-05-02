Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id E4D466F4403
	for <lists+netdev@lfdr.de>; Tue,  2 May 2023 14:42:12 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234099AbjEBMmJ (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 2 May 2023 08:42:09 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:57486 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229533AbjEBMmI (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 2 May 2023 08:42:08 -0400
Received: from desiato.infradead.org (desiato.infradead.org [IPv6:2001:8b0:10b:1:d65d:64ff:fe57:4e05])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 30B8659CF;
        Tue,  2 May 2023 05:42:06 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
        d=infradead.org; s=desiato.20200630; h=In-Reply-To:Content-Type:MIME-Version:
        References:Message-ID:Subject:Cc:To:From:Date:Sender:Reply-To:
        Content-Transfer-Encoding:Content-ID:Content-Description;
        bh=fgFCgKRt+dSv63SBQS0EqzIPjjsNgS5iABtgfP8KMvY=; b=Aptl0C9YZtVHhIGcqwN9psA40r
        S+G1CNNeqHBhJQCPyxq8JTFXrIC20oKv3sunDSOsd9zMFsFzTHjtJ4CsBZ6fPZJ9Fw97dzhOQkR6+
        sA6Qpx8UwumRQzMSrCbASWhI8qrfpguY0OMXsvQ70o9rTcpsAPZZjvbqrSSxvzgJPR1S4D4W0npH3
        w4nNuBkWL7Q9i/HqJgT5Z3cz+f2PzWKV7TdovHV7w5pdECflKTwy6Al+2ErY/vOjCg3YGmjyh4os3
        kpxblnvQPN/ZGuQQycvMxD3KXzI5YbnQ1+FGHmUmlZl+0aypr5sF9KDduv3PIftxymNZ2vLshSC+K
        /6KVXkHQ==;
Received: from j130084.upc-j.chello.nl ([24.132.130.84] helo=noisy.programming.kicks-ass.net)
        by desiato.infradead.org with esmtpsa (Exim 4.96 #2 (Red Hat Linux))
        id 1ptpJW-00GJ5B-34;
        Tue, 02 May 2023 12:41:04 +0000
Received: from hirez.programming.kicks-ass.net (hirez.programming.kicks-ass.net [192.168.1.225])
        (using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
         key-exchange X25519 server-signature RSA-PSS (4096 bits))
        (Client did not present a certificate)
        by noisy.programming.kicks-ass.net (Postfix) with ESMTPS id 00898300237;
        Tue,  2 May 2023 14:40:58 +0200 (CEST)
Received: by hirez.programming.kicks-ass.net (Postfix, from userid 1000)
        id BB0FB23C5C34C; Tue,  2 May 2023 14:40:58 +0200 (CEST)
Date:   Tue, 2 May 2023 14:40:58 +0200
From:   Peter Zijlstra <peterz@infradead.org>
To:     Lorenzo Stoakes <lstoakes@gmail.com>
Cc:     linux-mm@kvack.org, linux-kernel@vger.kernel.org,
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
        David Hildenbrand <david@redhat.com>,
        Dave Chinner <david@fromorbit.com>,
        Theodore Ts'o <tytso@mit.edu>, Peter Xu <peterx@redhat.com>,
        Paul McKenney <paulmck@kernel.org>
Subject: Re: [PATCH v6 3/3] mm/gup: disallow FOLL_LONGTERM GUP-fast writing
 to file-backed mappings
Message-ID: <20230502124058.GB1597602@hirez.programming.kicks-ass.net>
References: <cover.1682981880.git.lstoakes@gmail.com>
 <dee4f4ad6532b0f94d073da263526de334d5d7e0.1682981880.git.lstoakes@gmail.com>
 <20230502111334.GP1597476@hirez.programming.kicks-ass.net>
 <ab66d15a-acd0-4d9b-aa12-49cddd12c6a5@lucifer.local>
 <20230502120810.GD1597538@hirez.programming.kicks-ass.net>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20230502120810.GD1597538@hirez.programming.kicks-ass.net>
X-Spam-Status: No, score=-4.4 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_MED,SPF_HELO_NONE,
        SPF_NONE,T_SCC_BODY_TEXT_LINE autolearn=ham autolearn_force=no
        version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Tue, May 02, 2023 at 02:08:10PM +0200, Peter Zijlstra wrote:

> > >
> > >
> > > 	if (folio_test_anon(folio))
> > > 		return true;
> > 
> > This relies on the mapping so belongs below the lockdep assert imo.
> 
> Oh, right you are.
> 
> > >
> > > 	/*
> > > 	 * Having IRQs disabled (as per GUP-fast) also inhibits RCU
> > > 	 * grace periods from making progress, IOW. they imply
> > > 	 * rcu_read_lock().
> > > 	 */
> > > 	lockdep_assert_irqs_disabled();
> > >
> > > 	/*
> > > 	 * Inodes and thus address_space are RCU freed and thus safe to
> > > 	 * access at this point.
> > > 	 */
> > > 	mapping = folio_mapping(folio);
> > > 	if (mapping && shmem_mapping(mapping))
> > > 		return true;
> > >
> > > 	return false;
> > >
> > > > +}

So arguably you should do *one* READ_ONCE() load of mapping and
consistently use that, this means open-coding both folio_test_anon() and
folio_mapping().

