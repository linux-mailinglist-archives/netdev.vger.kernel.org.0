Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id D7BD32A8363
	for <lists+netdev@lfdr.de>; Thu,  5 Nov 2020 17:20:42 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729980AbgKEQUj (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 5 Nov 2020 11:20:39 -0500
Received: from vps0.lunn.ch ([185.16.172.187]:37566 "EHLO vps0.lunn.ch"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726371AbgKEQUj (ORCPT <rfc822;netdev@vger.kernel.org>);
        Thu, 5 Nov 2020 11:20:39 -0500
Received: from andrew by vps0.lunn.ch with local (Exim 4.94)
        (envelope-from <andrew@lunn.ch>)
        id 1kai03-005R1p-Lk; Thu, 05 Nov 2020 17:20:35 +0100
Date:   Thu, 5 Nov 2020 17:20:35 +0100
From:   Andrew Lunn <andrew@lunn.ch>
To:     Alayev Michael <malayev@iai.co.il>
Cc:     "mic.al.linux@gmail.com" <mic.al.linux@gmail.com>,
        "netdev@vger.kernel.org" <netdev@vger.kernel.org>
Subject: Re: net: dsa: mv88e6xxx : linux v5.4 crash
Message-ID: <20201105162035.GN933237@lunn.ch>
References: <48F7D4389F30BA4383F214EE802BA47101C2E0DB75@EXS12.iai.co.il>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <48F7D4389F30BA4383F214EE802BA47101C2E0DB75@EXS12.iai.co.il>
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

> &gem0 {
> 	status = "okay";
> 	phy-mode = "rgmii-id";
> 	phy-handle = <&phy0>;	
> 	fixed-link {
> 		speed = <1000>;
> 		full-duplex;
> 	};
> 
> > The diagram you showed had gem0 connected directly to the switch. So
> > this phy-handle is wrong. Or the diagram is wrong.
> The diagram is correct. I have commented the phy-mode and phy-handle in 'gem0' definition and got error:
> 'macb e000b000.ethernet eth0: no PHY found'

/* based on au1000_eth. c*/
static int macb_mii_probe(struct net_device *dev)
{
        struct macb *bp = netdev_priv(dev);
        struct phy_device *phydev;
        struct device_node *np;
        int ret, i;

        np = bp->pdev->dev.of_node;
        ret = 0;

        if (np) {
                if (of_phy_is_fixed_link(np)) {
                        bp->phy_node = of_node_get(np);
                } else {
...
        if (bp->phy_node) {
                phydev = of_phy_connect(dev, bp->phy_node,
                                        &macb_handle_link_change, 0,
                                        bp->phy_interface);
                if (!phydev)
                        return -ENODEV;
        } else {
                phydev = phy_find_first(bp->mii_bus);
                if (!phydev) {
                        netdev_err(dev, "no PHY found\n");
                        return -ENXIO;
                }


So either of_phy_is_fixed_link(np) is returning false, or
of_node_get(np) returns NULL.

You need to do some debugging and figure out which and why.

Also, note that this code has changed a lot since v5.4. You might want
to try v5.9, or v5.10-rc2.

    Andrew
