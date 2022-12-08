Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 7BBCA646BD8
	for <lists+netdev@lfdr.de>; Thu,  8 Dec 2022 10:26:35 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229643AbiLHJ0d (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 8 Dec 2022 04:26:33 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:56066 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229543AbiLHJ0b (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 8 Dec 2022 04:26:31 -0500
Received: from szxga03-in.huawei.com (szxga03-in.huawei.com [45.249.212.189])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id C27955D6A1
        for <netdev@vger.kernel.org>; Thu,  8 Dec 2022 01:26:30 -0800 (PST)
Received: from dggpemm500007.china.huawei.com (unknown [172.30.72.55])
        by szxga03-in.huawei.com (SkyGuard) with ESMTP id 4NSTG91fjVzJpCK;
        Thu,  8 Dec 2022 17:22:57 +0800 (CST)
Received: from huawei.com (10.175.103.91) by dggpemm500007.china.huawei.com
 (7.185.36.183) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id 15.1.2375.31; Thu, 8 Dec
 2022 17:26:28 +0800
From:   Yang Yingliang <yangyingliang@huawei.com>
To:     <netdev@vger.kernel.org>
CC:     <jdmason@kudzu.us>, <davem@davemloft.net>, <edumazet@google.com>,
        <kuba@kernel.org>, <pabeni@redhat.com>, <leon@kernel.org>
Subject: [PATCH net v3] ethernet: s2io: don't call dev_kfree_skb() under spin_lock_irqsave()
Date:   Thu, 8 Dec 2022 17:24:11 +0800
Message-ID: <20221208092411.1961448-1-yangyingliang@huawei.com>
X-Mailer: git-send-email 2.25.1
MIME-Version: 1.0
Content-Transfer-Encoding: 7BIT
Content-Type:   text/plain; charset=US-ASCII
X-Originating-IP: [10.175.103.91]
X-ClientProxiedBy: dggems706-chm.china.huawei.com (10.3.19.183) To
 dggpemm500007.china.huawei.com (7.185.36.183)
X-CFilter-Loop: Reflected
X-Spam-Status: No, score=-4.2 required=5.0 tests=BAYES_00,RCVD_IN_DNSWL_MED,
        SPF_HELO_NONE,SPF_PASS autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

The dev_kfree_skb() is defined as consume_skb(), and it is not allowed
to call consume_skb() from hardware interrupt context or with interrupts
being disabled. So replace dev_kfree_skb() with dev_consume_skb_irq()
under spin_lock_irqsave().

Fixes: 1da177e4c3f4 ("Linux-2.6.12-rc2")
Signed-off-by: Yang Yingliang <yangyingliang@huawei.com>
---
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
+				dev_consume_skb_irq(skb);
 				cnt++;
 			}
 		}
-- 
2.25.1

