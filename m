Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 6C6EC2C3D2
	for <lists+netdev@lfdr.de>; Tue, 28 May 2019 12:01:24 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726773AbfE1KBX (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 28 May 2019 06:01:23 -0400
Received: from mail-lj1-f195.google.com ([209.85.208.195]:40523 "EHLO
        mail-lj1-f195.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726282AbfE1KBU (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 28 May 2019 06:01:20 -0400
Received: by mail-lj1-f195.google.com with SMTP id q62so17084828ljq.7
        for <netdev@vger.kernel.org>; Tue, 28 May 2019 03:01:18 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=from:to:cc:subject:date:message-id:in-reply-to:references;
        bh=rOXTALNmXIfY7Rq9vahH2OWziFoD5sUaIovEl2yNk5c=;
        b=B8JWgF4qfZvFafi5lB7iqdQqQyimqOUmB9LjILZjYfkCfBGruSCUTCXhvLpEwp2clb
         vL0pjrLCtJyTDm6hjrXoc4ebFqyp72Gy/aZ8w0ZcfNzSplbHJraIe7f7DPwo7s7HIJPv
         fFJOTW0k8tVMyGH8PIq4O1b/SdJhtLS2uobEJ6Aq90ZsiuLyHJTRnI6+DZgfBoOESJbe
         pNbW90TotWlRRCBPYA4qJ6Tse9UF1fOfdEHjycWVPAQs7rZOx4H4xiNPVXVnDG9w7Ptl
         RYxYTooJwyF+I6SOREBeMMbgYpPIwm/lZWDgaPGlw5lBNuG8lfpL5QM2ukqFylR/pSeH
         6JqA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references;
        bh=rOXTALNmXIfY7Rq9vahH2OWziFoD5sUaIovEl2yNk5c=;
        b=SN36uxvNrizOC2dkBl1VgeQuY9kJOMPszYoBy3nTOhuT0sq4IiHT1WUJ8RVqV0E5Xx
         /U05XLbVt0jSnNzNzZTI5YtVWuO7ye++dj1i/9WMJ7WPxHkSa2hB8sJRrYdxiNnDyzCN
         aGZnfufwWipP8lZlcHHLg+mkuB5WF29csRCSEqjqcvu2EAAXwASBB/ha3gT+H0YROyws
         swcn2VEOzNHG1+cayiaAEH35OfyCU8km/aklkypZEdOs2SU+EV8s+cIV2Ir/JKdXVYVL
         KcAT6cdvcpV7iL6zMqY99NdLwkJDd9Jm5/isrp8CSBKIL/YTY+oGLfnKln+PosdyJrcq
         7iBQ==
X-Gm-Message-State: APjAAAWKKkyof0I9OIPf428LJDIqy1h9zAEtF5ZX+o3dbQOVIx87+dhJ
        FKw6bma7v/xeLVeGC7oNVSGb50AmqDdn0w==
X-Google-Smtp-Source: APXvYqyFuGQYkgmWoJY6qy5PaZx4+TOT5yLXZTzeYfx6Coa7cHkxQ/GXleLxxexK3W1rp2wXxF6DBg==
X-Received: by 2002:a2e:82c5:: with SMTP id n5mr28116933ljh.175.1559037678054;
        Tue, 28 May 2019 03:01:18 -0700 (PDT)
Received: from maxim-H61M-D2-B3.d-systems.local ([185.75.190.112])
        by smtp.gmail.com with ESMTPSA id x28sm581816lfc.2.2019.05.28.03.01.17
        (version=TLS1_2 cipher=ECDHE-RSA-AES128-GCM-SHA256 bits=128/128);
        Tue, 28 May 2019 03:01:17 -0700 (PDT)
From:   Max Uvarov <muvarov@gmail.com>
To:     netdev@vger.kernel.org
Cc:     andrew@lunn.ch, f.fainelli@gmail.com, hkallweit1@gmail.com,
        davem@davemloft.net, Max Uvarov <muvarov@gmail.com>
Subject: [PATCH v3 2/4] net: phy: dp83867: increase SGMII autoneg timer duration
Date:   Tue, 28 May 2019 13:00:50 +0300
Message-Id: <20190528100052.8023-3-muvarov@gmail.com>
X-Mailer: git-send-email 2.17.1
In-Reply-To: <20190528100052.8023-1-muvarov@gmail.com>
References: <20190528100052.8023-1-muvarov@gmail.com>
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

After reset SGMII Autoneg timer is set to 2us (bits 6 and 5 are 01).
That is not enough to finalize autonegatiation on some devices.
Increase this timer duration to maximum supported 16ms.

Signed-off-by: Max Uvarov <muvarov@gmail.com>
Cc: Heiner Kallweit <hkallweit1@gmail.com>
Reviewed-by: Florian Fainelli <f.fainelli@gmail.com>
---
 drivers/net/phy/dp83867.c | 18 ++++++++++++++++++
 1 file changed, 18 insertions(+)

diff --git a/drivers/net/phy/dp83867.c b/drivers/net/phy/dp83867.c
index 1091a625bf4c..14e9e8a94639 100644
--- a/drivers/net/phy/dp83867.c
+++ b/drivers/net/phy/dp83867.c
@@ -26,6 +26,12 @@
 
 /* Extended Registers */
 #define DP83867_CFG4            0x0031
+#define DP83867_CFG4_SGMII_ANEG_MASK (BIT(5) | BIT(6))
+#define DP83867_CFG4_SGMII_ANEG_TIMER_11MS   (3 << 5)
+#define DP83867_CFG4_SGMII_ANEG_TIMER_800US  (2 << 5)
+#define DP83867_CFG4_SGMII_ANEG_TIMER_2US    (1 << 5)
+#define DP83867_CFG4_SGMII_ANEG_TIMER_16MS   (0 << 5)
+
 #define DP83867_RGMIICTL	0x0032
 #define DP83867_STRAP_STS1	0x006E
 #define DP83867_RGMIIDCTL	0x0086
@@ -292,6 +298,18 @@ static int dp83867_config_init(struct phy_device *phydev)
 				     0);
 		if (ret)
 			return ret;
+
+		/* After reset SGMII Autoneg timer is set to 2us (bits 6 and 5
+		 * are 01). That is not enough to finalize autoneg on some
+		 * devices. Increase this timer duration to maximum 16ms.
+		 */
+		ret = phy_modify_mmd(phydev, DP83867_DEVADDR,
+				     DP83867_CFG4,
+				     DP83867_CFG4_SGMII_ANEG_MASK,
+				     DP83867_CFG4_SGMII_ANEG_TIMER_16MS);
+
+		if (ret)
+			return ret;
 	}
 
 	/* Enable Interrupt output INT_OE in CFG3 register */
-- 
2.17.1

