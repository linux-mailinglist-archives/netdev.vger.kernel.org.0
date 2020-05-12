Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 7046B1CF4C1
	for <lists+netdev@lfdr.de>; Tue, 12 May 2020 14:48:41 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729944AbgELMs1 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 12 May 2020 08:48:27 -0400
Received: from szxga01-in.huawei.com ([45.249.212.187]:2133 "EHLO huawei.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1729461AbgELMs0 (ORCPT <rfc822;netdev@vger.kernel.org>);
        Tue, 12 May 2020 08:48:26 -0400
Received: from DGGEMM404-HUB.china.huawei.com (unknown [172.30.72.54])
        by Forcepoint Email with ESMTP id 94D2ED6F91ACD733E9D7;
        Tue, 12 May 2020 20:48:22 +0800 (CST)
Received: from dggeme760-chm.china.huawei.com (10.3.19.106) by
 DGGEMM404-HUB.china.huawei.com (10.3.20.212) with Microsoft SMTP Server (TLS)
 id 14.3.487.0; Tue, 12 May 2020 20:48:21 +0800
Received: from [127.0.0.1] (10.57.37.248) by dggeme760-chm.china.huawei.com
 (10.3.19.106) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_128_CBC_SHA256_P256) id 15.1.1913.5; Tue, 12
 May 2020 20:48:22 +0800
From:   Yonglong Liu <liuyonglong@huawei.com>
Subject: [question] net: phy: rtl8211f: link speed shows 1000Mb/s but actual
 link speed in phy is 100Mb/s
To:     Andrew Lunn <andrew@lunn.ch>,
        Heiner Kallweit <hkallweit1@gmail.com>,
        "David S. Miller" <davem@davemloft.net>
CC:     <netdev@vger.kernel.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        <linuxarm@huawei.com>, Salil Mehta <salil.mehta@huawei.com>
Message-ID: <478f871a-583d-01f1-9cc5-2eea56d8c2a7@huawei.com>
Date:   Tue, 12 May 2020 20:48:21 +0800
User-Agent: Mozilla/5.0 (Windows NT 6.1; WOW64; rv:60.0) Gecko/20100101
 Thunderbird/60.2.1
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Language: en-US
Content-Transfer-Encoding: 7bit
X-Originating-IP: [10.57.37.248]
X-ClientProxiedBy: dggeme712-chm.china.huawei.com (10.1.199.108) To
 dggeme760-chm.china.huawei.com (10.3.19.106)
X-CFilter-Loop: Reflected
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

I use two devices, both support 1000M speed, they are directly connected
with a network cable. Two devices enable autoneg, and then do the following
test repeatedly:
	ifconfig eth5 down
	ifconfig eth5 up
	sleep $((RANDOM%6))
	ifconfig eth5 down
	ifconfig eth5 up
	sleep 10

With low probability, one device A link up with 100Mb/s, the other B link up with
1000Mb/s(the actual link speed read from phy is 100Mb/s), and the network can
not work.

device A:
Settings for eth5:
        Supported ports: [ TP ]
        Supported link modes:   10baseT/Half 10baseT/Full
                                100baseT/Half 100baseT/Full
                                1000baseT/Full
        Supported pause frame use: Symmetric Receive-only
        Supports auto-negotiation: Yes
        Supported FEC modes: Not reported
        Advertised link modes:  10baseT/Half 10baseT/Full
                                100baseT/Half 100baseT/Full
                                1000baseT/Full
        Advertised pause frame use: Symmetric
        Advertised auto-negotiation: Yes
        Advertised FEC modes: Not reported
        Link partner advertised link modes:  10baseT/Half 10baseT/Full
                                             100baseT/Half 100baseT/Full
        Link partner advertised pause frame use: Symmetric
        Link partner advertised auto-negotiation: Yes
        Link partner advertised FEC modes: Not reported
        Speed: 100Mb/s
        Duplex: Full
        Port: MII
        PHYAD: 3
        Transceiver: internal
        Auto-negotiation: on
        Current message level: 0x00000036 (54)
                               probe link ifdown ifup
        Link detected: yes

The regs value read from mdio are:
reg 9 = 0x200
reg a = 0

device B:
Settings for eth5:
        Supported ports: [ TP ]
        Supported link modes:   10baseT/Half 10baseT/Full
                                100baseT/Half 100baseT/Full
                                1000baseT/Full
        Supported pause frame use: Symmetric Receive-only
        Supports auto-negotiation: Yes
        Supported FEC modes: Not reported
        Advertised link modes:  10baseT/Half 10baseT/Full
                                100baseT/Half 100baseT/Full
                                1000baseT/Full
        Advertised pause frame use: Symmetric
        Advertised auto-negotiation: Yes
        Advertised FEC modes: Not reported
        Link partner advertised link modes:  10baseT/Half 10baseT/Full
                                             100baseT/Half 100baseT/Full
                                             1000baseT/Full
        Link partner advertised pause frame use: Symmetric
        Link partner advertised auto-negotiation: Yes
        Link partner advertised FEC modes: Not reported
        Speed: 1000Mb/s
        Duplex: Full
        Port: MII
        PHYAD: 3
        Transceiver: internal
        Auto-negotiation: on
        Current message level: 0x00000036 (54)
                               probe link ifdown ifup
        Link detected: yes

The regs value read from mdio are:
reg 9 = 0
reg a = 0x800

I had talk to the FAE of rtl8211f, they said if negotiation failed with 1000Mb/s,
rtl8211f will change reg 9 to 0, than try to negotiation with 100Mb/s.

The problem happened as:
ifconfig eth5 up -> phy_start -> phy_start_aneg -> phy_modify_changed(MII_CTRL1000)
(this time both A and B, reg 9 = 0x200) -> wait for link up -> (B: reg 9 changed to 0)
-> link up.

I think this is the bug of the rtl8211f itself, any one have an idea to avoid this bug?

When link up, update phydev->advertising before notify the eth driver, is this method
suitable? (phydev->advertising is config from user, if user just set one speed 1000M,
it's hard to )

