Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 9D0FB89670
	for <lists+netdev@lfdr.de>; Mon, 12 Aug 2019 06:50:07 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1725854AbfHLEt7 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 12 Aug 2019 00:49:59 -0400
Received: from szxga01-in.huawei.com ([45.249.212.187]:3936 "EHLO huawei.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1725648AbfHLEt7 (ORCPT <rfc822;netdev@vger.kernel.org>);
        Mon, 12 Aug 2019 00:49:59 -0400
Received: from DGGEMM401-HUB.china.huawei.com (unknown [172.30.72.55])
        by Forcepoint Email with ESMTP id C8F5E60998AFACD9EDAC;
        Mon, 12 Aug 2019 12:49:51 +0800 (CST)
Received: from dggeme760-chm.china.huawei.com (10.3.19.106) by
 DGGEMM401-HUB.china.huawei.com (10.3.20.209) with Microsoft SMTP Server (TLS)
 id 14.3.439.0; Mon, 12 Aug 2019 12:49:51 +0800
Received: from [127.0.0.1] (10.57.37.248) by dggeme760-chm.china.huawei.com
 (10.3.19.106) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_128_CBC_SHA256_P256) id 15.1.1591.10; Mon, 12
 Aug 2019 12:49:51 +0800
Subject: Re: [PATCH net] net: phy: rtl8211f: do a double read to get real time
 link status
To:     Heiner Kallweit <hkallweit1@gmail.com>,
        Andrew Lunn <andrew@lunn.ch>
CC:     <davem@davemloft.net>, <netdev@vger.kernel.org>,
        <linux-kernel@vger.kernel.org>, <linuxarm@huawei.com>,
        <salil.mehta@huawei.com>, <yisen.zhuang@huawei.com>,
        <shiju.jose@huawei.com>
References: <1565183772-44268-1-git-send-email-liuyonglong@huawei.com>
 <d67831ab-8902-a653-3db9-b2f55adacabd@gmail.com>
 <e663235c-93eb-702d-5a9c-8f781d631c42@huawei.com>
 <080b68c7-abe6-d142-da4b-26e8a7d4dc19@gmail.com>
 <c15f820b-cc80-9a93-4c48-1b60bc14f73a@huawei.com>
 <b1140603-f05b-2373-445f-c1d7a43ff012@gmail.com>
 <20190808194049.GM27917@lunn.ch>
 <26e2c5c9-915c-858b-d091-e5bfa7ab6a5b@gmail.com>
 <20190808203415.GO27917@lunn.ch>
 <414c6809-86a3-506c-b7b0-a32b7cd72fd6@huawei.com>
 <7f18113e-268b-6a4a-af83-236cfa337fcd@gmail.com>
From:   Yonglong Liu <liuyonglong@huawei.com>
Message-ID: <e752d04d-b62c-2979-a44a-62adfc04096e@huawei.com>
Date:   Mon, 12 Aug 2019 12:49:50 +0800
User-Agent: Mozilla/5.0 (Windows NT 6.1; WOW64; rv:60.0) Gecko/20100101
 Thunderbird/60.2.1
MIME-Version: 1.0
In-Reply-To: <7f18113e-268b-6a4a-af83-236cfa337fcd@gmail.com>
Content-Type: text/plain; charset="utf-8"
Content-Language: en-US
Content-Transfer-Encoding: 7bit
X-Originating-IP: [10.57.37.248]
X-ClientProxiedBy: dggeme720-chm.china.huawei.com (10.1.199.116) To
 dggeme760-chm.china.huawei.com (10.3.19.106)
X-CFilter-Loop: Reflected
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org



On 2019/8/10 4:05, Heiner Kallweit wrote:
> On 09.08.2019 06:57, Yonglong Liu wrote:
>>
>>
>> On 2019/8/9 4:34, Andrew Lunn wrote:
>>> On Thu, Aug 08, 2019 at 10:01:39PM +0200, Heiner Kallweit wrote:
>>>> On 08.08.2019 21:40, Andrew Lunn wrote:
>>>>>> @@ -568,6 +568,11 @@ int phy_start_aneg(struct phy_device *phydev)
>>>>>>  	if (err < 0)
>>>>>>  		goto out_unlock;
>>>>>>  
>>>>>> +	/* The PHY may not yet have cleared aneg-completed and link-up bit
>>>>>> +	 * w/o this delay when the following read is done.
>>>>>> +	 */
>>>>>> +	usleep_range(1000, 2000);
>>>>>> +
>>>>>
>>>>> Hi Heiner
>>>>>
>>>>> Does 802.3 C22 say anything about this?
>>>>>
>>>> C22 says:
>>>> "The Auto-Negotiation process shall be restarted by setting bit 0.9 to a logic one. This bit is self-
>>>> clearing, and a PHY shall return a value of one in bit 0.9 until the Auto-Negotiation process has been
>>>> initiated."
>>>>
>>>> Maybe we should read bit 0.9 in genphy_update_link() after having read BMSR and report
>>>> aneg-complete and link-up as false (no matter of their current value) if 0.9 is set.
>>>
>>> Yes. That sounds sensible.
>>>
>>>      Andrew
>>>
>>> .
>>>
>>
>> Hi Heiner:
>> 	I have test more than 50 times, it works. Previously less
>> than 20 times must be recurrence. so I think this patch solved the
>> problem.
>> 	And I checked about 40 times of the time gap between read
>> and autoneg started, all of them is more than 2ms, as below:
>>
>>   kworker/u257:1-670   [015] ....    27.182632: mdio_access: mii-0000:bd:00.3 write phy:0x07 reg:0x00 val:0x1240
>>   kworker/u257:1-670   [015] ....    27.184670: mdio_access: mii-0000:bd:00.3 read  phy:0x07 reg:0x01 val:0x7989
>>
>>
> 
> Instead of using this fixed delay, the following experimental patch
> considers that fact that between triggering aneg start and actual
> start of aneg (incl. clearing aneg-complete bit) Clause 22 requires
> a PHY to keep bit 0.9 (aneg restart) set.
> Could you please test this instead of the fixed-delay patch?
> 
> Thanks, Heiner
> 
> diff --git a/drivers/net/phy/phy_device.c b/drivers/net/phy/phy_device.c
> index b039632de..163295dbc 100644
> --- a/drivers/net/phy/phy_device.c
> +++ b/drivers/net/phy/phy_device.c
> @@ -1741,7 +1741,17 @@ EXPORT_SYMBOL(genphy_aneg_done);
>   */
>  int genphy_update_link(struct phy_device *phydev)
>  {
> -	int status;
> +	int status = 0, bmcr;
> +
> +	bmcr = phy_read(phydev, MII_BMCR);
> +	if (bmcr < 0)
> +		return bmcr;
> +
> +	/* Autoneg is being started, therefore disregard BMSR value and
> +	 * report link as down.
> +	 */
> +	if (bmcr & BMCR_ANRESTART)
> +		goto done;
>  
>  	/* The link state is latched low so that momentary link
>  	 * drops can be detected. Do not double-read the status
> 

Hi Heiner:
	Have test 50+ times, this patch can solved the problem too!

	Share the mdio trace after executing ifconfig ethx up:
# tracer: nop
#
# entries-in-buffer/entries-written: 60/60   #P:128
#
#                              _-----=> irqs-off
#                             / _----=> need-resched
#                            | / _---=> hardirq/softirq
#                            || / _--=> preempt-depth
#                            ||| /     delay
#           TASK-PID   CPU#  ||||    TIMESTAMP  FUNCTION
#              | |       |   ||||       |         |
        ifconfig-1174  [005] ....    27.026691: mdio_access: mii-0000:bd:00.3 read  phy:0x07 reg:0x00 val:0x1040
  kworker/u257:1-670   [020] ....    27.026734: mdio_access: mii-0000:bd:00.3 read  phy:0x07 reg:0x04 val:0x01e1
  kworker/u257:1-670   [020] ....    27.026744: mdio_access: mii-0000:bd:00.3 write phy:0x07 reg:0x04 val:0x05e1
  kworker/u257:1-670   [020] ....    27.026799: mdio_access: mii-0000:bd:00.3 read  phy:0x07 reg:0x01 val:0x79ad
  kworker/u257:1-670   [020] ....    27.026834: mdio_access: mii-0000:bd:00.3 read  phy:0x07 reg:0x09 val:0x0200
  kworker/u257:1-670   [020] ....    27.026869: mdio_access: mii-0000:bd:00.3 read  phy:0x07 reg:0x00 val:0x1040
  kworker/u257:1-670   [020] ....    27.026879: mdio_access: mii-0000:bd:00.3 write phy:0x07 reg:0x00 val:0x1240
  kworker/u257:1-670   [020] ....    27.026932: mdio_access: mii-0000:bd:00.3 read  phy:0x07 reg:0x00 val:0x1240
  kworker/u257:1-670   [020] ....    28.031770: mdio_access: mii-0000:bd:00.3 read  phy:0x07 reg:0x00 val:0x1040
  kworker/u257:1-670   [020] ....    28.031837: mdio_access: mii-0000:bd:00.3 read  phy:0x07 reg:0x01 val:0x7989
  kworker/u257:1-670   [020] ....    29.055837: mdio_access: mii-0000:bd:00.3 read  phy:0x07 reg:0x00 val:0x1040
  kworker/u257:1-670   [020] ....    29.055873: mdio_access: mii-0000:bd:00.3 read  phy:0x07 reg:0x01 val:0x7989
  kworker/u257:0-8     [004] ....    30.079840: mdio_access: mii-0000:bd:00.3 read  phy:0x07 reg:0x00 val:0x1040
  kworker/u257:0-8     [004] ....    30.079875: mdio_access: mii-0000:bd:00.3 read  phy:0x07 reg:0x01 val:0x7989
  kworker/u257:0-8     [004] ....    31.103771: mdio_access: mii-0000:bd:00.3 read  phy:0x07 reg:0x00 val:0x1040
  kworker/u257:0-8     [004] ....    31.103839: mdio_access: mii-0000:bd:00.3 read  phy:0x07 reg:0x01 val:0x79a9
  kworker/u257:0-8     [004] ....    31.103906: mdio_access: mii-0000:bd:00.3 read  phy:0x07 reg:0x0a val:0x7803
  kworker/u257:0-8     [004] ....    31.103973: mdio_access: mii-0000:bd:00.3 read  phy:0x07 reg:0x09 val:0x0200
  kworker/u257:0-8     [004] ....    31.104041: mdio_access: mii-0000:bd:00.3 read  phy:0x07 reg:0x05 val:0xc1e1
  kworker/u257:0-8     [004] ....    32.127814: mdio_access: mii-0000:bd:00.3 read  phy:0x07 reg:0x00 val:0x1040
  kworker/u257:0-8     [004] ....    32.127881: mdio_access: mii-0000:bd:00.3 read  phy:0x07 reg:0x01 val:0x79ad
  kworker/u257:0-8     [004] ....    32.127948: mdio_access: mii-0000:bd:00.3 read  phy:0x07 reg:0x0a val:0x4800
  kworker/u257:0-8     [004] ....    32.128015: mdio_access: mii-0000:bd:00.3 read  phy:0x07 reg:0x09 val:0x0200
  kworker/u257:0-8     [004] ....    32.128082: mdio_access: mii-0000:bd:00.3 read  phy:0x07 reg:0x05 val:0xc1e1
  kworker/u257:0-8     [004] ....    33.151775: mdio_access: mii-0000:bd:00.3 read  phy:0x07 reg:0x00 val:0x1040
  kworker/u257:0-8     [004] ....    33.151815: mdio_access: mii-0000:bd:00.3 read  phy:0x07 reg:0x01 val:0x79ad
  kworker/u257:1-670   [021] ....    34.175771: mdio_access: mii-0000:bd:00.3 read  phy:0x07 reg:0x00 val:0x1040
  kworker/u257:1-670   [021] ....    34.175838: mdio_access: mii-0000:bd:00.3 read  phy:0x07 reg:0x01 val:0x79ad
        ifconfig-1177  [005] ....    35.052340: mdio_access: mii-0000:bd:00.3 read  phy:0x07 reg:0x00 val:0x1040
        ifconfig-1177  [005] ....    35.052350: mdio_access: mii-0000:bd:00.3 write phy:0x07 reg:0x00 val:0x1840

