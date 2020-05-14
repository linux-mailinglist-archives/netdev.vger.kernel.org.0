Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 0FF4A1D2522
	for <lists+netdev@lfdr.de>; Thu, 14 May 2020 04:28:44 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1725938AbgENC2l (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 13 May 2020 22:28:41 -0400
Received: from mail-out.m-online.net ([212.18.0.9]:33094 "EHLO
        mail-out.m-online.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1725874AbgENC2k (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 13 May 2020 22:28:40 -0400
Received: from frontend01.mail.m-online.net (unknown [192.168.8.182])
        by mail-out.m-online.net (Postfix) with ESMTP id 49MwT24pkYz1qsb6;
        Thu, 14 May 2020 04:28:38 +0200 (CEST)
Received: from localhost (dynscan1.mnet-online.de [192.168.6.70])
        by mail.m-online.net (Postfix) with ESMTP id 49MwT249bsz1shfG;
        Thu, 14 May 2020 04:28:38 +0200 (CEST)
X-Virus-Scanned: amavisd-new at mnet-online.de
Received: from mail.mnet-online.de ([192.168.8.182])
        by localhost (dynscan1.mail.m-online.net [192.168.6.70]) (amavisd-new, port 10024)
        with ESMTP id EKNasTaDiYUU; Thu, 14 May 2020 04:28:37 +0200 (CEST)
X-Auth-Info: NfBKPu0deQruENdI0UFex4i426KJuzRowr48YfXFWWk=
Received: from [IPv6:::1] (unknown [195.140.253.167])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.mnet-online.de (Postfix) with ESMTPSA;
        Thu, 14 May 2020 04:28:36 +0200 (CEST)
Subject: Re: [PATCH V5 18/19] net: ks8851: Implement Parallel bus operations
To:     Andrew Lunn <andrew@lunn.ch>
Cc:     netdev@vger.kernel.org, "David S . Miller" <davem@davemloft.net>,
        Lukas Wunner <lukas@wunner.de>, Petr Stetiar <ynezz@true.cz>,
        YueHaibing <yuehaibing@huawei.com>
References: <20200514000747.159320-1-marex@denx.de>
 <20200514000747.159320-19-marex@denx.de> <20200514015753.GL527401@lunn.ch>
From:   Marek Vasut <marex@denx.de>
Message-ID: <5dbab44d-de45-f8e2-b4e4-4be15408657e@denx.de>
Date:   Thu, 14 May 2020 04:26:30 +0200
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:68.0) Gecko/20100101
 Thunderbird/68.5.0
MIME-Version: 1.0
In-Reply-To: <20200514015753.GL527401@lunn.ch>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On 5/14/20 3:57 AM, Andrew Lunn wrote:
>> diff --git a/drivers/net/ethernet/micrel/ks8851_par.c b/drivers/net/ethernet/micrel/ks8851_par.c
>> new file mode 100644
>> index 000000000000..90fffacb1695
>> --- /dev/null
>> +++ b/drivers/net/ethernet/micrel/ks8851_par.c
>> @@ -0,0 +1,348 @@
>> +// SPDX-License-Identifier: GPL-2.0-only
>> +/* drivers/net/ethernet/micrel/ks8851.c
>> + *
>> + * Copyright 2009 Simtec Electronics
>> + *	http://www.simtec.co.uk/
>> + *	Ben Dooks <ben@simtec.co.uk>
>> + */
>> +
>> +#define pr_fmt(fmt) KBUILD_MODNAME ": " fmt
>> +
>> +#define DEBUG
> 
> I don't think you wanted that left in.

This actually was in the original ks8851.c since forever, so I wonder.
Maybe a separate patch would be better ?

[...]

>> +	if (likely(txmir >= skb->len + 12)) {
>> +		ks8851_wrreg16_par(ks, KS_RXQCR, ks->rc_rxqcr | RXQCR_SDA);
>> +		ks8851_wrfifo_par(ks, skb, false);
>> +		ks8851_wrreg16_par(ks, KS_RXQCR, ks->rc_rxqcr);
>> +		ks8851_wrreg16_par(ks, KS_TXQCR, TXQCR_METFE);
>> +		while (ks8851_rdreg16_par(ks, KS_TXQCR) & TXQCR_METFE)
>> +			;
> 
> You should have a timeout/retry limit here, just in case.

OK

>> +		ks8851_done_tx(ks, skb);
>> +	} else {
>> +		ret = NETDEV_TX_BUSY;
>> +	}
>> +
>> +	ks8851_unlock_par(ks, &flags);
>> +
>> +	return ret;
>> +}
> 
>> +module_param_named(message, msg_enable, int, 0);
>> +MODULE_PARM_DESC(message, "Message verbosity level (0=none, 31=all)");
> 
> Module parameters are bad. A new driver should not have one, if
> possible. Please implement the ethtool .get_msglevel and .set_msglevel
> instead.

This was in the original ks8851.c , so I need to retain it , no ?
