Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 7300D6E076C
	for <lists+netdev@lfdr.de>; Thu, 13 Apr 2023 09:14:49 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229742AbjDMHOq (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 13 Apr 2023 03:14:46 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:34330 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229579AbjDMHOp (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 13 Apr 2023 03:14:45 -0400
Received: from m12.mail.163.com (m12.mail.163.com [220.181.12.214])
        by lindbergh.monkeyblade.net (Postfix) with ESMTP id 206F14C19;
        Thu, 13 Apr 2023 00:14:43 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=163.com;
        s=s110527; h=From:Subject:Date:Message-Id:MIME-Version; bh=J68ms
        hiUh+tWg8G3Lc53Yvgg2fGvMvWtMKcuYE3nO5I=; b=HYlqsnyLgt0bx1UIy1aiM
        wH6Co+vP7KviGJW3OVaGOAMb5Jz78biTlarSH91awvBVN6DOoOQTErvQA23S11SS
        KYe8XTHds+cg+cZQHqth+V1JTQG3q7n67l2ltf26CyrxGbZF+o3LiTd4RzORTSAi
        YRIlr/WWIq4+sQh2XrhQQU=
Received: from leanderwang-LC2.localdomain (unknown [111.206.145.21])
        by zwqz-smtp-mta-g4-1 (Coremail) with SMTP id _____wDXGOy7qzdkZEIsBQ--.1078S2;
        Thu, 13 Apr 2023 15:14:03 +0800 (CST)
From:   Zheng Wang <zyytlz.wz@163.com>
To:     davem@davemloft.net
Cc:     edumazet@google.com, kuba@kernel.org, pabeni@redhat.com,
        netdev@vger.kernel.org, linux-kernel@vger.kernel.org,
        hackerzheng666@gmail.com, 1395428693sheep@gmail.com,
        alex000young@gmail.com, Zheng Wang <zyytlz.wz@163.com>
Subject: [PATCH net v2] net: ethernet: fix use after free bug in ns83820_remove_one due to race condition
Date:   Thu, 13 Apr 2023 15:14:01 +0800
Message-Id: <20230413071401.210599-1-zyytlz.wz@163.com>
X-Mailer: git-send-email 2.25.1
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-CM-TRANSID: _____wDXGOy7qzdkZEIsBQ--.1078S2
X-Coremail-Antispam: 1Uf129KBjvJXoW7AFykCw1xJr1UWw47Zr1DZFb_yoW8Xw1rp3
        90kFyfuF1ktw4UWw1UJr40qry5XFs8t3yYgayIyw4avas5Zr4vgF4UKFWUZr18GrWqvr4f
        Aw45Zw43uas8ZaDanT9S1TB71UUUUUUqnTZGkaVYY2UrUUUUjbIjqfuFe4nvWSU5nxnvy2
        9KBjDUYxBIdaVFxhVjvjDU0xZFpf9x0ziFAprUUUUU=
X-Originating-IP: [111.206.145.21]
X-CM-SenderInfo: h2113zf2oz6qqrwthudrp/1tbiGg1QU1aEE4gpSgAEs6
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,FREEMAIL_FROM,RCVD_IN_MSPIKE_H2,
        SPF_HELO_NONE,SPF_PASS autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

In ns83820_init_one, dev->tq_refill was bound with queue_refill.

If irq happens, it will call ns83820_irq->ns83820_do_isr.
Then it invokes tasklet_schedule(&dev->rx_tasklet) to start
rx_action function. And rx_action will call ns83820_rx_kick
and finally start queue_refill function.

If we remove the driver without finishing the work, there
may be a race condition between ndev, which may cause UAF
bug.

CPU0                  CPU1

                     |queue_refill
ns83820_remove_one   |
free_netdev	 		 |
put_device			 |
free ndev			 |
                     |rx_refill
                     |//use ndev

Fixes: 1da177e4c3f4 ("Linux-2.6.12-rc2")
Signed-off-by: Zheng Wang <zyytlz.wz@163.com>
---
v2:
- cancel the work after unregister_netdev to make sure there 
is no more request suggested by Jakub Kicinski
---
 drivers/net/ethernet/natsemi/ns83820.c | 5 +++++
 1 file changed, 5 insertions(+)

diff --git a/drivers/net/ethernet/natsemi/ns83820.c b/drivers/net/ethernet/natsemi/ns83820.c
index 998586872599..2e84b9fcd8e9 100644
--- a/drivers/net/ethernet/natsemi/ns83820.c
+++ b/drivers/net/ethernet/natsemi/ns83820.c
@@ -2208,8 +2208,13 @@ static void ns83820_remove_one(struct pci_dev *pci_dev)
 
 	ns83820_disable_interrupts(dev); /* paranoia */
 
+	netif_carrier_off(ndev);
+	netif_tx_disable(ndev);
+
 	unregister_netdev(ndev);
 	free_irq(dev->pci_dev->irq, ndev);
+	cancel_work_sync(&dev->tq_refill);
+
 	iounmap(dev->base);
 	dma_free_coherent(&dev->pci_dev->dev, 4 * DESC_SIZE * NR_TX_DESC,
 			  dev->tx_descs, dev->tx_phy_descs);
-- 
2.25.1

