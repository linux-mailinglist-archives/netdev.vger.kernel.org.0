Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id EF02D3FD7CE
	for <lists+netdev@lfdr.de>; Wed,  1 Sep 2021 12:40:46 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S236136AbhIAKlV (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 1 Sep 2021 06:41:21 -0400
Received: from szxga02-in.huawei.com ([45.249.212.188]:9391 "EHLO
        szxga02-in.huawei.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231903AbhIAKlS (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 1 Sep 2021 06:41:18 -0400
Received: from dggemv711-chm.china.huawei.com (unknown [172.30.72.56])
        by szxga02-in.huawei.com (SkyGuard) with ESMTP id 4H00pF12N2z8x9K;
        Wed,  1 Sep 2021 18:36:05 +0800 (CST)
Received: from dggpemm500005.china.huawei.com (7.185.36.74) by
 dggemv711-chm.china.huawei.com (10.1.198.66) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2176.2; Wed, 1 Sep 2021 18:40:19 +0800
Received: from localhost.localdomain (10.69.192.56) by
 dggpemm500005.china.huawei.com (7.185.36.74) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2308.8; Wed, 1 Sep 2021 18:40:19 +0800
From:   Yunsheng Lin <linyunsheng@huawei.com>
To:     <davem@davemloft.net>, <kuba@kernel.org>
CC:     <netdev@vger.kernel.org>, <linux-kernel@vger.kernel.org>,
        <linuxarm@openeuler.org>, <edumazet@google.com>,
        <yoshfuji@linux-ipv6.org>, <dsahern@kernel.org>
Subject: [PATCH net-next] tcp: add tcp_tx_skb_cache_key checking in sk_stream_alloc_skb()
Date:   Wed, 1 Sep 2021 18:39:04 +0800
Message-ID: <1630492744-60396-1-git-send-email-linyunsheng@huawei.com>
X-Mailer: git-send-email 2.7.4
MIME-Version: 1.0
Content-Type: text/plain
X-Originating-IP: [10.69.192.56]
X-ClientProxiedBy: dggems705-chm.china.huawei.com (10.3.19.182) To
 dggpemm500005.china.huawei.com (7.185.36.74)
X-CFilter-Loop: Reflected
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Since tcp_tx_skb_cache is disabled by default in:
commit 0b7d7f6b2208 ("tcp: add tcp_tx_skb_cache sysctl")

Add tcp_tx_skb_cache_key checking in sk_stream_alloc_skb() to
avoid possible branch-misses.

Signed-off-by: Yunsheng Lin <linyunsheng@huawei.com>
---
Also, the sk->sk_tx_skb_cache may be both changed by allocation
and freeing side, I assume there may be some implicit protection
here too, such as the NAPI protection for rx?
---
 net/ipv4/tcp.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/net/ipv4/tcp.c b/net/ipv4/tcp.c
index e8b48df..226ddef 100644
--- a/net/ipv4/tcp.c
+++ b/net/ipv4/tcp.c
@@ -866,7 +866,7 @@ struct sk_buff *sk_stream_alloc_skb(struct sock *sk, int size, gfp_t gfp,
 {
 	struct sk_buff *skb;
 
-	if (likely(!size)) {
+	if (static_branch_unlikely(&tcp_tx_skb_cache_key) && likely(!size)) {
 		skb = sk->sk_tx_skb_cache;
 		if (skb) {
 			skb->truesize = SKB_TRUESIZE(skb_end_offset(skb));
-- 
2.7.4

