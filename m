Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id E760A4ED886
	for <lists+netdev@lfdr.de>; Thu, 31 Mar 2022 13:32:08 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233491AbiCaLdt (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 31 Mar 2022 07:33:49 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:40302 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232647AbiCaLdt (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 31 Mar 2022 07:33:49 -0400
Received: from pandora.armlinux.org.uk (pandora.armlinux.org.uk [IPv6:2001:4d48:ad52:32c8:5054:ff:fe00:142])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 0D9AB16BCF6;
        Thu, 31 Mar 2022 04:32:02 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
        d=armlinux.org.uk; s=pandora-2019; h=Sender:In-Reply-To:Content-Type:
        MIME-Version:References:Message-ID:Subject:Cc:To:From:Date:Reply-To:
        Content-Transfer-Encoding:Content-ID:Content-Description:Resent-Date:
        Resent-From:Resent-Sender:Resent-To:Resent-Cc:Resent-Message-ID:List-Id:
        List-Help:List-Unsubscribe:List-Subscribe:List-Post:List-Owner:List-Archive;
        bh=is2hfnm658tQQV/yE96Ye3wvp2HVc9uQBLKKmPWpOMc=; b=dpVa/bTWDFWOCs6jBoHfle55D+
        KFgmOlVmklNh2Krrqrwi8hqvDEDithDC4lS2WeEOjbS8nTPidVm4/N3HHWt3tuRWSnUBsdwvRxnrt
        vD4zxHsyvsTPHLPrcIVyESd0xvDjncd2grKUTEtAqIzilhbPMaqbDcqELHWZY+cRhCOgYb08GXvVe
        kgJzPxauCblhGjHEzWfpH/pnMMUkLYpfxTx3oxr5j4r7WIgAKLECyMUbmeBgTuxKCyMafqJs/MCK4
        8Uf1ZMukEph7Z0fmGFwps3MOP86NwMsukf7XnmAoTh2+HzOlbIzvGB88jcoMo+FENK9fj7SRxeuZ/
        HkTjIXpQ==;
Received: from shell.armlinux.org.uk ([fd8f:7570:feb6:1:5054:ff:fe00:4ec]:58048)
        by pandora.armlinux.org.uk with esmtpsa  (TLS1.3) tls TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384
        (Exim 4.94.2)
        (envelope-from <linux@armlinux.org.uk>)
        id 1nZt1s-0004iK-6d; Thu, 31 Mar 2022 12:31:51 +0100
Received: from linux by shell.armlinux.org.uk with local (Exim 4.94.2)
        (envelope-from <linux@shell.armlinux.org.uk>)
        id 1nZt1p-0007Zh-Hh; Thu, 31 Mar 2022 12:31:49 +0100
Date:   Thu, 31 Mar 2022 12:31:49 +0100
From:   "Russell King (Oracle)" <linux@armlinux.org.uk>
To:     Andrew Lunn <andrew@lunn.ch>
Cc:     Michael Walle <michael@walle.cc>,
        Heiner Kallweit <hkallweit1@gmail.com>,
        Jakub Kicinski <kuba@kernel.org>,
        Paolo Abeni <pabeni@redhat.com>,
        "David S . Miller" <davem@davemloft.net>,
        Xu Liang <lxu@maxlinear.com>,
        Alexandre Belloni <alexandre.belloni@bootlin.com>,
        Florian Fainelli <f.fainelli@gmail.com>,
        netdev@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH RFC net-next 4/5] net: phy: introduce is_c45_over_c22 flag
Message-ID: <YkWRJc6wubOaiFll@shell.armlinux.org.uk>
References: <20220323183419.2278676-1-michael@walle.cc>
 <20220323183419.2278676-5-michael@walle.cc>
 <Yjt99k57mM5PQ8bT@lunn.ch>
 <8304fb3578ee38525a158af768691e75@walle.cc>
 <Yju+SGuZ9aB52ARi@lunn.ch>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <Yju+SGuZ9aB52ARi@lunn.ch>
Sender: Russell King (Oracle) <linux@armlinux.org.uk>
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,SPF_HELO_NONE,SPF_NONE,
        T_SCC_BODY_TEXT_LINE autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Thu, Mar 24, 2022 at 01:41:44AM +0100, Andrew Lunn wrote:
ydev->c45_over_c22 we are currently in a bad shape for. We cannot
> reliably say the bus master supports C45. If the bus capabilities say
> C22 only, we can set phydev->c45_over_c22. If the bus capabilities
> list C45, we can set it false. But that only covers a few busses, most
> don't have any capabilities set. We can try a C45 access and see if we
> get an -EOPNOTSUPP, in which case we can set phydev->c45_over_c22. But
> the bus driver could also do the wrong thing, issue a C22 transfer and
> give us back rubbish.

Unfortunately, trying a C45 access will be very hit and miss - we
need to fix all the MDIO drivers before we do that to check the
access type. Many don't, and worse, many assume a C22 formatted
access request, and just try throwing the PHY address and register
address into the register fields without any masking. The result is
that a C45 access will set random bits in the register.

For example:
drivers/net/mdio/mdio-bcm-iproc.c (no bus capability):

        /* Prepare the read operation */
        cmd = (MII_DATA_TA_VAL << MII_DATA_TA_SHIFT) |
                (reg << MII_DATA_RA_SHIFT) |
                (phy_id << MII_DATA_PA_SHIFT) |
                BIT(MII_DATA_SB_SHIFT) |
                (MII_DATA_OP_READ << MII_DATA_OP_SHIFT);

        writel(cmd, priv->base + MII_DATA_OFFSET);

Similar is true for:
drivers/net/mdio/mdio-bcm-unimac.c (no bus capability)
drivers/net/mdio/mdio-hisi-femac.c (no bus capability)
drivers/net/mdio/mdio-moxart.c (no bus capability)
drivers/net/mdio/mdio-mscc-miim.c (no bus capability)
drivers/net/mdio/mdio-mux-bcm6368.c (no bus capability)
drivers/net/mdio/mdio-mux-bcm-iproc.c (no bus capability)
drivers/net/mdio/mdio-sun4i.c (no bus capability)

These truncate the fields, and fwics they don't set the bus type:
drivers/net/mdio/mdio-xgene.c (for the "rgmii" only bus and no bus capability)

So all of the above need at the very least code added to reject a C45
"dev" or "phy_id" address, or they need to set the bus capability
correctly.

My feeling is that the introduction of the bus capability hasn't done
much to improve this situation; it was introduced to hint at whether a
bus is safe for clause 45 accesses, but it hasn't actually solved this
problem because we patently still have this same issue today.

I think we just need to bite the bullet and audit all the MDIO drivers
we currently have, checking what the results would be if they were
passed a C45 access request, and make them reject such a request if
the register address or phy address obviously overflows into different
register fields and also mark them as C22-only.

I can't see any other reasonable option.

-- 
RMK's Patch system: https://www.armlinux.org.uk/developer/patches/
FTTP is here! 40Mbps down 10Mbps up. Decent connectivity at last!
