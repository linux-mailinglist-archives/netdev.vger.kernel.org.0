Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id A99AB4EA203
	for <lists+netdev@lfdr.de>; Mon, 28 Mar 2022 22:52:13 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S244465AbiC1Uxw (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 28 Mar 2022 16:53:52 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:34456 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1345728AbiC1Uws (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 28 Mar 2022 16:52:48 -0400
Received: from mail-ua1-x92b.google.com (mail-ua1-x92b.google.com [IPv6:2607:f8b0:4864:20::92b])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id DEB651EAF0
        for <netdev@vger.kernel.org>; Mon, 28 Mar 2022 13:50:33 -0700 (PDT)
Received: by mail-ua1-x92b.google.com with SMTP id i26so6817014uap.6
        for <netdev@vger.kernel.org>; Mon, 28 Mar 2022 13:50:33 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20210112;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc:content-transfer-encoding;
        bh=ZW+N1z8CEv3LE1wD1qgx9rdQlxwgYO+dOMzOsexKCX0=;
        b=EZ4Pn1hyGJfqkjtJMJ5UzhBpoI2gcU/TfKZi1ib8vKfGTY6MjwmFDxB1vzUajMDh6r
         TUBWBheCGn0f953AUiliYyBkukL317XB7i0HxGCaXfHXW3FVatPgyA7FJ40NV6qQdcp+
         faVNa1Jrr4qqUs5Qi0iaqmtnaUVY84FzVvfk1d+DXnTm0Y30yvhZTJ0oViRoDkrJZZs+
         VuI0NwN55nl+a2fNtokkTecoZHXLSYLwoawshrcSRxsVd65zReJmVmEkg3ZuyGBaBpcU
         qGUzMf35+zwL3Z0AGLehyaFskCPlj8m2JZIBoZvRfXKM2ADgDaFTI/Ef8hS6tVGQUY6E
         SzDA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc:content-transfer-encoding;
        bh=ZW+N1z8CEv3LE1wD1qgx9rdQlxwgYO+dOMzOsexKCX0=;
        b=s3QiWfJEMFXYb3OVe+b4gQkmES2Jnamf68LbkLACkS137oLIDUwA/l6qBOD4BLRMtb
         al+wuBqUzScLIQ3XgNEZ8BSu3FSoUVR25fr4kGoZ2biSJ2IMISphTinidnHHAAZpaxC7
         j5CsNI+wxKLMn/uraYgcXxdL7RgdrrlJ7i3xwwOhnPYriTF65fpr1Z7bDcQFS8ykrCvx
         k2JBAPjvWtwCE+Bs5kg2O4s0X5dL6fsy2z2lSN5r6AzXiLIrizX3MfTSJ7zgFO/27Ij3
         iBk4YG0MFRRp/EubosMw9ZyNKyWcFc4Y955xvhR3j7W7F0jha8sIe5/m5STCX3RCz83E
         TfbA==
X-Gm-Message-State: AOAM530BZWiGi3QwA41V6orK9AkGec2mvhhHQ06lfoOVAHJ/Yz1gzEOT
        7+WC9YzPbyM1VRWXIsHP5DoiKRcN96llZ7cIALzsOg==
X-Google-Smtp-Source: ABdhPJxMT9lEACJwR6BGk5c3GR+mHlu2ceSmYd943xCDVaeRhZbnPX80uw9WgTMMk3TRehrA/j1015qLMdmvbyuQwtY=
X-Received: by 2002:a9f:2048:0:b0:352:9b4f:ac98 with SMTP id
 66-20020a9f2048000000b003529b4fac98mr12932950uam.12.1648500632715; Mon, 28
 Mar 2022 13:50:32 -0700 (PDT)
MIME-Version: 1.0
References: <20220328062414.1893550-1-irogers@google.com> <20220328062414.1893550-3-irogers@google.com>
 <YkIZ8MNdWvtPEikz@kernel.org>
In-Reply-To: <YkIZ8MNdWvtPEikz@kernel.org>
From:   Ian Rogers <irogers@google.com>
Date:   Mon, 28 Mar 2022 13:50:21 -0700
Message-ID: <CAP-5=fVO6mHhGchtRZBDEYm1spK9JmpJ5OSwhNc8BAgzO_XDUg@mail.gmail.com>
Subject: Re: [PATCH 2/5] perf cpumap: More cpu map reuse by merge.
To:     Arnaldo Carvalho de Melo <acme@kernel.org>
Cc:     Peter Zijlstra <peterz@infradead.org>,
        Ingo Molnar <mingo@redhat.com>,
        Mark Rutland <mark.rutland@arm.com>,
        Alexander Shishkin <alexander.shishkin@linux.intel.com>,
        Jiri Olsa <jolsa@kernel.org>,
        Namhyung Kim <namhyung@kernel.org>,
        Mathieu Poirier <mathieu.poirier@linaro.org>,
        Suzuki K Poulose <suzuki.poulose@arm.com>,
        Mike Leach <mike.leach@linaro.org>,
        Leo Yan <leo.yan@linaro.org>,
        John Garry <john.garry@huawei.com>,
        Will Deacon <will@kernel.org>,
        Alexei Starovoitov <ast@kernel.org>,
        Daniel Borkmann <daniel@iogearbox.net>,
        Andrii Nakryiko <andrii@kernel.org>,
        Martin KaFai Lau <kafai@fb.com>,
        Song Liu <songliubraving@fb.com>, Yonghong Song <yhs@fb.com>,
        John Fastabend <john.fastabend@gmail.com>,
        KP Singh <kpsingh@kernel.org>,
        Kajol Jain <kjain@linux.ibm.com>,
        James Clark <james.clark@arm.com>,
        German Gomez <german.gomez@arm.com>,
        Adrian Hunter <adrian.hunter@intel.com>,
        Riccardo Mancini <rickyman7@gmail.com>,
        Andi Kleen <ak@linux.intel.com>,
        Alexey Bayduraev <alexey.v.bayduraev@linux.intel.com>,
        Alexander Antonov <alexander.antonov@linux.intel.com>,
        linux-perf-users@vger.kernel.org, linux-kernel@vger.kernel.org,
        coresight@lists.linaro.org, linux-arm-kernel@lists.infradead.org,
        netdev@vger.kernel.org, bpf@vger.kernel.org,
        Stephane Eranian <eranian@google.com>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
X-Spam-Status: No, score=-17.6 required=5.0 tests=BAYES_00,DKIMWL_WL_MED,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,
        ENV_AND_HDR_SPF_MATCH,RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_PASS,
        T_SCC_BODY_TEXT_LINE,USER_IN_DEF_DKIM_WL,USER_IN_DEF_SPF_WL
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Mon, Mar 28, 2022 at 1:26 PM Arnaldo Carvalho de Melo
<acme@kernel.org> wrote:
>
> Em Sun, Mar 27, 2022 at 11:24:11PM -0700, Ian Rogers escreveu:
> > perf_cpu_map__merge will reuse one of its arguments if they are equal o=
r
> > the other argument is NULL. The arguments could be reused if it is know=
n
> > one set of values is a subset of the other. For example, a map of 0-1
> > and a map of just 0 when merged yields the map of 0-1. Currently a new
> > map is created rather than adding a reference count to the original 0-1
> > map.
> >
> > Signed-off-by: Ian Rogers <irogers@google.com>
> > ---
> >  tools/lib/perf/cpumap.c | 38 ++++++++++++++++++++++++++++----------
> >  1 file changed, 28 insertions(+), 10 deletions(-)
> >
> > diff --git a/tools/lib/perf/cpumap.c b/tools/lib/perf/cpumap.c
> > index ee66760f1e63..953bc50b0e41 100644
> > --- a/tools/lib/perf/cpumap.c
> > +++ b/tools/lib/perf/cpumap.c
> > @@ -319,6 +319,29 @@ struct perf_cpu perf_cpu_map__max(struct perf_cpu_=
map *map)
> >       return map->nr > 0 ? map->map[map->nr - 1] : result;
> >  }
> >
> > +/** Is 'b' a subset of 'a'. */
> > +static bool perf_cpu_map__is_subset(const struct perf_cpu_map *a,
> > +                                 const struct perf_cpu_map *b)
> > +{
> > +     int i, j;
> > +
> > +     if (a =3D=3D b || !b)
> > +             return true;
> > +     if (!a || b->nr > a->nr)
> > +             return false;
> > +     j =3D 0;
> > +     for (i =3D 0; i < a->nr; i++) {
>
> Since the kernel bumped the minimum gcc version to one that supports
> declaring loop variables locally and that perf has been using this since
> forever:
>
> =E2=AC=A2[acme@toolbox perf]$ grep -r '(int [[:alpha:]] =3D 0;' tools/per=
f
> tools/perf/util/block-info.c:   for (int i =3D 0; i < nr_hpps; i++)
> tools/perf/util/block-info.c:   for (int i =3D 0; i < nr_hpps; i++) {
> tools/perf/util/block-info.c:   for (int i =3D 0; i < nr_reps; i++)
> tools/perf/util/stream.c:       for (int i =3D 0; i < nr_evsel; i++)
> tools/perf/util/stream.c:       for (int i =3D 0; i < nr_evsel; i++) {
> tools/perf/util/stream.c:       for (int i =3D 0; i < els->nr_evsel; i++)=
 {
> tools/perf/util/stream.c:       for (int i =3D 0; i < es_pair->nr_streams=
; i++) {
> tools/perf/util/stream.c:       for (int i =3D 0; i < es_base->nr_streams=
; i++) {
> tools/perf/util/cpumap.c:               for (int j =3D 0; j < c->nr; j++)=
 {
> tools/perf/util/mem-events.c:   for (int j =3D 0; j < PERF_MEM_EVENTS__MA=
X; j++) {
> tools/perf/util/header.c:       for (int i =3D 0; i < ff->ph->env.nr_hybr=
id_cpc_nodes; i++) {
> tools/perf/builtin-diff.c:      for (int i =3D 0; i < num; i++)
> tools/perf/builtin-diff.c:              for (int i =3D 0; i < pair->block=
_info->num; i++) {
> tools/perf/builtin-stat.c:      for (int i =3D 0; i < perf_cpu_map__nr(a-=
>core.cpus); i++) {
> =E2=AC=A2[acme@toolbox perf]$
>
> And this builds on all my test containers, please use:
>
>         for (int i =3D 0, j =3D 0; i < a->nr; i++)
>
> In this case to make the source code more compact.

Ack. We still need to declare 'j' and it is a bit weird to declare j
before i. Fwiw, Making.config has the CORE_CFLAGS set to gnu99, but
declaring in the loop is clearly valid in c99.

> > +             if (a->map[i].cpu > b->map[j].cpu)
> > +                     return false;
> > +             if (a->map[i].cpu =3D=3D b->map[j].cpu) {
> > +                     j++;
> > +                     if (j =3D=3D b->nr)
> > +                             return true;
>
> Ok, as its guaranteed that cpu_maps are ordered.
>
> > +             }
> > +     }
> > +     return false;
> > +}
> > +
> >  /*
> >   * Merge two cpumaps
> >   *
> > @@ -335,17 +358,12 @@ struct perf_cpu_map *perf_cpu_map__merge(struct p=
erf_cpu_map *orig,
> >       int i, j, k;
> >       struct perf_cpu_map *merged;
> >
> > -     if (!orig && !other)
> > -             return NULL;
> > -     if (!orig) {
> > -             perf_cpu_map__get(other);
> > -             return other;
> > -     }
> > -     if (!other)
> > -             return orig;
> > -     if (orig->nr =3D=3D other->nr &&
> > -         !memcmp(orig->map, other->map, orig->nr * sizeof(struct perf_=
cpu)))
> > +     if (perf_cpu_map__is_subset(orig, other))
> >               return orig;
>
> Can't we have first the introduction of perf_cpu_map__is_subset() and
> then another patch that gets the refcount, i.e. the four lines below?

I believe that will fail as it'd be an unused static function warning
and werror.

Thanks,
Ian

> > +     if (perf_cpu_map__is_subset(other, orig)) {
> > +             perf_cpu_map__put(orig);
> > +             return perf_cpu_map__get(other);
> > +     }
> >
> >       tmp_len =3D orig->nr + other->nr;
> >       tmp_cpus =3D malloc(tmp_len * sizeof(struct perf_cpu));
> > --
> > 2.35.1.1021.g381101b075-goog
>
> --
>
> - Arnaldo
