Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id BB17E644871
	for <lists+netdev@lfdr.de>; Tue,  6 Dec 2022 16:55:28 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233419AbiLFPz1 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 6 Dec 2022 10:55:27 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:42898 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232849AbiLFPzZ (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 6 Dec 2022 10:55:25 -0500
Received: from szxga03-in.huawei.com (szxga03-in.huawei.com [45.249.212.189])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id DDC80389F
        for <netdev@vger.kernel.org>; Tue,  6 Dec 2022 07:55:24 -0800 (PST)
Received: from dggpemm500007.china.huawei.com (unknown [172.30.72.54])
        by szxga03-in.huawei.com (SkyGuard) with ESMTP id 4NRPzs09WgzJp6v;
        Tue,  6 Dec 2022 23:51:53 +0800 (CST)
Received: from huawei.com (10.175.103.91) by dggpemm500007.china.huawei.com
 (7.185.36.183) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id 15.1.2375.31; Tue, 6 Dec
 2022 23:55:22 +0800
From:   Yang Yingliang <yangyingliang@huawei.com>
To:     <netdev@vger.kernel.org>
CC:     <davem@davemloft.net>, <edumazet@google.com>, <kuba@kernel.org>,
        <pabeni@redhat.com>
Subject: [PATCH net 1/2] net: apple: mace: don't call dev_kfree_skb() under spin_lock_irqsave()
Date:   Tue, 6 Dec 2022 23:53:08 +0800
Message-ID: <20221206155309.2326167-1-yangyingliang@huawei.com>
X-Mailer: git-send-email 2.25.1
MIME-Version: 1.0
Content-Transfer-Encoding: 7BIT
Content-Type:   text/plain; charset=US-ASCII
X-Originating-IP: [10.175.103.91]
X-ClientProxiedBy: dggems705-chm.china.huawei.com (10.3.19.182) To
 dggpemm500007.china.huawei.com (7.185.36.183)
X-CFilter-Loop: Reflected
X-Spam-Status: No, score=-4.2 required=5.0 tests=BAYES_00,RCVD_IN_DNSWL_MED,
        SPF_HELO_NONE,SPF_PASS autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

It is not allowed to call consume_skb() from hardware interrupt context
or with interrupts being disabled. So replace dev_kfree_skb() with
dev_consume_skb_irq() under spin_lock_irqsave().

Signed-off-by: Yang Yingliang <yangyingliang@huawei.com>
---
 drivers/net/ethernet/apple/mace.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/net/ethernet/apple/mace.c b/drivers/net/ethernet/apple/mace.c
index d0a771b65e88..77b4ed05140b 100644
--- a/drivers/net/ethernet/apple/mace.c
+++ b/drivers/net/ethernet/apple/mace.c
@@ -846,7 +846,7 @@ static void mace_tx_timeout(struct timer_list *t)
     if (mp->tx_bad_runt) {
 	mp->tx_bad_runt = 0;
     } else if (i != mp->tx_fill) {
-	dev_kfree_skb(mp->tx_bufs[i]);
+	dev_consume_skb_irq(mp->tx_bufs[i]);
 	if (++i >= N_TX_RING)
 	    i = 0;
 	mp->tx_empty = i;
-- 
2.25.1

