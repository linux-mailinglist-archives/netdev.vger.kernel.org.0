Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 96B821D369E
	for <lists+netdev@lfdr.de>; Thu, 14 May 2020 18:37:23 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726119AbgENQhW (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 14 May 2020 12:37:22 -0400
Received: from smtp.emailarray.com ([69.28.212.198]:44575 "EHLO
        smtp2.emailarray.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726017AbgENQhW (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 14 May 2020 12:37:22 -0400
X-Greylist: delayed 399 seconds by postgrey-1.27 at vger.kernel.org; Thu, 14 May 2020 12:37:21 EDT
Received: (qmail 73016 invoked by uid 89); 14 May 2020 16:30:40 -0000
Received: from unknown (HELO localhost) (amxlbW9uQGZsdWdzdmFtcC5jb21AMTYzLjExNC4xMzIuMw==) (POLARISLOCAL)  
  by smtp2.emailarray.com with SMTP; 14 May 2020 16:30:40 -0000
Date:   Thu, 14 May 2020 09:30:37 -0700
From:   Jonathan Lemon <bsd@fb.com>
To:     Andrii Nakryiko <andrii.nakryiko@gmail.com>
Cc:     Jonathan Lemon <jonathan.lemon@gmail.com>,
        Andrii Nakryiko <andriin@fb.com>, bpf <bpf@vger.kernel.org>,
        Networking <netdev@vger.kernel.org>,
        Alexei Starovoitov <ast@fb.com>,
        Daniel Borkmann <daniel@iogearbox.net>,
        Kernel Team <kernel-team@fb.com>,
        "Paul E . McKenney" <paulmck@kernel.org>
Subject: Re: [PATCH bpf-next 0/6] BPF ring buffer
Message-ID: <20200514163037.oijxmoemkg47ujft@bsd-mbp>
References: <20200513192532.4058934-1-andriin@fb.com>
 <20200513224927.643hszw3q3cgx7e6@bsd-mbp.dhcp.thefacebook.com>
 <CAEf4BzaSEPNyBvXBduH2Bkr64=MbzFiR9hJ9DYwXwk4D2AtcDw@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <CAEf4BzaSEPNyBvXBduH2Bkr64=MbzFiR9hJ9DYwXwk4D2AtcDw@mail.gmail.com>
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Wed, May 13, 2020 at 11:08:46PM -0700, Andrii Nakryiko wrote:
> On Wed, May 13, 2020 at 3:49 PM Jonathan Lemon <jonathan.lemon@gmail.com> wrote:
> >
> > On Wed, May 13, 2020 at 12:25:26PM -0700, Andrii Nakryiko wrote:
> > > Implement a new BPF ring buffer, as presented at BPF virtual conference ([0]).
> > > It presents an alternative to perf buffer, following its semantics closely,
> > > but allowing sharing same instance of ring buffer across multiple CPUs
> > > efficiently.
> > >
> > > Most patches have extensive commentary explaining various aspects, so I'll
> > > keep cover letter short. Overall structure of the patch set:
> > > - patch #1 adds BPF ring buffer implementation to kernel and necessary
> > >   verifier support;
> > > - patch #2 adds litmus tests validating all the memory orderings and locking
> > >   is correct;
> > > - patch #3 is an optional patch that generalizes verifier's reference tracking
> > >   machinery to capture type of reference;
> > > - patch #4 adds libbpf consumer implementation for BPF ringbuf;
> > > - path #5 adds selftest, both for single BPF ring buf use case, as well as
> > >   using it with array/hash of maps;
> > > - patch #6 adds extensive benchmarks and provide some analysis in commit
> > >   message, it build upon selftests/bpf's bench runner.
> > >
> > >   [0] https://docs.google.com/presentation/d/18ITdg77Bj6YDOH2LghxrnFxiPWe0fAqcmJY95t_qr0w
> > >
> > > Cc: Paul E. McKenney <paulmck@kernel.org>
> > > Cc: Jonathan Lemon <jonathan.lemon@gmail.com>
> >
> > Looks very nice!  A few random questions:
> >
> > 1) Why not use a structure for the header, instead of 2 32bit ints?
> 
> hm... no reason, just never occurred to me it's necessary :)

It might be clearer to do this.  Something like:

struct ringbuf_record {
    union {
        struct {
            u32 size:30;
            bool busy:1;
            bool discard:1;
        };
        u32 word1;
    };
    union {
        u32 pgoff;
        u32 word2;
    };
};

While perhaps a bit overkill, makes it clear what is going on.


> > 2) Would it make sense to reserve X bytes, but only commit Y?
> >    the offset field could be used to write the record length.
> >
> >    E.g.:
> >       reserve 512 bytes    [BUSYBIT | 512][PG OFFSET]
> >       commit  400 bytes    [ 512 ] [ 400 ]
> 
> It could be done, though I had tentative plans to use those second 4
> bytes for something useful eventually.
> 
> But what's the use case? From ring buffer's perspective, X bytes were
> reserved and are gone already and subsequent writers might have
> already advanced producer counter with the assumption that all X bytes
> are going to be used. So there are no space savings, even if record is
> discarded or only portion of it is submitted. I can only see a bit of
> added convenience for an application, because it doesn't have to track
> amount of actual data in its record. But this doesn't seem to be a
> common case either, so not sure how it's worth supporting... Is there
> a particular case where this is extremely useful and extra 4 bytes in
> record payload is too much?

Not off the top of my head - it was just the first thing that came to
mind when reading about the commit/discard paradigm.  I was thinking
about variable records, where the maximum is reserved, but less data
is written.  But there's no particular reason for the ringbuffer to
track this either, it could be part of the application framing.


> > 3) Why have 2 separate pages for producer/consumer, instead of
> >    just aligning to a smp cache line (or even 1/2 page?)
> 
> Access rights restrictions. Consumer page is readable/writable,
> producer page is read-only for user-space. If user-space had ability
> to write producer position, it could wreck a huge havoc for the
> ringbuf algorithm.

Ah, thanks, that makes sense.  Might want to add a comment to
that effect, as it's different from other implementations.
-- 
Jonathan
