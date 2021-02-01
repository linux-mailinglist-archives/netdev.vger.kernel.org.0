Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id AEC6B30B32A
	for <lists+netdev@lfdr.de>; Tue,  2 Feb 2021 00:13:35 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230170AbhBAXMk (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 1 Feb 2021 18:12:40 -0500
Received: from mga12.intel.com ([192.55.52.136]:51849 "EHLO mga12.intel.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S229476AbhBAXMd (ORCPT <rfc822;netdev@vger.kernel.org>);
        Mon, 1 Feb 2021 18:12:33 -0500
IronPort-SDR: wInf7flxUEYqNQ1p9h9h3Wgfqi+nUJrQiCRQoBAqEPFMvPGeSauK5GAU286WzeNbEEAVizS/yV
 w+kbGOkFoQMg==
X-IronPort-AV: E=McAfee;i="6000,8403,9882"; a="159934336"
X-IronPort-AV: E=Sophos;i="5.79,393,1602572400"; 
   d="scan'208";a="159934336"
Received: from orsmga008.jf.intel.com ([10.7.209.65])
  by fmsmga106.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 01 Feb 2021 15:09:27 -0800
IronPort-SDR: XpX+CIqHpjA/ie1CdZctUfzhgOQlkhwmsZMxSed4lN92pcbw0NTANi0/4H+OEF0ZWMB/BigpKu
 P7hokJeoPN+A==
X-IronPort-AV: E=Sophos;i="5.79,393,1602572400"; 
   d="scan'208";a="391188463"
Received: from mjmartin-desk2.amr.corp.intel.com (HELO mjmartin-desk2.intel.com) ([10.251.7.131])
  by orsmga008-auth.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 01 Feb 2021 15:09:26 -0800
From:   Mat Martineau <mathew.j.martineau@linux.intel.com>
To:     netdev@vger.kernel.org
Cc:     Geliang Tang <geliangtang@gmail.com>, davem@davemloft.net,
        kuba@kernel.org, mptcp@lists.01.org,
        Matthieu Baerts <matthieu.baerts@tessares.net>,
        Mat Martineau <mathew.j.martineau@linux.intel.com>
Subject: [PATCH net-next v2 02/15] mptcp: drop *_max fields in mptcp_pm_data
Date:   Mon,  1 Feb 2021 15:09:07 -0800
Message-Id: <20210201230920.66027-3-mathew.j.martineau@linux.intel.com>
X-Mailer: git-send-email 2.30.0
In-Reply-To: <20210201230920.66027-1-mathew.j.martineau@linux.intel.com>
References: <20210201230920.66027-1-mathew.j.martineau@linux.intel.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Geliang Tang <geliangtang@gmail.com>

This patch drops the per-msk values add_addr_signal_max,
add_addr_accept_max, local_addr_max and subflows_max fields in struct
mptcp_pm_data, uses the pernet *_max values instead. And adds four new
helpers to get the pernet *_max values separately.

Co-developed-by: Matthieu Baerts <matthieu.baerts@tessares.net>
Signed-off-by: Matthieu Baerts <matthieu.baerts@tessares.net>
Signed-off-by: Geliang Tang <geliangtang@gmail.com>
Signed-off-by: Mat Martineau <mathew.j.martineau@linux.intel.com>
---
 net/mptcp/mptcp_diag.c |  6 +--
 net/mptcp/pm.c         |  9 +++--
 net/mptcp/pm_netlink.c | 90 ++++++++++++++++++++++++++++++------------
 net/mptcp/protocol.h   |  7 ++--
 4 files changed, 77 insertions(+), 35 deletions(-)

diff --git a/net/mptcp/mptcp_diag.c b/net/mptcp/mptcp_diag.c
index b70ae4ba3000..00ed742f48a4 100644
--- a/net/mptcp/mptcp_diag.c
+++ b/net/mptcp/mptcp_diag.c
@@ -128,10 +128,10 @@ static void mptcp_diag_get_info(struct sock *sk, struct inet_diag_msg *r,
 	info->mptcpi_subflows = READ_ONCE(msk->pm.subflows);
 	info->mptcpi_add_addr_signal = READ_ONCE(msk->pm.add_addr_signaled);
 	info->mptcpi_add_addr_accepted = READ_ONCE(msk->pm.add_addr_accepted);
-	info->mptcpi_subflows_max = READ_ONCE(msk->pm.subflows_max);
-	val = READ_ONCE(msk->pm.add_addr_signal_max);
+	info->mptcpi_subflows_max = mptcp_pm_get_subflows_max(msk);
+	val = mptcp_pm_get_add_addr_signal_max(msk);
 	info->mptcpi_add_addr_signal_max = val;
-	val = READ_ONCE(msk->pm.add_addr_accept_max);
+	val = mptcp_pm_get_add_addr_accept_max(msk);
 	info->mptcpi_add_addr_accepted_max = val;
 	if (test_bit(MPTCP_FALLBACK_DONE, &msk->flags))
 		flags |= MPTCP_INFO_FLAG_FALLBACK;
diff --git a/net/mptcp/pm.c b/net/mptcp/pm.c
index 0a6ebd0642ec..01a846b25771 100644
--- a/net/mptcp/pm.c
+++ b/net/mptcp/pm.c
@@ -78,10 +78,13 @@ void mptcp_pm_new_connection(struct mptcp_sock *msk, int server_side)
 bool mptcp_pm_allow_new_subflow(struct mptcp_sock *msk)
 {
 	struct mptcp_pm_data *pm = &msk->pm;
+	unsigned int subflows_max;
 	int ret = 0;
 
+	subflows_max = mptcp_pm_get_subflows_max(msk);
+
 	pr_debug("msk=%p subflows=%d max=%d allow=%d", msk, pm->subflows,
-		 pm->subflows_max, READ_ONCE(pm->accept_subflow));
+		 subflows_max, READ_ONCE(pm->accept_subflow));
 
 	/* try to avoid acquiring the lock below */
 	if (!READ_ONCE(pm->accept_subflow))
@@ -89,8 +92,8 @@ bool mptcp_pm_allow_new_subflow(struct mptcp_sock *msk)
 
 	spin_lock_bh(&pm->lock);
 	if (READ_ONCE(pm->accept_subflow)) {
-		ret = pm->subflows < pm->subflows_max;
-		if (ret && ++pm->subflows == pm->subflows_max)
+		ret = pm->subflows < subflows_max;
+		if (ret && ++pm->subflows == subflows_max)
 			WRITE_ONCE(pm->accept_subflow, false);
 	}
 	spin_unlock_bh(&pm->lock);
diff --git a/net/mptcp/pm_netlink.c b/net/mptcp/pm_netlink.c
index c429bd82313e..6aeadcaef8ae 100644
--- a/net/mptcp/pm_netlink.c
+++ b/net/mptcp/pm_netlink.c
@@ -196,11 +196,46 @@ select_signal_address(struct pm_nl_pernet *pernet, unsigned int pos)
 	return ret;
 }
 
+unsigned int mptcp_pm_get_add_addr_signal_max(struct mptcp_sock *msk)
+{
+	struct pm_nl_pernet *pernet;
+
+	pernet = net_generic(sock_net((struct sock *)msk), pm_nl_pernet_id);
+	return READ_ONCE(pernet->add_addr_signal_max);
+}
+EXPORT_SYMBOL_GPL(mptcp_pm_get_add_addr_signal_max);
+
+unsigned int mptcp_pm_get_add_addr_accept_max(struct mptcp_sock *msk)
+{
+	struct pm_nl_pernet *pernet;
+
+	pernet = net_generic(sock_net((struct sock *)msk), pm_nl_pernet_id);
+	return READ_ONCE(pernet->add_addr_accept_max);
+}
+EXPORT_SYMBOL_GPL(mptcp_pm_get_add_addr_accept_max);
+
+unsigned int mptcp_pm_get_subflows_max(struct mptcp_sock *msk)
+{
+	struct pm_nl_pernet *pernet;
+
+	pernet = net_generic(sock_net((struct sock *)msk), pm_nl_pernet_id);
+	return READ_ONCE(pernet->subflows_max);
+}
+EXPORT_SYMBOL_GPL(mptcp_pm_get_subflows_max);
+
+static unsigned int mptcp_pm_get_local_addr_max(struct mptcp_sock *msk)
+{
+	struct pm_nl_pernet *pernet;
+
+	pernet = net_generic(sock_net((struct sock *)msk), pm_nl_pernet_id);
+	return READ_ONCE(pernet->local_addr_max);
+}
+
 static void check_work_pending(struct mptcp_sock *msk)
 {
-	if (msk->pm.add_addr_signaled == msk->pm.add_addr_signal_max &&
-	    (msk->pm.local_addr_used == msk->pm.local_addr_max ||
-	     msk->pm.subflows == msk->pm.subflows_max))
+	if (msk->pm.add_addr_signaled == mptcp_pm_get_add_addr_signal_max(msk) &&
+	    (msk->pm.local_addr_used == mptcp_pm_get_local_addr_max(msk) ||
+	     msk->pm.subflows == mptcp_pm_get_subflows_max(msk)))
 		WRITE_ONCE(msk->pm.work_pending, false);
 }
 
@@ -327,17 +362,24 @@ static void mptcp_pm_create_subflow_or_signal_addr(struct mptcp_sock *msk)
 {
 	struct sock *sk = (struct sock *)msk;
 	struct mptcp_pm_addr_entry *local;
+	unsigned int add_addr_signal_max;
+	unsigned int local_addr_max;
 	struct pm_nl_pernet *pernet;
+	unsigned int subflows_max;
 
 	pernet = net_generic(sock_net(sk), pm_nl_pernet_id);
 
+	add_addr_signal_max = mptcp_pm_get_add_addr_signal_max(msk);
+	local_addr_max = mptcp_pm_get_local_addr_max(msk);
+	subflows_max = mptcp_pm_get_subflows_max(msk);
+
 	pr_debug("local %d:%d signal %d:%d subflows %d:%d\n",
-		 msk->pm.local_addr_used, msk->pm.local_addr_max,
-		 msk->pm.add_addr_signaled, msk->pm.add_addr_signal_max,
-		 msk->pm.subflows, msk->pm.subflows_max);
+		 msk->pm.local_addr_used, local_addr_max,
+		 msk->pm.add_addr_signaled, add_addr_signal_max,
+		 msk->pm.subflows, subflows_max);
 
 	/* check first for announce */
-	if (msk->pm.add_addr_signaled < msk->pm.add_addr_signal_max) {
+	if (msk->pm.add_addr_signaled < add_addr_signal_max) {
 		local = select_signal_address(pernet,
 					      msk->pm.add_addr_signaled);
 
@@ -349,15 +391,15 @@ static void mptcp_pm_create_subflow_or_signal_addr(struct mptcp_sock *msk)
 			}
 		} else {
 			/* pick failed, avoid fourther attempts later */
-			msk->pm.local_addr_used = msk->pm.add_addr_signal_max;
+			msk->pm.local_addr_used = add_addr_signal_max;
 		}
 
 		check_work_pending(msk);
 	}
 
 	/* check if should create a new subflow */
-	if (msk->pm.local_addr_used < msk->pm.local_addr_max &&
-	    msk->pm.subflows < msk->pm.subflows_max) {
+	if (msk->pm.local_addr_used < local_addr_max &&
+	    msk->pm.subflows < subflows_max) {
 		local = select_local_address(pernet, msk);
 		if (local) {
 			struct mptcp_addr_info remote = { 0 };
@@ -373,7 +415,7 @@ static void mptcp_pm_create_subflow_or_signal_addr(struct mptcp_sock *msk)
 		}
 
 		/* lookup failed, avoid fourther attempts later */
-		msk->pm.local_addr_used = msk->pm.local_addr_max;
+		msk->pm.local_addr_used = local_addr_max;
 		check_work_pending(msk);
 	}
 }
@@ -391,17 +433,22 @@ void mptcp_pm_nl_subflow_established(struct mptcp_sock *msk)
 void mptcp_pm_nl_add_addr_received(struct mptcp_sock *msk)
 {
 	struct sock *sk = (struct sock *)msk;
+	unsigned int add_addr_accept_max;
 	struct mptcp_addr_info remote;
 	struct mptcp_addr_info local;
+	unsigned int subflows_max;
 	bool use_port = false;
 
+	add_addr_accept_max = mptcp_pm_get_add_addr_accept_max(msk);
+	subflows_max = mptcp_pm_get_subflows_max(msk);
+
 	pr_debug("accepted %d:%d remote family %d",
-		 msk->pm.add_addr_accepted, msk->pm.add_addr_accept_max,
+		 msk->pm.add_addr_accepted, add_addr_accept_max,
 		 msk->pm.remote.family);
 	msk->pm.add_addr_accepted++;
 	msk->pm.subflows++;
-	if (msk->pm.add_addr_accepted >= msk->pm.add_addr_accept_max ||
-	    msk->pm.subflows >= msk->pm.subflows_max)
+	if (msk->pm.add_addr_accepted >= add_addr_accept_max ||
+	    msk->pm.subflows >= subflows_max)
 		WRITE_ONCE(msk->pm.accept_addr, false);
 
 	/* connect to the specified remote address, using whatever
@@ -687,19 +734,12 @@ int mptcp_pm_nl_get_local_id(struct mptcp_sock *msk, struct sock_common *skc)
 void mptcp_pm_nl_data_init(struct mptcp_sock *msk)
 {
 	struct mptcp_pm_data *pm = &msk->pm;
-	struct pm_nl_pernet *pernet;
 	bool subflows;
 
-	pernet = net_generic(sock_net((struct sock *)msk), pm_nl_pernet_id);
-
-	pm->add_addr_signal_max = READ_ONCE(pernet->add_addr_signal_max);
-	pm->add_addr_accept_max = READ_ONCE(pernet->add_addr_accept_max);
-	pm->local_addr_max = READ_ONCE(pernet->local_addr_max);
-	pm->subflows_max = READ_ONCE(pernet->subflows_max);
-	subflows = !!pm->subflows_max;
-	WRITE_ONCE(pm->work_pending, (!!pm->local_addr_max && subflows) ||
-		   !!pm->add_addr_signal_max);
-	WRITE_ONCE(pm->accept_addr, !!pm->add_addr_accept_max && subflows);
+	subflows = !!mptcp_pm_get_subflows_max(msk);
+	WRITE_ONCE(pm->work_pending, (!!mptcp_pm_get_local_addr_max(msk) && subflows) ||
+		   !!mptcp_pm_get_add_addr_signal_max(msk));
+	WRITE_ONCE(pm->accept_addr, !!mptcp_pm_get_add_addr_accept_max(msk) && subflows);
 	WRITE_ONCE(pm->accept_subflow, subflows);
 }
 
diff --git a/net/mptcp/protocol.h b/net/mptcp/protocol.h
index 1460705aaad0..fcab3784e4fa 100644
--- a/net/mptcp/protocol.h
+++ b/net/mptcp/protocol.h
@@ -202,10 +202,6 @@ struct mptcp_pm_data {
 	u8		add_addr_accepted;
 	u8		local_addr_used;
 	u8		subflows;
-	u8		add_addr_signal_max;
-	u8		add_addr_accept_max;
-	u8		local_addr_max;
-	u8		subflows_max;
 	u8		status;
 	u8		rm_id;
 };
@@ -713,6 +709,9 @@ void mptcp_pm_nl_add_addr_send_ack(struct mptcp_sock *msk);
 void mptcp_pm_nl_rm_addr_received(struct mptcp_sock *msk);
 void mptcp_pm_nl_rm_subflow_received(struct mptcp_sock *msk, u8 rm_id);
 int mptcp_pm_nl_get_local_id(struct mptcp_sock *msk, struct sock_common *skc);
+unsigned int mptcp_pm_get_add_addr_signal_max(struct mptcp_sock *msk);
+unsigned int mptcp_pm_get_add_addr_accept_max(struct mptcp_sock *msk);
+unsigned int mptcp_pm_get_subflows_max(struct mptcp_sock *msk);
 
 static inline struct mptcp_ext *mptcp_get_ext(struct sk_buff *skb)
 {
-- 
2.30.0

