Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id C8C676931FD
	for <lists+netdev@lfdr.de>; Sat, 11 Feb 2023 16:32:56 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229476AbjBKPcx (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sat, 11 Feb 2023 10:32:53 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:37438 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229447AbjBKPcw (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sat, 11 Feb 2023 10:32:52 -0500
Received: from vps0.lunn.ch (vps0.lunn.ch [156.67.10.101])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id BAE8A23DAC;
        Sat, 11 Feb 2023 07:32:51 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed; d=lunn.ch;
        s=20171124; h=In-Reply-To:Content-Disposition:Content-Type:MIME-Version:
        References:Message-ID:Subject:Cc:To:From:Date:From:Sender:Reply-To:Subject:
        Date:Message-ID:To:Cc:MIME-Version:Content-Type:Content-Transfer-Encoding:
        Content-ID:Content-Description:Content-Disposition:In-Reply-To:References;
        bh=+nZCzFH2CatPkmq5OyRhXq2N8qdPXlAo2cpPPyX955k=; b=JPgz2W6RMH1r9WhCBHuWhkIIde
        K+o1bB+0DAySSNkTsZ57PdllSFv0vITYJ4OeaqvBim8R1pZeZxKSKbIcEItQGdFGbI60wR+vSp0QS
        U/an4wV/lE9Sc/Cu70sPnWno6VV1HxuiISjMCYY7mwvVLw2SUbjJ+AGnKm4ma0MMFDy8=;
Received: from andrew by vps0.lunn.ch with local (Exim 4.94.2)
        (envelope-from <andrew@lunn.ch>)
        id 1pQrrt-004htS-GZ; Sat, 11 Feb 2023 16:32:49 +0100
Date:   Sat, 11 Feb 2023 16:32:49 +0100
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
Message-ID: <Y+e1IfWcmHJjJlgp@lunn.ch>
References: <20230210190949.1115836-1-maxime.chevallier@bootlin.com>
 <20230210190949.1115836-1-maxime.chevallier@bootlin.com>
 <20230210193159.qmbtvwtx6kqagvxy@skbuf>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20230210193159.qmbtvwtx6kqagvxy@skbuf>
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,SPF_HELO_PASS,SPF_PASS
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Fri, Feb 10, 2023 at 09:31:59PM +0200, Vladimir Oltean wrote:
> On Fri, Feb 10, 2023 at 08:09:49PM +0100, Maxime Chevallier wrote:
> > When submitting the initial driver for the Altera TSE PCS, Russell King
> > noted that the register layout for the TSE PCS is very similar to the
> > Lynx PCS. The main difference being that TSE PCS's register space is
> > memory-mapped, whereas Lynx's is exposed over MDIO.
> > 
> > Convert the TSE PCS to reuse the whole logic from Lynx, by allowing
> > the creation of a dummy MDIO bus, and a dummy MDIO device located at
> > address 0 on that bus. The MAC driver that uses this PCS must provide
> > callbacks to read/write the MMIO.
> > 
> > Also convert the Altera TSE MAC driver to this new way of using the TSE
> > PCS.
> > 
> > Signed-off-by: Maxime Chevallier <maxime.chevallier@bootlin.com>
> > ---
> >  drivers/net/ethernet/altera/altera_tse.h      |   2 +-
> >  drivers/net/ethernet/altera/altera_tse_main.c |  50 ++++-
> >  drivers/net/pcs/Kconfig                       |   4 +
> >  drivers/net/pcs/pcs-altera-tse.c              | 194 +++++++-----------
> >  include/linux/pcs-altera-tse.h                |  22 +-
> >  5 files changed, 142 insertions(+), 130 deletions(-)
> 
> The glue layer is larger than the duplicated PCS code? :(

Another option might be regmap. There are both regmap-mdio.c and
regmap-mmio.c.

	Andrew
