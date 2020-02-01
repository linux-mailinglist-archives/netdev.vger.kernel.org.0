Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 0431D14F5BD
	for <lists+netdev@lfdr.de>; Sat,  1 Feb 2020 02:34:16 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726708AbgBABdc (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 31 Jan 2020 20:33:32 -0500
Received: from lelv0143.ext.ti.com ([198.47.23.248]:56010 "EHLO
        lelv0143.ext.ti.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726373AbgBABdc (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 31 Jan 2020 20:33:32 -0500
Received: from lelv0266.itg.ti.com ([10.180.67.225])
        by lelv0143.ext.ti.com (8.15.2/8.15.2) with ESMTP id 0111XPmp055911;
        Fri, 31 Jan 2020 19:33:25 -0600
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=ti.com;
        s=ti-com-17Q1; t=1580520805;
        bh=ltO/X86l/eQ0YQ6yCZwHOlZYycq3A6PW6ZvjoRyYgTE=;
        h=Subject:To:CC:References:From:Date:In-Reply-To;
        b=HNl7IWA5kq8oJ8oM4SWS3/8qztwPv3jEkrsRZkCaBjcVrS2yTI3DAxPT7dOCIOuSj
         ZFZRVeRH45QBLLvLnwtb+iWIa/iFGi9b6QM04Sg0/1rHlq3r4GVX5g3fDIDbp+l2WS
         mb2E5svuORClNc2/UhAhRwvpu0keUMr7m6izgHog=
Received: from DLEE115.ent.ti.com (dlee115.ent.ti.com [157.170.170.26])
        by lelv0266.itg.ti.com (8.15.2/8.15.2) with ESMTPS id 0111XP0n010124
        (version=TLSv1.2 cipher=AES256-GCM-SHA384 bits=256 verify=FAIL);
        Fri, 31 Jan 2020 19:33:25 -0600
Received: from DLEE111.ent.ti.com (157.170.170.22) by DLEE115.ent.ti.com
 (157.170.170.26) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_128_CBC_SHA256_P256) id 15.1.1847.3; Fri, 31
 Jan 2020 19:33:24 -0600
Received: from lelv0327.itg.ti.com (10.180.67.183) by DLEE111.ent.ti.com
 (157.170.170.22) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_128_CBC_SHA256_P256) id 15.1.1847.3 via
 Frontend Transport; Fri, 31 Jan 2020 19:33:25 -0600
Received: from [10.250.65.13] (ileax41-snat.itg.ti.com [10.172.224.153])
        by lelv0327.itg.ti.com (8.15.2/8.15.2) with ESMTP id 0111XOcp068100;
        Fri, 31 Jan 2020 19:33:24 -0600
Subject: Re: [PATCH net-master 1/1] net: phy: dp83867: Add speed optimization
 feature
To:     Heiner Kallweit <hkallweit1@gmail.com>, <andrew@lunn.ch>,
        <f.fainelli@gmail.com>, <bunk@kernel.org>
CC:     <netdev@vger.kernel.org>, <devicetree@vger.kernel.org>,
        <linux-kernel@vger.kernel.org>, <grygorii.strashko@ti.com>
References: <20200131151110.31642-1-dmurphy@ti.com>
 <20200131151110.31642-2-dmurphy@ti.com>
 <7e8080f7-3825-98f5-2465-c536ecbb8146@gmail.com>
From:   Dan Murphy <dmurphy@ti.com>
Message-ID: <27ab4feb-fe84-4d3b-1779-25a25065a9fa@ti.com>
Date:   Fri, 31 Jan 2020 19:30:05 -0600
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:68.0) Gecko/20100101
 Thunderbird/68.4.1
MIME-Version: 1.0
In-Reply-To: <7e8080f7-3825-98f5-2465-c536ecbb8146@gmail.com>
Content-Type: text/plain; charset="utf-8"; format=flowed
Content-Transfer-Encoding: 8bit
Content-Language: en-US
X-EXCLAIMER-MD-CONFIG: e1e8a2fd-e40a-4ac6-ac9b-f7e9cc9ee180
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Heiner

On 1/31/20 2:56 PM, Heiner Kallweit wrote:
> On 31.01.2020 16:11, Dan Murphy wrote:
>> Set the speed optimization bit on the DP83867 PHY.
>> This feature can also be strapped on the 64 pin PHY devices
>> but the 48 pin devices do not have the strap pin available to enable
>> this feature in the hardware.  PHY team suggests to have this bit set.
>>
> It's ok to enable downshift by default, however it would be good to
> make it configurable. Best implement the downshift tunable, you can
> use the Marvell PHY driver as reference.
> Can the number of attempts until downshifts happens be configured?

Yes we can tune the number of attempts it makes to negotiate 1000Mbps 
before enabling the speed optimization.  But why would we need to 
configure the number of attempts currently it is defaulted to 4.  Is 
there a use case for this level of configurability?


>
>> With this bit set the PHY will auto negotiate and report the link
>> parameters in the PHYSTS register and not in the BMCR.  So we need to
>> over ride the genphy_read_status with a DP83867 specific read status.
>>
>> Signed-off-by: Dan Murphy <dmurphy@ti.com>
>> ---
>>   drivers/net/phy/dp83867.c | 48 +++++++++++++++++++++++++++++++++++++++
>>   1 file changed, 48 insertions(+)
>>
>> diff --git a/drivers/net/phy/dp83867.c b/drivers/net/phy/dp83867.c
>> index 967f57ed0b65..695aaf4f942f 100644
>> --- a/drivers/net/phy/dp83867.c
>> +++ b/drivers/net/phy/dp83867.c
>> @@ -21,6 +21,7 @@
>>   #define DP83867_DEVADDR		0x1f
>>   
>>   #define MII_DP83867_PHYCTRL	0x10
>> +#define MII_DP83867_PHYSTS	0x11
>>   #define MII_DP83867_MICR	0x12
>>   #define MII_DP83867_ISR		0x13
>>   #define DP83867_CFG2		0x14
>> @@ -118,6 +119,15 @@
>>   #define DP83867_IO_MUX_CFG_CLK_O_SEL_MASK	(0x1f << 8)
>>   #define DP83867_IO_MUX_CFG_CLK_O_SEL_SHIFT	8
>>   
>> +/* PHY STS bits */
>> +#define DP83867_PHYSTS_1000			BIT(15)
>> +#define DP83867_PHYSTS_100			BIT(14)
>> +#define DP83867_PHYSTS_DUPLEX			BIT(13)
>> +#define DP83867_PHYSTS_LINK			BIT(10)
>> +
>> +/* CFG2 bits */
>> +#define DP83867_SPEED_OPTIMIZED_EN		(BIT(8) | BIT(9))
>> +
>>   /* CFG3 bits */
>>   #define DP83867_CFG3_INT_OE			BIT(7)
>>   #define DP83867_CFG3_ROBUST_AUTO_MDIX		BIT(9)
>> @@ -287,6 +297,36 @@ static int dp83867_config_intr(struct phy_device *phydev)
>>   	return phy_write(phydev, MII_DP83867_MICR, micr_status);
>>   }
>>   
>> +static int dp83867_read_status(struct phy_device *phydev)
>> +{
>> +	int status = phy_read(phydev, MII_DP83867_PHYSTS);
>> +
>> +	if (status < 0)
>> +		return status;
>> +
>> +	if (status & DP83867_PHYSTS_DUPLEX)
>> +		phydev->duplex = DUPLEX_FULL;
>> +	else
>> +		phydev->duplex = DUPLEX_HALF;
>> +
>> +	if (status & DP83867_PHYSTS_1000)
>> +		phydev->speed = SPEED_1000;
>> +	else if (status & DP83867_PHYSTS_100)
>> +		phydev->speed = SPEED_100;
>> +	else
>> +		phydev->speed = SPEED_10;
>> +
>> +	if (status & DP83867_PHYSTS_LINK)
>> +		phydev->link = 1;
>> +	else
>> +		phydev->link = 0;
>> +
>> +	phydev->pause = 0;
>> +	phydev->asym_pause = 0;
>> +
>> +	return 0;
>> +}
>> +
>>   static int dp83867_config_port_mirroring(struct phy_device *phydev)
>>   {
>>   	struct dp83867_private *dp83867 =
>> @@ -467,6 +507,12 @@ static int dp83867_config_init(struct phy_device *phydev)
>>   	int ret, val, bs;
>>   	u16 delay;
>>   
>> +	/* Force speed optimization for the PHY even if it strapped */
>> +	ret = phy_modify(phydev, DP83867_CFG2, DP83867_SPEED_OPTIMIZED_EN,
>> +			 DP83867_SPEED_OPTIMIZED_EN);
> Here phy_set_bits() would be easier.

Ack

Dan


