Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 759D8D85E5
	for <lists+netdev@lfdr.de>; Wed, 16 Oct 2019 04:28:21 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1732013AbfJPC2O (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 15 Oct 2019 22:28:14 -0400
Received: from szxga08-in.huawei.com ([45.249.212.255]:58940 "EHLO huawei.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1726534AbfJPC2O (ORCPT <rfc822;netdev@vger.kernel.org>);
        Tue, 15 Oct 2019 22:28:14 -0400
Received: from DGGEMM406-HUB.china.huawei.com (unknown [172.30.72.55])
        by Forcepoint Email with ESMTP id 50700C9C40FD3F12D008;
        Wed, 16 Oct 2019 10:28:11 +0800 (CST)
Received: from dggeme760-chm.china.huawei.com (10.3.19.106) by
 DGGEMM406-HUB.china.huawei.com (10.3.20.214) with Microsoft SMTP Server (TLS)
 id 14.3.439.0; Wed, 16 Oct 2019 10:28:10 +0800
Received: from [127.0.0.1] (10.57.37.248) by dggeme760-chm.china.huawei.com
 (10.3.19.106) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_128_CBC_SHA256_P256) id 15.1.1713.5; Wed, 16
 Oct 2019 10:27:55 +0800
Subject: Re: [RFC PATCH V2 net] net: phy: Fix "link partner" information
 disappear issue
To:     Heiner Kallweit <hkallweit1@gmail.com>, <davem@davemloft.net>,
        <andrew@lunn.ch>
CC:     <netdev@vger.kernel.org>, <linux-kernel@vger.kernel.org>,
        <linuxarm@huawei.com>, <salil.mehta@huawei.com>,
        <yisen.zhuang@huawei.com>, <shiju.jose@huawei.com>
References: <1571057797-37602-1-git-send-email-liuyonglong@huawei.com>
 <4a281b6d-1531-eac6-dcc5-8306d342caa4@gmail.com>
From:   Yonglong Liu <liuyonglong@huawei.com>
Message-ID: <53e41316-17d8-05b6-92dd-f4feb0617474@huawei.com>
Date:   Wed, 16 Oct 2019 10:27:55 +0800
User-Agent: Mozilla/5.0 (Windows NT 6.1; WOW64; rv:60.0) Gecko/20100101
 Thunderbird/60.2.1
MIME-Version: 1.0
In-Reply-To: <4a281b6d-1531-eac6-dcc5-8306d342caa4@gmail.com>
Content-Type: text/plain; charset="utf-8"
Content-Language: en-US
Content-Transfer-Encoding: 7bit
X-Originating-IP: [10.57.37.248]
X-ClientProxiedBy: dggeme710-chm.china.huawei.com (10.1.199.106) To
 dggeme760-chm.china.huawei.com (10.3.19.106)
X-CFilter-Loop: Reflected
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org



On 2019/10/16 4:02, Heiner Kallweit wrote:
> On 14.10.2019 14:56, Yonglong Liu wrote:
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
>> This patch moves the clear operation of lp_advertising from
>> phy_start_aneg() to genphy_read_lpa()/genphy_c45_read_lpa(), and
>> if autoneg on and autoneg not complete, just clear what the
>> generic functions care about.
>>
>> Fixes: 88d6272acaaa ("net: phy: avoid unneeded MDIO reads in genphy_read_status")
>> Signed-off-by: Yonglong Liu <liuyonglong@huawei.com>
>>
> Looks good to me, two small nits below.
> 
> 

Thanks! Will fix the two small nits and send it to "net" branch.

>> ---
>> change log:
>> V2: moves the clear operation of lp_advertising from
>> phy_start_aneg() to genphy_read_lpa()/genphy_c45_read_lpa(), and
>> if autoneg on and autoneg not complete, just clear what the
>> generic functions care about. Suggested by Heiner Kallweit.
>> ---
>> ---
> This line seems to be duplicated.
> 
>>  drivers/net/phy/phy-c45.c    |  2 ++
>>  drivers/net/phy/phy.c        |  3 ---
>>  drivers/net/phy/phy_device.c | 12 +++++++++++-
>>  3 files changed, 13 insertions(+), 4 deletions(-)
>>
>> diff --git a/drivers/net/phy/phy-c45.c b/drivers/net/phy/phy-c45.c
>> index 7935593..a1caeee 100644
>> --- a/drivers/net/phy/phy-c45.c
>> +++ b/drivers/net/phy/phy-c45.c
>> @@ -323,6 +323,8 @@ int genphy_c45_read_pma(struct phy_device *phydev)
>>  {
>>  	int val;
>>  
>> +	linkmode_zero(phydev->lp_advertising);
>> +
>>  	val = phy_read_mmd(phydev, MDIO_MMD_PMAPMD, MDIO_CTRL1);
>>  	if (val < 0)
>>  		return val;
>> diff --git a/drivers/net/phy/phy.c b/drivers/net/phy/phy.c
>> index 119e6f4..105d389b 100644
>> --- a/drivers/net/phy/phy.c
>> +++ b/drivers/net/phy/phy.c
>> @@ -572,9 +572,6 @@ int phy_start_aneg(struct phy_device *phydev)
>>  	if (AUTONEG_DISABLE == phydev->autoneg)
>>  		phy_sanitize_settings(phydev);
>>  
>> -	/* Invalidate LP advertising flags */
>> -	linkmode_zero(phydev->lp_advertising);
>> -
>>  	err = phy_config_aneg(phydev);
>>  	if (err < 0)
>>  		goto out_unlock;
>> diff --git a/drivers/net/phy/phy_device.c b/drivers/net/phy/phy_device.c
>> index 9d2bbb1..4b43466 100644
>> --- a/drivers/net/phy/phy_device.c
>> +++ b/drivers/net/phy/phy_device.c
>> @@ -1787,7 +1787,14 @@ int genphy_read_lpa(struct phy_device *phydev)
>>  {
>>  	int lpa, lpagb;
>>  
>> -	if (phydev->autoneg == AUTONEG_ENABLE && phydev->autoneg_complete) {
>> +	if (phydev->autoneg == AUTONEG_ENABLE) {
>> +		if (!phydev->autoneg_complete) {
>> +			mii_stat1000_mod_linkmode_lpa_t(phydev->lp_advertising,
>> +							0);
>> +			mii_lpa_mod_linkmode_lpa_t(phydev->lp_advertising, 0);
>> +			return 0;
>> +		}
>> +
>>  		if (phydev->is_gigabit_capable) {
>>  			lpagb = phy_read(phydev, MII_STAT1000);
>>  			if (lpagb < 0)
>> @@ -1816,6 +1823,9 @@ int genphy_read_lpa(struct phy_device *phydev)
>>  
>>  		mii_lpa_mod_linkmode_lpa_t(phydev->lp_advertising, lpa);
>>  	}
>> +	else {
> 
> "} else {" should be on one line.
> 
>> +		linkmode_zero(phydev->lp_advertising);
>> +	}
>>  
>>  	return 0;
>>  }
>>
> 
> 
> .
> 

