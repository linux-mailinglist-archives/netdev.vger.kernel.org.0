Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id DB3562C4622
	for <lists+netdev@lfdr.de>; Wed, 25 Nov 2020 17:59:11 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1732234AbgKYQ5o (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 25 Nov 2020 11:57:44 -0500
Received: from szxga03-in.huawei.com ([45.249.212.189]:2381 "EHLO
        szxga03-in.huawei.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1730608AbgKYQ5o (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 25 Nov 2020 11:57:44 -0500
Received: from dggeme760-chm.china.huawei.com (unknown [172.30.72.56])
        by szxga03-in.huawei.com (SkyGuard) with ESMTP id 4Ch6WC6T31z4xMb;
        Thu, 26 Nov 2020 00:57:11 +0800 (CST)
Received: from [127.0.0.1] (10.57.36.170) by dggeme760-chm.china.huawei.com
 (10.3.19.106) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_128_CBC_SHA256_P256) id 15.1.1913.5; Thu, 26
 Nov 2020 00:57:38 +0800
Subject: Re: [PATCH v3 net-next] net: phy: realtek: read actual speed on
 rtl8211f to detect downshift
From:   Yonglong Liu <liuyonglong@huawei.com>
To:     Antonio Borneo <antonio.borneo@st.com>,
        Andrew Lunn <andrew@lunn.ch>,
        Heiner Kallweit <hkallweit1@gmail.com>,
        Russell King <linux@armlinux.org.uk>,
        "David S. Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>, <netdev@vger.kernel.org>,
        Willy Liu <willy.liu@realtek.com>
CC:     <linux-kernel@vger.kernel.org>,
        Salil Mehta <salil.mehta@huawei.com>, <linuxarm@huawei.com>,
        <linux-stm32@st-md-mailman.stormreply.com>
References: <20201124143848.874894-1-antonio.borneo@st.com>
 <20201124230756.887925-1-antonio.borneo@st.com>
 <d62710c3-7813-7506-f209-fcfa65931778@huawei.com>
Message-ID: <f24476cc-39f0-ea5f-d6af-faad481e3235@huawei.com>
Date:   Thu, 26 Nov 2020 00:57:37 +0800
User-Agent: Mozilla/5.0 (Windows NT 6.1; Win64; x64; rv:78.0) Gecko/20100101
 Thunderbird/78.0.1
MIME-Version: 1.0
In-Reply-To: <d62710c3-7813-7506-f209-fcfa65931778@huawei.com>
Content-Type: text/plain; charset="utf-8"; format=flowed
Content-Transfer-Encoding: 8bit
Content-Language: en-US
X-Originating-IP: [10.57.36.170]
X-ClientProxiedBy: dggeme720-chm.china.huawei.com (10.1.199.116) To
 dggeme760-chm.china.huawei.com (10.3.19.106)
X-CFilter-Loop: Reflected
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Hi, Antonio:

     Could you help to provide a downshift warning message when this 
happen?

     It's a little strange that the adv and the lpa support 1000M, but 
finally the link speed is 100M.

Settings for eth5:
         Supported ports: [ TP ]
         Supported link modes:   10baseT/Half 10baseT/Full
                                 100baseT/Half 100baseT/Full
                                 1000baseT/Full
         Supported pause frame use: Symmetric Receive-only
         Supports auto-negotiation: Yes
         Supported FEC modes: Not reported
         *Advertised link modes:  10baseT/Half 10baseT/Full
                                 100baseT/Half 100baseT/Full
                                 1000baseT/Full*
         Advertised pause frame use: Symmetric
         Advertised auto-negotiation: Yes
         Advertised FEC modes: Not reported
         *Link partner advertised link modes:  10baseT/Half 10baseT/Full
                                              100baseT/Half 100baseT/Full
                                              1000baseT/Full*
         Link partner advertised pause frame use: Symmetric
         Link partner advertised auto-negotiation: Yes
         Link partner advertised FEC modes: Not reported
         *Speed: 100Mb/s*
         Duplex: Full
         Port: MII
         PHYAD: 3
         Transceiver: internal
         Auto-negotiation: on
         Current message level: 0x00000036 (54)
                                probe link ifdown ifup
         Link detected: yes


     

On 2020/11/25 23:03, Yonglong Liu wrote:
> Tested-by: Yonglong Liu <liuyonglong@huawei.com>
>
> On 2020/11/25 7:07, Antonio Borneo wrote:
>> The rtl8211f supports downshift and before commit 5502b218e001
>> ("net: phy: use phy_resolve_aneg_linkmode in genphy_read_status")
>> the read-back of register MII_CTRL1000 was used to detect the
>> negotiated link speed.
>> The code added in commit d445dff2df60 ("net: phy: realtek: read
>> actual speed to detect downshift") is working fine also for this
>> phy and it's trivial re-using it to restore the downshift
>> detection on rtl8211f.
>>
>> Add the phy specific read_status() pointing to the existing
>> function rtlgen_read_status().
>>
>> Signed-off-by: Antonio Borneo <antonio.borneo@st.com>
>> Link: 
>> https://lore.kernel.org/r/478f871a-583d-01f1-9cc5-2eea56d8c2a7@huawei.com
>> ---
>> To: Andrew Lunn <andrew@lunn.ch>
>> To: Heiner Kallweit <hkallweit1@gmail.com>
>> To: Russell King <linux@armlinux.org.uk>
>> To: "David S. Miller" <davem@davemloft.net>
>> To: Jakub Kicinski <kuba@kernel.org>
>> To: netdev@vger.kernel.org
>> To: Yonglong Liu <liuyonglong@huawei.com>
>> To: Willy Liu <willy.liu@realtek.com>
>> Cc: linuxarm@huawei.com
>> Cc: Salil Mehta <salil.mehta@huawei.com>
>> Cc: linux-stm32@st-md-mailman.stormreply.com
>> Cc: linux-kernel@vger.kernel.org
>> In-Reply-To: <20201124143848.874894-1-antonio.borneo@st.com>
>>
>> V1 => V2
>>     move from a generic implementation affecting every phy
>>     to a rtl8211f specific implementation
>> V2 => V3
>>     rebase on netdev-next, resolving minor conflict after
>>     merge of 8b43357fff61
>> ---
>>   drivers/net/phy/realtek.c | 1 +
>>   1 file changed, 1 insertion(+)
>>
>> diff --git a/drivers/net/phy/realtek.c b/drivers/net/phy/realtek.c
>> index f71eda945c6a..99ecd6c4c15a 100644
>> --- a/drivers/net/phy/realtek.c
>> +++ b/drivers/net/phy/realtek.c
>> @@ -729,6 +729,7 @@ static struct phy_driver realtek_drvs[] = {
>>           PHY_ID_MATCH_EXACT(0x001cc916),
>>           .name        = "RTL8211F Gigabit Ethernet",
>>           .config_init    = &rtl8211f_config_init,
>> +        .read_status    = rtlgen_read_status,
>>           .config_intr    = &rtl8211f_config_intr,
>>           .handle_interrupt = rtl8211f_handle_interrupt,
>>           .suspend    = genphy_suspend,
>>
>> base-commit: 1d155dfdf50efc2b0793bce93c06d1a5b23d0877
>
> _______________________________________________
> Linuxarm mailing list
> Linuxarm@huawei.com
> http://hulk.huawei.com/mailman/listinfo/linuxarm
>
> .

