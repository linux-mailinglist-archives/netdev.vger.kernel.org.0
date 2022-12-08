Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 78C9C646F3A
	for <lists+netdev@lfdr.de>; Thu,  8 Dec 2022 13:04:36 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229810AbiLHMEe (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 8 Dec 2022 07:04:34 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:53606 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229719AbiLHMEc (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 8 Dec 2022 07:04:32 -0500
Received: from szxga02-in.huawei.com (szxga02-in.huawei.com [45.249.212.188])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 6A72384DDB
        for <netdev@vger.kernel.org>; Thu,  8 Dec 2022 04:04:31 -0800 (PST)
Received: from dggpemm500007.china.huawei.com (unknown [172.30.72.56])
        by szxga02-in.huawei.com (SkyGuard) with ESMTP id 4NSXqb4XZTzJqLF;
        Thu,  8 Dec 2022 20:03:39 +0800 (CST)
Received: from huawei.com (10.175.103.91) by dggpemm500007.china.huawei.com
 (7.185.36.183) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id 15.1.2375.31; Thu, 8 Dec
 2022 20:04:13 +0800
From:   Yang Yingliang <yangyingliang@huawei.com>
To:     <netdev@vger.kernel.org>
CC:     <jdmason@kudzu.us>, <davem@davemloft.net>, <edumazet@google.com>,
        <kuba@kernel.org>, <pabeni@redhat.com>, <leon@kernel.org>
Subject: [PATCH net v4] ethernet: s2io: don't call dev_kfree_skb() under spin_lock_irqsave()
Date:   Thu, 8 Dec 2022 20:01:21 +0800
Message-ID: <20221208120121.2076486-1-yangyingliang@huawei.com>
X-Mailer: git-send-email 2.25.1
MIME-Version: 1.0
Content-Transfer-Encoding: 7BIT
Content-Type:   text/plain; charset=US-ASCII
X-Originating-IP: [10.175.103.91]
X-ClientProxiedBy: dggems703-chm.china.huawei.com (10.3.19.180) To
 dggpemm500007.china.huawei.com (7.185.36.183)
X-CFilter-Loop: Reflected
X-Spam-Status: No, score=-4.2 required=5.0 tests=BAYES_00,RCVD_IN_DNSWL_MED,
        SPF_HELO_NONE,SPF_PASS autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

It is not allowed to call kfree_skb() or consume_skb() from hardware
interrupt context or with hardware interrupts being disabled.

It should use dev_kfree_skb_irq() or dev_consume_skb_irq() instead.
The difference between them is free reason, dev_kfree_skb_irq() means
the SKB is dropped in error and dev_consume_skb_irq() means the SKB
is consumed in normal.

In this case, dev_kfree_skb() is called in free_tx_buffers() to drop
the SKBs in tx buffers, when the card is down, so replace it with
dev_kfree_skb_irq() here.

Fixes: 1da177e4c3f4 ("Linux-2.6.12-rc2")
Signed-off-by: Yang Yingliang <yangyingliang@huawei.com>
---
v4 -> v3:
  Update commit message, and change to use dev_kfree_skb_irq().

v2 -> v3:
  Update commit message.

v1 -> v2:
  Add fix tag.
---
 drivers/net/ethernet/neterion/s2io.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/net/ethernet/neterion/s2io.c b/drivers/net/ethernet/neterion/s2io.c
index 1d3c4474b7cb..a83d61d45936 100644
--- a/drivers/net/ethernet/neterion/s2io.c
+++ b/drivers/net/ethernet/neterion/s2io.c
@@ -2386,7 +2386,7 @@ static void free_tx_buffers(struct s2io_nic *nic)
 			skb = s2io_txdl_getskb(&mac_control->fifos[i], txdp, j);
 			if (skb) {
 				swstats->mem_freed += skb->truesize;
-				dev_kfree_skb(skb);
+				dev_kfree_skb_irq(skb);
 				cnt++;
 			}
 		}
-- 
2.25.1

