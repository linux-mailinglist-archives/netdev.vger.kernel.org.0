Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id B20421856AB
	for <lists+netdev@lfdr.de>; Sun, 15 Mar 2020 02:28:57 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726597AbgCOB2u (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sat, 14 Mar 2020 21:28:50 -0400
Received: from pandora.armlinux.org.uk ([78.32.30.218]:55780 "EHLO
        pandora.armlinux.org.uk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1725793AbgCOB2u (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sat, 14 Mar 2020 21:28:50 -0400
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
        d=armlinux.org.uk; s=pandora-2019; h=Sender:In-Reply-To:Content-Type:
        MIME-Version:References:Message-ID:Subject:Cc:To:From:Date:Reply-To:
        Content-Transfer-Encoding:Content-ID:Content-Description:Resent-Date:
        Resent-From:Resent-Sender:Resent-To:Resent-Cc:Resent-Message-ID:List-Id:
        List-Help:List-Unsubscribe:List-Subscribe:List-Post:List-Owner:List-Archive;
         bh=dil7C3egUGj9aFFuQLXd8JeybmuvdWV6IKvGnj64gBM=; b=DTCtNW4bCjz8pyo9Udvn2IBFo
        dXGDbO6IGfF9EmUFo1iSWevwvnzFhHAoTqogPkYu1znpWLwls+cAXsEDYSBMG8HSza2blqIQD/bjI
        AXuZIdYVJ2zL7peVjzLipb4PlMMqGIKtGZe3Nx05oadmSS5NB8N8JwD/7pcYuOxkS/ac//rEyJZpo
        nJLqEjRwJ4oNfHmw8Hdmrm1QxunqkT61GOxmDbIMqUR6Z9/U8bbqKCHDw/NHttIAsFwXALywffNvP
        cc+dwODIdHInNey7ceZWq4qokl4eyO3RcZiShC7AOXgN2fDhFt5dAZx5OblJNONBx1zqrcEdOK9gv
        q2cuRz8CQ==;
Received: from shell.armlinux.org.uk ([2001:4d48:ad52:3201:5054:ff:fe00:4ec]:52878)
        by pandora.armlinux.org.uk with esmtpsa (TLSv1.2:ECDHE-RSA-AES256-GCM-SHA384:256)
        (Exim 4.90_1)
        (envelope-from <linux@armlinux.org.uk>)
        id 1jD43H-0006L5-Bu; Sat, 14 Mar 2020 10:29:55 +0000
Received: from linux by shell.armlinux.org.uk with local (Exim 4.92)
        (envelope-from <linux@shell.armlinux.org.uk>)
        id 1jD43G-0008Ep-RI; Sat, 14 Mar 2020 10:29:54 +0000
Date:   Sat, 14 Mar 2020 10:29:54 +0000
From:   Russell King - ARM Linux admin <linux@armlinux.org.uk>
To:     Andrew Lunn <andrew@lunn.ch>,
        Florian Fainelli <f.fainelli@gmail.com>,
        Heiner Kallweit <hkallweit1@gmail.com>
Cc:     "David S. Miller" <davem@davemloft.net>, netdev@vger.kernel.org
Subject: [PATCH REPOST2 net-next 0/3] net: add phylink support for PCS
Message-ID: <20200314102954.GI25745@shell.armlinux.org.uk>
References: <20200314102721.GG25745@shell.armlinux.org.uk>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20200314102721.GG25745@shell.armlinux.org.uk>
User-Agent: Mutt/1.10.1 (2018-07-13)
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Depends on "net: mii clause 37 helpers".

This series adds support for IEEE 802.3 register set compliant PCS
for phylink.  In order to do this, we:

1. add accessors for modifying a MDIO device register, and use them in
   phylib, rather than duplicating the code from phylib.
2. add support for decoding the advertisement from clause 22 compatible
   register sets for clause 37 advertisements and SGMII advertisements.
3. add support for clause 45 register sets for 10GBASE-R PCS.

These have been tested on the LX2160A Clearfog-CX platform.

This is a re-post of the series previously sent, but with the first two
patches separated out; the conclusion of the discussion with Vladimir
seemed to be that there was no issue with the patches themselves.

 drivers/net/phy/mdio_bus.c |  55 +++++++++++
 drivers/net/phy/phy-core.c |  31 ------
 drivers/net/phy/phylink.c  | 236 +++++++++++++++++++++++++++++++++++++++++++++
 include/linux/mdio.h       |   4 +
 include/linux/phy.h        |  19 ++++
 include/linux/phylink.h    |   8 ++
 include/uapi/linux/mii.h   |   5 +
 7 files changed, 327 insertions(+), 31 deletions(-)

-- 
RMK's Patch system: https://www.armlinux.org.uk/developer/patches/
FTTC broadband for 0.8mile line in suburbia: sync at 10.2Mbps down 587kbps up
