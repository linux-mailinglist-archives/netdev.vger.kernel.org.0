Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id E6A46853AB
	for <lists+netdev@lfdr.de>; Wed,  7 Aug 2019 21:39:14 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2389459AbfHGTid (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 7 Aug 2019 15:38:33 -0400
Received: from mail-wr1-f66.google.com ([209.85.221.66]:33081 "EHLO
        mail-wr1-f66.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S2388881AbfHGTid (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 7 Aug 2019 15:38:33 -0400
Received: by mail-wr1-f66.google.com with SMTP id n9so92638555wru.0
        for <netdev@vger.kernel.org>; Wed, 07 Aug 2019 12:38:30 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=to:cc:from:subject:message-id:date:user-agent:mime-version
         :content-language:content-transfer-encoding;
        bh=tqtWrSVDEE5B7W85DhS+Hnzk2Fp/WTxwCd/mW1lVA/8=;
        b=dnDW5VfnWmA0McYzhVEFvVpks92hc5LsAzMuJhWpLyw8c3WoG5BKO2+wL+jJGVMvvF
         2sMfwd+D64MoC6A8Jnz559b625XBrjEVYet0m10Dgd8eVJSC4h5gKNfS/EJSTZdZCo13
         ItFYVIfSoiE8SVIP1wXgXGJpnEOuVSqvwH/j08UPTnE9fHYz4uBG+mEu5MNXQl0Vh+bj
         X18VM5KpsXSQ3pqhEN1ty0eoo1FEKoRBVpa1hrOvth0E4mLRWN7w1Vh/6tZUKSDuetTs
         sgYjlLgnjPvtZBQsa0ana6mjPZVVRvOYSu9TxvS/4M0Cap9lqrrDold2DZs4+4UhluyW
         3Nxg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:to:cc:from:subject:message-id:date:user-agent
         :mime-version:content-language:content-transfer-encoding;
        bh=tqtWrSVDEE5B7W85DhS+Hnzk2Fp/WTxwCd/mW1lVA/8=;
        b=oE1HzUZbXy5iOcOqFa+8zeHVEK5AUSaO0hyRVRUHWSm4Szxk0zLOuCwBJxUvKsutKi
         zXoJm6VLtpG+oBRl1vsbg6xci3cbwDNRNN9WAG8/Uh2+KBrCRWTmBG7PAjiqRlzptJVa
         My2OkjRFO39v9jqR+cMVNZTC9h3Qu8r0k4K32TEuo3wCCkVLgG2P+J2wf211r34ScYxJ
         HcbvsHAaVpExyXR5S3U9axrgVQW2ZUojO0GMMdXm2ov91FPaY81sckgY2C7ccnSw7e0F
         D0CwciqhanG2k+E+uaw90hyfWRH/LDjsSy0wnE4N4OJ5NefxUS1qoQtYxFQn/KpjBEv0
         0Wdg==
X-Gm-Message-State: APjAAAXNn0EvJie3UyYzLuxXXwBEKQeZrsP9FJGgHigdGWVVsP6hwQQb
        vmjdTpPkKkTowSX/exVAaZ26fMnW
X-Google-Smtp-Source: APXvYqxrYpiZP0nYWfsdgxNQ+KLcuqxpwFjn0d85a9u6CtkpvqndcPhgG5E6PffI4Jv7OQlO09B8GQ==
X-Received: by 2002:a5d:6749:: with SMTP id l9mr7685459wrw.73.1565206709729;
        Wed, 07 Aug 2019 12:38:29 -0700 (PDT)
Received: from ?IPv6:2003:ea:8f2f:3200:c422:a07f:e697:f900? (p200300EA8F2F3200C422A07FE697F900.dip0.t-ipconnect.de. [2003:ea:8f2f:3200:c422:a07f:e697:f900])
        by smtp.googlemail.com with ESMTPSA id w25sm29050wmk.18.2019.08.07.12.38.28
        (version=TLS1_2 cipher=ECDHE-RSA-AES128-GCM-SHA256 bits=128/128);
        Wed, 07 Aug 2019 12:38:29 -0700 (PDT)
To:     Realtek linux nic maintainers <nic_swsd@realtek.com>,
        David Miller <davem@davemloft.net>
Cc:     "netdev@vger.kernel.org" <netdev@vger.kernel.org>
From:   Heiner Kallweit <hkallweit1@gmail.com>
Subject: [PATCH net-next] r8169: allocate rx buffers using alloc_pages_node
Message-ID: <7d79d794-b41c-101f-0720-59eea88bf9ab@gmail.com>
Date:   Wed, 7 Aug 2019 21:38:22 +0200
User-Agent: Mozilla/5.0 (Windows NT 10.0; WOW64; rv:60.0) Gecko/20100101
 Thunderbird/60.8.0
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

We allocate 16kb per rx buffer, so we can avoid some overhead by using
alloc_pages_node directly instead of bothering kmalloc_node. Due to
this change buffers are page-aligned now, therefore the alignment check
can be removed.

Signed-off-by: Heiner Kallweit <hkallweit1@gmail.com>
---
 drivers/net/ethernet/realtek/r8169_main.c | 45 ++++++++++-------------
 1 file changed, 19 insertions(+), 26 deletions(-)

diff --git a/drivers/net/ethernet/realtek/r8169_main.c b/drivers/net/ethernet/realtek/r8169_main.c
index 3c7af6669..4f0b32280 100644
--- a/drivers/net/ethernet/realtek/r8169_main.c
+++ b/drivers/net/ethernet/realtek/r8169_main.c
@@ -642,7 +642,7 @@ struct rtl8169_private {
 	struct RxDesc *RxDescArray;	/* 256-aligned Rx descriptor ring */
 	dma_addr_t TxPhyAddr;
 	dma_addr_t RxPhyAddr;
-	void *Rx_databuff[NUM_RX_DESC];	/* Rx data buffers */
+	struct page *Rx_databuff[NUM_RX_DESC];	/* Rx data buffers */
 	struct ring_info tx_skb[NUM_TX_DESC];	/* Tx data buffers */
 	u16 cp_cmd;
 	u16 irq_mask;
@@ -5261,12 +5261,13 @@ static inline void rtl8169_make_unusable_by_asic(struct RxDesc *desc)
 }
 
 static void rtl8169_free_rx_databuff(struct rtl8169_private *tp,
-				     void **data_buff, struct RxDesc *desc)
+				     struct page **data_buff,
+				     struct RxDesc *desc)
 {
-	dma_unmap_single(tp_to_dev(tp), le64_to_cpu(desc->addr),
-			 R8169_RX_BUF_SIZE, DMA_FROM_DEVICE);
+	dma_unmap_page(tp_to_dev(tp), le64_to_cpu(desc->addr),
+		       R8169_RX_BUF_SIZE, DMA_FROM_DEVICE);
 
-	kfree(*data_buff);
+	__free_pages(*data_buff, get_order(R8169_RX_BUF_SIZE));
 	*data_buff = NULL;
 	rtl8169_make_unusable_by_asic(desc);
 }
@@ -5281,38 +5282,30 @@ static inline void rtl8169_mark_to_asic(struct RxDesc *desc)
 	desc->opts1 = cpu_to_le32(DescOwn | eor | R8169_RX_BUF_SIZE);
 }
 
-static struct sk_buff *rtl8169_alloc_rx_data(struct rtl8169_private *tp,
-					     struct RxDesc *desc)
+static struct page *rtl8169_alloc_rx_data(struct rtl8169_private *tp,
+					  struct RxDesc *desc)
 {
-	void *data;
-	dma_addr_t mapping;
 	struct device *d = tp_to_dev(tp);
 	int node = dev_to_node(d);
+	dma_addr_t mapping;
+	struct page *data;
 
-	data = kmalloc_node(R8169_RX_BUF_SIZE, GFP_KERNEL, node);
+	data = alloc_pages_node(node, GFP_KERNEL, get_order(R8169_RX_BUF_SIZE));
 	if (!data)
 		return NULL;
 
-	/* Memory should be properly aligned, but better check. */
-	if (!IS_ALIGNED((unsigned long)data, 8)) {
-		netdev_err_once(tp->dev, "RX buffer not 8-byte-aligned\n");
-		goto err_out;
-	}
-
-	mapping = dma_map_single(d, data, R8169_RX_BUF_SIZE, DMA_FROM_DEVICE);
+	mapping = dma_map_page(d, data, 0, R8169_RX_BUF_SIZE, DMA_FROM_DEVICE);
 	if (unlikely(dma_mapping_error(d, mapping))) {
 		if (net_ratelimit())
 			netif_err(tp, drv, tp->dev, "Failed to map RX DMA!\n");
-		goto err_out;
+		__free_pages(data, get_order(R8169_RX_BUF_SIZE));
+		return NULL;
 	}
 
 	desc->addr = cpu_to_le64(mapping);
 	rtl8169_mark_to_asic(desc);
-	return data;
 
-err_out:
-	kfree(data);
-	return NULL;
+	return data;
 }
 
 static void rtl8169_rx_clear(struct rtl8169_private *tp)
@@ -5337,7 +5330,7 @@ static int rtl8169_rx_fill(struct rtl8169_private *tp)
 	unsigned int i;
 
 	for (i = 0; i < NUM_RX_DESC; i++) {
-		void *data;
+		struct page *data;
 
 		data = rtl8169_alloc_rx_data(tp, tp->RxDescArray + i);
 		if (!data) {
@@ -5892,6 +5885,7 @@ static int rtl_rx(struct net_device *dev, struct rtl8169_private *tp, u32 budget
 
 	for (rx_left = min(budget, NUM_RX_DESC); rx_left > 0; rx_left--, cur_rx++) {
 		unsigned int entry = cur_rx % NUM_RX_DESC;
+		const void *rx_buf = page_address(tp->Rx_databuff[entry]);
 		struct RxDesc *desc = tp->RxDescArray + entry;
 		u32 status;
 
@@ -5946,9 +5940,8 @@ static int rtl_rx(struct net_device *dev, struct rtl8169_private *tp, u32 budget
 				goto release_descriptor;
 			}
 
-			prefetch(tp->Rx_databuff[entry]);
-			skb_copy_to_linear_data(skb, tp->Rx_databuff[entry],
-						pkt_size);
+			prefetch(rx_buf);
+			skb_copy_to_linear_data(skb, rx_buf, pkt_size);
 			skb->tail += pkt_size;
 			skb->len = pkt_size;
 
-- 
2.22.0

