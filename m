Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 7D5086C3305
	for <lists+netdev@lfdr.de>; Tue, 21 Mar 2023 14:36:17 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230523AbjCUNgP (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 21 Mar 2023 09:36:15 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:59600 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229808AbjCUNgN (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 21 Mar 2023 09:36:13 -0400
Received: from nbd.name (nbd.name [46.4.11.11])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 1C5D123878
        for <netdev@vger.kernel.org>; Tue, 21 Mar 2023 06:36:12 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed; d=nbd.name;
        s=20160729; h=Content-Transfer-Encoding:MIME-Version:Message-Id:Date:Subject:
        To:From:Sender:Reply-To:Cc:Content-Type:Content-ID:Content-Description:
        Resent-Date:Resent-From:Resent-Sender:Resent-To:Resent-Cc:Resent-Message-ID:
        In-Reply-To:References:List-Id:List-Help:List-Unsubscribe:List-Subscribe:
        List-Post:List-Owner:List-Archive;
        bh=GBUApRRtGoaJjOP3GcTw5c+/JTKNFvoSKf4pNzGjT98=; b=Wd98HMk3x5Enr/9flKtv0LSVYZ
        HiRehay3h1p2DknvJSqdCsfB4n5Ep/x4xp5XIEHux2tzXZWWcC1sr6ubSviGxvv+10vay9JuyleCa
        h3WwuASI7e45L8pJCGlG0mva37ez+Y1K2++Ld2KYjybPvj8/Rg/PiI1G+jsGHZTioXDA=;
Received: from [217.114.218.22] (helo=localhost.localdomain)
        by ds12 with esmtpsa  (TLS1.3) tls TLS_ECDHE_RSA_WITH_CHACHA20_POLY1305_SHA256
        (Exim 4.94.2)
        (envelope-from <nbd@nbd.name>)
        id 1pec9p-005Liy-Pj
        for netdev@vger.kernel.org; Tue, 21 Mar 2023 14:36:09 +0100
From:   Felix Fietkau <nbd@nbd.name>
To:     netdev@vger.kernel.org
Subject: [PATCH net-next 1/2] net: ethernet: mtk_eth_soc: add code for offloading flows from wlan devices
Date:   Tue, 21 Mar 2023 14:36:08 +0100
Message-Id: <20230321133609.49591-1-nbd@nbd.name>
X-Mailer: git-send-email 2.39.0
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,SPF_HELO_NONE,SPF_NONE,
        URIBL_BLOCKED autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

WED version 2 (on MT7986 and later) can offload flows originating from wireless
devices. In order to make that work, ndo_setup_tc needs to be implemented on
the netdevs. This adds the required code to offload flows coming in from WED,
while keeping track of the incoming wed index used for selecting the correct
PPE device.

Signed-off-by: Felix Fietkau <nbd@nbd.name>
---
 drivers/net/ethernet/mediatek/mtk_eth_soc.h   |   3 +
 .../net/ethernet/mediatek/mtk_ppe_offload.c   |  37 ++++---
 drivers/net/ethernet/mediatek/mtk_wed.c       | 104 ++++++++++++++++++
 include/linux/soc/mediatek/mtk_wed.h          |   6 +
 4 files changed, 136 insertions(+), 14 deletions(-)

diff --git a/drivers/net/ethernet/mediatek/mtk_eth_soc.h b/drivers/net/ethernet/mediatek/mtk_eth_soc.h
index 084a6badef6d..f7092b532643 100644
--- a/drivers/net/ethernet/mediatek/mtk_eth_soc.h
+++ b/drivers/net/ethernet/mediatek/mtk_eth_soc.h
@@ -1322,6 +1322,9 @@ int mtk_gmac_rgmii_path_setup(struct mtk_eth *eth, int mac_id);
 int mtk_eth_offload_init(struct mtk_eth *eth);
 int mtk_eth_setup_tc(struct net_device *dev, enum tc_setup_type type,
 		     void *type_data);
+int mtk_flow_offload_cmd(struct mtk_eth *eth, struct flow_cls_offload *cls,
+			 int ppe_index);
+void mtk_flow_offload_cleanup(struct mtk_eth *eth, struct list_head *list);
 void mtk_eth_set_dma_device(struct mtk_eth *eth, struct device *dma_dev);
 
 
diff --git a/drivers/net/ethernet/mediatek/mtk_ppe_offload.c b/drivers/net/ethernet/mediatek/mtk_ppe_offload.c
index 81afd5ee3fbf..0c5e049b8141 100644
--- a/drivers/net/ethernet/mediatek/mtk_ppe_offload.c
+++ b/drivers/net/ethernet/mediatek/mtk_ppe_offload.c
@@ -235,7 +235,8 @@ mtk_flow_set_output_device(struct mtk_eth *eth, struct mtk_foe_entry *foe,
 }
 
 static int
-mtk_flow_offload_replace(struct mtk_eth *eth, struct flow_cls_offload *f)
+mtk_flow_offload_replace(struct mtk_eth *eth, struct flow_cls_offload *f,
+			 int ppe_index)
 {
 	struct flow_rule *rule = flow_cls_offload_flow_rule(f);
 	struct flow_action_entry *act;
@@ -452,6 +453,7 @@ mtk_flow_offload_replace(struct mtk_eth *eth, struct flow_cls_offload *f)
 	entry->cookie = f->cookie;
 	memcpy(&entry->data, &foe, sizeof(entry->data));
 	entry->wed_index = wed_index;
+	entry->ppe_index = ppe_index;
 
 	err = mtk_foe_entry_commit(eth->ppe[entry->ppe_index], entry);
 	if (err < 0)
@@ -512,25 +514,15 @@ mtk_flow_offload_stats(struct mtk_eth *eth, struct flow_cls_offload *f)
 
 static DEFINE_MUTEX(mtk_flow_offload_mutex);
 
-static int
-mtk_eth_setup_tc_block_cb(enum tc_setup_type type, void *type_data, void *cb_priv)
+int mtk_flow_offload_cmd(struct mtk_eth *eth, struct flow_cls_offload *cls,
+			 int ppe_index)
 {
-	struct flow_cls_offload *cls = type_data;
-	struct net_device *dev = cb_priv;
-	struct mtk_mac *mac = netdev_priv(dev);
-	struct mtk_eth *eth = mac->hw;
 	int err;
 
-	if (!tc_can_offload(dev))
-		return -EOPNOTSUPP;
-
-	if (type != TC_SETUP_CLSFLOWER)
-		return -EOPNOTSUPP;
-
 	mutex_lock(&mtk_flow_offload_mutex);
 	switch (cls->command) {
 	case FLOW_CLS_REPLACE:
-		err = mtk_flow_offload_replace(eth, cls);
+		err = mtk_flow_offload_replace(eth, cls, ppe_index);
 		break;
 	case FLOW_CLS_DESTROY:
 		err = mtk_flow_offload_destroy(eth, cls);
@@ -547,6 +539,23 @@ mtk_eth_setup_tc_block_cb(enum tc_setup_type type, void *type_data, void *cb_pri
 	return err;
 }
 
+static int
+mtk_eth_setup_tc_block_cb(enum tc_setup_type type, void *type_data, void *cb_priv)
+{
+	struct flow_cls_offload *cls = type_data;
+	struct net_device *dev = cb_priv;
+	struct mtk_mac *mac = netdev_priv(dev);
+	struct mtk_eth *eth = mac->hw;
+
+	if (!tc_can_offload(dev))
+		return -EOPNOTSUPP;
+
+	if (type != TC_SETUP_CLSFLOWER)
+		return -EOPNOTSUPP;
+
+	return mtk_flow_offload_cmd(eth, cls, 0);
+}
+
 static int
 mtk_eth_setup_tc_block(struct net_device *dev, struct flow_block_offload *f)
 {
diff --git a/drivers/net/ethernet/mediatek/mtk_wed.c b/drivers/net/ethernet/mediatek/mtk_wed.c
index 95d890870984..30fe1281d2d3 100644
--- a/drivers/net/ethernet/mediatek/mtk_wed.c
+++ b/drivers/net/ethernet/mediatek/mtk_wed.c
@@ -13,6 +13,8 @@
 #include <linux/mfd/syscon.h>
 #include <linux/debugfs.h>
 #include <linux/soc/mediatek/mtk_wed.h>
+#include <net/flow_offload.h>
+#include <net/pkt_cls.h>
 #include "mtk_eth_soc.h"
 #include "mtk_wed_regs.h"
 #include "mtk_wed.h"
@@ -41,6 +43,11 @@
 static struct mtk_wed_hw *hw_list[2];
 static DEFINE_MUTEX(hw_lock);
 
+struct mtk_wed_flow_block_priv {
+	struct mtk_wed_hw *hw;
+	struct net_device *dev;
+};
+
 static void
 wed_m32(struct mtk_wed_device *dev, u32 reg, u32 mask, u32 val)
 {
@@ -1745,6 +1752,102 @@ void mtk_wed_flow_remove(int index)
 	mutex_unlock(&hw_lock);
 }
 
+static int
+mtk_wed_setup_tc_block_cb(enum tc_setup_type type, void *type_data, void *cb_priv)
+{
+	struct mtk_wed_flow_block_priv *priv = cb_priv;
+	struct flow_cls_offload *cls = type_data;
+	struct mtk_wed_hw *hw = priv->hw;
+
+	if (!tc_can_offload(priv->dev))
+		return -EOPNOTSUPP;
+
+	if (type != TC_SETUP_CLSFLOWER)
+		return -EOPNOTSUPP;
+
+	return mtk_flow_offload_cmd(hw->eth, cls, hw->index);
+}
+
+static int
+mtk_wed_setup_tc_block(struct mtk_wed_hw *hw, struct net_device *dev,
+		       struct flow_block_offload *f)
+{
+	struct mtk_wed_flow_block_priv *priv;
+	static LIST_HEAD(block_cb_list);
+	struct flow_block_cb *block_cb;
+	struct mtk_eth *eth = hw->eth;
+	bool register_block = false;
+	flow_setup_cb_t *cb;
+
+	if (!eth->soc->offload_version)
+		return -EOPNOTSUPP;
+
+	if (f->binder_type != FLOW_BLOCK_BINDER_TYPE_CLSACT_INGRESS)
+		return -EOPNOTSUPP;
+
+	cb = mtk_wed_setup_tc_block_cb;
+	f->driver_block_list = &block_cb_list;
+
+	switch (f->command) {
+	case FLOW_BLOCK_BIND:
+		block_cb = flow_block_cb_lookup(f->block, cb, dev);
+		if (!block_cb) {
+			priv = kzalloc(sizeof(*priv), GFP_KERNEL);
+			if (!priv)
+				return -ENOMEM;
+
+			priv->hw = hw;
+			priv->dev = dev;
+			block_cb = flow_block_cb_alloc(cb, dev, priv, NULL);
+			if (IS_ERR(block_cb)) {
+				kfree(priv);
+				return PTR_ERR(block_cb);
+			}
+
+			register_block = true;
+		}
+
+		flow_block_cb_incref(block_cb);
+
+		if (register_block) {
+			flow_block_cb_add(block_cb, f);
+			list_add_tail(&block_cb->driver_list, &block_cb_list);
+		}
+		return 0;
+	case FLOW_BLOCK_UNBIND:
+		block_cb = flow_block_cb_lookup(f->block, cb, dev);
+		if (!block_cb)
+			return -ENOENT;
+
+		if (!flow_block_cb_decref(block_cb)) {
+			flow_block_cb_remove(block_cb, f);
+			list_del(&block_cb->driver_list);
+			kfree(block_cb->cb_priv);
+		}
+		return 0;
+	default:
+		return -EOPNOTSUPP;
+	}
+}
+
+static int
+mtk_wed_setup_tc(struct mtk_wed_device *wed, struct net_device *dev,
+		 enum tc_setup_type type, void *type_data)
+{
+	struct mtk_wed_hw *hw = wed->hw;
+
+	if (hw->version < 2)
+		return -EOPNOTSUPP;
+
+	switch (type) {
+	case TC_SETUP_BLOCK:
+	case TC_SETUP_FT:
+		return mtk_wed_setup_tc_block(hw, dev, type_data);
+	default:
+		return -EOPNOTSUPP;
+	}
+}
+
 void mtk_wed_add_hw(struct device_node *np, struct mtk_eth *eth,
 		    void __iomem *wdma, phys_addr_t wdma_phy,
 		    int index)
@@ -1764,6 +1867,7 @@ void mtk_wed_add_hw(struct device_node *np, struct mtk_eth *eth,
 		.irq_set_mask = mtk_wed_irq_set_mask,
 		.detach = mtk_wed_detach,
 		.ppe_check = mtk_wed_ppe_check,
+		.setup_tc = mtk_wed_setup_tc,
 	};
 	struct device_node *eth_np = eth->dev->of_node;
 	struct platform_device *pdev;
diff --git a/include/linux/soc/mediatek/mtk_wed.h b/include/linux/soc/mediatek/mtk_wed.h
index fd0b0605cf90..b2b28180dff7 100644
--- a/include/linux/soc/mediatek/mtk_wed.h
+++ b/include/linux/soc/mediatek/mtk_wed.h
@@ -6,6 +6,7 @@
 #include <linux/regmap.h>
 #include <linux/pci.h>
 #include <linux/skbuff.h>
+#include <linux/netdevice.h>
 
 #define MTK_WED_TX_QUEUES		2
 #define MTK_WED_RX_QUEUES		2
@@ -179,6 +180,8 @@ struct mtk_wed_ops {
 
 	u32 (*irq_get)(struct mtk_wed_device *dev, u32 mask);
 	void (*irq_set_mask)(struct mtk_wed_device *dev, u32 mask);
+	int (*setup_tc)(struct mtk_wed_device *wed, struct net_device *dev,
+			enum tc_setup_type type, void *type_data);
 };
 
 extern const struct mtk_wed_ops __rcu *mtk_soc_wed_ops;
@@ -237,6 +240,8 @@ mtk_wed_get_rx_capa(struct mtk_wed_device *dev)
 	(_dev)->ops->msg_update(_dev, _id, _msg, _len)
 #define mtk_wed_device_stop(_dev) (_dev)->ops->stop(_dev)
 #define mtk_wed_device_dma_reset(_dev) (_dev)->ops->reset_dma(_dev)
+#define mtk_wed_device_setup_tc(_dev, _netdev, _type, _type_data) \
+	(_dev)->ops->setup_tc(_dev, _netdev, _type, _type_data)
 #else
 static inline bool mtk_wed_device_active(struct mtk_wed_device *dev)
 {
@@ -255,6 +260,7 @@ static inline bool mtk_wed_device_active(struct mtk_wed_device *dev)
 #define mtk_wed_device_update_msg(_dev, _id, _msg, _len) -ENODEV
 #define mtk_wed_device_stop(_dev) do {} while (0)
 #define mtk_wed_device_dma_reset(_dev) do {} while (0)
+#define mtk_wed_device_setup_tc(_dev, _netdev, _type, _type_data) -EOPNOTSUPP
 #endif
 
 #endif
-- 
2.39.0

