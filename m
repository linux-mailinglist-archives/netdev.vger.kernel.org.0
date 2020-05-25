Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id AB57A1E0622
	for <lists+netdev@lfdr.de>; Mon, 25 May 2020 06:29:06 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726572AbgEYE2x (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 25 May 2020 00:28:53 -0400
Received: from foss.arm.com ([217.140.110.172]:35830 "EHLO foss.arm.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726437AbgEYE2x (ORCPT <rfc822;netdev@vger.kernel.org>);
        Mon, 25 May 2020 00:28:53 -0400
Received: from usa-sjc-imap-foss1.foss.arm.com (unknown [10.121.207.14])
        by usa-sjc-mx-foss1.foss.arm.com (Postfix) with ESMTP id BCD8F30E;
        Sun, 24 May 2020 21:28:52 -0700 (PDT)
Received: from [192.168.122.166] (unknown [172.31.20.19])
        by usa-sjc-imap-foss1.foss.arm.com (Postfix) with ESMTPSA id 674383F52E;
        Sun, 24 May 2020 21:28:52 -0700 (PDT)
Subject: Re: [RFC 08/11] net: phy: Allow mdio buses to auto-probe c45 devices
To:     Andrew Lunn <andrew@lunn.ch>
Cc:     netdev@vger.kernel.org, davem@davemloft.net, f.fainelli@gmail.com,
        hkallweit1@gmail.com, linux@armlinux.org.uk,
        madalin.bucur@oss.nxp.com, calvin.johnson@oss.nxp.com,
        linux-kernel@vger.kernel.org
References: <20200522213059.1535892-1-jeremy.linton@arm.com>
 <20200522213059.1535892-9-jeremy.linton@arm.com>
 <20200524144449.GP610998@lunn.ch>
From:   Jeremy Linton <jeremy.linton@arm.com>
Message-ID: <ec63b0d4-2abc-0d32-69c0-ed1a822162cf@arm.com>
Date:   Sun, 24 May 2020 23:28:52 -0500
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:68.0) Gecko/20100101
 Thunderbird/68.8.0
MIME-Version: 1.0
In-Reply-To: <20200524144449.GP610998@lunn.ch>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Hi,

On 5/24/20 9:44 AM, Andrew Lunn wrote:
>> +++ b/include/linux/phy.h
>> @@ -275,6 +275,11 @@ struct mii_bus {
>>   	int reset_delay_us;
>>   	/* RESET GPIO descriptor pointer */
>>   	struct gpio_desc *reset_gpiod;
>> +	/* bus capabilities, used for probing */
>> +	enum {
>> +		MDIOBUS_C22_ONLY = 0,
>> +		MDIOBUS_C45_FIRST,
>> +	} probe_capabilities;
>>   };
> 
> 
> I'm not so keen on _FIRST. It suggest _LAST would also be valid.  But
> that then suggests this is not a bus property, but a PHY property, and
> some PHYs might need _FIRST and other phys need _LAST, and then you
> have a bus which has both sorts of PHY on it, and you have a problem.
> 
> So i think it would be better to have
> 
> 	enum {
> 		MDIOBUS_UNKNOWN = 0,
> 		MDIOBUS_C22,
> 		MDIOBUS_C45,
> 		MDIOBUS_C45_C22,
> 	} bus_capabilities;
> 
> Describe just what the bus master can support.

Yes, the naming is reasonable and I will update it in the next patch. I 
went around a bit myself with this naming early on, and the problem I 
saw was that a C45 capable master, can have C45 electrical phy's that 
only respond to c22 requests (AFAIK). So the MDIOBUS_C45 (I think I was 
calling it C45_ONLY) is an invalid selection. Not, that it wouldn't be 
helpful to have a C45_ONLY case, but that the assumption is that you 
wouldn't try and probe c22 registers, which I thought was a mistake.


Thanks,

