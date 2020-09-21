Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 0971827192B
	for <lists+netdev@lfdr.de>; Mon, 21 Sep 2020 04:08:42 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726402AbgIUCIh (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sun, 20 Sep 2020 22:08:37 -0400
Received: from szxga05-in.huawei.com ([45.249.212.191]:13733 "EHLO huawei.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1726184AbgIUCIh (ORCPT <rfc822;netdev@vger.kernel.org>);
        Sun, 20 Sep 2020 22:08:37 -0400
Received: from DGGEMS401-HUB.china.huawei.com (unknown [172.30.72.58])
        by Forcepoint Email with ESMTP id 7D4B3A2B58E6D22EB7B0;
        Mon, 21 Sep 2020 10:08:35 +0800 (CST)
Received: from localhost.localdomain (10.69.192.58) by
 DGGEMS401-HUB.china.huawei.com (10.3.19.201) with Microsoft SMTP Server id
 14.3.487.0; Mon, 21 Sep 2020 10:08:25 +0800
From:   Yunsheng Lin <linyunsheng@huawei.com>
To:     <davem@davemloft.net>, <kuba@kernel.org>, <linmiaohe@huawei.com>,
        <martin.varghese@nokia.com>, <fw@strlen.de>, <edumazet@google.com>,
        <dcaratti@redhat.com>, <steffen.klassert@secunet.com>,
        <pabeni@redhat.com>, <kyk.segfault@gmail.com>, <saeed@kernel.org>
CC:     <netdev@vger.kernel.org>, <linux-kernel@vger.kernel.org>,
        <linuxarm@huawei.com>
Subject: [PATCH net-next] net: use in_softirq() to indicate the NAPI context in napi_consume_skb()
Date:   Mon, 21 Sep 2020 10:04:53 +0800
Message-ID: <1600653893-206277-1-git-send-email-linyunsheng@huawei.com>
X-Mailer: git-send-email 2.8.1
MIME-Version: 1.0
Content-Type: text/plain
X-Originating-IP: [10.69.192.58]
X-CFilter-Loop: Reflected
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

When napi_consume_skb() is called in the tx desc cleaning process,
it is usually in the softirq context(BH disabled, or are processing
softirqs), but it may also be in the task context, such as in the
netpoll or loopback selftest process.

Currently napi_consume_skb() uses non-zero budget to indicate the
NAPI context, the driver writer may provide the wrong budget when
tx desc cleaning function is reused for both NAPI and non-NAPI
context, see [1].

So this patch uses in_softirq() to indicate the NAPI context, which
doesn't necessarily mean in NAPI context, but it shouldn't care if
NAPI context or not as long as it runs in softirq context or with BH
disabled, then _kfree_skb_defer() will push the skb to the particular
cpu' napi_alloc_cache atomically.

[1] https://lkml.org/lkml/2020/9/15/38

Signed-off-by: Yunsheng Lin <linyunsheng@huawei.com>
---
note that budget parameter is not removed in this patch because it
involves many driver changes, we can remove it in separate patch if
this patch is accepted.
---
 net/core/skbuff.c | 6 ++++--
 1 file changed, 4 insertions(+), 2 deletions(-)

diff --git a/net/core/skbuff.c b/net/core/skbuff.c
index e077447..03d0d28 100644
--- a/net/core/skbuff.c
+++ b/net/core/skbuff.c
@@ -895,8 +895,10 @@ void __kfree_skb_defer(struct sk_buff *skb)
 
 void napi_consume_skb(struct sk_buff *skb, int budget)
 {
-	/* Zero budget indicate non-NAPI context called us, like netpoll */
-	if (unlikely(!budget)) {
+	/* called by non-softirq context, which usually means non-NAPI
+	 * context, like netpoll.
+	 */
+	if (unlikely(!in_softirq())) {
 		dev_consume_skb_any(skb);
 		return;
 	}
-- 
2.8.1

