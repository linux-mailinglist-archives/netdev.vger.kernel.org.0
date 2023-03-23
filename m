Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 684246C6AA5
	for <lists+netdev@lfdr.de>; Thu, 23 Mar 2023 15:20:05 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231627AbjCWOT7 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 23 Mar 2023 10:19:59 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:50388 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231743AbjCWOT3 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 23 Mar 2023 10:19:29 -0400
Received: from vps0.lunn.ch (vps0.lunn.ch [156.67.10.101])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 0E5033403D
        for <netdev@vger.kernel.org>; Thu, 23 Mar 2023 07:19:24 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed; d=lunn.ch;
        s=20171124; h=In-Reply-To:Content-Disposition:Content-Type:MIME-Version:
        References:Message-ID:Subject:Cc:To:From:Date:From:Sender:Reply-To:Subject:
        Date:Message-ID:To:Cc:MIME-Version:Content-Type:Content-Transfer-Encoding:
        Content-ID:Content-Description:Content-Disposition:In-Reply-To:References;
        bh=/yPfIhK2CW+V1Ih2tVzFoUkOX1EaGIBx3YPMWWOZ8hI=; b=UTnXYsQsrdPJ9M7yEg/XyNQjRm
        ywG5l1z5sc67aM1Sa/G/7DbWMxetyvAf70gXzBh/+dOTb7hn9vYMdMRR72Z+e2h1Kw4vY4HNIMO15
        cMDCRYUzoV15ygUuXy41+1jNygPVmTgIJ9F6Q7DHGCWmjIn0uUU0Sjak82Bn+29cASK8=;
Received: from andrew by vps0.lunn.ch with local (Exim 4.94.2)
        (envelope-from <andrew@lunn.ch>)
        id 1pfLmj-008ClS-Sg; Thu, 23 Mar 2023 15:19:21 +0100
Date:   Thu, 23 Mar 2023 15:19:21 +0100
From:   Andrew Lunn <andrew@lunn.ch>
To:     "Buzarra, Arturo" <Arturo.Buzarra@digi.com>
Cc:     Heiner Kallweit <hkallweit1@gmail.com>,
        "netdev@vger.kernel.org" <netdev@vger.kernel.org>,
        Florian Fainelli <f.fainelli@gmail.com>,
        Russell King - ARM Linux <linux@armlinux.org.uk>
Subject: Re: [PATCH] net: phy: return EPROBE_DEFER if PHY is not accessible
Message-ID: <156b7aee-b61a-40b9-ac51-59bcaef0c129@lunn.ch>
References: <20230317121646.19616-1-arturo.buzarra@digi.com>
 <3e904a01-7ea8-705c-bf7a-05059729cebf@gmail.com>
 <DS7PR10MB4926EBB7DAA389E69A4E2FC1FA809@DS7PR10MB4926.namprd10.prod.outlook.com>
 <74cef958-9513-40d7-8da4-7a566ba47291@lunn.ch>
 <DS7PR10MB49260FFA60F0B3A5AB7AD69EFA879@DS7PR10MB4926.namprd10.prod.outlook.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <DS7PR10MB49260FFA60F0B3A5AB7AD69EFA879@DS7PR10MB4926.namprd10.prod.outlook.com>
X-Spam-Status: No, score=-0.2 required=5.0 tests=DKIM_SIGNED,DKIM_VALID,
        DKIM_VALID_AU,DKIM_VALID_EF,SPF_HELO_PASS,SPF_PASS
        autolearn=unavailable autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

> Gigabit PHY has its own Crystal, however the 10/100 PHY uses a clock
> from the CPU and it is the root cause of the issue because when
> Linux asks the PHY capabilities the clock is not ready yet.

O.K, now we are getting closer.

Which clock is it exactly? Both for the MAC and the PHY?

> We have identified the root cause of the 0xFFFF issue, it is because
> the two PHYs are defined in the same MDIO bus node inside the first
> Ethernet MAC node, and when the 10/100 PHY is probed the PHY Clock
> from the CPU is not ready, this is the DT definition:


> ---------
> /* Gigabit Ethernet */
> &eth1 {
> 	status = "okay";
> 	pinctrl-0 = <&eth1_rgmii_pins>;
> 	pinctrl-names = "default";
> 	phy-mode = "rgmii-id";
> 	max-speed = <1000>;
> 	phy-handle = <&phy0_eth1>;
> 
> 	mdio1 {
> 		#address-cells = <1>;
> 		#size-cells = <0>;
> 		compatible = "snps,dwmac-mdio";
> 
> 		phy0_eth1: ethernet-phy@0 {
> 			reg = <0>;
> 			compatible = "ethernet-phy-id0141.0dd0"; /* PHY ID for Marvell 88E1512 */
> 			reset-gpios = <&gpioi 2 (GPIO_ACTIVE_LOW | GPIO_PULL_UP)>;
> 			reset-assert-us = <1000>;
> 			reset-deassert-us = <2000>;
> 		};
> 
> 		phy0_eth2: ethernet-phy@1 {
> 			reg = <1>;
> 			compatible = "ethernet-phy-id0007.c0f0"; /* PHY ID for SMSC LAN8720Ai */
> 			reset-gpios = <&gpioh 7 (GPIO_ACTIVE_LOW | GPIO_PULL_UP)>;
> 			interrupt-parent = <&gpioh>;
> 			interrupts = <2 IRQ_TYPE_LEVEL_LOW>;
> 		};
> 	};
> };

This all looks reasonable.


> /* 10/100 Ethernet */
> &eth2 {
> 	status = "okay";
> 	pinctrl-0 = <&eth2_rmii_pins>;
> 	pinctrl-names = "default";
> 	phy-mode = "rmii";
> 	max-speed = <100>;
> 	phy-handle = <&phy0_eth2>;
> 	st,ext-phyclk;
> };

st,ext-phyclk is interesting. But looking at the code, that means the
clock is coming from somewhere else. And there appears to be eth-ck,
which the driver does a

devm_clk_get() on.

Is eth-ck being fed to both the MAC and the PHY? Is this the missing
clock?

So this is what we need to fix. And the correct way to do this is to
express this clock in DT. If you look at the PHY driver smsc, in its
probe function it has:

       /* Make clk optional to keep DTB backward compatibility. */
        refclk = devm_clk_get_optional_enabled(dev, NULL);
        if (IS_ERR(refclk))
                return dev_err_probe(dev, PTR_ERR(refclk),
                                     "Failed to request clock\n");

If there is a clock in DT, it will try to enable it. If the clock does
not exist yet, it will fail the probe with -EPRODE_DEFER, and the core
will try the probe again later, hopefully once the clock exists.

So this is the clock consumer. You also need a clock provider. What
exactly is this clock? We need the answer to the questions above,
but... If it is a SoC clock, it is quite likely there already is a
clock provider for it. If it is a clock in the MAC, you need to extend
the MAC driver to implement a clock provider. Maybe
meson8b_dwmac_register_clk() is a useful example?

	Andrew


