Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 5C9B369342A
	for <lists+netdev@lfdr.de>; Sat, 11 Feb 2023 23:23:21 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229570AbjBKWXP (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sat, 11 Feb 2023 17:23:15 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:57116 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229447AbjBKWXO (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sat, 11 Feb 2023 17:23:14 -0500
Received: from vps0.lunn.ch (vps0.lunn.ch [156.67.10.101])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 8088A16AD3;
        Sat, 11 Feb 2023 14:23:13 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed; d=lunn.ch;
        s=20171124; h=In-Reply-To:Content-Disposition:Content-Type:MIME-Version:
        References:Message-ID:Subject:Cc:To:From:Date:From:Sender:Reply-To:Subject:
        Date:Message-ID:To:Cc:MIME-Version:Content-Type:Content-Transfer-Encoding:
        Content-ID:Content-Description:Content-Disposition:In-Reply-To:References;
        bh=dWZ330/P4252JfJcutMFvdkpQeYvDX9p6oSeZOXNreo=; b=Um7erpfqUw7GfHH5kqobSPJv6n
        EF6EliuM71FBiNIVFtO7nAszwE7pkHqKR3L9aP+Evz+K9qaE+Fqy9+EKZacQDn4GWTajsWSFjuvUW
        pAoIiFl3hOHXrK0Kfk8/12SUVawyU5iypYMq9JHDnoeDFlMR77WnGAlgpf7zNP4NLtOo=;
Received: from andrew by vps0.lunn.ch with local (Exim 4.94.2)
        (envelope-from <andrew@lunn.ch>)
        id 1pQyGy-004j7z-7l; Sat, 11 Feb 2023 23:23:08 +0100
Date:   Sat, 11 Feb 2023 23:23:08 +0100
From:   Andrew Lunn <andrew@lunn.ch>
To:     Vladimir Oltean <vladimir.oltean@nxp.com>
Cc:     Maxime Chevallier <maxime.chevallier@bootlin.com>,
        davem@davemloft.net, netdev@vger.kernel.org,
        linux-kernel@vger.kernel.org, thomas.petazzoni@bootlin.com,
        Jakub Kicinski <kuba@kernel.org>,
        Eric Dumazet <edumazet@google.com>,
        Paolo Abeni <pabeni@redhat.com>,
        Florian Fainelli <f.fainelli@gmail.com>,
        Heiner Kallweit <hkallweit1@gmail.com>,
        Russell King <linux@armlinux.org.uk>,
        linux-arm-kernel@lists.infradead.org,
        Ioana Ciornei <ioana.ciornei@nxp.com>
Subject: Re: [PATCH net-next] net: pcs: tse: port to pcs-lynx
Message-ID: <Y+gVTOB09lz0M5b1@lunn.ch>
References: <20230210190949.1115836-1-maxime.chevallier@bootlin.com>
 <20230210190949.1115836-1-maxime.chevallier@bootlin.com>
 <20230210193159.qmbtvwtx6kqagvxy@skbuf>
 <Y+ai3zHMUCDcxqxP@lunn.ch>
 <20230211215229.ra43h35rbuibpj2p@skbuf>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20230211215229.ra43h35rbuibpj2p@skbuf>
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,SPF_HELO_PASS,SPF_PASS
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Sat, Feb 11, 2023 at 11:52:29PM +0200, Vladimir Oltean wrote:
> On Fri, Feb 10, 2023 at 09:02:39PM +0100, Andrew Lunn wrote:
> > I was wondering if the glue could actually be made generic. The kernel
> > has a number of reasonably generic MMIO device drivers, which are just
> > given an address range and assume a logical mapping.
> > 
> > Could this be made into a generic MDIO MMIO bus driver, which just
> > gets configured with a base address, and maybe a stride between
> > registers?
> 
> This sounds interesting to me because I also have at least one other
> potential use for it. The "nxp,sja1110-base-tx-mdio" driver does basically
> just that, except it's SPI instead of MMIO. So if the generic driver was a
> platform device driver and it was aware of dev_get_regmap(), it could
> get reused.
> 
> What I'm not sure of is the spacing between MDIO registers. For the
> SJA1110 CBTX PHY, the registers are 32-bit wide (but contain 16-bit
> values). So MII_BMCR is at offset 0x0, MII_BMSR at 0x4 etc. I'd imagine
> that other MDIO buses might have MII_BMSR at 0x2.

This is what i meant by stride. The distance between registers. As you
say, it could be 2 bytes, but also 4 bytes. It should be a
configuration parameter when instantiating such a generic driver.

	Andrew
