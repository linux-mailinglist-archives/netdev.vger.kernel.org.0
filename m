Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 4FA9053E32E
	for <lists+netdev@lfdr.de>; Mon,  6 Jun 2022 10:55:40 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231802AbiFFI0H (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 6 Jun 2022 04:26:07 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:51922 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231664AbiFFI0G (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 6 Jun 2022 04:26:06 -0400
Received: from pandora.armlinux.org.uk (pandora.armlinux.org.uk [IPv6:2001:4d48:ad52:32c8:5054:ff:fe00:142])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 7000D522C5;
        Mon,  6 Jun 2022 01:26:03 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
        d=armlinux.org.uk; s=pandora-2019; h=Sender:In-Reply-To:Content-Type:
        MIME-Version:References:Message-ID:Subject:Cc:To:From:Date:Reply-To:
        Content-Transfer-Encoding:Content-ID:Content-Description:Resent-Date:
        Resent-From:Resent-Sender:Resent-To:Resent-Cc:Resent-Message-ID:List-Id:
        List-Help:List-Unsubscribe:List-Subscribe:List-Post:List-Owner:List-Archive;
        bh=qf/LAFvNlOZVyndVIbBrukqYfRWVajDnK78SGRSwEJo=; b=H2FERXgpXpa7C+nugyVBaR1JiZ
        o3ovvx4Akac7TCMAgXrgBFFZD5S/+hPpIasexaVYhrp2D78wpUErfayQ3h58BjJ/gFvIgKwhM86z6
        RqIj7YcqZ9uu+urk+ekmeRFuj1XnYPWzH0xIhTyF8pcReJmS++zL8HRkf6O5Y6Z527EbbyB+GTYL+
        s2X6HtLpWIF47v0Xcs6HhmvZSFtNMzKV5haLHKFwRGcS6j46TQeoCbtwnK97OFOeE9ikSQ51JsX0H
        7HyUxfBKjlBE9i6g08lXt67GpeOYxI+8SIO/RhlhT0Z2bI2PX5reUJAICmNCSKBRERr7gzWlwqvkK
        tR4NiSPw==;
Received: from shell.armlinux.org.uk ([fd8f:7570:feb6:1:5054:ff:fe00:4ec]:60962)
        by pandora.armlinux.org.uk with esmtpsa  (TLS1.3) tls TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384
        (Exim 4.94.2)
        (envelope-from <linux@armlinux.org.uk>)
        id 1ny83e-0001c2-HH; Mon, 06 Jun 2022 09:25:54 +0100
Received: from linux by shell.armlinux.org.uk with local (Exim 4.94.2)
        (envelope-from <linux@shell.armlinux.org.uk>)
        id 1ny83b-00084b-DH; Mon, 06 Jun 2022 09:25:51 +0100
Date:   Mon, 6 Jun 2022 09:25:51 +0100
From:   "Russell King (Oracle)" <linux@armlinux.org.uk>
To:     Masahiro Yamada <masahiroy@kernel.org>
Cc:     "David S . Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>, netdev@vger.kernel.org,
        Eric Dumazet <edumazet@google.com>,
        Paolo Abeni <pabeni@redhat.com>,
        Stephen Rothwell <sfr@canb.auug.org.au>,
        Andrew Lunn <andrew@lunn.ch>,
        Florian Fainelli <f.fainelli@gmail.com>,
        Heiner Kallweit <hkallweit1@gmail.com>,
        linux-kernel@vger.kernel.org
Subject: Re: [PATCH 1/3] net: mdio: unexport __init-annotated mdio_bus_init()
Message-ID: <Yp26Dw3f8+XlSx2+@shell.armlinux.org.uk>
References: <20220606045355.4160711-1-masahiroy@kernel.org>
 <20220606045355.4160711-2-masahiroy@kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20220606045355.4160711-2-masahiroy@kernel.org>
Sender: Russell King (Oracle) <linux@armlinux.org.uk>
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,SPF_HELO_NONE,SPF_NONE,
        T_SCC_BODY_TEXT_LINE autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Mon, Jun 06, 2022 at 01:53:53PM +0900, Masahiro Yamada wrote:
> EXPORT_SYMBOL and __init is a bad combination because the .init.text
> section is freed up after the initialization. Hence, modules cannot
> use symbols annotated __init. The access to a freed symbol may end up
> with kernel panic.
> 
> modpost used to detect it, but it has been broken for a decade.
> 
> Recently, I fixed modpost so it started to warn it again, then this
> showed up in linux-next builds.
> 
> There are two ways to fix it:
> 
>   - Remove __init
>   - Remove EXPORT_SYMBOL
> 
> I chose the latter for this case because the only in-tree call-site,
> drivers/net/phy/phy_device.c is never compiled as modular.
> (CONFIG_PHYLIB is boolean)
> 
> Fixes: 90eff9096c01 ("net: phy: Allow splitting MDIO bus/device support from PHYs")
> Reported-by: Stephen Rothwell <sfr@canb.auug.org.au>
> Signed-off-by: Masahiro Yamada <masahiroy@kernel.org>

Reviewed-by: Russell King (Oracle) <rmk+kernel@armlinux.org.uk>

Thanks!

-- 
RMK's Patch system: https://www.armlinux.org.uk/developer/patches/
FTTP is here! 40Mbps down 10Mbps up. Decent connectivity at last!
