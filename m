Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 3A12D1E8441
	for <lists+netdev@lfdr.de>; Fri, 29 May 2020 19:02:56 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726975AbgE2RCu (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 29 May 2020 13:02:50 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:36300 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1725901AbgE2RCt (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 29 May 2020 13:02:49 -0400
Received: from pandora.armlinux.org.uk (pandora.armlinux.org.uk [IPv6:2001:4d48:ad52:3201:214:fdff:fe10:1be6])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 28885C03E969;
        Fri, 29 May 2020 10:02:49 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
        d=armlinux.org.uk; s=pandora-2019; h=Sender:In-Reply-To:Content-Type:
        MIME-Version:References:Message-ID:Subject:Cc:To:From:Date:Reply-To:
        Content-Transfer-Encoding:Content-ID:Content-Description:Resent-Date:
        Resent-From:Resent-Sender:Resent-To:Resent-Cc:Resent-Message-ID:List-Id:
        List-Help:List-Unsubscribe:List-Subscribe:List-Post:List-Owner:List-Archive;
         bh=mhDj8HvcidDM2+LUzhZWd1zqzMi1le6gCrrrRI5wWpM=; b=ACBySssAVilxbgU9+MMEcT32M
        9yfm6lrdnfGorj13jbyFG13Lyv0nwSklV87aLz5tCCqLoDer0SEuyqsqsNhvW09tkgZSkdFXxxB7t
        U96KaD+V/6wblyqVi2s5Zk+AWmNkDZQF7yiDGm84w5jDI5lLipCmf/qkHumnXq3XtjNAKS3vMLH+F
        Feacewq09M50KjsLA1v163yTI3VzJQJjByd5BUQOVBuyMwV3xa64KpH82sJQNY4cHaEmjGEJgGWOu
        YFPWxOqCobonGuw5Cc0oT5gaXh15I3KfuO8mLQRJi+/DuZlwRTc0P7zg6xG9l64X14N+dl+xhegIg
        D0+Sco2Sw==;
Received: from shell.armlinux.org.uk ([fd8f:7570:feb6:1:5054:ff:fe00:4ec]:38622)
        by pandora.armlinux.org.uk with esmtpsa (TLSv1.2:ECDHE-RSA-AES256-GCM-SHA384:256)
        (Exim 4.90_1)
        (envelope-from <linux@armlinux.org.uk>)
        id 1jeiOz-0000NO-Q6; Fri, 29 May 2020 18:02:37 +0100
Received: from linux by shell.armlinux.org.uk with local (Exim 4.92)
        (envelope-from <linux@shell.armlinux.org.uk>)
        id 1jeiOu-0000Bv-2J; Fri, 29 May 2020 18:02:32 +0100
Date:   Fri, 29 May 2020 18:02:32 +0100
From:   Russell King - ARM Linux admin <linux@armlinux.org.uk>
To:     Andrew Lunn <andrew@lunn.ch>
Cc:     Thomas Bogendoerfer <tbogendoerfer@suse.de>,
        "David S. Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>, netdev@vger.kernel.org,
        linux-kernel@vger.kernel.org
Subject: Re: [PATCH net] net: mvpp2: Enable autoneg bypass for
 1000BaseX/2500BaseX ports
Message-ID: <20200529170231.GB1551@shell.armlinux.org.uk>
References: <20200528151733.f1bc2fcdcb312b19b2919be9@suse.de>
 <20200528135608.GU1551@shell.armlinux.org.uk>
 <20200528163335.8f730b5a3ddc8cd9beab367f@suse.de>
 <20200528144805.GW1551@shell.armlinux.org.uk>
 <20200528204312.df9089425162a22e89669cf1@suse.de>
 <20200528220420.GY1551@shell.armlinux.org.uk>
 <20200529130539.3fe944fed7228e2b061a1e46@suse.de>
 <20200529145928.GF869823@lunn.ch>
 <20200529155121.GA1551@shell.armlinux.org.uk>
 <20200529162504.GH869823@lunn.ch>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20200529162504.GH869823@lunn.ch>
User-Agent: Mutt/1.10.1 (2018-07-13)
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Fri, May 29, 2020 at 06:25:04PM +0200, Andrew Lunn wrote:
> > I wonder how much risk there is to changing that, so we force the link
> > down if phylink says the link should be down, otherwise we force the
> > speed/duplex, disable AN, and allow the link to come up depending on
> > the serdes status.  It /sounds/ like something sane to do.
> 
> Hi Russell
> 
> I actually did this for mv88e6xxx in a patchset for ZII devel B. It
> was determining link based on SFP LOS, which we know is unreliable. It
> said there was link even when the SERDES had lost link.
> 
> I did it by making use of the fixed-link state call back, since it was
> a quick and dirty patch. But it might make more sense for the MAC to
> call phylink_mac_change() for change in PCS state? Or add a PCS
> specific.

Correct.  In the early phylink versions, I did have sync state reported
from the PCS back to phylink, but as phylink didn't make use of it, I
removed it as it wasn't obvious how it should be used.

-- 
RMK's Patch system: https://www.armlinux.org.uk/developer/patches/
FTTC for 0.8m (est. 1762m) line in suburbia: sync at 13.1Mbps down 424kbps up
