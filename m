Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id C28B287127
	for <lists+netdev@lfdr.de>; Fri,  9 Aug 2019 06:58:01 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2405171AbfHIE5x (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 9 Aug 2019 00:57:53 -0400
Received: from szxga03-in.huawei.com ([45.249.212.189]:3085 "EHLO huawei.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1725811AbfHIE5w (ORCPT <rfc822;netdev@vger.kernel.org>);
        Fri, 9 Aug 2019 00:57:52 -0400
Received: from DGGEMM401-HUB.china.huawei.com (unknown [172.30.72.53])
        by Forcepoint Email with ESMTP id 01A2419AF3CE2F54FA67;
        Fri,  9 Aug 2019 12:57:50 +0800 (CST)
Received: from dggeme760-chm.china.huawei.com (10.3.19.106) by
 DGGEMM401-HUB.china.huawei.com (10.3.20.209) with Microsoft SMTP Server (TLS)
 id 14.3.439.0; Fri, 9 Aug 2019 12:57:49 +0800
Received: from [127.0.0.1] (10.57.37.248) by dggeme760-chm.china.huawei.com
 (10.3.19.106) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_128_CBC_SHA256_P256) id 15.1.1591.10; Fri, 9
 Aug 2019 12:57:49 +0800
Subject: Re: [PATCH net] net: phy: rtl8211f: do a double read to get real time
 link status
To:     Andrew Lunn <andrew@lunn.ch>,
        Heiner Kallweit <hkallweit1@gmail.com>
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
From:   Yonglong Liu <liuyonglong@huawei.com>
Message-ID: <414c6809-86a3-506c-b7b0-a32b7cd72fd6@huawei.com>
Date:   Fri, 9 Aug 2019 12:57:48 +0800
User-Agent: Mozilla/5.0 (Windows NT 6.1; WOW64; rv:60.0) Gecko/20100101
 Thunderbird/60.2.1
MIME-Version: 1.0
In-Reply-To: <20190808203415.GO27917@lunn.ch>
Content-Type: text/plain; charset="utf-8"
Content-Language: en-US
Content-Transfer-Encoding: 7bit
X-Originating-IP: [10.57.37.248]
X-ClientProxiedBy: dggeme719-chm.china.huawei.com (10.1.199.115) To
 dggeme760-chm.china.huawei.com (10.3.19.106)
X-CFilter-Loop: Reflected
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org



On 2019/8/9 4:34, Andrew Lunn wrote:
> On Thu, Aug 08, 2019 at 10:01:39PM +0200, Heiner Kallweit wrote:
>> On 08.08.2019 21:40, Andrew Lunn wrote:
>>>> @@ -568,6 +568,11 @@ int phy_start_aneg(struct phy_device *phydev)
>>>>  	if (err < 0)
>>>>  		goto out_unlock;
>>>>  
>>>> +	/* The PHY may not yet have cleared aneg-completed and link-up bit
>>>> +	 * w/o this delay when the following read is done.
>>>> +	 */
>>>> +	usleep_range(1000, 2000);
>>>> +
>>>
>>> Hi Heiner
>>>
>>> Does 802.3 C22 say anything about this?
>>>
>> C22 says:
>> "The Auto-Negotiation process shall be restarted by setting bit 0.9 to a logic one. This bit is self-
>> clearing, and a PHY shall return a value of one in bit 0.9 until the Auto-Negotiation process has been
>> initiated."
>>
>> Maybe we should read bit 0.9 in genphy_update_link() after having read BMSR and report
>> aneg-complete and link-up as false (no matter of their current value) if 0.9 is set.
> 
> Yes. That sounds sensible.
> 
>      Andrew
> 
> .
> 

Hi Heiner:
	I have test more than 50 times, it works. Previously less
than 20 times must be recurrence. so I think this patch solved the
problem.
	And I checked about 40 times of the time gap between read
and autoneg started, all of them is more than 2ms, as below:

  kworker/u257:1-670   [015] ....    27.182632: mdio_access: mii-0000:bd:00.3 write phy:0x07 reg:0x00 val:0x1240
  kworker/u257:1-670   [015] ....    27.184670: mdio_access: mii-0000:bd:00.3 read  phy:0x07 reg:0x01 val:0x7989

