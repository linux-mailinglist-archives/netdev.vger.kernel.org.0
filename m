Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 8F85E251950
	for <lists+netdev@lfdr.de>; Tue, 25 Aug 2020 15:14:31 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726834AbgHYNOT (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 25 Aug 2020 09:14:19 -0400
Received: from vps0.lunn.ch ([185.16.172.187]:49146 "EHLO vps0.lunn.ch"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726241AbgHYNOD (ORCPT <rfc822;netdev@vger.kernel.org>);
        Tue, 25 Aug 2020 09:14:03 -0400
Received: from andrew by vps0.lunn.ch with local (Exim 4.94)
        (envelope-from <andrew@lunn.ch>)
        id 1kAYm0-00Blzu-ER; Tue, 25 Aug 2020 15:14:00 +0200
Date:   Tue, 25 Aug 2020 15:14:00 +0200
From:   Andrew Lunn <andrew@lunn.ch>
To:     Sascha Hauer <s.hauer@pengutronix.de>
Cc:     netdev@vger.kernel.org, Florian Fainelli <f.fainelli@gmail.com>,
        Heiner Kallweit <hkallweit1@gmail.com>, kernel@pengutronix.de
Subject: Re: ethernet-phy-ieee802.3-c22 binding and reset-gpios
Message-ID: <20200825131400.GO2588906@lunn.ch>
References: <20200825090933.GN13023@pengutronix.de>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20200825090933.GN13023@pengutronix.de>
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Tue, Aug 25, 2020 at 11:09:33AM +0200, Sascha Hauer wrote:
> Hi All,
> 
> I am using the ethernet phy binding here that looks like:
> 
> ethphy1: ethernet-phy@1 {
> 	compatible = "ethernet-phy-ieee802.3-c22";
> 	reg = <1>;
> 	eee-broken-1000t;
> 	reset-gpios = <&gpio4 2 GPIO_ACTIVE_LOW>;
> };
> 
> It seems the "reset-gpios" is inherently broken in Linux.

Hi Sascha

I think it would be better to say, it does not do what people expect,
rather than broken.

This code was developed for a PHY which needed to be reset after
enumeration. That PHY did enumerate, either because it was not held in
reset, or would still answer ID requests while held in reset.

It does however not work for PHYs which are held in reset during probe
and won't enumerate. This is a known issues, but could be better
documented.

> Is this the path to go or are there any other ideas how to solve
> this issue?

There is two different reset gpios in DT. There is a per PHY reset,
which you are trying to use. And a per MDIO bus reset, which should
apply to all PHYs on the bus. This per bus reset works more as
expected. If this works for you, you could use that.

Otherwise, you need to modify of_mdiobus_register() to look in device
tree while it is performing the scan and see if there is a reset
property for each address on the bus. If so, take the device out of
reset before reading the ID registers.

	Andrew
