Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 1E54D295A9
	for <lists+netdev@lfdr.de>; Fri, 24 May 2019 12:26:06 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2390506AbfEXK0C (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 24 May 2019 06:26:02 -0400
Received: from mail-lf1-f67.google.com ([209.85.167.67]:35529 "EHLO
        mail-lf1-f67.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S2390447AbfEXKZ4 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 24 May 2019 06:25:56 -0400
Received: by mail-lf1-f67.google.com with SMTP id c17so6752296lfi.2
        for <netdev@vger.kernel.org>; Fri, 24 May 2019 03:25:55 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=from:to:cc:subject:date:message-id:in-reply-to:references;
        bh=YvLGBBgJSYam41nRDDwluQ/RkCLRTEczZAaXcPGSB14=;
        b=YStyh/zpFnQ8Jg40+w2fipil0+Do1Y8B8o3MLdaG9BE4Md7/Tn1E5aJMa39G3rHaid
         QoHZJEoBVKypH8+T0hIVI7hACipYNf9eZ1tYHbC7wfTl6nKuVQphUVX1uaf3GvfBsXcP
         cs5n1P/VKIlXNoTbClXw3Kt4MMgJrN82JM9DtTFBsXUsB/PUsnF2SY+fHVEHsHx146+3
         VzrDz5RxWGBly2dwugk3x9RIpZASIQhulnDwrvtVcZ7medW8BptlLvjR6mPfneQQiU6m
         lO8HyGgGbwKqvJonnNgNWdw+EEZ6qCTlFlFOYSNRcEBZKcSXS57SkDWzHZiNLZcG8j57
         vg0Q==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references;
        bh=YvLGBBgJSYam41nRDDwluQ/RkCLRTEczZAaXcPGSB14=;
        b=ZcbVbfdgh3yiDSW+FWYhGsoWhbSk6idnOiTtD6O+tJdcE0bf3He78g3lLpu0aoWCv0
         WOT70J268uMZSHNQ6AUGaZUMRLdstxzcG7Lm6tG8xmgTZSLNNVNYBmXI93iBdkuNwJoW
         E2odPJw527Qz3olbyTy2cBwIU9/xwow/7gwnalpLWpp/R+eyNSVPc3jI6WBd6pC+oQYX
         NVLcyUFz75RhPdag/5JCCcfDr+erwM5YWuVZKfBcjjybri4Ot4EgnqMvwrf0pBpYmL5/
         wuq8dKmfRh+BhoEk+TVHCfr3Ios2h4wuNWXdVHZRrRo5pBpWTz1fzI/GRpOSzuKUY/nq
         +iJA==
X-Gm-Message-State: APjAAAVIzH9d3wEVY+qHkedyvIwxKK+nGGJiBo9B/MvEZe9I5/4QI40y
        eA5Y3TsbL4wyVJ03mW2zGUN9xRjmbjp9aw==
X-Google-Smtp-Source: APXvYqw4aglwG5Ebav9Ni1YBqhx6pXB2ptCH8zzRdoTluCAbBJrBqm7um2I6GoKp0ZnLPgaj1NSVlg==
X-Received: by 2002:ac2:4543:: with SMTP id j3mr1123962lfm.110.1558693554434;
        Fri, 24 May 2019 03:25:54 -0700 (PDT)
Received: from maxim-H61M-D2-B3.d-systems.local ([185.75.190.112])
        by smtp.gmail.com with ESMTPSA id n7sm421567ljc.69.2019.05.24.03.25.53
        (version=TLS1_2 cipher=ECDHE-RSA-AES128-GCM-SHA256 bits=128/128);
        Fri, 24 May 2019 03:25:54 -0700 (PDT)
From:   Max Uvarov <muvarov@gmail.com>
To:     netdev@vger.kernel.org
Cc:     andrew@lunn.ch, f.fainelli@gmail.com, hkallweit1@gmail.com,
        davem@davemloft.net, Max Uvarov <muvarov@gmail.com>
Subject: [PATCH 1/3] net:phy:dp83867: fix speed 10 in sgmii mode
Date:   Fri, 24 May 2019 13:25:39 +0300
Message-Id: <20190524102541.4478-2-muvarov@gmail.com>
X-Mailer: git-send-email 2.17.1
In-Reply-To: <20190524102541.4478-1-muvarov@gmail.com>
References: <20190524102541.4478-1-muvarov@gmail.com>
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

For support 10Mps sped in SGMII mode DP83867_10M_SGMII_RATE_ADAPT bit
of DP83867_10M_SGMII_CFG register has to be cleared by software.
That does not affect speeds 100 and 1000 so can be done on init.

Signed-off-by: Max Uvarov <muvarov@gmail.com>
---
 drivers/net/phy/dp83867.c | 22 ++++++++++++++++++++++
 1 file changed, 22 insertions(+)

diff --git a/drivers/net/phy/dp83867.c b/drivers/net/phy/dp83867.c
index fd35131a0c39..afd31c516cc7 100644
--- a/drivers/net/phy/dp83867.c
+++ b/drivers/net/phy/dp83867.c
@@ -30,6 +30,7 @@
 #define DP83867_STRAP_STS1	0x006E
 #define DP83867_RGMIIDCTL	0x0086
 #define DP83867_IO_MUX_CFG	0x0170
+#define DP83867_10M_SGMII_CFG  0x016F
 
 #define DP83867_SW_RESET	BIT(15)
 #define DP83867_SW_RESTART	BIT(14)
@@ -74,6 +75,9 @@
 /* CFG4 bits */
 #define DP83867_CFG4_PORT_MIRROR_EN              BIT(0)
 
+/* 10M_SGMII_CFG bits */
+#define DP83867_10M_SGMII_RATE_ADAPT		 BIT(7)
+
 enum {
 	DP83867_PORT_MIRROING_KEEP,
 	DP83867_PORT_MIRROING_EN,
@@ -277,6 +281,24 @@ static int dp83867_config_init(struct phy_device *phydev)
 				       DP83867_IO_MUX_CFG_IO_IMPEDANCE_CTRL);
 	}
 
+	if (phydev->interface == PHY_INTERFACE_MODE_SGMII) {
+		/* For support SPEED_10 in SGMII mode
+		 * DP83867_10M_SGMII_RATE_ADAPT bit
+		 * has to be cleared by software. That
+		 * does not affect SPEED_100 and
+		 * SPEED_1000.
+		 */
+		val = phy_read_mmd(phydev, DP83867_DEVADDR,
+				   DP83867_10M_SGMII_CFG);
+		val &= ~DP83867_10M_SGMII_RATE_ADAPT;
+		ret = phy_write_mmd(phydev, DP83867_DEVADDR,
+				    DP83867_10M_SGMII_CFG, val);
+		if (ret) {
+			WARN_ONCE(1, "dp83867: err DP83867_10M_SGMII_CFG\n");
+			return ret;
+		}
+	}
+
 	/* Enable Interrupt output INT_OE in CFG3 register */
 	if (phy_interrupt_is_valid(phydev)) {
 		val = phy_read(phydev, DP83867_CFG3);
-- 
2.17.1

