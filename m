Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id DDA2138F802
	for <lists+netdev@lfdr.de>; Tue, 25 May 2021 04:18:31 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230062AbhEYCT6 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 24 May 2021 22:19:58 -0400
Received: from vps0.lunn.ch ([185.16.172.187]:55124 "EHLO vps0.lunn.ch"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S230026AbhEYCT5 (ORCPT <rfc822;netdev@vger.kernel.org>);
        Mon, 24 May 2021 22:19:57 -0400
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed; d=lunn.ch;
        s=20171124; h=In-Reply-To:Content-Disposition:Content-Type:MIME-Version:
        References:Message-ID:Subject:Cc:To:From:Date:From:Sender:Reply-To:Subject:
        Date:Message-ID:To:Cc:MIME-Version:Content-Type:Content-Transfer-Encoding:
        Content-ID:Content-Description:Content-Disposition:In-Reply-To:References;
        bh=fcQs3evLbAI6fpikoPfcmobHPT+8O59iV7kLBO0fw/w=; b=m0BqXEeuczxwm0uYoQWlSf2FYj
        AT7cSXd0dQ8RCqv7xahV64gHKbb5OY9ok7EDqqC5rjSa3FaJa0Sl+v7tZ6dc/0Etp2HF23BHANXWl
        cwwz//0nWjzSnOV0lIvpnNm2QpROlWQTXYuCfgYrxnaVrny/aQLNXuMmxD9f9epJ94b0=;
Received: from andrew by vps0.lunn.ch with local (Exim 4.94.2)
        (envelope-from <andrew@lunn.ch>)
        id 1llMeG-0064SA-VX; Tue, 25 May 2021 04:18:24 +0200
Date:   Tue, 25 May 2021 04:18:24 +0200
From:   Andrew Lunn <andrew@lunn.ch>
To:     Vladimir Oltean <olteanv@gmail.com>
Cc:     Jakub Kicinski <kuba@kernel.org>,
        "David S. Miller" <davem@davemloft.net>, netdev@vger.kernel.org,
        Florian Fainelli <f.fainelli@gmail.com>,
        Vivien Didelot <vivien.didelot@gmail.com>,
        Vladimir Oltean <vladimir.oltean@nxp.com>,
        Russell King <linux@armlinux.org.uk>
Subject: Re: [PATCH net-next 11/13] net: dsa: sja1105: register the MDIO
 buses for 100base-T1 and 100base-TX
Message-ID: <YKxecB8aDJ4m5x7R@lunn.ch>
References: <20210524232214.1378937-1-olteanv@gmail.com>
 <20210524232214.1378937-12-olteanv@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20210524232214.1378937-12-olteanv@gmail.com>
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Tue, May 25, 2021 at 02:22:12AM +0300, Vladimir Oltean wrote:
> From: Vladimir Oltean <vladimir.oltean@nxp.com>
> 
> The SJA1110 contains two types of integrated PHYs: one 100base-TX PHY
> and multiple 100base-T1 PHYs.
> 
> The access procedure for the 100base-T1 PHYs is also different than it
> is for the 100base-TX one. So we register 2 MDIO buses, one for the
> base-TX and the other for the base-T1. Each bus has an OF node which is
> a child of the "mdio" subnode of the switch, and they are recognized by
> compatible string.

The mv88e6xxx also can have two MDIO busses. It is however an internal
bus for the internal PHYs and an external bus. The code however
evolved, since earlier devices only had one MDIO i ended up with a
binding like this:

       mdio {
                #address-cells = <1>;
                #size-cells = <0>;
                interrupt-parent = <&gpio0>;
                interrupts = <27 IRQ_TYPE_LEVEL_LOW>;
                interrupt-controller;
                #interrupt-cells = <2>;

                switch0: switch@0 {
                        compatible = "marvell,mv88e6390";
                        reg = <0>;
                        reset-gpios = <&gpio5 1 GPIO_ACTIVE_LOW>;

                        mdio {
                                #address-cells = <1>;
                                #size-cells = <0>;
                                switch1phy0: switch1phy0@0 {
                                        reg = <0>;
                                        interrupt-parent = <&switch0>;
                                        interrupts = <0 IRQ_TYPE_LEVEL_HIGH>;
                                };
                        };

                        mdio1 {
                                compatible = "marvell,mv88e6xxx-mdio-external";
                                #address-cells = <1>;
                                #size-cells = <0>;
                                switch1phy9: switch1phy0@9 {
                                        reg = <9>;
                                };
                        };
                };
        };

It however sounds like you have the two busses one level deeper?

It would be good if you document this as part of the binding.

   Andrew
