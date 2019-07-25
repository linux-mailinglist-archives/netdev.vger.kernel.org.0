Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 0C42F748D5
	for <lists+netdev@lfdr.de>; Thu, 25 Jul 2019 10:13:05 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2389134AbfGYIM4 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 25 Jul 2019 04:12:56 -0400
Received: from mail-pl1-f196.google.com ([209.85.214.196]:42096 "EHLO
        mail-pl1-f196.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S2389035AbfGYIM4 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 25 Jul 2019 04:12:56 -0400
Received: by mail-pl1-f196.google.com with SMTP id ay6so23134598plb.9
        for <netdev@vger.kernel.org>; Thu, 25 Jul 2019 01:12:55 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=endlessm-com.20150623.gappssmtp.com; s=20150623;
        h=from:to:cc:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=x4qD4ZEq8uB2B4m8nty7P7lvoqwTNJJnTm/9KwAGSJI=;
        b=hyFP81sv0viroEdy8kHV4s0OW1ZmcoTMqkLaeEWrdTHAfXIYp9YOTU3Gja+uGxe1xT
         8mbRo9cJFQs041EwlTqZKEvSXDfXOFul5b1m1mmWVmjURynYdiWY9TgvAyxe4sqP1bjw
         TfZ/ml/TZpZ3aok88NqO27D7DfHqL9krkjsAnM5KiZ+ZMw1IGocQVttwEQvXlfOijCAG
         SOFNPZvZSBXTkLf9pIPON+wEIyQz+5SZVhI8Xko9Y4MOyHRAaCHcd/ewpFKQp/8vHwPD
         IsqbSA5iw0Ks3DdK/xaFtMCy/A6kIDdZBvDlPib7OI902zKi+8nMJreXzay8umro7AZW
         pxXw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=x4qD4ZEq8uB2B4m8nty7P7lvoqwTNJJnTm/9KwAGSJI=;
        b=gOUZG3GuJPbrb5MTNrOfIE78Oe9tqEpC8vJsZKiALnvaXI/KxcSJ5PTrIt+3q27cK4
         H2reUKGjxE8D7639M20sQR/YjAVSAXNGPWjBHO+MtfkHY1FGu3ddGIiC+qWRy63323cA
         /k9MpwYvrJJ9FD4S7iEc89FOfuXAXlh9LHH/0TZuQ+19OyV510tZAnQhX6q6grXBGLLB
         O/tFUQAMgPp3vrf53+RPdqqQjNYYLmap0uYfDi7E01sH4NyLQEMZLKJB8UnSLKdHFuIX
         3MpWW+fFCbBoH9rCnN7rK/e0yEAdr1oz9Ff96dbITYIq+IXocip8FmNH/RU+2Unqimp/
         osDg==
X-Gm-Message-State: APjAAAWj7MM27QCviEkouz7oMcuUlPcUX3FCU2GHSxkxxTtsHueYflE5
        AnNQ8peIoAsBNyTtKmwjySm5nQ==
X-Google-Smtp-Source: APXvYqzKKvtappYDVLaQo4m4BL7cxE+13GCx7l7JLmacRP1SnNcL0IQrVtJECFSUP0ui4VaGDKSFAg==
X-Received: by 2002:a17:902:112c:: with SMTP id d41mr79563267pla.33.1564042375070;
        Thu, 25 Jul 2019 01:12:55 -0700 (PDT)
Received: from localhost.localdomain (123-204-46-122.static.seed.net.tw. [123.204.46.122])
        by smtp.gmail.com with ESMTPSA id 81sm77584306pfx.111.2019.07.25.01.12.51
        (version=TLS1_3 cipher=AEAD-AES256-GCM-SHA384 bits=256/256);
        Thu, 25 Jul 2019 01:12:54 -0700 (PDT)
From:   Jian-Hong Pan <jian-hong@endlessm.com>
To:     Yan-Hsuan Chuang <yhchuang@realtek.com>,
        Kalle Valo <kvalo@codeaurora.org>,
        "David S . Miller" <davem@davemloft.net>,
        David Laight <David.Laight@aculab.com>
Cc:     linux-wireless@vger.kernel.org, netdev@vger.kernel.org,
        linux-kernel@vger.kernel.org, linux@endlessm.com,
        Jian-Hong Pan <jian-hong@endlessm.com>, stable@vger.kernel.org
Subject: [PATCH] rtw88: pci: Use general byte arrays as the elements of RX ring
Date:   Thu, 25 Jul 2019 16:09:26 +0800
Message-Id: <20190725080925.6575-1-jian-hong@endlessm.com>
X-Mailer: git-send-email 2.22.0
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Each skb as the element in RX ring was expected with sized buffer 8216
(RTK_PCI_RX_BUF_SIZE) bytes. However, the skb buffer's true size is
16640 bytes for alignment after allocated, x86_64 for example. And, the
difference will be enlarged 512 times (RTK_MAX_RX_DESC_NUM).
To prevent that much wasted memory, this patch follows David's
suggestion [1] and uses general buffer arrays, instead of skbs as the
elements in RX ring.

[1] https://www.spinics.net/lists/linux-wireless/msg187870.html

Signed-off-by: Jian-Hong Pan <jian-hong@endlessm.com>
Cc: <stable@vger.kernel.org>
---
 drivers/net/wireless/realtek/rtw88/pci.c | 132 +++++++++++++----------
 drivers/net/wireless/realtek/rtw88/pci.h |   2 +-
 2 files changed, 75 insertions(+), 59 deletions(-)

diff --git a/drivers/net/wireless/realtek/rtw88/pci.c b/drivers/net/wireless/realtek/rtw88/pci.c
index 23dd06afef3d..e953010f0179 100644
--- a/drivers/net/wireless/realtek/rtw88/pci.c
+++ b/drivers/net/wireless/realtek/rtw88/pci.c
@@ -111,25 +111,49 @@ static void rtw_pci_free_tx_ring(struct rtw_dev *rtwdev,
 	tx_ring->r.head = NULL;
 }
 
+static struct rtw_pci_rx_buffer_desc *rtw_pci_get_rx_desc(
+					struct rtw_pci_rx_ring *rx_ring,
+					u32 idx)
+{
+	struct rtw_pci_rx_buffer_desc *buf_desc;
+	u32 desc_sz = rx_ring->r.desc_size;
+
+	buf_desc = (struct rtw_pci_rx_buffer_desc *)(rx_ring->r.head +
+						     idx * desc_sz);
+	return buf_desc;
+}
+
+static dma_addr_t rtw_pci_get_rx_bufdma(struct rtw_pci_rx_ring *rx_ring,
+					u32 idx)
+{
+	struct rtw_pci_rx_buffer_desc *buf_desc;
+	dma_addr_t dma;
+
+	buf_desc = rtw_pci_get_rx_desc(rx_ring, idx);
+	dma = le32_to_cpu(buf_desc->dma);
+
+	return dma;
+}
+
 static void rtw_pci_free_rx_ring(struct rtw_dev *rtwdev,
 				 struct rtw_pci_rx_ring *rx_ring)
 {
 	struct pci_dev *pdev = to_pci_dev(rtwdev->dev);
-	struct sk_buff *skb;
+	u8 *buf;
 	dma_addr_t dma;
 	u8 *head = rx_ring->r.head;
 	int buf_sz = RTK_PCI_RX_BUF_SIZE;
 	int ring_sz = rx_ring->r.desc_size * rx_ring->r.len;
-	int i;
+	u32 i;
 
 	for (i = 0; i < rx_ring->r.len; i++) {
-		skb = rx_ring->buf[i];
-		if (!skb)
+		buf = rx_ring->buf[i];
+		if (!buf)
 			continue;
 
-		dma = *((dma_addr_t *)skb->cb);
-		pci_unmap_single(pdev, dma, buf_sz, PCI_DMA_FROMDEVICE);
-		dev_kfree_skb(skb);
+		dma = rtw_pci_get_rx_bufdma(rx_ring, i);
+		pci_unmap_single(pdev, dma, buf_sz, DMA_FROM_DEVICE);
+		devm_kfree(rtwdev->dev, buf);
 		rx_ring->buf[i] = NULL;
 	}
 
@@ -180,27 +204,24 @@ static int rtw_pci_init_tx_ring(struct rtw_dev *rtwdev,
 	return 0;
 }
 
-static int rtw_pci_reset_rx_desc(struct rtw_dev *rtwdev, struct sk_buff *skb,
-				 struct rtw_pci_rx_ring *rx_ring,
-				 u32 idx, u32 desc_sz)
+static int rtw_pci_reset_rx_desc(struct rtw_dev *rtwdev, u8 *buf,
+				 struct rtw_pci_rx_ring *rx_ring, u32 idx)
 {
 	struct pci_dev *pdev = to_pci_dev(rtwdev->dev);
 	struct rtw_pci_rx_buffer_desc *buf_desc;
 	int buf_sz = RTK_PCI_RX_BUF_SIZE;
 	dma_addr_t dma;
 
-	if (!skb)
+	if (!buf)
 		return -EINVAL;
 
-	dma = pci_map_single(pdev, skb->data, buf_sz, PCI_DMA_FROMDEVICE);
+	dma = pci_map_single(pdev, buf, buf_sz, DMA_FROM_DEVICE);
 	if (pci_dma_mapping_error(pdev, dma))
 		return -EBUSY;
 
-	*((dma_addr_t *)skb->cb) = dma;
-	buf_desc = (struct rtw_pci_rx_buffer_desc *)(rx_ring->r.head +
-						     idx * desc_sz);
-	memset(buf_desc, 0, sizeof(*buf_desc));
+	buf_desc = rtw_pci_get_rx_desc(rx_ring, idx);
 	buf_desc->buf_size = cpu_to_le16(RTK_PCI_RX_BUF_SIZE);
+	buf_desc->total_pkt_size = cpu_to_le16(0);
 	buf_desc->dma = cpu_to_le32(dma);
 
 	return 0;
@@ -208,7 +229,7 @@ static int rtw_pci_reset_rx_desc(struct rtw_dev *rtwdev, struct sk_buff *skb,
 
 static void rtw_pci_sync_rx_desc_device(struct rtw_dev *rtwdev, dma_addr_t dma,
 					struct rtw_pci_rx_ring *rx_ring,
-					u32 idx, u32 desc_sz)
+					u32 idx)
 {
 	struct device *dev = rtwdev->dev;
 	struct rtw_pci_rx_buffer_desc *buf_desc;
@@ -216,10 +237,9 @@ static void rtw_pci_sync_rx_desc_device(struct rtw_dev *rtwdev, dma_addr_t dma,
 
 	dma_sync_single_for_device(dev, dma, buf_sz, DMA_FROM_DEVICE);
 
-	buf_desc = (struct rtw_pci_rx_buffer_desc *)(rx_ring->r.head +
-						     idx * desc_sz);
-	memset(buf_desc, 0, sizeof(*buf_desc));
+	buf_desc = rtw_pci_get_rx_desc(rx_ring, idx);
 	buf_desc->buf_size = cpu_to_le16(RTK_PCI_RX_BUF_SIZE);
+	buf_desc->total_pkt_size = cpu_to_le16(0);
 	buf_desc->dma = cpu_to_le32(dma);
 }
 
@@ -228,12 +248,12 @@ static int rtw_pci_init_rx_ring(struct rtw_dev *rtwdev,
 				u8 desc_size, u32 len)
 {
 	struct pci_dev *pdev = to_pci_dev(rtwdev->dev);
-	struct sk_buff *skb = NULL;
+	u8 *buf = NULL;
 	dma_addr_t dma;
 	u8 *head;
 	int ring_sz = desc_size * len;
 	int buf_sz = RTK_PCI_RX_BUF_SIZE;
-	int i, allocated;
+	u32 i, allocated;
 	int ret = 0;
 
 	head = pci_zalloc_consistent(pdev, ring_sz, &dma);
@@ -242,41 +262,39 @@ static int rtw_pci_init_rx_ring(struct rtw_dev *rtwdev,
 		return -ENOMEM;
 	}
 	rx_ring->r.head = head;
+	rx_ring->r.dma = dma;
+	rx_ring->r.len = len;
+	rx_ring->r.desc_size = desc_size;
+	rx_ring->r.wp = 0;
+	rx_ring->r.rp = 0;
 
 	for (i = 0; i < len; i++) {
-		skb = dev_alloc_skb(buf_sz);
-		if (!skb) {
+		buf = devm_kzalloc(rtwdev->dev, buf_sz, GFP_ATOMIC);
+		if (!buf) {
 			allocated = i;
 			ret = -ENOMEM;
 			goto err_out;
 		}
 
-		memset(skb->data, 0, buf_sz);
-		rx_ring->buf[i] = skb;
-		ret = rtw_pci_reset_rx_desc(rtwdev, skb, rx_ring, i, desc_size);
+		rx_ring->buf[i] = buf;
+		ret = rtw_pci_reset_rx_desc(rtwdev, buf, rx_ring, i);
 		if (ret) {
 			allocated = i;
-			dev_kfree_skb_any(skb);
+			devm_kfree(rtwdev->dev, buf);
 			goto err_out;
 		}
 	}
 
-	rx_ring->r.dma = dma;
-	rx_ring->r.len = len;
-	rx_ring->r.desc_size = desc_size;
-	rx_ring->r.wp = 0;
-	rx_ring->r.rp = 0;
-
 	return 0;
 
 err_out:
 	for (i = 0; i < allocated; i++) {
-		skb = rx_ring->buf[i];
-		if (!skb)
+		buf = rx_ring->buf[i];
+		if (!buf)
 			continue;
-		dma = *((dma_addr_t *)skb->cb);
-		pci_unmap_single(pdev, dma, buf_sz, PCI_DMA_FROMDEVICE);
-		dev_kfree_skb_any(skb);
+		dma = rtw_pci_get_rx_bufdma(rx_ring, i);
+		pci_unmap_single(pdev, dma, buf_sz, DMA_FROM_DEVICE);
+		devm_kfree(rtwdev->dev, buf);
 		rx_ring->buf[i] = NULL;
 	}
 	pci_free_consistent(pdev, ring_sz, head, dma);
@@ -776,13 +794,12 @@ static void rtw_pci_rx_isr(struct rtw_dev *rtwdev, struct rtw_pci *rtwpci,
 	struct rtw_pci_rx_ring *ring;
 	struct rtw_rx_pkt_stat pkt_stat;
 	struct ieee80211_rx_status rx_status;
-	struct sk_buff *skb, *new;
+	struct sk_buff *skb;
 	u32 cur_wp, cur_rp, tmp;
 	u32 count;
 	u32 pkt_offset;
 	u32 pkt_desc_sz = chip->rx_pkt_desc_sz;
-	u32 buf_desc_sz = chip->rx_buf_desc_sz;
-	u32 new_len;
+	u32 len;
 	u8 *rx_desc;
 	dma_addr_t dma;
 
@@ -799,11 +816,11 @@ static void rtw_pci_rx_isr(struct rtw_dev *rtwdev, struct rtw_pci *rtwpci,
 	cur_rp = ring->r.rp;
 	while (count--) {
 		rtw_pci_dma_check(rtwdev, ring, cur_rp);
-		skb = ring->buf[cur_rp];
-		dma = *((dma_addr_t *)skb->cb);
+		/* buffer is already filled as rx_desc */
+		rx_desc = ring->buf[cur_rp];
+		dma = rtw_pci_get_rx_bufdma(ring, cur_rp);
 		dma_sync_single_for_cpu(rtwdev->dev, dma, RTK_PCI_RX_BUF_SIZE,
 					DMA_FROM_DEVICE);
-		rx_desc = skb->data;
 		chip->ops->query_rx_desc(rtwdev, rx_desc, &pkt_stat, &rx_status);
 
 		/* offset from rx_desc to payload */
@@ -813,32 +830,31 @@ static void rtw_pci_rx_isr(struct rtw_dev *rtwdev, struct rtw_pci *rtwpci,
 		/* allocate a new skb for this frame,
 		 * discard the frame if none available
 		 */
-		new_len = pkt_stat.pkt_len + pkt_offset;
-		new = dev_alloc_skb(new_len);
-		if (WARN_ONCE(!new, "rx routine starvation\n"))
+		len = pkt_stat.pkt_len + pkt_offset;
+		skb = dev_alloc_skb(len);
+		if (WARN_ONCE(!skb, "rx routine starvation\n"))
 			goto next_rp;
 
 		/* put the DMA data including rx_desc from phy to new skb */
-		skb_put_data(new, skb->data, new_len);
+		skb_put_data(skb, rx_desc, len);
 
 		if (pkt_stat.is_c2h) {
 			 /* pass rx_desc & offset for further operation */
-			*((u32 *)new->cb) = pkt_offset;
-			skb_queue_tail(&rtwdev->c2h_queue, new);
+			*((u32 *)skb->cb) = pkt_offset;
+			skb_queue_tail(&rtwdev->c2h_queue, skb);
 			ieee80211_queue_work(rtwdev->hw, &rtwdev->c2h_work);
 		} else {
 			/* remove rx_desc */
-			skb_pull(new, pkt_offset);
+			skb_pull(skb, pkt_offset);
 
-			rtw_rx_stats(rtwdev, pkt_stat.vif, new);
-			memcpy(new->cb, &rx_status, sizeof(rx_status));
-			ieee80211_rx_irqsafe(rtwdev->hw, new);
+			rtw_rx_stats(rtwdev, pkt_stat.vif, skb);
+			memcpy(skb->cb, &rx_status, sizeof(rx_status));
+			ieee80211_rx_irqsafe(rtwdev->hw, skb);
 		}
 
 next_rp:
-		/* new skb delivered to mac80211, re-enable original skb DMA */
-		rtw_pci_sync_rx_desc_device(rtwdev, dma, ring, cur_rp,
-					    buf_desc_sz);
+		/* new skb delivered to mac80211, re-enable original buf DMA */
+		rtw_pci_sync_rx_desc_device(rtwdev, dma, ring, cur_rp);
 
 		/* host read next element in ring */
 		if (++cur_rp >= ring->r.len)
diff --git a/drivers/net/wireless/realtek/rtw88/pci.h b/drivers/net/wireless/realtek/rtw88/pci.h
index 87824a4caba9..283685421a64 100644
--- a/drivers/net/wireless/realtek/rtw88/pci.h
+++ b/drivers/net/wireless/realtek/rtw88/pci.h
@@ -174,7 +174,7 @@ struct rtw_pci_rx_buffer_desc {
 
 struct rtw_pci_rx_ring {
 	struct rtw_pci_ring r;
-	struct sk_buff *buf[RTK_MAX_RX_DESC_NUM];
+	u8 *buf[RTK_MAX_RX_DESC_NUM];
 };
 
 #define RX_TAG_MAX	8192
-- 
2.22.0

