Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 09B473F2CAE
	for <lists+netdev@lfdr.de>; Fri, 20 Aug 2021 15:02:09 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S240681AbhHTNCm (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 20 Aug 2021 09:02:42 -0400
Received: from vps0.lunn.ch ([185.16.172.187]:60642 "EHLO vps0.lunn.ch"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S240520AbhHTNCl (ORCPT <rfc822;netdev@vger.kernel.org>);
        Fri, 20 Aug 2021 09:02:41 -0400
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed; d=lunn.ch;
        s=20171124; h=In-Reply-To:Content-Disposition:Content-Type:MIME-Version:
        References:Message-ID:Subject:Cc:To:From:Date:From:Sender:Reply-To:Subject:
        Date:Message-ID:To:Cc:MIME-Version:Content-Type:Content-Transfer-Encoding:
        Content-ID:Content-Description:Content-Disposition:In-Reply-To:References;
        bh=JOimB47GACILb2RhQKIZ+znDpKjdnd4hYNprnm15ds0=; b=zv5IHNAUtWBsJCSY9/leF3jJHG
        LeKScnMXOvl7gj3K376Ij1m/kDv9oya1QywTlbScqH2SMV30RVTfxKR/7UdINvsdDkXbeDgEJVe93
        H41xeBiSE+0nYsL2aAvgaMaylL3KUC9T5FqWwWQ+snMMHYfa+9RiDz8Rl/z6sW07TZuc=;
Received: from andrew by vps0.lunn.ch with local (Exim 4.94.2)
        (envelope-from <andrew@lunn.ch>)
        id 1mH49l-0019iu-Bx; Fri, 20 Aug 2021 15:01:57 +0200
Date:   Fri, 20 Aug 2021 15:01:57 +0200
From:   Andrew Lunn <andrew@lunn.ch>
To:     Saravana Kannan <saravanak@google.com>
Cc:     Alvin =?utf-8?Q?=C5=A0ipraga?= <ALSI@bang-olufsen.dk>,
        Vladimir Oltean <olteanv@gmail.com>,
        Vladimir Oltean <vladimir.oltean@nxp.com>,
        "netdev@vger.kernel.org" <netdev@vger.kernel.org>,
        Jakub Kicinski <kuba@kernel.org>,
        "David S. Miller" <davem@davemloft.net>,
        Florian Fainelli <f.fainelli@gmail.com>,
        Vivien Didelot <vivien.didelot@gmail.com>,
        Frank Rowand <frowand.list@gmail.com>,
        Rob Herring <robh+dt@kernel.org>
Subject: Re: [PATCH net] net: dsa: sja1105: fix use-after-free after calling
 of_find_compatible_node, or worse
Message-ID: <YR+nxUNYxf1G0We7@lunn.ch>
References: <20210817145245.3555077-1-vladimir.oltean@nxp.com>
 <cd0d9c40-d07b-e2ab-b068-d0bcb4685d09@bang-olufsen.dk>
 <20210817223101.7wbdofi7xkeqa2cp@skbuf>
 <CAGETcx8T-ReJ_Gj-U+nxQyZPsv1v67DRBvpp9hS0fXgGRUQ17w@mail.gmail.com>
 <6b89a9e1-e92e-ca99-9fbd-1d98f6a7864b@bang-olufsen.dk>
 <CAGETcx_uj0V4DChME-gy5HGKTYnxLBX=TH2rag29f_p=UcG+Tg@mail.gmail.com>
 <YR5eMeKzcuYtB6Tk@lunn.ch>
 <CAGETcx9=AyEfjX_-adgRuX=8a0MkLnj8sy2KJGhxpNCinJu4yA@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <CAGETcx9=AyEfjX_-adgRuX=8a0MkLnj8sy2KJGhxpNCinJu4yA@mail.gmail.com>
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Thu, Aug 19, 2021 at 04:52:43PM -0700, Saravana Kannan wrote:
> On Thu, Aug 19, 2021 at 6:35 AM Andrew Lunn <andrew@lunn.ch> wrote:
> >
> > > (2) is what is happening in this case. fw_devlink=on sees that
> > > "switch" implements the "switch_intc" and "switch" hasn't finished
> > > probing yet. So it has no way of knowing that switch_intc is actually
> > > ready. And even if switch_intc was registered as part of switch's
> > > probe() by the time the PHYs are added, switch_intc could get
> > > deregistered if the probe fails at a later point. So until probe()
> > > returns 0, fw_devlink can't be fully sure the supplier (switch_intc)
> > > is ready. Which is good in general because you won't have to
> > > forcefully unbind (if that is even handled correctly in the first
> > > place) the consumers of a device if it fails probe() half way through
> > > registering a few services.
> 
> I had to read your email a couple of times before I understood it. I
> think I do now, but apologies if I'm not making sense.
> 
> >
> > There are actually a few different circular references with the way
> > switches work. Take for example:
> >
> > &fec1 {
> >         phy-mode = "rmii";
> >         pinctrl-names = "default";
> >         pinctrl-0 = <&pinctrl_fec1>;
> >         status = "okay";
> >
> >         fixed-link {
> >                 speed = <100>;
> >                 full-duplex;
> >         };
> >
> >         mdio1: mdio {
> >                 #address-cells = <1>;
> >                 #size-cells = <0>;
> >                 clock-frequency = <12500000>;
> >                 suppress-preamble;
> >                 status = "okay";
> >
> >                 switch0: switch0@0 {
> >                         compatible = "marvell,mv88e6190";
> >                         pinctrl-0 = <&pinctrl_gpio_switch0>;
> >                         pinctrl-names = "default";
> >                         reg = <0>;
> >                         eeprom-length = <65536>;
> >                         interrupt-parent = <&gpio3>;
> >                         interrupts = <2 IRQ_TYPE_LEVEL_LOW>;
> >                         interrupt-controller;
> >                         #interrupt-cells = <2>;
> >
> >                         ports {
> >                                 #address-cells = <1>;
> >                                 #size-cells = <0>;
> >
> >                                 port@0 {
> >                                         reg = <0>;
> >                                         label = "cpu";
> >                                         ethernet = <&fec1>;
> >
> >                                         fixed-link {
> >                                                 speed = <100>;
> >                                                 full-duplex;
> >                                         };
> >                                 };
> >
> > FEC is an ethernet controller. It has an MDIO bus, and on the bus is
> > an Ethernet switch. port 0 of the Ethernet switch is connected to the
> > FEC ethernet controller.
> >
> > While the FEC probes, it will at some point register its MDIO bus. At
> > that point, the MDIO bus is probed, the switch is found, and
> > registered with the switch core. The switch core looks for the port
> > with an ethernet property and goes looking for that ethernet
> > interface. But that this point in time, the FEC probe has only got as
> > far as registering the MDIO bus. The interface itself is not
> > registered. So finding the interface fails, and we go into
> > EPROBE_DEFER for probing the switch.
> 
> Ok, I understood up to here. Couple of questions:
> Is this EPROBE_DEFER causing an issue? Wouldn't the switch then
> probe successfully when it's reattempted? And then things work
> normally? I don't see what the problem is.

Everything works on the second time around. So there is no problem,
other than we waste time trying to probe the switch, which we know is
going to fail. Depending on the setup, this can add 1/2 second to the
boot time. 

> > It is pretty hard to solve. An Ethernet interface can be used by the
> > kernel itself, e.g. NFS root. At the point you call register_netdev()
> > in the probe function, to register the interface with the core,
> 
> Are you using "ethernet interface" and "ethernet controller"
> interchangeably?

Yeh, pretty much.

> Looking at some other drivers, it looks like the
> ethernet controlled (FEC) is what would call register_netdev(). So
> what's wrong with that happening if switch0 has not probed
> successfully?
> 
> > it
> > needs to be fully ready to go.  The networking stack can start using
> > the interface before register_netdev() even returns. So you cannot
> > first register the interface and then register the MDIO bus.
> >
> > I once looked to see if it was possible to tell the driver core to not
> > even bother probing a bus as soon as it is registered, go straight to
> > defer probe handling. Because this is one case we know it cannot
> > work. But it does not seem possible.
> 
> fw_devlink doesn't understand the "ethernet" property. If I add that,
> then in the example you state above, switch0's probe won't even be
> called until the FEC probe returns. The change is pretty trivial
> (pasted below) -- can you try it out and tell me if it does what you
> need/want?

Cool. I will try this.

Thanks
	Andrew
