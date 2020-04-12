Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (unknown [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id D19FD1A5FF3
	for <lists+netdev@lfdr.de>; Sun, 12 Apr 2020 20:55:16 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727824AbgDLSzI (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sun, 12 Apr 2020 14:55:08 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.18]:48148 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1727329AbgDLSzI (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sun, 12 Apr 2020 14:55:08 -0400
Received: from pandora.armlinux.org.uk (pandora.armlinux.org.uk [78.32.30.218])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 3D818C0A3BF0;
        Sun, 12 Apr 2020 11:55:07 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
        d=armlinux.org.uk; s=pandora-2019; h=Sender:In-Reply-To:Content-Type:
        MIME-Version:References:Message-ID:Subject:Cc:To:From:Date:Reply-To:
        Content-Transfer-Encoding:Content-ID:Content-Description:Resent-Date:
        Resent-From:Resent-Sender:Resent-To:Resent-Cc:Resent-Message-ID:List-Id:
        List-Help:List-Unsubscribe:List-Subscribe:List-Post:List-Owner:List-Archive;
         bh=T0Qm20dtHzGxUq+udQUOjpBFugQ/FhXVFcJ4ylKYLww=; b=LosmyP6UyPNjxXtS7gdm833Xa
        FSeSbquKUgLN6f0KcuF0gsgOyE7pgxAbaGjnUzr1kIl7ADd+z5ktSPoPI6e4tTZhwcSJ5u6ch+3ZU
        ojCum4P7/qKFbRjmDzU/94ua8FHnTLthd8sZPRzzlTqK/BpF+xv+mX/CK+OW+DGdtMyLnLaSloH1k
        1kvp6RXowJlz+cr24sYiV0sVZ5+/tkfUJPtJ522ULMOAWO2GxioB4xsPG9AXhUQJA9SPwm4hI1ma/
        QQwD9tKqfKc7BqlMP3nqTRvdxTMBAgTjGKsMmJfIMd9CJQRSbxN3vXY30/oUYx/DdTIozCWnCnc0j
        VR5gf1ByQ==;
Received: from shell.armlinux.org.uk ([2001:4d48:ad52:3201:5054:ff:fe00:4ec]:37524)
        by pandora.armlinux.org.uk with esmtpsa (TLSv1.2:ECDHE-RSA-AES256-GCM-SHA384:256)
        (Exim 4.90_1)
        (envelope-from <linux@armlinux.org.uk>)
        id 1jNhkq-00063D-Ku; Sun, 12 Apr 2020 19:54:52 +0100
Received: from linux by shell.armlinux.org.uk with local (Exim 4.92)
        (envelope-from <linux@shell.armlinux.org.uk>)
        id 1jNhkl-0006F5-RU; Sun, 12 Apr 2020 19:54:47 +0100
Date:   Sun, 12 Apr 2020 19:54:47 +0100
From:   Russell King - ARM Linux admin <linux@armlinux.org.uk>
To:     Clemens Gruber <clemens.gruber@pqgruber.com>
Cc:     Jakub Kicinski <kuba@kernel.org>, netdev@vger.kernel.org,
        Andrew Lunn <andrew@lunn.ch>,
        Florian Fainelli <f.fainelli@gmail.com>,
        Heiner Kallweit <hkallweit1@gmail.com>,
        "David S . Miller" <davem@davemloft.net>,
        linux-kernel@vger.kernel.org
Subject: Re: [PATCH] net: phy: marvell: Fix pause frame negotiation
Message-ID: <20200412185447.GN25745@shell.armlinux.org.uk>
References: <20200408214326.934440-1-clemens.gruber@pqgruber.com>
 <20200410174304.22f812fd@kicinski-fedora-pc1c0hjn.dhcp.thefacebook.com>
 <20200411091705.GG25745@shell.armlinux.org.uk>
 <20200411132401.GA273086@workstation.tuxnet>
 <20200411134344.GI25745@shell.armlinux.org.uk>
 <20200412170336.GA1826@workstation.tuxnet>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20200412170336.GA1826@workstation.tuxnet>
User-Agent: Mutt/1.10.1 (2018-07-13)
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Sun, Apr 12, 2020 at 07:03:36PM +0200, Clemens Gruber wrote:
> On Sat, Apr 11, 2020 at 02:43:44PM +0100, Russell King - ARM Linux admin wrote:
> > The fiber code is IMHO very suspect; the decoding of the pause status
> > seems to be completely broken. However, I'm not sure whether anyone
> > actually uses that or not, so I've been trying not to touch it.
> 
> If the following table for the link partner advertisement is correct..
> PAUSE           ASYM_PAUSE      MEANING
> 0               0               Link partner has no pause frame support
> 0               1               <-  Link partner can TX pause frames
> 1               0               <-> Link partner can RX and TX pauses
> 1               1                -> Link partner can RX pause frames
> 
> ..then I think both pause and asym_pause have to be assigned
> independently, like this:
> phydev->pause = !!(lpa & LPA_1000XPAUSE);
> phydev->asym_pause = !!(lpa & LPA_1000XPAUSE_ASYM);

Yes, that's how it should be, because the pause and asym pause bits
correspond exactly with the phydev members.

> (Using the defines from uapi mii.h instead of the redundant/combined
> LPA_PAUSE_FIBER etc. which can then be removed from marvell.c)
> 
> Currently, if LPA_1000XPAUSE_ASYM is set we do pause=1 and asym_pause=1
> no matter if LPA_1000XPAUSE is set. This could lead us to mistake a link
> partner who can only send for one who can only receive pause frames.
> ^ Was this the problem you meant?

Exactly, but given that I've no way to actually test anything with
regard to 1G Marvell PHYs using 1000BASE-X, I have to assume that
whoever contributed this code tested it and it worked for them. So,
it should not be changed just because it looks wrong - there may be
some subtle issues in the hardware that we don't know about that
makes this code "do the best it can". We need someone who can
actually do some tests to solve this.

> Does anybody have access to a Marvell PHY with 1000base-X Ethernet?
> (I only have a 88E1510 + 1000Base-T at the home office)

Yes, that's what we need... this isn't the first time I've mentioned
the problem, and so far no one has stepped forward.

-- 
RMK's Patch system: https://www.armlinux.org.uk/developer/patches/
FTTC broadband for 0.8mile line in suburbia: sync at 10.2Mbps down 587kbps up
