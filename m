Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 4EE8259A9FA
	for <lists+netdev@lfdr.de>; Sat, 20 Aug 2022 02:21:55 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S240630AbiHTAVD (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 19 Aug 2022 20:21:03 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:52590 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231538AbiHTAVB (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 19 Aug 2022 20:21:01 -0400
Received: from pandora.armlinux.org.uk (pandora.armlinux.org.uk [IPv6:2001:4d48:ad52:32c8:5054:ff:fe00:142])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 06D18B14F4;
        Fri, 19 Aug 2022 17:20:59 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
        d=armlinux.org.uk; s=pandora-2019; h=Sender:In-Reply-To:Content-Type:
        MIME-Version:References:Message-ID:Subject:Cc:To:From:Date:Reply-To:
        Content-Transfer-Encoding:Content-ID:Content-Description:Resent-Date:
        Resent-From:Resent-Sender:Resent-To:Resent-Cc:Resent-Message-ID:List-Id:
        List-Help:List-Unsubscribe:List-Subscribe:List-Post:List-Owner:List-Archive;
        bh=p7OaUEQxnRUEyVn0aBNy9OZOTgyHnlL4VWLHvQaahXM=; b=RRWtKMe+05MqjkFW+FovBB3SMH
        shWUY1f36odwXDlNIHlzNde128rW2IgkiOesPP3vpyKG9advF5qjnLNBPmiTNPVbi91j3//czsben
        8lHsLssoVdF/0o0RXaTQqBUGBbuCOflkHW0K8YLvtX9jKLG06ZyZb+MPSDXvNFBTb2MNWiYXxOehA
        FTLsyuiITxJz4m8wc7Pn86BvIn/gLiqDveAreH7Y42tykPNT5YyRYuJUghLRUZj8WxiTGPqw1p851
        Mwot/5rUygWaKcv1/8vA2is/2KUh3Mj4EqMlZFrQHH7hEffKq4m4mSPih2bonaQLdASIAmp+c7j2j
        R+8tZLCw==;
Received: from shell.armlinux.org.uk ([fd8f:7570:feb6:1:5054:ff:fe00:4ec]:33858)
        by pandora.armlinux.org.uk with esmtpsa  (TLS1.3) tls TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384
        (Exim 4.94.2)
        (envelope-from <linux@armlinux.org.uk>)
        id 1oPCER-0008Hl-7k; Sat, 20 Aug 2022 01:20:55 +0100
Received: from linux by shell.armlinux.org.uk with local (Exim 4.94.2)
        (envelope-from <linux@shell.armlinux.org.uk>)
        id 1oPCEN-0008EM-NC; Sat, 20 Aug 2022 01:20:51 +0100
Date:   Sat, 20 Aug 2022 01:20:51 +0100
From:   "Russell King (Oracle)" <linux@armlinux.org.uk>
To:     Jakub Kicinski <kuba@kernel.org>
Cc:     Sean Anderson <sean.anderson@seco.com>,
        Andrew Lunn <andrew@lunn.ch>,
        Heiner Kallweit <hkallweit1@gmail.com>, netdev@vger.kernel.org,
        Paolo Abeni <pabeni@redhat.com>,
        "David S . Miller" <davem@davemloft.net>,
        linux-kernel@vger.kernel.org, Eric Dumazet <edumazet@google.com>,
        Vladimir Oltean <olteanv@gmail.com>
Subject: Re: [PATCH net] net: phy: Warn if phy is attached when removing
Message-ID: <YwAo42QkTgD0kOqz@shell.armlinux.org.uk>
References: <20220816163701.1578850-1-sean.anderson@seco.com>
 <20220819164519.2c71823e@kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20220819164519.2c71823e@kernel.org>
Sender: Russell King (Oracle) <linux@armlinux.org.uk>
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,SPF_HELO_NONE,SPF_NONE,
        T_SCC_BODY_TEXT_LINE autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Fri, Aug 19, 2022 at 04:45:19PM -0700, Jakub Kicinski wrote:
> On Tue, 16 Aug 2022 12:37:01 -0400 Sean Anderson wrote:
> > netdevs using phylib can be oopsed from userspace in the following
> > manner:
> > 
> > $ ip link set $iface up
> > $ echo $(basename $(readlink /sys/class/net/$iface/phydev)) > \
> >       /sys/class/net/$iface/phydev/driver/unbind
> > $ ip link set $iface down
> > 
> > However, the traceback provided is a bit too late, since it does not
> > capture the root of the problem (unbinding the driver). It's also
> > possible that the memory has been reallocated if sufficient time passes
> > between when the phy is detached and when the netdev touches the phy
> > (which could result in silent memory corruption). Add a warning at the
> > source of the problem. A future patch could make this more robust by
> > calling dev_close.
> 
> FWIW, I think DaveM marked this patch as changes requested.
> 
> I don't really know enough to have an opinion.
> 
> PHY maintainers, anyone willing to cast a vote?

I don't think Linus is a fan of using WARN_ON() as an assert()
replacement, which this feels very much like that kind of thing.
I don't see much point in using WARN_ON() here as we'll soon get
a kernel oops anyway, and the backtrace WARN_ON() will produce isn't
useful - it'll be just noise.

So, I'd tone it down to something like:

	if (phydev->attached_dev)
		phydev_err(phydev, "Removing in-use PHY, expect an oops");

Maybe even introduce phydev_crit() just for this message.

Since we have bazillions of network drivers that hold a reference to
the phydev, I don't think we can do much better than this for phylib.
It would be a massive effort to go through all the network drivers
and try to work out how to fix them.


Addressing the PCS part of the patch posting and unrelated to what we
do for phylib...

However, I don't see "we'll do this for phylib, so we can do it for
PCS as well" as much of a sane argument - we don't have bazillions
of network drivers to fix to make this work for PCS. We currently
have no removable PCS (they don't appear with a driver so aren't
even bound to anything.) So we should add the appropriate handling
when we start to do this.

Phylink has the capability to take the link down when something goes
away, and if the PCS goes away, that's exactly what should happen,
rather than oopsing the kernel.

As MAC drivers hold a reference to the PCS instances, as they need to
select the appropriate one, how do MAC drivers get to know that the
PCS has gone away to drop their reference - and tell phylink that the
PCS has gone. That's the problem that needs solving to allow PCS to
be unbound if we're going to make them first class citizens of the
driver model.

I am no fan of "but XYZ doesn't care about it, so why should we care"
arguments. If I remember correctly, phylib pre-dates the device model,
and had the device model retrofitted, so it was a best-efforts
attempt - and suffered back then with the same problem of needing
lots of drivers to be changed in non-trivial ways.

We have the chance here to come up with something better - and I think
that chance should be used to full effect.

-- 
RMK's Patch system: https://www.armlinux.org.uk/developer/patches/
FTTP is here! 40Mbps down 10Mbps up. Decent connectivity at last!
