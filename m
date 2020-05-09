Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 0A7FA1CBBEE
	for <lists+netdev@lfdr.de>; Sat,  9 May 2020 02:40:20 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728572AbgEIAkO (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 8 May 2020 20:40:14 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:59038 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-FAIL-OK-FAIL)
        by vger.kernel.org with ESMTP id S1728564AbgEIAkN (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 8 May 2020 20:40:13 -0400
Received: from mail-yb1-xb43.google.com (mail-yb1-xb43.google.com [IPv6:2607:f8b0:4864:20::b43])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id BE12CC05BD0B
        for <netdev@vger.kernel.org>; Fri,  8 May 2020 17:40:12 -0700 (PDT)
Received: by mail-yb1-xb43.google.com with SMTP id c2so1855871ybi.7
        for <netdev@vger.kernel.org>; Fri, 08 May 2020 17:40:12 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20161025;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=DiUjvkF6vCMGtTuhzeX2uqz+eNOu/2CgaqSxS5DH4H8=;
        b=nlpf2Tni9SbwpK2ejywX/nSoEvPGALiyyk0dSewDdpZrPgmU3+Y5AAEvGSRYO5PzdE
         NGXYKbZbxCqLHeKBUpw7BGuttAxG+AaTIauH0d5FhH8rrYKL5DiddCalSGt1QglN1T5/
         Ist1+TWx/yOPa/8c0qoqc0TK3y/H8rYsQqc1bH3BsfvOQP4spAcFSYooVliUDefOEuEn
         FFkzpk5ARs0/lboa7VIHuWLiNChQHwelej02dQsQjeB8PxieTVbTIStfcp6bpwaRXWRy
         Bz1vMEs2LULJ0yL52jOrVN2xhz1qdMnTId0pIRqa6PkIOVGOgr0TKjeVy6tXhLdqyWnX
         0/OQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=DiUjvkF6vCMGtTuhzeX2uqz+eNOu/2CgaqSxS5DH4H8=;
        b=qiO6SEbsLfczaFZfhUHae1hebAUjaSf+g6/rL7q7mV/PhWJvRhT+I2nEnlM3YE3UYz
         Ul9DcrHl6NxmwHx3V/dx2XGkMfWzugow3uAYNrVDLhrEjEvOXeNXpMa67BJ0jcyKu/YW
         PJz+l0DeOQxkil1CJzImZJEJ1/QpcdOU7iPex4Oh671rMgtV8VFBwcuz/j502+HWAvnu
         ovAxIWXgFeV+0e4Cv+D9V/AmDiZOP/qXY/T8SjshwZgH1lwWstnmz223gu/HuD/HJtqt
         scM0jwvQmsMnOtqJ0ny8R9QMrnYxF/+zWPhrmrxpA1UbERLiViNNGVRK6id/NVe8pE7l
         LUvw==
X-Gm-Message-State: AGi0PubLc3R9RO3BxQst7O6fN5vjC0pUD6LEb9seRyyx5EXEttkhaPS4
        NshuRsIad8dITrHM9pivL/9HnUqwPL7zUaq6/+SmdA==
X-Google-Smtp-Source: APiQypIPFAFRkwGC8+KkENUNGl0fcYDNynIZ0VzmubvzBIbCblF9sk9QOBKYrqHkPOGzJ97iVIYuW0adnTty5KJb2VU=
X-Received: by 2002:a5b:9cb:: with SMTP id y11mr9151074ybq.177.1588984811458;
 Fri, 08 May 2020 17:40:11 -0700 (PDT)
MIME-Version: 1.0
References: <20200508053629.210324-1-irogers@google.com> <20200508053629.210324-13-irogers@google.com>
 <20200509002518.GF3538@tassilo.jf.intel.com>
In-Reply-To: <20200509002518.GF3538@tassilo.jf.intel.com>
From:   Ian Rogers <irogers@google.com>
Date:   Fri, 8 May 2020 17:40:00 -0700
Message-ID: <CAP-5=fWYO2e9yVPuXGVKZ7TBP4PP6MjyEFiSd+20DOxYSLC--w@mail.gmail.com>
Subject: Re: [RFC PATCH v3 12/14] perf metricgroup: order event groups by size
To:     Andi Kleen <ak@linux.intel.com>
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
        Kajol Jain <kjain@linux.ibm.com>,
        John Garry <john.garry@huawei.com>,
        Jin Yao <yao.jin@linux.intel.com>,
        Kan Liang <kan.liang@linux.intel.com>,
        Cong Wang <xiyou.wangcong@gmail.com>,
        Kim Phillips <kim.phillips@amd.com>,
        LKML <linux-kernel@vger.kernel.org>,
        Networking <netdev@vger.kernel.org>, bpf <bpf@vger.kernel.org>,
        linux-perf-users <linux-perf-users@vger.kernel.org>,
        Vince Weaver <vincent.weaver@maine.edu>,
        Stephane Eranian <eranian@google.com>
Content-Type: text/plain; charset="UTF-8"
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Fri, May 8, 2020 at 5:25 PM Andi Kleen <ak@linux.intel.com> wrote:
>
> On Thu, May 07, 2020 at 10:36:27PM -0700, Ian Rogers wrote:
> > When adding event groups to the group list, insert them in size order.
> > This performs an insertion sort on the group list. By placing the
> > largest groups at the front of the group list it is possible to see if a
> > larger group contains the same events as a later group. This can make
> > the later group redundant - it can reuse the events from the large group.
> > A later patch will add this sharing.
>
> I'm not sure if size is that great an heuristic. The dedup algorithm should
> work in any case even if you don't order by size, right?

Consider two metrics:
 - metric 1 with events {A,B}
 - metric 2 with events {A,B,C,D}
If the list isn't sorted then as the matching takes the first group
with all the events, metric 1 will match {A,B} and metric 2 {A,B,C,D}.
If the order is sorted to {A,B,C,D},{A,B} then metric 1 matches within
the {A,B,C,D} group as does metric 2. The events in metric 1 aren't
used and are removed.

The dedup algorithm is very naive :-)

> I suppose in theory some kind of topological sort would be better.

We could build something more complex, such as a directed acyclic
graph where metrics with a subset of events are children of parent
metrics. Children could have >1 parent for example
{A,B,C,D},{A,B,E},{A,B} where {A,B} is a subset of both {A,B,C,D} and
{A,B,E} and so a child of both. Presumably in that case it'd be better
to match {A,B} with {A,B,E} to reduce multiplexing. As we're merging
smaller groups into bigger, the sorting of the list is a quick and
dirty approximation of this.

Thanks,
Ian

> -Andi
> >
> > Signed-off-by: Ian Rogers <irogers@google.com>
> > ---
> >  tools/perf/util/metricgroup.c | 16 +++++++++++++++-
> >  1 file changed, 15 insertions(+), 1 deletion(-)
> >
> > diff --git a/tools/perf/util/metricgroup.c b/tools/perf/util/metricgroup.c
> > index 2a6456fa178b..69fbff47089f 100644
> > --- a/tools/perf/util/metricgroup.c
> > +++ b/tools/perf/util/metricgroup.c
> > @@ -520,7 +520,21 @@ static int __metricgroup__add_metric(struct list_head *group_list,
> >               return -EINVAL;
> >       }
> >
> > -     list_add_tail(&eg->nd, group_list);
> > +     if (list_empty(group_list))
> > +             list_add(&eg->nd, group_list);
> > +     else {
> > +             struct list_head *pos;
> > +
> > +             /* Place the largest groups at the front. */
> > +             list_for_each_prev(pos, group_list) {
> > +                     struct egroup *old = list_entry(pos, struct egroup, nd);
> > +
> > +                     if (hashmap__size(&eg->pctx.ids) <=
> > +                         hashmap__size(&old->pctx.ids))
> > +                             break;
> > +             }
> > +             list_add(&eg->nd, pos);
> > +     }
> >
> >       return 0;
> >  }
> > --
> > 2.26.2.645.ge9eca65c58-goog
> >
