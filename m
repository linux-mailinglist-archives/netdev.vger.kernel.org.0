Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 0561E6F4501
	for <lists+netdev@lfdr.de>; Tue,  2 May 2023 15:30:29 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234138AbjEBNa0 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 2 May 2023 09:30:26 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:58392 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233158AbjEBNaY (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 2 May 2023 09:30:24 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [IPv6:2604:1380:4641:c500::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id D5F0310E3;
        Tue,  2 May 2023 06:30:22 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 7200D62462;
        Tue,  2 May 2023 13:30:22 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id D0848C433D2;
        Tue,  2 May 2023 13:30:21 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1683034221;
        bh=sfX70rgX6LXhrIEHuYX+oDxJVNsw5R+p+cnfXJBH4Ks=;
        h=Date:From:To:Cc:Subject:Reply-To:References:In-Reply-To:From;
        b=jyXMf9In6AHy1bmkdNltyyjI4MUbC8e1Nymm1lHaYc13hX4IbCgWT9V4SOi6ONxsF
         Ieomw9/iBjC7qecZnGCUMcS6RkJvEzMLW2GGx/Qd54Z94gH4w1HHDQh7SxF59TSnuK
         +Zj2iJxRCjsgra2wnCM1vBUC2R4dw26dZpx0OztkUYSsShRB4maw/iwZGeQQut1cBG
         ZnU1hWx+7MQW6Mdt4nzDFTjRcv0yA3sMmo1oOhm8nH9iDrs7QF1yX+clv9U1n7g5pi
         RKdMfKMJck/ZDnJUuqrF/lzSP3RN1fcvhHHrs7fPuQXKT4HRwoWX1XbTA0TsumoH6N
         J1++5bovfKEPg==
Received: by paulmck-ThinkPad-P72.home (Postfix, from userid 1000)
        id 61ED715405AD; Tue,  2 May 2023 06:30:21 -0700 (PDT)
Date:   Tue, 2 May 2023 06:30:21 -0700
From:   "Paul E. McKenney" <paulmck@kernel.org>
To:     Peter Zijlstra <peterz@infradead.org>
Cc:     Lorenzo Stoakes <lstoakes@gmail.com>, linux-mm@kvack.org,
        linux-kernel@vger.kernel.org,
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
        Theodore Ts'o <tytso@mit.edu>, Peter Xu <peterx@redhat.com>
Subject: Re: [PATCH v6 3/3] mm/gup: disallow FOLL_LONGTERM GUP-fast writing
 to file-backed mappings
Message-ID: <b00d066f-1eb7-4765-a6ff-6aacb073109d@paulmck-laptop>
Reply-To: paulmck@kernel.org
References: <cover.1682981880.git.lstoakes@gmail.com>
 <dee4f4ad6532b0f94d073da263526de334d5d7e0.1682981880.git.lstoakes@gmail.com>
 <20230502111334.GP1597476@hirez.programming.kicks-ass.net>
 <ab66d15a-acd0-4d9b-aa12-49cddd12c6a5@lucifer.local>
 <20230502120810.GD1597538@hirez.programming.kicks-ass.net>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20230502120810.GD1597538@hirez.programming.kicks-ass.net>
X-Spam-Status: No, score=-4.6 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_MED,
        SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Tue, May 02, 2023 at 02:08:10PM +0200, Peter Zijlstra wrote:
> On Tue, May 02, 2023 at 12:25:54PM +0100, Lorenzo Stoakes wrote:
> > On Tue, May 02, 2023 at 01:13:34PM +0200, Peter Zijlstra wrote:
> > > On Tue, May 02, 2023 at 12:11:49AM +0100, Lorenzo Stoakes wrote:
> > > > @@ -95,6 +96,77 @@ static inline struct folio *try_get_folio(struct page *page, int refs)
> > > >  	return folio;
> > > >  }
> > > >
> > > > +#ifdef CONFIG_MMU_GATHER_RCU_TABLE_FREE
> > > > +static bool stabilise_mapping_rcu(struct folio *folio)
> > > > +{
> > > > +	struct address_space *mapping = READ_ONCE(folio->mapping);
> > > > +
> > > > +	rcu_read_lock();
> > > > +
> > > > +	return mapping == READ_ONCE(folio->mapping);
> > >
> > > This doesn't make sense; why bother reading the same thing twice?
> > 
> > The intent is to see whether the folio->mapping has been truncated from
> > underneath us, as per the futex code that Kirill referred to which does
> > something similar [1].
> 
> Yeah, but per that 3rd load you got nothing here. Also that futex code
> did the early load to deal with the !mapping case, but you're not doing
> that.
> 
> > > Who cares if the thing changes from before; what you care about is that
> > > the value you see has stable storage, this doesn't help with that.
> > >
> > > > +}
> > > > +
> > > > +static void unlock_rcu(void)
> > > > +{
> > > > +	rcu_read_unlock();
> > > > +}
> > > > +#else
> > > > +static bool stabilise_mapping_rcu(struct folio *)
> > > > +{
> > > > +	return true;
> > > > +}
> > > > +
> > > > +static void unlock_rcu(void)
> > > > +{
> > > > +}
> > > > +#endif
> > >
> > > Anyway, this all can go away. RCU can't progress while you have
> > > interrupts disabled anyway.
> > 
> > There seems to be other code in the kernel that assumes that this is not
> > the case,
> 
> Yeah, so Paul went back on forth on that a bit. It used to be true in
> the good old days when everything was simple. Then Paul made things
> complicated by separating out sched-RCU bh-RCU and 'regular' RCU
> flavours.

Almost.  ;-)

The way I made things complicated was instead by creating preemptible RCU
for the real-time effort.  The original non-preemptible RCU was still
required for a number of use cases (for example, waiting for hardware
interrupt handlers), so it had to stay.  Separately, network-based DoS
attacks necessitated adding RCU bh.

> At that point disabling IRQs would only (officially) inhibit sched and
> bh RCU flavours, but not the regular RCU.

Quite right.

> But then some years ago Linus convinced Paul that having all these
> separate RCU flavours with separate QS rules was a big pain in the
> backside and Paul munged them all together again.

What happened was that someone used one flavor of RCU reader and a
different flavor of RCU updater, creating an exploitable bug.  

http://www2.rdrop.com/~paulmck/RCU/cve.2019.01.23e.pdf
https://www.youtube.com/watch?v=hZX1aokdNiY

And Linus asked that this bug be ruled out, so...

> So now, anything that inhibits any of the RCU flavours inhibits them
> all. So disabling IRQs is sufficient.

...for v4.20 and later, exactly.

							Thanx, Paul

> > i.e. the futex code, though not sure if that's being run with
> > IRQs disabled...
> 
> That futex code runs in preemptible context, per the lock_page() that
> can sleep etc.. :-)
> 
> > > > +/*
> > > > + * Used in the GUP-fast path to determine whether a FOLL_PIN | FOLL_LONGTERM |
> > > > + * FOLL_WRITE pin is permitted for a specific folio.
> > > > + *
> > > > + * This assumes the folio is stable and pinned.
> > > > + *
> > > > + * Writing to pinned file-backed dirty tracked folios is inherently problematic
> > > > + * (see comment describing the writeable_file_mapping_allowed() function). We
> > > > + * therefore try to avoid the most egregious case of a long-term mapping doing
> > > > + * so.
> > > > + *
> > > > + * This function cannot be as thorough as that one as the VMA is not available
> > > > + * in the fast path, so instead we whitelist known good cases.
> > > > + *
> > > > + * The folio is stable, but the mapping might not be. When truncating for
> > > > + * instance, a zap is performed which triggers TLB shootdown. IRQs are disabled
> > > > + * so we are safe from an IPI, but some architectures use an RCU lock for this
> > > > + * operation, so we acquire an RCU lock to ensure the mapping is stable.
> > > > + */
> > > > +static bool folio_longterm_write_pin_allowed(struct folio *folio)
> > > > +{
> > > > +	bool ret;
> > > > +
> > > > +	/* hugetlb mappings do not require dirty tracking. */
> > > > +	if (folio_test_hugetlb(folio))
> > > > +		return true;
> > > > +
> > >
> > > This:
> > >
> > > > +	if (stabilise_mapping_rcu(folio)) {
> > > > +		struct address_space *mapping = folio_mapping(folio);
> > >
> > > And this is 3rd read of folio->mapping, just for giggles?
> > 
> > I like to giggle :)
> > 
> > Actually this is to handle the various cases in which the mapping might not
> > be what we want (i.e. have PAGE_MAPPING_FLAGS set) which doesn't appear to
> > have a helper exposed for a check. Given previous review about duplication
> > I felt best to reuse this even though it does access again... yes I felt
> > weird about doing that.
> 
> Right, I had a peek inside folio_mapping(), but the point is that this
> 3rd load might see yet *another* value of mapping from the prior two
> loads, rendering them somewhat worthless.
> 
> > > > +
> > > > +		/*
> > > > +		 * Neither anonymous nor shmem-backed folios require
> > > > +		 * dirty tracking.
> > > > +		 */
> > > > +		ret = folio_test_anon(folio) ||
> > > > +			(mapping && shmem_mapping(mapping));
> > > > +	} else {
> > > > +		/* If the mapping is unstable, fallback to the slow path. */
> > > > +		ret = false;
> > > > +	}
> > > > +
> > > > +	unlock_rcu();
> > > > +
> > > > +	return ret;
> > >
> > > then becomes:
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
> > 
> > I'm more than happy to do this (I'd rather drop the RCU bits if possible)
> > but need to be sure it's safe.
> 
> GUP-fast as a whole relies on it :-)
