Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 5DF1614FA27
	for <lists+netdev@lfdr.de>; Sat,  1 Feb 2020 20:20:24 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726722AbgBATUR (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sat, 1 Feb 2020 14:20:17 -0500
Received: from foss.arm.com ([217.140.110.172]:43454 "EHLO foss.arm.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726443AbgBATUR (ORCPT <rfc822;netdev@vger.kernel.org>);
        Sat, 1 Feb 2020 14:20:17 -0500
Received: from usa-sjc-imap-foss1.foss.arm.com (unknown [10.121.207.14])
        by usa-sjc-mx-foss1.foss.arm.com (Postfix) with ESMTP id 46ECAFEC;
        Sat,  1 Feb 2020 11:20:16 -0800 (PST)
Received: from [192.168.122.164] (unknown [172.31.20.19])
        by usa-sjc-imap-foss1.foss.arm.com (Postfix) with ESMTPSA id 313983F68E;
        Sat,  1 Feb 2020 11:20:15 -0800 (PST)
Subject: Re: [PATCH 5/6] net: bcmgenet: Fetch MAC address from the adapter
To:     Andrew Lunn <andrew@lunn.ch>
Cc:     netdev@vger.kernel.org, opendmb@gmail.com, f.fainelli@gmail.com,
        davem@davemloft.net, bcm-kernel-feedback-list@broadcom.com,
        linux-kernel@vger.kernel.org, wahrenst@gmx.net,
        hkallweit1@gmail.com
References: <20200201074625.8698-1-jeremy.linton@arm.com>
 <20200201074625.8698-6-jeremy.linton@arm.com> <20200201153709.GK9639@lunn.ch>
From:   Jeremy Linton <jeremy.linton@arm.com>
Message-ID: <99353ae3-4ad5-b2b3-1303-4b9867eb213d@arm.com>
Date:   Sat, 1 Feb 2020 13:20:14 -0600
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:68.0) Gecko/20100101
 Thunderbird/68.4.1
MIME-Version: 1.0
In-Reply-To: <20200201153709.GK9639@lunn.ch>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Hi,

On 2/1/20 9:37 AM, Andrew Lunn wrote:
>> @@ -3601,6 +3605,23 @@ static int bcmgenet_probe(struct platform_device *pdev)
>>   	    !strcasecmp(phy_mode_str, "internal"))
>>   		bcmgenet_power_up(priv, GENET_POWER_PASSIVE);
>>   
>> +	if (dn)
>> +		macaddr = of_get_mac_address(dn);
>> +	else if (pd)
>> +		macaddr = pd->mac_address;
>> +
>> +	if (IS_ERR_OR_NULL(macaddr) || !is_valid_ether_addr(macaddr)) {
>> +		if (has_acpi_companion(&pdev->dev))
>> +			bcmgenet_get_hw_addr(priv, dev->dev_addr);
>> +
>> +		if (!is_valid_ether_addr(dev->dev_addr)) {
>> +			dev_warn(&pdev->dev, "using random Ethernet MAC\n");
>> +			eth_hw_addr_random(dev);
>> +		}
>> +	} else {
>> +		ether_addr_copy(dev->dev_addr, macaddr);
>> +	}
>> +
> 
> Could you also maybe put in here somewhere a call to
> device_get_mac_address(), to support getting the MAC address out of
> ACPI?

I had that here until right before I posted it, mostly because I was 
trying to consolidate the DT/ACPI paths. I pulled it out because it 
wasn't making the code any clearer, and as I mentioned in my response to 
the general _DSD properties I would rather entirely depend on non DSD 
properties if possible.

I will put it back in, but IMHO we shouldn't be finding firmware using 
it. Since the discussion a few years back, its become clearer to me its 
not usually needed. As in this example, the addresses can usually be 
picked off the adapter if the firmware bothers to set them up.

