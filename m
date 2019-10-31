Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 7FA0FEAA0A
	for <lists+netdev@lfdr.de>; Thu, 31 Oct 2019 06:08:22 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726806AbfJaFIU (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 31 Oct 2019 01:08:20 -0400
Received: from mail-pg1-f194.google.com ([209.85.215.194]:34597 "EHLO
        mail-pg1-f194.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726321AbfJaFIU (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 31 Oct 2019 01:08:20 -0400
Received: by mail-pg1-f194.google.com with SMTP id e4so3167713pgs.1
        for <netdev@vger.kernel.org>; Wed, 30 Oct 2019 22:08:19 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=broadcom.com; s=google;
        h=from:to:cc:subject:date:message-id:in-reply-to:references;
        bh=dWyKmAWaYmT1p2HyJja2KLhSwTX7JbXm1LRoMDPRGI0=;
        b=bHbZmyZazf+4VNHJHFjPTpihKXex7PRU6Z4ootbxOKuJKZAPge7/rLYMr8FJXhDVhU
         0kz4IscnBMSRCuAKBnqzhWU9klCrOH6UpC+9HZCzOFoMknfofrtVWR631QfHtHYr0Z85
         20HAzC085vKzdbWdjuqbZsaO2Z8DhRctE5MiQ=
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references;
        bh=dWyKmAWaYmT1p2HyJja2KLhSwTX7JbXm1LRoMDPRGI0=;
        b=RfXgQ8HhLGrMfggWuKbxihRdABIzSFeXslYnl0ZeVk5K64pnvGBqTZrRLopYG9Y4QN
         TgGbXejLJcB2PjLwYqcccbFub3dQ6EEgjrSbK5ad7fvaz0BgMiRMhT+mj5znlvNBBAW6
         TVfT9n0WzVlt5RQb3HhJERC85fK0QpuunfZYB7bs2LEu6NONwpO5pn52n8si8STiAvSR
         WoEu3jXMDsALHzRcpb48XEG4jW+Fhga3D+8QxvlG9EQN06hNtFjJNO/uwEeGHmRJ68as
         0orpSVYXmCg4WmPaTX86kwBnRk8W2CeBwjg65V0KEhodGcvvnIKMPF+eAH47SC2RN3rv
         SnFA==
X-Gm-Message-State: APjAAAWGggYqJz7WVuQqtFkeIVOqH3xWoqmnm5m3dw2MRO4mgdvBeUuQ
        DXmAjCmsdZrkl2dtNWEHuUS2S83S4K0=
X-Google-Smtp-Source: APXvYqxbQqwsXBm4OVRzSQkFHVTxeZtRKwf0qgLdPaBmTuJ6GfzRFqMv+7jK/ObM6w+xrTKS67DzBw==
X-Received: by 2002:a62:1551:: with SMTP id 78mr3752021pfv.200.1572498499521;
        Wed, 30 Oct 2019 22:08:19 -0700 (PDT)
Received: from localhost.swdvt.lab.broadcom.com ([192.19.223.252])
        by smtp.gmail.com with ESMTPSA id a8sm1690899pff.5.2019.10.30.22.08.17
        (version=TLS1_2 cipher=ECDHE-RSA-AES128-GCM-SHA256 bits=128/128);
        Wed, 30 Oct 2019 22:08:19 -0700 (PDT)
From:   Michael Chan <michael.chan@broadcom.com>
To:     davem@davemloft.net
Cc:     netdev@vger.kernel.org,
        Sriharsha Basavapatna <sriharsha.basavapatna@broadcom.com>
Subject: [PATCH net-next v2 4/7] bnxt_en: flow_offload: offload tunnel decap rules via indirect callbacks
Date:   Thu, 31 Oct 2019 01:07:48 -0400
Message-Id: <1572498471-31550-5-git-send-email-michael.chan@broadcom.com>
X-Mailer: git-send-email 1.8.3.1
In-Reply-To: <1572498471-31550-1-git-send-email-michael.chan@broadcom.com>
References: <1572498471-31550-1-git-send-email-michael.chan@broadcom.com>
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Sriharsha Basavapatna <sriharsha.basavapatna@broadcom.com>

The decap (VXLAN tunnel) flow rules are not getting offloaded with
upstream kernel. This is because TC block callback infrastructure has
been updated to use indirect callbacks to get offloaded rules from
other higher level devices (such as tunnels), instead of ndo_setup_tc().
Since the decap rules are applied to the tunnel devices (e.g, vxlan_sys),
the driver should register for indirect TC callback with tunnel devices
to get the rules for offloading. This patch updates the driver to
register and process indirect TC block callbacks from VXLAN tunnels.

Signed-off-by: Sriharsha Basavapatna <sriharsha.basavapatna@broadcom.com>
Signed-off-by: Michael Chan <michael.chan@broadcom.com>
---
 drivers/net/ethernet/broadcom/bnxt/bnxt.c    |   2 +-
 drivers/net/ethernet/broadcom/bnxt/bnxt.h    |  12 +++
 drivers/net/ethernet/broadcom/bnxt/bnxt_tc.c | 153 ++++++++++++++++++++++++++-
 3 files changed, 165 insertions(+), 2 deletions(-)

diff --git a/drivers/net/ethernet/broadcom/bnxt/bnxt.c b/drivers/net/ethernet/broadcom/bnxt/bnxt.c
index 8cdf71f..708d724 100644
--- a/drivers/net/ethernet/broadcom/bnxt/bnxt.c
+++ b/drivers/net/ethernet/broadcom/bnxt/bnxt.c
@@ -10936,7 +10936,7 @@ static int bnxt_setup_tc_block_cb(enum tc_setup_type type, void *type_data,
 	}
 }
 
-static LIST_HEAD(bnxt_block_cb_list);
+LIST_HEAD(bnxt_block_cb_list);
 
 static int bnxt_setup_tc(struct net_device *dev, enum tc_setup_type type,
 			 void *type_data)
diff --git a/drivers/net/ethernet/broadcom/bnxt/bnxt.h b/drivers/net/ethernet/broadcom/bnxt/bnxt.h
index d333589..7bd8ad9 100644
--- a/drivers/net/ethernet/broadcom/bnxt/bnxt.h
+++ b/drivers/net/ethernet/broadcom/bnxt/bnxt.h
@@ -26,6 +26,8 @@
 #include <net/xdp.h>
 #include <linux/dim.h>
 
+extern struct list_head bnxt_block_cb_list;
+
 struct page_pool;
 
 struct tx_bd {
@@ -1241,6 +1243,14 @@ struct bnxt_tc_flow_stats {
 	u64		bytes;
 };
 
+#ifdef CONFIG_BNXT_FLOWER_OFFLOAD
+struct bnxt_flower_indr_block_cb_priv {
+	struct net_device *tunnel_netdev;
+	struct bnxt *bp;
+	struct list_head list;
+};
+#endif
+
 struct bnxt_tc_info {
 	bool				enabled;
 
@@ -1815,6 +1825,8 @@ struct bnxt {
 	u16			*cfa_code_map; /* cfa_code -> vf_idx map */
 	u8			switch_id[8];
 	struct bnxt_tc_info	*tc_info;
+	struct list_head	tc_indr_block_list;
+	struct notifier_block	tc_netdev_nb;
 	struct dentry		*debugfs_pdev;
 	struct device		*hwmon_dev;
 };
diff --git a/drivers/net/ethernet/broadcom/bnxt/bnxt_tc.c b/drivers/net/ethernet/broadcom/bnxt/bnxt_tc.c
index c801666..174412a 100644
--- a/drivers/net/ethernet/broadcom/bnxt/bnxt_tc.c
+++ b/drivers/net/ethernet/broadcom/bnxt/bnxt_tc.c
@@ -18,6 +18,7 @@
 #include <net/tc_act/tc_vlan.h>
 #include <net/tc_act/tc_pedit.h>
 #include <net/tc_act/tc_tunnel_key.h>
+#include <net/vxlan.h>
 
 #include "bnxt_hsi.h"
 #include "bnxt.h"
@@ -1841,6 +1842,147 @@ int bnxt_tc_setup_flower(struct bnxt *bp, u16 src_fid,
 	}
 }
 
+static int bnxt_tc_setup_indr_block_cb(enum tc_setup_type type,
+				       void *type_data, void *cb_priv)
+{
+	struct bnxt_flower_indr_block_cb_priv *priv = cb_priv;
+	struct flow_cls_offload *flower = type_data;
+	struct bnxt *bp = priv->bp;
+
+	if (flower->common.chain_index)
+		return -EOPNOTSUPP;
+
+	switch (type) {
+	case TC_SETUP_CLSFLOWER:
+		return bnxt_tc_setup_flower(bp, bp->pf.fw_fid, flower);
+	default:
+		return -EOPNOTSUPP;
+	}
+}
+
+static struct bnxt_flower_indr_block_cb_priv *
+bnxt_tc_indr_block_cb_lookup(struct bnxt *bp, struct net_device *netdev)
+{
+	struct bnxt_flower_indr_block_cb_priv *cb_priv;
+
+	/* All callback list access should be protected by RTNL. */
+	ASSERT_RTNL();
+
+	list_for_each_entry(cb_priv, &bp->tc_indr_block_list, list)
+		if (cb_priv->tunnel_netdev == netdev)
+			return cb_priv;
+
+	return NULL;
+}
+
+static void bnxt_tc_setup_indr_rel(void *cb_priv)
+{
+	struct bnxt_flower_indr_block_cb_priv *priv = cb_priv;
+
+	list_del(&priv->list);
+	kfree(priv);
+}
+
+static int bnxt_tc_setup_indr_block(struct net_device *netdev, struct bnxt *bp,
+				    struct flow_block_offload *f)
+{
+	struct bnxt_flower_indr_block_cb_priv *cb_priv;
+	struct flow_block_cb *block_cb;
+
+	if (f->binder_type != FLOW_BLOCK_BINDER_TYPE_CLSACT_INGRESS)
+		return -EOPNOTSUPP;
+
+	switch (f->command) {
+	case FLOW_BLOCK_BIND:
+		cb_priv = kmalloc(sizeof(*cb_priv), GFP_KERNEL);
+		if (!cb_priv)
+			return -ENOMEM;
+
+		cb_priv->tunnel_netdev = netdev;
+		cb_priv->bp = bp;
+		list_add(&cb_priv->list, &bp->tc_indr_block_list);
+
+		block_cb = flow_block_cb_alloc(bnxt_tc_setup_indr_block_cb,
+					       cb_priv, cb_priv,
+					       bnxt_tc_setup_indr_rel);
+		if (IS_ERR(block_cb)) {
+			list_del(&cb_priv->list);
+			kfree(cb_priv);
+			return PTR_ERR(block_cb);
+		}
+
+		flow_block_cb_add(block_cb, f);
+		list_add_tail(&block_cb->driver_list, &bnxt_block_cb_list);
+		break;
+	case FLOW_BLOCK_UNBIND:
+		cb_priv = bnxt_tc_indr_block_cb_lookup(bp, netdev);
+		if (!cb_priv)
+			return -ENOENT;
+
+		block_cb = flow_block_cb_lookup(f->block,
+						bnxt_tc_setup_indr_block_cb,
+						cb_priv);
+		if (!block_cb)
+			return -ENOENT;
+
+		flow_block_cb_remove(block_cb, f);
+		list_del(&block_cb->driver_list);
+		break;
+	default:
+		return -EOPNOTSUPP;
+	}
+	return 0;
+}
+
+static int bnxt_tc_setup_indr_cb(struct net_device *netdev, void *cb_priv,
+				 enum tc_setup_type type, void *type_data)
+{
+	switch (type) {
+	case TC_SETUP_BLOCK:
+		return bnxt_tc_setup_indr_block(netdev, cb_priv, type_data);
+	default:
+		return -EOPNOTSUPP;
+	}
+}
+
+static bool bnxt_is_netdev_indr_offload(struct net_device *netdev)
+{
+	return netif_is_vxlan(netdev);
+}
+
+static int bnxt_tc_indr_block_event(struct notifier_block *nb,
+				    unsigned long event, void *ptr)
+{
+	struct net_device *netdev;
+	struct bnxt *bp;
+	int rc;
+
+	netdev = netdev_notifier_info_to_dev(ptr);
+	if (!bnxt_is_netdev_indr_offload(netdev))
+		return NOTIFY_OK;
+
+	bp = container_of(nb, struct bnxt, tc_netdev_nb);
+
+	switch (event) {
+	case NETDEV_REGISTER:
+		rc = __flow_indr_block_cb_register(netdev, bp,
+						   bnxt_tc_setup_indr_cb,
+						   bp);
+		if (rc)
+			netdev_info(bp->dev,
+				    "Failed to register indirect blk: dev: %s",
+				    netdev->name);
+		break;
+	case NETDEV_UNREGISTER:
+		__flow_indr_block_cb_unregister(netdev,
+						bnxt_tc_setup_indr_cb,
+						bp);
+		break;
+	}
+
+	return NOTIFY_DONE;
+}
+
 static const struct rhashtable_params bnxt_tc_flow_ht_params = {
 	.head_offset = offsetof(struct bnxt_tc_flow_node, node),
 	.key_offset = offsetof(struct bnxt_tc_flow_node, cookie),
@@ -1924,7 +2066,15 @@ int bnxt_init_tc(struct bnxt *bp)
 	bp->dev->hw_features |= NETIF_F_HW_TC;
 	bp->dev->features |= NETIF_F_HW_TC;
 	bp->tc_info = tc_info;
-	return 0;
+
+	/* init indirect block notifications */
+	INIT_LIST_HEAD(&bp->tc_indr_block_list);
+	bp->tc_netdev_nb.notifier_call = bnxt_tc_indr_block_event;
+	rc = register_netdevice_notifier(&bp->tc_netdev_nb);
+	if (!rc)
+		return 0;
+
+	rhashtable_destroy(&tc_info->encap_table);
 
 destroy_decap_table:
 	rhashtable_destroy(&tc_info->decap_table);
@@ -1946,6 +2096,7 @@ void bnxt_shutdown_tc(struct bnxt *bp)
 	if (!bnxt_tc_flower_enabled(bp))
 		return;
 
+	unregister_netdevice_notifier(&bp->tc_netdev_nb);
 	rhashtable_destroy(&tc_info->flow_table);
 	rhashtable_destroy(&tc_info->l2_table);
 	rhashtable_destroy(&tc_info->decap_l2_table);
-- 
2.5.1

