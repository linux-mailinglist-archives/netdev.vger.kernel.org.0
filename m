Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 0C2A8482355
	for <lists+netdev@lfdr.de>; Fri, 31 Dec 2021 11:27:23 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230102AbhLaK1T (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 31 Dec 2021 05:27:19 -0500
Received: from relay2-d.mail.gandi.net ([217.70.183.194]:63203 "EHLO
        relay2-d.mail.gandi.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230109AbhLaK1S (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 31 Dec 2021 05:27:18 -0500
Received: (Authenticated sender: alexandre.belloni@bootlin.com)
        by relay2-d.mail.gandi.net (Postfix) with ESMTPSA id 376DE40003;
        Fri, 31 Dec 2021 10:27:17 +0000 (UTC)
Date:   Fri, 31 Dec 2021 11:27:16 +0100
From:   Alexandre Belloni <alexandre.belloni@bootlin.com>
To:     Colin Foster <colin.foster@in-advantage.com>
Cc:     netdev@vger.kernel.org, Vladimir Oltean <olteanv@gmail.com>,
        Horatiu Vultur <horatiu.vultur@microchip.com>
Subject: Re: packets trickling out of STP-blocked ports
Message-ID: <Yc7bBLupVUQC9b3X@piout.net>
References: <20211230230740.GA1510894@euler>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20211230230740.GA1510894@euler>
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Hi,

On 30/12/2021 15:07:40-0800, Colin Foster wrote:
> Hi all,
> 
> I'm not sure who all to include in this email, but I'm starting with
> this list to start.
> 
> Probably obvious to those in this email list, I'm testing a VSC7512 dev
> board controlled via SPI. The patches are still out-of-tree, but I
> figured I'll report these findings, since they seem real.
> 
> My setup is port 0 of the 7512 is tied to a Beaglebone Black. Port 1 is
> tied to my development PC. Ports 2 and 3 are tied together to test STP.
> 
> I run the commands:
> 
> ip link set eth0 up
> ip link set swp[1-3] up
> ip link add name br0 type bridge stp_state 1
> ip link set dev swp[1-3] master br0
> ip addr add 10.100.3.1/16 dev br0
> ip link set dev br0 up
> 
> After running this, the STP blocks swp3, and swp1/2 are forwarding.
> 
> Periodically I see messages saying that swp2 is receiving packets with
> own address as source address.
> 
> I can confirm that via ethtool that TX packets are increasing on swp3. I
> believe I captured the event via tshark. A 4 minute capture showed three
> non-STP packets on swp2. All three of these packets are ICMPv6 Router
> Solicitation packets. 
> 
> I would expect no packets at all to egress swp3. Is this an issue that
> is unique to me and my in-development configuration? Or is this an issue
> with all Ocelot / Felix devices?
> 
> If this is an Ocelot thing, I can try to come up with a different test 
> setup to capture more data... printing the packet when it is received,
> capturing the traffic externally, capturing eth0 traffic to see if it is
> coming from the kernel or being hardware-forwarded...
> 
> (side note - if there's a place where a parser for Ocelot NPI traffic is
> hidden, that might eventually save me a lot of debugging in Lua)
> 
> 
> An idea of how frequently this happens - my system has been currently up
> for 3700 seconds. Eight "own address as source address" events have
> happened at 66, 96, 156, 279, 509, 996, 1897, and 3699 seconds. 
> 

This is something I solved back in 2017. I can exactly remember how, you
can try:

sysctl -w net.ipv6.conf.swp3.autoconf=0


-- 
Alexandre Belloni, co-owner and COO, Bootlin
Embedded Linux and Kernel engineering
https://bootlin.com
