Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 693715600E0
	for <lists+netdev@lfdr.de>; Wed, 29 Jun 2022 15:10:16 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233308AbiF2M4o (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 29 Jun 2022 08:56:44 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:56104 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233429AbiF2M4l (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 29 Jun 2022 08:56:41 -0400
Received: from vps0.lunn.ch (vps0.lunn.ch [185.16.172.187])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id E4E053668F;
        Wed, 29 Jun 2022 05:56:39 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed; d=lunn.ch;
        s=20171124; h=In-Reply-To:Content-Disposition:Content-Type:MIME-Version:
        References:Message-ID:Subject:Cc:To:From:Date:From:Sender:Reply-To:Subject:
        Date:Message-ID:To:Cc:MIME-Version:Content-Type:Content-Transfer-Encoding:
        Content-ID:Content-Description:Content-Disposition:In-Reply-To:References;
        bh=BWWvFWIhlZ36cadXM9F7Ld3mUdOKao0uILrzUG5jiRU=; b=3FDCiBFBNQJtIWMHmnlsuCJaRy
        KXU+6P/kboFiPFwUnhUJJSKvESAY/J3IA1XzgdL3Dp1/MbffLkkdOW++tUoYtoChXR3N/TZB6Hfmt
        zUpdTljH0tWdoNQgt4JdpjJSFVgyocYjnBtmXIOZk+zMDoH+lNtwMp0shPqQZMyRZERo=;
Received: from andrew by vps0.lunn.ch with local (Exim 4.94.2)
        (envelope-from <andrew@lunn.ch>)
        id 1o6XF0-008hz2-BB; Wed, 29 Jun 2022 14:56:22 +0200
Date:   Wed, 29 Jun 2022 14:56:22 +0200
From:   Andrew Lunn <andrew@lunn.ch>
To:     Frank <Frank.Sae@motor-comm.com>
Cc:     Peter Geis <pgwipeout@gmail.com>,
        Heiner Kallweit <hkallweit1@gmail.com>,
        Russell King <linux@armlinux.org.uk>,
        "David S . Miller" <davem@davemloft.net>,
        Eric Dumazet <edumazet@google.com>,
        Jakub Kicinski <kuba@kernel.org>,
        Paolo Abeni <pabeni@redhat.com>, yinghong.zhang@motor-comm.com,
        fei.zhang@motor-comm.com, hua.sun@motor-comm.com,
        netdev@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: Re: Re: [PATCH v2] net: phy: Add driver for Motorcomm yt8521 gigabit
Message-ID: <YrxL9g1WQLn4TIMW@lunn.ch>
References: <20220629124848.142-1-Frank.Sae@motor-comm.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20220629124848.142-1-Frank.Sae@motor-comm.com>
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,SPF_HELO_PASS,SPF_PASS,
        T_SCC_BODY_TEXT_LINE autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

> > > +int yt8521_config_aneg(struct phy_device *phydev)
> > > +{
> > > + struct yt8521_priv *priv = phydev->priv;
> > > + u8 polling_mode = priv->polling_mode;
> > > + int old_page;
> > > + int ret;
> > > +
> > > + old_page = yt8521_read_page_with_lock(phydev);
> > > + if (old_page)
> > > +  return old_page;
> > > +
> > > + if (polling_mode == YT8521_MODE_FIBER ||
> > > +     polling_mode == YT8521_MODE_POLL) {
> > > +  ret = yt8521_write_page_with_lock(phydev,
> > > +        YT8521_RSSR_FIBER_SPACE);
> > > +  if (ret < 0)
> > > +   goto err_restore_page;
> > > +
> > > +  ret = genphy_config_aneg(phydev);
> > > +  if (ret < 0)
> > > +   goto err_restore_page;
> > > + }
> > > +
> > > + if (polling_mode == YT8521_MODE_UTP ||
> > > +     polling_mode == YT8521_MODE_POLL) {
> > > +  ret = yt8521_write_page_with_lock(phydev,
> > > +        YT8521_RSSR_UTP_SPACE);
> > > +  if (ret < 0)
> > > +   goto err_restore_page;
> > > +
> > > +  ret = genphy_config_aneg(phydev);
> > > +  if (ret < 0)
> > > +   goto err_restore_page;
> > > + }
> > 
> > Looks like this could be refactored to reduce duplication.
> > 
> 
> sure, as the reason said above, the same operation is required in both utp and
> fiber spaces.

So you can probably pull the 'core' of this function out into a
helper, and then call it either with YT8521_RSSR_UTP_SPACE or
YT8521_RSSR_FIBER_SPACE.

> > > + ret = !!(link_fiber | link_utp);
> > 
> > Does this mean it can do both copper and fibre at the same time. And
> > whichever gives up first wins?
> 
> Sure, the phy supports utp, fiber, and both. In the case of both, this driver
> supposes that fiber is of priority.

It is generally not that simple. Fibre, you probably want 1000BaseX,
unless the fibre module is actually copper, and then you want
SGMII. So you need something to talk to the fibre module and ask it
what it is. That something is phylink. Phylink does not support both
copper and fibre at the same time for one MAC.

       Andrew
