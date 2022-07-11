Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 47E67570A7D
	for <lists+netdev@lfdr.de>; Mon, 11 Jul 2022 21:16:43 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229922AbiGKTQl (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 11 Jul 2022 15:16:41 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:56390 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229721AbiGKTQk (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 11 Jul 2022 15:16:40 -0400
Received: from mga11.intel.com (mga11.intel.com [192.55.52.93])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 68DAE2A970
        for <netdev@vger.kernel.org>; Mon, 11 Jul 2022 12:16:39 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1657566999; x=1689102999;
  h=from:to:cc:subject:date:message-id:in-reply-to:
   references:mime-version:content-transfer-encoding;
  bh=t7KH8qBXV+0o1mxMLu306DNdEfP6w1tkeWJrivYbd+8=;
  b=O1MYrK6BaVI15nrHmI4t6acCAKc/RYZ7QD6tDkof+aggcZRxDSYqn3q5
   e5QIKeHg4uBUKmiZMMPni0o0Cw8dqCikxrJXtUcodTlj2yNrYujam23j3
   QKQw7Wj3P7yXFHigxPKiQABlfPf4B24fC410naA6ACPAU14jqGtNmYySO
   9FBTdwHB3033KHZ0UW4WtOTEbDKAdkkWIxTaPEofWmr7yw7t7Z/0nsEzp
   C/4B3lS4cxKDUahR68q68XA0Qe1b/nUaB3fgIcrkEiIIBu29NTA5r6alG
   Dl2+WCgbEKtXrrUYiM/htTBmkY7ZOazR1mYvFzXkQCzVp/sH9XN7GtiTf
   A==;
X-IronPort-AV: E=McAfee;i="6400,9594,10405"; a="282300978"
X-IronPort-AV: E=Sophos;i="5.92,263,1650956400"; 
   d="scan'208";a="282300978"
Received: from fmsmga002.fm.intel.com ([10.253.24.26])
  by fmsmga102.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 11 Jul 2022 12:16:38 -0700
X-IronPort-AV: E=Sophos;i="5.92,263,1650956400"; 
   d="scan'208";a="697742711"
Received: from eedeets-mobl1.amr.corp.intel.com (HELO mjmartin-desk2.intel.com) ([10.251.2.111])
  by fmsmga002-auth.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 11 Jul 2022 12:16:38 -0700
From:   Mat Martineau <mathew.j.martineau@linux.intel.com>
To:     netdev@vger.kernel.org
Cc:     Paolo Abeni <pabeni@redhat.com>, davem@davemloft.net,
        kuba@kernel.org, edumazet@google.com, matthieu.baerts@tessares.net,
        mptcp@lists.linux.dev,
        Mat Martineau <mathew.j.martineau@linux.intel.com>
Subject: [PATCH net-next 1/5] mptcp: introduce and use mptcp_pm_send_ack()
Date:   Mon, 11 Jul 2022 12:16:29 -0700
Message-Id: <20220711191633.80826-2-mathew.j.martineau@linux.intel.com>
X-Mailer: git-send-email 2.37.0
In-Reply-To: <20220711191633.80826-1-mathew.j.martineau@linux.intel.com>
References: <20220711191633.80826-1-mathew.j.martineau@linux.intel.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-7.6 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,SPF_HELO_NONE,
        SPF_NONE,T_SCC_BODY_TEXT_LINE autolearn=ham autolearn_force=no
        version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Paolo Abeni <pabeni@redhat.com>

The in-kernel PM has a bit of duplicate code related to ack
generation. Create a new helper factoring out the PM-specific
needs and use it in a couple of places.

As a bonus, mptcp_subflow_send_ack() is not used anymore
outside its own compilation unit and can become static.

Reviewed-by: Mat Martineau <mathew.j.martineau@linux.intel.com>
Signed-off-by: Paolo Abeni <pabeni@redhat.com>
Signed-off-by: Mat Martineau <mathew.j.martineau@linux.intel.com>
---
 net/mptcp/pm_netlink.c | 56 +++++++++++++++++++++++++-----------------
 net/mptcp/protocol.c   |  2 +-
 net/mptcp/protocol.h   |  1 -
 3 files changed, 35 insertions(+), 24 deletions(-)

diff --git a/net/mptcp/pm_netlink.c b/net/mptcp/pm_netlink.c
index 5bdb559d5242..8e1d3aec94da 100644
--- a/net/mptcp/pm_netlink.c
+++ b/net/mptcp/pm_netlink.c
@@ -463,6 +463,37 @@ static unsigned int fill_remote_addresses_vec(struct mptcp_sock *msk, bool fullm
 	return i;
 }
 
+static void __mptcp_pm_send_ack(struct mptcp_sock *msk, struct mptcp_subflow_context *subflow,
+				bool prio, bool backup)
+{
+	struct sock *ssk = mptcp_subflow_tcp_sock(subflow);
+	bool slow;
+
+	pr_debug("send ack for %s",
+		 prio ? "mp_prio" : (mptcp_pm_should_add_signal(msk) ? "add_addr" : "rm_addr"));
+
+	slow = lock_sock_fast(ssk);
+	if (prio) {
+		if (subflow->backup != backup)
+			msk->last_snd = NULL;
+
+		subflow->send_mp_prio = 1;
+		subflow->backup = backup;
+		subflow->request_bkup = backup;
+	}
+
+	__mptcp_subflow_send_ack(ssk);
+	unlock_sock_fast(ssk, slow);
+}
+
+static void mptcp_pm_send_ack(struct mptcp_sock *msk, struct mptcp_subflow_context *subflow,
+			      bool prio, bool backup)
+{
+	spin_unlock_bh(&msk->pm.lock);
+	__mptcp_pm_send_ack(msk, subflow, prio, backup);
+	spin_lock_bh(&msk->pm.lock);
+}
+
 static struct mptcp_pm_addr_entry *
 __lookup_addr_by_id(struct pm_nl_pernet *pernet, unsigned int id)
 {
@@ -705,16 +736,8 @@ void mptcp_pm_nl_addr_send_ack(struct mptcp_sock *msk)
 		return;
 
 	subflow = list_first_entry_or_null(&msk->conn_list, typeof(*subflow), node);
-	if (subflow) {
-		struct sock *ssk = mptcp_subflow_tcp_sock(subflow);
-
-		spin_unlock_bh(&msk->pm.lock);
-		pr_debug("send ack for %s",
-			 mptcp_pm_should_add_signal(msk) ? "add_addr" : "rm_addr");
-
-		mptcp_subflow_send_ack(ssk);
-		spin_lock_bh(&msk->pm.lock);
-	}
+	if (subflow)
+		mptcp_pm_send_ack(msk, subflow, false, false);
 }
 
 int mptcp_pm_nl_mp_prio_send_ack(struct mptcp_sock *msk,
@@ -729,7 +752,6 @@ int mptcp_pm_nl_mp_prio_send_ack(struct mptcp_sock *msk,
 	mptcp_for_each_subflow(msk, subflow) {
 		struct sock *ssk = mptcp_subflow_tcp_sock(subflow);
 		struct mptcp_addr_info local, remote;
-		bool slow;
 
 		local_address((struct sock_common *)ssk, &local);
 		if (!mptcp_addresses_equal(&local, addr, addr->port))
@@ -741,17 +763,7 @@ int mptcp_pm_nl_mp_prio_send_ack(struct mptcp_sock *msk,
 				continue;
 		}
 
-		slow = lock_sock_fast(ssk);
-		if (subflow->backup != bkup)
-			msk->last_snd = NULL;
-		subflow->backup = bkup;
-		subflow->send_mp_prio = 1;
-		subflow->request_bkup = bkup;
-
-		pr_debug("send ack for mp_prio");
-		__mptcp_subflow_send_ack(ssk);
-		unlock_sock_fast(ssk, slow);
-
+		__mptcp_pm_send_ack(msk, subflow, true, bkup);
 		return 0;
 	}
 
diff --git a/net/mptcp/protocol.c b/net/mptcp/protocol.c
index 2caad4a3adea..6cf5fa191b12 100644
--- a/net/mptcp/protocol.c
+++ b/net/mptcp/protocol.c
@@ -508,7 +508,7 @@ void __mptcp_subflow_send_ack(struct sock *ssk)
 		tcp_send_ack(ssk);
 }
 
-void mptcp_subflow_send_ack(struct sock *ssk)
+static void mptcp_subflow_send_ack(struct sock *ssk)
 {
 	bool slow;
 
diff --git a/net/mptcp/protocol.h b/net/mptcp/protocol.h
index 07871e10e510..e38b861263ce 100644
--- a/net/mptcp/protocol.h
+++ b/net/mptcp/protocol.h
@@ -607,7 +607,6 @@ void mptcp_subflow_shutdown(struct sock *sk, struct sock *ssk, int how);
 void mptcp_close_ssk(struct sock *sk, struct sock *ssk,
 		     struct mptcp_subflow_context *subflow);
 void __mptcp_subflow_send_ack(struct sock *ssk);
-void mptcp_subflow_send_ack(struct sock *ssk);
 void mptcp_subflow_reset(struct sock *ssk);
 void mptcp_subflow_queue_clean(struct sock *ssk);
 void mptcp_sock_graft(struct sock *sk, struct socket *parent);
-- 
2.37.0

