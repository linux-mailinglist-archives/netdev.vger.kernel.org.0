Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 20AD487497
	for <lists+netdev@lfdr.de>; Fri,  9 Aug 2019 10:52:34 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2405976AbfHIIwc (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 9 Aug 2019 04:52:32 -0400
Received: from mail02.iobjects.de ([188.40.134.68]:54734 "EHLO
        mail02.iobjects.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S2405941AbfHIIwc (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 9 Aug 2019 04:52:32 -0400
Received: from tux.wizards.de (p5DE2B30B.dip0.t-ipconnect.de [93.226.179.11])
        by mail02.iobjects.de (Postfix) with ESMTPSA id 9F5EA416013A;
        Fri,  9 Aug 2019 10:52:30 +0200 (CEST)
Received: from [192.168.100.223] (ragnarok.applied-asynchrony.com [192.168.100.223])
        by tux.wizards.de (Postfix) with ESMTP id 6CB0FF0160E;
        Fri,  9 Aug 2019 10:52:30 +0200 (CEST)
Subject: Re: [PATCH net-next] r8169: make use of xmit_more
To:     Eric Dumazet <edumazet@google.com>
Cc:     Heiner Kallweit <hkallweit1@gmail.com>,
        Realtek linux nic maintainers <nic_swsd@realtek.com>,
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
From:   =?UTF-8?Q?Holger_Hoffst=c3=a4tte?= <holger@applied-asynchrony.com>
Organization: Applied Asynchrony, Inc.
Message-ID: <72a58a6b-974c-0feb-2fa4-c8a71c7eff7e@applied-asynchrony.com>
Date:   Fri, 9 Aug 2019 10:52:30 +0200
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:60.0) Gecko/20100101
 Thunderbird/60.8.0
MIME-Version: 1.0
In-Reply-To: <CANn89iKjPz5-EypQ9cb3LRsLJBy1Hr0vLoW6Sjd_Df082H1Yzw@mail.gmail.com>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On 8/9/19 10:25 AM, Eric Dumazet wrote:
(snip)
>>
>> So that didn't take long - got another timeout this morning during some
>> random light usage, despite sg/tso being disabled this time.
>> Again the only common element is the xmit_more patch. :(
>> Not sure whether you want to revert this right away or wait for 5.4-rc1
>> feedback. Maybe this too is chipset-specific?
>>
>>> Thanks a lot for the analysis and testing. Then I'll submit the disabling
>>> of SG on RTL8168evl (on your behalf), independent of whether it fixes
>>> the timeout issue.
>>
>> Got it, thanks!
>>
>> Holger
> 
> I would try this fix maybe ?
> 
> diff --git a/drivers/net/ethernet/realtek/r8169_main.c
> b/drivers/net/ethernet/realtek/r8169_main.c
> index b2a275d8504cf099cff738f2f7554efa9658fe32..e77628813daba493ad50dab9ac1e3703e38b560c
> 100644
> --- a/drivers/net/ethernet/realtek/r8169_main.c
> +++ b/drivers/net/ethernet/realtek/r8169_main.c
> @@ -5691,6 +5691,7 @@ static netdev_tx_t rtl8169_start_xmit(struct sk_buff *skb,
>                   */
>                  smp_wmb();
>                  netif_stop_queue(dev);
> +               door_bell = true;
>          }
> 
>          if (door_bell)
> 

Thanks Eric, I'll give that a try and see how it fares over the next few days.
It suspiciously looks like it could help..

-h
