Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 8EBDC5B12C6
	for <lists+netdev@lfdr.de>; Thu,  8 Sep 2022 05:05:06 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229970AbiIHDEm (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 7 Sep 2022 23:04:42 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:42830 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229651AbiIHDEg (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 7 Sep 2022 23:04:36 -0400
Received: from szxga02-in.huawei.com (szxga02-in.huawei.com [45.249.212.188])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 1B92655A1;
        Wed,  7 Sep 2022 20:04:28 -0700 (PDT)
Received: from canpemm500006.china.huawei.com (unknown [172.30.72.55])
        by szxga02-in.huawei.com (SkyGuard) with ESMTP id 4MNP5H0zwfzmVFG;
        Thu,  8 Sep 2022 11:00:51 +0800 (CST)
Received: from localhost.localdomain (10.175.104.82) by
 canpemm500006.china.huawei.com (7.192.105.130) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2375.24; Thu, 8 Sep 2022 11:04:26 +0800
From:   Ziyang Xuan <william.xuanziyang@huawei.com>
To:     <socketcan@hartkopp.net>, <mkl@pengutronix.de>,
        <edumazet@google.com>, <kuba@kernel.org>,
        <linux-can@vger.kernel.org>, <netdev@vger.kernel.org>
CC:     <linux-kernel@vger.kernel.org>
Subject: [PATCH 2/2] can: bcm: check the result of can_send() in bcm_can_tx()
Date:   Thu, 8 Sep 2022 11:04:20 +0800
Message-ID: <5c0f2f1bd1dc7bbb9500afd4273e36378e00a35d.1662606045.git.william.xuanziyang@huawei.com>
X-Mailer: git-send-email 2.25.1
In-Reply-To: <cover.1662606045.git.william.xuanziyang@huawei.com>
References: <cover.1662606045.git.william.xuanziyang@huawei.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 7BIT
Content-Type:   text/plain; charset=US-ASCII
X-Originating-IP: [10.175.104.82]
X-ClientProxiedBy: dggems701-chm.china.huawei.com (10.3.19.178) To
 canpemm500006.china.huawei.com (7.192.105.130)
X-CFilter-Loop: Reflected
X-Spam-Status: No, score=-4.2 required=5.0 tests=BAYES_00,RCVD_IN_DNSWL_MED,
        SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

If can_send() fail, it should not update statistics in bcm_can_tx().
Add the result check for can_send() in bcm_can_tx().

Fixes: ffd980f976e7 ("[CAN]: Add broadcast manager (bcm) protocol")
Signed-off-by: Ziyang Xuan <william.xuanziyang@huawei.com>
---
 net/can/bcm.c | 3 ++-
 1 file changed, 2 insertions(+), 1 deletion(-)

diff --git a/net/can/bcm.c b/net/can/bcm.c
index e2783156bfd1..8f5d704a409f 100644
--- a/net/can/bcm.c
+++ b/net/can/bcm.c
@@ -298,7 +298,8 @@ static void bcm_can_tx(struct bcm_op *op)
 	/* send with loopback */
 	skb->dev = dev;
 	can_skb_set_owner(skb, op->sk);
-	can_send(skb, 1);
+	if (can_send(skb, 1))
+		goto out;
 
 	/* update statistics */
 	op->currframe++;
-- 
2.25.1

