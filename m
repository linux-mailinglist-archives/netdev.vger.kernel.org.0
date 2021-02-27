Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 61996326B07
	for <lists+netdev@lfdr.de>; Sat, 27 Feb 2021 02:29:26 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230090AbhB0B2p (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 26 Feb 2021 20:28:45 -0500
Received: from szxga03-in.huawei.com ([45.249.212.189]:2910 "EHLO
        szxga03-in.huawei.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230063AbhB0B2n (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 26 Feb 2021 20:28:43 -0500
Received: from dggeme753-chm.china.huawei.com (unknown [172.30.72.55])
        by szxga03-in.huawei.com (SkyGuard) with ESMTP id 4DnTPC178Gz5W4x;
        Sat, 27 Feb 2021 09:25:51 +0800 (CST)
Received: from [127.0.0.1] (10.69.26.252) by dggeme753-chm.china.huawei.com
 (10.3.19.99) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_128_CBC_SHA256_P256) id 15.1.2106.2; Sat, 27
 Feb 2021 09:27:54 +0800
Subject: Re: [PATCH net] net: phy: fix save wrong speed and duplex problem if
 autoneg is on
To:     Andrew Lunn <andrew@lunn.ch>
CC:     <f.fainelli@gmail.com>, <hkallweit1@gmail.com>,
        <davem@davemloft.net>, <kuba@kernel.org>, <netdev@vger.kernel.org>,
        <linux-kernel@vger.kernel.org>,
        Guangbin Huang <huangguangbin2@huawei.com>
References: <1614325482-25208-1-git-send-email-tanhuazhong@huawei.com>
 <YDmYIb0O5DZkL+X3@lunn.ch>
From:   Huazhong Tan <tanhuazhong@huawei.com>
Message-ID: <d323d07d-c189-b3eb-7942-9cadbd318f11@huawei.com>
Date:   Sat, 27 Feb 2021 09:27:54 +0800
User-Agent: Mozilla/5.0 (Windows NT 10.0; Win64; x64; rv:78.0) Gecko/20100101
 Thunderbird/78.5.1
MIME-Version: 1.0
In-Reply-To: <YDmYIb0O5DZkL+X3@lunn.ch>
Content-Type: text/plain; charset="utf-8"; format=flowed
Content-Transfer-Encoding: 7bit
Content-Language: en-US
X-Originating-IP: [10.69.26.252]
X-ClientProxiedBy: dggeme704-chm.china.huawei.com (10.1.199.100) To
 dggeme753-chm.china.huawei.com (10.3.19.99)
X-CFilter-Loop: Reflected
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org


On 2021/2/27 8:53, Andrew Lunn wrote:
> On Fri, Feb 26, 2021 at 03:44:42PM +0800, Huazhong Tan wrote:
>> From: Guangbin Huang <huangguangbin2@huawei.com>
>>
>> If phy uses generic driver and autoneg is on, enter command
>> "ethtool -s eth0 speed 50" will not change phy speed actually, but
>> command "ethtool eth0" shows speed is 50Mb/s because phydev->speed
>> has been set to 50 and no update later.
>>
>> And duplex setting has same problem too.
>>
>> However, if autoneg is on, phy only changes speed and duplex according to
>> phydev->advertising, but not phydev->speed and phydev->duplex. So in this
>> case, phydev->speed and phydev->duplex don't need to be set in function
>> phy_ethtool_ksettings_set() if autoneg is on.
>>
>> Signed-off-by: Guangbin Huang <huangguangbin2@huawei.com>
>> Signed-off-by: Huazhong Tan <tanhuazhong@huawei.com>
> I'm not sure, but i think this happens after
>
> commit 51e2a3846eab18711f4eb59cd0a4c33054e2980a
> Author: Trent Piepho <tpiepho@freescale.com>
> Date:   Wed Sep 24 10:55:46 2008 +0000
>
>      PHY: Avoid unnecessary aneg restarts
>      
>      The PHY's aneg is configured and restarted whenever the link is brought up,
>      e.g. when DHCP is started after the kernel has booted.  This can take the
>      link down for several seconds while auto-negotiation is redone.
>      
>      If the advertised features haven't changed, then it shouldn't be necessary
>      to bring down the link and start auto-negotiation over again.
>      
>      genphy_config_advert() is enhanced to return 0 when the advertised features
>      haven't been changed and >0 when they have been.
>      
>      genphy_config_aneg() then uses this information to not call
>      genphy_restart_aneg() if there has been no change.
>
> Before then, i think autoneg was unconditionally restarted, and so the
> speed would get overwritten when autoneg completed. After this patch,
> since autoneg is not being changed when only speed is set, autoneg is
> not triggered.
>
> 	Andrew


Thanks.


> .

