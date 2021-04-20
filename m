Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 0209D365CBE
	for <lists+netdev@lfdr.de>; Tue, 20 Apr 2021 17:58:39 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232174AbhDTP7H (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 20 Apr 2021 11:59:07 -0400
Received: from www62.your-server.de ([213.133.104.62]:41540 "EHLO
        www62.your-server.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232303AbhDTP7F (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 20 Apr 2021 11:59:05 -0400
Received: from sslproxy06.your-server.de ([78.46.172.3])
        by www62.your-server.de with esmtpsa (TLSv1.3:TLS_AES_256_GCM_SHA384:256)
        (Exim 4.92.3)
        (envelope-from <daniel@iogearbox.net>)
        id 1lYslg-0006BR-Eo; Tue, 20 Apr 2021 17:58:28 +0200
Received: from [85.7.101.30] (helo=linux.home)
        by sslproxy06.your-server.de with esmtpsa (TLSv1.3:TLS_AES_256_GCM_SHA384:256)
        (Exim 4.92)
        (envelope-from <daniel@iogearbox.net>)
        id 1lYslg-0003VA-5f; Tue, 20 Apr 2021 17:58:28 +0200
Subject: Re: [PATCH bpf-next v4 2/3] bpf: selftests: remove percpu macros from
 bpf_util.h
To:     Alexei Starovoitov <alexei.starovoitov@gmail.com>,
        Pedro Tammela <pctammela@gmail.com>
Cc:     Alexei Starovoitov <ast@kernel.org>,
        Andrii Nakryiko <andrii@kernel.org>,
        Martin KaFai Lau <kafai@fb.com>,
        Song Liu <songliubraving@fb.com>, Yonghong Song <yhs@fb.com>,
        John Fastabend <john.fastabend@gmail.com>,
        KP Singh <kpsingh@kernel.org>, Shuah Khan <shuah@kernel.org>,
        Pedro Tammela <pctammela@mojatatu.com>,
        David Verbeiren <david.verbeiren@tessares.net>,
        Matthieu Baerts <matthieu.baerts@tessares.net>,
        Network Development <netdev@vger.kernel.org>,
        bpf <bpf@vger.kernel.org>
References: <20210415174619.51229-1-pctammela@mojatatu.com>
 <20210415174619.51229-3-pctammela@mojatatu.com>
 <CAADnVQ+XtLj2vUmfazYu8-k3+bd0bJFJUTZWGRBALV1xy-vqFg@mail.gmail.com>
From:   Daniel Borkmann <daniel@iogearbox.net>
Message-ID: <e9c5baa2-62e1-86eb-6cde-a6ceec8f05dc@iogearbox.net>
Date:   Tue, 20 Apr 2021 17:58:27 +0200
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:60.0) Gecko/20100101
 Thunderbird/60.7.2
MIME-Version: 1.0
In-Reply-To: <CAADnVQ+XtLj2vUmfazYu8-k3+bd0bJFJUTZWGRBALV1xy-vqFg@mail.gmail.com>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Language: en-US
Content-Transfer-Encoding: 7bit
X-Authenticated-Sender: daniel@iogearbox.net
X-Virus-Scanned: Clear (ClamAV 0.102.4/26146/Tue Apr 20 13:06:39 2021)
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On 4/20/21 3:17 AM, Alexei Starovoitov wrote:
> On Thu, Apr 15, 2021 at 10:47 AM Pedro Tammela <pctammela@gmail.com> wrote:
>>
>> Andrii suggested to remove this abstraction layer and have the percpu
>> handling more explicit[1].
>>
>> This patch also updates the tests that relied on the macros.
>>
>> [1] https://lore.kernel.org/bpf/CAEf4BzYmj_ZPDq8Zi4dbntboJKRPU2TVopysBNrdd9foHTfLZw@mail.gmail.com/
>>
>> Suggested-by: Andrii Nakryiko <andrii@kernel.org>
>> Signed-off-by: Pedro Tammela <pctammela@mojatatu.com>
>> ---
>>   tools/testing/selftests/bpf/bpf_util.h        |  7 --
>>   .../bpf/map_tests/htab_map_batch_ops.c        | 87 +++++++++----------
>>   .../selftests/bpf/prog_tests/map_init.c       |  9 +-
>>   tools/testing/selftests/bpf/test_maps.c       | 84 +++++++++++-------
>>   4 files changed, 96 insertions(+), 91 deletions(-)
>>
>> diff --git a/tools/testing/selftests/bpf/bpf_util.h b/tools/testing/selftests/bpf/bpf_util.h
>> index a3352a64c067..105db3120ab4 100644
>> --- a/tools/testing/selftests/bpf/bpf_util.h
>> +++ b/tools/testing/selftests/bpf/bpf_util.h
>> @@ -20,13 +20,6 @@ static inline unsigned int bpf_num_possible_cpus(void)
>>          return possible_cpus;
>>   }
>>
>> -#define __bpf_percpu_val_align __attribute__((__aligned__(8)))
>> -
>> -#define BPF_DECLARE_PERCPU(type, name)                         \
>> -       struct { type v; /* padding */ } __bpf_percpu_val_align \
>> -               name[bpf_num_possible_cpus()]
>> -#define bpf_percpu(name, cpu) name[(cpu)].v
>> -
> 
> Hmm. I wonder what Daniel has to say about it, since he
> introduced it in commit f3515b5d0b71 ("bpf: provide a generic macro
> for percpu values for selftests")
> to address a class of bugs.

I would probably even move those into libbpf instead. ;-) The problem is that this can
be missed easily and innocent changes would lead to corruption of the applications
memory if there's a map lookup. Having this at least in selftest code or even in libbpf
would document code-wise that care needs to be taken on per cpu maps. Even if we'd put
a note under Documentation/bpf/ or such, this might get missed easily and finding such
bugs is like looking for a needle in a haystack.. so I don't think this should be removed.

Thanks,
Daniel
