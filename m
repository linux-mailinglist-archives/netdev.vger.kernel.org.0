Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 14C3F5B26D3
	for <lists+netdev@lfdr.de>; Thu,  8 Sep 2022 21:35:38 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231621AbiIHTff (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 8 Sep 2022 15:35:35 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:56040 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231576AbiIHTfX (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 8 Sep 2022 15:35:23 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [139.178.84.217])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 3C639474DF;
        Thu,  8 Sep 2022 12:35:22 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id C3BE861DF3;
        Thu,  8 Sep 2022 19:35:21 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id C9996C433D6;
        Thu,  8 Sep 2022 19:35:20 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1662665721;
        bh=UCo8WjMWi7KIyTBPnjzHpkfBerUaBGH8JiDneaKY47c=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=pIXK18aRAYI0i7aluQ5bB+9OfNGzrYv01J37IPrHAqnmIjv3bZIXdyXSxDsQOZoHG
         uhjZOmrXtnurWkT3PfNFlnWX4Ve6dH6XVhREONk1+RK1SyQRZLhAJp11PIOT12Si4O
         3+cXdXwVb1QUMEXL655/kOOjhnql1lFnDCZacNKs0rYzOROP8nA5RH4ol/Kc/W5CrU
         2pz3qOFbh6WqizjcbZP1Y0AkiFazWbsEFx1V6rCbx3JYYdHDXEbHowBkJmETmOHFfZ
         ZhPGTg9b5SVI/i57UFXRHiIXt5kzlYlcGT1Oc+8qAK+on24IY9Pbis2562wMI5p9bs
         dpG9BaJRNyjDg==
From:   Lorenzo Bianconi <lorenzo@kernel.org>
To:     netdev@vger.kernel.org
Cc:     nbd@nbd.name, john@phrozen.org, sean.wang@mediatek.com,
        Mark-MC.Lee@mediatek.com, davem@davemloft.net, edumazet@google.com,
        kuba@kernel.org, pabeni@redhat.com, matthias.bgg@gmail.com,
        linux-mediatek@lists.infradead.org, lorenzo.bianconi@redhat.com,
        Bo.Jiao@mediatek.com, sujuan.chen@mediatek.com,
        ryder.Lee@mediatek.com, evelyn.tsai@mediatek.com,
        devicetree@vger.kernel.org, robh@kernel.org
Subject: [PATCH net-next 05/12] net: ethernet: mtk_eth_soc: add the capability to run multiple ppe
Date:   Thu,  8 Sep 2022 21:33:39 +0200
Message-Id: <dd0254775390eb031c67c448df8b19e87df58558.1662661555.git.lorenzo@kernel.org>
X-Mailer: git-send-email 2.37.3
In-Reply-To: <cover.1662661555.git.lorenzo@kernel.org>
References: <cover.1662661555.git.lorenzo@kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-7.1 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

mt7986 chipset support multiple packet engines for wlan <-> eth
packet forwarding.

Co-developed-by: Bo Jiao <Bo.Jiao@mediatek.com>
Signed-off-by: Bo Jiao <Bo.Jiao@mediatek.com>
Co-developed-by: Sujuan Chen <sujuan.chen@mediatek.com>
Signed-off-by: Sujuan Chen <sujuan.chen@mediatek.com>
Signed-off-by: Lorenzo Bianconi <lorenzo@kernel.org>
---
 drivers/net/ethernet/mediatek/mtk_eth_soc.c   | 35 ++++++++++++-------
 drivers/net/ethernet/mediatek/mtk_eth_soc.h   |  2 +-
 drivers/net/ethernet/mediatek/mtk_ppe.c       | 14 +++++---
 drivers/net/ethernet/mediatek/mtk_ppe.h       |  9 +++--
 .../net/ethernet/mediatek/mtk_ppe_debugfs.c   |  8 ++---
 .../net/ethernet/mediatek/mtk_ppe_offload.c   | 13 +++----
 6 files changed, 48 insertions(+), 33 deletions(-)

diff --git a/drivers/net/ethernet/mediatek/mtk_eth_soc.c b/drivers/net/ethernet/mediatek/mtk_eth_soc.c
index d09717d4f3be..bbafe5598b14 100644
--- a/drivers/net/ethernet/mediatek/mtk_eth_soc.c
+++ b/drivers/net/ethernet/mediatek/mtk_eth_soc.c
@@ -1919,7 +1919,7 @@ static int mtk_poll_rx(struct napi_struct *napi, int budget,
 
 		reason = FIELD_GET(MTK_RXD4_PPE_CPU_REASON, trxd.rxd4);
 		if (reason == MTK_PPE_CPU_REASON_HIT_UNBIND_RATE_REACHED)
-			mtk_ppe_check_skb(eth->ppe, skb, hash);
+			mtk_ppe_check_skb(eth->ppe[0], skb, hash);
 
 		if (netdev->features & NETIF_F_HW_VLAN_CTAG_RX) {
 			if (MTK_HAS_CAPS(eth->soc->caps, MTK_NETSYS_V2)) {
@@ -2983,15 +2983,18 @@ static int mtk_open(struct net_device *dev)
 	/* we run 2 netdevs on the same dma ring so we only bring it up once */
 	if (!refcount_read(&eth->dma_refcnt)) {
 		const struct mtk_soc_data *soc = eth->soc;
-		u32 gdm_config = MTK_GDMA_TO_PDMA;
+		u32 gdm_config;
+		int i;
 
 		err = mtk_start_dma(eth);
 		if (err)
 			return err;
 
-		if (soc->offload_version && mtk_ppe_start(eth->ppe) == 0)
-			gdm_config = soc->reg_map->gdma_to_ppe;
+		for (i = 0; i < ARRAY_SIZE(eth->ppe); i++)
+			mtk_ppe_start(eth->ppe[i]);
 
+		gdm_config = soc->offload_version ? soc->reg_map->gdma_to_ppe
+						  : MTK_GDMA_TO_PDMA;
 		mtk_gdm_config(eth, gdm_config);
 
 		napi_enable(&eth->tx_napi);
@@ -3035,6 +3038,7 @@ static int mtk_stop(struct net_device *dev)
 {
 	struct mtk_mac *mac = netdev_priv(dev);
 	struct mtk_eth *eth = mac->hw;
+	int i;
 
 	phylink_stop(mac->phylink);
 
@@ -3062,8 +3066,8 @@ static int mtk_stop(struct net_device *dev)
 
 	mtk_dma_free(eth);
 
-	if (eth->soc->offload_version)
-		mtk_ppe_stop(eth->ppe);
+	for (i = 0; i < ARRAY_SIZE(eth->ppe); i++)
+		mtk_ppe_stop(eth->ppe[i]);
 
 	return 0;
 }
@@ -4103,12 +4107,19 @@ static int mtk_probe(struct platform_device *pdev)
 	}
 
 	if (eth->soc->offload_version) {
-		u32 ppe_addr = eth->soc->reg_map->ppe_base;
-
-		eth->ppe = mtk_ppe_init(eth, eth->base + ppe_addr, 2);
-		if (!eth->ppe) {
-			err = -ENOMEM;
-			goto err_free_dev;
+		u32 num_ppe;
+
+		num_ppe = MTK_HAS_CAPS(eth->soc->caps, MTK_NETSYS_V2) ? 2 : 1;
+		num_ppe = min_t(u32, ARRAY_SIZE(eth->ppe), num_ppe);
+		for (i = 0; i < num_ppe; i++) {
+			u32 ppe_addr = eth->soc->reg_map->ppe_base + i * 0x400;
+
+			eth->ppe[i] = mtk_ppe_init(eth, eth->base + ppe_addr,
+						   eth->soc->offload_version, i);
+			if (!eth->ppe[i]) {
+				err = -ENOMEM;
+				goto err_free_dev;
+			}
 		}
 
 		err = mtk_eth_offload_init(eth);
diff --git a/drivers/net/ethernet/mediatek/mtk_eth_soc.h b/drivers/net/ethernet/mediatek/mtk_eth_soc.h
index 6c5e144cb9f0..54448795159d 100644
--- a/drivers/net/ethernet/mediatek/mtk_eth_soc.h
+++ b/drivers/net/ethernet/mediatek/mtk_eth_soc.h
@@ -1114,7 +1114,7 @@ struct mtk_eth {
 
 	int				ip_align;
 
-	struct mtk_ppe			*ppe;
+	struct mtk_ppe			*ppe[2];
 	struct rhashtable		flow_table;
 
 	struct bpf_prog			__rcu *prog;
diff --git a/drivers/net/ethernet/mediatek/mtk_ppe.c b/drivers/net/ethernet/mediatek/mtk_ppe.c
index 1cc7d8338722..687d365b601a 100644
--- a/drivers/net/ethernet/mediatek/mtk_ppe.c
+++ b/drivers/net/ethernet/mediatek/mtk_ppe.c
@@ -682,7 +682,7 @@ int mtk_foe_entry_idle_time(struct mtk_ppe *ppe, struct mtk_flow_entry *entry)
 }
 
 struct mtk_ppe *mtk_ppe_init(struct mtk_eth *eth, void __iomem *base,
-		 int version)
+			     int version, int index)
 {
 	const struct mtk_soc_data *soc = eth->soc;
 	struct device *dev = eth->dev;
@@ -717,7 +717,7 @@ struct mtk_ppe *mtk_ppe_init(struct mtk_eth *eth, void __iomem *base,
 	if (!ppe->foe_flow)
 		return NULL;
 
-	mtk_ppe_debugfs_init(ppe);
+	mtk_ppe_debugfs_init(ppe, index);
 
 	return ppe;
 }
@@ -738,10 +738,13 @@ static void mtk_ppe_init_foe_table(struct mtk_ppe *ppe)
 			ppe->foe_table[i + skip[k]].ib1 |= MTK_FOE_IB1_STATIC;
 }
 
-int mtk_ppe_start(struct mtk_ppe *ppe)
+void mtk_ppe_start(struct mtk_ppe *ppe)
 {
 	u32 val;
 
+	if (!ppe)
+		return;
+
 	mtk_ppe_init_foe_table(ppe);
 	ppe_w32(ppe, MTK_PPE_TB_BASE, ppe->foe_phys);
 
@@ -809,8 +812,6 @@ int mtk_ppe_start(struct mtk_ppe *ppe)
 	ppe_w32(ppe, MTK_PPE_GLO_CFG, val);
 
 	ppe_w32(ppe, MTK_PPE_DEFAULT_CPU_PORT, 0);
-
-	return 0;
 }
 
 int mtk_ppe_stop(struct mtk_ppe *ppe)
@@ -818,6 +819,9 @@ int mtk_ppe_stop(struct mtk_ppe *ppe)
 	u32 val;
 	int i;
 
+	if (!ppe)
+		return 0;
+
 	for (i = 0; i < MTK_PPE_ENTRIES; i++)
 		ppe->foe_table[i].ib1 = FIELD_PREP(MTK_FOE_IB1_STATE,
 						   MTK_FOE_STATE_INVALID);
diff --git a/drivers/net/ethernet/mediatek/mtk_ppe.h b/drivers/net/ethernet/mediatek/mtk_ppe.h
index 22efed6599c2..4c31d854e986 100644
--- a/drivers/net/ethernet/mediatek/mtk_ppe.h
+++ b/drivers/net/ethernet/mediatek/mtk_ppe.h
@@ -247,6 +247,7 @@ struct mtk_flow_entry {
 	};
 	u8 type;
 	s8 wed_index;
+	u8 ppe_index;
 	u16 hash;
 	union {
 		struct mtk_foe_entry data;
@@ -265,6 +266,7 @@ struct mtk_ppe {
 	struct device *dev;
 	void __iomem *base;
 	int version;
+	char dirname[5];
 
 	struct mtk_foe_entry *foe_table;
 	dma_addr_t foe_phys;
@@ -277,8 +279,9 @@ struct mtk_ppe {
 	void *acct_table;
 };
 
-struct mtk_ppe *mtk_ppe_init(struct mtk_eth *eth, void __iomem *base, int version);
-int mtk_ppe_start(struct mtk_ppe *ppe);
+struct mtk_ppe *mtk_ppe_init(struct mtk_eth *eth, void __iomem *base,
+			     int version, int index);
+void mtk_ppe_start(struct mtk_ppe *ppe);
 int mtk_ppe_stop(struct mtk_ppe *ppe);
 
 void __mtk_ppe_check_skb(struct mtk_ppe *ppe, struct sk_buff *skb, u16 hash);
@@ -320,6 +323,6 @@ int mtk_foe_entry_set_wdma(struct mtk_foe_entry *entry, int wdma_idx, int txq,
 int mtk_foe_entry_commit(struct mtk_ppe *ppe, struct mtk_flow_entry *entry);
 void mtk_foe_entry_clear(struct mtk_ppe *ppe, struct mtk_flow_entry *entry);
 int mtk_foe_entry_idle_time(struct mtk_ppe *ppe, struct mtk_flow_entry *entry);
-int mtk_ppe_debugfs_init(struct mtk_ppe *ppe);
+int mtk_ppe_debugfs_init(struct mtk_ppe *ppe, int index);
 
 #endif
diff --git a/drivers/net/ethernet/mediatek/mtk_ppe_debugfs.c b/drivers/net/ethernet/mediatek/mtk_ppe_debugfs.c
index eb0b598f14e4..0868226ccc27 100644
--- a/drivers/net/ethernet/mediatek/mtk_ppe_debugfs.c
+++ b/drivers/net/ethernet/mediatek/mtk_ppe_debugfs.c
@@ -187,7 +187,7 @@ mtk_ppe_debugfs_foe_open_bind(struct inode *inode, struct file *file)
 			   inode->i_private);
 }
 
-int mtk_ppe_debugfs_init(struct mtk_ppe *ppe)
+int mtk_ppe_debugfs_init(struct mtk_ppe *ppe, int index)
 {
 	static const struct file_operations fops_all = {
 		.open = mtk_ppe_debugfs_foe_open_all,
@@ -195,17 +195,17 @@ int mtk_ppe_debugfs_init(struct mtk_ppe *ppe)
 		.llseek = seq_lseek,
 		.release = single_release,
 	};
-
 	static const struct file_operations fops_bind = {
 		.open = mtk_ppe_debugfs_foe_open_bind,
 		.read = seq_read,
 		.llseek = seq_lseek,
 		.release = single_release,
 	};
-
 	struct dentry *root;
 
-	root = debugfs_create_dir("mtk_ppe", NULL);
+	snprintf(ppe->dirname, sizeof(ppe->dirname), "ppe%d", index);
+
+	root = debugfs_create_dir(ppe->dirname, NULL);
 	debugfs_create_file("entries", S_IRUGO, root, ppe, &fops_all);
 	debugfs_create_file("bind", S_IRUGO, root, ppe, &fops_bind);
 
diff --git a/drivers/net/ethernet/mediatek/mtk_ppe_offload.c b/drivers/net/ethernet/mediatek/mtk_ppe_offload.c
index 25dc3c3aa31d..0324e7750065 100644
--- a/drivers/net/ethernet/mediatek/mtk_ppe_offload.c
+++ b/drivers/net/ethernet/mediatek/mtk_ppe_offload.c
@@ -434,7 +434,7 @@ mtk_flow_offload_replace(struct mtk_eth *eth, struct flow_cls_offload *f)
 	memcpy(&entry->data, &foe, sizeof(entry->data));
 	entry->wed_index = wed_index;
 
-	err = mtk_foe_entry_commit(eth->ppe, entry);
+	err = mtk_foe_entry_commit(eth->ppe[entry->ppe_index], entry);
 	if (err < 0)
 		goto free;
 
@@ -446,7 +446,7 @@ mtk_flow_offload_replace(struct mtk_eth *eth, struct flow_cls_offload *f)
 	return 0;
 
 clear:
-	mtk_foe_entry_clear(eth->ppe, entry);
+	mtk_foe_entry_clear(eth->ppe[entry->ppe_index], entry);
 free:
 	kfree(entry);
 	if (wed_index >= 0)
@@ -464,7 +464,7 @@ mtk_flow_offload_destroy(struct mtk_eth *eth, struct flow_cls_offload *f)
 	if (!entry)
 		return -ENOENT;
 
-	mtk_foe_entry_clear(eth->ppe, entry);
+	mtk_foe_entry_clear(eth->ppe[entry->ppe_index], entry);
 	rhashtable_remove_fast(&eth->flow_table, &entry->node,
 			       mtk_flow_ht_params);
 	if (entry->wed_index >= 0)
@@ -485,7 +485,7 @@ mtk_flow_offload_stats(struct mtk_eth *eth, struct flow_cls_offload *f)
 	if (!entry)
 		return -ENOENT;
 
-	idle = mtk_foe_entry_idle_time(eth->ppe, entry);
+	idle = mtk_foe_entry_idle_time(eth->ppe[entry->ppe_index], entry);
 	f->stats.lastused = jiffies - idle * HZ;
 
 	return 0;
@@ -537,7 +537,7 @@ mtk_eth_setup_tc_block(struct net_device *dev, struct flow_block_offload *f)
 	struct flow_block_cb *block_cb;
 	flow_setup_cb_t *cb;
 
-	if (!eth->ppe || !eth->ppe->foe_table)
+	if (!eth->soc->offload_version)
 		return -EOPNOTSUPP;
 
 	if (f->binder_type != FLOW_BLOCK_BINDER_TYPE_CLSACT_INGRESS)
@@ -589,8 +589,5 @@ int mtk_eth_setup_tc(struct net_device *dev, enum tc_setup_type type,
 
 int mtk_eth_offload_init(struct mtk_eth *eth)
 {
-	if (!eth->ppe || !eth->ppe->foe_table)
-		return 0;
-
 	return rhashtable_init(&eth->flow_table, &mtk_flow_ht_params);
 }
-- 
2.37.3

