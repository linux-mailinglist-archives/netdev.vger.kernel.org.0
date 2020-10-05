Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 9138A283DFC
	for <lists+netdev@lfdr.de>; Mon,  5 Oct 2020 20:08:30 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727320AbgJESIY (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 5 Oct 2020 14:08:24 -0400
Received: from lhrrgout.huawei.com ([185.176.76.210]:2957 "EHLO huawei.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1725960AbgJESIY (ORCPT <rfc822;netdev@vger.kernel.org>);
        Mon, 5 Oct 2020 14:08:24 -0400
Received: from lhreml724-chm.china.huawei.com (unknown [172.18.7.106])
        by Forcepoint Email with ESMTP id C9FE3F895F4435A2D160;
        Mon,  5 Oct 2020 19:08:21 +0100 (IST)
Received: from [127.0.0.1] (10.47.2.205) by lhreml724-chm.china.huawei.com
 (10.201.108.75) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id 15.1.1913.5; Mon, 5 Oct 2020
 19:08:19 +0100
Subject: Re: Issue of metrics for multiple uncore PMUs (was Re: [RFC PATCH v2
 23/23] perf metricgroup: remove duped metric group events)
To:     Ian Rogers <irogers@google.com>
CC:     Peter Zijlstra <peterz@infradead.org>,
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
        LKML <linux-kernel@vger.kernel.org>,
        Networking <netdev@vger.kernel.org>, bpf <bpf@vger.kernel.org>,
        linux-perf-users <linux-perf-users@vger.kernel.org>,
        Stephane Eranian <eranian@google.com>
References: <20200507140819.126960-1-irogers@google.com>
 <20200507140819.126960-24-irogers@google.com>
 <e3c4f253-e1ed-32f6-c252-e8657968fc42@huawei.com>
 <CAP-5=fXkYQ0ktt5DZYW=PPzgRN4_DeM08_def4Qn-6BPRvKW-A@mail.gmail.com>
 <757974b3-62b0-2822-84fb-1e75907c6cc4@huawei.com>
 <CAP-5=fXwQZVDxJM4LmEvsKW9h0HYP6t3F0EZfy0+hwAzDmBgGA@mail.gmail.com>
From:   John Garry <john.garry@huawei.com>
Message-ID: <248e8d19-8727-b403-4196-59eac1b1f305@huawei.com>
Date:   Mon, 5 Oct 2020 19:05:17 +0100
User-Agent: Mozilla/5.0 (Windows NT 10.0; WOW64; rv:68.0) Gecko/20100101
 Thunderbird/68.1.2
MIME-Version: 1.0
In-Reply-To: <CAP-5=fXwQZVDxJM4LmEvsKW9h0HYP6t3F0EZfy0+hwAzDmBgGA@mail.gmail.com>
Content-Type: text/plain; charset="utf-8"; format=flowed
Content-Language: en-US
Content-Transfer-Encoding: 7bit
X-Originating-IP: [10.47.2.205]
X-ClientProxiedBy: lhreml748-chm.china.huawei.com (10.201.108.198) To
 lhreml724-chm.china.huawei.com (10.201.108.75)
X-CFilter-Loop: Reflected
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On 05/10/2020 17:28, Ian Rogers wrote:
> On Mon, Oct 5, 2020 at 3:06 AM John Garry <john.garry@huawei.com> wrote:
>>
>> On 02/10/2020 21:46, Ian Rogers wrote:
>>> On Fri, Oct 2, 2020 at 5:00 AM John Garry <john.garry@huawei.com> wrote:
>>>>
>>>> On 07/05/2020 15:08, Ian Rogers wrote:
>>>>
>>>> Hi Ian,
>>>>
>>>> I was wondering if you ever tested commit 2440689d62e9 ("perf
>>>> metricgroup: Remove duped metric group events") for when we have a
>>>> metric which aliases multiple instances of the same uncore PMU in the
>>>> system?
>>>
>>> Sorry for this, I hadn't tested such a metric and wasn't aware of how
>>> the aliasing worked. I sent a fix for this issue here:
>>> https://lore.kernel.org/lkml/20200917201807.4090224-1-irogers@google.com/
>>> Could you see if this addresses the issue for you? I don't see the
>>> change in Arnaldo's trees yet.
>>
>> Unfortunately this does not seem to fix my issue.
>>
>> So for that patch, you say you fix metric expression for DRAM_BW_Use,
>> which is:
>>
>> {
>>    "BriefDescription": "Average external Memory Bandwidth Use for reads
>> and writes [GB / sec]",
>>    "MetricExpr": "( 64 * ( uncore_imc@cas_count_read@ +
>> uncore_imc@cas_count_write@ ) / 1000000000 ) / duration_time",
>>    "MetricGroup": "Memory_BW",
>> "MetricName": "DRAM_BW_Use"
>> },
>>
>> But this metric expression does not include any alias events; rather I
>> think it is just cas_count_write + cas_count_read event count for PMU
>> uncore_imc / duration_time.
>>
>> When I say alias, I mean - as an example, we have event:
>>
>>       {
>>           "BriefDescription": "write requests to memory controller.
>> Derived from unc_m_cas_count.wr",
>>           "Counter": "0,1,2,3",
>>           "EventCode": "0x4",
>>           "EventName": "LLC_MISSES.MEM_WRITE",
>>           "PerPkg": "1",
>>           "ScaleUnit": "64Bytes",
>>           "UMask": "0xC",
>>           "Unit": "iMC"
>>       },
>>
>> And then reference LLC_MISSES.MEM_WRITE in a metric expression:
>>
>> "MetricExpr": "LLC_MISSES.MEM_WRITE / duration_time",
>>
>> This is what seems to be broken for when the alias matches > 1 PMU.
>>
>> Please check this.
> 
Hi Ian,

> Happy to check. 

So I am, but the code is a little complicated :)

> Can you provide a reproduction? Looking on broadwell
> this metric doesn't exist.

Right, I just added this test metric as my 2x x86 platform has no 
examples which I can find:

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

I'll try to find a better mainline example, though, but I'm not hopeful ...

Thanks,
John

