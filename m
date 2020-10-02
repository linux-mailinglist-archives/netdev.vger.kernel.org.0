Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id B99B22811E2
	for <lists+netdev@lfdr.de>; Fri,  2 Oct 2020 14:00:16 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2387785AbgJBMAK (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 2 Oct 2020 08:00:10 -0400
Received: from lhrrgout.huawei.com ([185.176.76.210]:2940 "EHLO huawei.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1725964AbgJBMAJ (ORCPT <rfc822;netdev@vger.kernel.org>);
        Fri, 2 Oct 2020 08:00:09 -0400
Received: from lhreml724-chm.china.huawei.com (unknown [172.18.7.106])
        by Forcepoint Email with ESMTP id 79E40690D0CDFE47C8A8;
        Fri,  2 Oct 2020 13:00:06 +0100 (IST)
Received: from [127.0.0.1] (10.47.8.137) by lhreml724-chm.china.huawei.com
 (10.201.108.75) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id 15.1.1913.5; Fri, 2 Oct 2020
 13:00:04 +0100
Subject: Issue of metrics for multiple uncore PMUs (was Re: [RFC PATCH v2
 23/23] perf metricgroup: remove duped metric group events)
To:     Ian Rogers <irogers@google.com>,
        Peter Zijlstra <peterz@infradead.org>,
        Ingo Molnar <mingo@redhat.com>,
        Arnaldo Carvalho de Melo <acme@kernel.org>,
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
        Jin Yao <yao.jin@linux.intel.com>,
        Kan Liang <kan.liang@linux.intel.com>,
        Cong Wang <xiyou.wangcong@gmail.com>,
        Kim Phillips <kim.phillips@amd.com>,
        <linux-kernel@vger.kernel.org>
CC:     <netdev@vger.kernel.org>, <bpf@vger.kernel.org>,
        <linux-perf-users@vger.kernel.org>,
        Stephane Eranian <eranian@google.com>
References: <20200507140819.126960-1-irogers@google.com>
 <20200507140819.126960-24-irogers@google.com>
From:   John Garry <john.garry@huawei.com>
Message-ID: <e3c4f253-e1ed-32f6-c252-e8657968fc42@huawei.com>
Date:   Fri, 2 Oct 2020 12:57:04 +0100
User-Agent: Mozilla/5.0 (Windows NT 10.0; WOW64; rv:68.0) Gecko/20100101
 Thunderbird/68.1.2
MIME-Version: 1.0
In-Reply-To: <20200507140819.126960-24-irogers@google.com>
Content-Type: text/plain; charset="utf-8"; format=flowed
Content-Language: en-US
Content-Transfer-Encoding: 7bit
X-Originating-IP: [10.47.8.137]
X-ClientProxiedBy: lhreml727-chm.china.huawei.com (10.201.108.78) To
 lhreml724-chm.china.huawei.com (10.201.108.75)
X-CFilter-Loop: Reflected
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On 07/05/2020 15:08, Ian Rogers wrote:

Hi Ian,

I was wondering if you ever tested commit 2440689d62e9 ("perf 
metricgroup: Remove duped metric group events") for when we have a 
metric which aliases multiple instances of the same uncore PMU in the 
system?

I have been rebasing some of my arm64 perf work to v5.9-rc7, and find an 
issue where find_evsel_group() fails for the uncore metrics under the 
condition mentioned above.

Unfortunately I don't have an x86 machine to which this test applies. 
However, as an experiment, I added a test metric to my broadwell JSON:

diff --git a/tools/perf/pmu-events/arch/x86/broadwell/bdw-metrics.json 
b/tools/perf/pmu-events/arch/x86/broadwell/bdw-metrics.json
index 8cdc7c13dc2a..fc6d9adf996a 100644
--- a/tools/perf/pmu-events/arch/x86/broadwell/bdw-metrics.json
+++ b/tools/perf/pmu-events/arch/x86/broadwell/bdw-metrics.json
@@ -348,5 +348,11 @@
         "MetricExpr": "(cstate_pkg@c7\\-residency@ / msr@tsc@) * 100",
         "MetricGroup": "Power",
         "MetricName": "C7_Pkg_Residency"
+    },
+    {
+        "BriefDescription": "test metric",
+        "MetricExpr": "UNC_CBO_XSNP_RESPONSE.MISS_XCORE * 
UNC_CBO_XSNP_RESPONSE.MISS_EVICTION",
+        "MetricGroup": "Test",
+        "MetricName": "test_metric_inc"
     }
]


And get this:

john@localhost:~/linux/tools/perf> sudo ./perf stat -v -M 
test_metric_inc sleep 1
Using CPUID GenuineIntel-6-3D-4
metric expr unc_cbo_xsnp_response.miss_xcore * 
unc_cbo_xsnp_response.miss_eviction for test_metric_inc
found event unc_cbo_xsnp_response.miss_eviction
found event unc_cbo_xsnp_response.miss_xcore
adding 
{unc_cbo_xsnp_response.miss_eviction,unc_cbo_xsnp_response.miss_xcore}:W
unc_cbo_xsnp_response.miss_eviction -> uncore_cbox_1/umask=0x81,event=0x22/
unc_cbo_xsnp_response.miss_eviction -> uncore_cbox_0/umask=0x81,event=0x22/
unc_cbo_xsnp_response.miss_xcore -> uncore_cbox_1/umask=0x41,event=0x22/
unc_cbo_xsnp_response.miss_xcore -> uncore_cbox_0/umask=0x41,event=0x22/
Cannot resolve test_metric_inc: unc_cbo_xsnp_response.miss_xcore * 
unc_cbo_xsnp_response.miss_eviction
task-clock: 688876 688876 688876
context-switches: 2 688876 688876
cpu-migrations: 0 688876 688876
page-faults: 69 688876 688876
cycles: 2101719 695690 695690
instructions: 1180534 695690 695690
branches: 249450 695690 695690
branch-misses: 10815 695690 695690

Performance counter stats for 'sleep 1':

              0.69 msec task-clock                #    0.001 CPUs 
utilized
                 2      context-switches          #    0.003 M/sec 

                 0      cpu-migrations            #    0.000 K/sec 

                69      page-faults               #    0.100 M/sec 

         2,101,719      cycles                    #    3.051 GHz 

         1,180,534      instructions              #    0.56  insn per 
cycle
           249,450      branches                  #  362.112 M/sec 

            10,815      branch-misses             #    4.34% of all 
branches

       1.001177693 seconds time elapsed

       0.001149000 seconds user
       0.000000000 seconds sys


john@localhost:~/linux/tools/perf>


Any idea what is going wrong here, before I have to dive in? The issue 
seems to be this named commit.

Thanks,
John

> A metric group contains multiple metrics. These metrics may use the same
> events. If metrics use separate events then it leads to more
> multiplexing and overall metric counts fail to sum to 100%.
> Modify how metrics are associated with events so that if the events in
> an earlier group satisfy the current metric, the same events are used.
> A record of used events is kept and at the end of processing unnecessary
> events are eliminated.
> 
> Before:
