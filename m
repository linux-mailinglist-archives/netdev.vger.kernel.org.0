Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 20A4CE7858
	for <lists+netdev@lfdr.de>; Mon, 28 Oct 2019 19:23:35 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2404375AbfJ1SXd (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 28 Oct 2019 14:23:33 -0400
Received: from mail-pf1-f201.google.com ([209.85.210.201]:43676 "EHLO
        mail-pf1-f201.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S2404359AbfJ1SXd (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 28 Oct 2019 14:23:33 -0400
Received: by mail-pf1-f201.google.com with SMTP id i187so9212001pfc.10
        for <netdev@vger.kernel.org>; Mon, 28 Oct 2019 11:23:31 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20161025;
        h=date:message-id:mime-version:subject:from:to:cc;
        bh=ppBm0fKmBOdTFuSEk0MbgqDNTEpNStWaVhz7C3CAoKc=;
        b=kgzQ8vTpFHUX41G9N2wcnnfdfvvAXw/h5rhlQAiLOwYeelUTMO/Xl8BOV/0Nhr+nf9
         fH2VVpLX3BYcd+8RNK1FzahlWq7d+2OGSDxEUp1N39iB9cxU4/uAAsUTtXXC1XZvYz37
         HMGktcY8UTaUbJl8QqkD23k3jNHDT7qfpOlyzehxGwM/jeJJjFQmdZrox4O6iE57UElL
         wrqEfhrULDUaE+tfIHfajtSnsgKWDTDAXDlQg51+M9N8alvNezrXXDlesC5DCvFg8UK2
         PYsdSYUWR3su8pl6CQa6/4HA4hLav6EvINiGex7dpTZpXbMFrU0qyq1B4BFlc4BRUEU7
         teZA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:message-id:mime-version:subject:from:to:cc;
        bh=ppBm0fKmBOdTFuSEk0MbgqDNTEpNStWaVhz7C3CAoKc=;
        b=bXrAzysIXCxK4nTDvmBS6V4e+iws3N3XW+CW+H7DQEbRftHSmFLpCAauKM7CK1kQKL
         mPRm44RNKgGWQm16rJxnwRC+SQHSOLJDkli+6O3Uuu5J7aWutBGBDe5Y3sLEMTJTMh6B
         b5qROaadhfhk/jkG1yT++fIHjL3y8VX73qW5z4pMWKVIYhghp3flpNGU4l8hFhEY6nj/
         g5urZScp2JRTB/ja248g4WpSsE4l3MiNPqPlqCCyn8BsrcqEngHXzkCKwyuDbxY2JoOo
         x2uT5YhjFxJ9hP9Gl0BOJp63RQti/b+Jl03B/s5FMHjbenGUEn8hTcWJi6QTGkm8LDDB
         oorA==
X-Gm-Message-State: APjAAAVLseLee6XO4l9std+hEg6qU0vonolTcj8kwSjhORGnhlE3qr9F
        AUMr6pG3u10Hfri8IdJpMjtqwYMO8QgdN3FNIxRRLsQjmisAA6mGwxUlfhU0TDVEOC3r2ngsIW9
        H8rC0jZQmS4M7vZU5tuUPoO8XClLFFSx1Jrb2kwH031mI/8uQdbfCBC6Eaec6aSq1CqM=
X-Google-Smtp-Source: APXvYqz1KupkG5XJycSqSPEVglUXOeFCGYKeGuzuN+OIWDTJeILOotgValcZ0mL5S+3bC8BRrkhwdEfqRkeuXg==
X-Received: by 2002:a63:6287:: with SMTP id w129mr1618617pgb.162.1572287010443;
 Mon, 28 Oct 2019 11:23:30 -0700 (PDT)
Date:   Mon, 28 Oct 2019 11:23:09 -0700
Message-Id: <20191028182309.73313-1-yangchun@google.com>
Mime-Version: 1.0
X-Mailer: git-send-email 2.24.0.rc0.303.g954a862665-goog
Subject: [PATCH net] gve: Fixes DMA synchronization.
From:   Yangchun Fu <yangchun@google.com>
To:     netdev@vger.kernel.org
Cc:     Yangchun Fu <yangchun@google.com>,
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
 drivers/net/ethernet/google/gve/gve_rx.c |  2 ++
 drivers/net/ethernet/google/gve/gve_tx.c | 26 ++++++++++++++++++++++--
 2 files changed, 26 insertions(+), 2 deletions(-)

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
index 778b87b5a06c..d8342b7b9764 100644
--- a/drivers/net/ethernet/google/gve/gve_tx.c
+++ b/drivers/net/ethernet/google/gve/gve_tx.c
@@ -390,7 +390,23 @@ static void gve_tx_fill_seg_desc(union gve_tx_desc *seg_desc,
 	seg_desc->seg.seg_addr = cpu_to_be64(addr);
 }
 
-static int gve_tx_add_skb(struct gve_tx_ring *tx, struct sk_buff *skb)
+static inline void gve_dma_sync_for_device(struct gve_priv *priv,
+					   dma_addr_t *page_buses,
+					   u64 iov_offset, u64 iov_len)
+{
+	u64 addr;
+	dma_addr_t dma;
+
+	for (addr = iov_offset; addr < iov_offset + iov_len;
+	     addr += PAGE_SIZE) {
+		dma = page_buses[addr / PAGE_SIZE];
+		dma_sync_single_for_device(&priv->pdev->dev, dma, PAGE_SIZE,
+					   DMA_TO_DEVICE);
+	}
+}
+
+static int gve_tx_add_skb(struct gve_tx_ring *tx, struct sk_buff *skb,
+			  struct gve_priv *priv)
 {
 	int pad_bytes, hlen, hdr_nfrags, payload_nfrags, l4_hdr_offset;
 	union gve_tx_desc *pkt_desc, *seg_desc;
@@ -432,6 +448,9 @@ static int gve_tx_add_skb(struct gve_tx_ring *tx, struct sk_buff *skb)
 	skb_copy_bits(skb, 0,
 		      tx->tx_fifo.base + info->iov[hdr_nfrags - 1].iov_offset,
 		      hlen);
+	gve_dma_sync_for_device(priv, tx->tx_fifo.qpl->page_buses,
+				info->iov[hdr_nfrags - 1].iov_offset,
+				info->iov[hdr_nfrags - 1].iov_len);
 	copy_offset = hlen;
 
 	for (i = payload_iov; i < payload_nfrags + payload_iov; i++) {
@@ -445,6 +464,9 @@ static int gve_tx_add_skb(struct gve_tx_ring *tx, struct sk_buff *skb)
 		skb_copy_bits(skb, copy_offset,
 			      tx->tx_fifo.base + info->iov[i].iov_offset,
 			      info->iov[i].iov_len);
+		gve_dma_sync_for_device(priv, tx->tx_fifo.qpl->page_buses,
+					info->iov[i].iov_offset,
+					info->iov[i].iov_len);
 		copy_offset += info->iov[i].iov_len;
 	}
 
@@ -473,7 +495,7 @@ netdev_tx_t gve_tx(struct sk_buff *skb, struct net_device *dev)
 		gve_tx_put_doorbell(priv, tx->q_resources, tx->req);
 		return NETDEV_TX_BUSY;
 	}
-	nsegs = gve_tx_add_skb(tx, skb);
+	nsegs = gve_tx_add_skb(tx, skb, priv);
 
 	netdev_tx_sent_queue(tx->netdev_txq, skb->len);
 	skb_tx_timestamp(skb);
-- 
2.24.0.rc0.303.g954a862665-goog

