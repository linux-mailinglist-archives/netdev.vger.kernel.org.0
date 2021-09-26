Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 6AE91418716
	for <lists+netdev@lfdr.de>; Sun, 26 Sep 2021 09:19:31 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231431AbhIZHVA (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sun, 26 Sep 2021 03:21:00 -0400
Received: from szxga08-in.huawei.com ([45.249.212.255]:20155 "EHLO
        szxga08-in.huawei.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231185AbhIZHUY (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sun, 26 Sep 2021 03:20:24 -0400
Received: from dggemv703-chm.china.huawei.com (unknown [172.30.72.53])
        by szxga08-in.huawei.com (SkyGuard) with ESMTP id 4HHHCZ1vPdz1DHFX;
        Sun, 26 Sep 2021 15:17:30 +0800 (CST)
Received: from dggpeml500002.china.huawei.com (7.185.36.158) by
 dggemv703-chm.china.huawei.com (10.3.19.46) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2308.8; Sun, 26 Sep 2021 15:18:45 +0800
Received: from huawei.com (10.136.117.208) by dggpeml500002.china.huawei.com
 (7.185.36.158) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id 15.1.2308.8; Sun, 26 Sep
 2021 15:18:44 +0800
From:   Qiumiao Zhang <zhangqiumiao1@huawei.com>
To:     <linux-kernel@vger.kernel.org>
CC:     <stable@vger.kernel.org>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        Sasha Levin <sasha.levin@oracle.com>,
        "David S . Miller" <davem@davemloft.net>,
        Alexey Kuznetsov <kuznet@ms2.inr.ac.ru>,
        <netdev@vger.kernel.org>, <yanan@huawei.com>,
        <rose.chen@huawei.com>
Subject: [PATCH stable 4.19 2/4] tcp: always set retrans_stamp on recovery
Date:   Sun, 26 Sep 2021 15:18:40 +0800
Message-ID: <20210926071842.1429-3-zhangqiumiao1@huawei.com>
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

commit 7ae189759cc48cf8b54beebff566e9fd2d4e7d7c upstream

Previously TCP socket's retrans_stamp is not set if the
retransmission has failed to send. As a result if a socket is
experiencing local issues to retransmit packets, determining when
to abort a socket is complicated w/o knowning the starting time of
the recovery since retrans_stamp may remain zero.

This complication causes sub-optimal behavior that TCP may use the
latest, instead of the first, retransmission time to compute the
elapsed time of a stalling connection due to local issues. Then TCP
may disrecard TCP retries settings and keep retrying until it finally
succeed: not a good idea when the local host is already strained.

The simple fix is to always timestamp the start of a recovery.
It's worth noting that retrans_stamp is also used to compare echo
timestamp values to detect spurious recovery. This patch does
not break that because retrans_stamp is still later than when the
original packet was sent.

Signed-off-by: Yuchung Cheng <ycheng@google.com>
Signed-off-by: Eric Dumazet <edumazet@google.com>
Reviewed-by: Neal Cardwell <ncardwell@google.com>
Reviewed-by: Soheil Hassas Yeganeh <soheil@google.com>
Signed-off-by: David S. Miller <davem@davemloft.net>
Signed-off-by: Qiumiao Zhang <zhangqiumiao1@huawei.com>
---
 net/ipv4/tcp_output.c |  9 ++++-----
 net/ipv4/tcp_timer.c  | 23 +++--------------------
 2 files changed, 7 insertions(+), 25 deletions(-)

diff --git a/net/ipv4/tcp_output.c b/net/ipv4/tcp_output.c
index 97b9d671a83c..6710056fd1b2 100644
--- a/net/ipv4/tcp_output.c
+++ b/net/ipv4/tcp_output.c
@@ -3011,13 +3011,12 @@ int tcp_retransmit_skb(struct sock *sk, struct sk_buff *skb, int segs)
 #endif
 		TCP_SKB_CB(skb)->sacked |= TCPCB_RETRANS;
 		tp->retrans_out += tcp_skb_pcount(skb);
-
-		/* Save stamp of the first retransmit. */
-		if (!tp->retrans_stamp)
-			tp->retrans_stamp = tcp_skb_timestamp(skb);
-
 	}
 
+	/* Save stamp of the first (attempted) retransmit. */
+	if (!tp->retrans_stamp)
+		tp->retrans_stamp = tcp_skb_timestamp(skb);
+
 	if (tp->undo_retrans < 0)
 		tp->undo_retrans = 0;
 	tp->undo_retrans += tcp_skb_pcount(skb);
diff --git a/net/ipv4/tcp_timer.c b/net/ipv4/tcp_timer.c
index 7c7f7e6cd955..9a904bf8decc 100644
--- a/net/ipv4/tcp_timer.c
+++ b/net/ipv4/tcp_timer.c
@@ -22,28 +22,14 @@
 #include <linux/gfp.h>
 #include <net/tcp.h>
 
-static u32 tcp_retransmit_stamp(const struct sock *sk)
-{
-	u32 start_ts = tcp_sk(sk)->retrans_stamp;
-
-	if (unlikely(!start_ts)) {
-		struct sk_buff *head = tcp_rtx_queue_head(sk);
-
-		if (!head)
-			return 0;
-		start_ts = tcp_skb_timestamp(head);
-	}
-	return start_ts;
-}
-
 static u32 tcp_clamp_rto_to_user_timeout(const struct sock *sk)
 {
 	struct inet_connection_sock *icsk = inet_csk(sk);
 	u32 elapsed, start_ts;
 	s32 remaining;
 
-	start_ts = tcp_retransmit_stamp(sk);
-	if (!icsk->icsk_user_timeout || !start_ts)
+	start_ts = tcp_sk(sk)->retrans_stamp;
+	if (!icsk->icsk_user_timeout)
 		return icsk->icsk_rto;
 	elapsed = tcp_time_stamp(tcp_sk(sk)) - start_ts;
 	remaining = icsk->icsk_user_timeout - elapsed;
@@ -198,10 +184,7 @@ static bool retransmits_timed_out(struct sock *sk,
 	if (!inet_csk(sk)->icsk_retransmits)
 		return false;
 
-	start_ts = tcp_retransmit_stamp(sk);
-	if (!start_ts)
-		return false;
-
+	start_ts = tcp_sk(sk)->retrans_stamp;
 	if (likely(timeout == 0)) {
 		linear_backoff_thresh = ilog2(TCP_RTO_MAX/rto_base);
 
-- 
2.19.1

