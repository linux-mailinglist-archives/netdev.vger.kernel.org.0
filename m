Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id B145A3E85FA
	for <lists+netdev@lfdr.de>; Wed, 11 Aug 2021 00:13:31 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S235087AbhHJWNw (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 10 Aug 2021 18:13:52 -0400
Received: from vps0.lunn.ch ([185.16.172.187]:43688 "EHLO vps0.lunn.ch"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S234315AbhHJWNv (ORCPT <rfc822;netdev@vger.kernel.org>);
        Tue, 10 Aug 2021 18:13:51 -0400
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed; d=lunn.ch;
        s=20171124; h=In-Reply-To:Content-Disposition:Content-Type:MIME-Version:
        References:Message-ID:Subject:Cc:To:From:Date:From:Sender:Reply-To:Subject:
        Date:Message-ID:To:Cc:MIME-Version:Content-Type:Content-Transfer-Encoding:
        Content-ID:Content-Description:Content-Disposition:In-Reply-To:References;
        bh=OB3waPJnO9HIxiScEHDmzpd/7crEtzeUTo41xa7qAIs=; b=S9VI4h4EWUlBa5YAECqiYB+TOg
        xjC+wUaOP41/pgWCvjDHBIOysvJS0BihmZcGXnXhgHN6ErBJfme4iWVtHRiJTLxotZKnxYkUtnQMP
        R3EA9jYAZk1VeonwH2n79wNSyApb7faIE2z/ag7SqqTgRLeDHEVQvIqfEAV18v6TLX5c=;
Received: from andrew by vps0.lunn.ch with local (Exim 4.94.2)
        (envelope-from <andrew@lunn.ch>)
        id 1mDZzz-00GzAb-RC; Wed, 11 Aug 2021 00:13:27 +0200
Date:   Wed, 11 Aug 2021 00:13:27 +0200
From:   Andrew Lunn <andrew@lunn.ch>
To:     Dario Alcocer <dalcocer@helixd.com>
Cc:     netdev@vger.kernel.org
Subject: Re: Marvell switch port shows LOWERLAYERDOWN, ping fails
Message-ID: <YRL6B3fh7IrLQZST@lunn.ch>
References: <YQGgvj2e7dqrHDCc@lunn.ch>
 <59790fef-bf4a-17e5-4927-5f8d8a1645f7@helixd.com>
 <YQGu2r02XdMR5Ajp@lunn.ch>
 <11b81662-e9ce-591c-122a-af280f1e1f59@helixd.com>
 <fea36eed-eaff-4381-b2fd-628b60237aab@helixd.com>
 <de5758c6-4379-1b70-19ff-d6dd2b3ea269@helixd.com>
 <4902bb0e-87ad-3fa4-f7af-bbe7b43ad68f@helixd.com>
 <YQ7Xo3UII/1Gw/G1@lunn.ch>
 <ac33ec5f-568e-e43c-5d58-48876a7d9b0d@helixd.com>
 <404e5b00-59ee-1165-4f7c-d0853c730354@helixd.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <404e5b00-59ee-1165-4f7c-d0853c730354@helixd.com>
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Tue, Aug 10, 2021 at 01:58:21PM -0700, Dario Alcocer wrote:
> Well, I misread the schematic; the DSA ports are connected via four pins on
> each of the MV88E6176 chips (S_RXP, S_RXN, S_TXP, S_TXN):
> 
> S_RXP (PHY 0x1E) <---> S_TXP (PHY 0x1A)
> S_RXN (PHY 0x1E) <---> S_TXN (PHY 0x1A)
> S_TXP (PHY 0x1E) <---> S_RXP (PHY 0x1A)
> S_TXN (PHY 0x1E) <---> S_RXN (PHY 0x1A)
> 
> As you mentioned before, 1G requires 4 pairs. Thus, it seems that phy-mode =
> "1000base-x" and speed = <1000> cannot be used for the SERDES link.

You are mixing up the link from a MAC to a PHY, and from a PHY over a
cable to another PHY.

An Ethernet cable has 4 pairs, and it is the PHYs job to generate and
receive the signals over these four pairs. How those signals look is
all part of the 802.3 standard, nothing you can configure.

There are a number of different ways you can connect a MAC to a PHY,
or a MAC to another MAC. The generic name for this is MII, Media
Independent Interface.  The number of copper tracks between the MAC
and PHY varies. Gigabit MII has around 22 pins, here as Reduced
Gigabit MII has 11 pins. And a SERDES 100Base-X only has 4 pins.

So 1000base-x is correct.

I don't have the datasheet for the 6176, but i assume it is similar to
the 6352. The SERDES can be connected to either port4 or port5. The
S_SEL pin is used to configure this. For the 6352, S_SEL=1 means port
5. You can also configure the port to 100Base-FX or 1000Base-X/SGMII
using the S_MODE pin. S_MODE=1 means 1000Base-X or SGMII.

The CMODE, or Config mode, the lowest nibble of the port status
register, tells you what it is actually using. A value of 0xf means a
copper PHY. 0x8 is 100Base-FX. 0x9 = 1000Base-X, 0x0a = SGMII.

       Andrew

