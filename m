Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 164BD4533E6
	for <lists+netdev@lfdr.de>; Tue, 16 Nov 2021 15:15:07 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S237252AbhKPOSA (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 16 Nov 2021 09:18:00 -0500
Received: from vps0.lunn.ch ([185.16.172.187]:36068 "EHLO vps0.lunn.ch"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S237212AbhKPORz (ORCPT <rfc822;netdev@vger.kernel.org>);
        Tue, 16 Nov 2021 09:17:55 -0500
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed; d=lunn.ch;
        s=20171124; h=In-Reply-To:Content-Disposition:Content-Type:MIME-Version:
        References:Message-ID:Subject:Cc:To:From:Date:From:Sender:Reply-To:Subject:
        Date:Message-ID:To:Cc:MIME-Version:Content-Type:Content-Transfer-Encoding:
        Content-ID:Content-Description:Content-Disposition:In-Reply-To:References;
        bh=3AIZ41+tqVRM1/xAiVsE723Y0TQuUEbBW9w9e6TgV3Y=; b=0s4GLgMY4QwvUzfOUF+u2Ihr84
        jc983K1vxOEmD4fnmJrC0uj0R3kyx2tRPKr3Zm2tsAtVj5AueuHBkE9xsBbDRwMZhDb9xlBsiWKBK
        E/KA3aI0x06d+F7CMDIsT8ity6epg/0GJGgaJICwMbVsy+cDpdfS65+BBljBVFdhiJkQ=;
Received: from andrew by vps0.lunn.ch with local (Exim 4.94.2)
        (envelope-from <andrew@lunn.ch>)
        id 1mmzEe-00DesX-NR; Tue, 16 Nov 2021 15:14:56 +0100
Date:   Tue, 16 Nov 2021 15:14:56 +0100
From:   Andrew Lunn <andrew@lunn.ch>
To:     Vladimir Oltean <olteanv@gmail.com>
Cc:     Oleksij Rempel <o.rempel@pengutronix.de>, g@pengutronix.de,
        Woojung Huh <woojung.huh@microchip.com>,
        Florian Fainelli <f.fainelli@gmail.com>,
        "David S. Miller" <davem@davemloft.net>, netdev@vger.kernel.org,
        linux-kernel@vger.kernel.org, UNGLinuxDriver@microchip.com,
        kernel@pengutronix.de, Jakub Kicinski <kuba@kernel.org>,
        Vivien Didelot <vivien.didelot@gmail.com>
Subject: Re: [RFC PATCH net-next] net: dsa: microchip: implement multi-bridge
 support
Message-ID: <YZO84IfL87dxg3n+@lunn.ch>
References: <20211108111034.2735339-1-o.rempel@pengutronix.de>
 <20211110123640.z5hub3nv37dypa6m@skbuf>
 <20211112075823.GJ12195@pengutronix.de>
 <20211115234546.spi7hz2fsxddn4dz@skbuf>
 <20211116083903.GA16121@pengutronix.de>
 <20211116124723.kivonrdbgqdxlryd@skbuf>
 <20211116131657.GC16121@pengutronix.de>
 <YZO0tuMtDUIbRfcC@lunn.ch>
 <20211116135335.j5mmvpnfzw4hfz67@skbuf>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20211116135335.j5mmvpnfzw4hfz67@skbuf>
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Tue, Nov 16, 2021 at 03:53:35PM +0200, Vladimir Oltean wrote:
> On Tue, Nov 16, 2021 at 02:40:06PM +0100, Andrew Lunn wrote:
> > > > What logging noise?
> > > 
> > > I get this with current ksz driver:
> > > [   40.185928] br0: port 2(lan2) entered blocking state
> > > [   40.190924] br0: port 2(lan2) entered listening state
> > > [   41.043186] br0: port 2(lan2) entered blocking state
> > > [   55.512832] br0: port 1(lan1) entered learning state
> > > [   61.272802] br0: port 2(lan2) neighbor 8000.ae:1b:91:58:77:8b lost
> > > [   61.279192] br0: port 2(lan2) entered listening state
> > > [   63.113236] br0: received packet on lan1 with own address as source address (addr:00:0e:cd:00:cd:be, vlan:0)
> > 
> > I would guess that transmission from the CPU is broken in this
> > case. It could be looking up the destination address in the
> > translation table and not finding an entry. So it floods the packet
> > out all interfaces, including the CPU. So the CPU receives its own
> > packet and gives this warning.
> > 
> > Flooding should exclude where the frame came from.
> 
> I interpret this very differently. If Oleksij is looping lan1 with lan2
> and he keeps the MAC addresses the way DSA sets them up by default, i.e.
> equal and inherited from the DSA master, then receiving a packet with a
> MAC SA (lan2) equal with the address of the receiving interface (lan1)
> is absolutely natural. What is not natural is that the bridge attempts
> to learn from this packet (the message is printed from br_fdb_update),
> which in turn is caused by the fact that the port is allowed to proceed
> to the LEARNING state despite there being a loop (which is not detected
> by STP because STP is broken as Oleksij describes).

Ah, yes, that is more likely.

Sorry, should not of jumped in without reading all the context. If STP
is broken, odd things will happen.

   Andrew
