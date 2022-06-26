Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id CF28B55B07F
	for <lists+netdev@lfdr.de>; Sun, 26 Jun 2022 11:03:03 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230221AbiFZI6s (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sun, 26 Jun 2022 04:58:48 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:40746 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229550AbiFZI6q (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sun, 26 Jun 2022 04:58:46 -0400
Received: from vps0.lunn.ch (vps0.lunn.ch [185.16.172.187])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 14FDAE0F8;
        Sun, 26 Jun 2022 01:58:46 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed; d=lunn.ch;
        s=20171124; h=In-Reply-To:Content-Disposition:Content-Type:MIME-Version:
        References:Message-ID:Subject:Cc:To:From:Date:From:Sender:Reply-To:Subject:
        Date:Message-ID:To:Cc:MIME-Version:Content-Type:Content-Transfer-Encoding:
        Content-ID:Content-Description:Content-Disposition:In-Reply-To:References;
        bh=1JKbLmopt0oRqy5yYNNrI21JPFQkbbU7U2hItfpsuus=; b=bJR8iIVxbtaUXB8NG6eDKqiuVa
        9xrMJnFB15Amkl8LagOgvijKEaeh9zgoC3mhJBCcBNlf4ZjIxiLGToqMKFmW+xvL1pkeMHdaK4ZL9
        tFyONmKeM676Dr4TwnFCvsDVXQw1uEDIbBVkcF76otqwqJWfovuEgAvUbIuI+cyDRGNg=;
Received: from andrew by vps0.lunn.ch with local (Exim 4.94.2)
        (envelope-from <andrew@lunn.ch>)
        id 1o5O64-008HQM-Mi; Sun, 26 Jun 2022 10:58:24 +0200
Date:   Sun, 26 Jun 2022 10:58:24 +0200
From:   Andrew Lunn <andrew@lunn.ch>
To:     Lukas Wunner <lukas@wunner.de>
Cc:     Oleksij Rempel <o.rempel@pengutronix.de>,
        "David S. Miller" <davem@davemloft.net>,
        Eric Dumazet <edumazet@google.com>,
        Jakub Kicinski <kuba@kernel.org>,
        Paolo Abeni <pabeni@redhat.com>, kernel@pengutronix.de,
        linux-kernel@vger.kernel.org, netdev@vger.kernel.org
Subject: Re: [PATCH net-next v1 1/1] net: phy: ax88772a: fix lost pause
 advertisement configuration
Message-ID: <YrgfsPq4lrYnSStk@lunn.ch>
References: <20220624075558.3141464-1-o.rempel@pengutronix.de>
 <20220625071731.GA3462@wunner.de>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20220625071731.GA3462@wunner.de>
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,SPF_HELO_PASS,SPF_PASS,
        T_SCC_BODY_TEXT_LINE autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Sat, Jun 25, 2022 at 09:17:31AM +0200, Lukas Wunner wrote:
> On Fri, Jun 24, 2022 at 09:55:58AM +0200, Oleksij Rempel wrote:
> > In case of asix_ax88772a_link_change_notify() workaround, we run soft
> > reset which will automatically clear MII_ADVERTISE configuration. The
> > PHYlib framework do not know about changed configuration state of the
> > PHY, so we need to save and restore all needed configuration registers.
> [...]
> >  static void asix_ax88772a_link_change_notify(struct phy_device *phydev)
> >  {
> >  	/* Reset PHY, otherwise MII_LPA will provide outdated information.
> >  	 * This issue is reproducible only with some link partner PHYs
> >  	 */
> > -	if (phydev->state == PHY_NOLINK && phydev->drv->soft_reset)
> > +	if (phydev->state == PHY_NOLINK && phydev->drv->soft_reset) {
> > +		struct asix_context context;
> > +
> > +		asix_context_save(phydev, &context);
> > +
> >  		phydev->drv->soft_reset(phydev);
> > +
> > +		asix_context_restore(phydev, &context);
> > +	}
> >  }
> 
> Hm, how about just calling phy_init_hw()?  That will perform a
> ->soft_reset() and also restore the configuration, including
> interrupts (which the above does not, but I guess that's
> irrelevant as long as the driver uses polling).
> 
> Does phy_init_hw() do too much or too little compared to the above
> and is hence not a viable solution?


at803x.c has:

        /* After changing the smart speed settings, we need to perform a
         * software reset, use phy_init_hw() to make sure we set the
         * reapply any values which might got lost during software reset.
         */
        if (ret == 1)
                ret = phy_init_hw(phydev);

	Andrew
