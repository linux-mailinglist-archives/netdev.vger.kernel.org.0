Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id B498E418717
	for <lists+netdev@lfdr.de>; Sun, 26 Sep 2021 09:19:31 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231350AbhIZHU7 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sun, 26 Sep 2021 03:20:59 -0400
Received: from szxga01-in.huawei.com ([45.249.212.187]:11000 "EHLO
        szxga01-in.huawei.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231176AbhIZHUY (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sun, 26 Sep 2021 03:20:24 -0400
Received: from dggemv704-chm.china.huawei.com (unknown [172.30.72.56])
        by szxga01-in.huawei.com (SkyGuard) with ESMTP id 4HHHCY3ZNRzWTNr;
        Sun, 26 Sep 2021 15:17:29 +0800 (CST)
Received: from dggpeml500002.china.huawei.com (7.185.36.158) by
 dggemv704-chm.china.huawei.com (10.3.19.47) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2308.8; Sun, 26 Sep 2021 15:18:44 +0800
Received: from huawei.com (10.136.117.208) by dggpeml500002.china.huawei.com
 (7.185.36.158) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id 15.1.2308.8; Sun, 26 Sep
 2021 15:18:43 +0800
From:   Qiumiao Zhang <zhangqiumiao1@huawei.com>
To:     <linux-kernel@vger.kernel.org>
CC:     <stable@vger.kernel.org>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        Sasha Levin <sasha.levin@oracle.com>,
        "David S . Miller" <davem@davemloft.net>,
        Alexey Kuznetsov <kuznet@ms2.inr.ac.ru>,
        <netdev@vger.kernel.org>, <yanan@huawei.com>,
        <rose.chen@huawei.com>
Subject: [PATCH stable 4.19 1/4] tcp: address problems caused by EDT misshaps
Date:   Sun, 26 Sep 2021 15:18:39 +0800
Message-ID: <20210926071842.1429-2-zhangqiumiao1@huawei.com>
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

commit 9efdda4e3abed13f0903b7b6e4d4c2102019440a upstream

When a qdisc setup including pacing FQ is dismantled and recreated,
some TCP packets are sent earlier than instructed by TCP stack.

TCP can be fooled when ACK comes back, because the following
operation can return a negative value.

    tcp_time_stamp(tp) - tp->rx_opt.rcv_tsecr;

Some paths in TCP stack were not dealing properly with this,
this patch addresses four of them.

Fixes: ab408b6dc744 ("tcp: switch tcp and sch_fq to new earliest departure time model")
Signed-off-by: Eric Dumazet <edumazet@google.com>
Signed-off-by: David S. Miller <davem@davemloft.net>
Signed-off-by: Qiumiao Zhang <zhangqiumiao1@huawei.com>
---
 net/ipv4/tcp_input.c | 16 ++++++++++------
 net/ipv4/tcp_timer.c | 10 ++++++----
 2 files changed, 16 insertions(+), 10 deletions(-)

diff --git a/net/ipv4/tcp_input.c b/net/ipv4/tcp_input.c
index a058fb936c2a..2a5f7db9a653 100644
--- a/net/ipv4/tcp_input.c
+++ b/net/ipv4/tcp_input.c
@@ -581,10 +581,12 @@ static inline void tcp_rcv_rtt_measure_ts(struct sock *sk,
 		u32 delta = tcp_time_stamp(tp) - tp->rx_opt.rcv_tsecr;
 		u32 delta_us;
 
-		if (!delta)
-			delta = 1;
-		delta_us = delta * (USEC_PER_SEC / TCP_TS_HZ);
-		tcp_rcv_rtt_update(tp, delta_us, 0);
+		if (likely(delta < INT_MAX / (USEC_PER_SEC / TCP_TS_HZ))) {
+			if (!delta)
+				delta = 1;
+			delta_us = delta * (USEC_PER_SEC / TCP_TS_HZ);
+			tcp_rcv_rtt_update(tp, delta_us, 0);
+		}
 	}
 }
 
@@ -2934,9 +2936,11 @@ static bool tcp_ack_update_rtt(struct sock *sk, const int flag,
 	if (seq_rtt_us < 0 && tp->rx_opt.saw_tstamp && tp->rx_opt.rcv_tsecr &&
 	    flag & FLAG_ACKED) {
 		u32 delta = tcp_time_stamp(tp) - tp->rx_opt.rcv_tsecr;
-		u32 delta_us = delta * (USEC_PER_SEC / TCP_TS_HZ);
 
-		seq_rtt_us = ca_rtt_us = delta_us;
+		if (likely(delta < INT_MAX / (USEC_PER_SEC / TCP_TS_HZ))) {
+			seq_rtt_us = delta * (USEC_PER_SEC / TCP_TS_HZ);
+			ca_rtt_us = seq_rtt_us;
+		}
 	}
 	rs->rtt_us = ca_rtt_us; /* RTT of last (S)ACKed packet (or -1) */
 	if (seq_rtt_us < 0)
diff --git a/net/ipv4/tcp_timer.c b/net/ipv4/tcp_timer.c
index 681882a40968..7c7f7e6cd955 100644
--- a/net/ipv4/tcp_timer.c
+++ b/net/ipv4/tcp_timer.c
@@ -40,15 +40,17 @@ static u32 tcp_clamp_rto_to_user_timeout(const struct sock *sk)
 {
 	struct inet_connection_sock *icsk = inet_csk(sk);
 	u32 elapsed, start_ts;
+	s32 remaining;
 
 	start_ts = tcp_retransmit_stamp(sk);
 	if (!icsk->icsk_user_timeout || !start_ts)
 		return icsk->icsk_rto;
 	elapsed = tcp_time_stamp(tcp_sk(sk)) - start_ts;
-	if (elapsed >= icsk->icsk_user_timeout)
+	remaining = icsk->icsk_user_timeout - elapsed;
+	if (remaining <= 0)
 		return 1; /* user timeout has passed; fire ASAP */
-	else
-		return min_t(u32, icsk->icsk_rto, msecs_to_jiffies(icsk->icsk_user_timeout - elapsed));
+
+	return min_t(u32, icsk->icsk_rto, msecs_to_jiffies(remaining));
 }
 
 /**
@@ -210,7 +212,7 @@ static bool retransmits_timed_out(struct sock *sk,
 				(boundary - linear_backoff_thresh) * TCP_RTO_MAX;
 		timeout = jiffies_to_msecs(timeout);
 	}
-	return (tcp_time_stamp(tcp_sk(sk)) - start_ts) >= timeout;
+	return (s32)(tcp_time_stamp(tcp_sk(sk)) - start_ts - timeout) >= 0;
 }
 
 /* A write timeout has occurred. Process the after effects. */
-- 
2.19.1

