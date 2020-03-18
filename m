Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 7A53F18A501
	for <lists+netdev@lfdr.de>; Wed, 18 Mar 2020 21:58:17 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728516AbgCRU6M (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 18 Mar 2020 16:58:12 -0400
Received: from www62.your-server.de ([213.133.104.62]:44520 "EHLO
        www62.your-server.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1728181AbgCRU6L (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 18 Mar 2020 16:58:11 -0400
Received: from sslproxy05.your-server.de ([78.46.172.2])
        by www62.your-server.de with esmtpsa (TLSv1.2:DHE-RSA-AES256-GCM-SHA384:256)
        (Exim 4.89_1)
        (envelope-from <daniel@iogearbox.net>)
        id 1jEflQ-00077f-Lh; Wed, 18 Mar 2020 21:58:08 +0100
Received: from [85.7.42.192] (helo=pc-9.home)
        by sslproxy05.your-server.de with esmtpsa (TLSv1.3:TLS_AES_256_GCM_SHA384:256)
        (Exim 4.92)
        (envelope-from <daniel@iogearbox.net>)
        id 1jEflQ-0007WN-Ax; Wed, 18 Mar 2020 21:58:08 +0100
Subject: Re: [PATCH v2 bpf-next] bpf: sharing bpf runtime stats with
 /dev/bpf_stats
To:     Song Liu <songliubraving@fb.com>
Cc:     "linux-fsdevel@vger.kernel.org" <linux-fsdevel@vger.kernel.org>,
        Networking <netdev@vger.kernel.org>,
        "bpf@vger.kernel.org" <bpf@vger.kernel.org>,
        Kernel Team <Kernel-team@fb.com>,
        "ast@kernel.org" <ast@kernel.org>,
        "mcgrof@kernel.org" <mcgrof@kernel.org>,
        "keescook@chromium.org" <keescook@chromium.org>,
        "yzaikin@google.com" <yzaikin@google.com>
References: <20200316203329.2747779-1-songliubraving@fb.com>
 <eb31bed3-3be4-501e-4340-bd558b31ead2@iogearbox.net>
 <920839AF-AC7A-4CD3-975F-111C3C6F75B9@fb.com>
 <a69245f8-c70f-857c-b109-556d1bc267f7@iogearbox.net>
 <C126A009-516F-451A-9A83-31BC8F67AA11@fb.com>
 <53f8973f-4b3e-08fe-2363-2300027c8f9d@iogearbox.net>
 <C624907B-22DB-4505-9C9E-1F8A96013AC7@fb.com>
 <6D317BBF-093E-41DC-9838-D685C39F6DAB@fb.com>
From:   Daniel Borkmann <daniel@iogearbox.net>
Message-ID: <ba62e0be-6de6-036c-a836-178c1a9c079a@iogearbox.net>
Date:   Wed, 18 Mar 2020 21:58:07 +0100
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:60.0) Gecko/20100101
 Thunderbird/60.7.2
MIME-Version: 1.0
In-Reply-To: <6D317BBF-093E-41DC-9838-D685C39F6DAB@fb.com>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Language: en-US
Content-Transfer-Encoding: 7bit
X-Authenticated-Sender: daniel@iogearbox.net
X-Virus-Scanned: Clear (ClamAV 0.102.2/25755/Wed Mar 18 14:14:00 2020)
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On 3/18/20 7:33 AM, Song Liu wrote:
>> On Mar 17, 2020, at 4:08 PM, Song Liu <songliubraving@fb.com> wrote:
>>> On Mar 17, 2020, at 2:47 PM, Daniel Borkmann <daniel@iogearbox.net> wrote:
>>>>>
>>>>> Hm, true as well. Wouldn't long-term extending "bpftool prog profile" fentry/fexit
>>>>> programs supersede this old bpf_stats infrastructure? Iow, can't we implement the
>>>>> same (or even more elaborate stats aggregation) in BPF via fentry/fexit and then
>>>>> potentially deprecate bpf_stats counters?
>>>> I think run_time_ns has its own value as a simple monitoring framework. We can
>>>> use it in tools like top (and variations). It will be easier for these tools to
>>>> adopt run_time_ns than using fentry/fexit.
>>>
>>> Agree that this is easier; I presume there is no such official integration today
>>> in tools like top, right, or is there anything planned?
>>
>> Yes, we do want more supports in different tools to increase the visibility.
>> Here is the effort for atop: https://github.com/Atoptool/atop/pull/88 .
>>
>> I wasn't pushing push hard on this one mostly because the sysctl interface requires
>> a user space "owner".
>>
>>>> On the other hand, in long term, we may include a few fentry/fexit based programs
>>>> in the kernel binary (or the rpm), so that these tools can use them easily. At
>>>> that time, we can fully deprecate run_time_ns. Maybe this is not too far away?
>>>
>>> Did you check how feasible it is to have something like `bpftool prog profile top`
>>> which then enables fentry/fexit for /all/ existing BPF programs in the system? It
>>> could then sort the sample interval by run_cnt, cycles, cache misses, aggregated
>>> runtime, etc in a top-like output. Wdyt?
>>
>> I wonder whether we can achieve this with one bpf prog (or a trampoline) that covers
>> all BPF programs, like a trampoline inside __BPF_PROG_RUN()?
>>
>> For long term direction, I think we could compare two different approaches: add new
>> tools (like bpftool prog profile top) vs. add BPF support to existing tools. The
>> first approach is easier. The latter approach would show BPF information to users
>> who are not expecting BPF programs in the systems. For many sysadmins, seeing BPF
>> programs in top/ps, and controlling them via kill is more natural than learning
>> bpftool. What's your thought on this?
> 
> More thoughts on this.
> 
> If we have a special trampoline that attach to all BPF programs at once, we really
> don't need the run_time_ns stats anymore. Eventually, tools that monitor BPF
> programs will depend on libbpf, so using fentry/fexit to monitor BPF programs doesn't
> introduce extra dependency. I guess we also need a way to include BPF program in
> libbpf.
> 
> To summarize this plan, we need:
> 
> 1) A global trampoline that attaches to all BPF programs at once;

Overall sounds good, I think the `at once` part might be tricky, at least it would
need to patch one prog after another, each prog also needs to store its own metrics
somewhere for later collection. The start-to-sample could be a shared global var (aka
shared map between all the programs) which would flip the switch though.

> 2) Embed fentry/fexit program in libbpf, which will be used by tools for monitoring;
> 3) BPF helpers to read time, which replaces current run_time_ns.
> 
> Does this look reasonable?
> 
> Thanks,
> Song
> 

