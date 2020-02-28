Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id BF52A17438A
	for <lists+netdev@lfdr.de>; Sat, 29 Feb 2020 00:48:00 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726917AbgB1Xr7 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 28 Feb 2020 18:47:59 -0500
Received: from mga14.intel.com ([192.55.52.115]:3767 "EHLO mga14.intel.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726490AbgB1Xr5 (ORCPT <rfc822;netdev@vger.kernel.org>);
        Fri, 28 Feb 2020 18:47:57 -0500
X-Amp-Result: SKIPPED(no attachment in message)
X-Amp-File-Uploaded: False
Received: from fmsmga001.fm.intel.com ([10.253.24.23])
  by fmsmga103.fm.intel.com with ESMTP/TLS/DHE-RSA-AES256-GCM-SHA384; 28 Feb 2020 15:47:56 -0800
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="5.70,497,1574150400"; 
   d="scan'208";a="351031532"
Received: from mjmartin-nuc02.mjmartin-nuc02 (HELO mjmartin-nuc02.sea.intel.com) ([10.251.18.184])
  by fmsmga001.fm.intel.com with ESMTP; 28 Feb 2020 15:47:56 -0800
From:   Mat Martineau <mathew.j.martineau@linux.intel.com>
To:     netdev@vger.kernel.org
Cc:     Mat Martineau <mathew.j.martineau@linux.intel.com>
Subject: [PATCH net-next 2/3] mptcp: Use per-subflow storage for DATA_FIN sequence number
Date:   Fri, 28 Feb 2020 15:47:40 -0800
Message-Id: <20200228234741.57086-3-mathew.j.martineau@linux.intel.com>
X-Mailer: git-send-email 2.25.1
In-Reply-To: <20200228234741.57086-1-mathew.j.martineau@linux.intel.com>
References: <20200228234741.57086-1-mathew.j.martineau@linux.intel.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Instead of reading the MPTCP-level sequence number when sending DATA_FIN,
store the data in the subflow so it can be safely accessed when the
subflow TCP headers are written to the packet without the MPTCP-level
lock held. This also allows the MPTCP-level socket to close individual
subflows without closing the MPTCP connection.

Signed-off-by: Mat Martineau <mathew.j.martineau@linux.intel.com>
---
 net/mptcp/options.c  |  5 ++---
 net/mptcp/protocol.c | 20 +++++++++++++++++---
 net/mptcp/protocol.h |  2 ++
 3 files changed, 21 insertions(+), 6 deletions(-)

diff --git a/net/mptcp/options.c b/net/mptcp/options.c
index 45acd877bef3..90c81953ec2c 100644
--- a/net/mptcp/options.c
+++ b/net/mptcp/options.c
@@ -312,7 +312,7 @@ static void mptcp_write_data_fin(struct mptcp_subflow_context *subflow,
 		 */
 		ext->use_map = 1;
 		ext->dsn64 = 1;
-		ext->data_seq = mptcp_sk(subflow->conn)->write_seq;
+		ext->data_seq = subflow->data_fin_tx_seq;
 		ext->subflow_seq = 0;
 		ext->data_len = 1;
 	} else {
@@ -354,8 +354,7 @@ static bool mptcp_established_options_dss(struct sock *sk, struct sk_buff *skb,
 		if (mpext)
 			opts->ext_copy = *mpext;
 
-		if (skb && tcp_fin &&
-		    subflow->conn->sk_state != TCP_ESTABLISHED)
+		if (skb && tcp_fin && subflow->data_fin_tx_enable)
 			mptcp_write_data_fin(subflow, &opts->ext_copy);
 		ret = true;
 	}
diff --git a/net/mptcp/protocol.c b/net/mptcp/protocol.c
index 07559b45eec5..4c075a9f7ed0 100644
--- a/net/mptcp/protocol.c
+++ b/net/mptcp/protocol.c
@@ -720,7 +720,8 @@ static void mptcp_cancel_work(struct sock *sk)
 		sock_put(sk);
 }
 
-static void mptcp_subflow_shutdown(struct sock *ssk, int how)
+static void mptcp_subflow_shutdown(struct sock *ssk, int how,
+				   bool data_fin_tx_enable, u64 data_fin_tx_seq)
 {
 	lock_sock(ssk);
 
@@ -733,6 +734,14 @@ static void mptcp_subflow_shutdown(struct sock *ssk, int how)
 		tcp_disconnect(ssk, O_NONBLOCK);
 		break;
 	default:
+		if (data_fin_tx_enable) {
+			struct mptcp_subflow_context *subflow;
+
+			subflow = mptcp_subflow_ctx(ssk);
+			subflow->data_fin_tx_seq = data_fin_tx_seq;
+			subflow->data_fin_tx_enable = 1;
+		}
+
 		ssk->sk_shutdown |= how;
 		tcp_shutdown(ssk, how);
 		break;
@@ -749,6 +758,7 @@ static void mptcp_close(struct sock *sk, long timeout)
 	struct mptcp_subflow_context *subflow, *tmp;
 	struct mptcp_sock *msk = mptcp_sk(sk);
 	LIST_HEAD(conn_list);
+	u64 data_fin_tx_seq;
 
 	lock_sock(sk);
 
@@ -757,11 +767,15 @@ static void mptcp_close(struct sock *sk, long timeout)
 
 	list_splice_init(&msk->conn_list, &conn_list);
 
+	data_fin_tx_seq = msk->write_seq;
+
 	release_sock(sk);
 
 	list_for_each_entry_safe(subflow, tmp, &conn_list, node) {
 		struct sock *ssk = mptcp_subflow_tcp_sock(subflow);
 
+		subflow->data_fin_tx_seq = data_fin_tx_seq;
+		subflow->data_fin_tx_enable = 1;
 		__mptcp_close_ssk(sk, ssk, subflow, timeout);
 	}
 
@@ -854,7 +868,7 @@ static struct sock *mptcp_accept(struct sock *sk, int flags, int *err,
 			*err = -ENOBUFS;
 			local_bh_enable();
 			release_sock(sk);
-			mptcp_subflow_shutdown(newsk, SHUT_RDWR + 1);
+			mptcp_subflow_shutdown(newsk, SHUT_RDWR + 1, 0, 0);
 			tcp_close(newsk, 0);
 			return NULL;
 		}
@@ -1309,7 +1323,7 @@ static int mptcp_shutdown(struct socket *sock, int how)
 	mptcp_for_each_subflow(msk, subflow) {
 		struct sock *tcp_sk = mptcp_subflow_tcp_sock(subflow);
 
-		mptcp_subflow_shutdown(tcp_sk, how);
+		mptcp_subflow_shutdown(tcp_sk, how, 1, msk->write_seq);
 	}
 
 out_unlock:
diff --git a/net/mptcp/protocol.h b/net/mptcp/protocol.h
index 6c0b2c8ab674..313558fa8185 100644
--- a/net/mptcp/protocol.h
+++ b/net/mptcp/protocol.h
@@ -125,7 +125,9 @@ struct mptcp_subflow_context {
 		mpc_map : 1,
 		data_avail : 1,
 		rx_eof : 1,
+		data_fin_tx_enable : 1,
 		can_ack : 1;	    /* only after processing the remote a key */
+	u64	data_fin_tx_seq;
 
 	struct	sock *tcp_sock;	    /* tcp sk backpointer */
 	struct	sock *conn;	    /* parent mptcp_sock */
-- 
2.25.1

