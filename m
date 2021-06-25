Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 227023B3ABB
	for <lists+netdev@lfdr.de>; Fri, 25 Jun 2021 04:05:29 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233066AbhFYCHr (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 24 Jun 2021 22:07:47 -0400
Received: from out30-57.freemail.mail.aliyun.com ([115.124.30.57]:51724 "EHLO
        out30-57.freemail.mail.aliyun.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S232942AbhFYCHp (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 24 Jun 2021 22:07:45 -0400
X-Alimail-AntiSpam: AC=PASS;BC=-1|-1;BR=01201311R641e4;CH=green;DM=||false|;DS=||;FP=0|-1|-1|-1|0|-1|-1|-1;HT=e01e04426;MF=chengshuyi@linux.alibaba.com;NM=1;PH=DS;RN=12;SR=0;TI=SMTPD_---0UdZHJqO_1624586721;
Received: from B-39YZML7H-2200.local(mailfrom:chengshuyi@linux.alibaba.com fp:SMTPD_---0UdZHJqO_1624586721)
          by smtp.aliyun-inc.com(127.0.0.1);
          Fri, 25 Jun 2021 10:05:22 +0800
Subject: Re: [PATCH bpf-next] libbpf: Introduce 'custom_btf_path' to
 'bpf_obj_open_opts'.
To:     Daniel Borkmann <daniel@iogearbox.net>, ast@kernel.org,
        andrii@kernel.org, kafai@fb.com, songliubraving@fb.com, yhs@fb.com,
        john.fastabend@gmail.com, kpsingh@kernel.org
Cc:     netdev@vger.kernel.org, bpf@vger.kernel.org,
        linux-kernel@vger.kernel.org, kernel-janitors@vger.kernel.org
References: <1624507409-114522-1-git-send-email-chengshuyi@linux.alibaba.com>
 <8ca15bab-ec66-657d-570a-278deff0b1a3@iogearbox.net>
From:   Shuyi Cheng <chengshuyi@linux.alibaba.com>
Message-ID: <e8a17455-e3e7-d259-b7ae-154cfa6f1a0a@linux.alibaba.com>
Date:   Fri, 25 Jun 2021 10:05:19 +0800
User-Agent: Mozilla/5.0 (Macintosh; Intel Mac OS X 10.15; rv:78.0)
 Gecko/20100101 Thunderbird/78.11.0
MIME-Version: 1.0
In-Reply-To: <8ca15bab-ec66-657d-570a-278deff0b1a3@iogearbox.net>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org



On 6/24/21 11:06 PM, Daniel Borkmann wrote:
> On 6/24/21 6:03 AM, Shuyi Cheng wrote:
>> In order to enable the older kernel to use the CO-RE feature, load the
>> vmlinux btf of the specified path.
>>
>> Learn from Andrii's comments in [0], add the custom_btf_path parameter
>> to bpf_obj_open_opts, you can directly use the skeleton's
>> <objname>_bpf__open_opts function to pass in the custom_btf_path
>> parameter.
>>
>> Prior to this, there was also a developer who provided a patch with
>> similar functions. It is a pity that the follow-up did not continue to
>> advance. See [1].
>>
>>     [0]https://lore.kernel.org/bpf/CAEf4BzbJZLjNoiK8_VfeVg_Vrg=9iYFv+po-38SMe=UzwDKJ=Q@mail.gmail.com/#t 
>>
>>     [1]https://yhbt.net/lore/all/CAEf4Bzbgw49w2PtowsrzKQNcxD4fZRE6AKByX-5-dMo-+oWHHA@mail.gmail.com/ 
>>
>>
>> Signed-off-by: Shuyi Cheng <chengshuyi@linux.alibaba.com>
>> ---
>>   tools/lib/bpf/libbpf.c | 23 ++++++++++++++++++++---
>>   tools/lib/bpf/libbpf.h |  6 +++++-
>>   2 files changed, 25 insertions(+), 4 deletions(-)
>>
>> diff --git a/tools/lib/bpf/libbpf.c b/tools/lib/bpf/libbpf.c
>> index 1e04ce7..518b19f 100644
>> --- a/tools/lib/bpf/libbpf.c
>> +++ b/tools/lib/bpf/libbpf.c
>> @@ -509,6 +509,8 @@ struct bpf_object {
>>       void *priv;
>>       bpf_object_clear_priv_t clear_priv;
>> +    char *custom_btf_path;
>> +
> 
> nit: This should rather go to the 'Parse and load BTF vmlinux if any of 
> [...]'
> section of struct bpf_object, and for consistency, I'd keep the btf_ 
> prefix,
> like: char *btf_custom_path
> 

Thank you very much for your reply.

Agree.


>>       char path[];
>>   };
>>   #define obj_elf_valid(o)    ((o)->efile.elf)
>> @@ -2679,8 +2681,15 @@ static int bpf_object__load_vmlinux_btf(struct 
>> bpf_object *obj, bool force)
>>       if (!force && !obj_needs_vmlinux_btf(obj))
>>           return 0;
>> -    obj->btf_vmlinux = libbpf_find_kernel_btf();
>> -    err = libbpf_get_error(obj->btf_vmlinux);
>> +    if (obj->custom_btf_path) {
>> +        obj->btf_vmlinux = btf__parse(obj->custom_btf_path, NULL);
>> +        err = libbpf_get_error(obj->btf_vmlinux);
>> +        pr_debug("loading custom vmlinux BTF '%s': %d\n", 
>> obj->custom_btf_path, err);
>> +    } else {
>> +        obj->btf_vmlinux = libbpf_find_kernel_btf();
>> +        err = libbpf_get_error(obj->btf_vmlinux);
>> +    }
> 
> Couldn't we do something like (only compile-tested):
> 

Your approach is very inspiring to me. But I did it for two reasons.

1. When the developer specifies btf_custom_path, btf should only be 
loaded from btf_custom_path;
2. Now pahole supports saving vmlinux's btf in raw format, so the old 
kernel can provide btf in elf format or raw format. see [0].

	[0] 
https://git.kernel.org/pub/scm/devel/pahole/pahole.git/tree/pahole.c#n1157

What do you think?
	
Regards,
Shuyi

> diff --git a/tools/lib/bpf/btf.c b/tools/lib/bpf/btf.c
> index b46760b93bb4..5b88ce3e483c 100644
> --- a/tools/lib/bpf/btf.c
> +++ b/tools/lib/bpf/btf.c
> @@ -4394,7 +4394,7 @@ static int btf_dedup_remap_types(struct btf_dedup *d)
>    * Probe few well-known locations for vmlinux kernel image and try to 
> load BTF
>    * data out of it to use for target BTF.
>    */
> -struct btf *libbpf_find_kernel_btf(void)
> +static struct btf *__libbpf_find_kernel_btf(char *btf_custom_path)
>   {
>       struct {
>           const char *path_fmt;
> @@ -4402,6 +4402,8 @@ struct btf *libbpf_find_kernel_btf(void)
>       } locations[] = {
>           /* try canonical vmlinux BTF through sysfs first */
>           { "/sys/kernel/btf/vmlinux", true /* raw BTF */ },
> +        /* try user defined vmlinux ELF if a path was specified */
> +        { btf_custom_path },
>           /* fall back to trying to find vmlinux ELF on disk otherwise */
>           { "/boot/vmlinux-%1$s" },
>           { "/lib/modules/%1$s/vmlinux-%1$s" },
> @@ -4419,11 +4421,11 @@ struct btf *libbpf_find_kernel_btf(void)
>       uname(&buf);
> 
>       for (i = 0; i < ARRAY_SIZE(locations); i++) {
> +        if (!locations[i].path_fmt)
> +            continue;
>           snprintf(path, PATH_MAX, locations[i].path_fmt, buf.release);
> -
>           if (access(path, R_OK))
>               continue;
> -
>           if (locations[i].raw_btf)
>               btf = btf__parse_raw(path);
>           else
> @@ -4440,6 +4442,11 @@ struct btf *libbpf_find_kernel_btf(void)
>       return libbpf_err_ptr(-ESRCH);
>   }
> 
> +struct btf *libbpf_find_kernel_btf(void)
> +{
> +    return __libbpf_find_kernel_btf(NULL);
> +}
> +
>   int btf_type_visit_type_ids(struct btf_type *t, type_id_visit_fn 
> visit, void *ctx)
>   {
>       int i, n, err;
> 
> And then you just call it as:
> 
>      obj->btf_vmlinux = __libbpf_find_kernel_btf(obj->btf_custom_path);
>      err = libbpf_get_error(obj->btf_vmlinux);
> 
>>       if (err) {
>>           pr_warn("Error loading vmlinux BTF: %d\n", err);
>>           obj->btf_vmlinux = NULL;

