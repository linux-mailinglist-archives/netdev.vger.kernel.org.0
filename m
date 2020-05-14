Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 3CEC51D4065
	for <lists+netdev@lfdr.de>; Thu, 14 May 2020 23:53:06 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727084AbgENVxD (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 14 May 2020 17:53:03 -0400
Received: from lelv0143.ext.ti.com ([198.47.23.248]:59060 "EHLO
        lelv0143.ext.ti.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726046AbgENVxD (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 14 May 2020 17:53:03 -0400
Received: from fllv0034.itg.ti.com ([10.64.40.246])
        by lelv0143.ext.ti.com (8.15.2/8.15.2) with ESMTP id 04ELqvKs096190;
        Thu, 14 May 2020 16:52:57 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=ti.com;
        s=ti-com-17Q1; t=1589493177;
        bh=gq1egVzpDSB9B+OD1HzxXbmyNMglkSN4GoPkuCuAoZw=;
        h=Subject:To:CC:References:From:Date:In-Reply-To;
        b=tVE470XWB6YZ/q4MZMgEKQqGk8Bs3y5T7zDmGrQpAWdSperW386SBKl4uKuOtpUeU
         CUnOziB5GRQI9kJ1ZJkB0I8bTVUhVaLr96mQnsYtVSYl3L7RdigjQFCT+6lrSxLcXG
         5B8fhqNusISqVdLe2vlubt9M4B86QPWxCctcuBDI=
Received: from DFLE115.ent.ti.com (dfle115.ent.ti.com [10.64.6.36])
        by fllv0034.itg.ti.com (8.15.2/8.15.2) with ESMTPS id 04ELqvGJ030194
        (version=TLSv1.2 cipher=AES256-GCM-SHA384 bits=256 verify=FAIL);
        Thu, 14 May 2020 16:52:57 -0500
Received: from DFLE106.ent.ti.com (10.64.6.27) by DFLE115.ent.ti.com
 (10.64.6.36) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_128_CBC_SHA256_P256) id 15.1.1979.3; Thu, 14
 May 2020 16:52:57 -0500
Received: from fllv0039.itg.ti.com (10.64.41.19) by DFLE106.ent.ti.com
 (10.64.6.27) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_128_CBC_SHA256_P256) id 15.1.1979.3 via
 Frontend Transport; Thu, 14 May 2020 16:52:57 -0500
Received: from [10.250.52.63] (ileax41-snat.itg.ti.com [10.172.224.153])
        by fllv0039.itg.ti.com (8.15.2/8.15.2) with ESMTP id 04ELqvEs072265;
        Thu, 14 May 2020 16:52:57 -0500
Subject: Re: [PATCH net-next 2/2] net: phy: DP83822: Add ability to advertise
 Fiber connection
To:     Andrew Lunn <andrew@lunn.ch>
CC:     <f.fainelli@gmail.com>, <hkallweit1@gmail.com>,
        <davem@davemloft.net>, <robh@kernel.org>, <netdev@vger.kernel.org>,
        <linux-kernel@vger.kernel.org>, <devicetree@vger.kernel.org>
References: <20200514173055.15013-1-dmurphy@ti.com>
 <20200514173055.15013-3-dmurphy@ti.com> <20200514185217.GX499265@lunn.ch>
From:   Dan Murphy <dmurphy@ti.com>
Message-ID: <2ccba0e1-d7f1-86ae-d67c-5e9f4a3b0c4f@ti.com>
Date:   Thu, 14 May 2020 16:43:25 -0500
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:68.0) Gecko/20100101
 Thunderbird/68.7.0
MIME-Version: 1.0
In-Reply-To: <20200514185217.GX499265@lunn.ch>
Content-Type: text/plain; charset="utf-8"; format=flowed
Content-Transfer-Encoding: 8bit
Content-Language: en-US
X-EXCLAIMER-MD-CONFIG: e1e8a2fd-e40a-4ac6-ac9b-f7e9cc9ee180
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Andrew

On 5/14/20 1:52 PM, Andrew Lunn wrote:
>> +static int dp83822_config_init(struct phy_device *phydev)
>> +{
>> +	struct dp83822_private *dp83822 = phydev->priv;
>> +	int err = 0;
>> +
>> +	if (dp83822->fx_enabled) {
>> +		linkmode_set_bit(ETHTOOL_LINK_MODE_FIBRE_BIT,
>> +				 phydev->supported);
>> +		linkmode_set_bit(ETHTOOL_LINK_MODE_FIBRE_BIT,
>> +				 phydev->advertising);
>> +
>> +		/*  Auto negotiation is not available in fiber mode */
>> +		phydev->autoneg = AUTONEG_DISABLE;
>> +		phydev->speed = SPEED_100;
>> +		phydev->duplex = DUPLEX_FULL;
> Hi Dan
>
> This is normally determined by reading the ability registers,
> genphy_read_abilities(). When strapped to fibre mode, does it still
> indicate all the usual copper capabilities, which it can not actually
> do?

Auto negotiation is not available when in Fiber mode for this PHY.  The 
Speed is locked at 100Mbps for fiber.

Duplex can be either FULL or HALF so that should be removed.

I am verifying with the PHY team on the BMSR register but I do not see 
any bits for FX there.

If we remove these settings then I will need to read the PHY_STS 
register to manage the speed and mode of the fiber.  This register 
reports the PHY link status regardless of the mode.

Dan


>
> 	Andrew
