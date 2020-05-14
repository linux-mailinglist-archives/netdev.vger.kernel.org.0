Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 809BD1D24F6
	for <lists+netdev@lfdr.de>; Thu, 14 May 2020 03:51:50 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728607AbgENBvs (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 13 May 2020 21:51:48 -0400
Received: from mail-out.m-online.net ([212.18.0.9]:52883 "EHLO
        mail-out.m-online.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1725925AbgENBvs (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 13 May 2020 21:51:48 -0400
Received: from frontend01.mail.m-online.net (unknown [192.168.8.182])
        by mail-out.m-online.net (Postfix) with ESMTP id 49MvfT6Dh9z1qrfB;
        Thu, 14 May 2020 03:51:45 +0200 (CEST)
Received: from localhost (dynscan1.mnet-online.de [192.168.6.70])
        by mail.m-online.net (Postfix) with ESMTP id 49MvfT5fYzz1shfC;
        Thu, 14 May 2020 03:51:45 +0200 (CEST)
X-Virus-Scanned: amavisd-new at mnet-online.de
Received: from mail.mnet-online.de ([192.168.8.182])
        by localhost (dynscan1.mail.m-online.net [192.168.6.70]) (amavisd-new, port 10024)
        with ESMTP id s9IesH-ertF2; Thu, 14 May 2020 03:51:44 +0200 (CEST)
X-Auth-Info: PqBluoDEPYjj54vdTzMvth0Cw8Km8kqz8D9Z7eC7CDI=
Received: from [IPv6:::1] (unknown [195.140.253.167])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.mnet-online.de (Postfix) with ESMTPSA;
        Thu, 14 May 2020 03:51:44 +0200 (CEST)
Subject: Re: [PATCH V5 13/19] net: ks8851: Split out SPI specific code from
 probe() and remove()
To:     Andrew Lunn <andrew@lunn.ch>
Cc:     netdev@vger.kernel.org, "David S . Miller" <davem@davemloft.net>,
        Lukas Wunner <lukas@wunner.de>, Petr Stetiar <ynezz@true.cz>,
        YueHaibing <yuehaibing@huawei.com>
References: <20200514000747.159320-1-marex@denx.de>
 <20200514000747.159320-14-marex@denx.de> <20200514013103.GH527401@lunn.ch>
From:   Marek Vasut <marex@denx.de>
Message-ID: <7f06fe95-599c-3ef8-bdf3-23cd06abe773@denx.de>
Date:   Thu, 14 May 2020 03:34:19 +0200
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:68.0) Gecko/20100101
 Thunderbird/68.5.0
MIME-Version: 1.0
In-Reply-To: <20200514013103.GH527401@lunn.ch>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On 5/14/20 3:31 AM, Andrew Lunn wrote:
> On Thu, May 14, 2020 at 02:07:41AM +0200, Marek Vasut wrote:
>> Factor out common code into ks8851_probe_common() and
>> ks8851_remove_common() to permit both SPI and parallel
>> bus driver variants to use the common code path for
>> both probing and removal.
>>
>> There should be no functional change.
>>
>> Signed-off-by: Marek Vasut <marex@denx.de>
>> Cc: David S. Miller <davem@davemloft.net>
>> Cc: Lukas Wunner <lukas@wunner.de>
>> Cc: Petr Stetiar <ynezz@true.cz>
>> Cc: YueHaibing <yuehaibing@huawei.com>
>> ---
>> V2: - Add RB from Andrew
>>     - Rework on top of locking patches, drop RB
>> V3: No change
>> V4: No change
>> V5: Pass message enable as parameter to common probe function,
>>     so the MODULE_* bits can be per-driver
>> ---
>>  drivers/net/ethernet/micrel/ks8851.c | 86 ++++++++++++++++------------
>>  1 file changed, 48 insertions(+), 38 deletions(-)
>>
>> diff --git a/drivers/net/ethernet/micrel/ks8851.c b/drivers/net/ethernet/micrel/ks8851.c
>> index 440ddd5cafbd..791b2f14dd9d 100644
>> --- a/drivers/net/ethernet/micrel/ks8851.c
>> +++ b/drivers/net/ethernet/micrel/ks8851.c
>> @@ -1431,27 +1431,15 @@ static int ks8851_resume(struct device *dev)
>>  
>>  static SIMPLE_DEV_PM_OPS(ks8851_pm_ops, ks8851_suspend, ks8851_resume);
>>  
>> -static int ks8851_probe(struct spi_device *spi)
>> +static int ks8851_probe_common(struct net_device *netdev, struct device *dev,
>> +			       int msg_en)
>>  {
> 
>>  
>> -	dev_info(dev, "message enable is %d\n", msg_enable);
>> +	dev_info(dev, "message enable is %d\n", msg_en);
>>  
>>  	/* set the default message enable */
>> -	ks->msg_enable = netif_msg_init(msg_enable, (NETIF_MSG_DRV |
>> -						     NETIF_MSG_PROBE |
>> -						     NETIF_MSG_LINK));
>> +	ks->msg_enable = netif_msg_init(msg_en, NETIF_MSG_DRV |
>> +						NETIF_MSG_PROBE |
>> +						NETIF_MSG_LINK);
> 
> It would of been nice to keep the name msg_en, then these changes
> would not be needed. Or is there something not visible in this patch
> which means the variable name it not usable?

I think this is just a product of the back-and-forth this patch went
through, to fix some line-over-80 issue in the previous iteration(s).

> Reviewed-by: Andrew Lunn <andrew@lunn.ch>
> 
>     Andrew
> 
