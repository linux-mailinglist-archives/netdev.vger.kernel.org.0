Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 1385D39D806
	for <lists+netdev@lfdr.de>; Mon,  7 Jun 2021 10:57:35 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230323AbhFGI7Q (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 7 Jun 2021 04:59:16 -0400
Received: from szxga03-in.huawei.com ([45.249.212.189]:4377 "EHLO
        szxga03-in.huawei.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230299AbhFGI7P (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 7 Jun 2021 04:59:15 -0400
Received: from dggeme760-chm.china.huawei.com (unknown [172.30.72.56])
        by szxga03-in.huawei.com (SkyGuard) with ESMTP id 4Fz6bd1tlQz6tsN;
        Mon,  7 Jun 2021 16:53:33 +0800 (CST)
Received: from localhost.localdomain (10.175.104.82) by
 dggeme760-chm.china.huawei.com (10.3.19.106) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_CBC_SHA256_P256) id
 15.1.2176.2; Mon, 7 Jun 2021 16:57:21 +0800
From:   Zheng Yongjun <zhengyongjun3@huawei.com>
To:     <davem@davemloft.net>, <yoshfuji@linux-ipv6.org>,
        <dsahern@kernel.org>, <kuba@kernel.org>, <netdev@vger.kernel.org>,
        <linux-kernel@vger.kernel.org>
CC:     Zheng Yongjun <zhengyongjun3@huawei.com>
Subject: [PATCH] ping: Check return value of function 'ping_queue_rcv_skb'
Date:   Mon, 7 Jun 2021 17:10:58 +0800
Message-ID: <20210607091058.2766648-1-zhengyongjun3@huawei.com>
X-Mailer: git-send-email 2.25.1
MIME-Version: 1.0
Content-Transfer-Encoding: 7BIT
Content-Type:   text/plain; charset=US-ASCII
X-Originating-IP: [10.175.104.82]
X-ClientProxiedBy: dggems703-chm.china.huawei.com (10.3.19.180) To
 dggeme760-chm.china.huawei.com (10.3.19.106)
X-CFilter-Loop: Reflected
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Function 'ping_queue_rcv_skb' not always return success, which will
also return fail. If not check the wrong return value of it, lead to function
`ping_rcv` return success.

Signed-off-by: Zheng Yongjun <zhengyongjun3@huawei.com>
---
 net/ipv4/ping.c | 7 ++++---
 1 file changed, 4 insertions(+), 3 deletions(-)

diff --git a/net/ipv4/ping.c b/net/ipv4/ping.c
index 1c9f71a37258..8e84cde95011 100644
--- a/net/ipv4/ping.c
+++ b/net/ipv4/ping.c
@@ -968,10 +968,11 @@ bool ping_rcv(struct sk_buff *skb)
 		struct sk_buff *skb2 = skb_clone(skb, GFP_ATOMIC);
 
 		pr_debug("rcv on socket %p\n", sk);
-		if (skb2)
-			ping_queue_rcv_skb(sk, skb2);
+		if (skb2 && !ping_queue_rcv_skb(sk, skb2)) {
+			sock_put(sk);
+			return true;
+		}
 		sock_put(sk);
-		return true;
 	}
 	pr_debug("no socket, dropping\n");
 
-- 
2.25.1

