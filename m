Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 64EA845A734
	for <lists+netdev@lfdr.de>; Tue, 23 Nov 2021 17:08:36 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S238725AbhKWQLi (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 23 Nov 2021 11:11:38 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:57818 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S238733AbhKWQLf (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 23 Nov 2021 11:11:35 -0500
Received: from pandora.armlinux.org.uk (pandora.armlinux.org.uk [IPv6:2001:4d48:ad52:32c8:5054:ff:fe00:142])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id B04DBC061714
        for <netdev@vger.kernel.org>; Tue, 23 Nov 2021 08:08:26 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
        d=armlinux.org.uk; s=pandora-2019; h=Sender:In-Reply-To:Content-Type:
        MIME-Version:References:Message-ID:Subject:Cc:To:From:Date:Reply-To:
        Content-Transfer-Encoding:Content-ID:Content-Description:Resent-Date:
        Resent-From:Resent-Sender:Resent-To:Resent-Cc:Resent-Message-ID:List-Id:
        List-Help:List-Unsubscribe:List-Subscribe:List-Post:List-Owner:List-Archive;
        bh=twcwpuMueGYyjGyqVQIkI89HletvDrqkckGMX3j3kIw=; b=iSfGjINe0V3k78UXkOxUHZBKn/
        I5KMYPNvZ+XSkR3plj9wNhEcrxOnuSy3ocukDF2A/+62bpUHmvgohUf7McVxWz6jdrYve+wLs396G
        F7lXYnKuNmWEJqmwfWRixLG4tDhkc++Xtosa3RkVRD0ZTltazFNEPttsCI+b/PxIdEvCOTgRdHEzQ
        skYandIT9Ewys+gFfFOHNXB08ecmQSKF+h1ZTVVbjyrQwUsvf5N3Aa5cY0tA0S+mkOL4yrWySQ7J1
        QNzUVWukITuBCNXANwHo0uskRWBMAjNQ7eK8nUNTFckfzep/U0G2QQelpJEXrUJtYvpVmvFqevzr8
        oeH2UhlA==;
Received: from shell.armlinux.org.uk ([fd8f:7570:feb6:1:5054:ff:fe00:4ec]:55820)
        by pandora.armlinux.org.uk with esmtpsa  (TLS1.3) tls TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384
        (Exim 4.94.2)
        (envelope-from <linux@armlinux.org.uk>)
        id 1mpYL7-000867-S2; Tue, 23 Nov 2021 16:08:13 +0000
Received: from linux by shell.armlinux.org.uk with local (Exim 4.94.2)
        (envelope-from <linux@shell.armlinux.org.uk>)
        id 1mpYL3-0000LS-8c; Tue, 23 Nov 2021 16:08:09 +0000
Date:   Tue, 23 Nov 2021 16:08:09 +0000
From:   "Russell King (Oracle)" <linux@armlinux.org.uk>
To:     Vladimir Oltean <olteanv@gmail.com>,
        Sean Anderson <sean.anderson@seco.com>
Cc:     Chris Snook <chris.snook@gmail.com>, Felix Fietkau <nbd@nbd.name>,
        Florian Fainelli <f.fainelli@gmail.com>,
        John Crispin <john@phrozen.org>,
        Mark Lee <Mark-MC.Lee@mediatek.com>,
        Matthias Brugger <matthias.bgg@gmail.com>,
        Michal Simek <michal.simek@xilinx.com>,
        Radhey Shyam Pandey <radhey.shyam.pandey@xilinx.com>,
        Sean Wang <sean.wang@mediatek.com>,
        Vivien Didelot <vivien.didelot@gmail.com>,
        Andrew Lunn <andrew@lunn.ch>,
        "David S. Miller" <davem@davemloft.net>,
        Heiner Kallweit <hkallweit1@gmail.com>,
        Jakub Kicinski <kuba@kernel.org>,
        linux-arm-kernel@lists.infradead.org,
        linux-mediatek@lists.infradead.org, netdev@vger.kernel.org
Subject: Re: [PATCH RFC net-next 8/8] net: phylink: allow PCS to be removed
Message-ID: <YZ0R6T33DNTW80SU@shell.armlinux.org.uk>
References: <YZy59OTNCpKoPZT/@shell.armlinux.org.uk>
 <E1mpSba-00BXp6-9e@rmk-PC.armlinux.org.uk>
 <20211123120825.jvuh7444wdxzugbo@skbuf>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20211123120825.jvuh7444wdxzugbo@skbuf>
Sender: Russell King (Oracle) <linux@armlinux.org.uk>
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Tue, Nov 23, 2021 at 02:08:25PM +0200, Vladimir Oltean wrote:
> On Tue, Nov 23, 2021 at 10:00:50AM +0000, Russell King (Oracle) wrote:
> > Allow phylink_set_pcs() to be called with a NULL pcs argument to remove
> > the PCS from phylink. This is only supported on non-legacy drivers
> > where doing so will have no effect on the mac_config() calling
> > behaviour.
> > 
> > Signed-off-by: Russell King (Oracle) <rmk+kernel@armlinux.org.uk>
> > ---
> >  drivers/net/phy/phylink.c | 20 +++++++++++++++-----
> >  1 file changed, 15 insertions(+), 5 deletions(-)
> > 
> > diff --git a/drivers/net/phy/phylink.c b/drivers/net/phy/phylink.c
> > index a935655c39c0..9f0f0e0aad55 100644
> > --- a/drivers/net/phy/phylink.c
> > +++ b/drivers/net/phy/phylink.c
> > @@ -1196,15 +1196,25 @@ EXPORT_SYMBOL_GPL(phylink_create);
> >   * in mac_prepare() or mac_config() methods if it is desired to dynamically
> >   * change the PCS.
> >   *
> > - * Please note that there are behavioural changes with the mac_config()
> > - * callback if a PCS is present (denoting a newer setup) so removing a PCS
> > - * is not supported, and if a PCS is going to be used, it must be registered
> > - * by calling phylink_set_pcs() at the latest in the first mac_config() call.
> > + * Please note that for legacy phylink users, there are behavioural changes
> > + * with the mac_config() callback if a PCS is present (denoting a newer setup)
> > + * so removing a PCS is not supported. If a PCS is going to be used, it must
> > + * be registered by calling phylink_set_pcs() at the latest in the first
> > + * mac_config() call.
> > + *
> > + * For modern drivers, this may be called with a NULL pcs argument to
> > + * disconnect the PCS from phylink.
> >   */
> >  void phylink_set_pcs(struct phylink *pl, struct phylink_pcs *pcs)
> >  {
> > +	if (pl->config->legacy_pre_march2020 && pl->pcs && !pcs) {
> > +		phylink_warn(pl,
> > +			     "Removing PCS is not supported in a legacy driver");
> > +		return;
> > +	}
> > +
> >  	pl->pcs = pcs;
> > -	pl->pcs_ops = pcs->ops;
> > +	pl->pcs_ops = pcs ? pcs->ops : NULL;
> >  }
> >  EXPORT_SYMBOL_GPL(phylink_set_pcs);
> >  
> > -- 
> > 2.30.2
> > 
> 
> I've read the discussion at
> https://lore.kernel.org/netdev/cfcb368f-a785-9ea5-c446-1906eacd8c03@seco.com/
> and I still am not sure that I understand what is the use case behind
> removing a PCS?

Passing that to Sean to answer in detail...

-- 
RMK's Patch system: https://www.armlinux.org.uk/developer/patches/
FTTP is here! 40Mbps down 10Mbps up. Decent connectivity at last!
