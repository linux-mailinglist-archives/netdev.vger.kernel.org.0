Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 988D534AE93
	for <lists+netdev@lfdr.de>; Fri, 26 Mar 2021 19:28:31 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230401AbhCZS2E (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 26 Mar 2021 14:28:04 -0400
Received: from mga05.intel.com ([192.55.52.43]:12666 "EHLO mga05.intel.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S230236AbhCZS1h (ORCPT <rfc822;netdev@vger.kernel.org>);
        Fri, 26 Mar 2021 14:27:37 -0400
IronPort-SDR: XfycC4sa+6wsnfwq0bPrUN4FHsOYtIKFZqEpa1a0z5GKHPJCRmv1H7dqQiHi0dobIopcVn1O6N
 0D0LSZMmnXXg==
X-IronPort-AV: E=McAfee;i="6000,8403,9935"; a="276343008"
X-IronPort-AV: E=Sophos;i="5.81,281,1610438400"; 
   d="scan'208";a="276343008"
Received: from fmsmga002.fm.intel.com ([10.253.24.26])
  by fmsmga105.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 26 Mar 2021 11:27:37 -0700
IronPort-SDR: 6UneWHQTMUMz4ipzh1yDnqKfCy6zImoD7RuYS4gDpYniWO9e5okTVXmv/FulxNEzHaaaaF3sk0
 FZeklBXIr+JA==
X-IronPort-AV: E=Sophos;i="5.81,281,1610438400"; 
   d="scan'208";a="443456570"
Received: from mjmartin-desk2.amr.corp.intel.com (HELO mjmartin-desk2.intel.com) ([10.251.24.139])
  by fmsmga002-auth.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 26 Mar 2021 11:27:36 -0700
From:   Mat Martineau <mathew.j.martineau@linux.intel.com>
To:     netdev@vger.kernel.org
Cc:     Geliang Tang <geliangtang@gmail.com>, davem@davemloft.net,
        kuba@kernel.org, matthieu.baerts@tessares.net,
        mptcp@lists.linux.dev,
        Mat Martineau <mathew.j.martineau@linux.intel.com>
Subject: [PATCH net-next 11/13] mptcp: send ack for rm_addr
Date:   Fri, 26 Mar 2021 11:26:40 -0700
Message-Id: <20210326182642.136419-11-mathew.j.martineau@linux.intel.com>
X-Mailer: git-send-email 2.31.0
In-Reply-To: <20210326182642.136419-1-mathew.j.martineau@linux.intel.com>
References: <20210326182307.136256-1-mathew.j.martineau@linux.intel.com>
 <20210326182642.136419-1-mathew.j.martineau@linux.intel.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Geliang Tang <geliangtang@gmail.com>

This patch changes the sending ACK conditions for the ADD_ADDR, send an
ACK packet for RM_ADDR too.

In mptcp_pm_remove_addr, invoke mptcp_pm_nl_add_addr_send_ack to send
the ACK packet.

Signed-off-by: Geliang Tang <geliangtang@gmail.com>
Signed-off-by: Mat Martineau <mathew.j.martineau@linux.intel.com>
---
 net/mptcp/pm.c         |  1 +
 net/mptcp/pm_netlink.c | 10 +++++-----
 net/mptcp/protocol.h   |  1 +
 3 files changed, 7 insertions(+), 5 deletions(-)

diff --git a/net/mptcp/pm.c b/net/mptcp/pm.c
index 966942d1013f..efa7deb96139 100644
--- a/net/mptcp/pm.c
+++ b/net/mptcp/pm.c
@@ -53,6 +53,7 @@ int mptcp_pm_remove_addr(struct mptcp_sock *msk, const struct mptcp_rm_list *rm_
 	msk->pm.rm_list_tx = *rm_list;
 	rm_addr |= BIT(MPTCP_RM_ADDR_SIGNAL);
 	WRITE_ONCE(msk->pm.addr_signal, rm_addr);
+	mptcp_pm_nl_add_addr_send_ack(msk);
 	return 0;
 }
 
diff --git a/net/mptcp/pm_netlink.c b/net/mptcp/pm_netlink.c
index 743bd23b1f78..f71e910670bf 100644
--- a/net/mptcp/pm_netlink.c
+++ b/net/mptcp/pm_netlink.c
@@ -56,8 +56,6 @@ struct pm_nl_pernet {
 #define MPTCP_PM_ADDR_MAX	8
 #define ADD_ADDR_RETRANS_MAX	3
 
-static void mptcp_pm_nl_add_addr_send_ack(struct mptcp_sock *msk);
-
 static bool addresses_equal(const struct mptcp_addr_info *a,
 			    struct mptcp_addr_info *b, bool use_port)
 {
@@ -524,14 +522,15 @@ static void mptcp_pm_nl_add_addr_received(struct mptcp_sock *msk)
 	mptcp_pm_nl_add_addr_send_ack(msk);
 }
 
-static void mptcp_pm_nl_add_addr_send_ack(struct mptcp_sock *msk)
+void mptcp_pm_nl_add_addr_send_ack(struct mptcp_sock *msk)
 {
 	struct mptcp_subflow_context *subflow;
 
 	msk_owned_by_me(msk);
 	lockdep_assert_held(&msk->pm.lock);
 
-	if (!mptcp_pm_should_add_signal(msk))
+	if (!mptcp_pm_should_add_signal(msk) &&
+	    !mptcp_pm_should_rm_signal(msk))
 		return;
 
 	__mptcp_flush_join_list(msk);
@@ -540,7 +539,8 @@ static void mptcp_pm_nl_add_addr_send_ack(struct mptcp_sock *msk)
 		struct sock *ssk = mptcp_subflow_tcp_sock(subflow);
 
 		spin_unlock_bh(&msk->pm.lock);
-		pr_debug("send ack for add_addr%s%s",
+		pr_debug("send ack for %s%s%s",
+			 mptcp_pm_should_add_signal(msk) ? "add_addr" : "rm_addr",
 			 mptcp_pm_should_add_signal_ipv6(msk) ? " [ipv6]" : "",
 			 mptcp_pm_should_add_signal_port(msk) ? " [port]" : "");
 
diff --git a/net/mptcp/protocol.h b/net/mptcp/protocol.h
index b417b3591e07..6ce6ef58f092 100644
--- a/net/mptcp/protocol.h
+++ b/net/mptcp/protocol.h
@@ -650,6 +650,7 @@ void mptcp_pm_add_addr_received(struct mptcp_sock *msk,
 void mptcp_pm_add_addr_echoed(struct mptcp_sock *msk,
 			      struct mptcp_addr_info *addr);
 void mptcp_pm_add_addr_send_ack(struct mptcp_sock *msk);
+void mptcp_pm_nl_add_addr_send_ack(struct mptcp_sock *msk);
 void mptcp_pm_rm_addr_received(struct mptcp_sock *msk,
 			       const struct mptcp_rm_list *rm_list);
 void mptcp_pm_mp_prio_received(struct sock *sk, u8 bkup);
-- 
2.31.0

