Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 10EA11D5BB2
	for <lists+netdev@lfdr.de>; Fri, 15 May 2020 23:37:20 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727785AbgEOVgA (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 15 May 2020 17:36:00 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:45090 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-FAIL-OK-FAIL)
        by vger.kernel.org with ESMTP id S1726228AbgEOVf5 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 15 May 2020 17:35:57 -0400
Received: from mail-yb1-xb43.google.com (mail-yb1-xb43.google.com [IPv6:2607:f8b0:4864:20::b43])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id EE0B9C05BD09
        for <netdev@vger.kernel.org>; Fri, 15 May 2020 14:35:55 -0700 (PDT)
Received: by mail-yb1-xb43.google.com with SMTP id i16so1845656ybq.9
        for <netdev@vger.kernel.org>; Fri, 15 May 2020 14:35:55 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20161025;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=sVQVIr84sLsAtEf+Ll1fioJb9v8WVaNtHmGOv4kP0R8=;
        b=NfimAyTC/aIkfOHS2ufqPSllOkeKqp1ZK6kze94gN6kn1ADBKZD3dHs2eXsMiGzBR1
         15TmsMiq4KlpeHxxUJ5YdLeKyW23BftJ/gMJmVwlsAn9wcJ8hNxPhlPYwpt5prr5Plzx
         X43QaZjtrMfGtVTJ/ubc6mkEj6Ge5py3FKjasFZ+0KDaHQnCgsGN1GjqHijFAE+tqSUr
         I0o2HfrLoen8lac1vJSzfPD+hjfINdbvGmnNZ+aYkTJtddLFqxcCrbqe6UPzgZVuVVHV
         xDLercuanoXp8rDUc6rnzIa3P8yb045tTQv7jF96E3NAAxmFtOEQvwlMc35NBfkuYpr+
         Seqg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=sVQVIr84sLsAtEf+Ll1fioJb9v8WVaNtHmGOv4kP0R8=;
        b=PpZjJF3LkZbW1d7d0nC9vswNfOEfcJBxi+24GHnH6X//AqeO85u/iukZh10DKyaAs1
         5mHX3Gg/sIxh9lbKyYPn/Cs96b4/YNxheheQhWFxnqFgmqsnQzf2yqD5S4jRQWsQvt9S
         0CvMZCiKB8nBk4ry2KoYxUOhc8i3Yr/XrVXo+fSKpj7PCfRsKMvWdeAiXpH0AFqaVd+I
         TI+cS22IpBset4NAs2y8R6s8OfhVdMhZ4KMwPGW8BRL8UA5T/12tmDUJEiQnQvbB86mC
         ubwsV5gZTsZmyyUfsC2Vg2v5DRRu2NcGzPsz8xdck1CAgHcWuC3aDVRwNET42RuceqsK
         eRTA==
X-Gm-Message-State: AOAM533ZIPqnkGnU+a8thIK+H1xXI2Ge4rXwqMoFR4utOHTyHsl4QCnB
        kQO8lzr2sqMvof6OwZmdFFq9VoeihtUUkOvYMYVlPg==
X-Google-Smtp-Source: ABdhPJzO8Z79WAQPa+P8cIWRu5FYqccxVpUsubtP/BCBp9spOPnwntRjPW/UivBlIqcTjuFF/pHj3glO1AKf2bwUZSU=
X-Received: by 2002:a25:d450:: with SMTP id m77mr9073716ybf.177.1589578554699;
 Fri, 15 May 2020 14:35:54 -0700 (PDT)
MIME-Version: 1.0
References: <20200515165007.217120-1-irogers@google.com> <20200515165007.217120-8-irogers@google.com>
 <20200515194115.GA3577540@krava>
In-Reply-To: <20200515194115.GA3577540@krava>
From:   Ian Rogers <irogers@google.com>
Date:   Fri, 15 May 2020 14:35:43 -0700
Message-ID: <CAP-5=fUp4ECBntUamWK53LhTbT9W5w5A0frFyOMxoWK0Q2o60A@mail.gmail.com>
Subject: Re: [PATCH v2 7/7] perf expr: Migrate expr ids table to a hashmap
To:     Jiri Olsa <jolsa@redhat.com>
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
Content-Type: text/plain; charset="UTF-8"
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Fri, May 15, 2020 at 12:41 PM Jiri Olsa <jolsa@redhat.com> wrote:
>
> On Fri, May 15, 2020 at 09:50:07AM -0700, Ian Rogers wrote:
>
> SNIP
>
> > diff --git a/tools/perf/util/metricgroup.c b/tools/perf/util/metricgroup.c
> > index b071df373f8b..37be5a368d6e 100644
> > --- a/tools/perf/util/metricgroup.c
> > +++ b/tools/perf/util/metricgroup.c
> > @@ -85,8 +85,7 @@ static void metricgroup__rblist_init(struct rblist *metric_events)
> >
> >  struct egroup {
> >       struct list_head nd;
> > -     int idnum;
> > -     const char **ids;
> > +     struct expr_parse_ctx pctx;
> >       const char *metric_name;
> >       const char *metric_expr;
> >       const char *metric_unit;
> > @@ -94,19 +93,21 @@ struct egroup {
> >  };
> >
> >  static struct evsel *find_evsel_group(struct evlist *perf_evlist,
> > -                                   const char **ids,
> > -                                   int idnum,
> > +                                   struct expr_parse_ctx *pctx,
> >                                     struct evsel **metric_events,
> >                                     bool *evlist_used)
> >  {
> >       struct evsel *ev;
> > -     int i = 0, j = 0;
> >       bool leader_found;
> > +     const size_t idnum = hashmap__size(&pctx->ids);
> > +     size_t i = 0;
> > +     int j = 0;
> > +     double *val_ptr;
> >
> >       evlist__for_each_entry (perf_evlist, ev) {
> >               if (evlist_used[j++])
> >                       continue;
> > -             if (!strcmp(ev->name, ids[i])) {
> > +             if (hashmap__find(&pctx->ids, ev->name, (void **)&val_ptr)) {
>
> hum, you sure it's doing the same thing as before?
>
> hashmap__find will succede all the time in here, while the
> previous code was looking for the start of the group ...
> the logic in here is little convoluted, so maybe I'm
> missing some point in here ;-)

If we have a metric like "A + B" and another like "C / D" then by
we'll generate a string (the extra_events strbuf in the code) like
"{A,B}:W,{C,D}:W" from __metricgroup__add_metric. This will turn into
an evlist in metricgroup__parse_groups of A,B,C,D. The code is trying
to associate the events A,B with the first metric and C,D with the
second. The code doesn't support sharing of events and events are
marked as used and can't be part of other metrics. The evlist order is
also reflective of the order of metrics, so if there were metrics "A +
B + C" and "A + B", as the first metric is first in the evlist we
don't run the risk of C being placed with A and B in a different
group.

The old code used the order of events to match within a metric and say
for metric "A+B+C" we want to match A then B, and so on. The new code
acts more like a set, so "A + B + C" becomes a set containing A, B and
C, we check A is in the set then B and then C. For both pieces of code
they are only working because of the evlist_used "bitmap" and that the
order in the evlists and metrics matches.

The current code could just use ordering to match first n1 events with
the first metric, the next n2 events with the second and so on. So
both the find now, and the strcmp before always return true in this
branch.

In the RFC patch set I want to share events and so I do checks related
to the group leader so that I know when moving from one group to
another in the evlist. The find/strcmp becomes load bearing as I will
re-use events as long as they match.
https://lore.kernel.org/lkml/20200508053629.210324-14-irogers@google.com/

> jirka
>
> >                       if (!metric_events[i])
> >                               metric_events[i] = ev;
> >                       i++;
> > @@ -118,7 +119,8 @@ static struct evsel *find_evsel_group(struct evlist *perf_evlist,
> >                       memset(metric_events, 0,
> >                               sizeof(struct evsel *) * idnum);

This re-check was unnecessary in the old code and unnecessary even
more so now as the hashmap_find is given exactly the same arguments.
I'll remove it in v3 while addressing Andrii's memory leak fixes.

Thanks,
Ian

> > -                     if (!strcmp(ev->name, ids[i])) {
> > +                     if (hashmap__find(&pctx->ids, ev->name,
> > +                                       (void **)&val_ptr)) {
> >                               if (!metric_events[i])
> >                                       metric_events[i] = ev;
>
> SNIP
>
