Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 033A34A8A1F
	for <lists+netdev@lfdr.de>; Thu,  3 Feb 2022 18:33:16 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1352868AbiBCRbS (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 3 Feb 2022 12:31:18 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:43830 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1352864AbiBCRbQ (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 3 Feb 2022 12:31:16 -0500
Received: from pandora.armlinux.org.uk (pandora.armlinux.org.uk [IPv6:2001:4d48:ad52:32c8:5054:ff:fe00:142])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id EC15AC061714
        for <netdev@vger.kernel.org>; Thu,  3 Feb 2022 09:31:15 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
        d=armlinux.org.uk; s=pandora-2019; h=Date:Sender:Message-Id:Content-Type:
        Content-Transfer-Encoding:MIME-Version:Subject:Cc:To:From:References:
        In-Reply-To:Reply-To:Content-ID:Content-Description:Resent-Date:Resent-From:
        Resent-Sender:Resent-To:Resent-Cc:Resent-Message-ID:List-Id:List-Help:
        List-Unsubscribe:List-Subscribe:List-Post:List-Owner:List-Archive;
        bh=1OEms46dU74qLWGA0INHwPED/HIKfZFFAClQYerDQqI=; b=PoXTWLDjSiZsZqWzfbDn+GqwDI
        9eWtPVQllGtl+6aJOJnDVKzVBq3ZcJmmSAWN9AjX43kNNKUTKUkozrtwmgITv50OUDkLGng/qx1iC
        kMsHCA8PsZX1ppD9CnaXTVkKugnKFtV2fNnmuv3Ek+FEca6lpp+eKVBGWWztEK+hLJx4Im0wjrmFj
        wO+w8mS5AMAr6L111UKpHW8DKTTwAKVwAy/OEn6Y8CPKtcfPbNWJtQKb+8VEpeWhU1RGWx8XQvGEB
        QzutYxeTvGkn+ycZ4aM9mPhawWhfFJWifWlIP68fJPADTmrIfac883pJhENe/q1mJktjMUbanjEBp
        SCuPmZDw==;
Received: from e0022681537dd.dyn.armlinux.org.uk ([fd8f:7570:feb6:1:222:68ff:fe15:37dd]:54876 helo=rmk-PC.armlinux.org.uk)
        by pandora.armlinux.org.uk with esmtpsa  (TLS1.3) tls TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384
        (Exim 4.94.2)
        (envelope-from <rmk@armlinux.org.uk>)
        id 1nFfwv-0002z0-GE; Thu, 03 Feb 2022 17:31:13 +0000
Received: from rmk by rmk-PC.armlinux.org.uk with local (Exim 4.94.2)
        (envelope-from <rmk@rmk-PC.armlinux.org.uk>)
        id 1nFfwu-006X6Y-TI; Thu, 03 Feb 2022 17:31:12 +0000
In-Reply-To: <YfvrIf/FDddglaKE@shell.armlinux.org.uk>
References: <YfvrIf/FDddglaKE@shell.armlinux.org.uk>
From:   "Russell King (Oracle)" <rmk+kernel@armlinux.org.uk>
To:     Florian Fainelli <f.fainelli@gmail.com>
Cc:     Andrew Lunn <andrew@lunn.ch>,
        Vivien Didelot <vivien.didelot@gmail.com>,
        Vladimir Oltean <olteanv@gmail.com>,
        "David S. Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>, netdev@vger.kernel.org
Subject: [PATCH RFC net-next 5/5] net: dsa: b53: mark as non-legacy
MIME-Version: 1.0
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
Content-Type: text/plain; charset="utf-8"
Message-Id: <E1nFfwu-006X6Y-TI@rmk-PC.armlinux.org.uk>
Sender: Russell King <rmk@armlinux.org.uk>
Date:   Thu, 03 Feb 2022 17:31:12 +0000
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

The B53 driver does not make use of the speed, duplex, pause or
advertisement in its phylink_mac_config() implementation, so it can be
marked as a non-legacy driver.

Signed-off-by: Russell King (Oracle) <rmk+kernel@armlinux.org.uk>
---
 drivers/net/dsa/b53/b53_common.c | 6 ++++++
 1 file changed, 6 insertions(+)

diff --git a/drivers/net/dsa/b53/b53_common.c b/drivers/net/dsa/b53/b53_common.c
index 50a372dc32ae..83bf30349c26 100644
--- a/drivers/net/dsa/b53/b53_common.c
+++ b/drivers/net/dsa/b53/b53_common.c
@@ -1346,6 +1346,12 @@ static void b53_phylink_get_caps(struct dsa_switch *ds, int port,
 	/* Get the implementation specific capabilities */
 	if (dev->ops->phylink_get_caps)
 		dev->ops->phylink_get_caps(dev, port, config);
+
+	/* This driver does not make use of the speed, duplex, pause or the
+	 * advertisement in its mac_config, so it is safe to mark this driver
+	 * as non-legacy.
+	 */
+	config->legacy_pre_march2020 = false;
 }
 
 int b53_phylink_mac_link_state(struct dsa_switch *ds, int port,
-- 
2.30.2

