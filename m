Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 8728D5638CA
	for <lists+netdev@lfdr.de>; Fri,  1 Jul 2022 19:58:22 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230029AbiGAR4X (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 1 Jul 2022 13:56:23 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:58610 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229508AbiGAR4W (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 1 Jul 2022 13:56:22 -0400
Received: from galois.linutronix.de (Galois.linutronix.de [193.142.43.55])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id CEBB53ED32
        for <netdev@vger.kernel.org>; Fri,  1 Jul 2022 10:56:21 -0700 (PDT)
From:   Kurt Kanzenbach <kurt@linutronix.de>
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linutronix.de;
        s=2020; t=1656698179;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:
         content-transfer-encoding:content-transfer-encoding;
        bh=vS24F5YGdPOPAx/Pa+4KPZKtNneEwZGgUbh+g+22ueQ=;
        b=kz/YLEIjpjTGGgYhskoQxylOEjz/GqRjHN+5Iln0ukr9xjE2yE+EoRVoj9/1rEzXfCB7Cx
        1PhtsldB42upsoEOF2c4WmqZZgd2xkn3CWVYyB5Ng32U6/LSHAJH5jrLJ2rrqf6nKOyNan
        zCCg1NzIK4DtMAiHjxmvXtX0VacEo1OBBVexBNr455ilf/FW+kiiO3lCOAqoPkUQKiUSxL
        m/FsNtaSx+99Ok8H9NrErSVnhxqCHspJAsu5wz1OLMAm57iK0+OdDVtb0xlfF8Wbqv1SYH
        OfOn1GzVtCOwZsXbHpzOIqhvCcQQ/1SaSgnbsZDl2M4jfe2gkPoQQTYE/ZNy5w==
DKIM-Signature: v=1; a=ed25519-sha256; c=relaxed/relaxed; d=linutronix.de;
        s=2020e; t=1656698179;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:
         content-transfer-encoding:content-transfer-encoding;
        bh=vS24F5YGdPOPAx/Pa+4KPZKtNneEwZGgUbh+g+22ueQ=;
        b=Ga1NO5thY5grMrNkl23zCLDlS4PS1xvpFfAhbBrIE3v+d0/3C6MrOU0JQhxlhRsi60Xqeg
        CGofPaS0r1I1XtCw==
To:     Florian Fainelli <f.fainelli@gmail.com>
Cc:     Broadcom internal kernel review list 
        <bcm-kernel-feedback-list@broadcom.com>,
        Andrew Lunn <andrew@lunn.ch>,
        Heiner Kallweit <hkallweit1@gmail.com>,
        Russell King <linux@armlinux.org.uk>,
        "David S. Miller" <davem@davemloft.net>,
        Eric Dumazet <edumazet@google.com>,
        Jakub Kicinski <kuba@kernel.org>,
        Paolo Abeni <pabeni@redhat.com>, netdev@vger.kernel.org,
        Kurt Kanzenbach <kurt@linutronix.de>
Subject: [PATCH net-next] net: phy: broadcom: Add support for BCM53128 internal PHYs
Date:   Fri,  1 Jul 2022 19:56:06 +0200
Message-Id: <20220701175606.22586-1-kurt@linutronix.de>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-4.4 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_MED,SPF_HELO_NONE,
        SPF_PASS,T_SCC_BODY_TEXT_LINE autolearn=ham autolearn_force=no
        version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Add support for BCM53128 internal PHYs. These support interrupts as well as
statistics. Therefore, enable the Broadcom PHY driver for them.

Tested on BCM53128 switch using the mainline b53 DSA driver.

Signed-off-by: Kurt Kanzenbach <kurt@linutronix.de>
---
 drivers/net/phy/broadcom.c | 15 +++++++++++++++
 include/linux/brcmphy.h    |  1 +
 2 files changed, 16 insertions(+)

diff --git a/drivers/net/phy/broadcom.c b/drivers/net/phy/broadcom.c
index 876bc45ede60..31fbcdddc9ad 100644
--- a/drivers/net/phy/broadcom.c
+++ b/drivers/net/phy/broadcom.c
@@ -1066,6 +1066,20 @@ static struct phy_driver broadcom_drivers[] = {
 	.config_intr	= bcm_phy_config_intr,
 	.handle_interrupt = bcm_phy_handle_interrupt,
 	.link_change_notify	= bcm54xx_link_change_notify,
+}, {
+	.phy_id		= PHY_ID_BCM53128,
+	.phy_id_mask	= 0xfffffff0,
+	.name		= "Broadcom BCM53128",
+	.flags		= PHY_IS_INTERNAL,
+	/* PHY_GBIT_FEATURES */
+	.get_sset_count	= bcm_phy_get_sset_count,
+	.get_strings	= bcm_phy_get_strings,
+	.get_stats	= bcm54xx_get_stats,
+	.probe		= bcm54xx_phy_probe,
+	.config_init	= bcm54xx_config_init,
+	.config_intr	= bcm_phy_config_intr,
+	.handle_interrupt = bcm_phy_handle_interrupt,
+	.link_change_notify	= bcm54xx_link_change_notify,
 }, {
 	.phy_id         = PHY_ID_BCM89610,
 	.phy_id_mask    = 0xfffffff0,
@@ -1102,6 +1116,7 @@ static struct mdio_device_id __maybe_unused broadcom_tbl[] = {
 	{ PHY_ID_BCM5241, 0xfffffff0 },
 	{ PHY_ID_BCM5395, 0xfffffff0 },
 	{ PHY_ID_BCM53125, 0xfffffff0 },
+	{ PHY_ID_BCM53128, 0xfffffff0 },
 	{ PHY_ID_BCM89610, 0xfffffff0 },
 	{ }
 };
diff --git a/include/linux/brcmphy.h b/include/linux/brcmphy.h
index 747fad264033..6ff567ece34a 100644
--- a/include/linux/brcmphy.h
+++ b/include/linux/brcmphy.h
@@ -16,6 +16,7 @@
 #define PHY_ID_BCM5481			0x0143bca0
 #define PHY_ID_BCM5395			0x0143bcf0
 #define PHY_ID_BCM53125			0x03625f20
+#define PHY_ID_BCM53128			0x03625e10
 #define PHY_ID_BCM54810			0x03625d00
 #define PHY_ID_BCM54811			0x03625cc0
 #define PHY_ID_BCM5482			0x0143bcb0
-- 
2.30.2

