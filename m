Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id D7178308321
	for <lists+netdev@lfdr.de>; Fri, 29 Jan 2021 02:19:13 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231459AbhA2BSW (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 28 Jan 2021 20:18:22 -0500
Received: from mga07.intel.com ([134.134.136.100]:6819 "EHLO mga07.intel.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S231686AbhA2BSQ (ORCPT <rfc822;netdev@vger.kernel.org>);
        Thu, 28 Jan 2021 20:18:16 -0500
IronPort-SDR: cCnEKgR9NtBJoh/enHovnNzRMIavHsdqHMaS0y+wYvfdabClMQKmG55hvYR2xUvkrd68bYM5LN
 V3qGhT2/d8fw==
X-IronPort-AV: E=McAfee;i="6000,8403,9878"; a="244430176"
X-IronPort-AV: E=Sophos;i="5.79,384,1602572400"; 
   d="scan'208";a="244430176"
Received: from orsmga004.jf.intel.com ([10.7.209.38])
  by orsmga105.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 28 Jan 2021 17:11:23 -0800
IronPort-SDR: CfzL76TMKLc5zO56oJyRK1WzWPF+eJBiNvyiUmfalqgurSlLL0QlgLWCBdVF6Mu+f9cnQ6MkSp
 LRO1+MpCu58g==
X-IronPort-AV: E=Sophos;i="5.79,384,1602572400"; 
   d="scan'208";a="505538337"
Received: from mjmartin-desk2.amr.corp.intel.com (HELO mjmartin-desk2.intel.com) ([10.254.96.46])
  by orsmga004-auth.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 28 Jan 2021 17:11:23 -0800
From:   Mat Martineau <mathew.j.martineau@linux.intel.com>
To:     netdev@vger.kernel.org
Cc:     Geliang Tang <geliangtang@gmail.com>, davem@davemloft.net,
        kuba@kernel.org, mptcp@lists.01.org,
        Mat Martineau <mathew.j.martineau@linux.intel.com>
Subject: [PATCH net-next 10/16] mptcp: add port number check for MP_JOIN
Date:   Thu, 28 Jan 2021 17:11:09 -0800
Message-Id: <20210129011115.133953-11-mathew.j.martineau@linux.intel.com>
X-Mailer: git-send-email 2.30.0
In-Reply-To: <20210129011115.133953-1-mathew.j.martineau@linux.intel.com>
References: <20210129011115.133953-1-mathew.j.martineau@linux.intel.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Geliang Tang <geliangtang@gmail.com>

This patch adds two new helpers, subflow_use_different_sport and
subflow_use_different_dport, to check whether the subflow's source or
destination port number is different from the msk's port number. When
receiving the MP_JOIN's SYN/SYNACK/ACK, we do these port number checks
and print out the different port numbers.

And furthermore, when receiving the MP_JOIN's SYN/ACK, we also use a new
helper mptcp_pm_sport_in_anno_list to check whether this port number is
announced. If it isn't, we need to abort this connection.

This patch also populates the local address's port field in
local_address.

Signed-off-by: Geliang Tang <geliangtang@gmail.com>
Signed-off-by: Mat Martineau <mathew.j.martineau@linux.intel.com>
---
 net/mptcp/pm_netlink.c | 23 ++++++++++++++++++++++-
 net/mptcp/protocol.h   |  1 +
 net/mptcp/subflow.c    | 38 ++++++++++++++++++++++++++++++++++++++
 3 files changed, 61 insertions(+), 1 deletion(-)

diff --git a/net/mptcp/pm_netlink.c b/net/mptcp/pm_netlink.c
index 5ab79f659c6d..d6e23e079fb0 100644
--- a/net/mptcp/pm_netlink.c
+++ b/net/mptcp/pm_netlink.c
@@ -97,8 +97,8 @@ static bool address_zero(const struct mptcp_addr_info *addr)
 static void local_address(const struct sock_common *skc,
 			  struct mptcp_addr_info *addr)
 {
-	addr->port = 0;
 	addr->family = skc->skc_family;
+	addr->port = htons(skc->skc_num);
 	if (addr->family == AF_INET)
 		addr->addr.s_addr = skc->skc_rcv_saddr;
 #if IS_ENABLED(CONFIG_MPTCP_IPV6)
@@ -254,6 +254,27 @@ lookup_anno_list_by_saddr(struct mptcp_sock *msk,
 	return NULL;
 }
 
+bool mptcp_pm_sport_in_anno_list(struct mptcp_sock *msk, const struct sock *sk)
+{
+	struct mptcp_pm_add_entry *entry;
+	struct mptcp_addr_info saddr;
+	bool ret = false;
+
+	local_address((struct sock_common *)sk, &saddr);
+
+	spin_lock_bh(&msk->pm.lock);
+	list_for_each_entry(entry, &msk->pm.anno_list, list) {
+		if (addresses_equal(&entry->addr, &saddr, true)) {
+			ret = true;
+			goto out;
+		}
+	}
+
+out:
+	spin_unlock_bh(&msk->pm.lock);
+	return ret;
+}
+
 static void mptcp_pm_add_timer(struct timer_list *timer)
 {
 	struct mptcp_pm_add_entry *entry = from_timer(entry, timer, add_timer);
diff --git a/net/mptcp/protocol.h b/net/mptcp/protocol.h
index 7e0d8774c673..1d6076f1c538 100644
--- a/net/mptcp/protocol.h
+++ b/net/mptcp/protocol.h
@@ -649,6 +649,7 @@ int mptcp_pm_nl_mp_prio_send_ack(struct mptcp_sock *msk,
 				 struct mptcp_addr_info *addr,
 				 u8 bkup);
 void mptcp_pm_free_anno_list(struct mptcp_sock *msk);
+bool mptcp_pm_sport_in_anno_list(struct mptcp_sock *msk, const struct sock *sk);
 struct mptcp_pm_add_entry *
 mptcp_pm_del_add_timer(struct mptcp_sock *msk,
 		       struct mptcp_addr_info *addr);
diff --git a/net/mptcp/subflow.c b/net/mptcp/subflow.c
index 94926ab74d48..ebfbf6a9b669 100644
--- a/net/mptcp/subflow.c
+++ b/net/mptcp/subflow.c
@@ -120,6 +120,11 @@ static int __subflow_init_req(struct request_sock *req, const struct sock *sk_li
 	return 0;
 }
 
+static bool subflow_use_different_sport(struct mptcp_sock *msk, const struct sock *sk)
+{
+	return inet_sk(sk)->inet_sport != inet_sk((struct sock *)msk)->inet_sport;
+}
+
 /* Init mptcp request socket.
  *
  * Returns an error code if a JOIN has failed and a TCP reset
@@ -192,6 +197,20 @@ static int subflow_init_req(struct request_sock *req,
 		if (!subflow_req->msk)
 			return -EPERM;
 
+		if (subflow_use_different_sport(subflow_req->msk, sk_listener)) {
+			pr_debug("syn inet_sport=%d %d",
+				 ntohs(inet_sk(sk_listener)->inet_sport),
+				 ntohs(inet_sk((struct sock *)subflow_req->msk)->inet_sport));
+			if (!mptcp_pm_sport_in_anno_list(subflow_req->msk, sk_listener)) {
+				sock_put((struct sock *)subflow_req->msk);
+				mptcp_token_destroy_request(req);
+				tcp_request_sock_ops.destructor(req);
+				subflow_req->msk = NULL;
+				subflow_req->mp_join = 0;
+				return -EPERM;
+			}
+		}
+
 		subflow_req_create_thmac(subflow_req);
 
 		if (unlikely(req->syncookie)) {
@@ -336,6 +355,11 @@ void mptcp_subflow_reset(struct sock *ssk)
 	sock_put(sk);
 }
 
+static bool subflow_use_different_dport(struct mptcp_sock *msk, const struct sock *sk)
+{
+	return inet_sk(sk)->inet_dport != inet_sk((struct sock *)msk)->inet_dport;
+}
+
 static void subflow_finish_connect(struct sock *sk, const struct sk_buff *skb)
 {
 	struct mptcp_subflow_context *subflow = mptcp_subflow_ctx(sk);
@@ -402,6 +426,12 @@ static void subflow_finish_connect(struct sock *sk, const struct sk_buff *skb)
 
 		subflow->mp_join = 1;
 		MPTCP_INC_STATS(sock_net(sk), MPTCP_MIB_JOINSYNACKRX);
+
+		if (subflow_use_different_dport(mptcp_sk(parent), sk)) {
+			pr_debug("synack inet_dport=%d %d",
+				 ntohs(inet_sk(sk)->inet_dport),
+				 ntohs(inet_sk(parent)->inet_dport));
+		}
 	} else if (mptcp_check_fallback(sk)) {
 fallback:
 		mptcp_rcv_space_init(mptcp_sk(parent), sk);
@@ -667,6 +697,14 @@ static struct sock *subflow_syn_recv_sock(const struct sock *sk,
 
 			SUBFLOW_REQ_INC_STATS(req, MPTCP_MIB_JOINACKRX);
 			tcp_rsk(req)->drop_req = true;
+
+			if (subflow_use_different_sport(owner, sk)) {
+				pr_debug("ack inet_sport=%d %d",
+					 ntohs(inet_sk(sk)->inet_sport),
+					 ntohs(inet_sk((struct sock *)owner)->inet_sport));
+				if (!mptcp_pm_sport_in_anno_list(owner, sk))
+					goto out;
+			}
 		}
 	}
 
-- 
2.30.0

