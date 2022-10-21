Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 48502606E13
	for <lists+netdev@lfdr.de>; Fri, 21 Oct 2022 04:58:09 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229918AbiJUC6G (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 20 Oct 2022 22:58:06 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:37980 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229785AbiJUC6F (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 20 Oct 2022 22:58:05 -0400
Received: from szxga02-in.huawei.com (szxga02-in.huawei.com [45.249.212.188])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id CD77F1BC148;
        Thu, 20 Oct 2022 19:58:03 -0700 (PDT)
Received: from dggpemm500021.china.huawei.com (unknown [172.30.72.54])
        by szxga02-in.huawei.com (SkyGuard) with ESMTP id 4Mtq004NnkzHvDj;
        Fri, 21 Oct 2022 10:57:52 +0800 (CST)
Received: from dggpemm500005.china.huawei.com (7.185.36.74) by
 dggpemm500021.china.huawei.com (7.185.36.109) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2375.31; Fri, 21 Oct 2022 10:57:39 +0800
Received: from localhost.localdomain (10.69.192.56) by
 dggpemm500005.china.huawei.com (7.185.36.74) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2375.31; Fri, 21 Oct 2022 10:57:39 +0800
From:   Yunsheng Lin <linyunsheng@huawei.com>
To:     <davem@davemloft.net>, <kuba@kernel.org>
CC:     <netdev@vger.kernel.org>, <linux-kernel@vger.kernel.org>,
        <linuxarm@openeuler.org>, <pabeni@redhat.com>, <hawk@kernel.org>,
        <ilias.apalodimas@linaro.org>
Subject: [PATCH net-next] net: skb: move skb_pp_recycle() to skbuff.c
Date:   Fri, 21 Oct 2022 10:58:22 +0800
Message-ID: <20221021025822.64381-1-linyunsheng@huawei.com>
X-Mailer: git-send-email 2.33.0
MIME-Version: 1.0
Content-Transfer-Encoding: 7BIT
Content-Type:   text/plain; charset=US-ASCII
X-Originating-IP: [10.69.192.56]
X-ClientProxiedBy: dggems702-chm.china.huawei.com (10.3.19.179) To
 dggpemm500005.china.huawei.com (7.185.36.74)
X-CFilter-Loop: Reflected
X-Spam-Status: No, score=-4.2 required=5.0 tests=BAYES_00,RCVD_IN_DNSWL_MED,
        SPF_HELO_NONE,SPF_PASS autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

skb_pp_recycle() is only used by skb_free_head() in
skbuff.c, so move it to skbuff.c.

Signed-off-by: Yunsheng Lin <linyunsheng@huawei.com>
---
 include/linux/skbuff.h | 7 -------
 net/core/skbuff.c      | 7 +++++++
 2 files changed, 7 insertions(+), 7 deletions(-)

diff --git a/include/linux/skbuff.h b/include/linux/skbuff.h
index 9fcf534f2d92..28a7b5fbc7b7 100644
--- a/include/linux/skbuff.h
+++ b/include/linux/skbuff.h
@@ -5048,12 +5048,5 @@ static inline void skb_mark_for_recycle(struct sk_buff *skb)
 }
 #endif
 
-static inline bool skb_pp_recycle(struct sk_buff *skb, void *data)
-{
-	if (!IS_ENABLED(CONFIG_PAGE_POOL) || !skb->pp_recycle)
-		return false;
-	return page_pool_return_skb_page(virt_to_page(data));
-}
-
 #endif	/* __KERNEL__ */
 #endif	/* _LINUX_SKBUFF_H */
diff --git a/net/core/skbuff.c b/net/core/skbuff.c
index 1d9719e72f9d..9b3b19816d2d 100644
--- a/net/core/skbuff.c
+++ b/net/core/skbuff.c
@@ -748,6 +748,13 @@ static void skb_clone_fraglist(struct sk_buff *skb)
 		skb_get(list);
 }
 
+static bool skb_pp_recycle(struct sk_buff *skb, void *data)
+{
+	if (!IS_ENABLED(CONFIG_PAGE_POOL) || !skb->pp_recycle)
+		return false;
+	return page_pool_return_skb_page(virt_to_page(data));
+}
+
 static void skb_free_head(struct sk_buff *skb)
 {
 	unsigned char *head = skb->head;
-- 
2.33.0

