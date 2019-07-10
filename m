Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 46F13643BE
	for <lists+netdev@lfdr.de>; Wed, 10 Jul 2019 10:44:21 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727592AbfGJIoP (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 10 Jul 2019 04:44:15 -0400
Received: from mail-pf1-f194.google.com ([209.85.210.194]:41838 "EHLO
        mail-pf1-f194.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726097AbfGJIoP (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 10 Jul 2019 04:44:15 -0400
Received: by mail-pf1-f194.google.com with SMTP id m30so762292pff.8
        for <netdev@vger.kernel.org>; Wed, 10 Jul 2019 01:44:15 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=endlessm-com.20150623.gappssmtp.com; s=20150623;
        h=from:to:cc:subject:date:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=ZxB6K90WEOCOsXFUiDbe1sddkLrl4+FMawAXBSkTyfs=;
        b=Yv02FiX2qw7jZOKTrsoiIMkDDSP78zsxI2V+pkdLGpN8sQ2V9lYpCBTujbjLOd4+XX
         cDHNZGrU/OY6+FRbsNHKPd9Pi/5iY4BUy8RRb4v/YuXTqTo96k3IM3BvQBPijRhv5ykC
         3M8lrau2R5HxxkFPUp0vn7kIiIuFkU0VmWVtqF8NQ8810MvhOKhoHVeynE63w6hpwNtX
         zqpv0eFQplEjHM793bOPiK6GZZjpPSpLCWoz9X38kBQ8V6Pt15H4jijSHphDEN+Qtimw
         aurOy9tnyBXRUbgisvNaPCNVSUb0EOgeJPbdyErfH7PHrnO69wdgHiS3AqX/zHyZLQcm
         S23w==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=ZxB6K90WEOCOsXFUiDbe1sddkLrl4+FMawAXBSkTyfs=;
        b=A1PBy+hiyyJScw8HPIx9jJU1XqDNLYGy98PxLlL7tC4DeobH7Br6+0zyOF6RByPqVV
         avPZVcqfuipzB/LkbkYLrZPxF/xUy2f/8eXXgi8Q5SlkNkz0q/gZsvShsqpqzskhVxs3
         P4C5M7Qr+m06ldb8XX0S7hub7BLbXZ54vuc016oB7yafoCqmx6Jo/QteTDyP1pxbnfzI
         qhfV4twEEqTG21WAGtRD2kOtNtnlV/0NcACKhUDm8pBCdE0Ro/Qp2BUhORwQV2aYC8h9
         aQv2MEgwb4UEyEQaFIm4mLTXwV8QbkSXaIVS3t6socOJjDEGLwxVDSkmkqbv27xBseLv
         u6yg==
X-Gm-Message-State: APjAAAWBb+JOepSgnKC5V5DFWWIWEBu59iFu/sa8/wPAmsuKhLVSILdQ
        yuKKr8fUD2J2YQRwRD+0ew8ecA==
X-Google-Smtp-Source: APXvYqx6r3nK/XJfM+4IfR4WIlijQtiFKtASr2UXeXiYiziTXmlsNyQAr1EFL/V112AK8JqshhpfCw==
X-Received: by 2002:a63:7d05:: with SMTP id y5mr32971869pgc.425.1562748254525;
        Wed, 10 Jul 2019 01:44:14 -0700 (PDT)
Received: from localhost.localdomain (123-204-46-122.static.seed.net.tw. [123.204.46.122])
        by smtp.gmail.com with ESMTPSA id v5sm1378133pgq.66.2019.07.10.01.44.10
        (version=TLS1_3 cipher=AEAD-AES256-GCM-SHA384 bits=256/256);
        Wed, 10 Jul 2019 01:44:14 -0700 (PDT)
From:   Jian-Hong Pan <jian-hong@endlessm.com>
To:     Yan-Hsuan Chuang <yhchuang@realtek.com>,
        Kalle Valo <kvalo@codeaurora.org>,
        "David S . Miller" <davem@davemloft.net>,
        Larry Finger <Larry.Finger@lwfinger.net>,
        David Laight <David.Laight@aculab.com>,
        Christoph Hellwig <hch@infradead.org>
Cc:     linux-wireless@vger.kernel.org, netdev@vger.kernel.org,
        linux-kernel@vger.kernel.org, linux@endlessm.com,
        Daniel Drake <drake@endlessm.com>,
        Jian-Hong Pan <jian-hong@endlessm.com>, stable@vger.kernel.org
Subject: [PATCH v3 2/2] rtw88: pci: Use DMA sync instead of remapping in RX ISR
Date:   Wed, 10 Jul 2019 16:38:27 +0800
Message-Id: <20190710083825.7115-2-jian-hong@endlessm.com>
X-Mailer: git-send-email 2.22.0
In-Reply-To: <20190709161550.GA8703@infradead.org>
References: <20190709161550.GA8703@infradead.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Since each skb in RX ring is reused instead of new allocation, we can
treat the DMA in a more efficient way by DMA synchronization.

Signed-off-by: Jian-Hong Pan <jian-hong@endlessm.com>
Cc: <stable@vger.kernel.org>
---
v2:
 - New patch by following [PATCH v3 1/2] rtw88: pci: Rearrange the
   memory usage for skb in RX ISR.

v3:
 - Remove rtw_pci_sync_rx_desc_cpu and call dma_sync_single_for_cpu in
   rtw_pci_rx_isr directly.
 - Remove the return value of rtw_pci_sync_rx_desc_device.
 - Use DMA_FROM_DEVICE instead of PCI_DMA_FROMDEVICE.

 drivers/net/wireless/realtek/rtw88/pci.c | 24 +++++++++++++++++++++---
 1 file changed, 21 insertions(+), 3 deletions(-)

diff --git a/drivers/net/wireless/realtek/rtw88/pci.c b/drivers/net/wireless/realtek/rtw88/pci.c
index e9fe3ad896c8..485d30c06935 100644
--- a/drivers/net/wireless/realtek/rtw88/pci.c
+++ b/drivers/net/wireless/realtek/rtw88/pci.c
@@ -206,6 +206,23 @@ static int rtw_pci_reset_rx_desc(struct rtw_dev *rtwdev, struct sk_buff *skb,
 	return 0;
 }
 
+static void rtw_pci_sync_rx_desc_device(struct rtw_dev *rtwdev, dma_addr_t dma,
+					struct rtw_pci_rx_ring *rx_ring,
+					u32 idx, u32 desc_sz)
+{
+	struct device *dev = rtwdev->dev;
+	struct rtw_pci_rx_buffer_desc *buf_desc;
+	int buf_sz = RTK_PCI_RX_BUF_SIZE;
+
+	dma_sync_single_for_device(dev, dma, buf_sz, DMA_FROM_DEVICE);
+
+	buf_desc = (struct rtw_pci_rx_buffer_desc *)(rx_ring->r.head +
+						     idx * desc_sz);
+	memset(buf_desc, 0, sizeof(*buf_desc));
+	buf_desc->buf_size = cpu_to_le16(RTK_PCI_RX_BUF_SIZE);
+	buf_desc->dma = cpu_to_le32(dma);
+}
+
 static int rtw_pci_init_rx_ring(struct rtw_dev *rtwdev,
 				struct rtw_pci_rx_ring *rx_ring,
 				u8 desc_size, u32 len)
@@ -782,8 +799,8 @@ static void rtw_pci_rx_isr(struct rtw_dev *rtwdev, struct rtw_pci *rtwpci,
 		rtw_pci_dma_check(rtwdev, ring, cur_rp);
 		skb = ring->buf[cur_rp];
 		dma = *((dma_addr_t *)skb->cb);
-		pci_unmap_single(rtwpci->pdev, dma, RTK_PCI_RX_BUF_SIZE,
-				 PCI_DMA_FROMDEVICE);
+		dma_sync_single_for_cpu(rtwdev->dev, dma, RTK_PCI_RX_BUF_SIZE,
+					DMA_FROM_DEVICE);
 		rx_desc = skb->data;
 		chip->ops->query_rx_desc(rtwdev, rx_desc, &pkt_stat, &rx_status);
 
@@ -818,7 +835,8 @@ static void rtw_pci_rx_isr(struct rtw_dev *rtwdev, struct rtw_pci *rtwpci,
 
 next_rp:
 		/* new skb delivered to mac80211, re-enable original skb DMA */
-		rtw_pci_reset_rx_desc(rtwdev, skb, ring, cur_rp, buf_desc_sz);
+		rtw_pci_sync_rx_desc_device(rtwdev, dma, ring, cur_rp,
+					    buf_desc_sz);
 
 		/* host read next element in ring */
 		if (++cur_rp >= ring->r.len)
-- 
2.22.0

