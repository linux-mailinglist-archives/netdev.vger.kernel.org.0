Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 47B30108BBB
	for <lists+netdev@lfdr.de>; Mon, 25 Nov 2019 11:32:07 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727523AbfKYKcE (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 25 Nov 2019 05:32:04 -0500
Received: from metis.ext.pengutronix.de ([85.220.165.71]:51401 "EHLO
        metis.ext.pengutronix.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1727386AbfKYKcB (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 25 Nov 2019 05:32:01 -0500
Received: from soja.hi.pengutronix.de ([2001:67c:670:100:3ad5:47ff:feaf:13da])
        by metis.ext.pengutronix.de with esmtps (TLS1.2:ECDHE_RSA_AES_128_GCM_SHA256:128)
        (Exim 4.92)
        (envelope-from <o.rempel@pengutronix.de>)
        id 1iZBev-0007gt-17; Mon, 25 Nov 2019 11:31:57 +0100
Subject: Re: [PATCH v1 1/2] net: dsa: sja1105: print info about probet chip
 only after every thing was done.
To:     Vladimir Oltean <olteanv@gmail.com>
Cc:     mkl@pengutronix.de, Andrew Lunn <andrew@lunn.ch>,
        Vivien Didelot <vivien.didelot@gmail.com>,
        Florian Fainelli <f.fainelli@gmail.com>,
        "David S. Miller" <davem@davemloft.net>, kernel@pengutronix.de,
        netdev <netdev@vger.kernel.org>,
        lkml <linux-kernel@vger.kernel.org>, david@protonic.nl
References: <20191125100259.5147-1-o.rempel@pengutronix.de>
 <CA+h21hrwK-8TWcAowcLC5MOaqE+XYXdogmAE7TYVG5B3dG57cA@mail.gmail.com>
From:   Oleksij Rempel <o.rempel@pengutronix.de>
Message-ID: <caab9bcc-a4a6-db88-aa23-859ffcf6ff85@pengutronix.de>
Date:   Mon, 25 Nov 2019 11:31:55 +0100
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:60.0) Gecko/20100101
 Thunderbird/60.9.0
MIME-Version: 1.0
In-Reply-To: <CA+h21hrwK-8TWcAowcLC5MOaqE+XYXdogmAE7TYVG5B3dG57cA@mail.gmail.com>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Language: en-US
Content-Transfer-Encoding: 7bit
X-SA-Exim-Connect-IP: 2001:67c:670:100:3ad5:47ff:feaf:13da
X-SA-Exim-Mail-From: o.rempel@pengutronix.de
X-SA-Exim-Scanned: No (on metis.ext.pengutronix.de); SAEximRunCond expanded to false
X-PTX-Original-Recipient: netdev@vger.kernel.org
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org



On 25.11.19 11:22, Vladimir Oltean wrote:
> On Mon, 25 Nov 2019 at 12:03, Oleksij Rempel <o.rempel@pengutronix.de> wrote:
>>
>> Currently we will get "Probed switch chip" notification multiple times
>> if first probe filed by some reason. To avoid this confusing notifications move
>> dev_info to the end of probe.
>>
>> Signed-off-by: Oleksij Rempel <o.rempel@pengutronix.de>
>> ---
> 
> Also there are some typos which should be corrected:
> probet -> probed
> every thing -> everything
> filed -> failed
> 
> "failed for some reason" -> "was deferred"

Ok, thx.

should i resend both patches separately or only this one with spell fixes?

> 
>>   drivers/net/dsa/sja1105/sja1105_main.c | 10 +++++++---
>>   1 file changed, 7 insertions(+), 3 deletions(-)
>>
>> diff --git a/drivers/net/dsa/sja1105/sja1105_main.c b/drivers/net/dsa/sja1105/sja1105_main.c
>> index 7687ddcae159..1238fd68b2cd 100644
>> --- a/drivers/net/dsa/sja1105/sja1105_main.c
>> +++ b/drivers/net/dsa/sja1105/sja1105_main.c
>> @@ -2191,8 +2191,6 @@ static int sja1105_probe(struct spi_device *spi)
>>                  return rc;
>>          }
>>
>> -       dev_info(dev, "Probed switch chip: %s\n", priv->info->name);
>> -
>>          ds = dsa_switch_alloc(dev, SJA1105_NUM_PORTS);
>>          if (!ds)
>>                  return -ENOMEM;
>> @@ -2218,7 +2216,13 @@ static int sja1105_probe(struct spi_device *spi)
>>
>>          sja1105_tas_setup(ds);
>>
>> -       return dsa_register_switch(priv->ds);
>> +       rc = dsa_register_switch(priv->ds);
>> +       if (rc)
>> +               return rc;
>> +
>> +       dev_info(dev, "Probed switch chip: %s\n", priv->info->name);
>> +
>> +       return 0;
>>   }
>>
>>   static int sja1105_remove(struct spi_device *spi)
>> --
>> 2.24.0
>>
> 
> Thanks,
> -Vladimir
> 

Kind regards,
Oleksij Rempel

-- 
Pengutronix e.K.                           |                             |
Industrial Linux Solutions                 | http://www.pengutronix.de/  |
Peiner Str. 6-8, 31137 Hildesheim, Germany | Phone: +49-5121-206917-0    |
Amtsgericht Hildesheim, HRA 2686           | Fax:   +49-5121-206917-5555 |
