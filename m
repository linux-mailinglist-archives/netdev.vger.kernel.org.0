Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 105CF6471B6
	for <lists+netdev@lfdr.de>; Thu,  8 Dec 2022 15:26:28 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230037AbiLHO0R (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 8 Dec 2022 09:26:17 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:48890 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230210AbiLHOZb (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 8 Dec 2022 09:25:31 -0500
Received: from szxga02-in.huawei.com (szxga02-in.huawei.com [45.249.212.188])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 873DD934F6
        for <netdev@vger.kernel.org>; Thu,  8 Dec 2022 06:24:45 -0800 (PST)
Received: from dggpemm500007.china.huawei.com (unknown [172.30.72.56])
        by szxga02-in.huawei.com (SkyGuard) with ESMTP id 4NSbxP5fNHzJqPK;
        Thu,  8 Dec 2022 22:23:53 +0800 (CST)
Received: from huawei.com (10.175.103.91) by dggpemm500007.china.huawei.com
 (7.185.36.183) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id 15.1.2375.31; Thu, 8 Dec
 2022 22:24:42 +0800
From:   Yang Yingliang <yangyingliang@huawei.com>
To:     <netdev@vger.kernel.org>
CC:     <davem@davemloft.net>, <edumazet@google.com>, <kuba@kernel.org>,
        <pabeni@redhat.com>, <leon@kernel.org>,
        Yang Yingliang <yangyingliang@huawei.com>,
        Michal Simek <michal.simek@xilinx.com>,
        John Linn <john.linn@xilinx.com>,
        Sadanand M <sadanan@xilinx.com>,
        Harini Katakam <harinikatakamlinux@gmail.com>,
        <linux-arm-kernel@lists.infradead.org>
Subject: [PATCH net v3 1/4] net: emaclite: don't call dev_kfree_skb() under spin_lock_irqsave()
Date:   Thu, 8 Dec 2022 22:21:44 +0800
Message-ID: <20221208142147.2376671-2-yangyingliang@huawei.com>
X-Mailer: git-send-email 2.25.1
In-Reply-To: <20221208142147.2376671-1-yangyingliang@huawei.com>
References: <20221208142147.2376671-1-yangyingliang@huawei.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 7BIT
Content-Type:   text/plain; charset=US-ASCII
X-Originating-IP: [10.175.103.91]
X-ClientProxiedBy: dggems704-chm.china.huawei.com (10.3.19.181) To
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

In this case, dev_kfree_skb() is called in xemaclite_tx_timeout() to
drop the SKB, when tx timeout, so replace it with dev_kfree_skb_irq().

Fixes: bb81b2ddfa19 ("net: add Xilinx emac lite device driver")
Signed-off-by: Yang Yingliang <yangyingliang@huawei.com>
---
 drivers/net/ethernet/xilinx/xilinx_emaclite.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/net/ethernet/xilinx/xilinx_emaclite.c b/drivers/net/ethernet/xilinx/xilinx_emaclite.c
index a3967f8de417..a1e1387ea84e 100644
--- a/drivers/net/ethernet/xilinx/xilinx_emaclite.c
+++ b/drivers/net/ethernet/xilinx/xilinx_emaclite.c
@@ -536,7 +536,7 @@ static void xemaclite_tx_timeout(struct net_device *dev, unsigned int txqueue)
 	xemaclite_enable_interrupts(lp);
 
 	if (lp->deferred_skb) {
-		dev_kfree_skb(lp->deferred_skb);
+		dev_kfree_skb_irq(lp->deferred_skb);
 		lp->deferred_skb = NULL;
 		dev->stats.tx_errors++;
 	}
-- 
2.25.1

