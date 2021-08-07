Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id BB0683E36DF
	for <lists+netdev@lfdr.de>; Sat,  7 Aug 2021 20:57:42 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229743AbhHGS56 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sat, 7 Aug 2021 14:57:58 -0400
Received: from vps0.lunn.ch ([185.16.172.187]:38380 "EHLO vps0.lunn.ch"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S229464AbhHGS56 (ORCPT <rfc822;netdev@vger.kernel.org>);
        Sat, 7 Aug 2021 14:57:58 -0400
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed; d=lunn.ch;
        s=20171124; h=In-Reply-To:Content-Disposition:Content-Type:MIME-Version:
        References:Message-ID:Subject:Cc:To:From:Date:From:Sender:Reply-To:Subject:
        Date:Message-ID:To:Cc:MIME-Version:Content-Type:Content-Transfer-Encoding:
        Content-ID:Content-Description:Content-Disposition:In-Reply-To:References;
        bh=wmcbPGlfQt2NINMDV6odu8iLXe9HYA9cpbbrKmGFQiE=; b=wOSCbWtub/t1SOhuhQmOFY6GBQ
        46dGUAGCwmJxNhrt/QJ4fJMaJMXpIAWpxwkz35+gwxOHA1Pj5uYYQBp892288qox0ElISYeTju98K
        d+3lrsMuTdZWw2bdvtGMuf+9dw5ubLSNwjTESzAkzqLqdP7ol1mvhQSTlssnlCD996DE=;
Received: from andrew by vps0.lunn.ch with local (Exim 4.94.2)
        (envelope-from <andrew@lunn.ch>)
        id 1mCRVr-00GVuP-4U; Sat, 07 Aug 2021 20:57:39 +0200
Date:   Sat, 7 Aug 2021 20:57:39 +0200
From:   Andrew Lunn <andrew@lunn.ch>
To:     Dario Alcocer <dalcocer@helixd.com>
Cc:     netdev@vger.kernel.org
Subject: Re: Marvell switch port shows LOWERLAYERDOWN, ping fails
Message-ID: <YQ7Xo3UII/1Gw/G1@lunn.ch>
References: <bcd589bd-eeb4-478c-127b-13f613fdfebc@helixd.com>
 <527bcc43-d99c-f86e-29b0-2b4773226e38@helixd.com>
 <fb7ced72-384c-9908-0a35-5f425ec52748@helixd.com>
 <YQGgvj2e7dqrHDCc@lunn.ch>
 <59790fef-bf4a-17e5-4927-5f8d8a1645f7@helixd.com>
 <YQGu2r02XdMR5Ajp@lunn.ch>
 <11b81662-e9ce-591c-122a-af280f1e1f59@helixd.com>
 <fea36eed-eaff-4381-b2fd-628b60237aab@helixd.com>
 <de5758c6-4379-1b70-19ff-d6dd2b3ea269@helixd.com>
 <4902bb0e-87ad-3fa4-f7af-bbe7b43ad68f@helixd.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <4902bb0e-87ad-3fa4-f7af-bbe7b43ad68f@helixd.com>
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Fri, Aug 06, 2021 at 04:46:08PM -0700, Dario Alcocer wrote:
> Andrew,
> 
> Using 5.13.8 resolves the LOWERLAYERDOWN issue I observed when bringing up a
> slave interface on 5.4.114. The interface comes up after a 15-second delay,
> with the Marvell PHY driver reporting a downshift event:
> 
> root@dali:~# ip addr add 192.0.2.1/24 dev lan1
> root@dali:~# ip link set lan1 up
> [  264.992698] socfpga-dwmac ff700000.ethernet eth0: Register
> MEM_TYPE_PAGE_POOL RxQ-0
> [  264.997303] socfpga-dwmac ff700000.ethernet eth0: No Safety Features
> support found
> [  264.998167] socfpga-dwmac ff700000.ethernet eth0: IEEE 1588-2008 Advanced
> Timestamp supported
> [  264.999357] socfpga-dwmac ff700000.ethernet eth0: registered PTP clock
> [  265.000804] socfpga-dwmac ff700000.ethernet eth0: configuring for
> fixed/gmii link mode
> [  265.002542] socfpga-dwmac ff700000.ethernet eth0: Link is Up - 1Gbps/Full
> - flow control rx/tx
> [  265.007121] mv88e6085 stmmac-0:1a lan1: configuring for phy/gmii link
> mode
> [  265.015320] 8021q: adding VLAN 0 to HW filter on device lan1
> [  265.016921] IPv6: ADDRCONF(NETDEV_CHANGE): eth0: link becomes ready
> root@dali:~# [  280.856989] Marvell 88E1540 mv88e6xxx-0:00: Downshift
> occurred from negotiated speed 1Gbps to actual speed 100Mbps, check cabling!

Humm, interesting. Two things pop to mind:

There is probably something wrong with your hardware. 1G requires 4
working pairs in the cable. If one pair is broken, the PHY will keep
trying to establish link, and fail. It will retry this a number of
times, and then drop to 100Mbps. That only requires 2 working pairs.
So get your hardware person to check the wiring from the switch to the
RJ-45 socket, and your cable.

Does the switch know the port is actually running at 100Mbps? 

> Detailed info from switch 0, port 0, corresponding to lan1 port:
> 
> root@dali:~# mv88e6xxx_dump --port 0 --device mdio_bus/stmmac-0:1a
> 00 Port status                            0x9d0f
>       Pause Enabled                        1
>       My Pause                             0
>       802.3 PHY Detected                   1
>       Link Status                          Up
>       Duplex                               Full
>       Speed                                100 or 200 Mbps
>       EEE Enabled                          0
>       Transmitter Paused                   0
>       Flow Control                         0
>       Config Mode                          0xf

O.K, so it does know the port is running at 100Mbps.

> Any ideas on how to get ICMP working, using the DSA single-port
> configuration example, are welcome.

Take a look at the port statistics. ethtool -S lan1 ? Do the counters
show the packets being sent out? They are probably broadcast packets,
ARP, not unicast ICMP.

Also ethtool -S eth0

At the end of the list, you see statistics for the CPU port.

   Andrew
