Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id F2DB52A2863
	for <lists+netdev@lfdr.de>; Mon,  2 Nov 2020 11:36:27 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728414AbgKBKgV (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 2 Nov 2020 05:36:21 -0500
Received: from mailout12.rmx.de ([94.199.88.78]:41513 "EHLO mailout12.rmx.de"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1728005AbgKBKgV (ORCPT <rfc822;netdev@vger.kernel.org>);
        Mon, 2 Nov 2020 05:36:21 -0500
Received: from kdin02.retarus.com (kdin02.dmz1.retloc [172.19.17.49])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mailout12.rmx.de (Postfix) with ESMTPS id 4CPq8H5S7FzRlqj;
        Mon,  2 Nov 2020 11:36:15 +0100 (CET)
Received: from mta.arri.de (unknown [217.111.95.66])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-SHA384 (256/256 bits))
        (No client certificate requested)
        by kdin02.retarus.com (Postfix) with ESMTPS id 4CPq830KPnz2TTMl;
        Mon,  2 Nov 2020 11:36:03 +0100 (CET)
Received: from n95hx1g2.localnet (192.168.54.112) by mta.arri.de
 (192.168.100.104) with Microsoft SMTP Server (TLS) id 14.3.487.0; Mon, 2 Nov
 2020 11:35:01 +0100
From:   Christian Eggers <ceggers@arri.de>
To:     Vladimir Oltean <olteanv@gmail.com>
CC:     Richard Cochran <richardcochran@gmail.com>,
        Florian Fainelli <f.fainelli@gmail.com>,
        Andrew Lunn <andrew@lunn.ch>,
        Vivien Didelot <vivien.didelot@gmail.com>,
        Jakub Kicinski <kuba@kernel.org>,
        Rob Herring <robh+dt@kernel.org>,
        Helmut Grohne <helmut.grohne@intenta.de>,
        Paul Barker <pbarker@konsulko.com>,
        Codrin Ciubotariu <codrin.ciubotariu@microchip.com>,
        George McCollister <george.mccollister@gmail.com>,
        Marek Vasut <marex@denx.de>,
        Tristram Ha <Tristram.Ha@microchip.com>,
        "David S . Miller" <davem@davemloft.net>,
        Woojung Huh <woojung.huh@microchip.com>,
        "Microchip Linux Driver Support" <UNGLinuxDriver@microchip.com>,
        <netdev@vger.kernel.org>, <devicetree@vger.kernel.org>,
        <linux-kernel@vger.kernel.org>
Subject: Re: [RFC PATCH net-next 7/9] net: dsa: microchip: ksz9477: add hardware time stamping support
Date:   Mon, 2 Nov 2020 11:35:00 +0100
Message-ID: <1779456.uGjeJ53Q7B@n95hx1g2>
Organization: Arnold & Richter Cine Technik GmbH & Co. Betriebs KG
In-Reply-To: <20201101234149.rrhrjiyt7l4orkm7@skbuf>
References: <20201019172435.4416-1-ceggers@arri.de> <3355013.oZEI4y40TO@n95hx1g2> <20201101234149.rrhrjiyt7l4orkm7@skbuf>
MIME-Version: 1.0
Content-Transfer-Encoding: 7Bit
Content-Type: text/plain; charset="us-ascii"
X-Originating-IP: [192.168.54.112]
X-RMX-ID: 20201102-113603-4CPq830KPnz2TTMl-0@kdin02
X-RMX-SOURCE: 217.111.95.66
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Monday, 2 November 2020, 00:41:49 CET, Vladimir Oltean wrote:
> On Sun, Nov 01, 2020 at 11:14:24PM +0100, Christian Eggers wrote:
> > My assumption is that the KSZ9563 simply doesn't forward specific PTP
> > packages from the slave ports to the CPU port. In my imagination this
> > happens in hardware and is not visible in software.
> 
> You talked about tracking the BMCA by snooping Announce messages. I
> don't think that is going to be the path forward either. Think about the
> general case, where there might not even be a BMCA (like in the
> automotive profile).
Maybe my mail from October, 22 was ambiguous. I meant that despite of the 
presence of filtering, a BCMA algorithm should be about to work (as no 
Announce messages are filtered out).

Additionally I said, that switching between "master" and "slave" mode could 
not be done automatically by the driver, as the driver could at most detect 
the presence of Sync messages (indication for master mode), but would do hard 
to detect a transition to slave mode.

I see a chance that user space (ptp4l) could configure the appropriate 
"hardware filter setup" for master/slave mode. 

> It almost seems to me as if the hardware is trying to be helpful by
> dropping the PTP messages that the application layer would drop anyway.
> Too bad that nobody seems to have told them to make this helpful
> mechanism optional, because as it is, it's standing in the way more than
> helping.
I think the same. Maybe there is some undocumented "filter disable" bit, but 
this information must come from Microchip.

> You know what the real problem is, with DSA you don't have the concept
> of the host port being an Ordinary Clock. DSA does not treat the host
> port as a switched endpoint (aka a plain net device attached to a dumb
> switch, and unaware of that switch), but instead is the conduit interface
> for each front-panel switch interface, which is an individually
> addressable network interface in its own right. You are not supposed to
> use a DSA master interface for networking directly, not for regular
> networking and not for PTP. In fact, DSA-enabled ports, only the PTP
> clock of the switch is usable. If you attempt to run ptp4l on the master
> interface an error will be thrown back at you.
> 
> Why am I mentioning this? Because the setting that's causing trouble for
> us is 'port state of the host port OC', which in the context of what I
> said above is nonsense. There _is_ no host port OC. There are 2 switch
> ports which can act as individual OCs, or as a BC, or as a TC.
But the switch has only one clock at all. I assume that the switch cannot be a 
boundary clock, only TC seems possible.

> But
> consider the case when the switch is a BC, with one of the front-panel
> ports being a master and the other a slave. What mode are you supposed
> to put the host port in, so that it receives both the Sync packets from
> the slave port, and the Delay_Req packets from the master port?! It just
> makes no sense to me. In principle I don't see any reason why this
> switch would not be able to operate as a one-step peer delay BC.
> 
> Unless somebody from Microchip could shed some light on the design
> decisions of this switch (and there are enough Microchip people copied
> already), here's what I would do. I would cut my losses and just support
> peer delay, no E2E delay request-response mechanism (this means you'll
> need to deploy peer delay to all devices within your network, but the
> gains might be worth it). Because peer delay is symmetrical (both link
> partners are both requestors as well as responders), there's no help in
> the world that this switch could volunteer to give you in dropping
> packets on your behalf. So I expect that if you hardcode:
> - the port state for the host port OC as slave, then you'd get the Sync
>   messages from all ports, and the Delay_Req messages would be dropped
>   but you wouldn't care about those anyway, and
> - the selection of TC mode to P2P TC.
When using only P2P, setting the OCMODE bit to "slave" should work.

> Then I would negotiate with Richard whether it's ok to add these extra
> values to enum hwtstamp_rx_filters:
> 	HWTSTAMP_FILTER_PTP_V2_PDELAY
> 	HWTSTAMP_FILTER_PTP_V2_L4_PDELAY
>
As said above, having "filter setups" for E2E/P2P and for MASTER/SLAVE would 
probably fit well for this kind of hardware.

> Given the fact that you're only limiting the timestamping to Pdelay
> because we don't fully understand the hardware, I don't really know
> whether introducing UAPI for this one situation is justifiable. If not,
> then your driver will not have a chance to reject ptp4l -E, and it will
> Simply Not Work.




