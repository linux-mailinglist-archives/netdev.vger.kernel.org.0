Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 1288C2D6AD1
	for <lists+netdev@lfdr.de>; Thu, 10 Dec 2020 23:55:55 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2404732AbgLJWzZ (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 10 Dec 2020 17:55:25 -0500
Received: from mga04.intel.com ([192.55.52.120]:9222 "EHLO mga04.intel.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1732863AbgLJWce (ORCPT <rfc822;netdev@vger.kernel.org>);
        Thu, 10 Dec 2020 17:32:34 -0500
IronPort-SDR: QZXKebPbuAfTCS6slCf0fYv5bsxW4XorQzcpHZE6owgeaq46I7gFvn3z6Wy0AMRq93o3zsWd6D
 soowmE7fIlrQ==
X-IronPort-AV: E=McAfee;i="6000,8403,9831"; a="171776492"
X-IronPort-AV: E=Sophos;i="5.78,409,1599548400"; 
   d="scan'208";a="171776492"
Received: from orsmga006.jf.intel.com ([10.7.209.51])
  by fmsmga104.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 10 Dec 2020 14:25:15 -0800
IronPort-SDR: E517UUcrcIYreC9T8ISW6Y3LTnKgnqNo0YdV4g4N5PwHZRoMi5zcBrYOKL/2ADOAHvNbA/0VzS
 6W70KZnJO0Gg==
X-IronPort-AV: E=Sophos;i="5.78,409,1599548400"; 
   d="scan'208";a="338703759"
Received: from mjmartin-nuc02.amr.corp.intel.com ([10.254.112.51])
  by orsmga006-auth.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 10 Dec 2020 14:25:14 -0800
From:   Mat Martineau <mathew.j.martineau@linux.intel.com>
To:     netdev@vger.kernel.org
Cc:     Florian Westphal <fw@strlen.de>, davem@davemloft.net,
        kuba@kernel.org, mptcp@lists.01.org,
        Matthieu Baerts <matthieu.baerts@tessares.net>,
        Mat Martineau <mathew.j.martineau@linux.intel.com>
Subject: [PATCH net-next 7/9] mptcp: parse and act on incoming FASTCLOSE option
Date:   Thu, 10 Dec 2020 14:25:04 -0800
Message-Id: <20201210222506.222251-8-mathew.j.martineau@linux.intel.com>
X-Mailer: git-send-email 2.29.2
In-Reply-To: <20201210222506.222251-1-mathew.j.martineau@linux.intel.com>
References: <20201210222506.222251-1-mathew.j.martineau@linux.intel.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Florian Westphal <fw@strlen.de>

parse the MPTCP FASTCLOSE subtype.

If provided key matches the local one, schedule the work queue to close
(with tcp reset) all subflows.

The MPTCP socket moves to closed state immediately.

Reviewed-by: Matthieu Baerts <matthieu.baerts@tessares.net>
Signed-off-by: Florian Westphal <fw@strlen.de>
Signed-off-by: Mat Martineau <mathew.j.martineau@linux.intel.com>
---
 net/mptcp/options.c  | 17 +++++++++++++++++
 net/mptcp/protocol.c | 33 +++++++++++++++++++++++++++++++++
 net/mptcp/protocol.h |  4 ++++
 3 files changed, 54 insertions(+)

diff --git a/net/mptcp/options.c b/net/mptcp/options.c
index 1ca60d9da3ef..5e7d7755d1a6 100644
--- a/net/mptcp/options.c
+++ b/net/mptcp/options.c
@@ -282,6 +282,16 @@ static void mptcp_parse_option(const struct sk_buff *skb,
 		pr_debug("RM_ADDR: id=%d", mp_opt->rm_id);
 		break;
 
+	case MPTCPOPT_MP_FASTCLOSE:
+		if (opsize != TCPOLEN_MPTCP_FASTCLOSE)
+			break;
+
+		ptr += 2;
+		mp_opt->rcvr_key = get_unaligned_be64(ptr);
+		ptr += 8;
+		mp_opt->fastclose = 1;
+		break;
+
 	default:
 		break;
 	}
@@ -299,6 +309,7 @@ void mptcp_get_options(const struct sk_buff *skb,
 	mp_opt->mp_join = 0;
 	mp_opt->add_addr = 0;
 	mp_opt->ahmac = 0;
+	mp_opt->fastclose = 0;
 	mp_opt->port = 0;
 	mp_opt->rm_addr = 0;
 	mp_opt->dss = 0;
@@ -942,6 +953,12 @@ void mptcp_incoming_options(struct sock *sk, struct sk_buff *skb)
 	if (!check_fully_established(msk, sk, subflow, skb, &mp_opt))
 		return;
 
+	if (mp_opt.fastclose &&
+	    msk->local_key == mp_opt.rcvr_key) {
+		WRITE_ONCE(msk->rcv_fastclose, true);
+		mptcp_schedule_work((struct sock *)msk);
+	}
+
 	if (mp_opt.add_addr && add_addr_hmac_valid(msk, &mp_opt)) {
 		struct mptcp_addr_info addr;
 
diff --git a/net/mptcp/protocol.c b/net/mptcp/protocol.c
index 2540d82742ac..cb8b7adf218a 100644
--- a/net/mptcp/protocol.c
+++ b/net/mptcp/protocol.c
@@ -2217,6 +2217,36 @@ static bool mptcp_check_close_timeout(const struct sock *sk)
 	return true;
 }
 
+static void mptcp_check_fastclose(struct mptcp_sock *msk)
+{
+	struct mptcp_subflow_context *subflow, *tmp;
+	struct sock *sk = &msk->sk.icsk_inet.sk;
+
+	if (likely(!READ_ONCE(msk->rcv_fastclose)))
+		return;
+
+	mptcp_token_destroy(msk);
+
+	list_for_each_entry_safe(subflow, tmp, &msk->conn_list, node) {
+		struct sock *tcp_sk = mptcp_subflow_tcp_sock(subflow);
+
+		lock_sock(tcp_sk);
+		if (tcp_sk->sk_state != TCP_CLOSE) {
+			tcp_send_active_reset(tcp_sk, GFP_ATOMIC);
+			tcp_set_state(tcp_sk, TCP_CLOSE);
+		}
+		release_sock(tcp_sk);
+	}
+
+	inet_sk_state_store(sk, TCP_CLOSE);
+	sk->sk_shutdown = SHUTDOWN_MASK;
+	smp_mb__before_atomic(); /* SHUTDOWN must be visible first */
+	set_bit(MPTCP_DATA_READY, &msk->flags);
+	set_bit(MPTCP_WORK_CLOSE_SUBFLOW, &msk->flags);
+
+	mptcp_close_wake_up(sk);
+}
+
 static void mptcp_worker(struct work_struct *work)
 {
 	struct mptcp_sock *msk = container_of(work, struct mptcp_sock, work);
@@ -2233,6 +2263,9 @@ static void mptcp_worker(struct work_struct *work)
 
 	mptcp_check_data_fin_ack(sk);
 	__mptcp_flush_join_list(msk);
+
+	mptcp_check_fastclose(msk);
+
 	if (test_and_clear_bit(MPTCP_WORK_CLOSE_SUBFLOW, &msk->flags))
 		__mptcp_close_subflow(msk);
 
diff --git a/net/mptcp/protocol.h b/net/mptcp/protocol.h
index a5bc9599ae5c..7cf9d110b85f 100644
--- a/net/mptcp/protocol.h
+++ b/net/mptcp/protocol.h
@@ -23,6 +23,7 @@
 #define OPTION_MPTCP_ADD_ADDR	BIT(6)
 #define OPTION_MPTCP_ADD_ADDR6	BIT(7)
 #define OPTION_MPTCP_RM_ADDR	BIT(8)
+#define OPTION_MPTCP_FASTCLOSE	BIT(9)
 
 /* MPTCP option subtypes */
 #define MPTCPOPT_MP_CAPABLE	0
@@ -58,6 +59,7 @@
 #define TCPOLEN_MPTCP_ADD_ADDR6_BASE_PORT	24
 #define TCPOLEN_MPTCP_PORT_LEN		4
 #define TCPOLEN_MPTCP_RM_ADDR_BASE	4
+#define TCPOLEN_MPTCP_FASTCLOSE		12
 
 /* MPTCP MP_JOIN flags */
 #define MPTCPOPT_BACKUP		BIT(0)
@@ -110,6 +112,7 @@ struct mptcp_options_received {
 	u16	data_len;
 	u16	mp_capable : 1,
 		mp_join : 1,
+		fastclose : 1,
 		dss : 1,
 		add_addr : 1,
 		rm_addr : 1,
@@ -237,6 +240,7 @@ struct mptcp_sock {
 	bool		fully_established;
 	bool		rcv_data_fin;
 	bool		snd_data_fin_enable;
+	bool		rcv_fastclose;
 	bool		use_64bit_ack; /* Set when we received a 64-bit DSN */
 	spinlock_t	join_list_lock;
 	struct sock	*ack_hint;
-- 
2.29.2

