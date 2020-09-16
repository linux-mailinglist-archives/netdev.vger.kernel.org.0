Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 97E7426CD2C
	for <lists+netdev@lfdr.de>; Wed, 16 Sep 2020 22:55:22 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727957AbgIPUzA (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 16 Sep 2020 16:55:00 -0400
Received: from lelv0142.ext.ti.com ([198.47.23.249]:57342 "EHLO
        lelv0142.ext.ti.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1727174AbgIPUyy (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 16 Sep 2020 16:54:54 -0400
Received: from fllv0035.itg.ti.com ([10.64.41.0])
        by lelv0142.ext.ti.com (8.15.2/8.15.2) with ESMTP id 08GKsejU047173;
        Wed, 16 Sep 2020 15:54:40 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=ti.com;
        s=ti-com-17Q1; t=1600289680;
        bh=xWqHCu7jfOaINCHQDzJtCt2bywNS0XOYCTj1VHDUf2U=;
        h=Subject:To:CC:References:From:Date:In-Reply-To;
        b=D4ZgRyxI2wcdEaHE75nx5j7/9vcNp0dl2dmu4+OpGATsO4H8+/gm6I2CXNb/i/35q
         wRVC9WrPzbyTZo3zS71Vtr1ZZntzIlpQB4ttAf9un/0lDIkGvtANzNCEN4tL0rkk/2
         F/C9dOT67XOPwYJxNenxf9M2iUMsSdhb3eiboaR0=
Received: from DLEE109.ent.ti.com (dlee109.ent.ti.com [157.170.170.41])
        by fllv0035.itg.ti.com (8.15.2/8.15.2) with ESMTP id 08GKse8H078555;
        Wed, 16 Sep 2020 15:54:40 -0500
Received: from DLEE108.ent.ti.com (157.170.170.38) by DLEE109.ent.ti.com
 (157.170.170.41) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_128_CBC_SHA256_P256) id 15.1.1979.3; Wed, 16
 Sep 2020 15:54:39 -0500
Received: from fllv0039.itg.ti.com (10.64.41.19) by DLEE108.ent.ti.com
 (157.170.170.38) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_128_CBC_SHA256_P256) id 15.1.1979.3 via
 Frontend Transport; Wed, 16 Sep 2020 15:54:39 -0500
Received: from [10.250.32.129] (ileax41-snat.itg.ti.com [10.172.224.153])
        by fllv0039.itg.ti.com (8.15.2/8.15.2) with ESMTP id 08GKsdhk113843;
        Wed, 16 Sep 2020 15:54:39 -0500
Subject: Re: [PATCH net-next 2/3] net: dp83869: Add ability to advertise Fiber
 connection
To:     Andrew Lunn <andrew@lunn.ch>
CC:     <davem@davemloft.net>, <f.fainelli@gmail.com>,
        <hkallweit1@gmail.com>, <mkubecek@suse.cz>,
        <netdev@vger.kernel.org>, <linux-kernel@vger.kernel.org>
References: <20200915181708.25842-1-dmurphy@ti.com>
 <20200915181708.25842-3-dmurphy@ti.com> <20200915201718.GD3526428@lunn.ch>
From:   Dan Murphy <dmurphy@ti.com>
Message-ID: <4b297d8a-b4da-0e19-a5fb-6dda89ca4148@ti.com>
Date:   Wed, 16 Sep 2020 15:54:34 -0500
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:68.0) Gecko/20100101
 Thunderbird/68.10.0
MIME-Version: 1.0
In-Reply-To: <20200915201718.GD3526428@lunn.ch>
Content-Type: text/plain; charset="utf-8"; format=flowed
Content-Transfer-Encoding: 8bit
Content-Language: en-US
X-EXCLAIMER-MD-CONFIG: e1e8a2fd-e40a-4ac6-ac9b-f7e9cc9ee180
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Andrew

On 9/15/20 3:17 PM, Andrew Lunn wrote:
>> +		linkmode_set_bit(ETHTOOL_LINK_MODE_100baseFX_Full_BIT,
>> +				 phydev->supported);
>> +		linkmode_set_bit(ETHTOOL_LINK_MODE_100baseFX_Half_BIT,
>> +				 phydev->supported);
>> +
>> +		/* Auto neg is not supported in 100base FX mode */
> Hi Dan
>
> If it does not support auto neg, how do you decide to do half duplex?
> I don't see any code here which allows the user to configure it.

Ethtool has the provisions to set the duplex and speed right?.

The only call back I see which is valid is config_aneg which would still 
require a user space tool to set the needed link modes.

I could implement the config_aneg to call genphy_setup_forced if auto 
neg is disabled but that function just writes the BMCR which is already 
updated and if auto neg is enabled it would just call 
genphy_check_and_restart_aneg.

I verified the ethtool path with the DP83822 by reading the BMCR and 
ethtool displayed the correct advertisement

root@am335x-evm:~# ethtool -s eth0 speed 100 duplex full
root@am335x-evm:~# ethtool eth0
Settings for eth0:
         Supported ports: [ TP MII FIBRE ]
         Supported link modes:   10baseT/Half 10baseT/Full
                                 100baseT/Half 100baseT/Full
         Supported pause frame use: Symmetric Receive-only
         Supports auto-negotiation: No
         Supported FEC modes: Not reported
         Advertised link modes:  100baseT/Full

<snip>

root@am335x-evm:~# ethtool -s eth0 speed 10 duplex half
root@am335x-evm:~# ethtool eth0
Settings for eth0:
         Supported ports: [ TP MII FIBRE ]
         Supported link modes:   10baseT/Half 10baseT/Full
                                 100baseT/Half 100baseT/Full
         Supported pause frame use: Symmetric Receive-only
         Supports auto-negotiation: No
         Supported FEC modes: Not reported
         Advertised link modes:  10baseT/Half

root@am335x-evm:~# ./mdio-test g eth0 0
0x0000
root@am335x-evm:~# ethtool -s eth0 speed 100 duplex full
root@am335x-evm:~# ./mdio-test g eth0 0
0x2100
root@am335x-evm:~# ethtool -s eth0 speed 10 duplex half
root@am335x-evm:~# ./mdio-test g eth0 0
0x0000
root@am335x-evm:~# ethtool -s eth0 speed 10 duplex full
root@am335x-evm:~# ./mdio-test g eth0 0
0x0100
root@am335x-evm:~# ethtool eth0
Settings for eth0:
         Supported ports: [ TP MII FIBRE ]
         Supported link modes:   10baseT/Half 10baseT/Full
                                 100baseT/Half 100baseT/Full
         Supported pause frame use: Symmetric Receive-only
         Supports auto-negotiation: No
         Supported FEC modes: Not reported
         Advertised link modes:  10baseT/Full

Dan


