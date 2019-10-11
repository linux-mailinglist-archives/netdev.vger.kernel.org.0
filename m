Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 6AB0BD38F4
	for <lists+netdev@lfdr.de>; Fri, 11 Oct 2019 07:55:39 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726707AbfJKFzg (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 11 Oct 2019 01:55:36 -0400
Received: from szxga08-in.huawei.com ([45.249.212.255]:54992 "EHLO huawei.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1726116AbfJKFzf (ORCPT <rfc822;netdev@vger.kernel.org>);
        Fri, 11 Oct 2019 01:55:35 -0400
Received: from DGGEMM405-HUB.china.huawei.com (unknown [172.30.72.55])
        by Forcepoint Email with ESMTP id 4F38FF226CE0EBD03314;
        Fri, 11 Oct 2019 13:55:32 +0800 (CST)
Received: from dggeme760-chm.china.huawei.com (10.3.19.106) by
 DGGEMM405-HUB.china.huawei.com (10.3.20.213) with Microsoft SMTP Server (TLS)
 id 14.3.439.0; Fri, 11 Oct 2019 13:55:31 +0800
Received: from [127.0.0.1] (10.57.37.248) by dggeme760-chm.china.huawei.com
 (10.3.19.106) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_128_CBC_SHA256_P256) id 15.1.1713.5; Fri, 11
 Oct 2019 13:55:31 +0800
Subject: Re: [RFC PATCH net] net: phy: Fix "link partner" information
 disappear issue
To:     Heiner Kallweit <hkallweit1@gmail.com>, <davem@davemloft.net>,
        <andrew@lunn.ch>, Florian Fainelli <f.fainelli@gmail.com>
CC:     <netdev@vger.kernel.org>, <linux-kernel@vger.kernel.org>,
        <linuxarm@huawei.com>, <salil.mehta@huawei.com>,
        <yisen.zhuang@huawei.com>, <shiju.jose@huawei.com>
References: <1570699808-55313-1-git-send-email-liuyonglong@huawei.com>
 <ee969d27-debe-9bc4-92f2-fe5b04c36a39@gmail.com>
From:   Yonglong Liu <liuyonglong@huawei.com>
Message-ID: <670bd6ac-54ee-ecfa-c108-fcf48a3a7dc8@huawei.com>
Date:   Fri, 11 Oct 2019 13:55:30 +0800
User-Agent: Mozilla/5.0 (Windows NT 6.1; WOW64; rv:60.0) Gecko/20100101
 Thunderbird/60.2.1
MIME-Version: 1.0
In-Reply-To: <ee969d27-debe-9bc4-92f2-fe5b04c36a39@gmail.com>
Content-Type: text/plain; charset="utf-8"
Content-Language: en-US
Content-Transfer-Encoding: 7bit
X-Originating-IP: [10.57.37.248]
X-ClientProxiedBy: dggeme715-chm.china.huawei.com (10.1.199.111) To
 dggeme760-chm.china.huawei.com (10.3.19.106)
X-CFilter-Loop: Reflected
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org



On 2019/10/11 3:17, Heiner Kallweit wrote:
> On 10.10.2019 11:30, Yonglong Liu wrote:
>> Some drivers just call phy_ethtool_ksettings_set() to set the
>> links, for those phy drivers that use genphy_read_status(), if
>> autoneg is on, and the link is up, than execute "ethtool -s
>> ethx autoneg on" will cause "link partner" information disappear.
>>
>> The call trace is phy_ethtool_ksettings_set()->phy_start_aneg()
>> ->linkmode_zero(phydev->lp_advertising)->genphy_read_status(),
>> the link didn't change, so genphy_read_status() just return, and
>> phydev->lp_advertising is zero now.
>>
> I think that clearing link partner advertising info in
> phy_start_aneg() is questionable. If advertising doesn't change
> then phy_config_aneg() basically is a no-op. Instead we may have
> to clear the link partner advertising info in genphy_read_lpa()
> if aneg is disabled or aneg isn't completed (basically the same
> as in genphy_c45_read_lpa()). Something like:
> 
> if (!phydev->autoneg_complete) { /* also covers case that aneg is disabled */
> 	linkmode_zero(phydev->lp_advertising);
> } else if (phydev->autoneg == AUTONEG_ENABLE) {
> 	...
> }
> 

If clear the link partner advertising info in genphy_read_lpa() and
genphy_c45_read_lpa(), for the drivers that use genphy_read_status()
is ok, but for those drivers that use there own read_status() may
have problem, like aqr_read_status(), it will update lp_advertising
first, and than call genphy_c45_read_status(), so will cause
lp_advertising lost.

Another question, please see genphy_c45_read_status(), if clear the
link partner advertising info in genphy_c45_read_lpa(), if autoneg is
off, phydev->lp_advertising will not clear.

>> This patch call genphy_read_lpa() before the link state judgement
>> to fix this problem.
>>
>> Fixes: 88d6272acaaa ("net: phy: avoid unneeded MDIO reads in genphy_read_status")
>> Signed-off-by: Yonglong Liu <liuyonglong@huawei.com>
>> ---
>>  drivers/net/phy/phy_device.c | 8 ++++----
>>  1 file changed, 4 insertions(+), 4 deletions(-)
>>
>> diff --git a/drivers/net/phy/phy_device.c b/drivers/net/phy/phy_device.c
>> index 9d2bbb1..ef3073c 100644
>> --- a/drivers/net/phy/phy_device.c
>> +++ b/drivers/net/phy/phy_device.c
>> @@ -1839,6 +1839,10 @@ int genphy_read_status(struct phy_device *phydev)
>>  	if (err)
>>  		return err;
>>  
>> +	err = genphy_read_lpa(phydev);
>> +	if (err < 0)
>> +		return err;
>> +
>>  	/* why bother the PHY if nothing can have changed */
>>  	if (phydev->autoneg == AUTONEG_ENABLE && old_link && phydev->link)
>>  		return 0;
>> @@ -1848,10 +1852,6 @@ int genphy_read_status(struct phy_device *phydev)
>>  	phydev->pause = 0;
>>  	phydev->asym_pause = 0;
>>  
>> -	err = genphy_read_lpa(phydev);
>> -	if (err < 0)
>> -		return err;
>> -
>>  	if (phydev->autoneg == AUTONEG_ENABLE && phydev->autoneg_complete) {
>>  		phy_resolve_aneg_linkmode(phydev);
>>  	} else if (phydev->autoneg == AUTONEG_DISABLE) {
>>
> 
> 
> .
> 

