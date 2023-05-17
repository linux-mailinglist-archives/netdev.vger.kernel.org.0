Return-Path: <netdev+bounces-3220-lists+netdev=lfdr.de@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [139.178.88.99])
	by mail.lfdr.de (Postfix) with ESMTPS id 77C2170611F
	for <lists+netdev@lfdr.de>; Wed, 17 May 2023 09:29:28 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id 916D8280F06
	for <lists+netdev@lfdr.de>; Wed, 17 May 2023 07:29:26 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id CFB278830;
	Wed, 17 May 2023 07:29:24 +0000 (UTC)
X-Original-To: netdev@vger.kernel.org
Received: from lindbergh.monkeyblade.net (lindbergh.monkeyblade.net [23.128.96.19])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id C2CED8460
	for <netdev@vger.kernel.org>; Wed, 17 May 2023 07:29:24 +0000 (UTC)
Received: from smtp-out2.suse.de (smtp-out2.suse.de [IPv6:2001:67c:2178:6::1d])
	by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 4A9D01717
	for <netdev@vger.kernel.org>; Wed, 17 May 2023 00:29:22 -0700 (PDT)
Received: from imap2.suse-dmz.suse.de (imap2.suse-dmz.suse.de [192.168.254.74])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (P-521) server-digest SHA512)
	(No client certificate requested)
	by smtp-out2.suse.de (Postfix) with ESMTPS id E7188204F0;
	Wed, 17 May 2023 07:29:20 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=suse.cz; s=susede2_rsa;
	t=1684308560; h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
	 mime-version:mime-version:content-type:content-type:
	 in-reply-to:in-reply-to:references:references;
	bh=eii5ss2ocLxG8N7/nX823yY9WNM71xoVrkq3X6PC3iI=;
	b=ThXAnaVWBGnnqBZtfbIMAR0hX/ao8ZQHdKq6svUyFCGqgSRIQebsWzx75B3g/D/gG4ejjv
	QaLP54aZzFaHQx2Dg5lU8zRK1mmgsRbSUU7B+ovHSoAcA9qR9AaCCE307BHiCSIk465hsb
	5SdskPkCEIF9cdXAtjy2OKwS211WmH4=
DKIM-Signature: v=1; a=ed25519-sha256; c=relaxed/relaxed; d=suse.cz;
	s=susede2_ed25519; t=1684308560;
	h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
	 mime-version:mime-version:content-type:content-type:
	 in-reply-to:in-reply-to:references:references;
	bh=eii5ss2ocLxG8N7/nX823yY9WNM71xoVrkq3X6PC3iI=;
	b=Sqz/WI6g7ZxcFMqyFw1GiD4SEGIqElhv22w5+UkXvSfuSPLuSi7teR9RomQymrT67sPYHd
	Mb3rwK1NqgaOfQBw==
Received: from imap2.suse-dmz.suse.de (imap2.suse-dmz.suse.de [192.168.254.74])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (P-521) server-digest SHA512)
	(No client certificate requested)
	by imap2.suse-dmz.suse.de (Postfix) with ESMTPS id D691B13478;
	Wed, 17 May 2023 07:29:20 +0000 (UTC)
Received: from dovecot-director2.suse.de ([192.168.254.65])
	by imap2.suse-dmz.suse.de with ESMTPSA
	id ef9GNFCCZGSlDQAAMHmgww
	(envelope-from <jack@suse.cz>); Wed, 17 May 2023 07:29:20 +0000
Received: by quack3.suse.cz (Postfix, from userid 1000)
	id 24F03A0735; Wed, 17 May 2023 09:29:20 +0200 (CEST)
Date: Wed, 17 May 2023 09:29:20 +0200
From: Jan Kara <jack@suse.cz>
To: Lorenzo Stoakes <lstoakes@gmail.com>
Cc: Jason Gunthorpe <jgg@nvidia.com>,
	"Kirill A . Shutemov" <kirill@shutemov.name>, linux-mm@kvack.org,
	linux-kernel@vger.kernel.org,
	Andrew Morton <akpm@linux-foundation.org>,
	Jens Axboe <axboe@kernel.dk>, Matthew Wilcox <willy@infradead.org>,
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
	Jiri Olsa <jolsa@kernel.org>, Namhyung Kim <namhyung@kernel.org>,
	Ian Rogers <irogers@google.com>,
	Adrian Hunter <adrian.hunter@intel.com>,
	Bjorn Topel <bjorn@kernel.org>,
	Magnus Karlsson <magnus.karlsson@intel.com>,
	Maciej Fijalkowski <maciej.fijalkowski@intel.com>,
	Jonathan Lemon <jonathan.lemon@gmail.com>,
	"David S . Miller" <davem@davemloft.net>,
	Eric Dumazet <edumazet@google.com>,
	Jakub Kicinski <kuba@kernel.org>, Paolo Abeni <pabeni@redhat.com>,
	Christian Brauner <brauner@kernel.org>,
	Richard Cochran <richardcochran@gmail.com>,
	Alexei Starovoitov <ast@kernel.org>,
	Daniel Borkmann <daniel@iogearbox.net>,
	Jesper Dangaard Brouer <hawk@kernel.org>,
	John Fastabend <john.fastabend@gmail.com>,
	linux-fsdevel@vger.kernel.org, linux-perf-users@vger.kernel.org,
	netdev@vger.kernel.org, bpf@vger.kernel.org,
	Oleg Nesterov <oleg@redhat.com>, John Hubbard <jhubbard@nvidia.com>,
	Jan Kara <jack@suse.cz>, Pavel Begunkov <asml.silence@gmail.com>,
	Mika Penttila <mpenttil@redhat.com>,
	David Hildenbrand <david@redhat.com>,
	Dave Chinner <david@fromorbit.com>, Theodore Ts'o <tytso@mit.edu>,
	Peter Xu <peterx@redhat.com>,
	Matthew Rosato <mjrosato@linux.ibm.com>,
	"Paul E . McKenney" <paulmck@kernel.org>,
	Christian Borntraeger <borntraeger@linux.ibm.com>
Subject: Re: [PATCH v9 0/3] mm/gup: disallow GUP writing to file-backed
 mappings by default
Message-ID: <20230517072920.bfs7gfo4whdmi6ay@quack3>
References: <cover.1683235180.git.lstoakes@gmail.com>
 <20230515110315.uqifqgqkzcrrrubv@box.shutemov.name>
 <7f6dbe36-88f2-468e-83c1-c97e666d8317@lucifer.local>
 <ZGIhwZl2FbLodLrc@nvidia.com>
 <ad0053a4-fa34-4b95-a262-d27942b168fd@lucifer.local>
Precedence: bulk
X-Mailing-List: netdev@vger.kernel.org
List-Id: <netdev.vger.kernel.org>
List-Subscribe: <mailto:netdev+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:netdev+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <ad0053a4-fa34-4b95-a262-d27942b168fd@lucifer.local>
X-Spam-Status: No, score=-3.7 required=5.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_MED,SPF_HELO_NONE,
	SPF_SOFTFAIL,T_SCC_BODY_TEXT_LINE,URIBL_BLOCKED autolearn=ham
	autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
	lindbergh.monkeyblade.net

On Mon 15-05-23 14:07:57, Lorenzo Stoakes wrote:
> On Mon, May 15, 2023 at 09:12:49AM -0300, Jason Gunthorpe wrote:
> > On Mon, May 15, 2023 at 12:16:21PM +0100, Lorenzo Stoakes wrote:
> > > Jason will have some thoughts on this I'm sure. I guess the key question
> > > here is - is it actually feasible for this to work at all? Once we
> > > establish that, the rest are details :)
> >
> > Surely it is, but like Ted said, the FS folks are not interested and
> > they are at least half the solution..
> 
> :'(

Well, I'd phrase this a bit differently - it is a difficult sell to fs
maintainers that they should significantly complicate writeback code / VFS
with bounce page handling etc. for a thing that is not much used corner
case. So if we can get away with forbiding long-term pins, then that's the
easiest solution. Dealing with short-term pins is easier as we can just
wait for unpinning which is implementable in a localized manner.

> > The FS also has to actively not write out the page while it cannot be
> > write protected unless it copies the data to a stable page. The block
> > stack needs the source data to be stable to do checksum/parity/etc
> > stuff. It is a complicated subject.
> 
> Yes my sense was that being able to write arbitrarily to these pages _at
> all_ was a big issue, not only the dirty tracking aspect.

Yes.

> I guess at some level letting filesystems have such total flexibility as to
> how they implement things leaves us in a difficult position.

I'm not sure what you mean by "total flexibility" here. In my opinion it is
also about how HW performs checksumming etc.

								Honza
-- 
Jan Kara <jack@suse.com>
SUSE Labs, CR

