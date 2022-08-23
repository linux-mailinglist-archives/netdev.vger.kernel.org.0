Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id DFEFE59EA16
	for <lists+netdev@lfdr.de>; Tue, 23 Aug 2022 19:46:38 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229808AbiHWRnW (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 23 Aug 2022 13:43:22 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:57722 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230028AbiHWRmw (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 23 Aug 2022 13:42:52 -0400
Received: from vps0.lunn.ch (vps0.lunn.ch [185.16.172.187])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id E730FF59A
        for <netdev@vger.kernel.org>; Tue, 23 Aug 2022 08:31:20 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed; d=lunn.ch;
        s=20171124; h=In-Reply-To:Content-Disposition:Content-Type:MIME-Version:
        References:Message-ID:Subject:Cc:To:From:Date:From:Sender:Reply-To:Subject:
        Date:Message-ID:To:Cc:MIME-Version:Content-Type:Content-Transfer-Encoding:
        Content-ID:Content-Description:Content-Disposition:In-Reply-To:References;
        bh=S8mZ4lXXOdtXKrmks5jlBFoEUP1UYsLDzLUIKLF24C0=; b=4ejIh6QHqqDaRrjcguFv5LiF3Q
        JG7Q/FZHTWtuhDpJ6fUpwHXwoCHmWshcK5rWQkxkF/PUP203xDWsPxFwFxKUJGmoFe9oZKK0jpYK+
        MApb1ewlaNv+SMCPwbo8CBtgnY8jg2d5TsGJ5Fh9Yu43okCeFvyUSamPFfueTzVJgv6g=;
Received: from andrew by vps0.lunn.ch with local (Exim 4.94.2)
        (envelope-from <andrew@lunn.ch>)
        id 1oQVs6-00EMXs-9Y; Tue, 23 Aug 2022 17:31:18 +0200
Date:   Tue, 23 Aug 2022 17:31:18 +0200
From:   Andrew Lunn <andrew@lunn.ch>
To:     Hau <hau@realtek.com>
Cc:     "hkallweit1@gmail.com" <hkallweit1@gmail.com>,
        "netdev@vger.kernel.org" <netdev@vger.kernel.org>,
        nic_swsd <nic_swsd@realtek.com>,
        "kuba@kernel.org" <kuba@kernel.org>,
        "davem@davemloft.net" <davem@davemloft.net>
Subject: Re: [PATCH v3 net-next] r8169: add support for rtl8168h(revid 0x2a)
 + rtl8211fs fiber application
Message-ID: <YwTyxpKbjxz1s8Xe@lunn.ch>
References: <20220822160714.2904-1-hau@realtek.com>
 <YwPf8yXud3mYFvnW@lunn.ch>
 <7e24c3c4c3ea42e482a70160aec6930c@realtek.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <7e24c3c4c3ea42e482a70160aec6930c@realtek.com>
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,SPF_HELO_PASS,SPF_PASS,
        T_SCC_BODY_TEXT_LINE autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Tue, Aug 23, 2022 at 03:17:16PM +0000, Hau wrote:
> > > @@ -914,8 +952,12 @@ static void r8168g_mdio_write(struct
> > rtl8169_private *tp, int reg, int value)
> > >  	if (tp->ocp_base != OCP_STD_PHY_BASE)
> > >  		reg -= 0x10;
> > >
> > > -	if (tp->ocp_base == OCP_STD_PHY_BASE && reg == MII_BMCR)
> > > +	if (tp->ocp_base == OCP_STD_PHY_BASE && reg == MII_BMCR) {
> > > +		if (tp->sfp_if_type != RTL_SFP_IF_NONE && value &
> > BMCR_PDOWN)
> > > +			return;
> > > +
> > 
> > Please could you explain this change.
> H/W has issue. If we power down phy, then H/W will become abnormal.

Does the MAC break, or the PHY? If the PHY is the problem, the work
around should be in the PHY driver, not the MAC driver.

> > > +/* MDIO bus init function */
> > > +static int rtl_mdio_bitbang_init(struct rtl8169_private *tp) {
> > > +	struct bb_info *bitbang;
> > > +	struct device *d = tp_to_dev(tp);
> > > +	struct mii_bus *new_bus;
> > > +
> > > +	/* create bit control struct for PHY */
> > > +	bitbang = devm_kzalloc(d, sizeof(struct bb_info), GFP_KERNEL);
> > > +	if (!bitbang)
> > > +		return -ENOMEM;
> > > +
> > > +	/* bitbang init */
> > > +	bitbang->tp = tp;
> > > +	bitbang->ctrl.ops = &bb_ops;
> > > +	bitbang->ctrl.op_c22_read = MDIO_READ;
> > > +	bitbang->ctrl.op_c22_write = MDIO_WRITE;
> > > +
> > > +	/* MII controller setting */
> > > +	new_bus = devm_mdiobus_alloc(d);
> > > +	if (!new_bus)
> > > +		return -ENOMEM;
> > > +
> > > +	new_bus->read = mdiobb_read;
> > > +	new_bus->write = mdiobb_write;
> > > +	new_bus->priv = &bitbang->ctrl;
> > 
> > Please use alloc_mdio_bitbang().
> >
> I have tried to use alloc_mdio_bitbang(). But I will get error message " rmmod: ERROR: Module r8169 is in use " when I try to unload r8169.
> After debug, I found it is cause by "__module_get(ctrl->ops->owner); " in alloc_mdio_bitbang().

void free_mdio_bitbang(struct mii_bus *bus)
{
        struct mdiobb_ctrl *ctrl = bus->priv;

        module_put(ctrl->ops->owner);
        mdiobus_free(bus);
}

Make sure your cleanup is symmetrical to your setup.

     Andrew
