Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 265EE3C73CE
	for <lists+netdev@lfdr.de>; Tue, 13 Jul 2021 18:07:57 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229978AbhGMQKp (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 13 Jul 2021 12:10:45 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:38412 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229454AbhGMQKm (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 13 Jul 2021 12:10:42 -0400
Received: from nbd.name (nbd.name [IPv6:2a01:4f8:221:3d45::2])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id B13B7C0613EF;
        Tue, 13 Jul 2021 09:07:51 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed; d=nbd.name;
         s=20160729; h=Content-Transfer-Encoding:MIME-Version:References:In-Reply-To:
        Message-Id:Date:Subject:Cc:To:From:Sender:Reply-To:Content-Type:Content-ID:
        Content-Description:Resent-Date:Resent-From:Resent-Sender:Resent-To:Resent-Cc
        :Resent-Message-ID:List-Id:List-Help:List-Unsubscribe:List-Subscribe:
        List-Post:List-Owner:List-Archive;
        bh=sFwfQ9Uw9O52hL6lZwNWeKhI6xCaEO5BECLZyahskzE=; b=WIXyCvBWmlGG7bhrM1hmyXMGev
        rbXCcSGxJxF7nkCV1A4F9+YO3/3I2VVWrgqq7cgJFG3d2G9Tig4XT0XA9JGGJKrgNMB9S3I6Y89JL
        TIycZopmt7OdCFV1753Ufg39eu2Wa0dVJp+1hTxeQYlEEszOmTIa5LnEsK4Cb479JK7Q=;
Received: from p54ae93f7.dip0.t-ipconnect.de ([84.174.147.247] helo=localhost.localdomain)
        by ds12 with esmtpsa (TLS1.2:ECDHE_RSA_AES_128_GCM_SHA256:128)
        (Exim 4.89)
        (envelope-from <nbd@nbd.name>)
        id 1m3Kwm-0008TX-Rd; Tue, 13 Jul 2021 18:07:48 +0200
From:   Felix Fietkau <nbd@nbd.name>
To:     linux-wireless@vger.kernel.org
Cc:     netdev@vger.kernel.org, pablo@netfilter.org, ryder.lee@mediatek.com
Subject: [RFC 3/7] net: ethernet: mtk_eth_soc: implement flow offloading to WED devices
Date:   Tue, 13 Jul 2021 18:07:41 +0200
Message-Id: <20210713160745.59707-4-nbd@nbd.name>
X-Mailer: git-send-email 2.30.1
In-Reply-To: <20210713160745.59707-1-nbd@nbd.name>
References: <20210713160745.59707-1-nbd@nbd.name>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

This allows hardware flow offloading from Ethernet to WLAN on MT7622 SoC

Signed-off-by: Felix Fietkau <nbd@nbd.name>
---
 drivers/net/ethernet/mediatek/mtk_ppe.c       | 18 +++++
 drivers/net/ethernet/mediatek/mtk_ppe.h       | 14 ++--
 .../net/ethernet/mediatek/mtk_ppe_offload.c   | 67 ++++++++++++-------
 include/linux/netdevice.h                     |  7 ++
 net/core/dev.c                                |  4 ++
 5 files changed, 78 insertions(+), 32 deletions(-)

diff --git a/drivers/net/ethernet/mediatek/mtk_ppe.c b/drivers/net/ethernet/mediatek/mtk_ppe.c
index 3ad10c793308..472bcd3269a7 100644
--- a/drivers/net/ethernet/mediatek/mtk_ppe.c
+++ b/drivers/net/ethernet/mediatek/mtk_ppe.c
@@ -329,6 +329,24 @@ int mtk_foe_entry_set_pppoe(struct mtk_foe_entry *entry, int sid)
 	return 0;
 }
 
+int mtk_foe_entry_set_wdma(struct mtk_foe_entry *entry, int wdma_idx, int txq,
+			   int bss, int wcid)
+{
+	struct mtk_foe_mac_info *l2 = mtk_foe_entry_l2(entry);
+	u32 *ib2 = mtk_foe_entry_ib2(entry);
+
+	*ib2 &= ~MTK_FOE_IB2_PORT_MG;
+	*ib2 |= MTK_FOE_IB2_WDMA_WINFO;
+	if (wdma_idx)
+		*ib2 |= MTK_FOE_IB2_WDMA_DEVIDX;
+
+	l2->vlan2 = FIELD_PREP(MTK_FOE_VLAN2_WINFO_BSS, bss) |
+		    FIELD_PREP(MTK_FOE_VLAN2_WINFO_WCID, wcid) |
+		    FIELD_PREP(MTK_FOE_VLAN2_WINFO_RING, txq);
+
+	return 0;
+}
+
 static inline bool mtk_foe_entry_usable(struct mtk_foe_entry *entry)
 {
 	return !(entry->ib1 & MTK_FOE_IB1_STATIC) &&
diff --git a/drivers/net/ethernet/mediatek/mtk_ppe.h b/drivers/net/ethernet/mediatek/mtk_ppe.h
index 242fb8f2ae65..df8ccaf48171 100644
--- a/drivers/net/ethernet/mediatek/mtk_ppe.h
+++ b/drivers/net/ethernet/mediatek/mtk_ppe.h
@@ -48,9 +48,9 @@ enum {
 #define MTK_FOE_IB2_DEST_PORT		GENMASK(7, 5)
 #define MTK_FOE_IB2_MULTICAST		BIT(8)
 
-#define MTK_FOE_IB2_WHNAT_QID2		GENMASK(13, 12)
-#define MTK_FOE_IB2_WHNAT_DEVIDX	BIT(16)
-#define MTK_FOE_IB2_WHNAT_NAT		BIT(17)
+#define MTK_FOE_IB2_WDMA_QID2		GENMASK(13, 12)
+#define MTK_FOE_IB2_WDMA_DEVIDX		BIT(16)
+#define MTK_FOE_IB2_WDMA_WINFO		BIT(17)
 
 #define MTK_FOE_IB2_PORT_MG		GENMASK(17, 12)
 
@@ -58,9 +58,9 @@ enum {
 
 #define MTK_FOE_IB2_DSCP		GENMASK(31, 24)
 
-#define MTK_FOE_VLAN2_WHNAT_BSS		GEMMASK(5, 0)
-#define MTK_FOE_VLAN2_WHNAT_WCID	GENMASK(13, 6)
-#define MTK_FOE_VLAN2_WHNAT_RING	GENMASK(15, 14)
+#define MTK_FOE_VLAN2_WINFO_BSS		GENMASK(5, 0)
+#define MTK_FOE_VLAN2_WINFO_WCID	GENMASK(13, 6)
+#define MTK_FOE_VLAN2_WINFO_RING	GENMASK(15, 14)
 
 enum {
 	MTK_FOE_STATE_INVALID,
@@ -281,6 +281,8 @@ int mtk_foe_entry_set_ipv6_tuple(struct mtk_foe_entry *entry,
 int mtk_foe_entry_set_dsa(struct mtk_foe_entry *entry, int port);
 int mtk_foe_entry_set_vlan(struct mtk_foe_entry *entry, int vid);
 int mtk_foe_entry_set_pppoe(struct mtk_foe_entry *entry, int sid);
+int mtk_foe_entry_set_wdma(struct mtk_foe_entry *entry, int wdma_idx, int txq,
+			   int bss, int wcid);
 int mtk_foe_entry_commit(struct mtk_ppe *ppe, struct mtk_foe_entry *entry,
 			 u16 timestamp);
 int mtk_ppe_debugfs_init(struct mtk_ppe *ppe);
diff --git a/drivers/net/ethernet/mediatek/mtk_ppe_offload.c b/drivers/net/ethernet/mediatek/mtk_ppe_offload.c
index b5f68f66d42a..00b1d06f60d1 100644
--- a/drivers/net/ethernet/mediatek/mtk_ppe_offload.c
+++ b/drivers/net/ethernet/mediatek/mtk_ppe_offload.c
@@ -10,6 +10,7 @@
 #include <net/pkt_cls.h>
 #include <net/dsa.h>
 #include "mtk_eth_soc.h"
+#include "mtk_wed.h"
 
 struct mtk_flow_data {
 	struct ethhdr eth;
@@ -39,6 +40,7 @@ struct mtk_flow_entry {
 	struct rhash_head node;
 	unsigned long cookie;
 	u16 hash;
+	s8 wed_index;
 };
 
 static const struct rhashtable_params mtk_flow_ht_params = {
@@ -127,35 +129,38 @@ mtk_flow_mangle_ipv4(const struct flow_action_entry *act,
 }
 
 static int
-mtk_flow_get_dsa_port(struct net_device **dev)
+mtk_flow_set_output_device(struct mtk_eth *eth, struct mtk_foe_entry *foe,
+			   struct net_device *dev, const u8 *dest_mac,
+			   int *wed_index)
 {
-#if IS_ENABLED(CONFIG_NET_DSA)
-	struct dsa_port *dp;
-
-	dp = dsa_port_from_netdev(*dev);
-	if (IS_ERR(dp))
-		return -ENODEV;
-
-	if (dp->cpu_dp->tag_ops->proto != DSA_TAG_PROTO_MTK)
-		return -ENODEV;
+	struct net_device_path_ctx ctx = {
+		.dev    = dev,
+		.daddr  = dest_mac,
+	};
+	struct net_device_path path = {};
+	int pse_port;
 
-	*dev = dp->cpu_dp->master;
+	if (!dev->netdev_ops->ndo_fill_forward_path ||
+	    dev->netdev_ops->ndo_fill_forward_path(&ctx, &path) < 0)
+		path.type = DEV_PATH_ETHERNET;
 
-	return dp->index;
-#else
-	return -ENODEV;
-#endif
-}
-
-static int
-mtk_flow_set_output_device(struct mtk_eth *eth, struct mtk_foe_entry *foe,
-			   struct net_device *dev)
-{
-	int pse_port, dsa_port;
+	switch (path.type) {
+	case DEV_PATH_DSA:
+		if (path.dsa.proto != DSA_TAG_PROTO_MTK)
+			break;
 
-	dsa_port = mtk_flow_get_dsa_port(&dev);
-	if (dsa_port >= 0)
-		mtk_foe_entry_set_dsa(foe, dsa_port);
+		mtk_foe_entry_set_dsa(foe, path.dsa.port);
+		break;
+	case DEV_PATH_MTK_WDMA:
+		mtk_foe_entry_set_wdma(foe, path.mtk_wdma.wdma_idx,
+				       path.mtk_wdma.queue, path.mtk_wdma.bss,
+				       path.mtk_wdma.wcid);
+		mtk_foe_entry_set_pse_port(foe, 3);
+		*wed_index = path.mtk_wdma.wdma_idx;
+		return 0;
+	default:
+		break;
+	}
 
 	if (dev == eth->netdev[0])
 		pse_port = 1;
@@ -179,6 +184,7 @@ mtk_flow_offload_replace(struct mtk_eth *eth, struct flow_cls_offload *f)
 	struct net_device *odev = NULL;
 	struct mtk_flow_entry *entry;
 	int offload_type = 0;
+	int wed_index = -1;
 	u16 addr_type = 0;
 	u32 timestamp;
 	u8 l4proto = 0;
@@ -323,10 +329,14 @@ mtk_flow_offload_replace(struct mtk_eth *eth, struct flow_cls_offload *f)
 	if (data.pppoe.num == 1)
 		mtk_foe_entry_set_pppoe(&foe, data.pppoe.sid);
 
-	err = mtk_flow_set_output_device(eth, &foe, odev);
+	err = mtk_flow_set_output_device(eth, &foe, odev, data.eth.h_dest,
+					 &wed_index);
 	if (err)
 		return err;
 
+	if (wed_index >= 0 && (err = mtk_wed_flow_add(wed_index)) < 0)
+		return err;
+
 	entry = kzalloc(sizeof(*entry), GFP_KERNEL);
 	if (!entry)
 		return -ENOMEM;
@@ -340,6 +350,7 @@ mtk_flow_offload_replace(struct mtk_eth *eth, struct flow_cls_offload *f)
 	}
 
 	entry->hash = hash;
+	entry->wed_index = wed_index;
 	err = rhashtable_insert_fast(&eth->flow_table, &entry->node,
 				     mtk_flow_ht_params);
 	if (err < 0)
@@ -350,6 +361,8 @@ mtk_flow_offload_replace(struct mtk_eth *eth, struct flow_cls_offload *f)
 	mtk_foe_entry_clear(&eth->ppe, hash);
 free:
 	kfree(entry);
+	if (wed_index >= 0)
+	    mtk_wed_flow_remove(wed_index);
 	return err;
 }
 
@@ -366,6 +379,8 @@ mtk_flow_offload_destroy(struct mtk_eth *eth, struct flow_cls_offload *f)
 	mtk_foe_entry_clear(&eth->ppe, entry->hash);
 	rhashtable_remove_fast(&eth->flow_table, &entry->node,
 			       mtk_flow_ht_params);
+	if (entry->wed_index >= 0)
+		mtk_wed_flow_remove(entry->wed_index);
 	kfree(entry);
 
 	return 0;
diff --git a/include/linux/netdevice.h b/include/linux/netdevice.h
index eaf5bb008aa9..67bba2826bc4 100644
--- a/include/linux/netdevice.h
+++ b/include/linux/netdevice.h
@@ -856,6 +856,7 @@ enum net_device_path_type {
 	DEV_PATH_BRIDGE,
 	DEV_PATH_PPPOE,
 	DEV_PATH_DSA,
+	DEV_PATH_MTK_WDMA,
 };
 
 struct net_device_path {
@@ -881,6 +882,12 @@ struct net_device_path {
 			int port;
 			u16 proto;
 		} dsa;
+		struct {
+			u8 wdma_idx;
+			u8 queue;
+			u8 bss;
+			u8 wcid;
+		} mtk_wdma;
 	};
 };
 
diff --git a/net/core/dev.c b/net/core/dev.c
index c253c2aafe97..7ea6a1db0338 100644
--- a/net/core/dev.c
+++ b/net/core/dev.c
@@ -885,6 +885,10 @@ int dev_fill_forward_path(const struct net_device *dev, const u8 *daddr,
 		if (WARN_ON_ONCE(last_dev == ctx.dev))
 			return -1;
 	}
+
+	if (!ctx.dev)
+		return ret;
+
 	path = dev_fwd_path(stack);
 	if (!path)
 		return -1;
-- 
2.30.1

