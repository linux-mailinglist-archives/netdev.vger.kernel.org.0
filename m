Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 6A5B929271B
	for <lists+netdev@lfdr.de>; Mon, 19 Oct 2020 14:19:27 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726685AbgJSMT0 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 19 Oct 2020 08:19:26 -0400
Received: from vps0.lunn.ch ([185.16.172.187]:34532 "EHLO vps0.lunn.ch"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726336AbgJSMTZ (ORCPT <rfc822;netdev@vger.kernel.org>);
        Mon, 19 Oct 2020 08:19:25 -0400
Received: from andrew by vps0.lunn.ch with local (Exim 4.94)
        (envelope-from <andrew@lunn.ch>)
        id 1kUU8G-002Uan-JZ; Mon, 19 Oct 2020 14:19:20 +0200
Date:   Mon, 19 Oct 2020 14:19:20 +0200
From:   Andrew Lunn <andrew@lunn.ch>
To:     Vladimir Oltean <vladimir.oltean@nxp.com>
Cc:     David Laight <David.Laight@ACULAB.COM>,
        'Florian Fainelli' <f.fainelli@gmail.com>,
        "netdev@vger.kernel.org" <netdev@vger.kernel.org>,
        "vivien.didelot@gmail.com" <vivien.didelot@gmail.com>,
        "kuba@kernel.org" <kuba@kernel.org>,
        Christian Eggers <ceggers@arri.de>,
        Kurt Kanzenbach <kurt@linutronix.de>
Subject: Re: [RFC PATCH 02/13] net: dsa: implement a central TX reallocation
 procedure
Message-ID: <20201019121920.GM456889@lunn.ch>
References: <20201017213611.2557565-1-vladimir.oltean@nxp.com>
 <20201017213611.2557565-3-vladimir.oltean@nxp.com>
 <20201017220104.wejlxn2a4seefkfv@skbuf>
 <d2578c4b-7da6-e25d-5dde-5ec89b82aeef@gmail.com>
 <049e7fd8f46c43819a05689fe464df25@AcuMS.aculab.com>
 <20201019103047.oq5ki3jlhnwzz2xv@skbuf>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20201019103047.oq5ki3jlhnwzz2xv@skbuf>
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Mon, Oct 19, 2020 at 10:30:47AM +0000, Vladimir Oltean wrote:
> On Mon, Oct 19, 2020 at 08:33:27AM +0000, David Laight wrote:
> > Is it possible to send the extra bytes from a separate buffer fragment?
> > The entire area could be allocated (coherent) when the rings are
> > allocated.
> > That would save having to modify the skb at all.
> > 
> > Even if some bytes of the frame header need 'adjusting' transmitting
> > from a copy may be faster - especially on systems with an iommu.
> > 
> > Many (many) moons ago we found the cutoff point for copying frames
> > on a system with an iommu to be around 1k bytes.
> 
> Please help me understand better how to implement what you're suggesting.
> DSA switches have 3 places where they might insert a tag:
> 1. Between the source MAC address and the EtherType (this is the most
>    common)
> 2. Before the destination MAC address
> 3. Before the FCS
> 
> I imagine that the most common scenario (1) is also the most difficult
> to implement using fragments, since I would need to split the Ethernet
> header from the rest of the skb data area, which might defeat the
> purpose.

We also have length issues. Most scatter/gather DMA engines require
the fragments are multiple of 4 bytes. Only the last segment does not
have this length restriction. And some of the DSA tag headers are 2
bytes, or 1 byte. So some master devices are going to have to convert
the fragments back to a linear buffer.

    Andrew
