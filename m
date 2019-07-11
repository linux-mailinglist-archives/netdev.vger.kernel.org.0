Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 399DB65166
	for <lists+netdev@lfdr.de>; Thu, 11 Jul 2019 07:25:20 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728006AbfGKFZO (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 11 Jul 2019 01:25:14 -0400
Received: from mail-pl1-f196.google.com ([209.85.214.196]:40004 "EHLO
        mail-pl1-f196.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1727968AbfGKFZN (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 11 Jul 2019 01:25:13 -0400
Received: by mail-pl1-f196.google.com with SMTP id a93so2393127pla.7
        for <netdev@vger.kernel.org>; Wed, 10 Jul 2019 22:25:13 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=endlessm-com.20150623.gappssmtp.com; s=20150623;
        h=from:to:cc:subject:date:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=YnDj7HeMgqllbVcG4VtSZ86mS/XHDBUJrdAevBr6spA=;
        b=B9qYrQ9m+H4aMMhUv91/t0G9wD/DK3Li0yqRGwJJ+UpboBpDdEb/OMjnIq8d1cDGQw
         eC9gbnCRyABGHd0Nyj4WgZQSB+NAQEjqJS1HmVt7DNcLC73PKAwqDydhdjc2waT8rUnR
         CzWyxbnrGZLHtsyGntaxLTY36rX9uuL2C3WhPIQ7xygdqmgyUXt5AxzIzQSAy1YDnKw+
         DCc/DFqLMS8lKtjuq/aWaXdlc+C3JugnUptgm9v4gfVdtrE1HqIiSiXyKpeyegW6MMGC
         0REKQEO0uD0w3qoIARZZE4eDmPWQba0yTOZIc6ZHCw0mwNFXCETTw/Trs2xd0VUuqx1u
         bxyg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=YnDj7HeMgqllbVcG4VtSZ86mS/XHDBUJrdAevBr6spA=;
        b=scXe17EjUNbUHQc9KIFhNwdsuzPn2WGKmXv4QPZQd1eUqPfNwqoz+nfaAaWUkqdCs0
         5WcbaMOsMJlIszLTzzIX4znqNnZyPeKj4ZCZ4JHj0R7NTx1D/8RhxgLPdHqZH6Y8Tcu9
         fTv3HYtP+hdcUNnOH62RuG1VfItUksZ1OS2by38+Dg8aAodSf13u/SYM2soIxdu47LQJ
         DG0mbhUU992pml4fR8TMq9JBxjBkxBDRWmlb/HqOASgy2jkf3RoJjDUB9w3Zsmd5pPQi
         wzeooOV8/mGDvgs/GBtHfGyD06t5f8ErEQpoifzFhJKi/3FD2VLe/XO/zhsPrj+k95cg
         Czyw==
X-Gm-Message-State: APjAAAVq3AMfWPHwo7e88O7jp5neVv93siKP85W6WsnbpLoOKEz6t2PW
        PhIeiAdJbzoS0ZBhXQA/yl7CYQ==
X-Google-Smtp-Source: APXvYqzKeDK8OkxK6szumbrprfqFg7I8okB/dx+QucnEs398OraeKe4q3ipZIzcp/fCFEx7KY8LVEQ==
X-Received: by 2002:a17:902:6847:: with SMTP id f7mr2397704pln.311.1562822712599;
        Wed, 10 Jul 2019 22:25:12 -0700 (PDT)
Received: from localhost.localdomain (123-204-46-122.static.seed.net.tw. [123.204.46.122])
        by smtp.gmail.com with ESMTPSA id 201sm5471345pfz.24.2019.07.10.22.25.09
        (version=TLS1_3 cipher=AEAD-AES256-GCM-SHA384 bits=256/256);
        Wed, 10 Jul 2019 22:25:12 -0700 (PDT)
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
Subject: [PATCH v4 2/2] rtw88: pci: Use DMA sync instead of remapping in RX ISR
Date:   Thu, 11 Jul 2019 13:24:27 +0800
Message-Id: <20190711052427.5582-2-jian-hong@endlessm.com>
X-Mailer: git-send-email 2.22.0
In-Reply-To: <20190711052427.5582-1-jian-hong@endlessm.com>
References: <CAPpJ_edDcaBq+0DocPmS-yYM10B4MkWvBn=f6wwbYdqzSGmp_g@mail.gmail.com>
 <20190711052427.5582-1-jian-hong@endlessm.com>
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
 drivers/net/wireless/realtek/rtw88/pci.c | 24 +++++++++++++++++++++---
 1 file changed, 21 insertions(+), 3 deletions(-)

diff --git a/drivers/net/wireless/realtek/rtw88/pci.c b/drivers/net/wireless/realtek/rtw88/pci.c
index c415f5e94fed..68fae52151dd 100644
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

