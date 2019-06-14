Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id B1D1646197
	for <lists+netdev@lfdr.de>; Fri, 14 Jun 2019 16:51:13 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728766AbfFNOvD (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 14 Jun 2019 10:51:03 -0400
Received: from www62.your-server.de ([213.133.104.62]:52230 "EHLO
        www62.your-server.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1727560AbfFNOvD (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 14 Jun 2019 10:51:03 -0400
Received: from [78.46.172.3] (helo=sslproxy06.your-server.de)
        by www62.your-server.de with esmtpsa (TLSv1.2:DHE-RSA-AES256-GCM-SHA384:256)
        (Exim 4.89_1)
        (envelope-from <daniel@iogearbox.net>)
        id 1hbnXf-0002uH-AX; Fri, 14 Jun 2019 16:50:59 +0200
Received: from [2a02:120b:c3fc:feb0:dda7:bd28:a848:50e2] (helo=linux.home)
        by sslproxy06.your-server.de with esmtpsa (TLSv1.2:ECDHE-RSA-AES256-GCM-SHA384:256)
        (Exim 4.89)
        (envelope-from <daniel@iogearbox.net>)
        id 1hbnXf-0009sG-41; Fri, 14 Jun 2019 16:50:59 +0200
Subject: Re: [PATCH bpf v2] bpf: fix nested bpf tracepoints with per-cpu data
To:     Matt Mullins <mmullins@fb.com>,
        "andrii.nakryiko@gmail.com" <andrii.nakryiko@gmail.com>
Cc:     Song Liu <songliubraving@fb.com>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "bpf@vger.kernel.org" <bpf@vger.kernel.org>,
        "rostedt@goodmis.org" <rostedt@goodmis.org>,
        "ast@kernel.org" <ast@kernel.org>, Andrew Hall <hall@fb.com>,
        "mingo@redhat.com" <mingo@redhat.com>,
        "netdev@vger.kernel.org" <netdev@vger.kernel.org>,
        Martin Lau <kafai@fb.com>, Yonghong Song <yhs@fb.com>
References: <20190611215304.28831-1-mmullins@fb.com>
 <CAEf4BzZ_Gypm32mSnrpGWw_U9q8LfTn7hag-p-LvYKVNkFdZGw@mail.gmail.com>
 <4aa26670-75b8-118d-68ca-56719af44204@iogearbox.net>
 <9c77657414993332987ca79d4081c4d71cc48d66.camel@fb.com>
From:   Daniel Borkmann <daniel@iogearbox.net>
Message-ID: <e9665520-0523-def3-ddbb-59137694b029@iogearbox.net>
Date:   Fri, 14 Jun 2019 16:50:58 +0200
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:52.0) Gecko/20100101
 Thunderbird/52.3.0
MIME-Version: 1.0
In-Reply-To: <9c77657414993332987ca79d4081c4d71cc48d66.camel@fb.com>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 8bit
X-Authenticated-Sender: daniel@iogearbox.net
X-Virus-Scanned: Clear (ClamAV 0.100.3/25480/Fri Jun 14 10:12:45 2019)
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On 06/14/2019 02:51 AM, Matt Mullins wrote:
> On Fri, 2019-06-14 at 00:47 +0200, Daniel Borkmann wrote:
>> On 06/12/2019 07:00 AM, Andrii Nakryiko wrote:
>>> On Tue, Jun 11, 2019 at 8:48 PM Matt Mullins <mmullins@fb.com> wrote:
>>>>
>>>> BPF_PROG_TYPE_RAW_TRACEPOINTs can be executed nested on the same CPU, as
>>>> they do not increment bpf_prog_active while executing.
>>>>
>>>> This enables three levels of nesting, to support
>>>>   - a kprobe or raw tp or perf event,
>>>>   - another one of the above that irq context happens to call, and
>>>>   - another one in nmi context
>>>> (at most one of which may be a kprobe or perf event).
>>>>
>>>> Fixes: 20b9d7ac4852 ("bpf: avoid excessive stack usage for perf_sample_data")
>>
>> Generally, looks good to me. Two things below:
>>
>> Nit, for stable, shouldn't fixes tag be c4f6699dfcb8 ("bpf: introduce BPF_RAW_TRACEPOINT")
>> instead of the one you currently have?
> 
> Ah, yeah, that's probably more reasonable; I haven't managed to come up
> with a scenario where one could hit this without raw tracepoints.  I'll
> fix up the nits that've accumulated since v2.
> 
>> One more question / clarification: we have __bpf_trace_run() vs trace_call_bpf().
>>
>> Only raw tracepoints can be nested since the rest has the bpf_prog_active per-CPU
>> counter via trace_call_bpf() and would bail out otherwise, iiuc. And raw ones use
>> the __bpf_trace_run() added in c4f6699dfcb8 ("bpf: introduce BPF_RAW_TRACEPOINT").
>>
>> 1) I tried to recall and find a rationale for mentioned trace_call_bpf() split in
>> the c4f6699dfcb8 log, but couldn't find any. Is the raison d'être purely because of
>> performance overhead (and desire to not miss events as a result of nesting)? (This
>> also means we're not protected by bpf_prog_active in all the map ops, of course.)
>> 2) Wouldn't this also mean that we only need to fix the raw tp programs via
>> get_bpf_raw_tp_regs() / put_bpf_raw_tp_regs() and won't need this duplication for
>> the rest which relies upon trace_call_bpf()? I'm probably missing something, but
>> given they have separate pt_regs there, how could they be affected then?
> 
> For the pt_regs, you're correct: I only used get/put_raw_tp_regs for
> the _raw_tp variants.  However, consider the following nesting:
> 
>                                     trace_nest_level raw_tp_nest_level
>   (kprobe) bpf_perf_event_output            1               0
>   (raw_tp) bpf_perf_event_output_raw_tp     2               1
>   (raw_tp) bpf_get_stackid_raw_tp           2               2
> 
> I need to increment a nest level (and ideally increment it only once)
> between the kprobe and the first raw_tp, because they would otherwise
> share the struct perf_sample_data.  But I also need to increment a nest

I'm not sure I follow on this one: the former would still keep using the
bpf_trace_sd as-is today since only ever /one/ can be active on a given CPU
as we otherwise bail out in trace_call_bpf() due to bpf_prog_active counter.
Given these two are /not/ shared, you only need the code you have below for
nesting to deal with the raw_tps via get_bpf_raw_tp_regs() / put_bpf_raw_tp_regs()
which should also simplify the code quite a bit.

> level between the two raw_tps, since they share the pt_regs -- I can't
> use trace_nest_level for everything because it's not used by
> get_stackid, and I can't use raw_tp_nest_level for everything because
> it's not incremented by kprobes.

(See above wrt kprobes.)

> If raw tracepoints were to bump bpf_prog_active, then I could get away
> with just using that count in these callsites -- I'm reluctant to do
> that, though, since it would prevent kprobes from ever running inside a
> raw_tp.  I'd like to retain the ability to (e.g.)
>   trace.py -K htab_map_update_elem
> and get some stack traces from at least within raw tracepoints.
> 
> That said, as I wrote up this example, bpf_trace_nest_level seems to be
> wildly misnamed; I should name those after the structure they're
> protecting...
