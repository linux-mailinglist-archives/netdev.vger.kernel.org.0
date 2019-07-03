Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id CAC635DCDF
	for <lists+netdev@lfdr.de>; Wed,  3 Jul 2019 05:26:29 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727248AbfGCD0Z (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 2 Jul 2019 23:26:25 -0400
Received: from szxga07-in.huawei.com ([45.249.212.35]:43626 "EHLO huawei.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1727179AbfGCD0Z (ORCPT <rfc822;netdev@vger.kernel.org>);
        Tue, 2 Jul 2019 23:26:25 -0400
Received: from DGGEMS407-HUB.china.huawei.com (unknown [172.30.72.58])
        by Forcepoint Email with ESMTP id C3A5D8A5EF48C5630538;
        Wed,  3 Jul 2019 11:26:22 +0800 (CST)
Received: from [127.0.0.1] (10.133.213.239) by DGGEMS407-HUB.china.huawei.com
 (10.3.19.207) with Microsoft SMTP Server id 14.3.439.0; Wed, 3 Jul 2019
 11:26:18 +0800
Subject: Re: [PATCH bpf-next] bpf: cgroup: Fix build error without CONFIG_NET
To:     Yonghong Song <yhs@fb.com>
References: <20190702132913.26060-1-yuehaibing@huawei.com>
 <20190702155316.GJ6757@mini-arch>
 <fd312c26-db8e-cae3-1c14-869d8e3a62ae@fb.com>
CC:     Stanislav Fomichev <sdf@fomichev.me>,
        "ast@kernel.org" <ast@kernel.org>,
        "daniel@iogearbox.net" <daniel@iogearbox.net>,
        Martin Lau <kafai@fb.com>, Song Liu <songliubraving@fb.com>,
        "sdf@google.com" <sdf@google.com>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "netdev@vger.kernel.org" <netdev@vger.kernel.org>,
        "bpf@vger.kernel.org" <bpf@vger.kernel.org>
From:   Yuehaibing <yuehaibing@huawei.com>
Message-ID: <780afbff-5b93-099c-f318-7f2704af13d6@huawei.com>
Date:   Wed, 3 Jul 2019 11:26:17 +0800
User-Agent: Mozilla/5.0 (Windows NT 6.1; WOW64; rv:45.0) Gecko/20100101
 Thunderbird/45.2.0
MIME-Version: 1.0
In-Reply-To: <fd312c26-db8e-cae3-1c14-869d8e3a62ae@fb.com>
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
X-Originating-IP: [10.133.213.239]
X-CFilter-Loop: Reflected
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On 2019/7/3 0:04, Yonghong Song wrote:
> 
> 
> On 7/2/19 8:53 AM, Stanislav Fomichev wrote:
>> On 07/02, YueHaibing wrote:
>>> If CONFIG_NET is not set, gcc building fails:
>>>
>>> kernel/bpf/cgroup.o: In function `cg_sockopt_func_proto':
>>> cgroup.c:(.text+0x237e): undefined reference to `bpf_sk_storage_get_proto'
>>> cgroup.c:(.text+0x2394): undefined reference to `bpf_sk_storage_delete_proto'
>>> kernel/bpf/cgroup.o: In function `__cgroup_bpf_run_filter_getsockopt':
>>> (.text+0x2a1f): undefined reference to `lock_sock_nested'
>>> (.text+0x2ca2): undefined reference to `release_sock'
>>> kernel/bpf/cgroup.o: In function `__cgroup_bpf_run_filter_setsockopt':
>>> (.text+0x3006): undefined reference to `lock_sock_nested'
>>> (.text+0x32bb): undefined reference to `release_sock'
>>>
>>> Add CONFIG_NET dependency to fix this.
>> Can you share the config? Do I understand correctly that you have
>> CONFIG_NET=n and CONFIG_BPF=y? What parts of BPF do you expect to
>> work in this case?
>>
>> Less invasive fix would be something along the lines:
>>
>> diff --git a/kernel/bpf/cgroup.c b/kernel/bpf/cgroup.c
>> index 76fa0076f20d..0a00eaca6fae 100644
>> --- a/kernel/bpf/cgroup.c
>> +++ b/kernel/bpf/cgroup.c
>> @@ -939,6 +939,7 @@ int __cgroup_bpf_run_filter_sysctl(struct ctl_table_header *head,
>>   }
>>   EXPORT_SYMBOL(__cgroup_bpf_run_filter_sysctl);
>>   
>> +#ifdef CONFIG_NET
>>   static bool __cgroup_bpf_prog_array_is_empty(struct cgroup *cgrp,
>>   					     enum bpf_attach_type attach_type)
>>   {
>> @@ -1120,6 +1121,7 @@ int __cgroup_bpf_run_filter_getsockopt(struct sock *sk, int level,
>>   	return ret;
>>   }
>>   EXPORT_SYMBOL(__cgroup_bpf_run_filter_getsockopt);
>> +#endif
>>   
>>   static ssize_t sysctl_cpy_dir(const struct ctl_dir *dir, char **bufp,
>>   			      size_t *lenp)
>> @@ -1386,10 +1388,12 @@ static const struct bpf_func_proto *
>>   cg_sockopt_func_proto(enum bpf_func_id func_id, const struct bpf_prog *prog)
>>   {
>>   	switch (func_id) {
>> +#ifdef CONFIG_NET
>>   	case BPF_FUNC_sk_storage_get:
>>   		return &bpf_sk_storage_get_proto;
>>   	case BPF_FUNC_sk_storage_delete:
>>   		return &bpf_sk_storage_delete_proto;
>> +#endif
>>   #ifdef CONFIG_INET
>>   	case BPF_FUNC_tcp_sock:
>>   		return &bpf_tcp_sock_proto;
> 
> Ah. Just send another email without checking inbox.
> Looks like the above change is preferred.
> YueHaibing, could you make change and resubmit your patch?

Sure, I will test and resubmit it.

> 
>>
>>> Reported-by: Hulk Robot <hulkci@huawei.com>
>>> Fixes: 0d01da6afc54 ("bpf: implement getsockopt and setsockopt hooks")
>>> Signed-off-by: YueHaibing <yuehaibing@huawei.com>
>>> ---
>>>   init/Kconfig | 1 +
>>>   1 file changed, 1 insertion(+)
>>>
>>> diff --git a/init/Kconfig b/init/Kconfig
>>> index e2e51b5..341cf2a 100644
>>> --- a/init/Kconfig
>>> +++ b/init/Kconfig
>>> @@ -998,6 +998,7 @@ config CGROUP_PERF
>>>   config CGROUP_BPF
>>>   	bool "Support for eBPF programs attached to cgroups"
>>>   	depends on BPF_SYSCALL
>>> +	depends on NET
>>>   	select SOCK_CGROUP_DATA
>>>   	help
>>>   	  Allow attaching eBPF programs to a cgroup using the bpf(2)
>>> -- 
>>> 2.7.4
>>>
>>>

