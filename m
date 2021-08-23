Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 8FFC43F5306
	for <lists+netdev@lfdr.de>; Mon, 23 Aug 2021 23:51:59 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232949AbhHWVw3 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 23 Aug 2021 17:52:29 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:47764 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232503AbhHWVw1 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 23 Aug 2021 17:52:27 -0400
Received: from mail-pg1-x536.google.com (mail-pg1-x536.google.com [IPv6:2607:f8b0:4864:20::536])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id E4BDBC061575;
        Mon, 23 Aug 2021 14:51:44 -0700 (PDT)
Received: by mail-pg1-x536.google.com with SMTP id s11so17894957pgr.11;
        Mon, 23 Aug 2021 14:51:44 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=subject:to:cc:references:from:message-id:date:user-agent
         :mime-version:in-reply-to:content-language:content-transfer-encoding;
        bh=/4sa3hRKHYJGIpFu2RJ99Np1mz1P713WKUCXGQ7iJ/Q=;
        b=CIWhz7kp8gl/zgbtxNFGtTMSZ+gnaR8xvtCnRG2sa/p2P+PzAwJMYt9KYytxMKb23e
         8NP3/T3i2fxZ03EKpg/nLweR6mAjDJ4hK21jgLUuvWq1GbdkIyWz6VoqyD70JNq5V11q
         +SVZxiz+uTRd5TxYkK5rC+BpKhuvyJzOM2ReFqibVzUTxYGDc2wrL07FYtnQE3fxT1oF
         PY4jYk8um+69/UG8IM6Pnk0R1KNUM3/k3tw4AGrdzoghiI5KOcITlzcVB7cvXZoa2Q2M
         /YW0+8ipJT+NaCvRcPsY0MS7N+WGQ3aeEEIppSbPzhtt12N+zyfHbG2y7bOTUmapHeer
         ++tA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:subject:to:cc:references:from:message-id:date
         :user-agent:mime-version:in-reply-to:content-language
         :content-transfer-encoding;
        bh=/4sa3hRKHYJGIpFu2RJ99Np1mz1P713WKUCXGQ7iJ/Q=;
        b=Q5bQwiQeV8cXUAzbiKA5PnfUbpeVb1dAkeEMbSEzIO1B1aO1UrBHV7Z2Lv8siZ2eqF
         pZjos3bwhBfMvGnemgdtza3m6hZnhjsbuhF1bGQI3n0qdf2+3JDH1YeyBqNuGGKTCoad
         fqdUhsRRA3BjX+RO8aIBVIE0nPTMId7RHH2d91CCOgps9Y3SwI9g82JB5o9YhX3hueO/
         Y2ZIYgYeOfYMwyvQ942vNaWVLTycNW75hD1E/4RoYqAF05VYcnfIbndRK1yV48veztJl
         Fur6OUIUypxLXw9hBWBvb5vIWBkfhxmqA9gmnvOhDgBufsdkIn//jwZZF1cEqd42BdE4
         BypA==
X-Gm-Message-State: AOAM532qmiCIE/OiAZTk1l2D5ZxZ6O4RzUOYNUm6tdoJuLZODYs4w2JA
        usrBJUoL0wXXh4oMfSz9n+w=
X-Google-Smtp-Source: ABdhPJz7ykDAk2ewsdsErG1eLUx8tkDakwd9PXhQh5tnA9bj4a6ZNxrmlkLQ+KwOukGYcdHV7J3N5w==
X-Received: by 2002:a62:3301:0:b0:3eb:2fee:87cc with SMTP id z1-20020a623301000000b003eb2fee87ccmr7194794pfz.62.1629755504454;
        Mon, 23 Aug 2021 14:51:44 -0700 (PDT)
Received: from [192.168.86.235] (c-73-241-150-58.hsd1.ca.comcast.net. [73.241.150.58])
        by smtp.gmail.com with ESMTPSA id j4sm19534603pgi.6.2021.08.23.14.51.43
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Mon, 23 Aug 2021 14:51:43 -0700 (PDT)
Subject: Re: [PATCH NET-NEXT] ipv6: skb_expand_head() adjust skb->truesize
 incorrectly
To:     Eric Dumazet <eric.dumazet@gmail.com>,
        Christoph Paasch <christoph.paasch@gmail.com>,
        Vasily Averin <vvs@virtuozzo.com>
Cc:     "David S. Miller" <davem@davemloft.net>,
        Hideaki YOSHIFUJI <yoshfuji@linux-ipv6.org>,
        David Ahern <dsahern@kernel.org>,
        Jakub Kicinski <kuba@kernel.org>,
        netdev <netdev@vger.kernel.org>,
        LKML <linux-kernel@vger.kernel.org>, kernel@openvz.org,
        Julian Wiedmann <jwi@linux.ibm.com>
References: <6858f130-e6b4-1ba7-ed6f-58c00152be69@virtuozzo.com>
 <ef4458d9-c4d7-f419-00f2-0f1cea5140ce@virtuozzo.com>
 <CALMXkpZkW+ULMMFgeY=cag1F0=891F-v9NEVcdn7Tyd-VUWGYA@mail.gmail.com>
 <1c12b056-79d2-126a-3f78-64629f072345@gmail.com>
From:   Eric Dumazet <eric.dumazet@gmail.com>
Message-ID: <2d8a102a-d641-c6c1-b417-7a35efa4e5da@gmail.com>
Date:   Mon, 23 Aug 2021 14:51:42 -0700
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:78.0) Gecko/20100101
 Thunderbird/78.12.0
MIME-Version: 1.0
In-Reply-To: <1c12b056-79d2-126a-3f78-64629f072345@gmail.com>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org



On 8/23/21 2:45 PM, Eric Dumazet wrote:
> 
> 
> On 8/23/21 10:25 AM, Christoph Paasch wrote:
>> Hello,
>>
>> On Mon, Aug 23, 2021 at 12:56 AM Vasily Averin <vvs@virtuozzo.com> wrote:
>>>
>>> Christoph Paasch reports [1] about incorrect skb->truesize
>>> after skb_expand_head() call in ip6_xmit.
>>> This happen because skb_set_owner_w() for newly clone skb is called
>>> too early, before pskb_expand_head() where truesize is adjusted for
>>> (!skb-sk) case.
>>>
>>> [1] https://lkml.org/lkml/2021/8/20/1082
>>>
>>> Reported-by: Christoph Paasch <christoph.paasch@gmail.com>
>>> Signed-off-by: Vasily Averin <vvs@virtuozzo.com>
>>> ---
>>>  net/core/skbuff.c | 24 +++++++++++++-----------
>>>  1 file changed, 13 insertions(+), 11 deletions(-)
>>>
>>> diff --git a/net/core/skbuff.c b/net/core/skbuff.c
>>> index f931176..508d5c4 100644
>>> --- a/net/core/skbuff.c
>>> +++ b/net/core/skbuff.c
>>> @@ -1803,6 +1803,8 @@ struct sk_buff *skb_realloc_headroom(struct sk_buff *skb, unsigned int headroom)
>>>
>>>  struct sk_buff *skb_expand_head(struct sk_buff *skb, unsigned int headroom)
>>>  {
>>> +       struct sk_buff *oskb = skb;
>>> +       struct sk_buff *nskb = NULL;
>>>         int delta = headroom - skb_headroom(skb);
>>>
>>>         if (WARN_ONCE(delta <= 0,
>>> @@ -1811,21 +1813,21 @@ struct sk_buff *skb_expand_head(struct sk_buff *skb, unsigned int headroom)
>>>
>>>         /* pskb_expand_head() might crash, if skb is shared */
>>>         if (skb_shared(skb)) {
>>> -               struct sk_buff *nskb = skb_clone(skb, GFP_ATOMIC);
>>> -
>>> -               if (likely(nskb)) {
>>> -                       if (skb->sk)
>>> -                               skb_set_owner_w(nskb, skb->sk);
>>> -                       consume_skb(skb);
>>> -               } else {
>>> -                       kfree_skb(skb);
>>> -               }
>>> +               nskb = skb_clone(skb, GFP_ATOMIC);
>>>                 skb = nskb;
>>>         }
>>>         if (skb &&
>>> -           pskb_expand_head(skb, SKB_DATA_ALIGN(delta), 0, GFP_ATOMIC)) {
>>> -               kfree_skb(skb);
>>> +           pskb_expand_head(skb, SKB_DATA_ALIGN(delta), 0, GFP_ATOMIC))
>>>                 skb = NULL;
>>> +
>>> +       if (!skb) {
>>> +               kfree_skb(oskb);
>>> +               if (nskb)
>>> +                       kfree_skb(nskb);
>>> +       } else if (nskb) {
>>> +               if (oskb->sk)
>>> +                       skb_set_owner_w(nskb, oskb->sk);
>>> +               consume_skb(oskb);
>>
>> sorry, this does not fix the problem. The syzkaller repro still
>> triggers the WARN.
>>
>> When it happens, the skb in ip6_xmit() is not shared as it comes from
>> __tcp_transmit_skb, where it is skb_clone()'d.
>>
>>
> 
> Old code (in skb_realloc_headroom())
> was first calling skb2 = skb_clone(skb, GFP_ATOMIC); 
> 
> At this point, skb2->sk was NULL
> So pskb_expand_head(skb2, SKB_DATA_ALIGN(delta), 0, ...) was able to tweak skb2->truesize
> 
> I would try :
> 
> diff --git a/net/core/skbuff.c b/net/core/skbuff.c
> index f9311762cc475bd38d87c33e988d7c983b902e56..326749a8938637b044a616cc33b6a19ed191ac41 100644
> --- a/net/core/skbuff.c
> +++ b/net/core/skbuff.c
> @@ -1804,6 +1804,7 @@ EXPORT_SYMBOL(skb_realloc_headroom);
>  struct sk_buff *skb_expand_head(struct sk_buff *skb, unsigned int headroom)
>  {
>         int delta = headroom - skb_headroom(skb);
> +       struct sk_buff *oskb = NULL;
>  
>         if (WARN_ONCE(delta <= 0,
>                       "%s is expecting an increase in the headroom", __func__))
> @@ -1813,19 +1814,21 @@ struct sk_buff *skb_expand_head(struct sk_buff *skb, unsigned int headroom)
>         if (skb_shared(skb)) {
>                 struct sk_buff *nskb = skb_clone(skb, GFP_ATOMIC);
>  
> -               if (likely(nskb)) {
> -                       if (skb->sk)
> -                               skb_set_owner_w(nskb, skb->sk);
> -                       consume_skb(skb);
> -               } else {
> +               if (unlikely(!nskb)) {
>                         kfree_skb(skb);
> +                       return NULL;
>                 }
> +               oskb = skb;
>                 skb = nskb;
>         }
> -       if (skb &&
> -           pskb_expand_head(skb, SKB_DATA_ALIGN(delta), 0, GFP_ATOMIC)) {
> +       if (pskb_expand_head(skb, SKB_DATA_ALIGN(delta), 0, GFP_ATOMIC)) {
>                 kfree_skb(skb);
> -               skb = NULL;
> +               kfree_skb(oskb);
> +               return NULL;
> +       }
> +       if (oskb) {
> +               skb_set_owner_w(skb, oskb->sk);
> +               consume_skb(oskb);
>         }
>         return skb;
>  }


Oh well, probably not going to work.

We have to find a way to properly increase skb->truesize, even if skb_clone() is _not_ called.



