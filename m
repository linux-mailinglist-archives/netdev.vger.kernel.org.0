Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 950A26DC6A2
	for <lists+netdev@lfdr.de>; Mon, 10 Apr 2023 14:11:55 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229907AbjDJMLx (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 10 Apr 2023 08:11:53 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:38716 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229777AbjDJMLw (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 10 Apr 2023 08:11:52 -0400
Received: from vps0.lunn.ch (vps0.lunn.ch [156.67.10.101])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 6F1C65BB5
        for <netdev@vger.kernel.org>; Mon, 10 Apr 2023 05:11:46 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed; d=lunn.ch;
        s=20171124; h=In-Reply-To:Content-Disposition:Content-Type:MIME-Version:
        References:Message-ID:Subject:Cc:To:From:Date:From:Sender:Reply-To:Subject:
        Date:Message-ID:To:Cc:MIME-Version:Content-Type:Content-Transfer-Encoding:
        Content-ID:Content-Description:Content-Disposition:In-Reply-To:References;
        bh=6jqf8cMAq4Kfd9n3UiUpXp44lPUh+x5p+3c0Dou5UqY=; b=vRXPmMbbjVJqPtKJNp5x3qfHhb
        ZChQuNltuN17UmaGSc0DzLPVAV7m3lZ5KT7UYybM92h2BwEX7eriMeYkiG/QtlkK2L+fmiJ5MzhOR
        bKzyC2kfraNM3HzZqFsF8c+PS5UHK9dysd+CdLLbO6+lOEPpRYxNJz4cdY+/gJqViQyg=;
Received: from andrew by vps0.lunn.ch with local (Exim 4.94.2)
        (envelope-from <andrew@lunn.ch>)
        id 1plqN1-009uke-K5; Mon, 10 Apr 2023 14:11:39 +0200
Date:   Mon, 10 Apr 2023 14:11:39 +0200
From:   Andrew Lunn <andrew@lunn.ch>
To:     Simon Horman <simon.horman@corigine.com>
Cc:     David Miller <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>,
        netdev <netdev@vger.kernel.org>,
        Florian Fainelli <f.fainelli@gmail.com>,
        Heiner Kallweit <hkallweit1@gmail.com>,
        Russell King <rmk+kernel@armlinux.org.uk>
Subject: Re: [PATCH] net: ethernet: Add missing depends on MDIO_DEVRES
Message-ID: <741fc0ef-c94d-488e-86f8-436ab4582971@lunn.ch>
References: <20230409150204.2346231-1-andrew@lunn.ch>
 <ZDPR7sQj3Mpatici@corigine.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <ZDPR7sQj3Mpatici@corigine.com>
X-Spam-Status: No, score=-0.2 required=5.0 tests=DKIM_SIGNED,DKIM_VALID,
        DKIM_VALID_AU,DKIM_VALID_EF,SPF_HELO_PASS,SPF_PASS
        autolearn=unavailable autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Mon, Apr 10, 2023 at 11:07:58AM +0200, Simon Horman wrote:
> On Sun, Apr 09, 2023 at 05:02:04PM +0200, Andrew Lunn wrote:
> > A number of MDIO drivers make use of devm_mdiobus_alloc_size(). This
> > is only available when CONFIG_MDIO_DEVRES is enabled. Add missing
> > depends or selects, depending on if there are circular dependencies or
> > not. This avoids linker errors, especially for randconfig builds.
> > 
> > Signed-off-by: Andrew Lunn <andrew@lunn.ch>
> > ---
> >  drivers/net/ethernet/freescale/Kconfig       | 1 +
> >  drivers/net/ethernet/freescale/enetc/Kconfig | 1 +
> >  drivers/net/ethernet/marvell/Kconfig         | 1 +
> >  drivers/net/ethernet/qualcomm/Kconfig        | 1 +
> >  drivers/net/mdio/Kconfig                     | 3 +++
> >  5 files changed, 7 insertions(+)
> > 
> > diff --git a/drivers/net/ethernet/freescale/Kconfig b/drivers/net/ethernet/freescale/Kconfig
> > index f1e80d6996ef..1c78f66a89da 100644
> > --- a/drivers/net/ethernet/freescale/Kconfig
> > +++ b/drivers/net/ethernet/freescale/Kconfig
> > @@ -71,6 +71,7 @@ config FSL_XGMAC_MDIO
> >  	tristate "Freescale XGMAC MDIO"
> >  	select PHYLIB
> >  	depends on OF
> > +	select MDIO_DEVRES
> >  	select OF_MDIO
> >  	help
> >  	  This driver supports the MDIO bus on the Fman 10G Ethernet MACs, and
> 
> Perhaps this is a good idea, but I'd like to mention that I don't think
> it is strictly necessary as:
> 
> 1. FSL_XGMAC_MDIO selects PHYLIB.
> 2. And PHYLIB selects MDIO_DEVRES.
> 
> Likewise for FSL_ENETC, MV643XX_ETH, QCOM_EMAC.
> 
> Is there some combination of N/y/m that defeats my logic here?
> I feel like I am missing something obvious.

I keep getting 0-day randconfig build warning about kernel
configuration which don't link. It seems to get worse when we add in
support of MAC and PHY LEDs. My guess is, the additional dependencies
for LEDs upsets the conflict resolution engine, and it comes out with
a different solution. `select` is a soft dependency. It is more a
hint, and can be ignored. And when a randconfig kernel fails to build,
MDIO_DEVRES is disabled.

Where possible, i've added a `depends on`, which is a much stronger
dependency. But that can lead to circular dependencies, which kconfig
cannot handle. In such cases, i've added selects. Maybe having more
selects for a config option will influence it to find a solution which
has MDIO_DEVRES enabled?

I've had this patch in a github tree for a week or more, and 0-day has
not yet returned any randconfig build errors. But i've not combined it
with the LED code.

     Andrew
