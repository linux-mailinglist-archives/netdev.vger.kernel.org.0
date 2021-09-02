Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 538D03FEEA2
	for <lists+netdev@lfdr.de>; Thu,  2 Sep 2021 15:26:49 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234416AbhIBN1m (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 2 Sep 2021 09:27:42 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:33942 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S234277AbhIBN1k (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 2 Sep 2021 09:27:40 -0400
Received: from pandora.armlinux.org.uk (pandora.armlinux.org.uk [IPv6:2001:4d48:ad52:32c8:5054:ff:fe00:142])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 2C91AC061575;
        Thu,  2 Sep 2021 06:26:41 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
        d=armlinux.org.uk; s=pandora-2019; h=Sender:In-Reply-To:Content-Type:
        MIME-Version:References:Message-ID:Subject:Cc:To:From:Date:Reply-To:
        Content-Transfer-Encoding:Content-ID:Content-Description:Resent-Date:
        Resent-From:Resent-Sender:Resent-To:Resent-Cc:Resent-Message-ID:List-Id:
        List-Help:List-Unsubscribe:List-Subscribe:List-Post:List-Owner:List-Archive;
         bh=tJw4vBFLbw26+n1iOurtCAPTzn5rxnS3DNMi7TNfPu4=; b=oIGip4OBLINXP3hGDVMrz4UNy
        sRLEzFetWGuINThhg/NMbm5BAWE+uQtRcc8rjJK5CWA59kG3Ku2J/uvwA1YYaHh7jNyLIbhY80sFI
        hsDuIkP63vfNDjrbbiombOov7fiGH9OK2rhRzSQezYv2W2IIppiQ+EXztGrCBttvvJsZV24RX8kpk
        2ib6T1cYQnuJFbh7j+qhuWb5uFlEPymImOimpGjibhCpSANyt/g55tegIEhhUiNzqqUEmTn0a5AJM
        6auJjQEUIG2JhhuT5eae/lgVd9FpWFSmDF9BBCwz+f7EVuwOFY6cGvEWMjIUlALsAwXZnlUN5W+E+
        skq7igmmw==;
Received: from shell.armlinux.org.uk ([fd8f:7570:feb6:1:5054:ff:fe00:4ec]:48090)
        by pandora.armlinux.org.uk with esmtpsa (TLS1.3:ECDHE_RSA_AES_256_GCM_SHA384:256)
        (Exim 4.92)
        (envelope-from <linux@armlinux.org.uk>)
        id 1mLmjm-0001Tp-KB; Thu, 02 Sep 2021 14:26:38 +0100
Received: from linux by shell.armlinux.org.uk with local (Exim 4.92)
        (envelope-from <linux@shell.armlinux.org.uk>)
        id 1mLmjj-0007rI-PN; Thu, 02 Sep 2021 14:26:35 +0100
Date:   Thu, 2 Sep 2021 14:26:35 +0100
From:   "Russell King (Oracle)" <linux@armlinux.org.uk>
To:     Vladimir Oltean <olteanv@gmail.com>
Cc:     Vladimir Oltean <vladimir.oltean@nxp.com>, netdev@vger.kernel.org,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        "Rafael J. Wysocki" <rafael@kernel.org>,
        Andrew Lunn <andrew@lunn.ch>,
        Heiner Kallweit <hkallweit1@gmail.com>,
        "David S. Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>,
        Vivien Didelot <vivien.didelot@gmail.com>,
        Florian Fainelli <f.fainelli@gmail.com>,
        linux-kernel@vger.kernel.org,
        Linus Walleij <linus.walleij@linaro.org>,
        Alvin =?utf-8?Q?=C5=A0ipraga?= <alsi@bang-olufsen.dk>,
        ACPI Devel Maling List <linux-acpi@vger.kernel.org>,
        kernel-team <kernel-team@android.com>,
        Len Brown <lenb@kernel.org>
Subject: Re: [RFC PATCH net-next 0/3] Make the PHY library stop being so
 greedy when binding the generic PHY driver
Message-ID: <20210902132635.GG22278@shell.armlinux.org.uk>
References: <20210901225053.1205571-1-vladimir.oltean@nxp.com>
 <20210902121927.GE22278@shell.armlinux.org.uk>
 <20210902123532.ruvuecxoig67yv5v@skbuf>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20210902123532.ruvuecxoig67yv5v@skbuf>
User-Agent: Mutt/1.10.1 (2018-07-13)
Sender: Russell King (Oracle) <linux@armlinux.org.uk>
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Thu, Sep 02, 2021 at 03:35:32PM +0300, Vladimir Oltean wrote:
> On Thu, Sep 02, 2021 at 01:19:27PM +0100, Russell King (Oracle) wrote:
> > On Thu, Sep 02, 2021 at 01:50:50AM +0300, Vladimir Oltean wrote:
> > > The central point of that discussion is that DSA seems "broken" for
> > > expecting the PHY driver to probe immediately on PHYs belonging to the
> > > internal MDIO buses of switches. A few suggestions were made about what
> > > to do, but some were not satisfactory and some did not solve the problem.
> > 
> > I think you need to describe the mechanism here. Why wouldn't a PHY
> > belonging to an internal MDIO bus of a switch not probe immediately?
> > What resources may not be available?
> 
> As you point out below, the interrupt-controller is what is not available.
> There is a mechanism called fw_devlink which infers links from one OF
> node to another based on phandles. When you have an interrupt-parent,
> that OF node becomes a supplier to you. Those OF node links are then
> transferred to device links once the devices having those OF nodes are
> created.
> 
> > If we have a DSA driver that tries to probe the PHYs before e.g. the
> > interrupt controller inside the DSA switch has been configured, aren't
> > we just making completely unnecessary problems for ourselves?
> 
> This is not what happens, if that were the case, of course I would fix
> _that_ and not in this way.
> 
> > Wouldn't it be saner to ensure that the interrupt controller has been
> > setup and become available prior to attempting to setup anything that
> > relies upon that interrupt controller?
> 
> The interrupt controller _has_ been set up. The trouble is that the
> interrupt controller has the same OF node as the switch itself, and the
> same OF node. Therefore, fw_devlink waits for the _entire_ switch to
> finish probing, it doesn't have insight into the fact that the
> dependency is just on the interrupt controller.
> 
> > From what I see of Marvell switches, the internal PHYs only ever rely
> > on internal resources of the switch they are embedded in.
> > 
> > External PHYs to the switch are a different matter - these can rely on
> > external clocks, and in that scenario, it would make sense for a
> > deferred probe to cause the entire switch to defer, since we don't
> > have all the resources for the switch to be functional (and, because we
> > want the PHYs to be present at switch probe time, not when we try to
> > bring up the interface, I don't see there's much other choice.)
> > 
> > Trying to move that to interface-up time /will/ break userspace - for
> > example, Debian's interfaces(8) bridge support will become unreliable,
> > and probably a whole host of other userspace. It will cause regressions
> > and instability to userspace. So that's a big no.
> 
> Why a big no?

Fundamental rule of kernel programming: we do not break existing
userspace.

Debian has had support for configuring bridges at boot time via
the interfaces file for years. Breaking that is going to upset a
lot of people (me included) resulting in busted networks. It
would be a sure way to make oneself unpopular.

> I expect there to be 2 call paths of phy_attach_direct:
> - At probe time. Both the MAC driver and the PHY driver are probing.
>   This is what has this patch addresses. There is no issue to return
>   -EPROBE_DEFER at that time, since drivers connect to the PHY before
>   they register their netdev. So if connecting defers, there is no
>   netdev to unregister, and user space knows nothing of this.
> - At .ndo_open time. This is where it maybe gets interesting, but not to
>   user space. If you open a netdev and it connects to the PHY then, I
>   wouldn't expect the PHY to be undergoing a probing process, all of
>   that should have been settled by then, should it not? Where it might
>   get interesting is with NFS root, and I admit I haven't tested that.

I don't think you can make that assumption. Consider the case where
systemd is being used, DSA stuff is modular, and we're trying to
setup a bridge device on DSA. DSA could be probing while the bridge
is being setup.

Sadly, this isn't theoretical. I've ended up needing:

	pre-up sleep 1

in my bridge configuration to allow time for DSA to finish probing.
It's not a pleasant solution, nor a particularly reliable one at
that, but it currently works around the problem. We don't need more
cases of this kind of thing leading to boot time unreliability...

Or if we do, then we're turning Linux into Windows, where you can
end up with different behaviours each time the system is boot
depending on the exact order that various stuff comes up.

-- 
RMK's Patch system: https://www.armlinux.org.uk/developer/patches/
FTTP is here! 40Mbps down 10Mbps up. Decent connectivity at last!
