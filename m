Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 44CD22517B7
	for <lists+netdev@lfdr.de>; Tue, 25 Aug 2020 13:34:51 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1730007AbgHYLet (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 25 Aug 2020 07:34:49 -0400
Received: from szxga04-in.huawei.com ([45.249.212.190]:10318 "EHLO huawei.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1725893AbgHYLeq (ORCPT <rfc822;netdev@vger.kernel.org>);
        Tue, 25 Aug 2020 07:34:46 -0400
Received: from DGGEMS412-HUB.china.huawei.com (unknown [172.30.72.59])
        by Forcepoint Email with ESMTP id 1B76FEC9296461D1268C;
        Tue, 25 Aug 2020 19:34:41 +0800 (CST)
Received: from huawei.com (10.175.104.175) by DGGEMS412-HUB.china.huawei.com
 (10.3.19.212) with Microsoft SMTP Server id 14.3.487.0; Tue, 25 Aug 2020
 19:34:30 +0800
From:   Miaohe Lin <linmiaohe@huawei.com>
To:     <davem@davemloft.net>, <kuznet@ms2.inr.ac.ru>,
        <yoshfuji@linux-ipv6.org>, <kuba@kernel.org>
CC:     <netdev@vger.kernel.org>, <linux-kernel@vger.kernel.org>,
        <linmiaohe@huawei.com>
Subject: [PATCH] net: Set ping saddr after we successfully get the ping port
Date:   Tue, 25 Aug 2020 07:33:22 -0400
Message-ID: <20200825113322.11771-1-linmiaohe@huawei.com>
X-Mailer: git-send-email 2.19.1
MIME-Version: 1.0
Content-Transfer-Encoding: 7BIT
Content-Type:   text/plain; charset=US-ASCII
X-Originating-IP: [10.175.104.175]
X-CFilter-Loop: Reflected
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

We can defer set ping saddr until we successfully get the ping port. So we
can avoid clear saddr when failed. Since ping_clear_saddr() is not used
anymore now, remove it.

Signed-off-by: Miaohe Lin <linmiaohe@huawei.com>
---
 net/ipv4/ping.c | 19 +++----------------
 1 file changed, 3 insertions(+), 16 deletions(-)

diff --git a/net/ipv4/ping.c b/net/ipv4/ping.c
index df6fbefe44d4..cc09d1135ce2 100644
--- a/net/ipv4/ping.c
+++ b/net/ipv4/ping.c
@@ -383,20 +383,6 @@ static void ping_set_saddr(struct sock *sk, struct sockaddr *saddr)
 	}
 }
 
-static void ping_clear_saddr(struct sock *sk, int dif)
-{
-	sk->sk_bound_dev_if = dif;
-	if (sk->sk_family == AF_INET) {
-		struct inet_sock *isk = inet_sk(sk);
-		isk->inet_rcv_saddr = isk->inet_saddr = 0;
-#if IS_ENABLED(CONFIG_IPV6)
-	} else if (sk->sk_family == AF_INET6) {
-		struct ipv6_pinfo *np = inet6_sk(sk);
-		memset(&sk->sk_v6_rcv_saddr, 0, sizeof(sk->sk_v6_rcv_saddr));
-		memset(&np->saddr, 0, sizeof(np->saddr));
-#endif
-	}
-}
 /*
  * We need our own bind because there are no privileged id's == local ports.
  * Moreover, we don't allow binding to multi- and broadcast addresses.
@@ -420,12 +406,13 @@ int ping_bind(struct sock *sk, struct sockaddr *uaddr, int addr_len)
 		goto out;
 
 	err = -EADDRINUSE;
-	ping_set_saddr(sk, uaddr);
 	snum = ntohs(((struct sockaddr_in *)uaddr)->sin_port);
 	if (ping_get_port(sk, snum) != 0) {
-		ping_clear_saddr(sk, dif);
+		/* Restore possibly modified sk->sk_bound_dev_if by ping_check_bind_addr(). */
+		sk->sk_bound_dev_if = dif;
 		goto out;
 	}
+	ping_set_saddr(sk, uaddr);
 
 	pr_debug("after bind(): num = %hu, dif = %d\n",
 		 isk->inet_num,
-- 
2.19.1

