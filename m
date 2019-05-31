Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 8DE39313F0
	for <lists+netdev@lfdr.de>; Fri, 31 May 2019 19:35:31 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726678AbfEaRfY (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 31 May 2019 13:35:24 -0400
Received: from mail-pg1-f196.google.com ([209.85.215.196]:36640 "EHLO
        mail-pg1-f196.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1725913AbfEaRfX (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 31 May 2019 13:35:23 -0400
Received: by mail-pg1-f196.google.com with SMTP id a3so4424637pgb.3;
        Fri, 31 May 2019 10:35:23 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=subject:to:cc:references:from:message-id:date:user-agent
         :mime-version:in-reply-to:content-language:content-transfer-encoding;
        bh=wMCuYwpMjG1YZSXNE/hDJ22AreM7u72wA8DYLemzKlM=;
        b=eJOgNfohAy+su0elwDRNsmjVxZ2dQ6AIhVVafMCZlge+eT3le4uN2IcoULLocJvEj/
         qace1DpCnhZj7sPQYFENG2bp0doFbbgQg2uMk4MimAo5uvI2dNrZORF/MmhRYDhui9IT
         wa1WDlOabqaUxkRcL0Cg29OkPG/jql5w7fk0KkeZrOyJORV5VLTN5T3bG/uU7lN7axyW
         IviZywZZb3Kjar6oujFAiD4QNmqPZq2PNIC9M5+jwkPbSV3MrklbyBtKXNCJBOplbvSh
         6bCpUlKbQ598wJUMK5dK5GBOKGL+J5xm16bUqV94U0f7frRM7rPs8U1eYua9GMdRcC95
         c39w==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:subject:to:cc:references:from:message-id:date
         :user-agent:mime-version:in-reply-to:content-language
         :content-transfer-encoding;
        bh=wMCuYwpMjG1YZSXNE/hDJ22AreM7u72wA8DYLemzKlM=;
        b=DRvf1X2RRI/lhh1GSWOp5r6q86DQfSIR+N/MafQzp2zzbR3RGyG37gxLMX5IPZVp2c
         jH+sqPs5mXLjOMP2J71DeYFbnQe0MkImSDOaelzFNwFYFG88WQ1O34InM6Xr5DtqHm4u
         isdFYFQ4sCx4SPcs6WEWb/aczuaBtG9PCaFpb2c5JOywyS1jEkBZDpwgY9PInyf5mmFP
         rWg/8rYH/vC8YPzJ1KdWr42gWrnWSaPU6hKkao9Tl6kYUGoClKwnDHRQIrq9qeJ/plXN
         pXPxKLNrGLJtkIJ44eUZ88eP+dMzx3CMsrOqXWh2ufR/Cl9gXyq8h8By19hrzJjmiwqs
         piIQ==
X-Gm-Message-State: APjAAAVN8qRzeWcYH+LTRTDfF88uyuYjm2s6y07maVs+V5HD5Lhx4I/g
        xnyMqcQE1iZSGHRdI2XVgXz+gz1v
X-Google-Smtp-Source: APXvYqy4/eIf5sk/vkYcZ/Sr7bqBMW2sH1G3WtD8rZ6hb475weubXu+2aBC3oKtm8jAdAgAcdQX+sA==
X-Received: by 2002:a17:90a:207:: with SMTP id c7mr10587815pjc.82.1559324122844;
        Fri, 31 May 2019 10:35:22 -0700 (PDT)
Received: from ?IPv6:2620:15c:2c1:200:55c7:81e6:c7d8:94b? ([2620:15c:2c1:200:55c7:81e6:c7d8:94b])
        by smtp.gmail.com with ESMTPSA id d3sm688307pfa.176.2019.05.31.10.35.21
        (version=TLS1_3 cipher=AEAD-AES128-GCM-SHA256 bits=128/128);
        Fri, 31 May 2019 10:35:22 -0700 (PDT)
Subject: Re: [PATCH] ipv6: Prevent overrun when parsing v6 header options
To:     Yang Xiao <92siuyang@gmail.com>
Cc:     David Miller <davem@davemloft.net>,
        Alexey Kuznetsov <kuznet@ms2.inr.ac.ru>,
        Hideaki YOSHIFUJI <yoshfuji@linux-ipv6.org>,
        netdev <netdev@vger.kernel.org>,
        LKML <linux-kernel@vger.kernel.org>,
        Steffen Klassert <steffen.klassert@secunet.com>,
        Herbert Xu <herbert@gondor.apana.org.au>
References: <1559230098-1543-1-git-send-email-92siuyang@gmail.com>
 <c83f8777-f6be-029b-980d-9f974b4e28ce@gmail.com>
 <CAKgHYH1=aqmOEsbH-OuSjK4CJ=9FmocjuOg6tsyJNPLEOWVB-g@mail.gmail.com>
From:   Eric Dumazet <eric.dumazet@gmail.com>
Message-ID: <a0f08b20-41ef-db53-48df-4d8f5333b6af@gmail.com>
Date:   Fri, 31 May 2019 10:35:20 -0700
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:60.0) Gecko/20100101
 Thunderbird/60.6.1
MIME-Version: 1.0
In-Reply-To: <CAKgHYH1=aqmOEsbH-OuSjK4CJ=9FmocjuOg6tsyJNPLEOWVB-g@mail.gmail.com>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org



On 5/30/19 8:04 PM, Yang Xiao wrote:
> On Fri, May 31, 2019 at 1:17 AM Eric Dumazet <eric.dumazet@gmail.com> wrote:
>>
>>
>>
>> On 5/30/19 8:28 AM, Young Xiao wrote:
>>> The fragmentation code tries to parse the header options in order
>>> to figure out where to insert the fragment option.  Since nexthdr points
>>> to an invalid option, the calculation of the size of the network header
>>> can made to be much larger than the linear section of the skb and data
>>> is read outside of it.
>>>
>>> This vulnerability is similar to CVE-2017-9074.
>>>
>>> Signed-off-by: Young Xiao <92siuyang@gmail.com>
>>> ---
>>>  net/ipv6/mip6.c | 24 ++++++++++++++----------
>>>  1 file changed, 14 insertions(+), 10 deletions(-)
>>>
>>> diff --git a/net/ipv6/mip6.c b/net/ipv6/mip6.c
>>> index 64f0f7b..30ed1c5 100644
>>> --- a/net/ipv6/mip6.c
>>> +++ b/net/ipv6/mip6.c
>>> @@ -263,8 +263,6 @@ static int mip6_destopt_offset(struct xfrm_state *x, struct sk_buff *skb,
>>>                              u8 **nexthdr)
>>>  {
>>>       u16 offset = sizeof(struct ipv6hdr);
>>> -     struct ipv6_opt_hdr *exthdr =
>>> -                                (struct ipv6_opt_hdr *)(ipv6_hdr(skb) + 1);
>>>       const unsigned char *nh = skb_network_header(skb);
>>>       unsigned int packet_len = skb_tail_pointer(skb) -
>>>               skb_network_header(skb);
>>> @@ -272,7 +270,8 @@ static int mip6_destopt_offset(struct xfrm_state *x, struct sk_buff *skb,
>>>
>>>       *nexthdr = &ipv6_hdr(skb)->nexthdr;
>>>
>>> -     while (offset + 1 <= packet_len) {
>>> +     while (offset <= packet_len) {
>>> +             struct ipv6_opt_hdr *exthdr;
>>>
>>>               switch (**nexthdr) {
>>>               case NEXTHDR_HOP:
>>> @@ -299,12 +298,15 @@ static int mip6_destopt_offset(struct xfrm_state *x, struct sk_buff *skb,
>>>                       return offset;
>>>               }
>>>
>>> +             if (offset + sizeof(struct ipv6_opt_hdr) > packet_len)
>>> +                     return -EINVAL;
>>> +
>>> +             exthdr = (struct ipv6_opt_hdr *)(nh + offset);
>>>               offset += ipv6_optlen(exthdr);
>>>               *nexthdr = &exthdr->nexthdr;
>>> -             exthdr = (struct ipv6_opt_hdr *)(nh + offset);
>>>       }
>>>
>>> -     return offset;
>>> +     return -EINVAL;
>>>  }
>>>
>>
>>
>> Ok, but have you checked that callers have been fixed ?
> 
> I've checked the callers. There are two callers:
> xfrm6_transport_output() and xfrm6_ro_output(). There are checks in
> both function.
> 
> ------------------------------------------------------------------------------
>         hdr_len = x->type->hdr_offset(x, skb, &prevhdr);
>         if (hdr_len < 0)
>                 return hdr_len;
> ------------------------------------------------------------------------------
>>
>> xfrm6_transport_output() seems buggy as well,
>> unless the skbs are linearized before entering these functions ?
> I can not understand what you mean about this comment.
> Could you explain it in more detail.


If we had a problem, then the memmove(ipv6_hdr(skb), iph, hdr_len);
 in xfrm6_transport_output() would be buggy, since iph could also point to freed memory.



