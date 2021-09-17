Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 18C614101C5
	for <lists+netdev@lfdr.de>; Sat, 18 Sep 2021 01:33:34 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S239283AbhIQXez (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 17 Sep 2021 19:34:55 -0400
Received: from mga02.intel.com ([134.134.136.20]:37385 "EHLO mga02.intel.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S234992AbhIQXex (ORCPT <rfc822;netdev@vger.kernel.org>);
        Fri, 17 Sep 2021 19:34:53 -0400
X-IronPort-AV: E=McAfee;i="6200,9189,10110"; a="210130344"
X-IronPort-AV: E=Sophos;i="5.85,302,1624345200"; 
   d="scan'208";a="210130344"
Received: from orsmga008.jf.intel.com ([10.7.209.65])
  by orsmga101.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 17 Sep 2021 16:33:30 -0700
X-IronPort-AV: E=Sophos;i="5.85,302,1624345200"; 
   d="scan'208";a="483228556"
Received: from mjmartin-desk2.amr.corp.intel.com (HELO mjmartin-desk2.intel.com) ([10.212.205.24])
  by orsmga008-auth.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 17 Sep 2021 16:33:29 -0700
From:   Mat Martineau <mathew.j.martineau@linux.intel.com>
To:     netdev@vger.kernel.org
Cc:     Florian Westphal <fw@strlen.de>, davem@davemloft.net,
        kuba@kernel.org, matthieu.baerts@tessares.net,
        mptcp@lists.linux.dev,
        Mat Martineau <mathew.j.martineau@linux.intel.com>
Subject: [PATCH net-next 1/5] mptcp: add new mptcp_fill_diag helper
Date:   Fri, 17 Sep 2021 16:33:18 -0700
Message-Id: <20210917233322.271789-2-mathew.j.martineau@linux.intel.com>
X-Mailer: git-send-email 2.33.0
In-Reply-To: <20210917233322.271789-1-mathew.j.martineau@linux.intel.com>
References: <20210917233322.271789-1-mathew.j.martineau@linux.intel.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Florian Westphal <fw@strlen.de>

Will be re-used from getsockopt path.
Since diag can be a module, we can't export the helper from diag, it
needs to be moved to core.

Signed-off-by: Florian Westphal <fw@strlen.de>
Signed-off-by: Mat Martineau <mathew.j.martineau@linux.intel.com>
---
 include/net/mptcp.h    |  4 ++++
 net/mptcp/mptcp_diag.c | 26 +-------------------------
 net/mptcp/sockopt.c    | 32 ++++++++++++++++++++++++++++++++
 3 files changed, 37 insertions(+), 25 deletions(-)

diff --git a/include/net/mptcp.h b/include/net/mptcp.h
index 6026bbefbffd..f83fa48408b3 100644
--- a/include/net/mptcp.h
+++ b/include/net/mptcp.h
@@ -12,6 +12,8 @@
 #include <linux/tcp.h>
 #include <linux/types.h>
 
+struct mptcp_info;
+struct mptcp_sock;
 struct seq_file;
 
 /* MPTCP sk_buff extension data */
@@ -121,6 +123,8 @@ bool mptcp_incoming_options(struct sock *sk, struct sk_buff *skb);
 void mptcp_write_options(__be32 *ptr, const struct tcp_sock *tp,
 			 struct mptcp_out_options *opts);
 
+void mptcp_diag_fill_info(struct mptcp_sock *msk, struct mptcp_info *info);
+
 /* move the skb extension owership, with the assumption that 'to' is
  * newly allocated
  */
diff --git a/net/mptcp/mptcp_diag.c b/net/mptcp/mptcp_diag.c
index f48eb6315bbb..fdf0c1f15a65 100644
--- a/net/mptcp/mptcp_diag.c
+++ b/net/mptcp/mptcp_diag.c
@@ -113,37 +113,13 @@ static void mptcp_diag_get_info(struct sock *sk, struct inet_diag_msg *r,
 {
 	struct mptcp_sock *msk = mptcp_sk(sk);
 	struct mptcp_info *info = _info;
-	u32 flags = 0;
-	bool slow;
-	u8 val;
 
 	r->idiag_rqueue = sk_rmem_alloc_get(sk);
 	r->idiag_wqueue = sk_wmem_alloc_get(sk);
 	if (!info)
 		return;
 
-	slow = lock_sock_fast(sk);
-	info->mptcpi_subflows = READ_ONCE(msk->pm.subflows);
-	info->mptcpi_add_addr_signal = READ_ONCE(msk->pm.add_addr_signaled);
-	info->mptcpi_add_addr_accepted = READ_ONCE(msk->pm.add_addr_accepted);
-	info->mptcpi_local_addr_used = READ_ONCE(msk->pm.local_addr_used);
-	info->mptcpi_subflows_max = mptcp_pm_get_subflows_max(msk);
-	val = mptcp_pm_get_add_addr_signal_max(msk);
-	info->mptcpi_add_addr_signal_max = val;
-	val = mptcp_pm_get_add_addr_accept_max(msk);
-	info->mptcpi_add_addr_accepted_max = val;
-	info->mptcpi_local_addr_max = mptcp_pm_get_local_addr_max(msk);
-	if (test_bit(MPTCP_FALLBACK_DONE, &msk->flags))
-		flags |= MPTCP_INFO_FLAG_FALLBACK;
-	if (READ_ONCE(msk->can_ack))
-		flags |= MPTCP_INFO_FLAG_REMOTE_KEY_RECEIVED;
-	info->mptcpi_flags = flags;
-	info->mptcpi_token = READ_ONCE(msk->token);
-	info->mptcpi_write_seq = READ_ONCE(msk->write_seq);
-	info->mptcpi_snd_una = READ_ONCE(msk->snd_una);
-	info->mptcpi_rcv_nxt = READ_ONCE(msk->ack_seq);
-	info->mptcpi_csum_enabled = READ_ONCE(msk->csum_enabled);
-	unlock_sock_fast(sk, slow);
+	mptcp_diag_fill_info(msk, info);
 }
 
 static const struct inet_diag_handler mptcp_diag_handler = {
diff --git a/net/mptcp/sockopt.c b/net/mptcp/sockopt.c
index 8c03afac5ca0..54f0d521a399 100644
--- a/net/mptcp/sockopt.c
+++ b/net/mptcp/sockopt.c
@@ -670,6 +670,38 @@ static int mptcp_getsockopt_first_sf_only(struct mptcp_sock *msk, int level, int
 	return ret;
 }
 
+void mptcp_diag_fill_info(struct mptcp_sock *msk, struct mptcp_info *info)
+{
+	struct sock *sk = &msk->sk.icsk_inet.sk;
+	bool slow = lock_sock_fast(sk);
+	u32 flags = 0;
+	u8 val;
+
+	info->mptcpi_subflows = READ_ONCE(msk->pm.subflows);
+	info->mptcpi_add_addr_signal = READ_ONCE(msk->pm.add_addr_signaled);
+	info->mptcpi_add_addr_accepted = READ_ONCE(msk->pm.add_addr_accepted);
+	info->mptcpi_local_addr_used = READ_ONCE(msk->pm.local_addr_used);
+	info->mptcpi_subflows_max = mptcp_pm_get_subflows_max(msk);
+	val = mptcp_pm_get_add_addr_signal_max(msk);
+	info->mptcpi_add_addr_signal_max = val;
+	val = mptcp_pm_get_add_addr_accept_max(msk);
+	info->mptcpi_add_addr_accepted_max = val;
+	info->mptcpi_local_addr_max = mptcp_pm_get_local_addr_max(msk);
+	if (test_bit(MPTCP_FALLBACK_DONE, &msk->flags))
+		flags |= MPTCP_INFO_FLAG_FALLBACK;
+	if (READ_ONCE(msk->can_ack))
+		flags |= MPTCP_INFO_FLAG_REMOTE_KEY_RECEIVED;
+	info->mptcpi_flags = flags;
+	info->mptcpi_token = READ_ONCE(msk->token);
+	info->mptcpi_write_seq = READ_ONCE(msk->write_seq);
+	info->mptcpi_snd_una = READ_ONCE(msk->snd_una);
+	info->mptcpi_rcv_nxt = READ_ONCE(msk->ack_seq);
+	info->mptcpi_csum_enabled = READ_ONCE(msk->csum_enabled);
+
+	unlock_sock_fast(sk, slow);
+}
+EXPORT_SYMBOL_GPL(mptcp_diag_fill_info);
+
 static int mptcp_getsockopt_sol_tcp(struct mptcp_sock *msk, int optname,
 				    char __user *optval, int __user *optlen)
 {
-- 
2.33.0

