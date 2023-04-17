Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 373526E3D34
	for <lists+netdev@lfdr.de>; Mon, 17 Apr 2023 03:36:58 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229588AbjDQBcE (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sun, 16 Apr 2023 21:32:04 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:34984 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229461AbjDQBcC (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sun, 16 Apr 2023 21:32:02 -0400
Received: from m12.mail.163.com (m12.mail.163.com [220.181.12.196])
        by lindbergh.monkeyblade.net (Postfix) with ESMTP id 22AFA1FFF;
        Sun, 16 Apr 2023 18:31:59 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=163.com;
        s=s110527; h=From:Subject:Date:Message-Id:MIME-Version; bh=QuIf/
        EYEkw8pplucBBff2qSL7WeM9vg3Fx4DkoCPDsc=; b=Zo+eOOiSG0uhBtb+QiEca
        uipm2Z9k+EX9Q19BokpUNco/HlZNmspY8Ljr77qz+unmgMFthuCzg27hXY3gst4G
        MQI0C90JnE6s0dhXafDtjcjn9OCxBNK71MJZhReVAPDqlqTqwZdm0SjKfhNS7m0M
        DvQHd5uX9PRGF7aNIjgBO8=
Received: from leanderwang-LC2.localdomain (unknown [111.206.145.21])
        by zwqz-smtp-mta-g2-3 (Coremail) with SMTP id _____wBnGyBcoTxkaj2bBg--.41108S2;
        Mon, 17 Apr 2023 09:31:09 +0800 (CST)
From:   Zheng Wang <zyytlz.wz@163.com>
To:     davem@davemloft.net
Cc:     horatiu.vultur@microchip.com, edumazet@google.com, kuba@kernel.org,
        pabeni@redhat.com, netdev@vger.kernel.org,
        linux-kernel@vger.kernel.org, hackerzheng666@gmail.com,
        1395428693sheep@gmail.com, alex000young@gmail.com,
        Zheng Wang <zyytlz.wz@163.com>
Subject: [PATCH net v3] net: ethernet: fix use after free bug in ns83820_remove_one  due to race condition
Date:   Mon, 17 Apr 2023 09:31:07 +0800
Message-Id: <20230417013107.360888-1-zyytlz.wz@163.com>
X-Mailer: git-send-email 2.25.1
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-CM-TRANSID: _____wBnGyBcoTxkaj2bBg--.41108S2
X-Coremail-Antispam: 1Uf129KBjvJXoW7AFykCw1xJr1UWw47Zr1DZFb_yoW8Ww1rp3
        yYkaySkr1kJw4jgr18Jr40qry5Xrs8t3yjgayIy34avas5Zr4vgF4UKFWUZr18GrWqvF4f
        Aw4UZw43u3Z8ZFJanT9S1TB71UUUUUUqnTZGkaVYY2UrUUUUjbIjqfuFe4nvWSU5nxnvy2
        9KBjDUYxBIdaVFxhVjvjDU0xZFpf9x0ziaZXrUUUUU=
X-Originating-IP: [111.206.145.21]
X-CM-SenderInfo: h2113zf2oz6qqrwthudrp/1tbiXR1UU1WBpQu3oAAAsq
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,FREEMAIL_FROM,RCVD_IN_MSPIKE_H2,
        SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE autolearn=ham
        autolearn_force=no version=3.4.6
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
v3:
- add tasklet_kill to stop more task scheduling suggested by
Horatiu Vultur
v2:
- cancel the work after unregister_netdev to make sure there
is no more request suggested by Jakub Kicinski
---
 drivers/net/ethernet/natsemi/ns83820.c | 6 ++++++
 1 file changed, 6 insertions(+)

diff --git a/drivers/net/ethernet/natsemi/ns83820.c b/drivers/net/ethernet/natsemi/ns83820.c
index 998586872599..af597719795d 100644
--- a/drivers/net/ethernet/natsemi/ns83820.c
+++ b/drivers/net/ethernet/natsemi/ns83820.c
@@ -2208,8 +2208,14 @@ static void ns83820_remove_one(struct pci_dev *pci_dev)
 
 	ns83820_disable_interrupts(dev); /* paranoia */
 
+	netif_carrier_off(ndev);
+	netif_tx_disable(ndev);
+
 	unregister_netdev(ndev);
 	free_irq(dev->pci_dev->irq, ndev);
+	tasklet_kill(&dev->rx_tasklet);
+	cancel_work_sync(&dev->tq_refill);
+
 	iounmap(dev->base);
 	dma_free_coherent(&dev->pci_dev->dev, 4 * DESC_SIZE * NR_TX_DESC,
 			  dev->tx_descs, dev->tx_phy_descs);
-- 
2.25.1

