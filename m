Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id AA34D2CC8B4
	for <lists+netdev@lfdr.de>; Wed,  2 Dec 2020 22:12:54 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729102AbgLBVMR (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 2 Dec 2020 16:12:17 -0500
Received: from vps0.lunn.ch ([185.16.172.187]:35100 "EHLO vps0.lunn.ch"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726361AbgLBVMQ (ORCPT <rfc822;netdev@vger.kernel.org>);
        Wed, 2 Dec 2020 16:12:16 -0500
Received: from andrew by vps0.lunn.ch with local (Exim 4.94)
        (envelope-from <andrew@lunn.ch>)
        id 1kkZPS-009vpd-TC; Wed, 02 Dec 2020 22:11:34 +0100
Date:   Wed, 2 Dec 2020 22:11:34 +0100
From:   Andrew Lunn <andrew@lunn.ch>
To:     Grant Edwards <grant.b.edwards@gmail.com>
Cc:     netdev@vger.kernel.org
Subject: Re: net: macb: fail when there's no PHY
Message-ID: <20201202211134.GM2324545@lunn.ch>
References: <20170921195905.GA29873@grante>
 <66c0a032-4d20-69f1-deb4-6c65af6ec740@gmail.com>
 <CAK=1mW6Gti0QpUjirB6PfMCiQvnDjkbb56pVKkQmpCSkRU6wtA@mail.gmail.com>
 <6a9c1d4a-ed73-3074-f9fa-158c697c7bfe@gmail.com>
 <X8fb4zGoxcS6gFsc@grante>
 <20201202183531.GJ2324545@lunn.ch>
 <rq8p74$2l0$1@ciao.gmane.io>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <rq8p74$2l0$1@ciao.gmane.io>
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

> > So it will access the MDIO bus of the PHY that is attached to the
> > MAC.
> 
> If that's the case, wouldn't the ioctl() calls "just work" even when
> only the fixed-phy mdio bus and fake PHY are declared in the device
> tree?

The fixed-link PHY is connected to the MAC. So the IOCTL calls will be
made to the fixed-link fake MDIO bus.

> OK, I think I've got a vague idea of how that would be done.
> 
> [When it comes to device-tree stuff, I've learned that "a vague idea"
> is pretty much the best I can manage. Nothing ever works the way I
> think it's going to the first time, but with enough guesses I usually
> get there.]

There are plenty of examples to follow.

e.g. arch/arm/boot/dts/vf610-twr.dts

&fec0 {
        phy-mode = "rmii";
        phy-handle = <&ethphy0>;
        pinctrl-names = "default";
        pinctrl-0 = <&pinctrl_fec0>;
        status = "okay";

        mdio {
                #address-cells = <1>;
                #size-cells = <0>;

                ethphy0: ethernet-phy@0 {
                        reg = <0>;
                };

                ethphy1: ethernet-phy@1 {
                        reg = <1>;
                };
        };
};

So one Ethernet controller with an MDIO bus with two PHYs on it. It
has a phy-handle pointing it is own PHY.

&fec1 {
        phy-mode = "rmii";
        phy-handle = <&ethphy1>;
        pinctrl-names = "default";
        pinctrl-0 = <&pinctrl_fec1>;
        status = "okay";
};

A second Ethernet, with phy-handle pointing to the second PHY on the
other controllers MDIO bus.

	    Andrew
