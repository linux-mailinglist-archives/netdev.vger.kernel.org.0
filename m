Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id A03C3621683
	for <lists+netdev@lfdr.de>; Tue,  8 Nov 2022 15:28:37 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234276AbiKHO2f (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 8 Nov 2022 09:28:35 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:36614 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S234604AbiKHO1B (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 8 Nov 2022 09:27:01 -0500
Received: from pandora.armlinux.org.uk (pandora.armlinux.org.uk [IPv6:2001:4d48:ad52:32c8:5054:ff:fe00:142])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id B77FD5B844
        for <netdev@vger.kernel.org>; Tue,  8 Nov 2022 06:26:04 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
        d=armlinux.org.uk; s=pandora-2019; h=Date:Sender:Message-Id:Content-Type:
        Content-Transfer-Encoding:MIME-Version:Subject:Cc:To:From:References:
        In-Reply-To:Reply-To:Content-ID:Content-Description:Resent-Date:Resent-From:
        Resent-Sender:Resent-To:Resent-Cc:Resent-Message-ID:List-Id:List-Help:
        List-Unsubscribe:List-Subscribe:List-Post:List-Owner:List-Archive;
        bh=SUoGBk1fQ9UIAtid8uB3Zyjqe3B5czXkENVuJfJFuoE=; b=E0vNpfooX9ljGIKWop8/91AjXE
        /+NsTOy1hkjJWZPw0TRUh7ECpMHp4a744PTNfuTnlkMtRtRrNYbwRN8FNH8ibffnH/rPB7fjtpp1K
        sM6kyX0+WhSrPFp+6qWRvXNvlT+yTu+9vtJP2VfvyWDdmYC4/y2LTn6q4Wu2PvicDF5mbHKRgVJTk
        SvWuL2occDnXN55r/+TH9wyzkWI9yqoM8fnH1oXss0cqqBgVxb3OtJOaE99U7wrcOJl5ALBVYFPsB
        Zdu25HqN4Cm3H/3Z+DOQxyWfW/9kYjyHWLOQe/UsgeAO2ulhs2jpZq/pT1oRPizoutc4PA7YaIqzC
        Pue+wlaA==;
Received: from e0022681537dd.dyn.armlinux.org.uk ([fd8f:7570:feb6:1:222:68ff:fe15:37dd]:42060 helo=rmk-PC.armlinux.org.uk)
        by pandora.armlinux.org.uk with esmtpsa  (TLS1.3) tls TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384
        (Exim 4.94.2)
        (envelope-from <rmk@armlinux.org.uk>)
        id 1osPY9-0003Kb-Mf; Tue, 08 Nov 2022 14:26:01 +0000
Received: from rmk by rmk-PC.armlinux.org.uk with local (Exim 4.94.2)
        (envelope-from <rmk@rmk-PC.armlinux.org.uk>)
        id 1osPY9-002SMq-3e; Tue, 08 Nov 2022 14:26:01 +0000
In-Reply-To: <Y2pm13+SDg6N/IVx@shell.armlinux.org.uk>
References: <Y2pm13+SDg6N/IVx@shell.armlinux.org.uk>
From:   "Russell King (Oracle)" <rmk+kernel@armlinux.org.uk>
To:     Jose Abreu <Jose.Abreu@synopsys.com>
Cc:     Andrew Lunn <andrew@lunn.ch>,
        "David S. Miller" <davem@davemloft.net>,
        Eric Dumazet <edumazet@google.com>,
        Heiner Kallweit <hkallweit1@gmail.com>,
        Jakub Kicinski <kuba@kernel.org>, netdev@vger.kernel.org,
        Paolo Abeni <pabeni@redhat.com>
Subject: [PATCH net-next 2/2] net: pcs: xpcs: use mdiodev accessors
MIME-Version: 1.0
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
Content-Type: text/plain; charset="utf-8"
Message-Id: <E1osPY9-002SMq-3e@rmk-PC.armlinux.org.uk>
Sender: Russell King <rmk@armlinux.org.uk>
Date:   Tue, 08 Nov 2022 14:26:01 +0000
X-Spam-Status: No, score=0.4 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,SORTED_RECIPS,SPF_HELO_NONE,
        SPF_NONE autolearn=no autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Use mdiodev accessors rather than accessing the bus and address in
the mdio_device structure and using the mdiobus accessors.

Signed-off-by: Russell King (Oracle) <rmk+kernel@armlinux.org.uk>
---
 drivers/net/pcs/pcs-xpcs.c | 10 ++--------
 1 file changed, 2 insertions(+), 8 deletions(-)

diff --git a/drivers/net/pcs/pcs-xpcs.c b/drivers/net/pcs/pcs-xpcs.c
index 70f88eae2a9e..f6a038a1d51e 100644
--- a/drivers/net/pcs/pcs-xpcs.c
+++ b/drivers/net/pcs/pcs-xpcs.c
@@ -188,18 +188,12 @@ static bool __xpcs_linkmode_supported(const struct xpcs_compat *compat,
 
 int xpcs_read(struct dw_xpcs *xpcs, int dev, u32 reg)
 {
-	struct mii_bus *bus = xpcs->mdiodev->bus;
-	int addr = xpcs->mdiodev->addr;
-
-	return mdiobus_c45_read(bus, addr, dev, reg);
+	return mdiodev_c45_read(xpcs->mdiodev, dev, reg);
 }
 
 int xpcs_write(struct dw_xpcs *xpcs, int dev, u32 reg, u16 val)
 {
-	struct mii_bus *bus = xpcs->mdiodev->bus;
-	int addr = xpcs->mdiodev->addr;
-
-	return mdiobus_c45_write(bus, addr, dev, reg, val);
+	return mdiodev_c45_write(xpcs->mdiodev, dev, reg, val);
 }
 
 static int xpcs_modify_changed(struct dw_xpcs *xpcs, int dev, u32 reg,
-- 
2.30.2

