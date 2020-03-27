Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 5F9A3195F57
	for <lists+netdev@lfdr.de>; Fri, 27 Mar 2020 20:55:58 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727666AbgC0Tzz (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 27 Mar 2020 15:55:55 -0400
Received: from mail-wm1-f68.google.com ([209.85.128.68]:39666 "EHLO
        mail-wm1-f68.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726959AbgC0Tzz (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 27 Mar 2020 15:55:55 -0400
Received: by mail-wm1-f68.google.com with SMTP id e9so1857865wme.4
        for <netdev@vger.kernel.org>; Fri, 27 Mar 2020 12:55:54 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=from:to:cc:subject:date:message-id:in-reply-to:references;
        bh=/Mzq3rQkcV1a2ODzkZa7pXB/yVYLXhR/mkJB5f7PvZE=;
        b=CIL4w2UAU+kGWNu40k82TdNHzaKevIUzQ/l6NntuOW3fA/GVwyj/79G+ydDBqaPxZF
         SpINpLuR6FNxG737mZPg0sO1eKxhnzhnI5fV9w8Mxp0XvahY8qygwkf6TO9S/ROJ80q0
         EGvr2G4Au1GjTUDWIx1YsDSmJNFNIDP/XREvgUEuVo2Ibig4Y4lAnDE7ySnVSTCYQ3lM
         g4OwJt3TwVa0IuVy8bXBTBRskWmFCAGYz6lQWI58nXJdP2Jrk1xDDaWGR3eGqtO9chPc
         6fYR9sQ6XkTL/bTz3CLYOCN0YeH3vJPhqvyU+FOVsgcIp7+U4RwKf0QN3TnVaHz44TLQ
         Yjvw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references;
        bh=/Mzq3rQkcV1a2ODzkZa7pXB/yVYLXhR/mkJB5f7PvZE=;
        b=X7fXhD0RiyT6n/rsCULQyeUd5YcLhTRW0wcE4SB7EAVwn0BqZ9BuAOyyDzGCqqQSCy
         Eqyi4ENIKNt2VgdhA6dBaX8SIqLj2VWlig9x31tsaVJAarOLCLVcYMR9hdgYqAat5UOV
         fqrhe+lTcjHqNvHnG5vu8Ie6A80zT5Gs4BmGlQgpRvasHK5L3FTfvilR5ICfa6u1iwsa
         K0ewcBz7DT/XMQpyaOoyl0tEWbsAXpAxSrfAEslLpjiW4Peax1/z1Wq9iscg6ILanTq2
         JeGL12qNpwsmZonB7sf21qr1hC3vnlDos+cbWJwA9rJuA58NR2JqySTBcqoU5heyE7iS
         UVlg==
X-Gm-Message-State: ANhLgQ0Zi2isj0IRHcLVw9l07PcZoxMCK5QzpQQ5+Bcu8USiG7j+087K
        0wP4mdmSEThfFRWUWqJb4DA=
X-Google-Smtp-Source: ADFU+vsfvl7LargwUHlJHFEONPslxR4Tc3UDT1WODExLMHI2RdEDQnwFKIrPB6qjmV8QDzuC80F9hQ==
X-Received: by 2002:a7b:cd8f:: with SMTP id y15mr312643wmj.106.1585338953659;
        Fri, 27 Mar 2020 12:55:53 -0700 (PDT)
Received: from localhost.localdomain ([79.115.60.40])
        by smtp.gmail.com with ESMTPSA id z19sm10089479wrg.28.2020.03.27.12.55.52
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 27 Mar 2020 12:55:53 -0700 (PDT)
From:   Vladimir Oltean <olteanv@gmail.com>
To:     andrew@lunn.ch, f.fainelli@gmail.com, vivien.didelot@gmail.com,
        davem@davemloft.net
Cc:     murali.policharla@broadcom.com, stephen@networkplumber.org,
        jiri@resnulli.us, idosch@idosch.org, kuba@kernel.org,
        nikolay@cumulusnetworks.com, netdev@vger.kernel.org
Subject: [PATCH v4 net-next 1/8] net: phy: bcm7xx: add jumbo frame configuration to PHY
Date:   Fri, 27 Mar 2020 21:55:40 +0200
Message-Id: <20200327195547.11583-2-olteanv@gmail.com>
X-Mailer: git-send-email 2.17.1
In-Reply-To: <20200327195547.11583-1-olteanv@gmail.com>
References: <20200327195547.11583-1-olteanv@gmail.com>
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Murali Krishna Policharla <murali.policharla@broadcom.com>

The BCM7XX PHY family requires special configuration to pass jumbo
frames. Do that during initial PHY setup.

Signed-off-by: Murali Krishna Policharla <murali.policharla@broadcom.com>
Reviewed-by: Scott Branden <scott.branden@broadcom.com>
Signed-off-by: Vladimir Oltean <vladimir.oltean@nxp.com>
Acked-by: Florian Fainelli <f.fainelli@gmail.com>
---
Changes in v4:
None.

Changes in v3:
Using the bcm54xx_auxctl_read and phy_set_bits helpers.
Corrected the value of the shadow register from 7 to 0.

Changes in v2:
Patch is new.

 drivers/net/phy/bcm-phy-lib.c | 22 ++++++++++++++++++++++
 drivers/net/phy/bcm-phy-lib.h |  1 +
 drivers/net/phy/bcm7xxx.c     |  4 ++++
 include/linux/brcmphy.h       |  2 ++
 4 files changed, 29 insertions(+)

diff --git a/drivers/net/phy/bcm-phy-lib.c b/drivers/net/phy/bcm-phy-lib.c
index e0d3310957ff..e77b274a09fd 100644
--- a/drivers/net/phy/bcm-phy-lib.c
+++ b/drivers/net/phy/bcm-phy-lib.c
@@ -423,6 +423,28 @@ int bcm_phy_28nm_a0b0_afe_config_init(struct phy_device *phydev)
 }
 EXPORT_SYMBOL_GPL(bcm_phy_28nm_a0b0_afe_config_init);
 
+int bcm_phy_enable_jumbo(struct phy_device *phydev)
+{
+	int ret;
+
+	ret = bcm54xx_auxctl_read(phydev, MII_BCM54XX_AUXCTL_SHDWSEL_AUXCTL);
+	if (ret < 0)
+		return ret;
+
+	/* Enable extended length packet reception */
+	ret = bcm54xx_auxctl_write(phydev, MII_BCM54XX_AUXCTL_SHDWSEL_AUXCTL,
+				   ret | MII_BCM54XX_AUXCTL_ACTL_EXT_PKT_LEN);
+	if (ret < 0)
+		return ret;
+
+	/* Enable the elastic FIFO for raising the transmission limit from
+	 * 4.5KB to 10KB, at the expense of an additional 16 ns in propagation
+	 * latency.
+	 */
+	return phy_set_bits(phydev, MII_BCM54XX_ECR, MII_BCM54XX_ECR_FIFOE);
+}
+EXPORT_SYMBOL_GPL(bcm_phy_enable_jumbo);
+
 MODULE_DESCRIPTION("Broadcom PHY Library");
 MODULE_LICENSE("GPL v2");
 MODULE_AUTHOR("Broadcom Corporation");
diff --git a/drivers/net/phy/bcm-phy-lib.h b/drivers/net/phy/bcm-phy-lib.h
index c86fb9d1240c..129df819be8c 100644
--- a/drivers/net/phy/bcm-phy-lib.h
+++ b/drivers/net/phy/bcm-phy-lib.h
@@ -65,5 +65,6 @@ void bcm_phy_get_stats(struct phy_device *phydev, u64 *shadow,
 		       struct ethtool_stats *stats, u64 *data);
 void bcm_phy_r_rc_cal_reset(struct phy_device *phydev);
 int bcm_phy_28nm_a0b0_afe_config_init(struct phy_device *phydev);
+int bcm_phy_enable_jumbo(struct phy_device *phydev);
 
 #endif /* _LINUX_BCM_PHY_LIB_H */
diff --git a/drivers/net/phy/bcm7xxx.c b/drivers/net/phy/bcm7xxx.c
index af8eabe7a6d4..692048d86ab1 100644
--- a/drivers/net/phy/bcm7xxx.c
+++ b/drivers/net/phy/bcm7xxx.c
@@ -178,6 +178,10 @@ static int bcm7xxx_28nm_config_init(struct phy_device *phydev)
 		break;
 	}
 
+	if (ret)
+		return ret;
+
+	ret =  bcm_phy_enable_jumbo(phydev);
 	if (ret)
 		return ret;
 
diff --git a/include/linux/brcmphy.h b/include/linux/brcmphy.h
index b475e7f20d28..6462c5447872 100644
--- a/include/linux/brcmphy.h
+++ b/include/linux/brcmphy.h
@@ -79,6 +79,7 @@
 #define MII_BCM54XX_ECR		0x10	/* BCM54xx extended control register */
 #define MII_BCM54XX_ECR_IM	0x1000	/* Interrupt mask */
 #define MII_BCM54XX_ECR_IF	0x0800	/* Interrupt force */
+#define MII_BCM54XX_ECR_FIFOE	0x0001	/* FIFO elasticity */
 
 #define MII_BCM54XX_ESR		0x11	/* BCM54xx extended status register */
 #define MII_BCM54XX_ESR_IS	0x1000	/* Interrupt status */
@@ -119,6 +120,7 @@
 #define MII_BCM54XX_AUXCTL_SHDWSEL_AUXCTL	0x00
 #define MII_BCM54XX_AUXCTL_ACTL_TX_6DB		0x0400
 #define MII_BCM54XX_AUXCTL_ACTL_SMDSP_ENA	0x0800
+#define MII_BCM54XX_AUXCTL_ACTL_EXT_PKT_LEN	0x4000
 
 #define MII_BCM54XX_AUXCTL_SHDWSEL_MISC			0x07
 #define MII_BCM54XX_AUXCTL_SHDWSEL_MISC_WIRESPEED_EN	0x0010
-- 
2.17.1

