Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 942744F53A5
	for <lists+netdev@lfdr.de>; Wed,  6 Apr 2022 06:36:40 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2361237AbiDFEZm (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 6 Apr 2022 00:25:42 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:47620 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1351862AbiDEUP3 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 5 Apr 2022 16:15:29 -0400
Received: from nbd.name (nbd.name [IPv6:2a01:4f8:221:3d45::2])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 7CED9F9FB6;
        Tue,  5 Apr 2022 12:58:20 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed; d=nbd.name;
         s=20160729; h=Content-Transfer-Encoding:MIME-Version:References:In-Reply-To:
        Message-Id:Date:Subject:Cc:To:From:Sender:Reply-To:Content-Type:Content-ID:
        Content-Description:Resent-Date:Resent-From:Resent-Sender:Resent-To:Resent-Cc
        :Resent-Message-ID:List-Id:List-Help:List-Unsubscribe:List-Subscribe:
        List-Post:List-Owner:List-Archive;
        bh=49n/N3seNVvQaTYjzXX+V0A2d2uQ8w8pWanG0yiINLI=; b=s7Jvcei0nZ761JrSTKn37efb7i
        IXfmjw4mdzgtqgxidpBiK91XIgl9ho4GfV5eDOVmGplOo5V3e7qZ1mqOqo5lf+wvEKSZY32aG5ZDy
        VKBkiovCncqsQ57ffjY8hDrf1Uv7t8SyWUYy5psVAs+ClIxvtVLGUqi5Hreg42O2R3Bs=;
Received: from p200300daa70ef200456864e8b8d10029.dip0.t-ipconnect.de ([2003:da:a70e:f200:4568:64e8:b8d1:29] helo=Maecks.lan)
        by ds12 with esmtpsa (TLS1.2:ECDHE_RSA_AES_128_GCM_SHA256:128)
        (Exim 4.89)
        (envelope-from <nbd@nbd.name>)
        id 1nbpJV-00035V-9W; Tue, 05 Apr 2022 21:58:05 +0200
From:   Felix Fietkau <nbd@nbd.name>
To:     netdev@vger.kernel.org, John Crispin <john@phrozen.org>,
        Sean Wang <sean.wang@mediatek.com>,
        Mark Lee <Mark-MC.Lee@mediatek.com>,
        "David S. Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>,
        Paolo Abeni <pabeni@redhat.com>,
        Matthias Brugger <matthias.bgg@gmail.com>
Cc:     Lorenzo Bianconi <lorenzo@kernel.org>,
        linux-arm-kernel@lists.infradead.org,
        linux-mediatek@lists.infradead.org, linux-kernel@vger.kernel.org
Subject: [PATCH v2 07/14] net: ethernet: mtk_eth_soc: implement flow offloading to WED devices
Date:   Tue,  5 Apr 2022 21:57:48 +0200
Message-Id: <20220405195755.10817-8-nbd@nbd.name>
X-Mailer: git-send-email 2.35.1
In-Reply-To: <20220405195755.10817-1-nbd@nbd.name>
References: <20220405195755.10817-1-nbd@nbd.name>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,SPF_HELO_NONE,SPF_NONE,
        T_SCC_BODY_TEXT_LINE autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

This allows hardware flow offloading from Ethernet to WLAN on MT7622 SoC

Co-developed-by: Lorenzo Bianconi <lorenzo@kernel.org>
Signed-off-by: Lorenzo Bianconi <lorenzo@kernel.org>
Signed-off-by: Felix Fietkau <nbd@nbd.name>
---
 drivers/net/ethernet/mediatek/mtk_ppe.c       | 18 ++++++
 drivers/net/ethernet/mediatek/mtk_ppe.h       | 14 +++--
 .../net/ethernet/mediatek/mtk_ppe_offload.c   | 56 ++++++++++++++++++-
 drivers/net/ethernet/mediatek/mtk_wed.h       |  7 +++
 include/linux/netdevice.h                     |  7 +++
 net/core/dev.c                                |  4 ++
 6 files changed, 98 insertions(+), 8 deletions(-)

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
index 7bb1f20002b5..bcf342bb9051 100644
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
@@ -80,6 +82,35 @@ mtk_flow_offload_mangle_eth(const struct flow_action_entry *act, void *eth)
 	memcpy(dest, src, act->mangle.mask ? 2 : 4);
 }
 
+static int
+mtk_flow_get_wdma_info(struct net_device *dev, const u8 *addr, struct mtk_wdma_info *info)
+{
+	struct net_device_path_ctx ctx = {
+		.dev = dev,
+		.daddr = addr,
+	};
+	struct net_device_path path = {};
+
+	if (!IS_ENABLED(CONFIG_NET_MEDIATEK_SOC_WED))
+		return -1;
+
+	if (!dev->netdev_ops->ndo_fill_forward_path)
+		return -1;
+
+	if (dev->netdev_ops->ndo_fill_forward_path(&ctx, &path))
+		return -1;
+
+	if (path.type != DEV_PATH_MTK_WDMA)
+		return -1;
+
+	info->wdma_idx = path.mtk_wdma.wdma_idx;
+	info->queue = path.mtk_wdma.queue;
+	info->bss = path.mtk_wdma.bss;
+	info->wcid = path.mtk_wdma.wcid;
+
+	return 0;
+}
+
 
 static int
 mtk_flow_mangle_ports(const struct flow_action_entry *act,
@@ -149,10 +180,20 @@ mtk_flow_get_dsa_port(struct net_device **dev)
 
 static int
 mtk_flow_set_output_device(struct mtk_eth *eth, struct mtk_foe_entry *foe,
-			   struct net_device *dev)
+			   struct net_device *dev, const u8 *dest_mac,
+			   int *wed_index)
 {
+	struct mtk_wdma_info info = {};
 	int pse_port, dsa_port;
 
+	if (mtk_flow_get_wdma_info(dev, dest_mac, &info) == 0) {
+		mtk_foe_entry_set_wdma(foe, info.wdma_idx, info.queue, info.bss,
+				       info.wcid);
+		pse_port = 3;
+		*wed_index = info.wdma_idx;
+		goto out;
+	}
+
 	dsa_port = mtk_flow_get_dsa_port(&dev);
 	if (dsa_port >= 0)
 		mtk_foe_entry_set_dsa(foe, dsa_port);
@@ -164,6 +205,7 @@ mtk_flow_set_output_device(struct mtk_eth *eth, struct mtk_foe_entry *foe,
 	else
 		return -EOPNOTSUPP;
 
+out:
 	mtk_foe_entry_set_pse_port(foe, pse_port);
 
 	return 0;
@@ -179,6 +221,7 @@ mtk_flow_offload_replace(struct mtk_eth *eth, struct flow_cls_offload *f)
 	struct net_device *odev = NULL;
 	struct mtk_flow_entry *entry;
 	int offload_type = 0;
+	int wed_index = -1;
 	u16 addr_type = 0;
 	u32 timestamp;
 	u8 l4proto = 0;
@@ -326,10 +369,14 @@ mtk_flow_offload_replace(struct mtk_eth *eth, struct flow_cls_offload *f)
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
@@ -343,6 +390,7 @@ mtk_flow_offload_replace(struct mtk_eth *eth, struct flow_cls_offload *f)
 	}
 
 	entry->hash = hash;
+	entry->wed_index = wed_index;
 	err = rhashtable_insert_fast(&eth->flow_table, &entry->node,
 				     mtk_flow_ht_params);
 	if (err < 0)
@@ -353,6 +401,8 @@ mtk_flow_offload_replace(struct mtk_eth *eth, struct flow_cls_offload *f)
 	mtk_foe_entry_clear(&eth->ppe, hash);
 free:
 	kfree(entry);
+	if (wed_index >= 0)
+	    mtk_wed_flow_remove(wed_index);
 	return err;
 }
 
@@ -369,6 +419,8 @@ mtk_flow_offload_destroy(struct mtk_eth *eth, struct flow_cls_offload *f)
 	mtk_foe_entry_clear(&eth->ppe, entry->hash);
 	rhashtable_remove_fast(&eth->flow_table, &entry->node,
 			       mtk_flow_ht_params);
+	if (entry->wed_index >= 0)
+		mtk_wed_flow_remove(entry->wed_index);
 	kfree(entry);
 
 	return 0;
diff --git a/drivers/net/ethernet/mediatek/mtk_wed.h b/drivers/net/ethernet/mediatek/mtk_wed.h
index 404c9a9b130d..981ec613f4b0 100644
--- a/drivers/net/ethernet/mediatek/mtk_wed.h
+++ b/drivers/net/ethernet/mediatek/mtk_wed.h
@@ -7,6 +7,7 @@
 #include <linux/soc/mediatek/mtk_wed.h>
 #include <linux/debugfs.h>
 #include <linux/regmap.h>
+#include <linux/netdevice.h>
 
 struct mtk_eth;
 
@@ -27,6 +28,12 @@ struct mtk_wed_hw {
 	int index;
 };
 
+struct mtk_wdma_info {
+	u8 wdma_idx;
+	u8 queue;
+	u16 wcid;
+	u8 bss;
+};
 
 #ifdef CONFIG_NET_MEDIATEK_SOC_WED
 static inline void
diff --git a/include/linux/netdevice.h b/include/linux/netdevice.h
index 59e27a2b7bf0..93d85f207d3d 100644
--- a/include/linux/netdevice.h
+++ b/include/linux/netdevice.h
@@ -862,6 +862,7 @@ enum net_device_path_type {
 	DEV_PATH_BRIDGE,
 	DEV_PATH_PPPOE,
 	DEV_PATH_DSA,
+	DEV_PATH_MTK_WDMA,
 };
 
 struct net_device_path {
@@ -887,6 +888,12 @@ struct net_device_path {
 			int port;
 			u16 proto;
 		} dsa;
+		struct {
+			u8 wdma_idx;
+			u8 queue;
+			u16 wcid;
+			u8 bss;
+		} mtk_wdma;
 	};
 };
 
diff --git a/net/core/dev.c b/net/core/dev.c
index 8c6c08446556..388be014e981 100644
--- a/net/core/dev.c
+++ b/net/core/dev.c
@@ -701,6 +701,10 @@ int dev_fill_forward_path(const struct net_device *dev, const u8 *daddr,
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
2.35.1

