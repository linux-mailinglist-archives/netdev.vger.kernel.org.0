Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id CAD516F42A6
	for <lists+netdev@lfdr.de>; Tue,  2 May 2023 13:24:01 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233711AbjEBLX7 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 2 May 2023 07:23:59 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:37338 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233548AbjEBLX6 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 2 May 2023 07:23:58 -0400
Received: from smtp-out1.suse.de (smtp-out1.suse.de [195.135.220.28])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 259801FDB;
        Tue,  2 May 2023 04:23:57 -0700 (PDT)
Received: from imap2.suse-dmz.suse.de (imap2.suse-dmz.suse.de [192.168.254.74])
        (using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
         key-exchange X25519 server-signature ECDSA (P-521) server-digest SHA512)
        (No client certificate requested)
        by smtp-out1.suse.de (Postfix) with ESMTPS id CC26221D09;
        Tue,  2 May 2023 11:23:55 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=suse.cz; s=susede2_rsa;
        t=1683026635; h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
         mime-version:mime-version:content-type:content-type:
         in-reply-to:in-reply-to:references:references;
        bh=auMKjFCZlAomyDKk7xnRROZ2Twge8AIH71DokXSPSjQ=;
        b=yDVZEbiiKxDBys2VplkjOJE5soUzLmDaeNBafVUAWaWwTSf/XXaJ+Zd5/un54dtk0vtleb
        z75+VYNYttuBHYfV8xrjFbBG6D8v1hltNrPmlFUiT8sjlBi+CY/j9+QjjtHawuDJ4jZus9
        YjTg6JKDcs6YZHWR/VA7BAOF40ws0hg=
DKIM-Signature: v=1; a=ed25519-sha256; c=relaxed/relaxed; d=suse.cz;
        s=susede2_ed25519; t=1683026635;
        h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
         mime-version:mime-version:content-type:content-type:
         in-reply-to:in-reply-to:references:references;
        bh=auMKjFCZlAomyDKk7xnRROZ2Twge8AIH71DokXSPSjQ=;
        b=vlJ+ISc1zUTFBDEuIMzGfidUwuB/hxcA/r7oslsic0I9dKZoBi2WfdSZ8Ly/xfYA8bkfJw
        ALbmGkc8a0ixEOBg==
Received: from imap2.suse-dmz.suse.de (imap2.suse-dmz.suse.de [192.168.254.74])
        (using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
         key-exchange X25519 server-signature ECDSA (P-521) server-digest SHA512)
        (No client certificate requested)
        by imap2.suse-dmz.suse.de (Postfix) with ESMTPS id AD0F4134FB;
        Tue,  2 May 2023 11:23:55 +0000 (UTC)
Received: from dovecot-director2.suse.de ([192.168.254.65])
        by imap2.suse-dmz.suse.de with ESMTPSA
        id xdLSKcvyUGT/FQAAMHmgww
        (envelope-from <jack@suse.cz>); Tue, 02 May 2023 11:23:55 +0000
Received: by quack3.suse.cz (Postfix, from userid 1000)
        id 24A0EA0735; Tue,  2 May 2023 13:23:55 +0200 (CEST)
Date:   Tue, 2 May 2023 13:23:55 +0200
From:   Jan Kara <jack@suse.cz>
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
Message-ID: <20230502112355.x5lgcy75lh4mjo66@quack3>
References: <cover.1682981880.git.lstoakes@gmail.com>
 <dee4f4ad6532b0f94d073da263526de334d5d7e0.1682981880.git.lstoakes@gmail.com>
 <20230502111334.GP1597476@hirez.programming.kicks-ass.net>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20230502111334.GP1597476@hirez.programming.kicks-ass.net>
X-Spam-Status: No, score=-4.4 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_MED,SPF_HELO_NONE,
        SPF_PASS,T_SCC_BODY_TEXT_LINE autolearn=ham autolearn_force=no
        version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Tue 02-05-23 13:13:34, Peter Zijlstra wrote:
> On Tue, May 02, 2023 at 12:11:49AM +0100, Lorenzo Stoakes wrote:
> > +
> > +		/*
> > +		 * Neither anonymous nor shmem-backed folios require
> > +		 * dirty tracking.
> > +		 */
> > +		ret = folio_test_anon(folio) ||
> > +			(mapping && shmem_mapping(mapping));
> > +	} else {
> > +		/* If the mapping is unstable, fallback to the slow path. */
> > +		ret = false;
> > +	}
> > +
> > +	unlock_rcu();
> > +
> > +	return ret;
> 
> then becomes:
> 
> 
> 	if (folio_test_anon(folio))
> 		return true;
> 
> 	/*
> 	 * Having IRQs disabled (as per GUP-fast) also inhibits RCU
> 	 * grace periods from making progress, IOW. they imply
> 	 * rcu_read_lock().
> 	 */
> 	lockdep_assert_irqs_disabled();
> 
> 	/*
> 	 * Inodes and thus address_space are RCU freed and thus safe to
> 	 * access at this point.
> 	 */
> 	mapping = folio_mapping(folio);
> 	if (mapping && shmem_mapping(mapping))
> 		return true;
> 
> 	return false;

Yeah, that's even better.

								Honza
-- 
Jan Kara <jack@suse.com>
SUSE Labs, CR
