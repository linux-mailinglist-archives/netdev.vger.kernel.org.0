Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 91F5D502117
	for <lists+netdev@lfdr.de>; Fri, 15 Apr 2022 05:53:55 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1349286AbiDOD4U (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 14 Apr 2022 23:56:20 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:45732 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S242764AbiDOD4R (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 14 Apr 2022 23:56:17 -0400
Received: from szxga01-in.huawei.com (szxga01-in.huawei.com [45.249.212.187])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 656439F6D0;
        Thu, 14 Apr 2022 20:53:50 -0700 (PDT)
Received: from kwepemi500015.china.huawei.com (unknown [172.30.72.56])
        by szxga01-in.huawei.com (SkyGuard) with ESMTP id 4Kfj9154GvzfYsy;
        Fri, 15 Apr 2022 11:53:09 +0800 (CST)
Received: from kwepemm600003.china.huawei.com (7.193.23.202) by
 kwepemi500015.china.huawei.com (7.221.188.92) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2375.24; Fri, 15 Apr 2022 11:53:47 +0800
Received: from [10.67.111.205] (10.67.111.205) by
 kwepemm600003.china.huawei.com (7.193.23.202) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2375.24; Fri, 15 Apr 2022 11:53:47 +0800
Subject: Re: [PATCH] perf llvm: Fix compile bpf failed to cope with latest
 llvm
To:     Nick Desaulniers <ndesaulniers@google.com>
CC:     <peterz@infradead.org>, <mingo@redhat.com>, <acme@kernel.org>,
        <mark.rutland@arm.com>, <alexander.shishkin@linux.intel.com>,
        <jolsa@kernel.org>, <namhyung@kernel.org>, <ast@kernel.org>,
        <daniel@iogearbox.net>, <andrii@kernel.org>, <kafai@fb.com>,
        <songliubraving@fb.com>, <yhs@fb.com>, <john.fastabend@gmail.com>,
        <kpsingh@kernel.org>, <nathan@kernel.org>, <trix@redhat.com>,
        <ak@linux.intel.com>, <adrian.hunter@intel.com>,
        <james.clark@arm.com>, <linux-perf-users@vger.kernel.org>,
        <linux-kernel@vger.kernel.org>, <netdev@vger.kernel.org>,
        <bpf@vger.kernel.org>, <llvm@lists.linux.dev>
References: <20220414134134.247912-1-yangjihong1@huawei.com>
 <CAKwvOdmZCS784R5myuA=MgSnxQfS6sPUsBKbbax_QN1fSMNzbQ@mail.gmail.com>
From:   Yang Jihong <yangjihong1@huawei.com>
Message-ID: <6d7635be-e694-0132-e2b2-e6816c34aa72@huawei.com>
Date:   Fri, 15 Apr 2022 11:53:46 +0800
User-Agent: Mozilla/5.0 (Windows NT 10.0; Win64; x64; rv:78.0) Gecko/20100101
 Thunderbird/78.6.1
MIME-Version: 1.0
In-Reply-To: <CAKwvOdmZCS784R5myuA=MgSnxQfS6sPUsBKbbax_QN1fSMNzbQ@mail.gmail.com>
Content-Type: text/plain; charset="utf-8"; format=flowed
Content-Language: en-US
Content-Transfer-Encoding: 7bit
X-Originating-IP: [10.67.111.205]
X-ClientProxiedBy: dggems703-chm.china.huawei.com (10.3.19.180) To
 kwepemm600003.china.huawei.com (7.193.23.202)
X-CFilter-Loop: Reflected
X-Spam-Status: No, score=-6.7 required=5.0 tests=BAYES_00,NICE_REPLY_A,
        RCVD_IN_DNSWL_MED,RCVD_IN_MSPIKE_H5,RCVD_IN_MSPIKE_WL,SPF_HELO_NONE,
        SPF_PASS,T_SCC_BODY_TEXT_LINE autolearn=ham autolearn_force=no
        version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On 2022/4/14 23:57, Nick Desaulniers wrote:
> On Thu, Apr 14, 2022 at 6:42 AM Yang Jihong <yangjihong1@huawei.com> wrote:
>>
>> Inline assembly used by asm/sysreg.h is incompatible with latest llvm,
> 
> With "latest" llvm makes it sound like LLVM has regressed. Has it? Or
> have the headers changed in a way where now inline asm from a
> different target (x86) than what's being targeted (BPF)? Perhaps
> fixing that is simpler?
> 
> Clang will validate inline asm before LLVM drops unreferenced static
> inline functions; this was a headache getting i386 building with
> clang, but not insurmountable.
> 
According to the notes of samples/bpf/Makefile:
"The reason is due to llvm change https://reviews.llvm.org/D87153
where the CORE relocation global generation is moved from the beginning
of target dependent optimization (llc) to the beginning
of target independent optimization (opt).

Since samples/bpf programs did not use vmlinux.h and its clang compilation
uses native architecture, we need to adjust arch triple at opt level
to do CORE relocation global generation properly. Otherwise, the above
error will appear."
I think opt and llvm-dis are introduced to solve another problem, that 
is, the incompatibility of native architecture.

>> If bpf C program include "linux/ptrace.h" (which is common), compile will fail:
>>
>>   # perf --debug verbose record -e bpf-output/no-inherit,name=evt/ \
>>                                -e ./perf_bpf_test.c/map:channel.event=evt/ ls
>>   [SNIP]
>>   /lib/modules/5.17/build/./arch/x86/include/asm/arch_hweight.h:20:7: error: invalid output constraint '=a' in asm
>>                            : "="REG_OUT (res)
>>                             ^
>>   /lib/modules/5.17/build/./arch/x86/include/asm/arch_hweight.h:48:7: error: invalid output constraint '=a' in asm
>>                            : "="REG_OUT (res)
>>                             ^
>>   In file included from /root/projects/perf-bpf/perf_bpf_test.c:2:
>>   In file included from /lib/modules/5.17/build/./include/linux/ptrace.h:6:
>>   In file included from /lib/modules/5.17/build/./include/linux/sched.h:12:
>>   In file included from /lib/modules/5.17/build/./arch/x86/include/asm/current.h:6:
>>   In file included from /lib/modules/5.17/build/./arch/x86/include/asm/percpu.h:27:
>>   In file included from /lib/modules/5.17/build/./include/linux/kernel.h:25:
>>   In file included from /lib/modules/5.17/build/./include/linux/math.h:6:
>>   /lib/modules/5.17.0/build/./arch/x86/include/asm/div64.h:85:28: error: invalid output constraint '=a' in asm
>>           asm ("mulq %2; divq %3" : "=a" (q)
>>   [SNIP]
>>   # cat /root/projects/perf-bpf/perf_bpf_test.c
>>   /************************ BEGIN **************************/
>>   #include <uapi/linux/bpf.h>
>>   #include <linux/ptrace.h>
>>   #include <linux/types.h>
>>   #define SEC(NAME) __attribute__((section(NAME), used))
>>
>>   struct bpf_map_def {
>>           unsigned int type;
>>           unsigned int key_size;
>>           unsigned int value_size;
>>           unsigned int max_entries;
>>   };
>>
>>   static int (*perf_event_output)(void *, struct bpf_map_def *, int, void *,
>>       unsigned long) = (void *)BPF_FUNC_perf_event_output;
>>
>>   struct bpf_map_def SEC("maps") channel = {
>>           .type = BPF_MAP_TYPE_PERF_EVENT_ARRAY,
>>           .key_size = sizeof(int),
>>           .value_size = sizeof(__u32),
>>           .max_entries = __NR_CPUS__,
>>   };
>>
>>   #define MIN_BYTES 1024
>>
>>   SEC("func=vfs_read")
>>   int bpf_myprog(struct pt_regs *ctx)
>>   {
>>           long bytes = ctx->dx;
>>           if (bytes >= MIN_BYTES) {
>>                   perf_event_output(ctx, &channel, BPF_F_CURRENT_CPU,
>>                                     &bytes, sizeof(bytes));
>>           }
>>
>>           return 0;
>>   }
>>
>> char _license[] SEC("license") = "GPL";
>> int _version SEC("version") = LINUX_VERSION_CODE;
>> /************************* END ***************************/
>>
>> Compilation command is modified to be the same as that in samples/bpf/Makefile,
>> use clang | opt | llvm-dis | llc chain of commands to solve the problem.
>> see the comment in samples/bpf/Makefile.
>>
>> Modifications:
>> 1. Change "clang --target bpf" to chain of commands "clang | opt | llvm-dis | llc"
> 
> This will drop the --target flag. That will mess up the default target
> triple, and can affect command line option feature detection.
> 
opt add -mtriple=bpf-pc-linux flag,
The complete command is as follows:
clang -O2 -emit-llvm -Xclang -disable-llvm-passes -c $< -o - |
opt -O2 -mtriple=bpf-pc-linux | $(LLVM_DIS) | \
llc -march=bpf $(LLC_FLAGS) -filetype=obj -o $@

This may be a problem. Currently, no simple method is found. Therefore, 
refer to the processing method of samles/bpf/Makefile.

-- 
Thanks,
Jihong

