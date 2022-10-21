Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 1799F606E1A
	for <lists+netdev@lfdr.de>; Fri, 21 Oct 2022 05:03:09 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229729AbiJUDDG (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 20 Oct 2022 23:03:06 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:51314 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229541AbiJUDDD (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 20 Oct 2022 23:03:03 -0400
Received: from szxga08-in.huawei.com (szxga08-in.huawei.com [45.249.212.255])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 0C3E91C4917;
        Thu, 20 Oct 2022 20:03:02 -0700 (PDT)
Received: from kwepemi500015.china.huawei.com (unknown [172.30.72.53])
        by szxga08-in.huawei.com (SkyGuard) with ESMTP id 4Mtq0Q0lnnz1P75W;
        Fri, 21 Oct 2022 10:58:14 +0800 (CST)
Received: from huawei.com (10.175.101.6) by kwepemi500015.china.huawei.com
 (7.221.188.92) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id 15.1.2375.31; Fri, 21 Oct
 2022 11:02:58 +0800
From:   Lu Wei <luwei32@huawei.com>
To:     <davem@davemloft.net>, <edumazet@google.com>, <kuba@kernel.org>,
        <pabeni@redhat.com>, <yoshfuji@linux-ipv6.org>,
        <dsahern@kernel.org>, <ast@kernel.org>, <martin.lau@kernel.org>,
        <kuniyu@amazon.com>, <asml.silence@gmail.com>,
        <imagedong@tencent.com>, <ncardwell@google.com>,
        <netdev@vger.kernel.org>, <linux-kernel@vger.kernel.org>
Subject: [PATCH net,v3] tcp: fix a signed-integer-overflow bug in tcp_add_backlog()
Date:   Fri, 21 Oct 2022 12:06:22 +0800
Message-ID: <20221021040622.815143-1-luwei32@huawei.com>
X-Mailer: git-send-email 2.31.1
MIME-Version: 1.0
Content-Transfer-Encoding: 7BIT
Content-Type:   text/plain; charset=US-ASCII
X-Originating-IP: [10.175.101.6]
X-ClientProxiedBy: dggems706-chm.china.huawei.com (10.3.19.183) To
 kwepemi500015.china.huawei.com (7.221.188.92)
X-CFilter-Loop: Reflected
X-Spam-Status: No, score=-4.2 required=5.0 tests=BAYES_00,RCVD_IN_DNSWL_MED,
        SPF_HELO_NONE,SPF_PASS autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

The type of sk_rcvbuf and sk_sndbuf in struct sock is int, and
in tcp_add_backlog(), the variable limit is caculated by adding
sk_rcvbuf, sk_sndbuf and 64 * 1024, it may exceed the max value
of int and overflow. This patch reduces the limit budget by
halving the sndbuf to solve this issue since ACK packets are much
smaller than the payload.

Fixes: c9c3321257e1 ("tcp: add tcp_add_backlog()")
Signed-off-by: Lu Wei <luwei32@huawei.com>
---
 net/ipv4/tcp_ipv4.c | 4 +++-
 1 file changed, 3 insertions(+), 1 deletion(-)

diff --git a/net/ipv4/tcp_ipv4.c b/net/ipv4/tcp_ipv4.c
index 7a250ef9d1b7..87d440f47a70 100644
--- a/net/ipv4/tcp_ipv4.c
+++ b/net/ipv4/tcp_ipv4.c
@@ -1874,11 +1874,13 @@ bool tcp_add_backlog(struct sock *sk, struct sk_buff *skb,
 	__skb_push(skb, hdrlen);
 
 no_coalesce:
+	limit = (u32)READ_ONCE(sk->sk_rcvbuf) + (u32)(READ_ONCE(sk->sk_sndbuf) >> 1);
+
 	/* Only socket owner can try to collapse/prune rx queues
 	 * to reduce memory overhead, so add a little headroom here.
 	 * Few sockets backlog are possibly concurrently non empty.
 	 */
-	limit = READ_ONCE(sk->sk_rcvbuf) + READ_ONCE(sk->sk_sndbuf) + 64*1024;
+	limit += 64 * 1024;
 
 	if (unlikely(sk_add_backlog(sk, skb, limit))) {
 		bh_unlock_sock(sk);
-- 
2.31.1

