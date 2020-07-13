Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id A016C21DAC4
	for <lists+netdev@lfdr.de>; Mon, 13 Jul 2020 17:50:48 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1730039AbgGMPum (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 13 Jul 2020 11:50:42 -0400
Received: from fllv0015.ext.ti.com ([198.47.19.141]:55690 "EHLO
        fllv0015.ext.ti.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1729644AbgGMPum (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 13 Jul 2020 11:50:42 -0400
Received: from lelv0265.itg.ti.com ([10.180.67.224])
        by fllv0015.ext.ti.com (8.15.2/8.15.2) with ESMTP id 06DFoZm7040441;
        Mon, 13 Jul 2020 10:50:35 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=ti.com;
        s=ti-com-17Q1; t=1594655435;
        bh=UP8gUaK9xzAkhH7w+bk3utyGDEWK8nP4G8Haxvi0cTQ=;
        h=Subject:To:CC:References:From:Date:In-Reply-To;
        b=ScekaUzrbaORIdLjpDoS6wmlw8wwWpYf5PkR1593q1pOSxRxSLV8RebfwBfG+M3rN
         6kktOvbB18iFIb1WbfbJNgT8JMRw1AERIHqvEdeDjTsECzwbqL7RwSGJVwCeBWEfgL
         OdbvaRJDU+NjbL3KwgND66BmtcfiAbj+O0ofVvL8=
Received: from DLEE114.ent.ti.com (dlee114.ent.ti.com [157.170.170.25])
        by lelv0265.itg.ti.com (8.15.2/8.15.2) with ESMTPS id 06DFoZtf074057
        (version=TLSv1.2 cipher=AES256-GCM-SHA384 bits=256 verify=FAIL);
        Mon, 13 Jul 2020 10:50:35 -0500
Received: from DLEE104.ent.ti.com (157.170.170.34) by DLEE114.ent.ti.com
 (157.170.170.25) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_128_CBC_SHA256_P256) id 15.1.1979.3; Mon, 13
 Jul 2020 10:50:35 -0500
Received: from fllv0040.itg.ti.com (10.64.41.20) by DLEE104.ent.ti.com
 (157.170.170.34) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_128_CBC_SHA256_P256) id 15.1.1979.3 via
 Frontend Transport; Mon, 13 Jul 2020 10:50:34 -0500
Received: from [10.250.32.229] (ileax41-snat.itg.ti.com [10.172.224.153])
        by fllv0040.itg.ti.com (8.15.2/8.15.2) with ESMTP id 06DFoYKa042533;
        Mon, 13 Jul 2020 10:50:34 -0500
Subject: Re: [PATCH net-next v2 2/2] net: phy: DP83822: Add ability to
 advertise Fiber connection
To:     Andrew Lunn <andrew@lunn.ch>
CC:     <f.fainelli@gmail.com>, <hkallweit1@gmail.com>,
        <davem@davemloft.net>, <robh@kernel.org>, <netdev@vger.kernel.org>,
        <linux-kernel@vger.kernel.org>, <devicetree@vger.kernel.org>
References: <20200710143733.30751-1-dmurphy@ti.com>
 <20200710143733.30751-3-dmurphy@ti.com> <20200711185421.GS1014141@lunn.ch>
From:   Dan Murphy <dmurphy@ti.com>
Message-ID: <2d1d297c-e252-98df-bf96-d6630dd9a423@ti.com>
Date:   Mon, 13 Jul 2020 10:50:29 -0500
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:68.0) Gecko/20100101
 Thunderbird/68.10.0
MIME-Version: 1.0
In-Reply-To: <20200711185421.GS1014141@lunn.ch>
Content-Type: text/plain; charset="utf-8"; format=flowed
Content-Transfer-Encoding: 7bit
Content-Language: en-US
X-EXCLAIMER-MD-CONFIG: e1e8a2fd-e40a-4ac6-ac9b-f7e9cc9ee180
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Andrew

On 7/11/20 1:54 PM, Andrew Lunn wrote:
>> @@ -302,6 +357,48 @@ static int dp83822_config_init(struct phy_device *phydev)
>>   		}
>>   	}
>>   
>> +	if (dp83822->fx_enabled) {
>> +		err = phy_modify(phydev, MII_DP83822_CTRL_2,
>> +				 DP83822_FX_ENABLE, 1);
>> +		if (err < 0)
>> +			return err;
>> +
>> +		linkmode_set_bit(ETHTOOL_LINK_MODE_FIBRE_BIT,
>> +				 phydev->supported);
>> +		linkmode_set_bit(ETHTOOL_LINK_MODE_FIBRE_BIT,
>> +				 phydev->advertising);
>> +
>> +		/* Auto neg is not supported in fiber mode */
>> +		bmcr = phy_read(phydev, MII_BMCR);
>> +		if (bmcr < 0)
>> +			return bmcr;
>> +
>> +		if (bmcr & BMCR_ANENABLE) {
>> +			err =  phy_modify(phydev, MII_BMCR, BMCR_ANENABLE, 0);
>> +			if (err < 0)
>> +				return err;
>> +		}
>> +		phydev->autoneg = AUTONEG_DISABLE;
> You should also be removing ETHTOOL_LINK_MODE_Autoneg_BIT from
> phydev->supported, to make it clear autoneg is not supported. Assuming
> genphy_read_abilities() cannot figure this out for itself.

In our testing we are finding that it cannot determine that for itself 
so I will have to clear the bit.

Dan

