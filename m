Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id CFAA31D7E78
	for <lists+netdev@lfdr.de>; Mon, 18 May 2020 18:29:21 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728198AbgERQ3U (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 18 May 2020 12:29:20 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:48374 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1728078AbgERQ3T (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 18 May 2020 12:29:19 -0400
Received: from mail-io1-xd43.google.com (mail-io1-xd43.google.com [IPv6:2607:f8b0:4864:20::d43])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 3D7EDC061A0C
        for <netdev@vger.kernel.org>; Mon, 18 May 2020 09:29:19 -0700 (PDT)
Received: by mail-io1-xd43.google.com with SMTP id o5so11213970iow.8
        for <netdev@vger.kernel.org>; Mon, 18 May 2020 09:29:19 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20161025;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=TmNo324ewiqBrOzyFgGIajOz2Fxu5S4md+RR2eoMBH0=;
        b=cR6cpj4L3VfEX9LUwmpRrf5NaiDdEHQkdowyBqBDeP9M+RN+2PDUK9GqoycTwAHDkz
         v1kLKq+JDAbgGiNdDihildBwccSJeTyzjQl9UKfkXpQ9vNqRRkcWCErz0HmKI4hifSBY
         d+uumoTs1E8WCj8oA4lOOmAv+ZnAizTpJiETY5X+seRwXvJZ00cQWJXbrBIJFcVP7yCj
         gxEc9sgee310IqVllejFcBrMITelb35V5SI6azfkxzd2lv3TBqfKwDRq9Q8XFAJD41bg
         yO3/yfvFY1kq5xP74oW7hSdtWwD1jEBZqJm/mFWU9DOy0ggV+8k8/IdM9hN5lcU7qonu
         v0Rg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=TmNo324ewiqBrOzyFgGIajOz2Fxu5S4md+RR2eoMBH0=;
        b=gwCVflN9tDPqNsDFkUz2qHLWSKOOYuhrdgAPEc5vPgg0AH0hXh/reX0egiSReI40K3
         8asr5MMi61FTkQEu/XQNzT+jPL6Lf+CX+UE/EQ0mQleX/KSnAz2QJ6dhIMhq4+iFCCC1
         2W7JqvhNrZqJ0XW1Oj7XpnG43VtQ2In6MWJvwI+d3a8Ium2BQcF73h9Ciba1pVyu0mUh
         0z6G2KyEsKuMz85PyjAuIs2uMTIK7Rl+uw1iTT4pxOCUhaYbRiplO7wr1HmZx1/56piA
         zdHDO2Frfy3BNu/MIvLhZ/8LZbe7ha5C+NCESgGl+0EJrjP++HY3x6jxAvtczhZR2FKF
         wWoA==
X-Gm-Message-State: AOAM533SSKvU3gJDY9RdaKCvlVlSeSrGCHhvogvPNK+CYtkWcEBBDOAS
        dl7RK6cAsS5Gi8ubCF4kBsA630/+Cg70OqR0bMRxQw==
X-Google-Smtp-Source: ABdhPJwfkal/ogCvbE1YiVUSr2oHNZPX1BV5tAJ5ccooYPRJnI4ec3PTfIwWNWbZ0WgPcK7m/mubWCdkilY0URhDGgE=
X-Received: by 2002:a02:cf17:: with SMTP id q23mr16428337jar.39.1589819358215;
 Mon, 18 May 2020 09:29:18 -0700 (PDT)
MIME-Version: 1.0
References: <20200515221732.44078-1-irogers@google.com> <20200515221732.44078-8-irogers@google.com>
 <20200518154505.GE24211@kernel.org> <CAP-5=fWZwuSLaFX+-pgeE_H92Mtp7+_NrwBeRFTqyfPjVRkbWg@mail.gmail.com>
 <20200518160648.GI24211@kernel.org> <20200518161137.GK24211@kernel.org>
In-Reply-To: <20200518161137.GK24211@kernel.org>
From:   Ian Rogers <irogers@google.com>
Date:   Mon, 18 May 2020 09:29:06 -0700
Message-ID: <CAP-5=fWzb5XxcFishFErRtdc-Gvv-7DkVpd6HSiy2_RswfjeDg@mail.gmail.com>
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

On Mon, May 18, 2020 at 9:11 AM Arnaldo Carvalho de Melo
<arnaldo.melo@gmail.com> wrote:
>
> Em Mon, May 18, 2020 at 01:06:48PM -0300, Arnaldo Carvalho de Melo escreveu:
> > Em Mon, May 18, 2020 at 09:03:45AM -0700, Ian Rogers escreveu:
> > > On Mon, May 18, 2020 at 8:45 AM Arnaldo Carvalho de Melo wrote:
> > > this build issue sounds like this patch is missing:
> > > https://lore.kernel.org/lkml/20200515221732.44078-3-irogers@google.com/
> > > The commit message there could have explicitly said having this
> > > #include causes the conflicting definitions between perf's debug.h and
> > > libbpf_internal.h's definitions of pr_info, etc.
> >
> > yeah, understood, but I'm not processing patches for tools/lib/bpf/,
> > Daniel is, I'll only get that one later, then we can go back to the way
> > you structured it. Just an extra bit of confusion in this process ;-)
>
> So, thiis is failing on all alpine Linux containers:
>
>   CC       /tmp/build/perf/util/metricgroup.o
>   CC       /tmp/build/perf/util/header.o
> In file included from util/metricgroup.c:25:0:
> /git/linux/tools/lib/api/fs/fs.h:16:0: error: "FS" redefined [-Werror]
>  #define FS(name)    \
>  ^
> In file included from /git/linux/tools/perf/util/hashmap.h:16:0,
>                  from util/expr.h:11,
>                  from util/metricgroup.c:14:
> /usr/include/bits/reg.h:28:0: note: this is the location of the previous definition
>  #define FS     25
>  ^
>   CC       /tmp/build/perf/util/callchain.o
>   CC       /tmp/build/perf/util/values.o
>   CC       /tmp/build/perf/util/debug.o
>   CC       /tmp/build/perf/util/fncache.o
> cc1: all warnings being treated as errors
> mv: can't rename '/tmp/build/perf/util/.metricgroup.o.tmp': No such file or directory
> /git/linux/tools/build/Makefile.build:96: recipe for target '/tmp/build/perf/util/metricgroup.o' failed
>
>
> I'll check that soon,
>
> - Arnaldo

I had some issues here too:
https://lore.kernel.org/lkml/CAEf4BzYxTTND7T7X0dLr2CbkEvUuKtarOeoJYYROefij+qds0w@mail.gmail.com/
The only reason for the bits/reg.h inclusion is for __WORDSIZE for the
hash_bits operation. As shown below:

#ifdef __GLIBC__
#include <bits/wordsize.h>
#else
#include <bits/reg.h>
#endif
static inline size_t hash_bits(size_t h, int bits)
{
/* shuffle bits and return requested number of upper bits */
return (h * 11400714819323198485llu) >> (__WORDSIZE - bits);
}

It'd be possible to change the definition of hash_bits and remove the
#includes by:

static inline size_t hash_bits(size_t h, int bits)
{
/* shuffle bits and return requested number of upper bits */
#ifdef __LP64__
  int shift = 64 - bits;
#else
  int shift = 32 - bits;
#endif
return (h * 11400714819323198485llu) >> shift;
}

Others may have a prefered more portable solution. A separate issue
with this same function is undefined behavior getting flagged
(unnecessarily) by sanitizers:
https://lore.kernel.org/lkml/20200508063954.256593-1-irogers@google.com/

I was planning to come back to that once we got these changes landed.

Thanks!
Ian
