Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 83360479BE3
	for <lists+netdev@lfdr.de>; Sat, 18 Dec 2021 18:38:46 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233612AbhLRRig (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sat, 18 Dec 2021 12:38:36 -0500
Received: from yo2urs.ro ([86.126.81.149]:51860 "EHLO mail.yo2urs.ro"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S229552AbhLRRig (ORCPT <rfc822;netdev@vger.kernel.org>);
        Sat, 18 Dec 2021 12:38:36 -0500
X-Greylist: delayed 927 seconds by postgrey-1.27 at vger.kernel.org; Sat, 18 Dec 2021 12:38:36 EST
Received: by mail.yo2urs.ro (Postfix, from userid 124)
        id E5B4534A7; Sat, 18 Dec 2021 19:23:06 +0200 (EET)
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on server.local.net
X-Spam-Level: 
X-Spam-Status: No, score=-2.9 required=5.0 tests=ALL_TRUSTED,BAYES_00
        autolearn=unavailable autolearn_force=no version=3.4.6
Received: from www.yo2urs.ro (localhost [127.0.0.1])
        by mail.yo2urs.ro (Postfix) with ESMTP id CC50E30B;
        Sat, 18 Dec 2021 19:23:02 +0200 (EET)
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII;
 format=flowed
Content-Transfer-Encoding: 7bit
Date:   Sat, 18 Dec 2021 19:23:02 +0200
From:   Gabriel Hojda <ghojda@yo2urs.ro>
To:     Andrew Lunn <andrew@lunn.ch>
Cc:     Martyn Welch <martyn.welch@collabora.com>, netdev@vger.kernel.org,
        Krzysztof Kozlowski <krzk@kernel.org>,
        Marek Szyprowski <m.szyprowski@samsung.com>,
        Markus Reichl <m.reichl@fivetechno.de>,
        Steve Glendinning <steve.glendinning@shawell.net>,
        UNGLinuxDriver@microchip.com,
        "David S. Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>, stable@kernel.org
Subject: Re: Issues with smsc95xx driver since a049a30fc27c
In-Reply-To: <Yb4QFDQ0rFfFsT+Y@lunn.ch>
References: <199eebbd6b97f52b9119c9fa4fd8504f8a34de18.camel@collabora.com>
 <Yb4QFDQ0rFfFsT+Y@lunn.ch>
User-Agent: Roundcube Webmail/1.4.11
Message-ID: <36f765d8450ba08cb3f8aecab0cadd89@yo2urs.ro>
X-Sender: ghojda@yo2urs.ro
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On 2021-12-18 18:45, Andrew Lunn wrote:
> On Fri, Dec 17, 2021 at 03:45:08PM +0000, Martyn Welch wrote:
>> I've had some reports of the smsc95xx driver failing to work for the
>> ODROID-X2 and ODROID-U3 since a049a30fc27c was merged (also backported
>> to 5.15.y stable branch, which I believe is what those affected by 
>> this
>> are using).
>> 
>> Since then we have performed a number of tests, here's what we've 
>> found
>> so far:
>> 
>> ODROID-U3 (built-in LAN9730):
>> 
>>  - No errors reported from smsc95xx driver, however networking broken
>>    (can not perform DHCP via NetworkManager, Fedora user space).
>> 
>>  - Networking starts working if device forced into promiscuous mode
>>    (Gabriel noticed this whilst running tcpdump)
>> 
>> 
>> ODROID-X2 (built in LAN9514):
>> 
>>  - Networking not brought up (Using Debian Buster and Bullseye with
>> traditional `/etc/network/interfaces` approach).
>> 
>>  - As with Odroid-u3, works when running in promiscuous mode.
> 
> Hi Martyn
> 
> Promisc mode is really odd, given what
> 
> commit a049a30fc27c1cb2e12889bbdbd463dbf750103a
> Author: Martyn Welch <martyn.welch@collabora.com>
> Date:   Mon Nov 22 18:44:45 2021 +0000
> 
>     net: usb: Correct PHY handling of smsc95xx
> 
> does. Has it been confirmed this is really the patch which causes
> the problem?
> 
> Does mii-tool -vvv how any difference between the working and broken
> case?
> 
> Can you also confirm the same PHY driver is used before/after this
> patch. There is a chance one is using a specific PHY driver and the
> other genphy.
> 
>     Andrew

hi Andrew,

on my odroid-u3, with all kernel versions since 5.15.6 (where the patch 
was applied) and also with 5.16.y if tcpdump is running the network 
works. when tcpdump process is killed/stopped, networking stops working.

1. as a test that this is the offending patch, i've recompiled the 
fedora kernel 5.15.7 with the patch reverted and everything was working 
normally as it last worked with 5.15.5

2.1. kernel 5.15.5 - "mii-tool -vvv eth0"

Using SIOCGMIIPHY=0x8947
eth0: negotiated 1000baseT-HD flow-control, link ok
   registers for MII PHY 1:
     3100 782d 0007 c101 01e1 45e1 0001 ffff
     ffff ffff ffff ffff ffff 0000 0000 0000
     0040 0002 00e1 ffff 0000 0000 0000 0000
     0b9d 0000 0000 000a 0000 00c8 0000 1058
   product info: vendor 00:01:f0, model 16 rev 1
   basic mode:   autonegotiation enabled
   basic status: autonegotiation complete, link ok
   capabilities: 1000baseT-HD 1000baseT-FD 100baseTx-FD 100baseTx-HD 
10baseT-FD 10baseT-HD
   advertising:  1000baseT-HD 1000baseT-FD 100baseTx-FD 100baseTx-HD 
10baseT-FD 10baseT-HD
   link partner: 1000baseT-HD 1000baseT-FD 100baseTx-FD 100baseTx-HD 
10baseT-FD 10baseT-HD flow-control

2.2. kernel 5.15.8 - "mii-tool -vvv eth0"

Using SIOCGMIIPHY=0x8947
eth0: negotiated 1000baseT-HD flow-control, link ok
   registers for MII PHY 1:
     3100 782d 0007 c101 01e1 45e1 0003 ffff
     ffff ffff ffff ffff ffff 0000 0000 0000
     0040 0002 00e1 ffff 0000 0000 0000 0000
     0b9d 0000 0000 000a 0000 00c8 0000 1058
   product info: vendor 00:01:f0, model 16 rev 1
   basic mode:   autonegotiation enabled
   basic status: autonegotiation complete, link ok
   capabilities: 1000baseT-HD 1000baseT-FD 100baseTx-FD 100baseTx-HD 
10baseT-FD 10baseT-HD
   advertising:  1000baseT-HD 1000baseT-FD 100baseTx-FD 100baseTx-HD 
10baseT-FD 10baseT-HD
   link partner: 1000baseT-HD 1000baseT-FD 100baseTx-FD 100baseTx-HD 
10baseT-FD 10baseT-HD flow-control

3.1 kernel 5.15.5 - "dmesg | grep -i phy"

[    0.000000] Booting Linux on physical CPU 0xa00
[    0.000000] GIC physical location is 0x10490000
[    2.290065] libphy: Fixed MDIO Bus: probed
[    6.763235] samsung-usb2-phy 125b0000.exynos-usbphy: supply vbus not 
found, using dummy regulator
[    8.045968] libphy: smsc95xx-mdiobus: probed
[   23.261816] Generic PHY usb-001:002:01: attached PHY driver 
(mii_bus:phy_addr=usb-001:002:01, irq=POLL)

3.1 kernel 5.15.8 - "dmesg | grep -i phy"

[    0.000000] Booting Linux on physical CPU 0xa00
[    0.000000] GIC physical location is 0x10490000
[    3.291292] libphy: Fixed MDIO Bus: probed
[   10.198145] samsung-usb2-phy 125b0000.exynos-usbphy: supply vbus not 
found, using dummy regulator
[   11.740943] libphy: smsc95xx-mdiobus: probed
[   11.742916] Generic PHY usb-001:002:01: attached PHY driver 
(mii_bus:phy_addr=usb-001:002:01, irq=POLL)

