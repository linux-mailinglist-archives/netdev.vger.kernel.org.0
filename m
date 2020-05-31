Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id F0C9E1E94BD
	for <lists+netdev@lfdr.de>; Sun, 31 May 2020 02:19:28 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729543AbgEaATN (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sat, 30 May 2020 20:19:13 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:45610 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1729361AbgEaATM (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sat, 30 May 2020 20:19:12 -0400
Received: from pandora.armlinux.org.uk (pandora.armlinux.org.uk [IPv6:2001:4d48:ad52:3201:214:fdff:fe10:1be6])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id AA49EC03E969;
        Sat, 30 May 2020 17:19:11 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
        d=armlinux.org.uk; s=pandora-2019; h=Sender:In-Reply-To:Content-Type:
        MIME-Version:References:Message-ID:Subject:Cc:To:From:Date:Reply-To:
        Content-Transfer-Encoding:Content-ID:Content-Description:Resent-Date:
        Resent-From:Resent-Sender:Resent-To:Resent-Cc:Resent-Message-ID:List-Id:
        List-Help:List-Unsubscribe:List-Subscribe:List-Post:List-Owner:List-Archive;
         bh=wOIeSpwSQVRmf9tkVhXNQpeRGfDV1NinvsV4WEWvauA=; b=ycsWV7OFygToHe8J31oVZBGPo
        piaZXSFsWHFuinXM0j2wipzzCttiOgVD2YDSMnTybl0L2vmQHGyvCSWYh2S34ywrLf2J+dHHl3fi9
        lRgebGj+pKgjEnDn414wrizIqzBfTSF5adoox6aKSCWoF8mc9OK7fxSldXCpxyXESNKvhQJers5p4
        9QPN8dGi8McfQ2osaEpNqcdd7UK3sacFUbInX1WIWhE5QsO9H5/BlOU2U8y4zZedVKKcGaVIoZkO4
        m5SCBwd/WD4OSGnqc+t16wzIARqGJTIwCgrht+87nH071+rqeOm/1Otv/ag/EmyvkmeCiRn0uHxCb
        Prc0re8JQ==;
Received: from shell.armlinux.org.uk ([2001:4d48:ad52:3201:5054:ff:fe00:4ec]:47224)
        by pandora.armlinux.org.uk with esmtpsa (TLSv1.2:ECDHE-RSA-AES256-GCM-SHA384:256)
        (Exim 4.90_1)
        (envelope-from <linux@armlinux.org.uk>)
        id 1jfBgl-0003Qq-0l; Sun, 31 May 2020 01:18:55 +0100
Received: from linux by shell.armlinux.org.uk with local (Exim 4.92)
        (envelope-from <linux@shell.armlinux.org.uk>)
        id 1jfBgf-0001WV-6Z; Sun, 31 May 2020 01:18:49 +0100
Date:   Sun, 31 May 2020 01:18:49 +0100
From:   Russell King - ARM Linux admin <linux@armlinux.org.uk>
To:     Vladimir Oltean <olteanv@gmail.com>
Cc:     stable@vger.kernel.org, gregkh@linuxfoundation.org,
        netdev@vger.kernel.org, andrew@lunn.ch, f.fainelli@gmail.com,
        hkallweit1@gmail.com, davem@davemloft.net, kuba@kernel.org,
        linux-kernel@vger.kernel.org
Subject: Re: [PATCH stable-4.19.y] net: phy: reschedule state machine if AN
 has not completed in PHY_AN state
Message-ID: <20200531001849.GG1551@shell.armlinux.org.uk>
References: <20200530214315.1051358-1-olteanv@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20200530214315.1051358-1-olteanv@gmail.com>
User-Agent: Mutt/1.10.1 (2018-07-13)
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Sun, May 31, 2020 at 12:43:15AM +0300, Vladimir Oltean wrote:
> From: Vladimir Oltean <vladimir.oltean@nxp.com>
> 
> In kernel 4.19 (and probably earlier too) there are issues surrounding
> the PHY_AN state.
> 
> For example, if a PHY is in PHY_AN state and AN has not finished, then
> what is supposed to happen is that the state machine gets rescheduled
> until it is, or until the link_timeout reaches zero which triggers an
> autoneg restart process.
> 
> But actually the rescheduling never works if the PHY uses interrupts,
> because the condition under which rescheduling occurs is just if
> phy_polling_mode() is true. So basically, this whole rescheduling
> functionality works for AN-not-yet-complete just by mistake. Let me
> explain.
> 
> Most of the time the AN process manages to finish by the time the
> interrupt has triggered. One might say "that should always be the case,
> otherwise the PHY wouldn't raise the interrupt, right?".
> Well, some PHYs implement an .aneg_done method which allows them to tell
> the state machine when the AN is really complete.
> The AR8031/AR8033 driver (at803x.c) is one such example. Even when
> copper autoneg completes, the driver still keeps the "aneg_done"
> variable unset until in-band SGMII autoneg finishes too (there is no
> interrupt for that). So we have the premises of a race condition.

Why do we care whether SGMII autoneg has completed - is that not the
domain of the MAC side of the link?

It sounds like things are a little confused.  The PHY interrupt is
signalling that the copper side has completed its autoneg.  If we're
in SGMII mode, the PHY can now start the process of informing the
MAC about the negotiation results across the SGMII link.  When the
MAC receives those results, and sends the acknowledgement back to the
PHY, is it not the responsibility of the MAC to then say "the link is
now up" ?

That's how we deal with it elsewhere with phylink integration, which
is what has to be done when you have to cope with PHYs that switch
their host interface mode between SGMII, 2500BASE-X, 5GBASE-R and
10GBASE-R - the MAC side needs to be dynamically reconfigured depending
on the new host-side operating mode of the PHY.  Only when the MAC
subsequently reports that the link has been established is the whole
link from the MAC to the media deemed to be operational.

-- 
RMK's Patch system: https://www.armlinux.org.uk/developer/patches/
FTTC for 0.8m (est. 1762m) line in suburbia: sync at 13.1Mbps down 424kbps up
