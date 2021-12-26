Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 674E147F928
	for <lists+netdev@lfdr.de>; Sun, 26 Dec 2021 22:57:19 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234648AbhLZV5Q (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sun, 26 Dec 2021 16:57:16 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:60028 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S234606AbhLZV5Q (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sun, 26 Dec 2021 16:57:16 -0500
Received: from pandora.armlinux.org.uk (pandora.armlinux.org.uk [IPv6:2001:4d48:ad52:32c8:5054:ff:fe00:142])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 87E71C06173E;
        Sun, 26 Dec 2021 13:57:15 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
        d=armlinux.org.uk; s=pandora-2019; h=Sender:In-Reply-To:Content-Type:
        MIME-Version:References:Message-ID:Subject:Cc:To:From:Date:Reply-To:
        Content-Transfer-Encoding:Content-ID:Content-Description:Resent-Date:
        Resent-From:Resent-Sender:Resent-To:Resent-Cc:Resent-Message-ID:List-Id:
        List-Help:List-Unsubscribe:List-Subscribe:List-Post:List-Owner:List-Archive;
        bh=ZgoXuaZYiF+8e1hdm/07nW5qxeTxUuvpPxUwfPpfj8g=; b=Em7+b/9yc9xPRzljsvC06Wvd48
        tJqpLeedC6jDkjp843UhO0SoAnkTxZ3d7f/iGQR6cplk54QgZ/K7yp81GF/YQ1VbadZWIfAJ4vLCM
        ST9LULm/kBvEcUucuDzuMOgC39RMwEzrzFEwhKERIH8KJFsr/cx3JThFMqI8HdqpvOFSkdsvUDYlJ
        JVu2yN4EAw0QOl+3fCbwQia4iKAmgwJ0d1I7pLcX6vrFjuSAd9W6P6T90CHoGfXRodo0wK0sso3t7
        2nrExSjG35DhwrELoD2VDZfrMguIIMn3JEySM3YduLNKcPdovL1jQj6ezssVMR+BSdJ+4oy8rje48
        hh2xZyXg==;
Received: from shell.armlinux.org.uk ([fd8f:7570:feb6:1:5054:ff:fe00:4ec]:56452)
        by pandora.armlinux.org.uk with esmtpsa  (TLS1.3) tls TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384
        (Exim 4.94.2)
        (envelope-from <linux@armlinux.org.uk>)
        id 1n1bVs-0000ex-AQ; Sun, 26 Dec 2021 21:57:08 +0000
Received: from linux by shell.armlinux.org.uk with local (Exim 4.94.2)
        (envelope-from <linux@shell.armlinux.org.uk>)
        id 1n1bVp-0007Xm-0U; Sun, 26 Dec 2021 21:57:05 +0000
Date:   Sun, 26 Dec 2021 21:57:04 +0000
From:   "Russell King (Oracle)" <linux@armlinux.org.uk>
To:     Andrew Lunn <andrew@lunn.ch>
Cc:     Daniel Golle <daniel@makrotopia.org>,
        linux-mediatek@lists.infradead.org, netdev@vger.kernel.org,
        linux-arm-kernel@lists.infradead.org, linux-kernel@vger.kernel.org,
        Felix Fietkau <nbd@nbd.name>, John Crispin <john@phrozen.org>,
        Sean Wang <sean.wang@mediatek.com>,
        Mark Lee <Mark-MC.Lee@mediatek.com>,
        "David S. Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>,
        Matthias Brugger <matthias.bgg@gmail.com>
Subject: Re: [PATCH] net: ethernet: mtk_eth_soc: implement Clause 45 MDIO
 access
Message-ID: <YcjlMCacTTJ4RsSA@shell.armlinux.org.uk>
References: <YcjepQ2fmkPZ2+pE@makrotopia.org>
 <YcjjzNJ159Bo1xk7@lunn.ch>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <YcjjzNJ159Bo1xk7@lunn.ch>
Sender: Russell King (Oracle) <linux@armlinux.org.uk>
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Sun, Dec 26, 2021 at 10:51:08PM +0100, Andrew Lunn wrote:
> > +	if (phy_register & MII_ADDR_C45) {
> > +		u8 dev_num = (phy_register >> 16) & 0x1f;
> > +		u16 reg = (u16)(phy_register & 0xffff);
> 
> Hi Daniel
> 
> You can use the helpers
> 
> mdio_phy_id_is_c45()
> mdio_phy_id_prtad()
> mdio_phy_id_devad()

Before someone makes a mistake with this... no, don't use these. These
are for the userspace MII ioctl API, not for drivers.

The MII ioctl API passes the prtad and devad via the PHY ID field, and
is decoded by the above macros.

The internal API passes the prtad as the PHY ID and merges the devad
into the register address.

The C45 register address can be extracted by masking with
MII_REGADDR_C45_MASK. The C45 devad can be extracted by shifting right
by MII_DEVADDR_C45_SHIFT and masking 5 bits. We don't have helpers for
this.

-- 
RMK's Patch system: https://www.armlinux.org.uk/developer/patches/
FTTP is here! 40Mbps down 10Mbps up. Decent connectivity at last!
