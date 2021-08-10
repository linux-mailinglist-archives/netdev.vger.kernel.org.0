Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id D08553E5975
	for <lists+netdev@lfdr.de>; Tue, 10 Aug 2021 13:51:41 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S238348AbhHJLvs (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 10 Aug 2021 07:51:48 -0400
Received: from www62.your-server.de ([213.133.104.62]:59110 "EHLO
        www62.your-server.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S237516AbhHJLvp (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 10 Aug 2021 07:51:45 -0400
Received: from sslproxy01.your-server.de ([78.46.139.224])
        by www62.your-server.de with esmtpsa (TLSv1.3:TLS_AES_256_GCM_SHA384:256)
        (Exim 4.92.3)
        (envelope-from <daniel@iogearbox.net>)
        id 1mDQHv-0004Ol-Vj; Tue, 10 Aug 2021 13:51:20 +0200
Received: from [85.5.47.65] (helo=linux.home)
        by sslproxy01.your-server.de with esmtpsa (TLSv1.3:TLS_AES_256_GCM_SHA384:256)
        (Exim 4.92)
        (envelope-from <daniel@iogearbox.net>)
        id 1mDQHv-000Jr6-Kz; Tue, 10 Aug 2021 13:51:19 +0200
Subject: Re: [PATCH bpf-next 1/1] bpf: migrate cgroup_bpf to internal
 cgroup_bpf_attach_type enum
To:     Andrii Nakryiko <andrii.nakryiko@gmail.com>,
        Dave Marchevsky <davemarchevsky@fb.com>
Cc:     bpf <bpf@vger.kernel.org>, Networking <netdev@vger.kernel.org>,
        Alexei Starovoitov <ast@kernel.org>,
        Andrii Nakryiko <andrii@kernel.org>,
        Martin KaFai Lau <kafai@fb.com>,
        Song Liu <songliubraving@fb.com>, Yonghong Song <yhs@fb.com>,
        John Fastabend <john.fastabend@gmail.com>,
        KP Singh <kpsingh@kernel.org>
References: <20210731233056.850105-1-davemarchevsky@fb.com>
 <20210731233056.850105-2-davemarchevsky@fb.com>
 <CAEf4BzYJanf4gCmeeNHZhjJeUwwOQOCteCP4Uoj3yRD698BJCg@mail.gmail.com>
From:   Daniel Borkmann <daniel@iogearbox.net>
Message-ID: <9883d0ca-df89-5bca-aa94-67fb4e620ac2@iogearbox.net>
Date:   Tue, 10 Aug 2021 13:51:18 +0200
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:60.0) Gecko/20100101
 Thunderbird/60.7.2
MIME-Version: 1.0
In-Reply-To: <CAEf4BzYJanf4gCmeeNHZhjJeUwwOQOCteCP4Uoj3yRD698BJCg@mail.gmail.com>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Language: en-US
Content-Transfer-Encoding: 7bit
X-Authenticated-Sender: daniel@iogearbox.net
X-Virus-Scanned: Clear (ClamAV 0.103.2/26259/Tue Aug 10 10:19:56 2021)
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On 8/2/21 11:35 PM, Andrii Nakryiko wrote:
> On Sat, Jul 31, 2021 at 4:33 PM Dave Marchevsky <davemarchevsky@fb.com> wrote:
[...]
> 
>>   #define BPF_CGROUP_RUN_PROG_INET_SOCK(sk)                                     \
>> -       BPF_CGROUP_RUN_SK_PROG(sk, BPF_CGROUP_INET_SOCK_CREATE)
>> +       BPF_CGROUP_RUN_SK_PROG(sk, CG_BPF_CGROUP_INET_SOCK_CREATE)
>>
>>   #define BPF_CGROUP_RUN_PROG_INET_SOCK_RELEASE(sk)                             \
>> -       BPF_CGROUP_RUN_SK_PROG(sk, BPF_CGROUP_INET_SOCK_RELEASE)
>> +       BPF_CGROUP_RUN_SK_PROG(sk, CG_BPF_CGROUP_INET_SOCK_RELEASE)
>>
>>   #define BPF_CGROUP_RUN_PROG_INET4_POST_BIND(sk)                                       \
>> -       BPF_CGROUP_RUN_SK_PROG(sk, BPF_CGROUP_INET4_POST_BIND)
>> +       BPF_CGROUP_RUN_SK_PROG(sk, CG_BPF_CGROUP_INET4_POST_BIND)
>>
>>   #define BPF_CGROUP_RUN_PROG_INET6_POST_BIND(sk)                                       \
>> -       BPF_CGROUP_RUN_SK_PROG(sk, BPF_CGROUP_INET6_POST_BIND)
>> +       BPF_CGROUP_RUN_SK_PROG(sk, CG_BPF_CGROUP_INET6_POST_BIND)
>>
> 
> all these macros are candidate for a rewrite to proper (always
> inlined) functions, similarly to what I did in [0]. It would make it
> much harder to accidentally use wrong constant and will make typing
> explicit. But let's see how that change goes first.

Fully agree, this has grown into a horrible mess over time, would be nice
to have this refactored and cleaned up. :/

>    [0] https://patchwork.kernel.org/project/netdevbpf/patch/20210730053413.1090371-3-andrii@kernel.org/
> 
>> -#define BPF_CGROUP_RUN_SA_PROG(sk, uaddr, type)                                       \
>> +#define BPF_CGROUP_RUN_SA_PROG(sk, uaddr, atype)                                      \
>>   ({                                                                            \
>>          u32 __unused_flags;                                                    \
>>          int __ret = 0;                                                         \
>> -       if (cgroup_bpf_enabled(type))                                          \
>> -               __ret = __cgroup_bpf_run_filter_sock_addr(sk, uaddr, type,     \
>> +       if (cgroup_bpf_enabled(atype))                                         \
>> +               __ret = __cgroup_bpf_run_filter_sock_addr(sk, uaddr, atype,     \
>>                                                            NULL,                \
>>                                                            &__unused_flags);    \
>>          __ret;                                                                 \
>>   })
>>
> 
> [...]
> 

