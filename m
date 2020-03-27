Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 338F2195D88
	for <lists+netdev@lfdr.de>; Fri, 27 Mar 2020 19:22:31 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727505AbgC0SWY (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 27 Mar 2020 14:22:24 -0400
Received: from mail-out.m-online.net ([212.18.0.10]:46506 "EHLO
        mail-out.m-online.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726738AbgC0SWX (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 27 Mar 2020 14:22:23 -0400
Received: from frontend01.mail.m-online.net (unknown [192.168.8.182])
        by mail-out.m-online.net (Postfix) with ESMTP id 48pqvc3x1rz1rrKs;
        Fri, 27 Mar 2020 19:22:13 +0100 (CET)
Received: from localhost (dynscan1.mnet-online.de [192.168.6.70])
        by mail.m-online.net (Postfix) with ESMTP id 48pqvT3L67z1qs9p;
        Fri, 27 Mar 2020 19:22:13 +0100 (CET)
X-Virus-Scanned: amavisd-new at mnet-online.de
Received: from mail.mnet-online.de ([192.168.8.182])
        by localhost (dynscan1.mail.m-online.net [192.168.6.70]) (amavisd-new, port 10024)
        with ESMTP id 11cQMOmB3E_U; Fri, 27 Mar 2020 19:22:12 +0100 (CET)
X-Auth-Info: 6sSXXMUmM3SdPviHXSOgqqJubWtT5w3Gb/UuiaSF100=
Received: from [127.0.0.1] (unknown [195.140.253.167])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.mnet-online.de (Postfix) with ESMTPSA;
        Fri, 27 Mar 2020 19:22:12 +0100 (CET)
Subject: Re: [PATCH V2 08/14] net: ks8851: Use 16-bit writes to program MAC
 address
To:     Michal Kubecek <mkubecek@suse.cz>
Cc:     netdev@vger.kernel.org, "David S . Miller" <davem@davemloft.net>,
        Lukas Wunner <lukas@wunner.de>, Petr Stetiar <ynezz@true.cz>,
        YueHaibing <yuehaibing@huawei.com>
References: <20200325150543.78569-1-marex@denx.de>
 <20200325150543.78569-9-marex@denx.de>
 <20200325165640.GA31519@unicorn.suse.cz>
 <f9f82695-23aa-9835-37f5-7b6ac4d4b387@denx.de>
 <20200325173008.GB31519@unicorn.suse.cz>
From:   Marek Vasut <marex@denx.de>
Message-ID: <86605e3e-cbed-557c-d618-50b318e8c473@denx.de>
Date:   Fri, 27 Mar 2020 19:16:26 +0100
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:68.0) Gecko/20100101
 Thunderbird/68.5.0
MIME-Version: 1.0
In-Reply-To: <20200325173008.GB31519@unicorn.suse.cz>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On 3/25/20 6:30 PM, Michal Kubecek wrote:
> On Wed, Mar 25, 2020 at 06:05:30PM +0100, Marek Vasut wrote:
>> On 3/25/20 5:56 PM, Michal Kubecek wrote:
>>> On Wed, Mar 25, 2020 at 04:05:37PM +0100, Marek Vasut wrote:
>>>> On the SPI variant of KS8851, the MAC address can be programmed with
>>>> either 8/16/32-bit writes. To make it easier to support the 16-bit
>>>> parallel option of KS8851 too, switch both the MAC address programming
>>>> and readout to 16-bit operations.
>>>>
>>>> Remove ks8851_wrreg8() as it is not used anywhere anymore.
>>>>
>>>> There should be no functional change.
>>>>
>>>> Signed-off-by: Marek Vasut <marex@denx.de>
>>>> Cc: David S. Miller <davem@davemloft.net>
>>>> Cc: Lukas Wunner <lukas@wunner.de>
>>>> Cc: Petr Stetiar <ynezz@true.cz>
>>>> Cc: YueHaibing <yuehaibing@huawei.com>
>>>> ---
>>>> V2: Get rid of the KS_MAR(i + 1) by adjusting KS_MAR(x) macro
>>>> ---
>>> [...]
>>>> @@ -358,8 +329,12 @@ static int ks8851_write_mac_addr(struct net_device *dev)
>>>>  	 * the first write to the MAC address does not take effect.
>>>>  	 */
>>>>  	ks8851_set_powermode(ks, PMECR_PM_NORMAL);
>>>> -	for (i = 0; i < ETH_ALEN; i++)
>>>> -		ks8851_wrreg8(ks, KS_MAR(i), dev->dev_addr[i]);
>>>> +
>>>> +	for (i = 0; i < ETH_ALEN; i += 2) {
>>>> +		val = (dev->dev_addr[i] << 8) | dev->dev_addr[i + 1];
>>>> +		ks8851_wrreg16(ks, KS_MAR(i), val);
>>>> +	}
>>>> +
>>>>  	if (!netif_running(dev))
>>>>  		ks8851_set_powermode(ks, PMECR_PM_SOFTDOWN);
>>>>  
>>>> @@ -377,12 +352,16 @@ static int ks8851_write_mac_addr(struct net_device *dev)
>>>>  static void ks8851_read_mac_addr(struct net_device *dev)
>>>>  {
>>>>  	struct ks8851_net *ks = netdev_priv(dev);
>>>> +	u16 reg;
>>>>  	int i;
>>>>  
>>>>  	mutex_lock(&ks->lock);
>>>>  
>>>> -	for (i = 0; i < ETH_ALEN; i++)
>>>> -		dev->dev_addr[i] = ks8851_rdreg8(ks, KS_MAR(i));
>>>> +	for (i = 0; i < ETH_ALEN; i += 2) {
>>>> +		reg = ks8851_rdreg16(ks, KS_MAR(i));
>>>> +		dev->dev_addr[i] = reg & 0xff;
>>>> +		dev->dev_addr[i + 1] = reg >> 8;
>>>> +	}
>>>>  
>>>>  	mutex_unlock(&ks->lock);
>>>>  }
>>>
>>> It seems my question from v1 went unnoticed and the inconsistency still
>>> seems to be there so let me ask again: when writing, you put addr[i]
>>> into upper part of the 16-bit value and addr[i+1] into lower but when 
>>> reading, you do the opposite. Is it correct?
>>
>> I believe so, and it works at least on the hardware I have here.
>> I need to wait for Lukas to verify that on KS8851 SPI edition tomorrow
>> (that's also why I sent out the V2, so he can test it out)
> 
> That's a bit surprising (and counterintuitive) as it means that if you do
> 
>   ks8851_wrreg16(ks, a, val);
>   val = ks8851_rdreg16(ks, a);
> 
> you read a different value than you wrote. But I know nothing about the
> hardware (I only noticed the strange inconsistency) so I can't say where
> does it come from.

So this really does need fixing.
