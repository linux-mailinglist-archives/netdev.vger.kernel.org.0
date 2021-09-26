Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id D261B418710
	for <lists+netdev@lfdr.de>; Sun, 26 Sep 2021 09:19:22 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231466AbhIZHUw (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sun, 26 Sep 2021 03:20:52 -0400
Received: from szxga02-in.huawei.com ([45.249.212.188]:19375 "EHLO
        szxga02-in.huawei.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231367AbhIZHUa (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sun, 26 Sep 2021 03:20:30 -0400
Received: from dggemv711-chm.china.huawei.com (unknown [172.30.72.55])
        by szxga02-in.huawei.com (SkyGuard) with ESMTP id 4HHH865FcLzRX23;
        Sun, 26 Sep 2021 15:14:30 +0800 (CST)
Received: from dggpeml500002.china.huawei.com (7.185.36.158) by
 dggemv711-chm.china.huawei.com (10.1.198.66) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2308.8; Sun, 26 Sep 2021 15:18:45 +0800
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
Subject: [PATCH stable 4.19 3/4] tcp: create a helper to model exponential backoff
Date:   Sun, 26 Sep 2021 15:18:41 +0800
Message-ID: <20210926071842.1429-4-zhangqiumiao1@huawei.com>
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

From: Yuchung Cheng <ycheng@google.com>

commit 01a523b071618abbc634d1958229fe3bd2dfa5fa upstream

Create a helper to model TCP exponential backoff for the next patch.
This is pure refactor w no behavior change.

Signed-off-by: Yuchung Cheng <ycheng@google.com>
Signed-off-by: Eric Dumazet <edumazet@google.com>
Reviewed-by: Neal Cardwell <ncardwell@google.com>
Reviewed-by: Soheil Hassas Yeganeh <soheil@google.com>
Signed-off-by: David S. Miller <davem@davemloft.net>
Signed-off-by: Qiumiao Zhang <zhangqiumiao1@huawei.com>
---
 net/ipv4/tcp_timer.c | 31 ++++++++++++++++++-------------
 1 file changed, 18 insertions(+), 13 deletions(-)

diff --git a/net/ipv4/tcp_timer.c b/net/ipv4/tcp_timer.c
index 9a904bf8decc..9e9507f125a2 100644
--- a/net/ipv4/tcp_timer.c
+++ b/net/ipv4/tcp_timer.c
@@ -160,7 +160,20 @@ static void tcp_mtu_probing(struct inet_connection_sock *icsk, struct sock *sk)
 	tcp_sync_mss(sk, icsk->icsk_pmtu_cookie);
 }
 
-
+static unsigned int tcp_model_timeout(struct sock *sk,
+				      unsigned int boundary,
+				      unsigned int rto_base)
+{
+	unsigned int linear_backoff_thresh, timeout;
+
+	linear_backoff_thresh = ilog2(TCP_RTO_MAX / rto_base);
+	if (boundary <= linear_backoff_thresh)
+		timeout = ((2 << boundary) - 1) * rto_base;
+	else
+		timeout = ((2 << linear_backoff_thresh) - 1) * rto_base +
+			(boundary - linear_backoff_thresh) * TCP_RTO_MAX;
+	return jiffies_to_msecs(timeout);
+}
 /**
  *  retransmits_timed_out() - returns true if this connection has timed out
  *  @sk:       The current socket
@@ -178,23 +191,15 @@ static bool retransmits_timed_out(struct sock *sk,
 				  unsigned int boundary,
 				  unsigned int timeout)
 {
-	const unsigned int rto_base = TCP_RTO_MIN;
-	unsigned int linear_backoff_thresh, start_ts;
+	unsigned int start_ts;
 
 	if (!inet_csk(sk)->icsk_retransmits)
 		return false;
 
 	start_ts = tcp_sk(sk)->retrans_stamp;
-	if (likely(timeout == 0)) {
-		linear_backoff_thresh = ilog2(TCP_RTO_MAX/rto_base);
-
-		if (boundary <= linear_backoff_thresh)
-			timeout = ((2 << boundary) - 1) * rto_base;
-		else
-			timeout = ((2 << linear_backoff_thresh) - 1) * rto_base +
-				(boundary - linear_backoff_thresh) * TCP_RTO_MAX;
-		timeout = jiffies_to_msecs(timeout);
-	}
+	if (likely(timeout == 0))
+		timeout = tcp_model_timeout(sk, boundary, TCP_RTO_MIN);
+
 	return (s32)(tcp_time_stamp(tcp_sk(sk)) - start_ts - timeout) >= 0;
 }
 
-- 
2.19.1

