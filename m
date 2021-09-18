Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 223C64102DE
	for <lists+netdev@lfdr.de>; Sat, 18 Sep 2021 04:03:27 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S238702AbhIRCEg (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 17 Sep 2021 22:04:36 -0400
Received: from szxga02-in.huawei.com ([45.249.212.188]:15435 "EHLO
        szxga02-in.huawei.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230465AbhIRCEf (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 17 Sep 2021 22:04:35 -0400
Received: from dggemv703-chm.china.huawei.com (unknown [172.30.72.57])
        by szxga02-in.huawei.com (SkyGuard) with ESMTP id 4HBDWp4ZfbzRH8x;
        Sat, 18 Sep 2021 09:59:02 +0800 (CST)
Received: from dggpeml500025.china.huawei.com (7.185.36.35) by
 dggemv703-chm.china.huawei.com (10.3.19.46) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2308.8; Sat, 18 Sep 2021 10:03:10 +0800
Received: from [10.174.176.117] (10.174.176.117) by
 dggpeml500025.china.huawei.com (7.185.36.35) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2308.8; Sat, 18 Sep 2021 10:03:09 +0800
Subject: Re: [RFC PATCH bpf-next 1/3] bpf: add dummy BPF STRUCT_OPS for test
 purpose
To:     Martin KaFai Lau <kafai@fb.com>
CC:     Alexei Starovoitov <ast@kernel.org>,
        Daniel Borkmann <daniel@iogearbox.net>,
        Andrii Nakryiko <andrii@kernel.org>, <netdev@vger.kernel.org>,
        <bpf@vger.kernel.org>
References: <20210915033753.1201597-1-houtao1@huawei.com>
 <20210915033753.1201597-2-houtao1@huawei.com>
 <20210915205837.3v77ajauw4nnhnc2@kafai-mbp.dhcp.thefacebook.com>
From:   Hou Tao <houtao1@huawei.com>
Message-ID: <0423fe89-496a-e30c-dec8-9de992d9525b@huawei.com>
Date:   Sat, 18 Sep 2021 10:03:09 +0800
User-Agent: Mozilla/5.0 (Windows NT 10.0; Win64; x64; rv:78.0) Gecko/20100101
 Thunderbird/78.6.0
MIME-Version: 1.0
In-Reply-To: <20210915205837.3v77ajauw4nnhnc2@kafai-mbp.dhcp.thefacebook.com>
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 8bit
Content-Language: en-US
X-Originating-IP: [10.174.176.117]
X-ClientProxiedBy: dggems702-chm.china.huawei.com (10.3.19.179) To
 dggpeml500025.china.huawei.com (7.185.36.35)
X-CFilter-Loop: Reflected
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Hi,

On 9/16/2021 4:58 AM, Martin KaFai Lau wrote:
> On Wed, Sep 15, 2021 at 11:37:51AM +0800, Hou Tao wrote:
>> Currently the test of BPF STRUCT_OPS depends on the specific bpf
>> implementation of tcp_congestion_ops, and it can not cover all
>> basic functionalities (e.g, return value handling), so introduce
>> a dummy BPF STRUCT_OPS for test purpose.
>>
>> Dummy BPF STRUCT_OPS may not being needed for release kernel, so
>> adding a kconfig option BPF_DUMMY_STRUCT_OPS to enable it separatedly.
> Thanks for the patches !
>
>> diff --git a/include/linux/bpf_dummy_ops.h b/include/linux/bpf_dummy_ops.h
>> new file mode 100644
>> index 000000000000..b2aad3e6e2fe
>> --- /dev/null
>> +++ b/include/linux/bpf_dummy_ops.h
>> @@ -0,0 +1,28 @@
>> +/* SPDX-License-Identifier: GPL-2.0-only */
>> +/*
>> + * Copyright (C) 2021. Huawei Technologies Co., Ltd
>> + */
>> +#ifndef _BPF_DUMMY_OPS_H
>> +#define _BPF_DUMMY_OPS_H
>> +
>> +#ifdef CONFIG_BPF_DUMMY_STRUCT_OPS
>> +#include <linux/module.h>
>> +
>> +struct bpf_dummy_ops_state {
>> +	int val;
>> +};
>> +
>> +struct bpf_dummy_ops {
>> +	int (*init)(struct bpf_dummy_ops_state *state);
>> +	struct module *owner;
>> +};
>> +
>> +extern struct bpf_dummy_ops *bpf_get_dummy_ops(void);
>> +extern void bpf_put_dummy_ops(struct bpf_dummy_ops *ops);
>> +#else
>> +struct bpf_dummy_ops {}；
> This ';' looks different ;)
>
> It probably has dodged the compiler due to the kconfig.
> I think CONFIG_BPF_DUMMY_STRUCT_OPS and the bpf_(get|put)_dummy_ops
> are not needed.  More on this later.
>
>> diff --git a/kernel/bpf/bpf_dummy_struct_ops.c b/kernel/bpf/bpf_dummy_struct_ops.c
>> new file mode 100644
>> index 000000000000..f76c4a3733f0
>> --- /dev/null
>> +++ b/kernel/bpf/bpf_dummy_struct_ops.c
>> @@ -0,0 +1,173 @@
>> +// SPDX-License-Identifier: GPL-2.0
>> +/*
>> + * Copyright (C) 2021. Huawei Technologies Co., Ltd
>> + */
>> +#include <linux/kernel.h>
>> +#include <linux/spinlock.h>
>> +#include <linux/bpf_verifier.h>
>> +#include <linux/bpf.h>
>> +#include <linux/btf.h>
>> +#include <linux/bpf_dummy_ops.h>
>> +
>> +static struct bpf_dummy_ops *bpf_dummy_ops_singletion;
>> +static DEFINE_SPINLOCK(bpf_dummy_ops_lock);
>> +
>> +static const struct btf_type *dummy_ops_state;
>> +
>> +struct bpf_dummy_ops *bpf_get_dummy_ops(void)
>> +{
>> +	struct bpf_dummy_ops *ops;
>> +
>> +	spin_lock(&bpf_dummy_ops_lock);
>> +	ops = bpf_dummy_ops_singletion;
>> +	if (ops && !bpf_try_module_get(ops, ops->owner))
>> +		ops = NULL;
>> +	spin_unlock(&bpf_dummy_ops_lock);
>> +
>> +	return ops ? ops : ERR_PTR(-ENXIO);
>> +}
>> +EXPORT_SYMBOL_GPL(bpf_get_dummy_ops);
>> +
>> +void bpf_put_dummy_ops(struct bpf_dummy_ops *ops)
>> +{
>> +	bpf_module_put(ops, ops->owner);
>> +}
>> +EXPORT_SYMBOL_GPL(bpf_put_dummy_ops);
> [ ... ]
>
>> +static int bpf_dummy_reg(void *kdata)
>> +{
>> +	struct bpf_dummy_ops *ops = kdata;
>> +	int err = 0;
>> +
>> +	spin_lock(&bpf_dummy_ops_lock);
>> +	if (!bpf_dummy_ops_singletion)
>> +		bpf_dummy_ops_singletion = ops;
>> +	else
>> +		err = -EEXIST;
>> +	spin_unlock(&bpf_dummy_ops_lock);
>> +
>> +	return err;
>> +}
> I don't think we are interested in testing register/unregister
> a struct_ops.  This common infra logic should have already
> been covered by bpf_tcp_ca.   Lets see if it can be avoided
> such that the above singleton instance and EXPORT_SYMBOL_GPL
> can also be removed.
>
> It can reuse the bpf_prog_test_run() which can run a particular
> bpf prog.  Then it allows a flexible way to select which prog
> to call instead of creating a file and then triggering individual
> prog by writing a name string into this new file.
>
> For bpf_prog_test_run(),  it needs a ".test_run" implementation in
> "const struct bpf_prog_ops bpf_struct_ops_prog_ops".
> This to-be-implemented  ".test_run" can check the prog->aux->attach_btf_id
> to ensure it is the bpf_dummy_ops.  The prog->expected_attach_type can
> tell which "func" ptr within the bpf_dummy_ops and then ".test_run" will
> know how to call it.  The extra thing for the struct_ops's ".test_run" is
> to first call arch_prepare_bpf_trampoline() to prepare the trampoline
> before calling into the bpf prog.
>
> You can take a look at the other ".test_run" implementations,
> e.g. bpf_prog_test_run_skb() and bpf_prog_test_run_tracing().
>
> test_skb_pkt_end.c and fentry_test.c (likely others also) can be
> used as reference for prog_tests/ purpose.  For the dummy_ops test in
> prog_tests/, it does not need to call bpf_map__attach_struct_ops() since
> there is no need to reg().  Instead, directly bpf_prog_test_run() to
> exercise each prog in bpf_dummy_ops.skel.h.
>
> bpf_dummy_init_member() should return -ENOTSUPP.
> bpf_dummy_reg() and bpf_dummy_unreg() should then be never called.
>
> bpf_dummy_struct_ops.c should be moved into net/bpf/.
> No need to have CONFIG_BPF_DUMMY_STRUCT_OPS.  In the future, a generic one
> could be created for the test_run related codes, if there is a need.
Will do and thanks for your suggestions.
>> +
>> +static void bpf_dummy_unreg(void *kdata)
>> +{
>> +	struct bpf_dummy_ops *ops = kdata;
>> +
>> +	spin_lock(&bpf_dummy_ops_lock);
>> +	if (bpf_dummy_ops_singletion == ops)
>> +		bpf_dummy_ops_singletion = NULL;
>> +	else
>> +		WARN_ON(1);
>> +	spin_unlock(&bpf_dummy_ops_lock);
>> +}
>> +
>> +extern struct bpf_struct_ops bpf_bpf_dummy_ops;
>> +
>> +struct bpf_struct_ops bpf_bpf_dummy_ops = {
>> +	.verifier_ops = &bpf_dummy_verifier_ops,
>> +	.init = bpf_dummy_init,
>> +	.init_member = bpf_dummy_init_member,
>> +	.check_member = bpf_dummy_check_member,
>> +	.reg = bpf_dummy_reg,
>> +	.unreg = bpf_dummy_unreg,
>> +	.name = "bpf_dummy_ops",
>> +};
> .

