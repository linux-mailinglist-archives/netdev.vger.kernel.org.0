Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 5F4253B3542
	for <lists+netdev@lfdr.de>; Thu, 24 Jun 2021 20:08:04 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232572AbhFXSKN (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 24 Jun 2021 14:10:13 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:37750 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232554AbhFXSKG (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 24 Jun 2021 14:10:06 -0400
Received: from mail-qt1-x849.google.com (mail-qt1-x849.google.com [IPv6:2607:f8b0:4864:20::849])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id D980DC061574
        for <netdev@vger.kernel.org>; Thu, 24 Jun 2021 11:07:46 -0700 (PDT)
Received: by mail-qt1-x849.google.com with SMTP id c17-20020ac87d910000b029024ee21abd54so7094877qtd.19
        for <netdev@vger.kernel.org>; Thu, 24 Jun 2021 11:07:46 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20161025;
        h=date:in-reply-to:message-id:mime-version:references:subject:from:to
         :cc;
        bh=NBzeqdVL1FHtPJL1v/U3LdFAK/Op8Mjf4OERsboctv0=;
        b=j9KuaS+5HWylIDSUD6giBI0te8Nt6wzxz9KswJuFY3I3mJJRvZTpGqD208hLAnqZ6V
         EktgKWa0bLzb4P3L6ZVMbWdd8E9uoOudHB0OSM+AoQZJWGag8LoymBS/oFdWabxHBm8i
         PqCczUYgc5qwngPSn19SVSOIrPYVz6ADzVap8vKthHsbU9icml2K6TxZpJTb4taz6jGK
         ZfyXgMwWlsrOOxdnKgBQPw3F7ja9+NeZCQ0fM3cikB6fs2shTOw2m8UplDAqSt2qaJvI
         63h64POCpAo4ebyAgGhd7Mrhq8IKO1tg3Ju9A2uqYC8YdMCmbnnfyEvUWi0o//NmhFkd
         4IvQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:in-reply-to:message-id:mime-version
         :references:subject:from:to:cc;
        bh=NBzeqdVL1FHtPJL1v/U3LdFAK/Op8Mjf4OERsboctv0=;
        b=f3En8wnrcGiYF6ftP5XZ8k9YDFhfQhSMTzQFse+c3zh9MWlZhUoMfMsp9nh4xHMuY6
         U7MSdr7bYWOtZal0KER8M2PXz6kRX1bVGa6ADjAMNyKTHed4wZ3JzAbOvTRRtK1gtRkD
         cfryTstNPmtzPCC/DfULTK/1bAjX5W43rfQTl5EyBfCFDZ/yCn5rr4KKa89D70om4j5g
         MoRo/J1iK5jyPKdjVz9cjX3boDCO3TvvVBz2OTE8lpuKgMtBBGsQfl1U3BuguqxULFSX
         dJQB5ActJarZbZCvmObp4Zic7cs1WpbE0QmzKk1O+6QpdCDRPU10vCep1QKUd4zVUL3/
         jA7A==
X-Gm-Message-State: AOAM530eyaiNfSHcQ1XU1JRhqDX09iIwtfRj+tjQJe3HPXlTD0kggGRB
        as7/YGKUab+sjIo90abGaM0BNe0=
X-Google-Smtp-Source: ABdhPJzCF1h58ydwEH8bMakFltfZWWgVyA6V4+bBUJ37xfz/pPSpObFrSO7VPqVt/N+pXSp3LlgOvtw=
X-Received: from bcf-linux.svl.corp.google.com ([2620:15c:2c4:1:cb6c:4753:6df0:b898])
 (user=bcf job=sendgmr) by 2002:ad4:4ea7:: with SMTP id ed7mr4109382qvb.1.1624558066017;
 Thu, 24 Jun 2021 11:07:46 -0700 (PDT)
Date:   Thu, 24 Jun 2021 11:06:23 -0700
In-Reply-To: <20210624180632.3659809-1-bcf@google.com>
Message-Id: <20210624180632.3659809-8-bcf@google.com>
Mime-Version: 1.0
References: <20210624180632.3659809-1-bcf@google.com>
X-Mailer: git-send-email 2.32.0.93.g670b81a890-goog
Subject: [PATCH net-next 07/16] gve: adminq: DQO specific device descriptor logic
From:   Bailey Forrest <bcf@google.com>
To:     Bailey Forrest <bcf@google.com>,
        "David S . Miller" <davem@davemloft.net>
Cc:     netdev@vger.kernel.org, Willem de Bruijn <willemb@google.com>,
        Catherine Sullivan <csully@google.com>
Content-Type: text/plain; charset="UTF-8"
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

- In addition to TX and RX queues, DQO has TX completion and RX buffer
  queues.
  - TX completions are received when the device has completed sending a
    packet on the wire.
  - RX buffers are posted on a separate queue form the RX completions.
- DQO descriptor rings are allowed to be smaller than PAGE_SIZE.

Signed-off-by: Bailey Forrest <bcf@google.com>
Reviewed-by: Willem de Bruijn <willemb@google.com>
Reviewed-by: Catherine Sullivan <csully@google.com>
---
 drivers/net/ethernet/google/gve/gve.h        | 13 +++++
 drivers/net/ethernet/google/gve/gve_adminq.c | 57 ++++++++++++++------
 2 files changed, 55 insertions(+), 15 deletions(-)

diff --git a/drivers/net/ethernet/google/gve/gve.h b/drivers/net/ethernet/google/gve/gve.h
index 9cb9b8f3e66e..9045b86279cb 100644
--- a/drivers/net/ethernet/google/gve/gve.h
+++ b/drivers/net/ethernet/google/gve/gve.h
@@ -194,6 +194,11 @@ struct gve_qpl_config {
 	unsigned long *qpl_id_map; /* bitmap of used qpl ids */
 };
 
+struct gve_options_dqo_rda {
+	u16 tx_comp_ring_entries; /* number of tx_comp descriptors */
+	u16 rx_buff_ring_entries; /* number of rx_buff descriptors */
+};
+
 /* GVE_QUEUE_FORMAT_UNSPECIFIED must be zero since 0 is the default value
  * when the entire configure_device_resources command is zeroed out and the
  * queue_format is not specified.
@@ -286,6 +291,8 @@ struct gve_priv {
 	/* Gvnic device link speed from hypervisor. */
 	u64 link_speed;
 
+	struct gve_options_dqo_rda options_dqo_rda;
+
 	enum gve_queue_format queue_format;
 };
 
@@ -533,6 +540,12 @@ static inline enum dma_data_direction gve_qpl_dma_dir(struct gve_priv *priv,
 		return DMA_FROM_DEVICE;
 }
 
+static inline bool gve_is_gqi(struct gve_priv *priv)
+{
+	return priv->queue_format == GVE_GQI_RDA_FORMAT ||
+		priv->queue_format == GVE_GQI_QPL_FORMAT;
+}
+
 /* buffers */
 int gve_alloc_page(struct gve_priv *priv, struct device *dev,
 		   struct page **page, dma_addr_t *dma,
diff --git a/drivers/net/ethernet/google/gve/gve_adminq.c b/drivers/net/ethernet/google/gve/gve_adminq.c
index 9dfce9af60bc..9efa60ce34e0 100644
--- a/drivers/net/ethernet/google/gve/gve_adminq.c
+++ b/drivers/net/ethernet/google/gve/gve_adminq.c
@@ -602,6 +602,40 @@ int gve_adminq_destroy_rx_queues(struct gve_priv *priv, u32 num_queues)
 	return gve_adminq_kick_and_wait(priv);
 }
 
+static int gve_set_desc_cnt(struct gve_priv *priv,
+			    struct gve_device_descriptor *descriptor)
+{
+	priv->tx_desc_cnt = be16_to_cpu(descriptor->tx_queue_entries);
+	if (priv->tx_desc_cnt * sizeof(priv->tx->desc[0]) < PAGE_SIZE) {
+		dev_err(&priv->pdev->dev, "Tx desc count %d too low\n",
+			priv->tx_desc_cnt);
+		return -EINVAL;
+	}
+	priv->rx_desc_cnt = be16_to_cpu(descriptor->rx_queue_entries);
+	if (priv->rx_desc_cnt * sizeof(priv->rx->desc.desc_ring[0])
+	    < PAGE_SIZE) {
+		dev_err(&priv->pdev->dev, "Rx desc count %d too low\n",
+			priv->rx_desc_cnt);
+		return -EINVAL;
+	}
+	return 0;
+}
+
+static int
+gve_set_desc_cnt_dqo(struct gve_priv *priv,
+		     const struct gve_device_descriptor *descriptor,
+		     const struct gve_device_option_dqo_rda *dev_op_dqo_rda)
+{
+	priv->tx_desc_cnt = be16_to_cpu(descriptor->tx_queue_entries);
+	priv->options_dqo_rda.tx_comp_ring_entries =
+		be16_to_cpu(dev_op_dqo_rda->tx_comp_ring_entries);
+	priv->rx_desc_cnt = be16_to_cpu(descriptor->rx_queue_entries);
+	priv->options_dqo_rda.rx_buff_ring_entries =
+		be16_to_cpu(dev_op_dqo_rda->rx_buff_ring_entries);
+
+	return 0;
+}
+
 int gve_adminq_describe_device(struct gve_priv *priv)
 {
 	struct gve_device_option_gqi_rda *dev_op_gqi_rda = NULL;
@@ -655,22 +689,14 @@ int gve_adminq_describe_device(struct gve_priv *priv)
 		dev_info(&priv->pdev->dev,
 			 "Driver is running with GQI QPL queue format.\n");
 	}
-
-	priv->tx_desc_cnt = be16_to_cpu(descriptor->tx_queue_entries);
-	if (priv->tx_desc_cnt * sizeof(priv->tx->desc[0]) < PAGE_SIZE) {
-		dev_err(&priv->pdev->dev, "Tx desc count %d too low\n", priv->tx_desc_cnt);
-		err = -EINVAL;
-		goto free_device_descriptor;
+	if (gve_is_gqi(priv)) {
+		err = gve_set_desc_cnt(priv, descriptor);
+	} else {
+		err = gve_set_desc_cnt_dqo(priv, descriptor, dev_op_dqo_rda);
 	}
-	priv->rx_desc_cnt = be16_to_cpu(descriptor->rx_queue_entries);
-	if (priv->rx_desc_cnt * sizeof(priv->rx->desc.desc_ring[0])
-	    < PAGE_SIZE ||
-	    priv->rx_desc_cnt * sizeof(priv->rx->data.data_ring[0])
-	    < PAGE_SIZE) {
-		dev_err(&priv->pdev->dev, "Rx desc count %d too low\n", priv->rx_desc_cnt);
-		err = -EINVAL;
+	if (err)
 		goto free_device_descriptor;
-	}
+
 	priv->max_registered_pages =
 				be64_to_cpu(descriptor->max_registered_pages);
 	mtu = be16_to_cpu(descriptor->mtu);
@@ -686,7 +712,8 @@ int gve_adminq_describe_device(struct gve_priv *priv)
 	dev_info(&priv->pdev->dev, "MAC addr: %pM\n", mac);
 	priv->tx_pages_per_qpl = be16_to_cpu(descriptor->tx_pages_per_qpl);
 	priv->rx_data_slot_cnt = be16_to_cpu(descriptor->rx_pages_per_qpl);
-	if (priv->rx_data_slot_cnt < priv->rx_desc_cnt) {
+
+	if (gve_is_gqi(priv) && priv->rx_data_slot_cnt < priv->rx_desc_cnt) {
 		dev_err(&priv->pdev->dev, "rx_data_slot_cnt cannot be smaller than rx_desc_cnt, setting rx_desc_cnt down to %d.\n",
 			priv->rx_data_slot_cnt);
 		priv->rx_desc_cnt = priv->rx_data_slot_cnt;
-- 
2.32.0.288.g62a8d224e6-goog

