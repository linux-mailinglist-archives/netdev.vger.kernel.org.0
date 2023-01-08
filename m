Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id B7939661489
	for <lists+netdev@lfdr.de>; Sun,  8 Jan 2023 11:36:37 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233000AbjAHKgf (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sun, 8 Jan 2023 05:36:35 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:36082 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232985AbjAHKgU (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sun, 8 Jan 2023 05:36:20 -0500
Received: from smtp-fw-6002.amazon.com (smtp-fw-6002.amazon.com [52.95.49.90])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 3C1C662D2
        for <netdev@vger.kernel.org>; Sun,  8 Jan 2023 02:36:17 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
  d=amazon.com; i=@amazon.com; q=dns/txt; s=amazon201209;
  t=1673174178; x=1704710178;
  h=from:to:cc:subject:date:message-id:in-reply-to:
   references:mime-version:content-transfer-encoding;
  bh=dQcm+cOOxJBC7N26Urrc2pvccfWbsgrlFnnvrKfUAbA=;
  b=m1oVB1O6nooPCfSB1jRgYMW9h1kMmx6NRMdvrAQaIXw24z4lctCAoRx8
   JYRhBm+KAueq1VRT5kNOc0GdQlR24ldBeGNnUjgV0i4/aKjAdHW7cAZFX
   ATNViAgD5wjLpkhSk5Ubw7BSiF1PmpAqU6yS0f5sTlpFU3AqqhGzIoHUu
   I=;
X-IronPort-AV: E=Sophos;i="5.96,310,1665446400"; 
   d="scan'208";a="284419000"
Received: from iad12-co-svc-p1-lb1-vlan3.amazon.com (HELO email-inbound-relay-iad-1a-m6i4x-9fe6ad2f.us-east-1.amazon.com) ([10.43.8.6])
  by smtp-border-fw-6002.iad6.amazon.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 08 Jan 2023 10:36:17 +0000
Received: from EX13MTAUWB001.ant.amazon.com (iad12-ws-svc-p26-lb9-vlan3.iad.amazon.com [10.40.163.38])
        by email-inbound-relay-iad-1a-m6i4x-9fe6ad2f.us-east-1.amazon.com (Postfix) with ESMTPS id 70D5882285;
        Sun,  8 Jan 2023 10:36:14 +0000 (UTC)
Received: from EX19D002UWA002.ant.amazon.com (10.13.138.246) by
 EX13MTAUWB001.ant.amazon.com (10.43.161.207) with Microsoft SMTP Server (TLS)
 id 15.0.1497.42; Sun, 8 Jan 2023 10:35:50 +0000
Received: from EX13MTAUWA001.ant.amazon.com (10.43.160.58) by
 EX19D002UWA002.ant.amazon.com (10.13.138.246) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_CBC_SHA) id 15.2.1118.7;
 Sun, 8 Jan 2023 10:35:50 +0000
Received: from dev-dsk-darinzon-1c-05962a8d.eu-west-1.amazon.com
 (172.19.80.187) by mail-relay.amazon.com (10.43.160.118) with Microsoft SMTP
 Server id 15.0.1497.42 via Frontend Transport; Sun, 8 Jan 2023 10:35:48 +0000
From:   David Arinzon <darinzon@amazon.com>
To:     David Miller <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>, <netdev@vger.kernel.org>
CC:     David Arinzon <darinzon@amazon.com>,
        "Machulsky, Zorik" <zorik@amazon.com>,
        "Matushevsky, Alexander" <matua@amazon.com>,
        Saeed Bshara <saeedb@amazon.com>,
        "Bshara, Nafea" <nafea@amazon.com>,
        "Saidi, Ali" <alisaidi@amazon.com>,
        "Kiyanovski, Arthur" <akiyano@amazon.com>,
        "Dagan, Noam" <ndagan@amazon.com>,
        "Agroskin, Shay" <shayagr@amazon.com>,
        "Itzko, Shahar" <itzko@amazon.com>,
        "Abboud, Osama" <osamaabb@amazon.com>
Subject: [PATCH V1 net-next 3/5] net: ena: Configure large LLQ using devlink params
Date:   Sun, 8 Jan 2023 10:35:31 +0000
Message-ID: <20230108103533.10104-4-darinzon@amazon.com>
X-Mailer: git-send-email 2.38.1
In-Reply-To: <20230108103533.10104-1-darinzon@amazon.com>
References: <20230108103533.10104-1-darinzon@amazon.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-Spam-Status: No, score=-11.9 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_MED,
        RCVD_IN_MSPIKE_H2,SPF_HELO_NONE,SPF_PASS,USER_IN_DEF_SPF_WL
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

This change introduces devlink params infrastructure
to the ena driver as well as the ability to enable large LLQ
configuration through the infrastructure.

Default LLQ entry size is 128 bytes. 128 bytes entry size
allows for a maximum of 96 bytes of packet header size which
sometimes is not enough (e.g. when using tunneling).
Increasing LLQ entry size to 256 bytes, by enabling large
LLQ through devlink, allows a maximum header size of 224 bytes.
This comes with the penalty of reducing the number of LLQ
entries in the TX queue by 2 (i.e. from 1024 to 512).

Signed-off-by: Shay Agroskin <shayagr@amazon.com>
Signed-off-by: David Arinzon <darinzon@amazon.com>
---
 drivers/net/ethernet/amazon/ena/ena_devlink.c | 106 +++++++++++++++++-
 drivers/net/ethernet/amazon/ena/ena_devlink.h |   2 +
 drivers/net/ethernet/amazon/ena/ena_netdev.c  |  47 +++++++-
 drivers/net/ethernet/amazon/ena/ena_netdev.h  |   8 ++
 4 files changed, 157 insertions(+), 6 deletions(-)

diff --git a/drivers/net/ethernet/amazon/ena/ena_devlink.c b/drivers/net/ethernet/amazon/ena/ena_devlink.c
index 2568ade34c2a..25194c365299 100644
--- a/drivers/net/ethernet/amazon/ena/ena_devlink.c
+++ b/drivers/net/ethernet/amazon/ena/ena_devlink.c
@@ -7,6 +7,72 @@
 
 #include "ena_devlink.h"
 
+static int ena_devlink_llq_header_validate(struct devlink *devlink, u32 id,
+					   union devlink_param_value val,
+					   struct netlink_ext_ack *extack);
+
+enum ena_devlink_param_id {
+	ENA_DEVLINK_PARAM_ID_BASE = DEVLINK_PARAM_GENERIC_ID_MAX,
+	ENA_DEVLINK_PARAM_ID_LLQ_HEADER_SIZE,
+};
+
+static const struct devlink_param ena_devlink_params[] = {
+	DEVLINK_PARAM_DRIVER(ENA_DEVLINK_PARAM_ID_LLQ_HEADER_SIZE,
+			     "large_llq_header", DEVLINK_PARAM_TYPE_BOOL,
+			     BIT(DEVLINK_PARAM_CMODE_DRIVERINIT),
+			     NULL, NULL, ena_devlink_llq_header_validate),
+};
+
+static int ena_devlink_llq_header_validate(struct devlink *devlink, u32 id,
+					   union devlink_param_value val,
+					   struct netlink_ext_ack *extack)
+{
+	struct ena_adapter *adapter = ENA_DEVLINK_PRIV(devlink);
+	bool value = val.vbool;
+
+	if (!value)
+		return 0;
+
+	if (adapter->ena_dev->tx_mem_queue_type == ENA_ADMIN_PLACEMENT_POLICY_HOST) {
+		NL_SET_ERR_MSG_MOD(extack, "Instance doesn't support LLQ");
+		return -EOPNOTSUPP;
+	}
+
+	if (!adapter->large_llq_header_supported) {
+		NL_SET_ERR_MSG_MOD(extack, "Instance doesn't support large LLQ");
+		return -EOPNOTSUPP;
+	}
+
+	return 0;
+}
+
+void ena_devlink_params_get(struct devlink *devlink)
+{
+	struct ena_adapter *adapter = ENA_DEVLINK_PRIV(devlink);
+	union devlink_param_value val;
+	int err;
+
+	err = devlink_param_driverinit_value_get(devlink,
+						 ENA_DEVLINK_PARAM_ID_LLQ_HEADER_SIZE,
+						 &val);
+	if (err) {
+		netdev_err(adapter->netdev, "Failed to query LLQ header size param\n");
+		return;
+	}
+
+	adapter->large_llq_header_enabled = val.vbool;
+}
+
+void ena_devlink_disable_large_llq_header_param(struct devlink *devlink)
+{
+	union devlink_param_value value;
+
+	value.vbool = false;
+	devlink_param_driverinit_value_set(devlink,
+					   ENA_DEVLINK_PARAM_ID_LLQ_HEADER_SIZE,
+					   value);
+}
+
 static int ena_devlink_reload_down(struct devlink *devlink,
 				   bool netns_change,
 				   enum devlink_reload_action action,
@@ -78,6 +144,29 @@ static const struct devlink_ops ena_devlink_ops = {
 	.reload_up	= ena_devlink_reload_up,
 };
 
+static int ena_devlink_configure_params(struct devlink *devlink)
+{
+	struct ena_adapter *adapter = ENA_DEVLINK_PRIV(devlink);
+	union devlink_param_value value;
+	int rc;
+
+	rc = devlink_params_register(devlink, ena_devlink_params,
+				     ARRAY_SIZE(ena_devlink_params));
+	if (rc) {
+		netdev_err(adapter->netdev, "Failed to register devlink params\n");
+		return rc;
+	}
+
+	value.vbool = adapter->large_llq_header_enabled;
+	devlink_param_driverinit_value_set(devlink,
+					   ENA_DEVLINK_PARAM_ID_LLQ_HEADER_SIZE,
+					   value);
+
+	devlink_set_features(devlink, DEVLINK_F_RELOAD);
+
+	return 0;
+}
+
 struct devlink *ena_devlink_alloc(struct ena_adapter *adapter)
 {
 	struct device *dev = &adapter->pdev->dev;
@@ -89,16 +178,29 @@ struct devlink *ena_devlink_alloc(struct ena_adapter *adapter)
 		return NULL;
 	}
 
-	devlink_set_features(devlink, DEVLINK_F_RELOAD);
-
 	ENA_DEVLINK_PRIV(devlink) = adapter;
 	adapter->devlink = devlink;
 
+	if (ena_devlink_configure_params(devlink))
+		goto free_devlink;
+
 	return devlink;
+free_devlink:
+	devlink_free(devlink);
+
+	return NULL;
+}
+
+static void ena_devlink_configure_params_clean(struct devlink *devlink)
+{
+	devlink_params_unregister(devlink, ena_devlink_params,
+				  ARRAY_SIZE(ena_devlink_params));
 }
 
 void ena_devlink_free(struct devlink *devlink)
 {
+	ena_devlink_configure_params_clean(devlink);
+
 	devlink_free(devlink);
 }
 
diff --git a/drivers/net/ethernet/amazon/ena/ena_devlink.h b/drivers/net/ethernet/amazon/ena/ena_devlink.h
index 6f737884b850..9db6038ecd62 100644
--- a/drivers/net/ethernet/amazon/ena/ena_devlink.h
+++ b/drivers/net/ethernet/amazon/ena/ena_devlink.h
@@ -16,5 +16,7 @@ struct devlink *ena_devlink_alloc(struct ena_adapter *adapter);
 void ena_devlink_free(struct devlink *devlink);
 void ena_devlink_register(struct devlink *devlink, struct device *dev);
 void ena_devlink_unregister(struct devlink *devlink);
+void ena_devlink_params_get(struct devlink *devlink);
+void ena_devlink_disable_large_llq_header_param(struct devlink *devlink);
 
 #endif /* DEVLINK_H */
diff --git a/drivers/net/ethernet/amazon/ena/ena_netdev.c b/drivers/net/ethernet/amazon/ena/ena_netdev.c
index a42db781472c..24b95765bb04 100644
--- a/drivers/net/ethernet/amazon/ena/ena_netdev.c
+++ b/drivers/net/ethernet/amazon/ena/ena_netdev.c
@@ -3385,13 +3385,30 @@ static int ena_device_validate_params(struct ena_adapter *adapter,
 	return 0;
 }
 
-static void set_default_llq_configurations(struct ena_llq_configurations *llq_config)
+static void set_default_llq_configurations(struct ena_adapter *adapter,
+					   struct ena_llq_configurations *llq_config,
+					   struct ena_admin_feature_llq_desc *llq)
 {
+	struct ena_com_dev *ena_dev = adapter->ena_dev;
+
 	llq_config->llq_header_location = ENA_ADMIN_INLINE_HEADER;
 	llq_config->llq_stride_ctrl = ENA_ADMIN_MULTIPLE_DESCS_PER_ENTRY;
 	llq_config->llq_num_decs_before_header = ENA_ADMIN_LLQ_NUM_DESCS_BEFORE_HEADER_2;
-	llq_config->llq_ring_entry_size = ENA_ADMIN_LIST_ENTRY_SIZE_128B;
-	llq_config->llq_ring_entry_size_value = 128;
+
+	adapter->large_llq_header_supported =
+		!!(ena_dev->supported_features & (1 << ENA_ADMIN_LLQ));
+	adapter->large_llq_header_supported &=
+		!!(llq->entry_size_ctrl_supported &
+			ENA_ADMIN_LIST_ENTRY_SIZE_256B);
+
+	if ((llq->entry_size_ctrl_supported & ENA_ADMIN_LIST_ENTRY_SIZE_256B) &&
+	    adapter->large_llq_header_enabled) {
+		llq_config->llq_ring_entry_size = ENA_ADMIN_LIST_ENTRY_SIZE_256B;
+		llq_config->llq_ring_entry_size_value = 256;
+	} else {
+		llq_config->llq_ring_entry_size = ENA_ADMIN_LIST_ENTRY_SIZE_128B;
+		llq_config->llq_ring_entry_size_value = 128;
+	}
 }
 
 static int ena_set_queues_placement_policy(struct pci_dev *pdev,
@@ -3493,6 +3510,8 @@ static int ena_device_init(struct ena_com_dev *ena_dev, struct pci_dev *pdev,
 		goto err_mmio_read_less;
 	}
 
+	ena_devlink_params_get(adapter->devlink);
+
 	/* ENA admin level init */
 	rc = ena_com_admin_init(ena_dev, &aenq_handlers);
 	if (rc) {
@@ -3533,7 +3552,7 @@ static int ena_device_init(struct ena_com_dev *ena_dev, struct pci_dev *pdev,
 
 	*wd_state = !!(aenq_groups & BIT(ENA_ADMIN_KEEP_ALIVE));
 
-	set_default_llq_configurations(&llq_config);
+	set_default_llq_configurations(adapter, &llq_config, &get_feat_ctx->llq);
 
 	rc = ena_set_queues_placement_policy(pdev, ena_dev, &get_feat_ctx->llq,
 					     &llq_config);
@@ -4212,6 +4231,26 @@ static void ena_calc_io_queue_size(struct ena_adapter *adapter,
 	max_tx_queue_size = rounddown_pow_of_two(max_tx_queue_size);
 	max_rx_queue_size = rounddown_pow_of_two(max_rx_queue_size);
 
+	/* When forcing large headers, we multiply the entry size by 2,
+	 * and therefore divide the queue size by 2, leaving the amount
+	 * of memory used by the queues unchanged.
+	 */
+	if (adapter->large_llq_header_enabled) {
+		if ((llq->entry_size_ctrl_supported & ENA_ADMIN_LIST_ENTRY_SIZE_256B) &&
+		    (ena_dev->tx_mem_queue_type == ENA_ADMIN_PLACEMENT_POLICY_DEV)) {
+			max_tx_queue_size /= 2;
+			dev_info(&adapter->pdev->dev,
+				 "Forcing large headers and decreasing maximum TX queue size to %d\n",
+				 max_tx_queue_size);
+		} else {
+			dev_err(&adapter->pdev->dev,
+				"Forcing large headers failed: LLQ is disabled or device does not support large headers\n");
+
+			adapter->large_llq_header_enabled = false;
+			ena_devlink_disable_large_llq_header_param(adapter->devlink);
+		}
+	}
+
 	tx_queue_size = clamp_val(tx_queue_size, ENA_MIN_RING_SIZE,
 				  max_tx_queue_size);
 	rx_queue_size = clamp_val(rx_queue_size, ENA_MIN_RING_SIZE,
diff --git a/drivers/net/ethernet/amazon/ena/ena_netdev.h b/drivers/net/ethernet/amazon/ena/ena_netdev.h
index 244c80af6974..b6faf48373d2 100644
--- a/drivers/net/ethernet/amazon/ena/ena_netdev.h
+++ b/drivers/net/ethernet/amazon/ena/ena_netdev.h
@@ -336,6 +336,14 @@ struct ena_adapter {
 
 	u32 msg_enable;
 
+	/* The flag is used for two purposes:
+	 * 1. Indicates that large LLQ has been requested.
+	 * 2. Indicates whether large LLQ is set or not after device
+	 *    initialization / configuration.
+	 */
+	bool large_llq_header_enabled;
+	bool large_llq_header_supported;
+
 	u16 max_tx_sgl_size;
 	u16 max_rx_sgl_size;
 
-- 
2.38.1

