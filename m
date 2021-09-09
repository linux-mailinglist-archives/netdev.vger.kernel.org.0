Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 74A0B404699
	for <lists+netdev@lfdr.de>; Thu,  9 Sep 2021 09:57:42 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230073AbhIIH6v (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 9 Sep 2021 03:58:51 -0400
Received: from www62.your-server.de ([213.133.104.62]:59298 "EHLO
        www62.your-server.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229609AbhIIH6r (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 9 Sep 2021 03:58:47 -0400
Received: from sslproxy01.your-server.de ([78.46.139.224])
        by www62.your-server.de with esmtpsa (TLSv1.3:TLS_AES_256_GCM_SHA384:256)
        (Exim 4.92.3)
        (envelope-from <daniel@iogearbox.net>)
        id 1mOEvf-0001T3-P1; Thu, 09 Sep 2021 09:57:03 +0200
Received: from [85.5.47.65] (helo=linux.home)
        by sslproxy01.your-server.de with esmtpsa (TLSv1.3:TLS_AES_256_GCM_SHA384:256)
        (Exim 4.92)
        (envelope-from <daniel@iogearbox.net>)
        id 1mOEvf-000H3n-3x; Thu, 09 Sep 2021 09:57:03 +0200
Subject: Re: [PATCH bpf-next] bpf: Change value of MAX_TAIL_CALL_CNT from 32
 to 33
To:     Andrii Nakryiko <andrii.nakryiko@gmail.com>,
        Tiezhu Yang <yangtiezhu@loongson.cn>
Cc:     Shubham Bansal <illusionist.neo@gmail.com>,
        Russell King <linux@armlinux.org.uk>,
        Alexei Starovoitov <ast@kernel.org>,
        Andrii Nakryiko <andrii@kernel.org>,
        Martin KaFai Lau <kafai@fb.com>,
        Song Liu <songliubraving@fb.com>, Yonghong Song <yhs@fb.com>,
        John Fastabend <john.fastabend@gmail.com>,
        KP Singh <kpsingh@kernel.org>,
        Zi Shen Lim <zlim.lnx@gmail.com>,
        Catalin Marinas <catalin.marinas@arm.com>,
        Will Deacon <will@kernel.org>,
        Paul Burton <paulburton@kernel.org>,
        Thomas Bogendoerfer <tsbogend@alpha.franken.de>,
        naveen.n.rao@linux.ibm.com, Michael Ellerman <mpe@ellerman.id.au>,
        Benjamin Herrenschmidt <benh@kernel.crashing.org>,
        Paul Mackerras <paulus@samba.org>,
        Luke Nelson <luke.r.nels@gmail.com>,
        Xi Wang <xi.wang@gmail.com>,
        Paul Walmsley <paul.walmsley@sifive.com>,
        Palmer Dabbelt <palmer@dabbelt.com>,
        Albert Ou <aou@eecs.berkeley.edu>,
        =?UTF-8?B?QmrDtnJuIFTDtnBlbA==?= <bjorn@kernel.org>,
        "David S. Miller" <davem@davemloft.net>,
        Johan Almbladh <johan.almbladh@anyfinetworks.com>,
        Paul Chaignon <paul@cilium.io>,
        Networking <netdev@vger.kernel.org>, bpf <bpf@vger.kernel.org>,
        linux-arm-kernel <linux-arm-kernel@lists.infradead.org>,
        open list <linux-kernel@vger.kernel.org>,
        linux-mips@vger.kernel.org, linuxppc-dev@lists.ozlabs.org,
        linux-riscv@lists.infradead.org, sparclinux@vger.kernel.org
References: <1631158350-3661-1-git-send-email-yangtiezhu@loongson.cn>
 <CAEf4BzZqoVZ7keWCLmC=A5oPPwj_xMNRWDkJUcjWn9yE_z1gSg@mail.gmail.com>
From:   Daniel Borkmann <daniel@iogearbox.net>
Message-ID: <e9063116-617a-5916-bc6f-a1e917776bd7@iogearbox.net>
Date:   Thu, 9 Sep 2021 09:57:02 +0200
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:60.0) Gecko/20100101
 Thunderbird/60.7.2
MIME-Version: 1.0
In-Reply-To: <CAEf4BzZqoVZ7keWCLmC=A5oPPwj_xMNRWDkJUcjWn9yE_z1gSg@mail.gmail.com>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Language: en-US
Content-Transfer-Encoding: 7bit
X-Authenticated-Sender: daniel@iogearbox.net
X-Virus-Scanned: Clear (ClamAV 0.103.2/26288/Wed Sep  8 10:22:21 2021)
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On 9/9/21 7:50 AM, Andrii Nakryiko wrote:
> On Wed, Sep 8, 2021 at 8:33 PM Tiezhu Yang <yangtiezhu@loongson.cn> wrote:
>>
>> In the current code, the actual max tail call count is 33 which is greater
>> than MAX_TAIL_CALL_CNT (defined as 32), the actual limit is not consistent
>> with the meaning of MAX_TAIL_CALL_CNT, there is some confusion and need to
>> spend some time to think the reason at the first glance.
> 
> think *about* the reason
> 
>> We can see the historical evolution from commit 04fd61ab36ec ("bpf: allow
>> bpf programs to tail-call other bpf programs") and commit f9dabe016b63
>> ("bpf: Undo off-by-one in interpreter tail call count limit").
>>
>> In order to avoid changing existing behavior, the actual limit is 33 now,
>> this is resonable.
> 
> typo: reasonable
> 
>> After commit 874be05f525e ("bpf, tests: Add tail call test suite"), we can
>> see there exists failed testcase.
>>
>> On all archs when CONFIG_BPF_JIT_ALWAYS_ON is not set:
>>   # echo 0 > /proc/sys/net/core/bpf_jit_enable
>>   # modprobe test_bpf
>>   # dmesg | grep -w FAIL
>>   Tail call error path, max count reached jited:0 ret 34 != 33 FAIL
>>
>> On some archs:
>>   # echo 1 > /proc/sys/net/core/bpf_jit_enable
>>   # modprobe test_bpf
>>   # dmesg | grep -w FAIL
>>   Tail call error path, max count reached jited:1 ret 34 != 33 FAIL
>>
>> So it is necessary to change the value of MAX_TAIL_CALL_CNT from 32 to 33,
>> then do some small changes of the related code.
>>
>> With this patch, it does not change the current limit, MAX_TAIL_CALL_CNT
>> can reflect the actual max tail call count, and the above failed testcase
>> can be fixed.
>>
>> Signed-off-by: Tiezhu Yang <yangtiezhu@loongson.cn>
>> ---
> 
> This change breaks selftests ([0]), please fix them at the same time
> as you are changing the kernel behavior:

The below selftests shouldn't have to change given there is no change in
behavior intended (MAX_TAIL_CALL_CNT is bumped to 33 but counter inc'ed
prior to the comparison). It just means that /all/ JITs must be changed
and in particular properly _tested_.

>    test_tailcall_2:PASS:tailcall 128 nsec
>    test_tailcall_2:PASS:tailcall 128 nsec
>    test_tailcall_2:FAIL:tailcall err 0 errno 2 retval 4
>    #135/2 tailcalls/tailcall_2:FAIL
>    test_tailcall_3:PASS:tailcall 128 nsec
>    test_tailcall_3:FAIL:tailcall count err 0 errno 2 count 34
>    test_tailcall_3:PASS:tailcall 128 nsec
>    #135/3 tailcalls/tailcall_3:FAIL
>    #135/4 tailcalls/tailcall_4:OK
>    #135/5 tailcalls/tailcall_5:OK
>    #135/6 tailcalls/tailcall_bpf2bpf_1:OK
>    test_tailcall_bpf2bpf_2:PASS:tailcall 128 nsec
>    test_tailcall_bpf2bpf_2:FAIL:tailcall count err 0 errno 2 count 34
>    test_tailcall_bpf2bpf_2:PASS:tailcall 128 nsec
>    #135/7 tailcalls/tailcall_bpf2bpf_2:FAIL
>    #135/8 tailcalls/tailcall_bpf2bpf_3:OK
>    test_tailcall_bpf2bpf_4:PASS:tailcall 54 nsec
>    test_tailcall_bpf2bpf_4:FAIL:tailcall count err 0 errno 2 count 32
>    #135/9 tailcalls/tailcall_bpf2bpf_4:FAIL
>    test_tailcall_bpf2bpf_4:PASS:tailcall 54 nsec
>    test_tailcall_bpf2bpf_4:FAIL:tailcall count err 0 errno 2 count 32
>    #135/10 tailcalls/tailcall_bpf2bpf_5:FAIL
>    #135 tailcalls:FAIL
> 
>    [0] https://github.com/kernel-patches/bpf/pull/1747/checks?check_run_id=3552002906
> 
>>   arch/arm/net/bpf_jit_32.c         | 11 ++++++-----
>>   arch/arm64/net/bpf_jit_comp.c     |  7 ++++---
>>   arch/mips/net/ebpf_jit.c          |  4 ++--
>>   arch/powerpc/net/bpf_jit_comp32.c |  4 ++--
>>   arch/powerpc/net/bpf_jit_comp64.c | 12 ++++++------
>>   arch/riscv/net/bpf_jit_comp32.c   |  4 ++--
>>   arch/riscv/net/bpf_jit_comp64.c   |  4 ++--
>>   arch/sparc/net/bpf_jit_comp_64.c  |  8 ++++----
>>   include/linux/bpf.h               |  2 +-
>>   kernel/bpf/core.c                 |  4 ++--
>>   10 files changed, 31 insertions(+), 29 deletions(-)
>>
> 
> [...]
> 

