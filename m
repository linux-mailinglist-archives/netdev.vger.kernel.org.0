Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 490653E9443
	for <lists+netdev@lfdr.de>; Wed, 11 Aug 2021 17:10:57 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232773AbhHKPLQ (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 11 Aug 2021 11:11:16 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:39796 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232440AbhHKPLQ (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 11 Aug 2021 11:11:16 -0400
Received: from pandora.armlinux.org.uk (pandora.armlinux.org.uk [IPv6:2001:4d48:ad52:32c8:5054:ff:fe00:142])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 59F36C061765;
        Wed, 11 Aug 2021 08:10:52 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
        d=armlinux.org.uk; s=pandora-2019; h=Sender:In-Reply-To:Content-Type:
        MIME-Version:References:Message-ID:Subject:Cc:To:From:Date:Reply-To:
        Content-Transfer-Encoding:Content-ID:Content-Description:Resent-Date:
        Resent-From:Resent-Sender:Resent-To:Resent-Cc:Resent-Message-ID:List-Id:
        List-Help:List-Unsubscribe:List-Subscribe:List-Post:List-Owner:List-Archive;
         bh=8c4jvAPh9GG+ChQXbPWzdnZGQWYdJP7nQQ9g0ggPFr8=; b=bIBef/TM/54i+CILkU7k3b2UK
        NMIiNzGHW8C0jIqsdEV/k6eQtYm7RTM84z5AtFAWeDApx4SfxMabe+TvUfdehlUHHUu7obCnBVbqq
        AIRtN2u7fScxvgsScdWaWL0/J/K2T5YkG1pZyzQy1I9u8238DVXSds52MnvD+eSSmVm4BN2n2ZBz7
        kJIgaH2v2ez0VGPFWJNr298SX3lJ4VIybRQU8aqXHsdXNl/Yku29RDzpDU1mCX7/M0Yv8V4TLZevd
        EvPNWgSrLDsYMWdGVd9v1rRSaVCJgJ+V/MfWfpdXiDiJgDYIWBzMCnN5UbICdKdaMC3KgLqvFBdmz
        4E8vRdCgg==;
Received: from shell.armlinux.org.uk ([fd8f:7570:feb6:1:5054:ff:fe00:4ec]:47184)
        by pandora.armlinux.org.uk with esmtpsa (TLS1.3:ECDHE_RSA_AES_256_GCM_SHA384:256)
        (Exim 4.92)
        (envelope-from <linux@armlinux.org.uk>)
        id 1mDpsU-0000iQ-CT; Wed, 11 Aug 2021 16:10:46 +0100
Received: from linux by shell.armlinux.org.uk with local (Exim 4.92)
        (envelope-from <linux@shell.armlinux.org.uk>)
        id 1mDpsT-0003Fl-2U; Wed, 11 Aug 2021 16:10:45 +0100
Date:   Wed, 11 Aug 2021 16:10:45 +0100
From:   "Russell King (Oracle)" <linux@armlinux.org.uk>
To:     "Ivan T. Ivanov" <iivanov@suse.de>
Cc:     Andrew Lunn <andrew@lunn.ch>,
        Heiner Kallweit <hkallweit1@gmail.com>,
        "David S . Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>, netdev@vger.kernel.org,
        linux-kernel@vger.kernel.org
Subject: Re: [PATCH] net: phy: leds: Trigger leds only if PHY speed is known
Message-ID: <20210811151044.GW22278@shell.armlinux.org.uk>
References: <20210716141142.12710-1-iivanov@suse.de>
 <YPGjnvB92ajEBKGJ@lunn.ch>
 <162646032060.16633.4902744414139431224@localhost>
 <20210719152942.GQ22278@shell.armlinux.org.uk>
 <162737250593.8289.392757192031571742@localhost>
 <162806599009.5748.14837844278631256325@localhost>
 <20210809141633.GT22278@shell.armlinux.org.uk>
 <162867546407.30043.9226294532918992883@localhost>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <162867546407.30043.9226294532918992883@localhost>
User-Agent: Mutt/1.10.1 (2018-07-13)
Sender: Russell King (Oracle) <linux@armlinux.org.uk>
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Wed, Aug 11, 2021 at 12:51:04PM +0300, Ivan T. Ivanov wrote:
> There are a few callers of this, but then we have a few callers of
> genphy_read_status() too, which are outside just implementing 
> phy_driver->read_status() and don't use locking.

I think we need to strongly discourage people using the genphy*
functions directly from anything except phylib driver code. Any
such use is a layering violation.

I think it does make sense to have a set of lower-level API
functions that do the locking necessary, rather than having the
phylib locking spread out across multiple network drivers. It's
better to have it in one place.

> Then there a few users of phy_init_eee() which uses phy_read_status(),
> again without locking.

That is kind-of a special case - phy_init_eee() can be called by
network drivers from within the phylib adjust_link() callback, and
this callback is made while holding the phydev's lock. So those
cases are safe.

If phy_init_eee() is called outside of that, and the lock isn't
taken, then yes, it's buggy.

This all said, I can't say that I have particularly liked the
phy_init_eee() API. It seems to mix interface-up like configuration
(do we wish clocks to stop in EEE) with working out whether EEE
should be enabled for the speed/duplex that we've just read from
the PHY. However, most users of this function are being called as a
result of a link-up event when we already know the link parameters,
so we shouldn't be re-interrogating the PHY at this point. It seems
to me to be entirely unnecessary.

> I think will be easier if we protect public phylib API internally with
> lock, otherwise it is easy to make mistakes, obviously. But still this
> will not protect users which directly dereference phy_device members.

As Andrew says... but there are some members that network drivers
have to access due to the design of phylib, such as speed, duplex,
*pause, link, etc. Indeed these can change at any time when
phydev->lock is not held due to the action of phylib polling or
link interrupts from the PHY. So, accessing them outside of the
adjust_link() callback without holding the lock is racy.

Note that phylink's usage is similarly safe to the adjust_link()
callback; its access to these members is similarly protected by
phydev->lock taken in the phylib state machine - we use the
slightly lower-level phy_link_change() hook which avoids some of
the help that phylib provides to network drivers (which phylink
really doesn't want phylib managing.)

-- 
RMK's Patch system: https://www.armlinux.org.uk/developer/patches/
FTTP is here! 40Mbps down 10Mbps up. Decent connectivity at last!
