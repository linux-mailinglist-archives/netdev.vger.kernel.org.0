Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 5709F203FF0
	for <lists+netdev@lfdr.de>; Mon, 22 Jun 2020 21:17:04 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728174AbgFVTRC (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 22 Jun 2020 15:17:02 -0400
Received: from mail.bugwerft.de ([46.23.86.59]:58306 "EHLO mail.bugwerft.de"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726308AbgFVTRC (ORCPT <rfc822;netdev@vger.kernel.org>);
        Mon, 22 Jun 2020 15:17:02 -0400
Received: from [192.168.178.106] (p57bc9787.dip0.t-ipconnect.de [87.188.151.135])
        by mail.bugwerft.de (Postfix) with ESMTPSA id 4E21642B88B;
        Mon, 22 Jun 2020 19:17:00 +0000 (UTC)
Subject: Re: [PATCH] net: dsa: mv88e6xxx: Allow MAC configuration for ports
 with internal PHY
To:     Russell King - ARM Linux admin <linux@armlinux.org.uk>
Cc:     Andrew Lunn <andrew@lunn.ch>, netdev@vger.kernel.org,
        vivien.didelot@gmail.com, f.fainelli@gmail.com
References: <20200622183443.3355240-1-daniel@zonque.org>
 <20200622184115.GE405672@lunn.ch>
 <b8a67f7d-9854-9854-3f53-983dd4eb8fda@zonque.org>
 <20200622185837.GN1551@shell.armlinux.org.uk>
From:   Daniel Mack <daniel@zonque.org>
Message-ID: <bb89fbef-bde7-2a7f-9089-bbe86323dd63@zonque.org>
Date:   Mon, 22 Jun 2020 21:16:59 +0200
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:68.0) Gecko/20100101
 Thunderbird/68.8.0
MIME-Version: 1.0
In-Reply-To: <20200622185837.GN1551@shell.armlinux.org.uk>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Hi Russell,

On 6/22/20 8:58 PM, Russell King - ARM Linux admin wrote:
> On Mon, Jun 22, 2020 at 08:44:51PM +0200, Daniel Mack wrote:
>> On 6/22/20 8:41 PM, Andrew Lunn wrote:

>>> How are you trying to change the speed?
>>
>> With ethtool for instance. But all userspace tools are bailing out early
>> on this port for the reason I described.
> 
> A simple "return" to ignore a call in a void function won't have that
> effect.

It has the effect that mv88e6xxx_port_setup_mac() is currently not being
called from mv88e6xxx_mac_config().

> I don't see an issue here:
> 
> # ethtool -s lan1 autoneg off speed 10 duplex half

I've tried that of course, but that doesn't fix the problem here. Which
switch port does 'lan1' map to in your setup? My CPU port maps to port 4.

Correct me if I'm mistaken, but speed and duplex settings are only being
communicated to the MAC driver through the aforementioned chain of
calls, right?

> I've also been able to change what is advertised just fine, and the
> link comes up as expected - in fact, I was running one of the switch
> ports at 10Mbps to one of my machines and using the 'scope on the
> ethernet signals over the weekend to debug a problem, which turned
> out to be broken RGMII clock delay timings.

To recap, my setup features a Cadence GEM that is connected to a 88E1510
PHY which is then connected to port 4 of the switch (which has an
internal PHY) through a transformer-less link. I know this is not
optimal as the speed is limited to 100M by that, but that was the only
way as all other ports where used up.

The setup works just fine in principle, I'm just struggling with a
correct way of configuring the drivers to allow that setting.

I can control what is advertised on eth0, which is the GEM, and the PHY
there reports the correct link speed:


# ethtool -s eth0 advertise 0x008
[   79.573992] macb e000b000.ethernet eth0: Link is Down
[   79.637048] mv88e6085 e000b000.ethernet-ffffffff:02: Link is Down
[   81.221974] macb e000b000.ethernet eth0: Link is Up - 100Mbps/Full -
flow control off
[   81.285639] mv88e6085 e000b000.ethernet-ffffffff:02: Link is Up -
100Mbps/Full - flow control off

However, the MAC in the switch is not changed by that, and it was forced
to 1 Gbit at probe time of the driver. Hence no packets are being seen
by the GEM, even though the PHYs seem to see each other just fine
(traffic is also signaled by an LED on the 88E1510).

I'm happy to try other solutions of course.


Thanks,
Daniel
