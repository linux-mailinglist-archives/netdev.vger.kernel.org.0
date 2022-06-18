Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 050F95503F3
	for <lists+netdev@lfdr.de>; Sat, 18 Jun 2022 12:04:05 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231645AbiFRKAh (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sat, 18 Jun 2022 06:00:37 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:53772 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229594AbiFRKAg (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sat, 18 Jun 2022 06:00:36 -0400
Received: from pandora.armlinux.org.uk (pandora.armlinux.org.uk [IPv6:2001:4d48:ad52:32c8:5054:ff:fe00:142])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id CB0D627FE0
        for <netdev@vger.kernel.org>; Sat, 18 Jun 2022 03:00:34 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
        d=armlinux.org.uk; s=pandora-2019; h=Sender:Content-Type:MIME-Version:
        Message-ID:Subject:Cc:To:From:Date:Reply-To:Content-Transfer-Encoding:
        Content-ID:Content-Description:Resent-Date:Resent-From:Resent-Sender:
        Resent-To:Resent-Cc:Resent-Message-ID:In-Reply-To:References:List-Id:
        List-Help:List-Unsubscribe:List-Subscribe:List-Post:List-Owner:List-Archive;
        bh=hfoHfxTQIWw8pNiFK8kCu8T6N+p8DplH3n1Far9Ueqw=; b=cV+nnY+x1KjTQLg76MKE8zTTZI
        0y77406LfU1FHooGVF9UOE4pX4DcgASBYuHXM0zwtl+ek2vNYnmZoK7wUc29inbujeZKcUrJwg0/u
        DsIPH8xAsXjEwEFJopfOZMYBwzCSZn5afVNfl4md0fkapmMZ4StO7UgU3OcSo3KeWkeCWsgiCUa26
        A/4qMUUzj6Z2pGY80E2LcIX+WYrqB2WjRMRcSBNLYzEyInyX58B7AuSyQvrgsIhl4IHKSu5mpH0aS
        t8ia61DhpCtmfXcAQOp0if59O8Cn2DvOdSN479mekbWCJ5Kj8GsYPnRioZarRfunLjt/lVdh40PUG
        oBTpUxhA==;
Received: from shell.armlinux.org.uk ([fd8f:7570:feb6:1:5054:ff:fe00:4ec]:32914)
        by pandora.armlinux.org.uk with esmtpsa  (TLS1.3) tls TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384
        (Exim 4.94.2)
        (envelope-from <linux@armlinux.org.uk>)
        id 1o2VFg-0004A5-JP; Sat, 18 Jun 2022 11:00:24 +0100
Received: from linux by shell.armlinux.org.uk with local (Exim 4.94.2)
        (envelope-from <linux@shell.armlinux.org.uk>)
        id 1o2VFa-0002pJ-IL; Sat, 18 Jun 2022 11:00:18 +0100
Date:   Sat, 18 Jun 2022 11:00:18 +0100
From:   "Russell King (Oracle)" <linux@armlinux.org.uk>
To:     Andrew Lunn <andrew@lunn.ch>,
        Heiner Kallweit <hkallweit1@gmail.com>
Cc:     "David S. Miller" <davem@davemloft.net>,
        Eric Dumazet <edumazet@google.com>,
        Jakub Kicinski <kuba@kernel.org>,
        Jose Abreu <Jose.Abreu@synopsys.com>, netdev@vger.kernel.org,
        Paolo Abeni <pabeni@redhat.com>
Subject: [PATCH net-next 0/4] introduce mii_bmcr_encode_fixed()
Message-ID: <Yq2iMpbsux5wEM54@shell.armlinux.org.uk>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Sender: Russell King (Oracle) <linux@armlinux.org.uk>
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,SPF_HELO_NONE,SPF_NONE,
        T_SCC_BODY_TEXT_LINE autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Hi,

While converting the mv88e6xxx driver to phylink pcs, it has been
noticed that we've started to have repeated cases where we convert a
speed and duplex to a BMCR value.

Rather than open coding this in multiple locations, let's provide a
helper for this - in linux/mii.h. This helper not only takes care of
the standard 10, 100 and 1000Mbps encodings, but also includes
2500Mbps (which is the same as 1000Mbps) for those users who require
that encoding as well. Unknown speeds will be encoded to 10Mbps, and
non-full duplexes will be encoded as half duplex.

This series converts the existing users to the new helper, and the
mv88e6xxx conversion will add further users in the 6352 and 639x PCS
code.

 drivers/net/pcs/pcs-xpcs.c   | 18 +-----------------
 drivers/net/phy/marvell.c    | 10 ++--------
 drivers/net/phy/phy_device.c | 18 +++---------------
 include/linux/mii.h          | 35 +++++++++++++++++++++++++++++++++++
 4 files changed, 41 insertions(+), 40 deletions(-)

-- 
RMK's Patch system: https://www.armlinux.org.uk/developer/patches/
FTTP is here! 40Mbps down 10Mbps up. Decent connectivity at last!
