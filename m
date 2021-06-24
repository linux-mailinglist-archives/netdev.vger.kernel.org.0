Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 161B13B3541
	for <lists+netdev@lfdr.de>; Thu, 24 Jun 2021 20:08:04 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232548AbhFXSKK (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 24 Jun 2021 14:10:10 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:37768 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231488AbhFXSKE (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 24 Jun 2021 14:10:04 -0400
Received: from mail-yb1-xb49.google.com (mail-yb1-xb49.google.com [IPv6:2607:f8b0:4864:20::b49])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 97377C061787
        for <netdev@vger.kernel.org>; Thu, 24 Jun 2021 11:07:44 -0700 (PDT)
Received: by mail-yb1-xb49.google.com with SMTP id v17-20020a25c5110000b0290553ebda4e3cso496634ybe.22
        for <netdev@vger.kernel.org>; Thu, 24 Jun 2021 11:07:44 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20161025;
        h=date:in-reply-to:message-id:mime-version:references:subject:from:to
         :cc;
        bh=Cez1stuTbQg/qcNgfFjOt3cVZ8ed4RVfK+/KWy1F4Ok=;
        b=SN0afJsF3nKVJQyyJvviboBhXek7rw9aC3H7yA62sjKG692iRt/L+PHYOnQayXaekN
         4pBhj6GYFlC9+3S33gj7DLugE7YJKwUL05r2cAAtVWz9GPGLegxoKJ9sSJH2REeyJN+c
         6et/qGgsUkm75fRRBjc0fX2LAwDXwNIWjWpBN0e4J+gG37r+6u6lQv+R92KBpdjyoKh5
         oIkmU9Xa7sxXXrXRvVp3M5O8Gk10YbYpq6EDho7E49ZDa5sGbw7kEZAwiMwPwdvRGyGI
         eE4FSUgwvVHb/qCFNKF4R9nybIp1MAR28UmXxJE1jil4YGP37QvVTbtIeJkHT4jnymfF
         32hw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:in-reply-to:message-id:mime-version
         :references:subject:from:to:cc;
        bh=Cez1stuTbQg/qcNgfFjOt3cVZ8ed4RVfK+/KWy1F4Ok=;
        b=UzF46/0KUr4RY0hFbzHF1671KoiTVuBnbrH9U+yDbwprbCTWpw5I2n0wechMykoZOJ
         pPgQzPXKH68J9sKVE6WTiat2gEJQxG4F6jQ/P02xaLKircFzGdA8rLWOZDRxtM63BA9E
         PXUv4d49BurnNoIeJll/gzcSXgTHp+KmQe+Z3rK6Nu0MdT40/sZN3q0lrNZvNZfwlaQD
         FwwC02V5Mq+psONiBZ3eiKlSlrYx/LKLeqQ45QUc34lvGGRzKWB76R2T8Ui9ns631g7U
         yiGZ1r1cDacn8/zs2GWzTssKpWVGmVM4DOU+hgUqrtUs4VqorWab5waA3RgKy4fC4/Gr
         atdw==
X-Gm-Message-State: AOAM530fUDb1iy9lW9C12ZrAN6+ZKyWoDZIG8qoaZymYTawfJGiGAeie
        ScJ1EwS/0PMGDxpEprSoCI6kKr0=
X-Google-Smtp-Source: ABdhPJzqoxuS4C4tjXz4EO6PBek40CdrHnZsNthZqJpN+iTO5BwyKKKYb+g7mOB4VA1oMxAMEIcniGY=
X-Received: from bcf-linux.svl.corp.google.com ([2620:15c:2c4:1:cb6c:4753:6df0:b898])
 (user=bcf job=sendgmr) by 2002:a25:f449:: with SMTP id p9mr6664903ybe.259.1624558063841;
 Thu, 24 Jun 2021 11:07:43 -0700 (PDT)
Date:   Thu, 24 Jun 2021 11:06:22 -0700
In-Reply-To: <20210624180632.3659809-1-bcf@google.com>
Message-Id: <20210624180632.3659809-7-bcf@google.com>
Mime-Version: 1.0
References: <20210624180632.3659809-1-bcf@google.com>
X-Mailer: git-send-email 2.32.0.93.g670b81a890-goog
Subject: [PATCH net-next 06/16] gve: Introduce per netdev `enum gve_queue_format`
From:   Bailey Forrest <bcf@google.com>
To:     Bailey Forrest <bcf@google.com>,
        "David S . Miller" <davem@davemloft.net>
Cc:     netdev@vger.kernel.org, Willem de Bruijn <willemb@google.com>,
        Catherine Sullivan <csully@google.com>
Content-Type: text/plain; charset="UTF-8"
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

The currently supported queue formats are:
- GQI_RDA - GQI with raw DMA addressing
- GQI_QPL - GQI with queue page list
- DQO_RDA - DQO with raw DMA addressing

The old `gve_priv.raw_addressing` value is only used for GQI_RDA, so we
remove it in favor of just checking against GQI_RDA

Signed-off-by: Bailey Forrest <bcf@google.com>
Reviewed-by: Willem de Bruijn <willemb@google.com>
Reviewed-by: Catherine Sullivan <csully@google.com>
---
 drivers/net/ethernet/google/gve/gve.h        | 24 +++++++++++++++++---
 drivers/net/ethernet/google/gve/gve_adminq.c | 15 +++++++-----
 drivers/net/ethernet/google/gve/gve_main.c   |  9 ++++----
 drivers/net/ethernet/google/gve/gve_rx.c     |  2 +-
 drivers/net/ethernet/google/gve/gve_tx.c     |  2 +-
 5 files changed, 37 insertions(+), 15 deletions(-)

diff --git a/drivers/net/ethernet/google/gve/gve.h b/drivers/net/ethernet/google/gve/gve.h
index 5467c74d379e..9cb9b8f3e66e 100644
--- a/drivers/net/ethernet/google/gve/gve.h
+++ b/drivers/net/ethernet/google/gve/gve.h
@@ -194,6 +194,17 @@ struct gve_qpl_config {
 	unsigned long *qpl_id_map; /* bitmap of used qpl ids */
 };
 
+/* GVE_QUEUE_FORMAT_UNSPECIFIED must be zero since 0 is the default value
+ * when the entire configure_device_resources command is zeroed out and the
+ * queue_format is not specified.
+ */
+enum gve_queue_format {
+	GVE_QUEUE_FORMAT_UNSPECIFIED	= 0x0,
+	GVE_GQI_RDA_FORMAT		= 0x1,
+	GVE_GQI_QPL_FORMAT		= 0x2,
+	GVE_DQO_RDA_FORMAT		= 0x3,
+};
+
 struct gve_priv {
 	struct net_device *dev;
 	struct gve_tx_ring *tx; /* array of tx_cfg.num_queues */
@@ -216,7 +227,6 @@ struct gve_priv {
 	u64 num_registered_pages; /* num pages registered with NIC */
 	u32 rx_copybreak; /* copy packets smaller than this */
 	u16 default_num_queues; /* default num queues to set up */
-	u8 raw_addressing; /* 1 if this dev supports raw addressing, 0 otherwise */
 
 	struct gve_queue_config tx_cfg;
 	struct gve_queue_config rx_cfg;
@@ -275,6 +285,8 @@ struct gve_priv {
 
 	/* Gvnic device link speed from hypervisor. */
 	u64 link_speed;
+
+	enum gve_queue_format queue_format;
 };
 
 enum gve_service_task_flags_bit {
@@ -454,14 +466,20 @@ static inline u32 gve_rx_idx_to_ntfy(struct gve_priv *priv, u32 queue_idx)
  */
 static inline u32 gve_num_tx_qpls(struct gve_priv *priv)
 {
-	return priv->raw_addressing ? 0 : priv->tx_cfg.num_queues;
+	if (priv->queue_format != GVE_GQI_QPL_FORMAT)
+		return 0;
+
+	return priv->tx_cfg.num_queues;
 }
 
 /* Returns the number of rx queue page lists
  */
 static inline u32 gve_num_rx_qpls(struct gve_priv *priv)
 {
-	return priv->raw_addressing ? 0 : priv->rx_cfg.num_queues;
+	if (priv->queue_format != GVE_GQI_QPL_FORMAT)
+		return 0;
+
+	return priv->rx_cfg.num_queues;
 }
 
 /* Returns a pointer to the next available tx qpl in the list of qpls
diff --git a/drivers/net/ethernet/google/gve/gve_adminq.c b/drivers/net/ethernet/google/gve/gve_adminq.c
index 1c2a4ccaefe5..9dfce9af60bc 100644
--- a/drivers/net/ethernet/google/gve/gve_adminq.c
+++ b/drivers/net/ethernet/google/gve/gve_adminq.c
@@ -61,7 +61,7 @@ void gve_parse_device_option(struct gve_priv *priv,
 
 		dev_info(&priv->pdev->dev,
 			 "Gqi raw addressing device option enabled.\n");
-		priv->raw_addressing = 1;
+		priv->queue_format = GVE_GQI_RDA_FORMAT;
 		break;
 	case GVE_DEV_OPT_ID_GQI_RDA:
 		if (option_length < sizeof(**dev_op_gqi_rda) ||
@@ -460,7 +460,8 @@ static int gve_adminq_create_tx_queue(struct gve_priv *priv, u32 queue_index)
 	u32 qpl_id;
 	int err;
 
-	qpl_id = priv->raw_addressing ? GVE_RAW_ADDRESSING_QPL_ID : tx->tx_fifo.qpl->id;
+	qpl_id = priv->queue_format == GVE_GQI_RDA_FORMAT ?
+		 GVE_RAW_ADDRESSING_QPL_ID : tx->tx_fifo.qpl->id;
 	memset(&cmd, 0, sizeof(cmd));
 	cmd.opcode = cpu_to_be32(GVE_ADMINQ_CREATE_TX_QUEUE);
 	cmd.create_tx_queue = (struct gve_adminq_create_tx_queue) {
@@ -501,7 +502,8 @@ static int gve_adminq_create_rx_queue(struct gve_priv *priv, u32 queue_index)
 	u32 qpl_id;
 	int err;
 
-	qpl_id = priv->raw_addressing ? GVE_RAW_ADDRESSING_QPL_ID : rx->data.qpl->id;
+	qpl_id = priv->queue_format == GVE_GQI_RDA_FORMAT ?
+		 GVE_RAW_ADDRESSING_QPL_ID : rx->data.qpl->id;
 	memset(&cmd, 0, sizeof(cmd));
 	cmd.opcode = cpu_to_be32(GVE_ADMINQ_CREATE_RX_QUEUE);
 	cmd.create_rx_queue = (struct gve_adminq_create_rx_queue) {
@@ -628,7 +630,6 @@ int gve_adminq_describe_device(struct gve_priv *priv)
 	if (err)
 		goto free_device_descriptor;
 
-	priv->raw_addressing = 0;
 	err = gve_process_device_options(priv, descriptor, &dev_op_gqi_rda,
 					 &dev_op_gqi_qpl, &dev_op_dqo_rda);
 	if (err)
@@ -638,17 +639,19 @@ int gve_adminq_describe_device(struct gve_priv *priv)
 	 * is not set to GqiRda, choose the queue format in a priority order:
 	 * DqoRda, GqiRda, GqiQpl. Use GqiQpl as default.
 	 */
-	if (priv->raw_addressing == 1) {
+	if (priv->queue_format == GVE_GQI_RDA_FORMAT) {
 		dev_info(&priv->pdev->dev,
 			 "Driver is running with GQI RDA queue format.\n");
 	} else if (dev_op_dqo_rda) {
+		priv->queue_format = GVE_DQO_RDA_FORMAT;
 		dev_info(&priv->pdev->dev,
 			 "Driver is running with DQO RDA queue format.\n");
 	} else if (dev_op_gqi_rda) {
+		priv->queue_format = GVE_GQI_RDA_FORMAT;
 		dev_info(&priv->pdev->dev,
 			 "Driver is running with GQI RDA queue format.\n");
-		priv->raw_addressing = 1;
 	} else {
+		priv->queue_format = GVE_GQI_QPL_FORMAT;
 		dev_info(&priv->pdev->dev,
 			 "Driver is running with GQI QPL queue format.\n");
 	}
diff --git a/drivers/net/ethernet/google/gve/gve_main.c b/drivers/net/ethernet/google/gve/gve_main.c
index bbc423e93122..aa0bff03c6c8 100644
--- a/drivers/net/ethernet/google/gve/gve_main.c
+++ b/drivers/net/ethernet/google/gve/gve_main.c
@@ -1,7 +1,7 @@
 // SPDX-License-Identifier: (GPL-2.0 OR MIT)
 /* Google virtual Ethernet (gve) driver
  *
- * Copyright (C) 2015-2019 Google, Inc.
+ * Copyright (C) 2015-2021 Google, Inc.
  */
 
 #include <linux/cpumask.h>
@@ -681,7 +681,7 @@ static int gve_alloc_qpls(struct gve_priv *priv)
 	int err;
 
 	/* Raw addressing means no QPLs */
-	if (priv->raw_addressing)
+	if (priv->queue_format == GVE_GQI_RDA_FORMAT)
 		return 0;
 
 	priv->qpls = kvzalloc(num_qpls * sizeof(*priv->qpls), GFP_KERNEL);
@@ -725,7 +725,7 @@ static void gve_free_qpls(struct gve_priv *priv)
 	int i;
 
 	/* Raw addressing means no QPLs */
-	if (priv->raw_addressing)
+	if (priv->queue_format == GVE_GQI_RDA_FORMAT)
 		return;
 
 	kvfree(priv->qpl_cfg.qpl_id_map);
@@ -1088,7 +1088,7 @@ static int gve_init_priv(struct gve_priv *priv, bool skip_describe_device)
 	if (skip_describe_device)
 		goto setup_device;
 
-	priv->raw_addressing = false;
+	priv->queue_format = GVE_QUEUE_FORMAT_UNSPECIFIED;
 	/* Get the initial information we need from the device */
 	err = gve_adminq_describe_device(priv);
 	if (err) {
@@ -1352,6 +1352,7 @@ static int gve_probe(struct pci_dev *pdev, const struct pci_device_id *ent)
 		goto abort_with_wq;
 
 	dev_info(&pdev->dev, "GVE version %s\n", gve_version_str);
+	dev_info(&pdev->dev, "GVE queue format %d\n", (int)priv->queue_format);
 	gve_clear_probe_in_progress(priv);
 	queue_work(priv->gve_wq, &priv->service_task);
 	return 0;
diff --git a/drivers/net/ethernet/google/gve/gve_rx.c b/drivers/net/ethernet/google/gve/gve_rx.c
index e14509614287..15a64e40004d 100644
--- a/drivers/net/ethernet/google/gve/gve_rx.c
+++ b/drivers/net/ethernet/google/gve/gve_rx.c
@@ -148,7 +148,7 @@ static int gve_rx_alloc_ring(struct gve_priv *priv, int idx)
 
 	slots = priv->rx_data_slot_cnt;
 	rx->mask = slots - 1;
-	rx->data.raw_addressing = priv->raw_addressing;
+	rx->data.raw_addressing = priv->queue_format == GVE_GQI_RDA_FORMAT;
 
 	/* alloc rx data ring */
 	bytes = sizeof(*rx->data.data_ring) * slots;
diff --git a/drivers/net/ethernet/google/gve/gve_tx.c b/drivers/net/ethernet/google/gve/gve_tx.c
index 6866f6e0139d..75930bb64eb9 100644
--- a/drivers/net/ethernet/google/gve/gve_tx.c
+++ b/drivers/net/ethernet/google/gve/gve_tx.c
@@ -191,7 +191,7 @@ static int gve_tx_alloc_ring(struct gve_priv *priv, int idx)
 	if (!tx->desc)
 		goto abort_with_info;
 
-	tx->raw_addressing = priv->raw_addressing;
+	tx->raw_addressing = priv->queue_format == GVE_GQI_RDA_FORMAT;
 	tx->dev = &priv->pdev->dev;
 	if (!tx->raw_addressing) {
 		tx->tx_fifo.qpl = gve_assign_tx_qpl(priv);
-- 
2.32.0.288.g62a8d224e6-goog

