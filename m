Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 6F5FC1D7DBB
	for <lists+netdev@lfdr.de>; Mon, 18 May 2020 18:04:03 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728237AbgERQD7 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 18 May 2020 12:03:59 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:44298 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1727007AbgERQD7 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 18 May 2020 12:03:59 -0400
Received: from mail-yb1-xb43.google.com (mail-yb1-xb43.google.com [IPv6:2607:f8b0:4864:20::b43])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id E56D2C061A0C
        for <netdev@vger.kernel.org>; Mon, 18 May 2020 09:03:58 -0700 (PDT)
Received: by mail-yb1-xb43.google.com with SMTP id o8so5514776ybc.11
        for <netdev@vger.kernel.org>; Mon, 18 May 2020 09:03:58 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20161025;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=wC6Al5//OLghdL5M5WT7D3yvk/6R//cCeiiqEjQaDTs=;
        b=BzPjM+6ebMCc28zoKiEL73mEspk5sX9NbICtCmYmgQk9eJeWE9jmnaOHS4Q+duidzu
         1E/H/4MHNP4DYOTR6Dr9xZBVFW+kUD2yG/sAByDJhVm034/xiFjJ9xNvwNnpbHF8ZHR2
         rQsh3/bPDQ+ouNzHK9cUHH8E4WjThxy5Z2cwnZwuVUFFvi/IF10B07KQN3LF1mIOuVv6
         42fATnMY9fhzIr+MAyNCODKrK+h1vn+1uL/tzErrF4KDRhVDmCM1Cek1qKtDPY5bEpWO
         dGknlsXCc0MmgMPOaNxNREdMd527VDWczNlWq2kNpqDEqL9O5WFh49DRdvJqHRmX8OkR
         33xg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=wC6Al5//OLghdL5M5WT7D3yvk/6R//cCeiiqEjQaDTs=;
        b=r6r/V/MUCPceEXr+w7MIfDrxcOlnZaILq+YW2iiBGjyHhGx1vMTTjWWpkTFIgTjDkd
         FsFfDFrJuJ50GkhGmAaPjPWXHYQvvB6sPvVD+V6dEUwT44w9VMAPdB8CQpQyAjj4Zxb1
         MI6ZU8p6yUlrmChKOHcct4WJBws5TNWfKtpCe4OGrppv9mUCs/oGZ1l1l5LlH/x1L0S7
         SGNQBXIU07Yp4u607N2MNNYZ+PHluQI17TEgcAkAKZQeBXLVMPUrHcgZBFyPFJMCbsDN
         f313NNpZsI7APMM9Q3wWTZ5iAasmZNyWbQ52WJHmQitiYobaaD+Snq2STkYvo/U4Amwe
         y4ig==
X-Gm-Message-State: AOAM533WJrPp6Z8wP3v8UuyULFkN6YFB2yGmZyLUnIb1mW40wE0Ycj3+
        VVhM3aF8vPPwHaxqwI/z9PxsP4l8XtoqHnddyctwNA==
X-Google-Smtp-Source: ABdhPJzFYLd/aLEk6sn35nDhblrHA7edN0rQqww9iySxXnjwYSCvGBXfkU7ecGC3j/vBijAtsHeQ1eURtfBdpWtSeCA=
X-Received: by 2002:a25:bb42:: with SMTP id b2mr25735216ybk.383.1589817837533;
 Mon, 18 May 2020 09:03:57 -0700 (PDT)
MIME-Version: 1.0
References: <20200515221732.44078-1-irogers@google.com> <20200515221732.44078-8-irogers@google.com>
 <20200518154505.GE24211@kernel.org>
In-Reply-To: <20200518154505.GE24211@kernel.org>
From:   Ian Rogers <irogers@google.com>
Date:   Mon, 18 May 2020 09:03:45 -0700
Message-ID: <CAP-5=fWZwuSLaFX+-pgeE_H92Mtp7+_NrwBeRFTqyfPjVRkbWg@mail.gmail.com>
Subject: Re: [PATCH v3 7/7] perf expr: Migrate expr ids table to a hashmap
To:     Arnaldo Carvalho de Melo <arnaldo.melo@gmail.com>
Cc:     Peter Zijlstra <peterz@infradead.org>,
        Ingo Molnar <mingo@redhat.com>,
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
        LKML <linux-kernel@vger.kernel.org>,
        Networking <netdev@vger.kernel.org>, bpf <bpf@vger.kernel.org>,
        Stephane Eranian <eranian@google.com>
Content-Type: text/plain; charset="UTF-8"
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Mon, May 18, 2020 at 8:45 AM Arnaldo Carvalho de Melo
<arnaldo.melo@gmail.com> wrote:
>
> Em Fri, May 15, 2020 at 03:17:32PM -0700, Ian Rogers escreveu:
> > Use a hashmap between a char* string and a double* value. While bpf's
> > hashmap entries are size_t in size, we can't guarantee sizeof(size_t) >=
> > sizeof(double). Avoid a memory allocation when gathering ids by making 0.0
> > a special value encoded as NULL.
> >
> > Original map suggestion by Andi Kleen:
> > https://lore.kernel.org/lkml/20200224210308.GQ160988@tassilo.jf.intel.com/
> > and seconded by Jiri Olsa:
> > https://lore.kernel.org/lkml/20200423112915.GH1136647@krava/
>
> I'm having trouble here when building it with:
>
> make -C tools/perf O=/tmp/build/perf
>
>     CC       /tmp/build/perf/tests/expr.o
>     INSTALL  trace_plugins
>     CC       /tmp/build/perf/util/metricgroup.o
>   In file included from /home/acme/git/perf/tools/lib/bpf/hashmap.h:18,
>                    from /home/acme/git/perf/tools/perf/util/expr.h:6,
>                    from tests/expr.c:3:
>   /home/acme/git/perf/tools/lib/bpf/libbpf_internal.h:63: error: "pr_info" redefined [-Werror]
>      63 | #define pr_info(fmt, ...) __pr(LIBBPF_INFO, fmt, ##__VA_ARGS__)
>         |
>   In file included from tests/expr.c:2:
>   /home/acme/git/perf/tools/perf/util/debug.h:24: note: this is the location of the previous definition
>
> It looks like libbpf's hashmap.h is being used instead of the one in
> tools/perf/util/, yeah, as intended, but then since I don't have the
> fixes you added to the BPF tree, the build fails, if I instead
> unconditionally use
>
> #include "util/hashmap.h"
>
> It works. Please ack.
>
> I.e. with the patch below, further tests:
>
> [acme@five perf]$ perf -vv | grep -i bpf
>                    bpf: [ on  ]  # HAVE_LIBBPF_SUPPORT
> [acme@five perf]$ nm ~/bin/perf | grep -i libbpf_ | wc -l
> 39
> [acme@five perf]$ nm ~/bin/perf | grep -i hashmap_ | wc -l
> 17
> [acme@five perf]$
>
> Explicitely building without LIBBPF:
>
> [acme@five perf]$ perf -vv | grep -i bpf
>                    bpf: [ OFF ]  # HAVE_LIBBPF_SUPPORT
> [acme@five perf]$
> [acme@five perf]$ nm ~/bin/perf | grep -i libbpf_ | wc -l
> 0
> [acme@five perf]$ nm ~/bin/perf | grep -i hashmap_ | wc -l
> 9
> [acme@five perf]$
>
> Works,
>
> - Arnaldo

Hi Arnaldo,

this build issue sounds like this patch is missing:
https://lore.kernel.org/lkml/20200515221732.44078-3-irogers@google.com/
The commit message there could have explicitly said having this
#include causes the conflicting definitions between perf's debug.h and
libbpf_internal.h's definitions of pr_info, etc.

Let me know how else to help and sorry for the confusion. Thanks,
Ian


> diff --git a/tools/perf/util/expr.h b/tools/perf/util/expr.h
> index d60a8feaf50b..8a2c1074f90f 100644
> --- a/tools/perf/util/expr.h
> +++ b/tools/perf/util/expr.h
> @@ -2,11 +2,14 @@
>  #ifndef PARSE_CTX_H
>  #define PARSE_CTX_H 1
>
> -#ifdef HAVE_LIBBPF_SUPPORT
> -#include <bpf/hashmap.h>
> -#else
> -#include "hashmap.h"
> -#endif
> +// There are fixes that need to land upstream before we can use libbpf's headers,
> +// for now use our copy unconditionally, since the data structures at this point
> +// are exactly the same, no problem.
> +//#ifdef HAVE_LIBBPF_SUPPORT
> +//#include <bpf/hashmap.h>
> +//#else
> +#include "util/hashmap.h"
> +//#endif
>
>  struct expr_parse_ctx {
>         struct hashmap ids;
