Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 6777D623BA6
	for <lists+netdev@lfdr.de>; Thu, 10 Nov 2022 07:14:53 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232058AbiKJGOu (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 10 Nov 2022 01:14:50 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:37664 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229449AbiKJGOs (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 10 Nov 2022 01:14:48 -0500
Received: from szxga02-in.huawei.com (szxga02-in.huawei.com [45.249.212.188])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 5224D275FC;
        Wed,  9 Nov 2022 22:14:44 -0800 (PST)
Received: from canpemm500006.china.huawei.com (unknown [172.30.72.57])
        by szxga02-in.huawei.com (SkyGuard) with ESMTP id 4N7BPN3MsFzHvdV;
        Thu, 10 Nov 2022 14:14:16 +0800 (CST)
Received: from localhost.localdomain (10.175.104.82) by
 canpemm500006.china.huawei.com (7.192.105.130) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2375.31; Thu, 10 Nov 2022 14:14:41 +0800
From:   Ziyang Xuan <william.xuanziyang@huawei.com>
To:     <max@enpas.org>, <wg@grandegger.com>, <mkl@pengutronix.de>,
        <davem@davemloft.net>, <edumazet@google.com>, <kuba@kernel.org>,
        <pabeni@redhat.com>, <linux-can@vger.kernel.org>,
        <netdev@vger.kernel.org>
CC:     <linux-kernel@vger.kernel.org>
Subject: [PATCH] can: can327: fix potential skb leak when netdev is down
Date:   Thu, 10 Nov 2022 14:14:37 +0800
Message-ID: <20221110061437.411525-1-william.xuanziyang@huawei.com>
X-Mailer: git-send-email 2.25.1
MIME-Version: 1.0
Content-Transfer-Encoding: 7BIT
Content-Type:   text/plain; charset=US-ASCII
X-Originating-IP: [10.175.104.82]
X-ClientProxiedBy: dggems702-chm.china.huawei.com (10.3.19.179) To
 canpemm500006.china.huawei.com (7.192.105.130)
X-CFilter-Loop: Reflected
X-Spam-Status: No, score=-4.2 required=5.0 tests=BAYES_00,RCVD_IN_DNSWL_MED,
        SPF_HELO_NONE,SPF_PASS autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

In can327_feed_frame_to_netdev(), it did not free the skb when netdev
is down, and all callers of can327_feed_frame_to_netdev() did not free
allocated skb too. That would trigger skb leak.

Fix it by adding kfree_skb() in can327_feed_frame_to_netdev() when netdev
is down. Not tested, just compiled.

Fixes: 43da2f07622f ("can: can327: CAN/ldisc driver for ELM327 based OBD-II adapters")
Signed-off-by: Ziyang Xuan <william.xuanziyang@huawei.com>
---
 drivers/net/can/can327.c | 4 +++-
 1 file changed, 3 insertions(+), 1 deletion(-)

diff --git a/drivers/net/can/can327.c b/drivers/net/can/can327.c
index 0aa1af31d0fe..17bca63f3dd3 100644
--- a/drivers/net/can/can327.c
+++ b/drivers/net/can/can327.c
@@ -263,8 +263,10 @@ static void can327_feed_frame_to_netdev(struct can327 *elm, struct sk_buff *skb)
 {
 	lockdep_assert_held(&elm->lock);
 
-	if (!netif_running(elm->dev))
+	if (!netif_running(elm->dev)) {
+		kfree_skb(skb);
 		return;
+	}
 
 	/* Queue for NAPI pickup.
 	 * rx-offload will update stats and LEDs for us.
-- 
2.25.1

