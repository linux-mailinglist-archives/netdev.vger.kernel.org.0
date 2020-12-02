Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 7B3422CB1D5
	for <lists+netdev@lfdr.de>; Wed,  2 Dec 2020 01:56:32 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727871AbgLBAzF (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 1 Dec 2020 19:55:05 -0500
Received: from mail.kernel.org ([198.145.29.99]:37180 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1727322AbgLBAzE (ORCPT <rfc822;netdev@vger.kernel.org>);
        Tue, 1 Dec 2020 19:55:04 -0500
Date:   Tue, 1 Dec 2020 16:54:21 -0800
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1606870463;
        bh=LLiukAIVp7rggPRhAeu/DaAOF681PbLxnZIWJeVXvBs=;
        h=From:To:Cc:Subject:In-Reply-To:References:From;
        b=OUyFSjCe1QSfqOXIOcOp7GyQaF7+qTjqSRU0M7SE7NKtVEkQBJRxFqZ17Do/Af334
         jB7tmFg5iwm6SrOE9Qr5hEuUBKrQIIxNdDZYDcTxGlPOl2vmkr3oJoqmVRaaiuel53
         fHzj7lp933qlKEcHkh95bVNPg+B1b/1dr8SoUP1U=
From:   Jakub Kicinski <kuba@kernel.org>
To:     Vladimir Oltean <olteanv@gmail.com>
Cc:     Andrew Lunn <andrew@lunn.ch>,
        George McCollister <george.mccollister@gmail.com>,
        Vivien Didelot <vivien.didelot@gmail.com>,
        Florian Fainelli <f.fainelli@gmail.com>,
        "David S . Miller" <davem@davemloft.net>, netdev@vger.kernel.org,
        "open list:OPEN FIRMWARE AND..." <devicetree@vger.kernel.org>
Subject: Re: [PATCH net-next v2 2/3] net: dsa: add Arrow SpeedChips XRS700x
 driver
Message-ID: <20201201165421.50d4b5a6@kicinski-fedora-pc1c0hjn.DHCP.thefacebook.com>
In-Reply-To: <20201202002851.z63jdsfqxdkjb46k@skbuf>
References: <CAFSKS=OY_-Agd6JPoFgm3MS5HE6soexHnDHfq8g9WVrCc82_sA@mail.gmail.com>
        <20201126132418.zigx6c2iuc4kmlvy@skbuf>
        <20201126175607.bqmpwbdqbsahtjn2@skbuf>
        <CAFSKS=Ok1FZhKqourHh-ikaia6eNWtXh6VBOhOypsEJAhwu06g@mail.gmail.com>
        <20201126220500.av3clcxbbvogvde5@skbuf>
        <20201127103503.5cda7f24@kicinski-fedora-pc1c0hjn.DHCP.thefacebook.com>
        <20201127204714.GX2073444@lunn.ch>
        <20201127131346.3d594c8e@kicinski-fedora-pc1c0hjn.DHCP.thefacebook.com>
        <20201127212342.qpyp6bcxd7mwgxf2@skbuf>
        <20201127213642.GZ2073444@lunn.ch>
        <20201202002851.z63jdsfqxdkjb46k@skbuf>
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Wed, 2 Dec 2020 02:28:51 +0200 Vladimir Oltean wrote:
> On Fri, Nov 27, 2020 at 10:36:42PM +0100, Andrew Lunn wrote:
> > > Either way, can we conclude that ndo_get_stats64 is not a replacement
> > > for ethtool -S, since the latter is blocking and, if implemented correctly,
> > > can return the counters at the time of the call (therefore making sure
> > > that anything that happened before the syscall has been accounted into
> > > the retrieved values), and the former isn't?  
> >
> > ethtool -S is the best source of consistent, up to date statistics we
> > have. It seems silly not to include everything the hardware offers
> > there.  
> 
> To add to this, it would seem odd to me if we took the decision to not
> expose MAC-level counters any longer in ethtool. Say the MAC has a counter
> named rx_dropped. If we are only exposing this counter in ndo_get_stats64,
> then we could hit the scenario where this counter keeps incrementing,
> but it is the network stack who increments it, and not the MAC.
> 
> dev_get_stats() currently does:
> 	storage->rx_dropped += (unsigned long)atomic_long_read(&dev->rx_dropped);
> 	storage->tx_dropped += (unsigned long)atomic_long_read(&dev->tx_dropped);
> 	storage->rx_nohandler += (unsigned long)atomic_long_read(&dev->rx_nohandler);
> 
> thereby clobbering the MAC-provided counter. We would not know if it is
> a MAC-level drop or not.

Fine granularity HW stats are fine, but the aggregate must be reported
in standard stats first.

The correct stat for MAC drops (AFAIU) is rx_missed.

This should act as a generic "device had to drop valid packets"
indication and ethtool -S should serve for manual debugging to find 
out which stage of pipeline / reason caused the drop.
