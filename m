Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 2F30951E2D2
	for <lists+netdev@lfdr.de>; Sat,  7 May 2022 02:51:07 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1445108AbiEGAyt (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 6 May 2022 20:54:49 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:54028 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229608AbiEGAyr (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 6 May 2022 20:54:47 -0400
Received: from szxga02-in.huawei.com (szxga02-in.huawei.com [45.249.212.188])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id AE67750B2F;
        Fri,  6 May 2022 17:51:02 -0700 (PDT)
Received: from dggpemm500022.china.huawei.com (unknown [172.30.72.54])
        by szxga02-in.huawei.com (SkyGuard) with ESMTP id 4Kw81W5kmDzGpLg;
        Sat,  7 May 2022 08:48:15 +0800 (CST)
Received: from dggpemm500019.china.huawei.com (7.185.36.180) by
 dggpemm500022.china.huawei.com (7.185.36.162) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2375.24; Sat, 7 May 2022 08:51:00 +0800
Received: from [10.67.109.184] (10.67.109.184) by
 dggpemm500019.china.huawei.com (7.185.36.180) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2375.24; Sat, 7 May 2022 08:51:00 +0800
Subject: Re: [PATCH bpf-next v2 1/2] bpf: Unify data extension operation of
 jited_ksyms and jited_linfo
To:     John Fastabend <john.fastabend@gmail.com>, <bpf@vger.kernel.org>,
        <linux-riscv@lists.infradead.org>, <netdev@vger.kernel.org>,
        <linux-kernel@vger.kernel.org>
CC:     Alexei Starovoitov <ast@kernel.org>,
        Daniel Borkmann <daniel@iogearbox.net>,
        Andrii Nakryiko <andrii@kernel.org>,
        =?UTF-8?B?QmrDtnJuIFTDtnBlbA==?= <bjorn@kernel.org>,
        Luke Nelson <luke.r.nels@gmail.com>,
        Xi Wang <xi.wang@gmail.com>, Martin KaFai Lau <kafai@fb.com>,
        Song Liu <songliubraving@fb.com>, Yonghong Song <yhs@fb.com>,
        KP Singh <kpsingh@kernel.org>,
        Paul Walmsley <paul.walmsley@sifive.com>,
        Palmer Dabbelt <palmer@dabbelt.com>,
        Albert Ou <aou@eecs.berkeley.edu>
References: <20220429014240.3434866-1-pulehui@huawei.com>
 <20220429014240.3434866-2-pulehui@huawei.com>
 <62758a83b512a_18fd5208b5@john.notmuch>
From:   Pu Lehui <pulehui@huawei.com>
Message-ID: <7e1ef7a3-582b-7443-8018-69126efdc587@huawei.com>
Date:   Sat, 7 May 2022 08:51:00 +0800
User-Agent: Mozilla/5.0 (Windows NT 10.0; Win64; x64; rv:78.0) Gecko/20100101
 Thunderbird/78.8.1
MIME-Version: 1.0
In-Reply-To: <62758a83b512a_18fd5208b5@john.notmuch>
Content-Type: text/plain; charset="utf-8"; format=flowed
Content-Language: en-US
Content-Transfer-Encoding: 7bit
X-Originating-IP: [10.67.109.184]
X-ClientProxiedBy: dggems702-chm.china.huawei.com (10.3.19.179) To
 dggpemm500019.china.huawei.com (7.185.36.180)
X-CFilter-Loop: Reflected
X-Spam-Status: No, score=-7.3 required=5.0 tests=BAYES_00,NICE_REPLY_A,
        RCVD_IN_DNSWL_MED,SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org



On 2022/5/7 4:52, John Fastabend wrote:
> Pu Lehui wrote:
>> We found that 32-bit environment can not print bpf line info due
>> to data inconsistency between jited_ksyms[0] and jited_linfo[0].
>>
>> For example:
>> jited_kyms[0] = 0xb800067c, jited_linfo[0] = 0xffffffffb800067c
>>
>> We know that both of them store bpf func address, but due to the
>> different data extension operations when extended to u64, they may
>> not be the same. We need to unify the data extension operations of
>> them.
>>
>> Signed-off-by: Pu Lehui <pulehui@huawei.com>
>> ---
>>   kernel/bpf/syscall.c | 5 ++++-
>>   1 file changed, 4 insertions(+), 1 deletion(-)
>>
>> diff --git a/kernel/bpf/syscall.c b/kernel/bpf/syscall.c
>> index e9e3e49c0eb7..18137ea5190d 100644
>> --- a/kernel/bpf/syscall.c
>> +++ b/kernel/bpf/syscall.c
>> @@ -3871,13 +3871,16 @@ static int bpf_prog_get_info_by_fd(struct file *file,
>>   		info.nr_jited_line_info = 0;
>>   	if (info.nr_jited_line_info && ulen) {
>>   		if (bpf_dump_raw_ok(file->f_cred)) {
>> +			unsigned long jited_linfo_addr;
>>   			__u64 __user *user_linfo;
>>   			u32 i;
>>   
>>   			user_linfo = u64_to_user_ptr(info.jited_line_info);
>>   			ulen = min_t(u32, info.nr_jited_line_info, ulen);
>>   			for (i = 0; i < ulen; i++) {
>> -				if (put_user((__u64)(long)prog->aux->jited_linfo[i],
>> +				jited_linfo_addr = (unsigned long)
>> +					prog->aux->jited_linfo[i];
>> +				if (put_user((__u64) jited_linfo_addr,
>>   					     &user_linfo[i]))
> 
> the logic is fine but i'm going to nitpick a bit this 4 lines is ugly
> just make it slightly longer than 80chars or use a shoarter name? For
> example,
> 
> 			for (i = 0; i < ulen; i++) {
> 				unsigned long l;
> 
> 				l = (unsigned long) prog->aux->jited_linfo[i];
> 				if (put_user((__u64) l, &user_linfo[i]))
> 
> is much nicer -- no reason to smash single assignment across multiple
> lines. My $.02.
> 

Okay, It sounds good. I will make change in next version. Thanks.

> Thanks,
> John
> .
> 
