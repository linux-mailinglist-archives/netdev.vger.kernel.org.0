Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 26A506342C
	for <lists+netdev@lfdr.de>; Tue,  9 Jul 2019 12:22:34 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726580AbfGIKW1 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 9 Jul 2019 06:22:27 -0400
Received: from mail-pf1-f193.google.com ([209.85.210.193]:40274 "EHLO
        mail-pf1-f193.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726060AbfGIKW1 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 9 Jul 2019 06:22:27 -0400
Received: by mail-pf1-f193.google.com with SMTP id p184so9063568pfp.7
        for <netdev@vger.kernel.org>; Tue, 09 Jul 2019 03:22:26 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=endlessm-com.20150623.gappssmtp.com; s=20150623;
        h=from:to:cc:subject:date:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=Ys5VCG//C+7d/Mv4iPcZy1mrBP7z7sVwq8ShwHAlzGY=;
        b=EYqSBY5RYT3l0wkuw1OiniPSthEwR1m6QScRVqkNRuncNcPiHi18uDfiPzlQ64tyOT
         tFnG4+QleLyJ5BINvC4LqWUj6LzpVUIwfmTehOtXgG+QCpSO2kmuYWp4LBvDqw4TAycS
         rUPJnPjVy196wMzOuZn7AILaZrq5Otwr4AfORpaIWUOi8XFXWgYvtdPXoso5l+txhymh
         3kr4MOeTNuPTCctGwVMZnXh4EeeJGe2tiGybWZlLLrOrRpCTaKMwQpUdPkM8bettx8Wr
         fS9nzTh9CWZuuNv6NWzmVBkaHo/g7OgOJFLMdKB7JtjNZvusIkI0fUWh6GaLzdxhiZM+
         WRLA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=Ys5VCG//C+7d/Mv4iPcZy1mrBP7z7sVwq8ShwHAlzGY=;
        b=j6YSCwIuraEFA0gq8B56jiWAWYa/xA8AqX7e/591j4yqU6deVFFTCh/a3iFmZGRcYE
         0LoVkqSpwm+LFX832FA2UrRPIYrF1MXbuML3F2virNTHiWKoLdGQd72E6kPWbWGl3dCy
         kt95cqYqtTLUd5WfFwrIrEXV7/IQQ42WTIXYOtcFj3QPZMV5gvKPH5pM1cVqHu69BZbK
         46ztmGNU9bTJY+PIljZ8qzpULvaCMQTn87DcZ5R+FOG1xd0lc1GnrdUgAd0V9aCZnN9s
         NZrccqsq+9S3ttlqm++emTHIknbx7v5DeZvgaqT+AiqHmcpTzUgcvgfNc3eghvycUX0i
         nLPg==
X-Gm-Message-State: APjAAAWWodL5eztfjMEU3PqJPIG/NLVR4Z+AefRAVobtkurAhpfmzHLg
        OooXDE3Rq5Jo2sbjUpsBUioePw==
X-Google-Smtp-Source: APXvYqy4rOzsSukM8QjFevK1EGTmIXDq4LXaDasAKMlIyOuWJyyfPkpJ2F67P17lv+jigztmLW01bw==
X-Received: by 2002:a65:56c1:: with SMTP id w1mr25026367pgs.395.1562667746195;
        Tue, 09 Jul 2019 03:22:26 -0700 (PDT)
Received: from localhost.localdomain (123-204-46-122.static.seed.net.tw. [123.204.46.122])
        by smtp.gmail.com with ESMTPSA id j1sm40161849pgl.12.2019.07.09.03.22.23
        (version=TLS1_3 cipher=AEAD-AES256-GCM-SHA384 bits=256/256);
        Tue, 09 Jul 2019 03:22:25 -0700 (PDT)
From:   Jian-Hong Pan <jian-hong@endlessm.com>
To:     Yan-Hsuan Chuang <yhchuang@realtek.com>,
        Kalle Valo <kvalo@codeaurora.org>,
        "David S . Miller" <davem@davemloft.net>,
        Larry Finger <Larry.Finger@lwfinger.net>,
        David Laight <David.Laight@aculab.com>
Cc:     linux-wireless@vger.kernel.org, netdev@vger.kernel.org,
        linux-kernel@vger.kernel.org, linux@endlessm.com,
        Daniel Drake <drake@endlessm.com>,
        Jian-Hong Pan <jian-hong@endlessm.com>
Subject: [PATCH v2 2/2] rtw88: pci: Use DMA sync instead of remapping in RX ISR
Date:   Tue,  9 Jul 2019 18:21:01 +0800
Message-Id: <20190709102059.7036-2-jian-hong@endlessm.com>
X-Mailer: git-send-email 2.22.0
In-Reply-To: <20190708063252.4756-1-jian-hong@endlessm.com>
References: <20190708063252.4756-1-jian-hong@endlessm.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Since each skb in RX ring is reused instead of new allocation, we can
treat the DMA in a more efficient way by DMA synchronization.

Signed-off-by: Jian-Hong Pan <jian-hong@endlessm.com>
---
 drivers/net/wireless/realtek/rtw88/pci.c | 35 ++++++++++++++++++++++--
 1 file changed, 32 insertions(+), 3 deletions(-)

diff --git a/drivers/net/wireless/realtek/rtw88/pci.c b/drivers/net/wireless/realtek/rtw88/pci.c
index e9fe3ad896c8..28ca76f71dfe 100644
--- a/drivers/net/wireless/realtek/rtw88/pci.c
+++ b/drivers/net/wireless/realtek/rtw88/pci.c
@@ -206,6 +206,35 @@ static int rtw_pci_reset_rx_desc(struct rtw_dev *rtwdev, struct sk_buff *skb,
 	return 0;
 }
 
+static int rtw_pci_sync_rx_desc_cpu(struct rtw_dev *rtwdev, dma_addr_t dma)
+{
+	struct device *dev = rtwdev->dev;
+	int buf_sz = RTK_PCI_RX_BUF_SIZE;
+
+	dma_sync_single_for_cpu(dev, dma, buf_sz, PCI_DMA_FROMDEVICE);
+
+	return 0;
+}
+
+static int rtw_pci_sync_rx_desc_device(struct rtw_dev *rtwdev, dma_addr_t dma,
+				       struct rtw_pci_rx_ring *rx_ring,
+				       u32 idx, u32 desc_sz)
+{
+	struct device *dev = rtwdev->dev;
+	struct rtw_pci_rx_buffer_desc *buf_desc;
+	int buf_sz = RTK_PCI_RX_BUF_SIZE;
+
+	dma_sync_single_for_device(dev, dma, buf_sz, PCI_DMA_FROMDEVICE);
+
+	buf_desc = (struct rtw_pci_rx_buffer_desc *)(rx_ring->r.head +
+						     idx * desc_sz);
+	memset(buf_desc, 0, sizeof(*buf_desc));
+	buf_desc->buf_size = cpu_to_le16(RTK_PCI_RX_BUF_SIZE);
+	buf_desc->dma = cpu_to_le32(dma);
+
+	return 0;
+}
+
 static int rtw_pci_init_rx_ring(struct rtw_dev *rtwdev,
 				struct rtw_pci_rx_ring *rx_ring,
 				u8 desc_size, u32 len)
@@ -782,8 +811,7 @@ static void rtw_pci_rx_isr(struct rtw_dev *rtwdev, struct rtw_pci *rtwpci,
 		rtw_pci_dma_check(rtwdev, ring, cur_rp);
 		skb = ring->buf[cur_rp];
 		dma = *((dma_addr_t *)skb->cb);
-		pci_unmap_single(rtwpci->pdev, dma, RTK_PCI_RX_BUF_SIZE,
-				 PCI_DMA_FROMDEVICE);
+		rtw_pci_sync_rx_desc_cpu(rtwdev, dma);
 		rx_desc = skb->data;
 		chip->ops->query_rx_desc(rtwdev, rx_desc, &pkt_stat, &rx_status);
 
@@ -818,7 +846,8 @@ static void rtw_pci_rx_isr(struct rtw_dev *rtwdev, struct rtw_pci *rtwpci,
 
 next_rp:
 		/* new skb delivered to mac80211, re-enable original skb DMA */
-		rtw_pci_reset_rx_desc(rtwdev, skb, ring, cur_rp, buf_desc_sz);
+		rtw_pci_sync_rx_desc_device(rtwdev, dma, ring, cur_rp,
+					    buf_desc_sz);
 
 		/* host read next element in ring */
 		if (++cur_rp >= ring->r.len)
-- 
2.22.0

