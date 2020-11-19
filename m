Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 2E9722B9BB2
	for <lists+netdev@lfdr.de>; Thu, 19 Nov 2020 20:50:00 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728049AbgKSTqU (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 19 Nov 2020 14:46:20 -0500
Received: from mga03.intel.com ([134.134.136.65]:56904 "EHLO mga03.intel.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1727911AbgKSTqN (ORCPT <rfc822;netdev@vger.kernel.org>);
        Thu, 19 Nov 2020 14:46:13 -0500
IronPort-SDR: +YOwWHAFm6Ks7seALdMfdnnhP5aA9Lm5iOb5+jaO9w83DQBQ2xRrqTs99Pqok91zXsadOuaW+N
 YOGCJvVTZ7Xg==
X-IronPort-AV: E=McAfee;i="6000,8403,9810"; a="171451134"
X-IronPort-AV: E=Sophos;i="5.78,354,1599548400"; 
   d="scan'208";a="171451134"
X-Amp-Result: SKIPPED(no attachment in message)
X-Amp-File-Uploaded: False
Received: from orsmga004.jf.intel.com ([10.7.209.38])
  by orsmga103.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 19 Nov 2020 11:46:09 -0800
IronPort-SDR: 6Cw6PbRC4pH6NQtwErvWzROzDmK+aHadY2DfgzBTStiCkJSd/nNoRNvBxcAJIGGZtPWN0mV99U
 O0Q94qR84blQ==
X-IronPort-AV: E=Sophos;i="5.78,354,1599548400"; 
   d="scan'208";a="476940485"
Received: from mjmartin-nuc02.amr.corp.intel.com ([10.255.229.232])
  by orsmga004-auth.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 19 Nov 2020 11:46:09 -0800
From:   Mat Martineau <mathew.j.martineau@linux.intel.com>
To:     netdev@vger.kernel.org
Cc:     Geliang Tang <geliangtang@gmail.com>, kuba@kernel.org,
        mptcp@lists.01.org, Paolo Abeni <pabeni@redhat.com>,
        Mat Martineau <mathew.j.martineau@linux.intel.com>
Subject: [PATCH net-next 07/10] mptcp: send out dedicated ADD_ADDR packet
Date:   Thu, 19 Nov 2020 11:46:00 -0800
Message-Id: <20201119194603.103158-8-mathew.j.martineau@linux.intel.com>
X-Mailer: git-send-email 2.29.2
In-Reply-To: <20201119194603.103158-1-mathew.j.martineau@linux.intel.com>
References: <20201119194603.103158-1-mathew.j.martineau@linux.intel.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Geliang Tang <geliangtang@gmail.com>

When ADD_ADDR suboption includes an IPv6 address, the size is 28 octets.
It will not fit when other MPTCP suboptions are included in this packet,
e.g. DSS. So here we send out an ADD_ADDR dedicated packet to carry only
ADD_ADDR suboption, no other MPTCP suboptions.

In mptcp_pm_announce_addr, we check whether this is an IPv6 ADD_ADDR.
If it is, we set the flag MPTCP_ADD_ADDR_IPV6 to true. Then we call
mptcp_pm_nl_add_addr_send_ack to sent out a new pure ACK packet.

In mptcp_established_options_add_addr, we check whether this is a pure
ACK packet for ADD_ADDR. If it is, we drop all other MPTCP suboptions
in this packet, only put ADD_ADDR suboption in it.

Suggested-by: Paolo Abeni <pabeni@redhat.com>
Acked-by: Paolo Abeni <pabeni@redhat.com>
Signed-off-by: Geliang Tang <geliangtang@gmail.com>
Signed-off-by: Mat Martineau <mathew.j.martineau@linux.intel.com>
---
 net/mptcp/options.c    | 25 ++++++++++++++++++++++---
 net/mptcp/pm.c         | 16 ++++++++++++++--
 net/mptcp/pm_netlink.c | 29 +++++++++++++++++++++++++++++
 net/mptcp/protocol.c   |  6 +++++-
 net/mptcp/protocol.h   | 10 ++++++++++
 5 files changed, 80 insertions(+), 6 deletions(-)

diff --git a/net/mptcp/options.c b/net/mptcp/options.c
index f2d1e27a2bc1..d7afffcc87c1 100644
--- a/net/mptcp/options.c
+++ b/net/mptcp/options.c
@@ -242,7 +242,9 @@ static void mptcp_parse_option(const struct sk_buff *skb,
 
 		mp_opt->add_addr = 1;
 		mp_opt->addr_id = *ptr++;
-		pr_debug("ADD_ADDR: id=%d, echo=%d", mp_opt->addr_id, mp_opt->echo);
+		pr_debug("ADD_ADDR%s: id=%d, echo=%d",
+			 (mp_opt->family == MPTCP_ADDR_IPVERSION_6) ? "6" : "",
+			 mp_opt->addr_id, mp_opt->echo);
 		if (mp_opt->family == MPTCP_ADDR_IPVERSION_4) {
 			memcpy((u8 *)&mp_opt->addr.s_addr, (u8 *)ptr, 4);
 			ptr += 4;
@@ -573,17 +575,27 @@ static u64 add_addr6_generate_hmac(u64 key1, u64 key2, u8 addr_id,
 }
 #endif
 
-static bool mptcp_established_options_add_addr(struct sock *sk,
+static bool mptcp_established_options_add_addr(struct sock *sk, struct sk_buff *skb,
 					       unsigned int *size,
 					       unsigned int remaining,
 					       struct mptcp_out_options *opts)
 {
 	struct mptcp_subflow_context *subflow = mptcp_subflow_ctx(sk);
 	struct mptcp_sock *msk = mptcp_sk(subflow->conn);
+	bool drop_other_suboptions = false;
+	unsigned int opt_size = *size;
 	struct mptcp_addr_info saddr;
 	bool echo;
 	int len;
 
+	if (mptcp_pm_should_add_signal_ipv6(msk) &&
+	    skb && skb_is_tcp_pure_ack(skb)) {
+		pr_debug("drop other suboptions");
+		opts->suboptions = 0;
+		remaining += opt_size;
+		drop_other_suboptions = true;
+	}
+
 	if (!mptcp_pm_should_add_signal(msk) ||
 	    !(mptcp_pm_add_addr_signal(msk, remaining, &saddr, &echo)))
 		return false;
@@ -593,6 +605,8 @@ static bool mptcp_established_options_add_addr(struct sock *sk,
 		return false;
 
 	*size = len;
+	if (drop_other_suboptions)
+		*size -= opt_size;
 	opts->addr_id = saddr.id;
 	if (saddr.family == AF_INET) {
 		opts->suboptions |= OPTION_MPTCP_ADD_ADDR;
@@ -678,7 +692,7 @@ bool mptcp_established_options(struct sock *sk, struct sk_buff *skb,
 
 	*size += opt_size;
 	remaining -= opt_size;
-	if (mptcp_established_options_add_addr(sk, &opt_size, remaining, opts)) {
+	if (mptcp_established_options_add_addr(sk, skb, &opt_size, remaining, opts)) {
 		*size += opt_size;
 		remaining -= opt_size;
 		ret = true;
@@ -759,6 +773,11 @@ static bool check_fully_established(struct mptcp_sock *msk, struct sock *ssk,
 		goto fully_established;
 	}
 
+	if (mp_opt->add_addr) {
+		WRITE_ONCE(msk->fully_established, true);
+		return true;
+	}
+
 	/* If the first established packet does not contain MP_CAPABLE + data
 	 * then fallback to TCP. Fallback scenarios requires a reset for
 	 * MP_JOIN subflows.
diff --git a/net/mptcp/pm.c b/net/mptcp/pm.c
index c2c12f02a263..75c5040e8d5d 100644
--- a/net/mptcp/pm.c
+++ b/net/mptcp/pm.c
@@ -24,6 +24,8 @@ int mptcp_pm_announce_addr(struct mptcp_sock *msk,
 	add_addr |= BIT(MPTCP_ADD_ADDR_SIGNAL);
 	if (echo)
 		add_addr |= BIT(MPTCP_ADD_ADDR_ECHO);
+	if (addr->family == AF_INET6)
+		add_addr |= BIT(MPTCP_ADD_ADDR_IPV6);
 	WRITE_ONCE(msk->pm.add_addr_signal, add_addr);
 	return 0;
 }
@@ -153,14 +155,24 @@ void mptcp_pm_add_addr_received(struct mptcp_sock *msk,
 
 	spin_lock_bh(&pm->lock);
 
-	if (!READ_ONCE(pm->accept_addr))
+	if (!READ_ONCE(pm->accept_addr)) {
 		mptcp_pm_announce_addr(msk, addr, true);
-	else if (mptcp_pm_schedule_work(msk, MPTCP_PM_ADD_ADDR_RECEIVED))
+		mptcp_pm_add_addr_send_ack(msk);
+	} else if (mptcp_pm_schedule_work(msk, MPTCP_PM_ADD_ADDR_RECEIVED)) {
 		pm->remote = *addr;
+	}
 
 	spin_unlock_bh(&pm->lock);
 }
 
+void mptcp_pm_add_addr_send_ack(struct mptcp_sock *msk)
+{
+	if (!mptcp_pm_should_add_signal_ipv6(msk))
+		return;
+
+	mptcp_pm_schedule_work(msk, MPTCP_PM_ADD_ADDR_SEND_ACK);
+}
+
 void mptcp_pm_rm_addr_received(struct mptcp_sock *msk, u8 rm_id)
 {
 	struct mptcp_pm_data *pm = &msk->pm;
diff --git a/net/mptcp/pm_netlink.c b/net/mptcp/pm_netlink.c
index f8a9d82a0ea8..03f2c28f11f5 100644
--- a/net/mptcp/pm_netlink.c
+++ b/net/mptcp/pm_netlink.c
@@ -228,6 +228,7 @@ static void mptcp_pm_add_timer(struct timer_list *timer)
 	if (!mptcp_pm_should_add_signal(msk)) {
 		pr_debug("retransmit ADD_ADDR id=%d", entry->addr.id);
 		mptcp_pm_announce_addr(msk, &entry->addr, false);
+		mptcp_pm_add_addr_send_ack(msk);
 		entry->retrans_times++;
 	}
 
@@ -328,6 +329,7 @@ static void mptcp_pm_create_subflow_or_signal_addr(struct mptcp_sock *msk)
 			if (mptcp_pm_alloc_anno_list(msk, local)) {
 				msk->pm.add_addr_signaled++;
 				mptcp_pm_announce_addr(msk, &local->addr, false);
+				mptcp_pm_nl_add_addr_send_ack(msk);
 			}
 		} else {
 			/* pick failed, avoid fourther attempts later */
@@ -398,6 +400,33 @@ void mptcp_pm_nl_add_addr_received(struct mptcp_sock *msk)
 	spin_lock_bh(&msk->pm.lock);
 
 	mptcp_pm_announce_addr(msk, &remote, true);
+	mptcp_pm_nl_add_addr_send_ack(msk);
+}
+
+void mptcp_pm_nl_add_addr_send_ack(struct mptcp_sock *msk)
+{
+	struct mptcp_subflow_context *subflow;
+
+	if (!mptcp_pm_should_add_signal_ipv6(msk))
+		return;
+
+	__mptcp_flush_join_list(msk);
+	subflow = list_first_entry_or_null(&msk->conn_list, typeof(*subflow), node);
+	if (subflow) {
+		struct sock *ssk = mptcp_subflow_tcp_sock(subflow);
+		u8 add_addr;
+
+		spin_unlock_bh(&msk->pm.lock);
+		pr_debug("send ack for add_addr6");
+		lock_sock(ssk);
+		tcp_send_ack(ssk);
+		release_sock(ssk);
+		spin_lock_bh(&msk->pm.lock);
+
+		add_addr = READ_ONCE(msk->pm.add_addr_signal);
+		add_addr &= ~BIT(MPTCP_ADD_ADDR_IPV6);
+		WRITE_ONCE(msk->pm.add_addr_signal, add_addr);
+	}
 }
 
 void mptcp_pm_nl_rm_addr_received(struct mptcp_sock *msk)
diff --git a/net/mptcp/protocol.c b/net/mptcp/protocol.c
index 0e83887efbc8..c2629190b1ce 100644
--- a/net/mptcp/protocol.c
+++ b/net/mptcp/protocol.c
@@ -690,7 +690,7 @@ void mptcp_data_ready(struct sock *sk, struct sock *ssk)
 		sk->sk_data_ready(sk);
 }
 
-static void __mptcp_flush_join_list(struct mptcp_sock *msk)
+void __mptcp_flush_join_list(struct mptcp_sock *msk)
 {
 	if (likely(list_empty(&msk->join_list)))
 		return;
@@ -1807,6 +1807,10 @@ static void pm_work(struct mptcp_sock *msk)
 		pm->status &= ~BIT(MPTCP_PM_ADD_ADDR_RECEIVED);
 		mptcp_pm_nl_add_addr_received(msk);
 	}
+	if (pm->status & BIT(MPTCP_PM_ADD_ADDR_SEND_ACK)) {
+		pm->status &= ~BIT(MPTCP_PM_ADD_ADDR_SEND_ACK);
+		mptcp_pm_nl_add_addr_send_ack(msk);
+	}
 	if (pm->status & BIT(MPTCP_PM_RM_ADDR_RECEIVED)) {
 		pm->status &= ~BIT(MPTCP_PM_RM_ADDR_RECEIVED);
 		mptcp_pm_nl_rm_addr_received(msk);
diff --git a/net/mptcp/protocol.h b/net/mptcp/protocol.h
index a62ffae621c2..4d6dd4adaaaf 100644
--- a/net/mptcp/protocol.h
+++ b/net/mptcp/protocol.h
@@ -160,6 +160,7 @@ struct mptcp_addr_info {
 
 enum mptcp_pm_status {
 	MPTCP_PM_ADD_ADDR_RECEIVED,
+	MPTCP_PM_ADD_ADDR_SEND_ACK,
 	MPTCP_PM_RM_ADDR_RECEIVED,
 	MPTCP_PM_ESTABLISHED,
 	MPTCP_PM_SUBFLOW_ESTABLISHED,
@@ -168,6 +169,7 @@ enum mptcp_pm_status {
 enum mptcp_add_addr_status {
 	MPTCP_ADD_ADDR_SIGNAL,
 	MPTCP_ADD_ADDR_ECHO,
+	MPTCP_ADD_ADDR_IPV6,
 };
 
 struct mptcp_pm_data {
@@ -466,6 +468,7 @@ bool mptcp_schedule_work(struct sock *sk);
 void mptcp_data_acked(struct sock *sk);
 void mptcp_subflow_eof(struct sock *sk);
 bool mptcp_update_rcv_data_fin(struct mptcp_sock *msk, u64 data_fin_seq, bool use_64bit);
+void __mptcp_flush_join_list(struct mptcp_sock *msk);
 static inline bool mptcp_data_fin_enabled(const struct mptcp_sock *msk)
 {
 	return READ_ONCE(msk->snd_data_fin_enable) &&
@@ -506,6 +509,7 @@ void mptcp_pm_subflow_established(struct mptcp_sock *msk,
 void mptcp_pm_subflow_closed(struct mptcp_sock *msk, u8 id);
 void mptcp_pm_add_addr_received(struct mptcp_sock *msk,
 				const struct mptcp_addr_info *addr);
+void mptcp_pm_add_addr_send_ack(struct mptcp_sock *msk);
 void mptcp_pm_rm_addr_received(struct mptcp_sock *msk, u8 rm_id);
 void mptcp_pm_free_anno_list(struct mptcp_sock *msk);
 struct mptcp_pm_add_entry *
@@ -528,6 +532,11 @@ static inline bool mptcp_pm_should_add_signal_echo(struct mptcp_sock *msk)
 	return READ_ONCE(msk->pm.add_addr_signal) & BIT(MPTCP_ADD_ADDR_ECHO);
 }
 
+static inline bool mptcp_pm_should_add_signal_ipv6(struct mptcp_sock *msk)
+{
+	return READ_ONCE(msk->pm.add_addr_signal) & BIT(MPTCP_ADD_ADDR_IPV6);
+}
+
 static inline bool mptcp_pm_should_rm_signal(struct mptcp_sock *msk)
 {
 	return READ_ONCE(msk->pm.rm_addr_signal);
@@ -552,6 +561,7 @@ void mptcp_pm_nl_data_init(struct mptcp_sock *msk);
 void mptcp_pm_nl_fully_established(struct mptcp_sock *msk);
 void mptcp_pm_nl_subflow_established(struct mptcp_sock *msk);
 void mptcp_pm_nl_add_addr_received(struct mptcp_sock *msk);
+void mptcp_pm_nl_add_addr_send_ack(struct mptcp_sock *msk);
 void mptcp_pm_nl_rm_addr_received(struct mptcp_sock *msk);
 void mptcp_pm_nl_rm_subflow_received(struct mptcp_sock *msk, u8 rm_id);
 int mptcp_pm_nl_get_local_id(struct mptcp_sock *msk, struct sock_common *skc);
-- 
2.29.2

