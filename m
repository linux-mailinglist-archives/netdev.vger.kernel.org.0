Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 203F568FCD1
	for <lists+netdev@lfdr.de>; Thu,  9 Feb 2023 03:07:18 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231483AbjBICHP (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 8 Feb 2023 21:07:15 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:43796 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231466AbjBICHJ (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 8 Feb 2023 21:07:09 -0500
Received: from smtpout.efficios.com (smtpout.efficios.com [167.114.26.122])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 57286C66C;
        Wed,  8 Feb 2023 18:07:02 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=efficios.com;
        s=smtpout1; t=1675908419;
        bh=T307AjNgapNVG2vuI3mdmLu0VBxKOLkbyo7sODH20GE=;
        h=Date:Subject:To:Cc:References:From:In-Reply-To:From;
        b=biuWd9/gcPXd3A6xs869yn+pPG/n/QrnzpDPCqid4y0Z8uI+h0RWZzejRsmXG38KI
         wiTHdBX6KTJPzj4iqEzP3/h+Q7JKAfCpua7sHsTDIfdcV8flAFcuOUJrxg9gcPqQj/
         APNfBFLCCAOxuPbYGvpE5uA+k56tyq+EjGQ6VaHfYpGKCs9M8vHKS09eZWLHRju+YI
         n0OOTH9zn/fdrqD6PIngPpqohnYeQ/NBMIovdANyQYYxkPVfRdQ/0BszqRnYPZfs5F
         RLei6HMR05iZ4G0oubCPAf1xojBsF32A24J+pFZUqYiflnDLv1buR7uh8GzcVzQXZy
         nmAncYBl7CIDQ==
Received: from [10.1.0.205] (192-222-188-97.qc.cable.ebox.net [192.222.188.97])
        by smtpout.efficios.com (Postfix) with ESMTPSA id 4PC0c31MBDzknt;
        Wed,  8 Feb 2023 21:06:59 -0500 (EST)
Message-ID: <08e1c9d0-376f-d669-6fe8-559b2fbc2f2b@efficios.com>
Date:   Wed, 8 Feb 2023 21:06:58 -0500
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:102.0) Gecko/20100101
 Thunderbird/102.6.0
Subject: Re: [PATCH v2 7/7] tools/testing/selftests/bpf: replace open-coded 16
 with TASK_COMM_LEN
Content-Language: en-US
To:     John Stultz <jstultz@google.com>,
        Alexei Starovoitov <alexei.starovoitov@gmail.com>
Cc:     Yafang Shao <laoar.shao@gmail.com>,
        Andrew Morton <akpm@linux-foundation.org>,
        Network Development <netdev@vger.kernel.org>,
        bpf <bpf@vger.kernel.org>,
        "linux-perf-use." <linux-perf-users@vger.kernel.org>,
        Linux-Fsdevel <linux-fsdevel@vger.kernel.org>,
        linux-mm <linux-mm@kvack.org>,
        LKML <linux-kernel@vger.kernel.org>,
        kernel test robot <oliver.sang@intel.com>,
        kbuild test robot <lkp@intel.com>,
        Andrii Nakryiko <andrii@kernel.org>,
        David Hildenbrand <david@redhat.com>,
        Arnaldo Carvalho de Melo <arnaldo.melo@gmail.com>,
        Andrii Nakryiko <andrii.nakryiko@gmail.com>,
        Michal Miroslaw <mirq-linux@rere.qmqm.pl>,
        Peter Zijlstra <peterz@infradead.org>,
        Steven Rostedt <rostedt@goodmis.org>,
        Matthew Wilcox <willy@infradead.org>,
        Al Viro <viro@zeniv.linux.org.uk>,
        Kees Cook <keescook@chromium.org>,
        Petr Mladek <pmladek@suse.com>,
        Kajetan Puchalski <kajetan.puchalski@arm.com>,
        Lukasz Luba <lukasz.luba@arm.com>,
        Qais Yousef <qyousef@google.com>,
        Daniele Di Proietto <ddiproietto@google.com>
References: <20211120112738.45980-1-laoar.shao@gmail.com>
 <20211120112738.45980-8-laoar.shao@gmail.com> <Y+QaZtz55LIirsUO@google.com>
 <CAADnVQ+nf8MmRWP+naWwZEKBFOYr7QkZugETgAVfjKcEVxmOtg@mail.gmail.com>
 <CANDhNCo_=Q3pWc7h=ruGyHdRVGpsMKRY=C2AtZgLDwtGzRz8Kw@mail.gmail.com>
From:   Mathieu Desnoyers <mathieu.desnoyers@efficios.com>
In-Reply-To: <CANDhNCo_=Q3pWc7h=ruGyHdRVGpsMKRY=C2AtZgLDwtGzRz8Kw@mail.gmail.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
X-Spam-Status: No, score=-3.2 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,NICE_REPLY_A,SPF_HELO_NONE,
        SPF_PASS autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On 2023-02-08 19:54, John Stultz wrote:
> On Wed, Feb 8, 2023 at 4:11 PM Alexei Starovoitov
> <alexei.starovoitov@gmail.com> wrote:
>>
>> On Wed, Feb 8, 2023 at 2:01 PM John Stultz <jstultz@google.com> wrote:
>>>
>>> On Sat, Nov 20, 2021 at 11:27:38AM +0000, Yafang Shao wrote:
>>>> As the sched:sched_switch tracepoint args are derived from the kernel,
>>>> we'd better make it same with the kernel. So the macro TASK_COMM_LEN is
>>>> converted to type enum, then all the BPF programs can get it through BTF.
>>>>
>>>> The BPF program which wants to use TASK_COMM_LEN should include the header
>>>> vmlinux.h. Regarding the test_stacktrace_map and test_tracepoint, as the
>>>> type defined in linux/bpf.h are also defined in vmlinux.h, so we don't
>>>> need to include linux/bpf.h again.
>>>>
>>>> Signed-off-by: Yafang Shao <laoar.shao@gmail.com>
>>>> Acked-by: Andrii Nakryiko <andrii@kernel.org>
>>>> Acked-by: David Hildenbrand <david@redhat.com>
>>>> Cc: Mathieu Desnoyers <mathieu.desnoyers@efficios.com>
>>>> Cc: Arnaldo Carvalho de Melo <arnaldo.melo@gmail.com>
>>>> Cc: Andrii Nakryiko <andrii.nakryiko@gmail.com>
>>>> Cc: Michal Miroslaw <mirq-linux@rere.qmqm.pl>
>>>> Cc: Peter Zijlstra <peterz@infradead.org>
>>>> Cc: Steven Rostedt <rostedt@goodmis.org>
>>>> Cc: Matthew Wilcox <willy@infradead.org>
>>>> Cc: David Hildenbrand <david@redhat.com>
>>>> Cc: Al Viro <viro@zeniv.linux.org.uk>
>>>> Cc: Kees Cook <keescook@chromium.org>
>>>> Cc: Petr Mladek <pmladek@suse.com>
>>>> ---
>>>>   include/linux/sched.h                                   | 9 +++++++--
>>>>   tools/testing/selftests/bpf/progs/test_stacktrace_map.c | 6 +++---
>>>>   tools/testing/selftests/bpf/progs/test_tracepoint.c     | 6 +++---
>>>>   3 files changed, 13 insertions(+), 8 deletions(-)
>>>
>>> Hey all,
>>>    I know this is a little late, but I recently got a report that
>>> this change was causiing older versions of perfetto to stop
>>> working.
>>>
>>> Apparently newer versions of perfetto has worked around this
>>> via the following changes:
>>>    https://android.googlesource.com/platform/external/perfetto/+/c717c93131b1b6e3705a11092a70ac47c78b731d%5E%21/
>>>    https://android.googlesource.com/platform/external/perfetto/+/160a504ad5c91a227e55f84d3e5d3fe22af7c2bb%5E%21/
>>>
>>> But for older versions of perfetto, reverting upstream commit
>>> 3087c61ed2c4 ("tools/testing/selftests/bpf: replace open-coded 16
>>> with TASK_COMM_LEN") is necessary to get it back to working.
>>>
>>> I haven't dug very far into the details, and obviously this doesn't
>>> break with the updated perfetto, but from a high level this does
>>> seem to be a breaking-userland regression.
>>>
>>> So I wanted to reach out to see if there was more context for this
>>> breakage? I don't want to raise a unnecessary stink if this was
>>> an unfortuante but forced situation.
>>
>> Let me understand what you're saying...
>>
>> The commit 3087c61ed2c4 did
>>
>> -/* Task command name length: */
>> -#define TASK_COMM_LEN                  16
>> +/*
>> + * Define the task command name length as enum, then it can be visible to
>> + * BPF programs.
>> + */
>> +enum {
>> +       TASK_COMM_LEN = 16,
>> +};
>>
>>
>> and that caused:
>>
>> cat /sys/kernel/debug/tracing/events/task/task_newtask/format
>>
>> to print
>> field:char comm[TASK_COMM_LEN];    offset:12;    size:16;    signed:0;
>> instead of
>> field:char comm[16];    offset:12;    size:16;    signed:0;
>>
>> so the ftrace parsing android tracing tool had to do:
>>
>> -  if (Match(type_and_name.c_str(), R"(char [a-zA-Z_]+\[[0-9]+\])")) {
>> +  if (Match(type_and_name.c_str(),
>> +            R"(char [a-zA-Z_][a-zA-Z_0-9]*\[[a-zA-Z_0-9]+\])")) {
>>
>> to workaround this change.
>> Right?
> 
> I believe so.
> 
>> And what are you proposing?
> 
> I'm not proposing anything. I was just wanting to understand more
> context around this, as it outwardly appears to be a user-breaking
> change, and that is usually not done, so I figured it was an issue
> worth raising.
> 
> If the debug/tracing/*/format output is in the murky not-really-abi
> space, that's fine, but I wanted to know if this was understood as
> something that may require userland updates or if this was a
> unexpected side-effect.

If you are looking at the root cause in the kernel code generating this:

kernel/trace/trace_events.c:f_show()

         /*
          * Smartly shows the array type(except dynamic array).
          * Normal:
          *      field:TYPE VAR
          * If TYPE := TYPE[LEN], it is shown:
          *      field:TYPE VAR[LEN]
          */

where it uses the content of field->type (a string) to format the VAR[LEN] part.

This in turn is the result of the definition of the
struct trace_event_fields done in:

include/trace/trace_events.h at stage 4, thus with the context of those macros defined:

include/trace/stages/stage4_event_fields.h:

#undef __array
#define __array(_type, _item, _len) {                                   \
         .type = #_type"["__stringify(_len)"]", .name = #_item,          \
         .size = sizeof(_type[_len]), .align = ALIGN_STRUCTFIELD(_type), \
         .is_signed = is_signed_type(_type), .filter_type = FILTER_OTHER },

I suspect the real culprit here is the use of __stringify(_len), which happens to work
on macros, but not on enum labels.

One possible solution to make this more robust would be to extend
struct trace_event_fields with one more field that indicates the length
of an array as an actual integer, without storing it in its stringified
form in the type, and do the formatting in f_show where it belongs.

This way everybody can stay happy and no ABI is broken.

Thoughts ?

Thanks,

Mathieu

-- 
Mathieu Desnoyers
EfficiOS Inc.
https://www.efficios.com

