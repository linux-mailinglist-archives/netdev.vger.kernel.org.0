Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 125C3EC73E
	for <lists+netdev@lfdr.de>; Fri,  1 Nov 2019 18:10:05 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728759AbfKARKC (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 1 Nov 2019 13:10:02 -0400
Received: from mail-pg1-f201.google.com ([209.85.215.201]:41645 "EHLO
        mail-pg1-f201.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1728016AbfKARKC (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 1 Nov 2019 13:10:02 -0400
Received: by mail-pg1-f201.google.com with SMTP id t6so3558744pgf.8
        for <netdev@vger.kernel.org>; Fri, 01 Nov 2019 10:10:01 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20161025;
        h=date:message-id:mime-version:subject:from:to:cc;
        bh=y86ShJc0lHY7mGjuegghOpKGlFnX8a1lnfR2jsV9nVk=;
        b=ecMqqHPfCAgFBm+cfNQQ+XYbaCWMZfUQZjfciiWwlPmWgiiVtZ1TrsiWxtjr3aWQ2Y
         uSniQmyE4jNRmI5AVkMqknqDx08U2j498jh3vCChGG+H2GpMzVzlJO1Z25HoVSMrKeL4
         nxzAFjLRVwF+UF3B9ogvEsxTmxUhbpeShPp74i+9WRwICdcFvyOe//KqHtHZewEoHITA
         +LhlDDwg+y1aDSzLBuTg85eTn+m5P9uuk9UOK8CeEE/mQyfUTa+wMqSnr4oIkDN10v+5
         fap62Ugx9nbtBxmB2Pgue0wDe/IEfhe5DZZmcMZBCvY1S2wINV73F/SnBgrHURf0zn2c
         jgWA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:message-id:mime-version:subject:from:to:cc;
        bh=y86ShJc0lHY7mGjuegghOpKGlFnX8a1lnfR2jsV9nVk=;
        b=jczQ99SKUuabRaOcxOtsJIyQ7YQGJj478sjxWWQ23EcKovZB3xf+hEwotQQeJUtxp2
         KRNCT/PWPPUeJ0vvIWs1C53p3HUF3h0xVJwhtZ2LxuzL4A1tIC3uRN4IBonxNQU2gB3k
         KxWKRUDZypCCTIEpJENQ/4cvGERuNU0WHGBHFS8bgCy5YWqMMymrKgATdxf+MPYH/0uo
         sakWYO9BmTYUY1pIZFw6GQVIZ+oOx/Vij2lKG8H3D39dgP2nSHrO/91JnjZ7p5BrU4RZ
         ySS+aznfbbsMjULPVnk9WLPV+T5OBEMKs6mKFvDEW8FkC+Rzs/stFiHiDjrAifMEi745
         /Ybw==
X-Gm-Message-State: APjAAAV2RdYRJDU8gOKxJT+uIxulxy/oeGfC4zGz1aa3cVBNf8Kmvr7C
        kc1rjlIwhhLH0tef6oWzaoTe80yCPGnl9s68WTl8FjxPMbx5aGUgAqVct5U4QI3mQEfwuAigo3L
        uS7tDrUD3bgC9hBQ+wd3YP9+yoQHYEWzbXD0Qe2Nkkw8Zzt2CPJLt65Rr6KwFx87qwK8=
X-Google-Smtp-Source: APXvYqz6U+XaPeeL8dkxvKXi77Nutnk8jwWBxruR7e+PCqXulr8Nf9Cdx07siNWi3DiQu1iyq4cd8lFm0psZMw==
X-Received: by 2002:a63:f246:: with SMTP id d6mr14556772pgk.368.1572628201039;
 Fri, 01 Nov 2019 10:10:01 -0700 (PDT)
Date:   Fri,  1 Nov 2019 10:09:56 -0700
Message-Id: <20191101170956.261330-1-yangchun@google.com>
Mime-Version: 1.0
X-Mailer: git-send-email 2.24.0.rc1.363.gb1bccd3e3d-goog
Subject: [PATCH net v3] gve: Fixes DMA synchronization.
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
Changes in v3:
	- Places local variables in reverse christmas tree ordering.

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
index 778b87b5a06c..0a9a7ee2a866 100644
--- a/drivers/net/ethernet/google/gve/gve_tx.c
+++ b/drivers/net/ethernet/google/gve/gve_tx.c
@@ -390,7 +390,21 @@ static void gve_tx_fill_seg_desc(union gve_tx_desc *seg_desc,
 	seg_desc->seg.seg_addr = cpu_to_be64(addr);
 }
 
-static int gve_tx_add_skb(struct gve_tx_ring *tx, struct sk_buff *skb)
+static void gve_dma_sync_for_device(struct device *dev, dma_addr_t *page_buses,
+				    u64 iov_offset, u64 iov_len)
+{
+	dma_addr_t dma;
+	u64 addr;
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
2.24.0.rc1.363.gb1bccd3e3d-goog

