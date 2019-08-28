Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 25CFF9F7A3
	for <lists+netdev@lfdr.de>; Wed, 28 Aug 2019 03:03:55 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726178AbfH1BDx (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 27 Aug 2019 21:03:53 -0400
Received: from szxga07-in.huawei.com ([45.249.212.35]:58524 "EHLO huawei.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1726092AbfH1BDx (ORCPT <rfc822;netdev@vger.kernel.org>);
        Tue, 27 Aug 2019 21:03:53 -0400
Received: from DGGEMS408-HUB.china.huawei.com (unknown [172.30.72.60])
        by Forcepoint Email with ESMTP id 4A382D73BD3A913D179B;
        Wed, 28 Aug 2019 09:03:51 +0800 (CST)
Received: from [127.0.0.1] (10.65.91.35) by DGGEMS408-HUB.china.huawei.com
 (10.3.19.208) with Microsoft SMTP Server id 14.3.439.0; Wed, 28 Aug 2019
 09:03:45 +0800
Subject: Re: [RFC PATCH net-next] net: phy: force phy suspend when calling
 phy_stop
To:     Heiner Kallweit <hkallweit1@gmail.com>, <andrew@lunn.ch>,
        <f.fainelli@gmail.com>, <davem@davemloft.net>
CC:     <netdev@vger.kernel.org>, <forest.zhouchang@huawei.com>,
        <linuxarm@huawei.com>
References: <1566874020-14334-1-git-send-email-shenjian15@huawei.com>
 <fc2a700a-9c24-b96c-df6b-c5414883d89e@gmail.com>
 <d3cd1ef1-8add-84bb-c4d9-801b65d0fba1@huawei.com>
 <04fdbe88-8471-c023-4a0d-890667735737@gmail.com>
From:   "shenjian (K)" <shenjian15@huawei.com>
Message-ID: <b12df315-3fcf-dbe3-9e25-f2ecafe752d5@huawei.com>
Date:   Wed, 28 Aug 2019 09:03:44 +0800
User-Agent: Mozilla/5.0 (Windows NT 6.1; WOW64; rv:52.0) Gecko/20100101
 Thunderbird/52.5.2
MIME-Version: 1.0
In-Reply-To: <04fdbe88-8471-c023-4a0d-890667735737@gmail.com>
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 8bit
X-Originating-IP: [10.65.91.35]
X-CFilter-Loop: Reflected
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org



在 2019/8/28 3:41, Heiner Kallweit 写道:
> On 27.08.2019 10:29, shenjian (K) wrote:
>>
>>
>> 在 2019/8/27 13:51, Heiner Kallweit 写道:
>>> On 27.08.2019 04:47, Jian Shen wrote:
>>>> Some ethernet drivers may call phy_start() and phy_stop() from
>>>> ndo_open and ndo_close() respectively.
>>>>
>>>> When network cable is unconnected, and operate like below:
>>>> step 1: ifconfig ethX up -> ndo_open -> phy_start ->start
>>>> autoneg, and phy is no link.
>>>> step 2: ifconfig ethX down -> ndo_close -> phy_stop -> just stop
>>>> phy state machine.
>>>> step 3: plugin the network cable, and autoneg complete, then
>>>> LED for link status will be on.
>>>> step 4: ethtool ethX --> see the result of "Link detected" is no.
>>>>
>>> Step 3 and 4 seem to be unrelated to the actual issue.
>>> With which MAC + PHY driver did you observe this?
>>>
>> Thanks Heiner,
>>
>> I tested this on HNS3 driver, with two phy, Marvell 88E1512 and RTL8211.
>>
>> Step 3 and Step 4 is just to describe that the LED of link shows link up,
>> but the port information shows no link.
>>
> ethtool refers to the link at MAC level. Therefore default implementation
> ethtool_op_get_link just returns the result of netif_carrier_ok().
> Also using PHY link status if interface is down doesn't really make sense:
> - phylib state machine isn't running, therefore PHY status doesn't get updated
> - often MAC drivers shut down parts of the MAC on ndo_close, this typically
>   makes the internal MDIO bus unaccessible
> So just remove steps 3 and 4. The patch itself is fine with me.
> 
OK, I will fix the commit log.
Thanks, Heiner.
>>
>>>> This patch forces phy suspend even phydev->link is off.
>>>>
>>>> Signed-off-by: Jian Shen <shenjian15@huawei.com>
>>>> ---
>>>>  drivers/net/phy/phy.c | 2 +-
>>>>  1 file changed, 1 insertion(+), 1 deletion(-)
>>>>
>>>> diff --git a/drivers/net/phy/phy.c b/drivers/net/phy/phy.c
>>>> index f3adea9..0acd5b4 100644
>>>> --- a/drivers/net/phy/phy.c
>>>> +++ b/drivers/net/phy/phy.c
>>>> @@ -911,8 +911,8 @@ void phy_state_machine(struct work_struct *work)
>>>>  		if (phydev->link) {
>>>>  			phydev->link = 0;
>>>>  			phy_link_down(phydev, true);
>>>> -			do_suspend = true;
>>>>  		}
>>>> +		do_suspend = true;
>>>>  		break;
>>>>  	}
>>>>  
>>>>
>>> Heiner
>>>
>>>
>>
>>
> 
> 
> .
> 

