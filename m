Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 09855341409
	for <lists+netdev@lfdr.de>; Fri, 19 Mar 2021 05:14:57 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233646AbhCSENw (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 19 Mar 2021 00:13:52 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:35702 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233640AbhCSENq (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 19 Mar 2021 00:13:46 -0400
Received: from mail-pg1-x52b.google.com (mail-pg1-x52b.google.com [IPv6:2607:f8b0:4864:20::52b])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 9B55CC06174A;
        Thu, 18 Mar 2021 21:13:46 -0700 (PDT)
Received: by mail-pg1-x52b.google.com with SMTP id u19so2831699pgh.10;
        Thu, 18 Mar 2021 21:13:46 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=from:to:cc:subject:date:message-id;
        bh=K3OlxThLELLV+dOYIME3VPwwc43El/+ZdfdX6SpwFbQ=;
        b=f2sC8usTyut5m4atRKYn5ilmo9LAudMDGOhuG1I+NNsaYpCyNwnRw1ZCcFTJtVErET
         6mtLr/LVlaD4Fw+q5QYFyMczvG7RHhQsxiktbxloie4xXnE+o7OI17v4xwuaDDIV9bRA
         +ac1RU/VyyVLTGR68E1s4k+GgZxi/ce+/Ob6bK4d6ILeEWKrQkFqe5Haeyom65o9+pnZ
         yfvq5fX63nVb0lWCgcoNuFlEBVqoTo+Vd7FBzPd1SjY0lO3L1NGyiW5vy1E8FgDqr8cG
         Gy8Xe7L2Ii+mkEpXTo6eC66egu1ns3WZk1bG7uYpSPxEeqFMMSpg+JfUQeVllziitb/K
         gX1g==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id;
        bh=K3OlxThLELLV+dOYIME3VPwwc43El/+ZdfdX6SpwFbQ=;
        b=MoG5m48r4thUqmu0KYLev31eq2O930TqUzbmscQ0TG2g8e5J7UW+IOQIUg4jyMg0Yi
         oPeliuG+ND5ENEtEBecONQsCTPzfRv6ipfJ9Peefq0Jy+OlG6jakUQwEFaI6EfAM3NQZ
         i1RVPTowpgpZ/1GGUQoHow3wOXLCl7lqOHQk2w4XOtUtXDr7wsE+kDpaYA3CupWsiKrU
         lSzjgze47vFkC+UXGqJaaKsV3zOBFFnCFu/sohwQVRXrRx7FYoo9aPbLOGpEILF8TwYM
         luNt8bwoK2Uv4Q2ukDjK8kkPVkak21lzKV0iWhMt+osDuaupi690ou3WmYBxFmtalPY3
         GR4w==
X-Gm-Message-State: AOAM531oA9vN6VeJjZ0AWMpmt5t5dlLHjasKyRRNTvNEMQ4GOWS6usk0
        3jcFYuPHZJdAtazF0NMIFCc=
X-Google-Smtp-Source: ABdhPJzcllcEurkXUULsIcF7lWceY2WmFQZcVMJdd0Bh30Sr5BYqw1ktwOkS/O9E1PuukqdyRkkN7Q==
X-Received: by 2002:a05:6a00:2b4:b029:1f6:6f37:ef92 with SMTP id q20-20020a056a0002b4b02901f66f37ef92mr7203979pfs.56.1616127225936;
        Thu, 18 Mar 2021 21:13:45 -0700 (PDT)
Received: from DESKTOP-8REGVGF.localdomain ([115.164.184.3])
        by smtp.gmail.com with ESMTPSA id f2sm3926888pfq.129.2021.03.18.21.13.43
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 18 Mar 2021 21:13:45 -0700 (PDT)
From:   Sieng Piaw Liew <liew.s.piaw@gmail.com>
To:     chris.snook@gmail.com
Cc:     davem@davemloft.net, kuba@kernel.org, netdev@vger.kernel.org,
        linux-kernel@vger.kernel.org,
        Sieng Piaw Liew <liew.s.piaw@gmail.com>
Subject: [PATCH] atl1c: use napi_alloc_skb
Date:   Fri, 19 Mar 2021 12:13:22 +0800
Message-Id: <20210319041322.1001-1-liew.s.piaw@gmail.com>
X-Mailer: git-send-email 2.17.1
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Using napi_alloc_skb in NAPI context avoids enable/disable IRQs, which
increases iperf3 result by a few Mbps. Since napi_alloc_skb() uses
NET_IP_ALIGN, convert other alloc methods to the same padding. Tested
on Intel Core2 and AMD K10 platforms.

Signed-off-by: Sieng Piaw Liew <liew.s.piaw@gmail.com>
---
 .../net/ethernet/atheros/atl1c/atl1c_main.c   | 28 +++++++++++--------
 1 file changed, 17 insertions(+), 11 deletions(-)

diff --git a/drivers/net/ethernet/atheros/atl1c/atl1c_main.c b/drivers/net/ethernet/atheros/atl1c/atl1c_main.c
index 3f65f2b370c5..66325ba5b3a1 100644
--- a/drivers/net/ethernet/atheros/atl1c/atl1c_main.c
+++ b/drivers/net/ethernet/atheros/atl1c/atl1c_main.c
@@ -47,7 +47,7 @@ static void atl1c_down(struct atl1c_adapter *adapter);
 static int atl1c_reset_mac(struct atl1c_hw *hw);
 static void atl1c_reset_dma_ring(struct atl1c_adapter *adapter);
 static int atl1c_configure(struct atl1c_adapter *adapter);
-static int atl1c_alloc_rx_buffer(struct atl1c_adapter *adapter);
+static int atl1c_alloc_rx_buffer(struct atl1c_adapter *adapter, bool napi_mode);
 
 
 static const u32 atl1c_default_msg = NETIF_MSG_DRV | NETIF_MSG_PROBE |
@@ -470,7 +470,7 @@ static void atl1c_set_rxbufsize(struct atl1c_adapter *adapter,
 	adapter->rx_buffer_len = mtu > AT_RX_BUF_SIZE ?
 		roundup(mtu + ETH_HLEN + ETH_FCS_LEN + VLAN_HLEN, 8) : AT_RX_BUF_SIZE;
 
-	head_size = SKB_DATA_ALIGN(adapter->rx_buffer_len + NET_SKB_PAD) +
+	head_size = SKB_DATA_ALIGN(adapter->rx_buffer_len + NET_SKB_PAD + NET_IP_ALIGN) +
 		    SKB_DATA_ALIGN(sizeof(struct skb_shared_info));
 	adapter->rx_frag_size = roundup_pow_of_two(head_size);
 }
@@ -1434,7 +1434,7 @@ static int atl1c_configure(struct atl1c_adapter *adapter)
 	atl1c_set_multi(netdev);
 	atl1c_restore_vlan(adapter);
 
-	num = atl1c_alloc_rx_buffer(adapter);
+	num = atl1c_alloc_rx_buffer(adapter, false);
 	if (unlikely(num == 0))
 		return -ENOMEM;
 
@@ -1650,14 +1650,20 @@ static inline void atl1c_rx_checksum(struct atl1c_adapter *adapter,
 	skb_checksum_none_assert(skb);
 }
 
-static struct sk_buff *atl1c_alloc_skb(struct atl1c_adapter *adapter)
+static struct sk_buff *atl1c_alloc_skb(struct atl1c_adapter *adapter,
+				       bool napi_mode)
 {
 	struct sk_buff *skb;
 	struct page *page;
 
-	if (adapter->rx_frag_size > PAGE_SIZE)
-		return netdev_alloc_skb(adapter->netdev,
-					adapter->rx_buffer_len);
+	if (adapter->rx_frag_size > PAGE_SIZE) {
+		if (likely(napi_mode))
+			return napi_alloc_skb(&adapter->napi,
+					      adapter->rx_buffer_len);
+		else
+			return netdev_alloc_skb_ip_align(adapter->netdev,
+							 adapter->rx_buffer_len);
+	}
 
 	page = adapter->rx_page;
 	if (!page) {
@@ -1670,7 +1676,7 @@ static struct sk_buff *atl1c_alloc_skb(struct atl1c_adapter *adapter)
 	skb = build_skb(page_address(page) + adapter->rx_page_offset,
 			adapter->rx_frag_size);
 	if (likely(skb)) {
-		skb_reserve(skb, NET_SKB_PAD);
+		skb_reserve(skb, NET_SKB_PAD + NET_IP_ALIGN);
 		adapter->rx_page_offset += adapter->rx_frag_size;
 		if (adapter->rx_page_offset >= PAGE_SIZE)
 			adapter->rx_page = NULL;
@@ -1680,7 +1686,7 @@ static struct sk_buff *atl1c_alloc_skb(struct atl1c_adapter *adapter)
 	return skb;
 }
 
-static int atl1c_alloc_rx_buffer(struct atl1c_adapter *adapter)
+static int atl1c_alloc_rx_buffer(struct atl1c_adapter *adapter, bool napi_mode)
 {
 	struct atl1c_rfd_ring *rfd_ring = &adapter->rfd_ring;
 	struct pci_dev *pdev = adapter->pdev;
@@ -1701,7 +1707,7 @@ static int atl1c_alloc_rx_buffer(struct atl1c_adapter *adapter)
 	while (next_info->flags & ATL1C_BUFFER_FREE) {
 		rfd_desc = ATL1C_RFD_DESC(rfd_ring, rfd_next_to_use);
 
-		skb = atl1c_alloc_skb(adapter);
+		skb = atl1c_alloc_skb(adapter, napi_mode);
 		if (unlikely(!skb)) {
 			if (netif_msg_rx_err(adapter))
 				dev_warn(&pdev->dev, "alloc rx buffer failed\n");
@@ -1857,7 +1863,7 @@ static void atl1c_clean_rx_irq(struct atl1c_adapter *adapter,
 		count++;
 	}
 	if (count)
-		atl1c_alloc_rx_buffer(adapter);
+		atl1c_alloc_rx_buffer(adapter, true);
 }
 
 /**
-- 
2.17.1

