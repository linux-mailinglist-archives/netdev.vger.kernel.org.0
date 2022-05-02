Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id BB5C051789D
	for <lists+netdev@lfdr.de>; Mon,  2 May 2022 22:52:52 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1387516AbiEBU4P (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 2 May 2022 16:56:15 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:43214 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1384178AbiEBU4O (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 2 May 2022 16:56:14 -0400
Received: from mga05.intel.com (mga05.intel.com [192.55.52.43])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 8071D6574
        for <netdev@vger.kernel.org>; Mon,  2 May 2022 13:52:44 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1651524764; x=1683060764;
  h=from:to:cc:subject:date:message-id:in-reply-to:
   references:mime-version:content-transfer-encoding;
  bh=Tl84NCpOr253pS4c/uwm4WkevvE9XpfGA0+EjXDUaKM=;
  b=Va+goW4ViKenBz8KeZ/B1P2RqtFlWdliKN0M0itLWjvSvTHnQzHoK6oC
   NX50WFuvYqDHbx7xSwq1ioVdVdmx24/AJLfY/a+zvEBorsAn1vEEPZ68+
   55sVuZ4xF/uwaM6Gs1SILB4kMjQwNBUjoEb2jIWI0MZROiFMQ4BcSfJQd
   TPt4Lfb1GZf2eDml6XbyOxrQ1JzqW5zdggMHbKj2prbUQtyTGGQKpS+c9
   SALeVMlU4MpT25ycqp1yJ27x8or4yFhK5XxuNlvJmyVuKJdc15Bft0thT
   zd8AfSyQY1Irg3qG35dHiNVy/OoDlBtlL+IX3hK/FJAnoqR8QpDiX6Mbw
   A==;
X-IronPort-AV: E=McAfee;i="6400,9594,10335"; a="353761111"
X-IronPort-AV: E=Sophos;i="5.91,193,1647327600"; 
   d="scan'208";a="353761111"
Received: from orsmga005.jf.intel.com ([10.7.209.41])
  by fmsmga105.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 02 May 2022 13:52:43 -0700
X-IronPort-AV: E=Sophos;i="5.91,193,1647327600"; 
   d="scan'208";a="733619568"
Received: from mjmartin-desk2.amr.corp.intel.com (HELO mjmartin-desk2.intel.com) ([10.212.141.55])
  by orsmga005-auth.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 02 May 2022 13:52:43 -0700
From:   Mat Martineau <mathew.j.martineau@linux.intel.com>
To:     netdev@vger.kernel.org
Cc:     Kishen Maloor <kishen.maloor@intel.com>, davem@davemloft.net,
        kuba@kernel.org, pabeni@redhat.com, matthieu.baerts@tessares.net,
        mptcp@lists.linux.dev,
        Mat Martineau <mathew.j.martineau@linux.intel.com>
Subject: [PATCH net-next 1/7] mptcp: bypass in-kernel PM restrictions for non-kernel PMs
Date:   Mon,  2 May 2022 13:52:31 -0700
Message-Id: <20220502205237.129297-2-mathew.j.martineau@linux.intel.com>
X-Mailer: git-send-email 2.36.0
In-Reply-To: <20220502205237.129297-1-mathew.j.martineau@linux.intel.com>
References: <20220502205237.129297-1-mathew.j.martineau@linux.intel.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-4.9 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_EF,RCVD_IN_DNSWL_MED,SPF_HELO_NONE,
        SPF_NONE,T_SCC_BODY_TEXT_LINE autolearn=ham autolearn_force=no
        version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Kishen Maloor <kishen.maloor@intel.com>

Current limits on the # of addresses/subflows must apply only to
in-kernel PM managed sockets. Thus this change removes such
restrictions on connections overseen by non-kernel (e.g. userspace)
PMs. This change also ensures that the kernel does not record stats
inside struct mptcp_pm_data updated along kernel code paths when exercised
via non-kernel PMs.

Additionally, address announcements are acknolwedged and subflow
requests are honored only when it's deemed that	a userspace path
manager	is active at the time.

Acked-by: Paolo Abeni <pabeni@redhat.com>
Signed-off-by: Kishen Maloor <kishen.maloor@intel.com>
Signed-off-by: Mat Martineau <mathew.j.martineau@linux.intel.com>
---
 net/mptcp/pm.c         | 15 +++++++++++++--
 net/mptcp/pm_netlink.c | 10 ++++++++++
 net/mptcp/protocol.h   |  6 ++++++
 net/mptcp/subflow.c    |  4 +++-
 4 files changed, 32 insertions(+), 3 deletions(-)

diff --git a/net/mptcp/pm.c b/net/mptcp/pm.c
index 57f67578a47f..8df9cb28d970 100644
--- a/net/mptcp/pm.c
+++ b/net/mptcp/pm.c
@@ -87,6 +87,9 @@ bool mptcp_pm_allow_new_subflow(struct mptcp_sock *msk)
 	unsigned int subflows_max;
 	int ret = 0;
 
+	if (mptcp_pm_is_userspace(msk))
+		return mptcp_userspace_pm_active(msk);
+
 	subflows_max = mptcp_pm_get_subflows_max(msk);
 
 	pr_debug("msk=%p subflows=%d max=%d allow=%d", msk, pm->subflows,
@@ -179,7 +182,8 @@ void mptcp_pm_subflow_check_next(struct mptcp_sock *msk, const struct sock *ssk,
 	bool update_subflows;
 
 	update_subflows = (ssk->sk_state == TCP_CLOSE) &&
-			  (subflow->request_join || subflow->mp_join);
+			  (subflow->request_join || subflow->mp_join) &&
+			  mptcp_pm_is_kernel(msk);
 	if (!READ_ONCE(pm->work_pending) && !update_subflows)
 		return;
 
@@ -208,7 +212,14 @@ void mptcp_pm_add_addr_received(struct mptcp_sock *msk,
 
 	spin_lock_bh(&pm->lock);
 
-	if (!READ_ONCE(pm->accept_addr) || mptcp_pm_is_userspace(msk)) {
+	if (mptcp_pm_is_userspace(msk)) {
+		if (mptcp_userspace_pm_active(msk)) {
+			mptcp_pm_announce_addr(msk, addr, true);
+			mptcp_pm_add_addr_send_ack(msk);
+		} else {
+			__MPTCP_INC_STATS(sock_net((struct sock *)msk), MPTCP_MIB_ADDADDRDROP);
+		}
+	} else if (!READ_ONCE(pm->accept_addr)) {
 		mptcp_pm_announce_addr(msk, addr, true);
 		mptcp_pm_add_addr_send_ack(msk);
 	} else if (mptcp_pm_schedule_work(msk, MPTCP_PM_ADD_ADDR_RECEIVED)) {
diff --git a/net/mptcp/pm_netlink.c b/net/mptcp/pm_netlink.c
index 473e5aa7baf4..d2b63529bfee 100644
--- a/net/mptcp/pm_netlink.c
+++ b/net/mptcp/pm_netlink.c
@@ -805,6 +805,9 @@ static void mptcp_pm_nl_rm_addr_or_subflow(struct mptcp_sock *msk,
 		if (!removed)
 			continue;
 
+		if (!mptcp_pm_is_kernel(msk))
+			continue;
+
 		if (rm_type == MPTCP_MIB_RMADDR) {
 			msk->pm.add_addr_accepted--;
 			WRITE_ONCE(msk->pm.accept_addr, true);
@@ -1855,6 +1858,13 @@ static void mptcp_nl_mcast_send(struct net *net, struct sk_buff *nlskb, gfp_t gf
 				nlskb, 0, MPTCP_PM_EV_GRP_OFFSET, gfp);
 }
 
+bool mptcp_userspace_pm_active(const struct mptcp_sock *msk)
+{
+	return genl_has_listeners(&mptcp_genl_family,
+				  sock_net((const struct sock *)msk),
+				  MPTCP_PM_EV_GRP_OFFSET);
+}
+
 static int mptcp_event_add_subflow(struct sk_buff *skb, const struct sock *ssk)
 {
 	const struct inet_sock *issk = inet_sk(ssk);
diff --git a/net/mptcp/protocol.h b/net/mptcp/protocol.h
index 54d2b3b2d100..85390146944d 100644
--- a/net/mptcp/protocol.h
+++ b/net/mptcp/protocol.h
@@ -784,6 +784,7 @@ void mptcp_event(enum mptcp_event_type type, const struct mptcp_sock *msk,
 		 const struct sock *ssk, gfp_t gfp);
 void mptcp_event_addr_announced(const struct mptcp_sock *msk, const struct mptcp_addr_info *info);
 void mptcp_event_addr_removed(const struct mptcp_sock *msk, u8 id);
+bool mptcp_userspace_pm_active(const struct mptcp_sock *msk);
 
 static inline bool mptcp_pm_should_add_signal(struct mptcp_sock *msk)
 {
@@ -811,6 +812,11 @@ static inline bool mptcp_pm_is_userspace(const struct mptcp_sock *msk)
 	return READ_ONCE(msk->pm.pm_type) == MPTCP_PM_TYPE_USERSPACE;
 }
 
+static inline bool mptcp_pm_is_kernel(const struct mptcp_sock *msk)
+{
+	return READ_ONCE(msk->pm.pm_type) == MPTCP_PM_TYPE_KERNEL;
+}
+
 static inline unsigned int mptcp_add_addr_len(int family, bool echo, bool port)
 {
 	u8 len = TCPOLEN_MPTCP_ADD_ADDR_BASE;
diff --git a/net/mptcp/subflow.c b/net/mptcp/subflow.c
index 75c824b67ca9..9567231a4bfa 100644
--- a/net/mptcp/subflow.c
+++ b/net/mptcp/subflow.c
@@ -62,7 +62,9 @@ static void subflow_generate_hmac(u64 key1, u64 key2, u32 nonce1, u32 nonce2,
 static bool mptcp_can_accept_new_subflow(const struct mptcp_sock *msk)
 {
 	return mptcp_is_fully_established((void *)msk) &&
-	       READ_ONCE(msk->pm.accept_subflow);
+		((mptcp_pm_is_userspace(msk) &&
+		  mptcp_userspace_pm_active(msk)) ||
+		 READ_ONCE(msk->pm.accept_subflow));
 }
 
 /* validate received token and create truncated hmac and nonce for SYN-ACK */
-- 
2.36.0

