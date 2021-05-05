Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 1AD1737416B
	for <lists+netdev@lfdr.de>; Wed,  5 May 2021 18:45:45 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S235208AbhEEQhv (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 5 May 2021 12:37:51 -0400
Received: from mail.kernel.org ([198.145.29.99]:53474 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S234548AbhEEQfq (ORCPT <rfc822;netdev@vger.kernel.org>);
        Wed, 5 May 2021 12:35:46 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id AADEB61441;
        Wed,  5 May 2021 16:33:03 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1620232384;
        bh=pstObWc4s3VCMIBz08bVRP4wjecVlqHtlaHyx1NNe24=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=Z/mpl5ApV0+dh+W6EkNh9jsWLSWsMU8yP0Gdw8zi/tB+5aTUiWezJ3OH/4wUk6I/w
         SN7Bs/veB03lBJL7SOw4Al7EDHduAWjenWjFvrK6ziKG/1I8CraNlfRZA5mm5xmSxa
         p0CAwXYO2gE5am5fhn192FD3Xf3WTjmWXTyjK9OufsCtgAFv1iqiBsXmUBFmF7lw1W
         9cMhgOHwEk5qtoAzKsFKX+Rhq3U/TJuKyvueB34d3do+ptz7LFhge4OVW5X8mWE7G7
         RV9v1CThfxwNmAOdp2TuxVgE2mEsNpW+othf9Nzb4cAWkx2G9GNdx3u0qnnOXIHOxy
         HF2MdLIApXjlQ==
From:   Sasha Levin <sashal@kernel.org>
To:     linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc:     Johannes Berg <johannes.berg@intel.com>,
        Luca Coelho <luciano.coelho@intel.com>,
        Sasha Levin <sashal@kernel.org>,
        linux-wireless@vger.kernel.org, netdev@vger.kernel.org
Subject: [PATCH AUTOSEL 5.12 071/116] iwlwifi: trans/pcie: defer transport initialisation
Date:   Wed,  5 May 2021 12:30:39 -0400
Message-Id: <20210505163125.3460440-71-sashal@kernel.org>
X-Mailer: git-send-email 2.30.2
In-Reply-To: <20210505163125.3460440-1-sashal@kernel.org>
References: <20210505163125.3460440-1-sashal@kernel.org>
MIME-Version: 1.0
X-stable: review
X-Patchwork-Hint: Ignore
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Johannes Berg <johannes.berg@intel.com>

[ Upstream commit d12455fdbfe9430affd88bfbfee51777356667a0 ]

In a few PCIe devices we may have to swap out the configuration
after we allocate/initialise some parts of the device because
we only know the correct one after reading some registers. This
causes some things such as the byte-count table allocations to
be incorrect, since the configuration is swapped for one with a
bigger queue size.

Fix this by initialising most of the transport much later, only
after the configuration has finally been determined.

Signed-off-by: Johannes Berg <johannes.berg@intel.com>
Signed-off-by: Luca Coelho <luciano.coelho@intel.com>
Link: https://lore.kernel.org/r/iwlwifi.20210411132130.8f5db97db1e4.Ic622da559b586a04ca536a0ec49ed5ecf03a9354@changeid
Signed-off-by: Luca Coelho <luciano.coelho@intel.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 .../net/wireless/intel/iwlwifi/iwl-trans.c    | 91 +++++++++++--------
 .../net/wireless/intel/iwlwifi/iwl-trans.h    |  1 +
 drivers/net/wireless/intel/iwlwifi/pcie/drv.c |  4 +
 3 files changed, 57 insertions(+), 39 deletions(-)

diff --git a/drivers/net/wireless/intel/iwlwifi/iwl-trans.c b/drivers/net/wireless/intel/iwlwifi/iwl-trans.c
index 60e0db4a5e20..9236f9106826 100644
--- a/drivers/net/wireless/intel/iwlwifi/iwl-trans.c
+++ b/drivers/net/wireless/intel/iwlwifi/iwl-trans.c
@@ -2,7 +2,7 @@
 /*
  * Copyright (C) 2015 Intel Mobile Communications GmbH
  * Copyright (C) 2016-2017 Intel Deutschland GmbH
- * Copyright (C) 2019-2020 Intel Corporation
+ * Copyright (C) 2019-2021 Intel Corporation
  */
 #include <linux/kernel.h>
 #include <linux/bsearch.h>
@@ -21,7 +21,6 @@ struct iwl_trans *iwl_trans_alloc(unsigned int priv_size,
 				  const struct iwl_cfg_trans_params *cfg_trans)
 {
 	struct iwl_trans *trans;
-	int txcmd_size, txcmd_align;
 #ifdef CONFIG_LOCKDEP
 	static struct lock_class_key __key;
 #endif
@@ -31,10 +30,40 @@ struct iwl_trans *iwl_trans_alloc(unsigned int priv_size,
 		return NULL;
 
 	trans->trans_cfg = cfg_trans;
-	if (!cfg_trans->gen2) {
+
+#ifdef CONFIG_LOCKDEP
+	lockdep_init_map(&trans->sync_cmd_lockdep_map, "sync_cmd_lockdep_map",
+			 &__key, 0);
+#endif
+
+	trans->dev = dev;
+	trans->ops = ops;
+	trans->num_rx_queues = 1;
+
+	WARN_ON(!ops->wait_txq_empty && !ops->wait_tx_queues_empty);
+
+	if (trans->trans_cfg->use_tfh) {
+		trans->txqs.tfd.addr_size = 64;
+		trans->txqs.tfd.max_tbs = IWL_TFH_NUM_TBS;
+		trans->txqs.tfd.size = sizeof(struct iwl_tfh_tfd);
+	} else {
+		trans->txqs.tfd.addr_size = 36;
+		trans->txqs.tfd.max_tbs = IWL_NUM_OF_TBS;
+		trans->txqs.tfd.size = sizeof(struct iwl_tfd);
+	}
+	trans->max_skb_frags = IWL_TRANS_MAX_FRAGS(trans);
+
+	return trans;
+}
+
+int iwl_trans_init(struct iwl_trans *trans)
+{
+	int txcmd_size, txcmd_align;
+
+	if (!trans->trans_cfg->gen2) {
 		txcmd_size = sizeof(struct iwl_tx_cmd);
 		txcmd_align = sizeof(void *);
-	} else if (cfg_trans->device_family < IWL_DEVICE_FAMILY_AX210) {
+	} else if (trans->trans_cfg->device_family < IWL_DEVICE_FAMILY_AX210) {
 		txcmd_size = sizeof(struct iwl_tx_cmd_gen2);
 		txcmd_align = 64;
 	} else {
@@ -46,17 +75,8 @@ struct iwl_trans *iwl_trans_alloc(unsigned int priv_size,
 	txcmd_size += 36; /* biggest possible 802.11 header */
 
 	/* Ensure device TX cmd cannot reach/cross a page boundary in gen2 */
-	if (WARN_ON(cfg_trans->gen2 && txcmd_size >= txcmd_align))
-		return ERR_PTR(-EINVAL);
-
-#ifdef CONFIG_LOCKDEP
-	lockdep_init_map(&trans->sync_cmd_lockdep_map, "sync_cmd_lockdep_map",
-			 &__key, 0);
-#endif
-
-	trans->dev = dev;
-	trans->ops = ops;
-	trans->num_rx_queues = 1;
+	if (WARN_ON(trans->trans_cfg->gen2 && txcmd_size >= txcmd_align))
+		return -EINVAL;
 
 	if (trans->trans_cfg->device_family >= IWL_DEVICE_FAMILY_AX210)
 		trans->txqs.bc_tbl_size = sizeof(struct iwl_gen3_bc_tbl);
@@ -68,23 +88,16 @@ struct iwl_trans *iwl_trans_alloc(unsigned int priv_size,
 	 * allocate here.
 	 */
 	if (trans->trans_cfg->gen2) {
-		trans->txqs.bc_pool = dmam_pool_create("iwlwifi:bc", dev,
+		trans->txqs.bc_pool = dmam_pool_create("iwlwifi:bc", trans->dev,
 						       trans->txqs.bc_tbl_size,
 						       256, 0);
 		if (!trans->txqs.bc_pool)
-			return NULL;
+			return -ENOMEM;
 	}
 
-	if (trans->trans_cfg->use_tfh) {
-		trans->txqs.tfd.addr_size = 64;
-		trans->txqs.tfd.max_tbs = IWL_TFH_NUM_TBS;
-		trans->txqs.tfd.size = sizeof(struct iwl_tfh_tfd);
-	} else {
-		trans->txqs.tfd.addr_size = 36;
-		trans->txqs.tfd.max_tbs = IWL_NUM_OF_TBS;
-		trans->txqs.tfd.size = sizeof(struct iwl_tfd);
-	}
-	trans->max_skb_frags = IWL_TRANS_MAX_FRAGS(trans);
+	/* Some things must not change even if the config does */
+	WARN_ON(trans->txqs.tfd.addr_size !=
+		(trans->trans_cfg->use_tfh ? 64 : 36));
 
 	snprintf(trans->dev_cmd_pool_name, sizeof(trans->dev_cmd_pool_name),
 		 "iwl_cmd_pool:%s", dev_name(trans->dev));
@@ -93,35 +106,35 @@ struct iwl_trans *iwl_trans_alloc(unsigned int priv_size,
 				  txcmd_size, txcmd_align,
 				  SLAB_HWCACHE_ALIGN, NULL);
 	if (!trans->dev_cmd_pool)
-		return NULL;
-
-	WARN_ON(!ops->wait_txq_empty && !ops->wait_tx_queues_empty);
+		return -ENOMEM;
 
 	trans->txqs.tso_hdr_page = alloc_percpu(struct iwl_tso_hdr_page);
 	if (!trans->txqs.tso_hdr_page) {
 		kmem_cache_destroy(trans->dev_cmd_pool);
-		return NULL;
+		return -ENOMEM;
 	}
 
 	/* Initialize the wait queue for commands */
 	init_waitqueue_head(&trans->wait_command_queue);
 
-	return trans;
+	return 0;
 }
 
 void iwl_trans_free(struct iwl_trans *trans)
 {
 	int i;
 
-	for_each_possible_cpu(i) {
-		struct iwl_tso_hdr_page *p =
-			per_cpu_ptr(trans->txqs.tso_hdr_page, i);
+	if (trans->txqs.tso_hdr_page) {
+		for_each_possible_cpu(i) {
+			struct iwl_tso_hdr_page *p =
+				per_cpu_ptr(trans->txqs.tso_hdr_page, i);
 
-		if (p->page)
-			__free_page(p->page);
-	}
+			if (p && p->page)
+				__free_page(p->page);
+		}
 
-	free_percpu(trans->txqs.tso_hdr_page);
+		free_percpu(trans->txqs.tso_hdr_page);
+	}
 
 	kmem_cache_destroy(trans->dev_cmd_pool);
 }
diff --git a/drivers/net/wireless/intel/iwlwifi/iwl-trans.h b/drivers/net/wireless/intel/iwlwifi/iwl-trans.h
index 4a5822c1be13..3e0df6fbb642 100644
--- a/drivers/net/wireless/intel/iwlwifi/iwl-trans.h
+++ b/drivers/net/wireless/intel/iwlwifi/iwl-trans.h
@@ -1438,6 +1438,7 @@ struct iwl_trans *iwl_trans_alloc(unsigned int priv_size,
 			  struct device *dev,
 			  const struct iwl_trans_ops *ops,
 			  const struct iwl_cfg_trans_params *cfg_trans);
+int iwl_trans_init(struct iwl_trans *trans);
 void iwl_trans_free(struct iwl_trans *trans);
 
 /*****************************************************
diff --git a/drivers/net/wireless/intel/iwlwifi/pcie/drv.c b/drivers/net/wireless/intel/iwlwifi/pcie/drv.c
index 6f4db04ead4a..66faf7914bd8 100644
--- a/drivers/net/wireless/intel/iwlwifi/pcie/drv.c
+++ b/drivers/net/wireless/intel/iwlwifi/pcie/drv.c
@@ -1243,6 +1243,10 @@ static int iwl_pci_probe(struct pci_dev *pdev, const struct pci_device_id *ent)
 		trans_pcie->num_rx_bufs = RX_QUEUE_SIZE;
 	}
 
+	ret = iwl_trans_init(iwl_trans);
+	if (ret)
+		goto out_free_trans;
+
 	pci_set_drvdata(pdev, iwl_trans);
 	iwl_trans->drv = iwl_drv_start(iwl_trans);
 
-- 
2.30.2

