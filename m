Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id DBFC22347EE
	for <lists+netdev@lfdr.de>; Fri, 31 Jul 2020 16:41:25 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728771AbgGaOlX (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 31 Jul 2020 10:41:23 -0400
Received: from vps0.lunn.ch ([185.16.172.187]:37008 "EHLO vps0.lunn.ch"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726353AbgGaOlX (ORCPT <rfc822;netdev@vger.kernel.org>);
        Fri, 31 Jul 2020 10:41:23 -0400
Received: from andrew by vps0.lunn.ch with local (Exim 4.94)
        (envelope-from <andrew@lunn.ch>)
        id 1k1WDj-007iAt-AF; Fri, 31 Jul 2020 16:41:15 +0200
Date:   Fri, 31 Jul 2020 16:41:15 +0200
From:   Andrew Lunn <andrew@lunn.ch>
To:     Russell King - ARM Linux admin <linux@armlinux.org.uk>
Cc:     Richard Cochran <richardcochran@gmail.com>,
        Florian Fainelli <f.fainelli@gmail.com>,
        Heiner Kallweit <hkallweit1@gmail.com>,
        "David S. Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>, netdev@vger.kernel.org
Subject: Re: [PATCH RFC net-next] net: phy: add Marvell PHY PTP support
 [multicast/DSA issues]
Message-ID: <20200731144115.GF1712415@lunn.ch>
References: <E1jvNlE-0001Y0-47@rmk-PC.armlinux.org.uk>
 <20200729105807.GZ1551@shell.armlinux.org.uk>
 <20200729131932.GA23222@hoboy>
 <20200730110613.GC1551@shell.armlinux.org.uk>
 <20200730115419.GX1605@shell.armlinux.org.uk>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20200730115419.GX1605@shell.armlinux.org.uk>
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

> Hmm, and even with IP_MULTICAST=y, I still can't get the "timestamping"
> program from the kernel sources to work.
> 
> On two different machines, I'm running:
> 
> # ./timestamping32 eno0 SOF_TIMESTAMPING_RX_HARDWARE SOF_TIMESTAMPING_RAW_HARDWARE
> 
> On one machine (arm32) this works - it can see the traffic it generates
> and receives from the other machine.
> 
> On the other machine (arm64), it sees _no_ traffic at all, but tcpdump
> on that machine can see the traffic being received:
> 
> 12:36:40.002065 00:51:82:11:33:03 > 01:00:5e:00:01:82, ethertype IPv4 (0x0800),
> length 166: (tos 0x0, ttl 1, id 15045, offset 0, flags [DF], proto UDP (17), length 152)
>     192.168.3.1.319 > 224.0.1.130.319: [bad udp cksum 0xa5c1 -> 0x7aaa!] UDP, length 124
> 12:36:41.105391 00:50:43:02:03:02 > 01:00:5e:00:01:82, ethertype IPv4 (0x0800),
> length 166: (tos 0x0, ttl 1, id 9715, offset 0, flags [DF], proto UDP (17), length 152)
>     192.168.3.2.319 > 224.0.1.130.319: [udp sum ok] UDP, length 124
> 
> The bad udp cksum is due to checksum offloadong on transmit - 3.1 is the
> arm64 host running that tcpdump.
> 
> When I look at /proc/net/snmp, I can see the IP InReceives incrementing
> but not the IP InDelivers nor UDP InDatagrams counter:
> 
> Ip: 2 64 1602 0 3 0 0 0 297 531 0 46 0 0 0 0 0 0 0
> Udp: 572 0 0 480 0 0 0 4
> Ip: 2 64 1603 0 3 0 0 0 297 531 0 46 0 0 0 0 0 0 0
> Udp: 572 0 0 480 0 0 0 4
> 
> I don't have any firewall rules on the machine.

Hi Russell

A shot in the dark....

I remember somewhere in the stack BPF is used to identify PTP
packets. Is it maybe getting JITed wrongly on arm64? Maybe disable the
BPF JIT and see if it starts working?

    Andrew
