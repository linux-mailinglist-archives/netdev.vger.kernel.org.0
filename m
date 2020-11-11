Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 574152AFAB9
	for <lists+netdev@lfdr.de>; Wed, 11 Nov 2020 22:50:36 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726276AbgKKVub (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 11 Nov 2020 16:50:31 -0500
Received: from mailout04.rmx.de ([94.199.90.94]:35086 "EHLO mailout04.rmx.de"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726108AbgKKVua (ORCPT <rfc822;netdev@vger.kernel.org>);
        Wed, 11 Nov 2020 16:50:30 -0500
Received: from kdin01.retarus.com (kdin01.dmz1.retloc [172.19.17.48])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mailout04.rmx.de (Postfix) with ESMTPS id 4CWdh25qXYz3qcH4;
        Wed, 11 Nov 2020 22:50:26 +0100 (CET)
Received: from mta.arri.de (unknown [217.111.95.66])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-SHA384 (256/256 bits))
        (No client certificate requested)
        by kdin01.retarus.com (Postfix) with ESMTPS id 4CWdgw19V5z2xDM;
        Wed, 11 Nov 2020 22:50:20 +0100 (CET)
Received: from n95hx1g2.localnet (192.168.54.13) by mta.arri.de
 (192.168.100.104) with Microsoft SMTP Server (TLS) id 14.3.487.0; Wed, 11 Nov
 2020 22:49:47 +0100
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
Date:   Wed, 11 Nov 2020 22:49:44 +0100
Message-ID: <5898097.XrYNDCFn2f@n95hx1g2>
Organization: Arnold & Richter Cine Technik GmbH & Co. Betriebs KG
In-Reply-To: <20201110193245.uwsmrqzio5hco7fb@skbuf>
References: <20201019172435.4416-1-ceggers@arri.de> <20201110164045.jqdwvmz5lq4hg54l@skbuf> <20201110193245.uwsmrqzio5hco7fb@skbuf>
MIME-Version: 1.0
Content-Transfer-Encoding: 7Bit
Content-Type: text/plain; charset="us-ascii"
X-Originating-IP: [192.168.54.13]
X-RMX-ID: 20201111-225020-4CWdgw19V5z2xDM-0@kdin01
X-RMX-SOURCE: 217.111.95.66
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Hi Vladimir,

On Tuesday, 10 November 2020, 20:32:45 CET, Vladimir Oltean wrote:
> On Tue, Nov 10, 2020 at 06:40:45PM +0200, Vladimir Oltean wrote:
> > I am fairly confident that this is how your hardware works, because
> > that's also how peer delay wants to be timestamped, it seems.
> 
> So I was confident and also wrong, it appears. My KSZ9477 datasheet
> says:
> 
> In the host-to-switch direction, the 4-byte timestamp field is always
> present when PTP is enabled, as shown in Figure 4-6. This is true for
> all packets sent by the host, including IBA packets. The host uses this
> field to insert the receive timestamp from PTP Pdelay_Req messages into
> the Pdelay_Resp messages. For all other traffic and PTP message types,
> the host should populate the timestamp field with zeros.
> 
> Hm. Does that mean that the switch updates the originTimestamp field of
> the Sync frames by itself?
IMHO this is the best solution. User space / driver do not know the exact time 
(would require slow I2C transfer). So inserting the time in hardware seems to 
be the better solution. Maybe this is what the data sheet meant with "egress 
timestamp insertion".

> Ok... Very interesting that they decided to
> introduce a field in the tail tag for a single type of PTP message.

> But something is still wrong if you need to special-case the negative
> correctionField, it looks like the arithmetic is not done on the correct
> number of bits, either by the driver or by the hardware.
> 
Maybe I found the formula which is (should) applied to the correction field 
for PDelayResp:

correction = correction_old + now + residental_delay + tx_latency - tail_tag

<correction_old>: current value from the PTP header
<now>: Time of the PTP clock when entering the switch
<residental_delay>: Switching delay
<Tx latency>: Delay between time stamping unit and wire (configurable via 
register)
<tail_tag>: Time stamp in the tail tag

The new correction value has been captured with Wireshark. For the measurement 
I simply halted the internal PTP clock and set it to zero (so it's value is 
exactly known). In the port's TX time stamp unit I got a non-zero time stamp 
anyway (between, 10 to 40 ns), so this must be the residential delay.

I tested with different values for the correction field and the tail_tag. 
Negative values are no problem, but the calculation seems no to consider all 
bits.

Measurements:
- PTP clock: 0 (frozen)
- Residential delay: variable
- TX delay: 45 ns (default)

- correction = 0xffff ffff ffff.ffff (-1.xxx ns)
correction = correction + now + residental_delay + tx_latency - tail_tag
           =          -1  + 0                 40 +         45          0
           = 84             (0000 0000 0054)
           wireshark:       (0000 0000 0054) --> correct

correction = correction + now + residental_delay + tx_latency - tail_tag
           =          -1  + 0                 32 +         45      1.000
           = -924           (FFFF FFFF FC64)
           wireshark:       (0000 FFFF FC64) --> wrong

correction = correction + now + residental_delay + tx_latency - tail_tag
           =          -1  + 0                 24 +         45   2.000.000.000 
           = -1.926.258.108 (FFFF 8D2F A244)
           wireshark:       (0000 7B9A CA44) --> wrong

- correction = 0xffff ffff 0000.0000 (-65536.0 ns)
correction = correction + now + residental_delay + tx_latency - tail_tag
           =     -65536     0                 24 +         45          0
           =     -65467     (FFFF FFFF 0045)
           wireshark:       (FFFF FFFF 0045) --> correct

correction = correction + now + residental_delay + tx_latency - tail_tag
           =     -65536   + 0                 32 +         45      1.000
           =     -66459     (FFFF FFFE FC65)
           wireshark:       (0000 FFFE FC65) --> wrong


Please note that the tail tag consist of 2 bits for seconds and 30 bit 
nanoseconds. So the value of 2.000.000.000 means 1s + 926.258.176 ns.

As you are better in 2's complement as me, you can give me some more 
combinations for testing if you need. But in the end it looks like I should 
keep T2 in the tail tag.

> And zeroing out the correctionField of the Pdelay_Resp on transmission,
> to put that value into t_Tail_Tag? How can you squeeze a 48-bit value
> into a 32-bit value without truncation?
Only the lower bits are used. As long as PDelayResp doesn't take more than 4 
seconds, this should be enough.

regards
Christian



