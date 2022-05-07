Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 2F3A651E2CF
	for <lists+netdev@lfdr.de>; Sat,  7 May 2022 02:48:32 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1445100AbiEGAwN (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 6 May 2022 20:52:13 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:51480 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229608AbiEGAwM (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 6 May 2022 20:52:12 -0400
Received: from szxga03-in.huawei.com (szxga03-in.huawei.com [45.249.212.189])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id C61DA58397;
        Fri,  6 May 2022 17:48:26 -0700 (PDT)
Received: from dggpemm500020.china.huawei.com (unknown [172.30.72.57])
        by szxga03-in.huawei.com (SkyGuard) with ESMTP id 4Kw7wF3gsKzXdkj;
        Sat,  7 May 2022 08:43:41 +0800 (CST)
Received: from dggpemm500019.china.huawei.com (7.185.36.180) by
 dggpemm500020.china.huawei.com (7.185.36.49) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2375.24; Sat, 7 May 2022 08:48:24 +0800
Received: from [10.67.109.184] (10.67.109.184) by
 dggpemm500019.china.huawei.com (7.185.36.180) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2375.24; Sat, 7 May 2022 08:48:23 +0800
Subject: Re: [PATCH -next 1/2] bpf: Unify data extension operation of
 jited_ksyms and jited_linfo
To:     Andrii Nakryiko <andrii.nakryiko@gmail.com>
CC:     bpf <bpf@vger.kernel.org>, <linux-riscv@lists.infradead.org>,
        Networking <netdev@vger.kernel.org>,
        open list <linux-kernel@vger.kernel.org>,
        =?UTF-8?B?QmrDtnJuIFTDtnBlbA==?= <bjorn@kernel.org>,
        Luke Nelson <luke.r.nels@gmail.com>,
        Xi Wang <xi.wang@gmail.com>,
        Alexei Starovoitov <ast@kernel.org>,
        Daniel Borkmann <daniel@iogearbox.net>,
        Andrii Nakryiko <andrii@kernel.org>, Martin Lau <kafai@fb.com>,
        Song Liu <songliubraving@fb.com>, Yonghong Song <yhs@fb.com>,
        john fastabend <john.fastabend@gmail.com>,
        KP Singh <kpsingh@kernel.org>,
        Paul Walmsley <paul.walmsley@sifive.com>,
        Palmer Dabbelt <palmer@dabbelt.com>,
        Albert Ou <aou@eecs.berkeley.edu>
References: <20220426140924.3308472-1-pulehui@huawei.com>
 <20220426140924.3308472-2-pulehui@huawei.com>
 <CAEf4BzYvGaskrquK1hsKv6h7iz0NXWCNYn_zJEHvYUBYC=2UoA@mail.gmail.com>
 <f1777267-7904-e993-24f9-8071cd4b5bf7@huawei.com>
 <CAEf4BzZ-eDcdJZgJ+Np7Y=V-TVjDDvOMqPwzKjyWrh=i5juv4w@mail.gmail.com>
From:   Pu Lehui <pulehui@huawei.com>
Message-ID: <c501e945-da44-e6b6-937d-cd4ded0b07fb@huawei.com>
Date:   Sat, 7 May 2022 08:48:23 +0800
User-Agent: Mozilla/5.0 (Windows NT 10.0; Win64; x64; rv:78.0) Gecko/20100101
 Thunderbird/78.8.1
MIME-Version: 1.0
In-Reply-To: <CAEf4BzZ-eDcdJZgJ+Np7Y=V-TVjDDvOMqPwzKjyWrh=i5juv4w@mail.gmail.com>
Content-Type: text/plain; charset="utf-8"; format=flowed
Content-Language: en-US
Content-Transfer-Encoding: 7bit
X-Originating-IP: [10.67.109.184]
X-ClientProxiedBy: dggems701-chm.china.huawei.com (10.3.19.178) To
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



On 2022/5/7 5:01, Andrii Nakryiko wrote:
> On Thu, Apr 28, 2022 at 2:47 AM Pu Lehui <pulehui@huawei.com> wrote:
>>
>> Hi Andrii,
>>
>> On 2022/4/28 6:33, Andrii Nakryiko wrote:
>>> On Tue, Apr 26, 2022 at 6:40 AM Pu Lehui <pulehui@huawei.com> wrote:
>>>>
>>>> We found that 32-bit environment can not print bpf line info due
>>>> to data inconsistency between jited_ksyms[0] and jited_linfo[0].
>>>>
>>>> For example:
>>>> jited_kyms[0] = 0xb800067c, jited_linfo[0] = 0xffffffffb800067c
>>>>
>>>> We know that both of them store bpf func address, but due to the
>>>> different data extension operations when extended to u64, they may
>>>> not be the same. We need to unify the data extension operations of
>>>> them.
>>>>
>>>> Signed-off-by: Pu Lehui <pulehui@huawei.com>
>>>> ---
>>>>    kernel/bpf/syscall.c                         |  5 ++++-
>>>>    tools/lib/bpf/bpf_prog_linfo.c               |  8 ++++----
>>>>    tools/testing/selftests/bpf/prog_tests/btf.c | 18 +++++++++---------
>>>
>>> please split kernel changes, libbpf changes, and selftests/bpf changes
>>> into separate patches
>> Thanks for your review. Alright, I will split it next time.
>>
>>>
>>>>    3 files changed, 17 insertions(+), 14 deletions(-)
>>>>
>>>> diff --git a/kernel/bpf/syscall.c b/kernel/bpf/syscall.c
>>>> index e9621cfa09f2..4c417c806d92 100644
>>>> --- a/kernel/bpf/syscall.c
>>>> +++ b/kernel/bpf/syscall.c
>>>> @@ -3868,13 +3868,16 @@ static int bpf_prog_get_info_by_fd(struct file *file,
>>>>                   info.nr_jited_line_info = 0;
>>>>           if (info.nr_jited_line_info && ulen) {
>>>>                   if (bpf_dump_raw_ok(file->f_cred)) {
>>>> +                       unsigned long jited_linfo_addr;
>>>>                           __u64 __user *user_linfo;
>>>>                           u32 i;
>>>>
>>>>                           user_linfo = u64_to_user_ptr(info.jited_line_info);
>>>>                           ulen = min_t(u32, info.nr_jited_line_info, ulen);
>>>>                           for (i = 0; i < ulen; i++) {
>>>> -                               if (put_user((__u64)(long)prog->aux->jited_linfo[i],
>>>> +                               jited_linfo_addr = (unsigned long)
>>>> +                                       prog->aux->jited_linfo[i];
>>>> +                               if (put_user((__u64) jited_linfo_addr,
>>>>                                                &user_linfo[i]))
>>>>                                           return -EFAULT;
>>>>                           }
>> Please let me to explain more detail, sorry if I'm wordy.
>> The main reason that 32-bit env does not print bpf line info is here:
>>
>> kernel/bpf/syscall.c:
>> bpf_prog_get_info_by_fd {
>>          ...
>>          user_ksyms = u64_to_user_ptr(info.jited_ksyms);
>>          ksym_addr = (unsigned long)prog->aux->func[i]->bpf_func;
>>          if (put_user((u64) ksym_addr, &user_ksyms[i]))
>>          ...
>>
>>          user_linfo = u64_to_user_ptr(info.jited_line_info);
>>          if (put_user((__u64)(long)prog->aux->jited_linfo[i],
>>                       &user_linfo[i]))
>>          ...
>> }
>>
>> In 32-bit env, ksym_addr and prog->aux->jited_linfo[0] both store the
>> 32-bit address of bpf_func, but the first one is zero-extension to u64,
>> while the other is sign-extension to u64.
>> For example:
>>          prog->aux->func[0]->bpf_func = 0xb800067c
>>          user_ksyms[0] = 0xb800067c, user_linfo[0] = 0xffffffffb800067c
>>
>> Both zero-extension and sign-extension are fine, but if operating
>> directly between them without casting in 32-bit env, there will have
>> some potential problems. Such as:
>>
>> tools/lib/bpf/bpf_prog_linfo.c:
>> dissect_jited_func {
>>          ...
>>          if (ksym_func[0] != *jited_linfo) //always missmatch in 32 env
>>                  goto errout;
>>          ...
>>          if (ksym_func[f] == *jited_linfo) {
>>          ...
>>          last_jited_linfo = *jited_linfo;
>>          if (last_jited_linfo - ksym_func[f - 1] + 1 >
>>              ksym_len[f - 1])
>>          ...
>> }
>>
>> We could cast them to 32-bit data type, but I think unify data extension
>> operation will be better.
>>
>>>> diff --git a/tools/lib/bpf/bpf_prog_linfo.c b/tools/lib/bpf/bpf_prog_linfo.c
>>>> index 5c503096ef43..5cf41a563ef5 100644
>>>> --- a/tools/lib/bpf/bpf_prog_linfo.c
>>>> +++ b/tools/lib/bpf/bpf_prog_linfo.c
>>>> @@ -127,7 +127,7 @@ struct bpf_prog_linfo *bpf_prog_linfo__new(const struct bpf_prog_info *info)
>>>>           prog_linfo->raw_linfo = malloc(data_sz);
>>>>           if (!prog_linfo->raw_linfo)
>>>>                   goto err_free;
>>>> -       memcpy(prog_linfo->raw_linfo, (void *)(long)info->line_info, data_sz);
>>>> +       memcpy(prog_linfo->raw_linfo, (void *)(unsigned long)info->line_info, data_sz);
>>>>
>>>>           nr_jited_func = info->nr_jited_ksyms;
>>>>           if (!nr_jited_func ||
>>>> @@ -148,7 +148,7 @@ struct bpf_prog_linfo *bpf_prog_linfo__new(const struct bpf_prog_info *info)
>>>>           if (!prog_linfo->raw_jited_linfo)
>>>>                   goto err_free;
>>>>           memcpy(prog_linfo->raw_jited_linfo,
>>>> -              (void *)(long)info->jited_line_info, data_sz);
>>>> +              (void *)(unsigned long)info->jited_line_info, data_sz);
>>>>
>>>>           /* Number of jited_line_info per jited func */
>>>>           prog_linfo->nr_jited_linfo_per_func = malloc(nr_jited_func *
>>>> @@ -166,8 +166,8 @@ struct bpf_prog_linfo *bpf_prog_linfo__new(const struct bpf_prog_info *info)
>>>>                   goto err_free;
>>>>
>>>>           if (dissect_jited_func(prog_linfo,
>>>> -                              (__u64 *)(long)info->jited_ksyms,
>>>> -                              (__u32 *)(long)info->jited_func_lens))
>>>> +                              (__u64 *)(unsigned long)info->jited_ksyms,
>>>> +                              (__u32 *)(unsigned long)info->jited_func_lens))
>>>
>>> so I'm trying to understand how this is changing anything for 32-bit
>>> architecture and I must be missing something, sorry if I'm being
>>> dense. The example you used below
>>>
>>> jited_kyms[0] = 0xb800067c, jited_linfo[0] = 0xffffffffb800067c
>>>
>>> Wouldn't (unsigned long)0xffffffffb800067c == (long)0xffffffffb800067c
>>> == 0xb800067c ?
>> If I understand correctly, info->jited_ksyms or info->jited_func_lens is
>> just a u64 address that point to the corresponding space. The bpf_func
>> address is stored in the item of info->jited_ksyms but not
>> info->jited_ksyms.
>>
>> And here, I may have misled you. Both (__u64 *)(long)info->jited_ksyms
>> and (__u64 *)(unsigned long)info->jited_ksyms are the same, I just want
>> to unify the style. I will remove them in v2.
>>
>> Please let me know if there is any problem with my understanding.
>>
> 
> Thanks for explanation. I guess in my mind I was always sign extending
> 32-bit to 64-bit, but I think memory addresses are conceptually
> unsigned, so (unsigned long) casting makes more sense, and u64
> representation of 0xb800067c should be 0x00000000b800067c and not
> 0xffffffffb800067c. So your changes make sense, and I agree that
> libbpf-side changes for conceptual uniformity are also good.
> 

Alright, I will pick them back in v3. Thanks.

> 
>> Thanks,
>> Lehui
>>>
>>> isn't sizeof(long) == sizeof(void*) == 4?
>>>
>>> It would be nice if you could elaborate a bit more on what problems
>>> did you see in practice?
>>>
>>>>                   goto err_free;
>>>>
>>>>           return prog_linfo;
>>>> diff --git a/tools/testing/selftests/bpf/prog_tests/btf.c b/tools/testing/selftests/bpf/prog_tests/btf.c
>>>> index 84aae639ddb5..d9ba1ec1d5b3 100644
>>>> --- a/tools/testing/selftests/bpf/prog_tests/btf.c
>>>> +++ b/tools/testing/selftests/bpf/prog_tests/btf.c
>>>> @@ -6451,8 +6451,8 @@ static int test_get_linfo(const struct prog_info_raw_test *test,
>>>>                     info.nr_jited_line_info, jited_cnt,
>>>>                     info.line_info_rec_size, rec_size,
>>>>                     info.jited_line_info_rec_size, jited_rec_size,
>>>> -                 (void *)(long)info.line_info,
>>>> -                 (void *)(long)info.jited_line_info)) {
>>>> +                 (void *)(unsigned long)info.line_info,
>>>> +                 (void *)(unsigned long)info.jited_line_info)) {
>>>>                   err = -1;
>>>>                   goto done;
>>>>           }
>>>> @@ -6500,8 +6500,8 @@ static int test_get_linfo(const struct prog_info_raw_test *test,
>>>>           }
>>>>
>>>>           if (CHECK(jited_linfo[0] != jited_ksyms[0],
>>>> -                 "jited_linfo[0]:%lx != jited_ksyms[0]:%lx",
>>>> -                 (long)(jited_linfo[0]), (long)(jited_ksyms[0]))) {
>>>> +                 "jited_linfo[0]:%llx != jited_ksyms[0]:%llx",
>>>> +                 jited_linfo[0], jited_ksyms[0])) {
>>>>                   err = -1;
>>>>                   goto done;
>>>>           }
>>>> @@ -6519,16 +6519,16 @@ static int test_get_linfo(const struct prog_info_raw_test *test,
>>>>                   }
>>>>
>>>>                   if (CHECK(jited_linfo[i] <= jited_linfo[i - 1],
>>>> -                         "jited_linfo[%u]:%lx <= jited_linfo[%u]:%lx",
>>>> -                         i, (long)jited_linfo[i],
>>>> -                         i - 1, (long)(jited_linfo[i - 1]))) {
>>>> +                         "jited_linfo[%u]:%llx <= jited_linfo[%u]:%llx",
>>>> +                         i, jited_linfo[i],
>>>> +                         i - 1, (jited_linfo[i - 1]))) {
>>>>                           err = -1;
>>>>                           goto done;
>>>>                   }
>>>>
>>>>                   if (CHECK(jited_linfo[i] - cur_func_ksyms > cur_func_len,
>>>> -                         "jited_linfo[%u]:%lx - %lx > %u",
>>>> -                         i, (long)jited_linfo[i], (long)cur_func_ksyms,
>>>> +                         "jited_linfo[%u]:%llx - %llx > %u",
>>>> +                         i, jited_linfo[i], cur_func_ksyms,
>>>>                             cur_func_len)) {
>>>>                           err = -1;
>>>>                           goto done;
>>>> --
>>>> 2.25.1
>>>>
>>> .
>>>
> .
> 
