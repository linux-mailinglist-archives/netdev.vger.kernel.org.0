Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 2A52E42239C
	for <lists+netdev@lfdr.de>; Tue,  5 Oct 2021 12:33:34 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234013AbhJEKfU (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 5 Oct 2021 06:35:20 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:45784 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233490AbhJEKfT (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 5 Oct 2021 06:35:19 -0400
Received: from pandora.armlinux.org.uk (pandora.armlinux.org.uk [IPv6:2001:4d48:ad52:32c8:5054:ff:fe00:142])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 009B4C06161C;
        Tue,  5 Oct 2021 03:33:28 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
        d=armlinux.org.uk; s=pandora-2019; h=Sender:In-Reply-To:Content-Type:
        MIME-Version:References:Message-ID:Subject:Cc:To:From:Date:Reply-To:
        Content-Transfer-Encoding:Content-ID:Content-Description:Resent-Date:
        Resent-From:Resent-Sender:Resent-To:Resent-Cc:Resent-Message-ID:List-Id:
        List-Help:List-Unsubscribe:List-Subscribe:List-Post:List-Owner:List-Archive;
        bh=kT0Hjr/F9NQrOS6/YDbtKD9/7NDOpyJOJCXmfpl4TQY=; b=sAozXbhwy6ljtDTsQq6amThNlY
        HnVkHvaEeJCEe0cJDtdlEe1tzejoJP4C5YZ8ndryKD7f78Tg/fxa1C34ciWHUZEjHpCVeLfHaTXyT
        36fnMw6UtlydkRd8fT1FXHgZ9n9NavNLrusL09kYe1OU+bRvvKatFQkGrLCyHpS7a6Gi1aFAyKeLr
        SI9gaL5EulVjCI+MM2EUbOgL/Ab1K/AihTz+QYIi5b7Q69A7pQ5AFioocV5gRxUXp93Nnh0pPwq1i
        DQpQksVuweSFVnOmT9U1cqBMgT3/G1hfueSiYDMnchwfpnsx+c1rJr8VhbVnpFWJzr+ZyKAQzDzrD
        aiC3/jzA==;
Received: from shell.armlinux.org.uk ([fd8f:7570:feb6:1:5054:ff:fe00:4ec]:54954)
        by pandora.armlinux.org.uk with esmtpsa  (TLS1.3) tls TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384
        (Exim 4.94.2)
        (envelope-from <linux@armlinux.org.uk>)
        id 1mXhlG-000095-Lh; Tue, 05 Oct 2021 11:33:26 +0100
Received: from linux by shell.armlinux.org.uk with local (Exim 4.94.2)
        (envelope-from <linux@shell.armlinux.org.uk>)
        id 1mXhlF-0008OZ-L9; Tue, 05 Oct 2021 11:33:25 +0100
Date:   Tue, 5 Oct 2021 11:33:25 +0100
From:   "Russell King (Oracle)" <linux@armlinux.org.uk>
To:     Sean Anderson <sean.anderson@seco.com>
Cc:     netdev@vger.kernel.org, "David S . Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>, linux-kernel@vger.kernel.org,
        Andrew Lunn <andrew@lunn.ch>,
        Heiner Kallweit <hkallweit1@gmail.com>
Subject: Re: [RFC net-next PATCH 16/16] net: sfp: Add quirk to ignore PHYs
Message-ID: <YVwp9R40r0ZWJzTa@shell.armlinux.org.uk>
References: <20211004191527.1610759-1-sean.anderson@seco.com>
 <20211004191527.1610759-17-sean.anderson@seco.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20211004191527.1610759-17-sean.anderson@seco.com>
Sender: Russell King (Oracle) <linux@armlinux.org.uk>
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Mon, Oct 04, 2021 at 03:15:27PM -0400, Sean Anderson wrote:
> Some modules have something at SFP_PHY_ADDR which isn't a PHY. If we try to
> probe it, we might attach genphy anyway if addresses 2 and 3 return
> something other than all 1s. To avoid this, add a quirk for these modules
> so that we do not probe their PHY.
> 
> The particular module in this case is a Finisar SFP-GB-GE-T. This module is
> also worked around in xgbe_phy_finisar_phy_quirks() by setting the support
> manually. However, I do not believe that it has a PHY in the first place:
> 
> $ i2cdump -y -r 0-31 $BUS 0x56 w
>      0,8  1,9  2,a  3,b  4,c  5,d  6,e  7,f
> 00: ff01 ff01 ff01 c20c 010c 01c0 0f00 0120
> 08: fc48 000e ff78 0000 0000 0000 0000 00f0
> 10: 7800 00bc 0000 401c 680c 0300 0000 0000
> 18: ff41 0000 0a00 8890 0000 0000 0000 0000

Actually, I think that is a PHY. It's byteswapped (which is normal using
i2cdump in this way). The real contents of the registers are:

00: 01ff 01ff 01ff 0cc2 0c01 c001 000f 2001
08: 48fc 0e00 78ff 0000 0000 0000 0000 f000
10: 0078 bc00 0000 1c40 0c68 0003 0000 0000
18: 41ff 0000 000a 9088 0000 0000 0000 0000

It's advertising pause + asym pause, 1000BASE-T FD, link partner is also
advertising 1000BASE-T FD but no pause abilities.

When comparing this with a Marvell 88e1111:

00: 1140 7949 0141 0cc2 05e1 0000 0004 2001
08: 0000 0e00 4000 0000 0000 0000 0000 f000
10: 0078 8100 0000 0040 0568 0000 0000 0000
18: 4100 0000 0002 8084 0000 0000 0000 0000

It looks remarkably similar. However, The first few reads seem to be
corrupted with 0x01ff. It may be that the module is slow to allow the
PHY to start responding - we've had similar with Champion One SFPs.

It looks like it's a Marvell 88e1111. The register at 0x11 is the
Marvell status register, and 0xbc00 indicates 1000Mbit, FD, AN
resolved, link up which agrees with what's in the various other
registers.

-- 
RMK's Patch system: https://www.armlinux.org.uk/developer/patches/
FTTP is here! 40Mbps down 10Mbps up. Decent connectivity at last!
