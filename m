Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id D1C74C032D
	for <lists+netdev@lfdr.de>; Fri, 27 Sep 2019 12:16:09 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727445AbfI0KPO (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 27 Sep 2019 06:15:14 -0400
Received: from mx2.suse.de ([195.135.220.15]:57180 "EHLO mx1.suse.de"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1727390AbfI0KPN (ORCPT <rfc822;netdev@vger.kernel.org>);
        Fri, 27 Sep 2019 06:15:13 -0400
X-Virus-Scanned: by amavisd-new at test-mx.suse.de
Received: from relay2.suse.de (unknown [195.135.220.254])
        by mx1.suse.de (Postfix) with ESMTP id D37CAAFD0;
        Fri, 27 Sep 2019 10:15:11 +0000 (UTC)
From:   Benjamin Poirier <bpoirier@suse.com>
To:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Cc:     Manish Chopra <manishc@marvell.com>, GR-Linux-NIC-Dev@marvell.com,
        netdev@vger.kernel.org, devel@driverdev.osuosl.org,
        linux-kernel@vger.kernel.org
Subject: [PATCH v2 07/17] staging: qlge: Remove useless dma synchronization calls
Date:   Fri, 27 Sep 2019 19:12:01 +0900
Message-Id: <20190927101210.23856-8-bpoirier@suse.com>
X-Mailer: git-send-email 2.23.0
In-Reply-To: <20190927101210.23856-1-bpoirier@suse.com>
References: <20190927101210.23856-1-bpoirier@suse.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

This is unneeded for two reasons:
1) the cpu does not write data for the device in the mapping
2) calls like ..._sync_..._for_device(..., ..._FROMDEVICE) are
   nonsensical, see commit 3f0fb4e85b38 ("Documentation/DMA-API-HOWTO.txt:
   fix misleading example")

Signed-off-by: Benjamin Poirier <bpoirier@suse.com>
---
 drivers/staging/qlge/qlge_main.c | 12 ------------
 1 file changed, 12 deletions(-)

diff --git a/drivers/staging/qlge/qlge_main.c b/drivers/staging/qlge/qlge_main.c
index 0a3809c50c10..03403718a273 100644
--- a/drivers/staging/qlge/qlge_main.c
+++ b/drivers/staging/qlge/qlge_main.c
@@ -1110,9 +1110,6 @@ static void ql_update_lbq(struct ql_adapter *qdev, struct rx_ring *rx_ring)
 			dma_unmap_addr_set(lbq_desc, mapaddr, map);
 			*lbq_desc->addr = cpu_to_le64(map);
 
-			pci_dma_sync_single_for_device(qdev->pdev, map,
-						       qdev->lbq_buf_size,
-						       PCI_DMA_FROMDEVICE);
 			clean_idx++;
 			if (clean_idx == rx_ring->lbq_len)
 				clean_idx = 0;
@@ -1598,10 +1595,6 @@ static void ql_process_mac_rx_skb(struct ql_adapter *qdev,
 
 	skb_put_data(new_skb, skb->data, length);
 
-	pci_dma_sync_single_for_device(qdev->pdev,
-				       dma_unmap_addr(sbq_desc, mapaddr),
-				       SMALL_BUF_MAP_SIZE,
-				       PCI_DMA_FROMDEVICE);
 	skb = new_skb;
 
 	/* Frame error, so drop the packet. */
@@ -1757,11 +1750,6 @@ static struct sk_buff *ql_build_rx_skb(struct ql_adapter *qdev,
 						    SMALL_BUF_MAP_SIZE,
 						    PCI_DMA_FROMDEVICE);
 			skb_put_data(skb, sbq_desc->p.skb->data, length);
-			pci_dma_sync_single_for_device(qdev->pdev,
-						       dma_unmap_addr(sbq_desc,
-								      mapaddr),
-						       SMALL_BUF_MAP_SIZE,
-						       PCI_DMA_FROMDEVICE);
 		} else {
 			netif_printk(qdev, rx_status, KERN_DEBUG, qdev->ndev,
 				     "%d bytes in a single small buffer.\n",
-- 
2.23.0

