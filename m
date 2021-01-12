Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 5E0C22F3FBF
	for <lists+netdev@lfdr.de>; Wed, 13 Jan 2021 01:46:42 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2395084AbhALXA1 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 12 Jan 2021 18:00:27 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:34928 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1730745AbhALXA0 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 12 Jan 2021 18:00:26 -0500
Received: from pandora.armlinux.org.uk (pandora.armlinux.org.uk [IPv6:2001:4d48:ad52:32c8:5054:ff:fe00:142])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 1112DC061575
        for <netdev@vger.kernel.org>; Tue, 12 Jan 2021 14:59:46 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
        d=armlinux.org.uk; s=pandora-2019; h=Date:Sender:Message-Id:Content-Type:
        Content-Transfer-Encoding:MIME-Version:Subject:Cc:To:From:Reply-To:Content-ID
        :Content-Description:Resent-Date:Resent-From:Resent-Sender:Resent-To:
        Resent-Cc:Resent-Message-ID:In-Reply-To:References:List-Id:List-Help:
        List-Unsubscribe:List-Subscribe:List-Post:List-Owner:List-Archive;
        bh=YzIivdm7UJO06Ek8Y7wIruVMVQSNeHEHPkHr3GgCFW0=; b=Z0NRQFlf4ukBMnT2kNCy8Jzct1
        Dt9pKQdCcJlajeamK7PW4ZVy0FC+MXY+bmBRkTLMOnTmu78ZFMzj2j1Wtvrw27YlVBbVIyvrReocg
        yYlD7YDCTfGEjGCWC6CAYBfy6rITDJ4K/l30Dq9eoFB7NK8LMX77VFxbzZXQmMWW/GoV/Kja58gxv
        OYLNeY3PJiGgyKU2tYAmc1TSr5CgQ9PHrrNHNPJNuuAWZD5Kg6s6/s7v2ugL5fGQEslt0bD5SbCmk
        tfBhi65im23NGAZHjcXwVpxjX9QAzCOLhlu5eE0GZq3JAQGskx1I49DaNYf1uCR7K3HomWOGSEBKm
        tTdAB30Q==;
Received: from e0022681537dd.dyn.armlinux.org.uk ([fd8f:7570:feb6:1:222:68ff:fe15:37dd]:48332 helo=rmk-PC.armlinux.org.uk)
        by pandora.armlinux.org.uk with esmtpsa (TLS1.3:ECDHE_RSA_AES_256_GCM_SHA384:256)
        (Exim 4.92)
        (envelope-from <rmk@armlinux.org.uk>)
        id 1kzSdb-0000Ua-PF; Tue, 12 Jan 2021 22:59:43 +0000
Received: from rmk by rmk-PC.armlinux.org.uk with local (Exim 4.92)
        (envelope-from <rmk@armlinux.org.uk>)
        id 1kzSdb-000417-FJ; Tue, 12 Jan 2021 22:59:43 +0000
From:   Russell King <rmk+kernel@armlinux.org.uk>
To:     Andrew Lunn <andrew@lunn.ch>,
        Heiner Kallweit <hkallweit1@gmail.com>
Cc:     "David S. Miller" <davem@davemloft.net>, netdev@vger.kernel.org,
        Jakub Kicinski <kuba@kernel.org>
Subject: [PATCH net-next] net: phy: ar803x: disable extended next page bit
MIME-Version: 1.0
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
Content-Type: text/plain; charset="utf-8"
Message-Id: <E1kzSdb-000417-FJ@rmk-PC.armlinux.org.uk>
Sender: Russell King <rmk@armlinux.org.uk>
Date:   Tue, 12 Jan 2021 22:59:43 +0000
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

This bit is enabled by default and advertises support for extended
next page support.  XNP is only needed for 10GBase-T and MultiGig
support which is not supported. Additionally, Cisco MultiGig switches
will read this bit and attempt 10Gb negotiation even though Next Page
support is disabled. This will cause timeouts when the interface is
forced to 100Mbps and auto-negotiation will fail. The interfaces are
only 1000Base-T and supporting auto-negotiation for this only requires
the Next Page bit to be set.

Taken from:
https://github.com/SolidRun/linux-stable/commit/7406c5244b7ea6bc17a2afe8568277a8c4b126a9
and adapted to mainline kernels by rmk.

Signed-off-by: Russell King <rmk+kernel@armlinux.org.uk>
---
 drivers/net/phy/at803x.c | 8 +++++++-
 1 file changed, 7 insertions(+), 1 deletion(-)

diff --git a/drivers/net/phy/at803x.c b/drivers/net/phy/at803x.c
index 9636edb8d618..3909dc9fc94b 100644
--- a/drivers/net/phy/at803x.c
+++ b/drivers/net/phy/at803x.c
@@ -587,7 +587,13 @@ static int at803x_config_init(struct phy_device *phydev)
 			return ret;
 	}
 
-	return 0;
+	/* Ar803x extended next page bit is enabled by default. Cisco
+	 * multigig switches read this bit and attempt to negotiate 10Gbps
+	 * rates even if the next page bit is disabled. This is incorrect
+	 * behaviour but we still need to accomodate it. XNP is only needed
+	 * for 10Gbps support, so disable XNP.
+	 */
+	return phy_modify(phydev, MII_ADVERTISE, MDIO_AN_CTRL1_XNP, 0);
 }
 
 static int at803x_ack_interrupt(struct phy_device *phydev)
-- 
2.20.1

