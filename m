Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 47654645142
	for <lists+netdev@lfdr.de>; Wed,  7 Dec 2022 02:32:56 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229750AbiLGBcy (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 6 Dec 2022 20:32:54 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:50302 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229538AbiLGBcw (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 6 Dec 2022 20:32:52 -0500
Received: from szxga08-in.huawei.com (szxga08-in.huawei.com [45.249.212.255])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 4AEA13056A
        for <netdev@vger.kernel.org>; Tue,  6 Dec 2022 17:32:51 -0800 (PST)
Received: from dggpemm500007.china.huawei.com (unknown [172.30.72.56])
        by szxga08-in.huawei.com (SkyGuard) with ESMTP id 4NRfsD72B9z15N9p;
        Wed,  7 Dec 2022 09:32:00 +0800 (CST)
Received: from huawei.com (10.175.103.91) by dggpemm500007.china.huawei.com
 (7.185.36.183) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id 15.1.2375.31; Wed, 7 Dec
 2022 09:32:18 +0800
From:   Yang Yingliang <yangyingliang@huawei.com>
To:     <netdev@vger.kernel.org>
CC:     <davem@davemloft.net>, <edumazet@google.com>, <kuba@kernel.org>,
        <pabeni@redhat.com>
Subject: [PATCH net v2 2/2] net: apple: bmac: don't call dev_kfree_skb() under spin_lock_irqsave()
Date:   Wed, 7 Dec 2022 09:29:59 +0800
Message-ID: <20221207012959.2800421-2-yangyingliang@huawei.com>
X-Mailer: git-send-email 2.25.1
In-Reply-To: <20221207012959.2800421-1-yangyingliang@huawei.com>
References: <20221207012959.2800421-1-yangyingliang@huawei.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 7BIT
Content-Type:   text/plain; charset=US-ASCII
X-Originating-IP: [10.175.103.91]
X-ClientProxiedBy: dggems702-chm.china.huawei.com (10.3.19.179) To
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

Fixes: 1da177e4c3f4 ("Linux-2.6.12-rc2")
Signed-off-by: Yang Yingliang <yangyingliang@huawei.com>
---
v1 -> v2:
  Add a fix tag.
---
 drivers/net/ethernet/apple/bmac.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/net/ethernet/apple/bmac.c b/drivers/net/ethernet/apple/bmac.c
index 334de0d93c89..3e6a629bcf21 100644
--- a/drivers/net/ethernet/apple/bmac.c
+++ b/drivers/net/ethernet/apple/bmac.c
@@ -1510,7 +1510,7 @@ static void bmac_tx_timeout(struct timer_list *t)
 	i = bp->tx_empty;
 	++dev->stats.tx_errors;
 	if (i != bp->tx_fill) {
-		dev_kfree_skb(bp->tx_bufs[i]);
+		dev_consume_skb_irq(bp->tx_bufs[i]);
 		bp->tx_bufs[i] = NULL;
 		if (++i >= N_TX_RING) i = 0;
 		bp->tx_empty = i;
-- 
2.25.1

