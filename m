Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id AFF99192EE0
	for <lists+netdev@lfdr.de>; Wed, 25 Mar 2020 18:05:41 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727236AbgCYRFk (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 25 Mar 2020 13:05:40 -0400
Received: from mail-out.m-online.net ([212.18.0.10]:56185 "EHLO
        mail-out.m-online.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726102AbgCYRFj (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 25 Mar 2020 13:05:39 -0400
Received: from frontend01.mail.m-online.net (unknown [192.168.8.182])
        by mail-out.m-online.net (Postfix) with ESMTP id 48nZHz3wP7z1rsNM;
        Wed, 25 Mar 2020 18:05:32 +0100 (CET)
Received: from localhost (dynscan1.mnet-online.de [192.168.6.70])
        by mail.m-online.net (Postfix) with ESMTP id 48nZHw3VCQz1qqkZ;
        Wed, 25 Mar 2020 18:05:32 +0100 (CET)
X-Virus-Scanned: amavisd-new at mnet-online.de
Received: from mail.mnet-online.de ([192.168.8.182])
        by localhost (dynscan1.mail.m-online.net [192.168.6.70]) (amavisd-new, port 10024)
        with ESMTP id R1kfJgVNcq0d; Wed, 25 Mar 2020 18:05:31 +0100 (CET)
X-Auth-Info: p/LllI0q01VIYc4Rzh/R/oooi3TIpHlcOj51krFAy30=
Received: from [IPv6:::1] (unknown [195.140.253.167])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.mnet-online.de (Postfix) with ESMTPSA;
        Wed, 25 Mar 2020 18:05:31 +0100 (CET)
Subject: Re: [PATCH V2 08/14] net: ks8851: Use 16-bit writes to program MAC
 address
To:     Michal Kubecek <mkubecek@suse.cz>
Cc:     netdev@vger.kernel.org, "David S . Miller" <davem@davemloft.net>,
        Lukas Wunner <lukas@wunner.de>, Petr Stetiar <ynezz@true.cz>,
        YueHaibing <yuehaibing@huawei.com>
References: <20200325150543.78569-1-marex@denx.de>
 <20200325150543.78569-9-marex@denx.de>
 <20200325165640.GA31519@unicorn.suse.cz>
From:   Marek Vasut <marex@denx.de>
Message-ID: <f9f82695-23aa-9835-37f5-7b6ac4d4b387@denx.de>
Date:   Wed, 25 Mar 2020 18:05:30 +0100
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:68.0) Gecko/20100101
 Thunderbird/68.5.0
MIME-Version: 1.0
In-Reply-To: <20200325165640.GA31519@unicorn.suse.cz>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On 3/25/20 5:56 PM, Michal Kubecek wrote:
> On Wed, Mar 25, 2020 at 04:05:37PM +0100, Marek Vasut wrote:
>> On the SPI variant of KS8851, the MAC address can be programmed with
>> either 8/16/32-bit writes. To make it easier to support the 16-bit
>> parallel option of KS8851 too, switch both the MAC address programming
>> and readout to 16-bit operations.
>>
>> Remove ks8851_wrreg8() as it is not used anywhere anymore.
>>
>> There should be no functional change.
>>
>> Signed-off-by: Marek Vasut <marex@denx.de>
>> Cc: David S. Miller <davem@davemloft.net>
>> Cc: Lukas Wunner <lukas@wunner.de>
>> Cc: Petr Stetiar <ynezz@true.cz>
>> Cc: YueHaibing <yuehaibing@huawei.com>
>> ---
>> V2: Get rid of the KS_MAR(i + 1) by adjusting KS_MAR(x) macro
>> ---
> [...]
>> @@ -358,8 +329,12 @@ static int ks8851_write_mac_addr(struct net_device *dev)
>>  	 * the first write to the MAC address does not take effect.
>>  	 */
>>  	ks8851_set_powermode(ks, PMECR_PM_NORMAL);
>> -	for (i = 0; i < ETH_ALEN; i++)
>> -		ks8851_wrreg8(ks, KS_MAR(i), dev->dev_addr[i]);
>> +
>> +	for (i = 0; i < ETH_ALEN; i += 2) {
>> +		val = (dev->dev_addr[i] << 8) | dev->dev_addr[i + 1];
>> +		ks8851_wrreg16(ks, KS_MAR(i), val);
>> +	}
>> +
>>  	if (!netif_running(dev))
>>  		ks8851_set_powermode(ks, PMECR_PM_SOFTDOWN);
>>  
>> @@ -377,12 +352,16 @@ static int ks8851_write_mac_addr(struct net_device *dev)
>>  static void ks8851_read_mac_addr(struct net_device *dev)
>>  {
>>  	struct ks8851_net *ks = netdev_priv(dev);
>> +	u16 reg;
>>  	int i;
>>  
>>  	mutex_lock(&ks->lock);
>>  
>> -	for (i = 0; i < ETH_ALEN; i++)
>> -		dev->dev_addr[i] = ks8851_rdreg8(ks, KS_MAR(i));
>> +	for (i = 0; i < ETH_ALEN; i += 2) {
>> +		reg = ks8851_rdreg16(ks, KS_MAR(i));
>> +		dev->dev_addr[i] = reg & 0xff;
>> +		dev->dev_addr[i + 1] = reg >> 8;
>> +	}
>>  
>>  	mutex_unlock(&ks->lock);
>>  }
> 
> It seems my question from v1 went unnoticed and the inconsistency still
> seems to be there so let me ask again: when writing, you put addr[i]
> into upper part of the 16-bit value and addr[i+1] into lower but when 
> reading, you do the opposite. Is it correct?

I believe so, and it works at least on the hardware I have here.
I need to wait for Lukas to verify that on KS8851 SPI edition tomorrow
(that's also why I sent out the V2, so he can test it out)
