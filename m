Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 8017737390
	for <lists+netdev@lfdr.de>; Thu,  6 Jun 2019 13:55:47 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727729AbfFFLzl (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 6 Jun 2019 07:55:41 -0400
Received: from smtp-fw-9101.amazon.com ([207.171.184.25]:25477 "EHLO
        smtp-fw-9101.amazon.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1727555AbfFFLzl (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 6 Jun 2019 07:55:41 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
  d=amazon.com; i=@amazon.com; q=dns/txt; s=amazon201209;
  t=1559822139; x=1591358139;
  h=from:to:cc:subject:date:message-id:in-reply-to:
   references:mime-version;
  bh=5u0zvPPRJQxii5UOBaDZf41bNuPkaIm70qEkN9i+wy0=;
  b=NM/prb/Tp9qh/EEF63fNiq6YTbB9q9Vhc1bepNs8pWao80+JTrpTItcZ
   iQNw0dlfFupoy/dN523qB6KuhHIrVFsH5PaogTm/voCfgQ+uPSSpYAivb
   3HTOmYXMlspm9oCMnXCYvnyqm7/dtJh7er5DPxUWy+EhUn8X7PKYWLLwB
   4=;
X-IronPort-AV: E=Sophos;i="5.60,559,1549929600"; 
   d="scan'208";a="808940018"
Received: from sea3-co-svc-lb6-vlan3.sea.amazon.com (HELO email-inbound-relay-2c-397e131e.us-west-2.amazon.com) ([10.47.22.38])
  by smtp-border-fw-out-9101.sea19.amazon.com with ESMTP; 06 Jun 2019 11:55:37 +0000
Received: from EX13MTAUWC001.ant.amazon.com (pdx1-ws-svc-p6-lb9-vlan2.pdx.amazon.com [10.236.137.194])
        by email-inbound-relay-2c-397e131e.us-west-2.amazon.com (Postfix) with ESMTPS id C238BA2491;
        Thu,  6 Jun 2019 11:55:37 +0000 (UTC)
Received: from EX13d09UWC004.ant.amazon.com (10.43.162.114) by
 EX13MTAUWC001.ant.amazon.com (10.43.162.135) with Microsoft SMTP Server (TLS)
 id 15.0.1367.3; Thu, 6 Jun 2019 11:55:32 +0000
Received: from EX13MTAUWC001.ant.amazon.com (10.43.162.135) by
 EX13d09UWC004.ant.amazon.com (10.43.162.114) with Microsoft SMTP Server (TLS)
 id 15.0.1367.3; Thu, 6 Jun 2019 11:55:31 +0000
Received: from HFA16-8226Y22.hfa16.amazon.com (10.218.52.81) by
 mail-relay.amazon.com (10.43.162.232) with Microsoft SMTP Server id
 15.0.1367.3 via Frontend Transport; Thu, 6 Jun 2019 11:55:28 +0000
From:   <sameehj@amazon.com>
To:     <davem@davemloft.net>, <netdev@vger.kernel.org>
CC:     Arthur Kiyanovski <akiyano@amazon.com>, <dwmw@amazon.com>,
        <zorik@amazon.com>, <matua@amazon.com>, <saeedb@amazon.com>,
        <msw@amazon.com>, <aliguori@amazon.com>, <nafea@amazon.com>,
        <gtzalik@amazon.com>, <netanel@amazon.com>, <alisaidi@amazon.com>,
        <benh@amazon.com>, Sameeh Jubran <sameehj@amazon.com>
Subject: [PATCH V1 net-next 1/6] net: ena: add MAX_QUEUES_EXT get feature admin command
Date:   Thu, 6 Jun 2019 14:55:15 +0300
Message-ID: <20190606115520.20394-2-sameehj@amazon.com>
X-Mailer: git-send-email 2.17.1
In-Reply-To: <20190606115520.20394-1-sameehj@amazon.com>
References: <20190606115520.20394-1-sameehj@amazon.com>
MIME-Version: 1.0
Content-Type: text/plain
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Arthur Kiyanovski <akiyano@amazon.com>

Add a new admin command to support different queue size for Tx/Rx
queues (the change also support different SQ/CQ sizes)

Signed-off-by: Arthur Kiyanovski <akiyano@amazon.com>
Signed-off-by: Sameeh Jubran <sameehj@amazon.com>
---
 .../net/ethernet/amazon/ena/ena_admin_defs.h  | 56 +++++++++++++-
 drivers/net/ethernet/amazon/ena/ena_com.c     | 76 ++++++++++++-------
 drivers/net/ethernet/amazon/ena/ena_com.h     |  3 +
 3 files changed, 105 insertions(+), 30 deletions(-)

diff --git a/drivers/net/ethernet/amazon/ena/ena_admin_defs.h b/drivers/net/ethernet/amazon/ena/ena_admin_defs.h
index 414bae989..c8638f7b5 100644
--- a/drivers/net/ethernet/amazon/ena/ena_admin_defs.h
+++ b/drivers/net/ethernet/amazon/ena/ena_admin_defs.h
@@ -64,6 +64,7 @@ enum ena_admin_aq_feature_id {
 	ENA_ADMIN_LLQ                               = 4,
 	ENA_ADMIN_EXTRA_PROPERTIES_STRINGS          = 5,
 	ENA_ADMIN_EXTRA_PROPERTIES_FLAGS            = 6,
+	ENA_ADMIN_MAX_QUEUES_EXT                    = 7,
 	ENA_ADMIN_RSS_HASH_FUNCTION                 = 10,
 	ENA_ADMIN_STATELESS_OFFLOAD_CONFIG          = 11,
 	ENA_ADMIN_RSS_REDIRECTION_TABLE_CONFIG      = 12,
@@ -425,7 +426,13 @@ struct ena_admin_get_set_feature_common_desc {
 	/* as appears in ena_admin_aq_feature_id */
 	u8 feature_id;
 
-	u16 reserved16;
+	/* The driver specifies the max feature version it supports and the
+	 * device responds with the currently supported feature version. The
+	 * field is zero based
+	 */
+	u8 feature_version;
+
+	u8 reserved8;
 };
 
 struct ena_admin_device_attr_feature_desc {
@@ -535,6 +542,34 @@ struct ena_admin_feature_llq_desc {
 	u32 max_tx_burst_size;
 };
 
+struct ena_admin_queue_ext_feature_fields {
+	u32 max_tx_sq_num;
+
+	u32 max_tx_cq_num;
+
+	u32 max_rx_sq_num;
+
+	u32 max_rx_cq_num;
+
+	u32 max_tx_sq_depth;
+
+	u32 max_tx_cq_depth;
+
+	u32 max_rx_sq_depth;
+
+	u32 max_rx_cq_depth;
+
+	u32 max_tx_header_size;
+
+	/* Maximum Descriptors number, including meta descriptor, allowed for
+	 * a single Tx packet
+	 */
+	u16 max_per_packet_tx_descs;
+
+	/* Maximum Descriptors number allowed for a single Rx packet */
+	u16 max_per_packet_rx_descs;
+};
+
 struct ena_admin_queue_feature_desc {
 	u32 max_sq_num;
 
@@ -849,6 +884,19 @@ struct ena_admin_get_feat_cmd {
 	u32 raw[11];
 };
 
+struct ena_admin_queue_ext_feature_desc {
+	/* version */
+	u8 version;
+
+	u8 reserved1[3];
+
+	union {
+		struct ena_admin_queue_ext_feature_fields max_queue_ext;
+
+		u32 raw[10];
+	};
+};
+
 struct ena_admin_get_feat_resp {
 	struct ena_admin_acq_common_desc acq_common_desc;
 
@@ -861,6 +909,8 @@ struct ena_admin_get_feat_resp {
 
 		struct ena_admin_queue_feature_desc max_queue;
 
+		struct ena_admin_queue_ext_feature_desc max_queue_ext;
+
 		struct ena_admin_feature_aenq_desc aenq;
 
 		struct ena_admin_get_feature_link_desc link;
@@ -929,7 +979,9 @@ struct ena_admin_aenq_common_desc {
 
 	u16 syndrom;
 
-	/* 0 : phase */
+	/* 0 : phase
+	 * 7:1 : reserved - MBZ
+	 */
 	u8 flags;
 
 	u8 reserved1[3];
diff --git a/drivers/net/ethernet/amazon/ena/ena_com.c b/drivers/net/ethernet/amazon/ena/ena_com.c
index dbc12e383..9efb4be97 100644
--- a/drivers/net/ethernet/amazon/ena/ena_com.c
+++ b/drivers/net/ethernet/amazon/ena/ena_com.c
@@ -978,7 +978,8 @@ static int ena_com_get_feature_ex(struct ena_com_dev *ena_dev,
 				  struct ena_admin_get_feat_resp *get_resp,
 				  enum ena_admin_aq_feature_id feature_id,
 				  dma_addr_t control_buf_dma_addr,
-				  u32 control_buff_size)
+				  u32 control_buff_size,
+				  u8 feature_ver)
 {
 	struct ena_com_admin_queue *admin_queue;
 	struct ena_admin_get_feat_cmd get_cmd;
@@ -1009,7 +1010,7 @@ static int ena_com_get_feature_ex(struct ena_com_dev *ena_dev,
 	}
 
 	get_cmd.control_buffer.length = control_buff_size;
-
+	get_cmd.feat_common.feature_version = feature_ver;
 	get_cmd.feat_common.feature_id = feature_id;
 
 	ret = ena_com_execute_admin_command(admin_queue,
@@ -1029,13 +1030,15 @@ static int ena_com_get_feature_ex(struct ena_com_dev *ena_dev,
 
 static int ena_com_get_feature(struct ena_com_dev *ena_dev,
 			       struct ena_admin_get_feat_resp *get_resp,
-			       enum ena_admin_aq_feature_id feature_id)
+			       enum ena_admin_aq_feature_id feature_id,
+			       u8 feature_ver)
 {
 	return ena_com_get_feature_ex(ena_dev,
 				      get_resp,
 				      feature_id,
 				      0,
-				      0);
+				      0,
+				      feature_ver);
 }
 
 static int ena_com_hash_key_allocate(struct ena_com_dev *ena_dev)
@@ -1095,7 +1098,7 @@ static int ena_com_indirect_table_allocate(struct ena_com_dev *ena_dev,
 	int ret;
 
 	ret = ena_com_get_feature(ena_dev, &get_resp,
-				  ENA_ADMIN_RSS_REDIRECTION_TABLE_CONFIG);
+				  ENA_ADMIN_RSS_REDIRECTION_TABLE_CONFIG, 0);
 	if (unlikely(ret))
 		return ret;
 
@@ -1515,7 +1518,7 @@ int ena_com_set_aenq_config(struct ena_com_dev *ena_dev, u32 groups_flag)
 	struct ena_admin_get_feat_resp get_resp;
 	int ret;
 
-	ret = ena_com_get_feature(ena_dev, &get_resp, ENA_ADMIN_AENQ_CONFIG);
+	ret = ena_com_get_feature(ena_dev, &get_resp, ENA_ADMIN_AENQ_CONFIG, 0);
 	if (ret) {
 		pr_info("Can't get aenq configuration\n");
 		return ret;
@@ -1890,7 +1893,7 @@ void ena_com_destroy_io_queue(struct ena_com_dev *ena_dev, u16 qid)
 int ena_com_get_link_params(struct ena_com_dev *ena_dev,
 			    struct ena_admin_get_feat_resp *resp)
 {
-	return ena_com_get_feature(ena_dev, resp, ENA_ADMIN_LINK_CONFIG);
+	return ena_com_get_feature(ena_dev, resp, ENA_ADMIN_LINK_CONFIG, 0);
 }
 
 int ena_com_extra_properties_strings_init(struct ena_com_dev *ena_dev)
@@ -1916,7 +1919,7 @@ int ena_com_extra_properties_strings_init(struct ena_com_dev *ena_dev)
 	rc = ena_com_get_feature_ex(ena_dev, &resp,
 				    ENA_ADMIN_EXTRA_PROPERTIES_STRINGS,
 				    extra_properties_strings->dma_addr,
-				    extra_properties_strings->size);
+				    extra_properties_strings->size, 0);
 	if (rc) {
 		pr_debug("Failed to get extra properties strings\n");
 		goto err;
@@ -1946,7 +1949,7 @@ int ena_com_get_extra_properties_flags(struct ena_com_dev *ena_dev,
 				       struct ena_admin_get_feat_resp *resp)
 {
 	return ena_com_get_feature(ena_dev, resp,
-				   ENA_ADMIN_EXTRA_PROPERTIES_FLAGS);
+				   ENA_ADMIN_EXTRA_PROPERTIES_FLAGS, 0);
 }
 
 int ena_com_get_dev_attr_feat(struct ena_com_dev *ena_dev,
@@ -1956,7 +1959,7 @@ int ena_com_get_dev_attr_feat(struct ena_com_dev *ena_dev,
 	int rc;
 
 	rc = ena_com_get_feature(ena_dev, &get_resp,
-				 ENA_ADMIN_DEVICE_ATTRIBUTES);
+				 ENA_ADMIN_DEVICE_ATTRIBUTES, 0);
 	if (rc)
 		return rc;
 
@@ -1964,17 +1967,34 @@ int ena_com_get_dev_attr_feat(struct ena_com_dev *ena_dev,
 	       sizeof(get_resp.u.dev_attr));
 	ena_dev->supported_features = get_resp.u.dev_attr.supported_features;
 
-	rc = ena_com_get_feature(ena_dev, &get_resp,
-				 ENA_ADMIN_MAX_QUEUES_NUM);
-	if (rc)
-		return rc;
+	if (ena_dev->supported_features & BIT(ENA_ADMIN_MAX_QUEUES_EXT)) {
+		rc = ena_com_get_feature(ena_dev, &get_resp,
+					 ENA_ADMIN_MAX_QUEUES_EXT,
+					 ENA_FEATURE_MAX_QUEUE_EXT_VER);
+		if (rc)
+			return rc;
 
-	memcpy(&get_feat_ctx->max_queues, &get_resp.u.max_queue,
-	       sizeof(get_resp.u.max_queue));
-	ena_dev->tx_max_header_size = get_resp.u.max_queue.max_header_size;
+		if (get_resp.u.max_queue_ext.version != ENA_FEATURE_MAX_QUEUE_EXT_VER)
+			return -EINVAL;
+
+		memcpy(&get_feat_ctx->max_queue_ext, &get_resp.u.max_queue_ext,
+		       sizeof(get_resp.u.max_queue_ext));
+		ena_dev->tx_max_header_size =
+			get_resp.u.max_queue_ext.max_queue_ext.max_tx_header_size;
+	} else {
+		rc = ena_com_get_feature(ena_dev, &get_resp,
+					 ENA_ADMIN_MAX_QUEUES_NUM, 0);
+		memcpy(&get_feat_ctx->max_queues, &get_resp.u.max_queue,
+		       sizeof(get_resp.u.max_queue));
+		ena_dev->tx_max_header_size =
+			get_resp.u.max_queue.max_header_size;
+
+		if (rc)
+			return rc;
+	}
 
 	rc = ena_com_get_feature(ena_dev, &get_resp,
-				 ENA_ADMIN_AENQ_CONFIG);
+				 ENA_ADMIN_AENQ_CONFIG, 0);
 	if (rc)
 		return rc;
 
@@ -1982,7 +2002,7 @@ int ena_com_get_dev_attr_feat(struct ena_com_dev *ena_dev,
 	       sizeof(get_resp.u.aenq));
 
 	rc = ena_com_get_feature(ena_dev, &get_resp,
-				 ENA_ADMIN_STATELESS_OFFLOAD_CONFIG);
+				 ENA_ADMIN_STATELESS_OFFLOAD_CONFIG, 0);
 	if (rc)
 		return rc;
 
@@ -1992,7 +2012,7 @@ int ena_com_get_dev_attr_feat(struct ena_com_dev *ena_dev,
 	/* Driver hints isn't mandatory admin command. So in case the
 	 * command isn't supported set driver hints to 0
 	 */
-	rc = ena_com_get_feature(ena_dev, &get_resp, ENA_ADMIN_HW_HINTS);
+	rc = ena_com_get_feature(ena_dev, &get_resp, ENA_ADMIN_HW_HINTS, 0);
 
 	if (!rc)
 		memcpy(&get_feat_ctx->hw_hints, &get_resp.u.hw_hints,
@@ -2003,7 +2023,7 @@ int ena_com_get_dev_attr_feat(struct ena_com_dev *ena_dev,
 	else
 		return rc;
 
-	rc = ena_com_get_feature(ena_dev, &get_resp, ENA_ADMIN_LLQ);
+	rc = ena_com_get_feature(ena_dev, &get_resp, ENA_ADMIN_LLQ, 0);
 	if (!rc)
 		memcpy(&get_feat_ctx->llq, &get_resp.u.llq,
 		       sizeof(get_resp.u.llq));
@@ -2240,7 +2260,7 @@ int ena_com_get_offload_settings(struct ena_com_dev *ena_dev,
 	struct ena_admin_get_feat_resp resp;
 
 	ret = ena_com_get_feature(ena_dev, &resp,
-				  ENA_ADMIN_STATELESS_OFFLOAD_CONFIG);
+				  ENA_ADMIN_STATELESS_OFFLOAD_CONFIG, 0);
 	if (unlikely(ret)) {
 		pr_err("Failed to get offload capabilities %d\n", ret);
 		return ret;
@@ -2269,7 +2289,7 @@ int ena_com_set_hash_function(struct ena_com_dev *ena_dev)
 
 	/* Validate hash function is supported */
 	ret = ena_com_get_feature(ena_dev, &get_resp,
-				  ENA_ADMIN_RSS_HASH_FUNCTION);
+				  ENA_ADMIN_RSS_HASH_FUNCTION, 0);
 	if (unlikely(ret))
 		return ret;
 
@@ -2329,7 +2349,7 @@ int ena_com_fill_hash_function(struct ena_com_dev *ena_dev,
 	rc = ena_com_get_feature_ex(ena_dev, &get_resp,
 				    ENA_ADMIN_RSS_HASH_FUNCTION,
 				    rss->hash_key_dma_addr,
-				    sizeof(*rss->hash_key));
+				    sizeof(*rss->hash_key), 0);
 	if (unlikely(rc))
 		return rc;
 
@@ -2381,7 +2401,7 @@ int ena_com_get_hash_function(struct ena_com_dev *ena_dev,
 	rc = ena_com_get_feature_ex(ena_dev, &get_resp,
 				    ENA_ADMIN_RSS_HASH_FUNCTION,
 				    rss->hash_key_dma_addr,
-				    sizeof(*rss->hash_key));
+				    sizeof(*rss->hash_key), 0);
 	if (unlikely(rc))
 		return rc;
 
@@ -2406,7 +2426,7 @@ int ena_com_get_hash_ctrl(struct ena_com_dev *ena_dev,
 	rc = ena_com_get_feature_ex(ena_dev, &get_resp,
 				    ENA_ADMIN_RSS_HASH_INPUT,
 				    rss->hash_ctrl_dma_addr,
-				    sizeof(*rss->hash_ctrl));
+				    sizeof(*rss->hash_ctrl), 0);
 	if (unlikely(rc))
 		return rc;
 
@@ -2642,7 +2662,7 @@ int ena_com_indirect_table_get(struct ena_com_dev *ena_dev, u32 *ind_tbl)
 	rc = ena_com_get_feature_ex(ena_dev, &get_resp,
 				    ENA_ADMIN_RSS_REDIRECTION_TABLE_CONFIG,
 				    rss->rss_ind_tbl_dma_addr,
-				    tbl_size);
+				    tbl_size, 0);
 	if (unlikely(rc))
 		return rc;
 
@@ -2857,7 +2877,7 @@ int ena_com_init_interrupt_moderation(struct ena_com_dev *ena_dev)
 	int rc;
 
 	rc = ena_com_get_feature(ena_dev, &get_resp,
-				 ENA_ADMIN_INTERRUPT_MODERATION);
+				 ENA_ADMIN_INTERRUPT_MODERATION, 0);
 
 	if (rc) {
 		if (rc == -EOPNOTSUPP) {
diff --git a/drivers/net/ethernet/amazon/ena/ena_com.h b/drivers/net/ethernet/amazon/ena/ena_com.h
index 6d356cb05..4700d92a3 100644
--- a/drivers/net/ethernet/amazon/ena/ena_com.h
+++ b/drivers/net/ethernet/amazon/ena/ena_com.h
@@ -101,6 +101,8 @@
 
 #define ENA_HW_HINTS_NO_TIMEOUT				0xFFFF
 
+#define ENA_FEATURE_MAX_QUEUE_EXT_VER	1
+
 enum ena_intr_moder_level {
 	ENA_INTR_MODER_LOWEST = 0,
 	ENA_INTR_MODER_LOW,
@@ -389,6 +391,7 @@ struct ena_com_dev {
 
 struct ena_com_dev_get_features_ctx {
 	struct ena_admin_queue_feature_desc max_queues;
+	struct ena_admin_queue_ext_feature_desc max_queue_ext;
 	struct ena_admin_device_attr_feature_desc dev_attr;
 	struct ena_admin_feature_aenq_desc aenq;
 	struct ena_admin_feature_offload_desc offload;
-- 
2.17.1

