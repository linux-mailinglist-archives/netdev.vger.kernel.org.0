Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 122351D3209
	for <lists+netdev@lfdr.de>; Thu, 14 May 2020 16:02:31 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726166AbgENOC2 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 14 May 2020 10:02:28 -0400
Received: from mail-out.m-online.net ([212.18.0.9]:52364 "EHLO
        mail-out.m-online.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726037AbgENOC1 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 14 May 2020 10:02:27 -0400
Received: from frontend01.mail.m-online.net (unknown [192.168.8.182])
        by mail-out.m-online.net (Postfix) with ESMTP id 49NCsY75jVz1qs4B;
        Thu, 14 May 2020 16:02:14 +0200 (CEST)
Received: from localhost (dynscan1.mnet-online.de [192.168.6.70])
        by mail.m-online.net (Postfix) with ESMTP id 49NCsL0KQmz1qspS;
        Thu, 14 May 2020 16:02:14 +0200 (CEST)
X-Virus-Scanned: amavisd-new at mnet-online.de
Received: from mail.mnet-online.de ([192.168.8.182])
        by localhost (dynscan1.mail.m-online.net [192.168.6.70]) (amavisd-new, port 10024)
        with ESMTP id rSFQDmODC4Kp; Thu, 14 May 2020 16:02:12 +0200 (CEST)
X-Auth-Info: SyB8dx9dZL2+07cn8sMw41PxtEnVb2A5FB4CPg0qRnc=
Received: from [IPv6:::1] (unknown [195.140.253.167])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.mnet-online.de (Postfix) with ESMTPSA;
        Thu, 14 May 2020 16:02:12 +0200 (CEST)
Subject: Re: [PATCH V5 18/19] net: ks8851: Implement Parallel bus operations
To:     Andrew Lunn <andrew@lunn.ch>
Cc:     netdev@vger.kernel.org, "David S . Miller" <davem@davemloft.net>,
        Lukas Wunner <lukas@wunner.de>, Petr Stetiar <ynezz@true.cz>,
        YueHaibing <yuehaibing@huawei.com>
References: <20200514000747.159320-1-marex@denx.de>
 <20200514000747.159320-19-marex@denx.de> <20200514015753.GL527401@lunn.ch>
 <5dbab44d-de45-f8e2-b4e4-4be15408657e@denx.de>
 <20200514131527.GN527401@lunn.ch>
From:   Marek Vasut <marex@denx.de>
Message-ID: <16f60604-f3e9-1391-ff47-37c40ab9c6f7@denx.de>
Date:   Thu, 14 May 2020 16:00:18 +0200
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:68.0) Gecko/20100101
 Thunderbird/68.5.0
MIME-Version: 1.0
In-Reply-To: <20200514131527.GN527401@lunn.ch>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On 5/14/20 3:15 PM, Andrew Lunn wrote:
> On Thu, May 14, 2020 at 04:26:30AM +0200, Marek Vasut wrote:
>> On 5/14/20 3:57 AM, Andrew Lunn wrote:
>>>> diff --git a/drivers/net/ethernet/micrel/ks8851_par.c b/drivers/net/ethernet/micrel/ks8851_par.c
>>>> new file mode 100644
>>>> index 000000000000..90fffacb1695
>>>> --- /dev/null
>>>> +++ b/drivers/net/ethernet/micrel/ks8851_par.c
>>>> @@ -0,0 +1,348 @@
>>>> +// SPDX-License-Identifier: GPL-2.0-only
>>>> +/* drivers/net/ethernet/micrel/ks8851.c
>>>> + *
>>>> + * Copyright 2009 Simtec Electronics
>>>> + *	http://www.simtec.co.uk/
>>>> + *	Ben Dooks <ben@simtec.co.uk>
>>>> + */
>>>> +
>>>> +#define pr_fmt(fmt) KBUILD_MODNAME ": " fmt
>>>> +
>>>> +#define DEBUG
>>>
>>> I don't think you wanted that left in.
>>
>> This actually was in the original ks8851.c since forever, so I wonder.
>> Maybe a separate patch would be better ?
> 
> Yes, please add another patch.

OK

>>>> +		ks8851_done_tx(ks, skb);
>>>> +	} else {
>>>> +		ret = NETDEV_TX_BUSY;
>>>> +	}
>>>> +
>>>> +	ks8851_unlock_par(ks, &flags);
>>>> +
>>>> +	return ret;
>>>> +}
>>>
>>>> +module_param_named(message, msg_enable, int, 0);
>>>> +MODULE_PARM_DESC(message, "Message verbosity level (0=none, 31=all)");
>>>
>>> Module parameters are bad. A new driver should not have one, if
>>> possible. Please implement the ethtool .get_msglevel and .set_msglevel
>>> instead.
>>
>> This was in the original ks8851.c , so I need to retain it , no ?
> 
> Ah. Err.
> 
> This patch looks like a new driver. It has probe, remove
> module_platform_driver(), etc. So as a new driver, it should not have
> module parameters.
> 
> But then your next patch removes the mll driver. Your intention is
> that this driver replaces the mll driver. So for backwards
> compatibility, yes you do need the module parameter.

All right

btw is jiffies-based timeout OK? Like this:

diff --git a/drivers/net/ethernet/micrel/ks8851_par.c
b/drivers/net/ethernet/micrel/ks8851_par.c
index 5163d10971f4..1d9e7a33ffcf 100644
--- a/drivers/net/ethernet/micrel/ks8851_par.c
+++ b/drivers/net/ethernet/micrel/ks8851_par.c
@@ -238,6 +238,7 @@ static netdev_tx_t ks8851_start_xmit_par(struct
sk_buff *skb,
                                         struct net_device *dev)
 {
        struct ks8851_net *ks = netdev_priv(dev);
+       unsigned long txpoll_start_time;
        netdev_tx_t ret = NETDEV_TX_OK;
        unsigned long flags;
        u16 txmir;
@@ -254,8 +255,20 @@ static netdev_tx_t ks8851_start_xmit_par(struct
sk_buff *skb,
                ks8851_wrfifo_par(ks, skb, false);
                ks8851_wrreg16_par(ks, KS_RXQCR, ks->rc_rxqcr);
                ks8851_wrreg16_par(ks, KS_TXQCR, TXQCR_METFE);
-               while (ks8851_rdreg16_par(ks, KS_TXQCR) & TXQCR_METFE)
-                       ;
+
+               txpoll_start_time = jiffies;
+               while (true) {
+                       if (!(ks8851_rdreg16_par(ks, KS_TXQCR) &
TXQCR_METFE))
+                               break;
+
+                       if (time_after(jiffies, txpoll_start_time + HZ)) {
+                               netdev_warn(dev, "%s: did not complete.\n",
+                                           __func__);
+                               ret = NETDEV_TX_BUSY;
+                               break;
+                       }
+               }
+
                ks8851_done_tx(ks, skb);
        } else {
                ret = NETDEV_TX_BUSY;
