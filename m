Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id C3E3446BE83
	for <lists+netdev@lfdr.de>; Tue,  7 Dec 2021 15:59:53 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232812AbhLGPCu (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 7 Dec 2021 10:02:50 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:51732 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S238474AbhLGPCA (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 7 Dec 2021 10:02:00 -0500
Received: from pandora.armlinux.org.uk (pandora.armlinux.org.uk [IPv6:2001:4d48:ad52:32c8:5054:ff:fe00:142])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id DA5C1C061574
        for <netdev@vger.kernel.org>; Tue,  7 Dec 2021 06:58:29 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
        d=armlinux.org.uk; s=pandora-2019; h=Sender:In-Reply-To:Content-Type:
        MIME-Version:References:Message-ID:Subject:Cc:To:From:Date:Reply-To:
        Content-Transfer-Encoding:Content-ID:Content-Description:Resent-Date:
        Resent-From:Resent-Sender:Resent-To:Resent-Cc:Resent-Message-ID:List-Id:
        List-Help:List-Unsubscribe:List-Subscribe:List-Post:List-Owner:List-Archive;
        bh=+AMF01UXCTq1w00qH/gPJA4fQx+0gu1PKqT45C4WteY=; b=N4uK/oOWsjjt+xhULoMwhfpGDd
        RsSGTb30pHYNQROoWojiWyJACP/H34x/g4zmTft7K0sNdxZ4y6jNYE90YN6NK99EBLgVJ1PkWXTMg
        cEkrG8J+mztVelY3K3cgJ3OsVHzgc1tGldwWEHTkZF+S/e7r2vrWbb7C5DBlNKeqtjHd0lYgcbvF1
        u3bSyIs4yMnlgnl01OMpKrV99PAExQEqtezO0+Mec+qzICElyuOjWC/5LJrgwmuqJBChuytKw0Ndj
        pWb1ZHn7+XUsCt7rqjh0VZMOMyIXW793YEczDbcd3yAT6DacQvDz1pLH/+T6IBNvOo6TAwwkeTxZ+
        OpQmgiVQ==;
Received: from shell.armlinux.org.uk ([fd8f:7570:feb6:1:5054:ff:fe00:4ec]:56162)
        by pandora.armlinux.org.uk with esmtpsa  (TLS1.3) tls TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384
        (Exim 4.94.2)
        (envelope-from <linux@armlinux.org.uk>)
        id 1mubvG-0006Kw-V4; Tue, 07 Dec 2021 14:58:26 +0000
Received: from linux by shell.armlinux.org.uk with local (Exim 4.94.2)
        (envelope-from <linux@shell.armlinux.org.uk>)
        id 1mubvG-0005QI-8X; Tue, 07 Dec 2021 14:58:26 +0000
Date:   Tue, 7 Dec 2021 14:58:26 +0000
From:   "Russell King (Oracle)" <linux@armlinux.org.uk>
To:     Andrew Lunn <andrew@lunn.ch>
Cc:     Martyn Welch <martyn.welch@collabora.com>,
        Vivien Didelot <vivien.didelot@gmail.com>,
        Florian Fainelli <f.fainelli@gmail.com>,
        Vladimir Oltean <olteanv@gmail.com>,
        "David S. Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>, netdev@vger.kernel.org
Subject: Re: [PATCH RFC net] net: dsa: mv88e6xxx: allow use of PHYs on CPU
 and DSA ports
Message-ID: <Ya92klnTqoUpFvpo@shell.armlinux.org.uk>
References: <E1muYBr-00EwOF-9C@rmk-PC.armlinux.org.uk>
 <Ya91rX5acIKQk7W0@lunn.ch>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <Ya91rX5acIKQk7W0@lunn.ch>
Sender: Russell King (Oracle) <linux@armlinux.org.uk>
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Tue, Dec 07, 2021 at 03:54:37PM +0100, Andrew Lunn wrote:
> On Tue, Dec 07, 2021 at 10:59:19AM +0000, Russell King (Oracle) wrote:
> > Martyn Welch reports that his CPU port is unable to link where it has
> > been necessary to use one of the switch ports with an internal PHY for
> > the CPU port. The reason behind this is the port control register is
> > left forcing the link down, preventing traffic flow.
> > 
> > This occurs because during initialisation, phylink expects the link to
> > be down, and DSA forces the link down by synthesising a call to the
> > DSA drivers phylink_mac_link_down() method, but we don't touch the
> > forced-link state when we later reconfigure the port.
> > 
> > Resolve this by also unforcing the link state when we are operating in
> > PHY mode and the PPU is set to poll the PHY to retrieve link status
> > information.
> > 
> > Reported-by: Martyn Welch <martyn.welch@collabora.com>
> > Signed-off-by: Russell King (Oracle) <rmk+kernel@armlinux.org.uk>
> 
> Hi Russell
> 
> It would be good to have a Fixes: tag here, to help with back porting.

Oh, I thought this was a new development, not a regression. Do you have
a pointer to the earlier bits of the thread please, e.g. the message ID
of the original report.

Thanks.

> The concept looks good, and i see you now have a Tested-by:, so with
> the fixup applied i think you are good to go. Please add my
> Reviewed-by: to the next version.

Will do.

-- 
RMK's Patch system: https://www.armlinux.org.uk/developer/patches/
FTTP is here! 40Mbps down 10Mbps up. Decent connectivity at last!
