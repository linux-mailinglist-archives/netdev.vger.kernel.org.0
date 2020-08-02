Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 5900E235616
	for <lists+netdev@lfdr.de>; Sun,  2 Aug 2020 11:16:33 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727116AbgHBJQ2 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sun, 2 Aug 2020 05:16:28 -0400
Received: from zg8tmja5ljk3lje4mi4ymjia.icoremail.net ([209.97.182.222]:46932
        "HELO zg8tmja5ljk3lje4mi4ymjia.icoremail.net" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with SMTP id S1726376AbgHBJQ1 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sun, 2 Aug 2020 05:16:27 -0400
Received: from oslab.tsinghua.edu.cn (unknown [166.111.139.112])
        by app-4 (Coremail) with SMTP id EgQGZQDn79NehCZfxLnkAw--.3380S2;
        Sun, 02 Aug 2020 17:16:19 +0800 (CST)
From:   Jia-Ju Bai <baijiaju@tsinghua.edu.cn>
To:     3chas3@gmail.com
Cc:     linux-atm-general@lists.sourceforge.net, netdev@vger.kernel.org,
        linux-kernel@vger.kernel.org, Jia-Ju Bai <baijiaju@tsinghua.edu.cn>
Subject: [PATCH] atm: eni: avoid accessing the data mapped to streaming DMA
Date:   Sun,  2 Aug 2020 17:16:11 +0800
Message-Id: <20200802091611.24331-1-baijiaju@tsinghua.edu.cn>
X-Mailer: git-send-email 2.17.1
X-CM-TRANSID: EgQGZQDn79NehCZfxLnkAw--.3380S2
X-Coremail-Antispam: 1UD129KBjvJXoW7WF1DKrWrtrW5uw1UJr1rtFb_yoW8ArWkpF
        yxGas0krW0qFyUta4vg3y5XrWIvayktryagFyYk3srZan8XF1F9ry8GFW8tr10ka4fGr1j
        vwn5XryFgw1Dt3DanT9S1TB71UUUUUUqnTZGkaVYY2UrUUUUjbIjqfuFe4nvWSU5nxnvy2
        9KBjDU0xBIdaVrnRJUUUkS14x267AKxVWUJVW8JwAFc2x0x2IEx4CE42xK8VAvwI8IcIk0
        rVWrJVCq3wAFIxvE14AKwVWUJVWUGwA2ocxC64kIII0Yj41l84x0c7CEw4AK67xGY2AK02
        1l84ACjcxK6xIIjxv20xvE14v26ryj6F1UM28EF7xvwVC0I7IYx2IY6xkF7I0E14v26r4j
        6F4UM28EF7xvwVC2z280aVAFwI0_GcCE3s1l84ACjcxK6I8E87Iv6xkF7I0E14v26rxl6s
        0DM2AIxVAIcxkEcVAq07x20xvEncxIr21l5I8CrVACY4xI64kE6c02F40Ex7xfMcIj6xII
        jxv20xvE14v26r1Y6r17McIj6I8E87Iv67AKxVWUJVW8JwAm72CE4IkC6x0Yz7v_Jr0_Gr
        1lF7xvr2IYc2Ij64vIr41lF7I21c0EjII2zVCS5cI20VAGYxC7MxkIecxEwVAFwVW8uwCF
        04k20xvY0x0EwIxGrwCFx2IqxVCFs4IE7xkEbVWUJVW8JwC20s026c02F40E14v26r1j6r
        18MI8I3I0E7480Y4vE14v26r106r1rMI8E67AF67kF1VAFwI0_JF0_Jw1lIxkGc2Ij64vI
        r41lIxAIcVC0I7IYx2IY67AKxVWUJVWUCwCI42IY6xIIjxv20xvEc7CjxVAFwI0_Jr0_Gr
        1lIxAIcVCF04k26cxKx2IYs7xG6rW3Jr0E3s1lIxAIcVC2z280aVAFwI0_Jr0_Gr1lIxAI
        cVC2z280aVCY1x0267AKxVWUJVW8JbIYCTnIWIevJa73UjIFyTuYvjfUn89NUUUUU
X-CM-SenderInfo: xedlyxhdmxq3pvlqwxlxdovvfxof0/
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

In do_tx(), skb->data is mapped to streaming DMA on line 1111:
  paddr = dma_map_single(...,skb->data,DMA_TO_DEVICE);

Then skb->data is accessed on line 1153:
  (skb->data[3] & 0xf)

This access may cause data inconsistency between CPU cache and hardware.

To fix this problem, skb->data[3] is assigned to a local variable before
DMA mapping, and then the driver accesses this local variable instead of
skb->data[3].

Signed-off-by: Jia-Ju Bai <baijiaju@tsinghua.edu.cn>
---
 drivers/atm/eni.c | 4 +++-
 1 file changed, 3 insertions(+), 1 deletion(-)

diff --git a/drivers/atm/eni.c b/drivers/atm/eni.c
index 17d47ad03ab7..09f4e2f41363 100644
--- a/drivers/atm/eni.c
+++ b/drivers/atm/eni.c
@@ -1034,6 +1034,7 @@ static enum enq_res do_tx(struct sk_buff *skb)
 	u32 dma_rd,dma_wr;
 	u32 size; /* in words */
 	int aal5,dma_size,i,j;
+	unsigned char skb_data3;
 
 	DPRINTK(">do_tx\n");
 	NULLCHECK(skb);
@@ -1108,6 +1109,7 @@ DPRINTK("iovcnt = %d\n",skb_shinfo(skb)->nr_frags);
 		    vcc->dev->number);
 		return enq_jam;
 	}
+	skb_data3 = skb->data[3];
 	paddr = dma_map_single(&eni_dev->pci_dev->dev,skb->data,skb->len,
 			       DMA_TO_DEVICE);
 	ENI_PRV_PADDR(skb) = paddr;
@@ -1150,7 +1152,7 @@ DPRINTK("doing direct send\n"); /* @@@ well, this doesn't work anyway */
 	    (size/(ATM_CELL_PAYLOAD/4)),tx->send+tx->tx_pos*4);
 /*printk("dsc = 0x%08lx\n",(unsigned long) readl(tx->send+tx->tx_pos*4));*/
 	writel((vcc->vci << MID_SEG_VCI_SHIFT) |
-            (aal5 ? 0 : (skb->data[3] & 0xf)) |
+            (aal5 ? 0 : (skb_data3 & 0xf)) |
 	    (ATM_SKB(skb)->atm_options & ATM_ATMOPT_CLP ? MID_SEG_CLP : 0),
 	    tx->send+((tx->tx_pos+1) & (tx->words-1))*4);
 	DPRINTK("size: %d, len:%d\n",size,skb->len);
-- 
2.17.1

