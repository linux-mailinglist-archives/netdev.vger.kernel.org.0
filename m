Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 817DB22C6D8
	for <lists+netdev@lfdr.de>; Fri, 24 Jul 2020 15:39:42 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726676AbgGXNjj (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 24 Jul 2020 09:39:39 -0400
Received: from vps0.lunn.ch ([185.16.172.187]:53624 "EHLO vps0.lunn.ch"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726366AbgGXNjj (ORCPT <rfc822;netdev@vger.kernel.org>);
        Fri, 24 Jul 2020 09:39:39 -0400
Received: from andrew by vps0.lunn.ch with local (Exim 4.94)
        (envelope-from <andrew@lunn.ch>)
        id 1jyxv9-006gDH-Hp; Fri, 24 Jul 2020 15:39:31 +0200
Date:   Fri, 24 Jul 2020 15:39:31 +0200
From:   Andrew Lunn <andrew@lunn.ch>
To:     Jeremy Linton <jeremy.linton@arm.com>
Cc:     Calvin Johnson <calvin.johnson@oss.nxp.com>,
        Russell King - ARM Linux admin <linux@armlinux.org.uk>,
        Jon <jon@solid-run.com>,
        Cristi Sovaiala <cristian.sovaiala@nxp.com>,
        Ioana Ciornei <ioana.ciornei@nxp.com>,
        Andy Shevchenko <andy.shevchenko@gmail.com>,
        Florian Fainelli <f.fainelli@gmail.com>,
        Madalin Bucur <madalin.bucur@oss.nxp.com>,
        netdev@vger.kernel.org, linux.cj@gmail.com,
        linux-acpi@vger.kernel.org
Subject: Re: [net-next PATCH v7 1/6] Documentation: ACPI: DSD: Document MDIO
 PHY
Message-ID: <20200724133931.GF1472201@lunn.ch>
References: <20200715090400.4733-1-calvin.johnson@oss.nxp.com>
 <20200715090400.4733-2-calvin.johnson@oss.nxp.com>
 <1a031e62-1e87-fdc1-b672-e3ccf3530fda@arm.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1a031e62-1e87-fdc1-b672-e3ccf3530fda@arm.com>
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

> Otherwise the MDIO bus and its phy should be a
> child of the nic/mac using it, with standardized behaviors/etc left up to
> the OSPM when it comes to MDIO bus enumeration/etc.

Hi Jeremy 

Could you be a bit more specific here please.

DT allows

        macb0: ethernet@fffc4000 {
                compatible = "cdns,at32ap7000-macb";
                reg = <0xfffc4000 0x4000>;
                interrupts = <21>;
                phy-mode = "rmii";
                local-mac-address = [3a 0e 03 04 05 06];
                clock-names = "pclk", "hclk", "tx_clk";
                clocks = <&clkc 30>, <&clkc 30>, <&clkc 13>;
                ethernet-phy@1 {
                        reg = <0x1>;
                        reset-gpios = <&pioE 6 1>;
                };
        };

So the PHY is a direct child of the MAC. The MDIO bus is not modelled
at all. Although this is allowed, it is deprecated, because it results
in problems with advanced systems which have multiple different
children, and the need to differentiate them. So drivers are slowly
migrating to always modelling the MDIO bus. In that case, the
phy-handle is always used to point to the PHY:

        eth0: ethernet@522d0000 {
                compatible = "socionext,synquacer-netsec";
                reg = <0 0x522d0000 0x0 0x10000>, <0 0x10000000 0x0 0x10000>;
                interrupts = <GIC_SPI 176 IRQ_TYPE_LEVEL_HIGH>;
                clocks = <&clk_netsec>;
                clock-names = "phy_ref_clk";
                phy-mode = "rgmii";
                max-speed = <1000>;
                max-frame-size = <9000>;
                phy-handle = <&phy1>;

                mdio {
                        #address-cells = <1>;
                        #size-cells = <0>;
                        phy1: ethernet-phy@1 {
                                compatible = "ethernet-phy-ieee802.3-c22";
                                reg = <1>;
                        };
                };

"mdio-handle" is just half of phy-handle.

What you seem to be say is that although we have defined a generic
solution for ACPI which should work in all cases, it is suggested to
not use it? What exactly are you suggesting in its place?

	Andrew
