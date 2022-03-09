Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 238B84D30E7
	for <lists+netdev@lfdr.de>; Wed,  9 Mar 2022 15:19:59 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232574AbiCIOTz (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 9 Mar 2022 09:19:55 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:55412 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232063AbiCIOTy (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 9 Mar 2022 09:19:54 -0500
Received: from pandora.armlinux.org.uk (pandora.armlinux.org.uk [IPv6:2001:4d48:ad52:32c8:5054:ff:fe00:142])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id B9554BB0A0
        for <netdev@vger.kernel.org>; Wed,  9 Mar 2022 06:18:53 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
        d=armlinux.org.uk; s=pandora-2019; h=Sender:In-Reply-To:Content-Type:
        MIME-Version:References:Message-ID:Subject:Cc:To:From:Date:Reply-To:
        Content-Transfer-Encoding:Content-ID:Content-Description:Resent-Date:
        Resent-From:Resent-Sender:Resent-To:Resent-Cc:Resent-Message-ID:List-Id:
        List-Help:List-Unsubscribe:List-Subscribe:List-Post:List-Owner:List-Archive;
        bh=ifRGWr1umLtvonEG/HbluMF/Dz9MoNH6zVKBDbzB+iY=; b=hqmkH0/ufNym4gw2fIvwkOoH79
        f3Q6jiHCMH6oPgHuNgJZV3SArVpSx9wmCTTtTPk4eIwHFaXWWKsdzfUxqjsjxgrn3AnnJqTPsQoor
        IW+bO2wkMPUwZHFshL7JrE4l1gtLl58rqB3AS+4IXO9qY7EuxXj9/lTnK8zZIxNI8wrmQSw3F7Ozy
        jJVcT4n5L2xKjXJ6tNFkApoWmfpaNKOGOGp++FHzRO4ZJK52hurR05zYrPVLCQWjviLWmzmDGVd2J
        XkrYaQ8qQeG6xNz2dLHPvxVeFFN8ZSsYhrtTKog3hOM64AjcvlKdPu5HuwAhdCBqfe0Ro+F0Cv7AW
        zYABzoKQ==;
Received: from shell.armlinux.org.uk ([fd8f:7570:feb6:1:5054:ff:fe00:4ec]:57740)
        by pandora.armlinux.org.uk with esmtpsa  (TLS1.3) tls TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384
        (Exim 4.94.2)
        (envelope-from <linux@armlinux.org.uk>)
        id 1nRx9O-0001vN-KI; Wed, 09 Mar 2022 14:18:50 +0000
Received: from linux by shell.armlinux.org.uk with local (Exim 4.94.2)
        (envelope-from <linux@shell.armlinux.org.uk>)
        id 1nRx9M-00080e-Tp; Wed, 09 Mar 2022 14:18:48 +0000
Date:   Wed, 9 Mar 2022 14:18:48 +0000
From:   "Russell King (Oracle)" <linux@armlinux.org.uk>
To:     Vladimir Oltean <olteanv@gmail.com>
Cc:     Andrew Lunn <andrew@lunn.ch>,
        Heiner Kallweit <hkallweit1@gmail.com>,
        "David S. Miller" <davem@davemloft.net>, netdev@vger.kernel.org,
        Vivien Didelot <vivien.didelot@gmail.com>,
        Florian Fainelli <f.fainelli@gmail.com>,
        Jakub Kicinski <kuba@kernel.org>
Subject: Re: [PATCH net] net: dsa: silence fdb errors when unsupported
Message-ID: <Yii3SH7/mF7QmXO1@shell.armlinux.org.uk>
References: <E1nRtfI-00EnmD-I8@rmk-PC.armlinux.org.uk>
 <20220309104143.gmoks5aceq3dtmci@skbuf>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20220309104143.gmoks5aceq3dtmci@skbuf>
Sender: Russell King (Oracle) <linux@armlinux.org.uk>
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,SPF_HELO_NONE,SPF_NONE,
        T_SCC_BODY_TEXT_LINE autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Wed, Mar 09, 2022 at 12:41:43PM +0200, Vladimir Oltean wrote:
> Hello Russell,
> 
> On Wed, Mar 09, 2022 at 10:35:32AM +0000, Russell King (Oracle) wrote:
> > When booting with a Marvell 88e6xxx switch, the kernel spits out a
> > load of:
> > 
> > [    7.820996] mv88e6085 f1072004.mdio-mii:04: port 3 failed to add aa:bb:cc:dd:ee:ff vid XYZ1 to fdb: -95
> > [    7.835717] mv88e6085 f1072004.mdio-mii:04: port 2 failed to add aa:bb:cc:dd:ee:ff vid XYZ1 to fdb: -95
> > [    7.851090] mv88e6085 f1072004.mdio-mii:04: port 1 failed to add aa:bb:cc:dd:ee:ff vid XYZ1 to fdb: -95
> > [    7.968594] mv88e6085 f1072004.mdio-mii:04: port 0 failed to add aa:bb:cc:dd:ee:ff vid XYZ1 to fdb: -95
> > [    8.035408] mv88e6085 f1072004.mdio-mii:04: port 3 failed to add aa:bb:cc:dd:ee:ff vid XYZ3 to fdb: -95
> > 
> > while the switch is being setup. Comments in the Marvell DSA driver
> > indicate that "switchdev expects -EOPNOTSUPP to honor software VLANs"
> > in mv88e6xxx_port_db_load_purge() so this error code should not be
> > treated as an error.
> > 
> > Fixes: 3dc80afc5098 ("net: dsa: introduce a separate cross-chip notifier type for host FDBs")
> > Signed-off-by: Russell King (Oracle) <rmk+kernel@armlinux.org.uk>
> > ---
> > Hi,
> > 
> > I noticed these errors booting 5.16 on my Clearfog platforms with a
> > Marvell DSA switch. It appears that the switch continues to work
> > even though these errors are logged in the kernel log, so this patch
> > merely silences the errors, but I'm unsure this is the right thing
> > to do.
> 
> Can you please confirm that these errors have disappeared on net-next?

net-next: no warnings
v5.17-rc7: warnings
v5.16: warnings

So, it looks like we need a patch for 5.17-rc7 and 5.16-stable to fix
this. Do you have a better suggestion than my patch?

Thanks.

-- 
RMK's Patch system: https://www.armlinux.org.uk/developer/patches/
FTTP is here! 40Mbps down 10Mbps up. Decent connectivity at last!
