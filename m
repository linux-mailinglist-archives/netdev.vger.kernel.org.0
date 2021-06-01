Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id AAA73396A51
	for <lists+netdev@lfdr.de>; Tue,  1 Jun 2021 02:34:00 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232540AbhFAAfh (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 31 May 2021 20:35:37 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:35636 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232509AbhFAAfV (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 31 May 2021 20:35:21 -0400
Received: from mail-ed1-x52c.google.com (mail-ed1-x52c.google.com [IPv6:2a00:1450:4864:20::52c])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id A672CC06174A
        for <netdev@vger.kernel.org>; Mon, 31 May 2021 17:33:38 -0700 (PDT)
Received: by mail-ed1-x52c.google.com with SMTP id b11so8410098edy.4
        for <netdev@vger.kernel.org>; Mon, 31 May 2021 17:33:38 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=from:to:cc:subject:date:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=JmOBUlXZ/3U6PFIFQrU0jjPHJBZfE3frrHVrUeatxeg=;
        b=je6uTTnpglBZ+K9XfliQZcsUdQZDCv2Bdj5IFS8C8wQVhM/xvzxZgsWVMOLbxn4hsG
         G4XalSYqCcndGhI/Hc9qM/xmty3K6iQ8AxcAVS2umrBFMHQ3b+7w+G6LxzNlDvX5Ypx6
         uHCjDnFJgG7sLGlVASDDsfuDEkJUOwn0TLgrsVW+uYasx+mI1pBbDkDxV5BK68zhIoTn
         17DmzaCaHSfca/h0RW0gBIDO5AHW7+LKmIamup7xnSTsa7lLiTpoNHv2tlVzvzGiFW2J
         WXeybQa18bA8V0TiSbcQi8fuyKyBrTWRUGhTFGWtIZkur7iohvzvLW4CmGBQc6/wCpgL
         L0sg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=JmOBUlXZ/3U6PFIFQrU0jjPHJBZfE3frrHVrUeatxeg=;
        b=hkbCinB0sSnbEpU1mVbQ+mCHQ5z+ZG0qfFE0HojsXa/H20Zn3/wxXLZF1pBw0CeL7Y
         47J4deifWLnfKVgGISRIFom2BsSk3MDdR2NdXSB+6CvNpdECIIFSg6pGgg5RGSXnolOv
         Ifk+C/X2erBf/gq6eoIZx+ZTKMkg5tJg00Zuggf4m70fZckqu9bXW4nY1VgOyIFH06tu
         Vo6+tAh0ESKjTm7KASfBL+gJ9tAplEmvsTNnFfbL4Bg/4RUMWTHACEMDChV8Y6OdnZBc
         WelOidagemo6Fh1vZfbNXa9AaeR1+Hh8F27D8xnlaL9P7TWzTiBp5dwF3GSE6pAuYhMZ
         /lOA==
X-Gm-Message-State: AOAM531wowqOhGQ76quxqB+sFf6lw83cAovD7NHd7yFKEtuH/vCxuBwM
        VuCQJDHSinvCvXsWEFGCKakrNBDirNE=
X-Google-Smtp-Source: ABdhPJzRRZ5IUZVpzCtCXFGBSS0HTh8GDd6P24LKoJ+xylX0KYR7oU1aTMOEppfKORJpqiHiSleibQ==
X-Received: by 2002:a05:6402:b89:: with SMTP id cf9mr9811992edb.198.1622507617328;
        Mon, 31 May 2021 17:33:37 -0700 (PDT)
Received: from localhost.localdomain ([188.26.52.84])
        by smtp.gmail.com with ESMTPSA id g13sm6510521ejr.63.2021.05.31.17.33.36
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 31 May 2021 17:33:37 -0700 (PDT)
From:   Vladimir Oltean <olteanv@gmail.com>
To:     Jakub Kicinski <kuba@kernel.org>,
        "David S. Miller" <davem@davemloft.net>, netdev@vger.kernel.org
Cc:     Wong Vee Khee <vee.khee.wong@linux.intel.com>,
        Ong Boon Leong <boon.leong.ong@intel.com>,
        Michael Sit Wei Hong <michael.wei.hong.sit@intel.com>,
        Giuseppe Cavallaro <peppe.cavallaro@st.com>,
        Alexandre Torgue <alexandre.torgue@foss.st.com>,
        Jose Abreu <joabreu@synopsys.com>,
        Maxime Coquelin <mcoquelin.stm32@gmail.com>,
        Heiner Kallweit <hkallweit1@gmail.com>,
        Russell King - ARM Linux admin <linux@armlinux.org.uk>,
        Florian Fainelli <f.fainelli@gmail.com>,
        Andrew Lunn <andrew@lunn.ch>,
        Vladimir Oltean <vladimir.oltean@nxp.com>
Subject: [RFC PATCH v2 net-next 5/9] net: pcs: xpcs: export xpcs_config_eee
Date:   Tue,  1 Jun 2021 03:33:21 +0300
Message-Id: <20210601003325.1631980-6-olteanv@gmail.com>
X-Mailer: git-send-email 2.25.1
In-Reply-To: <20210601003325.1631980-1-olteanv@gmail.com>
References: <20210601003325.1631980-1-olteanv@gmail.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Vladimir Oltean <vladimir.oltean@nxp.com>

There is no good reason why we need to go through:

stmmac_xpcs_config_eee
-> stmmac_do_callback
   -> mdio_xpcs_ops->config_eee
      -> xpcs_config_eee

when we can simply call xpcs_config_eee.

priv->hw->xpcs is of the type "const struct mdio_xpcs_ops *" and is used
as a placeholder/synonym for priv->plat->mdio_bus_data->has_xpcs. It is
done that way because the mdio_bus_data pointer might or might not be
populated in all stmmac instantiations.

Signed-off-by: Vladimir Oltean <vladimir.oltean@nxp.com>
---
 drivers/net/ethernet/stmicro/stmmac/hwif.h           |  2 --
 drivers/net/ethernet/stmicro/stmmac/stmmac_ethtool.c | 12 +++++++-----
 drivers/net/pcs/pcs-xpcs.c                           |  6 +++---
 include/linux/pcs/pcs-xpcs.h                         |  4 ++--
 4 files changed, 12 insertions(+), 12 deletions(-)

diff --git a/drivers/net/ethernet/stmicro/stmmac/hwif.h b/drivers/net/ethernet/stmicro/stmmac/hwif.h
index a86b358feae9..2d2843edaf21 100644
--- a/drivers/net/ethernet/stmicro/stmmac/hwif.h
+++ b/drivers/net/ethernet/stmicro/stmmac/hwif.h
@@ -621,8 +621,6 @@ struct stmmac_mmc_ops {
 	stmmac_do_callback(__priv, xpcs, link_up, __args)
 #define stmmac_xpcs_probe(__priv, __args...) \
 	stmmac_do_callback(__priv, xpcs, probe, __args)
-#define stmmac_xpcs_config_eee(__priv, __args...) \
-	stmmac_do_callback(__priv, xpcs, config_eee, __args)
 
 struct stmmac_regs_off {
 	u32 ptp_off;
diff --git a/drivers/net/ethernet/stmicro/stmmac/stmmac_ethtool.c b/drivers/net/ethernet/stmicro/stmmac/stmmac_ethtool.c
index 1f6d749fd9a3..ba7d0f40723a 100644
--- a/drivers/net/ethernet/stmicro/stmmac/stmmac_ethtool.c
+++ b/drivers/net/ethernet/stmicro/stmmac/stmmac_ethtool.c
@@ -720,11 +720,13 @@ static int stmmac_ethtool_op_set_eee(struct net_device *dev,
 		netdev_warn(priv->dev,
 			    "Setting EEE tx-lpi is not supported\n");
 
-	ret = stmmac_xpcs_config_eee(priv, &priv->hw->xpcs_args,
-				     priv->plat->mult_fact_100ns,
-				     edata->eee_enabled);
-	if (ret)
-		return ret;
+	if (priv->hw->xpcs) {
+		ret = xpcs_config_eee(&priv->hw->xpcs_args,
+				      priv->plat->mult_fact_100ns,
+				      edata->eee_enabled);
+		if (ret)
+			return ret;
+	}
 
 	if (!edata->eee_enabled)
 		stmmac_disable_eee_mode(priv);
diff --git a/drivers/net/pcs/pcs-xpcs.c b/drivers/net/pcs/pcs-xpcs.c
index a9bae263dcdb..7cd057f43200 100644
--- a/drivers/net/pcs/pcs-xpcs.c
+++ b/drivers/net/pcs/pcs-xpcs.c
@@ -750,8 +750,8 @@ void xpcs_validate(struct mdio_xpcs_args *xpcs, unsigned long *supported,
 }
 EXPORT_SYMBOL_GPL(xpcs_validate);
 
-static int xpcs_config_eee(struct mdio_xpcs_args *xpcs, int mult_fact_100ns,
-			   int enable)
+int xpcs_config_eee(struct mdio_xpcs_args *xpcs, int mult_fact_100ns,
+		    int enable)
 {
 	int ret;
 
@@ -782,6 +782,7 @@ static int xpcs_config_eee(struct mdio_xpcs_args *xpcs, int mult_fact_100ns,
 	ret |= DW_VR_MII_EEE_TRN_LPI;
 	return xpcs_write(xpcs, MDIO_MMD_VEND2, DW_VR_MII_EEE_MCTRL1, ret);
 }
+EXPORT_SYMBOL_GPL(xpcs_config_eee);
 
 static int xpcs_config_aneg_c37_sgmii(struct mdio_xpcs_args *xpcs)
 {
@@ -1033,7 +1034,6 @@ static struct mdio_xpcs_ops xpcs_ops = {
 	.get_state = xpcs_get_state,
 	.link_up = xpcs_link_up,
 	.probe = xpcs_probe,
-	.config_eee = xpcs_config_eee,
 };
 
 struct mdio_xpcs_ops *mdio_xpcs_get_ops(void)
diff --git a/include/linux/pcs/pcs-xpcs.h b/include/linux/pcs/pcs-xpcs.h
index 5ec9aaca01fe..ae74a336dcb9 100644
--- a/include/linux/pcs/pcs-xpcs.h
+++ b/include/linux/pcs/pcs-xpcs.h
@@ -30,13 +30,13 @@ struct mdio_xpcs_ops {
 	int (*link_up)(struct mdio_xpcs_args *xpcs, int speed,
 		       phy_interface_t interface);
 	int (*probe)(struct mdio_xpcs_args *xpcs, phy_interface_t interface);
-	int (*config_eee)(struct mdio_xpcs_args *xpcs, int mult_fact_100ns,
-			  int enable);
 };
 
 int xpcs_get_an_mode(struct mdio_xpcs_args *xpcs, phy_interface_t interface);
 struct mdio_xpcs_ops *mdio_xpcs_get_ops(void);
 void xpcs_validate(struct mdio_xpcs_args *xpcs, unsigned long *supported,
 		   struct phylink_link_state *state);
+int xpcs_config_eee(struct mdio_xpcs_args *xpcs, int mult_fact_100ns,
+		    int enable);
 
 #endif /* __LINUX_PCS_XPCS_H */
-- 
2.25.1

