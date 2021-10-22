Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 13CE7437AD0
	for <lists+netdev@lfdr.de>; Fri, 22 Oct 2021 18:19:24 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233506AbhJVQVf (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 22 Oct 2021 12:21:35 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:51420 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233186AbhJVQVe (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 22 Oct 2021 12:21:34 -0400
Received: from pandora.armlinux.org.uk (pandora.armlinux.org.uk [IPv6:2001:4d48:ad52:32c8:5054:ff:fe00:142])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 0C677C061766;
        Fri, 22 Oct 2021 09:19:17 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
        d=armlinux.org.uk; s=pandora-2019; h=Sender:In-Reply-To:Content-Type:
        MIME-Version:References:Message-ID:Subject:Cc:To:From:Date:Reply-To:
        Content-Transfer-Encoding:Content-ID:Content-Description:Resent-Date:
        Resent-From:Resent-Sender:Resent-To:Resent-Cc:Resent-Message-ID:List-Id:
        List-Help:List-Unsubscribe:List-Subscribe:List-Post:List-Owner:List-Archive;
        bh=p70ruyvhHRYAaHqChjEXVRdKnpHTu1S59qwnsWDPDYk=; b=JrgeCX3TqVZF6XykSLym2IQiJd
        C/rdEveKTW+1qKmBz2N0acE5hlijigcE+Wz1Z1rCmup4cKXde9qIY+/XKkkNGqJIC7/SEZdI17Mtv
        7yNRJkQ3Wtxt78l20h0McH5tq+FvozIr0vaQ7hlJuHx3hoVLGe2mSfsUU2dpSb4CCMaTt4mqbAgNQ
        MNPiYmAZrolbST4LElmbyKhq3uI9PjQM6tNh+1Dvm4BFyF3uDI4MuhuktZJyOcPJQ8nwnUBuvF7LG
        NdFcY+LLHJcuT0PgoknJ28VVKSxYNmJErkZurbJVvQ0/mLTTPfBDwfNRWnheFgMDF382dU3HGUdiP
        86S9oFIQ==;
Received: from shell.armlinux.org.uk ([fd8f:7570:feb6:1:5054:ff:fe00:4ec]:55242)
        by pandora.armlinux.org.uk with esmtpsa  (TLS1.3) tls TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384
        (Exim 4.94.2)
        (envelope-from <linux@armlinux.org.uk>)
        id 1mdxGF-0001w8-45; Fri, 22 Oct 2021 17:19:15 +0100
Received: from linux by shell.armlinux.org.uk with local (Exim 4.94.2)
        (envelope-from <linux@shell.armlinux.org.uk>)
        id 1mdxGE-0001J7-D5; Fri, 22 Oct 2021 17:19:14 +0100
Date:   Fri, 22 Oct 2021 17:19:14 +0100
From:   "Russell King (Oracle)" <linux@armlinux.org.uk>
To:     Sean Anderson <sean.anderson@seco.com>
Cc:     netdev@vger.kernel.org, Andrew Lunn <andrew@lunn.ch>,
        linux-kernel@vger.kernel.org,
        Heiner Kallweit <hkallweit1@gmail.com>,
        Jakub Kicinski <kuba@kernel.org>,
        "David S . Miller" <davem@davemloft.net>
Subject: Re: [net-next PATCH v2] net: phylink: Add helpers for c22 registers
 without MDIO
Message-ID: <YXLkgr9wd3nkno9K@shell.armlinux.org.uk>
References: <20211022160959.3350916-1-sean.anderson@seco.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20211022160959.3350916-1-sean.anderson@seco.com>
Sender: Russell King (Oracle) <linux@armlinux.org.uk>
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Fri, Oct 22, 2021 at 12:09:59PM -0400, Sean Anderson wrote:
> Some devices expose memory-mapped c22-compliant PHYs. Because these
> devices do not have an MDIO bus, we cannot use the existing helpers.
> Refactor the existing helpers to allow supplying the values for c22
> registers directly, instead of using MDIO to access them. Only get_state
> and set_advertisement are converted, since they contain the most complex
> logic. Because set_advertisement is never actually used outside
> phylink_mii_c22_pcs_config, move the MDIO-writing part into that
> function. Because some modes do not need the advertisement register set
> at all, we use -EINVAL for this purpose.
> 
> Additionally, a new function phylink_pcs_enable_an is provided to
> determine whether to enable autonegotiation.
> 
> Signed-off-by: Sean Anderson <sean.anderson@seco.com>

Thanks!

Reviewed-by: Russell King (Oracle) <rmk+kernel@armlinux.org.uk>

> ---
> This series was originally submitted as [1]. Although does not include
> its intended user (macb), I have submitted it separately at the behest
> of Russel. This series depends on [2].

It has uses for the Marvell DSA code, specifically 88E6352 where the
"serdes" PCS needs to be accessed using the PHY's fiber page, and
thus needs to use unlocked accesses to the BMCR/BMSR/LPA registers.

-- 
RMK's Patch system: https://www.armlinux.org.uk/developer/patches/
FTTP is here! 40Mbps down 10Mbps up. Decent connectivity at last!
