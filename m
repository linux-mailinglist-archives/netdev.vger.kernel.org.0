Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 6A9203AF8D5
	for <lists+netdev@lfdr.de>; Tue, 22 Jun 2021 00:54:47 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232279AbhFUW5A (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 21 Jun 2021 18:57:00 -0400
Received: from mga14.intel.com ([192.55.52.115]:11255 "EHLO mga14.intel.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S232064AbhFUW46 (ORCPT <rfc822;netdev@vger.kernel.org>);
        Mon, 21 Jun 2021 18:56:58 -0400
IronPort-SDR: SFGj0uYKXXNLk+kIcRvnNsO4uqH2yfzmkkXTw95G8tN9k17v1Q2mRPlkr4XiJJuB6Y4g5Xyefw
 uchij8fH6SWg==
X-IronPort-AV: E=McAfee;i="6200,9189,10022"; a="206768516"
X-IronPort-AV: E=Sophos;i="5.83,290,1616482800"; 
   d="scan'208";a="206768516"
Received: from orsmga001.jf.intel.com ([10.7.209.18])
  by fmsmga103.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 21 Jun 2021 15:54:42 -0700
IronPort-SDR: fNxp68xcddpWethI0oDj1VY3R7LQvYhwXN3+7jippMq6oHRx87RKYXEJJxUGeLeN0a/SnESfgc
 FFg7U2puhnxA==
X-IronPort-AV: E=Sophos;i="5.83,290,1616482800"; 
   d="scan'208";a="486673970"
Received: from mjmartin-desk2.amr.corp.intel.com (HELO mjmartin-desk2.intel.com) ([10.209.74.136])
  by orsmga001-auth.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 21 Jun 2021 15:54:42 -0700
From:   Mat Martineau <mathew.j.martineau@linux.intel.com>
To:     netdev@vger.kernel.org
Cc:     Paolo Abeni <pabeni@redhat.com>, davem@davemloft.net,
        kuba@kernel.org, matthieu.baerts@tessares.net,
        mptcp@lists.linux.dev,
        Mat Martineau <mathew.j.martineau@linux.intel.com>
Subject: [PATCH net-next 2/6] mptcp: use fast lock for subflows when possible
Date:   Mon, 21 Jun 2021 15:54:34 -0700
Message-Id: <20210621225438.10777-3-mathew.j.martineau@linux.intel.com>
X-Mailer: git-send-email 2.32.0
In-Reply-To: <20210621225438.10777-1-mathew.j.martineau@linux.intel.com>
References: <20210621225438.10777-1-mathew.j.martineau@linux.intel.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Paolo Abeni <pabeni@redhat.com>

There are a bunch of callsite where the ssk socket
lock is acquired using the full-blown version eligible for
the fast variant. Let's move to the latter.

Signed-off-by: Paolo Abeni <pabeni@redhat.com>
Signed-off-by: Mat Martineau <mathew.j.martineau@linux.intel.com>
---
 net/mptcp/pm_netlink.c | 10 ++++++----
 net/mptcp/protocol.c   | 15 +++++++++------
 2 files changed, 15 insertions(+), 10 deletions(-)

diff --git a/net/mptcp/pm_netlink.c b/net/mptcp/pm_netlink.c
index 09722598994d..d4732a4f223e 100644
--- a/net/mptcp/pm_netlink.c
+++ b/net/mptcp/pm_netlink.c
@@ -540,6 +540,7 @@ void mptcp_pm_nl_addr_send_ack(struct mptcp_sock *msk)
 	subflow = list_first_entry_or_null(&msk->conn_list, typeof(*subflow), node);
 	if (subflow) {
 		struct sock *ssk = mptcp_subflow_tcp_sock(subflow);
+		bool slow;
 
 		spin_unlock_bh(&msk->pm.lock);
 		pr_debug("send ack for %s%s%s",
@@ -547,9 +548,9 @@ void mptcp_pm_nl_addr_send_ack(struct mptcp_sock *msk)
 			 mptcp_pm_should_add_signal_ipv6(msk) ? " [ipv6]" : "",
 			 mptcp_pm_should_add_signal_port(msk) ? " [port]" : "");
 
-		lock_sock(ssk);
+		slow = lock_sock_fast(ssk);
 		tcp_send_ack(ssk);
-		release_sock(ssk);
+		unlock_sock_fast(ssk, slow);
 		spin_lock_bh(&msk->pm.lock);
 	}
 }
@@ -566,6 +567,7 @@ int mptcp_pm_nl_mp_prio_send_ack(struct mptcp_sock *msk,
 		struct sock *ssk = mptcp_subflow_tcp_sock(subflow);
 		struct sock *sk = (struct sock *)msk;
 		struct mptcp_addr_info local;
+		bool slow;
 
 		local_address((struct sock_common *)ssk, &local);
 		if (!addresses_equal(&local, addr, addr->port))
@@ -578,9 +580,9 @@ int mptcp_pm_nl_mp_prio_send_ack(struct mptcp_sock *msk,
 
 		spin_unlock_bh(&msk->pm.lock);
 		pr_debug("send ack for mp_prio");
-		lock_sock(ssk);
+		slow = lock_sock_fast(ssk);
 		tcp_send_ack(ssk);
-		release_sock(ssk);
+		unlock_sock_fast(ssk, slow);
 		spin_lock_bh(&msk->pm.lock);
 
 		return 0;
diff --git a/net/mptcp/protocol.c b/net/mptcp/protocol.c
index 77c90d6f04df..c47ce074737d 100644
--- a/net/mptcp/protocol.c
+++ b/net/mptcp/protocol.c
@@ -433,23 +433,25 @@ static void mptcp_send_ack(struct mptcp_sock *msk)
 
 	mptcp_for_each_subflow(msk, subflow) {
 		struct sock *ssk = mptcp_subflow_tcp_sock(subflow);
+		bool slow;
 
-		lock_sock(ssk);
+		slow = lock_sock_fast(ssk);
 		if (tcp_can_send_ack(ssk))
 			tcp_send_ack(ssk);
-		release_sock(ssk);
+		unlock_sock_fast(ssk, slow);
 	}
 }
 
 static bool mptcp_subflow_cleanup_rbuf(struct sock *ssk)
 {
+	bool slow;
 	int ret;
 
-	lock_sock(ssk);
+	slow = lock_sock_fast(ssk);
 	ret = tcp_can_send_ack(ssk);
 	if (ret)
 		tcp_cleanup_rbuf(ssk, 1);
-	release_sock(ssk);
+	unlock_sock_fast(ssk, slow);
 	return ret;
 }
 
@@ -2252,13 +2254,14 @@ static void mptcp_check_fastclose(struct mptcp_sock *msk)
 
 	list_for_each_entry_safe(subflow, tmp, &msk->conn_list, node) {
 		struct sock *tcp_sk = mptcp_subflow_tcp_sock(subflow);
+		bool slow;
 
-		lock_sock(tcp_sk);
+		slow = lock_sock_fast(tcp_sk);
 		if (tcp_sk->sk_state != TCP_CLOSE) {
 			tcp_send_active_reset(tcp_sk, GFP_ATOMIC);
 			tcp_set_state(tcp_sk, TCP_CLOSE);
 		}
-		release_sock(tcp_sk);
+		unlock_sock_fast(tcp_sk, slow);
 	}
 
 	inet_sk_state_store(sk, TCP_CLOSE);
-- 
2.32.0

