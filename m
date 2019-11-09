Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id B8585F6197
	for <lists+netdev@lfdr.de>; Sat,  9 Nov 2019 22:06:11 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726565AbfKIVGF (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sat, 9 Nov 2019 16:06:05 -0500
Received: from vps0.lunn.ch ([185.16.172.187]:58498 "EHLO vps0.lunn.ch"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726470AbfKIVGF (ORCPT <rfc822;netdev@vger.kernel.org>);
        Sat, 9 Nov 2019 16:06:05 -0500
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed; d=lunn.ch;
        s=20171124; h=In-Reply-To:Content-Type:MIME-Version:References:Message-ID:
        Subject:Cc:To:From:Date:Sender:Reply-To:Content-Transfer-Encoding:Content-ID:
        Content-Description:Resent-Date:Resent-From:Resent-Sender:Resent-To:Resent-Cc
        :Resent-Message-ID:List-Id:List-Help:List-Unsubscribe:List-Subscribe:
        List-Post:List-Owner:List-Archive;
        bh=AeGy6oWAVhpsj0BuOFBbXLEEpIX0zbaOX8ktv7sw73c=; b=lYQBPpkdLtKmSRGPLw1rP6Sksg
        5cbWGNaNDZmJvgYtA1Bu3BaWCIDw5+TcbSLT/PtHyDpdwR0UwQB3Qq9itkCuBTffpi4ZXU7qGEbsB
        Gjb8s+Mps3XmVAbR9KR4IuqePkrcPpDIDNG/PnJJLfFTYw8Vj3qY5wZuv6erEbfcpD0g=;
Received: from andrew by vps0.lunn.ch with local (Exim 4.92.2)
        (envelope-from <andrew@lunn.ch>)
        id 1iTXvZ-0003tj-MJ; Sat, 09 Nov 2019 22:05:49 +0100
Date:   Sat, 9 Nov 2019 22:05:49 +0100
From:   Andrew Lunn <andrew@lunn.ch>
To:     Alexander Stein <alexander.stein@mailbox.org>
Cc:     Vladimir Oltean <olteanv@gmail.com>, shawnguo@kernel.org,
        mark.rutland@arm.com, devicetree@vger.kernel.org,
        leoyang.li@nxp.com, robh+dt@kernel.org,
        linux-arm-kernel@lists.infradead.org, linux-kernel@vger.kernel.org,
        netdev@vger.kernel.org
Subject: Re: [PATCH] ARM: dts: ls1021a-tsn: Use interrupts for the SGMII PHYs
Message-ID: <20191109210549.GB12999@lunn.ch>
References: <20191109105642.30700-1-olteanv@gmail.com>
 <20191109150953.GJ22978@lunn.ch>
 <CA+h21hoqkE2D03BHrFeU+STbK8pStRRFu+x7+9j2nwFf+EHJNg@mail.gmail.com>
 <393335751.FoSYQk3TTC@kongar>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <393335751.FoSYQk3TTC@kongar>
User-Agent: Mutt/1.10.1 (2018-07-13)
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Sat, Nov 09, 2019 at 08:52:54PM +0100, Alexander Stein wrote:
>  On Saturday, November 9, 2019, 4:21:51 PM CET Vladimir Oltean wrote:
> > On 09/11/2019, Andrew Lunn <andrew@lunn.ch> wrote:
> > > On Sat, Nov 09, 2019 at 12:56:42PM +0200, Vladimir Oltean wrote:
> > >> On the LS1021A-TSN board, the 2 Atheros AR8031 PHYs for eth0 and eth1
> > >> have interrupt lines connected to the shared IRQ2_B LS1021A pin.
> > >>
> > >> The interrupts are active low, but the GICv2 controller does not support
> > >> active-low and falling-edge interrupts, so the only mode it can be
> > >> configured in is rising-edge.
> > >
> > > Hi Vladimir
> > >
> > > So how does this work? The rising edge would occur after the interrupt
> > > handler has completed? What triggers the interrupt handler?
> > >
> > > 	Andrew
> > >
> > 
> > Hi Andrew,
> > 
> > I hope I am not terribly confused about this. I thought I am telling
> > the interrupt controller to raise an IRQ as a result of the
> > low-to-high transition of the electrical signal. Experimentation sure
> > seems to agree with me. So the IRQ is generated immediately _after_
> > the PHY has left the line in open drain and it got pulled up to Vdd.
> 

> It is correct GIC only supports raising edge and active-high. The
> IRQ[0:5] on ls1021a are a bit special though.  They not directly
> connected to GIC, but there is an optional inverter, enabled by
> default.

Ah, O.K. So configuring for a rising edge is actually giving a falling
edge. Which is why it works.

Actually supporting this correctly is going a cause some pain. I
wonder how many DT files currently say rising/active high, when in
fact falling/active low is actually being used? And when the IRQ
controller really does support active low and falling, things brake?

Vladimir, since this is a shared interrupt, you really should use
active low here. Maybe the first step is to get control of the
inverter, and define a DT binding which is not going to break
backwards compatibility. And then wire up this interrupt.

	  Andrew
