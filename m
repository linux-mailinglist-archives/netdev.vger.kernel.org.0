Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 17FC02B2130
	for <lists+netdev@lfdr.de>; Fri, 13 Nov 2020 17:58:06 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726273AbgKMQ6C (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 13 Nov 2020 11:58:02 -0500
Received: from mailout01.rmx.de ([94.199.90.91]:53925 "EHLO mailout01.rmx.de"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726136AbgKMQ6B (ORCPT <rfc822;netdev@vger.kernel.org>);
        Fri, 13 Nov 2020 11:58:01 -0500
Received: from kdin02.retarus.com (kdin02.dmz1.retloc [172.19.17.49])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mailout01.rmx.de (Postfix) with ESMTPS id 4CXl5d0DPVz2SVY5;
        Fri, 13 Nov 2020 17:57:57 +0100 (CET)
Received: from mta.arri.de (unknown [217.111.95.66])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-SHA384 (256/256 bits))
        (No client certificate requested)
        by kdin02.retarus.com (Postfix) with ESMTPS id 4CXl5D2TCwz2TTLW;
        Fri, 13 Nov 2020 17:57:36 +0100 (CET)
Received: from n95hx1g2.localnet (192.168.54.14) by mta.arri.de
 (192.168.100.104) with Microsoft SMTP Server (TLS) id 14.3.487.0; Fri, 13 Nov
 2020 17:56:34 +0100
From:   Christian Eggers <ceggers@arri.de>
To:     Vladimir Oltean <olteanv@gmail.com>
CC:     Jakub Kicinski <kuba@kernel.org>, Andrew Lunn <andrew@lunn.ch>,
        "Richard Cochran" <richardcochran@gmail.com>,
        Rob Herring <robh+dt@kernel.org>,
        "Vivien Didelot" <vivien.didelot@gmail.com>,
        "David S . Miller" <davem@davemloft.net>,
        Kurt Kanzenbach <kurt.kanzenbach@linutronix.de>,
        George McCollister <george.mccollister@gmail.com>,
        Marek Vasut <marex@denx.de>,
        Helmut Grohne <helmut.grohne@intenta.de>,
        Paul Barker <pbarker@konsulko.com>,
        "Codrin Ciubotariu" <codrin.ciubotariu@microchip.com>,
        Tristram Ha <Tristram.Ha@microchip.com>,
        Woojung Huh <woojung.huh@microchip.com>,
        Microchip Linux Driver Support <UNGLinuxDriver@microchip.com>,
        <netdev@vger.kernel.org>, <devicetree@vger.kernel.org>,
        <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH net-next v2 03/11] net: dsa: microchip: split ksz_common.h
Date:   Fri, 13 Nov 2020 17:56:34 +0100
Message-ID: <5328227.AyQhSCNoNJ@n95hx1g2>
Organization: Arnold & Richter Cine Technik GmbH & Co. Betriebs KG
In-Reply-To: <20201112230254.v6bzsud3jlcmsjm2@skbuf>
References: <20201112153537.22383-1-ceggers@arri.de> <20201112153537.22383-4-ceggers@arri.de> <20201112230254.v6bzsud3jlcmsjm2@skbuf>
MIME-Version: 1.0
Content-Transfer-Encoding: 7Bit
Content-Type: text/plain; charset="us-ascii"
X-Originating-IP: [192.168.54.14]
X-RMX-ID: 20201113-175738-4CXl5D2TCwz2TTLW-0@kdin02
X-RMX-SOURCE: 217.111.95.66
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Friday, 13 November 2020, 00:02:54 CET, Vladimir Oltean wrote:
> On Thu, Nov 12, 2020 at 04:35:29PM +0100, Christian Eggers wrote:
> > Parts of ksz_common.h (struct ksz_device) will be required in
> > net/dsa/tag_ksz.c soon. So move the relevant parts into a new header
> > file.
> > 
> > Signed-off-by: Christian Eggers <ceggers@arri.de>
> > ---
> 
> I had to skip ahead to see what you're going to use struct ksz_port and
> struct ksz_device for. It looks like you need:
> 
> 	struct ksz_port::tstamp_rx_latency_ns
> 	struct ksz_device::ptp_clock_lock
> 	struct ksz_device::ptp_clock_time
> 
> Not more.
> 
> Why don't you go the other way around, i.e. exporting some functions
> from your driver, and calling them from the tagger? 

Good question... But as for as I can see, there are a single tagger and 
multiple device drivers (currently KSZ8795 and KSZ9477). 

Moving the KSZ9477 specific stuff, which is required by the tagger, into the 
KSZ9477 device driver, would make the tagger dependent on the driver(s). 
Currently, no tagger seems to have this direction of dependency (at least I 
cannot find this in net/dsa/Kconfig).

If I shall change this anyway, I would use #ifdefs within the tag_ksz driver 
in order to avoid unnecessary dependencies to the KSZ9477 driver for the case 
only KSZ8795 is selected.

> You could even move
> the entire ksz9477_tstamp_to_clock() into the driver as-is, as far as I
> can see.




