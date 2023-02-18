Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 11E7E69B77E
	for <lists+netdev@lfdr.de>; Sat, 18 Feb 2023 02:30:56 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229734AbjBRBaw (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 17 Feb 2023 20:30:52 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:40332 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229463AbjBRBav (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 17 Feb 2023 20:30:51 -0500
Received: from szxga01-in.huawei.com (szxga01-in.huawei.com [45.249.212.187])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 89C3C5A3B4;
        Fri, 17 Feb 2023 17:30:48 -0800 (PST)
Received: from kwepemi500020.china.huawei.com (unknown [172.30.72.54])
        by szxga01-in.huawei.com (SkyGuard) with ESMTP id 4PJWKJ6L6rznW8X;
        Sat, 18 Feb 2023 09:28:20 +0800 (CST)
Received: from [10.67.109.184] (10.67.109.184) by
 kwepemi500020.china.huawei.com (7.221.188.8) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2507.17; Sat, 18 Feb 2023 09:30:44 +0800
Message-ID: <3c9d2ff9-46b3-1587-e0c0-e3931118fb01@huawei.com>
Date:   Sat, 18 Feb 2023 09:30:44 +0800
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (Windows NT 10.0; Win64; x64; rv:102.0) Gecko/20100101
 Thunderbird/102.3.0
Subject: Re: [PATCH bpf-next v1 0/4] Support bpf trampoline for RV64
Content-Language: en-US
To:     Daniel Borkmann <daniel@iogearbox.net>,
        =?UTF-8?B?QmrDtnJuIFTDtnBlbA==?= <bjorn@kernel.org>,
        Pu Lehui <pulehui@huaweicloud.com>, <bpf@vger.kernel.org>,
        <linux-riscv@lists.infradead.org>, <netdev@vger.kernel.org>,
        <linux-kernel@vger.kernel.org>
CC:     Alexei Starovoitov <ast@kernel.org>,
        Andrii Nakryiko <andrii@kernel.org>,
        Martin KaFai Lau <martin.lau@linux.dev>,
        Song Liu <song@kernel.org>, Yonghong Song <yhs@fb.com>,
        John Fastabend <john.fastabend@gmail.com>,
        KP Singh <kpsingh@kernel.org>,
        Stanislav Fomichev <sdf@google.com>,
        Hao Luo <haoluo@google.com>, Jiri Olsa <jolsa@kernel.org>,
        Palmer Dabbelt <palmer@dabbelt.com>,
        Conor Dooley <conor.dooley@microchip.com>,
        Guo Ren <guoren@kernel.org>,
        Luke Nelson <luke.r.nels@gmail.com>,
        Xi Wang <xi.wang@gmail.com>
References: <20230215135205.1411105-1-pulehui@huaweicloud.com>
 <8735763pcu.fsf@all.your.base.are.belong.to.us>
 <091287c6-5121-58e5-b1b2-76277d2f1b1a@iogearbox.net>
From:   Pu Lehui <pulehui@huawei.com>
In-Reply-To: <091287c6-5121-58e5-b1b2-76277d2f1b1a@iogearbox.net>
Content-Type: text/plain; charset="UTF-8"; format=flowed
Content-Transfer-Encoding: 8bit
X-Originating-IP: [10.67.109.184]
X-ClientProxiedBy: dggems706-chm.china.huawei.com (10.3.19.183) To
 kwepemi500020.china.huawei.com (7.221.188.8)
X-CFilter-Loop: Reflected
X-Spam-Status: No, score=-4.5 required=5.0 tests=BAYES_00,NICE_REPLY_A,
        RCVD_IN_DNSWL_MED,SPF_HELO_NONE,SPF_PASS autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org



On 2023/2/18 4:49, Daniel Borkmann wrote:
> On 2/16/23 10:56 AM, Björn Töpel wrote:
>> Pu Lehui <pulehui@huaweicloud.com> writes:
>>
>>> BPF trampoline is the critical infrastructure of the bpf
>>> subsystem, acting as a mediator between kernel functions
>>> and BPF programs. Numerous important features, such as
>>> using ebpf program for zero overhead kernel introspection,
>>> rely on this key component. We can't wait to support bpf
>>> trampoline on RV64. Since RV64 does not support ftrace
>>> direct call yet, the current RV64 bpf trampoline is only
>>> used in bpf context.
>>>
>>> As most of riscv cpu support unaligned memory accesses,
>>> we temporarily use patch [1] to facilitate testing. The
>>> test results are as follow, and test_verifier with no
>>> new failure ceses.
>>>
>>> - fexit_bpf2bpf:OK
>>> - dummy_st_ops:OK
>>> - xdp_bpf2bpf:OK
>>>
>>> [1] 
>>> https://lore.kernel.org/linux-riscv/20210916130855.4054926-2-chenhuang5@huawei.com/
>>>
>>> v1:
>>> - Remove the logic of bpf_arch_text_poke supported for
>>>    kernel functions. (Kuohai and Björn)
>>> - Extend patch_text for multiple instructions. (Björn)
>>> - Fix OOB issue when image too big. (Björn)
>>
>> This series is ready to go in as is.
> 
> Ok.
> 
>> @Palmer I'd like to take this series via the bpf-next tree (as usual),
>> but note that there are some non-BPF changes as well, related to text
>> poking.
>>
>> @Lehui I'd like to see two follow-up patches:
>>
>> 1. Enable kfunc for RV64, by adding:
>>   | bool bpf_jit_supports_kfunc_call(void)
>>   | {
>>   |         return true;
>>   | }
>>
>> 2. Remove the checkpatch warning on patch 4:
>>   | WARNING: kfree(NULL) is safe and this check is probably not required
>>   | #313: FILE: arch/riscv/net/bpf_jit_comp64.c:984:
>>   | +    if (branches_off)
>>   | +        kfree(branches_off);
>>
>>
>> For the series:
>>
>> Tested-by: Björn Töpel <bjorn@rivosinc.com>
>> Acked-by: Björn Töpel <bjorn@rivosinc.com>
> 
> Thanks, I fixed up issue 2 and cleaned up the commit msgs while applying.
> For issue 1, pls send a follow-up.

Thank you both, will handle this.
