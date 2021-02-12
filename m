Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 7135B319756
	for <lists+netdev@lfdr.de>; Fri, 12 Feb 2021 01:21:26 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229873AbhBLATs (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 11 Feb 2021 19:19:48 -0500
Received: from 95-165-96-9.static.spd-mgts.ru ([95.165.96.9]:33552 "EHLO
        blackbox.su" rhost-flags-OK-FAIL-OK-OK) by vger.kernel.org with ESMTP
        id S229553AbhBLATq (ORCPT <rfc822;netdev@vger.kernel.org>);
        Thu, 11 Feb 2021 19:19:46 -0500
Received: from metamini.metanet (metamini.metanet [192.168.2.5])
        by blackbox.su (Postfix) with ESMTP id 68B3A81451;
        Fri, 12 Feb 2021 03:18:54 +0300 (MSK)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=blackbox.su; s=mail;
        t=1613089134; bh=dMMXvZBKh3B1P5IFKOKHNMulx8E6cVOMfX22y9rCKJU=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=GP24pCzxZdw/cDX7ymJb1LgYYfD6Ygui60rtcCeNd4aF5Ur7pNZAHVjbvcTE+exD1
         f0vJD4DbDzypu4pwHpGQ7LxQ2r6+/51VXZi6XzCyE+Xda5Lnh5GKr6dGH60tD/+OX5
         XCDPozEyB9ypItBYLq1uwwNPu/EIEBqCSAY5kwvCBfN77OsS+vvp6cYgwQenlzzQ9j
         bLn6gPEn2NwB6O0vBk+9w0orIVKODRw0PN65ipyPHeYTP2lul7abkDu3Ing3tHSS/N
         HA/pTQ0fMN3d61WAhLbDrSURdicoB7IoQkD0RFOFm/gg13/Ng5UjgJM9DXGWZ0ozje
         uYSf/Bk8fa1ZQ==
From:   Sergej Bauer <sbauer@blackbox.su>
To:     thesven73@gmail.com
Cc:     andrew@lunn.ch, Markus.Elfring@web.de, rtgbnm@gmail.com,
        tharvey@gateworks.com, anders@ronningen.priv.no,
        sbauer@blackbox.su,
        Bryan Whitehead <bryan.whitehead@microchip.com>,
        UNGLinuxDriver@microchip.com (maintainer:MICROCHIP LAN743X ETHERNET
        DRIVER), "David S. Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>,
        netdev@vger.kernel.org (open list:MICROCHIP LAN743X ETHERNET DRIVER),
        linux-kernel@vger.kernel.org (open list)
Subject: Re: [PATCH net-next v2 1/5] lan743x: boost performance on cpu archs w/o dma cache snooping
Date:   Fri, 12 Feb 2021 03:18:52 +0300
Message-Id: <20210212001852.18042-1-sbauer@blackbox.su>
X-Mailer: git-send-email 2.20.1
In-Reply-To: <20210211161830.17366-2-TheSven73@gmail.com>
References: <20210211161830.17366-2-TheSven73@gmail.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Thursday, February 11, 2021 7:18:26 PM MSK you wrote:
> From: Sven Van Asbroeck <thesven73@gmail.com>
> 
> The buffers in the lan743x driver's receive ring are always 9K,
> even when the largest packet that can be received (the mtu) is
> much smaller. This performs particularly badly on cpu archs
> without dma cache snooping (such as ARM): each received packet
> results in a 9K dma_{map|unmap} operation, which is very expensive
> because cpu caches need to be invalidated.
> 
> Careful measurement of the driver rx path on armv7 reveals that
> the cpu spends the majority of its time waiting for cache
> invalidation.
> 
> Optimize by keeping the rx ring buffer size as close as possible
> to the mtu. This limits the amount of cache that requires
> invalidation.
> 
> This optimization would normally force us to re-allocate all
> ring buffers when the mtu is changed - a disruptive event,
> because it can only happen when the network interface is down.
> 
> Remove the need to re-allocate all ring buffers by adding support
> for multi-buffer frames. Now any combination of mtu and ring
> buffer size will work. When the mtu changes from mtu1 to mtu2,
> consumed buffers of size mtu1 are lazily replaced by newly
> allocated buffers of size mtu2.
> 
> These optimizations double the rx performance on armv7.
> Third parties report 3x rx speedup on armv8.
> 
> Tested with iperf3 on a freescale imx6qp + lan7430, both sides
> set to mtu 1500 bytes, measure rx performance:
> 
> Before:
> [ ID] Interval           Transfer     Bandwidth       Retr
> [  4]   0.00-20.00  sec   550 MBytes   231 Mbits/sec    0
> After:
> [ ID] Interval           Transfer     Bandwidth       Retr
> [  4]   0.00-20.00  sec  1.33 GBytes   570 Mbits/sec    0
> 
> Signed-off-by: Sven Van Asbroeck <thesven73@gmail.com>
> ---

( for the reference to current speed, response to v1 of the patch can be found at
https://lkml.org/lkml/2021/2/5/472 )

Hi Sven
although whole set of tests might be an overly extensive, but after applying patch v2 [1/5]
tests are:
sbauer@metamini ~/devel/kernel-works/net-next.git lan743x_virtual_phy$ ifmtu eth7 500
mtu =  500
sbauer@metamini ~/devel/kernel-works/net-next.git lan743x_virtual_phy$ sudo test_ber -l eth7 -c 1000 -n 1000000 -f500 --no-conf
...
number of sent packets      = 1000000
number of received packets  = 747411
number of lost packets = 252589
number of out of order packets = 0
number of bit errors   = 0
total errors detected  = 252589
bit error rate         = 0.252589
average speed: 408.0757 Mbit/s

...
number of sent packets      = 1000000
number of received packets  = 738377
number of lost packets = 261623
number of out of order packets = 0
number of bit errors   = 0
total errors detected  = 261623
bit error rate         = 0.261623
average speed: 413.1470 Mbit/s

...
number of sent packets      = 1000000
number of received packets  = 738142
number of lost packets = 261858
number of out of order packets = 0
number of bit errors   = 0
total errors detected  = 261858
bit error rate         = 0.261858
average speed: 413.2262 Mbit/s

...
number of sent packets      = 1000000
number of received packets  = 708973
number of lost packets = 291027
number of out of order packets = 0
number of bit errors   = 0
total errors detected  = 291027
bit error rate         = 0.291027
average speed: 430.6224 Mbit/s

...
number of sent packets      = 1000000
number of received packets  = 725452
number of lost packets = 274548
number of out of order packets = 0
number of bit errors   = 0
total errors detected  = 274548
bit error rate         = 0.274548
average speed: 420.7341 Mbit/s

sbauer@metamini ~/devel/kernel-works/net-next.git lan743x_virtual_phy$ ifmtu eth7 1500
mtu =  1500
sbauer@metamini ~/devel/kernel-works/net-next.git lan743x_virtual_phy$ sudo test_ber -l eth7 -c 1000 -n 1000000 -f500 --no-conf
...
number of sent packets      = 1000000
number of received packets  = 714228
number of lost packets = 285772
number of out of order packets = 0
number of bit errors   = 0
total errors detected  = 285772
bit error rate         = 0.285772
average speed: 427.1300 Mbit/s

...
number of sent packets      = 1000000
number of received packets  = 750055
number of lost packets = 249945
number of out of order packets = 0
number of bit errors   = 0
total errors detected  = 249945
bit error rate         = 0.249945
average speed: 405.0383 Mbit/s

...
number of sent packets      = 1000000
number of received packets  = 689458
number of lost packets = 310542
number of out of order packets = 0
number of bit errors   = 0
total errors detected  = 310542
bit error rate         = 0.310542
average speed: 442.5301 Mbit/s

number of sent packets      = 1000000
number of received packets  = 676830
number of lost packets = 323170
number of out of order packets = 0
number of bit errors   = 0
total errors detected  = 323170
bit error rate         = 0.32317
average speed: 450.9439 Mbit/s

number of sent packets      = 1000000
number of received packets  = 701719
number of lost packets = 298281
number of out of order packets = 0
number of bit errors   = 0
total errors detected  = 298281
bit error rate         = 0.298281
average speed: 434.7563 Mbit/s

sbauer@metamini ~/devel/kernel-works/net-next.git lan743x_virtual_phy$ sudo test_ber -l eth7 -c 1000 -n 1000000 -f1500 --no-conf
...
number of sent packets      = 1000000
number of received packets  = 1000000
number of lost packets = 0
number of out of order packets = 0
number of bit errors   = 0
total errors detected  = 0
bit error rate         = 0
average speed: 643.5758 Mbit/s

...
number of sent packets      = 1000000
number of received packets  = 1000000
number of lost packets = 0
number of out of order packets = 0
number of bit errors   = 0
total errors detected  = 0
bit error rate         = 0
average speed: 644.7713 Mbit/s

...
number of sent packets      = 1000000
number of received packets  = 1000000
number of lost packets = 0
number of out of order packets = 0
number of bit errors   = 0
total errors detected  = 0
bit error rate         = 0
average speed: 645.4407 Mbit/s

...
number of sent packets      = 1000000
number of received packets  = 1000000
number of lost packets = 0
number of out of order packets = 0
number of bit errors   = 0
total errors detected  = 0
bit error rate         = 0
average speed: 645.6741 Mbit/s

...
number of sent packets      = 1000000
number of received packets  = 1000000
number of lost packets = 0
number of out of order packets = 0
number of bit errors   = 0
total errors detected  = 0
bit error rate         = 0
average speed: 646.0109 Mbit/s

sbauer@metamini ~/devel/kernel-works/net-next.git lan743x_virtual_phy$ ifmtu eth7 9216
mtu =  9216
bauer@metamini ~/devel/kernel-works/net-next.git lan743x_virtual_phy$ sudo test_ber -l eth7 -c 1000 -n 1000000 -f1500 --no-conf
...
number of sent packets      = 1000000
number of received packets  = 575141
number of lost packets = 424859
number of out of order packets = 0
number of bit errors   = 0
total errors detected  = 424859
bit error rate         = 0.424859
average speed: 646.7859 Mbit/s

...
number of sent packets      = 1000000
number of received packets  = 583353
number of lost packets = 416647
number of out of order packets = 0
number of bit errors   = 0
total errors detected  = 416647
bit error rate         = 0.416647
average speed: 637.8472 Mbit/s

...
number of sent packets      = 1000000
number of received packets  = 577127
number of lost packets = 422873
number of out of order packets = 0
number of bit errors   = 0
total errors detected  = 422873
bit error rate         = 0.422873
average speed: 644.5562 Mbit/s

...
number of sent packets      = 1000000
number of received packets  = 576916
number of lost packets = 423084
number of out of order packets = 0
number of bit errors   = 0
total errors detected  = 423084
bit error rate         = 0.423084
average speed: 644.8260 Mbit/s

...
number of sent packets      = 1000000
number of received packets  = 577154
number of lost packets = 422846
number of out of order packets = 0
number of bit errors   = 0
total errors detected  = 422846
bit error rate         = 0.422846
average speed: 644.6815 Mbit/s

sbauer@metamini ~/devel/kernel-works/net-next.git lan743x_virtual_phy$ sudo test_ber -l eth7 -c 1000 -n 1000000 -f9216 --no-conf
...
number of sent packets      = 1000000
number of received packets  = 1000000
number of lost packets = 0
number of out of order packets = 0
number of bit errors   = 0
total errors detected  = 0
bit error rate         = 0
average speed: 775.2005 Mbit/s

...
number of sent packets      = 1000000
number of received packets  = 999998
number of lost packets = 2
number of out of order packets = 0
number of bit errors   = 0
total errors detected  = 2
bit error rate         = 2e-06
average speed: 775.0468 Mbit/

...
number of sent packets      = 1000000
number of received packets  = 999998
number of lost packets = 2
number of out of order packets = 0
number of bit errors   = 0
total errors detected  = 2
bit error rate         = 2e-06
average speed: 775.2150 Mbit/s

...
number of sent packets      = 1000000
number of received packets  = 999997
number of lost packets = 3
number of out of order packets = 0
number of bit errors   = 0
total errors detected  = 3
bit error rate         = 3e-06
average speed: 775.2666 Mbit/s

...
number of sent packets      = 1000000
number of received packets  = 999999
number of lost packets = 1
number of out of order packets = 0
number of bit errors   = 0
total errors detected  = 1
bit error rate         = 1e-06
average speed: 775.2182 Mbit/s

