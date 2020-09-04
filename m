Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id DE8E625DEEE
	for <lists+netdev@lfdr.de>; Fri,  4 Sep 2020 18:03:37 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726937AbgIDQDe (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 4 Sep 2020 12:03:34 -0400
Received: from us-smtp-2.mimecast.com ([205.139.110.61]:30374 "EHLO
        us-smtp-delivery-1.mimecast.com" rhost-flags-OK-OK-OK-FAIL)
        by vger.kernel.org with ESMTP id S1726722AbgIDQDd (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 4 Sep 2020 12:03:33 -0400
Received: from mimecast-mx01.redhat.com (mimecast-mx01.redhat.com
 [209.132.183.4]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-540-hb8g6iE0O5mrNFWlNdWvUA-1; Fri, 04 Sep 2020 12:03:28 -0400
X-MC-Unique: hb8g6iE0O5mrNFWlNdWvUA-1
Received: from smtp.corp.redhat.com (int-mx05.intmail.prod.int.phx2.redhat.com [10.5.11.15])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mimecast-mx01.redhat.com (Postfix) with ESMTPS id 22B2E108050D;
        Fri,  4 Sep 2020 16:03:15 +0000 (UTC)
Received: from krava (ovpn-112-34.ams2.redhat.com [10.36.112.34])
        by smtp.corp.redhat.com (Postfix) with SMTP id 86FEE88F2A;
        Fri,  4 Sep 2020 16:03:09 +0000 (UTC)
Date:   Fri, 4 Sep 2020 18:03:03 +0200
From:   Jiri Olsa <jolsa@redhat.com>
To:     Ian Rogers <irogers@google.com>
Cc:     Peter Zijlstra <peterz@infradead.org>,
        Ingo Molnar <mingo@redhat.com>,
        Arnaldo Carvalho de Melo <acme@kernel.org>,
        Mark Rutland <mark.rutland@arm.com>,
        Alexander Shishkin <alexander.shishkin@linux.intel.com>,
        Namhyung Kim <namhyung@kernel.org>,
        Alexei Starovoitov <ast@kernel.org>,
        Daniel Borkmann <daniel@iogearbox.net>,
        Martin KaFai Lau <kafai@fb.com>,
        Song Liu <songliubraving@fb.com>, Yonghong Song <yhs@fb.com>,
        Andrii Nakryiko <andriin@fb.com>,
        John Fastabend <john.fastabend@gmail.com>,
        KP Singh <kpsingh@chromium.org>,
        Adrian Hunter <adrian.hunter@intel.com>,
        Andi Kleen <ak@linux.intel.com>,
        Athira Rajeev <atrajeev@linux.vnet.ibm.com>,
        LKML <linux-kernel@vger.kernel.org>,
        Networking <netdev@vger.kernel.org>, bpf <bpf@vger.kernel.org>,
        Stephane Eranian <eranian@google.com>
Subject: Re: [PATCH v2 2/5] perf record: Prevent override of
 attr->sample_period for libpfm4 events
Message-ID: <20200904160303.GD939481@krava>
References: <20200728085734.609930-1-irogers@google.com>
 <20200728085734.609930-3-irogers@google.com>
 <20200728155940.GC1319041@krava>
 <20200728160954.GD1319041@krava>
 <CAP-5=fVqto0LrwgW6dHQupp7jFA3wToRBonBaXXQW4wwYcTreg@mail.gmail.com>
 <CAP-5=fWNniZuYfYhz_Cz7URQ+2E4T4Kg3DJqGPtDg70i38Er_A@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <CAP-5=fWNniZuYfYhz_Cz7URQ+2E4T4Kg3DJqGPtDg70i38Er_A@mail.gmail.com>
X-Scanned-By: MIMEDefang 2.79 on 10.5.11.15
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Thu, Sep 03, 2020 at 10:41:14PM -0700, Ian Rogers wrote:
> On Wed, Jul 29, 2020 at 4:24 PM Ian Rogers <irogers@google.com> wrote:
> >
> > On Tue, Jul 28, 2020 at 9:10 AM Jiri Olsa <jolsa@redhat.com> wrote:
> > >
> > > On Tue, Jul 28, 2020 at 05:59:46PM +0200, Jiri Olsa wrote:
> > > > On Tue, Jul 28, 2020 at 01:57:31AM -0700, Ian Rogers wrote:
> > > > > From: Stephane Eranian <eranian@google.com>
> > > > >
> > > > > Before:
> > > > > $ perf record -c 10000 --pfm-events=cycles:period=77777
> > > > >
> > > > > Would yield a cycles event with period=10000, instead of 77777.
> > > > >
> > > > > This was due to an ordering issue between libpfm4 parsing
> > > > > the event string and perf record initializing the event.
> > > > >
> > > > > This patch fixes the problem by preventing override for
> > > > > events with attr->sample_period != 0 by the time
> > > > > perf_evsel__config() is invoked. This seems to have been the
> > > > > intent of the author.
> > > > >
> > > > > Signed-off-by: Stephane Eranian <eranian@google.com>
> > > > > Reviewed-by: Ian Rogers <irogers@google.com>
> > > > > ---
> > > > >  tools/perf/util/evsel.c | 3 +--
> > > > >  1 file changed, 1 insertion(+), 2 deletions(-)
> > > > >
> > > > > diff --git a/tools/perf/util/evsel.c b/tools/perf/util/evsel.c
> > > > > index 811f538f7d77..8afc24e2ec52 100644
> > > > > --- a/tools/perf/util/evsel.c
> > > > > +++ b/tools/perf/util/evsel.c
> > > > > @@ -976,8 +976,7 @@ void evsel__config(struct evsel *evsel, struct record_opts *opts,
> > > > >      * We default some events to have a default interval. But keep
> > > > >      * it a weak assumption overridable by the user.
> > > > >      */
> > > > > -   if (!attr->sample_period || (opts->user_freq != UINT_MAX ||
> > > > > -                                opts->user_interval != ULLONG_MAX)) {
> > > > > +   if (!attr->sample_period) {
> > > >
> > > > I was wondering why this wouldn't break record/top
> > > > but we take care of the via record_opts__config
> > > >
> > > > as long as 'perf test attr' works it looks ok to me
> > >
> > > hum ;-)
> > >
> > > [jolsa@krava perf]$ sudo ./perf test 17 -v
> > > 17: Setup struct perf_event_attr                          :
> > > ...
> > > running './tests/attr/test-record-C0'
> > > expected sample_period=4000, got 3000
> > > FAILED './tests/attr/test-record-C0' - match failure
> >
> > I'm not able to reproduce this. Do you have a build configuration or
> > something else to look at? The test doesn't seem obviously connected
> > with this patch.
> >
> > Thanks,
> > Ian
> 
> Jiri, any update? Thanks,

sorry, I rebased and ran it again and it passes for me now,
so it got fixed along the way

jirka

