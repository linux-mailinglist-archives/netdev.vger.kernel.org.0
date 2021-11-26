Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id DA19C45EE4C
	for <lists+netdev@lfdr.de>; Fri, 26 Nov 2021 13:52:26 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234445AbhKZMzb (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 26 Nov 2021 07:55:31 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:42230 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232999AbhKZMx3 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 26 Nov 2021 07:53:29 -0500
Received: from pandora.armlinux.org.uk (pandora.armlinux.org.uk [IPv6:2001:4d48:ad52:32c8:5054:ff:fe00:142])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 8C8D6C061D71;
        Fri, 26 Nov 2021 04:09:13 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
        d=armlinux.org.uk; s=pandora-2019; h=Sender:In-Reply-To:Content-Type:
        MIME-Version:References:Message-ID:Subject:Cc:To:From:Date:Reply-To:
        Content-Transfer-Encoding:Content-ID:Content-Description:Resent-Date:
        Resent-From:Resent-Sender:Resent-To:Resent-Cc:Resent-Message-ID:List-Id:
        List-Help:List-Unsubscribe:List-Subscribe:List-Post:List-Owner:List-Archive;
        bh=UP4o40WovA7VvfxJGeCFvSn5F8UzSAraxCMx7u1V3Yc=; b=V9aBUG9nLRQMWSYWkP6fNVUjCR
        kmHWbkMIrEfjPyGss+0DGQvjmNEkTVD4Z3RcjAev3qJ82+3pb67hhgit7sl8CNkJhWL+6U5Fzzwdf
        y8OuvJGWdnq011dm14Ct/OQPg5trCrEYw0THrtFtlxz+QCr5xckbB06LbRr0DAw+qNphVsUbYkp89
        Bx4CSevdfarvcS3Y/QCIrAyma/y/2bSpzAgsS0MwNOf1ht8oCDFMw6nV22SElNCBZuSHphjTkDRNP
        0g326QgJEwLT98u1GCk7xDXzzFZrgq3bwJkisMk2kucWs1QAir/F77SeBbdKggq2H5JwJtlVY2ffb
        gdXoZ3Fg==;
Received: from shell.armlinux.org.uk ([fd8f:7570:feb6:1:5054:ff:fe00:4ec]:55914)
        by pandora.armlinux.org.uk with esmtpsa  (TLS1.3) tls TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384
        (Exim 4.94.2)
        (envelope-from <linux@armlinux.org.uk>)
        id 1mqa2M-00031A-T9; Fri, 26 Nov 2021 12:09:06 +0000
Received: from linux by shell.armlinux.org.uk with local (Exim 4.94.2)
        (envelope-from <linux@shell.armlinux.org.uk>)
        id 1mqa2L-0003Fe-33; Fri, 26 Nov 2021 12:09:05 +0000
Date:   Fri, 26 Nov 2021 12:09:05 +0000
From:   "Russell King (Oracle)" <linux@armlinux.org.uk>
To:     Heiner Kallweit <hkallweit1@gmail.com>
Cc:     Horatiu Vultur <horatiu.vultur@microchip.com>, andrew@lunn.ch,
        davem@davemloft.net, kuba@kernel.org, netdev@vger.kernel.org,
        linux-kernel@vger.kernel.org
Subject: Re: [PATCH net-next] net: phy: micrel: Add config_init for LAN8814
Message-ID: <YaDOYc+RWZ35lKjB@shell.armlinux.org.uk>
References: <20211126103833.3609945-1-horatiu.vultur@microchip.com>
 <402780af-9d12-45dd-e435-e7279f1b9263@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <402780af-9d12-45dd-e435-e7279f1b9263@gmail.com>
Sender: Russell King (Oracle) <linux@armlinux.org.uk>
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Fri, Nov 26, 2021 at 12:57:33PM +0100, Heiner Kallweit wrote:
> Not directly related to just this patch:
> Did you consider implementing the read_page and write_page PHY driver
> callbacks? Then you could use phylib functions like phy_modify_paged et al
> and you wouldn't have to open-code the paged register operations.
> 
> I think write_page would just be
> phy_write(phydev, LAN_EXT_PAGE_ACCESS_CONTROL, page);
> phy_write(phydev, LAN_EXT_PAGE_ACCESS_ADDRESS_DATA, addr);
> phy_write(phydev, LAN_EXT_PAGE_ACCESS_CONTROL, (page | LAN_EXT_PAGE_ACCESS_CTRL_EP_FUNC));
> 
> and read_page
> phy_read(phydev, LAN_EXT_PAGE_ACCESS_CONTROL);

Remember that read_page() and write_page() must be implemented using
the unlocked accessors since the MDIO bus lock is held prior to calling
them. So these should be __phy_write() and __phy_read().

The use of the helpers you mention above also bring greater safety to
the read-modify-write accesses, since with these accessors, the whole
set of accesses are done while holding the bus lock.

Thanks.

-- 
RMK's Patch system: https://www.armlinux.org.uk/developer/patches/
FTTP is here! 40Mbps down 10Mbps up. Decent connectivity at last!
