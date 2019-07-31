Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id B0E297B840
	for <lists+netdev@lfdr.de>; Wed, 31 Jul 2019 05:34:19 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727318AbfGaDdx (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 30 Jul 2019 23:33:53 -0400
Received: from szxga08-in.huawei.com ([45.249.212.255]:35926 "EHLO huawei.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1725851AbfGaDdw (ORCPT <rfc822;netdev@vger.kernel.org>);
        Tue, 30 Jul 2019 23:33:52 -0400
Received: from DGGEMM401-HUB.china.huawei.com (unknown [172.30.72.53])
        by Forcepoint Email with ESMTP id 011A4E5A6231014557A5;
        Wed, 31 Jul 2019 11:33:51 +0800 (CST)
Received: from dggeme760-chm.china.huawei.com (10.3.19.106) by
 DGGEMM401-HUB.china.huawei.com (10.3.20.209) with Microsoft SMTP Server (TLS)
 id 14.3.439.0; Wed, 31 Jul 2019 11:33:50 +0800
Received: from [127.0.0.1] (10.57.37.248) by dggeme760-chm.china.huawei.com
 (10.3.19.106) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_128_CBC_SHA256_P256) id 15.1.1591.10; Wed, 31
 Jul 2019 11:33:50 +0800
Subject: Re: [RFC] net: phy: read link status twice when
 phy_check_link_status()
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
 <9a0a8094-42ee-0a18-0e9a-d3ca783d6d4b@gmail.com>
From:   liuyonglong <liuyonglong@huawei.com>
Message-ID: <6add4874-fd2b-9b21-cd78-80b6dde4dd53@huawei.com>
Date:   Wed, 31 Jul 2019 11:33:33 +0800
User-Agent: Mozilla/5.0 (Windows NT 6.1; WOW64; rv:60.0) Gecko/20100101
 Thunderbird/60.2.1
MIME-Version: 1.0
In-Reply-To: <9a0a8094-42ee-0a18-0e9a-d3ca783d6d4b@gmail.com>
Content-Type: text/plain; charset="utf-8"
Content-Language: en-US
Content-Transfer-Encoding: 8bit
X-Originating-IP: [10.57.37.248]
X-ClientProxiedBy: dggeme712-chm.china.huawei.com (10.1.199.108) To
 dggeme760-chm.china.huawei.com (10.3.19.106)
X-CFilter-Loop: Reflected
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org



On 2019/7/31 3:04, Heiner Kallweit wrote:
> On 30.07.2019 08:35, liuyonglong wrote:
>> :/sys/kernel/debug/tracing$ cat trace
>> # tracer: nop
>> #
>> # entries-in-buffer/entries-written: 45/45   #P:128
>> #
>> #                              _-----=> irqs-off
>> #                             / _----=> need-resched
>> #                            | / _---=> hardirq/softirq
>> #                            || / _--=> preempt-depth
>> #                            ||| /     delay
>> #           TASK-PID   CPU#  ||||    TIMESTAMP  FUNCTION
>> #              | |       |   ||||       |         |
>>     kworker/64:2-1028  [064] ....   172.295687: mdio_access: mii-0000:bd:00.0 read  phy:0x01 reg:0x02 val:0x001c
>>     kworker/64:2-1028  [064] ....   172.295726: mdio_access: mii-0000:bd:00.0 read  phy:0x01 reg:0x03 val:0xc916
>>     kworker/64:2-1028  [064] ....   172.296902: mdio_access: mii-0000:bd:00.0 read  phy:0x01 reg:0x01 val:0x79ad
>>     kworker/64:2-1028  [064] ....   172.296938: mdio_access: mii-0000:bd:00.0 read  phy:0x01 reg:0x0f val:0x2000
>>     kworker/64:2-1028  [064] ....   172.321213: mdio_access: mii-0000:bd:00.0 read  phy:0x01 reg:0x00 val:0x1040
>>     kworker/64:2-1028  [064] ....   172.343209: mdio_access: mii-0000:bd:00.1 read  phy:0x03 reg:0x02 val:0x001c
>>     kworker/64:2-1028  [064] ....   172.343245: mdio_access: mii-0000:bd:00.1 read  phy:0x03 reg:0x03 val:0xc916
>>     kworker/64:2-1028  [064] ....   172.343882: mdio_access: mii-0000:bd:00.1 read  phy:0x03 reg:0x01 val:0x79ad
>>     kworker/64:2-1028  [064] ....   172.343918: mdio_access: mii-0000:bd:00.1 read  phy:0x03 reg:0x0f val:0x2000
>>     kworker/64:2-1028  [064] ....   172.362658: mdio_access: mii-0000:bd:00.1 read  phy:0x03 reg:0x00 val:0x1040
>>     kworker/64:2-1028  [064] ....   172.385961: mdio_access: mii-0000:bd:00.2 read  phy:0x05 reg:0x02 val:0x001c
>>     kworker/64:2-1028  [064] ....   172.385996: mdio_access: mii-0000:bd:00.2 read  phy:0x05 reg:0x03 val:0xc916
>>     kworker/64:2-1028  [064] ....   172.386646: mdio_access: mii-0000:bd:00.2 read  phy:0x05 reg:0x01 val:0x79ad
>>     kworker/64:2-1028  [064] ....   172.386681: mdio_access: mii-0000:bd:00.2 read  phy:0x05 reg:0x0f val:0x2000
>>     kworker/64:2-1028  [064] ....   172.411286: mdio_access: mii-0000:bd:00.2 read  phy:0x05 reg:0x00 val:0x1040
>>     kworker/64:2-1028  [064] ....   172.433225: mdio_access: mii-0000:bd:00.3 read  phy:0x07 reg:0x02 val:0x001c
>>     kworker/64:2-1028  [064] ....   172.433260: mdio_access: mii-0000:bd:00.3 read  phy:0x07 reg:0x03 val:0xc916
>>     kworker/64:2-1028  [064] ....   172.433887: mdio_access: mii-0000:bd:00.3 read  phy:0x07 reg:0x01 val:0x79ad
>>     kworker/64:2-1028  [064] ....   172.433922: mdio_access: mii-0000:bd:00.3 read  phy:0x07 reg:0x0f val:0x2000
>>     kworker/64:2-1028  [064] ....   172.452862: mdio_access: mii-0000:bd:00.3 read  phy:0x07 reg:0x00 val:0x1040
>>         ifconfig-1324  [011] ....   177.325585: mdio_access: mii-0000:bd:00.1 read  phy:0x03 reg:0x00 val:0x1040
>>   kworker/u257:0-8     [012] ....   177.325642: mdio_access: mii-0000:bd:00.1 read  phy:0x03 reg:0x04 val:0x01e1
>>   kworker/u257:0-8     [012] ....   177.325654: mdio_access: mii-0000:bd:00.1 write phy:0x03 reg:0x04 val:0x05e1
>>   kworker/u257:0-8     [012] ....   177.325708: mdio_access: mii-0000:bd:00.1 read  phy:0x03 reg:0x01 val:0x79ad
>>   kworker/u257:0-8     [012] ....   177.325744: mdio_access: mii-0000:bd:00.1 read  phy:0x03 reg:0x09 val:0x0200
>>   kworker/u257:0-8     [012] ....   177.325779: mdio_access: mii-0000:bd:00.1 read  phy:0x03 reg:0x00 val:0x1040
>>   kworker/u257:0-8     [012] ....   177.325788: mdio_access: mii-0000:bd:00.1 write phy:0x03 reg:0x00 val:0x1240
>>   kworker/u257:0-8     [012] ....   177.325843: mdio_access: mii-0000:bd:00.1 read  phy:0x03 reg:0x01 val:0x798d
> 
> What I think that happens here:
> Writing 0x1240 to BMCR starts aneg. When reading BMSR immediately after that then the PHY seems to have cleared
> the "aneg complete" bit already, but not yet the "link up" bit. This results in the false "link up" notification.
> The following patch is based on the fact that in case of enabled aneg we can't have a valid link if aneg isn't
> finished. Could you please test whether this works for you?
> 
> diff --git a/drivers/net/phy/phy_device.c b/drivers/net/phy/phy_device.c
> index 6b5cb87f3..7ddd91df9 100644
> --- a/drivers/net/phy/phy_device.c
> +++ b/drivers/net/phy/phy_device.c
> @@ -1774,6 +1774,12 @@ int genphy_update_link(struct phy_device *phydev)
>  	phydev->link = status & BMSR_LSTATUS ? 1 : 0;
>  	phydev->autoneg_complete = status & BMSR_ANEGCOMPLETE ? 1 : 0;
>  
> +	/* Consider the case that autoneg was started and "aneg complete"
> +	 * bit has been reset, but "link up" bit not yet.
> +	 */
> +	if (phydev->autoneg == AUTONEG_ENABLE && !phydev->autoneg_complete)
> +		phydev->link = 0;
> +
>  	return 0;
>  }
>  EXPORT_SYMBOL(genphy_update_link);
> 

This patch can solve the issue! Will it be upstream?

So it's nothing to do with the bios, and just the PHY's own behavior,
the "link up" bit can not reset immediately，right?

ps: It will take 1 second more to make the link up for RTL8211F when 0x798d happend.


