Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 9CC404989AB
	for <lists+netdev@lfdr.de>; Mon, 24 Jan 2022 19:57:56 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1343812AbiAXS5n (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 24 Jan 2022 13:57:43 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:44096 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1344557AbiAXSys (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 24 Jan 2022 13:54:48 -0500
Received: from mail-pj1-x1031.google.com (mail-pj1-x1031.google.com [IPv6:2607:f8b0:4864:20::1031])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 16949C061353
        for <netdev@vger.kernel.org>; Mon, 24 Jan 2022 10:53:40 -0800 (PST)
Received: by mail-pj1-x1031.google.com with SMTP id z10-20020a17090acb0a00b001b520826011so9903pjt.5
        for <netdev@vger.kernel.org>; Mon, 24 Jan 2022 10:53:40 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=pensando.io; s=google;
        h=from:to:cc:subject:date:message-id:in-reply-to:references;
        bh=mRU3UqtxyNf1zAAKIVJndcZ825EJaYE1oPvODudWCQ8=;
        b=Su6A/z1pEFp1PrJM9Cg/QxRHfMlW71lKnCMn5sEdyu10lKtz9GmtWoGE87dcgWbVjN
         zbI4C+SXP9p9WVwHCLaj8I6OE2hY6+Lc3CK6xJg2UKzyWp9GRWmvucITUxyQDXCdhgUK
         YCFVJfHhpwO5tMdSMEvfaCrRtSbpS8gtaC6Nk28gWBTfU/ur7vWx6HjL7Zc1gh+6AIRk
         lLat39EvFtAUdfj8mtv/kum16R5up352K4INvcspr1CdlgJuaJHgtJZwnuVgPbDYRxNR
         rzQDsqHmr5urPnOemcjI5aXIxlkS4YgbUDSII5KkPPjLIMmtIqZPfi9DozfXeMYJjVXA
         Ajtg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references;
        bh=mRU3UqtxyNf1zAAKIVJndcZ825EJaYE1oPvODudWCQ8=;
        b=4Vn7EtUirFNoqbksTYJUukzrDZRqxAmmhxz+yvonm2n/+w/s4b+46evvNhnh3Fk8hh
         dc9447kC261fuyOjhY4yB5hfUoT9mYrsxsviPf3uzh7r94xakIlMe9xjeQMcFc+DduF3
         mym0Q+vLQT7xawKPFPNHNvMX4EdnlbYptOkYHY1Ys2TkLV7C42E1OTmwJCmWiG+TQI2p
         ACzstseM1GWHxWxwWqS8lCA94Fo/EZlLQkggSruHKEsHxb6xK0NCcszXaRTH0McbDqwq
         ySlXksffw63cYR0OCi2kQEUDmBfVwJy1lQh7X7es7KTGg2LQpuaHE37hkLm4JnY3tfC4
         xjGQ==
X-Gm-Message-State: AOAM533u38aIoKFIhg3BVIrKSNwu+0L1upF/9VZYkfvpBpR4wOe64vV/
        2YlSUCdWBU42wnsw4sfceliibA==
X-Google-Smtp-Source: ABdhPJwiZlI+6lM4zYtUDrSGJziOeZRwsyDLx1c9BsYLXmuW9dbbfoDbNQ8EvUCAlZZX75p3ZF+iWQ==
X-Received: by 2002:a17:90a:5a0e:: with SMTP id b14mr3240419pjd.148.1643050419609;
        Mon, 24 Jan 2022 10:53:39 -0800 (PST)
Received: from driver-dev1.pensando.io ([12.226.153.42])
        by smtp.gmail.com with ESMTPSA id cq14sm85177pjb.33.2022.01.24.10.53.38
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 24 Jan 2022 10:53:39 -0800 (PST)
From:   Shannon Nelson <snelson@pensando.io>
To:     davem@davemloft.net, netdev@vger.kernel.org, kuba@kernel.org
Cc:     drivers@pensando.io, Brett Creeley <brett@pensando.io>,
        Shannon Nelson <snelson@pensando.io>
Subject: [PATCH net 12/16] ionic: Cleanups in the Tx hotpath code
Date:   Mon, 24 Jan 2022 10:53:08 -0800
Message-Id: <20220124185312.72646-13-snelson@pensando.io>
X-Mailer: git-send-email 2.17.1
In-Reply-To: <20220124185312.72646-1-snelson@pensando.io>
References: <20220124185312.72646-1-snelson@pensando.io>
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Brett Creeley <brett@pensando.io>

Buffer DMA mapping happens in ionic_tx_map_skb() and this function is
called from ionic_tx() and ionic_tx_tso(). If ionic_tx_map_skb()
succeeds, but a failure is encountered later in ionic_tx() or
ionic_tx_tso() we aren't unmapping the buffers. This can be fixed in
ionic_tx() by changing functions it calls to return void because they
always return 0. For ionic_tx_tso(), there's an actual possibility that
we leave the buffers mapped, so fix this by introducing the helper
function ionic_tx_desc_unmap_bufs(). This function is also re-used
in ionic_tx_clean().

Fixes: 0f3154e6bcb3 ("ionic: Add Tx and Rx handling")
Signed-off-by: Brett Creeley <brett@pensando.io>
Signed-off-by: Shannon Nelson <snelson@pensando.io>
---
 .../net/ethernet/pensando/ionic/ionic_txrx.c  | 66 ++++++++++---------
 1 file changed, 34 insertions(+), 32 deletions(-)

diff --git a/drivers/net/ethernet/pensando/ionic/ionic_txrx.c b/drivers/net/ethernet/pensando/ionic/ionic_txrx.c
index 94384f5d2a22..d197a70a49c9 100644
--- a/drivers/net/ethernet/pensando/ionic/ionic_txrx.c
+++ b/drivers/net/ethernet/pensando/ionic/ionic_txrx.c
@@ -669,27 +669,37 @@ static int ionic_tx_map_skb(struct ionic_queue *q, struct sk_buff *skb,
 	return -EIO;
 }
 
+static void ionic_tx_desc_unmap_bufs(struct ionic_queue *q,
+				     struct ionic_desc_info *desc_info)
+{
+	struct ionic_buf_info *buf_info = desc_info->bufs;
+	struct device *dev = q->dev;
+	unsigned int i;
+
+	if (!desc_info->nbufs)
+		return;
+
+	dma_unmap_single(dev, (dma_addr_t)buf_info->dma_addr,
+			 buf_info->len, DMA_TO_DEVICE);
+	buf_info++;
+	for (i = 1; i < desc_info->nbufs; i++, buf_info++)
+		dma_unmap_page(dev, (dma_addr_t)buf_info->dma_addr,
+			       buf_info->len, DMA_TO_DEVICE);
+
+	desc_info->nbufs = 0;
+}
+
 static void ionic_tx_clean(struct ionic_queue *q,
 			   struct ionic_desc_info *desc_info,
 			   struct ionic_cq_info *cq_info,
 			   void *cb_arg)
 {
-	struct ionic_buf_info *buf_info = desc_info->bufs;
 	struct ionic_tx_stats *stats = q_to_tx_stats(q);
 	struct ionic_qcq *qcq = q_to_qcq(q);
 	struct sk_buff *skb = cb_arg;
-	struct device *dev = q->dev;
-	unsigned int i;
 	u16 qi;
 
-	if (desc_info->nbufs) {
-		dma_unmap_single(dev, (dma_addr_t)buf_info->dma_addr,
-				 buf_info->len, DMA_TO_DEVICE);
-		buf_info++;
-		for (i = 1; i < desc_info->nbufs; i++, buf_info++)
-			dma_unmap_page(dev, (dma_addr_t)buf_info->dma_addr,
-				       buf_info->len, DMA_TO_DEVICE);
-	}
+	ionic_tx_desc_unmap_bufs(q, desc_info);
 
 	if (!skb)
 		return;
@@ -931,8 +941,11 @@ static int ionic_tx_tso(struct ionic_queue *q, struct sk_buff *skb)
 		err = ionic_tx_tcp_inner_pseudo_csum(skb);
 	else
 		err = ionic_tx_tcp_pseudo_csum(skb);
-	if (err)
+	if (err) {
+		/* clean up mapping from ionic_tx_map_skb */
+		ionic_tx_desc_unmap_bufs(q, desc_info);
 		return err;
+	}
 
 	if (encap)
 		hdrlen = skb_inner_transport_header(skb) - skb->data +
@@ -1003,8 +1016,8 @@ static int ionic_tx_tso(struct ionic_queue *q, struct sk_buff *skb)
 	return 0;
 }
 
-static int ionic_tx_calc_csum(struct ionic_queue *q, struct sk_buff *skb,
-			      struct ionic_desc_info *desc_info)
+static void ionic_tx_calc_csum(struct ionic_queue *q, struct sk_buff *skb,
+			       struct ionic_desc_info *desc_info)
 {
 	struct ionic_txq_desc *desc = desc_info->txq_desc;
 	struct ionic_buf_info *buf_info = desc_info->bufs;
@@ -1038,12 +1051,10 @@ static int ionic_tx_calc_csum(struct ionic_queue *q, struct sk_buff *skb,
 		stats->crc32_csum++;
 	else
 		stats->csum++;
-
-	return 0;
 }
 
-static int ionic_tx_calc_no_csum(struct ionic_queue *q, struct sk_buff *skb,
-				 struct ionic_desc_info *desc_info)
+static void ionic_tx_calc_no_csum(struct ionic_queue *q, struct sk_buff *skb,
+				  struct ionic_desc_info *desc_info)
 {
 	struct ionic_txq_desc *desc = desc_info->txq_desc;
 	struct ionic_buf_info *buf_info = desc_info->bufs;
@@ -1074,12 +1085,10 @@ static int ionic_tx_calc_no_csum(struct ionic_queue *q, struct sk_buff *skb,
 	desc->csum_offset = 0;
 
 	stats->csum_none++;
-
-	return 0;
 }
 
-static int ionic_tx_skb_frags(struct ionic_queue *q, struct sk_buff *skb,
-			      struct ionic_desc_info *desc_info)
+static void ionic_tx_skb_frags(struct ionic_queue *q, struct sk_buff *skb,
+			       struct ionic_desc_info *desc_info)
 {
 	struct ionic_txq_sg_desc *sg_desc = desc_info->txq_sg_desc;
 	struct ionic_buf_info *buf_info = &desc_info->bufs[1];
@@ -1093,31 +1102,24 @@ static int ionic_tx_skb_frags(struct ionic_queue *q, struct sk_buff *skb,
 	}
 
 	stats->frags += skb_shinfo(skb)->nr_frags;
-
-	return 0;
 }
 
 static int ionic_tx(struct ionic_queue *q, struct sk_buff *skb)
 {
 	struct ionic_desc_info *desc_info = &q->info[q->head_idx];
 	struct ionic_tx_stats *stats = q_to_tx_stats(q);
-	int err;
 
 	if (unlikely(ionic_tx_map_skb(q, skb, desc_info)))
 		return -EIO;
 
 	/* set up the initial descriptor */
 	if (skb->ip_summed == CHECKSUM_PARTIAL)
-		err = ionic_tx_calc_csum(q, skb, desc_info);
+		ionic_tx_calc_csum(q, skb, desc_info);
 	else
-		err = ionic_tx_calc_no_csum(q, skb, desc_info);
-	if (err)
-		return err;
+		ionic_tx_calc_no_csum(q, skb, desc_info);
 
 	/* add frags */
-	err = ionic_tx_skb_frags(q, skb, desc_info);
-	if (err)
-		return err;
+	ionic_tx_skb_frags(q, skb, desc_info);
 
 	skb_tx_timestamp(skb);
 	stats->pkts++;
-- 
2.17.1

