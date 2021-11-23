Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 87DC945A50B
	for <lists+netdev@lfdr.de>; Tue, 23 Nov 2021 15:14:24 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S237929AbhKWORb (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 23 Nov 2021 09:17:31 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:59440 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S237691AbhKWOR2 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 23 Nov 2021 09:17:28 -0500
Received: from pandora.armlinux.org.uk (pandora.armlinux.org.uk [IPv6:2001:4d48:ad52:32c8:5054:ff:fe00:142])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 850D8C061574
        for <netdev@vger.kernel.org>; Tue, 23 Nov 2021 06:14:20 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
        d=armlinux.org.uk; s=pandora-2019; h=Sender:In-Reply-To:Content-Type:
        MIME-Version:References:Message-ID:Subject:Cc:To:From:Date:Reply-To:
        Content-Transfer-Encoding:Content-ID:Content-Description:Resent-Date:
        Resent-From:Resent-Sender:Resent-To:Resent-Cc:Resent-Message-ID:List-Id:
        List-Help:List-Unsubscribe:List-Subscribe:List-Post:List-Owner:List-Archive;
        bh=kIC57tIQMC2RpVaL43xrefZcm7pKvNmxBibV1FxsXp8=; b=hOG/fqZuMFEztqDPQDHE8Df/6G
        WIoGHQnj7XoEKQ3+W8Imyi4KUhUUfgx3MSFRS/MmnOu9I42ENye9uphaIaSWq07y7iehmfSckJN4o
        EsP2mT2H98atr9gcad8lEH6Rke0SLOYPIHpHGTdnvvrcqxDtvktszqqZRRbO8XrrGQ9xWMIAvz5xw
        Nl3glakaOmFTEUXksv9ho/xRLzFkb+dd+ypnlb7zlkD4ltMSNHI/+ZI3JGRs5AWyOMC7gwCgTaQ3z
        qqsA3pSGPrcaNfKDenJOEE51vAzO7Q7MJyXKyzm4OX73qfv21zYmUjwSQnw0d2JjzInMVoti70XJt
        QBiFyotA==;
Received: from shell.armlinux.org.uk ([fd8f:7570:feb6:1:5054:ff:fe00:4ec]:55818)
        by pandora.armlinux.org.uk with esmtpsa  (TLS1.3) tls TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384
        (Exim 4.94.2)
        (envelope-from <linux@armlinux.org.uk>)
        id 1mpWYr-0007zk-TU; Tue, 23 Nov 2021 14:14:17 +0000
Received: from linux by shell.armlinux.org.uk with local (Exim 4.94.2)
        (envelope-from <linux@shell.armlinux.org.uk>)
        id 1mpWYq-0000Hh-Bv; Tue, 23 Nov 2021 14:14:16 +0000
Date:   Tue, 23 Nov 2021 14:14:16 +0000
From:   "Russell King (Oracle)" <linux@armlinux.org.uk>
To:     Andrew Lunn <andrew@lunn.ch>
Cc:     Alessandro B Maurici <abmaurici@gmail.com>, netdev@vger.kernel.org,
        Heiner Kallweit <hkallweit1@gmail.com>,
        "David S. Miller" <davem@davemloft.net>
Subject: Re: [PATCH] phy: fix possible double lock calling link changed
 handler
Message-ID: <YZz3OLKFvsMgqdGD@shell.armlinux.org.uk>
References: <20211122235548.38b3fc7c@work>
 <YZxrhhm0YdfoJcAu@lunn.ch>
 <20211123014946.1ec2d7ee@work>
 <YZz2AJ+wqasknw2p@lunn.ch>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <YZz2AJ+wqasknw2p@lunn.ch>
Sender: Russell King (Oracle) <linux@armlinux.org.uk>
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Tue, Nov 23, 2021 at 03:09:04PM +0100, Andrew Lunn wrote:
> On Tue, Nov 23, 2021 at 01:49:46AM -0300, Alessandro B Maurici wrote:
> > On Tue, 23 Nov 2021 05:18:14 +0100
> > Andrew Lunn <andrew@lunn.ch> wrote:
> > 
> > > On Mon, Nov 22, 2021 at 11:55:48PM -0300, Alessandro B Maurici wrote:
> > > > From: Alessandro B Maurici <abmaurici@gmail.com>
> > > > 
> > > > Releases the phy lock before calling phy_link_change to avoid any worker
> > > > thread lockup. Some network drivers(eg Microchip's LAN743x), make a call to
> > > > phy_ethtool_get_link_ksettings inside the link change handler  
> > > 
> > > I think we need to take a step back here and answer the question, why
> > > does it call phy_ethtool_get_link_ksettings in the link change
> > > handler. I'm not aware of any other MAC driver which does this.
> > > 
> > > 	 Andrew
> > 
> > I agree, the use in the lan743x seems related to the PTP, that driver seems
> > to be the only one using it, at least in the Linus tree. 
> > I think that driver could be patched as there are other ways to do it,
> > but my take on the problem itself is that the PHY device interface opens
> > a way to break the flow and this behavior does not seem to be documented,
> > so, instead of documenting a possible harmful interface while in the callback,
> > we should just get rid of the problem itself, and calling a callback without
> > any locks held seems to be a good alternative.
> 
> That is a really bad alternative. It is only because the lock is held
> can the MAC driver actually trust anything passed to it. The callback
> needs phydev->speed, phydev->duplex, etc, and they can change at any
> time when the lock is not held. The values can be inconsistent with
> each other, etc, unless the lock is held.
> 
> The callback has always had the lock held, so is safe. However,
> recently a few bugs have been reported and fixed for functions like
> phy_ethtool_get_link_ksettings() and phy_ethtool_set_link_ksettings()
> where they have accessed phydev members without the lock and got
> inconsistent values in race condition. These are hard race conditions
> to reproduce, but a deadlock like this is very obvious, easy to fix. I
> would also say that _ethtool_ in the function name is also a good hit
> this is intended to be used for an ethtool callback.
> 
> Lets remove the inappropriate use of phy_ethtool_get_link_ksettings()
> here.

100% agreed.

-- 
RMK's Patch system: https://www.armlinux.org.uk/developer/patches/
FTTP is here! 40Mbps down 10Mbps up. Decent connectivity at last!
