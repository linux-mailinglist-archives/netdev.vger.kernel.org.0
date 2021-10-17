Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 0B984430C3C
	for <lists+netdev@lfdr.de>; Sun, 17 Oct 2021 23:07:38 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1344623AbhJQVJq (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sun, 17 Oct 2021 17:09:46 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:41222 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232986AbhJQVJp (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sun, 17 Oct 2021 17:09:45 -0400
Received: from pandora.armlinux.org.uk (pandora.armlinux.org.uk [IPv6:2001:4d48:ad52:32c8:5054:ff:fe00:142])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 368D4C06161C;
        Sun, 17 Oct 2021 14:07:35 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
        d=armlinux.org.uk; s=pandora-2019; h=Sender:In-Reply-To:Content-Type:
        MIME-Version:References:Message-ID:Subject:Cc:To:From:Date:Reply-To:
        Content-Transfer-Encoding:Content-ID:Content-Description:Resent-Date:
        Resent-From:Resent-Sender:Resent-To:Resent-Cc:Resent-Message-ID:List-Id:
        List-Help:List-Unsubscribe:List-Subscribe:List-Post:List-Owner:List-Archive;
        bh=eR4g3uuGyNp1bFRoz5Hyr18qs5VEjGPKJqGzRB2AGqY=; b=momF6VusPtUxNlMO2Yz5/AJv/1
        AYe3LKPBFECRM/NV1KrrmGTiE/aKcGeB6sDtyVqo8ksG5Kb/Gc+PVbAlSajsuoQlQuYgptg4A5yDm
        PYa6jcRArtRMdVbHGi2B8coyMJO9JgqVow7XHD3qwpLNmh5Z+4ib1gKQcoIPFN6vVOxA73MJEhABt
        jefHxL5DB4uTZg6W7CZ6wKSBytFp9PwLhX4QyUYtaEwf13tzZD0JwfmojwxiOAC5GH2UGq1uPrd52
        zgRIe7eW5tAdj1B6eZzcWyD4p1746qZCvqJRBevGOKkI4ZR0vBNC0NAYVl+kBWPhP8b6w4EKygAky
        aLBLkipA==;
Received: from shell.armlinux.org.uk ([fd8f:7570:feb6:1:5054:ff:fe00:4ec]:55164)
        by pandora.armlinux.org.uk with esmtpsa  (TLS1.3) tls TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384
        (Exim 4.94.2)
        (envelope-from <linux@armlinux.org.uk>)
        id 1mcDNN-0004IW-9X; Sun, 17 Oct 2021 22:07:26 +0100
Received: from linux by shell.armlinux.org.uk with local (Exim 4.94.2)
        (envelope-from <linux@shell.armlinux.org.uk>)
        id 1mcDNJ-0005GW-Gy; Sun, 17 Oct 2021 22:07:21 +0100
Date:   Sun, 17 Oct 2021 22:07:21 +0100
From:   "Russell King (Oracle)" <linux@armlinux.org.uk>
To:     Maarten Zanders <maarten.zanders@mind.be>
Cc:     Maarten Zanders <m.zanders@televic.com>,
        Maxime Chevallier <maxime.chevallier@bootlin.com>,
        Andrew Lunn <andrew@lunn.ch>,
        Vivien Didelot <vivien.didelot@gmail.com>,
        Florian Fainelli <f.fainelli@gmail.com>,
        Vladimir Oltean <olteanv@gmail.com>,
        "David S. Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>, netdev@vger.kernel.org,
        linux-kernel@vger.kernel.org
Subject: Re: [PATCH] net: dsa: mv88e6xxx: don't use PHY_DETECT on internal
 PHY's
Message-ID: <YWyQiSejqGNOG6ES@shell.armlinux.org.uk>
References: <20211011142720.42642-1-maarten.zanders@mind.be>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20211011142720.42642-1-maarten.zanders@mind.be>
Sender: Russell King (Oracle) <linux@armlinux.org.uk>
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Mon, Oct 11, 2021 at 04:27:20PM +0200, Maarten Zanders wrote:
> mv88e6xxx_port_ppu_updates() interpretes data in the PORT_STS
> register incorrectly for internal ports (ie no PPU). In these
> cases, the PHY_DETECT bit indicates link status. This results
> in forcing the MAC state whenever the PHY link goes down which
> is not intended. As a side effect, LED's configured to show
> link status stay lit even though the physical link is down.

I know this patch has been merged, but I'm going to say this anyway
for the record.

The description is not entirely correct. It is not true that internal
ports do not have the PHY_DETECT bit. 88E6176 and friends are documented
that bit 12 is always the PHY_DETECT bit even for internal ports. Bit 11
there is Link status.

Looking at the definitions in port.h, some switches are different
(88E6250 family) and do indeed use bit 12 as link status.

The point I'm making is that the commit description is not universally
true and only applies to a subset of mv88e6xxx supported switches. It is
a shame it wasn't better reviewed before merging.

At least the patch is harmless; we leave the PHY_DETECT bit set on the
internal ports, which means the PPU fetches the configuration and
configures the port appropriately. The change merely helps to ensure
that we don't force link status on the internal ports.

-- 
RMK's Patch system: https://www.armlinux.org.uk/developer/patches/
FTTP is here! 40Mbps down 10Mbps up. Decent connectivity at last!
