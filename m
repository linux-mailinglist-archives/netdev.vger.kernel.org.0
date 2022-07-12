Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id F11BE571890
	for <lists+netdev@lfdr.de>; Tue, 12 Jul 2022 13:32:18 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230123AbiGLLcG (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 12 Jul 2022 07:32:06 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:45704 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230004AbiGLLcE (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 12 Jul 2022 07:32:04 -0400
Received: from szxga03-in.huawei.com (szxga03-in.huawei.com [45.249.212.189])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 10F8620F61;
        Tue, 12 Jul 2022 04:32:03 -0700 (PDT)
Received: from dggpemm500024.china.huawei.com (unknown [172.30.72.53])
        by szxga03-in.huawei.com (SkyGuard) with ESMTP id 4Lhz8p39RLzFpxp;
        Tue, 12 Jul 2022 19:31:06 +0800 (CST)
Received: from dggpemm500019.china.huawei.com (7.185.36.180) by
 dggpemm500024.china.huawei.com (7.185.36.203) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2375.24; Tue, 12 Jul 2022 19:32:00 +0800
Received: from [10.67.109.184] (10.67.109.184) by
 dggpemm500019.china.huawei.com (7.185.36.180) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2375.24; Tue, 12 Jul 2022 19:32:00 +0800
Subject: Re: [PATCH bpf-next 1/3] samples: bpf: Fix cross-compiling error by
 using bootstrap bpftool
To:     Quentin Monnet <quentin@isovalent.com>, <bpf@vger.kernel.org>,
        <netdev@vger.kernel.org>, <linux-kernel@vger.kernel.org>
CC:     Alexei Starovoitov <ast@kernel.org>,
        Daniel Borkmann <daniel@iogearbox.net>,
        Andrii Nakryiko <andrii@kernel.org>,
        Martin KaFai Lau <kafai@fb.com>,
        Song Liu <songliubraving@fb.com>, Yonghong Song <yhs@fb.com>,
        John Fastabend <john.fastabend@gmail.com>,
        KP Singh <kpsingh@kernel.org>,
        Jean-Philippe Brucker <jean-philippe@linaro.org>
References: <20220712030813.865410-1-pulehui@huawei.com>
 <20220712030813.865410-2-pulehui@huawei.com>
 <e1dd40cd-647c-10b4-53f9-a313e509474e@isovalent.com>
From:   Pu Lehui <pulehui@huawei.com>
Message-ID: <0c8f6067-0d5b-c1f7-2048-0ed4add76e73@huawei.com>
Date:   Tue, 12 Jul 2022 19:32:00 +0800
User-Agent: Mozilla/5.0 (Windows NT 10.0; Win64; x64; rv:78.0) Gecko/20100101
 Thunderbird/78.8.1
MIME-Version: 1.0
In-Reply-To: <e1dd40cd-647c-10b4-53f9-a313e509474e@isovalent.com>
Content-Type: text/plain; charset="utf-8"; format=flowed
Content-Language: en-US
Content-Transfer-Encoding: 7bit
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



On 2022/7/12 18:11, Quentin Monnet wrote:
> On 12/07/2022 04:08, Pu Lehui wrote:
>> Currently, when cross compiling bpf samples, the host side cannot
>> use arch-specific bpftool to generate vmlinux.h or skeleton. Since
>> samples/bpf use bpftool for vmlinux.h, skeleton, and static linking
>> only, we can use lightweight bootstrap version of bpftool to handle
>> these, and it's always host-native.
>>
>> Signed-off-by: Pu Lehui <pulehui@huawei.com>
>> Suggested-by: Andrii Nakryiko <andrii@kernel.org>
>> ---
>>   samples/bpf/Makefile | 16 +++++++++++-----
>>   1 file changed, 11 insertions(+), 5 deletions(-)
>>
>> diff --git a/samples/bpf/Makefile b/samples/bpf/Makefile
>> index 5002a5b9a7da..57012b8259d2 100644
>> --- a/samples/bpf/Makefile
>> +++ b/samples/bpf/Makefile
>> @@ -282,12 +282,18 @@ $(LIBBPF): $(wildcard $(LIBBPF_SRC)/*.[ch] $(LIBBPF_SRC)/Makefile) | $(LIBBPF_OU
>>   
>>   BPFTOOLDIR := $(TOOLS_PATH)/bpf/bpftool
>>   BPFTOOL_OUTPUT := $(abspath $(BPF_SAMPLES_PATH))/bpftool
>> -BPFTOOL := $(BPFTOOL_OUTPUT)/bpftool
>> +BPFTOOL := $(BPFTOOL_OUTPUT)/bootstrap/bpftool
>> +ifeq ($(CROSS_COMPILE),)
>>   $(BPFTOOL): $(LIBBPF) $(wildcard $(BPFTOOLDIR)/*.[ch] $(BPFTOOLDIR)/Makefile) | $(BPFTOOL_OUTPUT)
>> -	    $(MAKE) -C $(BPFTOOLDIR) srctree=$(BPF_SAMPLES_PATH)/../../ \
>> -		OUTPUT=$(BPFTOOL_OUTPUT)/ \
>> -		LIBBPF_OUTPUT=$(LIBBPF_OUTPUT)/ \
>> -		LIBBPF_DESTDIR=$(LIBBPF_DESTDIR)/
>> +	$(MAKE) -C $(BPFTOOLDIR) srctree=$(BPF_SAMPLES_PATH)/../../		\
>> +		OUTPUT=$(BPFTOOL_OUTPUT)/ 					\
>> +		LIBBPF_BOOTSTRAP_OUTPUT=$(LIBBPF_OUTPUT)/ 			\
>> +		LIBBPF_BOOTSTRAP_DESTDIR=$(LIBBPF_DESTDIR)/ bootstrap
>> +else
>> +$(BPFTOOL): $(wildcard $(BPFTOOLDIR)/*.[ch] $(BPFTOOLDIR)/Makefile) | $(BPFTOOL_OUTPUT)
> 
> Thanks for this! Just trying to fully understand the details here. When
> cross-compiling, you leave aside the dependency on target-arch-libbpf,
> so that "make -C <bpftool-dir> bootstrap" rebuilds its own host-arch
> libbpf, is this correct?
> 

You're right. libbpf may does get out-of-sync. So the best way is to 
compile both arch-specific libbpf simultaneously, and then attach to 
bpftool. But it will make this job more complicated. Could we just add 
back $(LIBBPF) to handle this?

>> +	$(MAKE) -C $(BPFTOOLDIR) srctree=$(BPF_SAMPLES_PATH)/../../ 		\
>> +		OUTPUT=$(BPFTOOL_OUTPUT)/ bootstrap
>> +endif
>>   
>>   $(LIBBPF_OUTPUT) $(BPFTOOL_OUTPUT):
>>   	$(call msg,MKDIR,$@)
> 
> .
> 
