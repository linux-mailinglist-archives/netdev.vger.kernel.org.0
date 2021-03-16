Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id AC17D33CB77
	for <lists+netdev@lfdr.de>; Tue, 16 Mar 2021 03:32:26 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232921AbhCPCb5 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 15 Mar 2021 22:31:57 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:38182 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S234594AbhCPCbv (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 15 Mar 2021 22:31:51 -0400
Received: from mail-pg1-x52f.google.com (mail-pg1-x52f.google.com [IPv6:2607:f8b0:4864:20::52f])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 56D5AC061756
        for <netdev@vger.kernel.org>; Mon, 15 Mar 2021 19:31:51 -0700 (PDT)
Received: by mail-pg1-x52f.google.com with SMTP id t37so10821143pga.11
        for <netdev@vger.kernel.org>; Mon, 15 Mar 2021 19:31:51 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=pensando.io; s=google;
        h=from:to:cc:subject:date:message-id:in-reply-to:references;
        bh=i8GkXn5ZP5S4E5t52lY5YVK+VfG9zlsLyHRTeIs78mw=;
        b=FQY/fuJRv6xiZWb3DbhhO3nUmcvO+TnCvEk2ZnogREU34HQjqhC2lqo+1RY+nuXnHX
         heC3YcNGFkwBsF/42l0kKNE+8duOqIBwj1/Tkwg/86A+S8hjclIq5dzTsjnhMoBgsgBE
         q4mZk1j1Q1t/5biMnJazI6V6s0K7urEeR9+RDiYCQBKhwi+CumdyphSaJ5nJPygeNIhR
         SDwMu6Vf+rDip9XkmbyyECmSB9GxbNkR1vbTxGHrReDPSauFuz7sJ+FEMnNVYu55Yg5e
         sHCwogeDB+Pc6bP0lscgMvBAN5I1EVz0BnNgVgwK8Kel6bxWaqWXpMHT8mgDn4H1F1nm
         sLfQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references;
        bh=i8GkXn5ZP5S4E5t52lY5YVK+VfG9zlsLyHRTeIs78mw=;
        b=M7PYjyIPL9UcBBeRvUj1uNJwBUKrX4cqO5G6dT4XB9M2NlZQS4NBfRcahYb5on8UDZ
         QB3iEr6d+WUg+lRKv+qUPoN9hy/PosKv36cxHJpLZP8/s8jZTHC6Zq/vGLqZicpGzwI8
         2X3IT3icHBG01WYah/RuHljydCptPCVImILOdEmT8+HD1tpYHAgimAuig+PImpGzSX6P
         r/+reA7NK3BEFNsiPlAoSEyukADVy1MOywep55UfPEXtFfC3nEYgpXqPDuKaxcMmFJ8T
         9pNlyHXveASwJv4fyhWF9wOGT6nkSjXb4B10B1vsnm//v4gLnBQwjspBhQjRRlaNhxu0
         q1SA==
X-Gm-Message-State: AOAM530ZPxlPyzHUq8iGWbMh/Cn6JKAvT0LNqzHzehYr/wwX7QrkeDe0
        fSz9YKjTIrbbsoc0nnuX7lSQ32by45phYg==
X-Google-Smtp-Source: ABdhPJyAPZdm9bl+eNDJNmEF9idCICsN57816NnSO7uqdPgFmHboEhBzJRTFAlg3ObTZXwTKfnVINQ==
X-Received: by 2002:a63:4956:: with SMTP id y22mr1849743pgk.309.1615861910612;
        Mon, 15 Mar 2021 19:31:50 -0700 (PDT)
Received: from driver-dev1.pensando.io ([12.226.153.42])
        by smtp.gmail.com with ESMTPSA id t18sm8687743pgg.33.2021.03.15.19.31.49
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 15 Mar 2021 19:31:50 -0700 (PDT)
From:   Shannon Nelson <snelson@pensando.io>
To:     netdev@vger.kernel.org, davem@davemloft.net, kuba@kernel.org
Cc:     drivers@pensando.io, Shannon Nelson <snelson@pensando.io>
Subject: [PATCH net-next 4/4] ionic: aggregate Tx byte counting calls
Date:   Mon, 15 Mar 2021 19:31:36 -0700
Message-Id: <20210316023136.22702-5-snelson@pensando.io>
X-Mailer: git-send-email 2.17.1
In-Reply-To: <20210316023136.22702-1-snelson@pensando.io>
References: <20210316023136.22702-1-snelson@pensando.io>
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Gather the Tx packet and byte counts and call
netdev_tx_completed_queue() only once per clean cycle.

Signed-off-by: Shannon Nelson <snelson@pensando.io>
---
 .../net/ethernet/pensando/ionic/ionic_dev.h   |  1 +
 .../net/ethernet/pensando/ionic/ionic_txrx.c  | 27 ++++++++++++++++---
 2 files changed, 25 insertions(+), 3 deletions(-)

diff --git a/drivers/net/ethernet/pensando/ionic/ionic_dev.h b/drivers/net/ethernet/pensando/ionic/ionic_dev.h
index d0c969a6d43e..ca7e55455165 100644
--- a/drivers/net/ethernet/pensando/ionic/ionic_dev.h
+++ b/drivers/net/ethernet/pensando/ionic/ionic_dev.h
@@ -196,6 +196,7 @@ struct ionic_desc_info {
 		struct ionic_txq_sg_desc *txq_sg_desc;
 		struct ionic_rxq_sg_desc *rxq_sgl_desc;
 	};
+	unsigned int bytes;
 	unsigned int nbufs;
 	struct ionic_buf_info bufs[IONIC_MAX_FRAGS];
 	ionic_desc_cb cb;
diff --git a/drivers/net/ethernet/pensando/ionic/ionic_txrx.c b/drivers/net/ethernet/pensando/ionic/ionic_txrx.c
index f841ccb5adfd..03e00a6c413a 100644
--- a/drivers/net/ethernet/pensando/ionic/ionic_txrx.c
+++ b/drivers/net/ethernet/pensando/ionic/ionic_txrx.c
@@ -671,7 +671,6 @@ static void ionic_tx_clean(struct ionic_queue *q,
 
 	if (cb_arg) {
 		struct sk_buff *skb = cb_arg;
-		u32 len = skb->len;
 
 		queue_index = skb_get_queue_mapping(skb);
 		if (unlikely(__netif_subqueue_stopped(q->lif->netdev,
@@ -679,9 +678,11 @@ static void ionic_tx_clean(struct ionic_queue *q,
 			netif_wake_subqueue(q->lif->netdev, queue_index);
 			q->wake++;
 		}
-		dev_kfree_skb_any(skb);
+
+		desc_info->bytes = skb->len;
 		stats->clean++;
-		netdev_tx_completed_queue(q_to_ndq(q), 1, len);
+
+		dev_consume_skb_any(skb);
 	}
 }
 
@@ -690,6 +691,8 @@ static bool ionic_tx_service(struct ionic_cq *cq, struct ionic_cq_info *cq_info)
 	struct ionic_txq_comp *comp = cq_info->txcq;
 	struct ionic_queue *q = cq->bound_q;
 	struct ionic_desc_info *desc_info;
+	int bytes = 0;
+	int pkts = 0;
 	u16 index;
 
 	if (!color_match(comp->color, cq->done_color))
@@ -700,13 +703,21 @@ static bool ionic_tx_service(struct ionic_cq *cq, struct ionic_cq_info *cq_info)
 	 */
 	do {
 		desc_info = &q->info[q->tail_idx];
+		desc_info->bytes = 0;
 		index = q->tail_idx;
 		q->tail_idx = (q->tail_idx + 1) & (q->num_descs - 1);
 		ionic_tx_clean(q, desc_info, cq_info, desc_info->cb_arg);
+		if (desc_info->cb_arg) {
+			pkts++;
+			bytes += desc_info->bytes;
+		}
 		desc_info->cb = NULL;
 		desc_info->cb_arg = NULL;
 	} while (index != le16_to_cpu(comp->comp_index));
 
+	if (pkts && bytes)
+		netdev_tx_completed_queue(q_to_ndq(q), pkts, bytes);
+
 	return true;
 }
 
@@ -725,15 +736,25 @@ void ionic_tx_flush(struct ionic_cq *cq)
 void ionic_tx_empty(struct ionic_queue *q)
 {
 	struct ionic_desc_info *desc_info;
+	int bytes = 0;
+	int pkts = 0;
 
 	/* walk the not completed tx entries, if any */
 	while (q->head_idx != q->tail_idx) {
 		desc_info = &q->info[q->tail_idx];
+		desc_info->bytes = 0;
 		q->tail_idx = (q->tail_idx + 1) & (q->num_descs - 1);
 		ionic_tx_clean(q, desc_info, NULL, desc_info->cb_arg);
+		if (desc_info->cb_arg) {
+			pkts++;
+			bytes += desc_info->bytes;
+		}
 		desc_info->cb = NULL;
 		desc_info->cb_arg = NULL;
 	}
+
+	if (pkts && bytes)
+		netdev_tx_completed_queue(q_to_ndq(q), pkts, bytes);
 }
 
 static int ionic_tx_tcp_inner_pseudo_csum(struct sk_buff *skb)
-- 
2.17.1

