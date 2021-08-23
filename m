Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 3ADF03F5302
	for <lists+netdev@lfdr.de>; Mon, 23 Aug 2021 23:46:03 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232930AbhHWVqn (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 23 Aug 2021 17:46:43 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:46480 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232503AbhHWVqm (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 23 Aug 2021 17:46:42 -0400
Received: from mail-pj1-x1030.google.com (mail-pj1-x1030.google.com [IPv6:2607:f8b0:4864:20::1030])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 510A5C061575;
        Mon, 23 Aug 2021 14:45:59 -0700 (PDT)
Received: by mail-pj1-x1030.google.com with SMTP id f11-20020a17090aa78b00b0018e98a7cddaso909052pjq.4;
        Mon, 23 Aug 2021 14:45:59 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=subject:to:cc:references:from:message-id:date:user-agent
         :mime-version:in-reply-to:content-language:content-transfer-encoding;
        bh=eg0Z8o2ilI8wJIZ0jn0I50CtOhDN2lQ5m6bWeCHobWY=;
        b=L0L+tCqOSb3y0lJqlEECjQsqooczJr4Cz6MLiAQS4dND+DqvccRENjjA0Kp8FhdSv/
         HJcBmei3hCM/g3TWpIpxC8Y/jR5YBVyLWTrazLEMj0ETG9OQUsbCui5GNcTv9MobHBay
         vg3FqBfTBL/nCHv1X/6OzR7Q0TZCHUxdxcyx7rqWa9cTMzl6YnN50Ru45yv55jcvDNmY
         2QjIZS9WBhzCwt+mQYNTYC3pb0XdBL9x8dFPGQNYfQbVN9IQZmmqnFypiGqwPiGDZe/u
         owDucPHwHhPWMfXhu+CkCya4PAe67Ga4+UfBaG7AsauB38CIm/mMdEJKYcBzy7yJg3L3
         W2pQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:subject:to:cc:references:from:message-id:date
         :user-agent:mime-version:in-reply-to:content-language
         :content-transfer-encoding;
        bh=eg0Z8o2ilI8wJIZ0jn0I50CtOhDN2lQ5m6bWeCHobWY=;
        b=oZRThkWEkcktaMbrX0pPwnJpF5gsb4DkwAqr/2NTG93sNb1JpHi5gXYIFFbOANDc69
         0gSPuIjQv2AIpGBdeDW+WLGmx/9NkNCsD37o92gk0tl66+qXJlizda+WMwoZ5bjUVLqR
         6r38cSDF41JmePXDlrOLdioT+CjmjHgg/ppz2pUPAZ5UBuhksRQjQ6UC7sk6XSN3QvSB
         M0w1aUQaLAGMGIctAkqGTiulcqlDZwZdoeUcXx0vkgA8UTzQZALaRPbXFWvMV8APexP8
         /ndvbOBSE/Dzw7OTLZdNepFJXvrKSGb4Tr8GoZmSPh8M1mwvgWSoJI67TwMLNmmm/Kyi
         Sbwg==
X-Gm-Message-State: AOAM532q1qaGRlz1i9C6iEaD8CgtU/A64RK4pY0hDeefRgzjXDV2HB0i
        eqw0xo6D7pFVsFlXZCXHzz8=
X-Google-Smtp-Source: ABdhPJzKLJ+S2UfRebBy/ZVx0JwGg4c09MUoh+Zkpc7t4YUnFM6w4XY+ZOXIuol5XmA5qIrNykaidA==
X-Received: by 2002:a17:902:82c1:b0:135:b97d:8e84 with SMTP id u1-20020a17090282c100b00135b97d8e84mr2130066plz.85.1629755158778;
        Mon, 23 Aug 2021 14:45:58 -0700 (PDT)
Received: from [192.168.86.235] (c-73-241-150-58.hsd1.ca.comcast.net. [73.241.150.58])
        by smtp.gmail.com with ESMTPSA id z11sm16755215pfn.69.2021.08.23.14.45.57
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Mon, 23 Aug 2021 14:45:58 -0700 (PDT)
Subject: Re: [PATCH NET-NEXT] ipv6: skb_expand_head() adjust skb->truesize
 incorrectly
To:     Christoph Paasch <christoph.paasch@gmail.com>,
        Vasily Averin <vvs@virtuozzo.com>
Cc:     "David S. Miller" <davem@davemloft.net>,
        Hideaki YOSHIFUJI <yoshfuji@linux-ipv6.org>,
        David Ahern <dsahern@kernel.org>,
        Jakub Kicinski <kuba@kernel.org>,
        Eric Dumazet <eric.dumazet@gmail.com>,
        netdev <netdev@vger.kernel.org>,
        LKML <linux-kernel@vger.kernel.org>, kernel@openvz.org,
        Julian Wiedmann <jwi@linux.ibm.com>
References: <6858f130-e6b4-1ba7-ed6f-58c00152be69@virtuozzo.com>
 <ef4458d9-c4d7-f419-00f2-0f1cea5140ce@virtuozzo.com>
 <CALMXkpZkW+ULMMFgeY=cag1F0=891F-v9NEVcdn7Tyd-VUWGYA@mail.gmail.com>
From:   Eric Dumazet <eric.dumazet@gmail.com>
Message-ID: <1c12b056-79d2-126a-3f78-64629f072345@gmail.com>
Date:   Mon, 23 Aug 2021 14:45:56 -0700
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:78.0) Gecko/20100101
 Thunderbird/78.12.0
MIME-Version: 1.0
In-Reply-To: <CALMXkpZkW+ULMMFgeY=cag1F0=891F-v9NEVcdn7Tyd-VUWGYA@mail.gmail.com>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org



On 8/23/21 10:25 AM, Christoph Paasch wrote:
> Hello,
> 
> On Mon, Aug 23, 2021 at 12:56 AM Vasily Averin <vvs@virtuozzo.com> wrote:
>>
>> Christoph Paasch reports [1] about incorrect skb->truesize
>> after skb_expand_head() call in ip6_xmit.
>> This happen because skb_set_owner_w() for newly clone skb is called
>> too early, before pskb_expand_head() where truesize is adjusted for
>> (!skb-sk) case.
>>
>> [1] https://lkml.org/lkml/2021/8/20/1082
>>
>> Reported-by: Christoph Paasch <christoph.paasch@gmail.com>
>> Signed-off-by: Vasily Averin <vvs@virtuozzo.com>
>> ---
>>  net/core/skbuff.c | 24 +++++++++++++-----------
>>  1 file changed, 13 insertions(+), 11 deletions(-)
>>
>> diff --git a/net/core/skbuff.c b/net/core/skbuff.c
>> index f931176..508d5c4 100644
>> --- a/net/core/skbuff.c
>> +++ b/net/core/skbuff.c
>> @@ -1803,6 +1803,8 @@ struct sk_buff *skb_realloc_headroom(struct sk_buff *skb, unsigned int headroom)
>>
>>  struct sk_buff *skb_expand_head(struct sk_buff *skb, unsigned int headroom)
>>  {
>> +       struct sk_buff *oskb = skb;
>> +       struct sk_buff *nskb = NULL;
>>         int delta = headroom - skb_headroom(skb);
>>
>>         if (WARN_ONCE(delta <= 0,
>> @@ -1811,21 +1813,21 @@ struct sk_buff *skb_expand_head(struct sk_buff *skb, unsigned int headroom)
>>
>>         /* pskb_expand_head() might crash, if skb is shared */
>>         if (skb_shared(skb)) {
>> -               struct sk_buff *nskb = skb_clone(skb, GFP_ATOMIC);
>> -
>> -               if (likely(nskb)) {
>> -                       if (skb->sk)
>> -                               skb_set_owner_w(nskb, skb->sk);
>> -                       consume_skb(skb);
>> -               } else {
>> -                       kfree_skb(skb);
>> -               }
>> +               nskb = skb_clone(skb, GFP_ATOMIC);
>>                 skb = nskb;
>>         }
>>         if (skb &&
>> -           pskb_expand_head(skb, SKB_DATA_ALIGN(delta), 0, GFP_ATOMIC)) {
>> -               kfree_skb(skb);
>> +           pskb_expand_head(skb, SKB_DATA_ALIGN(delta), 0, GFP_ATOMIC))
>>                 skb = NULL;
>> +
>> +       if (!skb) {
>> +               kfree_skb(oskb);
>> +               if (nskb)
>> +                       kfree_skb(nskb);
>> +       } else if (nskb) {
>> +               if (oskb->sk)
>> +                       skb_set_owner_w(nskb, oskb->sk);
>> +               consume_skb(oskb);
> 
> sorry, this does not fix the problem. The syzkaller repro still
> triggers the WARN.
> 
> When it happens, the skb in ip6_xmit() is not shared as it comes from
> __tcp_transmit_skb, where it is skb_clone()'d.
> 
> 

Old code (in skb_realloc_headroom())
was first calling skb2 = skb_clone(skb, GFP_ATOMIC); 

At this point, skb2->sk was NULL
So pskb_expand_head(skb2, SKB_DATA_ALIGN(delta), 0, ...) was able to tweak skb2->truesize

I would try :

diff --git a/net/core/skbuff.c b/net/core/skbuff.c
index f9311762cc475bd38d87c33e988d7c983b902e56..326749a8938637b044a616cc33b6a19ed191ac41 100644
--- a/net/core/skbuff.c
+++ b/net/core/skbuff.c
@@ -1804,6 +1804,7 @@ EXPORT_SYMBOL(skb_realloc_headroom);
 struct sk_buff *skb_expand_head(struct sk_buff *skb, unsigned int headroom)
 {
        int delta = headroom - skb_headroom(skb);
+       struct sk_buff *oskb = NULL;
 
        if (WARN_ONCE(delta <= 0,
                      "%s is expecting an increase in the headroom", __func__))
@@ -1813,19 +1814,21 @@ struct sk_buff *skb_expand_head(struct sk_buff *skb, unsigned int headroom)
        if (skb_shared(skb)) {
                struct sk_buff *nskb = skb_clone(skb, GFP_ATOMIC);
 
-               if (likely(nskb)) {
-                       if (skb->sk)
-                               skb_set_owner_w(nskb, skb->sk);
-                       consume_skb(skb);
-               } else {
+               if (unlikely(!nskb)) {
                        kfree_skb(skb);
+                       return NULL;
                }
+               oskb = skb;
                skb = nskb;
        }
-       if (skb &&
-           pskb_expand_head(skb, SKB_DATA_ALIGN(delta), 0, GFP_ATOMIC)) {
+       if (pskb_expand_head(skb, SKB_DATA_ALIGN(delta), 0, GFP_ATOMIC)) {
                kfree_skb(skb);
-               skb = NULL;
+               kfree_skb(oskb);
+               return NULL;
+       }
+       if (oskb) {
+               skb_set_owner_w(skb, oskb->sk);
+               consume_skb(oskb);
        }
        return skb;
 }



