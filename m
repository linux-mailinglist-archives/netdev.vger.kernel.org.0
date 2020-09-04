Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id A386325DFB8
	for <lists+netdev@lfdr.de>; Fri,  4 Sep 2020 18:22:36 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727800AbgIDQW1 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 4 Sep 2020 12:22:27 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:49602 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726733AbgIDQWZ (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 4 Sep 2020 12:22:25 -0400
Received: from mail-wr1-x444.google.com (mail-wr1-x444.google.com [IPv6:2a00:1450:4864:20::444])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id B0D82C061246
        for <netdev@vger.kernel.org>; Fri,  4 Sep 2020 09:22:23 -0700 (PDT)
Received: by mail-wr1-x444.google.com with SMTP id a17so7301781wrn.6
        for <netdev@vger.kernel.org>; Fri, 04 Sep 2020 09:22:23 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20161025;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=iUBmsm1x2IjnP/vvaMS9kAvkCHrQJaf0jWdnYFgluME=;
        b=pM4zSYEDH8rIALEQFgas6IpcrK9Kwnfi0QTIA+JO1xCa+et9UJk/Y5Uja1ezkn37Hu
         E56ZnTwuPhX33oHp0FNw9Ku43IDcnxNe6YfpoGyk+5c2+FZKe4x9gUkn2ZEFCpv6fEwy
         6r1bmx7G3efw7aVCikhg9ESQgCiEe6+PgKBCy5s2hVeBlVLUvpg2IMQ+eUpLpk2Q3da9
         XcMZOTIC2SaQJP8HTUuJXiyu6gol5/gm+ZXZdS8Hz+E0Nh99XY6bY4BsvYwIii+S16OK
         0IjjpP3RCLCn3VdHVSTNju8NoBPA3JNpUkfwz9po5oXprvtgF4qjPsScxIzhJxNiNTzK
         hv7Q==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=iUBmsm1x2IjnP/vvaMS9kAvkCHrQJaf0jWdnYFgluME=;
        b=iDYtD1bFHVzt3Jt8LORLC4ebnk571PRO20q4vW1vmrLeed6OiT3K4mVez0soNiZDVE
         MIA4Wp1QTvLFAgDTD13YJ6IetGIxKDs5khk85L3WWnmuqcOfZsNYo4lq2r41ffRzgiwe
         b1FxYzX5nu9RxXyRLQnfU1sKPAobnbD3cWDdoYQjwldRqqh1wB7PWKzxNspiAAH9MoWl
         n96098dKGPvaAGrd2HsXX+3xmLa4bIHocMVoimELyjPZqqdZMCALUnCfrSnWpNVcoN5P
         UYneHimbQ1TS4XXBjwxc7sLCsOsmNZqzZ6z7WDnUA/pbhoBr8OlOqdgGcCml+gdVSEEH
         SOig==
X-Gm-Message-State: AOAM533QtcTcZC0ZZkWwGkCrHkIF+jDVSXLznzWfUchxPwaW3q8gBMRA
        Wlk8/oriUQZyRb9J9qtLmTAZbquWSATsn7OwR5sLzA==
X-Google-Smtp-Source: ABdhPJySfIz8aAcQ9J1AamPC0cWNdBGNAI75Wc0N8M5+kih7VPDyB0ZJhly7HEz5L6PjHFBOXOFNgYbe/rcGjkqCQKg=
X-Received: by 2002:adf:f88b:: with SMTP id u11mr8134820wrp.376.1599236542160;
 Fri, 04 Sep 2020 09:22:22 -0700 (PDT)
MIME-Version: 1.0
References: <20200728085734.609930-1-irogers@google.com> <20200728085734.609930-3-irogers@google.com>
 <20200728155940.GC1319041@krava> <20200728160954.GD1319041@krava>
 <CAP-5=fVqto0LrwgW6dHQupp7jFA3wToRBonBaXXQW4wwYcTreg@mail.gmail.com>
 <CAP-5=fWNniZuYfYhz_Cz7URQ+2E4T4Kg3DJqGPtDg70i38Er_A@mail.gmail.com> <20200904160303.GD939481@krava>
In-Reply-To: <20200904160303.GD939481@krava>
From:   Ian Rogers <irogers@google.com>
Date:   Fri, 4 Sep 2020 09:22:10 -0700
Message-ID: <CAP-5=fWOSi4B3g1DARkh6Di-gU4FgmjnhbPYRBdvSdLSy_KC5Q@mail.gmail.com>
Subject: Re: [PATCH v2 2/5] perf record: Prevent override of
 attr->sample_period for libpfm4 events
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
        Adrian Hunter <adrian.hunter@intel.com>,
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

On Fri, Sep 4, 2020 at 9:03 AM Jiri Olsa <jolsa@redhat.com> wrote:
>
> On Thu, Sep 03, 2020 at 10:41:14PM -0700, Ian Rogers wrote:
> > On Wed, Jul 29, 2020 at 4:24 PM Ian Rogers <irogers@google.com> wrote:
> > >
> > > On Tue, Jul 28, 2020 at 9:10 AM Jiri Olsa <jolsa@redhat.com> wrote:
> > > >
> > > > On Tue, Jul 28, 2020 at 05:59:46PM +0200, Jiri Olsa wrote:
> > > > > On Tue, Jul 28, 2020 at 01:57:31AM -0700, Ian Rogers wrote:
> > > > > > From: Stephane Eranian <eranian@google.com>
> > > > > >
> > > > > > Before:
> > > > > > $ perf record -c 10000 --pfm-events=cycles:period=77777
> > > > > >
> > > > > > Would yield a cycles event with period=10000, instead of 77777.
> > > > > >
> > > > > > This was due to an ordering issue between libpfm4 parsing
> > > > > > the event string and perf record initializing the event.
> > > > > >
> > > > > > This patch fixes the problem by preventing override for
> > > > > > events with attr->sample_period != 0 by the time
> > > > > > perf_evsel__config() is invoked. This seems to have been the
> > > > > > intent of the author.
> > > > > >
> > > > > > Signed-off-by: Stephane Eranian <eranian@google.com>
> > > > > > Reviewed-by: Ian Rogers <irogers@google.com>
> > > > > > ---
> > > > > >  tools/perf/util/evsel.c | 3 +--
> > > > > >  1 file changed, 1 insertion(+), 2 deletions(-)
> > > > > >
> > > > > > diff --git a/tools/perf/util/evsel.c b/tools/perf/util/evsel.c
> > > > > > index 811f538f7d77..8afc24e2ec52 100644
> > > > > > --- a/tools/perf/util/evsel.c
> > > > > > +++ b/tools/perf/util/evsel.c
> > > > > > @@ -976,8 +976,7 @@ void evsel__config(struct evsel *evsel, struct record_opts *opts,
> > > > > >      * We default some events to have a default interval. But keep
> > > > > >      * it a weak assumption overridable by the user.
> > > > > >      */
> > > > > > -   if (!attr->sample_period || (opts->user_freq != UINT_MAX ||
> > > > > > -                                opts->user_interval != ULLONG_MAX)) {
> > > > > > +   if (!attr->sample_period) {
> > > > >
> > > > > I was wondering why this wouldn't break record/top
> > > > > but we take care of the via record_opts__config
> > > > >
> > > > > as long as 'perf test attr' works it looks ok to me
> > > >
> > > > hum ;-)
> > > >
> > > > [jolsa@krava perf]$ sudo ./perf test 17 -v
> > > > 17: Setup struct perf_event_attr                          :
> > > > ...
> > > > running './tests/attr/test-record-C0'
> > > > expected sample_period=4000, got 3000
> > > > FAILED './tests/attr/test-record-C0' - match failure
> > >
> > > I'm not able to reproduce this. Do you have a build configuration or
> > > something else to look at? The test doesn't seem obviously connected
> > > with this patch.
> > >
> > > Thanks,
> > > Ian
> >
> > Jiri, any update? Thanks,
>
> sorry, I rebased and ran it again and it passes for me now,
> so it got fixed along the way

No worries, thanks for the update! It'd be nice to land this and the
other libpfm fixes.

Ian

> jirka
>
