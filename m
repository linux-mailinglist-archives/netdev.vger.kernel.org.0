Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 2AB193CC07B
	for <lists+netdev@lfdr.de>; Sat, 17 Jul 2021 03:19:53 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232787AbhGQBSu (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 16 Jul 2021 21:18:50 -0400
Received: from out30-130.freemail.mail.aliyun.com ([115.124.30.130]:43251 "EHLO
        out30-130.freemail.mail.aliyun.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S229753AbhGQBSt (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 16 Jul 2021 21:18:49 -0400
X-Alimail-AntiSpam: AC=PASS;BC=-1|-1;BR=01201311R131e4;CH=green;DM=||false|;DS=||;FP=0|-1|-1|-1|0|-1|-1|-1;HT=e01e04420;MF=chengshuyi@linux.alibaba.com;NM=1;PH=DS;RN=13;SR=0;TI=SMTPD_---0Ug.os52_1626484550;
Received: from B-39YZML7H-2200.local(mailfrom:chengshuyi@linux.alibaba.com fp:SMTPD_---0Ug.os52_1626484550)
          by smtp.aliyun-inc.com(127.0.0.1);
          Sat, 17 Jul 2021 09:15:50 +0800
Subject: Re: [PATCH bpf-next v4 1/3] libbpf: Introduce 'btf_custom_path' to
 'bpf_obj_open_opts'
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
References: <1626180159-112996-1-git-send-email-chengshuyi@linux.alibaba.com>
 <1626180159-112996-2-git-send-email-chengshuyi@linux.alibaba.com>
 <CAEf4BzawyyJ0hhvmSM8ba817VffOV2O3qG49fqh+VFseiixigA@mail.gmail.com>
From:   Shuyi Cheng <chengshuyi@linux.alibaba.com>
Message-ID: <0fa3b7f1-7928-eff9-1644-df3384171bcd@linux.alibaba.com>
Date:   Sat, 17 Jul 2021 09:15:50 +0800
User-Agent: Mozilla/5.0 (Macintosh; Intel Mac OS X 10.15; rv:78.0)
 Gecko/20100101 Thunderbird/78.11.0
MIME-Version: 1.0
In-Reply-To: <CAEf4BzawyyJ0hhvmSM8ba817VffOV2O3qG49fqh+VFseiixigA@mail.gmail.com>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org



On 7/16/21 12:51 PM, Andrii Nakryiko wrote:
> On Tue, Jul 13, 2021 at 5:43 AM Shuyi Cheng
> <chengshuyi@linux.alibaba.com> wrote:
>>
>> btf_custom_path allows developers to load custom BTF, and subsequent
>> CO-RE will use custom BTF for relocation.
>>
>> Learn from Andrii's comments in [0], add the btf_custom_path parameter
>> to bpf_obj_open_opts, you can directly use the skeleton's
>> <objname>_bpf__open_opts function to pass in the btf_custom_path
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
>>   tools/lib/bpf/libbpf.c | 36 ++++++++++++++++++++++++++++++------
>>   tools/lib/bpf/libbpf.h |  9 ++++++++-
>>   2 files changed, 38 insertions(+), 7 deletions(-)
>>
>> diff --git a/tools/lib/bpf/libbpf.c b/tools/lib/bpf/libbpf.c
>> index 1e04ce7..6e11a7b 100644
>> --- a/tools/lib/bpf/libbpf.c
>> +++ b/tools/lib/bpf/libbpf.c
>> @@ -498,6 +498,13 @@ struct bpf_object {
>>           * it at load time.
>>           */
>>          struct btf *btf_vmlinux;
>> +       /* Path to the custom BTF to be used for BPF CO-RE relocations.
>> +        * This custom BTF completely replaces the use of vmlinux BTF
>> +        * for the purpose of CO-RE relocations.
>> +        * NOTE: any other BPF feature (e.g., fentry/fexit programs,
>> +        * struct_ops, etc) will need actual kernel BTF at /sys/kernel/btf/vmlinux.
>> +        */
> 
> this comment completely duplicates the one from bpf_object_open_opts,
> I'll remove or shorten it
> 
>> +       char *btf_custom_path;
>>          /* vmlinux BTF override for CO-RE relocations */
>>          struct btf *btf_vmlinux_override;
>>          /* Lazily initialized kernel module BTFs */
>> @@ -2645,10 +2652,6 @@ static bool obj_needs_vmlinux_btf(const struct bpf_object *obj)
>>          struct bpf_program *prog;
>>          int i;
>>
>> -       /* CO-RE relocations need kernel BTF */
>> -       if (obj->btf_ext && obj->btf_ext->core_relo_info.len)
>> -               return true;
>> -
>>          /* Support for typed ksyms needs kernel BTF */
>>          for (i = 0; i < obj->nr_extern; i++) {
>>                  const struct extern_desc *ext;
>> @@ -2665,6 +2668,13 @@ static bool obj_needs_vmlinux_btf(const struct bpf_object *obj)
>>                          return true;
>>          }
>>
>> +       /* CO-RE relocations need kernel BTF, only when btf_custom_path
>> +        * is not specified
>> +        */
>> +       if (obj->btf_ext && obj->btf_ext->core_relo_info.len
>> +               && !obj->btf_custom_path)
>> +               return true;
> 
> not sure why you moved it, I'll move it back to minimize code churn

You're right. 👍

regards,
Shuyi
> 
>> +
>>          return false;
>>   }
>>
> 
> [...]
> 
