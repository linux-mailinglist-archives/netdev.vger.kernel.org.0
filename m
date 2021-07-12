Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 5CF0B3C4146
	for <lists+netdev@lfdr.de>; Mon, 12 Jul 2021 04:42:23 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232454AbhGLCpG (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sun, 11 Jul 2021 22:45:06 -0400
Received: from szxga03-in.huawei.com ([45.249.212.189]:10353 "EHLO
        szxga03-in.huawei.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229818AbhGLCpF (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sun, 11 Jul 2021 22:45:05 -0400
Received: from dggeme751-chm.china.huawei.com (unknown [172.30.72.55])
        by szxga03-in.huawei.com (SkyGuard) with ESMTP id 4GNS3Y4bSdz78P9;
        Mon, 12 Jul 2021 10:13:13 +0800 (CST)
Received: from [10.67.110.55] (10.67.110.55) by dggeme751-chm.china.huawei.com
 (10.3.19.97) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_128_CBC_SHA256_P256) id 15.1.2176.2; Mon, 12
 Jul 2021 10:17:39 +0800
Subject: Re: [bpf-next 3/3] bpf: Fix a use after free in bpf_check()
To:     Alexei Starovoitov <alexei.starovoitov@gmail.com>
CC:     Song Liu <song@kernel.org>, Alexei Starovoitov <ast@kernel.org>,
        Daniel Borkmann <daniel@iogearbox.net>,
        Andrii Nakryiko <andrii@kernel.org>,
        Martin KaFai Lau <kafai@fb.com>,
        Song Liu <songliubraving@fb.com>, Yonghong Song <yhs@fb.com>,
        John Fastabend <john.fastabend@gmail.com>,
        KP Singh <kpsingh@kernel.org>,
        "David S . Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>,
        Networking <netdev@vger.kernel.org>, bpf <bpf@vger.kernel.org>,
        open list <linux-kernel@vger.kernel.org>
References: <20210707043811.5349-1-hefengqing@huawei.com>
 <20210707043811.5349-4-hefengqing@huawei.com>
 <CAPhsuW7ssFzvS5-kdZa3tY-2EJk8QUdVpQCJYVBr+vD11JzrsQ@mail.gmail.com>
 <1c5b393d-6848-3d10-30cf-7063a331f76c@huawei.com>
 <CAADnVQJ0Q0dLVs5UM-CyJe90N+KHomccAy-S_LOOARa9nXkXsA@mail.gmail.com>
 <bc75c9c5-7479-5021-58ea-ed8cf53fb331@huawei.com>
 <CAADnVQJ2DnoC07XLki_=xPti7V=wH153tQb1bowP+xdLwn580w@mail.gmail.com>
From:   He Fengqing <hefengqing@huawei.com>
Message-ID: <21d8cd9e-487e-411f-1cfd-67cebc86b221@huawei.com>
Date:   Mon, 12 Jul 2021 10:17:39 +0800
User-Agent: Mozilla/5.0 (Windows NT 10.0; Win64; x64; rv:78.0) Gecko/20100101
 Thunderbird/78.7.0
MIME-Version: 1.0
In-Reply-To: <CAADnVQJ2DnoC07XLki_=xPti7V=wH153tQb1bowP+xdLwn580w@mail.gmail.com>
Content-Type: text/plain; charset="utf-8"; format=flowed
Content-Transfer-Encoding: 8bit
X-Originating-IP: [10.67.110.55]
X-ClientProxiedBy: dggeme720-chm.china.huawei.com (10.1.199.116) To
 dggeme751-chm.china.huawei.com (10.3.19.97)
X-CFilter-Loop: Reflected
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org



在 2021/7/9 23:12, Alexei Starovoitov 写道:
> On Fri, Jul 9, 2021 at 4:11 AM He Fengqing <hefengqing@huawei.com> wrote:
>>
>>
>>
>> 在 2021/7/8 11:09, Alexei Starovoitov 写道:
>>> On Wed, Jul 7, 2021 at 8:00 PM He Fengqing <hefengqing@huawei.com> wrote:
>>>>
>>>> Ok, I will change this in next version.
>>>
>>> before you spam the list with the next version
>>> please explain why any of these changes are needed?
>>> I don't see an explanation in the patches and I don't see a bug in the code.
>>> Did you check what is the prog clone ?
>>> When is it constructed? Why verifier has anything to do with it?
>>> .
>>>
>>
>>
>> I'm sorry, I didn't describe these errors clearly.
>>
>> bpf_check(bpf_verifier_env)
>>       |
>>       |->do_misc_fixups(env)
>>       |    |
>>       |    |->bpf_patch_insn_data(env)
>>       |    |    |
>>       |    |    |->bpf_patch_insn_single(env->prog)
>>       |    |    |    |
>>       |    |    |    |->bpf_prog_realloc(env->prog)
>>       |    |    |    |    |
>>       |    |    |    |    |->construct new_prog
>>       |    |    |    |    |    free old_prog(env->prog)
>>       |    |    |    |    |
>>       |    |    |    |    |->return new_prog;
>>       |    |    |    |
>>       |    |    |    |->return new_prog;
>>       |    |    |
>>       |    |    |->adjust_insn_aux_data
>>       |    |    |    |
>>       |    |    |    |->return ENOMEM;
>>       |    |    |
>>       |    |    |->return NULL;
>>       |    |
>>       |    |->return ENOMEM;
>>
>> bpf_verifier_env->prog had been freed in bpf_prog_realloc function.
>>
>>
>> There are two errors here, the first is memleak in the
>> bpf_patch_insn_data function, and the second is use after free in the
>> bpf_check function.
>>
>> memleak in bpf_patch_insn_data:
>>
>> Look at the call chain above, if adjust_insn_aux_data function return
>> ENOMEM, bpf_patch_insn_data will return NULL, but we do not free the
>> new_prog.
>>
>> So in the patch 2, before bpf_patch_insn_data return NULL, we free the
>> new_prog.
>>
>> use after free in bpf_check:
>>
>> If bpf_patch_insn_data function return NULL, we will not assign new_prog
>> to the bpf_verifier_env->prog, but bpf_verifier_env->prog has been freed
>> in the bpf_prog_realloc function. Then in bpf_check function, we will
>> use bpf_verifier_env->prog after do_misc_fixups function.
>>
>> In the patch 3, I added a free_old parameter to bpf_prog_realloc, in
>> this scenario we don't free old_prog. Instead, we free it in the
>> do_misc_fixups function when bpf_patch_insn_data return a valid new_prog.
> 
> Thanks for explaining.
> Why not to make adjust_insn_aux_data() in bpf_patch_insn_data() first then?
> Just changing the order will resolve both issues, no?
> .
> 
adjust_insn_aux_data() need the new constructed new_prog as an input 
parameter, so we must call bpf_patch_insn_single() before 
adjust_insn_aux_data().

But we can make adjust_insn_aux_data() never return ENOMEM. In 
bpf_patch_insn_data(), first we pre-malloc memory for new aux_data, then 
call bpf_patch_insn_single() to constructed the new_prog, at last call 
adjust_insn_aux_data() functin. In this way, adjust_insn_aux_data() 
never fails.

bpf_patch_insn_data(env) {
	struct bpf_insn_aux_data *new_data = vzalloc();
	struct bpf_prog *new_prog;
	if (new_data == NULL)
		return NULL;

	new_prog = bpf_patch_insn_single(env->prog);
	if (new_prog == NULL) {
		vfree(new_data);
		return NULL;
	}

	adjust_insn_aux_data(new_prog, new_data);
	return new_prog;
}
What do you think about it?
