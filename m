Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id A80681962E9
	for <lists+netdev@lfdr.de>; Sat, 28 Mar 2020 02:40:25 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726661AbgC1BkY (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 27 Mar 2020 21:40:24 -0400
Received: from www62.your-server.de ([213.133.104.62]:55572 "EHLO
        www62.your-server.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726225AbgC1BkY (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 27 Mar 2020 21:40:24 -0400
Received: from sslproxy05.your-server.de ([78.46.172.2])
        by www62.your-server.de with esmtpsa (TLSv1.2:DHE-RSA-AES256-GCM-SHA384:256)
        (Exim 4.89_1)
        (envelope-from <daniel@iogearbox.net>)
        id 1jI0SQ-0003Bt-IQ; Sat, 28 Mar 2020 02:40:18 +0100
Received: from [178.195.186.98] (helo=pc-9.home)
        by sslproxy05.your-server.de with esmtpsa (TLSv1.3:TLS_AES_256_GCM_SHA384:256)
        (Exim 4.92)
        (envelope-from <daniel@iogearbox.net>)
        id 1jI0SQ-000ChE-9i; Sat, 28 Mar 2020 02:40:18 +0100
Subject: Re: [PATCH bpf-next 6/7] bpf: enable retrival of pid/tgid/comm from
 bpf cgroup hooks
To:     Andrii Nakryiko <andrii.nakryiko@gmail.com>
Cc:     Alexei Starovoitov <alexei.starovoitov@gmail.com>,
        Martynas Pumputis <m@lambda.lt>,
        Joe Stringer <joe@wand.net.nz>, bpf <bpf@vger.kernel.org>,
        Networking <netdev@vger.kernel.org>
References: <cover.1585323121.git.daniel@iogearbox.net>
 <18744744ed93c06343be8b41edcfd858706f39d7.1585323121.git.daniel@iogearbox.net>
 <CAEf4BzYjh++aorwBzgjdcWmRiw7GV4p=2avWqZu8S2Jdv3A3tQ@mail.gmail.com>
From:   Daniel Borkmann <daniel@iogearbox.net>
Message-ID: <b1af640d-527c-8641-6c85-e31e94840f85@iogearbox.net>
Date:   Sat, 28 Mar 2020 02:40:17 +0100
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:60.0) Gecko/20100101
 Thunderbird/60.7.2
MIME-Version: 1.0
In-Reply-To: <CAEf4BzYjh++aorwBzgjdcWmRiw7GV4p=2avWqZu8S2Jdv3A3tQ@mail.gmail.com>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Language: en-US
Content-Transfer-Encoding: 7bit
X-Authenticated-Sender: daniel@iogearbox.net
X-Virus-Scanned: Clear (ClamAV 0.102.2/25764/Fri Mar 27 14:11:26 2020)
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On 3/28/20 1:49 AM, Andrii Nakryiko wrote:
> On Fri, Mar 27, 2020 at 8:59 AM Daniel Borkmann <daniel@iogearbox.net> wrote:
>>
>> We already have the bpf_get_current_uid_gid() helper enabled, and
>> given we now have perf event RB output available for connect(),
>> sendmsg(), recvmsg() and bind-related hooks, add a trivial change
>> to enable bpf_get_current_pid_tgid() and bpf_get_current_comm()
>> as well.
>>
>> Signed-off-by: Daniel Borkmann <daniel@iogearbox.net>
>> ---
> 
> LGTM, there was probably never a good reason this wasn't available
> from the very beginning :)

Right. :-)

> Might as well add bpf_get_current_uid_gid() if it's not there yet.

It's already there. ;-)

> Acked-by: Andrii Nakryiko <andriin@fb.com>
> 
>>   net/core/filter.c | 8 ++++++++
>>   1 file changed, 8 insertions(+)
>>
>> diff --git a/net/core/filter.c b/net/core/filter.c
>> index 5cec3ac9e3dd..bb4a196c8809 100644
>> --- a/net/core/filter.c
>> +++ b/net/core/filter.c
>> @@ -6018,6 +6018,10 @@ sock_filter_func_proto(enum bpf_func_id func_id, const struct bpf_prog *prog)
>>                  return &bpf_get_netns_cookie_sock_proto;
>>          case BPF_FUNC_perf_event_output:
>>                  return &bpf_event_output_data_proto;
>> +       case BPF_FUNC_get_current_pid_tgid:
>> +               return &bpf_get_current_pid_tgid_proto;
>> +       case BPF_FUNC_get_current_comm:
>> +               return &bpf_get_current_comm_proto;
> 
> So you are not adding it to bpf_base_func_proto() instead, because
> that one can be used in BPF programs that don't have a valid current,
> is that right? If yes, would it make sense to have a common
> bpf_base_process_ctx_func_proto() function for cases where there is a
> valid current and add all the functions there (including uid_gid and
> whatever else makes sense?)

I didn't add it to bpf_base_func_proto() since we might not always have
a useful 'current' available. My focus in this series was on sock_addr
and sock helpers for our LB where 'current' is always the application
doing the syscall. A common base_func_proto() for both could be useful
though this only works with helpers that do not rely on the input context
since both are different. Tbh, the whole net/core/filter.c feels quite
convoluted these days where it's getting hard to follow which func_proto
and access checker belongs to which program type. I can check if we could
get some more order in there in general through some larger refactoring
to make it easier for people to extend, though not sure if more
bpf_base_func_proto()-like helpers would add much, I think it needs a
larger revamp.

>>   #ifdef CONFIG_CGROUPS
>>          case BPF_FUNC_get_current_cgroup_id:
>>                  return &bpf_get_current_cgroup_id_proto;
>> @@ -6058,6 +6062,10 @@ sock_addr_func_proto(enum bpf_func_id func_id, const struct bpf_prog *prog)
>>                  return &bpf_get_local_storage_proto;
>>          case BPF_FUNC_perf_event_output:
>>                  return &bpf_event_output_data_proto;
>> +       case BPF_FUNC_get_current_pid_tgid:
>> +               return &bpf_get_current_pid_tgid_proto;
>> +       case BPF_FUNC_get_current_comm:
>> +               return &bpf_get_current_comm_proto;
>>   #ifdef CONFIG_CGROUPS
>>          case BPF_FUNC_get_current_cgroup_id:
>>                  return &bpf_get_current_cgroup_id_proto;
>> --
>> 2.21.0
>>

