Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 0007A1A4573
	for <lists+netdev@lfdr.de>; Fri, 10 Apr 2020 13:01:50 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1725991AbgDJLBQ (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 10 Apr 2020 07:01:16 -0400
Received: from bmailout2.hostsharing.net ([83.223.78.240]:57917 "EHLO
        bmailout2.hostsharing.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1725930AbgDJLBQ (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 10 Apr 2020 07:01:16 -0400
Received: from h08.hostsharing.net (h08.hostsharing.net [IPv6:2a01:37:1000::53df:5f1c:0])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (Client CN "*.hostsharing.net", Issuer "COMODO RSA Domain Validation Secure Server CA" (not verified))
        by bmailout2.hostsharing.net (Postfix) with ESMTPS id 2CFE52800A26A;
        Fri, 10 Apr 2020 13:01:14 +0200 (CEST)
Received: by h08.hostsharing.net (Postfix, from userid 100393)
        id F110D15BC89; Fri, 10 Apr 2020 13:01:13 +0200 (CEST)
Date:   Fri, 10 Apr 2020 13:01:13 +0200
From:   Lukas Wunner <lukas@wunner.de>
To:     Marek Vasut <marex@denx.de>
Cc:     netdev@vger.kernel.org, "David S . Miller" <davem@davemloft.net>,
        Petr Stetiar <ynezz@true.cz>,
        YueHaibing <yuehaibing@huawei.com>
Subject: Re: [PATCH V3 00/18] net: ks8851: Unify KS8851 SPI and MLL drivers
Message-ID: <20200410110113.j5b3txz5fkgw56xq@wunner.de>
References: <20200328003148.498021-1-marex@denx.de>
 <20200406031649.zujfod44bz53ztlo@wunner.de>
 <f9449a3b-7536-0bde-4ee6-b254fd90923f@denx.de>
 <143b003a-81f9-d908-9580-67317a8e96c6@denx.de>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <143b003a-81f9-d908-9580-67317a8e96c6@denx.de>
User-Agent: NeoMutt/20170113 (1.7.2)
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Wed, Apr 08, 2020 at 09:49:14PM +0200, Marek Vasut wrote:
> On 4/6/20 1:20 PM, Marek Vasut wrote:
> > On 4/6/20 5:16 AM, Lukas Wunner wrote:
> > > I'll be back at the office this week and will conduct performance
> > > measurements with this version.

Latency without this series (ping -A -c 100000):

100000 packets transmitted, 100000 received, 0% packet loss, time 205ms
rtt min/avg/max/mdev = 0.790/1.695/2.624/0.046 ms, ipg/ewma 2.000/1.693 ms
                             ^^^^^
Latency with this series:

100000 packets transmitted, 100000 received, 0% packet loss, time 220ms
rtt min/avg/max/mdev = 0.880/1.717/2.428/0.059 ms, ipg/ewma 2.000/1.710 ms

Latency with this series + my patch to inline accessors:

100000 packets transmitted, 100000 received, 0% packet loss, time 219ms
rtt min/avg/max/mdev = 0.874/1.716/3.296/0.058 ms, ipg/ewma 2.000/1.719 ms


RX throughput without this series (iperf3 -f k -i 0 -c):

[  5]   0.00-10.00  sec  19.0 MBytes  15958 Kbits/sec                  receiver

RX throughput with this series:

[  5]   0.00-10.00  sec  18.4 MBytes  15452 Kbits/sec                  receiver

RX throughput with this series + my patch to inline accessors:

[  5]   0.00-10.00  sec  18.5 MBytes  15506 Kbits/sec                  receiver


TX throughput without this series (iperf3 -R -f k -i 0 -c):

[  5]   0.00-10.00  sec  18.6 MBytes  15604 Kbits/sec                  receiver

TX throughput with this series:

[  5]   0.00-10.00  sec  18.3 MBytes  15314 Kbits/sec                  receiver

TX throughput with this series + my patch to inline accessors:

[  5]   0.00-10.00  sec  18.3 MBytes  15349 Kbits/sec                  receiver


The commands were invoked from a machine with a Broadcom tg3
Gigabit Ethernet controller.

Conclusion:  The series does incur a measurable performance penalty
which should be fixed before it gets merged.  Inlining the accessors
only yields a very small improvement.  I'm wondering where the
performance penalty is originating from:  Perhaps because of the
16-bit read of RXFC in ks8851_rx_pkts()?


> So I got the KS8851SNL development kit to test the SPI option. The
> current driver in linux-next gives me SPI transfer timeouts at 1 MHz (I
> also tried 6 MHz, 10 MHz, same problem, I also checked the signal
> quality which is OK) both on iMX6Q and on STM32MP1 with ~2 cm long
> wiring between the SoM and the KS8851SNL devkit, so that's where my
> testing ends, sadly. Unless you have some idea what the problem might be ?

Check the signal quality with an oscilloscope.
Crank up drive strength of the SPI pins if supported by the pin controller.
Check if the driver for the SPI controller is buggy or somehow limits the
speed.

We use the KSZ8851SNL both with STM32-based products (at 20 MHz SPI clock,
but without an operating system) and with Raspberry Pi based products
(at up to 25 MHz SPI clock, with Linux).  It is only the latter that
I'm really familiar with.  We've invested considerable resources to
fix bugs and speed up the Raspberry Pi's SPI driver as much as possible.
By now it works pretty well with the ks8851.

A Raspberry Pi 3 is readily available for just a few Euros, so you may
want to pick up one of those.  My most recent speed improvements for the
Raspberry Pi's SPI and DMA drivers went into v5.4, so be sure to use at
least that.  Should signal quality be a problem, it's possible to
increase GPIO drive strength by putting a dt-blob.bin in the /boot
partition:

https://www.raspberrypi.org/documentation/configuration/pin-configuration.md

I forgot to test whether reading the MAC address from the external
EEPROM works with v3 of your series, but I'll be back in the office
on Tuesday to take another look.

Thanks,

Lukas
