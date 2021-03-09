Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 2BBFF332C82
	for <lists+netdev@lfdr.de>; Tue,  9 Mar 2021 17:47:33 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230517AbhCIQrA (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 9 Mar 2021 11:47:00 -0500
Received: from vps0.lunn.ch ([185.16.172.187]:47942 "EHLO vps0.lunn.ch"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S230328AbhCIQqd (ORCPT <rfc822;netdev@vger.kernel.org>);
        Tue, 9 Mar 2021 11:46:33 -0500
Received: from andrew by vps0.lunn.ch with local (Exim 4.94)
        (envelope-from <andrew@lunn.ch>)
        id 1lJfV3-00A1Kq-A4; Tue, 09 Mar 2021 17:46:25 +0100
Date:   Tue, 9 Mar 2021 17:46:25 +0100
From:   Andrew Lunn <andrew@lunn.ch>
To:     "Wyse, Chris" <cwyse@canoga.com>
Cc:     "drichards@impinj.com" <drichards@impinj.com>,
        "netdev@vger.kernel.org" <netdev@vger.kernel.org>
Subject: Re: DSA
Message-ID: <YEemYTQ9EhQQ9jyH@lunn.ch>
References: <MWHPR06MB3503CE521D6993C7786A3E93DC8D0@MWHPR06MB3503.namprd06.prod.outlook.com>
 <20180430125030.GB10066@lunn.ch>
 <bf9115d87b65766dab2d5671eceb1764d0d8dc0c.camel@canoga.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <bf9115d87b65766dab2d5671eceb1764d0d8dc0c.camel@canoga.com>
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

> I have a board that uses the Intel i210, and I'd like it be the DSA
> master.  I'm looking for suggestions on how to proceed.
> 
> My configuration is an Intel E3950 CPU running Linux 4.19.62,

Hi Chris

That is old. Can you update to 5.10.22? If you plan submitting any
kernel patches, you will need to be using net-next.

> using
> UEFI/ACPI.  The board has a Xilinx FPGA that supports SFP & QSFP
> devices.  The SFP ports use the standard SFP driver & phylink.  The
> QSFP ports use a modified version of the SFP driver.

Rusell King has some currently out of tree patches for QSFP. Since he
wrote the SFP code, you should talk to him, see what is needed to get
his changes merged.

> It also includes an interface to an Intel i210 ethernet.
> 
> We use device tree overlays to load the information for the devices
> supported by the FPGA, then load an MFD FPGA driver that instantiates
> platform drivers for each of those devices.  One of the drivers that
> gets loaded is a DSA driver that has the SFP & QSFP devices as its
> slaves.  The intent is to use the Intel i210 on the master port of the
> DSA driver.

So the switch is inside the FPGA? What is the control path for this
switch? The biggest problem with i210 is its MDIO bus. MDIO is often
used to control an Ethernet switch. But if your switch is inside the
FPGA, i guess you are not using MDIO?

> At first glance, I believe I need to complete these tasks:
>   1.  Create a device tree node for the i210, providing information on
> the already loaded driver, that can be used by the DSA driver.
>   2.  Obtain or update a i210 driver that will work with DSA

Take a look at arch/arm/boot/dts/imx6qdl-zii-rdu2.dtsi

&pcie {
        pinctrl-names = "default";
        pinctrl-0 = <&pinctrl_pcie>;
        reset-gpio = <&gpio7 12 GPIO_ACTIVE_LOW>;
        status = "okay";

        host@0 {
                reg = <0 0 0 0 0>;

                #address-cells = <3>;
                #size-cells = <2>;

                i210: i210@0 {
                        reg = <0 0 0 0 0>;
                };
        };
};

So this is an i210 on the PCIe bus of an IMX6.

It never made it into mailine, but we did have a setup where instead
of using the FEC Ethernet controller inside the IMX6, we used the i210
as the master. The usual phandle to this i210 just worked. The switch
was managed via MDIO from the FEC, or bit banging.

So assuming you switch control is not via the i210 MDIO bus, with the
correct DT, it should 'just work'.

      Andrew
