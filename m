Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id E38F834AA56
	for <lists+netdev@lfdr.de>; Fri, 26 Mar 2021 15:42:49 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230051AbhCZOmQ (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 26 Mar 2021 10:42:16 -0400
Received: from pegase1.c-s.fr ([93.17.236.30]:30047 "EHLO pegase1.c-s.fr"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S230230AbhCZOmG (ORCPT <rfc822;netdev@vger.kernel.org>);
        Fri, 26 Mar 2021 10:42:06 -0400
Received: from localhost (mailhub1-int [192.168.12.234])
        by localhost (Postfix) with ESMTP id 4F6PnR4Ky0z9v0Nc;
        Fri, 26 Mar 2021 15:42:03 +0100 (CET)
X-Virus-Scanned: Debian amavisd-new at c-s.fr
Received: from pegase1.c-s.fr ([192.168.12.234])
        by localhost (pegase1.c-s.fr [192.168.12.234]) (amavisd-new, port 10024)
        with ESMTP id CVOEt96TWs_n; Fri, 26 Mar 2021 15:42:03 +0100 (CET)
Received: from messagerie.si.c-s.fr (messagerie.si.c-s.fr [192.168.25.192])
        by pegase1.c-s.fr (Postfix) with ESMTP id 4F6PnR3NyVz9v0NB;
        Fri, 26 Mar 2021 15:42:03 +0100 (CET)
Received: from localhost (localhost [127.0.0.1])
        by messagerie.si.c-s.fr (Postfix) with ESMTP id 3E5CD8B8D9;
        Fri, 26 Mar 2021 15:42:05 +0100 (CET)
X-Virus-Scanned: amavisd-new at c-s.fr
Received: from messagerie.si.c-s.fr ([127.0.0.1])
        by localhost (messagerie.si.c-s.fr [127.0.0.1]) (amavisd-new, port 10023)
        with ESMTP id PwkSzDQZPpbn; Fri, 26 Mar 2021 15:42:05 +0100 (CET)
Received: from [192.168.4.90] (unknown [192.168.4.90])
        by messagerie.si.c-s.fr (Postfix) with ESMTP id 25D228B8D7;
        Fri, 26 Mar 2021 15:42:04 +0100 (CET)
Subject: Re: [PATCH v2 0/8] Implement EBPF on powerpc32
To:     Andrii Nakryiko <andrii.nakryiko@gmail.com>
Cc:     Benjamin Herrenschmidt <benh@kernel.crashing.org>,
        Paul Mackerras <paulus@samba.org>,
        Michael Ellerman <mpe@ellerman.id.au>,
        Alexei Starovoitov <ast@kernel.org>,
        Daniel Borkmann <daniel@iogearbox.net>,
        Andrii Nakryiko <andrii@kernel.org>, Martin Lau <kafai@fb.com>,
        Song Liu <songliubraving@fb.com>, Yonghong Song <yhs@fb.com>,
        john fastabend <john.fastabend@gmail.com>,
        KP Singh <kpsingh@chromium.org>, naveen.n.rao@linux.ibm.com,
        sandipan@linux.ibm.com, open list <linux-kernel@vger.kernel.org>,
        linuxppc-dev@lists.ozlabs.org, Networking <netdev@vger.kernel.org>,
        bpf <bpf@vger.kernel.org>
References: <cover.1616430991.git.christophe.leroy@csgroup.eu>
 <CAEf4BzZjNK_La1t5FGyie02FCABBieZJod49rW4=WtMs7ELLSw@mail.gmail.com>
From:   Christophe Leroy <christophe.leroy@csgroup.eu>
Message-ID: <86028d25-c3fe-3765-f7c3-12448523405a@csgroup.eu>
Date:   Fri, 26 Mar 2021 15:41:59 +0100
User-Agent: Mozilla/5.0 (Windows NT 6.1; Win64; x64; rv:78.0) Gecko/20100101
 Thunderbird/78.9.0
MIME-Version: 1.0
In-Reply-To: <CAEf4BzZjNK_La1t5FGyie02FCABBieZJod49rW4=WtMs7ELLSw@mail.gmail.com>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Language: fr
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org



Le 22/03/2021 à 18:53, Andrii Nakryiko a écrit :
> On Mon, Mar 22, 2021 at 9:37 AM Christophe Leroy
> <christophe.leroy@csgroup.eu> wrote:
>>
>> This series implements extended BPF on powerpc32. For the implementation
>> details, see the patch before the last.
>>
>> The following operations are not implemented:
>>
>>                  case BPF_ALU64 | BPF_DIV | BPF_X: /* dst /= src */
>>                  case BPF_ALU64 | BPF_MOD | BPF_X: /* dst %= src */
>>                  case BPF_STX | BPF_XADD | BPF_DW: /* *(u64 *)(dst + off) += src */
>>
>> The following operations are only implemented for power of two constants:
>>
>>                  case BPF_ALU64 | BPF_MOD | BPF_K: /* dst %= imm */
>>                  case BPF_ALU64 | BPF_DIV | BPF_K: /* dst /= imm */
>>
>> Below are the results on a powerpc 885:
>> - with the patch, with and without bpf_jit_enable
>> - without the patch, with bpf_jit_enable (ie with CBPF)
>>
>> With the patch, with bpf_jit_enable = 1 :
>>
>> [   60.826529] test_bpf: Summary: 378 PASSED, 0 FAILED, [354/366 JIT'ed]
>> [   60.832505] test_bpf: test_skb_segment: Summary: 2 PASSED, 0 FAILED
>>
>> With the patch, with bpf_jit_enable = 0 :
>>
>> [   75.186337] test_bpf: Summary: 378 PASSED, 0 FAILED, [0/366 JIT'ed]
>> [   75.192325] test_bpf: test_skb_segment: Summary: 2 PASSED, 0 FAILED
>>
>> Without the patch, with bpf_jit_enable = 1 :
>>
>> [  186.112429] test_bpf: Summary: 371 PASSED, 7 FAILED, [119/366 JIT'ed]
>>
>> Couldn't run test_progs because it doesn't build (clang 11 crashes during the build).
> 
> Can you please try checking out the latest clang from sources and use
> that one instead?

The crash is fixed, it builds one step more, then fails at:

[root@PC-server-ldb bpf]# make CROSS_COMPILE=ppc-linux- ARCH=powerpc V=1
/root/gen_ldb/linux-powerpc/tools/testing/selftests/bpf/host-tools/sbin/bpftool gen skeleton 
/root/gen_ldb/linux-powerpc/tools/testing/selftests/bpf/atomic_bounds.o > 
/root/gen_ldb/linux-powerpc/tools/testing/selftests/bpf/atomic_bounds.skel.h
libbpf: elf: endianness mismatch in atomic_bounds.
Error: failed to open BPF object file: Endian mismatch

I'm cross-building on x86 for powerpc/32

[root@PC-server-ldb bpf]# file atomic_bounds.o
atomic_bounds.o: ELF 64-bit MSB relocatable, eBPF, version 1 (SYSV), with debug_info, not stripped

Christophe
