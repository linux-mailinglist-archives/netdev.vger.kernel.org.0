Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 38B45308305
	for <lists+netdev@lfdr.de>; Fri, 29 Jan 2021 02:11:53 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231151AbhA2BJp (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 28 Jan 2021 20:09:45 -0500
Received: from www62.your-server.de ([213.133.104.62]:42830 "EHLO
        www62.your-server.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231397AbhA2BJ1 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 28 Jan 2021 20:09:27 -0500
Received: from sslproxy02.your-server.de ([78.47.166.47])
        by www62.your-server.de with esmtpsa (TLSv1.3:TLS_AES_256_GCM_SHA384:256)
        (Exim 4.92.3)
        (envelope-from <daniel@iogearbox.net>)
        id 1l5IHF-0008NN-PA; Fri, 29 Jan 2021 02:08:45 +0100
Received: from [85.7.101.30] (helo=pc-9.home)
        by sslproxy02.your-server.de with esmtpsa (TLSv1.3:TLS_AES_256_GCM_SHA384:256)
        (Exim 4.92)
        (envelope-from <daniel@iogearbox.net>)
        id 1l5IHF-0002Do-KA; Fri, 29 Jan 2021 02:08:45 +0100
Subject: Re: [PATCH bpf-next v2 4/4] bpf: enable bpf_{g,s}etsockopt in
 BPF_CGROUP_UDP{4,6}_RECVMSG
To:     Stanislav Fomichev <sdf@google.com>
Cc:     Netdev <netdev@vger.kernel.org>, bpf <bpf@vger.kernel.org>,
        Alexei Starovoitov <ast@kernel.org>
References: <20210127232853.3753823-1-sdf@google.com>
 <20210127232853.3753823-5-sdf@google.com>
 <3098d1b1-3438-6646-d466-feed27e9ba6b@iogearbox.net>
 <CAKH8qBsU+8495AwcCtQ0fQ8B6mrRLULZ4k3A=XUX3BL0gha_cA@mail.gmail.com>
From:   Daniel Borkmann <daniel@iogearbox.net>
Message-ID: <d421b6b5-f591-756f-2d73-0fab367a68f5@iogearbox.net>
Date:   Fri, 29 Jan 2021 02:08:39 +0100
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:60.0) Gecko/20100101
 Thunderbird/60.7.2
MIME-Version: 1.0
In-Reply-To: <CAKH8qBsU+8495AwcCtQ0fQ8B6mrRLULZ4k3A=XUX3BL0gha_cA@mail.gmail.com>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Language: en-US
Content-Transfer-Encoding: 7bit
X-Authenticated-Sender: daniel@iogearbox.net
X-Virus-Scanned: Clear (ClamAV 0.102.4/26063/Thu Jan 28 13:28:06 2021)
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On 1/29/21 1:59 AM, Stanislav Fomichev wrote:
> On Thu, Jan 28, 2021 at 4:52 PM Daniel Borkmann <daniel@iogearbox.net> wrote:
>> On 1/28/21 12:28 AM, Stanislav Fomichev wrote:
>>> Those hooks run as BPF_CGROUP_RUN_SA_PROG_LOCK and operate on
>>> a locked socket.
>>>
>>> Signed-off-by: Stanislav Fomichev <sdf@google.com>
>>> ---
>>>    net/core/filter.c                                 | 4 ++++
>>>    tools/testing/selftests/bpf/progs/recvmsg4_prog.c | 5 +++++
>>>    tools/testing/selftests/bpf/progs/recvmsg6_prog.c | 5 +++++
>>>    3 files changed, 14 insertions(+)
>>>
>>> diff --git a/net/core/filter.c b/net/core/filter.c
>>> index ba436b1d70c2..e15d4741719a 100644
>>> --- a/net/core/filter.c
>>> +++ b/net/core/filter.c
>>> @@ -7023,6 +7023,8 @@ sock_addr_func_proto(enum bpf_func_id func_id, const struct bpf_prog *prog)
>>>                case BPF_CGROUP_INET6_BIND:
>>>                case BPF_CGROUP_INET4_CONNECT:
>>>                case BPF_CGROUP_INET6_CONNECT:
>>> +             case BPF_CGROUP_UDP4_RECVMSG:
>>> +             case BPF_CGROUP_UDP6_RECVMSG:
>>>                case BPF_CGROUP_UDP4_SENDMSG:
>>>                case BPF_CGROUP_UDP6_SENDMSG:
>>>                case BPF_CGROUP_INET4_GETPEERNAME:
>>> @@ -7039,6 +7041,8 @@ sock_addr_func_proto(enum bpf_func_id func_id, const struct bpf_prog *prog)
>>>                case BPF_CGROUP_INET6_BIND:
>>>                case BPF_CGROUP_INET4_CONNECT:
>>>                case BPF_CGROUP_INET6_CONNECT:
>>> +             case BPF_CGROUP_UDP4_RECVMSG:
>>> +             case BPF_CGROUP_UDP6_RECVMSG:
>>>                case BPF_CGROUP_UDP4_SENDMSG:
>>>                case BPF_CGROUP_UDP6_SENDMSG:
>>>                case BPF_CGROUP_INET4_GETPEERNAME:
>>
>> Looks good overall, also thanks for adding the test cases! I was about to apply, but noticed one
>> small nit that would be good to get resolved before that. Above you now list all the attach hooks
>> for sock_addr ctx, so we should just remove the whole switch that tests on prog->expected_attach_type
>> altogether in this last commit.
> Sure, I can resend tomorrow.
> But do you think it's safe and there won't ever be another sock_addr
> hook that runs with an unlocked socket?

Ok, that rationale seems reasonable to keep the series as is. It probably makes sense to add a
small comment at least to the commit log to explain the reasoning, I can do so while applying.
So no need for v3, thanks!
