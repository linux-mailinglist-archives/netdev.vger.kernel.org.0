Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 01EFC85A84
	for <lists+netdev@lfdr.de>; Thu,  8 Aug 2019 08:21:35 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1730986AbfHHGVV (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 8 Aug 2019 02:21:21 -0400
Received: from szxga03-in.huawei.com ([45.249.212.189]:3082 "EHLO huawei.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1725796AbfHHGVU (ORCPT <rfc822;netdev@vger.kernel.org>);
        Thu, 8 Aug 2019 02:21:20 -0400
Received: from DGGEMM401-HUB.china.huawei.com (unknown [172.30.72.54])
        by Forcepoint Email with ESMTP id A0F7187DA62FA65D40F2;
        Thu,  8 Aug 2019 14:21:15 +0800 (CST)
Received: from dggeme760-chm.china.huawei.com (10.3.19.106) by
 DGGEMM401-HUB.china.huawei.com (10.3.20.209) with Microsoft SMTP Server (TLS)
 id 14.3.439.0; Thu, 8 Aug 2019 14:21:15 +0800
Received: from [127.0.0.1] (10.57.37.248) by dggeme760-chm.china.huawei.com
 (10.3.19.106) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_128_CBC_SHA256_P256) id 15.1.1591.10; Thu, 8
 Aug 2019 14:21:15 +0800
Subject: Re: [PATCH net] net: phy: rtl8211f: do a double read to get real time
 link status
To:     Heiner Kallweit <hkallweit1@gmail.com>, <davem@davemloft.net>,
        <andrew@lunn.ch>
CC:     <netdev@vger.kernel.org>, <linux-kernel@vger.kernel.org>,
        <linuxarm@huawei.com>, <salil.mehta@huawei.com>,
        <yisen.zhuang@huawei.com>, <shiju.jose@huawei.com>
References: <1565183772-44268-1-git-send-email-liuyonglong@huawei.com>
 <d67831ab-8902-a653-3db9-b2f55adacabd@gmail.com>
 <e663235c-93eb-702d-5a9c-8f781d631c42@huawei.com>
 <080b68c7-abe6-d142-da4b-26e8a7d4dc19@gmail.com>
From:   Yonglong Liu <liuyonglong@huawei.com>
Message-ID: <c15f820b-cc80-9a93-4c48-1b60bc14f73a@huawei.com>
Date:   Thu, 8 Aug 2019 14:21:14 +0800
User-Agent: Mozilla/5.0 (Windows NT 6.1; WOW64; rv:60.0) Gecko/20100101
 Thunderbird/60.2.1
MIME-Version: 1.0
In-Reply-To: <080b68c7-abe6-d142-da4b-26e8a7d4dc19@gmail.com>
Content-Type: text/plain; charset="utf-8"
Content-Language: en-US
Content-Transfer-Encoding: 7bit
X-Originating-IP: [10.57.37.248]
X-ClientProxiedBy: dggeme718-chm.china.huawei.com (10.1.199.114) To
 dggeme760-chm.china.huawei.com (10.3.19.106)
X-CFilter-Loop: Reflected
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org



On 2019/8/8 14:11, Heiner Kallweit wrote:
> On 08.08.2019 03:15, Yonglong Liu wrote:
>>
>>
>> On 2019/8/8 0:47, Heiner Kallweit wrote:
>>> On 07.08.2019 15:16, Yonglong Liu wrote:
>>>> [   27.232781] hns3 0000:bd:00.3 eth7: net open
>>>> [   27.237303] 8021q: adding VLAN 0 to HW filter on device eth7
>>>> [   27.242972] IPv6: ADDRCONF(NETDEV_CHANGE): eth7: link becomes ready
>>>> [   27.244449] hns3 0000:bd:00.3: invalid speed (-1)
>>>> [   27.253904] hns3 0000:bd:00.3 eth7: failed to adjust link.
>>>> [   27.259379] RTL8211F Gigabit Ethernet mii-0000:bd:00.3:07: PHY state change UP -> RUNNING
>>>> [   27.924903] hns3 0000:bd:00.3 eth7: link up
>>>> [   28.280479] RTL8211F Gigabit Ethernet mii-0000:bd:00.3:07: PHY state change RUNNING -> NOLINK
>>>> [   29.208452] hns3 0000:bd:00.3 eth7: link down
>>>> [   32.376745] RTL8211F Gigabit Ethernet mii-0000:bd:00.3:07: PHY state change NOLINK -> RUNNING
>>>> [   33.208448] hns3 0000:bd:00.3 eth7: link up
>>>> [   35.253821] hns3 0000:bd:00.3 eth7: net stop
>>>> [   35.258270] hns3 0000:bd:00.3 eth7: link down
>>>>
>>>> When using rtl8211f in polling mode, may get a invalid speed,
>>>> because of reading a fake link up and autoneg complete status
>>>> immediately after starting autoneg:
>>>>
>>>>         ifconfig-1176  [007] ....    27.232763: mdio_access: mii-0000:bd:00.3 read  phy:0x07 reg:0x00 val:0x1040
>>>>   kworker/u257:1-670   [015] ....    27.232805: mdio_access: mii-0000:bd:00.3 read  phy:0x07 reg:0x04 val:0x01e1
>>>>   kworker/u257:1-670   [015] ....    27.232815: mdio_access: mii-0000:bd:00.3 write phy:0x07 reg:0x04 val:0x05e1
>>>>   kworker/u257:1-670   [015] ....    27.232869: mdio_access: mii-0000:bd:00.3 read  phy:0x07 reg:0x01 val:0x79ad
>>>>   kworker/u257:1-670   [015] ....    27.232904: mdio_access: mii-0000:bd:00.3 read  phy:0x07 reg:0x09 val:0x0200
>>>>   kworker/u257:1-670   [015] ....    27.232940: mdio_access: mii-0000:bd:00.3 read  phy:0x07 reg:0x00 val:0x1040
>>>>   kworker/u257:1-670   [015] ....    27.232949: mdio_access: mii-0000:bd:00.3 write phy:0x07 reg:0x00 val:0x1240
>>>>   kworker/u257:1-670   [015] ....    27.233003: mdio_access: mii-0000:bd:00.3 read  phy:0x07 reg:0x01 val:0x79ad
>>>>   kworker/u257:1-670   [015] ....    27.233039: mdio_access: mii-0000:bd:00.3 read  phy:0x07 reg:0x0a val:0x3002
>>>>   kworker/u257:1-670   [015] ....    27.233074: mdio_access: mii-0000:bd:00.3 read  phy:0x07 reg:0x09 val:0x0200
>>>>   kworker/u257:1-670   [015] ....    27.233110: mdio_access: mii-0000:bd:00.3 read  phy:0x07 reg:0x05 val:0x0000
>>>>   kworker/u257:1-670   [000] ....    28.280475: mdio_access: mii-0000:bd:00.3 read  phy:0x07 reg:0x01 val:0x7989
>>>>   kworker/u257:1-670   [000] ....    29.304471: mdio_access: mii-0000:bd:00.3 read  phy:0x07 reg:0x01 val:0x7989
>>>>
>>>> According to the datasheet of rtl8211f, to get the real time
>>>> link status, need to read MII_BMSR twice.
>>>>
>>>> This patch add a read_status hook for rtl8211f, and do a fake
>>>> phy_read before genphy_read_status(), so that can get real link
>>>> status in genphy_read_status().
>>>>
>>>> Signed-off-by: Yonglong Liu <liuyonglong@huawei.com>
>>>> ---
>>>>  drivers/net/phy/realtek.c | 13 +++++++++++++
>>>>  1 file changed, 13 insertions(+)
>>>>
>>> Is this an accidental resubmit? Because we discussed this in
>>> https://marc.info/?t=156413509900003&r=1&w=2 and a fix has
>>> been applied already.
>>>
>>> Heiner
>>>
>>> .
>>>
>>
>> In https://marc.info/?t=156413509900003&r=1&w=2 , the invalid speed
>> recurrence rate is almost 100%, and I had test the solution about
>> 5 times and it works. But yesterday it happen again suddenly, and than
>> I fount that the recurrence rate reduce to 10%. This time we get 0x79ad
>> after autoneg started which is not 0x798d from last discussion.
>>
>>
>>
> OK, I'll have a look.
> However the approach is wrong. The double read is related to the latching
> of link-down events. This is done by all PHY's and not specific to RT8211F.
> Also it's not related to the problem. I assume any sufficient delay would
> do instead of the read.
> 
> .
> 

So you will send a new patch to fix this problem? I am waiting for it,
and can do a full test this time.

