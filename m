Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 72374F5367
	for <lists+netdev@lfdr.de>; Fri,  8 Nov 2019 19:18:37 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729790AbfKHSSb (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 8 Nov 2019 13:18:31 -0500
Received: from mail-wm1-f68.google.com ([209.85.128.68]:52440 "EHLO
        mail-wm1-f68.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1727001AbfKHSSa (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 8 Nov 2019 13:18:30 -0500
Received: by mail-wm1-f68.google.com with SMTP id c17so7128945wmk.2
        for <netdev@vger.kernel.org>; Fri, 08 Nov 2019 10:18:26 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20161025;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=YFWgg2ppFdsSmvg1LO5Op3wVrU8obP4yfGKEavUKWnE=;
        b=odPKyS18+DSSsImN1b6xBaUshgxpKtpxWVGaSny1LSRPawCj0YlfQAbxynL4QzAcLp
         dTRQYG78FTiX7zHN/GcrlcEPpgQcXl36mZXEqOL9c6wFcnGVWO9NpWTd72QJ++CFC0lQ
         KsMMuG3RuuKWrBBc85IkXpqzjEC5O5NLUeohSJZdiKLXoKJNY2XqiaPLfxxf1A9AQ4/Z
         UxUcs29U0W4lqKrfKGeMUUJyz7KArVlugWeKGmoYQG1NoKiwB9IEVO/zxXsAmXH4U2/y
         NpcBIcIAGJnn89f+Mh9a4UIEccmrwelPlOqmsd5HaCrME4UO7IyDLFjGm0GUSVwfmchr
         TP1Q==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=YFWgg2ppFdsSmvg1LO5Op3wVrU8obP4yfGKEavUKWnE=;
        b=GjCjH460Q+if+ah3B4bAvQjhGELt+bAfKi8IqbR2Q6JyXndzqoDC2Alqti+FdrPpul
         PrkWBLMVVfd+CvPQVjbQJjEkzJGWrCY3YMYhQmH2ROZMf4lNzXMHZP5MEX3bDdB+T17p
         YsELSZ1eydvebNA9vX9avjQKMj/YYQ7WXLDshVc8oXwBJr5HSHVrXvlpxZV2HhQDKNmw
         YwQx0juv8Yuo9MgPVQC1/LAyweaWNTL8rQ8C2GaN/SW34jsWTQInCl3d9KauWJ4K/wN7
         5/KjcQGTZ3YfvGSZAaprVTpVhgyXt2K2LyKqBWKoqKDb0RdLCwXVZ+kMq4lbqc2qTBJ0
         a2wA==
X-Gm-Message-State: APjAAAUWp8Lrr/Uf1/TMyleGd2qJgQ+SGm+nuSu5WHxMQWdzLbxZU+BW
        F0OySfnDg5slQmMDUNrkbSrKmRJ+kgNF5RR+pkf1nA==
X-Google-Smtp-Source: APXvYqyU6oVLGbDhInMDhJxLdE4qvb46gnjNmeO+08bYNzQOCoi0whdlXnTfSIjGUb8cBku2xStC02eJfl/G99qaqrY=
X-Received: by 2002:a1c:a791:: with SMTP id q139mr9275963wme.155.1573237105658;
 Fri, 08 Nov 2019 10:18:25 -0800 (PST)
MIME-Version: 1.0
References: <20191030223448.12930-1-irogers@google.com> <20191107221428.168286-1-irogers@google.com>
 <20191107222315.GA7261@kernel.org>
In-Reply-To: <20191107222315.GA7261@kernel.org>
From:   Ian Rogers <irogers@google.com>
Date:   Fri, 8 Nov 2019 10:18:14 -0800
Message-ID: <CAP-5=fVNYbZoEmFzxMj850eorOtRJAouzvCFObxZRZT2G7YOCg@mail.gmail.com>
Subject: Re: [PATCH v6 00/10] Improvements to memory usage by parse events
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

On Thu, Nov 7, 2019 at 2:23 PM Arnaldo Carvalho de Melo
<arnaldo.melo@gmail.com> wrote:
>
> Em Thu, Nov 07, 2019 at 02:14:18PM -0800, Ian Rogers escreveu:
> > The parse events parser leaks memory for certain expressions as well
> > as allowing a char* to reference stack, heap or .rodata. This series
> > of patches improves the hygeine and adds free-ing operations to
> > reclaim memory in the parser in error and non-error situations.
> >
> > The series of patches was generated with LLVM's address sanitizer and
> > libFuzzer:
> > https://llvm.org/docs/LibFuzzer.html
> > called on the parse_events function with randomly generated input. With
> > the patches no leaks or memory corruption issues were present.
> >
> > The v6 patches address a C90 compilation issue.
>
> Please take a look at what is in my perf/core branch, to see what is
> left, if something needs fixing, please send a patch on top of that,

Thanks, just the last patch remaining. I resent it rebased on your
perf/core branch:
https://lkml.org/lkml/2019/11/8/1103
https://git.kernel.org/pub/scm/linux/kernel/git/acme/linux.git/log/?h=perf/core

Thanks,
Ian

> Thanks,
>
> - Arnaldo
>
> > The v5 patches add initial error print to the set, as requested by
> > Jiri Olsa. They also fix additional 2 missed frees in the patch
> > 'before yyabort-ing free components' and remove a redundant new_str
> > variable from the patch 'add parse events handle error' as spotted by
> > Stephane Eranian.
> >
> > The v4 patches address review comments from Jiri Olsa, turning a long
> > error message into a single warning, fixing the data type in a list
> > iterator and reordering patches.
> >
> > The v3 patches address review comments from Jiri Olsa improving commit
> > messages, handling ENOMEM errors from strdup better, and removing a
> > printed warning if an invalid event is passed.
> >
> > The v2 patches are preferable to an earlier proposed patch:
> >    perf tools: avoid reading out of scope array
> >
> > Ian Rogers (10):
> >   perf tools: add parse events handle error
> >   perf tools: move ALLOC_LIST into a function
> >   perf tools: avoid a malloc for array events
> >   perf tools: splice events onto evlist even on error
> >   perf tools: ensure config and str in terms are unique
> >   perf tools: add destructors for parse event terms
> >   perf tools: before yyabort-ing free components
> >   perf tools: if pmu configuration fails free terms
> >   perf tools: add a deep delete for parse event terms
> >   perf tools: report initial event parsing error
> >
> >  tools/perf/arch/powerpc/util/kvm-stat.c |   9 +-
> >  tools/perf/builtin-stat.c               |   2 +
> >  tools/perf/builtin-trace.c              |  16 +-
> >  tools/perf/tests/parse-events.c         |   3 +-
> >  tools/perf/util/metricgroup.c           |   2 +-
> >  tools/perf/util/parse-events.c          | 239 +++++++++++----
> >  tools/perf/util/parse-events.h          |   7 +
> >  tools/perf/util/parse-events.y          | 390 +++++++++++++++++-------
> >  tools/perf/util/pmu.c                   |  32 +-
> >  9 files changed, 511 insertions(+), 189 deletions(-)
> >
> > --
> > 2.24.0.432.g9d3f5f5b63-goog
>
> --
>
> - Arnaldo
>
> --
> You received this message because you are subscribed to the Google Groups "Clang Built Linux" group.
> To unsubscribe from this group and stop receiving emails from it, send an email to clang-built-linux+unsubscribe@googlegroups.com.
> To view this discussion on the web visit https://groups.google.com/d/msgid/clang-built-linux/20191107222315.GA7261%40kernel.org.
