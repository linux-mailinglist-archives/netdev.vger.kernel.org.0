Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 9A4AE6A0565
	for <lists+netdev@lfdr.de>; Thu, 23 Feb 2023 10:55:43 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234170AbjBWJzl (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 23 Feb 2023 04:55:41 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:57372 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233497AbjBWJz1 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 23 Feb 2023 04:55:27 -0500
Received: from pandora.armlinux.org.uk (pandora.armlinux.org.uk [IPv6:2001:4d48:ad52:32c8:5054:ff:fe00:142])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 694605A39D;
        Thu, 23 Feb 2023 01:55:10 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
        d=armlinux.org.uk; s=pandora-2019; h=Sender:In-Reply-To:Content-Type:
        MIME-Version:References:Message-ID:Subject:Cc:To:From:Date:Reply-To:
        Content-Transfer-Encoding:Content-ID:Content-Description:Resent-Date:
        Resent-From:Resent-Sender:Resent-To:Resent-Cc:Resent-Message-ID:List-Id:
        List-Help:List-Unsubscribe:List-Subscribe:List-Post:List-Owner:List-Archive;
        bh=O7BaQvF+ZS0od31LkH/aM4xewR74xYOJkpqk9GRTgvo=; b=IAMcFx6idllv5exNqRXuuiB+cv
        T61XmIn5qBNZZrNPz5CTvD9OJkNuJAJnkL924x1ywrXMXS3X+YYUcOzQjg1OgihOqjJC559n7bGTm
        dG1LbO3HwVYyoOXk8l2PkEHyG1LJJDeff6MGkDUv/wTEfuyghsNfPHAfXt54rbfQU11SXv/aDdPcy
        J6MMWbf9RJFEmgO9mE7Rsy3HYLJ7RDmP3O1NtqTCVDEKwLhd7Acm5Mv2iBIf3kjF9Ksc2P0qzGt4P
        oJz69zLxThnhGZrdMnyvRsMYCxqPVAesGn1lL9MJwMhaMk0QkXu89BtNMingCAwUWt9Uxg1MoVnGv
        jex+EfOQ==;
Received: from shell.armlinux.org.uk ([fd8f:7570:feb6:1:5054:ff:fe00:4ec]:42824)
        by pandora.armlinux.org.uk with esmtpsa  (TLS1.3) tls TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384
        (Exim 4.94.2)
        (envelope-from <linux@armlinux.org.uk>)
        id 1pV8JZ-0007qT-Pb; Thu, 23 Feb 2023 09:55:01 +0000
Received: from linux by shell.armlinux.org.uk with local (Exim 4.94.2)
        (envelope-from <linux@shell.armlinux.org.uk>)
        id 1pV8JX-00044h-Cq; Thu, 23 Feb 2023 09:54:59 +0000
Date:   Thu, 23 Feb 2023 09:54:59 +0000
From:   "Russell King (Oracle)" <linux@armlinux.org.uk>
To:     Oleksij Rempel <o.rempel@pengutronix.de>
Cc:     Andrew Lunn <andrew@lunn.ch>,
        Heiner Kallweit <hkallweit1@gmail.com>,
        "David S. Miller" <davem@davemloft.net>,
        Eric Dumazet <edumazet@google.com>,
        Jakub Kicinski <kuba@kernel.org>,
        Paolo Abeni <pabeni@redhat.com>, kernel@pengutronix.de,
        linux-kernel@vger.kernel.org, netdev@vger.kernel.org
Subject: Re: [PATCH net v3 3/4] net: phy: do not force EEE support
Message-ID: <Y/c389xKmoJnSWnA@shell.armlinux.org.uk>
References: <20230222055043.113711-1-o.rempel@pengutronix.de>
 <20230222055043.113711-4-o.rempel@pengutronix.de>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20230222055043.113711-4-o.rempel@pengutronix.de>
Sender: Russell King (Oracle) <linux@armlinux.org.uk>
X-Spam-Status: No, score=-4.4 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_MED,SPF_HELO_NONE,
        SPF_NONE autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Wed, Feb 22, 2023 at 06:50:42AM +0100, Oleksij Rempel wrote:
> With following patches:
> commit 9b01c885be36 ("net: phy: c22: migrate to genphy_c45_write_eee_adv()")
> commit 5827b168125d ("net: phy: c45: migrate to genphy_c45_write_eee_adv()")
> 
> we set the advertisement to potentially supported values. This behavior
> may introduce new regressions on systems where EEE was disabled by
> default (BIOS or boot loader configuration or by other ways.)
> 
> At same time, with this patches, we would overwrite EEE advertisement
> configuration made over ethtool.
> 
> To avoid this issues, we need to cache initial and ethtool advertisement
> configuration and store it for later use.
> 
> Fixes: 9b01c885be36 ("net: phy: c22: migrate to genphy_c45_write_eee_adv()")
> Fixes: 5827b168125d ("net: phy: c45: migrate to genphy_c45_write_eee_adv()")
> Fixes: 022c3f87f88e ("net: phy: add genphy_c45_ethtool_get/set_eee() support")
> Signed-off-by: Oleksij Rempel <o.rempel@pengutronix.de>

Reviewed-by: Russell King (Oracle) <rmk+kernel@armlinux.org.uk>

Thanks!

-- 
RMK's Patch system: https://www.armlinux.org.uk/developer/patches/
FTTP is here! 40Mbps down 10Mbps up. Decent connectivity at last!
