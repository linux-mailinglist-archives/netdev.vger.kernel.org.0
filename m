Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 05DA747EAB5
	for <lists+netdev@lfdr.de>; Fri, 24 Dec 2021 03:58:00 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1351049AbhLXC56 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 23 Dec 2021 21:57:58 -0500
Received: from szxga02-in.huawei.com ([45.249.212.188]:16856 "EHLO
        szxga02-in.huawei.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231928AbhLXC54 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 23 Dec 2021 21:57:56 -0500
Received: from dggpemm500023.china.huawei.com (unknown [172.30.72.57])
        by szxga02-in.huawei.com (SkyGuard) with ESMTP id 4JKsCx2Vssz91sc;
        Fri, 24 Dec 2021 10:57:01 +0800 (CST)
Received: from dggpemm500019.china.huawei.com (7.185.36.180) by
 dggpemm500023.china.huawei.com (7.185.36.83) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2308.20; Fri, 24 Dec 2021 10:57:52 +0800
Received: from [10.67.109.184] (10.67.109.184) by
 dggpemm500019.china.huawei.com (7.185.36.180) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2308.20; Fri, 24 Dec 2021 10:57:52 +0800
Subject: Re: [PATCH bpf-next v2] selftests/bpf: Fix cross compiling error when
 using userspace pt_regs
To:     Andrii Nakryiko <andrii.nakryiko@gmail.com>
CC:     "open list:KERNEL SELFTEST FRAMEWORK" 
        <linux-kselftest@vger.kernel.org>,
        Networking <netdev@vger.kernel.org>, bpf <bpf@vger.kernel.org>,
        open list <linux-kernel@vger.kernel.org>
References: <20211223052007.4111674-1-pulehui@huawei.com>
 <CAEf4BzY29kWicH0fdh9NnYu4nn1E4odL2ES2EYTGkyvHbo2c4g@mail.gmail.com>
From:   Pu Lehui <pulehui@huawei.com>
Message-ID: <6bf1e9cb-77c8-7bb8-c55d-bf85a09819cd@huawei.com>
Date:   Fri, 24 Dec 2021 10:57:52 +0800
User-Agent: Mozilla/5.0 (Windows NT 10.0; Win64; x64; rv:78.0) Gecko/20100101
 Thunderbird/78.8.1
MIME-Version: 1.0
In-Reply-To: <CAEf4BzY29kWicH0fdh9NnYu4nn1E4odL2ES2EYTGkyvHbo2c4g@mail.gmail.com>
Content-Type: text/plain; charset="utf-8"; format=flowed
Content-Language: en-US
Content-Transfer-Encoding: 7bit
X-Originating-IP: [10.67.109.184]
X-ClientProxiedBy: dggems704-chm.china.huawei.com (10.3.19.181) To
 dggpemm500019.china.huawei.com (7.185.36.180)
X-CFilter-Loop: Reflected
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org



On 2021/12/24 2:21, Andrii Nakryiko wrote:
> On Wed, Dec 22, 2021 at 8:56 PM Pu Lehui <pulehui@huawei.com> wrote:
>>
>> When cross compiling arm64 bpf selftests in x86_64 host, the following
>> error occur:
>>
>> progs/loop2.c:20:7: error: incomplete definition of type 'struct
>> user_pt_regs'
>>
>> Some archs, like arm64 and riscv, use userspace pt_regs in bpf_tracing.h.
>> When arm64 bpf selftests cross compiling in x86_64 host, clang cannot
>> find the arch specific uapi ptrace.h. We can add arch specific header
>> file directory to fix this issue.
>>
>> Signed-off-by: Pu Lehui <pulehui@huawei.com>
>> ---
>> v1->v2:
>> - use vmlinux.h directly might lead to verifier fail.
>> - use source arch header file directory suggested by Andrii Nakryiko.
>>
>>   tools/testing/selftests/bpf/Makefile | 4 +++-
>>   1 file changed, 3 insertions(+), 1 deletion(-)
>>
>> diff --git a/tools/testing/selftests/bpf/Makefile b/tools/testing/selftests/bpf/Makefile
>> index 42ffc24e9e71..1ecb6d192953 100644
>> --- a/tools/testing/selftests/bpf/Makefile
>> +++ b/tools/testing/selftests/bpf/Makefile
>> @@ -12,6 +12,7 @@ BPFDIR := $(LIBDIR)/bpf
>>   TOOLSINCDIR := $(TOOLSDIR)/include
>>   BPFTOOLDIR := $(TOOLSDIR)/bpf/bpftool
>>   APIDIR := $(TOOLSINCDIR)/uapi
>> +ARCH_APIDIR := $(abspath ../../../../arch/$(SRCARCH)/include/uapi)
>>   GENDIR := $(abspath ../../../../include/generated)
>>   GENHDR := $(GENDIR)/autoconf.h
>>
>> @@ -294,7 +295,8 @@ MENDIAN=$(if $(IS_LITTLE_ENDIAN),-mlittle-endian,-mbig-endian)
>>   CLANG_SYS_INCLUDES = $(call get_sys_includes,$(CLANG))
>>   BPF_CFLAGS = -g -D__TARGET_ARCH_$(SRCARCH) $(MENDIAN)                  \
>>               -I$(INCLUDE_DIR) -I$(CURDIR) -I$(APIDIR)                   \
>> -            -I$(abspath $(OUTPUT)/../usr/include)
>> +            -I$(abspath $(OUTPUT)/../usr/include)                      \
>> +            -I$(ARCH_APIDIR)
>>
> 
> This causes compilation error, see [0]. I think we'll have to wait for
> my patch ([1]) to land and then add kernel-side variants for accessing
> pt_regs.
> 
>    [0] https://github.com/kernel-patches/bpf/runs/4614606900?check_suite_focus=true
>    [1] https://patchwork.kernel.org/project/netdevbpf/patch/20211222213924.1869758-1-andrii@kernel.org/
> 
> 
OK, I'll keep follow it.
>>   CLANG_CFLAGS = $(CLANG_SYS_INCLUDES) \
>>                 -Wno-compare-distinct-pointer-types
>> --
>> 2.25.1
>>
> .
> 
