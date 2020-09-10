Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id D1401264B5C
	for <lists+netdev@lfdr.de>; Thu, 10 Sep 2020 19:35:29 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726991AbgIJRe4 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 10 Sep 2020 13:34:56 -0400
Received: from lelv0143.ext.ti.com ([198.47.23.248]:60122 "EHLO
        lelv0143.ext.ti.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726899AbgIJReU (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 10 Sep 2020 13:34:20 -0400
Received: from fllv0034.itg.ti.com ([10.64.40.246])
        by lelv0143.ext.ti.com (8.15.2/8.15.2) with ESMTP id 08AHYAOU012934;
        Thu, 10 Sep 2020 12:34:10 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=ti.com;
        s=ti-com-17Q1; t=1599759250;
        bh=w/1pWFuQbg23uoRnZS+pLtiGKqGvx6oYjiN6Hcvqabo=;
        h=Subject:To:CC:References:From:Date:In-Reply-To;
        b=urHuQFYd2CTFPgRLbOo+EWXVbJR57kzBvFJ3f7s3mvG4mKsgoeg2rH9Im5Se/t2UT
         LGKy5aCD1MDMwUQ6Dlv1RqKrvjsGWOKbNWrNG19F8TtYGeRURxh4SNCS+gNZ4xSRTH
         gdXNPi6IqFZ3aN01FsrnJDG4wlc7WRflzCS7vH+w=
Received: from DFLE103.ent.ti.com (dfle103.ent.ti.com [10.64.6.24])
        by fllv0034.itg.ti.com (8.15.2/8.15.2) with ESMTPS id 08AHY9r3059716
        (version=TLSv1.2 cipher=AES256-GCM-SHA384 bits=256 verify=FAIL);
        Thu, 10 Sep 2020 12:34:09 -0500
Received: from DFLE115.ent.ti.com (10.64.6.36) by DFLE103.ent.ti.com
 (10.64.6.24) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_128_CBC_SHA256_P256) id 15.1.1979.3; Thu, 10
 Sep 2020 12:34:09 -0500
Received: from fllv0039.itg.ti.com (10.64.41.19) by DFLE115.ent.ti.com
 (10.64.6.36) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_128_CBC_SHA256_P256) id 15.1.1979.3 via
 Frontend Transport; Thu, 10 Sep 2020 12:34:09 -0500
Received: from [10.250.38.37] (ileax41-snat.itg.ti.com [10.172.224.153])
        by fllv0039.itg.ti.com (8.15.2/8.15.2) with ESMTP id 08AHY9Po113734;
        Thu, 10 Sep 2020 12:34:09 -0500
Subject: Re: [PATCH net-next v3 2/3] net: phy: dp83869: support Wake on LAN
To:     Jakub Kicinski <kuba@kernel.org>
CC:     <davem@davemloft.net>, <andrew@lunn.ch>, <f.fainelli@gmail.com>,
        <hkallweit1@gmail.com>, <netdev@vger.kernel.org>,
        <linux-kernel@vger.kernel.org>
References: <20200903114259.14013-1-dmurphy@ti.com>
 <20200903114259.14013-3-dmurphy@ti.com>
 <20200905113428.5bd7dc95@kicinski-fedora-pc1c0hjn.dhcp.thefacebook.com>
From:   Dan Murphy <dmurphy@ti.com>
Message-ID: <5051f1e2-4f8e-a021-df6c-d4066938422f@ti.com>
Date:   Thu, 10 Sep 2020 12:34:09 -0500
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:68.0) Gecko/20100101
 Thunderbird/68.10.0
MIME-Version: 1.0
In-Reply-To: <20200905113428.5bd7dc95@kicinski-fedora-pc1c0hjn.dhcp.thefacebook.com>
Content-Type: text/plain; charset="utf-8"; format=flowed
Content-Transfer-Encoding: 8bit
Content-Language: en-US
X-EXCLAIMER-MD-CONFIG: e1e8a2fd-e40a-4ac6-ac9b-f7e9cc9ee180
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Jakub

Thanks for the review

On 9/5/20 1:34 PM, Jakub Kicinski wrote:
> On Thu, 3 Sep 2020 06:42:58 -0500 Dan Murphy wrote:
>> This adds WoL support on TI DP83869 for magic, magic secure, unicast and
>> broadcast.
>>
>> Signed-off-by: Dan Murphy <dmurphy@ti.com>
>> ---
>>   drivers/net/phy/dp83869.c | 128 ++++++++++++++++++++++++++++++++++++++
>>   1 file changed, 128 insertions(+)
>>
>> diff --git a/drivers/net/phy/dp83869.c b/drivers/net/phy/dp83869.c
>> index 48a68474f89c..5045df9515a5 100644
>> --- a/drivers/net/phy/dp83869.c
>> +++ b/drivers/net/phy/dp83869.c
>> @@ -4,6 +4,7 @@
>>    */
>>   
>>   #include <linux/ethtool.h>
>> +#include <linux/etherdevice.h>
>>   #include <linux/kernel.h>
>>   #include <linux/mii.h>
>>   #include <linux/module.h>
>> @@ -27,6 +28,13 @@
>>   #define DP83869_RGMIICTL	0x0032
>>   #define DP83869_STRAP_STS1	0x006e
>>   #define DP83869_RGMIIDCTL	0x0086
>> +#define DP83869_RXFCFG		0x0134
>> +#define DP83869_RXFPMD1		0x0136
>> +#define DP83869_RXFPMD2		0x0137
>> +#define DP83869_RXFPMD3		0x0138
>> +#define DP83869_RXFSOP1		0x0139
>> +#define DP83869_RXFSOP2		0x013A
>> +#define DP83869_RXFSOP3		0x013B
>>   #define DP83869_IO_MUX_CFG	0x0170
>>   #define DP83869_OP_MODE		0x01df
>>   #define DP83869_FX_CTRL		0x0c00
>> @@ -105,6 +113,14 @@
>>   #define DP83869_OP_MODE_MII			BIT(5)
>>   #define DP83869_SGMII_RGMII_BRIDGE		BIT(6)
>>   
>> +/* RXFCFG bits*/
>> +#define DP83869_WOL_MAGIC_EN		BIT(0)
>> +#define DP83869_WOL_PATTERN_EN		BIT(1)
>> +#define DP83869_WOL_BCAST_EN		BIT(2)
>> +#define DP83869_WOL_UCAST_EN		BIT(4)
>> +#define DP83869_WOL_SEC_EN		BIT(5)
>> +#define DP83869_WOL_ENH_MAC		BIT(7)
>> +
>>   enum {
>>   	DP83869_PORT_MIRRORING_KEEP,
>>   	DP83869_PORT_MIRRORING_EN,
>> @@ -156,6 +172,115 @@ static int dp83869_config_intr(struct phy_device *phydev)
>>   	return phy_write(phydev, MII_DP83869_MICR, micr_status);
>>   }
>>   
>> +static int dp83869_set_wol(struct phy_device *phydev,
>> +			   struct ethtool_wolinfo *wol)
>> +{
>> +	struct net_device *ndev = phydev->attached_dev;
>> +	u16 val_rxcfg, val_micr;
>> +	u8 *mac;
>> +
>> +	val_rxcfg = phy_read_mmd(phydev, DP83869_DEVADDR, DP83869_RXFCFG);
>> +	val_micr = phy_read(phydev, MII_DP83869_MICR);
> In the previous patch you checked if phy_read() failed, here you don't.
I will add it back
>
>> +	if (wol->wolopts & (WAKE_MAGIC | WAKE_MAGICSECURE | WAKE_UCAST |
>> +			    WAKE_BCAST)) {
>> +		val_rxcfg |= DP83869_WOL_ENH_MAC;
>> +		val_micr |= MII_DP83869_MICR_WOL_INT_EN;
>> +
>> +		if (wol->wolopts & WAKE_MAGIC) {
>> +			mac = (u8 *)ndev->dev_addr;
>> +
>> +			if (!is_valid_ether_addr(mac))
>> +				return -EINVAL;
>> +
>> +			phy_write_mmd(phydev, DP83869_DEVADDR, DP83869_RXFPMD1,
>> +				      (mac[1] << 8 | mac[0]));
> parenthesis unnecessary
OK
>
>> +			phy_write_mmd(phydev, DP83869_DEVADDR, DP83869_RXFPMD2,
>> +				      (mac[3] << 8 | mac[2]));
>> +			phy_write_mmd(phydev, DP83869_DEVADDR, DP83869_RXFPMD3,
>> +				      (mac[5] << 8 | mac[4]));
> Why only program mac addr for wake_magic, does magic_secure or unicast
> not require it?

Unicast and broadcast are the ways to send the magic packet.

Magic secure is programmed below into the SOP (secure on pass) registers

>
>> +
>> +			val_rxcfg |= DP83869_WOL_MAGIC_EN;
>> +		} else {
>> +			val_rxcfg &= ~DP83869_WOL_MAGIC_EN;
>> +		}
>> +
>> +		if (wol->wolopts & WAKE_MAGICSECURE) {
>> +			phy_write_mmd(phydev, DP83869_DEVADDR, DP83869_RXFSOP1,
>> +				      (wol->sopass[1] << 8) | wol->sopass[0]);
>> +			phy_write_mmd(phydev, DP83869_DEVADDR, DP83869_RXFSOP2,
>> +				      (wol->sopass[3] << 8) | wol->sopass[2]);
>> +			phy_write_mmd(phydev, DP83869_DEVADDR, DP83869_RXFSOP3,
>> +				      (wol->sopass[5] << 8) | wol->sopass[4]);
>> +
>> +			val_rxcfg |= DP83869_WOL_SEC_EN;
>> +		} else {
>> +			val_rxcfg &= ~DP83869_WOL_SEC_EN;
>> +		}
>> +
>> +		if (wol->wolopts & WAKE_UCAST)
>> +			val_rxcfg |= DP83869_WOL_UCAST_EN;
>> +		else
>> +			val_rxcfg &= ~DP83869_WOL_UCAST_EN;
>> +
>> +		if (wol->wolopts & WAKE_BCAST)
>> +			val_rxcfg |= DP83869_WOL_BCAST_EN;
>> +		else
>> +			val_rxcfg &= ~DP83869_WOL_BCAST_EN;
>> +	} else {
>> +		val_rxcfg &= ~DP83869_WOL_ENH_MAC;
>> +		val_micr &= ~MII_DP83869_MICR_WOL_INT_EN;
>> +	}
>> +
>> +	phy_write_mmd(phydev, DP83869_DEVADDR, DP83869_RXFCFG, val_rxcfg);
>> +	phy_write(phydev, MII_DP83869_MICR, val_micr);
>> +
>> +	return 0;
>> +}
>> +
>> +static void dp83869_get_wol(struct phy_device *phydev,
>> +			    struct ethtool_wolinfo *wol)
>> +{
>> +	u16 value, sopass_val;
>> +
>> +	wol->supported = (WAKE_UCAST | WAKE_BCAST | WAKE_MAGIC |
>> +			WAKE_MAGICSECURE);
>> +	wol->wolopts = 0;
>> +
>> +	value = phy_read_mmd(phydev, DP83869_DEVADDR, DP83869_RXFCFG);
>> +
>> +	if (value & DP83869_WOL_UCAST_EN)
>> +		wol->wolopts |= WAKE_UCAST;
>> +
>> +	if (value & DP83869_WOL_BCAST_EN)
>> +		wol->wolopts |= WAKE_BCAST;
>> +
>> +	if (value & DP83869_WOL_MAGIC_EN)
>> +		wol->wolopts |= WAKE_MAGIC;
>> +
>> +	if (value & DP83869_WOL_SEC_EN) {
>> +		sopass_val = phy_read_mmd(phydev, DP83869_DEVADDR,
>> +					  DP83869_RXFSOP1);
>> +		wol->sopass[0] = (sopass_val & 0xff);
>> +		wol->sopass[1] = (sopass_val >> 8);
>> +
>> +		sopass_val = phy_read_mmd(phydev, DP83869_DEVADDR,
>> +					  DP83869_RXFSOP2);
>> +		wol->sopass[2] = (sopass_val & 0xff);
>> +		wol->sopass[3] = (sopass_val >> 8);
>> +
>> +		sopass_val = phy_read_mmd(phydev, DP83869_DEVADDR,
>> +					  DP83869_RXFSOP3);
>> +		wol->sopass[4] = (sopass_val & 0xff);
>> +		wol->sopass[5] = (sopass_val >> 8);
>> +
>> +		wol->wolopts |= WAKE_MAGICSECURE;
>> +	}
>> +
>> +	if (!(value & DP83869_WOL_ENH_MAC))
>> +		wol->wolopts = 0;
> What does ENH stand for?
Enhanced MAC - Enables enhanced RX features. This bit should be set when 
using
wakeup abilities, CRC check or RX 1588 indication
>
> Perhaps it would be cleaner to make a helper like this:
>
> u32 helper(u16 rxfsop1)
> {
> 	u32 wolopts;
>
> 	if (!(value & DP83869_WOL_ENH_MAC))
> 		return 0;
>
> 	if (value & DP83869_WOL_UCAST_EN)
> 		wolopts |= WAKE_UCAST;
> 	if (value & DP83869_WOL_BCAST_EN)
> 		wolopts |= WAKE_BCAST;
> 	if (value & DP83869_WOL_MAGIC_EN)
> 		wolopts |= WAKE_MAGIC;
> 	if (value & DP83869_WOL_SEC_EN)
> 		wolopts |= WAKE_MAGICSECURE;
>
> 	return wolopts;
> }
>
> wol->wolopts = helper(value);
>
> setting the bits and then clearing the value looks strange.
A helper is a bit overkill see below.
>
>> +}
>> +
>>   static int dp83869_config_port_mirroring(struct phy_device *phydev)
>>   {
>>   	struct dp83869_private *dp83869 = phydev->priv;
> Overall this code looks quite similar to dp83867, is there no way to
> factor this out?

Factor what out?  Yes the DP83867 and DP83869 are very similar in 
registers and bitmaps.  They just differ in their feature sets.

The WoL code was copied and pasted to the 869 and I would like to keep 
the two files as similar as I can as it will be easier to fix and find bugs.

