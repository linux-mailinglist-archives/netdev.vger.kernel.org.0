Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id E6ECC372A1D
	for <lists+netdev@lfdr.de>; Tue,  4 May 2021 14:32:58 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230348AbhEDMcr (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 4 May 2021 08:32:47 -0400
Received: from vps0.lunn.ch ([185.16.172.187]:52298 "EHLO vps0.lunn.ch"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S230110AbhEDMcq (ORCPT <rfc822;netdev@vger.kernel.org>);
        Tue, 4 May 2021 08:32:46 -0400
Received: from andrew by vps0.lunn.ch with local (Exim 4.94)
        (envelope-from <andrew@lunn.ch>)
        id 1lduD8-002Tjq-Qa; Tue, 04 May 2021 14:31:34 +0200
Date:   Tue, 4 May 2021 14:31:34 +0200
From:   Andrew Lunn <andrew@lunn.ch>
To:     Colin Foster <colin.foster@in-advantage.com>
Cc:     Rob Herring <robh+dt@kernel.org>,
        Vladimir Oltean <vladimir.oltean@nxp.com>,
        Claudiu Manoil <claudiu.manoil@nxp.com>,
        Alexandre Belloni <alexandre.belloni@bootlin.com>,
        "supporter:OCELOT ETHERNET SWITCH DRIVER" 
        <UNGLinuxDriver@microchip.com>,
        Vivien Didelot <vivien.didelot@gmail.com>,
        Florian Fainelli <f.fainelli@gmail.com>,
        "David S. Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>,
        Russell King <linux@armlinux.org.uk>,
        "open list:OPEN FIRMWARE AND FLATTENED DEVICE TREE BINDINGS" 
        <devicetree@vger.kernel.org>,
        open list <linux-kernel@vger.kernel.org>,
        "open list:OCELOT ETHERNET SWITCH DRIVER" <netdev@vger.kernel.org>
Subject: Re: [RFC PATCH vN net-next 2/2] net: mscc: ocelot: add support for
 VSC75XX SPI control
Message-ID: <YJE+prMCIMiQm26Z@lunn.ch>
References: <20210504051130.1207550-1-colin.foster@in-advantage.com>
 <20210504051130.1207550-2-colin.foster@in-advantage.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20210504051130.1207550-2-colin.foster@in-advantage.com>
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Mon, May 03, 2021 at 10:11:27PM -0700, Colin Foster wrote:
> Add support for control for VSC75XX chips over SPI control. Starting with the
> VSC9959 code, this will utilize a spi bus instead of PCIe or memory-mapped IO to
> control the chip.

Hi Colin

Please fix your subject line for the next version. vN should of been
v1. The number is important so we can tell revisions apart.

> 
> Signed-off-by: Colin Foster <colin.foster@in-advantage.com>
> ---
>  arch/arm/boot/dts/rpi-vsc7512-spi-overlay.dts |  124 ++
>  drivers/net/dsa/ocelot/Kconfig                |   11 +
>  drivers/net/dsa/ocelot/Makefile               |    5 +
>  drivers/net/dsa/ocelot/felix_vsc7512_spi.c    | 1214 +++++++++++++++++
>  include/soc/mscc/ocelot.h                     |   15 +

Please split this patch up. The DT overlay will probably be merged via
ARM SOC, not netdev. You also need to document the device tree
binding, as a separate patch.

> +	fragment@3 {
> +		target = <&spi0>;
> +		__overlay__ {
> +			#address-cells = <1>;
> +			#size-cells = <0>;
> +			cs-gpios = <&gpio 8 1>;
> +			status = "okay";
> +
> +			vsc7512: vsc7512@0{
> +				compatible = "mscc,vsc7512";
> +				spi-max-frequency = <250000>;
> +				reg = <0>;
> +
> +				ports {
> +					#address-cells = <1>;
> +					#size-cells = <0>;
> +
> +					port@0 {
> +						reg = <0>;
> +						ethernet = <&ethernet>;
> +						phy-mode = "internal";
> +
> +						fixed-link {
> +							speed = <1000>;
> +							full-duplex;
> +						};
> +					};
> +
> +					port@1 {
> +						reg = <1>;
> +						label = "swp1";
> +						status = "disabled";
> +					};
> +
> +					port@2 {
> +						reg = <2>;
> +						label = "swp2";
> +						status = "disabled";
> +					};

I'm surprised all the ports are disabled. I could understand that for
a DTSI file, but a DTS overlay?

> +++ b/drivers/net/dsa/ocelot/felix_vsc7512_spi.c
> @@ -0,0 +1,1214 @@
> +// SPDX-License-Identifier: (GPL-2.0 OR MIT)
> +/* Copyright 2017 Microsemi Corporation
> + * Copyright 2018-2019 NXP Semiconductors
> + */
> +#include <soc/mscc/ocelot_qsys.h>
> +#include <soc/mscc/ocelot_vcap.h>
> +#include <soc/mscc/ocelot_ptp.h>
> +#include <soc/mscc/ocelot_sys.h>
> +#include <soc/mscc/ocelot.h>
> +#include <linux/spi/spi.h>
> +#include <linux/packing.h>
> +#include <linux/pcs-lynx.h>
> +#include <net/pkt_sched.h>
> +#include <linux/iopoll.h>
> +#include <linux/kconfig.h>
> +#include <linux/mdio.h>
> +#include "felix.h"
> +
> +#define VSC7512_TAS_GCL_ENTRY_MAX 63
> +
> +// Note: These addresses and offsets are all shifted down
> +// by two. This is because the SPI protocol needs them to
> +// be before they get sent out.
> +//
> +// An alternative is to keep them standardized, but then
> +// a separate spi_bus regmap would need to be defined.
> +//
> +// That might be optimal though. The 'Read' protocol of
> +// the VSC driver might be much quicker if we add padding
> +// bytes, which I don't think regmap supports.

C style comments please.

> +static void vsc7512_phylink_validate(struct ocelot *ocelot, int port,
> +				     unsigned long *supported,
> +				     struct phylink_link_state *state)
> +{
> +	struct ocelot_port *ocelot_port = ocelot->ports[port];
> +	__ETHTOOL_DECLARE_LINK_MODE_MASK(mask) = {
> +		0,
> +	};

This function seems out of place. Why would SPI access change what the
ports are capable of doing? Please split this up into more
patches. Keep the focus of this patch as being adding SPI support.

	 Andrew
