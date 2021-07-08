Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 6283B3C13F5
	for <lists+netdev@lfdr.de>; Thu,  8 Jul 2021 15:12:02 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231893AbhGHNOm (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 8 Jul 2021 09:14:42 -0400
Received: from out30-133.freemail.mail.aliyun.com ([115.124.30.133]:54958 "EHLO
        out30-133.freemail.mail.aliyun.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S230080AbhGHNOl (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 8 Jul 2021 09:14:41 -0400
X-Alimail-AntiSpam: AC=PASS;BC=-1|-1;BR=01201311R211e4;CH=green;DM=||false|;DS=||;FP=0|-1|-1|-1|0|-1|-1|-1;HT=e01e04420;MF=chengshuyi@linux.alibaba.com;NM=1;PH=DS;RN=13;SR=0;TI=SMTPD_---0Uf7DnS._1625749917;
Received: from B-39YZML7H-2200.local(mailfrom:chengshuyi@linux.alibaba.com fp:SMTPD_---0Uf7DnS._1625749917)
          by smtp.aliyun-inc.com(127.0.0.1);
          Thu, 08 Jul 2021 21:11:57 +0800
Subject: Re: [PATCH bpf-next] libbpf: Introduce 'custom_btf_path' to
 'bpf_obj_open_opts'.
To:     Andrii Nakryiko <andrii.nakryiko@gmail.com>
Cc:     Alexei Starovoitov <ast@kernel.org>,
        Daniel Borkmann <daniel@iogearbox.net>,
        Andrii Nakryiko <andrii@kernel.org>, Martin Lau <kafai@fb.com>,
        Song Liu <songliubraving@fb.com>, Yonghong Song <yhs@fb.com>,
        john fastabend <john.fastabend@gmail.com>,
        KP Singh <kpsingh@kernel.org>,
        Networking <netdev@vger.kernel.org>, bpf <bpf@vger.kernel.org>,
        open list <linux-kernel@vger.kernel.org>,
        kernel-janitors@vger.kernel.org
References: <1624507409-114522-1-git-send-email-chengshuyi@linux.alibaba.com>
 <CAEf4BzaGjEC4t1OefDo11pj2-HfNy0BLhs_G2UREjRNTmb2u=A@mail.gmail.com>
From:   Shuyi Cheng <chengshuyi@linux.alibaba.com>
Message-ID: <ffc9000c-a3c1-c989-5bb1-c0b805fb8f50@linux.alibaba.com>
Date:   Thu, 8 Jul 2021 21:11:56 +0800
User-Agent: Mozilla/5.0 (Macintosh; Intel Mac OS X 10.15; rv:78.0)
 Gecko/20100101 Thunderbird/78.11.0
MIME-Version: 1.0
In-Reply-To: <CAEf4BzaGjEC4t1OefDo11pj2-HfNy0BLhs_G2UREjRNTmb2u=A@mail.gmail.com>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org



On 7/8/21 4:52 AM, Andrii Nakryiko wrote:
> On Wed, Jun 23, 2021 at 9:04 PM Shuyi Cheng
> <chengshuyi@linux.alibaba.com> wrote:
>>
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
>>          [0]https://lore.kernel.org/bpf/CAEf4BzbJZLjNoiK8_VfeVg_Vrg=9iYFv+po-38SMe=UzwDKJ=Q@mail.gmail.com/#t
>>          [1]https://yhbt.net/lore/all/CAEf4Bzbgw49w2PtowsrzKQNcxD4fZRE6AKByX-5-dMo-+oWHHA@mail.gmail.com/
>>
>> Signed-off-by: Shuyi Cheng <chengshuyi@linux.alibaba.com>
>> ---
>>   tools/lib/bpf/libbpf.c | 23 ++++++++++++++++++++---
>>   tools/lib/bpf/libbpf.h |  6 +++++-
>>   2 files changed, 25 insertions(+), 4 deletions(-)
>>
>> diff --git a/tools/lib/bpf/libbpf.c b/tools/lib/bpf/libbpf.c
>> index 1e04ce7..518b19f 100644
>> --- a/tools/lib/bpf/libbpf.c
>> +++ b/tools/lib/bpf/libbpf.c
>> @@ -509,6 +509,8 @@ struct bpf_object {
>>          void *priv;
>>          bpf_object_clear_priv_t clear_priv;
>>
>> +       char *custom_btf_path;
>> +
>>          char path[];
>>   };
>>   #define obj_elf_valid(o)       ((o)->efile.elf)
>> @@ -2679,8 +2681,15 @@ static int bpf_object__load_vmlinux_btf(struct bpf_object *obj, bool force)
>>          if (!force && !obj_needs_vmlinux_btf(obj))
>>                  return 0;
>>
>> -       obj->btf_vmlinux = libbpf_find_kernel_btf();
>> -       err = libbpf_get_error(obj->btf_vmlinux);
>> +       if (obj->custom_btf_path) {
>> +               obj->btf_vmlinux = btf__parse(obj->custom_btf_path, NULL);
>> +               err = libbpf_get_error(obj->btf_vmlinux);
>> +               pr_debug("loading custom vmlinux BTF '%s': %d\n", obj->custom_btf_path, err);
>> +       } else {
>> +               obj->btf_vmlinux = libbpf_find_kernel_btf();
>> +               err = libbpf_get_error(obj->btf_vmlinux);
>> +       }
> 
> 
> I think it will be more flexible to treat custom_btf as an vmlinux BTF
> override, just like [1] did. I can see how in some situations users
> might want to treat this custom BTF as either a replacement of vmlinux
> BTF or as an augmentation of vmlinux BTF for the purpose of extra
> custom CO-RE relocations (e.g., something along the XDP hints that
> were discussed recently). For now it's probably enough to implement
> "custom BTF is a replacement for vmlinux BTF" policy and, if
> necessary, add "custom BTF is in addition to vmlinux BTF" later with
> extra opts flag/field.
>

Thank you very much for your reply.

So this part of the code remains the same, right?


> Keep in mind that this custom BTF is only useful for BPF CO-RE
> relocation. Any other kernel feature relying on vmlinux BTF (e.g.,
> fentry) won't work with custom BTF because it expects correct BTF type
> IDs.
> 
> 
>> +
>>          if (err) {
>>                  pr_warn("Error loading vmlinux BTF: %d\n", err);
>>                  obj->btf_vmlinux = NULL;
>> @@ -7554,7 +7563,7 @@ int bpf_program__load(struct bpf_program *prog, char *license, __u32 kern_ver)
>>   __bpf_object__open(const char *path, const void *obj_buf, size_t obj_buf_sz,
>>                     const struct bpf_object_open_opts *opts)
>>   {
>> -       const char *obj_name, *kconfig;
>> +       const char *obj_name, *kconfig, *tmp_btf_path;
>>          struct bpf_program *prog;
>>          struct bpf_object *obj;
>>          char tmp_name[64];
>> @@ -7584,6 +7593,13 @@ int bpf_program__load(struct bpf_program *prog, char *license, __u32 kern_ver)
>>          obj = bpf_object__new(path, obj_buf, obj_buf_sz, obj_name);
>>          if (IS_ERR(obj))
>>                  return obj;
>> +
>> +       tmp_btf_path = OPTS_GET(opts, custom_btf_path, NULL);
>> +       if (tmp_btf_path && strlen(tmp_btf_path) < PATH_MAX) {
> 
> if strlen() is >= PATH_MAX you'll just silently ignore it? We should
> either truncate silently (because PATH_MAX is totally reasonable
> assumption) or error out.

Agree. I will send the second version of the patch.

Regards,
Shuyi


> 
>> +               obj->custom_btf_path = strdup(tmp_btf_path);
>> +               if (!obj->custom_btf_path)
>> +                       return ERR_PTR(-ENOMEM);
>> +       }
>>
>>          kconfig = OPTS_GET(opts, kconfig, NULL);
>>          if (kconfig) {
>> @@ -8702,6 +8718,7 @@ void bpf_object__close(struct bpf_object *obj)
>>          for (i = 0; i < obj->nr_maps; i++)
>>                  bpf_map__destroy(&obj->maps[i]);
>>
>> +       zfree(&obj->custom_btf_path);
>>          zfree(&obj->kconfig);
>>          zfree(&obj->externs);
>>          obj->nr_extern = 0;
>> diff --git a/tools/lib/bpf/libbpf.h b/tools/lib/bpf/libbpf.h
>> index 6e61342..16e0f01 100644
>> --- a/tools/lib/bpf/libbpf.h
>> +++ b/tools/lib/bpf/libbpf.h
>> @@ -94,8 +94,12 @@ struct bpf_object_open_opts {
>>           * system Kconfig for CONFIG_xxx externs.
>>           */
>>          const char *kconfig;
>> +       /* Specify the path of vmlinux btf to facilitate the use of CO-RE features
>> +        * in the old kernel.
>> +        */
>> +       char *custom_btf_path;
>>   };
>> -#define bpf_object_open_opts__last_field kconfig
>> +#define bpf_object_open_opts__last_field custom_btf_path
>>
>>   LIBBPF_API struct bpf_object *bpf_object__open(const char *path);
>>   LIBBPF_API struct bpf_object *
>> --
>> 1.8.3.1
>>
