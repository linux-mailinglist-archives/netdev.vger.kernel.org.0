Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id EC94760E140
	for <lists+netdev@lfdr.de>; Wed, 26 Oct 2022 14:54:57 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233925AbiJZMy4 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 26 Oct 2022 08:54:56 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:34218 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233919AbiJZMyz (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 26 Oct 2022 08:54:55 -0400
Received: from szxga02-in.huawei.com (szxga02-in.huawei.com [45.249.212.188])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 8981A3ECF3;
        Wed, 26 Oct 2022 05:54:52 -0700 (PDT)
Received: from dggpemm500020.china.huawei.com (unknown [172.30.72.55])
        by szxga02-in.huawei.com (SkyGuard) with ESMTP id 4My7tz5VZdzVj4w;
        Wed, 26 Oct 2022 20:50:03 +0800 (CST)
Received: from dggpemm500007.china.huawei.com (7.185.36.183) by
 dggpemm500020.china.huawei.com (7.185.36.49) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2375.31; Wed, 26 Oct 2022 20:54:51 +0800
Received: from huawei.com (10.175.103.91) by dggpemm500007.china.huawei.com
 (7.185.36.183) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id 15.1.2375.31; Wed, 26 Oct
 2022 20:54:50 +0800
From:   Yang Yingliang <yangyingliang@huawei.com>
To:     <linux-can@vger.kernel.org>, <netdev@vger.kernel.org>
CC:     <robin@protonic.nl>, <linux@rempel-privat.de>,
        <kernel@pengutronix.de>, <socketcan@hartkopp.net>,
        <mkl@pengutronix.de>
Subject: [PATCH] can: j1939: transport: replace kfree_skb() with dev_kfree_skb_irq()
Date:   Wed, 26 Oct 2022 20:53:54 +0800
Message-ID: <20221026125354.911575-1-yangyingliang@huawei.com>
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

It is not allowed to call kfree_skb() from hardware interrupt
context or with interrupts being disabled. So replace kfree_skb()
with dev_kfree_skb_irq() under spin_lock_irqsave().

Fixes: 9d71dd0c7009 ("can: add support of SAE J1939 protocol")
Signed-off-by: Yang Yingliang <yangyingliang@huawei.com>
---
 net/can/j1939/transport.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/net/can/j1939/transport.c b/net/can/j1939/transport.c
index d7d86c944d76..b95fb759c49d 100644
--- a/net/can/j1939/transport.c
+++ b/net/can/j1939/transport.c
@@ -343,7 +343,7 @@ static void j1939_session_skb_drop_old(struct j1939_session *session)
 		/* drop ref taken in j1939_session_skb_queue() */
 		skb_unref(do_skb);
 
-		kfree_skb(do_skb);
+		dev_kfree_skb_irq(do_skb);
 	}
 	spin_unlock_irqrestore(&session->skb_queue.lock, flags);
 }
-- 
2.25.1

