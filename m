Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id A696767FC3A
	for <lists+netdev@lfdr.de>; Sun, 29 Jan 2023 02:55:12 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230008AbjA2BzK (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sat, 28 Jan 2023 20:55:10 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:52010 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231789AbjA2BzI (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sat, 28 Jan 2023 20:55:08 -0500
Received: from out28-53.mail.aliyun.com (out28-53.mail.aliyun.com [115.124.28.53])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 6C0C120D00;
        Sat, 28 Jan 2023 17:55:06 -0800 (PST)
X-Alimail-AntiSpam: AC=CONTINUE;BC=0.1337155|-1;CH=green;DM=|CONTINUE|false|;DS=CONTINUE|ham_regular_dialog|0.00629158-0.000370313-0.993338;FP=0|0|0|0|0|-1|-1|-1;HT=ay29a033018047188;MF=frank.sae@motor-comm.com;NM=1;PH=DS;RN=13;RT=13;SR=0;TI=SMTPD_---.R3NiPf0_1674957301;
Received: from 10.0.2.15(mailfrom:Frank.Sae@motor-comm.com fp:SMTPD_---.R3NiPf0_1674957301)
          by smtp.aliyun-inc.com;
          Sun, 29 Jan 2023 09:55:03 +0800
Message-ID: <3fc60e9f-b688-8aaa-a112-ca100815a69d@motor-comm.com>
Date:   Sun, 29 Jan 2023 09:56:09 +0800
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:102.0) Gecko/20100101
 Thunderbird/102.4.2
Subject: Re: [PATCH net-next v2 5/5] net: phy: Add driver for Motorcomm yt8531
 gigabit ethernet phy
To:     Andrew Lunn <andrew@lunn.ch>
Cc:     Peter Geis <pgwipeout@gmail.com>,
        Heiner Kallweit <hkallweit1@gmail.com>,
        Russell King <linux@armlinux.org.uk>,
        "David S . Miller" <davem@davemloft.net>,
        Eric Dumazet <edumazet@google.com>,
        Jakub Kicinski <kuba@kernel.org>,
        Paolo Abeni <pabeni@redhat.com>, xiaogang.fan@motor-comm.com,
        fei.zhang@motor-comm.com, hua.sun@motor-comm.com,
        netdev@vger.kernel.org, linux-kernel@vger.kernel.org
References: <20230128031314.19752-1-Frank.Sae@motor-comm.com>
 <20230128031314.19752-6-Frank.Sae@motor-comm.com> <Y9VCfkzjHBDjXmet@lunn.ch>
Content-Language: en-US
From:   "Frank.Sae" <Frank.Sae@motor-comm.com>
In-Reply-To: <Y9VCfkzjHBDjXmet@lunn.ch>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
X-Spam-Status: No, score=-3.0 required=5.0 tests=BAYES_00,NICE_REPLY_A,
        RCVD_IN_DNSWL_NONE,RCVD_IN_MSPIKE_H2,SPF_HELO_NONE,SPF_PASS,
        UNPARSEABLE_RELAY autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Hi Andrew,

On 2023/1/28 23:42, Andrew Lunn wrote:
> On Sat, Jan 28, 2023 at 11:13:14AM +0800, Frank Sae wrote:
>>  Add a driver for the motorcomm yt8531 gigabit ethernet phy. We have
>>  verified the driver on AM335x platform with yt8531 board. On the
>>  board, yt8531 gigabit ethernet phy works in utp mode, RGMII
>>  interface, supports 1000M/100M/10M speeds, and wol(magic package).
>>
>> Signed-off-by: Frank Sae <Frank.Sae@motor-comm.com>
>> ---
>>  drivers/net/phy/Kconfig     |   2 +-
>>  drivers/net/phy/motorcomm.c | 204 +++++++++++++++++++++++++++++++++++-
>>  2 files changed, 203 insertions(+), 3 deletions(-)
>>
>> diff --git a/drivers/net/phy/Kconfig b/drivers/net/phy/Kconfig
>> index f5df2edc94a5..dc2f7d0b0cd8 100644
>> --- a/drivers/net/phy/Kconfig
>> +++ b/drivers/net/phy/Kconfig
>> @@ -257,7 +257,7 @@ config MOTORCOMM_PHY
>>  	tristate "Motorcomm PHYs"
>>  	help
>>  	  Enables support for Motorcomm network PHYs.
>> -	  Currently supports the YT8511, YT8521, YT8531S Gigabit Ethernet PHYs.
>> +	  Currently supports the YT8511, YT8521, YT8531, YT8531S Gigabit Ethernet PHYs.
> 
> This is O.K. for now, but when you add the next PHY, please do this in
> some other way, because it does not scale. Maybe just say YT85xx?
> 
>>  
>>  config NATIONAL_PHY
>>  	tristate "National Semiconductor PHYs"
>> diff --git a/drivers/net/phy/motorcomm.c b/drivers/net/phy/motorcomm.c
>> index 9559fc52814f..f1fc912738e0 100644
>> --- a/drivers/net/phy/motorcomm.c
>> +++ b/drivers/net/phy/motorcomm.c
>> @@ -1,6 +1,6 @@
>>  // SPDX-License-Identifier: GPL-2.0+
>>  /*
>> - * Motorcomm 8511/8521/8531S PHY driver.
>> + * Motorcomm 8511/8521/8531/8531S PHY driver.
>>   *
>>   * Author: Peter Geis <pgwipeout@gmail.com>
>>   * Author: Frank <Frank.Sae@motor-comm.com>
>> @@ -14,6 +14,7 @@
>>  
>>  #define PHY_ID_YT8511		0x0000010a
>>  #define PHY_ID_YT8521		0x0000011A
>> +#define PHY_ID_YT8531		0x4f51e91b
>>  #define PHY_ID_YT8531S		0x4F51E91A
>>  
>>  /* YT8521/YT8531S Register Overview
>> @@ -517,6 +518,68 @@ static int ytphy_set_wol(struct phy_device *phydev, struct ethtool_wolinfo *wol)
>>  	return phy_restore_page(phydev, old_page, ret);
>>  }
>>  
>> +static int yt8531_set_wol(struct phy_device *phydev,
>> +			  struct ethtool_wolinfo *wol)
>> +{
>> +	struct net_device *p_attached_dev;
>> +	const u16 mac_addr_reg[] = {
>> +		YTPHY_WOL_MACADDR2_REG,
>> +		YTPHY_WOL_MACADDR1_REG,
>> +		YTPHY_WOL_MACADDR0_REG,
>> +	};
>> +	const u8 *mac_addr;
>> +	u16 mask, val;
>> +	int ret;
>> +	u8 i;
>> +
>> +	if (wol->wolopts & WAKE_MAGIC) {
>> +		p_attached_dev = phydev->attached_dev;
>> +		if (!p_attached_dev)
>> +			return -ENODEV;
>> +
>> +		mac_addr = (const u8 *)p_attached_dev->dev_addr;
>> +		if (!is_valid_ether_addr(mac_addr))
>> +			return -EINVAL;
> 
> Have you ever seen that happen? It suggests the MAC driver has a bug,
> not validating its MAC address.

I have never seen that happen.
Do you mean that I should change the code from

+	if (wol->wolopts & WAKE_MAGIC) {
+		p_attached_dev = phydev->attached_dev;
+		if (!p_attached_dev)
+			return -ENODEV;
+
+		mac_addr = (const u8 *)p_attached_dev->dev_addr;
+		if (!is_valid_ether_addr(mac_addr))
+			return -EINVAL;

to

+	if (wol->wolopts & WAKE_MAGIC) {
+		mac_addr = phydev->attached_dev->dev_addr;

?

> Also, does the PHY actually care? Will the firmware crash if given a
> bad MAC address?
> 

The PHY actually is not care this. The firmware is not crash if given a
bad MAC address.

>     Andrew
