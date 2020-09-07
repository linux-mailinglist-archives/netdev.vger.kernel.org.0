Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 69A2825F347
	for <lists+netdev@lfdr.de>; Mon,  7 Sep 2020 08:37:06 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726895AbgIGGg4 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 7 Sep 2020 02:36:56 -0400
Received: from mga05.intel.com ([192.55.52.43]:13385 "EHLO mga05.intel.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726278AbgIGGgz (ORCPT <rfc822;netdev@vger.kernel.org>);
        Mon, 7 Sep 2020 02:36:55 -0400
IronPort-SDR: 39lQe0af65hZiTcIiYzvje7BTomVwBmuIz0besQbNFzSgEpyKvUe7dpzz1IIepG6uW9lOAXuVB
 PF1Qn5FOgSVA==
X-IronPort-AV: E=McAfee;i="6000,8403,9736"; a="242776996"
X-IronPort-AV: E=Sophos;i="5.76,401,1592895600"; 
   d="scan'208";a="242776996"
X-Amp-Result: SKIPPED(no attachment in message)
X-Amp-File-Uploaded: False
Received: from fmsmga006.fm.intel.com ([10.253.24.20])
  by fmsmga105.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 06 Sep 2020 23:36:54 -0700
IronPort-SDR: j9jvOKcV7TCFI0Sww+53PtsDvExwrk2f628yc+m5JU26xi67Rjd+hOfs9IwdJNqrspzmV9SQGx
 QyypmOkqFO6g==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="5.76,401,1592895600"; 
   d="scan'208";a="503927007"
Received: from ahunter-desktop.fi.intel.com (HELO [10.237.72.190]) ([10.237.72.190])
  by fmsmga006.fm.intel.com with ESMTP; 06 Sep 2020 23:36:49 -0700
Subject: Re: [PATCH v2 4/5] perf record: Don't clear event's period if set by
 a term
To:     Ian Rogers <irogers@google.com>
Cc:     Peter Zijlstra <peterz@infradead.org>,
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
        Andi Kleen <ak@linux.intel.com>,
        Athira Rajeev <atrajeev@linux.vnet.ibm.com>,
        LKML <linux-kernel@vger.kernel.org>,
        Networking <netdev@vger.kernel.org>, bpf <bpf@vger.kernel.org>,
        Stephane Eranian <eranian@google.com>
References: <20200728085734.609930-1-irogers@google.com>
 <20200728085734.609930-5-irogers@google.com>
 <969ef797-59ea-69d0-24b9-33bcdff106a1@intel.com>
 <CAP-5=fUCnBGX0L0Tt3_gmVnt+hvaouJMx6XFErFKk72+xuw9fw@mail.gmail.com>
 <86324041-aafb-f556-eda7-6250ba678f24@intel.com>
 <CAP-5=fXfBkXovaK3DuSCnwfsnxqW7ZR8-LigtGATgs4gMpZP9A@mail.gmail.com>
 <CAP-5=fXGpQ7awq7-99KJsPhwMS91hvFXEvN4YWfdoVpq7mRvDw@mail.gmail.com>
From:   Adrian Hunter <adrian.hunter@intel.com>
Organization: Intel Finland Oy, Registered Address: PL 281, 00181 Helsinki,
 Business Identity Code: 0357606 - 4, Domiciled in Helsinki
Message-ID: <3ab220cd-0b8f-427f-4832-b45bcf0851e9@intel.com>
Date:   Mon, 7 Sep 2020 09:36:26 +0300
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:68.0) Gecko/20100101
 Thunderbird/68.12.0
MIME-Version: 1.0
In-Reply-To: <CAP-5=fXGpQ7awq7-99KJsPhwMS91hvFXEvN4YWfdoVpq7mRvDw@mail.gmail.com>
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: 7bit
Content-Language: en-US
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On 4/09/20 8:43 am, Ian Rogers wrote:
> On Tue, Aug 4, 2020 at 8:50 AM Ian Rogers <irogers@google.com> wrote:
>> On Tue, Aug 4, 2020 at 7:49 AM Adrian Hunter <adrian.hunter@intel.com> wrote:
>>> On 4/08/20 4:33 pm, Ian Rogers wrote:
>>>> On Tue, Aug 4, 2020 at 3:08 AM Adrian Hunter <adrian.hunter@intel.com> wrote:
>>>>> On 28/07/20 11:57 am, Ian Rogers wrote:
>>>>>> If events in a group explicitly set a frequency or period with leader
>>>>>> sampling, don't disable the samples on those events.
>>>>>>
>>>>>> Prior to 5.8:
>>>>>> perf record -e '{cycles/period=12345000/,instructions/period=6789000/}:S'
>>>>> Might be worth explaining this use-case some more.
>>>>> Perhaps add it to the leader sampling documentation for perf-list.
>>>>>
>>>>>> would clear the attributes then apply the config terms. In commit
>>>>>> 5f34278867b7 leader sampling configuration was moved to after applying the
>>>>>> config terms, in the example, making the instructions' event have its period
>>>>>> cleared.
>>>>>> This change makes it so that sampling is only disabled if configuration
>>>>>> terms aren't present.
>>>>>>
>>>>>> Fixes: 5f34278867b7 ("perf evlist: Move leader-sampling configuration")
>>>>>> Signed-off-by: Ian Rogers <irogers@google.com>
>>>>>> ---
>>>>>>  tools/perf/util/record.c | 28 ++++++++++++++++++++--------
>>>>>>  1 file changed, 20 insertions(+), 8 deletions(-)
>>>>>>
>>>>>> diff --git a/tools/perf/util/record.c b/tools/perf/util/record.c
>>>>>> index a4cc11592f6b..01d1c6c613f7 100644
>>>>>> --- a/tools/perf/util/record.c
>>>>>> +++ b/tools/perf/util/record.c
>>>>>> @@ -2,6 +2,7 @@
>>>>>>  #include "debug.h"
>>>>>>  #include "evlist.h"
>>>>>>  #include "evsel.h"
>>>>>> +#include "evsel_config.h"
>>>>>>  #include "parse-events.h"
>>>>>>  #include <errno.h>
>>>>>>  #include <limits.h>
>>>>>> @@ -38,6 +39,9 @@ static void evsel__config_leader_sampling(struct evsel *evsel, struct evlist *ev
>>>>>>       struct perf_event_attr *attr = &evsel->core.attr;
>>>>>>       struct evsel *leader = evsel->leader;
>>>>>>       struct evsel *read_sampler;
>>>>>> +     struct evsel_config_term *term;
>>>>>> +     struct list_head *config_terms = &evsel->config_terms;
>>>>>> +     int term_types, freq_mask;
>>>>>>
>>>>>>       if (!leader->sample_read)
>>>>>>               return;
>>>>>> @@ -47,16 +51,24 @@ static void evsel__config_leader_sampling(struct evsel *evsel, struct evlist *ev
>>>>>>       if (evsel == read_sampler)
>>>>>>               return;
>>>>>>
>>>>>> +     /* Determine the evsel's config term types. */
>>>>>> +     term_types = 0;
>>>>>> +     list_for_each_entry(term, config_terms, list) {
>>>>>> +             term_types |= 1 << term->type;
>>>>>> +     }
>>>>>>       /*
>>>>>> -      * Disable sampling for all group members other than the leader in
>>>>>> -      * case the leader 'leads' the sampling, except when the leader is an
>>>>>> -      * AUX area event, in which case the 2nd event in the group is the one
>>>>>> -      * that 'leads' the sampling.
>>>>>> +      * Disable sampling for all group members except those with explicit
>>>>>> +      * config terms or the leader. In the case of an AUX area event, the 2nd
>>>>>> +      * event in the group is the one that 'leads' the sampling.
>>>>>>        */
>>>>>> -     attr->freq           = 0;
>>>>>> -     attr->sample_freq    = 0;
>>>>>> -     attr->sample_period  = 0;
>>>>>> -     attr->write_backward = 0;
>>>>>> +     freq_mask = (1 << EVSEL__CONFIG_TERM_FREQ) | (1 << EVSEL__CONFIG_TERM_PERIOD);
>>>>>> +     if ((term_types & freq_mask) == 0) {
>>>>> It would be nicer to have a helper e.g.
>>>>>
>>>>>         if (!evsel__have_config_term(evsel, FREQ) &&
>>>>>             !evsel__have_config_term(evsel, PERIOD)) {
>>>> Sure. The point of doing it this way was to avoid repeatedly iterating
>>>> over the config term list.
>>> But perhaps it is premature optimization
>> The alternative is more loc. I think we can bike shed on this but it's
>> not really changing the substance of the change. I'm keen to try to be
>> efficient where we can as we see issues at scale.
>>
>> Thanks,
>> Ian
> Ping. Do we want to turn this into multiple O(N) searches using a
> helper rather than 1 as coded here?

Actually max. 30 iterations vs max. 15 iterations for the 15 current
possible config terms.

At least please don't open code the config term implementation details.

For example, make evsel__have_config_term() accept multiple terms or introduce

u64 term_mask = evsel__config_term_mask(evsel);

has_config_term(term_mask, FREQ) etc

or whatever.

>
> Thanks,
> Ian
>
>>>>>> +             attr->freq           = 0;
>>>>>> +             attr->sample_freq    = 0;
>>>>>> +             attr->sample_period  = 0;
>>>>> If we are not sampling, then maybe we should also put here:
>>>>>
>>>>>                 attr->write_backward = 0;
>>>>>
>>>>>> +     }
>>>>> Then, if we are sampling this evsel shouldn't the backward setting
>>>>> match the leader? e.g.
>>>>>
>>>>>         if (attr->sample_freq)
>>>>>                 attr->write_backward = leader->core.attr.write_backward;
>>>> Perhaps that should be a follow up change? This change is trying to
>>>> make the behavior match the previous behavior.
>>> Sure
>>>
>>>> Thanks,
>>>> Ian
>>>>
>>>>>> +     if ((term_types & (1 << EVSEL__CONFIG_TERM_OVERWRITE)) == 0)
>>>>>> +             attr->write_backward = 0;
>>>>>>
>>>>>>       /*
>>>>>>        * We don't get a sample for slave events, we make them when delivering
>>>>>>

