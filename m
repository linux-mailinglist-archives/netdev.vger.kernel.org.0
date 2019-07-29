Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 311AA783C1
	for <lists+netdev@lfdr.de>; Mon, 29 Jul 2019 05:59:45 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726583AbfG2D7k (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sun, 28 Jul 2019 23:59:40 -0400
Received: from szxga02-in.huawei.com ([45.249.212.188]:2491 "EHLO huawei.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1726134AbfG2D7k (ORCPT <rfc822;netdev@vger.kernel.org>);
        Sun, 28 Jul 2019 23:59:40 -0400
Received: from DGGEMM403-HUB.china.huawei.com (unknown [172.30.72.56])
        by Forcepoint Email with ESMTP id E653D654BCAE1A68456B;
        Mon, 29 Jul 2019 11:59:36 +0800 (CST)
Received: from dggeme760-chm.china.huawei.com (10.3.19.106) by
 DGGEMM403-HUB.china.huawei.com (10.3.20.211) with Microsoft SMTP Server (TLS)
 id 14.3.439.0; Mon, 29 Jul 2019 11:59:36 +0800
Received: from [127.0.0.1] (10.57.37.248) by dggeme760-chm.china.huawei.com
 (10.3.19.106) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_128_CBC_SHA256_P256) id 15.1.1591.10; Mon, 29
 Jul 2019 11:59:36 +0800
Subject: Re: [RFC] net: phy: read link status twice when
 phy_check_link_status()
To:     Heiner Kallweit <hkallweit1@gmail.com>, <andrew@lunn.ch>,
        <davem@davemloft.net>
CC:     <netdev@vger.kernel.org>, <linux-kernel@vger.kernel.org>,
        <linuxarm@huawei.com>, <salil.mehta@huawei.com>,
        <yisen.zhuang@huawei.com>, <shiju.jose@huawei.com>
References: <1564134831-24962-1-git-send-email-liuyonglong@huawei.com>
 <92f42ee8-3659-87a7-ac96-d312a98046ba@gmail.com>
From:   liuyonglong <liuyonglong@huawei.com>
Message-ID: <4b4ba599-f160-39e7-d611-45ac53268389@huawei.com>
Date:   Mon, 29 Jul 2019 11:59:34 +0800
User-Agent: Mozilla/5.0 (Windows NT 6.1; WOW64; rv:60.0) Gecko/20100101
 Thunderbird/60.2.1
MIME-Version: 1.0
In-Reply-To: <92f42ee8-3659-87a7-ac96-d312a98046ba@gmail.com>
Content-Type: text/plain; charset="utf-8"
Content-Language: en-US
Content-Transfer-Encoding: 7bit
X-Originating-IP: [10.57.37.248]
X-ClientProxiedBy: dggeme711-chm.china.huawei.com (10.1.199.107) To
 dggeme760-chm.china.huawei.com (10.3.19.106)
X-CFilter-Loop: Reflected
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org



On 2019/7/27 2:14, Heiner Kallweit wrote:
> On 26.07.2019 11:53, Yonglong Liu wrote:
>> According to the datasheet of Marvell phy and Realtek phy, the
>> copper link status should read twice, or it may get a fake link
>> up status, and cause up->down->up at the first time when link up.
>> This happens more oftem at Realtek phy.
>>
> This is not correct, there is no fake link up status.
> Read the comment in genphy_update_link, only link-down events
> are latched. Means if the first read returns link up, then there
> is no need for a second read. And in polling mode we don't do a
> second read because we want to detect also short link drops.
> 
> It would be helpful if you could describe your actual problem
> and whether you use polling or interrupt mode.
> 

[   44.498633] hns3 0000:bd:00.1 eth5: net open
[   44.504273] hns3 0000:bd:00.1: reg=0x1, data=0x79ad -> called from phy_start_aneg
[   44.532348] hns3 0000:bd:00.1: reg=0x1, data=0x798d -> called from phy_state_machine,update link.

According to the datasheet:
reg 1.5=0 now, means copper auto-negotiation not complete
reg 1.2=1 now, means link is up

We can see that, when we read the link up, the auto-negotiation
is not complete yet, so the speed is invalid.

I don't know why this happen, maybe this state is keep from bios?
Or we may do something else in the phy initialize to fix it?
And also confuse that why read twice can fix it?

[   44.554063] hns3 0000:bd:00.1: invalid speed (-1)
[   44.560412] hns3 0000:bd:00.1 eth5: failed to adjust link.
[   45.194870] hns3 0000:bd:00.1 eth5: link up
[   45.574095] hns3 0000:bd:00.1: phyid=3, reg=0x1, data=0x7989
[   46.150051] hns3 0000:bd:00.1 eth5: link down
[   46.598074] hns3 0000:bd:00.1: phyid=3, reg=0x1, data=0x7989
[   47.622075] hns3 0000:bd:00.1: phyid=3, reg=0x1, data=0x79a9
[   48.646077] hns3 0000:bd:00.1: phyid=3, reg=0x1, data=0x79ad
[   48.934050] hns3 0000:bd:00.1 eth5: link up
[   49.702140] hns3 0000:bd:00.1: phyid=3, reg=0x1, data=0x79ad

>> I add a fake status read, and can solve this problem.
>>
>> I also see that in genphy_update_link(), had delete the fake
>> read in polling mode, so I don't know whether my solution is
>> correct.
>>
>> Or provide a phydev->drv->read_status functions for the phy I
>> used is more acceptable?
>>
>> Signed-off-by: Yonglong Liu <liuyonglong@huawei.com>
>> ---
>>  drivers/net/phy/phy.c | 8 ++++++++
>>  1 file changed, 8 insertions(+)
>>
>> diff --git a/drivers/net/phy/phy.c b/drivers/net/phy/phy.c
>> index ef7aa73..0c03edc 100644
>> --- a/drivers/net/phy/phy.c
>> +++ b/drivers/net/phy/phy.c
>> @@ -1,4 +1,7 @@
>>  // SPDX-License-Identifier: GPL-2.0+
>> +	err = phy_read_status(phydev);
>> +	if (err)
>> +		return err;
> 
> This seems to be completely wrong at that place.
> 

Sorry, this can be ignore.

>>  /* Framework for configuring and reading PHY devices
>>   * Based on code in sungem_phy.c and gianfar_phy.c
>>   *
>> @@ -525,6 +528,11 @@ static int phy_check_link_status(struct phy_device *phydev)
>>  
>>  	WARN_ON(!mutex_is_locked(&phydev->lock));
>>  
>> +	/* Do a fake read */
>> +	err = phy_read(phydev, MII_BMSR);
>> +	if (err < 0)
>> +		return err;
>> +
>>  	err = phy_read_status(phydev);
>>  	if (err)
>>  		return err;
>>
> 
> 
> .
> 

