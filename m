Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id F1F527A164
	for <lists+netdev@lfdr.de>; Tue, 30 Jul 2019 08:41:21 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728378AbfG3GlO (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 30 Jul 2019 02:41:14 -0400
Received: from szxga02-in.huawei.com ([45.249.212.188]:3521 "EHLO huawei.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1726736AbfG3GlO (ORCPT <rfc822;netdev@vger.kernel.org>);
        Tue, 30 Jul 2019 02:41:14 -0400
Received: from DGGEMM404-HUB.china.huawei.com (unknown [172.30.72.56])
        by Forcepoint Email with ESMTP id A8621FF0F6B2A76B032C;
        Tue, 30 Jul 2019 14:39:43 +0800 (CST)
Received: from dggeme760-chm.china.huawei.com (10.3.19.106) by
 DGGEMM404-HUB.china.huawei.com (10.3.20.212) with Microsoft SMTP Server (TLS)
 id 14.3.439.0; Tue, 30 Jul 2019 14:39:43 +0800
Received: from [127.0.0.1] (10.57.37.248) by dggeme760-chm.china.huawei.com
 (10.3.19.106) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_128_CBC_SHA256_P256) id 15.1.1591.10; Tue, 30
 Jul 2019 14:39:42 +0800
Subject: Re: [RFC] net: phy: read link status twice when
 phy_check_link_status()
From:   liuyonglong <liuyonglong@huawei.com>
To:     Heiner Kallweit <hkallweit1@gmail.com>, <andrew@lunn.ch>,
        <davem@davemloft.net>
CC:     <netdev@vger.kernel.org>, <linux-kernel@vger.kernel.org>,
        <linuxarm@huawei.com>, <salil.mehta@huawei.com>,
        <yisen.zhuang@huawei.com>, <shiju.jose@huawei.com>
References: <1564134831-24962-1-git-send-email-liuyonglong@huawei.com>
 <92f42ee8-3659-87a7-ac96-d312a98046ba@gmail.com>
 <4b4ba599-f160-39e7-d611-45ac53268389@huawei.com>
 <a0b26e4b-e288-cf44-049a-7d0b7f5696eb@gmail.com>
 <1d4be6ad-ffe6-2325-ceab-9f35da617ee9@huawei.com>
 <5087ee34-5776-f02b-d7e5-bce005ba3b92@gmail.com>
 <03708d00-a8d9-4a9d-4188-9fe0e38de2b8@huawei.com>
Message-ID: <44c1da08-6698-7873-771c-1d81da4ccf71@huawei.com>
Date:   Tue, 30 Jul 2019 14:39:40 +0800
User-Agent: Mozilla/5.0 (Windows NT 6.1; WOW64; rv:60.0) Gecko/20100101
 Thunderbird/60.2.1
MIME-Version: 1.0
In-Reply-To: <03708d00-a8d9-4a9d-4188-9fe0e38de2b8@huawei.com>
Content-Type: text/plain; charset="utf-8"
Content-Language: en-US
Content-Transfer-Encoding: 7bit
X-Originating-IP: [10.57.37.248]
X-ClientProxiedBy: dggeme717-chm.china.huawei.com (10.1.199.113) To
 dggeme760-chm.china.huawei.com (10.3.19.106)
X-CFilter-Loop: Reflected
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org



On 2019/7/30 14:35, liuyonglong wrote:
> :/sys/kernel/debug/tracing$ cat trace
> # tracer: nop
> #
> # entries-in-buffer/entries-written: 45/45   #P:128
> #
> #                              _-----=> irqs-off
> #                             / _----=> need-resched
> #                            | / _---=> hardirq/softirq
> #                            || / _--=> preempt-depth
> #                            ||| /     delay
> #           TASK-PID   CPU#  ||||    TIMESTAMP  FUNCTION
> #              | |       |   ||||       |         |
>     kworker/64:2-1028  [064] ....   172.295687: mdio_access: mii-0000:bd:00.0 read  phy:0x01 reg:0x02 val:0x001c
>     kworker/64:2-1028  [064] ....   172.295726: mdio_access: mii-0000:bd:00.0 read  phy:0x01 reg:0x03 val:0xc916
>     kworker/64:2-1028  [064] ....   172.296902: mdio_access: mii-0000:bd:00.0 read  phy:0x01 reg:0x01 val:0x79ad
>     kworker/64:2-1028  [064] ....   172.296938: mdio_access: mii-0000:bd:00.0 read  phy:0x01 reg:0x0f val:0x2000
>     kworker/64:2-1028  [064] ....   172.321213: mdio_access: mii-0000:bd:00.0 read  phy:0x01 reg:0x00 val:0x1040
>     kworker/64:2-1028  [064] ....   172.343209: mdio_access: mii-0000:bd:00.1 read  phy:0x03 reg:0x02 val:0x001c
>     kworker/64:2-1028  [064] ....   172.343245: mdio_access: mii-0000:bd:00.1 read  phy:0x03 reg:0x03 val:0xc916
>     kworker/64:2-1028  [064] ....   172.343882: mdio_access: mii-0000:bd:00.1 read  phy:0x03 reg:0x01 val:0x79ad
>     kworker/64:2-1028  [064] ....   172.343918: mdio_access: mii-0000:bd:00.1 read  phy:0x03 reg:0x0f val:0x2000
>     kworker/64:2-1028  [064] ....   172.362658: mdio_access: mii-0000:bd:00.1 read  phy:0x03 reg:0x00 val:0x1040
>     kworker/64:2-1028  [064] ....   172.385961: mdio_access: mii-0000:bd:00.2 read  phy:0x05 reg:0x02 val:0x001c
>     kworker/64:2-1028  [064] ....   172.385996: mdio_access: mii-0000:bd:00.2 read  phy:0x05 reg:0x03 val:0xc916
>     kworker/64:2-1028  [064] ....   172.386646: mdio_access: mii-0000:bd:00.2 read  phy:0x05 reg:0x01 val:0x79ad
>     kworker/64:2-1028  [064] ....   172.386681: mdio_access: mii-0000:bd:00.2 read  phy:0x05 reg:0x0f val:0x2000
>     kworker/64:2-1028  [064] ....   172.411286: mdio_access: mii-0000:bd:00.2 read  phy:0x05 reg:0x00 val:0x1040
>     kworker/64:2-1028  [064] ....   172.433225: mdio_access: mii-0000:bd:00.3 read  phy:0x07 reg:0x02 val:0x001c
>     kworker/64:2-1028  [064] ....   172.433260: mdio_access: mii-0000:bd:00.3 read  phy:0x07 reg:0x03 val:0xc916
>     kworker/64:2-1028  [064] ....   172.433887: mdio_access: mii-0000:bd:00.3 read  phy:0x07 reg:0x01 val:0x79ad
>     kworker/64:2-1028  [064] ....   172.433922: mdio_access: mii-0000:bd:00.3 read  phy:0x07 reg:0x0f val:0x2000
>     kworker/64:2-1028  [064] ....   172.452862: mdio_access: mii-0000:bd:00.3 read  phy:0x07 reg:0x00 val:0x1040
>         ifconfig-1324  [011] ....   177.325585: mdio_access: mii-0000:bd:00.1 read  phy:0x03 reg:0x00 val:0x1040
>   kworker/u257:0-8     [012] ....   177.325642: mdio_access: mii-0000:bd:00.1 read  phy:0x03 reg:0x04 val:0x01e1
>   kworker/u257:0-8     [012] ....   177.325654: mdio_access: mii-0000:bd:00.1 write phy:0x03 reg:0x04 val:0x05e1
>   kworker/u257:0-8     [012] ....   177.325708: mdio_access: mii-0000:bd:00.1 read  phy:0x03 reg:0x01 val:0x79ad
>   kworker/u257:0-8     [012] ....   177.325744: mdio_access: mii-0000:bd:00.1 read  phy:0x03 reg:0x09 val:0x0200
>   kworker/u257:0-8     [012] ....   177.325779: mdio_access: mii-0000:bd:00.1 read  phy:0x03 reg:0x00 val:0x1040
>   kworker/u257:0-8     [012] ....   177.325788: mdio_access: mii-0000:bd:00.1 write phy:0x03 reg:0x00 val:0x1240
>   kworker/u257:0-8     [012] ....   177.325843: mdio_access: mii-0000:bd:00.1 read  phy:0x03 reg:0x01 val:0x798d
>   kworker/u257:0-8     [003] ....   178.360488: mdio_access: mii-0000:bd:00.1 read  phy:0x03 reg:0x01 val:0x7989
>   kworker/u257:0-8     [000] ....   179.384479: mdio_access: mii-0000:bd:00.1 read  phy:0x03 reg:0x01 val:0x7989
>   kworker/u257:0-8     [000] ....   180.408477: mdio_access: mii-0000:bd:00.1 read  phy:0x03 reg:0x01 val:0x7989
>   kworker/u257:0-8     [000] ....   181.432474: mdio_access: mii-0000:bd:00.1 read  phy:0x03 reg:0x01 val:0x79a9
>   kworker/u257:0-8     [000] ....   181.432510: mdio_access: mii-0000:bd:00.1 read  phy:0x03 reg:0x0a val:0x7800
>   kworker/u257:0-8     [000] ....   181.432546: mdio_access: mii-0000:bd:00.1 read  phy:0x03 reg:0x09 val:0x0200
>   kworker/u257:0-8     [000] ....   181.432582: mdio_access: mii-0000:bd:00.1 read  phy:0x03 reg:0x05 val:0xc1e1
>   kworker/u257:0-8     [000] ....   182.456510: mdio_access: mii-0000:bd:00.1 read  phy:0x03 reg:0x01 val:0x79ad
>   kworker/u257:0-8     [000] ....   182.456546: mdio_access: mii-0000:bd:00.1 read  phy:0x03 reg:0x0a val:0x4800
>   kworker/u257:0-8     [000] ....   182.456582: mdio_access: mii-0000:bd:00.1 read  phy:0x03 reg:0x09 val:0x0200
>   kworker/u257:0-8     [000] ....   182.456618: mdio_access: mii-0000:bd:00.1 read  phy:0x03 reg:0x05 val:0xc1e1
>   kworker/u257:0-8     [001] ....   183.480476: mdio_access: mii-0000:bd:00.1 read  phy:0x03 reg:0x01 val:0x79ad
>   kworker/u257:0-8     [000] ....   184.504478: mdio_access: mii-0000:bd:00.1 read  phy:0x03 reg:0x01 val:0x79ad
>   kworker/u257:0-8     [000] ....   185.528486: mdio_access: mii-0000:bd:00.1 read  phy:0x03 reg:0x01 val:0x79ad
>   kworker/u257:0-8     [000] ....   186.552475: mdio_access: mii-0000:bd:00.1 read  phy:0x03 reg:0x01 val:0x79ad
>         ifconfig-1327  [011] ....   187.196036: mdio_access: mii-0000:bd:00.1 read  phy:0x03 reg:0x00 val:0x1040
>         ifconfig-1327  [011] ....   187.196046: mdio_access: mii-0000:bd:00.1 write phy:0x03 reg:0x00 val:0x1840
> 

Add dmesg below:

[  177.325619] hns3 0000:bd:00.1 eth5: net open
[  177.325859] hns3 0000:bd:00.1: invalid speed (-1)
[  177.330180] 8021q: adding VLAN 0 to HW filter on device eth5
[  177.334569] hns3 0000:bd:00.1 eth5: failed to adjust link.
[  177.345674] IPv6: ADDRCONF(NETDEV_CHANGE): eth5: link becomes ready
[  178.021616] hns3 0000:bd:00.1 eth5: link up
[  178.808459] hns3 0000:bd:00.1 eth5: link down
[  182.808452] hns3 0000:bd:00.1 eth5: link up
[  187.191563] hns3 0000:bd:00.1 eth5: net stop
[  187.196049] hns3 0000:bd:00.1 eth5: link down


> 
> 
> On 2019/7/30 14:08, Heiner Kallweit wrote:
>> On 30.07.2019 06:03, liuyonglong wrote:
>>>
>>>
>>> On 2019/7/30 4:57, Heiner Kallweit wrote:
>>>> On 29.07.2019 05:59, liuyonglong wrote:
>>>>>
>>>>>
>>>>> On 2019/7/27 2:14, Heiner Kallweit wrote:
>>>>>> On 26.07.2019 11:53, Yonglong Liu wrote:
>>>>>>> According to the datasheet of Marvell phy and Realtek phy, the
>>>>>>> copper link status should read twice, or it may get a fake link
>>>>>>> up status, and cause up->down->up at the first time when link up.
>>>>>>> This happens more oftem at Realtek phy.
>>>>>>>
>>>>>> This is not correct, there is no fake link up status.
>>>>>> Read the comment in genphy_update_link, only link-down events
>>>>>> are latched. Means if the first read returns link up, then there
>>>>>> is no need for a second read. And in polling mode we don't do a
>>>>>> second read because we want to detect also short link drops.
>>>>>>
>>>>>> It would be helpful if you could describe your actual problem
>>>>>> and whether you use polling or interrupt mode.
>>>>>>
>>>>>
>>>>> [   44.498633] hns3 0000:bd:00.1 eth5: net open
>>>>> [   44.504273] hns3 0000:bd:00.1: reg=0x1, data=0x79ad -> called from phy_start_aneg
>>>>> [   44.532348] hns3 0000:bd:00.1: reg=0x1, data=0x798d -> called from phy_state_machine,update link.
>>>>
>>>> This should not happen. The PHY indicates link up w/o having aneg finished.
>>>>
>>>>>
>>>>> According to the datasheet:
>>>>> reg 1.5=0 now, means copper auto-negotiation not complete
>>>>> reg 1.2=1 now, means link is up
>>>>>
>>>>> We can see that, when we read the link up, the auto-negotiation
>>>>> is not complete yet, so the speed is invalid.
>>>>>
>>>>> I don't know why this happen, maybe this state is keep from bios?
>>>>> Or we may do something else in the phy initialize to fix it?
>>>>> And also confuse that why read twice can fix it?
>>>>>
>>>> I suppose that basically any delay would do.
>>>>
>>>>> [   44.554063] hns3 0000:bd:00.1: invalid speed (-1)
>>>>> [   44.560412] hns3 0000:bd:00.1 eth5: failed to adjust link.
>>>>> [   45.194870] hns3 0000:bd:00.1 eth5: link up
>>>>> [   45.574095] hns3 0000:bd:00.1: phyid=3, reg=0x1, data=0x7989
>>>>> [   46.150051] hns3 0000:bd:00.1 eth5: link down
>>>>> [   46.598074] hns3 0000:bd:00.1: phyid=3, reg=0x1, data=0x7989
>>>>> [   47.622075] hns3 0000:bd:00.1: phyid=3, reg=0x1, data=0x79a9
>>>>> [   48.646077] hns3 0000:bd:00.1: phyid=3, reg=0x1, data=0x79ad
>>>>> [   48.934050] hns3 0000:bd:00.1 eth5: link up
>>>>> [   49.702140] hns3 0000:bd:00.1: phyid=3, reg=0x1, data=0x79ad
>>>>>
>>>>>>> I add a fake status read, and can solve this problem.
>>>>>>>
>>>>>>> I also see that in genphy_update_link(), had delete the fake
>>>>>>> read in polling mode, so I don't know whether my solution is
>>>>>>> correct.
>>>>>>>
>>>>
>>>> Can you test whether the following fixes the issue for you?
>>>> Also it would be interesting which exact PHY models you tested
>>>> and whether you built the respective PHY drivers or whether you
>>>> rely on the genphy driver. Best use the second patch to get the
>>>> needed info. It may make sense anyway to add the call to
>>>> phy_attached_info() to the hns3 driver.
>>>>
>>>
>>> [   40.100716] RTL8211F Gigabit Ethernet mii-0000:bd:00.3:07: attached PHY driver [RTL8211F Gigabit Ethernet] (mii_bus:phy_addr=mii-0000:bd:00.3:07, irq=POLL)
>>> [   40.932133] hns3 0000:bd:00.3 eth7: net open
>>> [   40.932458] hns3 0000:bd:00.3: invalid speed (-1)
>>> [   40.932541] 8021q: adding VLAN 0 to HW filter on device eth7
>>> [   40.937149] hns3 0000:bd:00.3 eth7: failed to adjust link.
>>>
>>> [   40.662050] Generic PHY mii-0000:bd:00.2:05: attached PHY driver [Generic PHY] (mii_bus:phy_addr=mii-0000:bd:00.2:05, irq=POLL)
>>> [   41.563511] hns3 0000:bd:00.2 eth6: net open
>>> [   41.563853] hns3 0000:bd:00.2: invalid speed (-1)
>>> [   41.563943] 8021q: adding VLAN 0 to HW filter on device eth6
>>> [   41.568578] IPv6: ADDRCONF(NETDEV_CHANGE): eth6: link becomes ready
>>> [   41.568898] hns3 0000:bd:00.2 eth6: failed to adjust link.
>>>
>>> I am using RTL8211F, but you can see that, both genphy driver and
>>> RTL8211F driver have the same issue.
>>>
>>>>
>>>> diff --git a/drivers/net/phy/phy_device.c b/drivers/net/phy/phy_device.c
>>>> index 6b5cb87f3..fbecfe210 100644
>>>> --- a/drivers/net/phy/phy_device.c
>>>> +++ b/drivers/net/phy/phy_device.c
>>>> @@ -1807,7 +1807,8 @@ int genphy_read_status(struct phy_device *phydev)
>>>>  
>>>>  	linkmode_zero(phydev->lp_advertising);
>>>>  
>>>> -	if (phydev->autoneg == AUTONEG_ENABLE && phydev->autoneg_complete) {
>>>> +	if (phydev->autoneg == AUTONEG_ENABLE &&
>>>> +	    (phydev->autoneg_complete || phydev->link)) {
>>>>  		if (phydev->is_gigabit_capable) {
>>>>  			lpagb = phy_read(phydev, MII_STAT1000);
>>>>  			if (lpagb < 0)
>>>>
>>>
>>> I have try this patch, have no effect. I suppose that at this time,
>>> the autoneg actually not complete yet.
>>>
>>> Maybe the wrong phy state is passed from bios? Invalid speed just
>>> happen at the first time when ethX up, after that, repeat the
>>> ifconfig down/ifconfig up command can not see that again.
>>>
>>> So I think the bios should power off the phy(writing reg 1.11 to 1)
>>> before it starts the OS? Or any other way to fix this in the OS?
>>>
>> To get a better idea of whats going on it would be good to see a full
>> MDIO trace. Can you enable MDIO tracing via the following sysctl file
>> /sys/kernel/debug/tracing/events/mdio/enable
>> and provide the generated trace?
>>
>> Due to polling mode each second entries will be generated, so you
>> better stop network after the issue occurred.
>>
>>>
>>>
>>>
>>
>> Heiner
>>
>> .
>>
> 
> 
> .
> 

