Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id F103D1A49F9
	for <lists+netdev@lfdr.de>; Fri, 10 Apr 2020 20:47:00 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726680AbgDJSpw (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 10 Apr 2020 14:45:52 -0400
Received: from mail-out.m-online.net ([212.18.0.9]:45744 "EHLO
        mail-out.m-online.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726203AbgDJSpw (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 10 Apr 2020 14:45:52 -0400
Received: from frontend01.mail.m-online.net (unknown [192.168.8.182])
        by mail-out.m-online.net (Postfix) with ESMTP id 48zRmD0ZXKz1qrfw;
        Fri, 10 Apr 2020 20:45:47 +0200 (CEST)
Received: from localhost (dynscan1.mnet-online.de [192.168.6.70])
        by mail.m-online.net (Postfix) with ESMTP id 48zRmC3MqVz1qqkg;
        Fri, 10 Apr 2020 20:45:47 +0200 (CEST)
X-Virus-Scanned: amavisd-new at mnet-online.de
Received: from mail.mnet-online.de ([192.168.8.182])
        by localhost (dynscan1.mail.m-online.net [192.168.6.70]) (amavisd-new, port 10024)
        with ESMTP id HFNPwD1Tb9QP; Fri, 10 Apr 2020 20:45:45 +0200 (CEST)
X-Auth-Info: Bwj4lHYAkz0EWt7mbDpF4uojhFUSPqpUWOEyE0PGUec=
Received: from [IPv6:::1] (unknown [195.140.253.167])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.mnet-online.de (Postfix) with ESMTPSA;
        Fri, 10 Apr 2020 20:45:45 +0200 (CEST)
Subject: Re: [PATCH V3 00/18] net: ks8851: Unify KS8851 SPI and MLL drivers
To:     Lukas Wunner <lukas@wunner.de>
Cc:     netdev@vger.kernel.org, "David S . Miller" <davem@davemloft.net>,
        Petr Stetiar <ynezz@true.cz>,
        YueHaibing <yuehaibing@huawei.com>
References: <20200328003148.498021-1-marex@denx.de>
 <20200406031649.zujfod44bz53ztlo@wunner.de>
 <f9449a3b-7536-0bde-4ee6-b254fd90923f@denx.de>
 <143b003a-81f9-d908-9580-67317a8e96c6@denx.de>
 <20200410110113.j5b3txz5fkgw56xq@wunner.de>
From:   Marek Vasut <marex@denx.de>
Message-ID: <82060747-824e-d779-b76d-6c4559b446c2@denx.de>
Date:   Fri, 10 Apr 2020 20:10:48 +0200
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:68.0) Gecko/20100101
 Thunderbird/68.5.0
MIME-Version: 1.0
In-Reply-To: <20200410110113.j5b3txz5fkgw56xq@wunner.de>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On 4/10/20 1:01 PM, Lukas Wunner wrote:
> On Wed, Apr 08, 2020 at 09:49:14PM +0200, Marek Vasut wrote:
>> On 4/6/20 1:20 PM, Marek Vasut wrote:
>>> On 4/6/20 5:16 AM, Lukas Wunner wrote:
>>>> I'll be back at the office this week and will conduct performance
>>>> measurements with this version.
> 
> Latency without this series (ping -A -c 100000):
> 
> 100000 packets transmitted, 100000 received, 0% packet loss, time 205ms
> rtt min/avg/max/mdev = 0.790/1.695/2.624/0.046 ms, ipg/ewma 2.000/1.693 ms
>                              ^^^^^
> Latency with this series:
> 
> 100000 packets transmitted, 100000 received, 0% packet loss, time 220ms
> rtt min/avg/max/mdev = 0.880/1.717/2.428/0.059 ms, ipg/ewma 2.000/1.710 ms
> 
> Latency with this series + my patch to inline accessors:
> 
> 100000 packets transmitted, 100000 received, 0% packet loss, time 219ms
> rtt min/avg/max/mdev = 0.874/1.716/3.296/0.058 ms, ipg/ewma 2.000/1.719 ms
> 
> 
> RX throughput without this series (iperf3 -f k -i 0 -c):
> 
> [  5]   0.00-10.00  sec  19.0 MBytes  15958 Kbits/sec                  receiver
> 
> RX throughput with this series:
> 
> [  5]   0.00-10.00  sec  18.4 MBytes  15452 Kbits/sec                  receiver
> 
> RX throughput with this series + my patch to inline accessors:
> 
> [  5]   0.00-10.00  sec  18.5 MBytes  15506 Kbits/sec                  receiver
> 
> 
> TX throughput without this series (iperf3 -R -f k -i 0 -c):
> 
> [  5]   0.00-10.00  sec  18.6 MBytes  15604 Kbits/sec                  receiver
> 
> TX throughput with this series:
> 
> [  5]   0.00-10.00  sec  18.3 MBytes  15314 Kbits/sec                  receiver
> 
> TX throughput with this series + my patch to inline accessors:
> 
> [  5]   0.00-10.00  sec  18.3 MBytes  15349 Kbits/sec                  receiver
> 
> 
> The commands were invoked from a machine with a Broadcom tg3
> Gigabit Ethernet controller.

It would be helpful if we could at least run the same test, so the
results are comparable.

> Conclusion:  The series does incur a measurable performance penalty
> which should be fixed before it gets merged.  Inlining the accessors
> only yields a very small improvement.

OK, so we finally agree on this, thanks.

> I'm wondering where the
> performance penalty is originating from:  Perhaps because of the
> 16-bit read of RXFC in ks8851_rx_pkts()?

Can you patch that part away to see whether that's the case ?

>> So I got the KS8851SNL development kit to test the SPI option. The
>> current driver in linux-next gives me SPI transfer timeouts at 1 MHz (I
>> also tried 6 MHz, 10 MHz, same problem, I also checked the signal
>> quality which is OK) both on iMX6Q and on STM32MP1 with ~2 cm long
>> wiring between the SoM and the KS8851SNL devkit, so that's where my
>> testing ends, sadly. Unless you have some idea what the problem might be ?
> 
> Check the signal quality with an oscilloscope.
> Crank up drive strength of the SPI pins if supported by the pin controller.

I already tried both, got nothing useful.

> Check if the driver for the SPI controller is buggy or somehow limits the
> speed.

I used two different drivers -- the iMX SPI and the STM32 SPI -- I would
say that if both show the same behavior, it's unlikely to be the driver.

> We use the KSZ8851SNL both with STM32-based products (at 20 MHz SPI clock,
> but without an operating system) and with Raspberry Pi based products
> (at up to 25 MHz SPI clock, with Linux).  It is only the latter that
> I'm really familiar with.  We've invested considerable resources to
> fix bugs and speed up the Raspberry Pi's SPI driver as much as possible.
> By now it works pretty well with the ks8851.
> 
> A Raspberry Pi 3 is readily available for just a few Euros, so you may
> want to pick up one of those.  My most recent speed improvements for the
> Raspberry Pi's SPI and DMA drivers went into v5.4, so be sure to use at
> least that.

This is based off linux-next, so that shouldn't be a problem.

I'll try to set up the RPi3 and see if that's any better.

> Should signal quality be a problem, it's possible to
> increase GPIO drive strength by putting a dt-blob.bin in the /boot
> partition:
> 
> https://www.raspberrypi.org/documentation/configuration/pin-configuration.md
> 
> I forgot to test whether reading the MAC address from the external
> EEPROM works with v3 of your series, but I'll be back in the office
> on Tuesday to take another look.

While you're at it, can you take a look at the latency ?
I think you should be able to git-bisect it rather easily.
Thanks
