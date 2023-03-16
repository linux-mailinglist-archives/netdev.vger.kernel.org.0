Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 67B9B6BD4C3
	for <lists+netdev@lfdr.de>; Thu, 16 Mar 2023 17:12:41 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229691AbjCPQMj (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 16 Mar 2023 12:12:39 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:57044 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229834AbjCPQMh (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 16 Mar 2023 12:12:37 -0400
Received: from pandora.armlinux.org.uk (pandora.armlinux.org.uk [IPv6:2001:4d48:ad52:32c8:5054:ff:fe00:142])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id CAD70C88BC
        for <netdev@vger.kernel.org>; Thu, 16 Mar 2023 09:12:34 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
        d=armlinux.org.uk; s=pandora-2019; h=Sender:In-Reply-To:Content-Type:
        MIME-Version:References:Message-ID:Subject:Cc:To:From:Date:Reply-To:
        Content-Transfer-Encoding:Content-ID:Content-Description:Resent-Date:
        Resent-From:Resent-Sender:Resent-To:Resent-Cc:Resent-Message-ID:List-Id:
        List-Help:List-Unsubscribe:List-Subscribe:List-Post:List-Owner:List-Archive;
        bh=AGO8WPIaopQ9Vyx7ceqtVJ2EGsPrpJzBALdP3gGoF+Y=; b=11oDZIPoVt8gMQ1kCMmnOXQRhz
        DU47X6ccclhR6Fu2QMKA12fELu4DxqfaocDD7mvlIhfcidV7tYTEMJaIr0oLbaZmzS5xlk5Mdf3rF
        FOsWrPYiMBKvnBa3QikUpqqc5JO4RUKQAH8BDadn9n+YFx0obUt646oncd1KIdhZnnlEDR3unYz5C
        6M+D8gObo5OmI5iaY2mu78pcRCmI4+EN6z9NPoO90gnwJOQpn+F/S6MctEgNsYvPsiwFaCerZ8Khb
        HqJ+pKRfpcS3AHkvK2qEp3EQgv6CN2gKxRy32clXSnAlFBDB0zc5VFr7+KVtCmGvmQquATU3lnjZg
        FoVmtdTg==;
Received: from shell.armlinux.org.uk ([fd8f:7570:feb6:1:5054:ff:fe00:4ec]:58776)
        by pandora.armlinux.org.uk with esmtpsa  (TLS1.3) tls TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384
        (Exim 4.94.2)
        (envelope-from <linux@armlinux.org.uk>)
        id 1pcqDE-0000tY-8W; Thu, 16 Mar 2023 16:12:20 +0000
Received: from linux by shell.armlinux.org.uk with local (Exim 4.94.2)
        (envelope-from <linux@shell.armlinux.org.uk>)
        id 1pcqDA-0002YE-8L; Thu, 16 Mar 2023 16:12:16 +0000
Date:   Thu, 16 Mar 2023 16:12:16 +0000
From:   "Russell King (Oracle)" <linux@armlinux.org.uk>
To:     Steen Hegelund <steen.hegelund@microchip.com>
Cc:     Andrew Lunn <andrew@lunn.ch>,
        Ioana Ciornei <ioana.ciornei@nxp.com>,
        Jonathan McDowell <noodles@earth.li>,
        Jose Abreu <Jose.Abreu@synopsys.com>,
        Vladimir Oltean <olteanv@gmail.com>,
        Heiner Kallweit <hkallweit1@gmail.com>,
        "David S. Miller" <davem@davemloft.net>,
        Eric Dumazet <edumazet@google.com>,
        Jakub Kicinski <kuba@kernel.org>,
        Paolo Abeni <pabeni@redhat.com>, netdev@vger.kernel.org
Subject: Re: [PATCH net-next 1/2] net: pcs: xpcs: remove double-read of link
 state when using AN
Message-ID: <ZBM/4H/BKZpjghB/@shell.armlinux.org.uk>
References: <ZBHaQDM+G/o/UW3i@shell.armlinux.org.uk>
 <E1pcSOp-00DiAo-Su@rmk-PC.armlinux.org.uk>
 <918d1908c2771f4941c191b73c495e20d89a6a99.camel@microchip.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <918d1908c2771f4941c191b73c495e20d89a6a99.camel@microchip.com>
Sender: Russell King (Oracle) <linux@armlinux.org.uk>
X-Spam-Status: No, score=-4.4 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_MED,SPF_HELO_NONE,
        SPF_NONE autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Thu, Mar 16, 2023 at 10:44:48AM +0100, Steen Hegelund wrote:
> Hi Russell,
> 
> 
> On Wed, 2023-03-15 at 14:46 +0000, Russell King (Oracle) wrote:
> > EXTERNAL EMAIL: Do not click links or open attachments unless you know the content is safe
> > 
> > Phylink does not want the current state of the link when reading the
> > PCS link state - it wants the latched state. Don't double-read the
> > MII status register. Phylink will re-read as necessary to capture
> > transient link-down events as of dbae3388ea9c ("net: phylink: Force
> > retrigger in case of latched link-fail indicator").
> > 
> > The above referenced commit is a dependency for this change, and thus
> > this change should not be backported to any kernel that does not
> > contain the above referenced commit.
> > 
> > Fixes: fcb26bd2b6ca ("net: phy: Add Synopsys DesignWare XPCS MDIO module")
> > Signed-off-by: Russell King (Oracle) <rmk+kernel@armlinux.org.uk>
> > ---
> >  drivers/net/pcs/pcs-xpcs.c | 13 ++-----------
> >  1 file changed, 2 insertions(+), 11 deletions(-)
> > 
> > diff --git a/drivers/net/pcs/pcs-xpcs.c b/drivers/net/pcs/pcs-xpcs.c
> > index bc428a816719..04a685353041 100644
> > --- a/drivers/net/pcs/pcs-xpcs.c
> > +++ b/drivers/net/pcs/pcs-xpcs.c
> > @@ -321,7 +321,7 @@ static int xpcs_read_fault_c73(struct dw_xpcs *xpcs,
> >         return 0;
> >  }
> > 
> > -static int xpcs_read_link_c73(struct dw_xpcs *xpcs, bool an)
> > +static int xpcs_read_link_c73(struct dw_xpcs *xpcs)
> >  {
> >         bool link = true;
> >         int ret;
> > @@ -333,15 +333,6 @@ static int xpcs_read_link_c73(struct dw_xpcs *xpcs, bool an)
> >         if (!(ret & MDIO_STAT1_LSTATUS))
> >                 link = false;
> > 
> > -       if (an) {
> > -               ret = xpcs_read(xpcs, MDIO_MMD_AN, MDIO_STAT1);
> > -               if (ret < 0)
> > -                       return ret;
> > -
> > -               if (!(ret & MDIO_STAT1_LSTATUS))
> > -                       link = false;
> > -       }
> > -
> >         return link;
> >  }
> > 
> > @@ -935,7 +926,7 @@ static int xpcs_get_state_c73(struct dw_xpcs *xpcs,
> >         int ret;
> > 
> >         /* Link needs to be read first ... */
> > -       state->link = xpcs_read_link_c73(xpcs, state->an_enabled) > 0 ? 1 : 0;
> > +       state->link = xpcs_read_link_c73(xpcs) > 0 ? 1 : 0;
> 
> Couldn't you just say:
> 
> 	state->link = xpcs_read_link_c73(xpcs) > 0;
> 
> That should be a boolean, right?

That would be another change to the code - and consider how such a
change would fit in this series given its description and also this
patch.

IMHO such a change should be a separate patch - and there's plenty
of scope for cleanups like the one you suggest in this driver.

Thanks.

-- 
RMK's Patch system: https://www.armlinux.org.uk/developer/patches/
FTTP is here! 40Mbps down 10Mbps up. Decent connectivity at last!
