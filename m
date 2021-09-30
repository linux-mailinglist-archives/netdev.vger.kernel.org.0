Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 9E4FA41D782
	for <lists+netdev@lfdr.de>; Thu, 30 Sep 2021 12:17:53 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1349874AbhI3KTY (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 30 Sep 2021 06:19:24 -0400
Received: from szxga03-in.huawei.com ([45.249.212.189]:24206 "EHLO
        szxga03-in.huawei.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1349867AbhI3KTS (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 30 Sep 2021 06:19:18 -0400
Received: from dggemv704-chm.china.huawei.com (unknown [172.30.72.55])
        by szxga03-in.huawei.com (SkyGuard) with ESMTP id 4HKq0T2YPVz8tWh;
        Thu, 30 Sep 2021 18:16:41 +0800 (CST)
Received: from dggpeml500025.china.huawei.com (7.185.36.35) by
 dggemv704-chm.china.huawei.com (10.3.19.47) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2308.8; Thu, 30 Sep 2021 18:17:34 +0800
Received: from [10.174.176.117] (10.174.176.117) by
 dggpeml500025.china.huawei.com (7.185.36.35) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2308.8; Thu, 30 Sep 2021 18:17:34 +0800
Subject: Re: [PATCH bpf-next 2/5] bpf: factor out a helper to prepare
 trampoline for struct_ops prog
To:     Martin KaFai Lau <kafai@fb.com>
CC:     Alexei Starovoitov <ast@kernel.org>,
        Daniel Borkmann <daniel@iogearbox.net>,
        Andrii Nakryiko <andrii@kernel.org>, <netdev@vger.kernel.org>,
        <bpf@vger.kernel.org>
References: <20210928025228.88673-1-houtao1@huawei.com>
 <20210928025228.88673-3-houtao1@huawei.com>
 <20210929175620.yi4jfpllhugys6eo@kafai-mbp.dhcp.thefacebook.com>
From:   Hou Tao <houtao1@huawei.com>
Message-ID: <74247c43-39df-6872-4de6-8f4136ac37cd@huawei.com>
Date:   Thu, 30 Sep 2021 18:17:33 +0800
User-Agent: Mozilla/5.0 (Windows NT 10.0; Win64; x64; rv:78.0) Gecko/20100101
 Thunderbird/78.6.0
MIME-Version: 1.0
In-Reply-To: <20210929175620.yi4jfpllhugys6eo@kafai-mbp.dhcp.thefacebook.com>
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Content-Language: en-US
X-Originating-IP: [10.174.176.117]
X-ClientProxiedBy: dggems705-chm.china.huawei.com (10.3.19.182) To
 dggpeml500025.china.huawei.com (7.185.36.35)
X-CFilter-Loop: Reflected
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Hi

On 9/30/2021 1:56 AM, Martin KaFai Lau wrote:
> On Tue, Sep 28, 2021 at 10:52:25AM +0800, Hou Tao wrote:
>> Factor out a helper bpf_prepare_st_ops_prog() to prepare trampoline
>> for BPF_PROG_TYPE_STRUCT_OPS prog. It will be used by .test_run
>> callback in following patch.
> Thanks for the patches.
Thanks for you review.
>
> This preparation change should be the first patch instead.
Will do.
>
>> diff --git a/include/linux/bpf.h b/include/linux/bpf.h
>> index 155dfcfb8923..002bbb2c8bc7 100644
>> --- a/include/linux/bpf.h
>> +++ b/include/linux/bpf.h
>> @@ -2224,4 +2224,9 @@ int bpf_bprintf_prepare(char *fmt, u32 fmt_size, const u64 *raw_args,
>>  			u32 **bin_buf, u32 num_args);
>>  void bpf_bprintf_cleanup(void);
>>  
>> +int bpf_prepare_st_ops_prog(struct bpf_tramp_progs *tprogs,
>> +			    struct bpf_prog *prog,
>> +			    const struct btf_func_model *model,
>> +			    void *image, void *image_end);
> Move it under where other bpf_struct_ops_.*() resides in bpf.h.
>
>> +
>>  #endif /* _LINUX_BPF_H */
>> diff --git a/kernel/bpf/bpf_struct_ops.c b/kernel/bpf/bpf_struct_ops.c
>> index 9abcc33f02cf..ec3c25174923 100644
>> --- a/kernel/bpf/bpf_struct_ops.c
>> +++ b/kernel/bpf/bpf_struct_ops.c
>> @@ -312,6 +312,20 @@ static int check_zero_holes(const struct btf_type *t, void *data)
>>  	return 0;
>>  }
>>  
>> +int bpf_prepare_st_ops_prog(struct bpf_tramp_progs *tprogs,
>> +			    struct bpf_prog *prog,
>> +			    const struct btf_func_model *model,
>> +			    void *image, void *image_end)
> The existing struct_ops functions in the kernel now have naming like
> bpf_struct_ops_.*().  How about renaming it to
> bpf_struct_ops_prepare_trampoline()?
bpf_struct_ops_prepare_trampoline() may be a little long, and it will make
the indentations of its parameters look ugly, so how about
bpf_struct_ops_prep_prog() ?
>
>> +{
>> +	u32 flags;
>> +
>> +	tprogs[BPF_TRAMP_FENTRY].progs[0] = prog;
>> +	tprogs[BPF_TRAMP_FENTRY].nr_progs = 1;
>> +	flags = model->ret_size > 0 ? BPF_TRAMP_F_RET_FENTRY_RET : 0;
>> +	return arch_prepare_bpf_trampoline(NULL, image, image_end,
>> +					   model, flags, tprogs, NULL);
>> +}
>> +
>>  static int bpf_struct_ops_map_update_elem(struct bpf_map *map, void *key,
>>  					  void *value, u64 flags)
>>  {
>> @@ -368,7 +382,6 @@ static int bpf_struct_ops_map_update_elem(struct bpf_map *map, void *key,
>>  		const struct btf_type *mtype, *ptype;
>>  		struct bpf_prog *prog;
>>  		u32 moff;
>> -		u32 flags;
>>  
>>  		moff = btf_member_bit_offset(t, member) / 8;
>>  		ptype = btf_type_resolve_ptr(btf_vmlinux, member->type, NULL);
>> @@ -430,14 +443,9 @@ static int bpf_struct_ops_map_update_elem(struct bpf_map *map, void *key,
>>  			goto reset_unlock;
>>  		}
>>  
>> -		tprogs[BPF_TRAMP_FENTRY].progs[0] = prog;
>> -		tprogs[BPF_TRAMP_FENTRY].nr_progs = 1;
>> -		flags = st_ops->func_models[i].ret_size > 0 ?
>> -			BPF_TRAMP_F_RET_FENTRY_RET : 0;
> This change can't apply to bpf-next now because
> commit 356ed64991c6 ("bpf: Handle return value of BPF_PROG_TYPE_STRUCT_OPS prog")
> is not pulled into bpf-next yet.  Please mention the dependency
> in the cover letter if it is still the case in v2.
Thanks for the reminder. Will do.
>
>> -		err = arch_prepare_bpf_trampoline(NULL, image,
>> -						  st_map->image + PAGE_SIZE,
>> -						  &st_ops->func_models[i],
>> -						  flags, tprogs, NULL);
>> +		err = bpf_prepare_st_ops_prog(tprogs, prog,
>> +					      &st_ops->func_models[i],
>> +					      image, st_map->image + PAGE_SIZE);
>>  		if (err < 0)
>>  			goto reset_unlock;
>>  
>> -- 
>> 2.29.2
>>
> .

