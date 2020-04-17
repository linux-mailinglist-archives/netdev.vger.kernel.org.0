Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 28C321AD980
	for <lists+netdev@lfdr.de>; Fri, 17 Apr 2020 11:09:22 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1730188AbgDQJJS (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 17 Apr 2020 05:09:18 -0400
Received: from us-smtp-2.mimecast.com ([207.211.31.81]:21843 "EHLO
        us-smtp-delivery-1.mimecast.com" rhost-flags-OK-OK-OK-FAIL)
        by vger.kernel.org with ESMTP id S1730166AbgDQJJR (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 17 Apr 2020 05:09:17 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1587114556;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         in-reply-to:in-reply-to:references:references;
        bh=2cCOf6XJLp8oVY3ARJuZvdamGJsDNMFwpwD+jmxrCyc=;
        b=i+qpCyA1wuhio4PheKZiow/KpwSdGwSzeRdUSknjf+g6shwm4c1MChNNAFwvPJwnhaeFpU
        Vb4VdvftfH8vypCjN0ycfzD/+VyD6gCtFjiKhKMsEZXxgPnqoUSwpYbJ9CpW0TOfdvwmQ+
        YtfqdRjTcB2WoUitqMi0ARDhs8eBVa0=
Received: from mimecast-mx01.redhat.com (mimecast-mx01.redhat.com
 [209.132.183.4]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-271-H6wdLbRDNBil-5rkjGT0_Q-1; Fri, 17 Apr 2020 05:09:11 -0400
X-MC-Unique: H6wdLbRDNBil-5rkjGT0_Q-1
Received: from smtp.corp.redhat.com (int-mx07.intmail.prod.int.phx2.redhat.com [10.5.11.22])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mimecast-mx01.redhat.com (Postfix) with ESMTPS id E6B5A107ACC4;
        Fri, 17 Apr 2020 09:09:07 +0000 (UTC)
Received: from krava (unknown [10.40.195.134])
        by smtp.corp.redhat.com (Postfix) with ESMTPS id C7C8E100EBA4;
        Fri, 17 Apr 2020 09:08:12 +0000 (UTC)
Date:   Fri, 17 Apr 2020 11:08:10 +0200
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
Subject: Re: [PATCH v11 0/4] perf tools: add support for libpfm4
Message-ID: <20200417090810.GA468827@krava>
References: <20200416221457.46710-1-irogers@google.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20200416221457.46710-1-irogers@google.com>
X-Scanned-By: MIMEDefang 2.84 on 10.5.11.22
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Thu, Apr 16, 2020 at 03:14:53PM -0700, Ian Rogers wrote:
> This patch links perf with the libpfm4 library if it is available
> and NO_LIBPFM4 isn't passed to the build. The libpfm4 library
> contains hardware event tables for all processors supported by
> perf_events. It is a helper library that helps convert from a
> symbolic event name to the event encoding required by the
> underlying kernel interface. This library is open-source and
> available from: http://perfmon2.sf.net.
>     
> With this patch, it is possible to specify full hardware events
> by name. Hardware filters are also supported. Events must be
> specified via the --pfm-events and not -e option. Both options
> are active at the same time and it is possible to mix and match:
>     
> $ perf stat --pfm-events inst_retired:any_p:c=1:i -e cycles ....
> 
> v11 reformats the perf list output to be:
> List of pre-defined events (to be used in -e):
> 
>   branch-instructions OR branches                    [Hardware event]
>   branch-misses                                      [Hardware event]
> ...
> 
> List of pre-defined events (to be used in --pfm-events):
> 
> ix86arch:
>   UNHALTED_CORE_CYCLES
>     [count core clock cycles whenever the clock signal on the specific core is running (not halted)]
>   INSTRUCTION_RETIRED
>     [count the number of instructions at retirement. For instructions that consists of multiple mic>
> ...
> skx:
>   UNHALTED_CORE_CYCLES
>     [Count core clock cycles whenever the clock signal on the specific core is running (not halted)]
> ...
>   BACLEARS
>     [Branch re-steered]
>       BACLEARS:ANY
>         [Number of front-end re-steers due to BPU misprediction]
> ...

Acked-by: Jiri Olsa <jolsa@redhat.com>

thanks,
jirka

