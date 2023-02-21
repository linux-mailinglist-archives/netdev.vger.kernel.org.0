Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 0CE0469DB3F
	for <lists+netdev@lfdr.de>; Tue, 21 Feb 2023 08:34:20 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233647AbjBUHeS (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 21 Feb 2023 02:34:18 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:33838 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229545AbjBUHeR (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 21 Feb 2023 02:34:17 -0500
Received: from relay7-d.mail.gandi.net (relay7-d.mail.gandi.net [217.70.183.200])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 4A6C4869D;
        Mon, 20 Feb 2023 23:34:16 -0800 (PST)
Received: (Authenticated sender: maxime.chevallier@bootlin.com)
        by mail.gandi.net (Postfix) with ESMTPSA id F178220002;
        Tue, 21 Feb 2023 07:34:12 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=bootlin.com; s=gm1;
        t=1676964855;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=ofPSoPH7VZ0FWxUqGEHa/UVsnt2dfr9s7ihBxoDcPic=;
        b=o7ndZ8vt0FQt1JKGfPvfP5kJdnULXs4WoDpkJ+6l0SDk1zp/RBR2YosPQ4kHr+StQlfoAQ
        35fm0WUjJEkKKEvgoTQuHqok2wN2S53+y8kxrqGJr8nYBHZbSjBSVwdKPtnJqI+/rMj0B8
        ii/F1/k+nz0GgHQ4Zz/g+x07zLx9phS5M4RVc0ldhnVOxZ3kWSNuB2lD5kxjyh3cEk747r
        K2kKFj2du1t+0gksWZh2G3nW77jlRhEYeT/PRx7qcu+X8JX93NdLfj9DfSuI4fdcIunEOx
        TlDXNrpkhgEd/GwLgQdKhqM6QEux51KXWUojVC/8pyIOLVjopZzxJCnrkwtQ8Q==
Date:   Tue, 21 Feb 2023 08:34:12 +0100
From:   Maxime Chevallier <maxime.chevallier@bootlin.com>
To:     Andrew Lunn <andrew@lunn.ch>
Cc:     Vladimir Oltean <vladimir.oltean@nxp.com>, davem@davemloft.net,
        netdev@vger.kernel.org, linux-kernel@vger.kernel.org,
        thomas.petazzoni@bootlin.com, Jakub Kicinski <kuba@kernel.org>,
        Eric Dumazet <edumazet@google.com>,
        Paolo Abeni <pabeni@redhat.com>,
        Florian Fainelli <f.fainelli@gmail.com>,
        Heiner Kallweit <hkallweit1@gmail.com>,
        Russell King <linux@armlinux.org.uk>,
        linux-arm-kernel@lists.infradead.org,
        Ioana Ciornei <ioana.ciornei@nxp.com>
Subject: Re: [PATCH net-next] net: pcs: tse: port to pcs-lynx
Message-ID: <20230221083412.5e11db13@pc-7.home>
In-Reply-To: <Y+ai3zHMUCDcxqxP@lunn.ch>
References: <20230210190949.1115836-1-maxime.chevallier@bootlin.com>
        <20230210190949.1115836-1-maxime.chevallier@bootlin.com>
        <20230210193159.qmbtvwtx6kqagvxy@skbuf>
        <Y+ai3zHMUCDcxqxP@lunn.ch>
Organization: Bootlin
X-Mailer: Claws Mail 4.1.1 (GTK 3.24.36; x86_64-redhat-linux-gnu)
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
X-Spam-Status: No, score=-2.8 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_LOW,
        RCVD_IN_MSPIKE_H2,SPF_HELO_NONE,SPF_PASS autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Hi Vlad, Andrew,

On Fri, 10 Feb 2023 21:02:39 +0100
Andrew Lunn <andrew@lunn.ch> wrote:

> On Fri, Feb 10, 2023 at 09:31:59PM +0200, Vladimir Oltean wrote:
> > On Fri, Feb 10, 2023 at 08:09:49PM +0100, Maxime Chevallier wrote:  
> > > When submitting the initial driver for the Altera TSE PCS,
> > > Russell King noted that the register layout for the TSE PCS is
> > > very similar to the Lynx PCS. The main difference being that TSE
> > > PCS's register space is memory-mapped, whereas Lynx's is exposed
> > > over MDIO.
> > > 
> > > Convert the TSE PCS to reuse the whole logic from Lynx, by
> > > allowing the creation of a dummy MDIO bus, and a dummy MDIO
> > > device located at address 0 on that bus. The MAC driver that uses
> > > this PCS must provide callbacks to read/write the MMIO.
> > > 
> > > Also convert the Altera TSE MAC driver to this new way of using
> > > the TSE PCS.
> > > 
> > > Signed-off-by: Maxime Chevallier <maxime.chevallier@bootlin.com>
> > > ---
> > >  drivers/net/ethernet/altera/altera_tse.h      |   2 +-
> > >  drivers/net/ethernet/altera/altera_tse_main.c |  50 ++++-
> > >  drivers/net/pcs/Kconfig                       |   4 +
> > >  drivers/net/pcs/pcs-altera-tse.c              | 194
> > > +++++++----------- include/linux/pcs-altera-tse.h
> > > |  22 +- 5 files changed, 142 insertions(+), 130 deletions(-)  
> > 
> > The glue layer is larger than the duplicated PCS code? :(  
> 
> I was wondering if the glue could actually be made generic. The kernel
> has a number of reasonably generic MMIO device drivers, which are just
> given an address range and assume a logical mapping.
> 
> Could this be made into a generic MDIO MMIO bus driver, which just
> gets configured with a base address, and maybe a stride between
> registers?

That would be ideal, I'll spin a new series prorotyping this, indeed
that can be interesting for other devices.

Thanks for the review,

Maxime

> 	Andrew

