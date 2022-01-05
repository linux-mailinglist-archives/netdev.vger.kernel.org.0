Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 84855484F99
	for <lists+netdev@lfdr.de>; Wed,  5 Jan 2022 09:54:15 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S238677AbiAEIyL (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 5 Jan 2022 03:54:11 -0500
Received: from smtp-relay-canonical-0.canonical.com ([185.125.188.120]:56670
        "EHLO smtp-relay-canonical-0.canonical.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S230087AbiAEIyK (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 5 Jan 2022 03:54:10 -0500
Received: from [192.168.1.7] (unknown [222.129.35.96])
        (using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
         key-exchange X25519 server-signature RSA-PSS (2048 bits) server-digest SHA256)
        (No client certificate requested)
        by smtp-relay-canonical-0.canonical.com (Postfix) with ESMTPSA id 7A22941937;
        Wed,  5 Jan 2022 08:54:06 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=canonical.com;
        s=20210705; t=1641372849;
        bh=/0VInOfSVksBi/+/LDZSIcnS/D6fzLNYDN2E0eg33aU=;
        h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
         In-Reply-To:Content-Type;
        b=T8dnLORTcO18xiaWQp1wOfBa47IlIzpA9vOTIJfId+0+Tz9HvGRLdZbCYaekkA1ok
         PYd4Elqr6WaJnBgcUzkAwt04oYBNAaUfworYL09N/SHaiWWLSa3mQoo0Cxs2VY4fGU
         Ataq9wI2b/u9oFppPGfVfPPRfMV5nEnQ6ubjHdvUnUOt1+s0Fn12TheWOc/a2gk7UV
         bOQYlygZaeHn9E8umeEyG92ltcfAIS6KvKHQfJfMdIz02EFTpq/MQEk32GaW/T26HR
         muyvdFcCH+dF+BRQEC1Akzz80WhEuY2hrxv15WmN6SoLU/CL2wWSvKK+msIjUNc1WT
         kQZRiEptOXyZg==
Message-ID: <77c44c18-199d-e5c6-f2b0-1b36e0028b41@canonical.com>
Date:   Wed, 5 Jan 2022 16:54:01 +0800
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:91.0) Gecko/20100101
 Thunderbird/91.4.0
Subject: Re: [PATCH] net: usb: r8152: Check used MAC passthrough address
Content-Language: en-US
To:     Henning Schild <henning.schild@siemens.com>
Cc:     kuba@kernel.org, linux-usb@vger.kernel.org, netdev@vger.kernel.org,
        linux-kernel@vger.kernel.org, davem@davemloft.net,
        hayeswang@realtek.com, tiwai@suse.de
References: <20220105061747.7104-1-aaron.ma@canonical.com>
 <20220105082355.79d44349@md1za8fc.ad001.siemens.net>
 <20220105083238.4278d331@md1za8fc.ad001.siemens.net>
 <e71f3dfd-5f17-6cdc-8f1b-9b5ad15ca793@canonical.com>
 <20220105085525.31873db2@md1za8fc.ad001.siemens.net>
 <fc72ca69-9043-dc46-6548-dbc3c4d40289@canonical.com>
 <20220105093218.283c9538@md1za8fc.ad001.siemens.net>
 <ba9f12b7-872f-8974-8865-9a2de539e09a@canonical.com>
 <20220105094702.561967ae@md1za8fc.ad001.siemens.net>
From:   Aaron Ma <aaron.ma@canonical.com>
In-Reply-To: <20220105094702.561967ae@md1za8fc.ad001.siemens.net>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org



On 1/5/22 16:47, Henning Schild wrote:
> Am Wed, 5 Jan 2022 16:37:11 +0800
> schrieb Aaron Ma <aaron.ma@canonical.com>:
> 
>> On 1/5/22 16:32, Henning Schild wrote:
>>> Am Wed, 5 Jan 2022 16:01:24 +0800
>>> schrieb Aaron Ma <aaron.ma@canonical.com>:
>>>    
>>>> On 1/5/22 15:55, Henning Schild wrote:
>>>>> Am Wed, 5 Jan 2022 15:38:51 +0800
>>>>> schrieb Aaron Ma <aaron.ma@canonical.com>:
>>>>>       
>>>>>> On 1/5/22 15:32, Henning Schild wrote:
>>>>>>> Am Wed, 5 Jan 2022 08:23:55 +0100
>>>>>>> schrieb Henning Schild <henning.schild@siemens.com>:
>>>>>>>          
>>>>>>>> Hi Aaron,
>>>>>>>>
>>>>>>>> if this or something similar goes in, please add another patch
>>>>>>>> to remove the left-over defines.
>>>>>>>>         
>>>>>>
>>>>>> Sure, I will do it.
>>>>>>      
>>>>>>>> Am Wed,  5 Jan 2022 14:17:47 +0800
>>>>>>>> schrieb Aaron Ma <aaron.ma@canonical.com>:
>>>>>>>>         
>>>>>>>>> When plugin multiple r8152 ethernet dongles to Lenovo Docks
>>>>>>>>> or USB hub, MAC passthrough address from BIOS should be
>>>>>>>>> checked if it had been used to avoid using on other dongles.
>>>>>>>>>
>>>>>>>>> Currently builtin r8152 on Dock still can't be identified.
>>>>>>>>> First detected r8152 will use the MAC passthrough address.
>>>>>>>>>
>>>>>>>>> Signed-off-by: Aaron Ma <aaron.ma@canonical.com>
>>>>>>>>> ---
>>>>>>>>>      drivers/net/usb/r8152.c | 10 ++++++++++
>>>>>>>>>      1 file changed, 10 insertions(+)
>>>>>>>>>
>>>>>>>>> diff --git a/drivers/net/usb/r8152.c b/drivers/net/usb/r8152.c
>>>>>>>>> index f9877a3e83ac..77f11b3f847b 100644
>>>>>>>>> --- a/drivers/net/usb/r8152.c
>>>>>>>>> +++ b/drivers/net/usb/r8152.c
>>>>>>>>> @@ -1605,6 +1605,7 @@ static int
>>>>>>>>> vendor_mac_passthru_addr_read(struct r8152 *tp, struct
>>>>>>>>> sockaddr *sa) char *mac_obj_name; acpi_object_type
>>>>>>>>> mac_obj_type; int mac_strlen;
>>>>>>>>> +	struct net_device *ndev;
>>>>>>>>>      
>>>>>>>>>      	if (tp->lenovo_macpassthru) {
>>>>>>>>>      		mac_obj_name = "\\MACA";
>>>>>>>>> @@ -1662,6 +1663,15 @@ static int
>>>>>>>>> vendor_mac_passthru_addr_read(struct r8152 *tp, struct
>>>>>>>>> sockaddr *sa) ret = -EINVAL; goto amacout;
>>>>>>>>>      	}
>>>>>>>>> +	rcu_read_lock();
>>>>>>>>> +	for_each_netdev_rcu(&init_net, ndev) {
>>>>>>>>> +		if (strncmp(buf, ndev->dev_addr, 6) == 0) {
>>>>>>>>> +			rcu_read_unlock();
>>>>>>>>> +			goto amacout;
>>>>>>>>
>>>>>>>> Since the original PCI netdev will always be there, that would
>>>>>>>> disable inheritance would it not?
>>>>>>>> I guess a strncmp(MODULE_NAME, info->driver,
>>>>>>>> strlen(MODULE_NAME)) is needed as well.
>>>>>>>>         
>>>>>>
>>>>>> PCI ethernet could be a builtin one on dock since there will be
>>>>>> TBT4 dock.
>>>>>
>>>>> In my X280 there is a PCI device in the laptop, always there. And
>>>>> its MAC is the one found in ACPI. Did not try but i think for such
>>>>> devices there would never be inheritance even if one wanted and
>>>>> used a Lenovo dock that is supposed to do it.
>>>>>       
>>>>
>>>> There will more TBT4 docks in market, the new ethernet is just the
>>>> same as PCI device, connected by thunderbolt.
>>>>
>>>> For exmaple, connect a TBT4 dock which uses i225 pcie base
>>>> ethernet, then connect another TBT3 dock which uses r8152.
>>>> If skip PCI check, then i225 and r8152 will use the same MAC.
>>>
>>> In current 5.15 i have that sort of collision already. All r8152s
>>> will happily grab the MAC of the I219. In fact i have only ever
>>> seen it with one r8152 at a time but while the I219 was actively in
>>> use. While this patch will probably solve that, i bet it would
>>> defeat MAC pass-thru altogether. Even when turned on in the BIOS.
>>> Or does that iterator take "up"/"down" state into consideration? But
>>> even if, the I219 could become "up" any time later.
>>>    
>>
>> No, that's different, I219 got MAC from their own space.
>> MAC passthrough got MAC from ACPI "\MACA".
> 
> On my machine "\MACA" and I219 are the same, likely "\MACA" was
> populated by looking at that I219 by the BIOS.
> Not sure if "\MACA" can change when plugging docks, but probably not
> since the BIOS is also trying to implement inheritance of the main MAC.
> 
> Let me try this patch, maybe i do not get it.

That's expected, MAC passthrough is intended to replace I219.
This feature allows the MAC address of the native Ethernet network device on the system to be used
on dock.
The company network only see one MAC for your laptop.

Aaron

> 
> Henning
> 
>>> These collisions are simply bound to happen and probably very hard
>>> to avoid once you have set your mind on allowing pass-thru in the
>>> first place. Not sure whether that even has potential to disturb
>>> network equipment like switches.
>>>    
>>
>> After check MAC address, it will be more safe.
>>
>> Aaron
>>
>>> Henning
>>>    
>>>> Aaron
>>>>   
>>>>> Maybe i should try the patch but it seems like it defeats
>>>>> inheritance completely. Well depending on probe order ...
>>>>>
>>>>> regards,
>>>>> Henning
>>>>>
>>>>>       
>>>>>>>> Maybe leave here with
>>>>>>>> netif_info()
>>>>>>>>         
>>>>>>
>>>>>> Not good to print in rcu lock.
>>>>>>      
>>>>>>>> And move the whole block up, we can skip the whole ACPI story
>>>>>>>> if we find the MAC busy.
>>>>>>>
>>>>>>> That is wrong, need to know that MAC so can not move up too
>>>>>>> much. But maybe above the is_valid_ether_addr
>>>>>>
>>>>>> The MAC passthough address is read from ACPI.
>>>>>> ACPI read only happens once during r8152 driver probe.
>>>>>> To keep the lock less time, do it after is_valid_ether_addr.
>>>>>>      
>>>>>>>
>>>>>>> Henning
>>>>>>>          
>>>>>>>>> +		}
>>>>>>>>> +	}
>>>>>>>>> +	rcu_read_unlock();
>>>>>>>>
>>>>>>>> Not sure if this function is guaranteed to only run once at a
>>>>>>>> time, otherwise i think that is a race. Multiple instances
>>>>>>>> could make it to this very point at the same time.
>>>>>>>>         
>>>>>>
>>>>>> Run once for one device.
>>>>>> So add a safe lock.
>>>>>>
>>>>>> Aaron
>>>>>>      
>>>>>>>> Henning
>>>>>>>>         
>>>>>>>>>      	memcpy(sa->sa_data, buf, 6);
>>>>>>>>>      	netif_info(tp, probe, tp->netdev,
>>>>>>>>>      		   "Using pass-thru MAC addr %pM\n",
>>>>>>>>> sa->sa_data);
>>>>>>>>         
>>>>>>>          
>>>>>       
>>>    
> 
