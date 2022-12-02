Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id DF66F640FFD
	for <lists+netdev@lfdr.de>; Fri,  2 Dec 2022 22:27:23 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234550AbiLBV1U (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 2 Dec 2022 16:27:20 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:39698 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S234481AbiLBV1T (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 2 Dec 2022 16:27:19 -0500
Received: from out-76.mta0.migadu.com (out-76.mta0.migadu.com [IPv6:2001:41d0:1004:224b::4c])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 487C0EE953
        for <netdev@vger.kernel.org>; Fri,  2 Dec 2022 13:27:18 -0800 (PST)
Message-ID: <b35e5328-c57f-a5f7-d9cb-eaee1a73991a@linux.dev>
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linux.dev; s=key1;
        t=1670016435;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=r5qJrXyOh08/0G2OJHK5zG6IyLevRu3YZQO062C5ygo=;
        b=QuaT4mbjrdiK2bBRjTk+FGIbCvdlh7IDvioHJsBDutl6Gm9snOSYrQa7P5tRh2Hg98Dmsh
        sZIXJcJLhO29G+LPziJDg45F1gdYehwaFFIilMhFtvtqeAqvG22AtV54d5aojkaFli2D+I
        TLagRgvx58wAi63rT3X8QElWGQBZY+A=
Date:   Fri, 2 Dec 2022 13:27:08 -0800
MIME-Version: 1.0
Subject: Re: [PATCH bpf-next,v4 2/4] xfrm: interface: Add unstable helpers for
 setting/getting XFRM metadata from TC-BPF
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
        jolsa@kernel.org, shuah@kernel.org, liuhangbin@gmail.com,
        lixiaoyan@google.com
References: <20221202095920.1659332-1-eyal.birger@gmail.com>
 <20221202095920.1659332-3-eyal.birger@gmail.com>
 <6d0e13eb-63e0-a777-2a27-7f2e02867a13@linux.dev>
 <CAHsH6Gtt4vihaZ5kCFsjT8x1SmuiUkijnVxgAA9bMp4NOgPeAw@mail.gmail.com>
 <4cf2ecd4-2f21-848a-00df-4e4fd86667eb@linux.dev>
 <CAHsH6Gt=WQhcqTsrDRhVyOSMwc4be5JaY9LpkbtFunvNZx3_Cg@mail.gmail.com>
X-Report-Abuse: Please report any abuse attempt to abuse@migadu.com and include these headers.
From:   Martin KaFai Lau <martin.lau@linux.dev>
In-Reply-To: <CAHsH6Gt=WQhcqTsrDRhVyOSMwc4be5JaY9LpkbtFunvNZx3_Cg@mail.gmail.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
X-Migadu-Flow: FLOW_OUT
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,SPF_HELO_NONE,SPF_PASS
        autolearn=unavailable autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On 12/2/22 12:49 PM, Eyal Birger wrote:
> On Fri, Dec 2, 2022 at 10:27 PM Martin KaFai Lau <martin.lau@linux.dev> wrote:
>>
>> On 12/2/22 11:42 AM, Eyal Birger wrote:
>>> Hi Martin,
>>>
>>> On Fri, Dec 2, 2022 at 9:08 PM Martin KaFai Lau <martin.lau@linux.dev> wrote:
>>>>
>>>> On 12/2/22 1:59 AM, Eyal Birger wrote:
>>>>> +__used noinline
>>>>> +int bpf_skb_set_xfrm_info(struct __sk_buff *skb_ctx,
>>>>> +                       const struct bpf_xfrm_info *from)
>>>>> +{
>>>>> +     struct sk_buff *skb = (struct sk_buff *)skb_ctx;
>>>>> +     struct metadata_dst *md_dst;
>>>>> +     struct xfrm_md_info *info;
>>>>> +
>>>>> +     if (unlikely(skb_metadata_dst(skb)))
>>>>> +             return -EINVAL;
>>>>> +
>>>>> +     md_dst = this_cpu_ptr(xfrm_md_dst);
>>>>> +
>>>>> +     info = &md_dst->u.xfrm_info;
>>>>> +
>>>>> +     info->if_id = from->if_id;
>>>>> +     info->link = from->link;
>>>>> +     skb_dst_force(skb);
>>>>> +     info->dst_orig = skb_dst(skb);
>>>>> +
>>>>> +     dst_hold((struct dst_entry *)md_dst);
>>>>> +     skb_dst_set(skb, (struct dst_entry *)md_dst);
>>>>
>>>>
>>>> I may be missed something obvious and this just came to my mind,
>>>>
>>>> What stops cleanup_xfrm_interface_bpf() being run while skb is still holding the
>>>> md_dst?
>>>>
>>> Oh I think you're right. I missed this.
>>>
>>> In order to keep this implementation I suppose it means that the module would
>>> not be allowed to be removed upon use of this kfunc. but this could be seen as
>>> annoying from the configuration user experience.
>>>
>>> Alternatively the metadata dsts can be separately allocated from the kfunc,
>>> which is probably the simplest approach to maintain, so I'll work on that
>>> approach.
>>
>> If it means dst_alloc on every skb, it will not be cheap.
>>
>> Another option is to metadata_dst_alloc_percpu() once during the very first
>> bpf_skb_set_xfrm_info() call and the xfrm_md_dst memory will never be freed.  It
>> is a tradeoff but likely the correct one.  You can take a look at
>> bpf_get_skb_set_tunnel_proto().
>>
> 
> Yes, I originally wrote this as a helper similar to the tunnel key
> helper which uses bpf_get_skb_set_tunnel_proto(), and when converting
> to kfuncs I kept the
> percpu implementation.
> 
> However, the set tunnel key code is never unloaded. Whereas taking this
> approach here would mean that this memory would leak on each module reload
> iiuc.

'struct metadata_dst __percpu *xfrm_md_dst' cannot be in the xfrm module. 
filter.c could be an option.
