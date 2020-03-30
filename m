Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id EBA301981C0
	for <lists+netdev@lfdr.de>; Mon, 30 Mar 2020 18:56:13 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1730070AbgC3Q4M (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 30 Mar 2020 12:56:12 -0400
Received: from stargate.chelsio.com ([12.32.117.8]:15123 "EHLO
        stargate.chelsio.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726023AbgC3Q4M (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 30 Mar 2020 12:56:12 -0400
Received: from localhost.localdomain (redhouse.blr.asicdesigners.com [10.193.185.57])
        by stargate.chelsio.com (8.13.8/8.13.8) with ESMTP id 02UGtv8v027233;
        Mon, 30 Mar 2020 09:55:58 -0700
From:   Rohit Maheshwari <rohitm@chelsio.com>
To:     davem@davemloft.net, netdev@vger.kernel.org
Cc:     kuba@kernel.org, borisp@mellanox.com, secdev@chelsio.com,
        Rohit Maheshwari <rohitm@chelsio.com>
Subject: [PATCH net-next] crypto/chtls: Fix chtls crash in connection cleanup
Date:   Mon, 30 Mar 2020 22:25:55 +0530
Message-Id: <20200330165555.17521-1-rohitm@chelsio.com>
X-Mailer: git-send-email 2.18.1
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

There is a possibility that cdev is removed before CPL_ABORT_REQ_RSS
is fully processed, so it's better to save it in skb.

Added checks in handling the flow correctly, which suggests connection reset
request is sent to HW, wait for HW to respond.

Signed-off-by: Rohit Maheshwari <rohitm@chelsio.com>
---
 drivers/crypto/chelsio/chtls/chtls_cm.c | 29 +++++++++++++++++++++----
 1 file changed, 25 insertions(+), 4 deletions(-)

diff --git a/drivers/crypto/chelsio/chtls/chtls_cm.c b/drivers/crypto/chelsio/chtls/chtls_cm.c
index 9b2745ad9e38..d5720a859443 100644
--- a/drivers/crypto/chelsio/chtls/chtls_cm.c
+++ b/drivers/crypto/chelsio/chtls/chtls_cm.c
@@ -445,6 +445,7 @@ void chtls_destroy_sock(struct sock *sk)
 	chtls_purge_write_queue(sk);
 	free_tls_keyid(sk);
 	kref_put(&csk->kref, chtls_sock_release);
+	csk->cdev = NULL;
 	sk->sk_prot = &tcp_prot;
 	sk->sk_prot->destroy(sk);
 }
@@ -759,8 +760,10 @@ static void chtls_release_resources(struct sock *sk)
 		csk->l2t_entry = NULL;
 	}
 
-	cxgb4_remove_tid(tids, csk->port_id, tid, sk->sk_family);
-	sock_put(sk);
+	if (sk->sk_state != TCP_SYN_SENT) {
+		cxgb4_remove_tid(tids, csk->port_id, tid, sk->sk_family);
+		sock_put(sk);
+	}
 }
 
 static void chtls_conn_done(struct sock *sk)
@@ -1716,6 +1719,9 @@ static void chtls_peer_close(struct sock *sk, struct sk_buff *skb)
 {
 	struct chtls_sock *csk = rcu_dereference_sk_user_data(sk);
 
+	if (csk_flag_nochk(csk, CSK_ABORT_RPL_PENDING))
+		goto out;
+
 	sk->sk_shutdown |= RCV_SHUTDOWN;
 	sock_set_flag(sk, SOCK_DONE);
 
@@ -1748,6 +1754,7 @@ static void chtls_peer_close(struct sock *sk, struct sk_buff *skb)
 		else
 			sk_wake_async(sk, SOCK_WAKE_WAITD, POLL_IN);
 	}
+out:
 	kfree_skb(skb);
 }
 
@@ -1758,6 +1765,10 @@ static void chtls_close_con_rpl(struct sock *sk, struct sk_buff *skb)
 	struct tcp_sock *tp;
 
 	csk = rcu_dereference_sk_user_data(sk);
+
+	if (csk_flag_nochk(csk, CSK_ABORT_RPL_PENDING))
+		goto out;
+
 	tp = tcp_sk(sk);
 
 	tp->snd_una = ntohl(rpl->snd_nxt) - 1;  /* exclude FIN */
@@ -1787,6 +1798,7 @@ static void chtls_close_con_rpl(struct sock *sk, struct sk_buff *skb)
 	default:
 		pr_info("close_con_rpl in bad state %d\n", sk->sk_state);
 	}
+out:
 	kfree_skb(skb);
 }
 
@@ -1896,6 +1908,7 @@ static void chtls_send_abort_rpl(struct sock *sk, struct sk_buff *skb,
 	}
 
 	set_abort_rpl_wr(reply_skb, tid, status);
+	kfree_skb(skb);
 	set_wr_txq(reply_skb, CPL_PRIORITY_DATA, queue);
 	if (csk_conn_inline(csk)) {
 		struct l2t_entry *e = csk->l2t_entry;
@@ -1906,7 +1919,6 @@ static void chtls_send_abort_rpl(struct sock *sk, struct sk_buff *skb,
 		}
 	}
 	cxgb4_ofld_send(cdev->lldi->ports[0], reply_skb);
-	kfree_skb(skb);
 }
 
 /*
@@ -2008,7 +2020,8 @@ static void chtls_abort_req_rss(struct sock *sk, struct sk_buff *skb)
 		chtls_conn_done(sk);
 	}
 
-	chtls_send_abort_rpl(sk, skb, csk->cdev, rst_status, queue);
+	chtls_send_abort_rpl(sk, skb, BLOG_SKB_CB(skb)->cdev,
+			     rst_status, queue);
 }
 
 static void chtls_abort_rpl_rss(struct sock *sk, struct sk_buff *skb)
@@ -2042,6 +2055,7 @@ static int chtls_conn_cpl(struct chtls_dev *cdev, struct sk_buff *skb)
 	struct cpl_peer_close *req = cplhdr(skb) + RSS_HDR;
 	void (*fn)(struct sock *sk, struct sk_buff *skb);
 	unsigned int hwtid = GET_TID(req);
+	struct chtls_sock *csk;
 	struct sock *sk;
 	u8 opcode;
 
@@ -2051,6 +2065,8 @@ static int chtls_conn_cpl(struct chtls_dev *cdev, struct sk_buff *skb)
 	if (!sk)
 		goto rel_skb;
 
+	csk = sk->sk_user_data;
+
 	switch (opcode) {
 	case CPL_PEER_CLOSE:
 		fn = chtls_peer_close;
@@ -2059,6 +2075,11 @@ static int chtls_conn_cpl(struct chtls_dev *cdev, struct sk_buff *skb)
 		fn = chtls_close_con_rpl;
 		break;
 	case CPL_ABORT_REQ_RSS:
+		/*
+		 * Save the offload device in the skb, we may process this
+		 * message after the socket has closed.
+		 */
+		BLOG_SKB_CB(skb)->cdev = csk->cdev;
 		fn = chtls_abort_req_rss;
 		break;
 	case CPL_ABORT_RPL_RSS:
-- 
2.18.1

