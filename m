Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 9465D2AC3AD
	for <lists+netdev@lfdr.de>; Mon,  9 Nov 2020 19:23:14 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1730920AbgKISXJ (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 9 Nov 2020 13:23:09 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:43108 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1730904AbgKISXI (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 9 Nov 2020 13:23:08 -0500
Received: from merlin.infradead.org (merlin.infradead.org [IPv6:2001:8b0:10b:1231::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id EFB53C0613CF;
        Mon,  9 Nov 2020 10:23:07 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
        d=infradead.org; s=merlin.20170209; h=In-Reply-To:Content-Type:MIME-Version:
        References:Message-ID:Subject:Cc:To:From:Date:Sender:Reply-To:
        Content-Transfer-Encoding:Content-ID:Content-Description;
        bh=8dJ1W8t6CVSj5rnc2L46yoGA7NryLJHpde00uR/u0R8=; b=lPkIhQrqk6+6Re0AfYc/O0FX+n
        P1wQXCj23DbYU/ryV+9dma02C0yYZ1laO5vmf5EXzxKtzZYBowONUy8O4hY5n8tpySDDWq3r3qViC
        JV9lWxr89qTFoSicHvIFpbGHx6sPEa4DisJ/6Td1zVjCAfNu0kaHeexoV/ASY6q+IE240uSlD4cf3
        S+XpwklulglKxakiyJpR09Jb2E+OUxgBbMLgATJp1/zsWcmOOwN9ZgBXTBLe1LADLdMFQDsAF2DKY
        YsA0Bj0o3hm5iR/PMcjkwDYDhrY+Q6CvFtC1eOh/19ROJCAK3RB7no6U9k/rbdEI7iLeaOm95m/Hl
        EYTLu/Fg==;
Received: from j217100.upc-j.chello.nl ([24.132.217.100] helo=noisy.programming.kicks-ass.net)
        by merlin.infradead.org with esmtpsa (Exim 4.92.3 #3 (Red Hat Linux))
        id 1kcBoe-00017B-LS; Mon, 09 Nov 2020 18:22:57 +0000
Received: from hirez.programming.kicks-ass.net (hirez.programming.kicks-ass.net [192.168.1.225])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (Client did not present a certificate)
        by noisy.programming.kicks-ass.net (Postfix) with ESMTPS id 1D0A23077E1;
        Mon,  9 Nov 2020 19:22:54 +0100 (CET)
Received: by hirez.programming.kicks-ass.net (Postfix, from userid 1000)
        id 0B0052B81AAA1; Mon,  9 Nov 2020 19:22:54 +0100 (CET)
Date:   Mon, 9 Nov 2020 19:22:53 +0100
From:   Peter Zijlstra <peterz@infradead.org>
To:     Alexei Starovoitov <alexei.starovoitov@gmail.com>
Cc:     Kevin Sheldrake <Kevin.Sheldrake@microsoft.com>,
        Ingo Molnar <mingo@kernel.org>,
        Daniel Borkmann <daniel@iogearbox.net>,
        Network Development <netdev@vger.kernel.org>,
        "bpf@vger.kernel.org" <bpf@vger.kernel.org>,
        Andrii Nakryiko <andrii.nakryiko@gmail.com>,
        KP Singh <kpsingh@google.com>
Subject: Re: [PATCH bpf-next v2] Update perf ring buffer to prevent corruption
Message-ID: <20201109182253.GR2594@hirez.programming.kicks-ass.net>
References: <VI1PR8303MB00802FE5D289E0D7BA95B7DDFBEE0@VI1PR8303MB0080.EURPRD83.prod.outlook.com>
 <CAADnVQLNdDn1jfyEAeKO17vXQiN+VKAvq+VFkY2G_pvSbaPjFA@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <CAADnVQLNdDn1jfyEAeKO17vXQiN+VKAvq+VFkY2G_pvSbaPjFA@mail.gmail.com>
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Thu, Nov 05, 2020 at 08:19:47PM -0800, Alexei Starovoitov wrote:

> > Subject: [PATCH] Update perf ring buffer to prevent corruption from
> >  bpf_perf_output_event()

$Subject is broken, it lacks subsystem prefix.

> >
> > The bpf_perf_output_event() helper takes a sample size parameter of u64, but
> > the underlying perf ring buffer uses a u16 internally. This 64KB maximum size
> > has to also accommodate a variable sized header. Failure to observe this
> > restriction can result in corruption of the perf ring buffer as samples
> > overlap.
> >
> > Track the sample size and return -E2BIG if too big to fit into the u16
> > size parameter.
> >
> > Signed-off-by: Kevin Sheldrake <kevin.sheldrake@microsoft.com>

> > ---
> >  include/linux/perf_event.h |  2 +-
> >  kernel/events/core.c       | 40 ++++++++++++++++++++++++++--------------
> >  2 files changed, 27 insertions(+), 15 deletions(-)
> >
> > diff --git a/include/linux/perf_event.h b/include/linux/perf_event.h
> > index 0c19d27..b9802e5 100644
> > --- a/include/linux/perf_event.h
> > +++ b/include/linux/perf_event.h
> > @@ -1060,7 +1060,7 @@ extern void perf_output_sample(struct perf_output_handle *handle,
> >                                struct perf_event_header *header,
> >                                struct perf_sample_data *data,
> >                                struct perf_event *event);
> > -extern void perf_prepare_sample(struct perf_event_header *header,
> > +extern int perf_prepare_sample(struct perf_event_header *header,
> >                                 struct perf_sample_data *data,
> >                                 struct perf_event *event,
> >                                 struct pt_regs *regs);
> > diff --git a/kernel/events/core.c b/kernel/events/core.c
> > index da467e1..c6c4a3c 100644
> > --- a/kernel/events/core.c
> > +++ b/kernel/events/core.c
> > @@ -7016,15 +7016,17 @@ perf_callchain(struct perf_event *event, struct pt_regs *regs)
> >         return callchain ?: &__empty_callchain;
> >  }
> >
> > -void perf_prepare_sample(struct perf_event_header *header,
> > +int perf_prepare_sample(struct perf_event_header *header,
> >                          struct perf_sample_data *data,
> >                          struct perf_event *event,
> >                          struct pt_regs *regs)

please re-align things.

> >  {
> >         u64 sample_type = event->attr.sample_type;
> > +       u32 header_size = header->size;
> > +
> >
> >         header->type = PERF_RECORD_SAMPLE;
> > -       header->size = sizeof(*header) + event->header_size;
> > +       header_size = sizeof(*header) + event->header_size;
> >
> >         header->misc = 0;
> >         header->misc |= perf_misc_flags(regs);
> > @@ -7042,7 +7044,7 @@ void perf_prepare_sample(struct perf_event_header *header,
> >
> >                 size += data->callchain->nr;
> >
> > -               header->size += size * sizeof(u64);
> > +               header_size += size * sizeof(u64);
> >         }
> >
> >         if (sample_type & PERF_SAMPLE_RAW) {
> > @@ -7067,7 +7069,7 @@ void perf_prepare_sample(struct perf_event_header *header,
> >                         size = sizeof(u64);
> >                 }
> >
> > -               header->size += size;
> > +               header_size += size;
> >         }

AFAICT perf_raw_frag::size is a u32, so the above addition can already
fully overflow. Best is probably to make header_size u64 and delay that
until the final tally below.

> >
> >         if (sample_type & PERF_SAMPLE_BRANCH_STACK) {

> > @@ -7162,14 +7164,20 @@ void perf_prepare_sample(struct perf_event_header *header,
> >                  * Make sure this doesn't happen by using up to U16_MAX bytes
> >                  * per sample in total (rounded down to 8 byte boundary).
> >                  */
> > -               size = min_t(size_t, U16_MAX - header->size,
> > +               size = min_t(size_t, U16_MAX - header_size,
> >                              event->attr.aux_sample_size);
> >                 size = rounddown(size, 8);
> >                 size = perf_prepare_sample_aux(event, data, size);
> >
> > -               WARN_ON_ONCE(size + header->size > U16_MAX);
> > -               header->size += size;
> > +               WARN_ON_ONCE(size + header_size > U16_MAX);
> > +               header_size += size;
> >         }
> > +
> > +       if (header_size > U16_MAX)
> > +               return -E2BIG;
> > +
> > +       header->size = header_size;
> > +
> >         /*
> >          * If you're adding more sample types here, you likely need to do
> >          * something about the overflowing header::size, like repurpose the
> > @@ -7179,6 +7187,8 @@ void perf_prepare_sample(struct perf_event_header *header,
> >          * do here next.
> >          */
> >         WARN_ON_ONCE(header->size & 7);
> > +
> > +       return 0;
> >  }
> >
> >  static __always_inline int
> > @@ -7196,7 +7206,9 @@ __perf_event_output(struct perf_event *event,
> >         /* protect the callchain buffers */
> >         rcu_read_lock();
> >
> > -       perf_prepare_sample(&header, data, event, regs);
> > +       err = perf_prepare_sample(&header, data, event, regs);
> > +       if (err)
> > +               goto exit;

This is wrong I think. The thing is that when output_begin() below
returns an error, there either is no buffer (in which case we can't do
anything much at all) or it will have incremented rb->lost.

This OTOH will completely fail to report the loss. The error case here
is to immediately try and emit a RECORD_LOST event, but then please also
consider these patches:

  https://lkml.kernel.org/r/20201030151345.540479897@infradead.org

(which I'll be pushing into tip/perf/urgent soonish)

> >
> >         err = output_begin(&handle, event, header.size);
> >         if (err)
> > --
> > 2.7.4
> >
