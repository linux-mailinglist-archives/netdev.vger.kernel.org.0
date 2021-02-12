Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id F262A31A884
	for <lists+netdev@lfdr.de>; Sat, 13 Feb 2021 01:02:17 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229980AbhBMACB (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 12 Feb 2021 19:02:01 -0500
Received: from mga06.intel.com ([134.134.136.31]:22720 "EHLO mga06.intel.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S229602AbhBMAB7 (ORCPT <rfc822;netdev@vger.kernel.org>);
        Fri, 12 Feb 2021 19:01:59 -0500
IronPort-SDR: L7qMU02Fp7i6CKKkArOl2CzYnrbYZn3oHKC+PaQmXgj/Lpw/GLkI3FNENUCvFihs6yYYzkZFTJ
 QdMae0yupx5A==
X-IronPort-AV: E=McAfee;i="6000,8403,9893"; a="243981687"
X-IronPort-AV: E=Sophos;i="5.81,175,1610438400"; 
   d="scan'208";a="243981687"
Received: from fmsmga002.fm.intel.com ([10.253.24.26])
  by orsmga104.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 12 Feb 2021 16:00:11 -0800
IronPort-SDR: +JUeLpeM3LwatkY/GbQirtl1JXfEPh4XbfWr7Sog1nDlolXd2CbPclSiDINCokfkFrwhakgUz3
 vPlzvL7YDBfQ==
X-IronPort-AV: E=Sophos;i="5.81,175,1610438400"; 
   d="scan'208";a="423381115"
Received: from mjmartin-desk2.amr.corp.intel.com (HELO mjmartin-desk2.intel.com) ([10.254.85.171])
  by fmsmga002-auth.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 12 Feb 2021 16:00:11 -0800
From:   Mat Martineau <mathew.j.martineau@linux.intel.com>
To:     netdev@vger.kernel.org
Cc:     Florian Westphal <fw@strlen.de>, davem@davemloft.net,
        kuba@kernel.org, mptcp@lists.01.org, matthieu.baerts@tessares.net,
        Mat Martineau <mathew.j.martineau@linux.intel.com>
Subject: [PATCH net-next 1/8] mptcp: move pm netlink work into pm_netlink
Date:   Fri, 12 Feb 2021 15:59:54 -0800
Message-Id: <20210213000001.379332-2-mathew.j.martineau@linux.intel.com>
X-Mailer: git-send-email 2.30.1
In-Reply-To: <20210213000001.379332-1-mathew.j.martineau@linux.intel.com>
References: <20210213000001.379332-1-mathew.j.martineau@linux.intel.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Florian Westphal <fw@strlen.de>

Allows to make some functions static and avoids acquire of the pm
spinlock in protocol.c.

Signed-off-by: Florian Westphal <fw@strlen.de>
Signed-off-by: Mat Martineau <mathew.j.martineau@linux.intel.com>
---
 net/mptcp/pm_netlink.c | 45 +++++++++++++++++++++++++++++++++++++-----
 net/mptcp/protocol.c   | 33 +------------------------------
 net/mptcp/protocol.h   |  6 +-----
 3 files changed, 42 insertions(+), 42 deletions(-)

diff --git a/net/mptcp/pm_netlink.c b/net/mptcp/pm_netlink.c
index 23780a13b934..8f2fd6874d85 100644
--- a/net/mptcp/pm_netlink.c
+++ b/net/mptcp/pm_netlink.c
@@ -56,6 +56,8 @@ struct pm_nl_pernet {
 #define MPTCP_PM_ADDR_MAX	8
 #define ADD_ADDR_RETRANS_MAX	3
 
+static void mptcp_pm_nl_add_addr_send_ack(struct mptcp_sock *msk);
+
 static bool addresses_equal(const struct mptcp_addr_info *a,
 			    struct mptcp_addr_info *b, bool use_port)
 {
@@ -448,17 +450,17 @@ static void mptcp_pm_create_subflow_or_signal_addr(struct mptcp_sock *msk)
 	}
 }
 
-void mptcp_pm_nl_fully_established(struct mptcp_sock *msk)
+static void mptcp_pm_nl_fully_established(struct mptcp_sock *msk)
 {
 	mptcp_pm_create_subflow_or_signal_addr(msk);
 }
 
-void mptcp_pm_nl_subflow_established(struct mptcp_sock *msk)
+static void mptcp_pm_nl_subflow_established(struct mptcp_sock *msk)
 {
 	mptcp_pm_create_subflow_or_signal_addr(msk);
 }
 
-void mptcp_pm_nl_add_addr_received(struct mptcp_sock *msk)
+static void mptcp_pm_nl_add_addr_received(struct mptcp_sock *msk)
 {
 	struct sock *sk = (struct sock *)msk;
 	unsigned int add_addr_accept_max;
@@ -498,7 +500,7 @@ void mptcp_pm_nl_add_addr_received(struct mptcp_sock *msk)
 	mptcp_pm_nl_add_addr_send_ack(msk);
 }
 
-void mptcp_pm_nl_add_addr_send_ack(struct mptcp_sock *msk)
+static void mptcp_pm_nl_add_addr_send_ack(struct mptcp_sock *msk)
 {
 	struct mptcp_subflow_context *subflow;
 
@@ -568,7 +570,7 @@ int mptcp_pm_nl_mp_prio_send_ack(struct mptcp_sock *msk,
 	return -EINVAL;
 }
 
-void mptcp_pm_nl_rm_addr_received(struct mptcp_sock *msk)
+static void mptcp_pm_nl_rm_addr_received(struct mptcp_sock *msk)
 {
 	struct mptcp_subflow_context *subflow, *tmp;
 	struct sock *sk = (struct sock *)msk;
@@ -605,6 +607,39 @@ void mptcp_pm_nl_rm_addr_received(struct mptcp_sock *msk)
 	}
 }
 
+void mptcp_pm_nl_work(struct mptcp_sock *msk)
+{
+	struct mptcp_pm_data *pm = &msk->pm;
+
+	msk_owned_by_me(msk);
+
+	spin_lock_bh(&msk->pm.lock);
+
+	pr_debug("msk=%p status=%x", msk, pm->status);
+	if (pm->status & BIT(MPTCP_PM_ADD_ADDR_RECEIVED)) {
+		pm->status &= ~BIT(MPTCP_PM_ADD_ADDR_RECEIVED);
+		mptcp_pm_nl_add_addr_received(msk);
+	}
+	if (pm->status & BIT(MPTCP_PM_ADD_ADDR_SEND_ACK)) {
+		pm->status &= ~BIT(MPTCP_PM_ADD_ADDR_SEND_ACK);
+		mptcp_pm_nl_add_addr_send_ack(msk);
+	}
+	if (pm->status & BIT(MPTCP_PM_RM_ADDR_RECEIVED)) {
+		pm->status &= ~BIT(MPTCP_PM_RM_ADDR_RECEIVED);
+		mptcp_pm_nl_rm_addr_received(msk);
+	}
+	if (pm->status & BIT(MPTCP_PM_ESTABLISHED)) {
+		pm->status &= ~BIT(MPTCP_PM_ESTABLISHED);
+		mptcp_pm_nl_fully_established(msk);
+	}
+	if (pm->status & BIT(MPTCP_PM_SUBFLOW_ESTABLISHED)) {
+		pm->status &= ~BIT(MPTCP_PM_SUBFLOW_ESTABLISHED);
+		mptcp_pm_nl_subflow_established(msk);
+	}
+
+	spin_unlock_bh(&msk->pm.lock);
+}
+
 void mptcp_pm_nl_rm_subflow_received(struct mptcp_sock *msk, u8 rm_id)
 {
 	struct mptcp_subflow_context *subflow, *tmp;
diff --git a/net/mptcp/protocol.c b/net/mptcp/protocol.c
index b9f16a1535d2..93134b72490a 100644
--- a/net/mptcp/protocol.c
+++ b/net/mptcp/protocol.c
@@ -2152,37 +2152,6 @@ static unsigned int mptcp_sync_mss(struct sock *sk, u32 pmtu)
 	return 0;
 }
 
-static void pm_work(struct mptcp_sock *msk)
-{
-	struct mptcp_pm_data *pm = &msk->pm;
-
-	spin_lock_bh(&msk->pm.lock);
-
-	pr_debug("msk=%p status=%x", msk, pm->status);
-	if (pm->status & BIT(MPTCP_PM_ADD_ADDR_RECEIVED)) {
-		pm->status &= ~BIT(MPTCP_PM_ADD_ADDR_RECEIVED);
-		mptcp_pm_nl_add_addr_received(msk);
-	}
-	if (pm->status & BIT(MPTCP_PM_ADD_ADDR_SEND_ACK)) {
-		pm->status &= ~BIT(MPTCP_PM_ADD_ADDR_SEND_ACK);
-		mptcp_pm_nl_add_addr_send_ack(msk);
-	}
-	if (pm->status & BIT(MPTCP_PM_RM_ADDR_RECEIVED)) {
-		pm->status &= ~BIT(MPTCP_PM_RM_ADDR_RECEIVED);
-		mptcp_pm_nl_rm_addr_received(msk);
-	}
-	if (pm->status & BIT(MPTCP_PM_ESTABLISHED)) {
-		pm->status &= ~BIT(MPTCP_PM_ESTABLISHED);
-		mptcp_pm_nl_fully_established(msk);
-	}
-	if (pm->status & BIT(MPTCP_PM_SUBFLOW_ESTABLISHED)) {
-		pm->status &= ~BIT(MPTCP_PM_SUBFLOW_ESTABLISHED);
-		mptcp_pm_nl_subflow_established(msk);
-	}
-
-	spin_unlock_bh(&msk->pm.lock);
-}
-
 static void __mptcp_close_subflow(struct mptcp_sock *msk)
 {
 	struct mptcp_subflow_context *subflow, *tmp;
@@ -2271,7 +2240,7 @@ static void mptcp_worker(struct work_struct *work)
 		__mptcp_close_subflow(msk);
 
 	if (msk->pm.status)
-		pm_work(msk);
+		mptcp_pm_nl_work(msk);
 
 	if (test_and_clear_bit(MPTCP_WORK_EOF, &msk->flags))
 		mptcp_check_for_eof(msk);
diff --git a/net/mptcp/protocol.h b/net/mptcp/protocol.h
index 73a923d02aad..702dbfefa093 100644
--- a/net/mptcp/protocol.h
+++ b/net/mptcp/protocol.h
@@ -713,11 +713,7 @@ int mptcp_pm_get_local_id(struct mptcp_sock *msk, struct sock_common *skc);
 
 void __init mptcp_pm_nl_init(void);
 void mptcp_pm_nl_data_init(struct mptcp_sock *msk);
-void mptcp_pm_nl_fully_established(struct mptcp_sock *msk);
-void mptcp_pm_nl_subflow_established(struct mptcp_sock *msk);
-void mptcp_pm_nl_add_addr_received(struct mptcp_sock *msk);
-void mptcp_pm_nl_add_addr_send_ack(struct mptcp_sock *msk);
-void mptcp_pm_nl_rm_addr_received(struct mptcp_sock *msk);
+void mptcp_pm_nl_work(struct mptcp_sock *msk);
 void mptcp_pm_nl_rm_subflow_received(struct mptcp_sock *msk, u8 rm_id);
 int mptcp_pm_nl_get_local_id(struct mptcp_sock *msk, struct sock_common *skc);
 unsigned int mptcp_pm_get_add_addr_signal_max(struct mptcp_sock *msk);
-- 
2.30.1

