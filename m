Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id A934CF60A7
	for <lists+netdev@lfdr.de>; Sat,  9 Nov 2019 18:21:58 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726470AbfKIRVv (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sat, 9 Nov 2019 12:21:51 -0500
Received: from vps0.lunn.ch ([185.16.172.187]:58318 "EHLO vps0.lunn.ch"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726204AbfKIRVu (ORCPT <rfc822;netdev@vger.kernel.org>);
        Sat, 9 Nov 2019 12:21:50 -0500
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed; d=lunn.ch;
        s=20171124; h=In-Reply-To:Content-Transfer-Encoding:Content-Type:MIME-Version
        :References:Message-ID:Subject:Cc:To:From:Date:Sender:Reply-To:Content-ID:
        Content-Description:Resent-Date:Resent-From:Resent-Sender:Resent-To:Resent-Cc
        :Resent-Message-ID:List-Id:List-Help:List-Unsubscribe:List-Subscribe:
        List-Post:List-Owner:List-Archive;
        bh=GnBQ82YlwA0ID38IFrxIGR1cO4p7JxsUcnjCyBe4x6E=; b=WMLHZ2PkZVx00hZyvDfl5UIP9s
        gxOZwLATHW98FpyGk4aPz/fdyyErcYH6+PsWU9Tvl96ExhmGlT5yQgcO3HNlC8WAjmgDTVuz2JJL+
        0k+cYrj8jVYxbCpGO/3yPXL3w68p1vm4H2Of5dZz/8GRYVTfN3y1LjhbqcdCg4LSM9z8=;
Received: from andrew by vps0.lunn.ch with local (Exim 4.92.2)
        (envelope-from <andrew@lunn.ch>)
        id 1iTUQf-0003Ct-CI; Sat, 09 Nov 2019 18:21:41 +0100
Date:   Sat, 9 Nov 2019 18:21:41 +0100
From:   Andrew Lunn <andrew@lunn.ch>
To:     Vladimir Oltean <olteanv@gmail.com>
Cc:     "shawnguo@kernel.org" <shawnguo@kernel.org>,
        "mark.rutland@arm.com" <mark.rutland@arm.com>,
        "devicetree@vger.kernel.org" <devicetree@vger.kernel.org>,
        "leoyang.li@nxp.com" <leoyang.li@nxp.com>,
        "robh+dt@kernel.org" <robh+dt@kernel.org>,
        "linux-arm-kernel@lists.infradead.org" 
        <linux-arm-kernel@lists.infradead.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "netdev@vger.kernel.org" <netdev@vger.kernel.org>
Subject: Re: [PATCH] ARM: dts: ls1021a-tsn: Use interrupts for the SGMII PHYs
Message-ID: <20191109172141.GL22978@lunn.ch>
References: <20191109105642.30700-1-olteanv@gmail.com>
 <20191109150953.GJ22978@lunn.ch>
 <CA+h21hrqczuOhTzWFZKX0XvgjgTzHT=3AdCPvO_eSabOzA3OCQ@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <CA+h21hrqczuOhTzWFZKX0XvgjgTzHT=3AdCPvO_eSabOzA3OCQ@mail.gmail.com>
User-Agent: Mutt/1.10.1 (2018-07-13)
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Sat, Nov 09, 2019 at 05:16:48PM +0200, Vladimir Oltean wrote:
> On Saturday, 9 November 2019, Andrew Lunn <andrew@lunn.ch> wrote:
> > On Sat, Nov 09, 2019 at 12:56:42PM +0200, Vladimir Oltean wrote:
> >> On the LS1021A-TSN board, the 2 Atheros AR8031 PHYs for eth0 and eth1
> >> have interrupt lines connected to the shared IRQ2_B LS1021A pin.
> >>
> >> The interrupts are active low, but the GICv2 controller does not support
> >> active-low and falling-edge interrupts, so the only mode it can be
> >> configured in is rising-edge.
> >
> > Hi Vladimir
> >
> > So how does this work? The rising edge would occur after the interrupt
> > handler has completed? What triggers the interrupt handler?
> >
> >         Andrew
> >
> 
> Hi Andrew,
> 
> I hope I am not terribly confused about this. I thought I am telling the
> interrupt controller to raise an IRQ as a result of the low-to-high transition
> of the electrical signal. Experimentation sure seems to agree with me. So the
> IRQ is generated immediately _after_ the PHY has left the line in open drain
> and it got pulled up to Vdd.

Hi Vladimir

                       t1                    t2

     ------------------\                     /----------------
                        \-------------------/

The interrupt output is active low. So it is high by default. At time
t1 something happens, say the link is established. The interrupt
becomes active, we have a failing edge. We want the interrupt
controller to fire. Lets say it does. The interrupt handler runs, and
clears the interrupt cause. This is at time t2. We then get a rising
edge and the PHY releases the interrupt, and the level returns to
high.

So how does this work if you have the interrupt controller triggering
on a rising edge? The edge won't rise until the interrupt handler
finishes its work.

	 Andrew

   
