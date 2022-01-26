Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id A0B0549CAC6
	for <lists+netdev@lfdr.de>; Wed, 26 Jan 2022 14:28:01 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S239492AbiAZN16 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 26 Jan 2022 08:27:58 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:43908 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232039AbiAZN16 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 26 Jan 2022 08:27:58 -0500
Received: from pandora.armlinux.org.uk (pandora.armlinux.org.uk [IPv6:2001:4d48:ad52:32c8:5054:ff:fe00:142])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 42133C06161C;
        Wed, 26 Jan 2022 05:27:57 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
        d=armlinux.org.uk; s=pandora-2019; h=Sender:In-Reply-To:Content-Type:
        MIME-Version:References:Message-ID:Subject:Cc:To:From:Date:Reply-To:
        Content-Transfer-Encoding:Content-ID:Content-Description:Resent-Date:
        Resent-From:Resent-Sender:Resent-To:Resent-Cc:Resent-Message-ID:List-Id:
        List-Help:List-Unsubscribe:List-Subscribe:List-Post:List-Owner:List-Archive;
        bh=ZAq7lphUj4ZBbT0ttD3I4ZX17HecYYp/WQ0M7GbtbZg=; b=eFfUhCblrGf2E9eacHO/gPRV0+
        zygiBNn0vwQXKqFymnCr9Q4qqkJ2UnBpzzmuIBdkSUViGWPMdfgBXbVWpq6hZELCjDLLtL5t8G17w
        /ZV8q0145pveahnMnBUbWiEUItdiWmGN7BuNEYfFqvMbF4wuWdvGPJaTrnGbLD3jblCcEj6q/ooH9
        9+lkEKoXdzlvBjgZzs3Enc591b7BaAKvn/woO0JrL2OLOrV0zzmFRTtZTNzaU+f4sYOD5rLEKD/Im
        DZzdEClcdv/5wAZHjt36yv8j8tu4rHShQ5D+avIeu9MkMsoOZENA2n8ypE1TMEU7KLbfJK7s2kuXK
        GQrBBiIA==;
Received: from shell.armlinux.org.uk ([fd8f:7570:feb6:1:5054:ff:fe00:4ec]:56888)
        by pandora.armlinux.org.uk with esmtpsa  (TLS1.3) tls TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384
        (Exim 4.94.2)
        (envelope-from <linux@armlinux.org.uk>)
        id 1nCiKu-0003K2-6Q; Wed, 26 Jan 2022 13:27:44 +0000
Received: from linux by shell.armlinux.org.uk with local (Exim 4.94.2)
        (envelope-from <linux@shell.armlinux.org.uk>)
        id 1nCiKk-0004VA-3N; Wed, 26 Jan 2022 13:27:34 +0000
Date:   Wed, 26 Jan 2022 13:27:34 +0000
From:   "Russell King (Oracle)" <linux@armlinux.org.uk>
To:     Jisheng Zhang <jszhang@kernel.org>
Cc:     Andrew Lunn <andrew@lunn.ch>,
        Giuseppe Cavallaro <peppe.cavallaro@st.com>,
        Alexandre Torgue <alexandre.torgue@foss.st.com>,
        Jose Abreu <joabreu@synopsys.com>,
        "David S . Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>,
        Maxime Coquelin <mcoquelin.stm32@gmail.com>,
        netdev@vger.kernel.org, linux-stm32@st-md-mailman.stormreply.com,
        linux-arm-kernel@lists.infradead.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH] net: stmmac: don't stop RXC during LPI
Message-ID: <YfFMRoLixWR/8spY@shell.armlinux.org.uk>
References: <20220123141245.1060-1-jszhang@kernel.org>
 <Ye15va7tFWMgKPEE@lunn.ch>
 <Ye19bHxcQ5Plx0v9@xhacker>
 <Ye2SznI2rNKAUDIq@lunn.ch>
 <YfFEulZJKzuRQfeG@xhacker>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <YfFEulZJKzuRQfeG@xhacker>
Sender: Russell King (Oracle) <linux@armlinux.org.uk>
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Wed, Jan 26, 2022 at 08:55:22PM +0800, Jisheng Zhang wrote:
> On Sun, Jan 23, 2022 at 06:39:26PM +0100, Andrew Lunn wrote:
> > > I think this is a common issue because the MAC needs phy's RXC for RX
> > > logic. But it's better to let other stmmac users verify. The issue
> > > can easily be reproduced on platforms with PHY_POLL external phy.
> > 
> > What is the relevance of PHY polling here? Are you saying if the PHY
> > is using interrupts you do not see this issue?
> 
> I tried these two days, if the PHY is using interrupts, I can't
> reproduce the issue. It looks a bit more complex. Any suggestions?

I suppose it could be that there is a delay between the PHY reporting
the link loss, raising an interrupt, which is then processed to disable
the receive side, and the PHY going into LPI. The problem with polling
is, well, it's polling, and at a one second rate - which probably is too
long between the PHY noticing the loss of link and going into LPI.

What this also probably means is that if interrupt latency is high
enough, the same problem will occur.

So maybe the EEE support to be a little more clever - so we only enable
clock stop after the MAC driver has disabled the receive side.

-- 
RMK's Patch system: https://www.armlinux.org.uk/developer/patches/
FTTP is here! 40Mbps down 10Mbps up. Decent connectivity at last!
