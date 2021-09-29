Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 00F9441C90A
	for <lists+netdev@lfdr.de>; Wed, 29 Sep 2021 17:59:24 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1345857AbhI2QA7 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 29 Sep 2021 12:00:59 -0400
Received: from szxga02-in.huawei.com ([45.249.212.188]:23324 "EHLO
        szxga02-in.huawei.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1345437AbhI2P7r (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 29 Sep 2021 11:59:47 -0400
Received: from dggemv711-chm.china.huawei.com (unknown [172.30.72.54])
        by szxga02-in.huawei.com (SkyGuard) with ESMTP id 4HKLWt3hxHzRYFX;
        Wed, 29 Sep 2021 23:53:46 +0800 (CST)
Received: from dggpeml500022.china.huawei.com (7.185.36.66) by
 dggemv711-chm.china.huawei.com (10.1.198.66) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2308.8; Wed, 29 Sep 2021 23:58:03 +0800
Received: from localhost.localdomain (10.67.165.24) by
 dggpeml500022.china.huawei.com (7.185.36.66) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2308.8; Wed, 29 Sep 2021 23:58:03 +0800
From:   Jian Shen <shenjian15@huawei.com>
To:     <davem@davemloft.net>, <kuba@kernel.org>, <andrew@lunn.ch>,
        <hkallweit1@gmail.com>
CC:     <netdev@vger.kernel.org>, <linuxarm@openeuler.org>
Subject: [RFCv2 net-next 054/167] net: dccp: use netdev feature helpers
Date:   Wed, 29 Sep 2021 23:51:41 +0800
Message-ID: <20210929155334.12454-55-shenjian15@huawei.com>
X-Mailer: git-send-email 2.33.0
In-Reply-To: <20210929155334.12454-1-shenjian15@huawei.com>
References: <20210929155334.12454-1-shenjian15@huawei.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 7BIT
Content-Type:   text/plain; charset=US-ASCII
X-Originating-IP: [10.67.165.24]
X-ClientProxiedBy: dggems706-chm.china.huawei.com (10.3.19.183) To
 dggpeml500022.china.huawei.com (7.185.36.66)
X-CFilter-Loop: Reflected
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Use netdev_feature_xxx helpers to replace the logical operation
for netdev features.

Signed-off-by: Jian Shen <shenjian15@huawei.com>
---
 net/dccp/ipv4.c | 2 +-
 net/dccp/ipv6.c | 7 ++++---
 2 files changed, 5 insertions(+), 4 deletions(-)

diff --git a/net/dccp/ipv4.c b/net/dccp/ipv4.c
index 0ea29270d7e5..f6161a100dbe 100644
--- a/net/dccp/ipv4.c
+++ b/net/dccp/ipv4.c
@@ -138,7 +138,7 @@ int dccp_v4_connect(struct sock *sk, struct sockaddr *uaddr, int addr_len)
 	 */
 	dccp_set_state(sk, DCCP_CLOSED);
 	ip_rt_put(rt);
-	sk->sk_route_caps = 0;
+	netdev_feature_zero(&sk->sk_route_caps);
 	inet->inet_dport = 0;
 	goto out;
 }
diff --git a/net/dccp/ipv6.c b/net/dccp/ipv6.c
index fa663518fa0e..0f966e02ddc4 100644
--- a/net/dccp/ipv6.c
+++ b/net/dccp/ipv6.c
@@ -489,8 +489,9 @@ static struct sock *dccp_v6_request_recv_sock(const struct sock *sk,
 	 */
 
 	ip6_dst_store(newsk, dst, NULL, NULL);
-	newsk->sk_route_caps = dst->dev->features & ~(NETIF_F_IP_CSUM |
-						      NETIF_F_TSO);
+	netdev_feature_copy(&newsk->sk_route_caps, dst->dev->features);
+	netdev_feature_clear_bits(NETIF_F_IP_CSUM | NETIF_F_TSO,
+				  &newsk->sk_route_caps);
 	newdp6 = (struct dccp6_sock *)newsk;
 	newinet = inet_sk(newsk);
 	newinet->pinet6 = &newdp6->inet6;
@@ -970,7 +971,7 @@ static int dccp_v6_connect(struct sock *sk, struct sockaddr *uaddr,
 	__sk_dst_reset(sk);
 failure:
 	inet->inet_dport = 0;
-	sk->sk_route_caps = 0;
+	netdev_feature_zero(&sk->sk_route_caps);
 	return err;
 }
 
-- 
2.33.0

