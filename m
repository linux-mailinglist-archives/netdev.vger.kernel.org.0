Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 3A3384E59D4
	for <lists+netdev@lfdr.de>; Wed, 23 Mar 2022 21:30:53 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1344633AbiCWUcV (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 23 Mar 2022 16:32:21 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:54036 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S234460AbiCWUcU (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 23 Mar 2022 16:32:20 -0400
Received: from vps0.lunn.ch (vps0.lunn.ch [185.16.172.187])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id DFB1D8878E;
        Wed, 23 Mar 2022 13:30:49 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed; d=lunn.ch;
        s=20171124; h=In-Reply-To:Content-Disposition:Content-Type:MIME-Version:
        References:Message-ID:Subject:Cc:To:From:Date:From:Sender:Reply-To:Subject:
        Date:Message-ID:To:Cc:MIME-Version:Content-Type:Content-Transfer-Encoding:
        Content-ID:Content-Description:Content-Disposition:In-Reply-To:References;
        bh=/P+1boOsbCQ6AVBVCSZ/z5hphLHXogBYDH2FQO7KmI4=; b=Ve7FKq/JIk+7trK6q3RWgSvlnS
        CrLHPojrgili7GrvVHfgwtk8st5K1uZU3yc0M2ag1k7eKYuAezQJZSLfvd38TXJ+CJqTKqZQyoCTZ
        MdFb4I9j+y0/A8L7pN2t2qd6ftDI59koFx3nbQtPMOFXqAfJAesd3R6FaTdxA0C00l9Q=;
Received: from andrew by vps0.lunn.ch with local (Exim 4.94.2)
        (envelope-from <andrew@lunn.ch>)
        id 1nX7cs-00CL1M-RO; Wed, 23 Mar 2022 21:30:38 +0100
Date:   Wed, 23 Mar 2022 21:30:38 +0100
From:   Andrew Lunn <andrew@lunn.ch>
To:     Michael Walle <michael@walle.cc>
Cc:     Heiner Kallweit <hkallweit1@gmail.com>,
        Russell King <linux@armlinux.org.uk>,
        Jakub Kicinski <kuba@kernel.org>,
        Paolo Abeni <pabeni@redhat.com>,
        "David S . Miller" <davem@davemloft.net>,
        Xu Liang <lxu@maxlinear.com>,
        Alexandre Belloni <alexandre.belloni@bootlin.com>,
        Florian Fainelli <f.fainelli@gmail.com>,
        netdev@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH RFC net-next 0/5] net: phy: C45-over-C22 access
Message-ID: <YjuDbqZom8knPVpm@lunn.ch>
References: <20220323183419.2278676-1-michael@walle.cc>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20220323183419.2278676-1-michael@walle.cc>
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,SPF_HELO_PASS,SPF_PASS,
        T_SCC_BODY_TEXT_LINE autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Wed, Mar 23, 2022 at 07:34:14PM +0100, Michael Walle wrote:
> Hi,
> 
> This is the result of this discussion:
> https://lore.kernel.org/netdev/240354b0a54b37e8b5764773711b8aa3@walle.cc/
> 
> The goal here is to get the GYP215 and LAN8814 running on the Microchip
> LAN9668 SoC. The LAN9668 suppports one external bus and unfortunately, the
> LAN8814 has a bug which makes it impossible to use C45 on that bus.
> Fortunately, it was the intention of the GPY215 driver to be used on a C22
> bus. But I think this could have never really worked, because the
> phy_get_c45_ids() will always do c45 accesses and thus on MDIO bus drivers
> which will correctly check for the MII_ADDR_C45 flag and return -EOPNOTSUPP
> the function call will fail and thus gpy_probe() will fail. This series
> tries to fix that and will lay the foundation to add a workaround for the
> LAN8814 bug by forcing an MDIO bus to be c22-only.
> 
> At the moment, the probe_capabilities is taken into account to decide if
> we have to use C45-over-C22. What is still missing from this series is the
> handling of a device tree property to restrict the probe_capabilities to
> c22-only.

We have a problem here with phydev->is_c45.

In phy-core.c, functions __phy_read_mmd() and __phy_write_mmd() it
means perform c45 transactions over the bus. We know we want to access
a register in c45 space because we are using an _mmd() function.

In phy.c, it means does this PHY have c45 registers and we should
access that register space, or should we use the c22 register
space. So far example phy_restart_aneg() decides to either call
genphy_c45_restart_aneg() or genphy_restart_aneg() depending on
is_c45.

So a PHY with C45 register space but only accessible by C45 over C22
is probably going to do the wrong thing with the current code.

For this patchset to work, we need to cleanly separate the concepts of
what sort of transactions to do over the bus, from what register
spaces the PHY has. We probably want something like phydev->has_c45 to
indicate the register space is implemented, and phydev->c45_over_c22
to indicate what sort of transaction should be used in the _mmd()
functions.

Your patches start in that direction, but i don't think it goes far
enough.

	Andrew
