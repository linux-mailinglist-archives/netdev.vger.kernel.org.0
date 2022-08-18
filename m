Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 1959F5980C4
	for <lists+netdev@lfdr.de>; Thu, 18 Aug 2022 11:25:45 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S238807AbiHRJXL (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 18 Aug 2022 05:23:11 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:54756 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233114AbiHRJXJ (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 18 Aug 2022 05:23:09 -0400
Received: from szxga01-in.huawei.com (szxga01-in.huawei.com [45.249.212.187])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id B47B3A2204;
        Thu, 18 Aug 2022 02:23:06 -0700 (PDT)
Received: from dggpemm500021.china.huawei.com (unknown [172.30.72.54])
        by szxga01-in.huawei.com (SkyGuard) with ESMTP id 4M7fV61hg2zkWVc;
        Thu, 18 Aug 2022 17:19:42 +0800 (CST)
Received: from dggpemm500007.china.huawei.com (7.185.36.183) by
 dggpemm500021.china.huawei.com (7.185.36.109) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2375.24; Thu, 18 Aug 2022 17:23:04 +0800
Received: from huawei.com (10.175.103.91) by dggpemm500007.china.huawei.com
 (7.185.36.183) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id 15.1.2375.24; Thu, 18 Aug
 2022 17:23:04 +0800
From:   Yang Yingliang <yangyingliang@huawei.com>
To:     <linux-kernel@vger.kernel.org>, <netdev@vger.kernel.org>
CC:     <ap420073@gmail.com>, <davem@davemloft.net>
Subject: [PATCH -next] amt: remove unneccessary skb pointer check
Date:   Thu, 18 Aug 2022 17:31:14 +0800
Message-ID: <20220818093114.2449179-1-yangyingliang@huawei.com>
X-Mailer: git-send-email 2.25.1
MIME-Version: 1.0
Content-Transfer-Encoding: 7BIT
Content-Type:   text/plain; charset=US-ASCII
X-Originating-IP: [10.175.103.91]
X-ClientProxiedBy: dggems704-chm.china.huawei.com (10.3.19.181) To
 dggpemm500007.china.huawei.com (7.185.36.183)
X-CFilter-Loop: Reflected
X-Spam-Status: No, score=-4.2 required=5.0 tests=BAYES_00,RCVD_IN_DNSWL_MED,
        SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

The skb pointer will be checked in kfree_skb(), so remove the outside check.

Signed-off-by: Yang Yingliang <yangyingliang@huawei.com>
---
 drivers/net/amt.c | 6 ++----
 1 file changed, 2 insertions(+), 4 deletions(-)

diff --git a/drivers/net/amt.c b/drivers/net/amt.c
index 9a247eb7679c..2d20be6ffb7e 100644
--- a/drivers/net/amt.c
+++ b/drivers/net/amt.c
@@ -2894,8 +2894,7 @@ static void amt_event_work(struct work_struct *work)
 			amt_event_send_request(amt);
 			break;
 		default:
-			if (skb)
-				kfree_skb(skb);
+			kfree_skb(skb);
 			break;
 		}
 	}
@@ -3033,8 +3032,7 @@ static int amt_dev_stop(struct net_device *dev)
 	cancel_work_sync(&amt->event_wq);
 	for (i = 0; i < AMT_MAX_EVENTS; i++) {
 		skb = amt->events[i].skb;
-		if (skb)
-			kfree_skb(skb);
+		kfree_skb(skb);
 		amt->events[i].event = AMT_EVENT_NONE;
 		amt->events[i].skb = NULL;
 	}
-- 
2.25.1

