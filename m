Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id DDA5C63F91E
	for <lists+netdev@lfdr.de>; Thu,  1 Dec 2022 21:28:14 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230370AbiLAU2M (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 1 Dec 2022 15:28:12 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:56454 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229999AbiLAU2K (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 1 Dec 2022 15:28:10 -0500
X-Greylist: delayed 548 seconds by postgrey-1.37 at lindbergh.monkeyblade.net; Thu, 01 Dec 2022 12:28:08 PST
Received: from out-90.mta0.migadu.com (out-90.mta0.migadu.com [IPv6:2001:41d0:1004:224b::5a])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 83BCAA1C23
        for <netdev@vger.kernel.org>; Thu,  1 Dec 2022 12:28:07 -0800 (PST)
Message-ID: <f4aa0e19-6c91-3d39-ca8a-7840bf46625d@linux.dev>
Date:   Thu, 1 Dec 2022 12:18:45 -0800
MIME-Version: 1.0
Subject: Re: [PATCH ipsec-next,v2 2/3] xfrm: interface: Add unstable helpers
 for setting/getting XFRM metadata from TC-BPF
Content-Language: en-US
To:     Eyal Birger <eyal.birger@gmail.com>
Cc:     netdev@vger.kernel.org, bpf@vger.kernel.org,
        linux-kselftest@vger.kernel.org, davem@davemloft.net,
        edumazet@google.com, kuba@kernel.org, pabeni@redhat.com,
        steffen.klassert@secunet.com, herbert@gondor.apana.org.au,
        andrii@kernel.org, daniel@iogearbox.net, nicolas.dichtel@6wind.com,
        razor@blackwall.org, mykolal@fb.com, ast@kernel.org,
        song@kernel.org, yhs@fb.com, john.fastabend@gmail.com,
        kpsingh@kernel.org, sdf@google.com, haoluo@google.com,
        jolsa@kernel.org, shuah@kernel.org
References: <20221129132018.985887-1-eyal.birger@gmail.com>
 <20221129132018.985887-3-eyal.birger@gmail.com>
 <b3306950-bea9-e914-0491-54048d6d55e4@linux.dev>
 <CAHsH6Gs4OajjoXauDw9zERx=+tUqpbpnP_8SxzmKKDQ3r8xmJA@mail.gmail.com>
 <CAHsH6Gv+WUDQvAL6jnzNFkNAKTk7ANahdbC_43y9x4t3AJZceA@mail.gmail.com>
X-Report-Abuse: Please report any abuse attempt to abuse@migadu.com and include these headers.
From:   Martin KaFai Lau <martin.lau@linux.dev>
In-Reply-To: <CAHsH6Gv+WUDQvAL6jnzNFkNAKTk7ANahdbC_43y9x4t3AJZceA@mail.gmail.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
X-Spam-Status: No, score=-1.9 required=5.0 tests=BAYES_00,SPF_HELO_NONE,
        SPF_PASS autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On 12/1/22 5:30 AM, Eyal Birger wrote:
> Hi Martin,
> 
> On Thu, Dec 1, 2022 at 7:55 AM Eyal Birger <eyal.birger@gmail.com> wrote:
>>
>> Hi Martin,
>>
>> On Wed, Nov 30, 2022 at 8:15 PM Martin KaFai Lau <martin.lau@linux.dev> wrote:
>>>
>>> On 11/29/22 5:20 AM, Eyal Birger wrote:
>>>> diff --git a/net/xfrm/xfrm_interface_bpf.c b/net/xfrm/xfrm_interface_bpf.c
>>>> new file mode 100644
>>>> index 000000000000..757e15857dbf
>>>> --- /dev/null
>>>> +++ b/net/xfrm/xfrm_interface_bpf.c
>>>> @@ -0,0 +1,100 @@
>>>> +// SPDX-License-Identifier: GPL-2.0-only
>>>> +/* Unstable XFRM Helpers for TC-BPF hook
>>>> + *
>>>> + * These are called from SCHED_CLS BPF programs. Note that it is
>>>> + * allowed to break compatibility for these functions since the interface they
>>>> + * are exposed through to BPF programs is explicitly unstable.
>>>> + */
>>>> +
>>>> +#include <linux/bpf.h>
>>>> +#include <linux/btf_ids.h>
>>>> +
>>>> +#include <net/dst_metadata.h>
>>>> +#include <net/xfrm.h>
>>>> +
>>>> +struct bpf_xfrm_info {
>>> No need to introduce a bpf variant of the "struct xfrm_md_info" (more on this
>>> later).
>>>
>>>> +     u32 if_id;
>>>> +     int link;
>>>> +};
>>>> +
>>>> +static struct metadata_dst __percpu *xfrm_md_dst;
>>>> +__diag_push();
>>>> +__diag_ignore_all("-Wmissing-prototypes",
>>>> +               "Global functions as their definitions will be in xfrm_interface BTF");
>>>> +
>>>> +__used noinline
>>>> +int bpf_skb_get_xfrm_info(struct __sk_buff *skb_ctx, struct bpf_xfrm_info *to)
>>>
>>> This kfunc is not needed.  It only reads the skb->_skb_refdst.  The new kfunc
>>> bpf_rdonly_cast() can be used.  Take a look at the bpf_rdonly_cast() usages in
>>> the selftests/bpf/progs/type_cast.c.  It was in bpf-next only but should also be
>>> in net-next now.
>>
>> I'm somewhat concerned with this approach.
>> Indeed it would remove the kfunc, and the API is declared "unstable", but
>> still the implementation as dst isn't relevant to the user and would make
>> the programs less readable.
>>
>> Also note that the helper can be also used as it is to get the xfrm info at
>> egress from an lwt route (which stores the xfrm_info in the dst lwstate).

Right, the whole skb_xfrm_md_info() can be implemented in bpf prog itself, like 
checking lwtstate.

If adding a kfunc, how about directly expose skb_xfrm_md_info() itself as a 
kfunc to bpf prog and directly return a "struct xfrm_md_info *" instead.  Then 
there is no need to copy if_id/link...etc.  The bpf prog has no need to 
initialize the "to" also.  Something like this:

__used noinline
const struct xfrm_md_info *bpf_skb_xfrm_md_info(const struct __sk_buff *skb) { ... }

BTF_ID_FLAGS(func, bpf_skb_xfrm_md_info, KF_RET_NULL)

>>
>>>
>>>> +{
>>>> +     struct sk_buff *skb = (struct sk_buff *)skb_ctx;
>>>> +     struct xfrm_md_info *info;
>>>> +
>>>> +     memset(to, 0, sizeof(*to));
>>>> +
>>>> +     info = skb_xfrm_md_info(skb);
>>>> +     if (!info)
>>>> +             return -EINVAL;
>>>> +
>>>> +     to->if_id = info->if_id;
>>>> +     to->link = info->link;
>>>> +     return 0;
>>>> +}
>>>> +
>>>> +__used noinline
>>>> +int bpf_skb_set_xfrm_info(struct __sk_buff *skb_ctx,
>>>> +                       const struct bpf_xfrm_info *from)
>>>
>>> Directly use "const struct xfrm_md_info *from" instead.  This kfunc can check
>>> from->dst_orig != NULL and return -EINVAL.  It will then have a consistent API
>>> with the bpf_rdonly_cast() mentioned above.
>>
>> See above.
> 
> Also, when trying this approach with bpf_set_xfrm_info() accepting
> "const struct xfrm_md_info *from" I fail to load the program:
> 
> libbpf: prog 'set_xfrm_info': BPF program load failed: Invalid argument
> libbpf: prog 'set_xfrm_info': -- BEGIN PROG LOAD LOG --
> 0: R1=ctx(off=0,imm=0) R10=fp0
> ; int set_xfrm_info(struct __sk_buff *skb)
> 0: (bf) r6 = r1                       ; R1=ctx(off=0,imm=0)
> R6_w=ctx(off=0,imm=0)
> 1: (b7) r1 = 0                        ; R1_w=0
> ; struct xfrm_md_info info = {};
> 2: (7b) *(u64 *)(r10 -8) = r1         ; R1_w=0 R10=fp0 fp-8_w=00000000
> 3: (7b) *(u64 *)(r10 -16) = r1        ; R1_w=0 R10=fp0 fp-16_w=00000000
> 4: (b4) w1 = 0                        ; R1_w=0
> ; __u32 index = 0;
> 5: (63) *(u32 *)(r10 -20) = r1        ; R1_w=0 R10=fp0 fp-24=0000????
> 6: (bf) r2 = r10                      ; R2_w=fp0 R10=fp0
> ;
> 7: (07) r2 += -20                     ; R2_w=fp-20
> ; if_id = bpf_map_lookup_elem(&dst_if_id_map, &index);
> 8: (18) r1 = 0xffff888006751c00       ; R1_w=map_ptr(off=0,ks=4,vs=4,imm=0)
> 10: (85) call bpf_map_lookup_elem#1   ;
> R0_w=map_value_or_null(id=1,off=0,ks=4,vs=4,imm=0)
> 11: (bf) r1 = r0                      ;
> R0_w=map_value_or_null(id=1,off=0,ks=4,vs=4,imm=0)
> R1_w=map_value_or_null(id=1,off=0,ks=4,vs=4,imm=0)
> 12: (b4) w0 = 2                       ; R0_w=2
> ; if (!if_id)
> 13: (15) if r1 == 0x0 goto pc+10      ; R1_w=map_value(off=0,ks=4,vs=4,imm=0)
> 14: (bf) r2 = r10                     ; R2_w=fp0 R10=fp0
> ;
> 15: (07) r2 += -16                    ; R2_w=fp-16
> ; info.if_id = *if_id;
> 16: (61) r1 = *(u32 *)(r1 +0)         ;
> R1_w=scalar(umax=4294967295,var_off=(0x0; 0xffffffff))
> ; info.if_id = *if_id;
> 17: (63) *(u32 *)(r2 +0) = r1         ;
> R1_w=scalar(umax=4294967295,var_off=(0x0; 0xffffffff)) R2_w=fp-16
> fp-16_w=
> ; ret = bpf_skb_set_xfrm_info(skb, &info);
> 18: (bf) r1 = r6                      ; R1_w=ctx(off=0,imm=0)
> R6_w=ctx(off=0,imm=0)
> 19: (85) call bpf_skb_set_xfrm_info#81442
> arg#1 pointer type STRUCT xfrm_md_info must point to scalar, or struct
> with scalar
> 
> Is there some registration I need to do for this struct?

Ah, thanks for trying!
hmm... it will need a change to the verifier.  likely tag the param with 
something like "const struct xfrm_md_info *from__nonscalar_ok".

The reason of my earlier suggestion was to avoid the need to duplicate future 
changes in xfrm_md_info to bpf_xfrm_info and more importantly avoid creating 
another __sk_buff vs sk_buff like usage confusion.

For now, lets stay with bpf_xfrm_info.  This can be changed later.

