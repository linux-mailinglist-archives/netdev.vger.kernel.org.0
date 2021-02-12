Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id C011131A888
	for <lists+netdev@lfdr.de>; Sat, 13 Feb 2021 01:03:26 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231663AbhBMADU (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 12 Feb 2021 19:03:20 -0500
Received: from mga06.intel.com ([134.134.136.31]:22718 "EHLO mga06.intel.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S231317AbhBMADS (ORCPT <rfc822;netdev@vger.kernel.org>);
        Fri, 12 Feb 2021 19:03:18 -0500
IronPort-SDR: dvHF8j2/6SKF3AYQlWmSXZ8TX2lPueLw9nEVU70XJu3281l+biJuMLExYrZgE9BDnJENSLIy18
 dPFacDWfDbPg==
X-IronPort-AV: E=McAfee;i="6000,8403,9893"; a="243981688"
X-IronPort-AV: E=Sophos;i="5.81,175,1610438400"; 
   d="scan'208";a="243981688"
Received: from fmsmga002.fm.intel.com ([10.253.24.26])
  by orsmga104.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 12 Feb 2021 16:00:12 -0800
IronPort-SDR: t6gO7O/HnciW+RiFQ8SsnV+poc7BBHBK627m23ew8M/pHxtYOzV5XI9bmin8VnW0IwYikZgBsQ
 B97JfluDdrAw==
X-IronPort-AV: E=Sophos;i="5.81,175,1610438400"; 
   d="scan'208";a="423381120"
Received: from mjmartin-desk2.amr.corp.intel.com (HELO mjmartin-desk2.intel.com) ([10.254.85.171])
  by fmsmga002-auth.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 12 Feb 2021 16:00:11 -0800
From:   Mat Martineau <mathew.j.martineau@linux.intel.com>
To:     netdev@vger.kernel.org
Cc:     Florian Westphal <fw@strlen.de>, davem@davemloft.net,
        kuba@kernel.org, mptcp@lists.01.org, matthieu.baerts@tessares.net,
        Mat Martineau <mathew.j.martineau@linux.intel.com>
Subject: [PATCH net-next 2/8] mptcp: split __mptcp_close_ssk helper
Date:   Fri, 12 Feb 2021 15:59:55 -0800
Message-Id: <20210213000001.379332-3-mathew.j.martineau@linux.intel.com>
X-Mailer: git-send-email 2.30.1
In-Reply-To: <20210213000001.379332-1-mathew.j.martineau@linux.intel.com>
References: <20210213000001.379332-1-mathew.j.martineau@linux.intel.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Florian Westphal <fw@strlen.de>

Prepare for subflow close events:

When mptcp connection is torn down its enough to send the mptcp socket
close notification rather than a subflow close event for all of the
subflows followed by the mptcp close event.

This splits the helper: mptcp_close_ssk() will emit the close
notification, __mptcp_close_ssk will not.

Signed-off-by: Florian Westphal <fw@strlen.de>
Signed-off-by: Mat Martineau <mathew.j.martineau@linux.intel.com>
---
 net/mptcp/pm_netlink.c |  4 ++--
 net/mptcp/protocol.c   | 12 +++++++++---
 net/mptcp/protocol.h   |  4 ++--
 3 files changed, 13 insertions(+), 7 deletions(-)

diff --git a/net/mptcp/pm_netlink.c b/net/mptcp/pm_netlink.c
index 8f2fd6874d85..c3abff40fa4e 100644
--- a/net/mptcp/pm_netlink.c
+++ b/net/mptcp/pm_netlink.c
@@ -594,7 +594,7 @@ static void mptcp_pm_nl_rm_addr_received(struct mptcp_sock *msk)
 
 		spin_unlock_bh(&msk->pm.lock);
 		mptcp_subflow_shutdown(sk, ssk, how);
-		__mptcp_close_ssk(sk, ssk, subflow);
+		mptcp_close_ssk(sk, ssk, subflow);
 		spin_lock_bh(&msk->pm.lock);
 
 		msk->pm.add_addr_accepted--;
@@ -664,7 +664,7 @@ void mptcp_pm_nl_rm_subflow_received(struct mptcp_sock *msk, u8 rm_id)
 
 		spin_unlock_bh(&msk->pm.lock);
 		mptcp_subflow_shutdown(sk, ssk, how);
-		__mptcp_close_ssk(sk, ssk, subflow);
+		mptcp_close_ssk(sk, ssk, subflow);
 		spin_lock_bh(&msk->pm.lock);
 
 		msk->pm.local_addr_used--;
diff --git a/net/mptcp/protocol.c b/net/mptcp/protocol.c
index 93134b72490a..3fd8aef979a3 100644
--- a/net/mptcp/protocol.c
+++ b/net/mptcp/protocol.c
@@ -2114,8 +2114,8 @@ static struct sock *mptcp_subflow_get_retrans(const struct mptcp_sock *msk)
  * so we need to use tcp_close() after detaching them from the mptcp
  * parent socket.
  */
-void __mptcp_close_ssk(struct sock *sk, struct sock *ssk,
-		       struct mptcp_subflow_context *subflow)
+static void __mptcp_close_ssk(struct sock *sk, struct sock *ssk,
+			      struct mptcp_subflow_context *subflow)
 {
 	list_del(&subflow->node);
 
@@ -2147,6 +2147,12 @@ void __mptcp_close_ssk(struct sock *sk, struct sock *ssk,
 	sock_put(ssk);
 }
 
+void mptcp_close_ssk(struct sock *sk, struct sock *ssk,
+		     struct mptcp_subflow_context *subflow)
+{
+	__mptcp_close_ssk(sk, ssk, subflow);
+}
+
 static unsigned int mptcp_sync_mss(struct sock *sk, u32 pmtu)
 {
 	return 0;
@@ -2164,7 +2170,7 @@ static void __mptcp_close_subflow(struct mptcp_sock *msk)
 		if (inet_sk_state_load(ssk) != TCP_CLOSE)
 			continue;
 
-		__mptcp_close_ssk((struct sock *)msk, ssk, subflow);
+		mptcp_close_ssk((struct sock *)msk, ssk, subflow);
 	}
 }
 
diff --git a/net/mptcp/protocol.h b/net/mptcp/protocol.h
index 702dbfefa093..3081294dca6c 100644
--- a/net/mptcp/protocol.h
+++ b/net/mptcp/protocol.h
@@ -539,8 +539,8 @@ void mptcp_subflow_fully_established(struct mptcp_subflow_context *subflow,
 bool mptcp_subflow_data_available(struct sock *sk);
 void __init mptcp_subflow_init(void);
 void mptcp_subflow_shutdown(struct sock *sk, struct sock *ssk, int how);
-void __mptcp_close_ssk(struct sock *sk, struct sock *ssk,
-		       struct mptcp_subflow_context *subflow);
+void mptcp_close_ssk(struct sock *sk, struct sock *ssk,
+		     struct mptcp_subflow_context *subflow);
 void mptcp_subflow_reset(struct sock *ssk);
 void mptcp_sock_graft(struct sock *sk, struct socket *parent);
 struct socket *__mptcp_nmpc_socket(const struct mptcp_sock *msk);
-- 
2.30.1

