Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id F321D3B353F
	for <lists+netdev@lfdr.de>; Thu, 24 Jun 2021 20:07:50 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232530AbhFXSKI (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 24 Jun 2021 14:10:08 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:37750 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232509AbhFXSKB (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 24 Jun 2021 14:10:01 -0400
Received: from mail-yb1-xb4a.google.com (mail-yb1-xb4a.google.com [IPv6:2607:f8b0:4864:20::b4a])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 489E8C061766
        for <netdev@vger.kernel.org>; Thu, 24 Jun 2021 11:07:42 -0700 (PDT)
Received: by mail-yb1-xb4a.google.com with SMTP id v65-20020a25abc70000b02905574862aa77so495846ybi.21
        for <netdev@vger.kernel.org>; Thu, 24 Jun 2021 11:07:42 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20161025;
        h=date:in-reply-to:message-id:mime-version:references:subject:from:to
         :cc;
        bh=jpHb/6Wvw/QZVk2jJxCz3QzcPeHVV+pvgGPwgYsQ4Cw=;
        b=vgnC6qX7cpdKeM9axecEiIbfv23hA6M4//eLVVVFh58hxIDI30VyCnXlLGAtNRgm3i
         5FbNCOXo8w8O8PyiAfLm4+fXtlptCU9PCWwR2b2MwSpW4+YX2SNk8kOaV7mJpiwjRLfw
         q++soLSEuG+WDnadINNIYQsXXwzCpL+t5WiPniLz7M/dc7zs7fICnm6fsOGtuY2XY2Vq
         uuz349g7QUlUOFgyGfl184tTZIE0RD11LEb33gYj48ItTOn67Be5+O31ZSMrywCUe0LR
         FWNf5dCDn7W3OgZ3cy3iuTkgJe4y1VHzTctbnkHMtyTkfuJ22IUzo1LVfFRhw7xC4eFR
         /1Tg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:in-reply-to:message-id:mime-version
         :references:subject:from:to:cc;
        bh=jpHb/6Wvw/QZVk2jJxCz3QzcPeHVV+pvgGPwgYsQ4Cw=;
        b=erB7s0z3peUyVR2sFqtPfL1P8AiOUXk230httEXlRuZayrsZ9HnCkZ9BT2SyBKjkxp
         i/kYjXHg7D/eglfccgka+fOq0wO9+qNfiZnGBKJCiK4Ikgl+Y+tiQRF3J3paVB9LuO5+
         3xXxlyFd+17drrmEuSr5KtzmQFuKpJanauP9hhFqTC1qXVO0vGNgBAlaSNbJ8ccaX3mq
         RA8xAk+uvYJB7a1ZCpEvwkBaQHiN9JkVPxgX4jDyw3ajejm3AaeE5bSpEDI/kjzMyn9s
         7EVv8UIQ5PXA2VVy8UV2nucpBY0BvcIWXMlt1Mhx4oChFXgjhbOOeWjPPtIOkeSoQC/5
         h/Tg==
X-Gm-Message-State: AOAM530OBSD1VTjcRwVU+9YqXOCFo7IwfEcMv5EcNtjYhn02pKH9AEpx
        d2/3dZogR4XWmKAxNVnV1sH6gKg=
X-Google-Smtp-Source: ABdhPJw0OG80upVLc4pe7L91gf4uYdf2zyWRpvgpC/38hzJCcNt8abJobJip2pvyqvFSWQ+XQj9doNg=
X-Received: from bcf-linux.svl.corp.google.com ([2620:15c:2c4:1:cb6c:4753:6df0:b898])
 (user=bcf job=sendgmr) by 2002:a25:b793:: with SMTP id n19mr6781224ybh.488.1624558061453;
 Thu, 24 Jun 2021 11:07:41 -0700 (PDT)
Date:   Thu, 24 Jun 2021 11:06:21 -0700
In-Reply-To: <20210624180632.3659809-1-bcf@google.com>
Message-Id: <20210624180632.3659809-6-bcf@google.com>
Mime-Version: 1.0
References: <20210624180632.3659809-1-bcf@google.com>
X-Mailer: git-send-email 2.32.0.93.g670b81a890-goog
Subject: [PATCH net-next 05/16] gve: Introduce a new model for device options
From:   Bailey Forrest <bcf@google.com>
To:     Bailey Forrest <bcf@google.com>,
        "David S . Miller" <davem@davemloft.net>
Cc:     netdev@vger.kernel.org, Willem de Bruijn <willemb@google.com>,
        Catherine Sullivan <csully@google.com>
Content-Type: text/plain; charset="UTF-8"
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

The current model uses an integer ID and a fixed size struct for the
parameters of each device option.

The new model allows the device option structs to grow in size over
time. A driver may assume that changes to device option structs will
always be appended.

New device options will also generally have a
`supported_features_mask` so that the driver knows which fields within a
particular device option are enabled.

`gve_device_option.feat_mask` is changed to `required_features_mask`,
and it is a bitmask which must match the value expected by the driver.
This gives the device the ability to break backwards compatibility with
old drivers for certain features by blocking the old drivers from trying
to use the feature.

We maintain ABI compatibility with the old model for
GVE_DEV_OPT_ID_RAW_ADDRESSING in case a driver is using a device which
does not support the new model.

This patch introduces some new terminology:

RDA - Raw DMA Addressing - Buffers associated with SKBs are directly DMA
      mapped and read/updated by the device.

QPL - Queue Page Lists - Driver uses bounce buffers which are DMA mapped
      with the device for read/write and data is copied from/to SKBs.

Signed-off-by: Bailey Forrest <bcf@google.com>
Reviewed-by: Willem de Bruijn <willemb@google.com>
Reviewed-by: Catherine Sullivan <csully@google.com>
---
 drivers/net/ethernet/google/gve/gve_adminq.c | 172 +++++++++++++++----
 drivers/net/ethernet/google/gve/gve_adminq.h |  50 +++++-
 2 files changed, 179 insertions(+), 43 deletions(-)

diff --git a/drivers/net/ethernet/google/gve/gve_adminq.c b/drivers/net/ethernet/google/gve/gve_adminq.c
index 53864f200599..1c2a4ccaefe5 100644
--- a/drivers/net/ethernet/google/gve/gve_adminq.c
+++ b/drivers/net/ethernet/google/gve/gve_adminq.c
@@ -1,7 +1,7 @@
 // SPDX-License-Identifier: (GPL-2.0 OR MIT)
 /* Google virtual Ethernet (gve) driver
  *
- * Copyright (C) 2015-2019 Google, Inc.
+ * Copyright (C) 2015-2021 Google, Inc.
  */
 
 #include <linux/etherdevice.h>
@@ -18,6 +18,8 @@
 "Expected: length=%d, feature_mask=%x.\n" \
 "Actual: length=%d, feature_mask=%x.\n"
 
+#define GVE_DEVICE_OPTION_TOO_BIG_FMT "Length of %s option larger than expected. Possible older version of guest driver.\n"
+
 static
 struct gve_device_option *gve_get_next_option(struct gve_device_descriptor *descriptor,
 					      struct gve_device_option *option)
@@ -33,28 +35,81 @@ struct gve_device_option *gve_get_next_option(struct gve_device_descriptor *desc
 static
 void gve_parse_device_option(struct gve_priv *priv,
 			     struct gve_device_descriptor *device_descriptor,
-			     struct gve_device_option *option)
+			     struct gve_device_option *option,
+			     struct gve_device_option_gqi_rda **dev_op_gqi_rda,
+			     struct gve_device_option_gqi_qpl **dev_op_gqi_qpl,
+			     struct gve_device_option_dqo_rda **dev_op_dqo_rda)
 {
+	u32 req_feat_mask = be32_to_cpu(option->required_features_mask);
 	u16 option_length = be16_to_cpu(option->option_length);
 	u16 option_id = be16_to_cpu(option->option_id);
 
+	/* If the length or feature mask doesn't match, continue without
+	 * enabling the feature.
+	 */
 	switch (option_id) {
-	case GVE_DEV_OPT_ID_RAW_ADDRESSING:
-		/* If the length or feature mask doesn't match,
-		 * continue without enabling the feature.
-		 */
-		if (option_length != GVE_DEV_OPT_LEN_RAW_ADDRESSING ||
-		    option->feat_mask != cpu_to_be32(GVE_DEV_OPT_FEAT_MASK_RAW_ADDRESSING)) {
-			dev_warn(&priv->pdev->dev, GVE_DEVICE_OPTION_ERROR_FMT, "Raw Addressing",
-				 GVE_DEV_OPT_LEN_RAW_ADDRESSING,
-				 cpu_to_be32(GVE_DEV_OPT_FEAT_MASK_RAW_ADDRESSING),
-				 option_length, option->feat_mask);
-			priv->raw_addressing = 0;
-		} else {
-			dev_info(&priv->pdev->dev,
-				 "Raw addressing device option enabled.\n");
-			priv->raw_addressing = 1;
+	case GVE_DEV_OPT_ID_GQI_RAW_ADDRESSING:
+		if (option_length != GVE_DEV_OPT_LEN_GQI_RAW_ADDRESSING ||
+		    req_feat_mask != GVE_DEV_OPT_REQ_FEAT_MASK_GQI_RAW_ADDRESSING) {
+			dev_warn(&priv->pdev->dev, GVE_DEVICE_OPTION_ERROR_FMT,
+				 "Raw Addressing",
+				 GVE_DEV_OPT_LEN_GQI_RAW_ADDRESSING,
+				 GVE_DEV_OPT_REQ_FEAT_MASK_GQI_RAW_ADDRESSING,
+				 option_length, req_feat_mask);
+			break;
+		}
+
+		dev_info(&priv->pdev->dev,
+			 "Gqi raw addressing device option enabled.\n");
+		priv->raw_addressing = 1;
+		break;
+	case GVE_DEV_OPT_ID_GQI_RDA:
+		if (option_length < sizeof(**dev_op_gqi_rda) ||
+		    req_feat_mask != GVE_DEV_OPT_REQ_FEAT_MASK_GQI_RDA) {
+			dev_warn(&priv->pdev->dev, GVE_DEVICE_OPTION_ERROR_FMT,
+				 "GQI RDA", (int)sizeof(**dev_op_gqi_rda),
+				 GVE_DEV_OPT_REQ_FEAT_MASK_GQI_RDA,
+				 option_length, req_feat_mask);
+			break;
+		}
+
+		if (option_length > sizeof(**dev_op_gqi_rda)) {
+			dev_warn(&priv->pdev->dev,
+				 GVE_DEVICE_OPTION_TOO_BIG_FMT, "GQI RDA");
+		}
+		*dev_op_gqi_rda = (void *)(option + 1);
+		break;
+	case GVE_DEV_OPT_ID_GQI_QPL:
+		if (option_length < sizeof(**dev_op_gqi_qpl) ||
+		    req_feat_mask != GVE_DEV_OPT_REQ_FEAT_MASK_GQI_QPL) {
+			dev_warn(&priv->pdev->dev, GVE_DEVICE_OPTION_ERROR_FMT,
+				 "GQI QPL", (int)sizeof(**dev_op_gqi_qpl),
+				 GVE_DEV_OPT_REQ_FEAT_MASK_GQI_QPL,
+				 option_length, req_feat_mask);
+			break;
+		}
+
+		if (option_length > sizeof(**dev_op_gqi_qpl)) {
+			dev_warn(&priv->pdev->dev,
+				 GVE_DEVICE_OPTION_TOO_BIG_FMT, "GQI QPL");
+		}
+		*dev_op_gqi_qpl = (void *)(option + 1);
+		break;
+	case GVE_DEV_OPT_ID_DQO_RDA:
+		if (option_length < sizeof(**dev_op_dqo_rda) ||
+		    req_feat_mask != GVE_DEV_OPT_REQ_FEAT_MASK_DQO_RDA) {
+			dev_warn(&priv->pdev->dev, GVE_DEVICE_OPTION_ERROR_FMT,
+				 "DQO RDA", (int)sizeof(**dev_op_dqo_rda),
+				 GVE_DEV_OPT_REQ_FEAT_MASK_DQO_RDA,
+				 option_length, req_feat_mask);
+			break;
+		}
+
+		if (option_length > sizeof(**dev_op_dqo_rda)) {
+			dev_warn(&priv->pdev->dev,
+				 GVE_DEVICE_OPTION_TOO_BIG_FMT, "DQO RDA");
 		}
+		*dev_op_dqo_rda = (void *)(option + 1);
 		break;
 	default:
 		/* If we don't recognize the option just continue
@@ -65,6 +120,39 @@ void gve_parse_device_option(struct gve_priv *priv,
 	}
 }
 
+/* Process all device options for a given describe device call. */
+static int
+gve_process_device_options(struct gve_priv *priv,
+			   struct gve_device_descriptor *descriptor,
+			   struct gve_device_option_gqi_rda **dev_op_gqi_rda,
+			   struct gve_device_option_gqi_qpl **dev_op_gqi_qpl,
+			   struct gve_device_option_dqo_rda **dev_op_dqo_rda)
+{
+	const int num_options = be16_to_cpu(descriptor->num_device_options);
+	struct gve_device_option *dev_opt;
+	int i;
+
+	/* The options struct directly follows the device descriptor. */
+	dev_opt = (void *)(descriptor + 1);
+	for (i = 0; i < num_options; i++) {
+		struct gve_device_option *next_opt;
+
+		next_opt = gve_get_next_option(descriptor, dev_opt);
+		if (!next_opt) {
+			dev_err(&priv->dev->dev,
+				"options exceed device_descriptor's total length.\n");
+			return -EINVAL;
+		}
+
+		gve_parse_device_option(priv, descriptor, dev_opt,
+					dev_op_gqi_rda, dev_op_gqi_qpl,
+					dev_op_dqo_rda);
+		dev_opt = next_opt;
+	}
+
+	return 0;
+}
+
 int gve_adminq_alloc(struct device *dev, struct gve_priv *priv)
 {
 	priv->adminq = dma_alloc_coherent(dev, PAGE_SIZE,
@@ -514,15 +602,15 @@ int gve_adminq_destroy_rx_queues(struct gve_priv *priv, u32 num_queues)
 
 int gve_adminq_describe_device(struct gve_priv *priv)
 {
+	struct gve_device_option_gqi_rda *dev_op_gqi_rda = NULL;
+	struct gve_device_option_gqi_qpl *dev_op_gqi_qpl = NULL;
+	struct gve_device_option_dqo_rda *dev_op_dqo_rda = NULL;
 	struct gve_device_descriptor *descriptor;
-	struct gve_device_option *dev_opt;
 	union gve_adminq_command cmd;
 	dma_addr_t descriptor_bus;
-	u16 num_options;
 	int err = 0;
 	u8 *mac;
 	u16 mtu;
-	int i;
 
 	memset(&cmd, 0, sizeof(cmd));
 	descriptor = dma_alloc_coherent(&priv->pdev->dev, PAGE_SIZE,
@@ -540,6 +628,31 @@ int gve_adminq_describe_device(struct gve_priv *priv)
 	if (err)
 		goto free_device_descriptor;
 
+	priv->raw_addressing = 0;
+	err = gve_process_device_options(priv, descriptor, &dev_op_gqi_rda,
+					 &dev_op_gqi_qpl, &dev_op_dqo_rda);
+	if (err)
+		goto free_device_descriptor;
+
+	/* If the GQI_RAW_ADDRESSING option is not enabled and the queue format
+	 * is not set to GqiRda, choose the queue format in a priority order:
+	 * DqoRda, GqiRda, GqiQpl. Use GqiQpl as default.
+	 */
+	if (priv->raw_addressing == 1) {
+		dev_info(&priv->pdev->dev,
+			 "Driver is running with GQI RDA queue format.\n");
+	} else if (dev_op_dqo_rda) {
+		dev_info(&priv->pdev->dev,
+			 "Driver is running with DQO RDA queue format.\n");
+	} else if (dev_op_gqi_rda) {
+		dev_info(&priv->pdev->dev,
+			 "Driver is running with GQI RDA queue format.\n");
+		priv->raw_addressing = 1;
+	} else {
+		dev_info(&priv->pdev->dev,
+			 "Driver is running with GQI QPL queue format.\n");
+	}
+
 	priv->tx_desc_cnt = be16_to_cpu(descriptor->tx_queue_entries);
 	if (priv->tx_desc_cnt * sizeof(priv->tx->desc[0]) < PAGE_SIZE) {
 		dev_err(&priv->pdev->dev, "Tx desc count %d too low\n", priv->tx_desc_cnt);
@@ -576,26 +689,9 @@ int gve_adminq_describe_device(struct gve_priv *priv)
 		priv->rx_desc_cnt = priv->rx_data_slot_cnt;
 	}
 	priv->default_num_queues = be16_to_cpu(descriptor->default_num_queues);
-	dev_opt = (void *)(descriptor + 1);
-
-	num_options = be16_to_cpu(descriptor->num_device_options);
-	for (i = 0; i < num_options; i++) {
-		struct gve_device_option *next_opt;
-
-		next_opt = gve_get_next_option(descriptor, dev_opt);
-		if (!next_opt) {
-			dev_err(&priv->dev->dev,
-				"options exceed device_descriptor's total length.\n");
-			err = -EINVAL;
-			goto free_device_descriptor;
-		}
-
-		gve_parse_device_option(priv, descriptor, dev_opt);
-		dev_opt = next_opt;
-	}
 
 free_device_descriptor:
-	dma_free_coherent(&priv->pdev->dev, sizeof(*descriptor), descriptor,
+	dma_free_coherent(&priv->pdev->dev, PAGE_SIZE, descriptor,
 			  descriptor_bus);
 	return err;
 }
diff --git a/drivers/net/ethernet/google/gve/gve_adminq.h b/drivers/net/ethernet/google/gve/gve_adminq.h
index d320c2ffd87c..4b1485b11a7b 100644
--- a/drivers/net/ethernet/google/gve/gve_adminq.h
+++ b/drivers/net/ethernet/google/gve/gve_adminq.h
@@ -1,7 +1,7 @@
 /* SPDX-License-Identifier: (GPL-2.0 OR MIT)
  * Google virtual Ethernet (gve) driver
  *
- * Copyright (C) 2015-2019 Google, Inc.
+ * Copyright (C) 2015-2021 Google, Inc.
  */
 
 #ifndef _GVE_ADMINQ_H
@@ -82,14 +82,54 @@ static_assert(sizeof(struct gve_device_descriptor) == 40);
 struct gve_device_option {
 	__be16 option_id;
 	__be16 option_length;
-	__be32 feat_mask;
+	__be32 required_features_mask;
 };
 
 static_assert(sizeof(struct gve_device_option) == 8);
 
-#define GVE_DEV_OPT_ID_RAW_ADDRESSING 0x1
-#define GVE_DEV_OPT_LEN_RAW_ADDRESSING 0x0
-#define GVE_DEV_OPT_FEAT_MASK_RAW_ADDRESSING 0x0
+struct gve_device_option_gqi_rda {
+	__be32 supported_features_mask;
+};
+
+static_assert(sizeof(struct gve_device_option_gqi_rda) == 4);
+
+struct gve_device_option_gqi_qpl {
+	__be32 supported_features_mask;
+};
+
+static_assert(sizeof(struct gve_device_option_gqi_qpl) == 4);
+
+struct gve_device_option_dqo_rda {
+	__be32 supported_features_mask;
+	__be16 tx_comp_ring_entries;
+	__be16 rx_buff_ring_entries;
+};
+
+static_assert(sizeof(struct gve_device_option_dqo_rda) == 8);
+
+/* Terminology:
+ *
+ * RDA - Raw DMA Addressing - Buffers associated with SKBs are directly DMA
+ *       mapped and read/updated by the device.
+ *
+ * QPL - Queue Page Lists - Driver uses bounce buffers which are DMA mapped with
+ *       the device for read/write and data is copied from/to SKBs.
+ */
+enum gve_dev_opt_id {
+	GVE_DEV_OPT_ID_GQI_RAW_ADDRESSING = 0x1,
+	GVE_DEV_OPT_ID_GQI_RDA = 0x2,
+	GVE_DEV_OPT_ID_GQI_QPL = 0x3,
+	GVE_DEV_OPT_ID_DQO_RDA = 0x4,
+};
+
+enum gve_dev_opt_req_feat_mask {
+	GVE_DEV_OPT_REQ_FEAT_MASK_GQI_RAW_ADDRESSING = 0x0,
+	GVE_DEV_OPT_REQ_FEAT_MASK_GQI_RDA = 0x0,
+	GVE_DEV_OPT_REQ_FEAT_MASK_GQI_QPL = 0x0,
+	GVE_DEV_OPT_REQ_FEAT_MASK_DQO_RDA = 0x0,
+};
+
+#define GVE_DEV_OPT_LEN_GQI_RAW_ADDRESSING 0x0
 
 struct gve_adminq_configure_device_resources {
 	__be64 counter_array;
-- 
2.32.0.288.g62a8d224e6-goog

