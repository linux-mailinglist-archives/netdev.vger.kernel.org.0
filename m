Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 570371AAA47
	for <lists+netdev@lfdr.de>; Wed, 15 Apr 2020 16:40:47 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S370795AbgDOOj0 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 15 Apr 2020 10:39:26 -0400
Received: from bmailout2.hostsharing.net ([83.223.78.240]:60927 "EHLO
        bmailout2.hostsharing.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S2634537AbgDOOjQ (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 15 Apr 2020 10:39:16 -0400
Received: from h08.hostsharing.net (h08.hostsharing.net [83.223.95.28])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (Client CN "*.hostsharing.net", Issuer "COMODO RSA Domain Validation Secure Server CA" (not verified))
        by bmailout2.hostsharing.net (Postfix) with ESMTPS id 4324F2800B1AF;
        Wed, 15 Apr 2020 16:39:10 +0200 (CEST)
Received: by h08.hostsharing.net (Postfix, from userid 100393)
        id 1137C14E866; Wed, 15 Apr 2020 16:39:10 +0200 (CEST)
Date:   Wed, 15 Apr 2020 16:39:09 +0200
From:   Lukas Wunner <lukas@wunner.de>
To:     Marek Vasut <marex@denx.de>
Cc:     netdev@vger.kernel.org, "David S . Miller" <davem@davemloft.net>,
        Petr Stetiar <ynezz@true.cz>,
        YueHaibing <yuehaibing@huawei.com>
Subject: Re: [PATCH V4 00/19] net: ks8851: Unify KS8851 SPI and MLL drivers
Message-ID: <20200415143909.wmtmud3vkkwzjv73@wunner.de>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <82060747-824e-d779-b76d-6c4559b446c2@denx.de>
 <20200414182029.183594-1-marex@denx.de>
User-Agent: NeoMutt/20170113 (1.7.2)
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Tue, Apr 14, 2020 at 08:20:10PM +0200, Marek Vasut wrote:
> NOTE: The V4 is now tested on RPi3B with KSZ8851SNL DEMO Board at 25 MHz.
>       The "ping -c 1000 -i 0.01" latency test is fluctuating around
>       		rtt min/avg/max/mdev = 1.448/1.540/1.699/0.030 ms
>       either way, with or without this series.

Compiling this series fails if CONFIG_KS8851=m and CONFIG_KS8851_MLL=y:

arm-linux-gnueabihf-ld: drivers/net/ethernet/micrel/ks8851_common.o:(__param+0x4): undefined reference to `__this_module'

I already reported this in my e-mail of April 6th, it's caused by the
module_param_named() for msg_enable.


Reading the MAC address from an external EEPROM works with this series.


I still get worse performance with this series than without it
(perhaps unsurprisingly so because not much has changed from v3 to v4).

We're using CONFIG_PREEMPT_RT_FULL=y.  I'm sorry for not mentioning this
earlier, I didn't assume it would make such a big difference but
apparently it does.

This is the branch I've tested today:
https://github.com/l1k/linux/commits/revpi-4.19-marek-v4


Latency without this series (ping -A -c 100000):
rtt min/avg/max/mdev = 0.793/1.694/2.321/0.044 ms, ipg/ewma 2.000/1.691 ms

Latency with this series:
rtt min/avg/max/mdev = 0.957/1.715/2.652/0.043 ms, ipg/ewma 2.000/1.716 ms


RX throughput without this series (iperf3 -f k -i 0 -c):
[  5]   0.00-10.00  sec  19.0 MBytes  15960 Kbits/sec                  receiver

RX throughput with this series:
[  5]   0.00-10.00  sec  18.5 MBytes  15498 Kbits/sec                  receiver


TX throughput without this series (iperf3 -R -f k -i 0 -c):
[  5]   0.00-10.00  sec  18.6 MBytes  15614 Kbits/sec                  receiver

TX throughput with this series:
[  5]   0.00-10.00  sec  18.3 MBytes  15371 Kbits/sec                  receiver

So this is pretty much the same performance degredation as before.


> > I'm wondering where the
> > performance penalty is originating from:  Perhaps because of the
> > 16-bit read of RXFC in ks8851_rx_pkts()?
> 
> Can you patch that part away to see whether that's the case ?

Will do.


> > Check if the driver for the SPI controller is buggy or somehow limits the
> > speed.
> 
> I used two different drivers -- the iMX SPI and the STM32 SPI -- I would
> say that if both show the same behavior, it's unlikely to be the driver.

Hm, so why did it work with the RasPi but not with the others?

Thanks,

Lukas
