Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 0F47A41870D
	for <lists+netdev@lfdr.de>; Sun, 26 Sep 2021 09:19:16 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231368AbhIZHUr (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sun, 26 Sep 2021 03:20:47 -0400
Received: from szxga01-in.huawei.com ([45.249.212.187]:22997 "EHLO
        szxga01-in.huawei.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231328AbhIZHUY (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sun, 26 Sep 2021 03:20:24 -0400
Received: from dggemv704-chm.china.huawei.com (unknown [172.30.72.55])
        by szxga01-in.huawei.com (SkyGuard) with ESMTP id 4HHH873kgDzbmpQ;
        Sun, 26 Sep 2021 15:14:31 +0800 (CST)
Received: from dggpeml500002.china.huawei.com (7.185.36.158) by
 dggemv704-chm.china.huawei.com (10.3.19.47) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2308.8; Sun, 26 Sep 2021 15:18:46 +0800
Received: from huawei.com (10.136.117.208) by dggpeml500002.china.huawei.com
 (7.185.36.158) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id 15.1.2308.8; Sun, 26 Sep
 2021 15:18:45 +0800
From:   Qiumiao Zhang <zhangqiumiao1@huawei.com>
To:     <linux-kernel@vger.kernel.org>
CC:     <stable@vger.kernel.org>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        Sasha Levin <sasha.levin@oracle.com>,
        "David S . Miller" <davem@davemloft.net>,
        Alexey Kuznetsov <kuznet@ms2.inr.ac.ru>,
        <netdev@vger.kernel.org>, <yanan@huawei.com>,
        <rose.chen@huawei.com>
Subject: [PATCH stable 4.19 4/4] tcp: adjust rto_base in retransmits_timed_out()
Date:   Sun, 26 Sep 2021 15:18:42 +0800
Message-ID: <20210926071842.1429-5-zhangqiumiao1@huawei.com>
X-Mailer: git-send-email 2.28.0.windows.1
In-Reply-To: <20210926071842.1429-1-zhangqiumiao1@huawei.com>
References: <20210926071842.1429-1-zhangqiumiao1@huawei.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 7BIT
Content-Type:   text/plain; charset=US-ASCII
X-Originating-IP: [10.136.117.208]
X-ClientProxiedBy: dggems701-chm.china.huawei.com (10.3.19.178) To
 dggpeml500002.china.huawei.com (7.185.36.158)
X-CFilter-Loop: Reflected
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Eric Dumazet <edumazet@google.com>

commit 3256a2d6ab1f71f9a1bd2d7f6f18eb8108c48d17 upstream

The cited commit exposed an old retransmits_timed_out() bug
which assumed it could call tcp_model_timeout() with
TCP_RTO_MIN as rto_base for all states.

But flows in SYN_SENT or SYN_RECV state uses a different
RTO base (1 sec instead of 200 ms, unless BPF choses
another value)

This caused a reduction of SYN retransmits from 6 to 4 with
the default /proc/sys/net/ipv4/tcp_syn_retries value.

Fixes: a41e8a88b06e ("tcp: better handle TCP_USER_TIMEOUT in SYN_SENT state")
Signed-off-by: Eric Dumazet <edumazet@google.com>
Cc: Yuchung Cheng <ycheng@google.com>
Cc: Marek Majkowski <marek@cloudflare.com>
Signed-off-by: David S. Miller <davem@davemloft.net>
Signed-off-by: Qiumiao Zhang <zhangqiumiao1@huawei.com>
---
 net/ipv4/tcp_timer.c | 9 +++++++--
 1 file changed, 7 insertions(+), 2 deletions(-)

diff --git a/net/ipv4/tcp_timer.c b/net/ipv4/tcp_timer.c
index 9e9507f125a2..d071ed6b8b9a 100644
--- a/net/ipv4/tcp_timer.c
+++ b/net/ipv4/tcp_timer.c
@@ -197,8 +197,13 @@ static bool retransmits_timed_out(struct sock *sk,
 		return false;
 
 	start_ts = tcp_sk(sk)->retrans_stamp;
-	if (likely(timeout == 0))
-		timeout = tcp_model_timeout(sk, boundary, TCP_RTO_MIN);
+	if (likely(timeout == 0)) {
+		unsigned int rto_base = TCP_RTO_MIN;
+
+		if ((1 << sk->sk_state) & (TCPF_SYN_SENT | TCPF_SYN_RECV))
+			rto_base = tcp_timeout_init(sk);
+		timeout = tcp_model_timeout(sk, boundary, rto_base);
+	}
 
 	return (s32)(tcp_time_stamp(tcp_sk(sk)) - start_ts - timeout) >= 0;
 }
-- 
2.19.1

