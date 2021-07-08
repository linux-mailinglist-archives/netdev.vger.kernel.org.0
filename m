Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id AE3743BF429
	for <lists+netdev@lfdr.de>; Thu,  8 Jul 2021 05:00:47 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230359AbhGHDDY (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 7 Jul 2021 23:03:24 -0400
Received: from szxga02-in.huawei.com ([45.249.212.188]:10429 "EHLO
        szxga02-in.huawei.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230201AbhGHDDY (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 7 Jul 2021 23:03:24 -0400
Received: from dggeme751-chm.china.huawei.com (unknown [172.30.72.56])
        by szxga02-in.huawei.com (SkyGuard) with ESMTP id 4GL1DS0scPzZqyG;
        Thu,  8 Jul 2021 10:57:28 +0800 (CST)
Received: from [10.67.110.55] (10.67.110.55) by dggeme751-chm.china.huawei.com
 (10.3.19.97) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_128_CBC_SHA256_P256) id 15.1.2176.2; Thu, 8 Jul
 2021 11:00:39 +0800
From:   He Fengqing <hefengqing@huawei.com>
Subject: Re: [bpf-next 3/3] bpf: Fix a use after free in bpf_check()
To:     Song Liu <song@kernel.org>
CC:     Alexei Starovoitov <ast@kernel.org>,
        Daniel Borkmann <daniel@iogearbox.net>,
        Andrii Nakryiko <andrii@kernel.org>,
        Martin KaFai Lau <kafai@fb.com>,
        Song Liu <songliubraving@fb.com>, Yonghong Song <yhs@fb.com>,
        John Fastabend <john.fastabend@gmail.com>,
        KP Singh <kpsingh@kernel.org>,
        "David S . Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>,
        Networking <netdev@vger.kernel.org>, bpf <bpf@vger.kernel.org>,
        open list <linux-kernel@vger.kernel.org>
References: <20210707043811.5349-1-hefengqing@huawei.com>
 <20210707043811.5349-4-hefengqing@huawei.com>
 <CAPhsuW7ssFzvS5-kdZa3tY-2EJk8QUdVpQCJYVBr+vD11JzrsQ@mail.gmail.com>
Message-ID: <1c5b393d-6848-3d10-30cf-7063a331f76c@huawei.com>
Date:   Thu, 8 Jul 2021 11:00:39 +0800
User-Agent: Mozilla/5.0 (Windows NT 10.0; Win64; x64; rv:78.0) Gecko/20100101
 Thunderbird/78.7.0
MIME-Version: 1.0
In-Reply-To: <CAPhsuW7ssFzvS5-kdZa3tY-2EJk8QUdVpQCJYVBr+vD11JzrsQ@mail.gmail.com>
Content-Type: text/plain; charset="utf-8"; format=flowed
Content-Transfer-Encoding: 8bit
X-Originating-IP: [10.67.110.55]
X-ClientProxiedBy: dggeme714-chm.china.huawei.com (10.1.199.110) To
 dggeme751-chm.china.huawei.com (10.3.19.97)
X-CFilter-Loop: Reflected
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org



在 2021/7/7 15:25, Song Liu 写道:
> On Tue, Jul 6, 2021 at 8:53 PM He Fengqing <hefengqing@huawei.com> wrote:
>>
>> In bpf_patch_insn_data, env->prog was input parameter of
>> bpf_patch_insn_single function. bpf_patch_insn_single call
>> bpf_prog_realloc to realloc ebpf prog. When we need to malloc new prog,
>> bpf_prog_realloc will free the old prog, in this scenery is the
>> env->prog.
>> Then bpf_patch_insn_data function call adjust_insn_aux_data function, if
>> adjust_insn_aux_data function return error, bpf_patch_insn_data will
>> return NULL.
>> In bpf_check->convert_ctx_accesses->bpf_patch_insn_data call chain, if
>> bpf_patch_insn_data return NULL, env->prog has been freed in
>> bpf_prog_realloc, then bpf_check will use the freed env->prog.
> 
> Besides "what is the bug", please also describe "how to fix it". For example,
> add "Fix it by adding a free_old argument to bpf_prog_realloc(), and ...".
> Also, for the subject of 0/3, it is better to say "fix potential
> memory leak and ...".

Thanks for your suggestion.

> 
>>
>> Signed-off-by: He Fengqing <hefengqing@huawei.com>
>> ---
>>   include/linux/filter.h |  2 +-
>>   kernel/bpf/core.c      |  9 ++++---
>>   kernel/bpf/verifier.c  | 53 ++++++++++++++++++++++++++++++++----------
>>   net/core/filter.c      |  2 +-
>>   4 files changed, 49 insertions(+), 17 deletions(-)
>>
>> diff --git a/include/linux/filter.h b/include/linux/filter.h
>> index f39e008a377d..ec11a5ae92c2 100644
>> --- a/include/linux/filter.h
>> +++ b/include/linux/filter.h
>> @@ -881,7 +881,7 @@ void bpf_prog_jit_attempt_done(struct bpf_prog *prog);
>>   struct bpf_prog *bpf_prog_alloc(unsigned int size, gfp_t gfp_extra_flags);
>>   struct bpf_prog *bpf_prog_alloc_no_stats(unsigned int size, gfp_t gfp_extra_flags);
>>   struct bpf_prog *bpf_prog_realloc(struct bpf_prog *fp_old, unsigned int size,
>> -                                 gfp_t gfp_extra_flags);
>> +                                 gfp_t gfp_extra_flags, bool free_old);
>>   void __bpf_prog_free(struct bpf_prog *fp);
>>
>>   static inline void bpf_prog_clone_free(struct bpf_prog *fp)
>> diff --git a/kernel/bpf/core.c b/kernel/bpf/core.c
>> index 49b0311f48c1..e5616bb1665b 100644
>> --- a/kernel/bpf/core.c
>> +++ b/kernel/bpf/core.c
>> @@ -218,7 +218,7 @@ void bpf_prog_fill_jited_linfo(struct bpf_prog *prog,
>>   }
>>
>>   struct bpf_prog *bpf_prog_realloc(struct bpf_prog *fp_old, unsigned int size,
>> -                                 gfp_t gfp_extra_flags)
>> +                                 gfp_t gfp_extra_flags, bool free_old)
>>   {
>>          gfp_t gfp_flags = GFP_KERNEL_ACCOUNT | __GFP_ZERO | gfp_extra_flags;
>>          struct bpf_prog *fp;
>> @@ -238,7 +238,8 @@ struct bpf_prog *bpf_prog_realloc(struct bpf_prog *fp_old, unsigned int size,
>>                  /* We keep fp->aux from fp_old around in the new
>>                   * reallocated structure.
>>                   */
>> -               bpf_prog_clone_free(fp_old);
>> +               if (free_old)
>> +                       bpf_prog_clone_free(fp_old);
>>          }
>>
>>          return fp;
>> @@ -456,7 +457,7 @@ struct bpf_prog *bpf_patch_insn_single(struct bpf_prog *prog, u32 off,
>>           * last page could have large enough tailroom.
>>           */
>>          prog_adj = bpf_prog_realloc(prog, bpf_prog_size(insn_adj_cnt),
>> -                                   GFP_USER);
>> +                                   GFP_USER, false);
>>          if (!prog_adj)
>>                  return ERR_PTR(-ENOMEM);
>>
>> @@ -1150,6 +1151,8 @@ struct bpf_prog *bpf_jit_blind_constants(struct bpf_prog *prog)
>>                          return tmp;
>>                  }
>>
>> +               if (tmp != clone)
>> +                       bpf_prog_clone_free(clone);
>>                  clone = tmp;
>>                  insn_delta = rewritten - 1;
>>
>> diff --git a/kernel/bpf/verifier.c b/kernel/bpf/verifier.c
>> index 41109f49b724..e75b933f69e4 100644
>> --- a/kernel/bpf/verifier.c
>> +++ b/kernel/bpf/verifier.c
>> @@ -11855,7 +11855,10 @@ static int opt_subreg_zext_lo32_rnd_hi32(struct bpf_verifier_env *env,
>>                  new_prog = bpf_patch_insn_data(env, adj_idx, patch, patch_len);
>>                  if (!new_prog)
>>                          return -ENOMEM;
>> -               env->prog = new_prog;
>> +               if (new_prog != env->prog) {
>> +                       bpf_prog_clone_free(env->prog);
>> +                       env->prog = new_prog;
>> +               }
> 
> Can we move this check into bpf_patch_insn_data()?

Ok, I will change this in next version.

> 
>>                  insns = new_prog->insnsi;
>>                  aux = env->insn_aux_data;
>>                  delta += patch_len - 1;
> [...]
> 
>> diff --git a/net/core/filter.c b/net/core/filter.c
>> index d70187ce851b..8a8d1a3ba5c2 100644
>> --- a/net/core/filter.c
>> +++ b/net/core/filter.c
>> @@ -1268,7 +1268,7 @@ static struct bpf_prog *bpf_migrate_filter(struct bpf_prog *fp)
>>
>>          /* Expand fp for appending the new filter representation. */
>>          old_fp = fp;
>> -       fp = bpf_prog_realloc(old_fp, bpf_prog_size(new_len), 0);
>> +       fp = bpf_prog_realloc(old_fp, bpf_prog_size(new_len), 0, true);
> 
> Can we add some logic here and not add free_old to bpf_prog_realloc()?

Ok, maybe we can free old_fp here, never in bpf_prog_realloc.


> 
> Thanks,
> Song
> .
> 
