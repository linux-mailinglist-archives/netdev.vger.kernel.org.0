Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 090B8654334
	for <lists+netdev@lfdr.de>; Thu, 22 Dec 2022 15:34:45 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S235779AbiLVOem (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 22 Dec 2022 09:34:42 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:38812 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S235770AbiLVOej (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 22 Dec 2022 09:34:39 -0500
Received: from vps0.lunn.ch (vps0.lunn.ch [156.67.10.101])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 930AF2B626;
        Thu, 22 Dec 2022 06:34:38 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed; d=lunn.ch;
        s=20171124; h=In-Reply-To:Content-Disposition:Content-Type:MIME-Version:
        References:Message-ID:Subject:Cc:To:From:Date:From:Sender:Reply-To:Subject:
        Date:Message-ID:To:Cc:MIME-Version:Content-Type:Content-Transfer-Encoding:
        Content-ID:Content-Description:Content-Disposition:In-Reply-To:References;
        bh=GYQZnbopL0raC7rLaDWaAW0xzhT+Z/xrWz90yKT+r8s=; b=mVxNLmc6SMtnlEVEod854eFGzY
        Y+rKvdZQulq03Th2It4k4TOuHDcHOfEeCO/RCQluCtLRbAhQuusN/R3MRupzv/9RlEtLNDclGQtDx
        eMEfea48OEtXlaHDF0zt0D2epoL98XQUT+3jHQumjHFPZyIA5VpezC8OHWyBN2ddZzrw=;
Received: from andrew by vps0.lunn.ch with local (Exim 4.94.2)
        (envelope-from <andrew@lunn.ch>)
        id 1p8MeR-000GGh-Ee; Thu, 22 Dec 2022 15:34:27 +0100
Date:   Thu, 22 Dec 2022 15:34:27 +0100
From:   Andrew Lunn <andrew@lunn.ch>
To:     Vladimir Oltean <vladimir.oltean@nxp.com>
Cc:     Rob Herring <robh+dt@kernel.org>,
        Krzysztof Kozlowski <krzysztof.kozlowski+dt@linaro.org>,
        Florian Fainelli <f.fainelli@gmail.com>,
        Lee Jones <lee@kernel.org>,
        Colin Foster <colin.foster@in-advantage.com>,
        Alexandre Belloni <alexandre.belloni@bootlin.com>,
        netdev@vger.kernel.org, linux-kernel@vger.kernel.org,
        devicetree@vger.kernel.org
Subject: Re: Advice on MFD-style probing of DSA switch SoCs
Message-ID: <Y6Rq8+wYpDkGGbYs@lunn.ch>
References: <20221222134844.lbzyx5hz7z5n763n@skbuf>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20221222134844.lbzyx5hz7z5n763n@skbuf>
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,SPF_HELO_PASS,SPF_PASS
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

> I think that doesn't scale very well either, so I was looking into
> transitioning the sja1105 bindings to something similar to what Colin
> Foster has done with vsc7512 (ocelot). For this switch, new-style
> bindings would look like this:

Have you looked at probe ordering issues? MFD devices i've played with
are very independent. They are a bunch of IP blocks sharing a bus. A
switch however is very interconnected.

> 
> 	soc@2 {
> 		compatible = "nxp,sja1110-soc";
> 		reg = <2>;
> 		spi-max-frequency = <4000000>;
> 		spi-cpol;
> 		#address-cells = <1>;
> 		#size-cells = <1>;
> 
> 		sw2: ethernet-switch@0 {
> 			compatible = "nxp,sja1110a";
> 			reg = <0x000000 0x400000>;
> 			resets = <&sw2_rgu SJA1110_RGU_ETHSW_RST>;
> 			dsa,member = <0 1>;
> 
> 			ethernet-ports {
> 				#address-cells = <1>;
> 				#size-cells = <0>;

...

> 
> 				port@3 {
> 					reg = <3>;
> 					label = "1ge_p2";
> 					phy-mode = "rgmii-id";
> 					phy-handle = <&sw2_mii3_phy>;
> 				};


So for the switch to probe, the PHY needs to probe first.

> 		mdio@704000 {
> 			compatible = "nxp,sja1110-base-t1-mdio";
> 			#address-cells = <1>;
> 			#size-cells = <0>;
> 			reg = <0x704000 0x1000>;
> 
> 			sw2_port5_base_t1_phy: ethernet-phy@1 {
> 				compatible = "ethernet-phy-ieee802.3-c45";
> 				reg = <0x1>;
> 				interrupts-extended = <&slir2 SJA1110_IRQ_CBT1_PHY1>;
> 			};

For the PHY to probe requires that the interrupt controller probes first.


> 		slir2: interrupt-controller@711fe0 {
> 			compatible = "nxp,sja1110-acu-slir";
> 			reg = <0x711fe0 0x10>;
> 			interrupt-controller;
> 			#interrupt-cells = <1>;
> 			interrupt-parent = <&gpio 10>;
> 		};

and the interrupt controller requires its parent gpio controller
probes first. I assume this is the host SOC GPIO controller, not the
switches GPIO controller.

> 		sw2_rgu: reset@718000 {
> 			compatible = "nxp,sja1110-rgu";
> 			reg = <0x718000 0x1000>;
> 			#reset-cells = <1>;
> 		};

and presumably something needs to hit the reset at some point? Will
there be DT phandles to this?

> 
> 		sw2_cgu: clock-controller@719000 {
> 			compatible = "nxp,sja1110-cgu";
> 			reg = <0x719000 0x1000>;
> 			#clock-cells = <1>;
> 		};

and phandles to the clock driver?

Before doing too much in this direction, i would want to be sure you
have sufficient control of ordering and the DT loops are not too
complex, that the MFD core and the driver core can actually get
everything probed.

The current way of doing it, with the drivers embedded inside the DSA
driver is that DT blob only exposes what needs to be seen outside of
the DSA driver. And the driver has full control over the order it
probes its internal sub drivers, so ensuring they are probed in the
correct order, and the linking is done in C, not DT, were again the
driver is in full control.

I do however agree that being able to split sub drivers out of the
main driver is a good idea, and putting them in the appropriated
subsystem would help with code review.

Maybe the media subsystem has some pointers how to do this. It also
has complex devices made up from lots of sub devices.

    Andrew

