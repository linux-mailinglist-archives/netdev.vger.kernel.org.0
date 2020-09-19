Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 35A7D270A00
	for <lists+netdev@lfdr.de>; Sat, 19 Sep 2020 04:19:55 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726315AbgISCTv (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 18 Sep 2020 22:19:51 -0400
Received: from szxga04-in.huawei.com ([45.249.212.190]:13315 "EHLO huawei.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1726119AbgISCTv (ORCPT <rfc822;netdev@vger.kernel.org>);
        Fri, 18 Sep 2020 22:19:51 -0400
Received: from DGGEMS404-HUB.china.huawei.com (unknown [172.30.72.59])
        by Forcepoint Email with ESMTP id 8FA2BE34F52534EADD74;
        Sat, 19 Sep 2020 10:19:49 +0800 (CST)
Received: from localhost.localdomain (10.69.192.58) by
 DGGEMS404-HUB.china.huawei.com (10.3.19.204) with Microsoft SMTP Server id
 14.3.487.0; Sat, 19 Sep 2020 10:19:38 +0800
From:   Yunsheng Lin <linyunsheng@huawei.com>
To:     <davem@davemloft.net>, <kuba@kernel.org>, <linmiaohe@huawei.com>,
        <martin.varghese@nokia.com>, <fw@strlen.de>, <edumazet@google.com>,
        <dcaratti@redhat.com>, <steffen.klassert@secunet.com>,
        <pabeni@redhat.com>, <kyk.segfault@gmail.com>
CC:     <netdev@vger.kernel.org>, <linux-kernel@vger.kernel.org>,
        <linuxarm@huawei.com>
Subject: [PATCH net-next] net: hns3: remove unnecessary NULL checking in napi_consume_skb()
Date:   Sat, 19 Sep 2020 10:16:06 +0800
Message-ID: <1600481766-46158-1-git-send-email-linyunsheng@huawei.com>
X-Mailer: git-send-email 2.8.1
MIME-Version: 1.0
Content-Type: text/plain
X-Originating-IP: [10.69.192.58]
X-CFilter-Loop: Reflected
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

When budget is non-zero, skb_unref() has already handled the
NULL checking.

When budget is zero, the dev_consume_skb_any() has handled NULL
checking in __dev_kfree_skb_irq(), or dev_kfree_skb() which also
ultimately call skb_unref().

So remove the unnecessary checking in napi_consume_skb().

Signed-off-by: Yunsheng Lin <linyunsheng@huawei.com>
---
 net/core/skbuff.c | 3 ---
 1 file changed, 3 deletions(-)

diff --git a/net/core/skbuff.c b/net/core/skbuff.c
index bfd7483..e077447 100644
--- a/net/core/skbuff.c
+++ b/net/core/skbuff.c
@@ -895,9 +895,6 @@ void __kfree_skb_defer(struct sk_buff *skb)
 
 void napi_consume_skb(struct sk_buff *skb, int budget)
 {
-	if (unlikely(!skb))
-		return;
-
 	/* Zero budget indicate non-NAPI context called us, like netpoll */
 	if (unlikely(!budget)) {
 		dev_consume_skb_any(skb);
-- 
2.8.1

