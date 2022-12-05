Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 2DA6F642DF5
	for <lists+netdev@lfdr.de>; Mon,  5 Dec 2022 17:53:08 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232444AbiLEQxC (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 5 Dec 2022 11:53:02 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:47180 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232317AbiLEQwM (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 5 Dec 2022 11:52:12 -0500
Received: from pandora.armlinux.org.uk (pandora.armlinux.org.uk [IPv6:2001:4d48:ad52:32c8:5054:ff:fe00:142])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id E9BBE9FFA
        for <netdev@vger.kernel.org>; Mon,  5 Dec 2022 08:50:48 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
        d=armlinux.org.uk; s=pandora-2019; h=Sender:In-Reply-To:Content-Type:
        MIME-Version:References:Message-ID:Subject:Cc:To:From:Date:Reply-To:
        Content-Transfer-Encoding:Content-ID:Content-Description:Resent-Date:
        Resent-From:Resent-Sender:Resent-To:Resent-Cc:Resent-Message-ID:List-Id:
        List-Help:List-Unsubscribe:List-Subscribe:List-Post:List-Owner:List-Archive;
        bh=XgtEcCNj5a4chpWpnx9taUp2f6wVhBTCXWlZjttN1lU=; b=akBMqRjWfJmIBzj5I2UjBkqpSf
        RQQBTMTCH8Wu+i9bGYRlKeNQGneJqhp0ZYc4To655NGB8rhaDLXk9EbLU0mrRgYXSXtDfBHMT3en6
        cbv2heX1VBiQurbJLc2ZHFQnivBewi5DL+OAb4gkeHqGLAEUH03ZBhkv1WA/JaJx/zNoli5zlpW9r
        pXhs8y+JT9G7lIIUGefSIOF+WAM6Scj8D5W/fopcob0I3rskNNkPLzt/runho9UNPXng1Zct6BZwV
        cQwrY7AUWAfEAhsezj/bveE0R7ugjitCKxkqBu4X6kQ3VAIG9VqfJjydaFlq9JhCiHuJ6k44/ueEF
        nyl9mW5g==;
Received: from shell.armlinux.org.uk ([fd8f:7570:feb6:1:5054:ff:fe00:4ec]:35584)
        by pandora.armlinux.org.uk with esmtpsa  (TLS1.3) tls TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384
        (Exim 4.94.2)
        (envelope-from <linux@armlinux.org.uk>)
        id 1p2Eg2-0006yp-6w; Mon, 05 Dec 2022 16:50:46 +0000
Received: from linux by shell.armlinux.org.uk with local (Exim 4.94.2)
        (envelope-from <linux@shell.armlinux.org.uk>)
        id 1p2Eg0-0007Ol-EH; Mon, 05 Dec 2022 16:50:44 +0000
Date:   Mon, 5 Dec 2022 16:50:44 +0000
From:   "Russell King (Oracle)" <linux@armlinux.org.uk>
To:     Andrew Lunn <andrew@lunn.ch>
Cc:     netdev <netdev@vger.kernel.org>,
        Sean Anderson <sean.anderson@seco.com>,
        Heiner Kallweit <hkallweit1@gmail.com>
Subject: Re: [PATCH net-next] net: phy: swphy: Support all normal speeds when
 link down
Message-ID: <Y44hZBHkP7yZSKFx@shell.armlinux.org.uk>
References: <20221204174103.1033005-1-andrew@lunn.ch>
 <Y44WhXU+Lq+MEM7A@shell.armlinux.org.uk>
 <Y44f4/volEMs+0Uo@lunn.ch>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <Y44f4/volEMs+0Uo@lunn.ch>
Sender: Russell King (Oracle) <linux@armlinux.org.uk>
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,SPF_HELO_NONE,SPF_NONE
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Mon, Dec 05, 2022 at 05:44:19PM +0100, Andrew Lunn wrote:
> On Mon, Dec 05, 2022 at 04:04:21PM +0000, Russell King (Oracle) wrote:
> > On Sun, Dec 04, 2022 at 06:41:03PM +0100, Andrew Lunn wrote:
> > > The software PHY emulator validation function is happy to accept any
> > > link speed if the link is down. swphy_read_reg() however triggers a
> > > WARN_ON(). Change this to report all the standard 1G link speeds are
> > > supported. Once the speed is known the supported link modes will
> > > change, which is a bit odd, but for emulation is probably O.K.
> > > 
> > > Suggested-by: Russell King (Oracle) <linux@armlinux.org.uk>
> > 
> > This isn't what I suggested. I suggested restoring the old behaviour of
> > fixed_phy before commit 5ae68b0ce134 ("phy: move fixed_phy MII register
> > generation to a library") which did _not_ report all speeds, but
> > reported no supported speeds in BMSR.
> 
> O.K.
> 
> Which is better. No speeds, or all speeds? I think all speeds is more
> like what a real PHY does.

We have a precedent for reporting no speeds - that's the behaviour of
fixed_phy before the above mentioned commit. So, if it was good enough
for many years of fixed_phy, shouldn't it still be good enough?

I guess it ultimately depends how those ethernet drivers making use
of fixed_phy with phylib end up behaving - will phylib operate
correctly, or does it read the BMSR and ESTATUS to determine the
speeds now, but didn't before?

-- 
RMK's Patch system: https://www.armlinux.org.uk/developer/patches/
FTTP is here! 40Mbps down 10Mbps up. Decent connectivity at last!
