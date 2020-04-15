Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 4BECD1AAB29
	for <lists+netdev@lfdr.de>; Wed, 15 Apr 2020 17:01:47 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2392977AbgDOO5p (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 15 Apr 2020 10:57:45 -0400
Received: from mail-out.m-online.net ([212.18.0.10]:35408 "EHLO
        mail-out.m-online.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S2390410AbgDOO5m (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 15 Apr 2020 10:57:42 -0400
Received: from frontend01.mail.m-online.net (unknown [192.168.8.182])
        by mail-out.m-online.net (Postfix) with ESMTP id 492QSg754Fz1rwbB;
        Wed, 15 Apr 2020 16:57:31 +0200 (CEST)
Received: from localhost (dynscan1.mnet-online.de [192.168.6.70])
        by mail.m-online.net (Postfix) with ESMTP id 492QSV6ljBz1qtwb;
        Wed, 15 Apr 2020 16:57:30 +0200 (CEST)
X-Virus-Scanned: amavisd-new at mnet-online.de
Received: from mail.mnet-online.de ([192.168.8.182])
        by localhost (dynscan1.mail.m-online.net [192.168.6.70]) (amavisd-new, port 10024)
        with ESMTP id kHkuRFO95cpx; Wed, 15 Apr 2020 16:57:29 +0200 (CEST)
X-Auth-Info: gHiBQ9iFWpAAW6Gh96Pyb7Aqz1I680Skh+VW/Nn9BCY=
Received: from [IPv6:::1] (unknown [195.140.253.167])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.mnet-online.de (Postfix) with ESMTPSA;
        Wed, 15 Apr 2020 16:57:29 +0200 (CEST)
Subject: Re: [PATCH V4 00/19] net: ks8851: Unify KS8851 SPI and MLL drivers
To:     Lukas Wunner <lukas@wunner.de>
Cc:     netdev@vger.kernel.org, "David S . Miller" <davem@davemloft.net>,
        Petr Stetiar <ynezz@true.cz>,
        YueHaibing <yuehaibing@huawei.com>
References: <20200415143909.wmtmud3vkkwzjv73@wunner.de>
From:   Marek Vasut <marex@denx.de>
Message-ID: <ac0f7227-a4ae-b6cd-36ec-3bcb02b1adbe@denx.de>
Date:   Wed, 15 Apr 2020 16:51:39 +0200
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:68.0) Gecko/20100101
 Thunderbird/68.5.0
MIME-Version: 1.0
In-Reply-To: <20200415143909.wmtmud3vkkwzjv73@wunner.de>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On 4/15/20 4:39 PM, Lukas Wunner wrote:
> On Tue, Apr 14, 2020 at 08:20:10PM +0200, Marek Vasut wrote:
>> NOTE: The V4 is now tested on RPi3B with KSZ8851SNL DEMO Board at 25 MHz.
>>       The "ping -c 1000 -i 0.01" latency test is fluctuating around
>>       		rtt min/avg/max/mdev = 1.448/1.540/1.699/0.030 ms
>>       either way, with or without this series.
> 
> Compiling this series fails if CONFIG_KS8851=m and CONFIG_KS8851_MLL=y:
> 
> arm-linux-gnueabihf-ld: drivers/net/ethernet/micrel/ks8851_common.o:(__param+0x4): undefined reference to `__this_module'
> 
> I already reported this in my e-mail of April 6th, it's caused by the
> module_param_named() for msg_enable.
> 
> 
> Reading the MAC address from an external EEPROM works with this series.
> 
> 
> I still get worse performance with this series than without it
> (perhaps unsurprisingly so because not much has changed from v3 to v4).

I reinstated the indirect access, so things did change. Besides, there
performance for the parallel option is back where it was with the old
driver, which is important for me.

> We're using CONFIG_PREEMPT_RT_FULL=y.  I'm sorry for not mentioning this
> earlier, I didn't assume it would make such a big difference but
> apparently it does.

Do you also have the RT patch applied ?

> This is the branch I've tested today:
> https://github.com/l1k/linux/commits/revpi-4.19-marek-v4

You seem to have quite a few more patches in that repository than just
this series, some of them even touching the RPi SPI driver and it's DMA
implementation.

Could it be that's why I don't see your performance problems too ?

> Latency without this series (ping -A -c 100000):
> rtt min/avg/max/mdev = 0.793/1.694/2.321/0.044 ms, ipg/ewma 2.000/1.691 ms
> 
> Latency with this series:
> rtt min/avg/max/mdev = 0.957/1.715/2.652/0.043 ms, ipg/ewma 2.000/1.716 ms
> 
> 
> RX throughput without this series (iperf3 -f k -i 0 -c):
> [  5]   0.00-10.00  sec  19.0 MBytes  15960 Kbits/sec                  receiver
> 
> RX throughput with this series:
> [  5]   0.00-10.00  sec  18.5 MBytes  15498 Kbits/sec                  receiver
> 
> 
> TX throughput without this series (iperf3 -R -f k -i 0 -c):
> [  5]   0.00-10.00  sec  18.6 MBytes  15614 Kbits/sec                  receiver
> 
> TX throughput with this series:
> [  5]   0.00-10.00  sec  18.3 MBytes  15371 Kbits/sec                  receiver
> 
> So this is pretty much the same performance degredation as before.
> 
> 
>>> I'm wondering where the
>>> performance penalty is originating from:  Perhaps because of the
>>> 16-bit read of RXFC in ks8851_rx_pkts()?
>>
>> Can you patch that part away to see whether that's the case ?
> 
> Will do.

Thanks

>>> Check if the driver for the SPI controller is buggy or somehow limits the
>>> speed.
>>
>> I used two different drivers -- the iMX SPI and the STM32 SPI -- I would
>> say that if both show the same behavior, it's unlikely to be the driver.
> 
> Hm, so why did it work with the RasPi but not with the others?

I didn't have a chance to debug this yet.
