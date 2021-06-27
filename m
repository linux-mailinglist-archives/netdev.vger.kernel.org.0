Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id A58583B54FC
	for <lists+netdev@lfdr.de>; Sun, 27 Jun 2021 21:09:27 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231410AbhF0TLr (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sun, 27 Jun 2021 15:11:47 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:35830 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231298AbhF0TLq (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sun, 27 Jun 2021 15:11:46 -0400
Received: from pandora.armlinux.org.uk (pandora.armlinux.org.uk [IPv6:2001:4d48:ad52:32c8:5054:ff:fe00:142])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id E27A7C061574
        for <netdev@vger.kernel.org>; Sun, 27 Jun 2021 12:09:20 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
        d=armlinux.org.uk; s=pandora-2019; h=Sender:In-Reply-To:Content-Type:
        MIME-Version:References:Message-ID:Subject:Cc:To:From:Date:Reply-To:
        Content-Transfer-Encoding:Content-ID:Content-Description:Resent-Date:
        Resent-From:Resent-Sender:Resent-To:Resent-Cc:Resent-Message-ID:List-Id:
        List-Help:List-Unsubscribe:List-Subscribe:List-Post:List-Owner:List-Archive;
         bh=5zpTy+eOeqgDk1er2L+8M8sTsHq+yo60ivWXGQSjcWM=; b=OuV2HZuP9uOUtecpV0ZB71Cw4
        99LE2ZAIh7jf3+Q0XwJxi/Czi5He84KlWmm06j1uKGcGMDV/EtFU0myguSI0leXUVIJCOuwVbZu5+
        Cr4JZ9lZ4O36Jx+EIjktNX5vKyNuePho0vHjvtAWKPy85nR0NONyBNBelK3hOhMG2o9NwaxQg/BdM
        chPBlkGfttHUZN4UMtGaBjmLOMRLWaxV10GEN1PHOfPye/N3ECixZdpZPPLyB8TIIJGy2nx7U5AQe
        wLT6RxWlSX2OJ0vB0WKnTVDuLzx58oQw5zwdveL61XLzHbE0lusiWU7lGQHNdERgiIya8BPP9Albb
        bgwsKzs2g==;
Received: from shell.armlinux.org.uk ([fd8f:7570:feb6:1:5054:ff:fe00:4ec]:45414)
        by pandora.armlinux.org.uk with esmtpsa (TLS1.3:ECDHE_RSA_AES_256_GCM_SHA384:256)
        (Exim 4.92)
        (envelope-from <linux@armlinux.org.uk>)
        id 1lxa9a-0002nN-Tr; Sun, 27 Jun 2021 20:09:14 +0100
Received: from linux by shell.armlinux.org.uk with local (Exim 4.92)
        (envelope-from <linux@shell.armlinux.org.uk>)
        id 1lxa9a-0000LW-3D; Sun, 27 Jun 2021 20:09:14 +0100
Date:   Sun, 27 Jun 2021 20:09:14 +0100
From:   "Russell King (Oracle)" <linux@armlinux.org.uk>
To:     Andrew Lunn <andrew@lunn.ch>
Cc:     Florian Fainelli <f.fainelli@gmail.com>,
        Linux Netdev List <netdev@vger.kernel.org>,
        Vladimir Oltean <olteanv@gmail.com>,
        Jakub Kicinski <kuba@kernel.org>,
        Michal Kubecek <mkubecek@suse.cz>,
        Heiner Kallweit <hkallweit1@gmail.com>
Subject: Re: PHY vs. MAC ethtool Wake-on-LAN selection
Message-ID: <20210627190913.GA22278@shell.armlinux.org.uk>
References: <554fea3f-ba7c-b2fc-5ee6-755015f6dfba@gmail.com>
 <YNiwJTgEZjRG7bha@lunn.ch>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <YNiwJTgEZjRG7bha@lunn.ch>
User-Agent: Mutt/1.10.1 (2018-07-13)
Sender: Russell King (Oracle) <linux@armlinux.org.uk>
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Sun, Jun 27, 2021 at 07:06:45PM +0200, Andrew Lunn wrote:
> > - Ethernet MAC (bcmgenet) is capable of doing Wake-on-LAN using Magic
> > Packets (g) with password (s) or network filters (f) and is powered on in
> > the "standby" (as written in /sys/power/state) suspend state, and completely
> > powered off (by hardware) in the "mem" state
> > 
> > - Ethernet PHY (broadcom.c, no code there to support WoL yet) is capable of
> > doing Wake-on-LAN using Magic Packets (g) with password (s) or a 48-bit MAC
> > destination address (f) match allowing us to match on say, Broadcom and
> > Multicast. That PHY is on during both the "standby" and "mem" suspend states
> 
> Marvell systems are similar. The mvneta hardware has support for WOL,
> and has quite a capable filter. But there is no driver support. WOL is
> simply forwarded to the PHY.
> 
> > What I envision we could do is add a ETHTOOL_A_WOL_DEVICE u8 field and have
> > it take the values: 0 (default), 1 (MAC), 2 (PHY), 3 (both) and you would do
> > the following on the command line:
> > 
> > ethtool -s eth0 wol g # default/existing mode, leave it to the driver
> > ethtool -s eth0 wol g target mac # target the MAC only
> > ethtool -s eth0 wol g target phy # target the PHY only
> > ethtool -s eth0 wol g target mac+phy # target both MAC and PHY
> 
> This API seems like a start, but is it going to be limiting? It does
> not appear you can say:
> 
> ethtool -s eth0 wol g target phy wol f target mac
> 
> So make use of magic packet in the PHY and filtering in the MAC.
> ETHTOOL_A_WOL_DEVICE u8 appears to apply to all WoL options, not one
> u8 per option.
> 
> And does mac+phy mean both will generate an interrupt? I'm assuming
> the default of 0 means do whatever undefined behaviour we have now. Do
> we need another value, 4 (auto) and the MAC driver will first try to
> offload to the PHY, and if that fails, it does it at the MAC, with the
> potential for some options to be in the MAC and some in the PHY?

Another question concerns the capabilities of the MAC and PHY in each
low power mode. Consider that userspace wishes to program the system
to wakeup when a certain packet is received. How does it know whether
it needs to program that into the MAC or the PHY or both?

Should that level of detail be available to userspace, or kept within
the driver?

For example, if userspace requests destination MAC address wakeup, then
shouldn't the driver be making the decision about which of the MAC or
PHY gets programmed to cause the wakeup depending on which mode the
system will be switching to and whether the appropriate blocks can be
left powered?

Another question would be - if the PHY can only do magic packet and
remains powered, and the MAC can only do destination MAC but is powered
down in the "mem" state, what do we advertise to the user. If the user
selects destination MAC and then requests the system enter "mem" state,
then what? Should we try to do the best we can?

Should we at the very least be advertising which WOL modes are
supported in each power state?

Sorry for adding to the questions...

-- 
RMK's Patch system: https://www.armlinux.org.uk/developer/patches/
FTTP is here! 40Mbps down 10Mbps up. Decent connectivity at last!
