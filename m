Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 0100A483906
	for <lists+netdev@lfdr.de>; Tue,  4 Jan 2022 00:26:09 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230502AbiACX0B (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 3 Jan 2022 18:26:01 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:47946 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230490AbiACXZ7 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 3 Jan 2022 18:25:59 -0500
Received: from mail-pg1-x533.google.com (mail-pg1-x533.google.com [IPv6:2607:f8b0:4864:20::533])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 96416C061761;
        Mon,  3 Jan 2022 15:25:59 -0800 (PST)
Received: by mail-pg1-x533.google.com with SMTP id x194so7972621pgx.4;
        Mon, 03 Jan 2022 15:25:59 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=from:to:cc:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=s8UxwvmkIsqGsTpVpE5Hu0C6rAGO/S5eDabYd0ebEco=;
        b=V4Fiu7UovDGhwD+9jwq9p8a5Pi/KmyePIwRa+p/C4koXbD8Y00KruT93l5++uR63iZ
         hhGvtO3uxNI1QaNY2e8iHZShwHWEbRlBxAJPXtVOcE6vwEu/0vDg6TF6/8e9jzjtiN2D
         Ac+sMz1Rv50GTZ7RUNe7B6ljw7LIrorVvgr/vV5HOEhIh07hsyslzflfEYlE3pkfNUn6
         xoEJrGEOkI1yIVxQr4VFRwLHRzq3+rKpd8LXNK44JOJkYNcNpyB3+SZ5T6nBv2/f9YKJ
         MlmaSo4d/QXXrbTWbuXNi07j0UqLlhAi+Yo6XjolMM28E+1dcroCbJEAuRAUwr1/CT2n
         ydqw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=s8UxwvmkIsqGsTpVpE5Hu0C6rAGO/S5eDabYd0ebEco=;
        b=o8PVT8nKMpXmrvdKHhT+DpsMDCti/FXUr9ZcAa+sgxtzcl26JqMhNma/CSmiA20FvM
         mg0QWpfQqagyvmOlMwjeLYRlaY7k2tdwZxWRmxrfhngNmDNlacwS12a9hOPFnQBD4g0R
         +u6l5uXuALHoiAsIXT7VwUrFhL7uVUsPwzT3Vz7bl6rqJL9bxynRIInjMCKCxZzA5Zd/
         sPWqJWcHKyGT3qcPy2qoD38zzkj30IiIULLxS0NoPAm5mp3SKHYsoVg5HMDBTyNMHLS1
         HICd1N2ZRPDXvricXOjHBeM+d60TLrCHbDutY8DzSBK0V0NxtTMe9ZALo9Rxsog1tApY
         pZMQ==
X-Gm-Message-State: AOAM5335hzj2JiR7U10TJ2aMyRLp6SbCLPCDU88KJTaqywbznY63t0SJ
        x6txg1OYlP4tEEJkpLPs2v1468aw36M=
X-Google-Smtp-Source: ABdhPJzgxwG2LIaWzNKuFcqrQmws+Vz9rzG2gt7XW61SY71WyXxrK8/12fiNhaLA8mrpqipawYdtRQ==
X-Received: by 2002:a62:7c58:0:b0:4bb:314b:86b9 with SMTP id x85-20020a627c58000000b004bb314b86b9mr48290021pfc.84.1641252358834;
        Mon, 03 Jan 2022 15:25:58 -0800 (PST)
Received: from localhost.localdomain ([2601:640:8200:33:e2d5:5eff:fea5:802f])
        by smtp.gmail.com with ESMTPSA id k6sm41340191pff.106.2022.01.03.15.25.57
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 03 Jan 2022 15:25:58 -0800 (PST)
From:   Richard Cochran <richardcochran@gmail.com>
To:     netdev@vger.kernel.org
Cc:     linux-kernel@vger.kernel.org, Andrew Lunn <andrew@lunn.ch>,
        David Miller <davem@davemloft.net>,
        Grygorii Strashko <grygorii.strashko@ti.com>,
        Jakub Kicinski <kuba@kernel.org>,
        Joakim Zhang <qiangqing.zhang@nxp.com>,
        Kurt Kanzenbach <kurt@linutronix.de>,
        Miroslav Lichvar <mlichvar@redhat.com>,
        Russell King <linux@arm.linux.org.uk>,
        Vladimir Oltean <vladimir.oltean@nxp.com>
Subject: [PATCH RFC V1 net-next 1/4] net: ethtool: Refactor identical get_ts_info implementations.
Date:   Mon,  3 Jan 2022 15:25:52 -0800
Message-Id: <20220103232555.19791-2-richardcochran@gmail.com>
X-Mailer: git-send-email 2.20.1
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Both the vlan and the bonding drivers call their "real" device driver
in order to report the time stamping capabilities.  Provide a core
ethtool helper function to avoid copy/paste in the stack.

Signed-off-by: Richard Cochran <richardcochran@gmail.com>
---
 drivers/net/bonding/bond_main.c | 14 ++------------
 include/linux/ethtool.h         |  8 ++++++++
 net/8021q/vlan_dev.c            | 15 +--------------
 net/ethtool/common.c            |  6 ++++++
 4 files changed, 17 insertions(+), 26 deletions(-)

diff --git a/drivers/net/bonding/bond_main.c b/drivers/net/bonding/bond_main.c
index b60e22f6394a..f28b88b67b9e 100644
--- a/drivers/net/bonding/bond_main.c
+++ b/drivers/net/bonding/bond_main.c
@@ -5353,23 +5353,13 @@ static int bond_ethtool_get_ts_info(struct net_device *bond_dev,
 				    struct ethtool_ts_info *info)
 {
 	struct bonding *bond = netdev_priv(bond_dev);
-	const struct ethtool_ops *ops;
 	struct net_device *real_dev;
-	struct phy_device *phydev;
 
 	rcu_read_lock();
 	real_dev = bond_option_active_slave_get_rcu(bond);
 	rcu_read_unlock();
-	if (real_dev) {
-		ops = real_dev->ethtool_ops;
-		phydev = real_dev->phydev;
-
-		if (phy_has_tsinfo(phydev)) {
-			return phy_ts_info(phydev, info);
-		} else if (ops->get_ts_info) {
-			return ops->get_ts_info(real_dev, info);
-		}
-	}
+	if (real_dev)
+		return ethtool_get_ts_info_by_layer(real_dev, info);
 
 	info->so_timestamping = SOF_TIMESTAMPING_RX_SOFTWARE |
 				SOF_TIMESTAMPING_SOFTWARE;
diff --git a/include/linux/ethtool.h b/include/linux/ethtool.h
index a26f37a27167..1d72344493bb 100644
--- a/include/linux/ethtool.h
+++ b/include/linux/ethtool.h
@@ -824,6 +824,14 @@ ethtool_params_from_link_mode(struct ethtool_link_ksettings *link_ksettings,
  */
 int ethtool_get_phc_vclocks(struct net_device *dev, int **vclock_index);
 
+/**
+ * ethtool_get_ts_info_by_layer - Obtains time stamping capabilities from the MAC or PHY layer.
+ * @dev: pointer to net_device structure
+ * @info: buffer to hold the result
+ * Returns zero on sauces, non-zero otherwise.
+ */
+int ethtool_get_ts_info_by_layer(struct net_device *dev, struct ethtool_ts_info *info);
+
 /**
  * ethtool_sprintf - Write formatted string to ethtool string data
  * @data: Pointer to start of string to update
diff --git a/net/8021q/vlan_dev.c b/net/8021q/vlan_dev.c
index 26d031a43cc1..c645d7c46d78 100644
--- a/net/8021q/vlan_dev.c
+++ b/net/8021q/vlan_dev.c
@@ -679,20 +679,7 @@ static int vlan_ethtool_get_ts_info(struct net_device *dev,
 				    struct ethtool_ts_info *info)
 {
 	const struct vlan_dev_priv *vlan = vlan_dev_priv(dev);
-	const struct ethtool_ops *ops = vlan->real_dev->ethtool_ops;
-	struct phy_device *phydev = vlan->real_dev->phydev;
-
-	if (phy_has_tsinfo(phydev)) {
-		return phy_ts_info(phydev, info);
-	} else if (ops->get_ts_info) {
-		return ops->get_ts_info(vlan->real_dev, info);
-	} else {
-		info->so_timestamping = SOF_TIMESTAMPING_RX_SOFTWARE |
-			SOF_TIMESTAMPING_SOFTWARE;
-		info->phc_index = -1;
-	}
-
-	return 0;
+	return ethtool_get_ts_info_by_layer(vlan->real_dev, info);
 }
 
 static void vlan_dev_get_stats64(struct net_device *dev,
diff --git a/net/ethtool/common.c b/net/ethtool/common.c
index 0c5210015911..651d18eef589 100644
--- a/net/ethtool/common.c
+++ b/net/ethtool/common.c
@@ -569,6 +569,12 @@ int ethtool_get_phc_vclocks(struct net_device *dev, int **vclock_index)
 }
 EXPORT_SYMBOL(ethtool_get_phc_vclocks);
 
+int ethtool_get_ts_info_by_layer(struct net_device *dev, struct ethtool_ts_info *info)
+{
+	return __ethtool_get_ts_info(dev, info);
+}
+EXPORT_SYMBOL(ethtool_get_ts_info_by_layer);
+
 const struct ethtool_phy_ops *ethtool_phy_ops;
 
 void ethtool_set_ethtool_phy_ops(const struct ethtool_phy_ops *ops)
-- 
2.20.1

