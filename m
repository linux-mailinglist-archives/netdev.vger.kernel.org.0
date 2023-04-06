Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 03E566D97AB
	for <lists+netdev@lfdr.de>; Thu,  6 Apr 2023 15:12:10 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S236727AbjDFNMF (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 6 Apr 2023 09:12:05 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:38882 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229671AbjDFNME (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 6 Apr 2023 09:12:04 -0400
Received: from phobos.denx.de (phobos.denx.de [IPv6:2a01:238:438b:c500:173d:9f52:ddab:ee01])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 414258690;
        Thu,  6 Apr 2023 06:12:02 -0700 (PDT)
Received: from localhost.localdomain (85-222-111-42.dynamic.chello.pl [85.222.111.42])
        (using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits))
        (No client certificate requested)
        (Authenticated sender: lukma@denx.de)
        by phobos.denx.de (Postfix) with ESMTPSA id 035C780B98;
        Thu,  6 Apr 2023 15:11:58 +0200 (CEST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=denx.de;
        s=phobos-20191101; t=1680786719;
        bh=KpoO1U+rDZspedrciHnBZ+SkMkfYySSQvrLMdTK/I0M=;
        h=From:To:Cc:Subject:Date:From;
        b=RtTGNGqV7/wQVBz9Dai8umyDUbYuueyCHr132f0kG6b3K27JvWe0/H5P53J1Q4z1N
         tG+0CfjzQJEdb5HS8bcjNrqY6KoNuX1BUslUGd0NKAzf/VMvKBSOld1Jvd/5N6n23j
         bj+8P0ErZUJBNgts6cAsehgoqZ9eAEOkhPDzDaY+ViFhVBTm2HUGoWEDvK0HtJHPyR
         ogufalfMrAB2CZl4AjFEs5wPncrnFGXTA49kq5X9z5LCgVC1RiWC++nHjJOYVrB5/D
         aSkc1x43V7EmeigcPu0L1GVift7tCJY6rsRVfoNmXlTpKv5jfaW7R/op/HwYdnNYsB
         MfDpFifTS63ag==
From:   Lukasz Majewski <lukma@denx.de>
To:     Andrew Lunn <andrew@lunn.ch>,
        Heiner Kallweit <hkallweit1@gmail.com>
Cc:     Eric Dumazet <edumazet@google.com>,
        "David S. Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>,
        Russell King <linux@armlinux.org.uk>,
        Paolo Abeni <pabeni@redhat.com>, netdev@vger.kernel.org,
        linux-kernel@vger.kernel.org, Lukasz Majewski <lukma@denx.de>
Subject: [PATCH] phy: smsc: Implement .aneg_done callback for LAN8720Ai
Date:   Thu,  6 Apr 2023 15:11:27 +0200
Message-Id: <20230406131127.383006-1-lukma@denx.de>
X-Mailer: git-send-email 2.30.2
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Virus-Scanned: clamav-milter 0.103.8 at phobos.denx.de
X-Virus-Status: Clean
X-Spam-Status: No, score=-2.5 required=5.0 tests=DKIM_SIGNED,DKIM_VALID,
        DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_MED,SPF_HELO_NONE,SPF_PASS
        autolearn=unavailable autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

The LAN8720Ai has special bit (12) in the PHY SPECIAL
CONTROL/STATUS REGISTER (dec 31) to indicate if the
AutoNeg is finished.

Signed-off-by: Lukasz Majewski <lukma@denx.de>
---
 drivers/net/phy/smsc.c  | 8 ++++++++
 include/linux/smscphy.h | 2 ++
 2 files changed, 10 insertions(+)

diff --git a/drivers/net/phy/smsc.c b/drivers/net/phy/smsc.c
index ac7481ce2fc1..58e5f06ef453 100644
--- a/drivers/net/phy/smsc.c
+++ b/drivers/net/phy/smsc.c
@@ -83,6 +83,13 @@ static int smsc_phy_config_intr(struct phy_device *phydev)
 	return rc < 0 ? rc : 0;
 }
 
+static int smsc_phy_aneg_done(struct phy_device *phydev)
+{
+	int rc = phy_read(phydev, MII_LAN83C185_PHY_CTRL_STS);
+
+	return rc & MII_LAN87XX_AUTODONE;
+}
+
 static irqreturn_t smsc_phy_handle_interrupt(struct phy_device *phydev)
 {
 	struct smsc_phy_priv *priv = phydev->priv;
@@ -416,6 +423,7 @@ static struct phy_driver smsc_phy_driver[] = {
 	.config_init	= smsc_phy_config_init,
 	.soft_reset	= smsc_phy_reset,
 	.config_aneg	= lan95xx_config_aneg_ext,
+	.aneg_done      = smsc_phy_aneg_done,
 
 	/* IRQ related */
 	.config_intr	= smsc_phy_config_intr,
diff --git a/include/linux/smscphy.h b/include/linux/smscphy.h
index 1a136271ba6a..0debebe999d6 100644
--- a/include/linux/smscphy.h
+++ b/include/linux/smscphy.h
@@ -4,6 +4,7 @@
 
 #define MII_LAN83C185_ISF 29 /* Interrupt Source Flags */
 #define MII_LAN83C185_IM  30 /* Interrupt Mask */
+#define MII_LAN83C185_PHY_CTRL_STS  31 /* PHY Special Control/Status Register */
 #define MII_LAN83C185_CTRL_STATUS 17 /* Mode/Status Register */
 #define MII_LAN83C185_SPECIAL_MODES 18 /* Special Modes Register */
 
@@ -22,6 +23,7 @@
 	 MII_LAN83C185_ISF_INT7)
 
 #define MII_LAN83C185_EDPWRDOWN (1 << 13) /* EDPWRDOWN */
+#define MII_LAN87XX_AUTODONE    (1 << 12) /* AUTODONE */
 #define MII_LAN83C185_ENERGYON  (1 << 1)  /* ENERGYON */
 
 #define MII_LAN83C185_MODE_MASK      0xE0
-- 
2.20.1

