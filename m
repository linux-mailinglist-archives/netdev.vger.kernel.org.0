Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 88FF759EB79
	for <lists+netdev@lfdr.de>; Tue, 23 Aug 2022 20:52:46 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231947AbiHWSwn (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 23 Aug 2022 14:52:43 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:37256 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233288AbiHWSwX (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 23 Aug 2022 14:52:23 -0400
Received: from vps0.lunn.ch (vps0.lunn.ch [185.16.172.187])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 4DC64C483D
        for <netdev@vger.kernel.org>; Tue, 23 Aug 2022 10:16:53 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed; d=lunn.ch;
        s=20171124; h=In-Reply-To:Content-Disposition:Content-Type:MIME-Version:
        References:Message-ID:Subject:Cc:To:From:Date:From:Sender:Reply-To:Subject:
        Date:Message-ID:To:Cc:MIME-Version:Content-Type:Content-Transfer-Encoding:
        Content-ID:Content-Description:Content-Disposition:In-Reply-To:References;
        bh=GRdzT202yVni30vuWRElTyfAAcAmLd28rb5Ul6SUSxg=; b=mAE1Df6KZOO+5fYJm6NqY4XIMj
        oseHdRI7dwYsFD2xJp5rpSECqd0f2W4sra3VoBCrw6s0BsopxmENlpYVs51ZdOx+SOKLLRffiIwHF
        h8d8Dih7U4xwEz1kyF0ZnaeR7IKQlUpYjTpjJ6x8tFTEYgwaLhLjj/msFYz+3e+EpUJI=;
Received: from andrew by vps0.lunn.ch with local (Exim 4.94.2)
        (envelope-from <andrew@lunn.ch>)
        id 1oQXWD-00EN3o-5M; Tue, 23 Aug 2022 19:16:49 +0200
Date:   Tue, 23 Aug 2022 19:16:49 +0200
From:   Andrew Lunn <andrew@lunn.ch>
To:     Hau <hau@realtek.com>
Cc:     "hkallweit1@gmail.com" <hkallweit1@gmail.com>,
        "netdev@vger.kernel.org" <netdev@vger.kernel.org>,
        nic_swsd <nic_swsd@realtek.com>,
        "kuba@kernel.org" <kuba@kernel.org>,
        "davem@davemloft.net" <davem@davemloft.net>
Subject: Re: [PATCH v3 net-next] r8169: add support for rtl8168h(revid 0x2a)
 + rtl8211fs fiber application
Message-ID: <YwULgfZBDBhnn+Aa@lunn.ch>
References: <20220822160714.2904-1-hau@realtek.com>
 <YwPf8yXud3mYFvnW@lunn.ch>
 <7e24c3c4c3ea42e482a70160aec6930c@realtek.com>
 <YwTyxpKbjxz1s8Xe@lunn.ch>
 <f0e230cebf274ce9ae38bf74e3d5da06@realtek.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <f0e230cebf274ce9ae38bf74e3d5da06@realtek.com>
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,SPF_HELO_PASS,SPF_PASS,
        T_SCC_BODY_TEXT_LINE autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Tue, Aug 23, 2022 at 03:48:13PM +0000, Hau wrote:
> > > > > @@ -914,8 +952,12 @@ static void r8168g_mdio_write(struct
> > > > rtl8169_private *tp, int reg, int value)
> > > > >  	if (tp->ocp_base != OCP_STD_PHY_BASE)
> > > > >  		reg -= 0x10;
> > > > >
> > > > > -	if (tp->ocp_base == OCP_STD_PHY_BASE && reg == MII_BMCR)
> > > > > +	if (tp->ocp_base == OCP_STD_PHY_BASE && reg == MII_BMCR) {
> > > > > +		if (tp->sfp_if_type != RTL_SFP_IF_NONE && value &
> > > > BMCR_PDOWN)
> > > > > +			return;
> > > > > +
> > > >
> > > > Please could you explain this change.
> > > H/W has issue. If we power down phy, then H/W will become abnormal.
> > 
> > Does the MAC break, or the PHY? If the PHY is the problem, the work around
> > should be in the PHY driver, not the MAC driver.
> >
> It is a workaround. We did not get the root cause yet.

O.K, since you are modifying a PHY register, lets assume it is a PHY
issue. Please put the workaround in the PHY driver.

> > > I have tried to use alloc_mdio_bitbang(). But I will get error message "
> > rmmod: ERROR: Module r8169 is in use " when I try to unload r8169.
> > > After debug, I found it is cause by "__module_get(ctrl->ops->owner); " in
> > alloc_mdio_bitbang().
> > 
> > void free_mdio_bitbang(struct mii_bus *bus) {
> >         struct mdiobb_ctrl *ctrl = bus->priv;
> > 
> >         module_put(ctrl->ops->owner);
> >         mdiobus_free(bus);
> > }
> > 
> > Make sure your cleanup is symmetrical to your setup.
> > 
> I have tried to call free_mdio_bitbang() in rtl_remove_one (). But when I try to unload r8169, rtl_remove_one() did not get called.

So you probably need to dig into driver/base/dd.c and maybe the
drivers/pci, to understand why.

	Andrew
