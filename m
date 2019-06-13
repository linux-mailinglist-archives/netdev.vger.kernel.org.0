Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id DA69844F80
	for <lists+netdev@lfdr.de>; Fri, 14 Jun 2019 00:47:56 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727135AbfFMWrs (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 13 Jun 2019 18:47:48 -0400
Received: from www62.your-server.de ([213.133.104.62]:58528 "EHLO
        www62.your-server.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1725809AbfFMWrs (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 13 Jun 2019 18:47:48 -0400
Received: from [88.198.220.130] (helo=sslproxy01.your-server.de)
        by www62.your-server.de with esmtpsa (TLSv1.2:DHE-RSA-AES256-GCM-SHA384:256)
        (Exim 4.89_1)
        (envelope-from <daniel@iogearbox.net>)
        id 1hbYVR-0004ID-O9; Fri, 14 Jun 2019 00:47:41 +0200
Received: from [178.199.41.31] (helo=linux.home)
        by sslproxy01.your-server.de with esmtpsa (TLSv1.2:ECDHE-RSA-AES256-GCM-SHA384:256)
        (Exim 4.89)
        (envelope-from <daniel@iogearbox.net>)
        id 1hbYVR-00077t-Fk; Fri, 14 Jun 2019 00:47:41 +0200
Subject: Re: [PATCH bpf v2] bpf: fix nested bpf tracepoints with per-cpu data
To:     Andrii Nakryiko <andrii.nakryiko@gmail.com>,
        Matt Mullins <mmullins@fb.com>
Cc:     hall@fb.com, Alexei Starovoitov <ast@kernel.org>,
        bpf <bpf@vger.kernel.org>, Networking <netdev@vger.kernel.org>,
        open list <linux-kernel@vger.kernel.org>,
        Steven Rostedt <rostedt@goodmis.org>,
        Ingo Molnar <mingo@redhat.com>,
        Martin KaFai Lau <kafai@fb.com>,
        Song Liu <songliubraving@fb.com>, Yonghong Song <yhs@fb.com>
References: <20190611215304.28831-1-mmullins@fb.com>
 <CAEf4BzZ_Gypm32mSnrpGWw_U9q8LfTn7hag-p-LvYKVNkFdZGw@mail.gmail.com>
From:   Daniel Borkmann <daniel@iogearbox.net>
Message-ID: <4aa26670-75b8-118d-68ca-56719af44204@iogearbox.net>
Date:   Fri, 14 Jun 2019 00:47:40 +0200
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:52.0) Gecko/20100101
 Thunderbird/52.3.0
MIME-Version: 1.0
In-Reply-To: <CAEf4BzZ_Gypm32mSnrpGWw_U9q8LfTn7hag-p-LvYKVNkFdZGw@mail.gmail.com>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 8bit
X-Authenticated-Sender: daniel@iogearbox.net
X-Virus-Scanned: Clear (ClamAV 0.100.3/25479/Thu Jun 13 10:12:53 2019)
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On 06/12/2019 07:00 AM, Andrii Nakryiko wrote:
> On Tue, Jun 11, 2019 at 8:48 PM Matt Mullins <mmullins@fb.com> wrote:
>>
>> BPF_PROG_TYPE_RAW_TRACEPOINTs can be executed nested on the same CPU, as
>> they do not increment bpf_prog_active while executing.
>>
>> This enables three levels of nesting, to support
>>   - a kprobe or raw tp or perf event,
>>   - another one of the above that irq context happens to call, and
>>   - another one in nmi context
>> (at most one of which may be a kprobe or perf event).
>>
>> Fixes: 20b9d7ac4852 ("bpf: avoid excessive stack usage for perf_sample_data")

Generally, looks good to me. Two things below:

Nit, for stable, shouldn't fixes tag be c4f6699dfcb8 ("bpf: introduce BPF_RAW_TRACEPOINT")
instead of the one you currently have?

One more question / clarification: we have __bpf_trace_run() vs trace_call_bpf().

Only raw tracepoints can be nested since the rest has the bpf_prog_active per-CPU
counter via trace_call_bpf() and would bail out otherwise, iiuc. And raw ones use
the __bpf_trace_run() added in c4f6699dfcb8 ("bpf: introduce BPF_RAW_TRACEPOINT").

1) I tried to recall and find a rationale for mentioned trace_call_bpf() split in
the c4f6699dfcb8 log, but couldn't find any. Is the raison d'être purely because of
performance overhead (and desire to not miss events as a result of nesting)? (This
also means we're not protected by bpf_prog_active in all the map ops, of course.)
2) Wouldn't this also mean that we only need to fix the raw tp programs via
get_bpf_raw_tp_regs() / put_bpf_raw_tp_regs() and won't need this duplication for
the rest which relies upon trace_call_bpf()? I'm probably missing something, but
given they have separate pt_regs there, how could they be affected then?

Thanks,
Daniel

>> Signed-off-by: Matt Mullins <mmullins@fb.com>
>> ---
> 
> LGTM, minor nit below.
> 
> Acked-by: Andrii Nakryiko <andriin@fb.com>
> 
>> v1->v2:
>>   * reverse-Christmas-tree-ize the declarations in bpf_perf_event_output
>>   * instantiate err more readably
>>
>> I've done additional testing with the original workload that hit the
>> irq+raw-tp reentrancy problem, and as far as I can tell, it's still
>> solved with this solution (as opposed to my earlier per-map-element
>> version).
>>
>>  kernel/trace/bpf_trace.c | 100 ++++++++++++++++++++++++++++++++-------
>>  1 file changed, 84 insertions(+), 16 deletions(-)
>>
>> diff --git a/kernel/trace/bpf_trace.c b/kernel/trace/bpf_trace.c
>> index f92d6ad5e080..1c9a4745e596 100644
>> --- a/kernel/trace/bpf_trace.c
>> +++ b/kernel/trace/bpf_trace.c
>> @@ -410,8 +410,6 @@ static const struct bpf_func_proto bpf_perf_event_read_value_proto = {
>>         .arg4_type      = ARG_CONST_SIZE,
>>  };
>>
>> -static DEFINE_PER_CPU(struct perf_sample_data, bpf_trace_sd);
>> -
>>  static __always_inline u64
>>  __bpf_perf_event_output(struct pt_regs *regs, struct bpf_map *map,
>>                         u64 flags, struct perf_sample_data *sd)
>> @@ -442,24 +440,50 @@ __bpf_perf_event_output(struct pt_regs *regs, struct bpf_map *map,
>>         return perf_event_output(event, sd, regs);
>>  }
>>
>> +/*
>> + * Support executing tracepoints in normal, irq, and nmi context that each call
>> + * bpf_perf_event_output
>> + */
>> +struct bpf_trace_sample_data {
>> +       struct perf_sample_data sds[3];
>> +};
>> +
>> +static DEFINE_PER_CPU(struct bpf_trace_sample_data, bpf_trace_sds);
>> +static DEFINE_PER_CPU(int, bpf_trace_nest_level);
>>  BPF_CALL_5(bpf_perf_event_output, struct pt_regs *, regs, struct bpf_map *, map,
>>            u64, flags, void *, data, u64, size)
>>  {
>> -       struct perf_sample_data *sd = this_cpu_ptr(&bpf_trace_sd);
>> +       struct bpf_trace_sample_data *sds = this_cpu_ptr(&bpf_trace_sds);
>> +       int nest_level = this_cpu_inc_return(bpf_trace_nest_level);
>>         struct perf_raw_record raw = {
>>                 .frag = {
>>                         .size = size,
>>                         .data = data,
>>                 },
>>         };
>> +       struct perf_sample_data *sd;
>> +       int err;
>>
>> -       if (unlikely(flags & ~(BPF_F_INDEX_MASK)))
>> -               return -EINVAL;
>> +       if (WARN_ON_ONCE(nest_level > ARRAY_SIZE(sds->sds))) {
>> +               err = -EBUSY;
>> +               goto out;
>> +       }
>> +
>> +       sd = &sds->sds[nest_level - 1];
>> +
>> +       if (unlikely(flags & ~(BPF_F_INDEX_MASK))) {
>> +               err = -EINVAL;
>> +               goto out;
>> +       }
> 
> Feel free to ignore, but just stylistically, given this check doesn't
> depend on sd, I'd move it either to the very top or right after
> `nest_level > ARRAY_SIZE(sds->sds)` check, so that all the error
> checking is grouped without interspersed assignment.

Makes sense.

>>         perf_sample_data_init(sd, 0, 0);
>>         sd->raw = &raw;
>>
>> -       return __bpf_perf_event_output(regs, map, flags, sd);
>> +       err = __bpf_perf_event_output(regs, map, flags, sd);
>> +
>> +out:
>> +       this_cpu_dec(bpf_trace_nest_level);
>> +       return err;
>>  }
>>
>>  static const struct bpf_func_proto bpf_perf_event_output_proto = {
>> @@ -822,16 +846,48 @@ pe_prog_func_proto(enum bpf_func_id func_id, const struct bpf_prog *prog)
>>  /*
>>   * bpf_raw_tp_regs are separate from bpf_pt_regs used from skb/xdp
>>   * to avoid potential recursive reuse issue when/if tracepoints are added
>> - * inside bpf_*_event_output, bpf_get_stackid and/or bpf_get_stack
>> + * inside bpf_*_event_output, bpf_get_stackid and/or bpf_get_stack.
>> + *
>> + * Since raw tracepoints run despite bpf_prog_active, support concurrent usage
>> + * in normal, irq, and nmi context.
>>   */
>> -static DEFINE_PER_CPU(struct pt_regs, bpf_raw_tp_regs);
>> +struct bpf_raw_tp_regs {
>> +       struct pt_regs regs[3];
>> +};
>> +static DEFINE_PER_CPU(struct bpf_raw_tp_regs, bpf_raw_tp_regs);
>> +static DEFINE_PER_CPU(int, bpf_raw_tp_nest_level);
>> +static struct pt_regs *get_bpf_raw_tp_regs(void)
>> +{
>> +       struct bpf_raw_tp_regs *tp_regs = this_cpu_ptr(&bpf_raw_tp_regs);
>> +       int nest_level = this_cpu_inc_return(bpf_raw_tp_nest_level);
>> +
>> +       if (WARN_ON_ONCE(nest_level > ARRAY_SIZE(tp_regs->regs))) {
>> +               this_cpu_dec(bpf_raw_tp_nest_level);
>> +               return ERR_PTR(-EBUSY);
>> +       }
>> +
>> +       return &tp_regs->regs[nest_level - 1];
>> +}
>> +
>> +static void put_bpf_raw_tp_regs(void)
>> +{
>> +       this_cpu_dec(bpf_raw_tp_nest_level);
>> +}
>> +
>>  BPF_CALL_5(bpf_perf_event_output_raw_tp, struct bpf_raw_tracepoint_args *, args,
>>            struct bpf_map *, map, u64, flags, void *, data, u64, size)
>>  {
>> -       struct pt_regs *regs = this_cpu_ptr(&bpf_raw_tp_regs);
>> +       struct pt_regs *regs = get_bpf_raw_tp_regs();
>> +       int ret;
>> +
>> +       if (IS_ERR(regs))
>> +               return PTR_ERR(regs);
>>
>>         perf_fetch_caller_regs(regs);
>> -       return ____bpf_perf_event_output(regs, map, flags, data, size);
>> +       ret = ____bpf_perf_event_output(regs, map, flags, data, size);
>> +
>> +       put_bpf_raw_tp_regs();
>> +       return ret;
>>  }
>>
>>  static const struct bpf_func_proto bpf_perf_event_output_proto_raw_tp = {
>> @@ -848,12 +904,18 @@ static const struct bpf_func_proto bpf_perf_event_output_proto_raw_tp = {
>>  BPF_CALL_3(bpf_get_stackid_raw_tp, struct bpf_raw_tracepoint_args *, args,
>>            struct bpf_map *, map, u64, flags)
>>  {
>> -       struct pt_regs *regs = this_cpu_ptr(&bpf_raw_tp_regs);
>> +       struct pt_regs *regs = get_bpf_raw_tp_regs();
>> +       int ret;
>> +
>> +       if (IS_ERR(regs))
>> +               return PTR_ERR(regs);
>>
>>         perf_fetch_caller_regs(regs);
>>         /* similar to bpf_perf_event_output_tp, but pt_regs fetched differently */
>> -       return bpf_get_stackid((unsigned long) regs, (unsigned long) map,
>> -                              flags, 0, 0);
>> +       ret = bpf_get_stackid((unsigned long) regs, (unsigned long) map,
>> +                             flags, 0, 0);
>> +       put_bpf_raw_tp_regs();
>> +       return ret;
>>  }
>>
>>  static const struct bpf_func_proto bpf_get_stackid_proto_raw_tp = {
>> @@ -868,11 +930,17 @@ static const struct bpf_func_proto bpf_get_stackid_proto_raw_tp = {
>>  BPF_CALL_4(bpf_get_stack_raw_tp, struct bpf_raw_tracepoint_args *, args,
>>            void *, buf, u32, size, u64, flags)
>>  {
>> -       struct pt_regs *regs = this_cpu_ptr(&bpf_raw_tp_regs);
>> +       struct pt_regs *regs = get_bpf_raw_tp_regs();
>> +       int ret;
>> +
>> +       if (IS_ERR(regs))
>> +               return PTR_ERR(regs);
>>
>>         perf_fetch_caller_regs(regs);
>> -       return bpf_get_stack((unsigned long) regs, (unsigned long) buf,
>> -                            (unsigned long) size, flags, 0);
>> +       ret = bpf_get_stack((unsigned long) regs, (unsigned long) buf,
>> +                           (unsigned long) size, flags, 0);
>> +       put_bpf_raw_tp_regs();
>> +       return ret;
>>  }
>>
>>  static const struct bpf_func_proto bpf_get_stack_proto_raw_tp = {
>> --
>> 2.17.1
>>

