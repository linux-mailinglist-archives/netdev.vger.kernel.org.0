Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 636341E1ED9
	for <lists+netdev@lfdr.de>; Tue, 26 May 2020 11:39:25 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2388724AbgEZJjS (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 26 May 2020 05:39:18 -0400
Received: from mail-db8eur05on2125.outbound.protection.outlook.com ([40.107.20.125]:25953
        "EHLO EUR05-DB8-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S2388704AbgEZJjR (ORCPT <rfc822;netdev@vger.kernel.org>);
        Tue, 26 May 2020 05:39:17 -0400
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=d0WEvYaiwapNil/TI0zr7KR4tCMMVU9YYiXscqXTWPe4rcSVqabvU82/Zf0fNkxKfK1iFTAqRL1etauGe2tc1bje+cljfuw6+hnc/7fPQADG8LRCV/0Fuj0QZEouWn09d/zZ/z/cL6H3b4hEarT8Rdln8cmjAenyov/1119ENa5X9r3s5T6LieJ9OEaqHe83NXeWFqRJlekqp9CfFTJZE6QYWkL+PziaKA6pfbzxfhzHr7LJ61fMVsydAJe/1IEfaNJbq7n9dRweBbOEgMG+9cYqGMoY8r0tBEtVNB7IQ1eAdisTWm8KIfNiC3Jm3QzYMmMkC4LCwO0Q9Yhda0Y/rQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=CTFw79NPAHW5+YbOTDoUVkSxqhWOJ5it5fp/dkiDdWw=;
 b=PqaQ/G51hpH+dQC7dHxKQAsXrQ7Vzz2FDCxvHLVX+vgTAtezF98ogR8AudfKvIku3qlBkIc+vsu1o0J2FjKVFcMBDh3eiTOUVfMoqukbTeftNpKpnpJCslUzTkY8Fw4kdOlga++G3+IdhKJEwXfMOKjLFy5T8fAT55+K9U1IqQIJii/Aw4R5jdTTEYJkntXyOfk+woY9mt0dbfR/LU+izoHdxG9wuCn6WiN2ZZkoWKXXbxx+4iLYMzzYM14ZhEjc+61sKV0YKtD/W5yCn49tRS5ZEtX9Ldp9rmV7UgpKzXkq3LvsW76n69oe9xVSzdsmz/3NrCALROuyabo7L1a7nw==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=dektech.com.au; dmarc=pass action=none
 header.from=dektech.com.au; dkim=pass header.d=dektech.com.au; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=dektech.com.au;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=CTFw79NPAHW5+YbOTDoUVkSxqhWOJ5it5fp/dkiDdWw=;
 b=BRe/XIa0VGew04cchN6Cz9d0IowEoIS1TmwGzTkl2godmsbPViTog2We4RYvUxyiz21c+b8XvkOCGFYe9oaxrLGh7Z2+IUg3pb8WWTvN4DJW0t7aSg4oTDIYdnyyEeWt9C5gn4TSnkIDODWlsyfv1HFisEGT7dgdTdnZwc0oQ/g=
Authentication-Results: davemloft.net; dkim=none (message not signed)
 header.d=none;davemloft.net; dmarc=none action=none
 header.from=dektech.com.au;
Received: from AM6PR0502MB3925.eurprd05.prod.outlook.com (2603:10a6:209:5::28)
 by AM6PR0502MB3718.eurprd05.prod.outlook.com (2603:10a6:209:11::29) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.3021.27; Tue, 26 May
 2020 09:38:59 +0000
Received: from AM6PR0502MB3925.eurprd05.prod.outlook.com
 ([fe80::4d5f:2ab:5a66:deaf]) by AM6PR0502MB3925.eurprd05.prod.outlook.com
 ([fe80::4d5f:2ab:5a66:deaf%7]) with mapi id 15.20.3021.029; Tue, 26 May 2020
 09:38:59 +0000
From:   Tuong Lien <tuong.t.lien@dektech.com.au>
To:     davem@davemloft.net, jmaloy@redhat.com, maloy@donjonn.com,
        ying.xue@windriver.com, netdev@vger.kernel.org
Cc:     tipc-discussion@lists.sourceforge.net
Subject: [net-next 5/5] tipc: add test for Nagle algorithm effectiveness
Date:   Tue, 26 May 2020 16:38:38 +0700
Message-Id: <20200526093838.17421-6-tuong.t.lien@dektech.com.au>
X-Mailer: git-send-email 2.13.7
In-Reply-To: <20200526093838.17421-1-tuong.t.lien@dektech.com.au>
References: <20200526093838.17421-1-tuong.t.lien@dektech.com.au>
Content-Type: text/plain
X-ClientProxiedBy: HK2PR03CA0060.apcprd03.prod.outlook.com
 (2603:1096:202:17::30) To AM6PR0502MB3925.eurprd05.prod.outlook.com
 (2603:10a6:209:5::28)
MIME-Version: 1.0
X-MS-Exchange-MessageSentRepresentingType: 1
Received: from dektech.com.au (14.161.14.188) by HK2PR03CA0060.apcprd03.prod.outlook.com (2603:1096:202:17::30) with Microsoft SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_CBC_SHA256) id 15.20.3045.8 via Frontend Transport; Tue, 26 May 2020 09:38:57 +0000
X-Mailer: git-send-email 2.13.7
X-Originating-IP: [14.161.14.188]
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: 7bf37cfc-085b-4da2-fd4d-08d801589e10
X-MS-TrafficTypeDiagnostic: AM6PR0502MB3718:
X-Microsoft-Antispam-PRVS: <AM6PR0502MB37185246922D4EC0A6E1EBC8E2B00@AM6PR0502MB3718.eurprd05.prod.outlook.com>
X-MS-Oob-TLC-OOBClassifiers: OLM:9508;
X-Forefront-PRVS: 041517DFAB
X-MS-Exchange-SenderADCheck: 1
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: oO8+xj/kRnZ5vtei0jkNegMm30Jh5ul/R8ChRiY4PmwZ7tP7+TqlSs3aUJwKVMpnTBqWJYMTiZsY1zt8vpaiHoaIJh6XLd8lEUkzScIL8mE+8725G/J7cZhUsU+2a/qWPHplxD1etFSzlPe3OizuH7LgdjmtV1uSGaT/PNVVsSyi/xr1nsFPI+GoPNM/4uOdCq8WaQ/lcjGSlDRWQQOVWtwvvni5tr3h3O9hIyJ3QBUR6E1n6HnEc3nrVMPITggGk4qEkR0USW4TnUj7Z+SYebcspbGplEyToRKmg6dPKZDXXbz5xvNbLgLNlnK3+SQV
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:AM6PR0502MB3925.eurprd05.prod.outlook.com;PTR:;CAT:NONE;SFTY:;SFS:(396003)(346002)(366004)(376002)(136003)(39850400004)(8676002)(16526019)(956004)(2616005)(103116003)(55016002)(186003)(6666004)(4326008)(66476007)(66556008)(2906002)(86362001)(36756003)(316002)(5660300002)(26005)(66946007)(8936002)(52116002)(1076003)(478600001)(7696005);DIR:OUT;SFP:1102;
X-MS-Exchange-AntiSpam-MessageData: 9ujbErDlYmfbC88vIUGwkQGD3hGau5HfflUjmqzqlL4s+FLkTHnExYwrYxDQXd8LFAwHwrUDK4UwKSMbCtV9cAMPDYFfW8I94rxa1/TYLnAnHG0ks1sS3U3m9ypeHZ+roWGAfLSjdJ3h+0TR47wAIPiAj9lUWvGbKDnxqXe2nWfGSy5hBL9+dxGdtB9Eqs+IxBUq2qqzP387jGOgEJ4dQygmIf9xRVK8ZB/lCSJpUoMs01DQpBEbpz8Ddx8llkSm7+kJwNtyT/DSD+QYIfyex5fqCe01+Y77bbe1nWJQPdSD8oFNvDTIHe9J5hS3LO0blAfN9BcWZvIsRV09mj6m/a1EDOaVt1BgSz4mwtso2dBj79B3rR6DXmAvtcISf+XHc0GB0IMdI2TXAsZ7aw6R4b4g3Ss0XFi0RQVu9bEYcEunzK/tPIywV6gw/mIqWXcVPhIMXyQiogc19xvIh8/Q/Wqbhw3YUjCM5tGgWI4NETs=
X-OriginatorOrg: dektech.com.au
X-MS-Exchange-CrossTenant-Network-Message-Id: 7bf37cfc-085b-4da2-fd4d-08d801589e10
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 26 May 2020 09:38:59.7076
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 1957ea50-0dd8-4360-8db0-c9530df996b2
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: kzq+FQX4bK58RoW2jGm9DDnhQHv5F+aBnINEkRYJL1nMLs+kUHJSYkhrav1HwzY0H/VXDDJ1NdvAbwUH/IaJqIzuJPd2OlmqS3WoKVhQ4/E=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: AM6PR0502MB3718
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

When streaming in Nagle mode, we try to bundle small messages from user
as many as possible if there is one outstanding buffer, i.e. not ACK-ed
by the receiving side, which helps boost up the overall throughput. So,
the algorithm's effectiveness really depends on when Nagle ACK comes or
what the specific network latency (RTT) is, compared to the user's
message sending rate.

In a bad case, the user's sending rate is low or the network latency is
small, there will not be many bundles, so making a Nagle ACK or waiting
for it is not meaningful.
For example: a user sends its messages every 100ms and the RTT is 50ms,
then for each messages, we require one Nagle ACK but then there is only
one user message sent without any bundles.

In a better case, even if we have a few bundles (e.g. the RTT = 300ms),
but now the user sends messages in medium size, then there will not be
any difference at all, that says 3 x 1000-byte data messages if bundled
will still result in 3 bundles with MTU = 1500.

When Nagle is ineffective, the delay in user message sending is clearly
wasted instead of sending directly.

Besides, adding Nagle ACKs will consume some processor load on both the
sending and receiving sides.

This commit adds a test on the effectiveness of the Nagle algorithm for
an individual connection in the network on which it actually runs.
Particularly, upon receipt of a Nagle ACK we will compare the number of
bundles in the backlog queue to the number of user messages which would
be sent directly without Nagle. If the ratio is good (e.g. >= 2), Nagle
mode will be kept for further message sending. Otherwise, we will leave
Nagle and put a 'penalty' on the connection, so it will have to spend
more 'one-way' messages before being able to re-enter Nagle.

In addition, the 'ack-required' bit is only set when really needed that
the number of Nagle ACKs will be reduced during Nagle mode.

Testing with benchmark showed that with the patch, there was not much
difference in throughput for small messages since the tool continuously
sends messages without a break, so Nagle would still take in effect.

Acked-by: Ying Xue <ying.xue@windriver.com>
Acked-by: Jon Maloy <jmaloy@redhat.com>
Signed-off-by: Tuong Lien <tuong.t.lien@dektech.com.au>
---
 net/tipc/msg.c    |  3 ---
 net/tipc/msg.h    | 14 ++++++++++--
 net/tipc/socket.c | 64 ++++++++++++++++++++++++++++++++++++++++++++-----------
 3 files changed, 64 insertions(+), 17 deletions(-)

diff --git a/net/tipc/msg.c b/net/tipc/msg.c
index c69fb99163fc..23809039dda1 100644
--- a/net/tipc/msg.c
+++ b/net/tipc/msg.c
@@ -235,9 +235,6 @@ int tipc_msg_append(struct tipc_msg *_hdr, struct msghdr *m, int dlen,
 			msg_set_size(hdr, MIN_H_SIZE);
 			__skb_queue_tail(txq, skb);
 			total += 1;
-			if (prev)
-				msg_set_ack_required(buf_msg(prev), 0);
-			msg_set_ack_required(hdr, 1);
 		}
 		hdr = buf_msg(skb);
 		curr = msg_blocks(hdr);
diff --git a/net/tipc/msg.h b/net/tipc/msg.h
index cd4281779468..58660d56bc83 100644
--- a/net/tipc/msg.h
+++ b/net/tipc/msg.h
@@ -340,9 +340,19 @@ static inline int msg_ack_required(struct tipc_msg *m)
 	return msg_bits(m, 0, 18, 1);
 }
 
-static inline void msg_set_ack_required(struct tipc_msg *m, u32 d)
+static inline void msg_set_ack_required(struct tipc_msg *m)
 {
-	msg_set_bits(m, 0, 18, 1, d);
+	msg_set_bits(m, 0, 18, 1, 1);
+}
+
+static inline int msg_nagle_ack(struct tipc_msg *m)
+{
+	return msg_bits(m, 0, 18, 1);
+}
+
+static inline void msg_set_nagle_ack(struct tipc_msg *m)
+{
+	msg_set_bits(m, 0, 18, 1, 1);
 }
 
 static inline bool msg_is_rcast(struct tipc_msg *m)
diff --git a/net/tipc/socket.c b/net/tipc/socket.c
index e370ad0edd76..d6b67d07d22e 100644
--- a/net/tipc/socket.c
+++ b/net/tipc/socket.c
@@ -48,6 +48,8 @@
 #include "group.h"
 #include "trace.h"
 
+#define NAGLE_START_INIT	4
+#define NAGLE_START_MAX		1024
 #define CONN_TIMEOUT_DEFAULT    8000    /* default connect timeout = 8s */
 #define CONN_PROBING_INTV	msecs_to_jiffies(3600000)  /* [ms] => 1 h */
 #define TIPC_FWD_MSG		1
@@ -119,7 +121,10 @@ struct tipc_sock {
 	struct rcu_head rcu;
 	struct tipc_group *group;
 	u32 oneway;
+	u32 nagle_start;
 	u16 snd_backlog;
+	u16 msg_acc;
+	u16 pkt_cnt;
 	bool expect_ack;
 	bool nodelay;
 	bool group_is_open;
@@ -143,7 +148,7 @@ static int tipc_sk_insert(struct tipc_sock *tsk);
 static void tipc_sk_remove(struct tipc_sock *tsk);
 static int __tipc_sendstream(struct socket *sock, struct msghdr *m, size_t dsz);
 static int __tipc_sendmsg(struct socket *sock, struct msghdr *m, size_t dsz);
-static void tipc_sk_push_backlog(struct tipc_sock *tsk);
+static void tipc_sk_push_backlog(struct tipc_sock *tsk, bool nagle_ack);
 
 static const struct proto_ops packet_ops;
 static const struct proto_ops stream_ops;
@@ -474,6 +479,7 @@ static int tipc_sk_create(struct net *net, struct socket *sock,
 	tsk = tipc_sk(sk);
 	tsk->max_pkt = MAX_PKT_DEFAULT;
 	tsk->maxnagle = 0;
+	tsk->nagle_start = NAGLE_START_INIT;
 	INIT_LIST_HEAD(&tsk->publications);
 	INIT_LIST_HEAD(&tsk->cong_links);
 	msg = &tsk->phdr;
@@ -541,7 +547,7 @@ static void __tipc_shutdown(struct socket *sock, int error)
 					    !tsk_conn_cong(tsk)));
 
 	/* Push out delayed messages if in Nagle mode */
-	tipc_sk_push_backlog(tsk);
+	tipc_sk_push_backlog(tsk, false);
 	/* Remove pending SYN */
 	__skb_queue_purge(&sk->sk_write_queue);
 
@@ -1252,14 +1258,37 @@ void tipc_sk_mcast_rcv(struct net *net, struct sk_buff_head *arrvq,
 /* tipc_sk_push_backlog(): send accumulated buffers in socket write queue
  *                         when socket is in Nagle mode
  */
-static void tipc_sk_push_backlog(struct tipc_sock *tsk)
+static void tipc_sk_push_backlog(struct tipc_sock *tsk, bool nagle_ack)
 {
 	struct sk_buff_head *txq = &tsk->sk.sk_write_queue;
+	struct sk_buff *skb = skb_peek_tail(txq);
 	struct net *net = sock_net(&tsk->sk);
 	u32 dnode = tsk_peer_node(tsk);
-	struct sk_buff *skb = skb_peek(txq);
 	int rc;
 
+	if (nagle_ack) {
+		tsk->pkt_cnt += skb_queue_len(txq);
+		if (!tsk->pkt_cnt || tsk->msg_acc / tsk->pkt_cnt < 2) {
+			tsk->oneway = 0;
+			if (tsk->nagle_start < NAGLE_START_MAX)
+				tsk->nagle_start *= 2;
+			tsk->expect_ack = false;
+			pr_debug("tsk %10u: bad nagle %u -> %u, next start %u!\n",
+				 tsk->portid, tsk->msg_acc, tsk->pkt_cnt,
+				 tsk->nagle_start);
+		} else {
+			tsk->nagle_start = NAGLE_START_INIT;
+			if (skb) {
+				msg_set_ack_required(buf_msg(skb));
+				tsk->expect_ack = true;
+			} else {
+				tsk->expect_ack = false;
+			}
+		}
+		tsk->msg_acc = 0;
+		tsk->pkt_cnt = 0;
+	}
+
 	if (!skb || tsk->cong_link_cnt)
 		return;
 
@@ -1267,9 +1296,10 @@ static void tipc_sk_push_backlog(struct tipc_sock *tsk)
 	if (msg_is_syn(buf_msg(skb)))
 		return;
 
+	if (tsk->msg_acc)
+		tsk->pkt_cnt += skb_queue_len(txq);
 	tsk->snt_unacked += tsk->snd_backlog;
 	tsk->snd_backlog = 0;
-	tsk->expect_ack = true;
 	rc = tipc_node_xmit(net, txq, dnode, tsk->portid);
 	if (rc == -ELINKCONG)
 		tsk->cong_link_cnt = 1;
@@ -1322,8 +1352,7 @@ static void tipc_sk_conn_proto_rcv(struct tipc_sock *tsk, struct sk_buff *skb,
 		return;
 	} else if (mtyp == CONN_ACK) {
 		was_cong = tsk_conn_cong(tsk);
-		tsk->expect_ack = false;
-		tipc_sk_push_backlog(tsk);
+		tipc_sk_push_backlog(tsk, msg_nagle_ack(hdr));
 		tsk->snt_unacked -= msg_conn_ack(hdr);
 		if (tsk->peer_caps & TIPC_BLOCK_FLOWCTL)
 			tsk->snd_win = msg_adv_win(hdr);
@@ -1516,6 +1545,7 @@ static int __tipc_sendstream(struct socket *sock, struct msghdr *m, size_t dlen)
 	struct tipc_sock *tsk = tipc_sk(sk);
 	struct tipc_msg *hdr = &tsk->phdr;
 	struct net *net = sock_net(sk);
+	struct sk_buff *skb;
 	u32 dnode = tsk_peer_node(tsk);
 	int maxnagle = tsk->maxnagle;
 	int maxpkt = tsk->max_pkt;
@@ -1544,17 +1574,25 @@ static int __tipc_sendstream(struct socket *sock, struct msghdr *m, size_t dlen)
 			break;
 		send = min_t(size_t, dlen - sent, TIPC_MAX_USER_MSG_SIZE);
 		blocks = tsk->snd_backlog;
-		if (tsk->oneway++ >= 4 && send <= maxnagle) {
+		if (tsk->oneway++ >= tsk->nagle_start && send <= maxnagle) {
 			rc = tipc_msg_append(hdr, m, send, maxnagle, txq);
 			if (unlikely(rc < 0))
 				break;
 			blocks += rc;
+			tsk->msg_acc++;
 			if (blocks <= 64 && tsk->expect_ack) {
 				tsk->snd_backlog = blocks;
 				sent += send;
 				break;
+			} else if (blocks > 64) {
+				tsk->pkt_cnt += skb_queue_len(txq);
+			} else {
+				skb = skb_peek_tail(txq);
+				msg_set_ack_required(buf_msg(skb));
+				tsk->expect_ack = true;
+				tsk->msg_acc = 0;
+				tsk->pkt_cnt = 0;
 			}
-			tsk->expect_ack = true;
 		} else {
 			rc = tipc_msg_build(hdr, m, sent, send, maxpkt, txq);
 			if (unlikely(rc != send))
@@ -2091,7 +2129,7 @@ static void tipc_sk_proto_rcv(struct sock *sk,
 		smp_wmb();
 		tsk->cong_link_cnt--;
 		wakeup = true;
-		tipc_sk_push_backlog(tsk);
+		tipc_sk_push_backlog(tsk, false);
 		break;
 	case GROUP_PROTOCOL:
 		tipc_group_proto_rcv(grp, &wakeup, hdr, inputq, xmitq);
@@ -2180,7 +2218,7 @@ static bool tipc_sk_filter_connect(struct tipc_sock *tsk, struct sk_buff *skb,
 		return false;
 	case TIPC_ESTABLISHED:
 		if (!skb_queue_empty(&sk->sk_write_queue))
-			tipc_sk_push_backlog(tsk);
+			tipc_sk_push_backlog(tsk, false);
 		/* Accept only connection-based messages sent by peer */
 		if (likely(con_msg && !err && pport == oport &&
 			   pnode == onode)) {
@@ -2188,8 +2226,10 @@ static bool tipc_sk_filter_connect(struct tipc_sock *tsk, struct sk_buff *skb,
 				struct sk_buff *skb;
 
 				skb = tipc_sk_build_ack(tsk);
-				if (skb)
+				if (skb) {
+					msg_set_nagle_ack(buf_msg(skb));
 					__skb_queue_tail(xmitq, skb);
+				}
 			}
 			return true;
 		}
-- 
2.13.7

