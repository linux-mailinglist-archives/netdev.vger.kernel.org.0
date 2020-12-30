Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 173812E7C2E
	for <lists+netdev@lfdr.de>; Wed, 30 Dec 2020 20:40:59 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726388AbgL3Tk0 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 30 Dec 2020 14:40:26 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:44558 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726247AbgL3TkZ (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 30 Dec 2020 14:40:25 -0500
Received: from pandora.armlinux.org.uk (pandora.armlinux.org.uk [IPv6:2001:4d48:ad52:32c8:5054:ff:fe00:142])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 63B13C061573;
        Wed, 30 Dec 2020 11:39:45 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
        d=armlinux.org.uk; s=pandora-2019; h=Sender:In-Reply-To:Content-Type:
        MIME-Version:References:Message-ID:Subject:Cc:To:From:Date:Reply-To:
        Content-Transfer-Encoding:Content-ID:Content-Description:Resent-Date:
        Resent-From:Resent-Sender:Resent-To:Resent-Cc:Resent-Message-ID:List-Id:
        List-Help:List-Unsubscribe:List-Subscribe:List-Post:List-Owner:List-Archive;
         bh=qV7ZUQ6rORlcabRv1wkqp9ROeOheZpX38ZbpFhhVfic=; b=yr/q4ovVclV3pqujqTJzuUVfD
        KN/ztVt6pZyCB0M/O00/H7JDNpnZt5YJaeUsszl7m5CdEpxLr4ICD/AhcHVC6yZloVQbSAddlcipA
        jCDsy7yvIAI+O/VwiPTNy+PSrx6g2ftriBPzBkz3Q5Gq3nO/c+7/dhR4+2C00r2aWYU700xFg2pSH
        Fd0I1oX90DGQ3t0CJjLQ9XfOQUEraBcGYq4TRCVLF9CtxUSjjwe/Tk7D7Yc+yD/7YeBWp2CsJAR/o
        UEFnmfXG+1fCU/sL+jo912vo5vcSp6rNvh9W01yiFpZIbMf9CIGwo7uxYel/uMBptbGeBGkee5CEw
        uGMhQUyHA==;
Received: from shell.armlinux.org.uk ([fd8f:7570:feb6:1:5054:ff:fe00:4ec]:44932)
        by pandora.armlinux.org.uk with esmtpsa (TLS1.3:ECDHE_RSA_AES_256_GCM_SHA384:256)
        (Exim 4.92)
        (envelope-from <linux@armlinux.org.uk>)
        id 1kuhJs-0005uV-Mg; Wed, 30 Dec 2020 19:39:40 +0000
Received: from linux by shell.armlinux.org.uk with local (Exim 4.92)
        (envelope-from <linux@shell.armlinux.org.uk>)
        id 1kuhJr-0002SN-WD; Wed, 30 Dec 2020 19:39:40 +0000
Date:   Wed, 30 Dec 2020 19:39:39 +0000
From:   Russell King - ARM Linux admin <linux@armlinux.org.uk>
To:     Andrew Lunn <andrew@lunn.ch>
Cc:     Pali =?iso-8859-1?Q?Roh=E1r?= <pali@kernel.org>,
        Heiner Kallweit <hkallweit1@gmail.com>,
        "David S. Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>,
        Marek =?iso-8859-1?Q?Beh=FAn?= <kabel@kernel.org>,
        netdev@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH 1/4] net: sfp: add workaround for Realtek RTL8672 and
 RTL9601C chips
Message-ID: <20201230193939.GZ1551@shell.armlinux.org.uk>
References: <20201230154755.14746-1-pali@kernel.org>
 <20201230154755.14746-2-pali@kernel.org>
 <20201230161036.GR1551@shell.armlinux.org.uk>
 <20201230165634.c4ty3mw6djezuyq6@pali>
 <20201230170546.GU1551@shell.armlinux.org.uk>
 <X+y1K21tp01GpvMy@lunn.ch>
 <20201230174307.lvehswvj5q6c6vk3@pali>
 <X+zVbM2vetCpiIFG@lunn.ch>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <X+zVbM2vetCpiIFG@lunn.ch>
User-Agent: Mutt/1.10.1 (2018-07-13)
Sender: Russell King - ARM Linux admin <linux@armlinux.org.uk>
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Wed, Dec 30, 2020 at 08:30:52PM +0100, Andrew Lunn wrote:
> > Ok!
> > 
> > So should we completely skip hwmon_device_register_with_info() call
> > if (i2c_block_size < 2) ?
> 
> Yep. That would be a nice simple test.
> 
> But does ethtool -m still export the second page? That is also
> unreliable.

It will do, but we need to check how ethtool decides to request/dump
that information - we probably need to make sfp_module_info()
report that it's a ETH_MODULE_SFF_8079 style EEPROM, not the
ETH_MODULE_SFF_8472 style.

-- 
RMK's Patch system: https://www.armlinux.org.uk/developer/patches/
FTTP is here! 40Mbps down 10Mbps up. Decent connectivity at last!
