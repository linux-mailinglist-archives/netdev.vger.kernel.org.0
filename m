Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 53A3363DBAF
	for <lists+netdev@lfdr.de>; Wed, 30 Nov 2022 18:14:24 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231134AbiK3ROW (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 30 Nov 2022 12:14:22 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:39708 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231143AbiK3ROC (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 30 Nov 2022 12:14:02 -0500
Received: from vps0.lunn.ch (vps0.lunn.ch [156.67.10.101])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 8B8F1B08;
        Wed, 30 Nov 2022 09:11:02 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed; d=lunn.ch;
        s=20171124; h=In-Reply-To:Content-Disposition:Content-Type:MIME-Version:
        References:Message-ID:Subject:Cc:To:From:Date:From:Sender:Reply-To:Subject:
        Date:Message-ID:To:Cc:MIME-Version:Content-Type:Content-Transfer-Encoding:
        Content-ID:Content-Description:Content-Disposition:In-Reply-To:References;
        bh=HOR8TJlxjCjAtgrXFWiZM3BCPiC97uvsOgWLmMHIcAM=; b=sJhVGozYoTaAqEbOHSw0JhUC/J
        ypKAouVxcLP88WVTUnVmgtF2KsPw4dohg41oO4EmPrBMy6rP0tZxVYoqGthR9Qrha8QcnCXvjtqTI
        /7gf957SDvkw5IVCsxATJM+cakLQy84lk53yvWQxM6UhHAxtl2KxjoKb3fji+pxoxZ38=;
Received: from andrew by vps0.lunn.ch with local (Exim 4.94.2)
        (envelope-from <andrew@lunn.ch>)
        id 1p0Qba-003ymW-GK; Wed, 30 Nov 2022 18:10:42 +0100
Date:   Wed, 30 Nov 2022 18:10:42 +0100
From:   Andrew Lunn <andrew@lunn.ch>
To:     "Russell King (Oracle)" <linux@armlinux.org.uk>
Cc:     Frank <Frank.Sae@motor-comm.com>, Peter Geis <pgwipeout@gmail.com>,
        Heiner Kallweit <hkallweit1@gmail.com>,
        "David S . Miller" <davem@davemloft.net>,
        Eric Dumazet <edumazet@google.com>,
        Jakub Kicinski <kuba@kernel.org>,
        Paolo Abeni <pabeni@redhat.com>, yinghong.zhang@motor-comm.com,
        fei.zhang@motor-comm.com, hua.sun@motor-comm.com,
        netdev@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH net-next] net: phy: Add driver for Motorcomm yt8531
 gigabit ethernet phy
Message-ID: <Y4eOkiaRywaUJa9n@lunn.ch>
References: <20221130094928.14557-1-Frank.Sae@motor-comm.com>
 <Y4copjAzKpGSeunB@shell.armlinux.org.uk>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <Y4copjAzKpGSeunB@shell.armlinux.org.uk>
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,SPF_HELO_PASS,SPF_PASS
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Wed, Nov 30, 2022 at 09:55:50AM +0000, Russell King (Oracle) wrote:
> On Wed, Nov 30, 2022 at 05:49:28PM +0800, Frank wrote:
> > +/**
> > + * yt8531_set_wol() - turn wake-on-lan on or off
> > + * @phydev: a pointer to a &struct phy_device
> > + * @wol: a pointer to a &struct ethtool_wolinfo
> > + *
> > + * NOTE: YTPHY_WOL_CONFIG_REG, YTPHY_WOL_MACADDR2_REG, YTPHY_WOL_MACADDR1_REG
> > + * and YTPHY_WOL_MACADDR0_REG are common ext reg.
> > + *
> > + * returns 0 or negative errno code
> > + */
> > +static int yt8531_set_wol(struct phy_device *phydev,
> > +			  struct ethtool_wolinfo *wol)
> > +{
> 
> So this is called from the .set_wol method directly, and won't have the
> MDIO bus lock taken...

Hi Frank

This is not the first time Russell has pointed out your locking is
wrong.

How about adding a check in functions which should be called with the
lock taken really do have the lock taken?

ASSERT_RTNL() but for an MDIO bus.

	Andrew
