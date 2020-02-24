Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id AD12E169E8C
	for <lists+netdev@lfdr.de>; Mon, 24 Feb 2020 07:37:14 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727235AbgBXGhI (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 24 Feb 2020 01:37:08 -0500
Received: from mail.kernel.org ([198.145.29.99]:35046 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726060AbgBXGhH (ORCPT <rfc822;netdev@vger.kernel.org>);
        Mon, 24 Feb 2020 01:37:07 -0500
Received: from dragon (80.251.214.228.16clouds.com [80.251.214.228])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 0860520661;
        Mon, 24 Feb 2020 06:37:03 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1582526226;
        bh=nteMY6ukhs8V/oKG37aUtU6inGDQFjnMuRAfI/7pHrg=;
        h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
        b=oTmb9lI6BrX9vuK8J+iX1SciGipjUms1Qwtmz6To5leJaFyHn5Mm/fri5+EnBcQt8
         w3FVCNVLjns8Kht/qG1iSmf57L3+VD25346O9iPNOXkKULV/f7tRafpGFHtQzouj2m
         SgB431ifbvn4+wC3OeyQ8klGnX4MbebuBBjWeNy8=
Date:   Mon, 24 Feb 2020 14:36:59 +0800
From:   Shawn Guo <shawnguo@kernel.org>
To:     Vladimir Oltean <olteanv@gmail.com>
Cc:     robh+dt@kernel.org, mark.rutland@arm.com,
        devicetree@vger.kernel.org, davem@davemloft.net,
        netdev@vger.kernel.org, andrew@lunn.ch, vivien.didelot@gmail.com,
        f.fainelli@gmail.com, linux-kernel@vger.kernel.org
Subject: Re: [PATCH v2 net-next/devicetree 4/5] arm64: dts: fsl: ls1028a: add
 node for Felix switch
Message-ID: <20200224063655.GM27688@dragon>
References: <20200219151259.14273-1-olteanv@gmail.com>
 <20200219151259.14273-5-olteanv@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20200219151259.14273-5-olteanv@gmail.com>
User-Agent: Mutt/1.9.4 (2018-02-28)
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Wed, Feb 19, 2020 at 05:12:58PM +0200, Vladimir Oltean wrote:
> From: Claudiu Manoil <claudiu.manoil@nxp.com>
> 
> Add the switch device node, available on PF5, so that the switch port
> sub-nodes (net devices) can be linked to corresponding board specific
> phy nodes (external ports) or have their link mode defined (internal
> ports).
> 
> The switch device features 6 ports, 4 with external links and 2
> internally facing to the LS1028A SoC and connected via fixed links to 2
> internal ENETC Ethernet controller ports.
> 
> Add the corresponding ENETC host port device nodes, mapped to PF2 and
> PF6 PCIe functions. Since the switch only supports tagging on one CPU
> port, only one port pair (swp4, eno2) is enabled by default and the
> other, lower speed, port pair is disabled to prevent the PCI core from
> probing them. If enabled, swp5 will be a fixed-link slave port.
> 
> DSA tagging can also be moved from the swp4-eno2 2.5G port pair to the
> 1G swp5-eno3 pair by changing the ethernet = <&enetc_port2> phandle to
> <&enetc_port3> and moving it under port5, but in that case enetc_port2
> should not be disabled, because it is the hardware owner of the Felix
> PCS and disabling its memory would result in access faults in the Felix
> DSA driver.
> 
> All ports are disabled by default, except one CPU port.
> 
> The switch's INTB interrupt line signals:
> - PTP timestamp ready in timestamp FIFO
> - TSN Frame Preemption
> 
> And don't forget to enable the 4MB BAR4 in the root complex ECAM space,
> where the switch registers are mapped.
> 
> Signed-off-by: Claudiu Manoil <claudiu.manoil@nxp.com>
> Signed-off-by: Alex Marginean <alexandru.marginean@nxp.com>
> Signed-off-by: Yangbo Lu <yangbo.lu@nxp.com>
> Signed-off-by: Vladimir Oltean <vladimir.oltean@nxp.com>
> ---
> Changes in v2:
> Adapted phy-mode = "gmii" to phy-mode = "internal".
> 
>  .../arm64/boot/dts/freescale/fsl-ls1028a.dtsi | 84 ++++++++++++++++++-
>  1 file changed, 83 insertions(+), 1 deletion(-)
> 
> diff --git a/arch/arm64/boot/dts/freescale/fsl-ls1028a.dtsi b/arch/arm64/boot/dts/freescale/fsl-ls1028a.dtsi
> index dfead691e509..a6b9c6d1eb5e 100644
> --- a/arch/arm64/boot/dts/freescale/fsl-ls1028a.dtsi
> +++ b/arch/arm64/boot/dts/freescale/fsl-ls1028a.dtsi
> @@ -700,7 +700,9 @@
>  				  /* PF1: VF0-1 BAR0 - non-prefetchable memory */
>  				  0x82000000 0x0 0x00000000  0x1 0xf8210000  0x0 0x020000
>  				  /* PF1: VF0-1 BAR2 - prefetchable memory */
> -				  0xc2000000 0x0 0x00000000  0x1 0xf8230000  0x0 0x020000>;
> +				  0xc2000000 0x0 0x00000000  0x1 0xf8230000  0x0 0x020000
> +				  /* BAR4 (PF5) - non-prefetchable memory */
> +				  0x82000000 0x0 0x00000000  0x1 0xfc000000  0x0 0x400000>;
>  
>  			enetc_port0: ethernet@0,0 {
>  				compatible = "fsl,enetc";
> @@ -710,6 +712,18 @@
>  				compatible = "fsl,enetc";
>  				reg = <0x000100 0 0 0 0>;
>  			};
> +
> +			enetc_port2: ethernet@0,2 {
> +				compatible = "fsl,enetc";
> +				reg = <0x000200 0 0 0 0>;
> +				phy-mode = "gmii";
> +
> +				fixed-link {
> +					speed = <1000>;
> +					full-duplex;
> +				};
> +			};
> +
>  			enetc_mdio_pf3: mdio@0,3 {
>  				compatible = "fsl,enetc-mdio";
>  				reg = <0x000300 0 0 0 0>;
> @@ -722,6 +736,74 @@
>  				clocks = <&clockgen 4 0>;
>  				little-endian;
>  			};
> +
> +			ethernet-switch@0,5 {
> +				reg = <0x000500 0 0 0 0>;
> +				/* IEP INT_B */
> +				interrupts = <GIC_SPI 95 IRQ_TYPE_LEVEL_HIGH>;
> +
> +				ports {
> +					#address-cells = <1>;
> +					#size-cells = <0>;
> +
> +					/* external ports */
> +					mscc_felix_port0: port@0 {
> +						reg = <0>;
> +						status = "disabled";
> +					};
> +
> +					mscc_felix_port1: port@1 {
> +						reg = <1>;
> +						status = "disabled";
> +					};
> +
> +					mscc_felix_port2: port@2 {
> +						reg = <2>;
> +						status = "disabled";
> +					};
> +
> +					mscc_felix_port3: port@3 {
> +						reg = <3>;
> +						status = "disabled";
> +					};
> +
> +					/* Internal port with DSA tagging */
> +					mscc_felix_port4: port@4 {
> +						reg = <4>;
> +						phy-mode = "internal";
> +						ethernet = <&enetc_port2>;
> +
> +						fixed-link {
> +							speed = <2500>;
> +							full-duplex;
> +						};
> +					};
> +
> +					/* Internal port without DSA tagging */
> +					mscc_felix_port5: port@5 {
> +						reg = <5>;
> +						phy-mode = "internal";
> +						status = "disabled";
> +
> +						fixed-link {
> +							speed = <1000>;
> +							full-duplex;
> +						};
> +					};
> +				};
> +			};
> +
> +			enetc_port3: ethernet@0,6 {
> +				compatible = "fsl,enetc";
> +				reg = <0x000600 0 0 0 0>;
> +				status = "disabled";

Please have 'status' at bottom of the property list.

Shawn

> +				phy-mode = "gmii";
> +
> +				fixed-link {
> +					speed = <1000>;
> +					full-duplex;
> +				};
> +			};
>  		};
>  	};
>  
> -- 
> 2.17.1
> 
