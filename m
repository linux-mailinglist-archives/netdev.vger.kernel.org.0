Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 165AE2B5E40
	for <lists+netdev@lfdr.de>; Tue, 17 Nov 2020 12:29:08 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728102AbgKQL2r (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 17 Nov 2020 06:28:47 -0500
Received: from mailout01.rmx.de ([94.199.90.91]:51055 "EHLO mailout01.rmx.de"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1727815AbgKQL2r (ORCPT <rfc822;netdev@vger.kernel.org>);
        Tue, 17 Nov 2020 06:28:47 -0500
Received: from kdin02.retarus.com (kdin02.dmz1.retloc [172.19.17.49])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mailout01.rmx.de (Postfix) with ESMTPS id 4Cb3bt4cv1z2SVD8;
        Tue, 17 Nov 2020 12:28:42 +0100 (CET)
Received: from mta.arri.de (unknown [217.111.95.66])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-SHA384 (256/256 bits))
        (No client certificate requested)
        by kdin02.retarus.com (Postfix) with ESMTPS id 4Cb3bT6n2Lz2TSDJ;
        Tue, 17 Nov 2020 12:28:21 +0100 (CET)
Received: from n95hx1g2.localnet (192.168.54.38) by mta.arri.de
 (192.168.100.104) with Microsoft SMTP Server (TLS) id 14.3.487.0; Tue, 17 Nov
 2020 12:27:18 +0100
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
Date:   Tue, 17 Nov 2020 12:27:17 +0100
Message-ID: <1813904.kIZFssEuCH@n95hx1g2>
Organization: Arnold & Richter Cine Technik GmbH & Co. Betriebs KG
In-Reply-To: <2477133.fPTnnZM2lx@n95hx1g2>
References: <20201019172435.4416-1-ceggers@arri.de> <20201110193245.uwsmrqzio5hco7fb@skbuf> <2477133.fPTnnZM2lx@n95hx1g2>
MIME-Version: 1.0
Content-Transfer-Encoding: 7Bit
Content-Type: text/plain; charset="us-ascii"
X-Originating-IP: [192.168.54.38]
X-RMX-ID: 20201117-122823-4Cb3bT6n2Lz2TSDJ-0@kdin02
X-RMX-SOURCE: 217.111.95.66
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Thursday, 12 November 2020, 16:28:44 CET, Christian Eggers wrote:
> Hi Vladimir,
> 
> On Tuesday, 10 November 2020, 20:32:45 CET, Vladimir Oltean wrote:
> > But something is still wrong if you need to special-case the negative
> > correctionField, it looks like the arithmetic is not done on the correct
> > number of bits, either by the driver or by the hardware.
> 
> I got it! 
I got it not!

While keeping the (negative) correction field works perfect when using
PTP over L2 (what I did the last weeks), this causes an unwanted side effect
when using UDP:

...
> User Datagram Protocol, Src Port: 319, Dst Port: 319
> 
>     Source Port: 319
>     Destination Port: 319
>     Length: 62
>  
>  Checksum: 0x2285 incorrect, should be 0x2286 (maybe caused by "UDP checksum offload"?)
^^^^^^^^^^^^^^^^^^^^^^^^^^^^^

>     [Checksum Status: Bad]
>     [Stream index: 0]
>     [Timestamps]
> 
> Precision Time Protocol (IEEE1588)
> 
>     0000 .... = transportSpecific: 0x0
>     .... 0011 = messageId: Peer_Delay_Resp Message (0x3)
>     0000 .... = Reserved: 0
>     .... 0010 = versionPTP: 2
>     messageLength: 54
>     subdomainNumber: 0
>     Reserved: 0
>     flags: 0x0000
>     correction: 5579788,000000 nanoseconds
>     Reserved: 0
>     ClockIdentity: 0x849000fffe0980f7
>     SourcePortID: 1
>     sequenceId: 785
>     control: Other Message (5)
>     logMessagePeriod: 127
>     requestreceiptTimestamp (seconds): 0
>     requestreceiptTimestamp (nanoseconds): 0
>     requestingSourcePortIdentity: 0x849000fffe0980f6
>     requestingSourcePortId: 2
While correction field is ok (residential delay ~5ms, using one printk...),
the UDP checksum is off by one in all PDelay_Resp messages.

The KSZ device offers on option to set the UDP checksum to zero, but this also
didn't help and additionally wouldn't work for IPv6.

It seems that I should return to "moving T2 from the correction field to the
tail tag" on tx.
 
regards
Christian




