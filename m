Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 433B11D5C9B
	for <lists+netdev@lfdr.de>; Sat, 16 May 2020 01:00:25 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727084AbgEOW7o (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 15 May 2020 18:59:44 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:58288 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726541AbgEOW7m (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 15 May 2020 18:59:42 -0400
Received: from mail-yb1-xb42.google.com (mail-yb1-xb42.google.com [IPv6:2607:f8b0:4864:20::b42])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 73168C061A0C
        for <netdev@vger.kernel.org>; Fri, 15 May 2020 15:59:41 -0700 (PDT)
Received: by mail-yb1-xb42.google.com with SMTP id a10so1954523ybc.3
        for <netdev@vger.kernel.org>; Fri, 15 May 2020 15:59:41 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20161025;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=dC+XhfbqGlhAhbAgyMdHUqPw5BLvGzk1yB+TQwnz4Es=;
        b=GtgoC7VfR7ofh/b0+XXCmCRyrz1ZdRQTxwPKcbSn8AGVsJL1PTuo8ed/VSbRTXOxxh
         QoQpob+pJw2EjpaAWbOkO1M85kUUJXBTCY5KJetb88ebg9cK3NME+3ys6Gblksg5ssu2
         gWEHe2DUfbY7PR6MfhCSCPt17ld2kmfha48RWc9lIaCNYE8BmYOqjCmDtlIbJyNzEnxn
         QuF5pDFw03jfZdfcoUKpL2Ep9KgVqE8ac34Kqcx8l9GO1n7FrPnPTTObHBdeoOTG39hp
         2CGFBZPuCAdG34MKdbxcD4Ouy6PfsgiHx8Adfb84KgVvK/ncefFwcRsGVmHEAZ21AQMb
         hAIw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=dC+XhfbqGlhAhbAgyMdHUqPw5BLvGzk1yB+TQwnz4Es=;
        b=gZcFKD/hlNzPckqjYwM85M9nlHJ9pEt+lxYBYOQ8yx4PscbO4U2PxPq+O9ZrIHuVqR
         pNPKUYE36qEwdppl3xIWXqoMqLm3fcUHeOlXAGE2UcOymaiMMYMhhZc2q7QeIrPqoMaM
         ZNFZL5DZf23lFSxVD8YQLUw30m8PJkso6rdEH8VX6X8sOiiEbMiLa4Nb9uG6E6KRVSfQ
         IKAxmDE6yy8EODUsTvKjk/llWQTRQCkZevmdn6bGRcMdlx6Jyv6bXdNpyDnU9Sj/YDyH
         trzpXCaE8Ox9XLFRfTp11zlylB/xY28vUt7tu3LHjrPcqebsNSnbXKRCY5A2Ik4PIR1l
         XVxg==
X-Gm-Message-State: AOAM530tBkS2ijFImNHKYXCG70mWzhIHvE+jHSFXkHTCW6+X8JwjqynR
        q2qAATTmM7VF+Bistz7+iHG/ZwnkIKrBH4+hMkA1IA==
X-Google-Smtp-Source: ABdhPJzA8Cr+oKh4iPKJxB/HOXfxB16FYU3mosClVpNarz/OFo9hUOk0QS6SuasjPAkl/T5P6KoafxYlyo87ftsOajw=
X-Received: by 2002:a25:d450:: with SMTP id m77mr9552468ybf.177.1589583580023;
 Fri, 15 May 2020 15:59:40 -0700 (PDT)
MIME-Version: 1.0
References: <20200515165007.217120-1-irogers@google.com> <20200515165007.217120-8-irogers@google.com>
 <20200515224139.GB3577540@krava>
In-Reply-To: <20200515224139.GB3577540@krava>
From:   Ian Rogers <irogers@google.com>
Date:   Fri, 15 May 2020 15:59:28 -0700
Message-ID: <CAP-5=fXxTt8Deh6JDQrEqKncM+EfzMnU3_Vg8J4tD3O1uN9hSA@mail.gmail.com>
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

On Fri, May 15, 2020 at 3:41 PM Jiri Olsa <jolsa@redhat.com> wrote:
>
> On Fri, May 15, 2020 at 09:50:07AM -0700, Ian Rogers wrote:
>
> SNIP
>
> > diff --git a/tools/perf/util/expr.c b/tools/perf/util/expr.c
> > index 8b4ce704a68d..f64ab91c432b 100644
> > --- a/tools/perf/util/expr.c
> > +++ b/tools/perf/util/expr.c
> > @@ -4,25 +4,76 @@
> >  #include "expr.h"
> >  #include "expr-bison.h"
> >  #include "expr-flex.h"
> > +#include <linux/kernel.h>
> >
> >  #ifdef PARSER_DEBUG
> >  extern int expr_debug;
> >  #endif
> >
> > +static size_t key_hash(const void *key, void *ctx __maybe_unused)
> > +{
> > +     const char *str = (const char *)key;
> > +     size_t hash = 0;
> > +
> > +     while (*str != '\0') {
> > +             hash *= 31;
> > +             hash += *str;
> > +             str++;
> > +     }
> > +     return hash;
> > +}
> > +
> > +static bool key_equal(const void *key1, const void *key2,
> > +                 void *ctx __maybe_unused)
> > +{
> > +     return !strcmp((const char *)key1, (const char *)key2);
>
> should that be strcasecmp ? would it affect the key_hash as well?

The original code does make use of strcasecmp in one place, but in the
group matching (the main useless use for this code) it doesn't. I
don't think it is a regression to keep it as this, and would like a
test case for when it does matter. Is that ok?

Thanks,
Ian

> jirka
>
