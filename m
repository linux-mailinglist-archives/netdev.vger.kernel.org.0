Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id C6118E5061
	for <lists+netdev@lfdr.de>; Fri, 25 Oct 2019 17:47:32 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2395519AbfJYPr3 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 25 Oct 2019 11:47:29 -0400
Received: from mail-wr1-f66.google.com ([209.85.221.66]:41046 "EHLO
        mail-wr1-f66.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S2395503AbfJYPr2 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 25 Oct 2019 11:47:28 -0400
Received: by mail-wr1-f66.google.com with SMTP id p4so2877607wrm.8
        for <netdev@vger.kernel.org>; Fri, 25 Oct 2019 08:47:26 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20161025;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=fo4JPUIMC83Jn+ORQE5fOd6wpwt98Yvm2b1ZRTBSf+k=;
        b=ga91dKJkyn2cOlf6giFVU0C2YNUeJjkbLh3Pf3h4sZyinbRfzD7EcS4kSgvNA7jtgf
         XR9TrWWx1kOpavXYRxxIkwm6ScKXIyQya+vNCwa9XP+O9Fq87NVlIJdwQqN/s9Lelej7
         HAOZ2MPW35Q9izjXjt9YvVa5kdHq6dfJvHcYdWY30LImx8kCmyfVu34FUTzxPYTmGvBJ
         1+h1S2xkNz3WABifyH13EHHjE6fihQTe/9XOKtDc+A6Lo2iGMM537BwN1GpIajQTXgGG
         F79oiTBy04YTWxY2gLNpis442uOF/suSwKB6d/qIz576NKM+R8PZbesZaPVhJyGJHsMc
         nJdA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=fo4JPUIMC83Jn+ORQE5fOd6wpwt98Yvm2b1ZRTBSf+k=;
        b=PI5EodtWUtcqL1KGVxHhnrOLjdZ9L2kOsMaXT0a7mmrF0v9d1ciChDEFZLBsos8r2h
         84H4Krf5gQderbHixAsjDIkD3XauEUZSfO8v7dChnRtuU2epz5IK+3MTYzoLsH98KkG5
         XTVLUgWjiWMXt0gCajEvuVk8AATCI71YQa416UDKjcgAKzvBCkB20Z5fshDiQ/lsAiTv
         manT1Eb6+AvIbLCSGZYPKCfQYB08R92R69Tutn39cSaShzf0NWqboqPIC8dI6FUPqXIw
         wl53Iso1IlJXofKiicPH0NfP5VNheEOzLoSYwzrhf5MB4/r5foqs6z7B62Zu/PNSEOsZ
         iW9g==
X-Gm-Message-State: APjAAAWywxO86akKvvFjg/OPQ33ugX5aVBewNtZlEeV2VrfSZyCoIkvs
        UKMz1ydGldQn92rTLGNXkepojFQh33VG7Y1onLoCbg==
X-Google-Smtp-Source: APXvYqwwkfHhZltSUACukXwYTKWvdIaDOhOctFQxNvUMIYQ3giUfUnfKv7ozh5lgMUz3hiL/7aAkS7f/pWM26k1Sqd8=
X-Received: by 2002:adf:e651:: with SMTP id b17mr3130375wrn.191.1572018445122;
 Fri, 25 Oct 2019 08:47:25 -0700 (PDT)
MIME-Version: 1.0
References: <20191023005337.196160-1-irogers@google.com> <20191024190202.109403-1-irogers@google.com>
 <20191024190202.109403-3-irogers@google.com> <20191025080142.GF31679@krava>
In-Reply-To: <20191025080142.GF31679@krava>
From:   Ian Rogers <irogers@google.com>
Date:   Fri, 25 Oct 2019 08:47:12 -0700
Message-ID: <CAP-5=fWoHN9wqWasZyyu8mB99-1SOP3NhTT9XX6d99aTG6-AOA@mail.gmail.com>
Subject: Re: [PATCH v3 2/9] perf tools: splice events onto evlist even on error
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
        Andi Kleen <ak@linux.intel.com>,
        Jin Yao <yao.jin@linux.intel.com>,
        Adrian Hunter <adrian.hunter@intel.com>,
        Kan Liang <kan.liang@linux.intel.com>,
        John Garry <john.garry@huawei.com>,
        LKML <linux-kernel@vger.kernel.org>, netdev@vger.kernel.org,
        bpf@vger.kernel.org,
        clang-built-linux <clang-built-linux@googlegroups.com>,
        Stephane Eranian <eranian@google.com>
Content-Type: text/plain; charset="UTF-8"
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Fri, Oct 25, 2019 at 1:01 AM Jiri Olsa <jolsa@redhat.com> wrote:
>
> On Thu, Oct 24, 2019 at 12:01:55PM -0700, Ian Rogers wrote:
> > If event parsing fails the event list is leaked, instead splice the list
> > onto the out result and let the caller cleanup.
> >
> > An example input for parse_events found by libFuzzer that reproduces
> > this memory leak is 'm{'.
> >
> > Signed-off-by: Ian Rogers <irogers@google.com>
> > ---
> >  tools/perf/util/parse-events.c | 17 +++++++++++------
> >  1 file changed, 11 insertions(+), 6 deletions(-)
> >
> > diff --git a/tools/perf/util/parse-events.c b/tools/perf/util/parse-events.c
> > index edb3ae76777d..f0d50f079d2f 100644
> > --- a/tools/perf/util/parse-events.c
> > +++ b/tools/perf/util/parse-events.c
> > @@ -1968,15 +1968,20 @@ int parse_events(struct evlist *evlist, const char *str,
> >
> >       ret = parse_events__scanner(str, &parse_state, PE_START_EVENTS);
> >       perf_pmu__parse_cleanup();
> > +
> > +     if (!ret && list_empty(&parse_state.list)) {
> > +             WARN_ONCE(true, "WARNING: event parser found nothing\n");
> > +             return -1;
> > +     }
> > +
> > +     /*
> > +      * Add list to the evlist even with errors to allow callers to clean up.
> > +      */
> > +     perf_evlist__splice_list_tail(evlist, &parse_state.list);
>
> I still dont understand this one.. if there was an error, the list
> should be empty, right? also if there's an error and there's something
> on the list, what is it? how it gets deleted?
>
> thanks,
> jirka

What I see happening with PARSER_DEBUG for 'm{' is (I've tried to
manually tweak the line numbers to be consistent with the current
parse-events.y, sorry for any discrepancies):

Starting parse
Entering state 0
Reading a token: Next token is token PE_START_EVENTS (1.1: )
Shifting token PE_START_EVENTS (1.1: )
Entering state 1
Reading a token: Next token is token PE_EVENT_NAME (1.0: )
Shifting token PE_EVENT_NAME (1.0: )
Entering state 8
Reading a token: Next token is token PE_NAME (1.0: )
Shifting token PE_NAME (1.0: )
Entering state 46
Reading a token: Next token is token '{' (1.1: )
Reducing stack by rule 50 (line 510):
-> $$ = nterm opt_event_config (1.0: )
Stack now 0 1 8 46
Entering state 51
Reducing stack by rule 27 (line 229):
  $1 = token PE_NAME (1.0: )
  $2 = nterm opt_event_config (1.0: )
-> $$ = nterm event_pmu (1.0: )
Stack now 0 1 8
Entering state 25
Reducing stack by rule 19 (line 219):
  $1 = nterm event_pmu (1.0: )
-> $$ = nterm event_def (1.0: )
Stack now 0 1 8
Entering state 47
Reducing stack by rule 17 (line 210):
  $1 = token PE_EVENT_NAME (1.0: )
  $2 = nterm event_def (1.0: )
-> $$ = nterm event_name (1.0: )
Stack now 0 1
Entering state 23
Next token is token '{' (1.1: )
Reducing stack by rule 16 (line 207):
  $1 = nterm event_name (1.0: )
-> $$ = nterm event_mod (1.0: )
Stack now 0 1
Entering state 22
Reducing stack by rule 14 (line 191):
  $1 = nterm event_mod (1.0: )
-> $$ = nterm event (1.0: )
Stack now 0 1
Entering state 21
Reducing stack by rule 7 (line 147):
  $1 = nterm event (1.0: )
-> $$ = nterm groups (1.0: )
Stack now 0 1
Entering state 18
Next token is token '{' (1.1: )
Reducing stack by rule 3 (line 119):
  $1 = nterm groups (1.0: )
-> $$ = nterm start_events (1.0: )
Stack now 0 1
Entering state 17
Reducing stack by rule 1 (line 115):
  $1 = token PE_START_EVENTS (1.1: )
  $2 = nterm start_events (1.0: )
-> $$ = nterm start (1.1: )
Stack now 0
Entering state 3
Next token is token '{' (1.1: )
Error: popping nterm start (1.1: )
Stack now 0
Cleanup: discarding lookahead token '{' (1.1: )
Stack now 0

Working backward through this we're going:
start: PE_START_EVENTS start_events
https://github.com/torvalds/linux/blob/master/tools/perf/util/parse-events.y#L115

start_events: groups
{
struct parse_events_state *parse_state = _parse_state;
parse_events_update_lists($1, &parse_state->list); // <--- where list
gets onto the state
}
https://github.com/torvalds/linux/blob/master/tools/perf/util/parse-events.y#L119

groups: event
https://github.com/torvalds/linux/blob/master/tools/perf/util/parse-events.y#L147

event: event_mod
https://github.com/torvalds/linux/blob/master/tools/perf/util/parse-events.y#L191

event_mod: event_name
https://github.com/torvalds/linux/blob/master/tools/perf/util/parse-events.y#L207

event_name: PE_EVENT_NAME event_def
https://github.com/torvalds/linux/blob/master/tools/perf/util/parse-events.y#L210

event_def: event_pmu
https://github.com/torvalds/linux/blob/master/tools/perf/util/parse-events.y#L219

event_pmu: PE_NAME opt_event_config
{
...
ALLOC_LIST(list);  // <--- where list gets allocated
...
https://github.com/torvalds/linux/blob/master/tools/perf/util/parse-events.y#L229

opt_event_config:
https://github.com/torvalds/linux/blob/master/tools/perf/util/parse-events.y#L510

So the parse_state is ending up with a list, however, parsing is
failing. If the list isn't adding to the evlist then it becomes a
leak. Splicing it onto the evlist allows the caller to clean this up
and avoids the leak. An alternate approach is to free the failed list
and not get the caller to clean up. A way to do this is to create an
evlist, splice the failed list onto it and then free it - which winds
up being fairly identical to this approach, and this approach is a
smaller change.

Thanks,
Ian

> > +
> >       if (!ret) {
> >               struct evsel *last;
> >
> > -             if (list_empty(&parse_state.list)) {
> > -                     WARN_ONCE(true, "WARNING: event parser found nothing\n");
> > -                     return -1;
> > -             }
> > -
> > -             perf_evlist__splice_list_tail(evlist, &parse_state.list);
> >               evlist->nr_groups += parse_state.nr_groups;
> >               last = evlist__last(evlist);
> >               last->cmdline_group_boundary = true;
> > --
> > 2.23.0.866.gb869b98d4c-goog
> >
>
