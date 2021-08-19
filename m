Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id DCE2B3F1A74
	for <lists+netdev@lfdr.de>; Thu, 19 Aug 2021 15:35:52 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S240012AbhHSNg1 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 19 Aug 2021 09:36:27 -0400
Received: from vps0.lunn.ch ([185.16.172.187]:58446 "EHLO vps0.lunn.ch"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S240010AbhHSNg0 (ORCPT <rfc822;netdev@vger.kernel.org>);
        Thu, 19 Aug 2021 09:36:26 -0400
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed; d=lunn.ch;
        s=20171124; h=In-Reply-To:Content-Disposition:Content-Type:MIME-Version:
        References:Message-ID:Subject:Cc:To:From:Date:From:Sender:Reply-To:Subject:
        Date:Message-ID:To:Cc:MIME-Version:Content-Type:Content-Transfer-Encoding:
        Content-ID:Content-Description:Content-Disposition:In-Reply-To:References;
        bh=V5jHhDV1c6P8nuNBrs+Sc4uIZf3xCOEXlWMVOOJ6w6Q=; b=EHBApSPUpPBCOh/BQYKIG57a9q
        R13PZ1yUx8oy6wypPOaIlOM+vxNC8f2BqTSzB4GkPsfoKzSRgay1aj/nfweuZ+TV/8aHHEVWX7wnC
        OG5a6slb0vP0DAqor3RLFCCBKDjtQzT0Ku2gzS8vD5HOHQt4lLpEbIIWmmCpCqAqGZHY=;
Received: from andrew by vps0.lunn.ch with local (Exim 4.94.2)
        (envelope-from <andrew@lunn.ch>)
        id 1mGiCv-000yQB-AX; Thu, 19 Aug 2021 15:35:45 +0200
Date:   Thu, 19 Aug 2021 15:35:45 +0200
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
Message-ID: <YR5eMeKzcuYtB6Tk@lunn.ch>
References: <20210817145245.3555077-1-vladimir.oltean@nxp.com>
 <cd0d9c40-d07b-e2ab-b068-d0bcb4685d09@bang-olufsen.dk>
 <20210817223101.7wbdofi7xkeqa2cp@skbuf>
 <CAGETcx8T-ReJ_Gj-U+nxQyZPsv1v67DRBvpp9hS0fXgGRUQ17w@mail.gmail.com>
 <6b89a9e1-e92e-ca99-9fbd-1d98f6a7864b@bang-olufsen.dk>
 <CAGETcx_uj0V4DChME-gy5HGKTYnxLBX=TH2rag29f_p=UcG+Tg@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <CAGETcx_uj0V4DChME-gy5HGKTYnxLBX=TH2rag29f_p=UcG+Tg@mail.gmail.com>
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

> (2) is what is happening in this case. fw_devlink=on sees that
> "switch" implements the "switch_intc" and "switch" hasn't finished
> probing yet. So it has no way of knowing that switch_intc is actually
> ready. And even if switch_intc was registered as part of switch's
> probe() by the time the PHYs are added, switch_intc could get
> deregistered if the probe fails at a later point. So until probe()
> returns 0, fw_devlink can't be fully sure the supplier (switch_intc)
> is ready. Which is good in general because you won't have to
> forcefully unbind (if that is even handled correctly in the first
> place) the consumers of a device if it fails probe() half way through
> registering a few services.

There are actually a few different circular references with the way
switches work. Take for example:

&fec1 {
        phy-mode = "rmii";
        pinctrl-names = "default";
        pinctrl-0 = <&pinctrl_fec1>;
        status = "okay";

        fixed-link {
                speed = <100>;
                full-duplex;
        };

        mdio1: mdio {
                #address-cells = <1>;
                #size-cells = <0>;
                clock-frequency = <12500000>;
                suppress-preamble;
                status = "okay";

                switch0: switch0@0 {
                        compatible = "marvell,mv88e6190";
                        pinctrl-0 = <&pinctrl_gpio_switch0>;
                        pinctrl-names = "default";
                        reg = <0>;
                        eeprom-length = <65536>;
                        interrupt-parent = <&gpio3>;
                        interrupts = <2 IRQ_TYPE_LEVEL_LOW>;
                        interrupt-controller;
                        #interrupt-cells = <2>;

                        ports {
                                #address-cells = <1>;
                                #size-cells = <0>;

                                port@0 {
                                        reg = <0>;
                                        label = "cpu";
                                        ethernet = <&fec1>;

                                        fixed-link {
                                                speed = <100>;
                                                full-duplex;
                                        };
                                };

FEC is an ethernet controller. It has an MDIO bus, and on the bus is
an Ethernet switch. port 0 of the Ethernet switch is connected to the
FEC ethernet controller.

While the FEC probes, it will at some point register its MDIO bus. At
that point, the MDIO bus is probed, the switch is found, and
registered with the switch core. The switch core looks for the port
with an ethernet property and goes looking for that ethernet
interface. But that this point in time, the FEC probe has only got as
far as registering the MDIO bus. The interface itself is not
registered. So finding the interface fails, and we go into
EPROBE_DEFER for probing the switch.

It is pretty hard to solve. An Ethernet interface can be used by the
kernel itself, e.g. NFS root. At the point you call register_netdev()
in the probe function, to register the interface with the core, it
needs to be fully ready to go.  The networking stack can start using
the interface before register_netdev() even returns. So you cannot
first register the interface and then register the MDIO bus.

I once looked to see if it was possible to tell the driver core to not
even bother probing a bus as soon as it is registered, go straight to
defer probe handling. Because this is one case we know it cannot
work. But it does not seem possible.

      Andrew
