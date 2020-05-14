Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id D642B1D4090
	for <lists+netdev@lfdr.de>; Fri, 15 May 2020 00:13:14 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728329AbgENWNM (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 14 May 2020 18:13:12 -0400
Received: from mail.kernel.org ([198.145.29.99]:34302 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726046AbgENWNM (ORCPT <rfc822;netdev@vger.kernel.org>);
        Thu, 14 May 2020 18:13:12 -0400
Received: from paulmck-ThinkPad-P72.home (unknown [50.39.105.78])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id C23B82065D;
        Thu, 14 May 2020 22:13:09 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1589494390;
        bh=f2WUV5cJBIm5s6ANLfJcEURYQZoNvbj81pbeEiNUwYc=;
        h=Date:From:To:Cc:Subject:Reply-To:References:In-Reply-To:From;
        b=LcCe/rRSVYWeP6M5BaLxYIau2lrpuL/ara3qptNlh35p9pbiYFiFDNA7/5gmQ/RDn
         IciPXImeOC1RrO9mUx3WviYr/GjVszrK5/6OwFonyKBQLXjlNuw/7WTenZQ4WAoYtm
         /78utC1nS3TcMvhxlOPpLGqW+4A8ZnBVpsv1v2bA=
Received: by paulmck-ThinkPad-P72.home (Postfix, from userid 1000)
        id 4EC7C35229C8; Thu, 14 May 2020 15:13:09 -0700 (PDT)
Date:   Thu, 14 May 2020 15:13:09 -0700
From:   "Paul E. McKenney" <paulmck@kernel.org>
To:     Andrii Nakryiko <andrii.nakryiko@gmail.com>
Cc:     Thomas Gleixner <tglx@linutronix.de>,
        Jakub Kicinski <kuba@kernel.org>,
        Andrii Nakryiko <andriin@fb.com>, linux-arch@vger.kernel.org,
        bpf <bpf@vger.kernel.org>, Networking <netdev@vger.kernel.org>,
        Alexei Starovoitov <ast@fb.com>,
        Daniel Borkmann <daniel@iogearbox.net>,
        Kernel Team <kernel-team@fb.com>,
        Jonathan Lemon <jonathan.lemon@gmail.com>
Subject: Re: [PATCH bpf-next 1/6] bpf: implement BPF ring buffer and verifier
 support for it
Message-ID: <20200514221309.GV2869@paulmck-ThinkPad-P72>
Reply-To: paulmck@kernel.org
References: <20200513192532.4058934-1-andriin@fb.com>
 <20200513192532.4058934-2-andriin@fb.com>
 <20200514121848.052966b3@kicinski-fedora-pc1c0hjn.dhcp.thefacebook.com>
 <87h7wixndi.fsf@nanos.tec.linutronix.de>
 <CAEf4Bzbj-WvRkoGxkSFtK5_1JfQxthoFid398C97RM0ppBb0dA@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <CAEf4Bzbj-WvRkoGxkSFtK5_1JfQxthoFid398C97RM0ppBb0dA@mail.gmail.com>
User-Agent: Mutt/1.9.4 (2018-02-28)
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Thu, May 14, 2020 at 02:30:11PM -0700, Andrii Nakryiko wrote:
> On Thu, May 14, 2020 at 1:39 PM Thomas Gleixner <tglx@linutronix.de> wrote:
> >
> > Jakub Kicinski <kuba@kernel.org> writes:
> >
> > > On Wed, 13 May 2020 12:25:27 -0700 Andrii Nakryiko wrote:
> > >> One interesting implementation bit, that significantly simplifies (and thus
> > >> speeds up as well) implementation of both producers and consumers is how data
> > >> area is mapped twice contiguously back-to-back in the virtual memory. This
> > >> allows to not take any special measures for samples that have to wrap around
> > >> at the end of the circular buffer data area, because the next page after the
> > >> last data page would be first data page again, and thus the sample will still
> > >> appear completely contiguous in virtual memory. See comment and a simple ASCII
> > >> diagram showing this visually in bpf_ringbuf_area_alloc().
> > >
> > > Out of curiosity - is this 100% okay to do in the kernel and user space
> > > these days? Is this bit part of the uAPI in case we need to back out of
> > > it?
> > >
> > > In the olden days virtually mapped/tagged caches could get confused
> > > seeing the same physical memory have two active virtual mappings, or
> > > at least that's what I've been told in school :)
> >
> > Yes, caching the same thing twice causes coherency problems.
> >
> > VIVT can be found in ARMv5, MIPS, NDS32 and Unicore32.
> >
> > > Checking with Paul - he says that could have been the case for Itanium
> > > and PA-RISC CPUs.
> >
> > Itanium: PIPT L1/L2.
> > PA-RISC: VIPT L1 and PIPT L2

Thank you, Thomas!

> > Thanks,
> 
> Jakub, thanks for bringing this up.

Indeed!  I had completely forgotten about it.

> Thomas, Paul, what kind of problems are we talking about here? What
> are the possible problems in practice?

One CPU stores into one of the mappings, and then it (or some other CPU)
subsequently sees the old value via the other mapping, maybe for a short
time, or maybe indefinitely, depending.  This sort of thing can happen
when the same location in the two mappings map to different location in
the cache.  The store via one virtual address then is placed into one
location in the cache, but the reads from the other virtual address are
referring to some other location in the cache.

In the past, some systems have documented virtual address offsets that
are guaranteed to work, presumably because those offsets force the two
views of the same physical memory to share the same location in the cache.

> So just for the context, all the metadata (record header) that is
> written/read under lock and with smp_store_release/smp_load_acquire is
> written through the one set of page mappings (the first one). Only
> some of sample payload might go into the second set of mapped pages.
> Does this mean that user-space might read some old payloads in such
> case?

That could happen, depending on which CPU accessed what physical
memory using which virtual address.

> I could work-around that in user-space, by mmaping twice the same
> range, one after the other (second mmap would use MAP_FIXED flag, of
> course). So that's not a big deal.

That would work, assuming you mean to map double the size of memory
and then handle the wraparound case very very carefully.  ;-)

But you need only do that on VI*T systems, if that helps.

> But on the kernel side it's crucial property, because it allows BPF
> programs to work with data with the assumption that all data is
> linearly mapped. If we can't do that, reserve() API is impossible to
> implement. So in that case, I'd rather enable BPF ring buffer only on
> platforms that won't have these problems, instead of removing
> reserve/commit API altogether.

You could flush the local CPU's cache before reading past the end,
but only if it is guaranteed that no other CPU is accessing that same
memory using the other mapping.  (No convinced that this is feasible,
but who knows?)

I see that linux-arch is copied, so do any of the affected architectures
object to being left out?

> Well, another way is to just "discard" remaining space at the end, if
> it's not sufficient for entire record. That's doable, there will
> always be at least 8 bytes available for record header, so not a
> problem in that regard. But I would appreciate if you can help me
> understand full implications of caching physical memory twice.
> 
> Also just for my education, with VIVT caches, if user-space
> application mmap()'s same region of memory twice (without MAP_FIXED),
> wouldn't that cause similar problems? Can't this happen today with
> mmap() API? Why is that not a problem?

It does indeed affect userspace applications as well.  And I haven't
heard about this being a problem for a very long time, which might be
why I had forgotten about it.

But the underlying problem is that on VIVT and VIPT platforms, mapping
the same physical memory to two different virtual addresses can cause
that same memory to appear twice in the cache, and the resulting pair
of cachelines will not be guaranteed to be in sync with each other.
So CPUs accessing this memory through the two virtual addresses might
see different values.  Which can come as a bit of a surprise to many
algorithms.

							Thanx, Paul
