Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 48B0D40CE72
	for <lists+netdev@lfdr.de>; Wed, 15 Sep 2021 22:56:35 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232168AbhIOU5v (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 15 Sep 2021 16:57:51 -0400
Received: from mail.kernel.org ([198.145.29.99]:43720 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S231830AbhIOU5t (ORCPT <rfc822;netdev@vger.kernel.org>);
        Wed, 15 Sep 2021 16:57:49 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id 549B06108F;
        Wed, 15 Sep 2021 20:56:29 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1631739389;
        bh=pBGc6MBPlKmkYJWBqJlD5hd44E7P23W0e7q7BSRmPAg=;
        h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
        b=gdelZNiZUfwtatkAqqlDS+KgxqYlzfFAGkky5/chQnW925kMBiym+E7CESFMuS2oP
         ZeVHIAbY2L6Yxe2aWUH3HTuNb+cY5xuHubt6aDW157N2m744v6no2zmmwP471++hjA
         kbo++TRHNhRO6B4b8BxGuv3iWnHuWuVUBG+K17cLMNBWSpCx5jgBd8t/U4K5vc+Jfu
         JZVzGxJoE+EhcUGhxZoeBGAp43b54VMdKX1wUbd9NSiXdtWRDbZy3RGHYize1VR/GB
         Osmrp14v5ZtDFYfqzLzxS3OL2lIOEx5mjL+4NiA3G93jusVnA3igALWNRH9m358/tx
         q8rFkSPYqhCvg==
Received: by quaco.ghostprotocols.net (Postfix, from userid 1000)
        id 40F894038F; Wed, 15 Sep 2021 17:56:26 -0300 (-03)
Date:   Wed, 15 Sep 2021 17:56:26 -0300
From:   Arnaldo Carvalho de Melo <acme@kernel.org>
To:     Andrii Nakryiko <andrii.nakryiko@gmail.com>
Cc:     Muhammad Falak R Wani <falakreyaz@gmail.com>,
        Peter Zijlstra <peterz@infradead.org>,
        Ingo Molnar <mingo@redhat.com>,
        Alexei Starovoitov <ast@kernel.org>,
        Daniel Borkmann <daniel@iogearbox.net>,
        Andrii Nakryiko <andrii@kernel.org>,
        Mark Rutland <mark.rutland@arm.com>,
        Alexander Shishkin <alexander.shishkin@linux.intel.com>,
        Jiri Olsa <jolsa@redhat.com>,
        Namhyung Kim <namhyung@kernel.org>,
        Martin KaFai Lau <kafai@fb.com>,
        Song Liu <songliubraving@fb.com>,
        John Fastabend <john.fastabend@gmail.com>,
        KP Singh <kpsingh@kernel.org>,
        Quentin Monnet <quentin@isovalent.com>,
        Yu Kuai <yukuai3@huawei.com>,
        "linux-perf-use." <linux-perf-users@vger.kernel.org>,
        open list <linux-kernel@vger.kernel.org>,
        Networking <netdev@vger.kernel.org>, bpf <bpf@vger.kernel.org>
Subject: Re: [PATCH] perflib: deprecate bpf_map__resize in favor of
 bpf_map_set_max_entries
Message-ID: <YUJd+jo1W+mdK0Fv@kernel.org>
References: <20210815103610.27887-1-falakreyaz@gmail.com>
 <CAEf4BzZ+3hM9oPxdXsxXRKJD2TCmpXPnkWz1LPnP7mDagprdyA@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <CAEf4BzZ+3hM9oPxdXsxXRKJD2TCmpXPnkWz1LPnP7mDagprdyA@mail.gmail.com>
X-Url:  http://acmel.wordpress.com
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Em Mon, Aug 16, 2021 at 12:28:14PM -0700, Andrii Nakryiko escreveu:
> On Sun, Aug 15, 2021 at 3:36 AM Muhammad Falak R Wani
> <falakreyaz@gmail.com> wrote:
> >
> > As a part of libbpf 1.0 plan[0], this patch deprecates use of
> > bpf_map__resize in favour of bpf_map__set_max_entries.
> >
> > Reference: https://github.com/libbpf/libbpf/issues/304
> > [0]: https://github.com/libbpf/libbpf/wiki/Libbpf:-the-road-to-v1.0#libbpfh-high-level-apis
> >
> > Signed-off-by: Muhammad Falak R Wani <falakreyaz@gmail.com>
> > ---
> 
> All looks good, there is an opportunity to simplify the code a bit (see below).
> 
> Arnaldo, I assume you'll take this through your tree or you'd like us

Yeah, I'll take the opportunity to try to improve that detection of
libbpf version, etc.

- Arnaldo

> to take it through bpf-next?
> 
> Acked-by: Andrii Nakryiko <andrii@kernel.org>
> 
> >  tools/perf/util/bpf_counter.c        | 8 ++++----
> >  tools/perf/util/bpf_counter_cgroup.c | 8 ++++----
> >  2 files changed, 8 insertions(+), 8 deletions(-)
> >
> > diff --git a/tools/perf/util/bpf_counter.c b/tools/perf/util/bpf_counter.c
> > index ba0f20853651..ced2dac31dcf 100644
> > --- a/tools/perf/util/bpf_counter.c
> > +++ b/tools/perf/util/bpf_counter.c
> > @@ -127,9 +127,9 @@ static int bpf_program_profiler_load_one(struct evsel *evsel, u32 prog_id)
> >
> >         skel->rodata->num_cpu = evsel__nr_cpus(evsel);
> >
> > -       bpf_map__resize(skel->maps.events, evsel__nr_cpus(evsel));
> > -       bpf_map__resize(skel->maps.fentry_readings, 1);
> > -       bpf_map__resize(skel->maps.accum_readings, 1);
> > +       bpf_map__set_max_entries(skel->maps.events, evsel__nr_cpus(evsel));
> > +       bpf_map__set_max_entries(skel->maps.fentry_readings, 1);
> > +       bpf_map__set_max_entries(skel->maps.accum_readings, 1);
> >
> >         prog_name = bpf_target_prog_name(prog_fd);
> >         if (!prog_name) {
> > @@ -399,7 +399,7 @@ static int bperf_reload_leader_program(struct evsel *evsel, int attr_map_fd,
> >                 return -1;
> >         }
> >
> > -       bpf_map__resize(skel->maps.events, libbpf_num_possible_cpus());
> > +       bpf_map__set_max_entries(skel->maps.events, libbpf_num_possible_cpus());
> 
> If you set max_entries to 0 (or just skip specifying it) for events
> map in util/bpf_skel/bperf_cgroup.bpf.c, you won't need to resize it,
> libbpf will automatically size it to number of possible CPUs.
> 
> >         err = bperf_leader_bpf__load(skel);
> >         if (err) {
> >                 pr_err("Failed to load leader skeleton\n");
> > diff --git a/tools/perf/util/bpf_counter_cgroup.c b/tools/perf/util/bpf_counter_cgroup.c
> > index 89aa5e71db1a..cbc6c2bca488 100644
> > --- a/tools/perf/util/bpf_counter_cgroup.c
> > +++ b/tools/perf/util/bpf_counter_cgroup.c
> > @@ -65,14 +65,14 @@ static int bperf_load_program(struct evlist *evlist)
> >
> >         /* we need one copy of events per cpu for reading */
> >         map_size = total_cpus * evlist->core.nr_entries / nr_cgroups;
> > -       bpf_map__resize(skel->maps.events, map_size);
> > -       bpf_map__resize(skel->maps.cgrp_idx, nr_cgroups);
> > +       bpf_map__set_max_entries(skel->maps.events, map_size);
> > +       bpf_map__set_max_entries(skel->maps.cgrp_idx, nr_cgroups);
> >         /* previous result is saved in a per-cpu array */
> >         map_size = evlist->core.nr_entries / nr_cgroups;
> > -       bpf_map__resize(skel->maps.prev_readings, map_size);
> > +       bpf_map__set_max_entries(skel->maps.prev_readings, map_size);
> >         /* cgroup result needs all events (per-cpu) */
> >         map_size = evlist->core.nr_entries;
> > -       bpf_map__resize(skel->maps.cgrp_readings, map_size);
> > +       bpf_map__set_max_entries(skel->maps.cgrp_readings, map_size);
> >
> >         set_max_rlimit();
> >
> > --
> > 2.17.1
> >

-- 

- Arnaldo
