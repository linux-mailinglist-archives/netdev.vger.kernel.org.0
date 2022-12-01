Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 2F49C63F8EF
	for <lists+netdev@lfdr.de>; Thu,  1 Dec 2022 21:21:47 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229987AbiLAUVp (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 1 Dec 2022 15:21:45 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:50314 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229646AbiLAUVo (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 1 Dec 2022 15:21:44 -0500
Received: from out2.migadu.com (out2.migadu.com [IPv6:2001:41d0:2:aacc::])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 784A2B2746;
        Thu,  1 Dec 2022 12:21:42 -0800 (PST)
Message-ID: <8ed7abe7-ebcb-766f-937e-793787578290@linux.dev>
Date:   Thu, 1 Dec 2022 12:21:33 -0800
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
X-Report-Abuse: Please report any abuse attempt to abuse@migadu.com and include these headers.
From:   Martin KaFai Lau <martin.lau@linux.dev>
In-Reply-To: <CAHsH6Gs4OajjoXauDw9zERx=+tUqpbpnP_8SxzmKKDQ3r8xmJA@mail.gmail.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
X-Spam-Status: No, score=-2.6 required=5.0 tests=BAYES_00,RCVD_IN_DNSWL_LOW,
        SPF_HELO_PASS,SPF_PASS autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On 11/30/22 9:55 PM, Eyal Birger wrote:
>>> +
>>> +     info->if_id = from->if_id;
>>> +     info->link = from->link;
>>> +     skb_dst_force(skb);
>>> +     info->dst_orig = skb_dst(skb);
>>> +
>>> +     dst_hold((struct dst_entry *)md_dst);
>>> +     skb_dst_set(skb, (struct dst_entry *)md_dst);
>>> +     return 0;
>>> +}
>>> +
>>> +__diag_pop()
>>> +
>>> +BTF_SET8_START(xfrm_ifc_kfunc_set)
>>> +BTF_ID_FLAGS(func, bpf_skb_get_xfrm_info)
>>> +BTF_ID_FLAGS(func, bpf_skb_set_xfrm_info)
>>> +BTF_SET8_END(xfrm_ifc_kfunc_set)
>>> +
>>> +static const struct btf_kfunc_id_set xfrm_interface_kfunc_set = {
>>> +     .owner = THIS_MODULE,
>>> +     .set   = &xfrm_ifc_kfunc_set,
>>> +};
>>> +
>>> +int __init register_xfrm_interface_bpf(void)
>>> +{
>>> +     int err;
>>> +
>>> +     xfrm_md_dst = metadata_dst_alloc_percpu(0, METADATA_XFRM,
>>> +                                             GFP_KERNEL);
>>
>> May be DEFINE_PER_CPU() instead?
> 
> Are you suggesting duplicating the dst init/cleanup logic here?
> Personally given that this happens once at module load, I think it's best to
> use the existing infrastructure, but am willing to add this here if you think
> it's better.

Agree, staying with the current patch is better.  I somehow thought 
metadata_dst_alloc_percpu() was newly added in this patch also.


