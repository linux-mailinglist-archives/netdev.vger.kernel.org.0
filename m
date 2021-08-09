Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id C055E3E49CB
	for <lists+netdev@lfdr.de>; Mon,  9 Aug 2021 18:28:22 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232779AbhHIQ2l (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 9 Aug 2021 12:28:41 -0400
Received: from tulum.helixd.com ([162.252.81.98]:49720 "EHLO tulum.helixd.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S229812AbhHIQ2k (ORCPT <rfc822;netdev@vger.kernel.org>);
        Mon, 9 Aug 2021 12:28:40 -0400
Received: from [IPv6:2600:8801:8800:12e8:2967:9ef1:6ba6:199a] (unknown [IPv6:2600:8801:8800:12e8:2967:9ef1:6ba6:199a])
        (using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
        (Client did not present a certificate)
        (Authenticated sender: dalcocer@helixd.com)
        by tulum.helixd.com (Postfix) with ESMTPSA id AFD5520673;
        Mon,  9 Aug 2021 09:28:14 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=tulum.helixd.com;
        s=mail; t=1628526494;
        bh=qHqwty/y7gVQn6wpSVogHSkMe1gLQgqveZVTFmNii7s=;
        h=Subject:To:Cc:References:From:Date:In-Reply-To:From;
        b=qqG3Rwe0XZWfZoKtIh5X3W4wzmOkGMJGx9beprAF3DoTm1FdFeq7mbRL7eA2LVt4K
         +drwF1rxV8sqYNTp78M/h69wDa0YjjAC2plnCdV/TZTbGoyqVl6AeF3yf2aSbn70mf
         9/BA/1GDYAM5YjTj93px1RyGTPQQ1ojLYWhQkqFE=
Subject: Re: Marvell switch port shows LOWERLAYERDOWN, ping fails
To:     Andrew Lunn <andrew@lunn.ch>
Cc:     netdev@vger.kernel.org
References: <bcd589bd-eeb4-478c-127b-13f613fdfebc@helixd.com>
 <527bcc43-d99c-f86e-29b0-2b4773226e38@helixd.com>
 <fb7ced72-384c-9908-0a35-5f425ec52748@helixd.com> <YQGgvj2e7dqrHDCc@lunn.ch>
 <59790fef-bf4a-17e5-4927-5f8d8a1645f7@helixd.com> <YQGu2r02XdMR5Ajp@lunn.ch>
 <11b81662-e9ce-591c-122a-af280f1e1f59@helixd.com>
 <fea36eed-eaff-4381-b2fd-628b60237aab@helixd.com>
 <de5758c6-4379-1b70-19ff-d6dd2b3ea269@helixd.com>
 <4902bb0e-87ad-3fa4-f7af-bbe7b43ad68f@helixd.com> <YQ7Xo3UII/1Gw/G1@lunn.ch>
From:   Dario Alcocer <dalcocer@helixd.com>
Message-ID: <ac33ec5f-568e-e43c-5d58-48876a7d9b0d@helixd.com>
Date:   Mon, 9 Aug 2021 09:28:13 -0700
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:78.0) Gecko/20100101
 Thunderbird/78.11.0
MIME-Version: 1.0
In-Reply-To: <YQ7Xo3UII/1Gw/G1@lunn.ch>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On 8/7/21 11:57 AM, Andrew Lunn wrote:
> On Fri, Aug 06, 2021 at 04:46:08PM -0700, Dario Alcocer wrote:
>> Any ideas on how to get ICMP working, using the DSA single-port
>> configuration example, are welcome.
> 
> Take a look at the port statistics. ethtool -S lan1 ? Do the counters
> show the packets being sent out? They are probably broadcast packets,
> ARP, not unicast ICMP.
> 
> Also ethtool -S eth0
> 
> At the end of the list, you see statistics for the CPU port.
> 
>     Andrew
> 

Andrew,

Well, I discovered that what I thought was physically lan1 was actually 
lan4, just as you had mentioned in an earlier message. :-)

The ping test is working now with the lan4 link peer.

However, I did notice something interesting in the output from 
mv88e6xxx_dump for the DSA ports. Apparently, the SERDES link between 
the two switch chips is not passing traffic, since no frames are 
received by either chip (note the "RX frame count" values below.) 
Interestingly, both DSA ports report link is up, but that may be because :

root@dali:~# mv88e6xxx_dump --port 4 --device mdio_bus/stmmac-0:1a
00 Port status                            0x1e0f
       Pause Enabled                        0
       My Pause                             0
       802.3 PHY Detected                   1
       Link Status                          Up
       Duplex                               Full
       Speed                                1000 Mbps
       EEE Enabled                          0
       Transmitter Paused                   0
       Flow Control                         0
       Config Mode                          0xf
01 Physical control                       0x003e
       RGMII Receive Timing Control         Default
       RGMII Transmit Timing Control        Default
       200 BASE Mode                        100
       Flow Control's Forced value          0
       Force Flow Control                   0
       Link's Forced value                  Up
       Force Link                           1
       Duplex's Forced value                Full
       Force Duplex                         1
       Force Speed                          1000 Mbps
...
04 Port control                           0x053f
       Source Address Filtering controls    Disabled
       Egress Mode                          Unmodified
       Ingress & Egress Header Mode         0
       IGMP and MLD Snooping                1
       Frame Mode                           DSA
...
13 RX frame count                         0x0000
...
root@dali:~# mv88e6xxx_dump --port 4 --device mdio_bus/stmmac-0:1e
00 Port status                            0x1e0f
       Pause Enabled                        0
       My Pause                             0
       802.3 PHY Detected                   1
       Link Status                          Up
       Duplex                               Full
       Speed                                1000 Mbps
       EEE Enabled                          0
       Transmitter Paused                   0
       Flow Control                         0
       Config Mode                          0xf
01 Physical control                       0x003e
       RGMII Receive Timing Control         Default
       RGMII Transmit Timing Control        Default
       200 BASE Mode                        100
       Flow Control's Forced value          0
       Force Flow Control                   0
       Link's Forced value                  Up
       Force Link                           1
       Duplex's Forced value                Full
       Force Duplex                         1
       Force Speed                          1000 Mbps
...
04 Port control                           0x053f
       Source Address Filtering controls    Disabled
       Egress Mode                          Unmodified
       Ingress & Egress Header Mode         0
       IGMP and MLD Snooping                1
       Frame Mode                           DSA
...
13 RX frame count                         0x0000
...

This probably explains why the none of the ports on the first chip 
(lan1, lan2, and lan3) work when running the ping test.

I will need to check with the hardware folks. The schematic indicates 
some DNP parts that may, in fact, have not been installed. ;-)

