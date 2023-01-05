Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 4412565F418
	for <lists+netdev@lfdr.de>; Thu,  5 Jan 2023 20:06:57 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S235294AbjAETGY (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 5 Jan 2023 14:06:24 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:39034 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S235437AbjAETGX (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 5 Jan 2023 14:06:23 -0500
Received: from pandora.armlinux.org.uk (pandora.armlinux.org.uk [IPv6:2001:4d48:ad52:32c8:5054:ff:fe00:142])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 49D4311B;
        Thu,  5 Jan 2023 11:06:22 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
        d=armlinux.org.uk; s=pandora-2019; h=Sender:In-Reply-To:Content-Type:
        MIME-Version:References:Message-ID:Subject:Cc:To:From:Date:Reply-To:
        Content-Transfer-Encoding:Content-ID:Content-Description:Resent-Date:
        Resent-From:Resent-Sender:Resent-To:Resent-Cc:Resent-Message-ID:List-Id:
        List-Help:List-Unsubscribe:List-Subscribe:List-Post:List-Owner:List-Archive;
        bh=ixGY7io/rE5K6EAUf3CTJ6PelTCXFqcbJYe+h11qlvs=; b=HX8w/kUto03BZlvL5JJrZfMEVo
        PW0Hpcy/xdauC8tMOg2C9pcBM1XxQDdf5CWRQhrEn0o9q6NY9CYhWHH17IuOyQSROIs76ZgDCt0TI
        vOPnL5BUXO4XqtS4Y8SzLqz6gUtzgvXTHmTZV7pjOGL8JiNgmuNjJAwr26iRbqRWD96mDGa7GQMes
        tSlmJs52ReE8yfjCP4bd+hysHn5WRTUbkyjPvNNetEH97zvalJHE1nJMj0zH251DNjzlfSLvAincy
        GvppPWra6aXfhu19vCQgZsSy7qCnI4U0PX/cZEoCXQX5WCQbjui2qAoWBgnBWYm5mXtLCgLEYVgtp
        rxjRwVeA==;
Received: from shell.armlinux.org.uk ([fd8f:7570:feb6:1:5054:ff:fe00:4ec]:35992)
        by pandora.armlinux.org.uk with esmtpsa  (TLS1.3) tls TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384
        (Exim 4.94.2)
        (envelope-from <linux@armlinux.org.uk>)
        id 1pDVZD-0007TX-Ou; Thu, 05 Jan 2023 19:06:19 +0000
Received: from linux by shell.armlinux.org.uk with local (Exim 4.94.2)
        (envelope-from <linux@shell.armlinux.org.uk>)
        id 1pDVZB-0004DV-VE; Thu, 05 Jan 2023 19:06:17 +0000
Date:   Thu, 5 Jan 2023 19:06:17 +0000
From:   "Russell King (Oracle)" <linux@armlinux.org.uk>
To:     Sean Anderson <sean.anderson@seco.com>
Cc:     Vladimir Oltean <olteanv@gmail.com>, Andrew Lunn <andrew@lunn.ch>,
        Heiner Kallweit <hkallweit1@gmail.com>, netdev@vger.kernel.org,
        "David S . Miller" <davem@davemloft.net>,
        Paolo Abeni <pabeni@redhat.com>, linux-kernel@vger.kernel.org,
        Jakub Kicinski <kuba@kernel.org>,
        Eric Dumazet <edumazet@google.com>,
        Tim Harvey <tharvey@gateworks.com>
Subject: Re: [PATCH net-next v5 4/4] phy: aquantia: Determine rate adaptation
 support from registers
Message-ID: <Y7cfqdVzrCNX6VqE@shell.armlinux.org.uk>
References: <20230103220511.3378316-1-sean.anderson@seco.com>
 <20230103220511.3378316-5-sean.anderson@seco.com>
 <20230105140421.bqd2aed6du5mtxn4@skbuf>
 <6ffe6719-648c-36aa-74be-467c8db40531@seco.com>
 <20230105173445.72rvdt4etvteageq@skbuf>
 <3919acb9-04bb-0ca0-07b9-45e96c4dad10@seco.com>
 <20230105175206.h3nmvccnzml2xa5d@skbuf>
 <Y7cdMyxap2hdPTec@shell.armlinux.org.uk>
 <18453c4e-484d-5131-36fe-77d3e55d6ac7@seco.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <18453c4e-484d-5131-36fe-77d3e55d6ac7@seco.com>
Sender: Russell King (Oracle) <linux@armlinux.org.uk>
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,SPF_HELO_NONE,SPF_NONE
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Thu, Jan 05, 2023 at 01:59:27PM -0500, Sean Anderson wrote:
> On 1/5/23 13:55, Russell King (Oracle) wrote:
> > On Thu, Jan 05, 2023 at 07:52:06PM +0200, Vladimir Oltean wrote:
> >> On Thu, Jan 05, 2023 at 12:43:47PM -0500, Sean Anderson wrote:
> >> > Again, this is to comply with the existing API assumptions. The current
> >> > code is buggy. Of course, another way around this is to modify the API.
> >> > I have chosen this route because I don't have a situation like you
> >> > described. But if support for that is important to you, I encourage you
> >> > to refactor things.
> >> 
> >> I don't think I'm aware of a practical situation like that either.
> >> I remember seeing some S32G boards with Aquantia PHYs which use 2500BASE-X
> >> for 2.5G and SGMII for <=1G, but that's about it in terms of protocol switching.
> > 
> > 88x3310 can dynamically switch between 10GBASE-R, 5GBASE-R, 2500BASE-X
> > and SGMII if rate adaption is not being used (and the rate adaption
> > method it supports in non-MACSEC PHYs is only via increasing the IPG on
> > the MAC... which currently no MAC driver supports.)
> > 
> 
> As an aside, do you know of any MACs which support open-loop rate
> matching to below ~95% of the line rate (the amount necessary for
> 10GBASE-W)?

I'm afraid I haven't paid too much attention to BASE-W, and I'm not
aware of anything within the realms of phylink/phylib supporting MAC
drivers having anything for it. I don't even remember mention of it
in any SoC datasheets.

Are you aware of a 10GBASE-W setup?

-- 
RMK's Patch system: https://www.armlinux.org.uk/developer/patches/
FTTP is here! 40Mbps down 10Mbps up. Decent connectivity at last!
