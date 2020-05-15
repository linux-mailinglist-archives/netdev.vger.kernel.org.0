Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 7E3B11D5C76
	for <lists+netdev@lfdr.de>; Sat, 16 May 2020 00:42:08 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726945AbgEOWmE (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 15 May 2020 18:42:04 -0400
Received: from us-smtp-delivery-1.mimecast.com ([205.139.110.120]:41140 "EHLO
        us-smtp-1.mimecast.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
        with ESMTP id S1726727AbgEOWmE (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 15 May 2020 18:42:04 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1589582522;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         in-reply-to:in-reply-to:references:references;
        bh=5q43gttRNqMu1PIGrPl7cLm6uhoV/76UxdA6VMpftBY=;
        b=R+lhrkFjgK5fVZ1yb0+bgEC67kB7gLaNHvwfMUFIFGxASlqXvenW4PvmdN11ufr+lDLwpn
        KmkdkGTV/NjHOxEYs7XlwZp1vHlQK1VmZwxElcc3RzmnNjVJ5TGxkHiASvCkKstz9E9kNv
        uX6TAJ0V/+2uFnrrRz5tpP2CV1a1r4E=
Received: from mimecast-mx01.redhat.com (mimecast-mx01.redhat.com
 [209.132.183.4]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-160-3xEnrdYeNSu20afDhsHuRQ-1; Fri, 15 May 2020 18:42:00 -0400
X-MC-Unique: 3xEnrdYeNSu20afDhsHuRQ-1
Received: from smtp.corp.redhat.com (int-mx02.intmail.prod.int.phx2.redhat.com [10.5.11.12])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mimecast-mx01.redhat.com (Postfix) with ESMTPS id EBC8A8014D7;
        Fri, 15 May 2020 22:41:56 +0000 (UTC)
Received: from krava (unknown [10.40.192.69])
        by smtp.corp.redhat.com (Postfix) with SMTP id 967F060BF1;
        Fri, 15 May 2020 22:41:51 +0000 (UTC)
Date:   Sat, 16 May 2020 00:41:50 +0200
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
        Kajol Jain <kjain@linux.ibm.com>,
        Andi Kleen <ak@linux.intel.com>,
        John Garry <john.garry@huawei.com>,
        Jin Yao <yao.jin@linux.intel.com>,
        Kan Liang <kan.liang@linux.intel.com>,
        Cong Wang <xiyou.wangcong@gmail.com>,
        Kim Phillips <kim.phillips@amd.com>,
        Adrian Hunter <adrian.hunter@intel.com>,
        Leo Yan <leo.yan@linaro.org>,
        LKML <linux-kernel@vger.kernel.org>,
        Networking <netdev@vger.kernel.org>, bpf <bpf@vger.kernel.org>,
        Stephane Eranian <eranian@google.com>
Subject: Re: [PATCH v2 7/7] perf expr: Migrate expr ids table to a hashmap
Message-ID: <20200515224150.GC3577540@krava>
References: <20200515165007.217120-1-irogers@google.com>
 <20200515165007.217120-8-irogers@google.com>
 <20200515194115.GA3577540@krava>
 <CAP-5=fUp4ECBntUamWK53LhTbT9W5w5A0frFyOMxoWK0Q2o60A@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <CAP-5=fUp4ECBntUamWK53LhTbT9W5w5A0frFyOMxoWK0Q2o60A@mail.gmail.com>
X-Scanned-By: MIMEDefang 2.79 on 10.5.11.12
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Fri, May 15, 2020 at 02:35:43PM -0700, Ian Rogers wrote:
> On Fri, May 15, 2020 at 12:41 PM Jiri Olsa <jolsa@redhat.com> wrote:
> >
> > On Fri, May 15, 2020 at 09:50:07AM -0700, Ian Rogers wrote:
> >
> > SNIP
> >
> > > diff --git a/tools/perf/util/metricgroup.c b/tools/perf/util/metricgroup.c
> > > index b071df373f8b..37be5a368d6e 100644
> > > --- a/tools/perf/util/metricgroup.c
> > > +++ b/tools/perf/util/metricgroup.c
> > > @@ -85,8 +85,7 @@ static void metricgroup__rblist_init(struct rblist *metric_events)
> > >
> > >  struct egroup {
> > >       struct list_head nd;
> > > -     int idnum;
> > > -     const char **ids;
> > > +     struct expr_parse_ctx pctx;
> > >       const char *metric_name;
> > >       const char *metric_expr;
> > >       const char *metric_unit;
> > > @@ -94,19 +93,21 @@ struct egroup {
> > >  };
> > >
> > >  static struct evsel *find_evsel_group(struct evlist *perf_evlist,
> > > -                                   const char **ids,
> > > -                                   int idnum,
> > > +                                   struct expr_parse_ctx *pctx,
> > >                                     struct evsel **metric_events,
> > >                                     bool *evlist_used)
> > >  {
> > >       struct evsel *ev;
> > > -     int i = 0, j = 0;
> > >       bool leader_found;
> > > +     const size_t idnum = hashmap__size(&pctx->ids);
> > > +     size_t i = 0;
> > > +     int j = 0;
> > > +     double *val_ptr;
> > >
> > >       evlist__for_each_entry (perf_evlist, ev) {
> > >               if (evlist_used[j++])
> > >                       continue;
> > > -             if (!strcmp(ev->name, ids[i])) {
> > > +             if (hashmap__find(&pctx->ids, ev->name, (void **)&val_ptr)) {
> >
> > hum, you sure it's doing the same thing as before?
> >
> > hashmap__find will succede all the time in here, while the
> > previous code was looking for the start of the group ...
> > the logic in here is little convoluted, so maybe I'm
> > missing some point in here ;-)
> 
> If we have a metric like "A + B" and another like "C / D" then by
> we'll generate a string (the extra_events strbuf in the code) like
> "{A,B}:W,{C,D}:W" from __metricgroup__add_metric. This will turn into
> an evlist in metricgroup__parse_groups of A,B,C,D. The code is trying
> to associate the events A,B with the first metric and C,D with the
> second. The code doesn't support sharing of events and events are
> marked as used and can't be part of other metrics. The evlist order is
> also reflective of the order of metrics, so if there were metrics "A +
> B + C" and "A + B", as the first metric is first in the evlist we
> don't run the risk of C being placed with A and B in a different
> group.
> 
> The old code used the order of events to match within a metric and say
> for metric "A+B+C" we want to match A then B, and so on. The new code
> acts more like a set, so "A + B + C" becomes a set containing A, B and
> C, we check A is in the set then B and then C. For both pieces of code
> they are only working because of the evlist_used "bitmap" and that the
> order in the evlists and metrics matches.
> 
> The current code could just use ordering to match first n1 events with
> the first metric, the next n2 events with the second and so on. So
> both the find now, and the strcmp before always return true in this
> branch.
> 
> In the RFC patch set I want to share events and so I do checks related
> to the group leader so that I know when moving from one group to
> another in the evlist. The find/strcmp becomes load bearing as I will
> re-use events as long as they match.
> https://lore.kernel.org/lkml/20200508053629.210324-14-irogers@google.com/
> 
> > jirka
> >
> > >                       if (!metric_events[i])
> > >                               metric_events[i] = ev;
> > >                       i++;
> > > @@ -118,7 +119,8 @@ static struct evsel *find_evsel_group(struct evlist *perf_evlist,
> > >                       memset(metric_events, 0,
> > >                               sizeof(struct evsel *) * idnum);
> 
> This re-check was unnecessary in the old code and unnecessary even
> more so now as the hashmap_find is given exactly the same arguments.
> I'll remove it in v3 while addressing Andrii's memory leak fixes.

ok, that was my other confusion, because it's useless ;-)

thanks for the explanation,
jirka

> 
> Thanks,
> Ian
> 
> > > -                     if (!strcmp(ev->name, ids[i])) {
> > > +                     if (hashmap__find(&pctx->ids, ev->name,
> > > +                                       (void **)&val_ptr)) {
> > >                               if (!metric_events[i])
> > >                                       metric_events[i] = ev;
> >
> > SNIP
> >
> 

