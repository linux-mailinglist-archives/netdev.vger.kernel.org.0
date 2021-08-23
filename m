Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 1B49F3F5356
	for <lists+netdev@lfdr.de>; Tue, 24 Aug 2021 00:23:40 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233108AbhHWWYR (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 23 Aug 2021 18:24:17 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:54964 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229632AbhHWWYQ (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 23 Aug 2021 18:24:16 -0400
Received: from mail-pl1-x635.google.com (mail-pl1-x635.google.com [IPv6:2607:f8b0:4864:20::635])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 8DF19C061575;
        Mon, 23 Aug 2021 15:23:33 -0700 (PDT)
Received: by mail-pl1-x635.google.com with SMTP id j2so6619661pll.1;
        Mon, 23 Aug 2021 15:23:33 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=subject:to:cc:references:from:message-id:date:user-agent
         :mime-version:in-reply-to:content-language:content-transfer-encoding;
        bh=2p6IxYHjQrK32WGk8qpPNDpZ5O6IjyX0XZXnKdnkjG4=;
        b=H05d40FOc/rKQBNGb8iMx3vGCtztK3NsVCTvaWXf8/0fJxqBMWd9EH2fNXmxFcOoKm
         2x5BF3eZmlM5M2q+VAnN7wnT1hX677x6tvoZoAotA8EzVuBVjS6XCjIlz0JLue8XWgsX
         fRqFJ7/eYJvmik4JXPq2NcN0oj0VF9tIUFzot+CBGnxtwdwvENrpCYaRAAI3+iSWdE0G
         C9jAgwtOF/Hua+t16qG+Y4spEvJr8WvNmnDKOL0j3eOxeO3Eq7EgHJ9gP7rKPBUX6QbF
         zNpYttQ9PiNNtI8GeunFSYFeKvAtfWimqZBu3earQFOWWDp1u4fWBJo+vZ2tAW3uYE9A
         /UDw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:subject:to:cc:references:from:message-id:date
         :user-agent:mime-version:in-reply-to:content-language
         :content-transfer-encoding;
        bh=2p6IxYHjQrK32WGk8qpPNDpZ5O6IjyX0XZXnKdnkjG4=;
        b=B8AYuYUIXsjofSPVtRz9y2wCK/1D1m/jHF+bUufEJYc1C8se2oXP6K08LkCPlS0tvg
         dQttJux5LT1jJXuGs3GLBviQD+nSweREPeBlyk6YmMF9lHMtrdmY9ysDDn/mV/lOiYC2
         ZOryI64cbCA6b4gPdNO7/jc9b6j7kjRFbovnI9AUa74g+AjeQ4zEY6E1ROxWLR9u97eu
         d3yjNokQzxPqZkfffQs0XT5uTg2BBy9VGDcnVH73vJc8HY1xFR4t+qa2WmGIKLszIb8v
         ovXdNT0yCv/cSUfx7xLYcuRsjCY3BXMIu5aUqF4sM+WefDEIvgQUeoC10xiTAi94aX1Y
         1T8Q==
X-Gm-Message-State: AOAM532Es6AxECrU90rBqGvXd2RKbbKljSzxVWiE3DAkm8CBNGdkUfjx
        y2CMmnDEvwhwr6FDKrgkwac=
X-Google-Smtp-Source: ABdhPJxYeR3r163BgqBExxC6eUbm7m606m6IUkhNm1PEkPowF12EZ5sHI+P1PO0SLFMvzc4Vb1GqKw==
X-Received: by 2002:a17:90a:c705:: with SMTP id o5mr795934pjt.55.1629757413049;
        Mon, 23 Aug 2021 15:23:33 -0700 (PDT)
Received: from [192.168.86.235] (c-73-241-150-58.hsd1.ca.comcast.net. [73.241.150.58])
        by smtp.gmail.com with ESMTPSA id w2sm236054pjq.5.2021.08.23.15.23.30
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Mon, 23 Aug 2021 15:23:32 -0700 (PDT)
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
 <2d8a102a-d641-c6c1-b417-7a35efa4e5da@gmail.com>
From:   Eric Dumazet <eric.dumazet@gmail.com>
Message-ID: <bd90616e-8e86-016b-0979-c4f4167b8bc2@gmail.com>
Date:   Mon, 23 Aug 2021 15:23:29 -0700
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:78.0) Gecko/20100101
 Thunderbird/78.12.0
MIME-Version: 1.0
In-Reply-To: <2d8a102a-d641-c6c1-b417-7a35efa4e5da@gmail.com>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org



On 8/23/21 2:51 PM, Eric Dumazet wrote:
> 
> 
> On 8/23/21 2:45 PM, Eric Dumazet wrote:
>>
>>
>> On 8/23/21 10:25 AM, Christoph Paasch wrote:
>>> Hello,
>>>
>>> On Mon, Aug 23, 2021 at 12:56 AM Vasily Averin <vvs@virtuozzo.com> wrote:
>>>>
>>>> Christoph Paasch reports [1] about incorrect skb->truesize
>>>> after skb_expand_head() call in ip6_xmit.
>>>> This happen because skb_set_owner_w() for newly clone skb is called
>>>> too early, before pskb_expand_head() where truesize is adjusted for
>>>> (!skb-sk) case.
>>>>
>>>> [1] https://lkml.org/lkml/2021/8/20/1082
>>>>
>>>> Reported-by: Christoph Paasch <christoph.paasch@gmail.com>
>>>> Signed-off-by: Vasily Averin <vvs@virtuozzo.com>
>>>> ---
>>>>  net/core/skbuff.c | 24 +++++++++++++-----------
>>>>  1 file changed, 13 insertions(+), 11 deletions(-)
>>>>
>>>> diff --git a/net/core/skbuff.c b/net/core/skbuff.c
>>>> index f931176..508d5c4 100644
>>>> --- a/net/core/skbuff.c
>>>> +++ b/net/core/skbuff.c
>>>> @@ -1803,6 +1803,8 @@ struct sk_buff *skb_realloc_headroom(struct sk_buff *skb, unsigned int headroom)
>>>>
>>>>  struct sk_buff *skb_expand_head(struct sk_buff *skb, unsigned int headroom)
>>>>  {
>>>> +       struct sk_buff *oskb = skb;
>>>> +       struct sk_buff *nskb = NULL;
>>>>         int delta = headroom - skb_headroom(skb);
>>>>
>>>>         if (WARN_ONCE(delta <= 0,
>>>> @@ -1811,21 +1813,21 @@ struct sk_buff *skb_expand_head(struct sk_buff *skb, unsigned int headroom)
>>>>
>>>>         /* pskb_expand_head() might crash, if skb is shared */
>>>>         if (skb_shared(skb)) {
>>>> -               struct sk_buff *nskb = skb_clone(skb, GFP_ATOMIC);
>>>> -
>>>> -               if (likely(nskb)) {
>>>> -                       if (skb->sk)
>>>> -                               skb_set_owner_w(nskb, skb->sk);
>>>> -                       consume_skb(skb);
>>>> -               } else {
>>>> -                       kfree_skb(skb);
>>>> -               }
>>>> +               nskb = skb_clone(skb, GFP_ATOMIC);
>>>>                 skb = nskb;
>>>>         }
>>>>         if (skb &&
>>>> -           pskb_expand_head(skb, SKB_DATA_ALIGN(delta), 0, GFP_ATOMIC)) {
>>>> -               kfree_skb(skb);
>>>> +           pskb_expand_head(skb, SKB_DATA_ALIGN(delta), 0, GFP_ATOMIC))
>>>>                 skb = NULL;
>>>> +
>>>> +       if (!skb) {
>>>> +               kfree_skb(oskb);
>>>> +               if (nskb)
>>>> +                       kfree_skb(nskb);
>>>> +       } else if (nskb) {
>>>> +               if (oskb->sk)
>>>> +                       skb_set_owner_w(nskb, oskb->sk);
>>>> +               consume_skb(oskb);
>>>
>>> sorry, this does not fix the problem. The syzkaller repro still
>>> triggers the WARN.
>>>
>>> When it happens, the skb in ip6_xmit() is not shared as it comes from
>>> __tcp_transmit_skb, where it is skb_clone()'d.
>>>
>>>
>>
>> Old code (in skb_realloc_headroom())
>> was first calling skb2 = skb_clone(skb, GFP_ATOMIC); 
>>
>> At this point, skb2->sk was NULL
>> So pskb_expand_head(skb2, SKB_DATA_ALIGN(delta), 0, ...) was able to tweak skb2->truesize
>>
>> I would try :
>>
>> diff --git a/net/core/skbuff.c b/net/core/skbuff.c
>> index f9311762cc475bd38d87c33e988d7c983b902e56..326749a8938637b044a616cc33b6a19ed191ac41 100644
>> --- a/net/core/skbuff.c
>> +++ b/net/core/skbuff.c
>> @@ -1804,6 +1804,7 @@ EXPORT_SYMBOL(skb_realloc_headroom);
>>  struct sk_buff *skb_expand_head(struct sk_buff *skb, unsigned int headroom)
>>  {
>>         int delta = headroom - skb_headroom(skb);
>> +       struct sk_buff *oskb = NULL;
>>  
>>         if (WARN_ONCE(delta <= 0,
>>                       "%s is expecting an increase in the headroom", __func__))
>> @@ -1813,19 +1814,21 @@ struct sk_buff *skb_expand_head(struct sk_buff *skb, unsigned int headroom)
>>         if (skb_shared(skb)) {
>>                 struct sk_buff *nskb = skb_clone(skb, GFP_ATOMIC);
>>  
>> -               if (likely(nskb)) {
>> -                       if (skb->sk)
>> -                               skb_set_owner_w(nskb, skb->sk);
>> -                       consume_skb(skb);
>> -               } else {
>> +               if (unlikely(!nskb)) {
>>                         kfree_skb(skb);
>> +                       return NULL;
>>                 }
>> +               oskb = skb;
>>                 skb = nskb;
>>         }
>> -       if (skb &&
>> -           pskb_expand_head(skb, SKB_DATA_ALIGN(delta), 0, GFP_ATOMIC)) {
>> +       if (pskb_expand_head(skb, SKB_DATA_ALIGN(delta), 0, GFP_ATOMIC)) {
>>                 kfree_skb(skb);
>> -               skb = NULL;
>> +               kfree_skb(oskb);
>> +               return NULL;
>> +       }
>> +       if (oskb) {
>> +               skb_set_owner_w(skb, oskb->sk);
>> +               consume_skb(oskb);
>>         }
>>         return skb;
>>  }
> 
> 
> Oh well, probably not going to work.
> 
> We have to find a way to properly increase skb->truesize, even if skb_clone() is _not_ called.
> 

I also note that current use of skb_set_owner_w(), forcing skb->destructor to sock_wfree()
is probably breaking TCP Small queues, since original skb->destructor would be tcp_wfree() or __sock_wfree()




