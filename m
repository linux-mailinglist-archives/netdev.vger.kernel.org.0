Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id DEE5F472E1E
	for <lists+netdev@lfdr.de>; Mon, 13 Dec 2021 14:54:40 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S238340AbhLMNyj (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 13 Dec 2021 08:54:39 -0500
Received: from foss.arm.com ([217.140.110.172]:55602 "EHLO foss.arm.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S233777AbhLMNyi (ORCPT <rfc822;netdev@vger.kernel.org>);
        Mon, 13 Dec 2021 08:54:38 -0500
Received: from usa-sjc-imap-foss1.foss.arm.com (unknown [10.121.207.14])
        by usa-sjc-mx-foss1.foss.arm.com (Postfix) with ESMTP id 1B5EF1FB;
        Mon, 13 Dec 2021 05:54:38 -0800 (PST)
Received: from [10.57.34.21] (unknown [10.57.34.21])
        by usa-sjc-imap-foss1.foss.arm.com (Postfix) with ESMTPSA id 203BD3F73B;
        Mon, 13 Dec 2021 05:54:35 -0800 (PST)
Subject: Re: [PATCH v1 2/2] perf evlist: Don't run perf in non-root PID
 namespace when launch workload
To:     Leo Yan <leo.yan@linaro.org>
References: <20211212134721.1721245-1-leo.yan@linaro.org>
 <20211212134721.1721245-3-leo.yan@linaro.org>
Cc:     Arnaldo Carvalho de Melo <acme@kernel.org>,
        Jiri Olsa <jolsa@redhat.com>,
        Peter Zijlstra <peterz@infradead.org>,
        Ingo Molnar <mingo@redhat.com>,
        Mark Rutland <mark.rutland@arm.com>,
        Alexander Shishkin <alexander.shishkin@linux.intel.com>,
        Namhyung Kim <namhyung@kernel.org>,
        Alexei Starovoitov <ast@kernel.org>,
        Daniel Borkmann <daniel@iogearbox.net>,
        Andrii Nakryiko <andrii@kernel.org>,
        Martin KaFai Lau <kafai@fb.com>,
        Song Liu <songliubraving@fb.com>, Yonghong Song <yhs@fb.com>,
        John Fastabend <john.fastabend@gmail.com>,
        KP Singh <kpsingh@kernel.org>,
        Jin Yao <yao.jin@linux.intel.com>,
        John Garry <john.garry@huawei.com>,
        Yonatan Goldschmidt <yonatan.goldschmidt@granulate.io>,
        linux-perf-users@vger.kernel.org, linux-kernel@vger.kernel.org,
        netdev@vger.kernel.org, bpf@vger.kernel.org
From:   James Clark <james.clark@arm.com>
Message-ID: <6cad0a2e-c4b8-9788-fa0d-05405453a0dd@arm.com>
Date:   Mon, 13 Dec 2021 13:54:33 +0000
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:78.0) Gecko/20100101
 Thunderbird/78.13.0
MIME-Version: 1.0
In-Reply-To: <20211212134721.1721245-3-leo.yan@linaro.org>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org



On 12/12/2021 13:47, Leo Yan wrote:
> In function evlist__prepare_workload(), after perf forks a child process
> and launches a workload in the created process, it needs to retrieve
> process and namespace related info via '/proc/$PID/' node.
> 
> The process folders under 'proc' file system use the PID number from the
> root PID namespace, when perf tool runs in non-root PID namespace and
> creates new process for profiled program, this leads to the perf tool
> wrongly gather process info since it uses PID from non-root namespace to
> access nodes under '/proc'.
> 
> Let's see an example:
> 
>   unshare --fork --pid perf record -e cs_etm//u -a -- test_program
> 
> This command runs perf tool and the profiled program 'test_program' in
> the non-root PID namespace.  When perf tool launches 'test_program',
> e.g. the forked PID number is 2, perf tool retrieves process info for
> 'test_program' from the folder '/proc/2'.  But '/proc/2' is actually for
> a kernel thread so perf tool wrongly gather info for 'test_program'.

Hi Leo,

Which features aren't working exactly when you run in a non root namespace?

I did "perf record -- ls" and it seemed to be working for me. At least kernel
sampling would be working in a namespace, even if there was something wrong
with userspace.

I think causing a failure might be too restrictive and would prevent people
from using perf in a container. Maybe we could show a warning instead, but
I'm not sure exactly what's not working because I thought perf looked up stuff
based on the path of the process not the pid.

James

> 
> To fix this issue, we don't allow perf tool runs in non-root PID
> namespace when it launches workload and reports error in this
> case.  This can notify users to run the perf tool in root PID namespace
> to gather correct info for profiled program.
> 
> Signed-off-by: Leo Yan <leo.yan@linaro.org>
> ---
>  tools/perf/util/evlist.c | 7 +++++++
>  1 file changed, 7 insertions(+)
> 
> diff --git a/tools/perf/util/evlist.c b/tools/perf/util/evlist.c
> index 5f92319ce258..bdf79a97db66 100644
> --- a/tools/perf/util/evlist.c
> +++ b/tools/perf/util/evlist.c
> @@ -11,6 +11,7 @@
>  #include <poll.h>
>  #include "cpumap.h"
>  #include "util/mmap.h"
> +#include "util/namespaces.h"
>  #include "thread_map.h"
>  #include "target.h"
>  #include "evlist.h"
> @@ -1364,6 +1365,12 @@ int evlist__prepare_workload(struct evlist *evlist, struct target *target, const
>  	int child_ready_pipe[2], go_pipe[2];
>  	char bf;
>  
> +	if (!nsinfo__is_in_root_namespace()) {
> +		pr_err("Perf runs in non-root PID namespace; please run perf tool ");
> +		pr_err("in the root PID namespace for gathering process info.\n");
> +		return -EPERM;
> +	}
> +
>  	if (pipe(child_ready_pipe) < 0) {
>  		perror("failed to create 'ready' pipe");
>  		return -1;
> 
