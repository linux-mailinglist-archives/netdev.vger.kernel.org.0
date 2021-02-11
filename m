Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id B89523188FE
	for <lists+netdev@lfdr.de>; Thu, 11 Feb 2021 12:09:58 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231208AbhBKLEN (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 11 Feb 2021 06:04:13 -0500
Received: from fllv0016.ext.ti.com ([198.47.19.142]:54130 "EHLO
        fllv0016.ext.ti.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231401AbhBKK7E (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 11 Feb 2021 05:59:04 -0500
Received: from fllv0035.itg.ti.com ([10.64.41.0])
        by fllv0016.ext.ti.com (8.15.2/8.15.2) with ESMTP id 11BAvecL042941;
        Thu, 11 Feb 2021 04:57:40 -0600
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=ti.com;
        s=ti-com-17Q1; t=1613041060;
        bh=wKdgx03ghD+cRQp0RuzxI1q5nFW9wubNtP3D1nV5/zY=;
        h=From:To:CC:Subject:Date:In-Reply-To:References;
        b=Sxt5I1zP3Nwgk19m3qSVKbrqC4jq1F4lyWxTWgLlaxWN+ytn36cVRupumec9eVbmr
         9u1+uwITR7FKzHxR48xMWX22nhFHRdd1Spw7+qBVDG/4Kwr7yk/YMtbW75Y8Qza4xC
         Lmj0V5+Z64FbJlAaOkRJXDpzuVvJkNU2eCvh18cE=
Received: from DLEE111.ent.ti.com (dlee111.ent.ti.com [157.170.170.22])
        by fllv0035.itg.ti.com (8.15.2/8.15.2) with ESMTPS id 11BAvewq044997
        (version=TLSv1.2 cipher=AES256-GCM-SHA384 bits=256 verify=FAIL);
        Thu, 11 Feb 2021 04:57:40 -0600
Received: from DLEE109.ent.ti.com (157.170.170.41) by DLEE111.ent.ti.com
 (157.170.170.22) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_128_CBC_SHA256_P256) id 15.1.1979.3; Thu, 11
 Feb 2021 04:57:40 -0600
Received: from fllv0039.itg.ti.com (10.64.41.19) by DLEE109.ent.ti.com
 (157.170.170.41) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_128_CBC_SHA256_P256) id 15.1.1979.3 via
 Frontend Transport; Thu, 11 Feb 2021 04:57:40 -0600
Received: from ula0132425.ent.ti.com (ileax41-snat.itg.ti.com [10.172.224.153])
        by fllv0039.itg.ti.com (8.15.2/8.15.2) with ESMTP id 11BAvS0b045148;
        Thu, 11 Feb 2021 04:57:37 -0600
From:   Vignesh Raghavendra <vigneshr@ti.com>
To:     David S Miller <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>,
        Jonathan Corbet <corbet@lwn.net>, Jiri Pirko <jiri@nvidia.com>
CC:     Vignesh Raghavendra <vigneshr@ti.com>,
        Grygorii Strashko <grygorii.strashko@ti.com>,
        Andrew Lunn <andrew@lunn.ch>, <netdev@vger.kernel.org>,
        <linux-doc@vger.kernel.org>, <linux-kernel@vger.kernel.org>,
        Linux ARM Mailing List <linux-arm-kernel@lists.infradead.org>
Subject: [PATCH v2 2/4] net: ti: am65-cpsw-nuss: Add netdevice notifiers
Date:   Thu, 11 Feb 2021 16:26:42 +0530
Message-ID: <20210211105644.15521-3-vigneshr@ti.com>
X-Mailer: git-send-email 2.30.0
In-Reply-To: <20210211105644.15521-1-vigneshr@ti.com>
References: <20210211105644.15521-1-vigneshr@ti.com>
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
index 75dbd9239061..d26228395e8d 100644
--- a/drivers/net/ethernet/ti/am65-cpsw-nuss.c
+++ b/drivers/net/ethernet/ti/am65-cpsw-nuss.c
@@ -2036,6 +2036,126 @@ static void am65_cpsw_nuss_cleanup_ndev(struct am65_cpsw_common *common)
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
@@ -2379,17 +2499,24 @@ static int am65_cpsw_nuss_register_ndevs(struct am65_cpsw_common *common)
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
 
@@ -2628,6 +2755,7 @@ static int am65_cpsw_nuss_remove(struct platform_device *pdev)
 	}
 
 	am65_cpsw_unregister_devlink(common);
+	am65_cpsw_unregister_notifiers(common);
 
 	/* must unregister ndevs here because DD release_driver routine calls
 	 * dma_deconfigure(dev) before devres_release_all(dev)
diff --git a/drivers/net/ethernet/ti/am65-cpsw-nuss.h b/drivers/net/ethernet/ti/am65-cpsw-nuss.h
index c1b175762fd4..5d93e346f05e 100644
--- a/drivers/net/ethernet/ti/am65-cpsw-nuss.h
+++ b/drivers/net/ethernet/ti/am65-cpsw-nuss.h
@@ -137,6 +137,8 @@ struct am65_cpsw_common {
 	u16			br_members;
 	int			default_vlan;
 	struct devlink *devlink;
+	struct net_device *hw_bridge_dev;
+	struct notifier_block am65_cpsw_netdevice_nb;
 	unsigned char switch_id[MAX_PHYS_ITEM_ID_LEN];
 };
 
@@ -180,4 +182,6 @@ void am65_cpsw_nuss_set_p0_ptype(struct am65_cpsw_common *common);
 void am65_cpsw_nuss_remove_tx_chns(struct am65_cpsw_common *common);
 int am65_cpsw_nuss_update_tx_chns(struct am65_cpsw_common *common, int num_tx);
 
+bool am65_cpsw_port_dev_check(const struct net_device *dev);
+
 #endif /* AM65_CPSW_NUSS_H_ */
-- 
2.30.0

