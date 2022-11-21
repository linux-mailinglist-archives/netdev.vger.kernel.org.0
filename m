Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id EA6976318F2
	for <lists+netdev@lfdr.de>; Mon, 21 Nov 2022 04:34:28 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229547AbiKUDe0 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sun, 20 Nov 2022 22:34:26 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:36640 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229455AbiKUDeZ (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sun, 20 Nov 2022 22:34:25 -0500
Received: from szxga01-in.huawei.com (szxga01-in.huawei.com [45.249.212.187])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 7F8BA2A72F
        for <netdev@vger.kernel.org>; Sun, 20 Nov 2022 19:34:24 -0800 (PST)
Received: from dggpeml500024.china.huawei.com (unknown [172.30.72.57])
        by szxga01-in.huawei.com (SkyGuard) with ESMTP id 4NFtFL09dLzqSPT;
        Mon, 21 Nov 2022 11:30:30 +0800 (CST)
Received: from huawei.com (10.175.112.208) by dggpeml500024.china.huawei.com
 (7.185.36.10) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id 15.1.2375.31; Mon, 21 Nov
 2022 11:34:22 +0800
From:   Yuan Can <yuancan@huawei.com>
To:     <davem@davemloft.net>, <edumazet@google.com>, <kuba@kernel.org>,
        <pabeni@redhat.com>, <sfr@canb.auug.org.au>, <error27@gmail.com>,
        <bigeasy@linutronix.de>, <colin.i.king@gmail.com>,
        <yang.lee@linux.alibaba.com>, <josright123@gmail.com>,
        <netdev@vger.kernel.org>
CC:     <yuancan@huawei.com>
Subject: [PATCH] net: dm9051: Fix missing dev_kfree_skb() in dm9051_loop_rx()
Date:   Mon, 21 Nov 2022 03:32:26 +0000
Message-ID: <20221121033226.91461-1-yuancan@huawei.com>
X-Mailer: git-send-email 2.17.1
MIME-Version: 1.0
Content-Type: text/plain
X-Originating-IP: [10.175.112.208]
X-ClientProxiedBy: dggems704-chm.china.huawei.com (10.3.19.181) To
 dggpeml500024.china.huawei.com (7.185.36.10)
X-CFilter-Loop: Reflected
X-Spam-Status: No, score=-4.2 required=5.0 tests=BAYES_00,RCVD_IN_DNSWL_MED,
        SPF_HELO_NONE,SPF_PASS autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

The dm9051_loop_rx() returns without release skb when dm9051_stop_mrcmd()
returns error, free the skb to avoid this leak.

Fixes: 2dc95a4d30ed ("net: Add dm9051 driver")
Signed-off-by: Yuan Can <yuancan@huawei.com>
---
 drivers/net/ethernet/davicom/dm9051.c | 4 +++-
 1 file changed, 3 insertions(+), 1 deletion(-)

diff --git a/drivers/net/ethernet/davicom/dm9051.c b/drivers/net/ethernet/davicom/dm9051.c
index a523ddda7609..de7105a84747 100644
--- a/drivers/net/ethernet/davicom/dm9051.c
+++ b/drivers/net/ethernet/davicom/dm9051.c
@@ -798,8 +798,10 @@ static int dm9051_loop_rx(struct board_info *db)
 		}
 
 		ret = dm9051_stop_mrcmd(db);
-		if (ret)
+		if (ret) {
+			dev_kfree_skb(skb);
 			return ret;
+		}
 
 		skb->protocol = eth_type_trans(skb, db->ndev);
 		if (db->ndev->features & NETIF_F_RXCSUM)
-- 
2.17.1

