Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 2885B46BD86
	for <lists+netdev@lfdr.de>; Tue,  7 Dec 2021 15:23:30 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S237750AbhLGO04 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 7 Dec 2021 09:26:56 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:42962 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233131AbhLGO0z (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 7 Dec 2021 09:26:55 -0500
Received: from pandora.armlinux.org.uk (pandora.armlinux.org.uk [IPv6:2001:4d48:ad52:32c8:5054:ff:fe00:142])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 17365C061574
        for <netdev@vger.kernel.org>; Tue,  7 Dec 2021 06:23:25 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
        d=armlinux.org.uk; s=pandora-2019; h=Sender:In-Reply-To:
        Content-Transfer-Encoding:Content-Type:MIME-Version:References:Message-ID:
        Subject:Cc:To:From:Date:Reply-To:Content-ID:Content-Description:Resent-Date:
        Resent-From:Resent-Sender:Resent-To:Resent-Cc:Resent-Message-ID:List-Id:
        List-Help:List-Unsubscribe:List-Subscribe:List-Post:List-Owner:List-Archive;
        bh=mYSOs2QHlV2e7sseWcPjuTwRw8Gvwlhd1h/Kt9Qur5Q=; b=qK8yAUqUI/5rIP3rR9LJf2vYze
        Mseyv2CkoUs123jXqUWap1urgoWHKI1k51kMCmJwFzY1T5aXPrgE26Dmkbqjp9g1r2GWRfStFcwup
        hLJB8VY5xF1KTM/qJIX/ftaV47YWUWt3x0hZR1Qyu9wFAG5jB1j1DHtBmIEbmRuleP5tKep0XQGX4
        gIkTdfcWBeS2LwzMWFVqRESPj1mDzfhrReEnLp5y72b/KRaqdmb03bFjPMEPtRErAEPwbLubVPPPZ
        I0af4hX7kh1pk0ksqq0ib/Vh6ToKcCFDgPueu66mbvU3U2zKUHCQIbLDa6ImKDWknpH5Zx5lEUvSh
        J24dm+dg==;
Received: from shell.armlinux.org.uk ([fd8f:7570:feb6:1:5054:ff:fe00:4ec]:56158)
        by pandora.armlinux.org.uk with esmtpsa  (TLS1.3) tls TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384
        (Exim 4.94.2)
        (envelope-from <linux@armlinux.org.uk>)
        id 1mubNJ-0006IX-8G; Tue, 07 Dec 2021 14:23:21 +0000
Received: from linux by shell.armlinux.org.uk with local (Exim 4.94.2)
        (envelope-from <linux@shell.armlinux.org.uk>)
        id 1mubNH-0005P7-CB; Tue, 07 Dec 2021 14:23:19 +0000
Date:   Tue, 7 Dec 2021 14:23:19 +0000
From:   "Russell King (Oracle)" <linux@armlinux.org.uk>
To:     Martyn Welch <martyn.welch@collabora.com>
Cc:     Andrew Lunn <andrew@lunn.ch>,
        Vivien Didelot <vivien.didelot@gmail.com>,
        Florian Fainelli <f.fainelli@gmail.com>,
        Vladimir Oltean <olteanv@gmail.com>,
        "David S. Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>, netdev@vger.kernel.org
Subject: Re: [PATCH RFC net] net: dsa: mv88e6xxx: allow use of PHYs on CPU
 and DSA ports
Message-ID: <Ya9uV+UVx1ymLg2E@shell.armlinux.org.uk>
References: <E1muYBr-00EwOF-9C@rmk-PC.armlinux.org.uk>
 <aa5e48e4b03eb9fd8eb6dacb439ef8e600245774.camel@collabora.com>
 <Ya9abXJELHCaBE0k@shell.armlinux.org.uk>
 <aa773849b84297679f4eb4b3743518856ca5b71a.camel@collabora.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <aa773849b84297679f4eb4b3743518856ca5b71a.camel@collabora.com>
Sender: Russell King (Oracle) <linux@armlinux.org.uk>
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Tue, Dec 07, 2021 at 02:20:28PM +0000, Martyn Welch wrote:
> On Tue, 2021-12-07 at 12:58 +0000, Russell King (Oracle) wrote:
> > On Tue, Dec 07, 2021 at 12:47:35PM +0000, Martyn Welch wrote:
> > > Sorry Russell, but unfortunately this patch doesn't seem to be
> > > resolving the issue for me.
> > > 
> > > I've dumped in a bit of debug around this change to see if I could
> > > determine what was going on here, it seems that in my case the
> > > function
> > > is being exited before this at:
> > > 
> > > /* FIXME: is this the correct test? If we're in fixed mode on an
> > >  * internal port, why should we process this any different from
> > >  * PHY mode? On the other hand, the port may be automedia between
> > >  * an internal PHY and the serdes...
> > >  */
> > > if ((mode == MLO_AN_PHY) && mv88e6xxx_phy_is_internal(ds, port))
> > >         return;
> > 
> > Oh, I was going to remove that, but clearly forgot, sorry. Please can
> > you try again with that removed? Meanwhile, I'll update the patch at
> > my end.
> > 
> 
> Yes! That makes it work for me.
> 
> To be clear, the additional change I made was:
> 
> 
> diff --git a/drivers/net/dsa/mv88e6xxx/chip.c
> b/drivers/net/dsa/mv88e6xxx/chip.c
> index b033e653d3f4..14f87f6ac479 100644
> --- a/drivers/net/dsa/mv88e6xxx/chip.c
> +++ b/drivers/net/dsa/mv88e6xxx/chip.c
> @@ -702,14 +702,6 @@ static void mv88e6xxx_mac_config(struct dsa_switch
> *ds, int port,
>  
>         p = &chip->ports[port];
>  
> -       /* FIXME: is this the correct test? If we're in fixed mode on
> an
> -        * internal port, why should we process this any different from
> -        * PHY mode? On the other hand, the port may be automedia
> between
> -        * an internal PHY and the serdes...
> -        */
> -       if ((mode == MLO_AN_PHY) && mv88e6xxx_phy_is_internal(ds,
> port))
> -               return;
> -
>         mv88e6xxx_reg_lock(chip);
>  
>         if (mode != MLO_AN_PHY || !mv88e6xxx_phy_is_internal(ds, port))
> {
> 
> 
> Assuming that's also what you've done:

That is exactly right, indeed, thanks!

> Tested-by: Martyn Welch <martyn.welch@collabora.com>
> 
> Thanks for your help!

Thanks for testing. I'll wait a little while in case there's any
further comments.

-- 
RMK's Patch system: https://www.armlinux.org.uk/developer/patches/
FTTP is here! 40Mbps down 10Mbps up. Decent connectivity at last!
