Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id DE4B143E4B6
	for <lists+netdev@lfdr.de>; Thu, 28 Oct 2021 17:14:11 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231313AbhJ1PQg (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 28 Oct 2021 11:16:36 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:42216 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230258AbhJ1PQf (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 28 Oct 2021 11:16:35 -0400
Received: from pandora.armlinux.org.uk (pandora.armlinux.org.uk [IPv6:2001:4d48:ad52:32c8:5054:ff:fe00:142])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 1C322C061570
        for <netdev@vger.kernel.org>; Thu, 28 Oct 2021 08:14:08 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
        d=armlinux.org.uk; s=pandora-2019; h=Sender:In-Reply-To:Content-Type:
        MIME-Version:References:Message-ID:Subject:Cc:To:From:Date:Reply-To:
        Content-Transfer-Encoding:Content-ID:Content-Description:Resent-Date:
        Resent-From:Resent-Sender:Resent-To:Resent-Cc:Resent-Message-ID:List-Id:
        List-Help:List-Unsubscribe:List-Subscribe:List-Post:List-Owner:List-Archive;
        bh=3ieo+Jt/9S9B7fQHQY/ubQ+4FPDCFuru8kvIMf3LM1s=; b=XejJAqYwUlxjQs+iPgGK5e3jp/
        mpY/3PRybcgteuOAvqX6O13phgzluP1GP6bEEzmjagzlLkGaeuB/N6g1+JFleoFcDmsT1Qve79X/4
        kXk2zrcOHzWwZbNS077BXtJ8UqvWD7wEGuPC/9Y5/I9vdNKz+HQ+s/Ux2r1XNnpnjPfkmNKRp+xjO
        /i3bIkcizb9axDD1FxlydUVSoLEoFme9OFDR0IPHmG72TLpLOBQ6EJgX7gOjlKQlBNHxeNVRJru+T
        tEhU2ZX/BLJnt6+pv46GhXBHDJ4wfPThC9g8yBjDO7O/yuRM7reYSKnPz8yQsTI8w8YzYZ7IcJ14S
        AVqQBGQQ==;
Received: from shell.armlinux.org.uk ([fd8f:7570:feb6:1:5054:ff:fe00:4ec]:55354)
        by pandora.armlinux.org.uk with esmtpsa  (TLS1.3) tls TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384
        (Exim 4.94.2)
        (envelope-from <linux@armlinux.org.uk>)
        id 1mg76T-0007hv-E5; Thu, 28 Oct 2021 16:14:05 +0100
Received: from linux by shell.armlinux.org.uk with local (Exim 4.94.2)
        (envelope-from <linux@shell.armlinux.org.uk>)
        id 1mg76R-0000Rb-T4; Thu, 28 Oct 2021 16:14:03 +0100
Date:   Thu, 28 Oct 2021 16:14:03 +0100
From:   "Russell King (Oracle)" <linux@armlinux.org.uk>
To:     Jakub Kicinski <kuba@kernel.org>
Cc:     Andrew Lunn <andrew@lunn.ch>,
        Heiner Kallweit <hkallweit1@gmail.com>,
        "David S. Miller" <davem@davemloft.net>, netdev@vger.kernel.org
Subject: Re: [PATCH net] net: phylink: avoid mvneta warning when setting
 pause parameters
Message-ID: <YXq+O3lJ0hvusG7s@shell.armlinux.org.uk>
References: <E1mg6oY-0020Bg-Td@rmk-PC.armlinux.org.uk>
 <20211028080607.6226a83a@kicinski-fedora-pc1c0hjn.dhcp.thefacebook.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20211028080607.6226a83a@kicinski-fedora-pc1c0hjn.dhcp.thefacebook.com>
Sender: Russell King (Oracle) <linux@armlinux.org.uk>
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Thu, Oct 28, 2021 at 08:06:07AM -0700, Jakub Kicinski wrote:
> On Thu, 28 Oct 2021 15:55:34 +0100 Russell King (Oracle) wrote:
> > mvneta does not support asymetric pause modes, and it flags this by the
> > lack of AsymPause in the supported field. When setting pause modes, we
> > check that pause->rx_pause == pause->tx_pause, but only when pause
> > autoneg is enabled. When pause autoneg is disabled, we still allow
> > pause->rx_pause != pause->tx_pause, which is incorrect when the MAC
> > does not support asymetric pause, and causes mvneta to issue a warning.
> > 
> > Fix this by removing the test for pause->autoneg, so we always check
> > that pause->rx_pause == pause->tx_pause for network devices that do not
> > support AsymPause.
> 
> Fixes..?

If people care...

Fixes: 9525ae83959b ("phylink: add phylink infrastructure")

but since no one reported the issue, I'd be tempted not to backport
the patch until there's a need to do so. Especially as it's going
to have conflicts.

-- 
RMK's Patch system: https://www.armlinux.org.uk/developer/patches/
FTTP is here! 40Mbps down 10Mbps up. Decent connectivity at last!
