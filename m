Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 0336C9E2AC
	for <lists+netdev@lfdr.de>; Tue, 27 Aug 2019 10:30:20 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729373AbfH0IaQ (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 27 Aug 2019 04:30:16 -0400
Received: from szxga04-in.huawei.com ([45.249.212.190]:5664 "EHLO huawei.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1728859AbfH0IaP (ORCPT <rfc822;netdev@vger.kernel.org>);
        Tue, 27 Aug 2019 04:30:15 -0400
Received: from DGGEMS412-HUB.china.huawei.com (unknown [172.30.72.59])
        by Forcepoint Email with ESMTP id 3054FDB02FEF2D491CB6;
        Tue, 27 Aug 2019 16:30:06 +0800 (CST)
Received: from [127.0.0.1] (10.65.91.35) by DGGEMS412-HUB.china.huawei.com
 (10.3.19.212) with Microsoft SMTP Server id 14.3.439.0; Tue, 27 Aug 2019
 16:29:59 +0800
Subject: Re: [RFC PATCH net-next] net: phy: force phy suspend when calling
 phy_stop
To:     Heiner Kallweit <hkallweit1@gmail.com>, <andrew@lunn.ch>,
        <f.fainelli@gmail.com>, <davem@davemloft.net>
CC:     <netdev@vger.kernel.org>, <forest.zhouchang@huawei.com>,
        <linuxarm@huawei.com>
References: <1566874020-14334-1-git-send-email-shenjian15@huawei.com>
 <fc2a700a-9c24-b96c-df6b-c5414883d89e@gmail.com>
From:   "shenjian (K)" <shenjian15@huawei.com>
Message-ID: <d3cd1ef1-8add-84bb-c4d9-801b65d0fba1@huawei.com>
Date:   Tue, 27 Aug 2019 16:29:59 +0800
User-Agent: Mozilla/5.0 (Windows NT 6.1; WOW64; rv:52.0) Gecko/20100101
 Thunderbird/52.5.2
MIME-Version: 1.0
In-Reply-To: <fc2a700a-9c24-b96c-df6b-c5414883d89e@gmail.com>
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 8bit
X-Originating-IP: [10.65.91.35]
X-CFilter-Loop: Reflected
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org



在 2019/8/27 13:51, Heiner Kallweit 写道:
> On 27.08.2019 04:47, Jian Shen wrote:
>> Some ethernet drivers may call phy_start() and phy_stop() from
>> ndo_open and ndo_close() respectively.
>>
>> When network cable is unconnected, and operate like below:
>> step 1: ifconfig ethX up -> ndo_open -> phy_start ->start
>> autoneg, and phy is no link.
>> step 2: ifconfig ethX down -> ndo_close -> phy_stop -> just stop
>> phy state machine.
>> step 3: plugin the network cable, and autoneg complete, then
>> LED for link status will be on.
>> step 4: ethtool ethX --> see the result of "Link detected" is no.
>>
> Step 3 and 4 seem to be unrelated to the actual issue.
> With which MAC + PHY driver did you observe this?
> 
Thanks Heiner,

I tested this on HNS3 driver, with two phy, Marvell 88E1512 and RTL8211.

Step 3 and Step 4 is just to describe that the LED of link shows link up,
but the port information shows no link.


>> This patch forces phy suspend even phydev->link is off.
>>
>> Signed-off-by: Jian Shen <shenjian15@huawei.com>
>> ---
>>  drivers/net/phy/phy.c | 2 +-
>>  1 file changed, 1 insertion(+), 1 deletion(-)
>>
>> diff --git a/drivers/net/phy/phy.c b/drivers/net/phy/phy.c
>> index f3adea9..0acd5b4 100644
>> --- a/drivers/net/phy/phy.c
>> +++ b/drivers/net/phy/phy.c
>> @@ -911,8 +911,8 @@ void phy_state_machine(struct work_struct *work)
>>  		if (phydev->link) {
>>  			phydev->link = 0;
>>  			phy_link_down(phydev, true);
>> -			do_suspend = true;
>>  		}
>> +		do_suspend = true;
>>  		break;
>>  	}
>>  
>>
> Heiner
> 
> 

