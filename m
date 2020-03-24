Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 78A7D190ADC
	for <lists+netdev@lfdr.de>; Tue, 24 Mar 2020 11:25:37 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727227AbgCXKZe (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 24 Mar 2020 06:25:34 -0400
Received: from us-smtp-delivery-74.mimecast.com ([216.205.24.74]:45043 "EHLO
        us-smtp-delivery-74.mimecast.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1726697AbgCXKZd (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 24 Mar 2020 06:25:33 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1585045533;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         in-reply-to:in-reply-to:references:references;
        bh=1uFndSPegRG+EuvCEPo50gmlgFaTjR12UYyGMB2agT0=;
        b=eT3lUmy/c9+vAq8KIAJF0UbAydX/hcSRloq9mzWuDO0Gy3z26rjC8HrGhVKLHFm6AAMLl6
        3VP3xHmQKVrrXnF2IISvVHiA4L2rOkSrlKeKqY+rE0jjH4+aBoZrfiDu8OchtF2LmayryF
        4TyFAEzvCrB0UXMqXuDSgBexHKevcRo=
Received: from mimecast-mx01.redhat.com (mimecast-mx01.redhat.com
 [209.132.183.4]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-383-fs7X8Db2OW-RqLYsS2OVOg-1; Tue, 24 Mar 2020 06:25:26 -0400
X-MC-Unique: fs7X8Db2OW-RqLYsS2OVOg-1
Received: from smtp.corp.redhat.com (int-mx04.intmail.prod.int.phx2.redhat.com [10.5.11.14])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mimecast-mx01.redhat.com (Postfix) with ESMTPS id 2B67F1088383;
        Tue, 24 Mar 2020 10:25:22 +0000 (UTC)
Received: from krava (unknown [10.40.192.119])
        by smtp.corp.redhat.com (Postfix) with ESMTPS id C3E915DA66;
        Tue, 24 Mar 2020 10:25:05 +0000 (UTC)
Date:   Tue, 24 Mar 2020 11:24:59 +0100
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
Message-ID: <20200324102459.GL1534489@krava>
References: <20200323235846.104937-1-irogers@google.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20200323235846.104937-1-irogers@google.com>
X-Scanned-By: MIMEDefang 2.79 on 10.5.11.14
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Mon, Mar 23, 2020 at 04:58:46PM -0700, Ian Rogers wrote:

SNIP

> diff --git a/tools/perf/util/parse-events.c b/tools/perf/util/parse-events.c
> index 10107747b361..31ed184566c8 100644
> --- a/tools/perf/util/parse-events.c
> +++ b/tools/perf/util/parse-events.c
> @@ -37,6 +37,11 @@
>  #include "util/evsel_config.h"
>  #include "util/event.h"
>  
> +#ifdef HAVE_LIBPFM
> +#include <perfmon/pfmlib_perf_event.h>
> +static void print_libpfm_events(bool name_only);
> +#endif
> +
>  #define MAX_NAME_LEN 100
>  
>  #ifdef PARSER_DEBUG
> @@ -2794,6 +2799,10 @@ void print_events(const char *event_glob, bool name_only, bool quiet_flag,
>  	print_sdt_events(NULL, NULL, name_only);
>  
>  	metricgroup__print(true, true, NULL, name_only, details_flag);
> +
> +#ifdef HAVE_LIBPFM
> +	print_libpfm_events(name_only);


we should make some effort to fit this into our current list shape,
currently it looks like:

	$ perf list
	...

	TopdownL1_SMT:
	  Backend_Bound_SMT
	       [This category represents fraction of slots where no uops are being delivered due to a lack of required resources for accepting new uops in the Backend>
	  Bad_Speculation_SMT
	       [This category represents fraction of slots wasted due to incorrect speculations. SMT version; use when SMT is enabled and measuring per logical CPU]
	  Frontend_Bound_SMT
	       [This category represents fraction of slots where the processor's Frontend undersupplies its Backend. SMT version; use when SMT is enabled and measurin>
	  Retiring_SMT
	       [This category represents fraction of slots utilized by useful work i.e. issued uops that eventually get retired. SMT version; use when SMT is enabled >


	Name  : UNHALTED_CORE_CYCLES
	PMU   : ix86arch
	Desc  : count core clock cycles whenever the clock signal on the specific core is running (not halted)
	Equiv : None
	Code  : 0x3c
	Modif : PMU: [e] : edge level (may require counter-mask >= 1) (boolean)
	Modif : PMU: [i] : invert (boolean)
	Modif : PMU: [c] : counter-mask in range [0-255] (integer)
	Modif : PMU: [t] : measure any thread (boolean)
	Modif : PMU: [intx] : monitor only inside transactional memory region (boolean)
	Modif : PMU: [intxcp] : do not count occurrences inside aborted transactional memory region (boolean)
	Modif : perf_event: [u] : monitor at user level (boolean)
	Modif : perf_event: [k] : monitor at kernel level (boolean)
	Modif : perf_event: [period] : sampling period (integer)
	Modif : perf_event: [freq] : sampling frequency (Hz) (integer)
	Modif : perf_event: [excl] : exclusive access (boolean)
	Modif : perf_event: [mg] : monitor guest execution (boolean)
	Modif : perf_event: [mh] : monitor host execution (boolean)
	Modif : perf_event: [cpu] : CPU to program (integer)
	Modif : perf_event: [pinned] : pin event to counters (boolean)

it needs some header like 'libpfm events:' and then
probably just name and doc for basic list and more
verbose for -v

jirka

