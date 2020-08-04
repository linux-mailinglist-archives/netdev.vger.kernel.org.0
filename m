Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id B614A23BB31
	for <lists+netdev@lfdr.de>; Tue,  4 Aug 2020 15:34:12 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726282AbgHDNeB (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 4 Aug 2020 09:34:01 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:48806 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1725864AbgHDNeB (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 4 Aug 2020 09:34:01 -0400
Received: from mail-wm1-x343.google.com (mail-wm1-x343.google.com [IPv6:2a00:1450:4864:20::343])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id D0F1FC06174A
        for <netdev@vger.kernel.org>; Tue,  4 Aug 2020 06:34:00 -0700 (PDT)
Received: by mail-wm1-x343.google.com with SMTP id g8so2703405wmk.3
        for <netdev@vger.kernel.org>; Tue, 04 Aug 2020 06:34:00 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20161025;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=J1/mYzIP2hMyjkq4qwIx7vKFLfGV8E9+xnljo9oNBug=;
        b=g2//3kmYqQevKfe9SCxyV6EZhOfaU+P+Cy9nDkqvNsV+5/24wqAVcu/5670F9bItAF
         kZ+KpSx8MmOK7MWb1gK9gTffVBJKT3jM2ZYsXwG+DAgcDPTTCOWQuj/I5vNUXZthINh0
         xHNQzGNUPZHfw/KK7oFFwG2obkokd6owf3M6AJiffKH4bsQYpX+DpisRtrdhYpxeR84P
         QDR1ZTwEsRgQ+EGJmjqhRRBjqaSsk7rK9/1z0oYSCbxox9ByTlQKYcyRhu4/RhiRuV4T
         btE6hTKn6Qd1gaziphYJ3e1eH3H7jANcKyBQJXIDcnYdDcwxDRPdrxcXVA8bcUYL69l/
         VVSA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=J1/mYzIP2hMyjkq4qwIx7vKFLfGV8E9+xnljo9oNBug=;
        b=WSU4vJkWv9vsyFA096x3EqlFs3ga92ygs96jauAku6Z7A4hhPDpl20nhIAkoE1IbkW
         8DY/zzVIg1t0pvSYCXVM98+vKHF2Gb24mCTM5hCM1qqonu+bKfMeiWobNxQijH/5gnWh
         Z5ARXxD+lt7YI10N8bEwkd2AKMdoT+8vitZJylBt1n769eEfXnC+v4Znn0EvBfk9uxbi
         /kSEP0u37eqDeI5iX8LZJaj1jwTEcus8DTVGBvDKOtmWU1Ypv/v5g/asMH/7mQMn5z4v
         r2xfwS1JrVlCjUL0td1daoZFkjDgXLXpOp8ktki3KEtQyURuw5ixisdsEpD/BFaWW95v
         J9SQ==
X-Gm-Message-State: AOAM530mpo32uZ0iMeGMcALoS0SevEwjHWn7noDCFW7cMicMWZtEvJ3k
        Z368Ef4V8Ey/GQ7QbAvIuaEd/tGn3R18pECVkdaU2Q==
X-Google-Smtp-Source: ABdhPJxAjw5E9Gzy3aeP53ZI+pqeCPa5gfx7N9vxRRtQkTi2sm8CbIjAo67QAvYWwoPiNQ7r1jW389h/z4hP4PYpkxw=
X-Received: by 2002:a1c:e0c2:: with SMTP id x185mr4073668wmg.124.1596548039304;
 Tue, 04 Aug 2020 06:33:59 -0700 (PDT)
MIME-Version: 1.0
References: <20200728085734.609930-1-irogers@google.com> <20200728085734.609930-5-irogers@google.com>
 <969ef797-59ea-69d0-24b9-33bcdff106a1@intel.com>
In-Reply-To: <969ef797-59ea-69d0-24b9-33bcdff106a1@intel.com>
From:   Ian Rogers <irogers@google.com>
Date:   Tue, 4 Aug 2020 06:33:47 -0700
Message-ID: <CAP-5=fUCnBGX0L0Tt3_gmVnt+hvaouJMx6XFErFKk72+xuw9fw@mail.gmail.com>
Subject: Re: [PATCH v2 4/5] perf record: Don't clear event's period if set by
 a term
To:     Adrian Hunter <adrian.hunter@intel.com>
Cc:     Peter Zijlstra <peterz@infradead.org>,
        Ingo Molnar <mingo@redhat.com>,
        Arnaldo Carvalho de Melo <acme@kernel.org>,
        Mark Rutland <mark.rutland@arm.com>,
        Alexander Shishkin <alexander.shishkin@linux.intel.com>,
        Jiri Olsa <jolsa@redhat.com>,
        Namhyung Kim <namhyung@kernel.org>,
        Alexei Starovoitov <ast@kernel.org>,
        Daniel Borkmann <daniel@iogearbox.net>,
        Martin KaFai Lau <kafai@fb.com>,
        Song Liu <songliubraving@fb.com>, Yonghong Song <yhs@fb.com>,
        Andrii Nakryiko <andriin@fb.com>,
        John Fastabend <john.fastabend@gmail.com>,
        KP Singh <kpsingh@chromium.org>,
        Andi Kleen <ak@linux.intel.com>,
        Athira Rajeev <atrajeev@linux.vnet.ibm.com>,
        LKML <linux-kernel@vger.kernel.org>,
        Networking <netdev@vger.kernel.org>, bpf <bpf@vger.kernel.org>,
        Stephane Eranian <eranian@google.com>
Content-Type: text/plain; charset="UTF-8"
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Tue, Aug 4, 2020 at 3:08 AM Adrian Hunter <adrian.hunter@intel.com> wrote:
>
> On 28/07/20 11:57 am, Ian Rogers wrote:
> > If events in a group explicitly set a frequency or period with leader
> > sampling, don't disable the samples on those events.
> >
> > Prior to 5.8:
> > perf record -e '{cycles/period=12345000/,instructions/period=6789000/}:S'
>
> Might be worth explaining this use-case some more.
> Perhaps add it to the leader sampling documentation for perf-list.
>
> > would clear the attributes then apply the config terms. In commit
> > 5f34278867b7 leader sampling configuration was moved to after applying the
> > config terms, in the example, making the instructions' event have its period
> > cleared.
> > This change makes it so that sampling is only disabled if configuration
> > terms aren't present.
> >
> > Fixes: 5f34278867b7 ("perf evlist: Move leader-sampling configuration")
> > Signed-off-by: Ian Rogers <irogers@google.com>
> > ---
> >  tools/perf/util/record.c | 28 ++++++++++++++++++++--------
> >  1 file changed, 20 insertions(+), 8 deletions(-)
> >
> > diff --git a/tools/perf/util/record.c b/tools/perf/util/record.c
> > index a4cc11592f6b..01d1c6c613f7 100644
> > --- a/tools/perf/util/record.c
> > +++ b/tools/perf/util/record.c
> > @@ -2,6 +2,7 @@
> >  #include "debug.h"
> >  #include "evlist.h"
> >  #include "evsel.h"
> > +#include "evsel_config.h"
> >  #include "parse-events.h"
> >  #include <errno.h>
> >  #include <limits.h>
> > @@ -38,6 +39,9 @@ static void evsel__config_leader_sampling(struct evsel *evsel, struct evlist *ev
> >       struct perf_event_attr *attr = &evsel->core.attr;
> >       struct evsel *leader = evsel->leader;
> >       struct evsel *read_sampler;
> > +     struct evsel_config_term *term;
> > +     struct list_head *config_terms = &evsel->config_terms;
> > +     int term_types, freq_mask;
> >
> >       if (!leader->sample_read)
> >               return;
> > @@ -47,16 +51,24 @@ static void evsel__config_leader_sampling(struct evsel *evsel, struct evlist *ev
> >       if (evsel == read_sampler)
> >               return;
> >
> > +     /* Determine the evsel's config term types. */
> > +     term_types = 0;
> > +     list_for_each_entry(term, config_terms, list) {
> > +             term_types |= 1 << term->type;
> > +     }
> >       /*
> > -      * Disable sampling for all group members other than the leader in
> > -      * case the leader 'leads' the sampling, except when the leader is an
> > -      * AUX area event, in which case the 2nd event in the group is the one
> > -      * that 'leads' the sampling.
> > +      * Disable sampling for all group members except those with explicit
> > +      * config terms or the leader. In the case of an AUX area event, the 2nd
> > +      * event in the group is the one that 'leads' the sampling.
> >        */
> > -     attr->freq           = 0;
> > -     attr->sample_freq    = 0;
> > -     attr->sample_period  = 0;
> > -     attr->write_backward = 0;
> > +     freq_mask = (1 << EVSEL__CONFIG_TERM_FREQ) | (1 << EVSEL__CONFIG_TERM_PERIOD);
> > +     if ((term_types & freq_mask) == 0) {
>
> It would be nicer to have a helper e.g.
>
>         if (!evsel__have_config_term(evsel, FREQ) &&
>             !evsel__have_config_term(evsel, PERIOD)) {

Sure. The point of doing it this way was to avoid repeatedly iterating
over the config term list.

> > +             attr->freq           = 0;
> > +             attr->sample_freq    = 0;
> > +             attr->sample_period  = 0;
>
> If we are not sampling, then maybe we should also put here:
>
>                 attr->write_backward = 0;
>
> > +     }
>
> Then, if we are sampling this evsel shouldn't the backward setting
> match the leader? e.g.
>
>         if (attr->sample_freq)
>                 attr->write_backward = leader->core.attr.write_backward;

Perhaps that should be a follow up change? This change is trying to
make the behavior match the previous behavior.

Thanks,
Ian

> > +     if ((term_types & (1 << EVSEL__CONFIG_TERM_OVERWRITE)) == 0)
> > +             attr->write_backward = 0;
> >
> >       /*
> >        * We don't get a sample for slave events, we make them when delivering
> >
>
