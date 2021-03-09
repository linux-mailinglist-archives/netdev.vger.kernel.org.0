Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 251863331C5
	for <lists+netdev@lfdr.de>; Tue,  9 Mar 2021 23:54:23 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232005AbhCIWxt (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 9 Mar 2021 17:53:49 -0500
Received: from vps0.lunn.ch ([185.16.172.187]:48472 "EHLO vps0.lunn.ch"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S232026AbhCIWxm (ORCPT <rfc822;netdev@vger.kernel.org>);
        Tue, 9 Mar 2021 17:53:42 -0500
Received: from andrew by vps0.lunn.ch with local (Exim 4.94)
        (envelope-from <andrew@lunn.ch>)
        id 1lJlES-00A52y-4B; Tue, 09 Mar 2021 23:53:40 +0100
Date:   Tue, 9 Mar 2021 23:53:40 +0100
From:   Andrew Lunn <andrew@lunn.ch>
To:     "Wyse, Chris" <cwyse@canoga.com>
Cc:     "netdev@vger.kernel.org" <netdev@vger.kernel.org>,
        "drichards@impinj.com" <drichards@impinj.com>
Subject: Re: DSA
Message-ID: <YEf8dFUCB+/vMkU8@lunn.ch>
References: <MWHPR06MB3503CE521D6993C7786A3E93DC8D0@MWHPR06MB3503.namprd06.prod.outlook.com>
 <20180430125030.GB10066@lunn.ch>
 <bf9115d87b65766dab2d5671eceb1764d0d8dc0c.camel@canoga.com>
 <YEemYTQ9EhQQ9jyH@lunn.ch>
 <20fd4a9ce09117e765dbf63f1baa9da5c834a64b.camel@canoga.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20fd4a9ce09117e765dbf63f1baa9da5c834a64b.camel@canoga.com>
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

> > Take a look at arch/arm/boot/dts/imx6qdl-zii-rdu2.dtsi
> >
> > &pcie {
> >         pinctrl-names = "default";
> >         pinctrl-0 = <&pinctrl_pcie>;
> >         reset-gpio = <&gpio7 12 GPIO_ACTIVE_LOW>;
> >         status = "okay";
> >
> >         host@0 {
> >                 reg = <0 0 0 0 0>;
> >
> >                 #address-cells = <3>;
> >                 #size-cells = <2>;
> >
> >                 i210: i210@0 {
> >                         reg = <0 0 0 0 0>;
> >                 };
> >         };
> > };
> >
> I'll look at this, but one thing I see initially is that there are
> references to other nodes that are not present in our device tree
> overlay.  The overlay solely supports the IP modules in the FPGA.  Both
> of our PCIe buses are handled via the ACPI table.  I'm not sure how to
> handle something that already has an ACPI node.

Overlay is also possibly too late. Maybe. I guess you need the DT
available at the time the PCIe controller probes the bus. The core
PCIe code then pokes around in the DT and finds the node which
corresponds to the device on the bus. You might be able to work around
this with pci hotplugging? Load the overlay, and then trigger a hot
unplug/plug of the i210 via files in /sys? The relevant bit of code is
pci_set_of_node() which appears to get called independent of ACPI or
DT.

Otherwise you need to go the platform driver route. What works for mv88e6xxx is

static struct dsa_mv88e6xxx_pdata dsa_mv88e6xxx_pdata = {
        .cd = {
                .port_names[0] = NULL,
                .port_names[1] = "cpu",
                .port_names[2] = "red",
                .port_names[3] = "blue",
                .port_names[4] = "green",
                .port_names[5] = NULL,
                .port_names[6] = NULL,
                .port_names[7] = NULL,
                .port_names[8] = "waic0",
        },
        .compatible = "marvell,mv88e6190",
        .enabled_ports = BIT(1) | BIT(2) | BIT(3) | BIT(4) | BIT(8),
        .eeprom_len = 65536,
};

static const struct mdio_board_info bdinfo = {
        .bus_id = "gpio-0",
        .modalias = "mv88e6085",
        .mdio_addr = 0,
        .platform_data = &dsa_mv88e6xxx_pdata,
};

        dsa_mv88e6xxx_pdata.netdev = dev_get_by_name(&init_net, "eth0");
        if (!dsa_mv88e6xxx_pdata.netdev) {
                dev_err(dev, "Error finding Ethernet device\n");
                return -ENODEV;
        }

        err = mdiobus_register_board_info(&bdinfo, 1);
        if (err) {
                dev_err(dev, "Error setting up MDIO board info\n");
                goto out;
        }

On this device, there is a bit-banging MDIO driver. The MDIO core has
the needed code to associate the mdio_board_info to the bus, such that
after the bus probes, it adds a platform device on that bus, the
switch. The mv88e6xxx gets the dsa_mv88e6xxx_pdata, containing the
name of the Ethernet interface. You can probably do something similar
in your MFD for the FPGA.

This a bit fragile. systemd can come in and rename your interface from
eth0 to enp1s0, and then dev_get_by_name(). The advantage of DT is
that the name does not matter, you point directly at the device.

The other problem with this is you don't have a DT representation of
the switch, making it hard to use phylink for the SFPs, etc. So
getting overlays working would be best.

     Andrew
