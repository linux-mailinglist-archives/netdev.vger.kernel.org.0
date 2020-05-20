Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id B10CC1DA811
	for <lists+netdev@lfdr.de>; Wed, 20 May 2020 04:34:51 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728489AbgETCeq (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 19 May 2020 22:34:46 -0400
Received: from mail.kernel.org ([198.145.29.99]:43258 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726352AbgETCep (ORCPT <rfc822;netdev@vger.kernel.org>);
        Tue, 19 May 2020 22:34:45 -0400
Received: from quaco.ghostprotocols.net (unknown [179.97.37.151])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 19D9F2075F;
        Wed, 20 May 2020 02:34:45 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1589942085;
        bh=5TX6blDXQ6f+6hKSGCxomiV/h9BfQhuTdQ1tm+sld0Q=;
        h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
        b=klTWpgECYRftIP9DfV5mt0U3/nHgbW3YxUGGev8YNKgKYSbR6PX904dQj9BXy+wwR
         Z57gcVqNNDl8oZQ0XqQt4jR8uStgPIqDNn91m1Hty6nAQEazs44wW6mpqpznPL70Lr
         2SM+1MGRt9qkjE38McwUKkvY60bdDnwI6cC1wIjI=
Received: by quaco.ghostprotocols.net (Postfix, from userid 1000)
        id 0C7C740AFD; Tue, 19 May 2020 23:34:43 -0300 (-03)
Date:   Tue, 19 May 2020 23:34:43 -0300
From:   Arnaldo Carvalho de Melo <acme@kernel.org>
To:     Ian Rogers <irogers@google.com>
Cc:     Arnaldo Carvalho de Melo <arnaldo.melo@gmail.com>,
        Peter Zijlstra <peterz@infradead.org>,
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
        Stephane Eranian <eranian@google.com>,
        Paul Clarke <pc@us.ibm.com>,
        Arnaldo Carvalho de Melo <acme@redhat.com>,
        Alexey Budankov <alexey.budankov@linux.intel.com>
Subject: Re: [PATCH v3 6/7] perf test: Improve pmu event metric testing
Message-ID: <20200520023443.GE32678@kernel.org>
References: <20200515221732.44078-1-irogers@google.com>
 <20200515221732.44078-7-irogers@google.com>
 <20200519190602.GB28228@kernel.org>
 <CAP-5=fVdDjazSdzfTXeuWwqCSh0zURp3M8QZpYK=qd92GeyrRw@mail.gmail.com>
 <20200520011548.GD28228@kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20200520011548.GD28228@kernel.org>
X-Url:  http://acmel.wordpress.com
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Em Tue, May 19, 2020 at 10:15:48PM -0300, Arnaldo Carvalho de Melo escreveu:
> Em Tue, May 19, 2020 at 01:15:41PM -0700, Ian Rogers escreveu:
> > On Tue, May 19, 2020 at 12:06 PM Arnaldo Carvalho de Melo
> > errno != 0 for both cases as the man page notes suggest doing this.
> > The tests using v are necessary to avoid the unused result, but
> > presumably any errno case should return false here? I guess testing
> > that is redundant as the return below will catch it. Perhaps this
> > should be:
> > 
> > errno = 0;
> > v = strtod(str, &end_ptr);
> > (void)v;  /* We don't care for the value of the double, just that it
> > converts. Avoid unused result warnings. */
> > return errno == 0 && end_ptr != str;
> 
> Ok, I'll try that one.

What I have is in my tmp.perf/core branch, this and the hashmap.h
__WORDSIZE fixups, with those all the alpine Linux containers, that use
Musl libc passed, waiting for the remaining 80 other containers to
finish, now lots of these containers build with and without NO_LIBBPF=1
to make sure we test both variants,

- Arnaldo
