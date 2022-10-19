Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 8775A6047A1
	for <lists+netdev@lfdr.de>; Wed, 19 Oct 2022 15:42:51 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231891AbiJSNmY (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 19 Oct 2022 09:42:24 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:32882 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230507AbiJSNlp (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 19 Oct 2022 09:41:45 -0400
Received: from pandora.armlinux.org.uk (pandora.armlinux.org.uk [IPv6:2001:4d48:ad52:32c8:5054:ff:fe00:142])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 82AC5270C
        for <netdev@vger.kernel.org>; Wed, 19 Oct 2022 06:29:29 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
        d=armlinux.org.uk; s=pandora-2019; h=Date:Sender:Message-Id:Content-Type:
        Content-Transfer-Encoding:MIME-Version:Subject:Cc:To:From:References:
        In-Reply-To:Reply-To:Content-ID:Content-Description:Resent-Date:Resent-From:
        Resent-Sender:Resent-To:Resent-Cc:Resent-Message-ID:List-Id:List-Help:
        List-Unsubscribe:List-Subscribe:List-Post:List-Owner:List-Archive;
        bh=CdzXJYSUP5pe0nNmt5zqsj5UcWBs/9HSTXlHf2H/4oI=; b=DkXI5lwhOCfxt+ccJMOWyUzkZV
        xua+a8o5SaRwMNguW0hN1hAsPLMj/GRW/KhlqELV2xBY5qT5xRoriR+ruvSuPdL79YLO4Rk9URFFU
        zsiNU5pezTqjdXOYUGHG7GV7JexkXK0tIOEG6sIbumQK+h25BlmW0mqkXn9SHACtwmVdAGqG2OFYJ
        +ohygEs7oqk7iQh1iVxqZxDx3OpWO8LPkEE8qBGG9XE3QF7JumIlUf+Th5i2DjQhAOSYFoMECeCG5
        iZZfKUZ4bjGfZU2hLYctQ5kjvWT/JwrlGSqSnzhwkMGoTzqe2kndnR8bCB2SywkcVEsJE1UYVQHSp
        fMJOC9nA==;
Received: from e0022681537dd.dyn.armlinux.org.uk ([fd8f:7570:feb6:1:222:68ff:fe15:37dd]:33112 helo=rmk-PC.armlinux.org.uk)
        by pandora.armlinux.org.uk with esmtpsa  (TLS1.3) tls TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384
        (Exim 4.94.2)
        (envelope-from <rmk@armlinux.org.uk>)
        id 1ol98C-0005k0-9N; Wed, 19 Oct 2022 14:29:12 +0100
Received: from rmk by rmk-PC.armlinux.org.uk with local (Exim 4.94.2)
        (envelope-from <rmk@rmk-PC.armlinux.org.uk>)
        id 1ol98B-00EDSv-Ma; Wed, 19 Oct 2022 14:29:11 +0100
In-Reply-To: <Y0/7dAB8OU3jrbz6@shell.armlinux.org.uk>
References: <Y0/7dAB8OU3jrbz6@shell.armlinux.org.uk>
From:   "Russell King (Oracle)" <rmk+kernel@armlinux.org.uk>
To:     "David S. Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>
Cc:     Andrew Lunn <andrew@lunn.ch>,
        Heiner Kallweit <hkallweit1@gmail.com>,
        Eric Dumazet <edumazet@google.com>,
        Paolo Abeni <pabeni@redhat.com>, netdev@vger.kernel.org
Subject: [PATCH net-next 6/7] net: sfp: add sfp_modify_u8() helper
MIME-Version: 1.0
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
Content-Type: text/plain; charset="utf-8"
Message-Id: <E1ol98B-00EDSv-Ma@rmk-PC.armlinux.org.uk>
Sender: Russell King <rmk@armlinux.org.uk>
Date:   Wed, 19 Oct 2022 14:29:11 +0100
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,SPF_HELO_NONE,SPF_NONE
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Add a helper to modify bits in a single byte in memory space, and use
it when updating the soft tx-disable flag in the module.

Signed-off-by: Russell King (Oracle) <rmk+kernel@armlinux.org.uk>
---
 drivers/net/phy/sfp.c | 31 ++++++++++++++++++++++---------
 1 file changed, 22 insertions(+), 9 deletions(-)

diff --git a/drivers/net/phy/sfp.c b/drivers/net/phy/sfp.c
index 16bce0ea68d9..921bbedd9b22 100644
--- a/drivers/net/phy/sfp.c
+++ b/drivers/net/phy/sfp.c
@@ -608,6 +608,22 @@ static int sfp_write(struct sfp *sfp, bool a2, u8 addr, void *buf, size_t len)
 	return sfp->write(sfp, a2, addr, buf, len);
 }
 
+static int sfp_modify_u8(struct sfp *sfp, bool a2, u8 addr, u8 mask, u8 val)
+{
+	int ret;
+	u8 old, v;
+
+	ret = sfp_read(sfp, a2, addr, &old, sizeof(old));
+	if (ret != sizeof(old))
+		return ret;
+
+	v = (old & ~mask) | (val & mask);
+	if (v == old)
+		return sizeof(v);
+
+	return sfp_write(sfp, a2, addr, &v, sizeof(v));
+}
+
 static unsigned int sfp_soft_get_state(struct sfp *sfp)
 {
 	unsigned int state = 0;
@@ -633,17 +649,14 @@ static unsigned int sfp_soft_get_state(struct sfp *sfp)
 
 static void sfp_soft_set_state(struct sfp *sfp, unsigned int state)
 {
-	u8 status;
+	u8 mask = SFP_STATUS_TX_DISABLE_FORCE;
+	u8 val = 0;
 
-	if (sfp_read(sfp, true, SFP_STATUS, &status, sizeof(status)) ==
-		     sizeof(status)) {
-		if (state & SFP_F_TX_DISABLE)
-			status |= SFP_STATUS_TX_DISABLE_FORCE;
-		else
-			status &= ~SFP_STATUS_TX_DISABLE_FORCE;
+	if (state & SFP_F_TX_DISABLE)
+		val |= SFP_STATUS_TX_DISABLE_FORCE;
 
-		sfp_write(sfp, true, SFP_STATUS, &status, sizeof(status));
-	}
+
+	sfp_modify_u8(sfp, true, SFP_STATUS, mask, val);
 }
 
 static void sfp_soft_start_poll(struct sfp *sfp)
-- 
2.30.2

