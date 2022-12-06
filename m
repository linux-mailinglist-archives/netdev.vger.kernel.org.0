Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 898EA64486C
	for <lists+netdev@lfdr.de>; Tue,  6 Dec 2022 16:54:01 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231756AbiLFPx7 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 6 Dec 2022 10:53:59 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:42158 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229780AbiLFPx5 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 6 Dec 2022 10:53:57 -0500
Received: from szxga02-in.huawei.com (szxga02-in.huawei.com [45.249.212.188])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 974BC388C
        for <netdev@vger.kernel.org>; Tue,  6 Dec 2022 07:53:54 -0800 (PST)
Received: from dggpemm500007.china.huawei.com (unknown [172.30.72.56])
        by szxga02-in.huawei.com (SkyGuard) with ESMTP id 4NRQ163GdzzFpxJ;
        Tue,  6 Dec 2022 23:52:58 +0800 (CST)
Received: from huawei.com (10.175.103.91) by dggpemm500007.china.huawei.com
 (7.185.36.183) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id 15.1.2375.31; Tue, 6 Dec
 2022 23:53:45 +0800
From:   Yang Yingliang <yangyingliang@huawei.com>
To:     <netdev@vger.kernel.org>
CC:     <jdmason@kudzu.us>, <davem@davemloft.net>, <edumazet@google.com>,
        <kuba@kernel.org>, <pabeni@redhat.com>
Subject: [PATCH net] ethernet: s2io: don't call dev_kfree_skb() under spin_lock_irqsave()
Date:   Tue, 6 Dec 2022 23:51:34 +0800
Message-ID: <20221206155134.2325115-1-yangyingliang@huawei.com>
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
+				dev_consume_skb_irq(skb);
 				cnt++;
 			}
 		}
-- 
2.25.1

