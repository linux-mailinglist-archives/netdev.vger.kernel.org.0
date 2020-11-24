Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 00CC72C234A
	for <lists+netdev@lfdr.de>; Tue, 24 Nov 2020 11:56:02 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1732271AbgKXKxO (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 24 Nov 2020 05:53:14 -0500
Received: from szxga06-in.huawei.com ([45.249.212.32]:7976 "EHLO
        szxga06-in.huawei.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1732047AbgKXKxO (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 24 Nov 2020 05:53:14 -0500
Received: from DGGEMS409-HUB.china.huawei.com (unknown [172.30.72.60])
        by szxga06-in.huawei.com (SkyGuard) with ESMTP id 4CgLTN66WwzhY7V;
        Tue, 24 Nov 2020 18:52:56 +0800 (CST)
Received: from localhost.localdomain (10.69.192.58) by
 DGGEMS409-HUB.china.huawei.com (10.3.19.209) with Microsoft SMTP Server id
 14.3.487.0; Tue, 24 Nov 2020 18:53:02 +0800
From:   Yunsheng Lin <linyunsheng@huawei.com>
To:     <peterz@infradead.org>, <mingo@redhat.com>, <will@kernel.org>,
        <viro@zeniv.linux.org.uk>, <kyk.segfault@gmail.com>,
        <davem@davemloft.net>, <kuba@kernel.org>, <linmiaohe@huawei.com>,
        <martin.varghese@nokia.com>, <pabeni@redhat.com>,
        <pshelar@ovn.org>, <fw@strlen.de>, <gnault@redhat.com>,
        <steffen.klassert@secunet.com>, <vladimir.oltean@nxp.com>,
        <edumazet@google.com>, <saeed@kernel.org>
CC:     <netdev@vger.kernel.org>, <linux-kernel@vger.kernel.org>,
        <linuxarm@huawei.com>
Subject: [PATCH net-next v3 2/2] net: Use lockdep_assert_in_softirq() in napi_consume_skb()
Date:   Tue, 24 Nov 2020 18:49:29 +0800
Message-ID: <1606214969-97849-3-git-send-email-linyunsheng@huawei.com>
X-Mailer: git-send-email 2.8.1
In-Reply-To: <1606214969-97849-1-git-send-email-linyunsheng@huawei.com>
References: <1606214969-97849-1-git-send-email-linyunsheng@huawei.com>
MIME-Version: 1.0
Content-Type: text/plain
X-Originating-IP: [10.69.192.58]
X-CFilter-Loop: Reflected
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Use napi_consume_skb() to assert the case when it is not called
in a atomic softirq context.

Signed-off-by: Yunsheng Lin <linyunsheng@huawei.com>
---
 net/core/skbuff.c | 2 ++
 1 file changed, 2 insertions(+)

diff --git a/net/core/skbuff.c b/net/core/skbuff.c
index ffe3dcc..effa19d 100644
--- a/net/core/skbuff.c
+++ b/net/core/skbuff.c
@@ -902,6 +902,8 @@ void napi_consume_skb(struct sk_buff *skb, int budget)
 		return;
 	}
 
+	lockdep_assert_in_softirq();
+
 	if (!skb_unref(skb))
 		return;
 
-- 
2.8.1

