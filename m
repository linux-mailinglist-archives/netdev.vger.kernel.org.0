Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 66974197129
	for <lists+netdev@lfdr.de>; Mon, 30 Mar 2020 01:54:09 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727134AbgC2XyG (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sun, 29 Mar 2020 19:54:06 -0400
Received: from mail-wr1-f67.google.com ([209.85.221.67]:39810 "EHLO
        mail-wr1-f67.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726403AbgC2XyG (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sun, 29 Mar 2020 19:54:06 -0400
Received: by mail-wr1-f67.google.com with SMTP id p10so19228696wrt.6
        for <netdev@vger.kernel.org>; Sun, 29 Mar 2020 16:54:05 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=from:subject:to:cc:message-id:date:user-agent:mime-version
         :content-language:content-transfer-encoding;
        bh=Vu5oyXPuPNhDz9Bplxz2mQUQZ1VIep0RobrJxEdIsBs=;
        b=qCeYab/zpREUfU0fXm2X9C7nodCbEajLRj5phg6yLGo7/q3EMshZ0nuhpnHOeqoqR5
         TMISAs6edBUCGijAiF5qG8UJgDdL68fQGjNm0EM2jp8Ga3lwU4WwAX0IFuU4a3XZGRSH
         N7VhjSpjl4ay+lqS7zaOJz7ks8IXaCD4vKIBVMYzZ7f6MVfiamicNXSVDiKJOUOaFYXn
         k5f76ito9i4groX2ZuDdLNohzrB4cs2no1OQIYaaFutDNisOPNyAPs4PckPral+0CV/c
         7auR5wuqJHPOgIqeQOX8qheKs2yzHhWiHw0JTJDq6igcXvyiJC0z/zHZZQEOOLYDtflV
         G7sA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:subject:to:cc:message-id:date:user-agent
         :mime-version:content-language:content-transfer-encoding;
        bh=Vu5oyXPuPNhDz9Bplxz2mQUQZ1VIep0RobrJxEdIsBs=;
        b=jFZevVnlc2Ki0gSLbJGzA2AAOz3Gn4zlfXdqywvq7ScKZkrXbjMF2Yzr5aTNhD+tn4
         oHzb5+HMhLp7CCIR+TdBLrkLZ9k9UQfpvnQhv/K7WGR2W+BF3JaiQcNvAxwBaaPSzzKS
         0WbDat4fS3P6WlM1V+WX5TFQhj4YY2PFKs29ILRm2Y6jJOhL1I95R4gvwhO/ZQK8ovvz
         WN5odrZ9oJBaQ/gcKpdWMzk9ZJnGAwb16RKiMdT7/oT4s63fa3cxq9ONiJpOynlbpMPm
         5yrcGb9q/bY2tEy3LobIaKqST5zGOw6C8yA2FeEUA5cAWdx48sKZ4wn78FFkrI0FTLu2
         QArA==
X-Gm-Message-State: ANhLgQ1zGA3u8rmj8PzoRRJWGNhhDDwxvh61rSz8/s9MoDKC1g8adcMl
        /AHAvtcKDaO92cf3Va8IBy2z2N4K
X-Google-Smtp-Source: ADFU+vuqW4plaNyPC5lyXlmiWJayKnFZr/ocgoHY92qDLmqNRN7rZXN8mDXeLdRjQ8MW6ButUX/xWg==
X-Received: by 2002:a5d:5112:: with SMTP id s18mr12154729wrt.306.1585526044133;
        Sun, 29 Mar 2020 16:54:04 -0700 (PDT)
Received: from ?IPv6:2003:ea:8f29:6000:186:fda7:a83:def2? (p200300EA8F2960000186FDA70A83DEF2.dip0.t-ipconnect.de. [2003:ea:8f29:6000:186:fda7:a83:def2])
        by smtp.googlemail.com with ESMTPSA id w9sm21413892wrk.18.2020.03.29.16.54.03
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Sun, 29 Mar 2020 16:54:03 -0700 (PDT)
From:   Heiner Kallweit <hkallweit1@gmail.com>
Subject: [PATCH net-next] r8169: factor out rtl8169_tx_map
To:     Realtek linux nic maintainers <nic_swsd@realtek.com>,
        David Miller <davem@davemloft.net>
Cc:     "netdev@vger.kernel.org" <netdev@vger.kernel.org>
Message-ID: <d9511cb2-42a7-eaec-7594-0f326f08efcd@gmail.com>
Date:   Mon, 30 Mar 2020 01:53:39 +0200
User-Agent: Mozilla/5.0 (Windows NT 10.0; WOW64; rv:68.0) Gecko/20100101
 Thunderbird/68.6.0
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Factor out mapping the tx skb to a new function rtl8169_tx_map(). This
allows to remove redundancies, and rtl8169_get_txd_opts1() has only
one user left, so it can be inlined.
As a result rtl8169_xmit_frags() is significantly simplified, and in
rtl8169_start_xmit() the code is simplified and better readable.
No functional change intended.

Signed-off-by: Heiner Kallweit <hkallweit1@gmail.com>
---
 drivers/net/ethernet/realtek/r8169_main.c | 110 ++++++++++------------
 1 file changed, 50 insertions(+), 60 deletions(-)

diff --git a/drivers/net/ethernet/realtek/r8169_main.c b/drivers/net/ethernet/realtek/r8169_main.c
index 5990147c0..55cb5730b 100644
--- a/drivers/net/ethernet/realtek/r8169_main.c
+++ b/drivers/net/ethernet/realtek/r8169_main.c
@@ -4040,54 +4040,55 @@ static void rtl8169_tx_timeout(struct net_device *dev, unsigned int txqueue)
 	rtl_schedule_task(tp, RTL_FLAG_TASK_RESET_PENDING);
 }
 
-static __le32 rtl8169_get_txd_opts1(u32 opts0, u32 len, unsigned int entry)
+static int rtl8169_tx_map(struct rtl8169_private *tp, const u32 *opts, u32 len,
+			  void *addr, unsigned int entry, bool desc_own)
 {
-	u32 status = opts0 | len;
+	struct TxDesc *txd = tp->TxDescArray + entry;
+	struct device *d = tp_to_dev(tp);
+	dma_addr_t mapping;
+	u32 opts1;
+	int ret;
+
+	mapping = dma_map_single(d, addr, len, DMA_TO_DEVICE);
+	ret = dma_mapping_error(d, mapping);
+	if (unlikely(ret)) {
+		if (net_ratelimit())
+			netif_err(tp, drv, tp->dev, "Failed to map TX data!\n");
+		return ret;
+	}
 
+	txd->addr = cpu_to_le64(mapping);
+	txd->opts2 = cpu_to_le32(opts[1]);
+
+	opts1 = opts[0] | len;
 	if (entry == NUM_TX_DESC - 1)
-		status |= RingEnd;
+		opts1 |= RingEnd;
+	if (desc_own)
+		opts1 |= DescOwn;
+	txd->opts1 = cpu_to_le32(opts1);
+
+	tp->tx_skb[entry].len = len;
 
-	return cpu_to_le32(status);
+	return 0;
 }
 
 static int rtl8169_xmit_frags(struct rtl8169_private *tp, struct sk_buff *skb,
-			      u32 *opts)
+			      const u32 *opts, unsigned int entry)
 {
 	struct skb_shared_info *info = skb_shinfo(skb);
-	unsigned int cur_frag, entry;
-	struct TxDesc *uninitialized_var(txd);
-	struct device *d = tp_to_dev(tp);
+	unsigned int cur_frag;
 
-	entry = tp->cur_tx;
 	for (cur_frag = 0; cur_frag < info->nr_frags; cur_frag++) {
 		const skb_frag_t *frag = info->frags + cur_frag;
-		dma_addr_t mapping;
-		u32 len;
-		void *addr;
+		void *addr = skb_frag_address(frag);
+		u32 len = skb_frag_size(frag);
 
 		entry = (entry + 1) % NUM_TX_DESC;
 
-		txd = tp->TxDescArray + entry;
-		len = skb_frag_size(frag);
-		addr = skb_frag_address(frag);
-		mapping = dma_map_single(d, addr, len, DMA_TO_DEVICE);
-		if (unlikely(dma_mapping_error(d, mapping))) {
-			if (net_ratelimit())
-				netif_err(tp, drv, tp->dev,
-					  "Failed to map TX fragments DMA!\n");
+		if (unlikely(rtl8169_tx_map(tp, opts, len, addr, entry, true)))
 			goto err_out;
-		}
-
-		txd->opts1 = rtl8169_get_txd_opts1(opts[0], len, entry);
-		txd->opts2 = cpu_to_le32(opts[1]);
-		txd->addr = cpu_to_le64(mapping);
-
-		tp->tx_skb[entry].len = len;
 	}
 
-	tp->tx_skb[entry].skb = skb;
-	txd->opts1 |= cpu_to_le32(LastFrag);
-
 	return 0;
 
 err_out:
@@ -4216,52 +4217,41 @@ static netdev_tx_t rtl8169_start_xmit(struct sk_buff *skb,
 	unsigned int frags = skb_shinfo(skb)->nr_frags;
 	struct rtl8169_private *tp = netdev_priv(dev);
 	unsigned int entry = tp->cur_tx % NUM_TX_DESC;
-	struct TxDesc *txd = tp->TxDescArray + entry;
-	struct device *d = tp_to_dev(tp);
-	dma_addr_t mapping;
-	u32 opts[2], len;
-	bool stop_queue;
-	bool door_bell;
+	struct TxDesc *txd_first, *txd_last;
+	bool stop_queue, door_bell;
+	u32 opts[2];
+
+	txd_first = tp->TxDescArray + entry;
 
 	if (unlikely(!rtl_tx_slots_avail(tp, frags))) {
 		netif_err(tp, drv, dev, "BUG! Tx Ring full when queue awake!\n");
 		goto err_stop_0;
 	}
 
-	if (unlikely(le32_to_cpu(txd->opts1) & DescOwn))
+	if (unlikely(le32_to_cpu(txd_first->opts1) & DescOwn))
 		goto err_stop_0;
 
 	opts[1] = rtl8169_tx_vlan_tag(skb);
-	opts[0] = DescOwn;
+	opts[0] = 0;
 
-	if (rtl_chip_supports_csum_v2(tp)) {
-		if (!rtl8169_tso_csum_v2(tp, skb, opts))
-			goto err_dma_0;
-	} else {
+	if (!rtl_chip_supports_csum_v2(tp))
 		rtl8169_tso_csum_v1(skb, opts);
-	}
-
-	len = skb_headlen(skb);
-	mapping = dma_map_single(d, skb->data, len, DMA_TO_DEVICE);
-	if (unlikely(dma_mapping_error(d, mapping))) {
-		if (net_ratelimit())
-			netif_err(tp, drv, dev, "Failed to map TX DMA!\n");
+	else if (!rtl8169_tso_csum_v2(tp, skb, opts))
 		goto err_dma_0;
-	}
 
-	tp->tx_skb[entry].len = len;
-	txd->addr = cpu_to_le64(mapping);
+	if (unlikely(rtl8169_tx_map(tp, opts, skb_headlen(skb), skb->data,
+				    entry, false)))
+		goto err_dma_0;
 
-	if (!frags) {
-		opts[0] |= FirstFrag | LastFrag;
-		tp->tx_skb[entry].skb = skb;
-	} else {
-		if (rtl8169_xmit_frags(tp, skb, opts))
+	if (frags) {
+		if (rtl8169_xmit_frags(tp, skb, opts, entry))
 			goto err_dma_1;
-		opts[0] |= FirstFrag;
+		entry = (entry + frags) % NUM_TX_DESC;
 	}
 
-	txd->opts2 = cpu_to_le32(opts[1]);
+	txd_last = tp->TxDescArray + entry;
+	txd_last->opts1 |= cpu_to_le32(LastFrag);
+	tp->tx_skb[entry].skb = skb;
 
 	skb_tx_timestamp(skb);
 
@@ -4270,7 +4260,7 @@ static netdev_tx_t rtl8169_start_xmit(struct sk_buff *skb,
 
 	door_bell = __netdev_sent_queue(dev, skb->len, netdev_xmit_more());
 
-	txd->opts1 = rtl8169_get_txd_opts1(opts[0], len, entry);
+	txd_first->opts1 |= cpu_to_le32(DescOwn | FirstFrag);
 
 	/* Force all memory writes to complete before notifying device */
 	wmb();
-- 
2.26.0

