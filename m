Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id B670744DB8E
	for <lists+netdev@lfdr.de>; Thu, 11 Nov 2021 19:23:40 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234389AbhKKS01 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 11 Nov 2021 13:26:27 -0500
Received: from vps0.lunn.ch ([185.16.172.187]:57028 "EHLO vps0.lunn.ch"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S232930AbhKKS01 (ORCPT <rfc822;netdev@vger.kernel.org>);
        Thu, 11 Nov 2021 13:26:27 -0500
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed; d=lunn.ch;
        s=20171124; h=In-Reply-To:Content-Disposition:Content-Type:MIME-Version:
        References:Message-ID:Subject:Cc:To:From:Date:From:Sender:Reply-To:Subject:
        Date:Message-ID:To:Cc:MIME-Version:Content-Type:Content-Transfer-Encoding:
        Content-ID:Content-Description:Content-Disposition:In-Reply-To:References;
        bh=Vn/FEUnwBAyr2EGt/+6N9yAjiUxR9PT2i5SKEAIC2/Q=; b=HZal7urJUrZK46lzxb474watrg
        fvc1bD30yeoEbxD9VK1Y+aKyif1zrvhP9cikm0U4u2eAeD4lzm7nEEZ04fsOicxS+oL9ryYXRK5iU
        h6QyopfXeoeoVgAO4zpwMAdvWJhZWzme48cF6uXJ7Gi3b0HL3ZC1dy5HboQfs/h1QCPk=;
Received: from andrew by vps0.lunn.ch with local (Exim 4.94.2)
        (envelope-from <andrew@lunn.ch>)
        id 1mlEjR-00DCxq-SZ; Thu, 11 Nov 2021 19:23:29 +0100
Date:   Thu, 11 Nov 2021 19:23:29 +0100
From:   Andrew Lunn <andrew@lunn.ch>
To:     Wells Lu <wellslutw@gmail.com>
Cc:     davem@davemloft.net, kuba@kernel.org, robh+dt@kernel.org,
        netdev@vger.kernel.org, devicetree@vger.kernel.org,
        linux-kernel@vger.kernel.org, p.zabel@pengutronix.de,
        vincent.shih@sunplus.com, Wells Lu <wells.lu@sunplus.com>
Subject: Re: [PATCH v2 1/2] devicetree: bindings: net: Add bindings doc for
 Sunplus SP7021.
Message-ID: <YY1fofJI0CW4Wmh5@lunn.ch>
References: <cover.1636620754.git.wells.lu@sunplus.com>
 <321e3b1a7dfca81f3ffae03b11099e8efeef92fa.1636620754.git.wells.lu@sunplus.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <321e3b1a7dfca81f3ffae03b11099e8efeef92fa.1636620754.git.wells.lu@sunplus.com>
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

> +examples:
> +  - |
> +    #include <dt-bindings/interrupt-controller/irq.h>
> +    emac: emac@9c108000 {
> +        compatible = "sunplus,sp7021-emac";
> +        reg = <0x9c108000 0x400>, <0x9c000280 0x80>;
> +        reg-names = "emac", "moon5";
> +        interrupt-parent = <&intc>;
> +        interrupts = <66 IRQ_TYPE_LEVEL_HIGH>;
> +        clocks = <&clkc 0xa7>;
> +        resets = <&rstc 0x97>;
> +        phy-handle1 = <&eth_phy0>;
> +        phy-handle2 = <&eth_phy1>;
> +        pinctrl-0 = <&emac_demo_board_v3_pins>;
> +        pinctrl-names = "default";
> +        nvmem-cells = <&mac_addr0>, <&mac_addr1>;
> +        nvmem-cell-names = "mac_addr0", "mac_addr1";
> +
> +        mdio {
> +            #address-cells = <1>;
> +            #size-cells = <0>;
> +            eth_phy0: ethernet-phy@0 {
> +                reg = <0>;
> +                phy-mode = "rmii";

This is in the wrong place. It is a MAC property. You usually put it
next to phy-handle.

> +            };
> +            eth_phy1: ethernet-phy@1 {
> +                reg = <1>;
> +                phy-mode = "rmii";
> +            };
> +        };

I would suggest you structure this differently to make it clear it is
a two port switch:

	ethernet-ports {
		#address-cells = <1>;
                #size-cells = <0>;

                port@0 {
                    reg = <0>;
		    phy-handle = <&eth_phy0>;
		    phy-mode = "rmii";
		}

		port@1 {
                    reg = <1>;
		    phy-handle = <&eth_phy1>;
		    phy-mode = "rmii";
		}
	}

	Andrew
