Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 6612917C89D
	for <lists+netdev@lfdr.de>; Fri,  6 Mar 2020 23:59:21 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726766AbgCFW7R (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 6 Mar 2020 17:59:17 -0500
Received: from mail-wm1-f67.google.com ([209.85.128.67]:34978 "EHLO
        mail-wm1-f67.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726162AbgCFW7P (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 6 Mar 2020 17:59:15 -0500
Received: by mail-wm1-f67.google.com with SMTP id m3so4052605wmi.0
        for <netdev@vger.kernel.org>; Fri, 06 Mar 2020 14:59:14 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=subject:from:to:cc:references:message-id:date:user-agent
         :mime-version:in-reply-to:content-language:content-transfer-encoding;
        bh=RynB79HgR7sTc4vLsv876vhUdcIwfUiJRUs3uVF7U/U=;
        b=bBNu6u5Vj/WX2J4M9Bq1ETM5rOzg+KHbXQNIBrSEoG4iYmfoT8GMSjtU1lW6aL316g
         oaUXHAx+6aRByAeBgXg2PjqACgnXGEiy25CrpvSpA6kAaScIJUHc9JfaRbo696qdADd+
         oaqMgqmGVQe1pvMLzR0tAYr9dSDva0wag3vfptk9vA0dhGYIEqHGOThCuO3whlrcPGIm
         BfDUPnWwhviOpxzXTaQugTkEi3J4UMMaKxETQ923PgMhM03lSi5nd5bXnQd3HoM40kCt
         +EiQCusK6A3f2g6NBIwbHYtuudW9a+nXCSsrCxBXwH1WbBHaZxKZN0g7z0tsOWyscb5j
         q9Eg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:subject:from:to:cc:references:message-id:date
         :user-agent:mime-version:in-reply-to:content-language
         :content-transfer-encoding;
        bh=RynB79HgR7sTc4vLsv876vhUdcIwfUiJRUs3uVF7U/U=;
        b=ndLB7p41PL8haTNDUwwquuuuxXtZ+F+XYAZiNgfZKOfzQrSBJYboS2aBquzETQ/Kni
         scau13lCzqpQYfuLjfxzXLeGJYcUJt6tt7MaRGdswqjGcnT8AruoyU6MdTywqgthhAOL
         p5FdPeDNt9fi4eSMwxdeQqSTqa4VyXsi/dnhfJtFhZinOhFlPNgdG3WbK+b171CLFonT
         ugh6LrENq2ha1aaPjBq9RSevPYZ88HLdSdZgBmXeNVaj4lvNv+CjszEQ8lgbdgC4uXw8
         EBg/UGzisx3JV0JbAQmPdOrf1V4fjaioYQN3iZpq9sQYUCNqU9X/+/OnNtQF7oaIzY8i
         cdfQ==
X-Gm-Message-State: ANhLgQ2GiOSdLvBub0M7gCNXOBZdfmjD58OfzMjXGiIj4WZZaZMklvie
        F11jgvX85b3Ytjfj8hYpiklDIk+F
X-Google-Smtp-Source: ADFU+vusyw2Opi5BIhWCzwcKLSk1UFpoewS/k3XB+si03IFM/R4n2m7agvg+jlwKiEjp3DPxuh3phw==
X-Received: by 2002:a1c:1b13:: with SMTP id b19mr6530718wmb.91.1583535553974;
        Fri, 06 Mar 2020 14:59:13 -0800 (PST)
Received: from ?IPv6:2003:ea:8f29:6000:1447:bded:797c:45a5? (p200300EA8F2960001447BDED797C45A5.dip0.t-ipconnect.de. [2003:ea:8f29:6000:1447:bded:797c:45a5])
        by smtp.googlemail.com with ESMTPSA id i67sm28499494wri.50.2020.03.06.14.59.13
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Fri, 06 Mar 2020 14:59:13 -0800 (PST)
Subject: [PATCH net-next 3/4] r8169: simplify usage of rtl8169_unmap_tx_skb
From:   Heiner Kallweit <hkallweit1@gmail.com>
To:     Realtek linux nic maintainers <nic_swsd@realtek.com>,
        David Miller <davem@davemloft.net>
Cc:     "netdev@vger.kernel.org" <netdev@vger.kernel.org>
References: <de8e697e-dd20-cbae-4d2d-b1e8994ba65d@gmail.com>
Message-ID: <f062e106-1cdf-8cdc-e2a7-fa165cdecb44@gmail.com>
Date:   Fri, 6 Mar 2020 23:56:38 +0100
User-Agent: Mozilla/5.0 (Windows NT 10.0; WOW64; rv:68.0) Gecko/20100101
 Thunderbird/68.5.0
MIME-Version: 1.0
In-Reply-To: <de8e697e-dd20-cbae-4d2d-b1e8994ba65d@gmail.com>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Simplify the parameters taken by rtl8169_unmap_tx_skb, this makes
usage of this function easier to read and understand.

Signed-off-by: Heiner Kallweit <hkallweit1@gmail.com>
---
 drivers/net/ethernet/realtek/r8169_main.c | 21 ++++++++++-----------
 1 file changed, 10 insertions(+), 11 deletions(-)

diff --git a/drivers/net/ethernet/realtek/r8169_main.c b/drivers/net/ethernet/realtek/r8169_main.c
index 359f029a7..8a707d67c 100644
--- a/drivers/net/ethernet/realtek/r8169_main.c
+++ b/drivers/net/ethernet/realtek/r8169_main.c
@@ -3970,12 +3970,13 @@ static int rtl8169_init_ring(struct rtl8169_private *tp)
 	return rtl8169_rx_fill(tp);
 }
 
-static void rtl8169_unmap_tx_skb(struct device *d, struct ring_info *tx_skb,
-				 struct TxDesc *desc)
+static void rtl8169_unmap_tx_skb(struct rtl8169_private *tp, unsigned int entry)
 {
-	unsigned int len = tx_skb->len;
+	struct ring_info *tx_skb = tp->tx_skb + entry;
+	struct TxDesc *desc = tp->TxDescArray + entry;
 
-	dma_unmap_single(d, le64_to_cpu(desc->addr), len, DMA_TO_DEVICE);
+	dma_unmap_single(tp_to_dev(tp), le64_to_cpu(desc->addr), tx_skb->len,
+			 DMA_TO_DEVICE);
 	memset(desc, 0, sizeof(*desc));
 	memset(tx_skb, 0, sizeof(*tx_skb));
 }
@@ -3993,8 +3994,7 @@ static void rtl8169_tx_clear_range(struct rtl8169_private *tp, u32 start,
 		if (len) {
 			struct sk_buff *skb = tx_skb->skb;
 
-			rtl8169_unmap_tx_skb(tp_to_dev(tp), tx_skb,
-					     tp->TxDescArray + entry);
+			rtl8169_unmap_tx_skb(tp, entry);
 			if (skb)
 				dev_consume_skb_any(skb);
 		}
@@ -4303,7 +4303,7 @@ static netdev_tx_t rtl8169_start_xmit(struct sk_buff *skb,
 	return NETDEV_TX_OK;
 
 err_dma_1:
-	rtl8169_unmap_tx_skb(d, tp->tx_skb + entry, txd);
+	rtl8169_unmap_tx_skb(tp, entry);
 err_dma_0:
 	dev_kfree_skb_any(skb);
 	dev->stats.tx_dropped++;
@@ -4390,8 +4390,7 @@ static void rtl_tx(struct net_device *dev, struct rtl8169_private *tp,
 
 	for (tx_left = tp->cur_tx - dirty_tx; tx_left > 0; tx_left--) {
 		unsigned int entry = dirty_tx % NUM_TX_DESC;
-		struct ring_info *tx_skb = tp->tx_skb + entry;
-		struct sk_buff *skb = tx_skb->skb;
+		struct sk_buff *skb = tp->tx_skb[entry].skb;
 		u32 status;
 
 		status = le32_to_cpu(tp->TxDescArray[entry].opts1);
@@ -4404,8 +4403,8 @@ static void rtl_tx(struct net_device *dev, struct rtl8169_private *tp,
 		 */
 		dma_rmb();
 
-		rtl8169_unmap_tx_skb(tp_to_dev(tp), tx_skb,
-				     tp->TxDescArray + entry);
+		rtl8169_unmap_tx_skb(tp, entry);
+
 		if (skb) {
 			pkts_compl++;
 			bytes_compl += skb->len;
-- 
2.25.1


