Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id A9D36192C36
	for <lists+netdev@lfdr.de>; Wed, 25 Mar 2020 16:22:43 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727710AbgCYPWU (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 25 Mar 2020 11:22:20 -0400
Received: from mail-wm1-f66.google.com ([209.85.128.66]:55349 "EHLO
        mail-wm1-f66.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726838AbgCYPWT (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 25 Mar 2020 11:22:19 -0400
Received: by mail-wm1-f66.google.com with SMTP id z5so2892273wml.5
        for <netdev@vger.kernel.org>; Wed, 25 Mar 2020 08:22:18 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=from:to:cc:subject:date:message-id:in-reply-to:references;
        bh=xtdHx3Qt30vc8vJyYfOQLaBLiscuFHmf8TqUqenHKXI=;
        b=V8ao8dbptUaJfu3AiNjVCYfvys3QRcAyl733OfoHocvoTxN2slwwOgW6Zo/8B26a1V
         8v2ooE2fDmORaDKx+Oq5x2bRoCCsDB/pv+3nFyf9/56iwZFvZcuwkCJUq55v8galMkly
         WoUVyHSe8OdCUxFqnZgx3JwGQggwaQBvOSehXy3rSB6NPk0oVetnmpKGHdM1LIMidPUS
         4rCgvEC2FlmZJvEVVojFGvTCXDes9J8DpWpW/bXFwXceV23kBtMwtv/yTPf1rIkXGonw
         m2yytNaECQAj59u+9YPm6n1M4CEOdKPRj7mdMPgD5yCTLcWYxI1nvJIi7DCJmbD8CpXz
         pp7w==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references;
        bh=xtdHx3Qt30vc8vJyYfOQLaBLiscuFHmf8TqUqenHKXI=;
        b=X52zQ+O3//IXrCuTHMOyH8PneVQ+f68yS5gpz2RGmbvB5F3DbENbp0TU9UDukRjyzS
         vIeNHVafXJg/HDxfrIVs7j5BI9OZRW+Xr0uAIMIkr6Q9f6lhAUjaMPd6bh3WwJC2rcL3
         aWpbkFhx6qqy3MB0FLAClVqNhw4WB4uiwx1D7EIJ6Wd9glKwOHMGFZX5t1wDP0225zPH
         PA6FQiCgg5ZLU7TcGNymhyVjZKZEjPqkm+qrTbHHr1EItR0TB49Zp8mLS9ZJwazLIy5W
         SHd3HjH6zk/G9QHv/AR39zMAsIJa5TG+p//pBqfkFt7g1DDMVGzyzOma+8tqtGVC48eR
         bKjA==
X-Gm-Message-State: ANhLgQ3c5v1B5+dvBiY6zZI+EhyYGHENcyc7+UtB8MaavPshXSPdXcog
        WrhJ5SOmb/+7kAjiQ9h3Yq4=
X-Google-Smtp-Source: ADFU+vu6h+IR+brZGgN8zBn/omNn9IkXCgZpjKUCJvVC/RVX2Vv2jDc5uEAAXQRaKKXgTceyL/EL+w==
X-Received: by 2002:a1c:f70a:: with SMTP id v10mr3859770wmh.72.1585149737552;
        Wed, 25 Mar 2020 08:22:17 -0700 (PDT)
Received: from localhost.localdomain ([79.115.60.40])
        by smtp.gmail.com with ESMTPSA id n9sm6309165wru.50.2020.03.25.08.22.16
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 25 Mar 2020 08:22:17 -0700 (PDT)
From:   Vladimir Oltean <olteanv@gmail.com>
To:     andrew@lunn.ch, f.fainelli@gmail.com, vivien.didelot@gmail.com,
        davem@davemloft.net, jakub.kicinski@netronome.com
Cc:     murali.policharla@broadcom.com, stephen@networkplumber.org,
        jiri@resnulli.us, idosch@idosch.org, kuba@kernel.org,
        nikolay@cumulusnetworks.com, netdev@vger.kernel.org
Subject: [PATCH v2 net-next 02/10] net: phy: bcm7xx: Add jumbo frame configuration to PHY
Date:   Wed, 25 Mar 2020 17:22:01 +0200
Message-Id: <20200325152209.3428-3-olteanv@gmail.com>
X-Mailer: git-send-email 2.17.1
In-Reply-To: <20200325152209.3428-1-olteanv@gmail.com>
References: <20200325152209.3428-1-olteanv@gmail.com>
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Murali Krishna Policharla <murali.policharla@broadcom.com>

Add API to configure jumbo frame settings in PHY during initial PHY
configuration.

Signed-off-by: Murali Krishna Policharla <murali.policharla@broadcom.com>
Reviewed-by: Scott Branden <scott.branden@broadcom.com>
Signed-off-by: Vladimir Oltean <vladimir.oltean@nxp.com>
---
 drivers/net/phy/bcm-phy-lib.c | 28 ++++++++++++++++++++++++++++
 drivers/net/phy/bcm-phy-lib.h |  1 +
 drivers/net/phy/bcm7xxx.c     |  4 ++++
 include/linux/brcmphy.h       |  1 +
 4 files changed, 34 insertions(+)

diff --git a/drivers/net/phy/bcm-phy-lib.c b/drivers/net/phy/bcm-phy-lib.c
index e0d3310957ff..a26c80e13b43 100644
--- a/drivers/net/phy/bcm-phy-lib.c
+++ b/drivers/net/phy/bcm-phy-lib.c
@@ -423,6 +423,34 @@ int bcm_phy_28nm_a0b0_afe_config_init(struct phy_device *phydev)
 }
 EXPORT_SYMBOL_GPL(bcm_phy_28nm_a0b0_afe_config_init);
 
+int bcm_phy_enable_jumbo(struct phy_device *phydev)
+{
+	int val = 0, ret = 0;
+
+	ret = phy_write(phydev, MII_BCM54XX_AUX_CTL,
+			MII_BCM54XX_AUXCTL_SHDWSEL_MISC);
+	if (ret < 0)
+		return ret;
+
+	val = phy_read(phydev, MII_BCM54XX_AUX_CTL);
+
+	/* Enable extended length packet reception */
+	val |= MII_BCM54XX_AUXCTL_ACTL_EXT_PKT_LEN;
+	ret = phy_write(phydev, MII_BCM54XX_AUX_CTL, val);
+
+	if (ret < 0)
+		return ret;
+
+	val = phy_read(phydev, MII_BCM54XX_ECR);
+
+	/* Enable 10K byte packet length reception */
+	val |= BIT(0);
+	ret =  phy_write(phydev, MII_BCM54XX_ECR, val);
+
+	return ret;
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
index b475e7f20d28..19bd86019e93 100644
--- a/include/linux/brcmphy.h
+++ b/include/linux/brcmphy.h
@@ -119,6 +119,7 @@
 #define MII_BCM54XX_AUXCTL_SHDWSEL_AUXCTL	0x00
 #define MII_BCM54XX_AUXCTL_ACTL_TX_6DB		0x0400
 #define MII_BCM54XX_AUXCTL_ACTL_SMDSP_ENA	0x0800
+#define MII_BCM54XX_AUXCTL_ACTL_EXT_PKT_LEN	0x4000
 
 #define MII_BCM54XX_AUXCTL_SHDWSEL_MISC			0x07
 #define MII_BCM54XX_AUXCTL_SHDWSEL_MISC_WIRESPEED_EN	0x0010
-- 
2.17.1

