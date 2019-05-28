Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 7264D2C3D0
	for <lists+netdev@lfdr.de>; Tue, 28 May 2019 12:01:21 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726708AbfE1KBU (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 28 May 2019 06:01:20 -0400
Received: from mail-lj1-f195.google.com ([209.85.208.195]:37786 "EHLO
        mail-lj1-f195.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726345AbfE1KBT (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 28 May 2019 06:01:19 -0400
Received: by mail-lj1-f195.google.com with SMTP id h19so8689920ljj.4
        for <netdev@vger.kernel.org>; Tue, 28 May 2019 03:01:17 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=from:to:cc:subject:date:message-id:in-reply-to:references;
        bh=25melUs60zp1chysDUtgRkNtQfn6TxpElDQ7Xu0aAc4=;
        b=JuLVnvqrWSTF55H+3ojr0HWeY1MPIrzfCkSj175NgdAm/zSsNKIsm+8G3pzFS7gqLI
         sjfBH1UXrA/fKhZ8RkpxU0e1HKSrvyj/Iie8XiD4NPMnIcks9zL00HYz0oTuKxyKPUDZ
         exov2G4qVDNGTiFrG2cQMA3GplgU1q/fOLYnJxv0hjh2ao29q0iyD2gIblILSJhT0/m1
         zT4oOgsvmKJCSiE+8Cy8u2ftel3VgQTubI+UEZODkQGQQ+4djX90a7cOPX/y7CX4O7fn
         +l+ObjjJlJX6b7rGnTnX4g8hDIRxoLzvaaSRXbe4uM3MiRCYKPGo3LnB+pmdT12Gbs72
         o7bw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references;
        bh=25melUs60zp1chysDUtgRkNtQfn6TxpElDQ7Xu0aAc4=;
        b=jXxTPMZqUl9nqfwtIrb6DHkoJdlr+jgaHzxuTd5zRav8oVrkbjgswzR+tVCinAiyRX
         hSwOOQ4B9jyJC5Q8LZnouSbsgvOFVMnhuu9meSNsquUdxiv+5sXmOZzsR1VelhsOlLVZ
         VlxvHc7BzTcjYHmnhz0g3zHPCLpHPhlxw97uATvJ12gjh67X3P8/IqNNz2GtEPuuAiCP
         WE8egL390hCGOyBca6uVJDeHYDHMUzFs6PagiwLBDwQZqRIpUpBRVzq1thpzzc6mdayj
         hdNizxt04lWgxbg0KP+8QFiLlgaVmWfGWTCjARGVb4JL8sg4SOzD8zgPcTtZBd63VpV9
         WSpw==
X-Gm-Message-State: APjAAAWEVyeeHeD+zixLAAdPj4jtwGlZ7ha7zrCZgFt7ph87JGhwOg7m
        PRgmnCF93qfDQfKYxNViss3tNTEhImeJ/A==
X-Google-Smtp-Source: APXvYqyb6DMc5K0CKFXJYPO8ZtAl2s+Ac5eGb3iHJU3VV7fK4ZPm6TQgwHjHUzkABoKZ5kuM+3YpyA==
X-Received: by 2002:a2e:81d0:: with SMTP id s16mr13122927ljg.42.1559037677110;
        Tue, 28 May 2019 03:01:17 -0700 (PDT)
Received: from maxim-H61M-D2-B3.d-systems.local ([185.75.190.112])
        by smtp.gmail.com with ESMTPSA id x28sm581816lfc.2.2019.05.28.03.01.16
        (version=TLS1_2 cipher=ECDHE-RSA-AES128-GCM-SHA256 bits=128/128);
        Tue, 28 May 2019 03:01:16 -0700 (PDT)
From:   Max Uvarov <muvarov@gmail.com>
To:     netdev@vger.kernel.org
Cc:     andrew@lunn.ch, f.fainelli@gmail.com, hkallweit1@gmail.com,
        davem@davemloft.net, Max Uvarov <muvarov@gmail.com>
Subject: [PATCH v3 1/4] net: phy: dp83867: fix speed 10 in sgmii mode
Date:   Tue, 28 May 2019 13:00:49 +0300
Message-Id: <20190528100052.8023-2-muvarov@gmail.com>
X-Mailer: git-send-email 2.17.1
In-Reply-To: <20190528100052.8023-1-muvarov@gmail.com>
References: <20190528100052.8023-1-muvarov@gmail.com>
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

For supporting 10Mps speed in SGMII mode DP83867_10M_SGMII_RATE_ADAPT bit
of DP83867_10M_SGMII_CFG register has to be cleared by software.
That does not affect speeds 100 and 1000 so can be done on init.

Signed-off-by: Max Uvarov <muvarov@gmail.com>
Cc: Heiner Kallweit <hkallweit1@gmail.com>
Reviewed-by: Florian Fainelli <f.fainelli@gmail.com>
---
 drivers/net/phy/dp83867.c | 17 +++++++++++++++++
 1 file changed, 17 insertions(+)

diff --git a/drivers/net/phy/dp83867.c b/drivers/net/phy/dp83867.c
index fd35131a0c39..1091a625bf4c 100644
--- a/drivers/net/phy/dp83867.c
+++ b/drivers/net/phy/dp83867.c
@@ -30,6 +30,8 @@
 #define DP83867_STRAP_STS1	0x006E
 #define DP83867_RGMIIDCTL	0x0086
 #define DP83867_IO_MUX_CFG	0x0170
+#define DP83867_10M_SGMII_CFG   0x016F
+#define DP83867_10M_SGMII_RATE_ADAPT_MASK BIT(7)
 
 #define DP83867_SW_RESET	BIT(15)
 #define DP83867_SW_RESTART	BIT(14)
@@ -277,6 +279,21 @@ static int dp83867_config_init(struct phy_device *phydev)
 				       DP83867_IO_MUX_CFG_IO_IMPEDANCE_CTRL);
 	}
 
+	if (phydev->interface == PHY_INTERFACE_MODE_SGMII) {
+		/* For support SPEED_10 in SGMII mode
+		 * DP83867_10M_SGMII_RATE_ADAPT bit
+		 * has to be cleared by software. That
+		 * does not affect SPEED_100 and
+		 * SPEED_1000.
+		 */
+		ret = phy_modify_mmd(phydev, DP83867_DEVADDR,
+				     DP83867_10M_SGMII_CFG,
+				     DP83867_10M_SGMII_RATE_ADAPT_MASK,
+				     0);
+		if (ret)
+			return ret;
+	}
+
 	/* Enable Interrupt output INT_OE in CFG3 register */
 	if (phy_interrupt_is_valid(phydev)) {
 		val = phy_read(phydev, DP83867_CFG3);
-- 
2.17.1

