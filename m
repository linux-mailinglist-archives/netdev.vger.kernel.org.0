Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 7190F4ACF21
	for <lists+netdev@lfdr.de>; Tue,  8 Feb 2022 03:47:35 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1345732AbiBHCrd (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 7 Feb 2022 21:47:33 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:37358 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229888AbiBHCrc (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 7 Feb 2022 21:47:32 -0500
Received: from szxga02-in.huawei.com (szxga02-in.huawei.com [45.249.212.188])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id A72F4C061355;
        Mon,  7 Feb 2022 18:47:31 -0800 (PST)
Received: from dggpeml500025.china.huawei.com (unknown [172.30.72.54])
        by szxga02-in.huawei.com (SkyGuard) with ESMTP id 4Jt6pY3zj2zYkdJ;
        Tue,  8 Feb 2022 10:46:29 +0800 (CST)
Received: from [10.174.176.117] (10.174.176.117) by
 dggpeml500025.china.huawei.com (7.185.36.35) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2308.21; Tue, 8 Feb 2022 10:47:29 +0800
Subject: Re: [PATCH bpf-next v4 2/2] selftests/bpf: check whether s32 is
 sufficient for kfunc offset
To:     Yonghong Song <yhs@fb.com>, Hou Tao <hotforest@gmail.com>,
        Daniel Borkmann <daniel@iogearbox.net>
CC:     Alexei Starovoitov <ast@kernel.org>,
        Martin KaFai Lau <kafai@fb.com>,
        Andrii Nakryiko <andrii@kernel.org>,
        "David S . Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>,
        John Fastabend <john.fastabend@gmail.com>,
        <netdev@vger.kernel.org>, <bpf@vger.kernel.org>
References: <20220206043107.18549-1-houtao1@huawei.com>
 <20220206043107.18549-3-houtao1@huawei.com>
 <585256c2-318f-3895-8175-e7d7cbe1cd4f@fb.com>
From:   Hou Tao <houtao1@huawei.com>
Message-ID: <c8ae6afe-d383-12b9-10df-57dc1da9b566@huawei.com>
Date:   Tue, 8 Feb 2022 10:47:28 +0800
User-Agent: Mozilla/5.0 (Windows NT 10.0; Win64; x64; rv:78.0) Gecko/20100101
 Thunderbird/78.6.0
MIME-Version: 1.0
In-Reply-To: <585256c2-318f-3895-8175-e7d7cbe1cd4f@fb.com>
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 8bit
Content-Language: en-US
X-Originating-IP: [10.174.176.117]
X-ClientProxiedBy: dggems704-chm.china.huawei.com (10.3.19.181) To
 dggpeml500025.china.huawei.com (7.185.36.35)
X-CFilter-Loop: Reflected
X-Spam-Status: No, score=-4.2 required=5.0 tests=BAYES_00,NICE_REPLY_A,
        RCVD_IN_DNSWL_MED,SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Hi,

On 2/8/2022 2:33 AM, Yonghong Song wrote:
>
>
> On 2/5/22 8:31 PM, Hou Tao wrote:
>> In add_kfunc_call(), bpf_kfunc_desc->imm with type s32 is used to
>> represent the offset of called kfunc from __bpf_call_base, so
>> add a test to ensure that the offset will not be overflowed.
>>
>> Signed-off-by: Hou Tao <houtao1@huawei.com>
>> ---
>>   .../selftests/bpf/prog_tests/ksyms_module.c   | 42 +++++++++++++++++++
>>   1 file changed, 42 insertions(+)
>>
[...]
>> +    /* Ensure kfunc call is supported */
>> +    skel = test_ksyms_module__open_and_load();
>> +    if (!ASSERT_OK_PTR(skel, "test_ksyms_module__open"))
>> +        return;
>> +
>> +    err = kallsyms_find("bpf_testmod_test_mod_kfunc", &kfunc_addr);
>> +    if (!ASSERT_OK(err, "find kfunc addr"))
>> +        goto cleanup;
>> +
>> +    err = kallsyms_find("__bpf_call_base", &base_addr);
>> +    if (!ASSERT_OK(err, "find base addr"))
>> +        goto cleanup;
>> +
>> +    used_offset = kfunc_addr - base_addr;
>> +    actual_offset = kfunc_addr - base_addr;
>> +    ASSERT_EQ((long long)used_offset, actual_offset, "kfunc offset
>> overflowed");
>
> I am a little bit confused about motivation here. Maybe I missed something. If
> we indeed have kfunc offset overflow,
> should kernel verifier just reject the program? Specially,
> we should make the above test_ksyms_module__open_and_load()
> fail?
In add_kfunc_call(), the calculation of imm doesn't consider the overflow
of s32. So test_ksyms_module__open_and_load() will succeed. I think the
better solution is to put the overflow check in add_kfunc_call(), so will
drop this patch and add the overflow check in add_kfunc_call() instead.

Regards,
Tao

[...]
