Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 3419F2C7FE6
	for <lists+netdev@lfdr.de>; Mon, 30 Nov 2020 09:31:40 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727721AbgK3IaO (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 30 Nov 2020 03:30:14 -0500
Received: from fllv0015.ext.ti.com ([198.47.19.141]:32810 "EHLO
        fllv0015.ext.ti.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1725972AbgK3IaN (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 30 Nov 2020 03:30:13 -0500
Received: from lelv0265.itg.ti.com ([10.180.67.224])
        by fllv0015.ext.ti.com (8.15.2/8.15.2) with ESMTP id 0AU8SO42117847;
        Mon, 30 Nov 2020 02:28:24 -0600
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=ti.com;
        s=ti-com-17Q1; t=1606724904;
        bh=um2hl1Bq2roKj2c9A6raYiZTuJdQqAJbr2VOZssIrNE=;
        h=From:To:CC:Subject:Date:In-Reply-To:References;
        b=xRjJ2apnQf8XwmaHVEgEpqLN69hyqvHT1hiwlOYZP4yedkvat77yMd+zd4DHm9NAs
         MD2gNdWJsjDxGj+pVGdA1fWvyPOy8E9X/rDppDBSZGb6Hfj2raydX0+3QJOBi30f4e
         0Wp57RNfdzmlYVMFNkGkxKCmj04OH/hY4rsLBB5Q=
Received: from DLEE112.ent.ti.com (dlee112.ent.ti.com [157.170.170.23])
        by lelv0265.itg.ti.com (8.15.2/8.15.2) with ESMTPS id 0AU8SOle017186
        (version=TLSv1.2 cipher=AES256-GCM-SHA384 bits=256 verify=FAIL);
        Mon, 30 Nov 2020 02:28:24 -0600
Received: from DLEE108.ent.ti.com (157.170.170.38) by DLEE112.ent.ti.com
 (157.170.170.23) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_128_CBC_SHA256_P256) id 15.1.1979.3; Mon, 30
 Nov 2020 02:28:24 -0600
Received: from fllv0040.itg.ti.com (10.64.41.20) by DLEE108.ent.ti.com
 (157.170.170.38) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_128_CBC_SHA256_P256) id 15.1.1979.3 via
 Frontend Transport; Mon, 30 Nov 2020 02:28:23 -0600
Received: from ula0132425.ent.ti.com (ileax41-snat.itg.ti.com [10.172.224.153])
        by fllv0040.itg.ti.com (8.15.2/8.15.2) with ESMTP id 0AU8S9Ds057144;
        Mon, 30 Nov 2020 02:28:20 -0600
From:   Vignesh Raghavendra <vigneshr@ti.com>
To:     "David S . Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>,
        Grygorii Strashko <grygorii.strashko@ti.com>
CC:     Jonathan Corbet <corbet@lwn.net>, Jiri Pirko <jiri@nvidia.com>,
        Vignesh Raghavendra <vigneshr@ti.com>,
        <netdev@vger.kernel.org>, <linux-doc@vger.kernel.org>,
        <linux-kernel@vger.kernel.org>,
        Linux ARM Mailing List <linux-arm-kernel@lists.infradead.org>
Subject: [PATCH 2/4] net: ti: am65-cpsw-nuss: Add netdevice notifiers
Date:   Mon, 30 Nov 2020 13:50:44 +0530
Message-ID: <20201130082046.16292-3-vigneshr@ti.com>
X-Mailer: git-send-email 2.29.2
In-Reply-To: <20201130082046.16292-1-vigneshr@ti.com>
References: <20201130082046.16292-1-vigneshr@ti.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-EXCLAIMER-MD-CONFIG: e1e8a2fd-e40a-4ac6-ac9b-f7e9cc9ee180
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Register netdevice notifiers in order to receive notification when
individual MAC ports are added to the HW bridge.

Signed-off-by: Vignesh Raghavendra <vigneshr@ti.com>
---
 drivers/net/ethernet/ti/am65-cpsw-nuss.c | 130 ++++++++++++++++++++++-
 drivers/net/ethernet/ti/am65-cpsw-nuss.h |   4 +
 2 files changed, 133 insertions(+), 1 deletion(-)

diff --git a/drivers/net/ethernet/ti/am65-cpsw-nuss.c b/drivers/net/ethernet/ti/am65-cpsw-nuss.c
index a635f6be7979..a7e5a0489aec 100644
--- a/drivers/net/ethernet/ti/am65-cpsw-nuss.c
+++ b/drivers/net/ethernet/ti/am65-cpsw-nuss.c
@@ -2023,6 +2023,126 @@ static void am65_cpsw_nuss_cleanup_ndev(struct am65_cpsw_common *common)
 	}
 }
 
+static void am65_cpsw_port_offload_fwd_mark_update(struct am65_cpsw_common *common)
+{
+	int set_val = 0;
+	int i;
+
+	if (common->br_members == (GENMASK(common->port_num, 1) & ~common->disabled_ports_mask))
+		set_val = 1;
+
+	dev_dbg(common->dev, "set offload_fwd_mark %d\n", set_val);
+
+	for (i = 1; i <= common->port_num; i++) {
+		struct am65_cpsw_port *port = am65_common_get_port(common, i);
+		struct am65_cpsw_ndev_priv *priv = am65_ndev_to_priv(port->ndev);
+
+		priv->offload_fwd_mark = set_val;
+	}
+}
+
+bool am65_cpsw_port_dev_check(const struct net_device *ndev)
+{
+	if (ndev->netdev_ops == &am65_cpsw_nuss_netdev_ops) {
+		struct am65_cpsw_common *common = am65_ndev_to_common(ndev);
+
+		return !common->is_emac_mode;
+	}
+
+	return false;
+}
+
+static int am65_cpsw_netdevice_port_link(struct net_device *ndev, struct net_device *br_ndev)
+{
+	struct am65_cpsw_common *common = am65_ndev_to_common(ndev);
+	struct am65_cpsw_ndev_priv *priv = am65_ndev_to_priv(ndev);
+
+	if (!common->br_members) {
+		common->hw_bridge_dev = br_ndev;
+	} else {
+		/* This is adding the port to a second bridge, this is
+		 * unsupported
+		 */
+		if (common->hw_bridge_dev != br_ndev)
+			return -EOPNOTSUPP;
+	}
+
+	common->br_members |= BIT(priv->port->port_id);
+
+	am65_cpsw_port_offload_fwd_mark_update(common);
+
+	return NOTIFY_DONE;
+}
+
+static void am65_cpsw_netdevice_port_unlink(struct net_device *ndev)
+{
+	struct am65_cpsw_common *common = am65_ndev_to_common(ndev);
+	struct am65_cpsw_ndev_priv *priv = am65_ndev_to_priv(ndev);
+
+	common->br_members &= ~BIT(priv->port->port_id);
+
+	am65_cpsw_port_offload_fwd_mark_update(common);
+
+	if (!common->br_members)
+		common->hw_bridge_dev = NULL;
+}
+
+/* netdev notifier */
+static int am65_cpsw_netdevice_event(struct notifier_block *unused,
+				     unsigned long event, void *ptr)
+{
+	struct net_device *ndev = netdev_notifier_info_to_dev(ptr);
+	struct netdev_notifier_changeupper_info *info;
+	int ret = NOTIFY_DONE;
+
+	if (!am65_cpsw_port_dev_check(ndev))
+		return NOTIFY_DONE;
+
+	switch (event) {
+	case NETDEV_CHANGEUPPER:
+		info = ptr;
+
+		if (netif_is_bridge_master(info->upper_dev)) {
+			if (info->linking)
+				ret = am65_cpsw_netdevice_port_link(ndev, info->upper_dev);
+			else
+				am65_cpsw_netdevice_port_unlink(ndev);
+		}
+		break;
+	default:
+		return NOTIFY_DONE;
+	}
+
+	return notifier_from_errno(ret);
+}
+
+static int am65_cpsw_register_notifiers(struct am65_cpsw_common *cpsw)
+{
+	int ret = 0;
+
+	if (AM65_CPSW_IS_CPSW2G(cpsw) ||
+	    !IS_REACHABLE(CONFIG_TI_K3_AM65_CPSW_SWITCHDEV))
+		return 0;
+
+	cpsw->am65_cpsw_netdevice_nb.notifier_call = &am65_cpsw_netdevice_event;
+	ret = register_netdevice_notifier(&cpsw->am65_cpsw_netdevice_nb);
+	if (ret) {
+		dev_err(cpsw->dev, "can't register netdevice notifier\n");
+		return ret;
+	}
+
+	return ret;
+}
+
+static void am65_cpsw_unregister_notifiers(struct am65_cpsw_common *cpsw)
+{
+	if (AM65_CPSW_IS_CPSW2G(cpsw) ||
+	    !IS_REACHABLE(CONFIG_TI_K3_AM65_CPSW_SWITCHDEV))
+		return;
+
+	unregister_netdevice_notifier(&cpsw->am65_cpsw_netdevice_nb);
+}
+
 static const struct devlink_ops am65_cpsw_devlink_ops = {};
 
 static void am65_cpsw_init_stp_ale_entry(struct am65_cpsw_common *cpsw)
@@ -2366,17 +2486,24 @@ static int am65_cpsw_nuss_register_ndevs(struct am65_cpsw_common *common)
 		}
 	}
 
-	ret = am65_cpsw_nuss_register_devlink(common);
+	ret = am65_cpsw_register_notifiers(common);
 	if (ret)
 		goto err_cleanup_ndev;
 
+	ret = am65_cpsw_nuss_register_devlink(common);
+	if (ret)
+		goto clean_unregister_notifiers;
+
 	/* can't auto unregister ndev using devm_add_action() due to
 	 * devres release sequence in DD core for DMA
 	 */
 
 	return 0;
+clean_unregister_notifiers:
+	am65_cpsw_unregister_notifiers(common);
 err_cleanup_ndev:
 	am65_cpsw_nuss_cleanup_ndev(common);
+
 	return ret;
 }
 
@@ -2607,6 +2734,7 @@ static int am65_cpsw_nuss_remove(struct platform_device *pdev)
 	}
 
 	am65_cpsw_unregister_devlink(common);
+	am65_cpsw_unregister_notifiers(common);
 
 	/* must unregister ndevs here because DD release_driver routine calls
 	 * dma_deconfigure(dev) before devres_release_all(dev)
diff --git a/drivers/net/ethernet/ti/am65-cpsw-nuss.h b/drivers/net/ethernet/ti/am65-cpsw-nuss.h
index 153181e894b2..2bd718f5307e 100644
--- a/drivers/net/ethernet/ti/am65-cpsw-nuss.h
+++ b/drivers/net/ethernet/ti/am65-cpsw-nuss.h
@@ -135,6 +135,8 @@ struct am65_cpsw_common {
 	u16			br_members;
 	int			default_vlan;
 	struct devlink *devlink;
+	struct net_device *hw_bridge_dev;
+	struct notifier_block am65_cpsw_netdevice_nb;
 	unsigned char switch_id[MAX_PHYS_ITEM_ID_LEN];
 };
 
@@ -178,4 +180,6 @@ void am65_cpsw_nuss_set_p0_ptype(struct am65_cpsw_common *common);
 void am65_cpsw_nuss_remove_tx_chns(struct am65_cpsw_common *common);
 int am65_cpsw_nuss_update_tx_chns(struct am65_cpsw_common *common, int num_tx);
 
+bool am65_cpsw_port_dev_check(const struct net_device *dev);
+
 #endif /* AM65_CPSW_NUSS_H_ */
-- 
2.29.2

