Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id B646846D4D1
	for <lists+netdev@lfdr.de>; Wed,  8 Dec 2021 14:50:49 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234403AbhLHNyU (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 8 Dec 2021 08:54:20 -0500
Received: from szxga02-in.huawei.com ([45.249.212.188]:28289 "EHLO
        szxga02-in.huawei.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232916AbhLHNyS (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 8 Dec 2021 08:54:18 -0500
Received: from dggpeml500025.china.huawei.com (unknown [172.30.72.56])
        by szxga02-in.huawei.com (SkyGuard) with ESMTP id 4J8JTN75KGzbjNx;
        Wed,  8 Dec 2021 21:50:32 +0800 (CST)
Received: from [10.174.176.117] (10.174.176.117) by
 dggpeml500025.china.huawei.com (7.185.36.35) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2308.20; Wed, 8 Dec 2021 21:50:45 +0800
Subject: Re: [PATCH bpf-next 5/5] selftests/bpf: add test cases for
 bpf_strncmp()
To:     Andrii Nakryiko <andrii.nakryiko@gmail.com>
CC:     Alexei Starovoitov <ast@kernel.org>,
        Martin KaFai Lau <kafai@fb.com>, Yonghong Song <yhs@fb.com>,
        Daniel Borkmann <daniel@iogearbox.net>,
        Andrii Nakryiko <andrii@kernel.org>,
        Networking <netdev@vger.kernel.org>, bpf <bpf@vger.kernel.org>
References: <20211130142215.1237217-1-houtao1@huawei.com>
 <20211130142215.1237217-6-houtao1@huawei.com>
 <CAEf4BzaZR84VXUSh-SkA32yTYXhz5vUxK7ysoGMgWsa0+d54vQ@mail.gmail.com>
From:   Hou Tao <houtao1@huawei.com>
Message-ID: <f39b4017-8f7e-474c-6497-7f6448c44911@huawei.com>
Date:   Wed, 8 Dec 2021 21:50:45 +0800
User-Agent: Mozilla/5.0 (Windows NT 10.0; Win64; x64; rv:78.0) Gecko/20100101
 Thunderbird/78.6.0
MIME-Version: 1.0
In-Reply-To: <CAEf4BzaZR84VXUSh-SkA32yTYXhz5vUxK7ysoGMgWsa0+d54vQ@mail.gmail.com>
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Content-Language: en-US
X-Originating-IP: [10.174.176.117]
X-ClientProxiedBy: dggems701-chm.china.huawei.com (10.3.19.178) To
 dggpeml500025.china.huawei.com (7.185.36.35)
X-CFilter-Loop: Reflected
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Hi,
On 12/7/2021 11:09 AM, Andrii Nakryiko wrote:
>> +static struct strncmp_test *strncmp_test_open_and_disable_autoload(void)
>> +{
>> +       struct strncmp_test *skel;
>> +       struct bpf_program *prog;
>> +
>> +       skel = strncmp_test__open();
>> +       if (libbpf_get_error(skel))
>> +               return skel;
>> +
>> +       bpf_object__for_each_program(prog, skel->obj)
>> +               bpf_program__set_autoload(prog, false);
> I think this is a wrong "code economy". You save few lines of code,
> but make tests harder to follow. Just do 4 lines of code for each
> subtest:
>
> skel = strncmp_test__open();
> if (!ASSERT_OK_PTR(skel, "skel_open"))
>     return;
>
> bpf_object__for_each_program(prog, skel->obj)
>     bpf_program__set_autoload(prog, false);
>
>
> It makes tests more self-contained and easier to follow. Also if some
> tests need to do something slightly different it's easier to modify
> them, as they are not coupled to some common helper. DRY is good where
> it makes sense, but it also increases code coupling and more "jumping
> around" in code, so it shouldn't be applied blindly.
Thanks for your suggestion on DRY topic. Will do in v2.
> +
> +static int trigger_strncmp(const struct strncmp_test *skel)
> +{
> +       struct timespec wait = {.tv_sec = 0, .tv_nsec = 1};
> +
> +       nanosleep(&wait, NULL);
> all the other tests are just doing usleep(1), why using this more verbose way?
Will do in v2.
>> +
>> +static __always_inline bool called_by_target_pid(void)
>> +{
>> +       __u32 pid = bpf_get_current_pid_tgid() >> 32;
>> +
>> +       return pid == target_pid;
>> +}
> again, what's the point of this helper? it's used once and you'd
> actually save the code by doing the following inline:
>
> if ((bpf_get_current_pid_tgid() >> 32) != target_pid)
>     return 0;
Will do in v2.
>> +
>> +SEC("tp/syscalls/sys_enter_nanosleep")
>> +int do_strncmp(void *ctx)
>> +{
>> +       if (!called_by_target_pid())
>> +               return 0;
>> +
>> +       cmp_ret = bpf_strncmp(str, STRNCMP_STR_SZ, target);
>> +
>> +       return 0;
>> +}
>> +
>> +SEC("tp/syscalls/sys_enter_nanosleep")
>> +int strncmp_bad_not_const_str_size(void *ctx)
>> +{
> probably worth leaving a short comment explaining that this program
> should fail because ...
OK. Will do in v2.

Regards,
Tao
