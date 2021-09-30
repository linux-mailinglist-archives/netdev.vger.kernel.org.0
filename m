Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 8A46F41D866
	for <lists+netdev@lfdr.de>; Thu, 30 Sep 2021 13:06:05 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1350351AbhI3LHa (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 30 Sep 2021 07:07:30 -0400
Received: from szxga08-in.huawei.com ([45.249.212.255]:24165 "EHLO
        szxga08-in.huawei.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1350347AbhI3LH0 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 30 Sep 2021 07:07:26 -0400
Received: from dggemv703-chm.china.huawei.com (unknown [172.30.72.57])
        by szxga08-in.huawei.com (SkyGuard) with ESMTP id 4HKr3V1MHwz1DHDv;
        Thu, 30 Sep 2021 19:04:22 +0800 (CST)
Received: from dggpeml500025.china.huawei.com (7.185.36.35) by
 dggemv703-chm.china.huawei.com (10.3.19.46) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2308.8; Thu, 30 Sep 2021 19:05:42 +0800
Received: from [10.174.176.117] (10.174.176.117) by
 dggpeml500025.china.huawei.com (7.185.36.35) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2308.8; Thu, 30 Sep 2021 19:05:42 +0800
Subject: Re: [PATCH bpf-next 3/5] bpf: do .test_run in dummy BPF STRUCT_OPS
To:     Martin KaFai Lau <kafai@fb.com>
CC:     Alexei Starovoitov <ast@kernel.org>,
        Daniel Borkmann <daniel@iogearbox.net>,
        Andrii Nakryiko <andrii@kernel.org>, <netdev@vger.kernel.org>,
        <bpf@vger.kernel.org>
References: <20210928025228.88673-1-houtao1@huawei.com>
 <20210928025228.88673-4-houtao1@huawei.com>
 <20210929185541.cb5z2xnngqljkscu@kafai-mbp.dhcp.thefacebook.com>
From:   Hou Tao <houtao1@huawei.com>
Message-ID: <89ce4b1c-6ea6-80b9-ec2f-5a6d49dd591b@huawei.com>
Date:   Thu, 30 Sep 2021 19:05:41 +0800
User-Agent: Mozilla/5.0 (Windows NT 10.0; Win64; x64; rv:78.0) Gecko/20100101
 Thunderbird/78.6.0
MIME-Version: 1.0
In-Reply-To: <20210929185541.cb5z2xnngqljkscu@kafai-mbp.dhcp.thefacebook.com>
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Content-Language: en-US
X-Originating-IP: [10.174.176.117]
X-ClientProxiedBy: dggems703-chm.china.huawei.com (10.3.19.180) To
 dggpeml500025.china.huawei.com (7.185.36.35)
X-CFilter-Loop: Reflected
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Hi,

On 9/30/2021 2:55 AM, Martin KaFai Lau wrote:
> On Tue, Sep 28, 2021 at 10:52:26AM +0800, Hou Tao wrote:
>> Now only program for bpf_dummy_ops::init() is supported. The following
>> two cases are exercised in bpf_dummy_st_ops_test_run():
>>
>> (1) test and check the value returned from state arg in init(state)
>> The content of state is copied from data_in before calling init() and
>> copied back to data_out after calling, so test program could use
>> data_in to pass the input state and use data_out to get the
>> output state.
>>
>> (2) test and check the return value of init(NULL)
>> data_in_size is set as 0, so the state will be NULL and there will be
>> no copy-in & copy-out.
> Patch 1 and patch 3 in this set should be combined.
Will do. The purpose of splitting into two patches is that if only the return
value test is needed, patch 3 can be dropped. But now we will add more
tests, so i think combine two patches into one is OK.
>
>>  include/linux/bpf_dummy_ops.h  |  13 ++-
>>  net/bpf/bpf_dummy_struct_ops.c | 176 +++++++++++++++++++++++++++++++++
>>  2 files changed, 188 insertions(+), 1 deletion(-)
>>
>> diff --git a/include/linux/bpf_dummy_ops.h b/include/linux/bpf_dummy_ops.h
>> index a594ae830eba..5049484e6693 100644
>> --- a/include/linux/bpf_dummy_ops.h
>> +++ b/include/linux/bpf_dummy_ops.h
> The changes here seem not worth a new header file.
> Let see if they can be simplified and move the only needed things to bpf.h.
>
>> @@ -5,10 +5,21 @@
>>  #ifndef _BPF_DUMMY_OPS_H
>>  #define _BPF_DUMMY_OPS_H
>>  
>> -typedef int (*bpf_dummy_ops_init_t)(void);
>> +#include <linux/bpf.h>
>> +#include <linux/filter.h>
>> +
>> +struct bpf_dummy_ops_state {
>> +	int val;
>> +};
> This struct can be moved to net/bpf/bpf_dummy_struct_ops.c.
>
>> +
>> +typedef int (*bpf_dummy_ops_init_t)(struct bpf_dummy_ops_state *cb);
> If I read it correctly, the typedef is only useful in casting later.
> It would need another typedef in the future if new test function is added.
> Lets try to remove it (more on this later).
>
>>  
>>  struct bpf_dummy_ops {
>>  	bpf_dummy_ops_init_t init;
> "init" is a little confusing since it is not doing initialization.
> It is for testing purpose.  How about renaming it to test1, test2, test3...:
>
> 	int (*test1)(struct bpf_dummy_ops_state *cb);
>
> Also, it should at least add another function to test more
> arguments which is another limitation of testing with
> tcp_congestion_ops.
>
>>  };
> The whole struct bpf_dummy_ops can be moved to include/linux/bpf.h also
> next to where other bpf_struct_ops_*() functions are residing.
Will do. Thanks for your suggestions.
>
>>  
>> +extern int bpf_dummy_st_ops_test_run(struct bpf_prog *prog,
>> +				     const union bpf_attr *kattr,
>> +				     union bpf_attr __user *uattr);
> Same here.  It can be moved to include/linux/bpf.h and remove the
> "extern" also.
>
>> +
>>  #endif
>> diff --git a/net/bpf/bpf_dummy_struct_ops.c b/net/bpf/bpf_dummy_struct_ops.c
>> index 1249e4bb4ccb..da77736cd093 100644
>> --- a/net/bpf/bpf_dummy_struct_ops.c
>> +++ b/net/bpf/bpf_dummy_struct_ops.c
>> @@ -10,12 +10,188 @@
>>  
>>  extern struct bpf_struct_ops bpf_bpf_dummy_ops;
>>  
>> +static const struct btf_type *dummy_ops_state;
>> +
>> +static struct bpf_dummy_ops_state *
>> +init_dummy_ops_state(const union bpf_attr *kattr)
>> +{
>> +	__u32 size_in;
>> +	struct bpf_dummy_ops_state *state;
>> +	void __user *data_in;
>> +
>> +	size_in = kattr->test.data_size_in;
> These are the args for the test functions?  Using ctx_in/ctx_size_in
> and ctx_out/ctx_size_out instead should be more consistent
> with other bpf_prog_test_run* in test_run.c.
Yes, there are args. I had think about using ctx_in/ctx_out, but I didn't
because I thought the program which using ctx_in/ctx_out only has
one argument (namely bpf_context *), but the bpf_dummy_ops::init
may have multiple arguments. Anyway I will check it again and use
ctx_in/ctx_out if possible.

>
>> +	if (!size_in)
>> +		return NULL;
>> +
>> +	if (size_in != sizeof(*state))
>> +		return ERR_PTR(-EINVAL);
>> +
>> +	state = kzalloc(sizeof(*state), GFP_KERNEL);
>> +	if (!state)
>> +		return ERR_PTR(-ENOMEM);
>> +
>> +	data_in = u64_to_user_ptr(kattr->test.data_in);
>> +	if (copy_from_user(state, data_in, size_in)) {
>> +		kfree(state);
>> +		return ERR_PTR(-EFAULT);
>> +	}
>> +
>> +	return state;
>> +}
>> +
>> +static int copy_dummy_ops_state(struct bpf_dummy_ops_state *state,
>> +				const union bpf_attr *kattr,
>> +				union bpf_attr __user *uattr)
>> +{
>> +	int err = 0;
>> +	void __user *data_out;
>> +
>> +	if (!state)
>> +		return 0;
>> +
>> +	data_out = u64_to_user_ptr(kattr->test.data_out);
>> +	if (copy_to_user(data_out, state, sizeof(*state))) {
>> +		err = -EFAULT;
>> +		goto out;
> Directly return err;
Will do
>
>> +	}
>> +	if (put_user(sizeof(*state), &uattr->test.data_size_out)) {
>> +		err = -EFAULT;
>> +		goto out;
> Same here.
>
>> +	}
>> +out:
>> +	return err;
>> +}
>> +
>> +static inline void exit_dummy_ops_state(struct bpf_dummy_ops_state *state)
> static is good enough.  no need to inline.  Allow the compiler to decide.
>
>> +{
>> +	kfree(state);
> Probably just remove this helper function and directly call kfree instead.
>
> Could you help to check if bpf_ctx_init and bpf_ctx_finish can be directly
> reused instead?  I haven't looked at them closely to compare yet.
Will do.
>
>> +}
>> +
>> +int bpf_dummy_st_ops_test_run(struct bpf_prog *prog,
>> +			      const union bpf_attr *kattr,
>> +			      union bpf_attr __user *uattr)
>> +{
>> +	const struct bpf_struct_ops *st_ops = &bpf_bpf_dummy_ops;
>> +	struct bpf_dummy_ops_state *state = NULL;
>> +	struct bpf_tramp_progs *tprogs = NULL;
>> +	void *image = NULL;
>> +	int err;
>> +	int prog_ret;
>> +
>> +	/* Now only support to call init(...) */
>> +	if (prog->expected_attach_type != 0) {
>> +		err = -EOPNOTSUPP;
>> +		goto out;
>> +	}
>> +
>> +	/* state will be NULL when data_size_in == 0 */
>> +	state = init_dummy_ops_state(kattr);
>> +	if (IS_ERR(state)) {
>> +		err = PTR_ERR(state);
>> +		state = NULL;
>> +		goto out;
>> +	}
>> +
>> +	tprogs = kcalloc(BPF_TRAMP_MAX, sizeof(*tprogs), GFP_KERNEL);
>> +	if (!tprogs) {
>> +		err = -ENOMEM;
>> +		goto out;
>> +	}
>> +
>> +	image = bpf_jit_alloc_exec(PAGE_SIZE);
>> +	if (!image) {
>> +		err = -ENOMEM;
>> +		goto out;
>> +	}
>> +	set_vm_flush_reset_perms(image);
>> +
>> +	err = bpf_prepare_st_ops_prog(tprogs, prog, &st_ops->func_models[0],
>> +				      image, image + PAGE_SIZE);
>> +	if (err < 0)
>> +		goto out;
>> +
>> +	set_memory_ro((long)image, 1);
>> +	set_memory_x((long)image, 1);
>> +	prog_ret = ((bpf_dummy_ops_init_t)image)(state);
> I would do something like this to avoid creating the
> bpf_dummy_ops_init_t typedef.
>
> 	struct bpf_dummy_ops ops;
>
> 	ops.init = (void *)image;
> 	prog_ret = ops.init(state);
Good idea. Will do that.
>
>> +
>> +	err = copy_dummy_ops_state(state, kattr, uattr);
>> +	if (err)
>> +		goto out;
>> +	if (put_user(prog_ret, &uattr->test.retval))
>> +		err = -EFAULT;
>> +out:
>> +	exit_dummy_ops_state(state);
>> +	bpf_jit_free_exec(image);
>> +	kfree(tprogs);
>> +	return err;
>> +}
>> +
>>  static int bpf_dummy_init(struct btf *btf)
>>  {
>> +	s32 type_id;
>> +
>> +	type_id = btf_find_by_name_kind(btf, "bpf_dummy_ops_state",
>> +					BTF_KIND_STRUCT);
>> +	if (type_id < 0)
>> +		return -EINVAL;
>> +
>> +	dummy_ops_state = btf_type_by_id(btf, type_id);
>> +
>>  	return 0;
>>  }
>>  
>> +static bool bpf_dummy_ops_is_valid_access(int off, int size,
>> +					  enum bpf_access_type type,
>> +					  const struct bpf_prog *prog,
>> +					  struct bpf_insn_access_aux *info)
>> +{
>> +	/* init(state) only has one argument */
>> +	if (off || type != BPF_READ)
>> +		return false;
>> +
>> +	return btf_ctx_access(off, size, type, prog, info);
>> +}
>> +
>> +static int bpf_dummy_ops_btf_struct_access(struct bpf_verifier_log *log,
>> +					   const struct btf *btf,
>> +					   const struct btf_type *t, int off,
>> +					   int size, enum bpf_access_type atype,
>> +					   u32 *next_btf_id)
>> +{
>> +	size_t end;
>> +
>> +	if (atype == BPF_READ)
>> +		return btf_struct_access(log, btf, t, off, size, atype,
>> +					 next_btf_id);
>> +
>> +	if (t != dummy_ops_state) {
>> +		bpf_log(log, "only read is supported\n");
>> +		return -EACCES;
>> +	}
> The idea is to only allow writing to dummy_ops_state?
>
> How about something like this (uncompiled code):
>
> 	int ret;
>
> 	if (atype != BPF_READ && t != dummy_ops_state)
> 		return -EACCES;
>
> 	ret = btf_struct_access(log, btf, t, off, size, atype,
> 				next_btf_id);
> 	if (ret < 0)
> 		return ret;
>
> 	return atype == BPF_READ ? ret : NOT_INIT;
>
> Then the following switch and offset logic can go away.
Good idea. Will do that in v2.
>
>> +
>> +	switch (off) {
>> +	case offsetof(struct bpf_dummy_ops_state, val):
>> +		end = offsetofend(struct bpf_dummy_ops_state, val);
>> +		break;
>> +	default:
>> +		bpf_log(log, "no write support to bpf_dummy_ops_state at off %d\n",
>> +			off);
>> +		return -EACCES;
>> +	}
>> +
>> +	if (off + size > end) {
>> +		bpf_log(log,
>> +			"write access at off %d with size %d beyond the member of bpf_dummy_ops_state ended at %zu\n",
>> +			off, size, end);
>> +		return -EACCES;
>> +	}
>> +
>> +	return NOT_INIT;
>> +}
>> +
>>  static const struct bpf_verifier_ops bpf_dummy_verifier_ops = {
>> +	.is_valid_access = bpf_dummy_ops_is_valid_access,
>> +	.btf_struct_access = bpf_dummy_ops_btf_struct_access,
>>  };
>>  
>>  static int bpf_dummy_init_member(const struct btf_type *t,
>> -- 
>> 2.29.2
>>
> .

