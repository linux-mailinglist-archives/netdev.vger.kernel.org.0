Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 1EF3E1890BB
	for <lists+netdev@lfdr.de>; Tue, 17 Mar 2020 22:47:06 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726735AbgCQVrE (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 17 Mar 2020 17:47:04 -0400
Received: from www62.your-server.de ([213.133.104.62]:56464 "EHLO
        www62.your-server.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726388AbgCQVrE (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 17 Mar 2020 17:47:04 -0400
Received: from sslproxy06.your-server.de ([78.46.172.3])
        by www62.your-server.de with esmtpsa (TLSv1.2:DHE-RSA-AES256-GCM-SHA384:256)
        (Exim 4.89_1)
        (envelope-from <daniel@iogearbox.net>)
        id 1jEK3B-000880-36; Tue, 17 Mar 2020 22:47:01 +0100
Received: from [85.7.42.192] (helo=pc-9.home)
        by sslproxy06.your-server.de with esmtpsa (TLSv1.3:TLS_AES_256_GCM_SHA384:256)
        (Exim 4.92)
        (envelope-from <daniel@iogearbox.net>)
        id 1jEK3A-0002u4-Oi; Tue, 17 Mar 2020 22:47:00 +0100
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
From:   Daniel Borkmann <daniel@iogearbox.net>
Message-ID: <53f8973f-4b3e-08fe-2363-2300027c8f9d@iogearbox.net>
Date:   Tue, 17 Mar 2020 22:47:00 +0100
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:60.0) Gecko/20100101
 Thunderbird/60.7.2
MIME-Version: 1.0
In-Reply-To: <C126A009-516F-451A-9A83-31BC8F67AA11@fb.com>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Language: en-US
Content-Transfer-Encoding: 7bit
X-Authenticated-Sender: daniel@iogearbox.net
X-Virus-Scanned: Clear (ClamAV 0.102.2/25754/Tue Mar 17 14:09:15 2020)
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On 3/17/20 9:13 PM, Song Liu wrote:
>> On Mar 17, 2020, at 1:03 PM, Daniel Borkmann <daniel@iogearbox.net> wrote:
>> On 3/17/20 8:54 PM, Song Liu wrote:
>>>> On Mar 17, 2020, at 12:30 PM, Daniel Borkmann <daniel@iogearbox.net> wrote:
>>>> On 3/16/20 9:33 PM, Song Liu wrote:
>>>>> Currently, sysctl kernel.bpf_stats_enabled controls BPF runtime stats.
>>>>> Typical userspace tools use kernel.bpf_stats_enabled as follows:
>>>>>    1. Enable kernel.bpf_stats_enabled;
>>>>>    2. Check program run_time_ns;
>>>>>    3. Sleep for the monitoring period;
>>>>>    4. Check program run_time_ns again, calculate the difference;
>>>>>    5. Disable kernel.bpf_stats_enabled.
>>>>> The problem with this approach is that only one userspace tool can toggle
>>>>> this sysctl. If multiple tools toggle the sysctl at the same time, the
>>>>> measurement may be inaccurate.
>>>>> To fix this problem while keep backward compatibility, introduce a new
>>>>> bpf command BPF_ENABLE_RUNTIME_STATS. On success, this command enables
>>>>> run_time_ns stats and returns a valid fd.
>>>>> With BPF_ENABLE_RUNTIME_STATS, user space tool would have the following
>>>>> flow:
>>>>>    1. Get a fd with BPF_ENABLE_RUNTIME_STATS, and make sure it is valid;
>>>>>    2. Check program run_time_ns;
>>>>>    3. Sleep for the monitoring period;
>>>>>    4. Check program run_time_ns again, calculate the difference;
>>>>>    5. Close the fd.
>>>>> Signed-off-by: Song Liu <songliubraving@fb.com>
>>>>
>>>> Hmm, I see no relation to /dev/bpf_stats anymore, yet the subject still talks
>>>> about it?
>>> My fault. Will fix..
>>>> Also, should this have bpftool integration now that we have `bpftool prog profile`
>>>> support? Would be nice to then fetch the related stats via bpf_prog_info, so users
>>>> can consume this in an easy way.
>>> We can add "run_time_ns" as a metric to "bpftool prog profile". But the
>>> mechanism is not the same though. Let me think about this.
>>
>> Hm, true as well. Wouldn't long-term extending "bpftool prog profile" fentry/fexit
>> programs supersede this old bpf_stats infrastructure? Iow, can't we implement the
>> same (or even more elaborate stats aggregation) in BPF via fentry/fexit and then
>> potentially deprecate bpf_stats counters?
> 
> I think run_time_ns has its own value as a simple monitoring framework. We can
> use it in tools like top (and variations). It will be easier for these tools to
> adopt run_time_ns than using fentry/fexit.

Agree that this is easier; I presume there is no such official integration today
in tools like top, right, or is there anything planned?

> On the other hand, in long term, we may include a few fentry/fexit based programs
> in the kernel binary (or the rpm), so that these tools can use them easily. At
> that time, we can fully deprecate run_time_ns. Maybe this is not too far away?

Did you check how feasible it is to have something like `bpftool prog profile top`
which then enables fentry/fexit for /all/ existing BPF programs in the system? It
could then sort the sample interval by run_cnt, cycles, cache misses, aggregated
runtime, etc in a top-like output. Wdyt?

Thanks,
Daniel
