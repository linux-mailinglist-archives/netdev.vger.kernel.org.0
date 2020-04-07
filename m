Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 414C21A0728
	for <lists+netdev@lfdr.de>; Tue,  7 Apr 2020 08:23:01 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726917AbgDGGWw (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 7 Apr 2020 02:22:52 -0400
Received: from mail-wr1-f66.google.com ([209.85.221.66]:46199 "EHLO
        mail-wr1-f66.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726232AbgDGGWv (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 7 Apr 2020 02:22:51 -0400
Received: by mail-wr1-f66.google.com with SMTP id j17so2392520wru.13
        for <netdev@vger.kernel.org>; Mon, 06 Apr 2020 23:22:50 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=subject:to:cc:references:from:message-id:date:user-agent
         :mime-version:in-reply-to:content-language:content-transfer-encoding;
        bh=E/XiOmdXvqiLyCleOOnc9Bqumf9NClc56J5DqrJioV4=;
        b=F69SyqKJiqbvHUrgcUl43dAzFu9CUilAAibW02C4pg2hPra4FU0DoxLgpS6+Y2OXME
         3S6r+Izk6asYqbNup9+XriFTLUynMZzVPGQ0vGYlQlEzIL6NrFniV4gUH7eQEgEd6HDU
         koFbzuRTHGs6BSRUfFBew0PMhWavoIWigJAMFtL2XAj+3Uqwc38oiXFJI/+fU5bWZZXR
         cPCqOQhTptzkmwORqJxsitsgOflPet4wdqgiR1ijOTXAA8KrefgcLYg/UVuJdmauY/X6
         SJWTJeliXwRfYDykE3th4kUu1EVC1Fc+SMvGKWaHPF3o+C5ib55yiv/ZAD72XerY/t61
         k2ww==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:subject:to:cc:references:from:message-id:date
         :user-agent:mime-version:in-reply-to:content-language
         :content-transfer-encoding;
        bh=E/XiOmdXvqiLyCleOOnc9Bqumf9NClc56J5DqrJioV4=;
        b=r+XhGPRmpbRhMMErErLDNAuVs+Hj5WTr3f796x6pJdmuqLBiCquSyFJn85b+vOF4RM
         OmZpjPvuo5Z2mrgh9U9JSb/RoOjbCQT/3VEvXOCq7ZMO/O001ygNcM9fsn6d1sH5xOmj
         zyvnh9W40Od44w7Xmo9OTi/V9Nu2OEHUj0yXwdb/Bie/4NZxQ+zKyEG4ps975f4dXMCQ
         HnN+ZVJsl3AHyHjewlWRJtH4VN9GWOry7Z93O0bJwq/1X/o1n5HYYWYS7STR8ynHwYFa
         Y3YMP8XzdTGPYjHzRpGbROc2xjrfM/zMnist37W5izcWJZuhJ0e4KIcV7k4Lk6SDvaQh
         +Kfg==
X-Gm-Message-State: AGi0PubC9RU/8Lxj4eXNi2n74E7c8DupX4F1llv4ThmzaQJdPZmcu8hU
        su9nj+vE9vWWeqb/i2iWfxF20CLF
X-Google-Smtp-Source: APiQypLEtAvtT1wl/5GtA94bj8mDnEBqkYM1BpfpETEj25YHthCpNTiwxF0vbUH6icBEYa0hXFVbnw==
X-Received: by 2002:adf:f8c1:: with SMTP id f1mr896688wrq.345.1586240569816;
        Mon, 06 Apr 2020 23:22:49 -0700 (PDT)
Received: from ?IPv6:2003:ea:8f29:6000:7992:12bb:3a79:c8a4? (p200300EA8F296000799212BB3A79C8A4.dip0.t-ipconnect.de. [2003:ea:8f29:6000:7992:12bb:3a79:c8a4])
        by smtp.googlemail.com with ESMTPSA id o16sm29690942wrs.44.2020.04.06.23.22.49
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Mon, 06 Apr 2020 23:22:49 -0700 (PDT)
Subject: Re: [PATCH net] r8169: fix multicast tx issue with macvlan interface
To:     Eric Dumazet <eric.dumazet@gmail.com>,
        Charles DAYMAND <charles.daymand@wifirst.fr>
Cc:     Eric Dumazet <edumazet@google.com>, netdev <netdev@vger.kernel.org>
References: <20200327090800.27810-1-charles.daymand@wifirst.fr>
 <0bab7e0b-7b22-ad0f-2558-25602705e807@gmail.com>
 <d7a0eca8-15aa-10da-06cc-1eeef3a7a423@gmail.com>
 <CANn89iKA8k3GyxCKCJRacB42qcFqUDsiRhFOZxOQ7JCED0ChyQ@mail.gmail.com>
 <42f81a4a-24fc-f1fb-11db-ea90a692f249@gmail.com>
 <CANn89i+A=Mu=9LMscd2Daqej+uVLc3E6w33MZzTwpe2v+k89Mw@mail.gmail.com>
 <CAFJtzm03QpjGRs70tth26BdUFN_o8zsJOccbnA58ma+2uwiGcg@mail.gmail.com>
 <c02274b9-1ba0-d5e9-848f-5d6761df20f4@gmail.com>
 <CAFJtzm0H=pztSp_RQt_YNnPHQkq4N4Z5S-PqMFgE=Fp=Fo-G_w@mail.gmail.com>
 <df776fc4-871d-d82c-a202-ba4f4d7bfb42@gmail.com>
 <b3867109-d09c-768c-7210-74e6f76c12b8@gmail.com>
From:   Heiner Kallweit <hkallweit1@gmail.com>
Message-ID: <d9c6ba82-4f3e-0f7e-e1f8-516da25e1fe4@gmail.com>
Date:   Tue, 7 Apr 2020 08:22:44 +0200
User-Agent: Mozilla/5.0 (Windows NT 10.0; WOW64; rv:68.0) Gecko/20100101
 Thunderbird/68.6.0
MIME-Version: 1.0
In-Reply-To: <b3867109-d09c-768c-7210-74e6f76c12b8@gmail.com>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On 07.04.2020 01:20, Eric Dumazet wrote:
> 
> 
> On 4/6/20 3:16 PM, Heiner Kallweit wrote:
> 
>>
>> In a similar context Realtek made me aware of a hw issue if IP header
>> has the options field set. You mentioned problems with multicast packets,
>> and based on the following code the root cause may be related.
>>
>> br_ip4_multicast_alloc_query()
>> -> iph->ihl = 6;
>>
>> I'd appreciate if you could test (with HW tx checksumming enabled)
>> whether this experimental patch fixes the issue with invalid/lost
>> multicasts.
>>
>>
>> diff --git a/drivers/net/ethernet/realtek/r8169_main.c b/drivers/net/ethernet/realtek/r8169_main.c
>> index e40e8eaeb..dd251ddb8 100644
>> --- a/drivers/net/ethernet/realtek/r8169_main.c
>> +++ b/drivers/net/ethernet/realtek/r8169_main.c
>> @@ -4319,6 +4319,10 @@ static netdev_features_t rtl8169_features_check(struct sk_buff *skb,
>>  		    rtl_chip_supports_csum_v2(tp))
>>  			features &= ~NETIF_F_ALL_TSO;
>>  	} else if (skb->ip_summed == CHECKSUM_PARTIAL) {
>> +		if (ip_hdrlen(skb) > sizeof(struct iphdr)) {
> 
> Packet could be non IPv4 at this point. (IPv6 for instance)
> 
Right, I should have mentioned it:
This experimental patch is for IPv4 only. In a final version (if it indeed
fixes the issue) I had to extend the condition and check for IPv4.

>> +			pr_info("hk: iphdr has options field set\n");
>> +			features &= ~NETIF_F_CSUM_MASK;
>> +		}
>>  		if (skb->len < ETH_ZLEN) {
>>  			switch (tp->mac_version) {
>>  			case RTL_GIGA_MAC_VER_11:
>>

