Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 62AC2883F6
	for <lists+netdev@lfdr.de>; Fri,  9 Aug 2019 22:29:35 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729285AbfHIU3N (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 9 Aug 2019 16:29:13 -0400
Received: from mail-wm1-f67.google.com ([209.85.128.67]:54422 "EHLO
        mail-wm1-f67.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1728252AbfHIU3E (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 9 Aug 2019 16:29:04 -0400
Received: by mail-wm1-f67.google.com with SMTP id p74so6857654wme.4
        for <netdev@vger.kernel.org>; Fri, 09 Aug 2019 13:29:03 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=subject:to:cc:references:from:message-id:date:user-agent
         :mime-version:in-reply-to:content-language:content-transfer-encoding;
        bh=CmEgRNqIeV0a7KgiakkqHxuM8a0X+gLkpJeoGnJ3RS4=;
        b=vGvc9aCEvVV9t8GZnhgJTD4dAHDeZQTEEQFUZZUWtEIiqEwJ+CHwA0xOCAoAab9fyW
         Ltb2iKOkzNudXptcnDoBDFKEACo0NZsHnrYYEStQeYdjROUFrjyQEIQqoFYT2z5cOgXq
         kRBGgXaQqDubN3PfjEpGZuopNlzuESab13uxwtBGrqi3m6fsJVblAD+EA10Es6Jlr8Eg
         Ku+cG/4p3cetPVFK6SjLVWEZ0RrnXYsZRRnpu4Bh0lWWADTyfV/IGPfXIR3Xlb83ymU3
         Of7dJTNB+CYRHSf+vPYUofXWNLQIR730F+jl64oGl3/4BoQ7ht/CZEoLr/ewf05ql0iK
         jnmA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:subject:to:cc:references:from:message-id:date
         :user-agent:mime-version:in-reply-to:content-language
         :content-transfer-encoding;
        bh=CmEgRNqIeV0a7KgiakkqHxuM8a0X+gLkpJeoGnJ3RS4=;
        b=RJ1YJQcVyAnC2DLVOVlGZVhmtMvZ1jgpO9JSKy2ZXJYN/KH8rDB/0wNP0NSJBDFdrb
         uVUe5P72eQ8J4ei58tyYKPkxAXKYtYTV+4a+s3vpenTguRCGkCGjCRcjNOI3gevXto4S
         CbmwvVvZINcwvNPmZ2ugPtRJP2bliMFOpV+wiOyp9woXTBOe4BthCKiKmlPDifeHpdMY
         +PvTuDNSGSHwJBwWtsQoIqhVCtODcXUmdLpKM1xK1AJ8aK6/xfX5x0Jnd9jqO6op/9p6
         LUMgkXYLgKOYaSLBJZO2+L2/R8VgrmT6GwotpnRLVUmxe5YcQ9MF6x7l+wbgbhRu5cuP
         2TKA==
X-Gm-Message-State: APjAAAXSZgdVuUx4T5GW0dww0+h/PsPTKro0fLfR1xEb0mFnXPZc3yj6
        0jIOwVhYzWCVg4ZLirmvIoo=
X-Google-Smtp-Source: APXvYqw0qEJT2O3ASo8I1HbuY8Qe5nz/+KI2zIineeS7u8w9s6PCJz7b1Pn8iEacrx6+u9U2HGZnEg==
X-Received: by 2002:a1c:e710:: with SMTP id e16mr13174831wmh.38.1565382543354;
        Fri, 09 Aug 2019 13:29:03 -0700 (PDT)
Received: from ?IPv6:2003:ea:8f2f:3200:2994:d24a:66a1:e0e5? (p200300EA8F2F32002994D24A66A1E0E5.dip0.t-ipconnect.de. [2003:ea:8f2f:3200:2994:d24a:66a1:e0e5])
        by smtp.googlemail.com with ESMTPSA id i66sm14159409wmi.11.2019.08.09.13.29.02
        (version=TLS1_2 cipher=ECDHE-RSA-AES128-GCM-SHA256 bits=128/128);
        Fri, 09 Aug 2019 13:29:02 -0700 (PDT)
Subject: Re: [PATCH net-next] r8169: make use of xmit_more
To:     =?UTF-8?Q?Holger_Hoffst=c3=a4tte?= <holger@applied-asynchrony.com>,
        Eric Dumazet <edumazet@google.com>
Cc:     Realtek linux nic maintainers <nic_swsd@realtek.com>,
        David Miller <davem@davemloft.net>,
        "netdev@vger.kernel.org" <netdev@vger.kernel.org>,
        Sander Eikelenboom <linux@eikelenboom.it>
References: <2950b2f7-7460-cce0-d964-ad654d897295@gmail.com>
 <acd65426-0c7e-8c5f-a002-a36286f09122@applied-asynchrony.com>
 <cfb9a1c7-57c8-db04-1081-ac1cb92bb447@applied-asynchrony.com>
 <a19bb3de-a866-d342-7cca-020fef219d03@gmail.com>
 <868a1f4c-5fba-c64b-ea31-30a3770e6a2f@applied-asynchrony.com>
 <f08a3207-0930-4b71-16f1-81e352f87a9c@gmail.com>
 <eecaaf82-e6cd-2b75-5756-006a70258a9f@applied-asynchrony.com>
 <CANn89iKjPz5-EypQ9cb3LRsLJBy1Hr0vLoW6Sjd_Df082H1Yzw@mail.gmail.com>
 <72a58a6b-974c-0feb-2fa4-c8a71c7eff7e@applied-asynchrony.com>
From:   Heiner Kallweit <hkallweit1@gmail.com>
Message-ID: <e46acb1c-36e9-2713-694e-9122b7b166bb@gmail.com>
Date:   Fri, 9 Aug 2019 22:28:54 +0200
User-Agent: Mozilla/5.0 (Windows NT 10.0; WOW64; rv:60.0) Gecko/20100101
 Thunderbird/60.8.0
MIME-Version: 1.0
In-Reply-To: <72a58a6b-974c-0feb-2fa4-c8a71c7eff7e@applied-asynchrony.com>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 8bit
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On 09.08.2019 10:52, Holger Hoffstätte wrote:
> On 8/9/19 10:25 AM, Eric Dumazet wrote:
> (snip)
>>>
>>> So that didn't take long - got another timeout this morning during some
>>> random light usage, despite sg/tso being disabled this time.
>>> Again the only common element is the xmit_more patch. :(
>>> Not sure whether you want to revert this right away or wait for 5.4-rc1
>>> feedback. Maybe this too is chipset-specific?
>>>
>>>> Thanks a lot for the analysis and testing. Then I'll submit the disabling
>>>> of SG on RTL8168evl (on your behalf), independent of whether it fixes
>>>> the timeout issue.
>>>
>>> Got it, thanks!
>>>
>>> Holger
>>
>> I would try this fix maybe ?
>>
>> diff --git a/drivers/net/ethernet/realtek/r8169_main.c
>> b/drivers/net/ethernet/realtek/r8169_main.c
>> index b2a275d8504cf099cff738f2f7554efa9658fe32..e77628813daba493ad50dab9ac1e3703e38b560c
>> 100644
>> --- a/drivers/net/ethernet/realtek/r8169_main.c
>> +++ b/drivers/net/ethernet/realtek/r8169_main.c
>> @@ -5691,6 +5691,7 @@ static netdev_tx_t rtl8169_start_xmit(struct sk_buff *skb,
>>                   */
>>                  smp_wmb();
>>                  netif_stop_queue(dev);
>> +               door_bell = true;
>>          }
>>
>>          if (door_bell)
>>
> 
> Thanks Eric, I'll give that a try and see how it fares over the next few days.
> It suspiciously looks like it could help..
> 
> -h
> 
Thanks for testing this. Looking forward to your feedback regarding the change.

Heiner
