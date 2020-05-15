Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 53B551D5A1B
	for <lists+netdev@lfdr.de>; Fri, 15 May 2020 21:40:00 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726372AbgEOTjq (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 15 May 2020 15:39:46 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:55274 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-FAIL-OK-FAIL)
        by vger.kernel.org with ESMTP id S1726168AbgEOTjq (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 15 May 2020 15:39:46 -0400
Received: from mail-qt1-x844.google.com (mail-qt1-x844.google.com [IPv6:2607:f8b0:4864:20::844])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id CED38C061A0C;
        Fri, 15 May 2020 12:39:45 -0700 (PDT)
Received: by mail-qt1-x844.google.com with SMTP id d7so2972737qtn.11;
        Fri, 15 May 2020 12:39:45 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=4BQMLiV7/BzZ4YarNv+2ABNpKJB9d3AIj9UHyBIXc0M=;
        b=CO76H2fPe/gmTLc9vA/Uw8T86Xg+X8HMd1/oZ+N6jGgzKfFJnhkyEa0nCAgaB1mhOO
         DS7bHDWmBfMxfgn08jVH+Ir45lUztMhcQsKK6BIas2HN5uB2bXHFSvRCAPJTiQGOQpff
         8o1iiDoziuQ4jhCJOf+TFMrADges9ONOoEZt9BciOzw2MEqpOjL0ZykeC8mK0ncvI02r
         zR/bHvcZVqlGOJhphjK5Uc2jl/D0QC2yq+8aa5hP2L3mXrivKoyb6Tvg2UrM3Iziugk7
         bpB2fbKaW4SnaN/5w3V0tEBkwP4xVvkY8lPghTePTtbTZE4OcvYtJbpUmSRUjdbJ9Imy
         EU3A==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=4BQMLiV7/BzZ4YarNv+2ABNpKJB9d3AIj9UHyBIXc0M=;
        b=WlLEPQTydNCDS+kVwktSixGKBH0WGSzJgAF43p9bvAkP2Az5JS8y7R+cfaYG7YcBwa
         JL4YubRiovq2rLk/XLcCQqbeqeGtmqngGOVVVKHcYgA+Sow6JCyvMHxUx72Mf1fO60IP
         fR9I562UxOkmAr+3aim8lHR5DC5YoT+KnO01ISGZZw4PrPjE4Bxd0fwNT4TvOKc89cx7
         ebrjB1czNV7F/1FUaptWPymWmive8JAqj//N2DpEu//OO6wuP7g08DVt75KuePICNuxe
         Pu7l0F8lfotKCZZybYvWHLCM19s3GX3ZDs/4MCSOOQ5Z1n+Qv3aX3IYawzEK1X6r+kWs
         MKwg==
X-Gm-Message-State: AOAM533HP9nFS/6GlmSFtRwPXixp7potRstIPGk5wMRmor9P3uYL0HKs
        GRvz1yBYGTm2WxYxu7UekslB9m51Nq5n1ueZR8s=
X-Google-Smtp-Source: ABdhPJxnwuBdyHD8GKWt0YJqtP3FaI6rV2VYuQhkw3oH7yyy8yh2SxOwnA6qKrcqBG6vPu4l1/yUJH2LM/bK/bqPcB8=
X-Received: by 2002:aed:2f02:: with SMTP id l2mr5209605qtd.117.1589571585047;
 Fri, 15 May 2020 12:39:45 -0700 (PDT)
MIME-Version: 1.0
References: <20200515165007.217120-1-irogers@google.com> <20200515165007.217120-8-irogers@google.com>
In-Reply-To: <20200515165007.217120-8-irogers@google.com>
From:   Andrii Nakryiko <andrii.nakryiko@gmail.com>
Date:   Fri, 15 May 2020 12:39:34 -0700
Message-ID: <CAEf4BzZOB0L0iie0CAduNOnE4TXbfKeo-g97kwfMPZ5Mg7uRwg@mail.gmail.com>
Subject: Re: [PATCH v2 7/7] perf expr: Migrate expr ids table to a hashmap
To:     Ian Rogers <irogers@google.com>
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
        Andi Kleen <ak@linux.intel.com>,
        John Garry <john.garry@huawei.com>,
        Jin Yao <yao.jin@linux.intel.com>,
        Kan Liang <kan.liang@linux.intel.com>,
        Cong Wang <xiyou.wangcong@gmail.com>,
        Kim Phillips <kim.phillips@amd.com>,
        Adrian Hunter <adrian.hunter@intel.com>,
        Leo Yan <leo.yan@linaro.org>,
        open list <linux-kernel@vger.kernel.org>,
        Networking <netdev@vger.kernel.org>, bpf <bpf@vger.kernel.org>,
        Stephane Eranian <eranian@google.com>
Content-Type: text/plain; charset="UTF-8"
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Fri, May 15, 2020 at 9:51 AM Ian Rogers <irogers@google.com> wrote:
>
> Use a hashmap between a char* string and a double* value. While bpf's
> hashmap entries are size_t in size, we can't guarantee sizeof(size_t) >=
> sizeof(double). Avoid a memory allocation when gathering ids by making 0.0
> a special value encoded as NULL.
>
> Original map suggestion by Andi Kleen:
> https://lore.kernel.org/lkml/20200224210308.GQ160988@tassilo.jf.intel.com/
> and seconded by Jiri Olsa:
> https://lore.kernel.org/lkml/20200423112915.GH1136647@krava/
>
> Signed-off-by: Ian Rogers <irogers@google.com>
> ---
>  tools/perf/tests/expr.c       |  40 ++++++-----
>  tools/perf/tests/pmu-events.c |  25 +++----
>  tools/perf/util/expr.c        | 129 +++++++++++++++++++---------------
>  tools/perf/util/expr.h        |  26 +++----
>  tools/perf/util/expr.y        |  22 +-----
>  tools/perf/util/metricgroup.c |  87 +++++++++++------------
>  tools/perf/util/stat-shadow.c |  49 ++++++++-----
>  7 files changed, 197 insertions(+), 181 deletions(-)
>
> diff --git a/tools/perf/tests/expr.c b/tools/perf/tests/expr.c
> index 3f742612776a..5e606fd5a2c6 100644
> --- a/tools/perf/tests/expr.c
> +++ b/tools/perf/tests/expr.c
> @@ -19,11 +19,9 @@ static int test(struct expr_parse_ctx *ctx, const char *e, double val2)
>  int test__expr(struct test *t __maybe_unused, int subtest __maybe_unused)
>  {
>         const char *p;
> -       const char **other;
> -       double val;
> -       int i, ret;
> +       double val, *val_ptr;
> +       int ret;
>         struct expr_parse_ctx ctx;
> -       int num_other;
>
>         expr__ctx_init(&ctx);
>         expr__add_id(&ctx, "FOO", 1);
> @@ -52,25 +50,29 @@ int test__expr(struct test *t __maybe_unused, int subtest __maybe_unused)
>         ret = expr__parse(&val, &ctx, p, 1);
>         TEST_ASSERT_VAL("missing operand", ret == -1);
>
> +       hashmap__clear(&ctx.ids);

hashmap__clear() will free up memory allocated for hashmap itself and
hash entries, but not keys/values. Unless it's happening somewhere
else, you'll need to do something similar to expr__ctx_clear() below?

Same below for another "lone" hashmap_clear() call.

>         TEST_ASSERT_VAL("find other",
> -                       expr__find_other("FOO + BAR + BAZ + BOZO", "FOO", &other, &num_other, 1) == 0);

[...]
