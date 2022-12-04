Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id DEDA5641EFB
	for <lists+netdev@lfdr.de>; Sun,  4 Dec 2022 19:48:44 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230110AbiLDSsl (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sun, 4 Dec 2022 13:48:41 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:50416 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229917AbiLDSsk (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sun, 4 Dec 2022 13:48:40 -0500
Received: from vps0.lunn.ch (vps0.lunn.ch [156.67.10.101])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id BB4B1BC3F;
        Sun,  4 Dec 2022 10:48:37 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed; d=lunn.ch;
        s=20171124; h=In-Reply-To:Content-Disposition:Content-Type:MIME-Version:
        References:Message-ID:Subject:Cc:To:From:Date:From:Sender:Reply-To:Subject:
        Date:Message-ID:To:Cc:MIME-Version:Content-Type:Content-Transfer-Encoding:
        Content-ID:Content-Description:Content-Disposition:In-Reply-To:References;
        bh=kanHw+QnAHfcqLMCiNmShG/TYNfncj9Qwo4nIigwvSI=; b=W16fe9xjyWa+FvAn/nRHUWmxma
        0TK2U7RCALTM/bQA3d6WjceAOtnWkqyb+QlNUD36tyzip2FnGqcRfq5ylVnU2Psgfnwgs7GmSB2Cx
        bvC6ZEe7jSFvDMNEKCC7GBMQ04oajA3I8ZsqkzHnvfncU1VjyyEdT+u4MqtSD5yVnVdw=;
Received: from andrew by vps0.lunn.ch with local (Exim 4.94.2)
        (envelope-from <andrew@lunn.ch>)
        id 1p1u2K-004Kvw-OS; Sun, 04 Dec 2022 19:48:24 +0100
Date:   Sun, 4 Dec 2022 19:48:24 +0100
From:   Andrew Lunn <andrew@lunn.ch>
To:     "Russell King (Oracle)" <linux@armlinux.org.uk>
Cc:     Piergiorgio Beruto <piergiorgio.beruto@gmail.com>,
        Heiner Kallweit <hkallweit1@gmail.com>,
        "David S. Miller" <davem@davemloft.net>,
        Eric Dumazet <edumazet@google.com>,
        Jakub Kicinski <kuba@kernel.org>,
        Paolo Abeni <pabeni@redhat.com>, linux-kernel@vger.kernel.org,
        netdev@vger.kernel.org, Oleksij Rempel <o.rempel@pengutronix.de>
Subject: Re: [PATCH net-next 4/4] driver/ncn26000: add PLCA support
Message-ID: <Y4zreLCwdx+fyuCe@lunn.ch>
References: <cover.1670119328.git.piergiorgio.beruto@gmail.com>
 <38623984f6235a1521e6b0ad2ea958abc84ad708.1670119328.git.piergiorgio.beruto@gmail.com>
 <Y4zTqvSxLJG+G8V+@shell.armlinux.org.uk>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <Y4zTqvSxLJG+G8V+@shell.armlinux.org.uk>
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,SPF_HELO_PASS,SPF_PASS
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Sun, Dec 04, 2022 at 05:06:50PM +0000, Russell King (Oracle) wrote:
> On Sun, Dec 04, 2022 at 03:32:06AM +0100, Piergiorgio Beruto wrote:
> > --- a/include/uapi/linux/mdio.h
> > +++ b/include/uapi/linux/mdio.h
> > @@ -26,6 +26,7 @@
> >  #define MDIO_MMD_C22EXT		29	/* Clause 22 extension */
> >  #define MDIO_MMD_VEND1		30	/* Vendor specific 1 */
> >  #define MDIO_MMD_VEND2		31	/* Vendor specific 2 */
> > +#define MDIO_MMD_OATC14		MDIO_MMD_VEND2
> 
> If this is in the vendor 2 register set, I doubt that this is a feature
> described by IEEE 802.3, since they allocated the entirety of this MMD
> over to manufacturers to do whatever they please with this space.
> 
> If this is correct, then these definitions have no place being in this
> generic header file, since they are likely specific to the vendors PHY.

Piergiorgio can give you the full details.

As i understand it, IEEE 802.3 defines the basic functionality, but
did not extend the standard to define the registers.

The Open Alliance member got together and added the missing parts, and
published an Open Alliance document.

Piergiorgio, i suggest you add a header file for these defines, named
to reflect that the Open Alliance defined them. And put in a comment,
explaining their origin, maybe a link to the standard. I also don't
think this needs to be a uapi header, they are not needed outside of
the kernel.

I also would not use MDIO_MMD_OATC14, but rather MDIO_MMD_VEND2. There
is no guarantee they are not being used for other things, and
MDIO_MMD_VEND2 gives a gentle warning about this.

	Andrew
