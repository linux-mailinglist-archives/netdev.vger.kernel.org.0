Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 0FDD456B0DC
	for <lists+netdev@lfdr.de>; Fri,  8 Jul 2022 05:42:30 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S237030AbiGHDMj (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 7 Jul 2022 23:12:39 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:48202 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S236180AbiGHDMi (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 7 Jul 2022 23:12:38 -0400
Received: from szxga03-in.huawei.com (szxga03-in.huawei.com [45.249.212.189])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 79FCA7393D;
        Thu,  7 Jul 2022 20:12:36 -0700 (PDT)
Received: from dggpemm500024.china.huawei.com (unknown [172.30.72.55])
        by szxga03-in.huawei.com (SkyGuard) with ESMTP id 4LfJGS4FtRzpW6X;
        Fri,  8 Jul 2022 11:11:44 +0800 (CST)
Received: from dggpemm500019.china.huawei.com (7.185.36.180) by
 dggpemm500024.china.huawei.com (7.185.36.203) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2375.24; Fri, 8 Jul 2022 11:12:34 +0800
Received: from [10.67.109.184] (10.67.109.184) by
 dggpemm500019.china.huawei.com (7.185.36.180) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2375.24; Fri, 8 Jul 2022 11:12:34 +0800
Subject: Re: [PATCH bpf-next] samples: bpf: Fix cross-compiling error about
 bpftool
From:   Pu Lehui <pulehui@huawei.com>
To:     Song Liu <songliubraving@fb.com>
CC:     bpf <bpf@vger.kernel.org>, Networking <netdev@vger.kernel.org>,
        lkml <linux-kernel@vger.kernel.org>,
        Alexei Starovoitov <ast@kernel.org>,
        "Daniel Borkmann" <daniel@iogearbox.net>,
        Andrii Nakryiko <andrii@kernel.org>,
        "Martin Lau" <kafai@fb.com>, Yonghong Song <yhs@fb.com>,
        John Fastabend <john.fastabend@gmail.com>,
        KP Singh <kpsingh@kernel.org>
References: <20220707140811.603590-1-pulehui@huawei.com>
 <FDFF5B78-F555-4C55-96D3-B7B3FAA8E84F@fb.com>
 <c357fa1a-5160-ed85-19bf-51f3c188d56e@huawei.com>
Message-ID: <d44f8faf-06df-6fdf-0adf-2abbdf9c9a49@huawei.com>
Date:   Fri, 8 Jul 2022 11:12:33 +0800
User-Agent: Mozilla/5.0 (Windows NT 10.0; Win64; x64; rv:78.0) Gecko/20100101
 Thunderbird/78.8.1
MIME-Version: 1.0
In-Reply-To: <c357fa1a-5160-ed85-19bf-51f3c188d56e@huawei.com>
Content-Type: text/plain; charset="utf-8"; format=flowed
Content-Language: en-US
Content-Transfer-Encoding: 8bit
X-Originating-IP: [10.67.109.184]
X-ClientProxiedBy: dggems703-chm.china.huawei.com (10.3.19.180) To
 dggpemm500019.china.huawei.com (7.185.36.180)
X-CFilter-Loop: Reflected
X-Spam-Status: No, score=-4.2 required=5.0 tests=BAYES_00,NICE_REPLY_A,
        RCVD_IN_DNSWL_MED,SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org



On 2022/7/8 10:46, Pu Lehui wrote:
> 
> 
> On 2022/7/8 3:12, Song Liu wrote:
>>
>>
>>> On Jul 7, 2022, at 7:08 AM, Pu Lehui <pulehui@huawei.com> wrote:
>>>
>>> Currently, when cross compiling bpf samples, the host side
>>> cannot use arch-specific bpftool to generate vmlinux.h or
>>> skeleton. We need to compile the bpftool with the host
>>> compiler.
>>>
>>> Signed-off-by: Pu Lehui <pulehui@huawei.com>
>>> ---
>>> samples/bpf/Makefile | 8 ++++----
>>> 1 file changed, 4 insertions(+), 4 deletions(-)
>>>
>>> diff --git a/samples/bpf/Makefile b/samples/bpf/Makefile
>>> index 5002a5b9a7da..fe54a8c8f312 100644
>>> --- a/samples/bpf/Makefile
>>> +++ b/samples/bpf/Makefile
>>> @@ -1,4 +1,5 @@
>>> # SPDX-License-Identifier: GPL-2.0
>>> +-include tools/scripts/Makefile.include
>>
>> Why do we need the -include here?
>>
> 
> HOSTLD is defined in tools/scripts/Makefile.include, we need to add it.
> 
> And for -include, mainly to resolve some conflicts:
> 1. If workdir is kernel_src, then 'include 
> tools/scripts/Makefile.include' is fine when 'make M=samples/bpf'.
> 2. Since the trick in samples/bpf/Makefile:
> 
> # Trick to allow make to be run from this directory
> all:
>      $(MAKE) -C ../../ M=$(CURDIR) BPF_SAMPLES_PATH=$(CURDIR)
> 
> If workdir is samples/bpf, the compile process will first load the 
> Makefile in samples/bpf, then change workdir to kernel_src and load the 
> kernel_src's Makefile. So if we just add 'include 
> tools/scripts/Makefile.include', then the first load will occur error 
> for not found the file, so we add -include to skip the first load.

sorry, correct the reply, so we add -include to skip the 
'tools/scripts/Makefile.include' file on the fisrt load.

> 
>> Thanks,
>> Song
>>
>>>
>>> BPF_SAMPLES_PATH ?= $(abspath $(srctree)/$(src))
>>> TOOLS_PATH := $(BPF_SAMPLES_PATH)/../../tools
>>> @@ -283,11 +284,10 @@ $(LIBBPF): $(wildcard $(LIBBPF_SRC)/*.[ch] 
>>> $(LIBBPF_SRC)/Makefile) | $(LIBBPF_OU
>>> BPFTOOLDIR := $(TOOLS_PATH)/bpf/bpftool
>>> BPFTOOL_OUTPUT := $(abspath $(BPF_SAMPLES_PATH))/bpftool
>>> BPFTOOL := $(BPFTOOL_OUTPUT)/bpftool
>>> -$(BPFTOOL): $(LIBBPF) $(wildcard $(BPFTOOLDIR)/*.[ch] 
>>> $(BPFTOOLDIR)/Makefile) | $(BPFTOOL_OUTPUT)
>>> +$(BPFTOOL): $(wildcard $(BPFTOOLDIR)/*.[ch] $(BPFTOOLDIR)/Makefile) 
>>> | $(BPFTOOL_OUTPUT)
>>>         $(MAKE) -C $(BPFTOOLDIR) srctree=$(BPF_SAMPLES_PATH)/../../ \
>>> -        OUTPUT=$(BPFTOOL_OUTPUT)/ \
>>> -        LIBBPF_OUTPUT=$(LIBBPF_OUTPUT)/ \
>>> -        LIBBPF_DESTDIR=$(LIBBPF_DESTDIR)/
>>> +        ARCH= CROSS_COMPILE= CC=$(HOSTCC) LD=$(HOSTLD) \
>>> +        OUTPUT=$(BPFTOOL_OUTPUT)/
>>>
>>> $(LIBBPF_OUTPUT) $(BPFTOOL_OUTPUT):
>>>     $(call msg,MKDIR,$@)
>>> -- 
>>> 2.25.1
>>>
>>
>> .
>>
> .
