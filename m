Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 7EF65484EF7
	for <lists+netdev@lfdr.de>; Wed,  5 Jan 2022 09:01:36 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S238279AbiAEIBe (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 5 Jan 2022 03:01:34 -0500
Received: from smtp-relay-canonical-0.canonical.com ([185.125.188.120]:52310
        "EHLO smtp-relay-canonical-0.canonical.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S229880AbiAEIBd (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 5 Jan 2022 03:01:33 -0500
Received: from [192.168.1.7] (unknown [222.129.35.96])
        (using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
         key-exchange X25519 server-signature RSA-PSS (2048 bits) server-digest SHA256)
        (No client certificate requested)
        by smtp-relay-canonical-0.canonical.com (Postfix) with ESMTPSA id A416841938;
        Wed,  5 Jan 2022 08:01:29 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=canonical.com;
        s=20210705; t=1641369692;
        bh=9wD1JxRaWZs6Kc2SP2+CnPTzm85J12Nvcvl6p/eRMLE=;
        h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
         In-Reply-To:Content-Type;
        b=QjmV1ZULSzSO6nBJ5n+WoUXzcLUNWXQQMJt5gICawmVShOeGp/p4/oOfu2Q66n3xm
         QuyIlfPjMX9XMbZYKgS5hejabzcRQexZRiFzTyGyEa+MuzNrBbo585BTm9fMlZV9JX
         ruOZD1cn1NlHDD4ogU9KkXW4U7M2ilsmD0nA8TwuNQZEeZuCTvJg+IGqQrnUv12vXE
         EOys0dn1Lpi5s3YdWGGY6nV36dVWL8RE/+mLAT4475xX5WJg20M9gOxJBUP30NRKTB
         8TATsqtuQOVBEadcRlXzl2h+nU9abUIoi8k8rkPpOWxtWEkgjUFNbE8PdKJPUlCE22
         C1/lOUebDBoLQ==
Message-ID: <fc72ca69-9043-dc46-6548-dbc3c4d40289@canonical.com>
Date:   Wed, 5 Jan 2022 16:01:24 +0800
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
From:   Aaron Ma <aaron.ma@canonical.com>
In-Reply-To: <20220105085525.31873db2@md1za8fc.ad001.siemens.net>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org



On 1/5/22 15:55, Henning Schild wrote:
> Am Wed, 5 Jan 2022 15:38:51 +0800
> schrieb Aaron Ma <aaron.ma@canonical.com>:
> 
>> On 1/5/22 15:32, Henning Schild wrote:
>>> Am Wed, 5 Jan 2022 08:23:55 +0100
>>> schrieb Henning Schild <henning.schild@siemens.com>:
>>>    
>>>> Hi Aaron,
>>>>
>>>> if this or something similar goes in, please add another patch to
>>>> remove the left-over defines.
>>>>   
>>
>> Sure, I will do it.
>>
>>>> Am Wed,  5 Jan 2022 14:17:47 +0800
>>>> schrieb Aaron Ma <aaron.ma@canonical.com>:
>>>>   
>>>>> When plugin multiple r8152 ethernet dongles to Lenovo Docks
>>>>> or USB hub, MAC passthrough address from BIOS should be
>>>>> checked if it had been used to avoid using on other dongles.
>>>>>
>>>>> Currently builtin r8152 on Dock still can't be identified.
>>>>> First detected r8152 will use the MAC passthrough address.
>>>>>
>>>>> Signed-off-by: Aaron Ma <aaron.ma@canonical.com>
>>>>> ---
>>>>>    drivers/net/usb/r8152.c | 10 ++++++++++
>>>>>    1 file changed, 10 insertions(+)
>>>>>
>>>>> diff --git a/drivers/net/usb/r8152.c b/drivers/net/usb/r8152.c
>>>>> index f9877a3e83ac..77f11b3f847b 100644
>>>>> --- a/drivers/net/usb/r8152.c
>>>>> +++ b/drivers/net/usb/r8152.c
>>>>> @@ -1605,6 +1605,7 @@ static int
>>>>> vendor_mac_passthru_addr_read(struct r8152 *tp, struct sockaddr
>>>>> *sa) char *mac_obj_name; acpi_object_type mac_obj_type;
>>>>>    	int mac_strlen;
>>>>> +	struct net_device *ndev;
>>>>>    
>>>>>    	if (tp->lenovo_macpassthru) {
>>>>>    		mac_obj_name = "\\MACA";
>>>>> @@ -1662,6 +1663,15 @@ static int
>>>>> vendor_mac_passthru_addr_read(struct r8152 *tp, struct sockaddr
>>>>> *sa) ret = -EINVAL; goto amacout;
>>>>>    	}
>>>>> +	rcu_read_lock();
>>>>> +	for_each_netdev_rcu(&init_net, ndev) {
>>>>> +		if (strncmp(buf, ndev->dev_addr, 6) == 0) {
>>>>> +			rcu_read_unlock();
>>>>> +			goto amacout;
>>>>
>>>> Since the original PCI netdev will always be there, that would
>>>> disable inheritance would it not?
>>>> I guess a strncmp(MODULE_NAME, info->driver, strlen(MODULE_NAME))
>>>> is needed as well.
>>>>   
>>
>> PCI ethernet could be a builtin one on dock since there will be TBT4
>> dock.
> 
> In my X280 there is a PCI device in the laptop, always there. And its
> MAC is the one found in ACPI. Did not try but i think for such devices
> there would never be inheritance even if one wanted and used a Lenovo
> dock that is supposed to do it.
> 

There will more TBT4 docks in market, the new ethernet is just the same as
PCI device, connected by thunderbolt.

For exmaple, connect a TBT4 dock which uses i225 pcie base ethernet,
then connect another TBT3 dock which uses r8152.
If skip PCI check, then i225 and r8152 will use the same MAC.

Aaron

> Maybe i should try the patch but it seems like it defeats inheritance
> completely. Well depending on probe order ...
> 
> regards,
> Henning
> 
> 
>>>> Maybe leave here with
>>>> netif_info()
>>>>   
>>
>> Not good to print in rcu lock.
>>
>>>> And move the whole block up, we can skip the whole ACPI story if we
>>>> find the MAC busy.
>>>
>>> That is wrong, need to know that MAC so can not move up too much.
>>> But maybe above the is_valid_ether_addr
>>
>> The MAC passthough address is read from ACPI.
>> ACPI read only happens once during r8152 driver probe.
>> To keep the lock less time, do it after is_valid_ether_addr.
>>
>>>
>>> Henning
>>>    
>>>>> +		}
>>>>> +	}
>>>>> +	rcu_read_unlock();
>>>>
>>>> Not sure if this function is guaranteed to only run once at a time,
>>>> otherwise i think that is a race. Multiple instances could make it
>>>> to this very point at the same time.
>>>>   
>>
>> Run once for one device.
>> So add a safe lock.
>>
>> Aaron
>>
>>>> Henning
>>>>   
>>>>>    	memcpy(sa->sa_data, buf, 6);
>>>>>    	netif_info(tp, probe, tp->netdev,
>>>>>    		   "Using pass-thru MAC addr %pM\n",
>>>>> sa->sa_data);
>>>>   
>>>    
> 
