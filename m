Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id ED100574124
	for <lists+netdev@lfdr.de>; Thu, 14 Jul 2022 04:02:46 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230074AbiGNCCp (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 13 Jul 2022 22:02:45 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:48902 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229468AbiGNCCo (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 13 Jul 2022 22:02:44 -0400
Received: from szxga01-in.huawei.com (szxga01-in.huawei.com [45.249.212.187])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 47B5618B36;
        Wed, 13 Jul 2022 19:02:43 -0700 (PDT)
Received: from dggpemm500022.china.huawei.com (unknown [172.30.72.53])
        by szxga01-in.huawei.com (SkyGuard) with ESMTP id 4LjyQ96qQszlW2F;
        Thu, 14 Jul 2022 10:01:05 +0800 (CST)
Received: from dggpemm500019.china.huawei.com (7.185.36.180) by
 dggpemm500022.china.huawei.com (7.185.36.162) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2375.24; Thu, 14 Jul 2022 10:02:07 +0800
Received: from [10.67.109.184] (10.67.109.184) by
 dggpemm500019.china.huawei.com (7.185.36.180) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2375.24; Thu, 14 Jul 2022 10:02:01 +0800
Subject: Re: [PATCH bpf-next 2/3] tools: runqslower: build and use lightweight
 bootstrap version of bpftool
To:     Andrii Nakryiko <andrii.nakryiko@gmail.com>
CC:     bpf <bpf@vger.kernel.org>, Networking <netdev@vger.kernel.org>,
        open list <linux-kernel@vger.kernel.org>,
        Alexei Starovoitov <ast@kernel.org>,
        "Daniel Borkmann" <daniel@iogearbox.net>,
        Andrii Nakryiko <andrii@kernel.org>,
        "Quentin Monnet" <quentin@isovalent.com>,
        Martin KaFai Lau <kafai@fb.com>,
        Song Liu <songliubraving@fb.com>, Yonghong Song <yhs@fb.com>,
        John Fastabend <john.fastabend@gmail.com>,
        KP Singh <kpsingh@kernel.org>,
        "Jean-Philippe Brucker" <jean-philippe@linaro.org>
References: <20220712030813.865410-1-pulehui@huawei.com>
 <20220712030813.865410-3-pulehui@huawei.com>
 <CAEf4BzYQM0RpsgUZgZpcMuDRSD2o96HzWzSeU5=GC0YfmjiXug@mail.gmail.com>
From:   Pu Lehui <pulehui@huawei.com>
Message-ID: <02f6f676-c6a9-9bac-19f1-a8fb0d236059@huawei.com>
Date:   Thu, 14 Jul 2022 10:02:01 +0800
User-Agent: Mozilla/5.0 (Windows NT 10.0; Win64; x64; rv:78.0) Gecko/20100101
 Thunderbird/78.8.1
MIME-Version: 1.0
In-Reply-To: <CAEf4BzYQM0RpsgUZgZpcMuDRSD2o96HzWzSeU5=GC0YfmjiXug@mail.gmail.com>
Content-Type: text/plain; charset="utf-8"; format=flowed
Content-Language: en-US
Content-Transfer-Encoding: 7bit
X-Originating-IP: [10.67.109.184]
X-ClientProxiedBy: dggems706-chm.china.huawei.com (10.3.19.183) To
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



On 2022/7/14 2:52, Andrii Nakryiko wrote:
> On Mon, Jul 11, 2022 at 7:37 PM Pu Lehui <pulehui@huawei.com> wrote:
>>
>> tools/runqslower use bpftool for vmlinux.h, skeleton, and static linking
>> only. So we can use lightweight bootstrap version of bpftool to handle
>> these, and it will be faster.
>>
>> Signed-off-by: Pu Lehui <pulehui@huawei.com>
>> Suggested-by: Andrii Nakryiko <andrii@kernel.org>
>> ---
>>   tools/bpf/runqslower/Makefile | 10 ++++++++--
>>   1 file changed, 8 insertions(+), 2 deletions(-)
>>
>> diff --git a/tools/bpf/runqslower/Makefile b/tools/bpf/runqslower/Makefile
>> index da6de16a3dfb..8900c74f29e2 100644
>> --- a/tools/bpf/runqslower/Makefile
>> +++ b/tools/bpf/runqslower/Makefile
>> @@ -4,7 +4,7 @@ include ../../scripts/Makefile.include
>>   OUTPUT ?= $(abspath .output)/
>>
>>   BPFTOOL_OUTPUT := $(OUTPUT)bpftool/
>> -DEFAULT_BPFTOOL := $(BPFTOOL_OUTPUT)bpftool
>> +DEFAULT_BPFTOOL := $(BPFTOOL_OUTPUT)bootstrap/bpftool
>>   BPFTOOL ?= $(DEFAULT_BPFTOOL)
>>   LIBBPF_SRC := $(abspath ../../lib/bpf)
>>   BPFOBJ_OUTPUT := $(OUTPUT)libbpf/
>> @@ -86,6 +86,12 @@ $(BPFOBJ): $(wildcard $(LIBBPF_SRC)/*.[ch] $(LIBBPF_SRC)/Makefile) | $(BPFOBJ_OU
>>          $(Q)$(MAKE) $(submake_extras) -C $(LIBBPF_SRC) OUTPUT=$(BPFOBJ_OUTPUT) \
>>                      DESTDIR=$(BPFOBJ_OUTPUT) prefix= $(abspath $@) install_headers
>>
>> +ifeq ($(CROSS_COMPILE),)
>>   $(DEFAULT_BPFTOOL): $(BPFOBJ) | $(BPFTOOL_OUTPUT)
>>          $(Q)$(MAKE) $(submake_extras) -C ../bpftool OUTPUT=$(BPFTOOL_OUTPUT)   \
>> -                   ARCH= CROSS_COMPILE= CC=$(HOSTCC) LD=$(HOSTLD)
>> +                   LIBBPF_BOOTSTRAP_OUTPUT=$(BPFOBJ_OUTPUT)                   \
>> +                   LIBBPF_BOOTSTRAP_DESTDIR=$(BPF_DESTDIR) bootstrap
>> +else
>> +$(DEFAULT_BPFTOOL): | $(BPFTOOL_OUTPUT)
>> +       $(Q)$(MAKE) $(submake_extras) -C ../bpftool OUTPUT=$(BPFTOOL_OUTPUT) bootstrap
>> +endif
> 
> Same comment as on the other patch, this CROSS_COMPILE if/else seems a
> bit fragile, let's keep only the second cleaner part, maybe?
> 

I will make it simple.

> 
>> --
>> 2.25.1
>>
> .
> 
