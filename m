Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 35C0A1ECFCF
	for <lists+netdev@lfdr.de>; Wed,  3 Jun 2020 14:32:00 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726117AbgFCMbz (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 3 Jun 2020 08:31:55 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:38114 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1725992AbgFCMby (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 3 Jun 2020 08:31:54 -0400
Received: from pandora.armlinux.org.uk (pandora.armlinux.org.uk [IPv6:2001:4d48:ad52:3201:214:fdff:fe10:1be6])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id D164CC08C5C0;
        Wed,  3 Jun 2020 05:31:53 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
        d=armlinux.org.uk; s=pandora-2019; h=Sender:In-Reply-To:Content-Type:
        MIME-Version:References:Message-ID:Subject:Cc:To:From:Date:Reply-To:
        Content-Transfer-Encoding:Content-ID:Content-Description:Resent-Date:
        Resent-From:Resent-Sender:Resent-To:Resent-Cc:Resent-Message-ID:List-Id:
        List-Help:List-Unsubscribe:List-Subscribe:List-Post:List-Owner:List-Archive;
         bh=TOhmvnzlmGigE1Miw3N6/6ONIbwSf6YuZAt+1vAhyXM=; b=WDEAYzj5IU60fkR/zEsX7YNtO
        YgVYYqu33onIdA26p4VUvN7E0Cg3z5u8zPdGgmbUEARPWtRBBi9g0ZAFdmahzE+F4GuKObKfyXYp8
        7K+t50vIQ4W4/HewyO4Q2Ay55AVLF80mtaHCoVOdmi6dU9i/+3kAxACS7YC93lhs+YfE8ZaRaCkoB
        KCi3ISwD0kFpDH6EadSuA/vnhN9nlfbIofGCvWtov1RK06E+NDhqu5cVuOGZrqi4OsWT8PBHd73hu
        2vjvl2+gxuMKjRaGhXghQrq1Gskz0eMuJP+aNMcPi7CuGASM0tQpBRky786bQSmisdC33vMgSRIca
        yZcrbr3vg==;
Received: from shell.armlinux.org.uk ([2001:4d48:ad52:3201:5054:ff:fe00:4ec]:48860)
        by pandora.armlinux.org.uk with esmtpsa (TLSv1.2:ECDHE-RSA-AES256-GCM-SHA384:256)
        (Exim 4.90_1)
        (envelope-from <linux@armlinux.org.uk>)
        id 1jgSYY-0005QV-NX; Wed, 03 Jun 2020 13:31:42 +0100
Received: from linux by shell.armlinux.org.uk with local (Exim 4.92)
        (envelope-from <linux@shell.armlinux.org.uk>)
        id 1jgSYT-0005OK-CV; Wed, 03 Jun 2020 13:31:37 +0100
Date:   Wed, 3 Jun 2020 13:31:37 +0100
From:   Russell King - ARM Linux admin <linux@armlinux.org.uk>
To:     Andrew Lunn <andrew@lunn.ch>
Cc:     Thomas Bogendoerfer <tbogendoerfer@suse.de>,
        "David S. Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>, netdev@vger.kernel.org,
        linux-kernel@vger.kernel.org
Subject: Re: [PATCH net] net: mvpp2: Enable autoneg bypass for
 1000BaseX/2500BaseX ports
Message-ID: <20200603123137.GZ1551@shell.armlinux.org.uk>
References: <20200528135608.GU1551@shell.armlinux.org.uk>
 <20200528163335.8f730b5a3ddc8cd9beab367f@suse.de>
 <20200528144805.GW1551@shell.armlinux.org.uk>
 <20200528204312.df9089425162a22e89669cf1@suse.de>
 <20200528220420.GY1551@shell.armlinux.org.uk>
 <20200529130539.3fe944fed7228e2b061a1e46@suse.de>
 <20200529145928.GF869823@lunn.ch>
 <20200529175225.a3be1b4faaa0408e165435ad@suse.de>
 <20200529163340.GI869823@lunn.ch>
 <20200602225016.GX1551@shell.armlinux.org.uk>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20200602225016.GX1551@shell.armlinux.org.uk>
User-Agent: Mutt/1.10.1 (2018-07-13)
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Tue, Jun 02, 2020 at 11:50:16PM +0100, Russell King - ARM Linux admin wrote:
> On Fri, May 29, 2020 at 06:33:40PM +0200, Andrew Lunn wrote:
> > Given the current code, you cannot. Now we understand the
> > requirements, we can come up with some ideas how to do this properly.
> 
> Okay, I've been a little quiet because of sorting out the ARM tree
> for merging with Linus (now done) and I've been working on a solution
> to this problem.
> 
> The good news is, I have an implementation in phylink to use the sync
> status reported from a PCS, and to appropriately enable sync status
> reporting.  I'm quite nervous about having that enabled as a matter of
> routine as I've seen some Marvell hardware end up with interrupt storms
> from it - presumably due to noise pickup on the serdes lines being
> interpreted as an intermittently valid signal.

Yes, as expected - though not quite a storm - I'm seeing:

[root@buildroot ~]# dmesg |grep 'eno2:' | wc -l
1604
[root@buildroot ~]# dmesg |grep 'eno2: mac link down' | wc -l
1598
[root@buildroot ~]# cat /proc/uptime
68868.10 137231.62

Similar happens with mvpp2 hardware - for Marvell's older mvpp2x driver,
I had to disable the AN bypass bit:

    net: marvell: mvpp2x: avoid link status flood

    eth2 on the Macchiatobin board floods the system with link status
    interrupts whilethe link is down.  This appears to be caused by the
    AN bypass logic causing spurious link status change interrupts,
    despite the port status register indicating that the link remains
    down.

    Avoid this by not setting the AN bypass bit for SGMII links.

    Signed-off-by: Russell King <rmk+kernel@armlinux.org.uk>

So, it looks like a different approach will be needed, since having a
system flooded with unnecessary interrupts is obviously bad.  This
isn't limited to just Marvell mvneta and mvpp2, I think Chris at ZII
has reported a similar behaviour on his boards with noise inducing
serdes sync/link events.

Hmm.

-- 
RMK's Patch system: https://www.armlinux.org.uk/developer/patches/
FTTC for 0.8m (est. 1762m) line in suburbia: sync at 13.1Mbps down 424kbps up
