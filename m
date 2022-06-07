Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 1708553F8F4
	for <lists+netdev@lfdr.de>; Tue,  7 Jun 2022 11:02:21 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232578AbiFGJCS (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 7 Jun 2022 05:02:18 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:54532 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231714AbiFGJCR (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 7 Jun 2022 05:02:17 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [139.178.84.217])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 33E826370;
        Tue,  7 Jun 2022 02:02:15 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id C235C6006F;
        Tue,  7 Jun 2022 09:02:14 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 51784C385A5;
        Tue,  7 Jun 2022 09:02:12 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1654592534;
        bh=AxhVrxjuZOZKV1GbUIk1rvwJbsVFaXDjxHTvatfVTZo=;
        h=From:To:Cc:Subject:Date:From;
        b=MkyC57ogSYxEdRipH21HepQexbFsX/x/JEIK/GROABEwTCmf8rjkktU7w9LtCI0P4
         gsGuQof2VcHApppebINuWvSNIkGhmaiXJDBnq70Mgr9cVgvopNKgd/ZHQbPsDJpN2c
         7U5VLQFYq7xeLE1NVCVgvZkjMihycwfwi8A8d3yN++3zSVRqC5Mew6C32RT9m1iKXu
         47XV5HqNLhRc8r9ZiMBTclbXARc+Q71sLWDPhEA2PYWJCR7MvQFh9ukDeEhhb7H8R8
         3yCJnERoE1u9GM+/v3YnaJI6Vkd1griSWHYLI2HEH7+sQHKLgceZqfiqv+BqbzEb0d
         3pDWvXYZV7xxQ==
From:   Arnd Bergmann <arnd@kernel.org>
To:     "David S. Miller" <davem@davemloft.net>,
        Eric Dumazet <edumazet@google.com>,
        Jakub Kicinski <kuba@kernel.org>,
        Paolo Abeni <pabeni@redhat.com>
Cc:     Arnd Bergmann <arnd@arndb.de>,
        Manuel Lauss <manuel.lauss@gmail.com>, netdev@vger.kernel.org,
        linux-kernel@vger.kernel.org
Subject: [PATCH] au1000_eth: stop using virt_to_bus()
Date:   Tue,  7 Jun 2022 11:01:46 +0200
Message-Id: <20220607090206.19830-1-arnd@kernel.org>
X-Mailer: git-send-email 2.29.2
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-8.3 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Arnd Bergmann <arnd@arndb.de>

The conversion to the dma-mapping API in linux-2.6.11 was incomplete
and left a virt_to_bus() call around. There have been a number of
fixes for DMA mapping API abuse in this driver, but this one always
slipped through.

Change it to just use the existing dma_addr_t pointer, and make it
use the correct types throughout the driver to make it easier to
understand the virtual vs dma address spaces.

Cc: Manuel Lauss <manuel.lauss@gmail.com>
Signed-off-by: Arnd Bergmann <arnd@arndb.de>
---
 drivers/net/ethernet/amd/au1000_eth.c | 22 +++++++++++-----------
 drivers/net/ethernet/amd/au1000_eth.h |  4 ++--
 2 files changed, 13 insertions(+), 13 deletions(-)

diff --git a/drivers/net/ethernet/amd/au1000_eth.c b/drivers/net/ethernet/amd/au1000_eth.c
index c6f003975621..d5f2c6989221 100644
--- a/drivers/net/ethernet/amd/au1000_eth.c
+++ b/drivers/net/ethernet/amd/au1000_eth.c
@@ -820,7 +820,7 @@ static int au1000_rx(struct net_device *dev)
 				pr_cont("\n");
 			}
 		}
-		prxd->buff_stat = (u32)(pDB->dma_addr | RX_DMA_ENABLE);
+		prxd->buff_stat = lower_32_bits(pDB->dma_addr) | RX_DMA_ENABLE;
 		aup->rx_head = (aup->rx_head + 1) & (NUM_RX_DMA - 1);
 		wmb(); /* drain writebuffer */
 
@@ -996,7 +996,7 @@ static netdev_tx_t au1000_tx(struct sk_buff *skb, struct net_device *dev)
 	ps->tx_packets++;
 	ps->tx_bytes += ptxd->len;
 
-	ptxd->buff_stat = pDB->dma_addr | TX_DMA_ENABLE;
+	ptxd->buff_stat = lower_32_bits(pDB->dma_addr) | TX_DMA_ENABLE;
 	wmb(); /* drain writebuffer */
 	dev_kfree_skb(skb);
 	aup->tx_head = (aup->tx_head + 1) & (NUM_TX_DMA - 1);
@@ -1131,9 +1131,9 @@ static int au1000_probe(struct platform_device *pdev)
 	/* Allocate the data buffers
 	 * Snooping works fine with eth on all au1xxx
 	 */
-	aup->vaddr = (u32)dma_alloc_coherent(&pdev->dev, MAX_BUF_SIZE *
-					  (NUM_TX_BUFFS + NUM_RX_BUFFS),
-					  &aup->dma_addr, 0);
+	aup->vaddr = dma_alloc_coherent(&pdev->dev, MAX_BUF_SIZE *
+					(NUM_TX_BUFFS + NUM_RX_BUFFS),
+					&aup->dma_addr, 0);
 	if (!aup->vaddr) {
 		dev_err(&pdev->dev, "failed to allocate data buffers\n");
 		err = -ENOMEM;
@@ -1234,8 +1234,8 @@ static int au1000_probe(struct platform_device *pdev)
 	for (i = 0; i < (NUM_TX_BUFFS+NUM_RX_BUFFS); i++) {
 		pDB->pnext = pDBfree;
 		pDBfree = pDB;
-		pDB->vaddr = (u32 *)((unsigned)aup->vaddr + MAX_BUF_SIZE*i);
-		pDB->dma_addr = (dma_addr_t)virt_to_bus(pDB->vaddr);
+		pDB->vaddr = aup->vaddr + MAX_BUF_SIZE * i;
+		pDB->dma_addr = aup->dma_addr + MAX_BUF_SIZE * i;
 		pDB++;
 	}
 	aup->pDBfree = pDBfree;
@@ -1246,7 +1246,7 @@ static int au1000_probe(struct platform_device *pdev)
 		if (!pDB)
 			goto err_out;
 
-		aup->rx_dma_ring[i]->buff_stat = (unsigned)pDB->dma_addr;
+		aup->rx_dma_ring[i]->buff_stat = lower_32_bits(pDB->dma_addr);
 		aup->rx_db_inuse[i] = pDB;
 	}
 
@@ -1255,7 +1255,7 @@ static int au1000_probe(struct platform_device *pdev)
 		if (!pDB)
 			goto err_out;
 
-		aup->tx_dma_ring[i]->buff_stat = (unsigned)pDB->dma_addr;
+		aup->tx_dma_ring[i]->buff_stat = lower_32_bits(pDB->dma_addr);
 		aup->tx_dma_ring[i]->len = 0;
 		aup->tx_db_inuse[i] = pDB;
 	}
@@ -1310,7 +1310,7 @@ static int au1000_probe(struct platform_device *pdev)
 	iounmap(aup->mac);
 err_remap1:
 	dma_free_coherent(&pdev->dev, MAX_BUF_SIZE * (NUM_TX_BUFFS + NUM_RX_BUFFS),
-			(void *)aup->vaddr, aup->dma_addr);
+			  aup->vaddr, aup->dma_addr);
 err_vaddr:
 	free_netdev(dev);
 err_alloc:
@@ -1343,7 +1343,7 @@ static int au1000_remove(struct platform_device *pdev)
 			au1000_ReleaseDB(aup, aup->tx_db_inuse[i]);
 
 	dma_free_coherent(&pdev->dev, MAX_BUF_SIZE * (NUM_TX_BUFFS + NUM_RX_BUFFS),
-			(void *)aup->vaddr, aup->dma_addr);
+			  aup->vaddr, aup->dma_addr);
 
 	iounmap(aup->macdma);
 	iounmap(aup->mac);
diff --git a/drivers/net/ethernet/amd/au1000_eth.h b/drivers/net/ethernet/amd/au1000_eth.h
index e3a3ed29db61..2489c2f4fd8a 100644
--- a/drivers/net/ethernet/amd/au1000_eth.h
+++ b/drivers/net/ethernet/amd/au1000_eth.h
@@ -106,8 +106,8 @@ struct au1000_private {
 	struct mac_reg *mac;  /* mac registers                      */
 	u32 *enable;     /* address of MAC Enable Register     */
 	void __iomem *macdma;	/* base of MAC DMA port */
-	u32 vaddr;                /* virtual address of rx/tx buffers   */
-	dma_addr_t dma_addr;      /* dma address of rx/tx buffers       */
+	void *vaddr;		/* virtual address of rx/tx buffers   */
+	dma_addr_t dma_addr;	/* dma address of rx/tx buffers       */
 
 	spinlock_t lock;       /* Serialise access to device */
 
-- 
2.29.2

