Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 8B81264182B
	for <lists+netdev@lfdr.de>; Sat,  3 Dec 2022 18:47:14 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229680AbiLCRrG (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sat, 3 Dec 2022 12:47:06 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:58494 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229540AbiLCRrF (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sat, 3 Dec 2022 12:47:05 -0500
Received: from vps0.lunn.ch (vps0.lunn.ch [156.67.10.101])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 219551EC48
        for <netdev@vger.kernel.org>; Sat,  3 Dec 2022 09:47:04 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed; d=lunn.ch;
        s=20171124; h=In-Reply-To:Content-Disposition:Content-Type:MIME-Version:
        References:Message-ID:Subject:Cc:To:From:Date:From:Sender:Reply-To:Subject:
        Date:Message-ID:To:Cc:MIME-Version:Content-Type:Content-Transfer-Encoding:
        Content-ID:Content-Description:Content-Disposition:In-Reply-To:References;
        bh=CzBado51hfccIZHKKzHnIuNTg9I97DzCJ46YPKjxNdY=; b=Z9swNQ8wml2pZA1nFB4+agGrD2
        MIqnRBWhX19yKAbYYaTorBIEgCUSyu2Gg8ZMBGqptuSy8OIDpWYQPzH/BIwS7HQ56y60icOxPuWYK
        ujNoPohnuL35LCs1JCmonnvRCFpQN5eVElbwiqxpPe+cLgXvfQkPFWpR7446qq3bI0gM=;
Received: from andrew by vps0.lunn.ch with local (Exim 4.94.2)
        (envelope-from <andrew@lunn.ch>)
        id 1p1WbN-004HQL-Ke; Sat, 03 Dec 2022 18:47:01 +0100
Date:   Sat, 3 Dec 2022 18:47:01 +0100
From:   Andrew Lunn <andrew@lunn.ch>
To:     Heiner Kallweit <hkallweit1@gmail.com>
Cc:     Chunhao Lin <hau@realtek.com>, netdev@vger.kernel.org,
        nic_swsd@realtek.com
Subject: Re: [PATCH net-next v5] r8169: add support for rtl8168h(revid 0x2a)
 + rtl8211fs fiber application
Message-ID: <Y4uLlai9+fWUFH7B@lunn.ch>
References: <20221201143911.4449-1-hau@realtek.com>
 <199a6a2d-f66f-bd7c-45af-44c115715eac@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <199a6a2d-f66f-bd7c-45af-44c115715eac@gmail.com>
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,SPF_HELO_PASS,SPF_PASS
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

> >  enum rtl_flag {
> >  	RTL_FLAG_TASK_ENABLED = 0,
> >  	RTL_FLAG_TASK_RESET_PENDING,
> > @@ -624,6 +642,12 @@ struct rtl8169_private {
> >  	struct rtl_fw *rtl_fw;
> >  
> >  	u32 ocp_base;
> > +
> > +	struct {
> > +		struct mii_bus *mii_bus;
> > +		struct phy_device *phydev;
> 
> We have a phydev member in in struct rtl8169_private already,
> why can't you use it and need a separate one instead?

There is also one in the net_device structure. That is the best one to
use, since a lot of the ethtool core code will use that.

> >  	if (device_may_wakeup(tp_to_dev(tp))) {
> > -		phy_speed_down(tp->phydev, false);
> > +		/* Fiber not support speed down */
> 
> phy_speed_down() will switch to the slowest mode supported by both
> link partners. If the local PHY doesn't support a speed below 1Gbps
> then the call to phy_speed_down() is a no-op, it won't hurt.
> Therefore I see no reason to add complexity for skipping this call.
> 
> Another question may be whether switching to a slower speed is
> benefitial to power consumption in general on fiber.
> That's something I can't answer. But if true, we should add
> to phy_speed_down() to do nothing if port is PORT_FIBRE.

If the SFP is actually a copper module, going down to 10/Half should
save power, just as it does with a normal copper PHY.

The problem with a fibre SFP is that there is no negotiation. So in
theory you might be able to save some power by changing from 2500BaseX
to 1000BaseX, but there is no way to tell the link partner you want to
drop the speed.

For this MAC driver, i think it is a moot point. Since it appears to
be using phylib, not phylink. To correctly support SFPs this MAC
driver probably needs to change to phylink.

     Andrew
