Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 246624548B5
	for <lists+netdev@lfdr.de>; Wed, 17 Nov 2021 15:31:07 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S238504AbhKQOeD (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 17 Nov 2021 09:34:03 -0500
Received: from mail.kernel.org ([198.145.29.99]:55412 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S235127AbhKQOeC (ORCPT <rfc822;netdev@vger.kernel.org>);
        Wed, 17 Nov 2021 09:34:02 -0500
Received: by mail.kernel.org (Postfix) with ESMTPSA id A2BCB613B1;
        Wed, 17 Nov 2021 14:31:03 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1637159464;
        bh=FUgQvzc3GBwWhFrOHosUZzSkmX09ovNiILZYlXvAIZY=;
        h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
        b=cgbgSLmi38RydHFpjBi2pnb+ME0ol6saKBRAnq3PYF0H9217xaPkBpWN3Q1IVxRR2
         STFFWJqRVrkSIxTXu2JRW8AFV5/SodYjNYcJhxaa7mLFSfrVEGlSCh8/BmNqZpdT02
         +YSvkVWU0AuhiCIapGTQSi2N/SWHzSxRhvGl2MqGeRT3fRZ7XPGaKTr9w+8e29daEU
         neRit7H01NdUG7C53w8bVs8vsx9OMBMq9m7GFXaJuUZygfEwcSGStuHn9kc9doPPAo
         YPZta3AZQfiBuIzczIlpit0P0XI1Gv9pzVtTYX1d+1R+3+DNhs034rzLQflyAwCKSe
         5mXdWFNCMESSw==
Received: by quaco.ghostprotocols.net (Postfix, from userid 1000)
        id 4238A4088E; Wed, 17 Nov 2021 11:31:01 -0300 (-03)
Date:   Wed, 17 Nov 2021 11:31:01 -0300
From:   Arnaldo Carvalho de Melo <acme@kernel.org>
To:     Yafang Shao <laoar.shao@gmail.com>
Cc:     akpm@linux-foundation.org, keescook@chromium.org,
        rostedt@goodmis.org, mathieu.desnoyers@efficios.com,
        arnaldo.melo@gmail.com, pmladek@suse.com, peterz@infradead.org,
        viro@zeniv.linux.org.uk, valentin.schneider@arm.com,
        qiang.zhang@windriver.com, robdclark@chromium.org,
        christian@brauner.io, dietmar.eggemann@arm.com, mingo@redhat.com,
        juri.lelli@redhat.com, vincent.guittot@linaro.org,
        davem@davemloft.net, kuba@kernel.org, ast@kernel.org,
        daniel@iogearbox.net, andrii@kernel.org, kafai@fb.com,
        songliubraving@fb.com, yhs@fb.com, john.fastabend@gmail.com,
        kpsingh@kernel.org, dennis.dalessandro@cornelisnetworks.com,
        mike.marciniszyn@cornelisnetworks.com, dledford@redhat.com,
        jgg@ziepe.ca, linux-rdma@vger.kernel.org, netdev@vger.kernel.org,
        bpf@vger.kernel.org, linux-perf-users@vger.kernel.org,
        linux-fsdevel@vger.kernel.org, linux-mm@kvack.org,
        linux-kernel@vger.kernel.org, oliver.sang@intel.com, lkp@intel.com,
        Alexei Starovoitov <alexei.starovoitov@gmail.com>,
        Andrii Nakryiko <andrii.nakryiko@gmail.com>
Subject: Re: [PATCH v7 08/11] tools/perf/test: make perf test adopt to task
 comm size change
Message-ID: <YZUSJQqDeY06nBsB@kernel.org>
References: <20211101060419.4682-1-laoar.shao@gmail.com>
 <20211101060419.4682-9-laoar.shao@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20211101060419.4682-9-laoar.shao@gmail.com>
X-Url:  http://acmel.wordpress.com
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Em Mon, Nov 01, 2021 at 06:04:16AM +0000, Yafang Shao escreveu:
> kernel test robot reported a perf-test failure after I extended task comm
> size from 16 to 24. The failure as follows,
> 
> 2021-10-13 18:00:46 sudo /usr/src/perf_selftests-x86_64-rhel-8.3-317419b91ef4eff4e2f046088201e4dc4065caa0/tools/perf/perf test 15
> 15: Parse sched tracepoints fields                                  : FAILED!
> 
> The reason is perf-test requires a fixed-size task comm. If we extend
> task comm size to 24, it will not equil with the required size 16 in perf
> test.
> 
> After some analyzation, I found perf itself can adopt to the size
> change, for example, below is the output of perf-sched after I extend
> comm size to 24 -
> 
> task    614 (            kthreadd:        84), nr_events: 1
> task    615 (             systemd:       843), nr_events: 1
> task    616 (     networkd-dispat:      1026), nr_events: 1
> task    617 (             systemd:       846), nr_events: 1
> 
> $ cat /proc/843/comm
> networkd-dispatcher
> 
> The task comm can be displayed correctly as expected.
> 
> Replace old hard-coded 16 with the new one can fix the warning, but we'd
> better make the test accept both old and new sizes, then it can be
> backward compatibility.
> 
> After this patch, the perf-test succeeds no matter task comm is 16 or
> 24 -
> 
> 15: Parse sched tracepoints fields                                  : Ok
> 
> This patch is a preparation for the followup patch.
> 
> Reported-by: kernel test robot <oliver.sang@intel.com>
> Suggested-by: Arnaldo Carvalho de Melo <arnaldo.melo@gmail.com>
> Signed-off-by: Yafang Shao <laoar.shao@gmail.com>
> Cc: Mathieu Desnoyers <mathieu.desnoyers@efficios.com>
> Cc: Arnaldo Carvalho de Melo <arnaldo.melo@gmail.com>
> Cc: Alexei Starovoitov <alexei.starovoitov@gmail.com>
> Cc: Andrii Nakryiko <andrii.nakryiko@gmail.com>
> Cc: Peter Zijlstra <peterz@infradead.org>
> Cc: Steven Rostedt <rostedt@goodmis.org>
> Cc: Al Viro <viro@zeniv.linux.org.uk>
> Cc: Kees Cook <keescook@chromium.org>
> Cc: Petr Mladek <pmladek@suse.com>
> ---
>  tools/include/linux/sched.h       | 11 +++++++++++
>  tools/perf/tests/evsel-tp-sched.c | 26 ++++++++++++++++++++------
>  2 files changed, 31 insertions(+), 6 deletions(-)
>  create mode 100644 tools/include/linux/sched.h
> 
> diff --git a/tools/include/linux/sched.h b/tools/include/linux/sched.h
> new file mode 100644
> index 000000000000..0d575afd7f43
> --- /dev/null
> +++ b/tools/include/linux/sched.h
> @@ -0,0 +1,11 @@
> +/* SPDX-License-Identifier: GPL-2.0 */
> +#ifndef _TOOLS_LINUX_SCHED_H
> +#define _TOOLS_LINUX_SCHED_H
> +
> +/* Keep both length for backward compatibility */
> +enum {
> +	TASK_COMM_LEN_16 = 16,
> +	TASK_COMM_LEN = 24,
> +};
> +

I don't think this is a good idea, to have it in tools/include/linux/,
we have /usr/include/linux/sched.h, this may end up confusing the build
at some point as your proposal is for a trimmed down header while what
is in /usr/include/linux/sched.h doesn't have just this.

But since we're using enums for this, we can't check for it with:

#ifdef TASK_COMM_LEN_16
#define TASK_COMM_LEN_16 16
#endif

ditto for TASK_COMM_LEN and be future proof, so I'd say just use
hardcoded values in tools/perf/tests/evsel-tp-sched.c?

- Arnaldo

> +#endif  /* _TOOLS_LINUX_SCHED_H */
> diff --git a/tools/perf/tests/evsel-tp-sched.c b/tools/perf/tests/evsel-tp-sched.c
> index f9e34bd26cf3..029f2a8c8e51 100644
> --- a/tools/perf/tests/evsel-tp-sched.c
> +++ b/tools/perf/tests/evsel-tp-sched.c
> @@ -1,11 +1,13 @@
>  // SPDX-License-Identifier: GPL-2.0
>  #include <linux/err.h>
> +#include <linux/sched.h>
>  #include <traceevent/event-parse.h>
>  #include "evsel.h"
>  #include "tests.h"
>  #include "debug.h"
>  
> -static int evsel__test_field(struct evsel *evsel, const char *name, int size, bool should_be_signed)
> +static int evsel__test_field_alt(struct evsel *evsel, const char *name,
> +				 int size, int alternate_size, bool should_be_signed)
>  {
>  	struct tep_format_field *field = evsel__field(evsel, name);
>  	int is_signed;
> @@ -23,15 +25,24 @@ static int evsel__test_field(struct evsel *evsel, const char *name, int size, bo
>  		ret = -1;
>  	}
>  
> -	if (field->size != size) {
> -		pr_debug("%s: \"%s\" size (%d) should be %d!\n",
> +	if (field->size != size && field->size != alternate_size) {
> +		pr_debug("%s: \"%s\" size (%d) should be %d",
>  			 evsel->name, name, field->size, size);
> +		if (alternate_size > 0)
> +			pr_debug(" or %d", alternate_size);
> +		pr_debug("!\n");
>  		ret = -1;
>  	}
>  
>  	return ret;
>  }
>  
> +static int evsel__test_field(struct evsel *evsel, const char *name,
> +			     int size, bool should_be_signed)
> +{
> +	return evsel__test_field_alt(evsel, name, size, -1, should_be_signed);
> +}
> +
>  int test__perf_evsel__tp_sched_test(struct test *test __maybe_unused, int subtest __maybe_unused)
>  {
>  	struct evsel *evsel = evsel__newtp("sched", "sched_switch");
> @@ -42,7 +53,8 @@ int test__perf_evsel__tp_sched_test(struct test *test __maybe_unused, int subtes
>  		return -1;
>  	}
>  
> -	if (evsel__test_field(evsel, "prev_comm", 16, false))
> +	if (evsel__test_field_alt(evsel, "prev_comm", TASK_COMM_LEN_16,
> +				  TASK_COMM_LEN, false))
>  		ret = -1;
>  
>  	if (evsel__test_field(evsel, "prev_pid", 4, true))
> @@ -54,7 +66,8 @@ int test__perf_evsel__tp_sched_test(struct test *test __maybe_unused, int subtes
>  	if (evsel__test_field(evsel, "prev_state", sizeof(long), true))
>  		ret = -1;
>  
> -	if (evsel__test_field(evsel, "next_comm", 16, false))
> +	if (evsel__test_field_alt(evsel, "next_comm", TASK_COMM_LEN_16,
> +				  TASK_COMM_LEN, false))
>  		ret = -1;
>  
>  	if (evsel__test_field(evsel, "next_pid", 4, true))
> @@ -72,7 +85,8 @@ int test__perf_evsel__tp_sched_test(struct test *test __maybe_unused, int subtes
>  		return -1;
>  	}
>  
> -	if (evsel__test_field(evsel, "comm", 16, false))
> +	if (evsel__test_field_alt(evsel, "comm", TASK_COMM_LEN_16,
> +				  TASK_COMM_LEN, false))
>  		ret = -1;
>  
>  	if (evsel__test_field(evsel, "pid", 4, true))
> -- 
> 2.17.1

-- 

- Arnaldo
