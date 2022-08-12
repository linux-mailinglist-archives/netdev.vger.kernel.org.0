Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 139AA5914AA
	for <lists+netdev@lfdr.de>; Fri, 12 Aug 2022 19:13:54 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S238874AbiHLRNt (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 12 Aug 2022 13:13:49 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:48450 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S234019AbiHLRNs (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 12 Aug 2022 13:13:48 -0400
Received: from mail-lj1-x22d.google.com (mail-lj1-x22d.google.com [IPv6:2a00:1450:4864:20::22d])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 96353A4052
        for <netdev@vger.kernel.org>; Fri, 12 Aug 2022 10:13:44 -0700 (PDT)
Received: by mail-lj1-x22d.google.com with SMTP id z20so1549308ljq.3
        for <netdev@vger.kernel.org>; Fri, 12 Aug 2022 10:13:44 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:from:to:cc;
        bh=m3zcp3iaGbmg+LbrGq1j6FWnwKspMtSv4IFs4ySHRck=;
        b=WJLuk5BrjXQS4Z60ykAuCauK0jzmee71ZGM7c64RIdovef3hrJwmxyVu1RkyxB0Ag/
         /XlYuHRdibKP72Gqu+rgNlds57LOWbBwtXzq/p/mhjAly9SgyX+hjsyUfbN4Qy0OOT8v
         cfFf/2mYBhsz5dXkk5LS30ixHrGIt+XCcYmZS4UX6oOR1Otw7Y6lXAOM/2KNG7A6ET5r
         6TVTXVYj68gvWnSlAz8njukjDHc/55FujCcZ9Ib2VBb0trRzc42DP9k9pkwdaK39yJjj
         JiUV1GNuR9n3ZkN31zFM+BGcRI81cAhX6Vk3SLD0+Ekkc27kcyJgzYmhirGFXHXUDKQg
         YTSg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:x-gm-message-state:from:to:cc;
        bh=m3zcp3iaGbmg+LbrGq1j6FWnwKspMtSv4IFs4ySHRck=;
        b=eHYFc7XtThjShQNPeTP8R1ReAeH/01T97/Idjwo+EZ0ZwWx3wDj9hNkNQgQP2yed05
         B70873TLqJ8TrMCUOAjNbGhrkqseISJRHUKNiIRSbqAa5ZXydaWWJZROPbUim4ZVrIPt
         KA6bSLm3WoS4uchttPANIOkHrjwI9vice7HrLXEbjUvsNTv6E2ZRXF9HAMGM9r/oz80I
         HTgSMLJtS8U71szJXjjBP7Eb7ErPMIQh2qSXdu2j+gp+yeU6fY7Z6djWTT+whygsElSU
         fNLQ4avSbb6//blJPShTgrFrTpB91c8tMwZsO0BY9FObfMVbn31h37tF3CqXLwWSBnLi
         /PFA==
X-Gm-Message-State: ACgBeo1t5tGhsF7+VYBDeBJ6ebPzU2encdPnFqsX+ZfMMA1EBj+1qHgd
        3oJ6R20OvumHTGruiYZ/F0c0uU4DQwxMaEJM
X-Google-Smtp-Source: AA6agR5B6085oSMQBHuWqSrMvkxZ64vExa2S733gMtdwnXkSaWiKaGHyJPU3mTWfZ3+ZMXMEqQEg8g==
X-Received: by 2002:a2e:894d:0:b0:25e:66e8:eb9c with SMTP id b13-20020a2e894d000000b0025e66e8eb9cmr1558482ljk.241.1660324422788;
        Fri, 12 Aug 2022 10:13:42 -0700 (PDT)
Received: from saproj-Latitude-5501.yandex.net ([2a02:6b8:0:40c:be32:268f:3ab7:4324])
        by smtp.gmail.com with ESMTPSA id f8-20020ac25328000000b0048a9d0242afsm277781lfh.32.2022.08.12.10.13.41
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 12 Aug 2022 10:13:42 -0700 (PDT)
From:   Sergei Antonov <saproj@gmail.com>
To:     netdev@vger.kernel.org
Cc:     Sergei Antonov <saproj@gmail.com>, Andrew Lunn <andrew@lunn.ch>,
        Jakub Kicinski <kuba@kernel.org>,
        Pavel Skripkin <paskripkin@gmail.com>,
        "David S . Miller" <davem@davemloft.net>,
        Paolo Abeni <pabeni@redhat.com>,
        Florian Fainelli <f.fainelli@gmail.com>
Subject: [PATCH v2] net: moxa: pass pdev instead of ndev to DMA functions
Date:   Fri, 12 Aug 2022 20:13:39 +0300
Message-Id: <20220812171339.2271788-1-saproj@gmail.com>
X-Mailer: git-send-email 2.32.0
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,FREEMAIL_FROM,
        RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

dma_map_single() calls fail in moxart_mac_setup_desc_ring() and
moxart_mac_start_xmit() which leads to an incessant output of this:

[   16.043925] moxart-ethernet 92000000.mac eth0: DMA mapping error
[   16.050957] moxart-ethernet 92000000.mac eth0: DMA mapping error
[   16.058229] moxart-ethernet 92000000.mac eth0: DMA mapping error

Passing pdev to DMA is a common approach among net drivers.

Changes in v2:
- Reject an approach to inherit DMA masks from the platform device.

Signed-off-by: Sergei Antonov <saproj@gmail.com>
Suggested-by: Andrew Lunn <andrew@lunn.ch>
CC: Jakub Kicinski <kuba@kernel.org>
CC: Pavel Skripkin <paskripkin@gmail.com>
CC: David S. Miller <davem@davemloft.net>
CC: Paolo Abeni <pabeni@redhat.com>
CC: Florian Fainelli <f.fainelli@gmail.com>
---
 drivers/net/ethernet/moxa/moxart_ether.c | 20 ++++++++++----------
 1 file changed, 10 insertions(+), 10 deletions(-)

diff --git a/drivers/net/ethernet/moxa/moxart_ether.c b/drivers/net/ethernet/moxa/moxart_ether.c
index a3214a762e4b..f11f1cb92025 100644
--- a/drivers/net/ethernet/moxa/moxart_ether.c
+++ b/drivers/net/ethernet/moxa/moxart_ether.c
@@ -77,7 +77,7 @@ static void moxart_mac_free_memory(struct net_device *ndev)
 	int i;
 
 	for (i = 0; i < RX_DESC_NUM; i++)
-		dma_unmap_single(&ndev->dev, priv->rx_mapping[i],
+		dma_unmap_single(&priv->pdev->dev, priv->rx_mapping[i],
 				 priv->rx_buf_size, DMA_FROM_DEVICE);
 
 	if (priv->tx_desc_base)
@@ -147,11 +147,11 @@ static void moxart_mac_setup_desc_ring(struct net_device *ndev)
 		       desc + RX_REG_OFFSET_DESC1);
 
 		priv->rx_buf[i] = priv->rx_buf_base + priv->rx_buf_size * i;
-		priv->rx_mapping[i] = dma_map_single(&ndev->dev,
+		priv->rx_mapping[i] = dma_map_single(&priv->pdev->dev,
 						     priv->rx_buf[i],
 						     priv->rx_buf_size,
 						     DMA_FROM_DEVICE);
-		if (dma_mapping_error(&ndev->dev, priv->rx_mapping[i]))
+		if (dma_mapping_error(&priv->pdev->dev, priv->rx_mapping[i]))
 			netdev_err(ndev, "DMA mapping error\n");
 
 		moxart_desc_write(priv->rx_mapping[i],
@@ -240,7 +240,7 @@ static int moxart_rx_poll(struct napi_struct *napi, int budget)
 		if (len > RX_BUF_SIZE)
 			len = RX_BUF_SIZE;
 
-		dma_sync_single_for_cpu(&ndev->dev,
+		dma_sync_single_for_cpu(&priv->pdev->dev,
 					priv->rx_mapping[rx_head],
 					priv->rx_buf_size, DMA_FROM_DEVICE);
 		skb = netdev_alloc_skb_ip_align(ndev, len);
@@ -294,7 +294,7 @@ static void moxart_tx_finished(struct net_device *ndev)
 	unsigned int tx_tail = priv->tx_tail;
 
 	while (tx_tail != tx_head) {
-		dma_unmap_single(&ndev->dev, priv->tx_mapping[tx_tail],
+		dma_unmap_single(&priv->pdev->dev, priv->tx_mapping[tx_tail],
 				 priv->tx_len[tx_tail], DMA_TO_DEVICE);
 
 		ndev->stats.tx_packets++;
@@ -358,9 +358,9 @@ static netdev_tx_t moxart_mac_start_xmit(struct sk_buff *skb,
 
 	len = skb->len > TX_BUF_SIZE ? TX_BUF_SIZE : skb->len;
 
-	priv->tx_mapping[tx_head] = dma_map_single(&ndev->dev, skb->data,
+	priv->tx_mapping[tx_head] = dma_map_single(&priv->pdev->dev, skb->data,
 						   len, DMA_TO_DEVICE);
-	if (dma_mapping_error(&ndev->dev, priv->tx_mapping[tx_head])) {
+	if (dma_mapping_error(&priv->pdev->dev, priv->tx_mapping[tx_head])) {
 		netdev_err(ndev, "DMA mapping error\n");
 		goto out_unlock;
 	}
@@ -379,7 +379,7 @@ static netdev_tx_t moxart_mac_start_xmit(struct sk_buff *skb,
 		len = ETH_ZLEN;
 	}
 
-	dma_sync_single_for_device(&ndev->dev, priv->tx_mapping[tx_head],
+	dma_sync_single_for_device(&priv->pdev->dev, priv->tx_mapping[tx_head],
 				   priv->tx_buf_size, DMA_TO_DEVICE);
 
 	txdes1 = TX_DESC1_LTS | TX_DESC1_FTS | (len & TX_DESC1_BUF_SIZE_MASK);
@@ -493,7 +493,7 @@ static int moxart_mac_probe(struct platform_device *pdev)
 	priv->tx_buf_size = TX_BUF_SIZE;
 	priv->rx_buf_size = RX_BUF_SIZE;
 
-	priv->tx_desc_base = dma_alloc_coherent(&pdev->dev, TX_REG_DESC_SIZE *
+	priv->tx_desc_base = dma_alloc_coherent(p_dev, TX_REG_DESC_SIZE *
 						TX_DESC_NUM, &priv->tx_base,
 						GFP_DMA | GFP_KERNEL);
 	if (!priv->tx_desc_base) {
@@ -501,7 +501,7 @@ static int moxart_mac_probe(struct platform_device *pdev)
 		goto init_fail;
 	}
 
-	priv->rx_desc_base = dma_alloc_coherent(&pdev->dev, RX_REG_DESC_SIZE *
+	priv->rx_desc_base = dma_alloc_coherent(p_dev, RX_REG_DESC_SIZE *
 						RX_DESC_NUM, &priv->rx_base,
 						GFP_DMA | GFP_KERNEL);
 	if (!priv->rx_desc_base) {
-- 
2.32.0

