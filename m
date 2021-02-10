Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id B92203165AE
	for <lists+netdev@lfdr.de>; Wed, 10 Feb 2021 12:52:18 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231379AbhBJLvt (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 10 Feb 2021 06:51:49 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:35242 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231309AbhBJLtK (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 10 Feb 2021 06:49:10 -0500
Received: from pandora.armlinux.org.uk (pandora.armlinux.org.uk [IPv6:2001:4d48:ad52:32c8:5054:ff:fe00:142])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id AA8CCC06178A;
        Wed, 10 Feb 2021 03:48:29 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
        d=armlinux.org.uk; s=pandora-2019; h=Sender:In-Reply-To:Content-Type:
        MIME-Version:References:Message-ID:Subject:Cc:To:From:Date:Reply-To:
        Content-Transfer-Encoding:Content-ID:Content-Description:Resent-Date:
        Resent-From:Resent-Sender:Resent-To:Resent-Cc:Resent-Message-ID:List-Id:
        List-Help:List-Unsubscribe:List-Subscribe:List-Post:List-Owner:List-Archive;
         bh=Gp2DKKhcUEdkFH2/w8t4+OEnfirGu0ZMc0MmPkoqto4=; b=YqtwlJERpIkuk1znDOHDzKRLs
        Pcrvx7jY8eAvN7eDcd3dKhHW07NXAsx+EvIPNC0nr2RCj2gJljXO2CHo9MMYdjC1fVFxcsGUYIJN7
        I3b1Rp0I47t2QydLRAFBaWRTFI5aEay3By4Wsqe8hH4d8LQBkCEApqrXjQnhIFruLG4qzpTNxgCAE
        Rtts7UjzOOuGILNoga0let5YtHxDV1iTL3WM7MLAHLosi2X4YNmYPdfnh3UsBP8rVnKPlbZJgycsM
        hGcraKW8286u8D9OiRriAQbqiTJEZfTO5Q682ZzKZE7BfgiesLYS4pGNA6a1Cwvk/FUp22Dy064F3
        uk6OROsgw==;
Received: from shell.armlinux.org.uk ([fd8f:7570:feb6:1:5054:ff:fe00:4ec]:41588)
        by pandora.armlinux.org.uk with esmtpsa (TLS1.3:ECDHE_RSA_AES_256_GCM_SHA384:256)
        (Exim 4.92)
        (envelope-from <linux@armlinux.org.uk>)
        id 1l9nyt-0004cL-Iy; Wed, 10 Feb 2021 11:48:27 +0000
Received: from linux by shell.armlinux.org.uk with local (Exim 4.92)
        (envelope-from <linux@shell.armlinux.org.uk>)
        id 1l9nys-00052Q-Hb; Wed, 10 Feb 2021 11:48:26 +0000
Date:   Wed, 10 Feb 2021 11:48:26 +0000
From:   Russell King - ARM Linux admin <linux@armlinux.org.uk>
To:     Michael Walle <michael@walle.cc>
Cc:     Heiner Kallweit <hkallweit1@gmail.com>, netdev@vger.kernel.org,
        linux-kernel@vger.kernel.org, Andrew Lunn <andrew@lunn.ch>,
        "David S . Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>
Subject: Re: [PATCH net-next 7/9] net: phy: icplus: select page before
 writing control register
Message-ID: <20210210114826.GU1463@shell.armlinux.org.uk>
References: <20210209164051.18156-1-michael@walle.cc>
 <20210209164051.18156-8-michael@walle.cc>
 <d5672062-c619-02a4-3bbe-dad44371331d@gmail.com>
 <20210210103059.GR1463@shell.armlinux.org.uk>
 <d35f726f82c6c743519f3d8a36037dfa@walle.cc>
 <20210210104900.GS1463@shell.armlinux.org.uk>
 <3a9716ffafc632d2963d3eee673fb0b1@walle.cc>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <3a9716ffafc632d2963d3eee673fb0b1@walle.cc>
User-Agent: Mutt/1.10.1 (2018-07-13)
Sender: Russell King - ARM Linux admin <linux@armlinux.org.uk>
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Wed, Feb 10, 2021 at 12:14:35PM +0100, Michael Walle wrote:
> Am 2021-02-10 11:49, schrieb Russell King - ARM Linux admin:
> The PHY doesn't support fiber and register 0..15 are always available
> regardless of the selected page for the IP101G.
> 
> genphy_() stuff will work, but the IP101G PHY driver specific functions,
> like interrupt and mdix will break if someone is messing with the page
> register from userspace.
> 
> So Heiner's point was, that there are other PHY drivers which
> also break when a user changes registers from userspace and no one
> seemed to cared about that for now.
> 
> I guess it boils down to: how hard should we try to get the driver
> behave correctly if the user is changing registers. Or can we
> just make the assumption that if the PHY driver sets the page
> selection to its default, all the other callbacks will work
> on this page.

Provided the PHY driver uses the paged accessors for all paged
registers, userspace can't break the PHY driver because we have proper
locking in the paged accessors (I wrote them.) Userspace can access the
paged registers too, but there will be no locking other than on each
individual access. This can't be fixed without augmenting the kernel/
user API, and in any case is not a matter for the PHY driver.

So, let's stop worrying about the userspace paged access problem for
driver reviews; that's a core phylib and userspace API issue.

The paged accessor API is designed to allow the driver author to access
registers in the most efficient manner. There are two parts to it.

1) the phy_*_paged() accessors switch the page before accessing the
   register, and restore it afterwards. If you need to access a lot
   of paged registers, this can be inefficient.

2) phy_save_page()..phy_restore_page() allows wrapping of __phy_*
   accessors to access paged registers.

3) phy_select_page()..phy_restore_page() also allows wrapping of
   __phy_* accessors to access paged registers.

phy_save_page() and phy_select_page() must /always/ be paired with
a call to phy_restore_page(), since the former pair takes the bus lock
and the latter releases it.

(2) and (3) allow multiple accesses to either a single page without
constantly saving and restoring the page, and can also be used to
select other pages without the save/restore and locking steps. We
could export __phy_read_page() and __phy_write_page() if required.

While the bus lock is taken, userspace can't access any PHY on the bus.

-- 
RMK's Patch system: https://www.armlinux.org.uk/developer/patches/
FTTP is here! 40Mbps down 10Mbps up. Decent connectivity at last!
