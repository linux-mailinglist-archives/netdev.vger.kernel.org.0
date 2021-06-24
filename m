Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 80C493B3549
	for <lists+netdev@lfdr.de>; Thu, 24 Jun 2021 20:09:06 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232590AbhFXSKl (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 24 Jun 2021 14:10:41 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:37856 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232600AbhFXSKT (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 24 Jun 2021 14:10:19 -0400
Received: from mail-yb1-xb4a.google.com (mail-yb1-xb4a.google.com [IPv6:2607:f8b0:4864:20::b4a])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 6DAA1C0617A8
        for <netdev@vger.kernel.org>; Thu, 24 Jun 2021 11:07:56 -0700 (PDT)
Received: by mail-yb1-xb4a.google.com with SMTP id x79-20020a25ce520000b02905519b84acfbso495831ybe.23
        for <netdev@vger.kernel.org>; Thu, 24 Jun 2021 11:07:56 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20161025;
        h=date:in-reply-to:message-id:mime-version:references:subject:from:to
         :cc;
        bh=tYPeUTCY6O5qLoeu23rNu4eVTYNZXjM9Mr8GOcPGRBo=;
        b=RsJt/DwobZzw85VUbh2A95NM2a/1VAx2KPqxBrPiBU5WYPZSVBKTyoclUZdFjOyZyk
         F5qxc+WBkxb+x0dAq3ePvee3t1rik/glhiJO3dkxVJ04Y+NWMv/WZ83tq0wmxzFwTFDb
         YeZBi/vNt9b4g+3pHnEthDxxqFCq7o6Q6jndjd7aNvJQz9QDbb69+W89YWFFES5wcmPG
         ZPl2siEByOiFnIqBzaUmh7syTBUbVd0qCnLSOJl824TvE12psL52ifq15Ps+bpebyCm8
         vy9gdUJajiCDt1XEQmsoLU1YiwhApuObBubuZcdxWIABasUvENLgHiCbq20P5lsMkJ88
         O16Q==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:in-reply-to:message-id:mime-version
         :references:subject:from:to:cc;
        bh=tYPeUTCY6O5qLoeu23rNu4eVTYNZXjM9Mr8GOcPGRBo=;
        b=sntfdkJEXUWOdyZYCQjEVyMZc1mTYYBiIfnOIekUfDmQprkOOuzjFUtim31+1lhj0R
         8vIhQjCxhubXRfVeqhNWUdDMM4cSwKM4wRrBMnWq6bttWwzcOUg8qwLEqCSikAEaaB16
         mmUNTG+4GMkXLy23MW1ZIq6TcyR+PmErdMjmoeKp5QlxkD6HdcKDRZWr6MdI2EGdcYUq
         CcAW7+0sA5BdJIj+OCtMJO33p+PbVREEk/5mnzYH18P4mg5cIbvs2N0SZOLd097pnwlR
         DpPEpAaVeL/yrnXQOukR2TTk3Nvm3121vSrBSVCudKeQjMffiE55djLUhqt9FcK8nBiF
         9xnQ==
X-Gm-Message-State: AOAM5300+nE1hbJBewRr5tc9zaRsXUmG2NKoKSYIgiuWlSKmkZGJZlKs
        natfZA5J/1KwbEX2gTVfbQgOXWw=
X-Google-Smtp-Source: ABdhPJzD3pl5QFMT0iOnF38qc752F6cbdkCah2AepBuV2XeSE3ZV7MDs9yaKen13hH6lwCpWEUXL4RE=
X-Received: from bcf-linux.svl.corp.google.com ([2620:15c:2c4:1:cb6c:4753:6df0:b898])
 (user=bcf job=sendgmr) by 2002:a25:3858:: with SMTP id f85mr6566309yba.202.1624558075609;
 Thu, 24 Jun 2021 11:07:55 -0700 (PDT)
Date:   Thu, 24 Jun 2021 11:06:27 -0700
In-Reply-To: <20210624180632.3659809-1-bcf@google.com>
Message-Id: <20210624180632.3659809-12-bcf@google.com>
Mime-Version: 1.0
References: <20210624180632.3659809-1-bcf@google.com>
X-Mailer: git-send-email 2.32.0.93.g670b81a890-goog
Subject: [PATCH net-next 11/16] gve: Update adminq commands to support DQO queues
From:   Bailey Forrest <bcf@google.com>
To:     Bailey Forrest <bcf@google.com>,
        "David S . Miller" <davem@davemloft.net>
Cc:     netdev@vger.kernel.org, Willem de Bruijn <willemb@google.com>,
        Catherine Sullivan <csully@google.com>
Content-Type: text/plain; charset="UTF-8"
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

DQO queue creation requires additional parameters:
- TX completion/RX buffer queue size
- TX completion/RX buffer queue address
- TX/RX queue size
- RX buffer size

Signed-off-by: Bailey Forrest <bcf@google.com>
Reviewed-by: Willem de Bruijn <willemb@google.com>
Reviewed-by: Catherine Sullivan <csully@google.com>
---
 drivers/net/ethernet/google/gve/gve.h         |  3 +
 drivers/net/ethernet/google/gve/gve_adminq.c  | 63 ++++++++++++-------
 drivers/net/ethernet/google/gve/gve_adminq.h  | 18 ++++--
 drivers/net/ethernet/google/gve/gve_ethtool.c |  9 ++-
 4 files changed, 64 insertions(+), 29 deletions(-)

diff --git a/drivers/net/ethernet/google/gve/gve.h b/drivers/net/ethernet/google/gve/gve.h
index 5bfab1ac20d1..8a2a8d125090 100644
--- a/drivers/net/ethernet/google/gve/gve.h
+++ b/drivers/net/ethernet/google/gve/gve.h
@@ -548,6 +548,9 @@ struct gve_priv {
 	struct gve_options_dqo_rda options_dqo_rda;
 	struct gve_ptype_lut *ptype_lut_dqo;
 
+	/* Must be a power of two. */
+	int data_buffer_size_dqo;
+
 	enum gve_queue_format queue_format;
 };
 
diff --git a/drivers/net/ethernet/google/gve/gve_adminq.c b/drivers/net/ethernet/google/gve/gve_adminq.c
index 7d8d354f67e2..cf017a499119 100644
--- a/drivers/net/ethernet/google/gve/gve_adminq.c
+++ b/drivers/net/ethernet/google/gve/gve_adminq.c
@@ -443,6 +443,7 @@ int gve_adminq_configure_device_resources(struct gve_priv *priv,
 		.irq_db_stride = cpu_to_be32(sizeof(priv->ntfy_blocks[0])),
 		.ntfy_blk_msix_base_idx =
 					cpu_to_be32(GVE_NTFY_BLK_BASE_MSIX_IDX),
+		.queue_format = priv->queue_format,
 	};
 
 	return gve_adminq_execute_cmd(priv, &cmd);
@@ -462,28 +463,32 @@ static int gve_adminq_create_tx_queue(struct gve_priv *priv, u32 queue_index)
 {
 	struct gve_tx_ring *tx = &priv->tx[queue_index];
 	union gve_adminq_command cmd;
-	u32 qpl_id;
-	int err;
 
-	qpl_id = priv->queue_format == GVE_GQI_RDA_FORMAT ?
-		 GVE_RAW_ADDRESSING_QPL_ID : tx->tx_fifo.qpl->id;
 	memset(&cmd, 0, sizeof(cmd));
 	cmd.opcode = cpu_to_be32(GVE_ADMINQ_CREATE_TX_QUEUE);
 	cmd.create_tx_queue = (struct gve_adminq_create_tx_queue) {
 		.queue_id = cpu_to_be32(queue_index),
-		.reserved = 0,
 		.queue_resources_addr =
 			cpu_to_be64(tx->q_resources_bus),
 		.tx_ring_addr = cpu_to_be64(tx->bus),
-		.queue_page_list_id = cpu_to_be32(qpl_id),
 		.ntfy_id = cpu_to_be32(tx->ntfy_id),
 	};
 
-	err = gve_adminq_issue_cmd(priv, &cmd);
-	if (err)
-		return err;
+	if (gve_is_gqi(priv)) {
+		u32 qpl_id = priv->queue_format == GVE_GQI_RDA_FORMAT ?
+			GVE_RAW_ADDRESSING_QPL_ID : tx->tx_fifo.qpl->id;
 
-	return 0;
+		cmd.create_tx_queue.queue_page_list_id = cpu_to_be32(qpl_id);
+	} else {
+		cmd.create_tx_queue.tx_ring_size =
+			cpu_to_be16(priv->tx_desc_cnt);
+		cmd.create_tx_queue.tx_comp_ring_addr =
+			cpu_to_be64(tx->complq_bus_dqo);
+		cmd.create_tx_queue.tx_comp_ring_size =
+			cpu_to_be16(priv->options_dqo_rda.tx_comp_ring_entries);
+	}
+
+	return gve_adminq_issue_cmd(priv, &cmd);
 }
 
 int gve_adminq_create_tx_queues(struct gve_priv *priv, u32 num_queues)
@@ -504,29 +509,41 @@ static int gve_adminq_create_rx_queue(struct gve_priv *priv, u32 queue_index)
 {
 	struct gve_rx_ring *rx = &priv->rx[queue_index];
 	union gve_adminq_command cmd;
-	u32 qpl_id;
-	int err;
 
-	qpl_id = priv->queue_format == GVE_GQI_RDA_FORMAT ?
-		 GVE_RAW_ADDRESSING_QPL_ID : rx->data.qpl->id;
 	memset(&cmd, 0, sizeof(cmd));
 	cmd.opcode = cpu_to_be32(GVE_ADMINQ_CREATE_RX_QUEUE);
 	cmd.create_rx_queue = (struct gve_adminq_create_rx_queue) {
 		.queue_id = cpu_to_be32(queue_index),
-		.index = cpu_to_be32(queue_index),
-		.reserved = 0,
 		.ntfy_id = cpu_to_be32(rx->ntfy_id),
 		.queue_resources_addr = cpu_to_be64(rx->q_resources_bus),
-		.rx_desc_ring_addr = cpu_to_be64(rx->desc.bus),
-		.rx_data_ring_addr = cpu_to_be64(rx->data.data_bus),
-		.queue_page_list_id = cpu_to_be32(qpl_id),
 	};
 
-	err = gve_adminq_issue_cmd(priv, &cmd);
-	if (err)
-		return err;
+	if (gve_is_gqi(priv)) {
+		u32 qpl_id = priv->queue_format == GVE_GQI_RDA_FORMAT ?
+			GVE_RAW_ADDRESSING_QPL_ID : rx->data.qpl->id;
+
+		cmd.create_rx_queue.rx_desc_ring_addr =
+			cpu_to_be64(rx->desc.bus),
+		cmd.create_rx_queue.rx_data_ring_addr =
+			cpu_to_be64(rx->data.data_bus),
+		cmd.create_rx_queue.index = cpu_to_be32(queue_index);
+		cmd.create_rx_queue.queue_page_list_id = cpu_to_be32(qpl_id);
+	} else {
+		cmd.create_rx_queue.rx_ring_size =
+			cpu_to_be16(priv->rx_desc_cnt);
+		cmd.create_rx_queue.rx_desc_ring_addr =
+			cpu_to_be64(rx->dqo.complq.bus);
+		cmd.create_rx_queue.rx_data_ring_addr =
+			cpu_to_be64(rx->dqo.bufq.bus);
+		cmd.create_rx_queue.packet_buffer_size =
+			cpu_to_be16(priv->data_buffer_size_dqo);
+		cmd.create_rx_queue.rx_buff_ring_size =
+			cpu_to_be16(priv->options_dqo_rda.rx_buff_ring_entries);
+		cmd.create_rx_queue.enable_rsc =
+			!!(priv->dev->features & NETIF_F_LRO);
+	}
 
-	return 0;
+	return gve_adminq_issue_cmd(priv, &cmd);
 }
 
 int gve_adminq_create_rx_queues(struct gve_priv *priv, u32 num_queues)
diff --git a/drivers/net/ethernet/google/gve/gve_adminq.h b/drivers/net/ethernet/google/gve/gve_adminq.h
index 62a7e96af715..47c3d8f313fc 100644
--- a/drivers/net/ethernet/google/gve/gve_adminq.h
+++ b/drivers/net/ethernet/google/gve/gve_adminq.h
@@ -139,9 +139,11 @@ struct gve_adminq_configure_device_resources {
 	__be32 num_irq_dbs;
 	__be32 irq_db_stride;
 	__be32 ntfy_blk_msix_base_idx;
+	u8 queue_format;
+	u8 padding[7];
 };
 
-static_assert(sizeof(struct gve_adminq_configure_device_resources) == 32);
+static_assert(sizeof(struct gve_adminq_configure_device_resources) == 40);
 
 struct gve_adminq_register_page_list {
 	__be32 page_list_id;
@@ -166,9 +168,13 @@ struct gve_adminq_create_tx_queue {
 	__be64 tx_ring_addr;
 	__be32 queue_page_list_id;
 	__be32 ntfy_id;
+	__be64 tx_comp_ring_addr;
+	__be16 tx_ring_size;
+	__be16 tx_comp_ring_size;
+	u8 padding[4];
 };
 
-static_assert(sizeof(struct gve_adminq_create_tx_queue) == 32);
+static_assert(sizeof(struct gve_adminq_create_tx_queue) == 48);
 
 struct gve_adminq_create_rx_queue {
 	__be32 queue_id;
@@ -179,10 +185,14 @@ struct gve_adminq_create_rx_queue {
 	__be64 rx_desc_ring_addr;
 	__be64 rx_data_ring_addr;
 	__be32 queue_page_list_id;
-	u8 padding[4];
+	__be16 rx_ring_size;
+	__be16 packet_buffer_size;
+	__be16 rx_buff_ring_size;
+	u8 enable_rsc;
+	u8 padding[5];
 };
 
-static_assert(sizeof(struct gve_adminq_create_rx_queue) == 48);
+static_assert(sizeof(struct gve_adminq_create_rx_queue) == 56);
 
 /* Queue resources that are shared with the device */
 struct gve_queue_resources {
diff --git a/drivers/net/ethernet/google/gve/gve_ethtool.c b/drivers/net/ethernet/google/gve/gve_ethtool.c
index 5fb05cf36b49..ccaf68562312 100644
--- a/drivers/net/ethernet/google/gve/gve_ethtool.c
+++ b/drivers/net/ethernet/google/gve/gve_ethtool.c
@@ -1,7 +1,7 @@
 // SPDX-License-Identifier: (GPL-2.0 OR MIT)
 /* Google virtual Ethernet (gve) driver
  *
- * Copyright (C) 2015-2019 Google, Inc.
+ * Copyright (C) 2015-2021 Google, Inc.
  */
 
 #include <linux/ethtool.h>
@@ -453,11 +453,16 @@ static int gve_set_tunable(struct net_device *netdev,
 
 	switch (etuna->id) {
 	case ETHTOOL_RX_COPYBREAK:
+	{
+		u32 max_copybreak = gve_is_gqi(priv) ?
+			(PAGE_SIZE / 2) : priv->data_buffer_size_dqo;
+
 		len = *(u32 *)value;
-		if (len > PAGE_SIZE / 2)
+		if (len > max_copybreak)
 			return -EINVAL;
 		priv->rx_copybreak = len;
 		return 0;
+	}
 	default:
 		return -EOPNOTSUPP;
 	}
-- 
2.32.0.288.g62a8d224e6-goog

