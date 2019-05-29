Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id CD87F2D972
	for <lists+netdev@lfdr.de>; Wed, 29 May 2019 11:50:55 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726141AbfE2Jux (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 29 May 2019 05:50:53 -0400
Received: from smtp-fw-9101.amazon.com ([207.171.184.25]:32305 "EHLO
        smtp-fw-9101.amazon.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1725861AbfE2Juw (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 29 May 2019 05:50:52 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
  d=amazon.com; i=@amazon.com; q=dns/txt; s=amazon201209;
  t=1559123449; x=1590659449;
  h=from:to:cc:subject:date:message-id:in-reply-to:
   references:mime-version;
  bh=uR4wSUYooLDI9ehtwfsS1/P3gtLOLL6yf9FNdIChdB8=;
  b=RrBqUt29ZsFsILUMRYfzezlEk4umIvTkeRWi1NY3+x6VgSrW91zGrDr8
   lb+2AxsRfbroyx9PH7P1UbJWcDDtG8hVywRQIJtUKyztuzlEBjLFFUogK
   dFAAp0+HxcQT+p0lj/QIKr+5S9Ld+zEh2FcCpaRcbkbnNdboDKGKdXhRM
   M=;
X-IronPort-AV: E=Sophos;i="5.60,526,1549929600"; 
   d="scan'208";a="807352817"
Received: from sea3-co-svc-lb6-vlan3.sea.amazon.com (HELO email-inbound-relay-1d-474bcd9f.us-east-1.amazon.com) ([10.47.22.38])
  by smtp-border-fw-out-9101.sea19.amazon.com with ESMTP; 29 May 2019 09:50:48 +0000
Received: from EX13MTAUWB001.ant.amazon.com (iad55-ws-svc-p15-lb9-vlan2.iad.amazon.com [10.40.159.162])
        by email-inbound-relay-1d-474bcd9f.us-east-1.amazon.com (Postfix) with ESMTPS id 7C3C7A04A0;
        Wed, 29 May 2019 09:50:48 +0000 (UTC)
Received: from EX13D10UWB004.ant.amazon.com (10.43.161.121) by
 EX13MTAUWB001.ant.amazon.com (10.43.161.249) with Microsoft SMTP Server (TLS)
 id 15.0.1367.3; Wed, 29 May 2019 09:50:22 +0000
Received: from EX13MTAUWB001.ant.amazon.com (10.43.161.207) by
 EX13D10UWB004.ant.amazon.com (10.43.161.121) with Microsoft SMTP Server (TLS)
 id 15.0.1367.3; Wed, 29 May 2019 09:50:21 +0000
Received: from HFA16-8226Y22.hfa16.amazon.com (10.218.60.55) by
 mail-relay.amazon.com (10.43.161.249) with Microsoft SMTP Server id
 15.0.1367.3 via Frontend Transport; Wed, 29 May 2019 09:50:17 +0000
From:   <sameehj@amazon.com>
To:     <davem@davemloft.net>, <netdev@vger.kernel.org>
CC:     Arthur Kiyanovski <akiyano@amazon.com>, <dwmw@amazon.com>,
        <zorik@amazon.com>, <matua@amazon.com>, <saeedb@amazon.com>,
        <msw@amazon.com>, <aliguori@amazon.com>, <nafea@amazon.com>,
        <gtzalik@amazon.com>, <netanel@amazon.com>, <alisaidi@amazon.com>,
        <benh@amazon.com>, Sameeh Jubran <sameehj@amazon.com>
Subject: [PATCH V1 net-next 02/11] net: ena: ethtool: add extra properties retrieval via get_priv_flags
Date:   Wed, 29 May 2019 12:49:55 +0300
Message-ID: <20190529095004.13341-3-sameehj@amazon.com>
X-Mailer: git-send-email 2.17.1
In-Reply-To: <20190529095004.13341-1-sameehj@amazon.com>
References: <20190529095004.13341-1-sameehj@amazon.com>
MIME-Version: 1.0
Content-Type: text/plain
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Arthur Kiyanovski <akiyano@amazon.com>

This commit adds a mechanism for exposing different driver
properties via ethtool's priv_flags.

In this commit we:

Add commands, structs and defines necessary for handling
extra properties

Add functions for:
Allocation/destruction of a buffer for extra properties strings.
Retreival of extra properties strings and flags from the network device.

Handle the allocation of a buffer for extra properties strings.

* Initialize buffer with extra properties strings from the
  network device at driver startup.

Use ethtool's get_priv_flags to expose extra properties of
the ENA device

Signed-off-by: Arthur Kiyanovski <akiyano@amazon.com>
Signed-off-by: Sameeh Jubran <sameehj@amazon.com>
---
 .../net/ethernet/amazon/ena/ena_admin_defs.h  | 16 ++++
 drivers/net/ethernet/amazon/ena/ena_com.c     | 56 ++++++++++++++
 drivers/net/ethernet/amazon/ena/ena_com.h     | 32 ++++++++
 drivers/net/ethernet/amazon/ena/ena_ethtool.c | 77 ++++++++++++++++---
 drivers/net/ethernet/amazon/ena/ena_netdev.c  | 14 ++++
 drivers/net/ethernet/amazon/ena/ena_netdev.h  |  2 +
 6 files changed, 186 insertions(+), 11 deletions(-)

diff --git a/drivers/net/ethernet/amazon/ena/ena_admin_defs.h b/drivers/net/ethernet/amazon/ena/ena_admin_defs.h
index 82cff1e12..414bae989 100644
--- a/drivers/net/ethernet/amazon/ena/ena_admin_defs.h
+++ b/drivers/net/ethernet/amazon/ena/ena_admin_defs.h
@@ -32,6 +32,8 @@
 #ifndef _ENA_ADMIN_H_
 #define _ENA_ADMIN_H_
 
+#define ENA_ADMIN_EXTRA_PROPERTIES_STRING_LEN 32
+#define ENA_ADMIN_EXTRA_PROPERTIES_COUNT     32
 
 enum ena_admin_aq_opcode {
 	ENA_ADMIN_CREATE_SQ                         = 1,
@@ -60,6 +62,8 @@ enum ena_admin_aq_feature_id {
 	ENA_ADMIN_MAX_QUEUES_NUM                    = 2,
 	ENA_ADMIN_HW_HINTS                          = 3,
 	ENA_ADMIN_LLQ                               = 4,
+	ENA_ADMIN_EXTRA_PROPERTIES_STRINGS          = 5,
+	ENA_ADMIN_EXTRA_PROPERTIES_FLAGS            = 6,
 	ENA_ADMIN_RSS_HASH_FUNCTION                 = 10,
 	ENA_ADMIN_STATELESS_OFFLOAD_CONFIG          = 11,
 	ENA_ADMIN_RSS_REDIRECTION_TABLE_CONFIG      = 12,
@@ -560,6 +564,14 @@ struct ena_admin_set_feature_mtu_desc {
 	u32 mtu;
 };
 
+struct ena_admin_get_extra_properties_strings_desc {
+	u32 count;
+};
+
+struct ena_admin_get_extra_properties_flags_desc {
+	u32 flags;
+};
+
 struct ena_admin_set_feature_host_attr_desc {
 	/* host OS info base address in OS memory. host info is 4KB of
 	 * physically contiguous
@@ -864,6 +876,10 @@ struct ena_admin_get_feat_resp {
 		struct ena_admin_feature_intr_moder_desc intr_moderation;
 
 		struct ena_admin_ena_hw_hints hw_hints;
+
+		struct ena_admin_get_extra_properties_strings_desc extra_properties_strings;
+
+		struct ena_admin_get_extra_properties_flags_desc extra_properties_flags;
 	} u;
 };
 
diff --git a/drivers/net/ethernet/amazon/ena/ena_com.c b/drivers/net/ethernet/amazon/ena/ena_com.c
index bd0d785b2..935e8fa8d 100644
--- a/drivers/net/ethernet/amazon/ena/ena_com.c
+++ b/drivers/net/ethernet/amazon/ena/ena_com.c
@@ -1877,6 +1877,62 @@ int ena_com_get_link_params(struct ena_com_dev *ena_dev,
 	return ena_com_get_feature(ena_dev, resp, ENA_ADMIN_LINK_CONFIG);
 }
 
+int ena_com_extra_properties_strings_init(struct ena_com_dev *ena_dev)
+{
+	struct ena_admin_get_feat_resp resp;
+	struct ena_extra_properties_strings *extra_properties_strings =
+			&ena_dev->extra_properties_strings;
+	u32 rc;
+
+	extra_properties_strings->size = ENA_ADMIN_EXTRA_PROPERTIES_COUNT *
+		ENA_ADMIN_EXTRA_PROPERTIES_STRING_LEN;
+
+	extra_properties_strings->virt_addr =
+		dma_alloc_coherent(ena_dev->dmadev,
+				   extra_properties_strings->size,
+				   &extra_properties_strings->dma_addr,
+				   GFP_KERNEL);
+	if (unlikely(!extra_properties_strings->virt_addr)) {
+		pr_err("Failed to allocate extra properties strings\n");
+		return 0;
+	}
+
+	rc = ena_com_get_feature_ex(ena_dev, &resp,
+				    ENA_ADMIN_EXTRA_PROPERTIES_STRINGS,
+				    extra_properties_strings->dma_addr,
+				    extra_properties_strings->size);
+	if (rc) {
+		pr_debug("Failed to get extra properties strings\n");
+		goto err;
+	}
+
+	return resp.u.extra_properties_strings.count;
+err:
+	ena_com_delete_extra_properties_strings(ena_dev);
+	return 0;
+}
+
+void ena_com_delete_extra_properties_strings(struct ena_com_dev *ena_dev)
+{
+	struct ena_extra_properties_strings *extra_properties_strings =
+				&ena_dev->extra_properties_strings;
+
+	if (extra_properties_strings->virt_addr) {
+		dma_free_coherent(ena_dev->dmadev,
+				  extra_properties_strings->size,
+				  extra_properties_strings->virt_addr,
+				  extra_properties_strings->dma_addr);
+		extra_properties_strings->virt_addr = NULL;
+	}
+}
+
+int ena_com_get_extra_properties_flags(struct ena_com_dev *ena_dev,
+				       struct ena_admin_get_feat_resp *resp)
+{
+	return ena_com_get_feature(ena_dev, resp,
+				   ENA_ADMIN_EXTRA_PROPERTIES_FLAGS);
+}
+
 int ena_com_get_dev_attr_feat(struct ena_com_dev *ena_dev,
 			      struct ena_com_dev_get_features_ctx *get_feat_ctx)
 {
diff --git a/drivers/net/ethernet/amazon/ena/ena_com.h b/drivers/net/ethernet/amazon/ena/ena_com.h
index f0cb043af..ce36444c3 100644
--- a/drivers/net/ethernet/amazon/ena/ena_com.h
+++ b/drivers/net/ethernet/amazon/ena/ena_com.h
@@ -347,6 +347,12 @@ struct ena_host_attribute {
 	dma_addr_t host_info_dma_addr;
 };
 
+struct ena_extra_properties_strings {
+	u8 *virt_addr;
+	dma_addr_t dma_addr;
+	u32 size;
+};
+
 /* Each ena_dev is a PCI function. */
 struct ena_com_dev {
 	struct ena_com_admin_queue admin_queue;
@@ -375,6 +381,7 @@ struct ena_com_dev {
 	struct ena_intr_moder_entry *intr_moder_tbl;
 
 	struct ena_com_llq_info llq_info;
+	struct ena_extra_properties_strings extra_properties_strings;
 };
 
 struct ena_com_dev_get_features_ctx {
@@ -596,6 +603,31 @@ int ena_com_validate_version(struct ena_com_dev *ena_dev);
 int ena_com_get_link_params(struct ena_com_dev *ena_dev,
 			    struct ena_admin_get_feat_resp *resp);
 
+/* ena_com_extra_properties_strings_init - Initialize the extra properties strings buffer.
+ * @ena_dev: ENA communication layer struct
+ *
+ * Initialize the extra properties strings buffer.
+ */
+int ena_com_extra_properties_strings_init(struct ena_com_dev *ena_dev);
+
+/* ena_com_delete_extra_properties_strings - Free the extra properties strings buffer.
+ * @ena_dev: ENA communication layer struct
+ *
+ * Free the allocated extra properties strings buffer.
+ */
+void ena_com_delete_extra_properties_strings(struct ena_com_dev *ena_dev);
+
+/* ena_com_get_extra_properties_flags - Retrieve extra properties flags.
+ * @ena_dev: ENA communication layer struct
+ * @resp: Extra properties flags.
+ *
+ * Retrieve the extra properties flags.
+ *
+ * @return - 0 on Success negative value otherwise.
+ */
+int ena_com_get_extra_properties_flags(struct ena_com_dev *ena_dev,
+				       struct ena_admin_get_feat_resp *resp);
+
 /* ena_com_get_dma_width - Retrieve physical dma address width the device
  * supports.
  * @ena_dev: ENA communication layer struct
diff --git a/drivers/net/ethernet/amazon/ena/ena_ethtool.c b/drivers/net/ethernet/amazon/ena/ena_ethtool.c
index fe596bc30..65bc5a2b2 100644
--- a/drivers/net/ethernet/amazon/ena/ena_ethtool.c
+++ b/drivers/net/ethernet/amazon/ena/ena_ethtool.c
@@ -197,15 +197,24 @@ static void ena_get_ethtool_stats(struct net_device *netdev,
 	ena_dev_admin_queue_stats(adapter, &data);
 }
 
+static int get_stats_sset_count(struct ena_adapter *adapter)
+{
+	return  adapter->num_queues * (ENA_STATS_ARRAY_TX + ENA_STATS_ARRAY_RX)
+		+ ENA_STATS_ARRAY_GLOBAL + ENA_STATS_ARRAY_ENA_COM;
+}
+
 int ena_get_sset_count(struct net_device *netdev, int sset)
 {
 	struct ena_adapter *adapter = netdev_priv(netdev);
 
-	if (sset != ETH_SS_STATS)
+	switch (sset) {
+	case ETH_SS_STATS:
+		return get_stats_sset_count(adapter);
+	case ETH_SS_PRIV_FLAGS:
+		return adapter->ena_extra_properties_count;
+	default:
 		return -EOPNOTSUPP;
-
-	return  adapter->num_queues * (ENA_STATS_ARRAY_TX + ENA_STATS_ARRAY_RX)
-		+ ENA_STATS_ARRAY_GLOBAL + ENA_STATS_ARRAY_ENA_COM;
+	}
 }
 
 static void ena_queue_strings(struct ena_adapter *adapter, u8 **data)
@@ -247,26 +256,56 @@ static void ena_com_dev_strings(u8 **data)
 	}
 }
 
-static void ena_get_strings(struct net_device *netdev, u32 sset, u8 *data)
+static void get_stats_strings(struct ena_adapter *adapter, u8 *data)
 {
-	struct ena_adapter *adapter = netdev_priv(netdev);
 	const struct ena_stats *ena_stats;
 	int i;
 
-	if (sset != ETH_SS_STATS)
-		return;
-
 	for (i = 0; i < ENA_STATS_ARRAY_GLOBAL; i++) {
 		ena_stats = &ena_stats_global_strings[i];
-
 		memcpy(data, ena_stats->name, ETH_GSTRING_LEN);
 		data += ETH_GSTRING_LEN;
 	}
-
 	ena_queue_strings(adapter, &data);
 	ena_com_dev_strings(&data);
 }
 
+static void get_private_flags_strings(struct ena_adapter *adapter, u8 *data)
+{
+	struct ena_com_dev *ena_dev = adapter->ena_dev;
+	u8 *strings = ena_dev->extra_properties_strings.virt_addr;
+	int i;
+
+	if (unlikely(!strings)) {
+		adapter->ena_extra_properties_count = 0;
+		netif_err(adapter, drv, adapter->netdev,
+			  "Failed to allocate extra properties strings\n");
+		return;
+	}
+
+	for (i = 0; i < adapter->ena_extra_properties_count; i++) {
+		snprintf(data, ETH_GSTRING_LEN, "%s",
+			 strings + ENA_ADMIN_EXTRA_PROPERTIES_STRING_LEN * i);
+		data += ETH_GSTRING_LEN;
+	}
+}
+
+static void ena_get_strings(struct net_device *netdev, u32 sset, u8 *data)
+{
+	struct ena_adapter *adapter = netdev_priv(netdev);
+
+	switch (sset) {
+	case ETH_SS_STATS:
+		get_stats_strings(adapter, data);
+		break;
+	case ETH_SS_PRIV_FLAGS:
+		get_private_flags_strings(adapter, data);
+		break;
+	default:
+		break;
+	}
+}
+
 static int ena_get_link_ksettings(struct net_device *netdev,
 				  struct ethtool_link_ksettings *link_ksettings)
 {
@@ -441,6 +480,7 @@ static void ena_get_drvinfo(struct net_device *dev,
 	strlcpy(info->version, DRV_MODULE_VERSION, sizeof(info->version));
 	strlcpy(info->bus_info, pci_name(adapter->pdev),
 		sizeof(info->bus_info));
+	info->n_priv_flags = adapter->ena_extra_properties_count;
 }
 
 static void ena_get_ringparam(struct net_device *netdev,
@@ -798,6 +838,20 @@ static int ena_set_tunable(struct net_device *netdev,
 	return ret;
 }
 
+static u32 ena_get_priv_flags(struct net_device *netdev)
+{
+	struct ena_adapter *adapter = netdev_priv(netdev);
+	struct ena_com_dev *ena_dev = adapter->ena_dev;
+	struct ena_admin_get_feat_resp get_resp;
+	u32 rc;
+
+	rc = ena_com_get_extra_properties_flags(ena_dev, &get_resp);
+	if (!rc)
+		return get_resp.u.extra_properties_flags.flags;
+
+	return 0;
+}
+
 static const struct ethtool_ops ena_ethtool_ops = {
 	.get_link_ksettings	= ena_get_link_ksettings,
 	.get_drvinfo		= ena_get_drvinfo,
@@ -819,6 +873,7 @@ static const struct ethtool_ops ena_ethtool_ops = {
 	.get_channels		= ena_get_channels,
 	.get_tunable		= ena_get_tunable,
 	.set_tunable		= ena_set_tunable,
+	.get_priv_flags		= ena_get_priv_flags,
 };
 
 void ena_set_ethtool_ops(struct net_device *netdev)
diff --git a/drivers/net/ethernet/amazon/ena/ena_netdev.c b/drivers/net/ethernet/amazon/ena/ena_netdev.c
index d2b82f917..33fab4f41 100644
--- a/drivers/net/ethernet/amazon/ena/ena_netdev.c
+++ b/drivers/net/ethernet/amazon/ena/ena_netdev.c
@@ -2369,6 +2369,14 @@ err:
 	ena_com_delete_debug_area(adapter->ena_dev);
 }
 
+static void ena_extra_properties_strings_destroy(struct net_device *netdev)
+{
+	struct ena_adapter *adapter = netdev_priv(netdev);
+
+	ena_com_delete_extra_properties_strings(adapter->ena_dev);
+	adapter->ena_extra_properties_count = 0;
+}
+
 static void ena_get_stats64(struct net_device *netdev,
 			    struct rtnl_link_stats64 *stats)
 {
@@ -3424,6 +3432,9 @@ static int ena_probe(struct pci_dev *pdev, const struct pci_device_id *ent)
 
 	ena_config_debug_area(adapter);
 
+	adapter->ena_extra_properties_count =
+		ena_com_extra_properties_strings_init(ena_dev);
+
 	memcpy(adapter->netdev->perm_addr, adapter->mac_addr, netdev->addr_len);
 
 	netif_carrier_off(netdev);
@@ -3463,6 +3474,7 @@ static int ena_probe(struct pci_dev *pdev, const struct pci_device_id *ent)
 	return 0;
 
 err_rss:
+	ena_extra_properties_strings_destroy(netdev);
 	ena_com_delete_debug_area(ena_dev);
 	ena_com_rss_destroy(ena_dev);
 err_free_msix:
@@ -3529,6 +3541,8 @@ static void ena_remove(struct pci_dev *pdev)
 
 	ena_com_delete_host_info(ena_dev);
 
+	ena_extra_properties_strings_destroy(netdev);
+
 	ena_release_bars(ena_dev, pdev);
 
 	pci_disable_device(pdev);
diff --git a/drivers/net/ethernet/amazon/ena/ena_netdev.h b/drivers/net/ethernet/amazon/ena/ena_netdev.h
index 63870072c..0681e18b0 100644
--- a/drivers/net/ethernet/amazon/ena/ena_netdev.h
+++ b/drivers/net/ethernet/amazon/ena/ena_netdev.h
@@ -364,6 +364,8 @@ struct ena_adapter {
 	u32 last_monitored_tx_qid;
 
 	enum ena_regs_reset_reason_types reset_reason;
+
+	u8 ena_extra_properties_count;
 };
 
 void ena_set_ethtool_ops(struct net_device *netdev);
-- 
2.17.1

