Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id CFBFD1DCB1C
	for <lists+netdev@lfdr.de>; Thu, 21 May 2020 12:35:04 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728421AbgEUKfC (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 21 May 2020 06:35:02 -0400
Received: from stargate.chelsio.com ([12.32.117.8]:11063 "EHLO
        stargate.chelsio.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1727039AbgEUKfC (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 21 May 2020 06:35:02 -0400
Received: from localhost (mehrangarh.blr.asicdesigners.com [10.193.185.169])
        by stargate.chelsio.com (8.13.8/8.13.8) with ESMTP id 04LAYrmW017426;
        Thu, 21 May 2020 03:34:55 -0700
From:   Potnuri Bharat Teja <bharat@chelsio.com>
To:     netdev@vger.kernel.org
Cc:     davem@davemloft.net, vishal@chelsio.com, bharat@chelsio.com,
        nirranjan@chelsio.com
Subject: [PATCH net-next] cxgb4: add adapter hotplug support for ULDs
Date:   Thu, 21 May 2020 16:04:29 +0530
Message-Id: <20200521103429.18682-1-bharat@chelsio.com>
X-Mailer: git-send-email 2.24.0
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Upon adapter hotplug, cxgb4 registers ULD devices for all the ULDs that
are already loaded, ensuring that ULD's can enumerate the hotplugged
adapter without reloading the ULD.

Signed-off-by: Potnuri Bharat Teja <bharat@chelsio.com>
---
 drivers/net/ethernet/chelsio/cxgb4/cxgb4.h    |   8 +
 .../net/ethernet/chelsio/cxgb4/cxgb4_main.c   |   8 +-
 .../net/ethernet/chelsio/cxgb4/cxgb4_uld.c    | 138 +++++++++++-------
 .../net/ethernet/chelsio/cxgb4/cxgb4_uld.h    |   2 +
 4 files changed, 100 insertions(+), 56 deletions(-)

diff --git a/drivers/net/ethernet/chelsio/cxgb4/cxgb4.h b/drivers/net/ethernet/chelsio/cxgb4/cxgb4.h
index fc1405a8ed74..5a41801acb6a 100644
--- a/drivers/net/ethernet/chelsio/cxgb4/cxgb4.h
+++ b/drivers/net/ethernet/chelsio/cxgb4/cxgb4.h
@@ -60,6 +60,7 @@
 
 #define CH_WARN(adap, fmt, ...) dev_warn(adap->pdev_dev, fmt, ## __VA_ARGS__)
 extern struct list_head adapter_list;
+extern struct list_head uld_list;
 extern struct mutex uld_mutex;
 
 /* Suspend an Ethernet Tx queue with fewer available descriptors than this.
@@ -822,6 +823,13 @@ struct sge_uld_txq_info {
 	u16 ntxq;		/* # of egress uld queues */
 };
 
+/* struct to maintain ULD list to reallocate ULD resources on hotplug */
+struct cxgb4_uld_list {
+	struct cxgb4_uld_info uld_info;
+	struct list_head list_node;
+	enum cxgb4_uld uld_type;
+};
+
 enum sge_eosw_state {
 	CXGB4_EO_STATE_CLOSED = 0, /* Not ready to accept traffic */
 	CXGB4_EO_STATE_FLOWC_OPEN_SEND, /* Send FLOWC open request */
diff --git a/drivers/net/ethernet/chelsio/cxgb4/cxgb4_main.c b/drivers/net/ethernet/chelsio/cxgb4/cxgb4_main.c
index d05c2371d8c7..7a0414f379be 100644
--- a/drivers/net/ethernet/chelsio/cxgb4/cxgb4_main.c
+++ b/drivers/net/ethernet/chelsio/cxgb4/cxgb4_main.c
@@ -180,6 +180,7 @@ static struct dentry *cxgb4_debugfs_root;
 
 LIST_HEAD(adapter_list);
 DEFINE_MUTEX(uld_mutex);
+LIST_HEAD(uld_list);
 
 static int cfg_queues(struct adapter *adap);
 
@@ -6519,11 +6520,8 @@ static int init_one(struct pci_dev *pdev, const struct pci_device_id *ent)
 	/* PCIe EEH recovery on powerpc platforms needs fundamental reset */
 	pdev->needs_freset = 1;
 
-	if (is_uld(adapter)) {
-		mutex_lock(&uld_mutex);
-		list_add_tail(&adapter->list_node, &adapter_list);
-		mutex_unlock(&uld_mutex);
-	}
+	if (is_uld(adapter))
+		cxgb4_uld_enable(adapter);
 
 	if (!is_t4(adapter->params.chip))
 		cxgb4_ptp_init(adapter);
diff --git a/drivers/net/ethernet/chelsio/cxgb4/cxgb4_uld.c b/drivers/net/ethernet/chelsio/cxgb4/cxgb4_uld.c
index e65b52375dd8..6b1d3df4b9ba 100644
--- a/drivers/net/ethernet/chelsio/cxgb4/cxgb4_uld.c
+++ b/drivers/net/ethernet/chelsio/cxgb4/cxgb4_uld.c
@@ -681,6 +681,74 @@ static void cxgb4_set_ktls_feature(struct adapter *adap, bool enable)
 }
 #endif
 
+static void cxgb4_uld_alloc_resources(struct adapter *adap,
+				      enum cxgb4_uld type,
+				      const struct cxgb4_uld_info *p)
+{
+	int ret = 0;
+
+	if ((type == CXGB4_ULD_CRYPTO && !is_pci_uld(adap)) ||
+	    (type != CXGB4_ULD_CRYPTO && !is_offload(adap)))
+		return;
+	if (type == CXGB4_ULD_ISCSIT && is_t4(adap->params.chip))
+		return;
+	ret = cfg_queues_uld(adap, type, p);
+	if (ret)
+		goto out;
+	ret = setup_sge_queues_uld(adap, type, p->lro);
+	if (ret)
+		goto free_queues;
+	if (adap->flags & CXGB4_USING_MSIX) {
+		ret = request_msix_queue_irqs_uld(adap, type);
+		if (ret)
+			goto free_rxq;
+	}
+	if (adap->flags & CXGB4_FULL_INIT_DONE)
+		enable_rx_uld(adap, type);
+#ifdef CONFIG_CHELSIO_TLS_DEVICE
+	/* send mbox to enable ktls related settings. */
+	if (type == CXGB4_ULD_CRYPTO &&
+	    (adap->params.crypto & FW_CAPS_CONFIG_TX_TLS_HW))
+		cxgb4_set_ktls_feature(adap, 1);
+#endif
+	if (adap->uld[type].add)
+		goto free_irq;
+	ret = setup_sge_txq_uld(adap, type, p);
+	if (ret)
+		goto free_irq;
+	adap->uld[type] = *p;
+	ret = uld_attach(adap, type);
+	if (ret)
+		goto free_txq;
+	return;
+free_txq:
+	release_sge_txq_uld(adap, type);
+free_irq:
+	if (adap->flags & CXGB4_FULL_INIT_DONE)
+		quiesce_rx_uld(adap, type);
+	if (adap->flags & CXGB4_USING_MSIX)
+		free_msix_queue_irqs_uld(adap, type);
+free_rxq:
+	free_sge_queues_uld(adap, type);
+free_queues:
+	free_queues_uld(adap, type);
+out:
+	dev_warn(adap->pdev_dev,
+		 "ULD registration failed for uld type %d\n", type);
+}
+
+void cxgb4_uld_enable(struct adapter *adap)
+{
+	struct cxgb4_uld_list *uld_entry;
+
+	mutex_lock(&uld_mutex);
+	list_add_tail(&adap->list_node, &adapter_list);
+	list_for_each_entry(uld_entry, &uld_list, list_node)
+		cxgb4_uld_alloc_resources(adap, uld_entry->uld_type,
+					  &uld_entry->uld_info);
+	mutex_unlock(&uld_mutex);
+}
+
 /* cxgb4_register_uld - register an upper-layer driver
  * @type: the ULD type
  * @p: the ULD methods
@@ -691,63 +759,23 @@ static void cxgb4_set_ktls_feature(struct adapter *adap, bool enable)
 void cxgb4_register_uld(enum cxgb4_uld type,
 			const struct cxgb4_uld_info *p)
 {
+	struct cxgb4_uld_list *uld_entry;
 	struct adapter *adap;
-	int ret = 0;
 
 	if (type >= CXGB4_ULD_MAX)
 		return;
 
+	uld_entry = kzalloc(sizeof(*uld_entry), GFP_KERNEL);
+	if (!uld_entry)
+		return;
+
+	memcpy(&uld_entry->uld_info, p, sizeof(struct cxgb4_uld_info));
 	mutex_lock(&uld_mutex);
-	list_for_each_entry(adap, &adapter_list, list_node) {
-		if ((type == CXGB4_ULD_CRYPTO && !is_pci_uld(adap)) ||
-		    (type != CXGB4_ULD_CRYPTO && !is_offload(adap)))
-			continue;
-		if (type == CXGB4_ULD_ISCSIT && is_t4(adap->params.chip))
-			continue;
-		ret = cfg_queues_uld(adap, type, p);
-		if (ret)
-			goto out;
-		ret = setup_sge_queues_uld(adap, type, p->lro);
-		if (ret)
-			goto free_queues;
-		if (adap->flags & CXGB4_USING_MSIX) {
-			ret = request_msix_queue_irqs_uld(adap, type);
-			if (ret)
-				goto free_rxq;
-		}
-		if (adap->flags & CXGB4_FULL_INIT_DONE)
-			enable_rx_uld(adap, type);
-#ifdef CONFIG_CHELSIO_TLS_DEVICE
-		/* send mbox to enable ktls related settings. */
-		if (type == CXGB4_ULD_CRYPTO &&
-		    (adap->params.crypto & FW_CAPS_CONFIG_TX_TLS_HW))
-			cxgb4_set_ktls_feature(adap, 1);
-#endif
-		if (adap->uld[type].add)
-			goto free_irq;
-		ret = setup_sge_txq_uld(adap, type, p);
-		if (ret)
-			goto free_irq;
-		adap->uld[type] = *p;
-		ret = uld_attach(adap, type);
-		if (ret)
-			goto free_txq;
-		continue;
-free_txq:
-		release_sge_txq_uld(adap, type);
-free_irq:
-		if (adap->flags & CXGB4_FULL_INIT_DONE)
-			quiesce_rx_uld(adap, type);
-		if (adap->flags & CXGB4_USING_MSIX)
-			free_msix_queue_irqs_uld(adap, type);
-free_rxq:
-		free_sge_queues_uld(adap, type);
-free_queues:
-		free_queues_uld(adap, type);
-out:
-		dev_warn(adap->pdev_dev,
-			 "ULD registration failed for uld type %d\n", type);
-	}
+	list_for_each_entry(adap, &adapter_list, list_node)
+		cxgb4_uld_alloc_resources(adap, type, p);
+
+	uld_entry->uld_type = type;
+	list_add_tail(&uld_entry->list_node, &uld_list);
 	mutex_unlock(&uld_mutex);
 	return;
 }
@@ -761,6 +789,7 @@ EXPORT_SYMBOL(cxgb4_register_uld);
  */
 int cxgb4_unregister_uld(enum cxgb4_uld type)
 {
+	struct cxgb4_uld_list *uld_entry, *tmp;
 	struct adapter *adap;
 
 	if (type >= CXGB4_ULD_MAX)
@@ -783,6 +812,13 @@ int cxgb4_unregister_uld(enum cxgb4_uld type)
 			cxgb4_set_ktls_feature(adap, 0);
 #endif
 	}
+
+	list_for_each_entry_safe(uld_entry, tmp, &uld_list, list_node) {
+		if (uld_entry->uld_type == type) {
+			list_del(&uld_entry->list_node);
+			kfree(uld_entry);
+		}
+	}
 	mutex_unlock(&uld_mutex);
 
 	return 0;
diff --git a/drivers/net/ethernet/chelsio/cxgb4/cxgb4_uld.h b/drivers/net/ethernet/chelsio/cxgb4/cxgb4_uld.h
index 16796785eea3..085fa1424f9a 100644
--- a/drivers/net/ethernet/chelsio/cxgb4/cxgb4_uld.h
+++ b/drivers/net/ethernet/chelsio/cxgb4/cxgb4_uld.h
@@ -327,6 +327,7 @@ enum cxgb4_control {
 	CXGB4_CONTROL_DB_DROP,
 };
 
+struct adapter;
 struct pci_dev;
 struct l2t_data;
 struct net_device;
@@ -465,6 +466,7 @@ struct cxgb4_uld_info {
 	int (*tx_handler)(struct sk_buff *skb, struct net_device *dev);
 };
 
+void cxgb4_uld_enable(struct adapter *adap);
 void cxgb4_register_uld(enum cxgb4_uld type, const struct cxgb4_uld_info *p);
 int cxgb4_unregister_uld(enum cxgb4_uld type);
 int cxgb4_ofld_send(struct net_device *dev, struct sk_buff *skb);
-- 
2.24.0

