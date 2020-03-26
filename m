Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 0ED85194BA7
	for <lists+netdev@lfdr.de>; Thu, 26 Mar 2020 23:41:08 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727495AbgCZWlG (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 26 Mar 2020 18:41:06 -0400
Received: from mail-wm1-f66.google.com ([209.85.128.66]:38961 "EHLO
        mail-wm1-f66.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726296AbgCZWlF (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 26 Mar 2020 18:41:05 -0400
Received: by mail-wm1-f66.google.com with SMTP id a9so9999541wmj.4
        for <netdev@vger.kernel.org>; Thu, 26 Mar 2020 15:41:04 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=from:to:cc:subject:date:message-id:in-reply-to:references;
        bh=3lVLNSRxRaoPCea/E1lx2aFVmxmDYx1au00hYk53d6E=;
        b=r1pt3IaB2kwHQ60g2yQHqcTHSeSmViYmOfFt9ux8Bl/LAuzSeRdsNkGD1hy7YYZ1DO
         lfZOl4ut4m5hQdCC96NZib2+o2Ya54hKlCEF3k54Ob0U2VH2YANrvQh1dciaq50PWfCI
         YJft8D88JACFGtTpvzK4kjHdbmPvbaK5xdm3uJGIL9YhUQkRSXup+KUy1egX9pCXpLB9
         BXDx3UZlQRA7UABrnMm3Ju7N8sdg8aQRhVMYSmFqBwTMdlq34Mpf9fkK2TBZX0A1/J5m
         XCyxKpps1QsrY9XR+wn17dAd+010vMPkymYpEsSHliVnHfj9DycoNT8Jgk5K0C+mcMEI
         IeOw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references;
        bh=3lVLNSRxRaoPCea/E1lx2aFVmxmDYx1au00hYk53d6E=;
        b=rBko/2YAMirl0iBMh2gtSkS38VgEChvPA5QiM7PLLgFjyhOSS7Pm2rZY7ol46dNKIn
         6fYsR+4im0mH1yg/LMWvgGznfLcnkwwc3+eD2+CaafmB59jBQunAtMGU9jnLuFSIWaG8
         Nbmz7+v2O+9r3X7Q1UI7N/2NnU9GOUd3LnN6hSSgY/b7J8O+rb2MzcHA8FiUWvOqnDmz
         X33K99okn4PUSYblGphpsvslikg3oZNP5CcL/s1U1SK37EmziOmt+J7BhY7QI87BcIfa
         RQkB37KCZfA5ke1vowHET3j+iOJtPW71CXoN1fGlaOuIzKia83uX65Bt3CL3Wa0tU9P1
         zLjw==
X-Gm-Message-State: ANhLgQ0rYGZqCJA1OfdE9v++A8YQoo5Qn6O+QnPMdgn7SE0Hzrjneuxb
        irJs8wYvqh1Z9TlnQffrqEI=
X-Google-Smtp-Source: ADFU+vvuHYqlHF9xZu+CDZPBAPM6FKJjQwWib+aYX/UglLb+mGL64ndNKE9rBXvMgq7cMvTW6rTmuw==
X-Received: by 2002:adf:fdd2:: with SMTP id i18mr9425642wrs.165.1585262463319;
        Thu, 26 Mar 2020 15:41:03 -0700 (PDT)
Received: from localhost.localdomain ([79.115.60.40])
        by smtp.gmail.com with ESMTPSA id t81sm5522783wmb.15.2020.03.26.15.41.02
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 26 Mar 2020 15:41:02 -0700 (PDT)
From:   Vladimir Oltean <olteanv@gmail.com>
To:     andrew@lunn.ch, f.fainelli@gmail.com, vivien.didelot@gmail.com,
        davem@davemloft.net, jakub.kicinski@netronome.com
Cc:     murali.policharla@broadcom.com, stephen@networkplumber.org,
        jiri@resnulli.us, idosch@idosch.org, kuba@kernel.org,
        nikolay@cumulusnetworks.com, netdev@vger.kernel.org
Subject: [PATCH v3 net-next 1/8] net: phy: bcm7xx: add jumbo frame configuration to PHY
Date:   Fri, 27 Mar 2020 00:40:33 +0200
Message-Id: <20200326224040.32014-2-olteanv@gmail.com>
X-Mailer: git-send-email 2.17.1
In-Reply-To: <20200326224040.32014-1-olteanv@gmail.com>
References: <20200326224040.32014-1-olteanv@gmail.com>
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
---
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

