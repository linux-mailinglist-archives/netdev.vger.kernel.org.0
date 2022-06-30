Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 21346561E68
	for <lists+netdev@lfdr.de>; Thu, 30 Jun 2022 16:51:01 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232240AbiF3Ouv (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 30 Jun 2022 10:50:51 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:57434 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229966AbiF3Ouv (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 30 Jun 2022 10:50:51 -0400
Received: from pandora.armlinux.org.uk (pandora.armlinux.org.uk [IPv6:2001:4d48:ad52:32c8:5054:ff:fe00:142])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id E5D9D1CFC3
        for <netdev@vger.kernel.org>; Thu, 30 Jun 2022 07:50:49 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
        d=armlinux.org.uk; s=pandora-2019; h=Sender:In-Reply-To:Content-Type:
        MIME-Version:References:Message-ID:Subject:Cc:To:From:Date:Reply-To:
        Content-Transfer-Encoding:Content-ID:Content-Description:Resent-Date:
        Resent-From:Resent-Sender:Resent-To:Resent-Cc:Resent-Message-ID:List-Id:
        List-Help:List-Unsubscribe:List-Subscribe:List-Post:List-Owner:List-Archive;
        bh=6z69s5XmE4N26yz/wfBRTcC6/4g2n89bhHHZG1ZEY3k=; b=BlTzebUwncI9PlcuxddnNPS5Ol
        mObYN0WtbG7F9CKh+rMuql4Ls9WtANYdvc1jfZV9joVzczX2L2jmKHsc6xoGr31/oZsfoVxQseEVb
        0I61M4sWcNsP2eqogC5BvOffo+OjtmTPBIdew+jXxwHFnw1NECv3oMlh/ETYeB/yPW5qXGS0jQWKb
        oZnts+joxavq2MifK+WjN6D+J4lJqnJfKmJfk9SmYCNuptviV/im1fCetM9hiJevcuPJYGEGEwLdb
        jk3C2Uweq5T3k877Jp1xrlejQC37m1dL0U5rZkM6l8wZH1N8S4RJhSsjHkxmDXnuuEi9gzJsOie+O
        0Tr7Sjkg==;
Received: from shell.armlinux.org.uk ([fd8f:7570:feb6:1:5054:ff:fe00:4ec]:33120)
        by pandora.armlinux.org.uk with esmtpsa  (TLS1.3) tls TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384
        (Exim 4.94.2)
        (envelope-from <linux@armlinux.org.uk>)
        id 1o6vVG-0004a3-6T; Thu, 30 Jun 2022 15:50:46 +0100
Received: from linux by shell.armlinux.org.uk with local (Exim 4.94.2)
        (envelope-from <linux@shell.armlinux.org.uk>)
        id 1o6vVD-0006ra-GF; Thu, 30 Jun 2022 15:50:43 +0100
Date:   Thu, 30 Jun 2022 15:50:43 +0100
From:   "Russell King (Oracle)" <linux@armlinux.org.uk>
To:     Nicolas Ferre <nicolas.ferre@microchip.com>
Cc:     Vladimir Oltean <vladimir.oltean@nxp.com>, netdev@vger.kernel.org,
        "David S. Miller" <davem@davemloft.net>,
        Eric Dumazet <edumazet@google.com>,
        Jakub Kicinski <kuba@kernel.org>,
        Paolo Abeni <pabeni@redhat.com>, Andrew Lunn <andrew@lunn.ch>,
        Heiner Kallweit <hkallweit1@gmail.com>,
        Claudiu Beznea <Claudiu.Beznea@microchip.com>,
        Santiago Esteban <Santiago.Esteban@microchip.com>
Subject: Re: [PATCH net-next] net: phylink: fix NULL pl->pcs dereference
 during phylink_pcs_poll_start
Message-ID: <Yr24QzzcS1dMVtl0@shell.armlinux.org.uk>
References: <20220629193358.4007923-1-vladimir.oltean@nxp.com>
 <bfe3b0a0-5f42-6c32-6de7-4d989544e488@microchip.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <bfe3b0a0-5f42-6c32-6de7-4d989544e488@microchip.com>
Sender: Russell King (Oracle) <linux@armlinux.org.uk>
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,SPF_HELO_NONE,SPF_NONE,
        T_SCC_BODY_TEXT_LINE autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Thu, Jun 30, 2022 at 03:46:54PM +0200, Nicolas Ferre wrote:
> Vladimir, Russell,
> 
> On 29/06/2022 at 21:33, Vladimir Oltean wrote:
> > The current link mode of the phylink instance may not require an
> > attached PCS. However, phylink_major_config() unconditionally
> > dereferences this potentially NULL pointer when restarting the link poll
> > timer, which will panic the kernel.
> > 
> > Fix the problem by checking whether a PCS exists in phylink_pcs_poll_start(),
> > otherwise do nothing. The code prior to the blamed patch also only
> > looked at pcs->poll within an "if (pcs)" block.
> > 
> > Fixes: bfac8c490d60 ("net: phylink: disable PCS polling over major configuration")
> > Signed-off-by: Vladimir Oltean <vladimir.oltean@nxp.com>
> > ---
> >   drivers/net/phy/phylink.c | 2 +-
> >   1 file changed, 1 insertion(+), 1 deletion(-)
> > 
> > diff --git a/drivers/net/phy/phylink.c b/drivers/net/phy/phylink.c
> > index 1a7550f5fdf5..48f0b9b39491 100644
> > --- a/drivers/net/phy/phylink.c
> > +++ b/drivers/net/phy/phylink.c
> > @@ -766,7 +766,7 @@ static void phylink_pcs_poll_stop(struct phylink *pl)
> >   static void phylink_pcs_poll_start(struct phylink *pl)
> >   {
> > -	if (pl->pcs->poll && pl->cfg_link_an_mode == MLO_AN_INBAND)
> > +	if (pl->pcs && pl->pcs->poll && pl->cfg_link_an_mode == MLO_AN_INBAND)
> >   		mod_timer(&pl->link_poll, jiffies + HZ);
> >   }
> 
> Fixes the NULL pointer on my boards:
> Tested-by: Nicolas Ferre <nicolas.ferre@microchip.com> # on sam9x60ek

Thanks all, hopefully it'll get applied to net-next soon.

Sadly, this slipped through my testing, as the only platform I have
access to at the moment always supplies a PCS (mvneta based) so there's
no way my testing would ever have caught this. Sorry for the problems.

-- 
RMK's Patch system: https://www.armlinux.org.uk/developer/patches/
FTTP is here! 40Mbps down 10Mbps up. Decent connectivity at last!
