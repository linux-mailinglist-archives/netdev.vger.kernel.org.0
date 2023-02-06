Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 46ECC68BE14
	for <lists+netdev@lfdr.de>; Mon,  6 Feb 2023 14:25:49 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229511AbjBFNZO (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 6 Feb 2023 08:25:14 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:59860 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229571AbjBFNYo (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 6 Feb 2023 08:24:44 -0500
Received: from vps0.lunn.ch (vps0.lunn.ch [156.67.10.101])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 5E7171724
        for <netdev@vger.kernel.org>; Mon,  6 Feb 2023 05:24:41 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed; d=lunn.ch;
        s=20171124; h=In-Reply-To:Content-Disposition:Content-Type:MIME-Version:
        References:Message-ID:Subject:Cc:To:From:Date:From:Sender:Reply-To:Subject:
        Date:Message-ID:To:Cc:MIME-Version:Content-Type:Content-Transfer-Encoding:
        Content-ID:Content-Description:Content-Disposition:In-Reply-To:References;
        bh=y/hBsB9swtng6qeN6RW2qV+HSs3CjdrXZpKCy0u4hx8=; b=jmZMh52SMDGj48UwT7GHPi7FLq
        kDqpWC/H8D2ZBgnU0fAhwkMxqEAyX42r9fpj9EKz1RjHIK4BBEoQp5o4Ow1qkmEv9V+dJxXmg6E2e
        gMS9pjFX3Wpymmq+rCx5oZcu4ucDMY9mNYKtJWWUH8ktjEp2m0GKuOBFfnsdKqtQAfXo=;
Received: from andrew by vps0.lunn.ch with local (Exim 4.94.2)
        (envelope-from <andrew@lunn.ch>)
        id 1pP1U5-004Ck6-TC; Mon, 06 Feb 2023 14:24:37 +0100
Date:   Mon, 6 Feb 2023 14:24:37 +0100
From:   Andrew Lunn <andrew@lunn.ch>
To:     Angelo Dureghello <angelo@kernel-space.org>
Cc:     Vladimir Oltean <olteanv@gmail.com>, netdev@vger.kernel.org
Subject: Re: mv88e6321, dual cpu port
Message-ID: <Y+D/lYul5X0JuHOR@lunn.ch>
References: <20230110222246.iy7m7f36iqrmiyqw@skbuf>
 <Y73ub0xgNmY5/4Qr@lunn.ch>
 <8d0fce6c-6138-4594-0d75-9a030d969f99@kernel-space.org>
 <20230123112828.yusuihorsl2tyjl3@skbuf>
 <7e29d955-2673-ea54-facb-3f96ce027e96@kernel-space.org>
 <20230123191844.ltcm7ez5yxhismos@skbuf>
 <Y87pLbMC4GRng6fa@lunn.ch>
 <7dd335e4-55ec-9276-37c2-0ecebba986b9@kernel-space.org>
 <Y8/jrzhb2zoDiidZ@lunn.ch>
 <1423df62-11aa-bbe3-8573-e5fd4fb17bbb@kernel-space.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1423df62-11aa-bbe3-8573-e5fd4fb17bbb@kernel-space.org>
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,SPF_HELO_PASS,SPF_PASS
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

> This is what i am testing now, a bit different,
> swapped ports 5 and 6.
> 
> #
> # Configuration:
> #                                   cpu      +---- port0
> #              br0 eth0  <-> rgmii  port 6  -+---- port1
> #                                            |
> #                                            +---- port2
> #
> #                                  user      +---- port3
> #              br1 eth1  <-> rmii  port 5   -+-----port4
> #
> #
> 
> mdio {
> 		#address-cells = <1>;
> 		#size-cells = <0>;
> 
> 		switch1: switch1@1d {
> 			compatible = "marvell,mv88e6085";
> 			reg = <0x1d>;
> 			interrupt-parent = <&lsio_gpio3>;
> 			interrupts = <4 IRQ_TYPE_LEVEL_LOW>;
> 			interrupt-controller;
> 			#interrupt-cells = <2>;
> 
> 			ports {
> 				#address-cells = <1>;
> 				#size-cells = <0>;
> 
> 				port@0 {
> 					reg = <0>;
> 					label = "port0";
> 					phy-mode = "1000base-x";
> 					managed = "in-band-status";
> 					sfp = <&sfp_0>;
> 				};
> 				port@1 {
> 					reg = <1>;
> 					label = "port1";
> 					phy-mode = "1000base-x";
> 					managed = "in-band-status";
> 					sfp = <&sfp_1>;
> 				};
> 				/* This is phyenet0 now */
> 				port@2 {
> 					reg = <2>;
> 					label = "port2";
> 					phy-handle = <&switchphy2>;
> 				};
> 				port@6 {
> 					/* wired to cpu fec1 */
> 					reg = <6>;
> 					label = "cpu";
> 					ethernet = <&fec1>;
> 					fixed-link = <0 1 1000 0 0>;

This is the deprecated way to do fixed link. Use

                fixed-link {
                        speed = <1000>;
                        full-duplex;
                };


> 				};
> 				port@3 {
> 					/* phy is internal to the switch */
> 					reg = <3>;
> 					label = "port3";
> 					phy-handle = <&switchphy3>;
> 				};
> 				port@4 {
> 					/* phy is internal to the switch */
> 					reg = <4>;
> 					label = "port4";
> 					phy-handle = <&switchphy4>;
> 				};
> 				port@5 {
> 					/* wired to cpu fec2 */
> 					reg = <5>;
> 					label = "port5";
> 					ethernet = <&fec2>;

This is wrong. As far as the switch is concerned, this port is nothing
special. It is just a regular user port. So it should not have an
ethernet property.



> 					fixed-link = <1 1 100 0 0>;
> 				};
> 			};
> 
> All seems to work properly, but on ports 0, 1, 2 i cannot go
> over 100Mbit even if master port (6) is rgmii
> (testing by iperf3).

What SoC is this? Some FECs are only Fast ethernet.

What does ethtool show for eth0?

Do you also have a fixed link in the fec node?

   Andrew
