Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 864B21D12C5
	for <lists+netdev@lfdr.de>; Wed, 13 May 2020 14:33:53 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1731816AbgEMMdg (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 13 May 2020 08:33:36 -0400
Received: from mail-eopbgr80117.outbound.protection.outlook.com ([40.107.8.117]:4078
        "EHLO EUR04-VI1-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1731497AbgEMMde (ORCPT <rfc822;netdev@vger.kernel.org>);
        Wed, 13 May 2020 08:33:34 -0400
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=g1q6U5upF1dcvjfZmOKBYK31ODCGdJlpJFleXWh+1oMcz5Vzr1krkP/sg3i0pVckm0lmQA2IBGC0kApZheccaCWSrnc9OwuX+kWFLMX0VjQz00ZUTxxRyKaKiyCTYZ6YAY6e6B6s56cvIuRODTP+J7vSBB0JzbrdhbJ22SShrnzJAgQ/oTFzc8sbfGpoVbMbRQWdKCH8ijnsvTr0ZD2pRm6y4+ZIh0+xYUfU1SS9eZP/PT4AtcYSrfYhpQ47Z3RnRwbWUnxZLFpp4bu4L6UVwgfiXiSBXn+lR1x+GhDO4YlGipMHn1eKLrhxM2/a8RxnuLI4E5gizl1DsubtRMDwPQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=WwTT1uMAAjJT77rPb5XIyIW0yt7hU/eQriQ+4qQ8oYg=;
 b=DUlJdSciydE7wbK6KG5aY36bKPlUjv1S2JZFId2qnpFddypgCGmuJL1S2ly2h6SeyW8GmlJlW4pVQOBF/jkNNM1j5V9hWd5l+cdm0tVQPzyC3rBmY5oIujP6YFzH7ce5pSMUG2/b6l0QSlC73G2Dp77Sb/17LqZlhD/jUpeM3JjnVe3Z7xaTGbRNMkBV+322bRNoflrn1Kgw3b8IkJ9Wjz7jF6ac25WcCEnmcOvLFzREkQLWAaUioPruIIsxs3g/r+wV9dn9dbKoiJ9mb13Wncb5PnwODe97y3FoR5uRMEz5nf0hVZ/CPETAknL26VFcasDLXtHiEj4llNnJBG3q8Q==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=dektech.com.au; dmarc=pass action=none
 header.from=dektech.com.au; dkim=pass header.d=dektech.com.au; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=dektech.com.au;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=WwTT1uMAAjJT77rPb5XIyIW0yt7hU/eQriQ+4qQ8oYg=;
 b=PMHf1y2xxgD11pMPivtl/Ku5jakNSCtKFHqDTgVl5ACDRA5lKBISh73yJ9GBvRYGIehvBDcU6HQvN/AtYO5sSyHlz1AsdfGj09OpyrMpnQEZ3NZXIUDkCjr6mTo1SWtoHuukVTw5cWqqlh8mAdcvyb1sTsnr0qpwMgMU/ZPlfek=
Authentication-Results: davemloft.net; dkim=none (message not signed)
 header.d=none;davemloft.net; dmarc=none action=none
 header.from=dektech.com.au;
Received: from AM6PR0502MB3925.eurprd05.prod.outlook.com (2603:10a6:209:5::28)
 by AM6SPR01MB0038.eurprd05.prod.outlook.com (2603:10a6:20b:3b::13) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.3000.20; Wed, 13 May
 2020 12:33:29 +0000
Received: from AM6PR0502MB3925.eurprd05.prod.outlook.com
 ([fe80::4d5f:2ab:5a66:deaf]) by AM6PR0502MB3925.eurprd05.prod.outlook.com
 ([fe80::4d5f:2ab:5a66:deaf%7]) with mapi id 15.20.3000.016; Wed, 13 May 2020
 12:33:29 +0000
From:   Tuong Lien <tuong.t.lien@dektech.com.au>
To:     davem@davemloft.net, jmaloy@redhat.com, maloy@donjonn.com,
        ying.xue@windriver.com, netdev@vger.kernel.org
Cc:     tipc-discussion@lists.sourceforge.net
Subject: [net 1/3] tipc: fix large latency in smart Nagle streaming
Date:   Wed, 13 May 2020 19:33:16 +0700
Message-Id: <20200513123318.1435-2-tuong.t.lien@dektech.com.au>
X-Mailer: git-send-email 2.13.7
In-Reply-To: <20200513123318.1435-1-tuong.t.lien@dektech.com.au>
References: <20200513123318.1435-1-tuong.t.lien@dektech.com.au>
Content-Type: text/plain
X-ClientProxiedBy: HK2PR02CA0203.apcprd02.prod.outlook.com
 (2603:1096:201:20::15) To AM6PR0502MB3925.eurprd05.prod.outlook.com
 (2603:10a6:209:5::28)
MIME-Version: 1.0
X-MS-Exchange-MessageSentRepresentingType: 1
Received: from dektech.com.au (14.161.14.188) by HK2PR02CA0203.apcprd02.prod.outlook.com (2603:1096:201:20::15) with Microsoft SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_CBC_SHA256) id 15.20.3000.20 via Frontend Transport; Wed, 13 May 2020 12:33:27 +0000
X-Mailer: git-send-email 2.13.7
X-Originating-IP: [14.161.14.188]
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: 086779de-2820-4b0c-ad41-08d7f739d74e
X-MS-TrafficTypeDiagnostic: AM6SPR01MB0038:
X-Microsoft-Antispam-PRVS: <AM6SPR01MB0038BBCF920F6E3D7AF73FA4E2BF0@AM6SPR01MB0038.eurprd05.prod.outlook.com>
X-MS-Oob-TLC-OOBClassifiers: OLM:1303;
X-Forefront-PRVS: 0402872DA1
X-MS-Exchange-SenderADCheck: 1
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: ZCRT+DMzjpIBIlgU3JK677XjjqOZwdUIeXcf9VlNcPu8gyc2rw94a/0EzNIXp3tCJzxln9dGQOzXVL4bOkf1e+gks2j4X3Aj0pUPmcaWnDgqmM+UAk8WU5dxtB8QZyRK5cLNzqPPBnGoF8+1yJOMQ4lYSpruvplgaB3ek71jskcr/EQmiolnAzsZz8Mer9teC56QdIOh5MigwQ2TxkOgl4x2JMd+GZwX8DHERbR1a6cl570e87intWGRj2SACs1MPU49s43Dhk60SV9az8hZgN6m8YlZipkvgwNf71AFnZEZscxvWA58SALLYz+ref1ZUr1RnYKZWlNz4z1Hao0botyDcqrCAw2AjKxYxGy3E78WdZxLAnMrMe4D20rXLVIGRfkEjh8vhi4kLRFhbWdXQlwElY5yEbd+D79HSYl6nSl2sjcUMNMvvs54gSGYui0YD9OcIsSLQyuFS33i3AETSjYbwv+DyAwWRWmI3heHzwS8H9YLQcCNZ9CBT7USIrP2UEpyOZ71dMdRdlBEU1glQA==
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:AM6PR0502MB3925.eurprd05.prod.outlook.com;PTR:;CAT:NONE;SFTY:;SFS:(376002)(39830400003)(396003)(136003)(366004)(346002)(33430700001)(7696005)(478600001)(2616005)(52116002)(186003)(16526019)(66476007)(956004)(26005)(316002)(6666004)(36756003)(55016002)(86362001)(5660300002)(66556008)(103116003)(33440700001)(1076003)(8936002)(2906002)(4326008)(8676002)(66946007);DIR:OUT;SFP:1102;
X-MS-Exchange-AntiSpam-MessageData: bJ1YWZ4ljEgkRHdTvVOFFz5jBDJ/dseMLd5cFiI57jLI25Gfyxr7mDGDi0H2mCmzYh3VF5FhAHSGtnV7aaJFrf0OwmxvDh26RoQF+rtkJRSxiRnazgru4osl7++3uY4nt9N4us/cumomWjmFgL/9JaSzBTIu7cwoKHHxvF3p7Y1GTQKDxxzMmOD2ODWCPToMVghKlHMMVVMAxvhNYAS7WISkD1buSoTKpqlUP8QtczMeq4K9OcP/akIL0SFvkKAE3qlHdJ9JsWmF0ifNXd4EYQI4OAwJHDB3tkUrAWViK1A2qri0cb5Tod5AdVNRGq3tbDpt2kgXbYgb0hbFs04eIu0JIRfarmGFq52sy78bwIUtvGL+BOMem6G/ycZZe36cwaYSmTsXrsT443o/zhIY1YtnAtenMegE2n+QT/0UZ5oU6TU+A29t6Y3j0mIurcZK8oilUh6ilZ++xr/YxJ4pVZYrEZcVzsvfGmngNHH5s2U=
X-OriginatorOrg: dektech.com.au
X-MS-Exchange-CrossTenant-Network-Message-Id: 086779de-2820-4b0c-ad41-08d7f739d74e
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 13 May 2020 12:33:29.8325
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 1957ea50-0dd8-4360-8db0-c9530df996b2
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: 1G8ToEyho4nI5TGSuvaHS/5u+TLGTzOKttAoXZxlgp5WVNtYITkIFVaGDYTcZ7o2E9ZOpXddZJq4hnPMb/OoIjZfXBYEoySnGVi8EXCL0iA=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: AM6SPR01MB0038
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Currently when a connection is in Nagle mode, we set the 'ack_required'
bit in the last sending buffer and wait for the corresponding ACK prior
to pushing more data. However, on the receiving side, the ACK is issued
only when application really  reads the whole data. Even if part of the
last buffer is received, we will not do the ACK as required. This might
cause an unnecessary delay since the receiver does not always fetch the
message as fast as the sender, resulting in a large latency in the user
message sending, which is: [one RTT + the receiver processing time].

The commit makes Nagle ACK as soon as possible i.e. when a message with
the 'ack_required' arrives in the receiving side's stack even before it
is processed or put in the socket receive queue...
This way, we can limit the streaming latency to one RTT as committed in
Nagle mode.

Acked-by: Ying Xue <ying.xue@windriver.com>
Acked-by: Jon Maloy <jmaloy@redhat.com>
Signed-off-by: Tuong Lien <tuong.t.lien@dektech.com.au>
---
 net/tipc/socket.c | 42 +++++++++++++++++++++++++++++++-----------
 1 file changed, 31 insertions(+), 11 deletions(-)

diff --git a/net/tipc/socket.c b/net/tipc/socket.c
index 87466607097f..e370ad0edd76 100644
--- a/net/tipc/socket.c
+++ b/net/tipc/socket.c
@@ -1739,22 +1739,21 @@ static int tipc_sk_anc_data_recv(struct msghdr *m, struct sk_buff *skb,
 	return 0;
 }
 
-static void tipc_sk_send_ack(struct tipc_sock *tsk)
+static struct sk_buff *tipc_sk_build_ack(struct tipc_sock *tsk)
 {
 	struct sock *sk = &tsk->sk;
-	struct net *net = sock_net(sk);
 	struct sk_buff *skb = NULL;
 	struct tipc_msg *msg;
 	u32 peer_port = tsk_peer_port(tsk);
 	u32 dnode = tsk_peer_node(tsk);
 
 	if (!tipc_sk_connected(sk))
-		return;
+		return NULL;
 	skb = tipc_msg_create(CONN_MANAGER, CONN_ACK, INT_H_SIZE, 0,
 			      dnode, tsk_own_node(tsk), peer_port,
 			      tsk->portid, TIPC_OK);
 	if (!skb)
-		return;
+		return NULL;
 	msg = buf_msg(skb);
 	msg_set_conn_ack(msg, tsk->rcv_unacked);
 	tsk->rcv_unacked = 0;
@@ -1764,7 +1763,19 @@ static void tipc_sk_send_ack(struct tipc_sock *tsk)
 		tsk->rcv_win = tsk_adv_blocks(tsk->sk.sk_rcvbuf);
 		msg_set_adv_win(msg, tsk->rcv_win);
 	}
-	tipc_node_xmit_skb(net, skb, dnode, msg_link_selector(msg));
+	return skb;
+}
+
+static void tipc_sk_send_ack(struct tipc_sock *tsk)
+{
+	struct sk_buff *skb;
+
+	skb = tipc_sk_build_ack(tsk);
+	if (!skb)
+		return;
+
+	tipc_node_xmit_skb(sock_net(&tsk->sk), skb, tsk_peer_node(tsk),
+			   msg_link_selector(buf_msg(skb)));
 }
 
 static int tipc_wait_for_rcvmsg(struct socket *sock, long *timeop)
@@ -1938,7 +1949,6 @@ static int tipc_recvstream(struct socket *sock, struct msghdr *m,
 	bool peek = flags & MSG_PEEK;
 	int offset, required, copy, copied = 0;
 	int hlen, dlen, err, rc;
-	bool ack = false;
 	long timeout;
 
 	/* Catch invalid receive attempts */
@@ -1983,7 +1993,6 @@ static int tipc_recvstream(struct socket *sock, struct msghdr *m,
 
 		/* Copy data if msg ok, otherwise return error/partial data */
 		if (likely(!err)) {
-			ack = msg_ack_required(hdr);
 			offset = skb_cb->bytes_read;
 			copy = min_t(int, dlen - offset, buflen - copied);
 			rc = skb_copy_datagram_msg(skb, hlen + offset, m, copy);
@@ -2011,7 +2020,7 @@ static int tipc_recvstream(struct socket *sock, struct msghdr *m,
 
 		/* Send connection flow control advertisement when applicable */
 		tsk->rcv_unacked += tsk_inc(tsk, hlen + dlen);
-		if (ack || tsk->rcv_unacked >= tsk->rcv_win / TIPC_ACK_RATE)
+		if (tsk->rcv_unacked >= tsk->rcv_win / TIPC_ACK_RATE)
 			tipc_sk_send_ack(tsk);
 
 		/* Exit if all requested data or FIN/error received */
@@ -2105,9 +2114,11 @@ static void tipc_sk_proto_rcv(struct sock *sk,
  * tipc_sk_filter_connect - check incoming message for a connection-based socket
  * @tsk: TIPC socket
  * @skb: pointer to message buffer.
+ * @xmitq: for Nagle ACK if any
  * Returns true if message should be added to receive queue, false otherwise
  */
-static bool tipc_sk_filter_connect(struct tipc_sock *tsk, struct sk_buff *skb)
+static bool tipc_sk_filter_connect(struct tipc_sock *tsk, struct sk_buff *skb,
+				   struct sk_buff_head *xmitq)
 {
 	struct sock *sk = &tsk->sk;
 	struct net *net = sock_net(sk);
@@ -2171,8 +2182,17 @@ static bool tipc_sk_filter_connect(struct tipc_sock *tsk, struct sk_buff *skb)
 		if (!skb_queue_empty(&sk->sk_write_queue))
 			tipc_sk_push_backlog(tsk);
 		/* Accept only connection-based messages sent by peer */
-		if (likely(con_msg && !err && pport == oport && pnode == onode))
+		if (likely(con_msg && !err && pport == oport &&
+			   pnode == onode)) {
+			if (msg_ack_required(hdr)) {
+				struct sk_buff *skb;
+
+				skb = tipc_sk_build_ack(tsk);
+				if (skb)
+					__skb_queue_tail(xmitq, skb);
+			}
 			return true;
+		}
 		if (!tsk_peer_msg(tsk, hdr))
 			return false;
 		if (!err)
@@ -2267,7 +2287,7 @@ static void tipc_sk_filter_rcv(struct sock *sk, struct sk_buff *skb,
 	while ((skb = __skb_dequeue(&inputq))) {
 		hdr = buf_msg(skb);
 		limit = rcvbuf_limit(sk, skb);
-		if ((sk_conn && !tipc_sk_filter_connect(tsk, skb)) ||
+		if ((sk_conn && !tipc_sk_filter_connect(tsk, skb, xmitq)) ||
 		    (!sk_conn && msg_connected(hdr)) ||
 		    (!grp && msg_in_group(hdr)))
 			err = TIPC_ERR_NO_PORT;
-- 
2.13.7

