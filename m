Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id BFACF116FB6
	for <lists+netdev@lfdr.de>; Mon,  9 Dec 2019 15:55:06 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726491AbfLIOzF (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 9 Dec 2019 09:55:05 -0500
Received: from www62.your-server.de ([213.133.104.62]:39266 "EHLO
        www62.your-server.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1725956AbfLIOzF (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 9 Dec 2019 09:55:05 -0500
Received: from sslproxy06.your-server.de ([78.46.172.3])
        by www62.your-server.de with esmtpsa (TLSv1.2:DHE-RSA-AES256-GCM-SHA384:256)
        (Exim 4.89_1)
        (envelope-from <daniel@iogearbox.net>)
        id 1ieKRA-0002jz-Lg; Mon, 09 Dec 2019 15:55:00 +0100
Received: from [2001:1620:665:0:5795:5b0a:e5d5:5944] (helo=linux.fritz.box)
        by sslproxy06.your-server.de with esmtpsa (TLSv1.2:ECDHE-RSA-AES256-GCM-SHA384:256)
        (Exim 4.89)
        (envelope-from <daniel@iogearbox.net>)
        id 1ieKRA-000RWo-CU; Mon, 09 Dec 2019 15:55:00 +0100
Subject: Re: [PATCH bpf-next] bpf, x86, arm64: enable jit by default when not
 built as always-on
To:     Will Deacon <will@kernel.org>
Cc:     ast@kernel.org, netdev@vger.kernel.org, bpf@vger.kernel.org
References: <b869ada979120dbb3463bdb363f6ab463aa38086.1575899698.git.daniel@iogearbox.net>
 <20191209143436.GC4401@willie-the-truck>
From:   Daniel Borkmann <daniel@iogearbox.net>
Message-ID: <e2628911-8ef3-d8ee-7fbd-c51247156390@iogearbox.net>
Date:   Mon, 9 Dec 2019 15:54:59 +0100
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:60.0) Gecko/20100101
 Thunderbird/60.7.2
MIME-Version: 1.0
In-Reply-To: <20191209143436.GC4401@willie-the-truck>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Language: en-US
Content-Transfer-Encoding: 7bit
X-Authenticated-Sender: daniel@iogearbox.net
X-Virus-Scanned: Clear (ClamAV 0.101.4/25658/Mon Dec  9 10:47:26 2019)
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On 12/9/19 3:34 PM, Will Deacon wrote:
> On Mon, Dec 09, 2019 at 03:04:42PM +0100, Daniel Borkmann wrote:
>> After Spectre 2 fix via 290af86629b2 ("bpf: introduce BPF_JIT_ALWAYS_ON
>> config") most major distros use BPF_JIT_ALWAYS_ON configuration these days
>> which compiles out the BPF interpreter entirely and always enables the
>> JIT. Also given recent fix in e1608f3fa857 ("bpf: Avoid setting bpf insns
>> pages read-only when prog is jited"), we additionally avoid fragmenting
>> the direct map for the BPF insns pages sitting in the general data heap
>> since they are not used during execution. Latter is only needed when run
>> through the interpreter.
>>
>> Since both x86 and arm64 JITs have seen a lot of exposure over the years,
>> are generally most up to date and maintained, there is more downside in
>> !BPF_JIT_ALWAYS_ON configurations to have the interpreter enabled by default
>> rather than the JIT. Add a ARCH_WANT_DEFAULT_BPF_JIT config which archs can
>> use to set the bpf_jit_{enable,kallsyms} to 1. Back in the days the
>> bpf_jit_kallsyms knob was set to 0 by default since major distros still
>> had /proc/kallsyms addresses exposed to unprivileged user space which is
>> not the case anymore. Hence both knobs are set via BPF_JIT_DEFAULT_ON which
>> is set to 'y' in case of BPF_JIT_ALWAYS_ON or ARCH_WANT_DEFAULT_BPF_JIT.
>>
>> Signed-off-by: Daniel Borkmann <daniel@iogearbox.net>
>> ---
>>   [ Follow-up from https://lore.kernel.org/bpf/20191202200947.GA14353@pc-9.home/,
>>     applies to both bpf and bpf-next, but I think going via bpf-next is more
>>     appropriate. ]
>>
>>   arch/arm64/Kconfig | 1 +
>>   arch/x86/Kconfig   | 1 +
>>   init/Kconfig       | 6 ++++++
>>   kernel/bpf/core.c  | 4 ++--
>>   4 files changed, 10 insertions(+), 2 deletions(-)
>>
>> diff --git a/arch/arm64/Kconfig b/arch/arm64/Kconfig
>> index b1b4476ddb83..29d03459de20 100644
>> --- a/arch/arm64/Kconfig
>> +++ b/arch/arm64/Kconfig
>> @@ -69,6 +69,7 @@ config ARM64
>>   	select ARCH_SUPPORTS_INT128 if CC_HAS_INT128 && (GCC_VERSION >= 50000 || CC_IS_CLANG)
>>   	select ARCH_SUPPORTS_NUMA_BALANCING
>>   	select ARCH_WANT_COMPAT_IPC_PARSE_VERSION if COMPAT
>> +	select ARCH_WANT_DEFAULT_BPF_JIT
>>   	select ARCH_WANT_DEFAULT_TOPDOWN_MMAP_LAYOUT
>>   	select ARCH_WANT_FRAME_POINTERS
>>   	select ARCH_WANT_HUGE_PMD_SHARE if ARM64_4K_PAGES || (ARM64_16K_PAGES && !ARM64_VA_BITS_36)
>> diff --git a/arch/x86/Kconfig b/arch/x86/Kconfig
>> index 5e8949953660..1f6a0388a65f 100644
>> --- a/arch/x86/Kconfig
>> +++ b/arch/x86/Kconfig
>> @@ -93,6 +93,7 @@ config X86
>>   	select ARCH_USE_QUEUED_RWLOCKS
>>   	select ARCH_USE_QUEUED_SPINLOCKS
>>   	select ARCH_WANT_BATCHED_UNMAP_TLB_FLUSH
>> +	select ARCH_WANT_DEFAULT_BPF_JIT	if X86_64
>>   	select ARCH_WANTS_DYNAMIC_TASK_STRUCT
>>   	select ARCH_WANT_HUGE_PMD_SHARE
>>   	select ARCH_WANTS_THP_SWAP		if X86_64
>> diff --git a/init/Kconfig b/init/Kconfig
>> index a34064a031a5..957a5e758e6d 100644
>> --- a/init/Kconfig
>> +++ b/init/Kconfig
>> @@ -1604,6 +1604,9 @@ config BPF_SYSCALL
>>   	  Enable the bpf() system call that allows to manipulate eBPF
>>   	  programs and maps via file descriptors.
>>   
>> +config ARCH_WANT_DEFAULT_BPF_JIT
>> +	bool
>> +
>>   config BPF_JIT_ALWAYS_ON
>>   	bool "Permanently enable BPF JIT and remove BPF interpreter"
>>   	depends on BPF_SYSCALL && HAVE_EBPF_JIT && BPF_JIT
>> @@ -1611,6 +1614,9 @@ config BPF_JIT_ALWAYS_ON
>>   	  Enables BPF JIT and removes BPF interpreter to avoid
>>   	  speculative execution of BPF instructions by the interpreter
>>   
>> +config BPF_JIT_DEFAULT_ON
>> +	def_bool ARCH_WANT_DEFAULT_BPF_JIT || BPF_JIT_ALWAYS_ON
>> +
> 
> Seems a bit weird to me that this doesn't end up depending on
> CONFIG_BPF_JIT, but for the general idea:

True, not used outside of it, but it does makes sense. I'll add the depends
on for the BPF_JIT_DEFAULT_ON.

> Acked-by: Will Deacon <will@kernel.org>

Thanks,
Daniel
