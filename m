Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id C9E3C29371E
	for <lists+netdev@lfdr.de>; Tue, 20 Oct 2020 10:50:48 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2392174AbgJTIuh (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 20 Oct 2020 04:50:37 -0400
Received: from mailout04.rmx.de ([94.199.90.94]:36952 "EHLO mailout04.rmx.de"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S2389510AbgJTIuh (ORCPT <rfc822;netdev@vger.kernel.org>);
        Tue, 20 Oct 2020 04:50:37 -0400
Received: from kdin02.retarus.com (kdin02.dmz1.retloc [172.19.17.49])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mailout04.rmx.de (Postfix) with ESMTPS id 4CFnQH1Cq3z3qv3d;
        Tue, 20 Oct 2020 10:50:31 +0200 (CEST)
Received: from mta.arri.de (unknown [217.111.95.66])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-SHA384 (256/256 bits))
        (No client certificate requested)
        by kdin02.retarus.com (Postfix) with ESMTPS id 4CFnQ039mzz2TTM8;
        Tue, 20 Oct 2020 10:50:16 +0200 (CEST)
Received: from n95hx1g2.localnet (192.168.54.97) by mta.arri.de
 (192.168.100.104) with Microsoft SMTP Server (TLS) id 14.3.408.0; Tue, 20 Oct
 2020 10:39:17 +0200
From:   Christian Eggers <ceggers@arri.de>
To:     Vladimir Oltean <olteanv@gmail.com>
CC:     Florian Fainelli <f.fainelli@gmail.com>,
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
        Microchip Linux Driver Support <UNGLinuxDriver@microchip.com>,
        <netdev@vger.kernel.org>, <devicetree@vger.kernel.org>,
        <linux-kernel@vger.kernel.org>
Subject: Re: [RFC PATCH net-next 7/9] net: dsa: microchip: ksz9477: add hardware time stamping support
Date:   Tue, 20 Oct 2020 10:39:03 +0200
Message-ID: <1773841.qDLamPWWuv@n95hx1g2>
Organization: Arnold & Richter Cine Technik GmbH & Co. Betriebs KG
In-Reply-To: <20201020001040.avkzgltrijaz4ujb@skbuf>
References: <20201019172435.4416-1-ceggers@arri.de> <20201019172435.4416-8-ceggers@arri.de> <20201020001040.avkzgltrijaz4ujb@skbuf>
MIME-Version: 1.0
Content-Transfer-Encoding: 7Bit
Content-Type: text/plain; charset="us-ascii"
X-Originating-IP: [192.168.54.97]
X-RMX-ID: 20201020-105020-4CFnQ039mzz2TTM8-0@kdin02
X-RMX-SOURCE: 217.111.95.66
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Tuesday, 20 October 2020, 02:10:40 CEST, Vladimir Oltean wrote:
> I looked a little bit at the KSZ9563 datasheet and I'm more confused
> than I was before opening it.
> 
> -----------------------------[cut here]-----------------------------
> The device supports V2 (2008) of the IEEE 1588 PTP specification and can
> be programmed as either an end-to-end (E2E) or peer-to-peer (P2P)
> transparent clock (TC) between ports. In addition, the host port can be
> programmed as either a slave or master ordinary clock (OC) port.
> Ingress timestamp capture, egress timestamp recording, correction field
> update with residence time and link delay, delay turn-around time
> insertion, egress timestamp insertion, and checksum update are
> supported.
> -----------------------------[cut here]-----------------------------
> 
> So it's a 1-step transparent clock, fair enough. That works autonomously
> without any sort of involvement from the operating system, you know
> that, right? This is stateless functionality.
The device performs "one-step time stamping". This means that the correction 
field in Sync and PDelay_Resp messages is updated automatically. Not more. For 
operation as a switch, this would be probably enough. But I need also to set 
the switch' local PTP clock in order to generate a synchronized output signal 
for local use.

> BUT, if that is the case, what do you need PTP support in the kernel
> for?
The device cannot autonomously set it's PTP clock. This requires calculating 
the link delay between the own port and the master/peer. It looks like the 
KSZ9563 cannot perform this calculation itself.

> What profiles are you using with linuxptp?
My config is at the bottom.

> What benefit does it
> bring you if you report timestamps to the operating system, for
> terminated 1588 traffic? Why would you even terminate 1588 traffic on
> the host CPU? I fail to understand many of the use cases that this
> switch is tailored for.
In my opinion, the switch doesn't terminate 1588 traffic. It only generates 
hardware time stamps and performs update of the correction field on selected 
messages.

> Also, I know that Microchip support does a pretty bad job at giving
> useful answers, and the datasheet isn't quite clear either (looks like
> there's info that has been copied from other switches, like for 2-step
> timestamping, then removed, and too much was removed because now nothing
> is clear) so you'll have to give your best shot at explaining some
> things.
It looks like it was planned to support also 2-step time stamping. You can see 
an errata in revision B of the errata sheet [1]. Revision C dropped this 
again.

> Global PTP Message Config 1 Register
> ------------------------------------
> 
> Bit 2: Selection of P2P or E2E
> 1 = Peer-to-peer (P2P) transparent clock mode
> 0 = End-to-end (E2E) transparent clock mode
> 
> What does this bit do exactly?
> Does it change the switch's behavior as an autonomous 1-step transparent
> clock? Or does it have anything to do with how/which timestamps are
> delivered to the CPU? The point is, why do you care to configure this?
> Sysfs is not going to fly without a solid explanation, which you did not
> provide here.
In short: Clock synchronization (using linuxptp) doesn't work if this is not 
configured in sync with ptp4l.conf. Either no time stamping is performed or 
PTP messages are filtered out. If required, I can investigate this further. 

> My understanding of E2E vs P2P TC is that an E2E TC will correct the
> timestamps of Pdelay messages, while a P2P TC won't
Yes, I think so. But I am no expert for PTP.

> The P2P TC must speak proper PDelay and not forward those packets 
> sheepishly. Which starts to answer my question, I believe... So my comment 
> above, that the 1-step TC functionality doesn't require any involvement from 
> the CPU, is only correct for E2E TC, am I right? For P2P TC, you would need 
> the host CPU to speak peer delay.
The host CPU is not required for updating forwarded (switched) PTP messages. 
But it is required RX/TX time stamping of own PTP messages. All local PTP 
operations can be done on the switch, there's no work left for the MAC 
connected to the host port.

> But you wouldn't need it for anything else (the
> SYNC messages would have no reason to go to the CPU, would they?). 
The (time stamped) SYNC messages are required in order to calculate the offset 
from the master clock.

> So, again, what profile are you using with linuxptp for this one?
only a few lines left...

> If my understanding is right, maybe you want to just leave the switch
> operate in E2E TC mode by default, and put it into P2P TC as soon as
> your .port_hwtstamp_set() method is called?
Currently the TC mode has to be set manually. So the automatic mode of ptp4l 
cannot be used. Probably this could be automated depending on received PTP 
messages. But probably we cannot see these messages because these are filtered 
out.

> Ok, on to my next question....
> 
> Bit 1: Selection of Master or Slave
> 1 = Host port is PTP master ordinary clock
> 0 = Host port is PTP slave ordinary clock
> 
> What does this _actually_ do? Here I really have no idea. I can only
> imagine that this has again to do with the 1-step TC operation, and that
> it's treating the host port as a switched endpoint, and this has to do
> with the port states of the P2P TC. I'm so confused by this one that I
> don't even know what to ask...
As for the TC mode questions, also this one could be best answered by 
Microchip. If not set correctly, clock synchronization will not work. I need 
to investigate what happens here concretely. Again I suppose that time 
stamping of the associated messages will not be performed or some messages may 
be filtered out.

> Ok, let's put it differently. You bothered to add a sysfs for it, so you
> must be using it for something. What are you using it for?
If not set correctly, nothing will work. This has the major drawback, that 
ptp4l cannot determine the clock mode nor the delay measurement mode 
automatically. I will try find some answers for this.

Best regards
Christian

[global]
twoStepFlag 0
time_stamping p2p1step
#slaveOnly 1
delay_mechanism P2P
#delay_mechanism E2E
delay_filter_length 100
tx_timestamp_timeout 100
#network_transport UDPv6
#network_transport L2

[1] 
http://ww1.microchip.com/downloads/en/DeviceDoc/KSZ9563R-Errata-80000786B.pdf



