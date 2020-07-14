Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id EBB7821F96E
	for <lists+netdev@lfdr.de>; Tue, 14 Jul 2020 20:30:22 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729214AbgGNS3m (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 14 Jul 2020 14:29:42 -0400
Received: from mail.kernel.org ([198.145.29.99]:35100 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1729132AbgGNS3j (ORCPT <rfc822;netdev@vger.kernel.org>);
        Tue, 14 Jul 2020 14:29:39 -0400
Received: from kicinski-fedora-PC1C0HJN.thefacebook.com (unknown [163.114.132.1])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 845DF229C6;
        Tue, 14 Jul 2020 18:29:37 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1594751378;
        bh=WB8Cv4RNpsjghADCNiN8s2GY2rN5Uf1Wb5SRBNBT53Q=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=ZbpY+eiERc7+2oHTWz7IvIkjHOVbOLnv0D0bAHsfkrk5RfwK1KsDm9roKPjb3s3bY
         Wm8vl0aTEfmMoslwSkzUubx2RbFdqLw0tmlyghhMq0cQgtYYYe6WctyQi+wKNI/L5/
         S9rzBkQE9DHoAlxPZaZRE60kRLGCm6rUm/S+8Lek=
From:   Jakub Kicinski <kuba@kernel.org>
To:     davem@davemloft.net
Cc:     netdev@vger.kernel.org, oss-drivers@netronome.com,
        simon.horman@netronome.com, ajit.khaparde@broadcom.com,
        sriharsha.basavapatna@broadcom.com, somnath.kotur@broadcom.com,
        thomas.lendacky@amd.com, aelior@marvell.com, skalluru@marvell.com,
        vishal@chelsio.com, benve@cisco.com, _govind@gmx.com,
        dchickles@marvell.com, sburla@marvell.com, fmanlunas@marvell.com,
        jeffrey.t.kirsher@intel.com, anthony.l.nguyen@intel.com,
        GR-everest-linux-l2@marvell.com, shshaikh@marvell.com,
        manishc@marvell.com, GR-Linux-NIC-Dev@marvell.com,
        Jakub Kicinski <kuba@kernel.org>
Subject: [PATCH net-next v2 11/12] qede: convert to new udp_tunnel_nic infra
Date:   Tue, 14 Jul 2020 11:29:07 -0700
Message-Id: <20200714182908.690108-12-kuba@kernel.org>
X-Mailer: git-send-email 2.26.2
In-Reply-To: <20200714182908.690108-1-kuba@kernel.org>
References: <20200714182908.690108-1-kuba@kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Covert to new infra. Looks like this driver was not doing
ref counting, and sleeping in the callback.

Signed-off-by: Jakub Kicinski <kuba@kernel.org>
---
 drivers/net/ethernet/qlogic/qede/qede.h       |   1 +
 .../net/ethernet/qlogic/qede/qede_filter.c    | 142 ++++++------------
 drivers/net/ethernet/qlogic/qede/qede_main.c  |  18 ++-
 3 files changed, 58 insertions(+), 103 deletions(-)

diff --git a/drivers/net/ethernet/qlogic/qede/qede.h b/drivers/net/ethernet/qlogic/qede/qede.h
index 591dd4051d06..8adda5dc9e88 100644
--- a/drivers/net/ethernet/qlogic/qede/qede.h
+++ b/drivers/net/ethernet/qlogic/qede/qede.h
@@ -543,6 +543,7 @@ void qede_set_dcbnl_ops(struct net_device *ndev);
 
 void qede_config_debug(uint debug, u32 *p_dp_module, u8 *p_dp_level);
 void qede_set_ethtool_ops(struct net_device *netdev);
+void qede_set_udp_tunnels(struct qede_dev *edev);
 void qede_reload(struct qede_dev *edev,
 		 struct qede_reload_args *args, bool is_locked);
 int qede_change_mtu(struct net_device *dev, int new_mtu);
diff --git a/drivers/net/ethernet/qlogic/qede/qede_filter.c b/drivers/net/ethernet/qlogic/qede/qede_filter.c
index d8100434e340..bb451c67a6f5 100644
--- a/drivers/net/ethernet/qlogic/qede/qede_filter.c
+++ b/drivers/net/ethernet/qlogic/qede/qede_filter.c
@@ -953,115 +953,67 @@ int qede_set_features(struct net_device *dev, netdev_features_t features)
 	return 0;
 }
 
-void qede_udp_tunnel_add(struct net_device *dev, struct udp_tunnel_info *ti)
+static int qede_udp_tunnel_sync(struct net_device *dev, unsigned int table)
 {
 	struct qede_dev *edev = netdev_priv(dev);
 	struct qed_tunn_params tunn_params;
-	u16 t_port = ntohs(ti->port);
+	struct udp_tunnel_info ti;
+	u16 *save_port;
 	int rc;
 
 	memset(&tunn_params, 0, sizeof(tunn_params));
 
-	switch (ti->type) {
-	case UDP_TUNNEL_TYPE_VXLAN:
-		if (!edev->dev_info.common.vxlan_enable)
-			return;
-
-		if (edev->vxlan_dst_port)
-			return;
-
+	udp_tunnel_nic_get_port(dev, table, 0, &ti);
+	if (ti.type == UDP_TUNNEL_TYPE_VXLAN) {
 		tunn_params.update_vxlan_port = 1;
-		tunn_params.vxlan_port = t_port;
-
-		__qede_lock(edev);
-		rc = edev->ops->tunn_config(edev->cdev, &tunn_params);
-		__qede_unlock(edev);
-
-		if (!rc) {
-			edev->vxlan_dst_port = t_port;
-			DP_VERBOSE(edev, QED_MSG_DEBUG, "Added vxlan port=%d\n",
-				   t_port);
-		} else {
-			DP_NOTICE(edev, "Failed to add vxlan UDP port=%d\n",
-				  t_port);
-		}
-
-		break;
-	case UDP_TUNNEL_TYPE_GENEVE:
-		if (!edev->dev_info.common.geneve_enable)
-			return;
-
-		if (edev->geneve_dst_port)
-			return;
-
+		tunn_params.vxlan_port = ntohs(ti.port);
+		save_port = &edev->vxlan_dst_port;
+	} else {
 		tunn_params.update_geneve_port = 1;
-		tunn_params.geneve_port = t_port;
-
-		__qede_lock(edev);
-		rc = edev->ops->tunn_config(edev->cdev, &tunn_params);
-		__qede_unlock(edev);
-
-		if (!rc) {
-			edev->geneve_dst_port = t_port;
-			DP_VERBOSE(edev, QED_MSG_DEBUG,
-				   "Added geneve port=%d\n", t_port);
-		} else {
-			DP_NOTICE(edev, "Failed to add geneve UDP port=%d\n",
-				  t_port);
-		}
-
-		break;
-	default:
-		return;
+		tunn_params.geneve_port = ntohs(ti.port);
+		save_port = &edev->geneve_dst_port;
 	}
-}
-
-void qede_udp_tunnel_del(struct net_device *dev,
-			 struct udp_tunnel_info *ti)
-{
-	struct qede_dev *edev = netdev_priv(dev);
-	struct qed_tunn_params tunn_params;
-	u16 t_port = ntohs(ti->port);
 
-	memset(&tunn_params, 0, sizeof(tunn_params));
-
-	switch (ti->type) {
-	case UDP_TUNNEL_TYPE_VXLAN:
-		if (t_port != edev->vxlan_dst_port)
-			return;
-
-		tunn_params.update_vxlan_port = 1;
-		tunn_params.vxlan_port = 0;
-
-		__qede_lock(edev);
-		edev->ops->tunn_config(edev->cdev, &tunn_params);
-		__qede_unlock(edev);
-
-		edev->vxlan_dst_port = 0;
-
-		DP_VERBOSE(edev, QED_MSG_DEBUG, "Deleted vxlan port=%d\n",
-			   t_port);
-
-		break;
-	case UDP_TUNNEL_TYPE_GENEVE:
-		if (t_port != edev->geneve_dst_port)
-			return;
-
-		tunn_params.update_geneve_port = 1;
-		tunn_params.geneve_port = 0;
+	__qede_lock(edev);
+	rc = edev->ops->tunn_config(edev->cdev, &tunn_params);
+	__qede_unlock(edev);
+	if (rc)
+		return rc;
 
-		__qede_lock(edev);
-		edev->ops->tunn_config(edev->cdev, &tunn_params);
-		__qede_unlock(edev);
+	*save_port = ntohs(ti.port);
+	return 0;
+}
 
-		edev->geneve_dst_port = 0;
+const struct udp_tunnel_nic_info qede_udp_tunnels_both = {
+	.sync_table	= qede_udp_tunnel_sync,
+	.flags		= UDP_TUNNEL_NIC_INFO_MAY_SLEEP,
+	.tables		= {
+		{ .n_entries = 1, .tunnel_types = UDP_TUNNEL_TYPE_VXLAN,  },
+		{ .n_entries = 1, .tunnel_types = UDP_TUNNEL_TYPE_GENEVE, },
+	},
+}, qede_udp_tunnels_vxlan = {
+	.sync_table	= qede_udp_tunnel_sync,
+	.flags		= UDP_TUNNEL_NIC_INFO_MAY_SLEEP,
+	.tables		= {
+		{ .n_entries = 1, .tunnel_types = UDP_TUNNEL_TYPE_VXLAN,  },
+	},
+}, qede_udp_tunnels_geneve = {
+	.sync_table	= qede_udp_tunnel_sync,
+	.flags		= UDP_TUNNEL_NIC_INFO_MAY_SLEEP,
+	.tables		= {
+		{ .n_entries = 1, .tunnel_types = UDP_TUNNEL_TYPE_GENEVE, },
+	},
+};
 
-		DP_VERBOSE(edev, QED_MSG_DEBUG, "Deleted geneve port=%d\n",
-			   t_port);
-		break;
-	default:
-		return;
-	}
+void qede_set_udp_tunnels(struct qede_dev *edev)
+{
+	if (edev->dev_info.common.vxlan_enable &&
+	    edev->dev_info.common.geneve_enable)
+		edev->ndev->udp_tunnel_nic_info = &qede_udp_tunnels_both;
+	else if (edev->dev_info.common.vxlan_enable)
+		edev->ndev->udp_tunnel_nic_info = &qede_udp_tunnels_vxlan;
+	else if (edev->dev_info.common.geneve_enable)
+		edev->ndev->udp_tunnel_nic_info = &qede_udp_tunnels_geneve;
 }
 
 static void qede_xdp_reload_func(struct qede_dev *edev,
diff --git a/drivers/net/ethernet/qlogic/qede/qede_main.c b/drivers/net/ethernet/qlogic/qede/qede_main.c
index 8cd27f8f1b3a..a653dd0e5c22 100644
--- a/drivers/net/ethernet/qlogic/qede/qede_main.c
+++ b/drivers/net/ethernet/qlogic/qede/qede_main.c
@@ -663,8 +663,8 @@ static const struct net_device_ops qede_netdev_ops = {
 	.ndo_get_vf_config = qede_get_vf_config,
 	.ndo_set_vf_rate = qede_set_vf_rate,
 #endif
-	.ndo_udp_tunnel_add = qede_udp_tunnel_add,
-	.ndo_udp_tunnel_del = qede_udp_tunnel_del,
+	.ndo_udp_tunnel_add = udp_tunnel_nic_add_port,
+	.ndo_udp_tunnel_del = udp_tunnel_nic_del_port,
 	.ndo_features_check = qede_features_check,
 	.ndo_bpf = qede_xdp,
 #ifdef CONFIG_RFS_ACCEL
@@ -687,8 +687,8 @@ static const struct net_device_ops qede_netdev_vf_ops = {
 	.ndo_fix_features = qede_fix_features,
 	.ndo_set_features = qede_set_features,
 	.ndo_get_stats64 = qede_get_stats64,
-	.ndo_udp_tunnel_add = qede_udp_tunnel_add,
-	.ndo_udp_tunnel_del = qede_udp_tunnel_del,
+	.ndo_udp_tunnel_add = udp_tunnel_nic_add_port,
+	.ndo_udp_tunnel_del = udp_tunnel_nic_del_port,
 	.ndo_features_check = qede_features_check,
 };
 
@@ -706,8 +706,8 @@ static const struct net_device_ops qede_netdev_vf_xdp_ops = {
 	.ndo_fix_features = qede_fix_features,
 	.ndo_set_features = qede_set_features,
 	.ndo_get_stats64 = qede_get_stats64,
-	.ndo_udp_tunnel_add = qede_udp_tunnel_add,
-	.ndo_udp_tunnel_del = qede_udp_tunnel_del,
+	.ndo_udp_tunnel_add = udp_tunnel_nic_add_port,
+	.ndo_udp_tunnel_del = udp_tunnel_nic_del_port,
 	.ndo_features_check = qede_features_check,
 	.ndo_bpf = qede_xdp,
 };
@@ -822,6 +822,8 @@ static void qede_init_ndev(struct qede_dev *edev)
 				NETIF_F_GSO_UDP_TUNNEL_CSUM);
 		ndev->hw_enc_features |= (NETIF_F_GSO_UDP_TUNNEL |
 					  NETIF_F_GSO_UDP_TUNNEL_CSUM);
+
+		qede_set_udp_tunnels(edev);
 	}
 
 	if (edev->dev_info.common.gre_enable) {
@@ -2421,7 +2423,7 @@ static int qede_open(struct net_device *ndev)
 	if (rc)
 		return rc;
 
-	udp_tunnel_get_rx_info(ndev);
+	udp_tunnel_nic_reset_ntf(ndev);
 
 	edev->ops->common->update_drv_state(edev->cdev, true);
 
@@ -2523,7 +2525,7 @@ static void qede_recovery_handler(struct qede_dev *edev)
 			goto err;
 
 		qede_config_rx_mode(edev->ndev);
-		udp_tunnel_get_rx_info(edev->ndev);
+		udp_tunnel_nic_reset_ntf(edev->ndev);
 	}
 
 	edev->state = curr_state;
-- 
2.26.2

