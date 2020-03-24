Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 4AC7B190AF4
	for <lists+netdev@lfdr.de>; Tue, 24 Mar 2020 11:29:16 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727385AbgCXK2F (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 24 Mar 2020 06:28:05 -0400
Received: from us-smtp-delivery-74.mimecast.com ([216.205.24.74]:47852 "EHLO
        us-smtp-delivery-74.mimecast.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1727130AbgCXK2E (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 24 Mar 2020 06:28:04 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1585045684;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         in-reply-to:in-reply-to:references:references;
        bh=Fb+k064Enl6GEK9uiujgF/I3NuLpU7i+xLE00RoVePc=;
        b=BYs7FNPOqIO7wB2wq5erWsw3fAz7R7av2E+StrP0w0P/JzYhb+WdvA+ramfHCPad0kJeAe
        6+Z2tEIq0pYHkKsK96NEWG8lG0oowZRI+WWOiMmv3gwpjNkEvnf7IIDJwXmVyHMjwYUzeJ
        t/ebjozpSxlf/psBJfbBFx69W8k1fTc=
Received: from mimecast-mx01.redhat.com (mimecast-mx01.redhat.com
 [209.132.183.4]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-183-5b9ot_9dM2OYVVo-MmeC0A-1; Tue, 24 Mar 2020 06:28:00 -0400
X-MC-Unique: 5b9ot_9dM2OYVVo-MmeC0A-1
Received: from smtp.corp.redhat.com (int-mx02.intmail.prod.int.phx2.redhat.com [10.5.11.12])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mimecast-mx01.redhat.com (Postfix) with ESMTPS id 07048149C1;
        Tue, 24 Mar 2020 10:27:56 +0000 (UTC)
Received: from krava (unknown [10.40.192.119])
        by smtp.corp.redhat.com (Postfix) with ESMTPS id EE4BD60BF3;
        Tue, 24 Mar 2020 10:27:36 +0000 (UTC)
Date:   Tue, 24 Mar 2020 11:27:32 +0100
From:   Jiri Olsa <jolsa@redhat.com>
To:     Ian Rogers <irogers@google.com>
Cc:     Peter Zijlstra <peterz@infradead.org>,
        Ingo Molnar <mingo@redhat.com>,
        Arnaldo Carvalho de Melo <acme@kernel.org>,
        Mark Rutland <mark.rutland@arm.com>,
        Alexander Shishkin <alexander.shishkin@linux.intel.com>,
        Namhyung Kim <namhyung@kernel.org>,
        Alexei Starovoitov <ast@kernel.org>,
        Daniel Borkmann <daniel@iogearbox.net>,
        Martin KaFai Lau <kafai@fb.com>, Yonghong Song <yhs@fb.com>,
        Andrii Nakryiko <andriin@fb.com>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        Thomas Gleixner <tglx@linutronix.de>,
        Igor Lubashev <ilubashe@akamai.com>,
        Alexey Budankov <alexey.budankov@linux.intel.com>,
        Florian Fainelli <f.fainelli@gmail.com>,
        Adrian Hunter <adrian.hunter@intel.com>,
        Andi Kleen <ak@linux.intel.com>,
        Jiwei Sun <jiwei.sun@windriver.com>,
        yuzhoujian <yuzhoujian@didichuxing.com>,
        Kan Liang <kan.liang@linux.intel.com>,
        Jin Yao <yao.jin@linux.intel.com>,
        Leo Yan <leo.yan@linaro.org>,
        John Garry <john.garry@huawei.com>,
        linux-kernel@vger.kernel.org, netdev@vger.kernel.org,
        bpf@vger.kernel.org, linux-perf-users@vger.kernel.org,
        Stephane Eranian <eranian@google.com>
Subject: Re: [PATCH v5] perf tools: add support for libpfm4
Message-ID: <20200324102732.GR1534489@krava>
References: <20200323235846.104937-1-irogers@google.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20200323235846.104937-1-irogers@google.com>
X-Scanned-By: MIMEDefang 2.79 on 10.5.11.12
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Mon, Mar 23, 2020 at 04:58:46PM -0700, Ian Rogers wrote:
> This patch links perf with the libpfm4 library if it is available and
> NO_LIBPFM4 isn't passed to the build. The libpfm4 library contains hardware
> event tables for all processors supported by perf_events. It is a helper
> library that helps convert from a symbolic event name to the event
> encoding required by the underlying kernel interface. This
> library is open-source and available from: http://perfmon2.sf.net.
> 
> With this patch, it is possible to specify full hardware events
> by name. Hardware filters are also supported. Events must be
> specified via the --pfm-events and not -e option. Both options
> are active at the same time and it is possible to mix and match:
> 
> $ perf stat --pfm-events inst_retired:any_p:c=1:i -e cycles ....
> 
> v5 is a rebase.
> v4 is a rebase on git://git.kernel.org/pub/scm/linux/kernel/git/acme/linux.git
>    branch perf/core and re-adds the tools/build/feature/test-libpfm4.c
>    missed in v3.
> v3 is against acme/perf/core and removes a diagnostic warning.
> v2 of this patch makes the --pfm-events man page documentation
> conditional on libpfm4 behing configured. It tidies some of the
> documentation and adds the feature test missed in the v1 patch.
> 
> Author: Stephane Eranian <eranian@google.com>
> Signed-off-by: Ian Rogers <irogers@google.com>

I still have some conflicts, but I merged it by hand


	patching file tools/build/Makefile.feature
	patching file tools/build/feature/Makefile
	patching file tools/build/feature/test-libpfm4.c
	patching file tools/perf/Documentation/Makefile
	patching file tools/perf/Documentation/perf-record.txt
	patching file tools/perf/Documentation/perf-stat.txt
	patching file tools/perf/Documentation/perf-top.txt
	patching file tools/perf/Makefile.config
	patching file tools/perf/Makefile.perf
	Hunk #3 FAILED at 834.
	1 out of 3 hunks FAILED -- saving rejects to file tools/perf/Makefile.perf.rej
	patching file tools/perf/builtin-list.c
	patching file tools/perf/builtin-record.c
	patching file tools/perf/builtin-stat.c
	patching file tools/perf/builtin-top.c
	Hunk #2 succeeded at 1549 (offset 2 lines).
	Hunk #3 succeeded at 1567 (offset 2 lines).
	patching file tools/perf/util/evsel.c
	patching file tools/perf/util/evsel.h
	patching file tools/perf/util/parse-events.c
	patching file tools/perf/util/parse-events.h
	patching file tools/perf/util/pmu.c
	Hunk #1 succeeded at 869 (offset 5 lines).
	patching file tools/perf/util/pmu.h
	Hunk #1 succeeded at 65 (offset 1 line).

jirka

