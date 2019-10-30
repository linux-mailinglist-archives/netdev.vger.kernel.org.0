Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id F029DEA5DF
	for <lists+netdev@lfdr.de>; Wed, 30 Oct 2019 23:00:38 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727232AbfJ3WAh (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 30 Oct 2019 18:00:37 -0400
Received: from mail-pg1-f201.google.com ([209.85.215.201]:51164 "EHLO
        mail-pg1-f201.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726826AbfJ3WAh (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 30 Oct 2019 18:00:37 -0400
Received: by mail-pg1-f201.google.com with SMTP id r24so2643187pgj.17
        for <netdev@vger.kernel.org>; Wed, 30 Oct 2019 15:00:36 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20161025;
        h=date:message-id:mime-version:subject:from:to:cc;
        bh=9Z9PJE69TkRCWWWgXqh2ZJ/7GTRBKRNuATEMcFOp0CM=;
        b=lByoByFZfLZYQI0AQyAPr9z8c545l7VCopi+1HaXw/gHZ2gM7lOOMUI0ApksIUviAL
         QOT2ZJJByCdi5a29eWsd1btMiAaTBSAeAFerDHnCbbI9PwTpFsxQ36XHuzsWUDr8SE0i
         i6SYA8yad3UHR0Rxj4Xxx2njf1NCsFEkFDLL2Ddb42teaoRahf3i5WkvQ2kk3zG4mwFT
         Je1VECUuRBLjJNLF8wpEvu6c68OpbHKLLIaNj1R9PdipqmsqI3RJY6Ddve+mOoqIzMbx
         QI+NS7oEU/6PzbrlDo1xW7etz/BQkKZv7bTCLesSCxshltENsIZ5AB8Rb16UoRMYAV/c
         p4XQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:message-id:mime-version:subject:from:to:cc;
        bh=9Z9PJE69TkRCWWWgXqh2ZJ/7GTRBKRNuATEMcFOp0CM=;
        b=ldt8wb9Y8ST7ODHlwur/wnNkxiZKNnRGpKmbuQBluqp/NpSDego3/Km/zbSvRYr2ZX
         2ow6870+GKoKPEiNrIIOAk9mg/cEZAfpD5VKkDJqofGDgxcSL1hj8i1jVrKVDeCE3mnU
         w3TUl2VCmq2GUfgMhXC6UI88HbQChFgcnQ2Ieipc1QPfEEJBhVLgr3Xm8tfT6Z2s21GY
         brueoROPdqE//xLSD86bXcyRF3sS9HDkGsSA35CfdYqNUvVVAvrVJxI5P/7d5F16Az6f
         43qXLzjeYdq7h6vuwGTvkKae0iJorGTeCC1r7MVty5zgZWWmlD79tdyWbCUSQwAyTGPV
         lCcg==
X-Gm-Message-State: APjAAAWiOsEyGr7tobROMN/8dLwcB20iaoBzF6/uZusn23aYXOyttje5
        yfL3zN8r4KsHBoHlNNirVMfEskB8tKv4z57KqjKq62mwnIF9WzqC0ThElk8Ago3rGo3jMAyeFyS
        88JhW8ptsQvKbYvZwmI3n7Iae7/qj7D2bYfkcFoe7173f9vLkG+DDcV/UTIZaxpNY97M=
X-Google-Smtp-Source: APXvYqzLU5I9oWdrb/08ByyckVxtuoLLGMHmgGZjOiZ/HulC91ZXOXoUfuG8WY3jjBL2YQ+hCs3Ddao0zNPpEw==
X-Received: by 2002:a63:5810:: with SMTP id m16mr1858943pgb.162.1572472835785;
 Wed, 30 Oct 2019 15:00:35 -0700 (PDT)
Date:   Wed, 30 Oct 2019 15:00:32 -0700
Message-Id: <20191030220032.199832-1-yangchun@google.com>
Mime-Version: 1.0
X-Mailer: git-send-email 2.24.0.rc0.303.g954a862665-goog
Subject: [PATCH net v2] gve: Fixes DMA synchronization.
From:   Yangchun Fu <yangchun@google.com>
To:     netdev@vger.kernel.org
Cc:     davem@davemloft.net, simon.horman@netronome.com,
        Yangchun Fu <yangchun@google.com>,
        Catherine Sullivan <csully@google.com>
Content-Type: text/plain; charset="UTF-8"
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Synces the DMA buffer properly in order for CPU and device to see
the most up-to-data data.

Signed-off-by: Yangchun Fu <yangchun@google.com>
Reviewed-by: Catherine Sullivan <csully@google.com>
---
Changes in v2:
	- Passes priv->pdev->dev directly instead of whole priv.
	- Removes inline keyword for function.
	
 drivers/net/ethernet/google/gve/gve_rx.c |  2 ++
 drivers/net/ethernet/google/gve/gve_tx.c | 24 ++++++++++++++++++++++--
 2 files changed, 24 insertions(+), 2 deletions(-)

diff --git a/drivers/net/ethernet/google/gve/gve_rx.c b/drivers/net/ethernet/google/gve/gve_rx.c
index 59564ac99d2a..edec61dfc868 100644
--- a/drivers/net/ethernet/google/gve/gve_rx.c
+++ b/drivers/net/ethernet/google/gve/gve_rx.c
@@ -289,6 +289,8 @@ static bool gve_rx(struct gve_rx_ring *rx, struct gve_rx_desc *rx_desc,
 
 	len = be16_to_cpu(rx_desc->len) - GVE_RX_PAD;
 	page_info = &rx->data.page_info[idx];
+	dma_sync_single_for_cpu(&priv->pdev->dev, rx->data.qpl->page_buses[idx],
+				PAGE_SIZE, DMA_FROM_DEVICE);
 
 	/* gvnic can only receive into registered segments. If the buffer
 	 * can't be recycled, our only choice is to copy the data out of
diff --git a/drivers/net/ethernet/google/gve/gve_tx.c b/drivers/net/ethernet/google/gve/gve_tx.c
index 778b87b5a06c..a0a911cd1184 100644
--- a/drivers/net/ethernet/google/gve/gve_tx.c
+++ b/drivers/net/ethernet/google/gve/gve_tx.c
@@ -390,7 +390,21 @@ static void gve_tx_fill_seg_desc(union gve_tx_desc *seg_desc,
 	seg_desc->seg.seg_addr = cpu_to_be64(addr);
 }
 
-static int gve_tx_add_skb(struct gve_tx_ring *tx, struct sk_buff *skb)
+static void gve_dma_sync_for_device(struct device *dev, dma_addr_t *page_buses,
+				    u64 iov_offset, u64 iov_len)
+{
+	u64 addr;
+	dma_addr_t dma;
+
+	for (addr = iov_offset; addr < iov_offset + iov_len;
+	     addr += PAGE_SIZE) {
+		dma = page_buses[addr / PAGE_SIZE];
+		dma_sync_single_for_device(dev, dma, PAGE_SIZE, DMA_TO_DEVICE);
+	}
+}
+
+static int gve_tx_add_skb(struct gve_tx_ring *tx, struct sk_buff *skb,
+			  struct device *dev)
 {
 	int pad_bytes, hlen, hdr_nfrags, payload_nfrags, l4_hdr_offset;
 	union gve_tx_desc *pkt_desc, *seg_desc;
@@ -432,6 +446,9 @@ static int gve_tx_add_skb(struct gve_tx_ring *tx, struct sk_buff *skb)
 	skb_copy_bits(skb, 0,
 		      tx->tx_fifo.base + info->iov[hdr_nfrags - 1].iov_offset,
 		      hlen);
+	gve_dma_sync_for_device(dev, tx->tx_fifo.qpl->page_buses,
+				info->iov[hdr_nfrags - 1].iov_offset,
+				info->iov[hdr_nfrags - 1].iov_len);
 	copy_offset = hlen;
 
 	for (i = payload_iov; i < payload_nfrags + payload_iov; i++) {
@@ -445,6 +462,9 @@ static int gve_tx_add_skb(struct gve_tx_ring *tx, struct sk_buff *skb)
 		skb_copy_bits(skb, copy_offset,
 			      tx->tx_fifo.base + info->iov[i].iov_offset,
 			      info->iov[i].iov_len);
+		gve_dma_sync_for_device(dev, tx->tx_fifo.qpl->page_buses,
+					info->iov[i].iov_offset,
+					info->iov[i].iov_len);
 		copy_offset += info->iov[i].iov_len;
 	}
 
@@ -473,7 +493,7 @@ netdev_tx_t gve_tx(struct sk_buff *skb, struct net_device *dev)
 		gve_tx_put_doorbell(priv, tx->q_resources, tx->req);
 		return NETDEV_TX_BUSY;
 	}
-	nsegs = gve_tx_add_skb(tx, skb);
+	nsegs = gve_tx_add_skb(tx, skb, &priv->pdev->dev);
 
 	netdev_tx_sent_queue(tx->netdev_txq, skb->len);
 	skb_tx_timestamp(skb);
-- 
2.24.0.rc0.303.g954a862665-goog

