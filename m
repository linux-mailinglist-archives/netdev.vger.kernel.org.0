Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 13F92177810
	for <lists+netdev@lfdr.de>; Tue,  3 Mar 2020 14:59:50 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729390AbgCCN7m (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 3 Mar 2020 08:59:42 -0500
Received: from vps0.lunn.ch ([185.16.172.187]:43508 "EHLO vps0.lunn.ch"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1729366AbgCCN7m (ORCPT <rfc822;netdev@vger.kernel.org>);
        Tue, 3 Mar 2020 08:59:42 -0500
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed; d=lunn.ch;
        s=20171124; h=In-Reply-To:Content-Type:MIME-Version:References:Message-ID:
        Subject:Cc:To:From:Date:Sender:Reply-To:Content-Transfer-Encoding:Content-ID:
        Content-Description:Resent-Date:Resent-From:Resent-Sender:Resent-To:Resent-Cc
        :Resent-Message-ID:List-Id:List-Help:List-Unsubscribe:List-Subscribe:
        List-Post:List-Owner:List-Archive;
        bh=LxSraZ4V6R6eSZ2XYZzkqraIm7vZB0AJQUd3qlAu/BQ=; b=gEdvT9UJOe7ZmXC9c8402O0aeo
        ZGe43nTZlQu4l2nCtqiM8ZfXptCpck6hPP/C6TDQSTWTw0m43qAduJYnA48JY3CRtZXc3hJVlh/zC
        stWqc/CxpRzYlAUEK7k9Ff1V3s14AVySvuD7ZHGX2R/8jZywUmYAOAYmzXbsuLI2M/Fk=;
Received: from andrew by vps0.lunn.ch with local (Exim 4.93)
        (envelope-from <andrew@lunn.ch>)
        id 1j985A-0006OD-Bh; Tue, 03 Mar 2020 14:59:36 +0100
Date:   Tue, 3 Mar 2020 14:59:36 +0100
From:   Andrew Lunn <andrew@lunn.ch>
To:     Oleksij Rempel <o.rempel@pengutronix.de>
Cc:     Florian Fainelli <f.fainelli@gmail.com>,
        Heiner Kallweit <hkallweit1@gmail.com>,
        Pengutronix Kernel Team <kernel@pengutronix.de>,
        linux-kernel@vger.kernel.org,
        "David S. Miller" <davem@davemloft.net>, netdev@vger.kernel.org,
        Marek Vasut <marex@denx.de>, David Jander <david@protonic.nl>,
        Quentin Schulz <quentin.schulz@bootlin.com>
Subject: Re: [PATCH v1] net: phy: tja11xx: add TJA1102 support
Message-ID: <20200303135936.GG31977@lunn.ch>
References: <20200303073715.32301-1-o.rempel@pengutronix.de>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20200303073715.32301-1-o.rempel@pengutronix.de>
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Hi Oleksij

> TJA1102 is an dual T1 PHY chip. Both PHYs are separately addressable.
> PHY 0 can be identified by PHY ID. PHY 1 has no PHY ID and can be
> configured in device tree by setting compatible =
> "ethernet-phy-id0180.dc81".

Why-o-why do silicon vendors make devices with invalid PHY IDs!?!?!

Did you try avoiding the compatible string. We know PHY 0 will probe
as normal. From its PHY ID we know it is a dual device. Could the
probe of PHY 0 register PHY 1?

No idea if it will work, but could nxp-tja11xx.c register is fixup for
PHY_ID_TJA1102. That fixup would do something like:

void tja1102_fixup(struct phy_device *phydev_phy0)
{
        struct mii_bus *bus = phydev_phy0->mdio.mii;
        struct phy_device *phydev_phy1;

        phydev_phy1 = phy_device_create(bus, phydev_phy0->addr + 1,
                                        PHY_ID_TJA1102, FALSE, NULL);
	if (phydev_phy1)
               phy_device_register(phydev_phy1);
}

I think the issue here is, it will deadlock when scanning for fixup
for phydev_phy1. So this basic idea, but maybe hooked in somewhere
else?

Something like this might also help vsc8584 which is a quad PHY with
some shared registers?

	  Andrew
