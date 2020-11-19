Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 0DB1A2B9BAB
	for <lists+netdev@lfdr.de>; Thu, 19 Nov 2020 20:49:57 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727900AbgKSTqL (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 19 Nov 2020 14:46:11 -0500
Received: from mga03.intel.com ([134.134.136.65]:56904 "EHLO mga03.intel.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1727066AbgKSTqK (ORCPT <rfc822;netdev@vger.kernel.org>);
        Thu, 19 Nov 2020 14:46:10 -0500
IronPort-SDR: QAQnKWLD5rOhA8N8ktN/Cv5YTnovh/190QOU388iMgVCn15/2mvHaC439GHH7nDZ50POi57cu/
 w9KZPbrEJV5Q==
X-IronPort-AV: E=McAfee;i="6000,8403,9810"; a="171451133"
X-IronPort-AV: E=Sophos;i="5.78,354,1599548400"; 
   d="scan'208";a="171451133"
X-Amp-Result: SKIPPED(no attachment in message)
X-Amp-File-Uploaded: False
Received: from orsmga004.jf.intel.com ([10.7.209.38])
  by orsmga103.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 19 Nov 2020 11:46:09 -0800
IronPort-SDR: ZCI2TO1Sh7a+CSPPgUkV+61DYFx2bJKlmnRFusAXp6fjnbs1qqGkRkSI6J5BAMnZHEuv5p1Yen
 g79HDq2Qd8DQ==
X-IronPort-AV: E=Sophos;i="5.78,354,1599548400"; 
   d="scan'208";a="476940484"
Received: from mjmartin-nuc02.amr.corp.intel.com ([10.255.229.232])
  by orsmga004-auth.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 19 Nov 2020 11:46:09 -0800
From:   Mat Martineau <mathew.j.martineau@linux.intel.com>
To:     netdev@vger.kernel.org
Cc:     Geliang Tang <geliangtang@gmail.com>, kuba@kernel.org,
        mptcp@lists.01.org, Paolo Abeni <pabeni@redhat.com>,
        Mat Martineau <mathew.j.martineau@linux.intel.com>
Subject: [PATCH net-next 06/10] mptcp: change add_addr_signal type
Date:   Thu, 19 Nov 2020 11:45:59 -0800
Message-Id: <20201119194603.103158-7-mathew.j.martineau@linux.intel.com>
X-Mailer: git-send-email 2.29.2
In-Reply-To: <20201119194603.103158-1-mathew.j.martineau@linux.intel.com>
References: <20201119194603.103158-1-mathew.j.martineau@linux.intel.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Geliang Tang <geliangtang@gmail.com>

This patch changed the 'add_addr_signal' type from bool to char, so that
we could encode the addr type there.

Suggested-by: Paolo Abeni <pabeni@redhat.com>
Acked-by: Paolo Abeni <pabeni@redhat.com>
Signed-off-by: Geliang Tang <geliangtang@gmail.com>
Signed-off-by: Mat Martineau <mathew.j.martineau@linux.intel.com>
---
 net/mptcp/pm.c       | 15 +++++++++------
 net/mptcp/protocol.h | 15 ++++++++++++---
 2 files changed, 21 insertions(+), 9 deletions(-)

diff --git a/net/mptcp/pm.c b/net/mptcp/pm.c
index f9c88e2abb8e..c2c12f02a263 100644
--- a/net/mptcp/pm.c
+++ b/net/mptcp/pm.c
@@ -16,11 +16,15 @@ int mptcp_pm_announce_addr(struct mptcp_sock *msk,
 			   const struct mptcp_addr_info *addr,
 			   bool echo)
 {
+	u8 add_addr = READ_ONCE(msk->pm.add_addr_signal);
+
 	pr_debug("msk=%p, local_id=%d", msk, addr->id);
 
 	msk->pm.local = *addr;
-	WRITE_ONCE(msk->pm.add_addr_echo, echo);
-	WRITE_ONCE(msk->pm.add_addr_signal, true);
+	add_addr |= BIT(MPTCP_ADD_ADDR_SIGNAL);
+	if (echo)
+		add_addr |= BIT(MPTCP_ADD_ADDR_ECHO);
+	WRITE_ONCE(msk->pm.add_addr_signal, add_addr);
 	return 0;
 }
 
@@ -182,13 +186,13 @@ bool mptcp_pm_add_addr_signal(struct mptcp_sock *msk, unsigned int remaining,
 	if (!mptcp_pm_should_add_signal(msk))
 		goto out_unlock;
 
-	*echo = READ_ONCE(msk->pm.add_addr_echo);
+	*echo = mptcp_pm_should_add_signal_echo(msk);
 
 	if (remaining < mptcp_add_addr_len(msk->pm.local.family, *echo))
 		goto out_unlock;
 
 	*saddr = msk->pm.local;
-	WRITE_ONCE(msk->pm.add_addr_signal, false);
+	WRITE_ONCE(msk->pm.add_addr_signal, 0);
 	ret = true;
 
 out_unlock:
@@ -232,11 +236,10 @@ void mptcp_pm_data_init(struct mptcp_sock *msk)
 	msk->pm.subflows = 0;
 	msk->pm.rm_id = 0;
 	WRITE_ONCE(msk->pm.work_pending, false);
-	WRITE_ONCE(msk->pm.add_addr_signal, false);
+	WRITE_ONCE(msk->pm.add_addr_signal, 0);
 	WRITE_ONCE(msk->pm.rm_addr_signal, false);
 	WRITE_ONCE(msk->pm.accept_addr, false);
 	WRITE_ONCE(msk->pm.accept_subflow, false);
-	WRITE_ONCE(msk->pm.add_addr_echo, false);
 	msk->pm.status = 0;
 
 	spin_lock_init(&msk->pm.lock);
diff --git a/net/mptcp/protocol.h b/net/mptcp/protocol.h
index 7affaf0b1941..a62ffae621c2 100644
--- a/net/mptcp/protocol.h
+++ b/net/mptcp/protocol.h
@@ -165,6 +165,11 @@ enum mptcp_pm_status {
 	MPTCP_PM_SUBFLOW_ESTABLISHED,
 };
 
+enum mptcp_add_addr_status {
+	MPTCP_ADD_ADDR_SIGNAL,
+	MPTCP_ADD_ADDR_ECHO,
+};
+
 struct mptcp_pm_data {
 	struct mptcp_addr_info local;
 	struct mptcp_addr_info remote;
@@ -172,13 +177,12 @@ struct mptcp_pm_data {
 
 	spinlock_t	lock;		/*protects the whole PM data */
 
-	bool		add_addr_signal;
+	u8		add_addr_signal;
 	bool		rm_addr_signal;
 	bool		server_side;
 	bool		work_pending;
 	bool		accept_addr;
 	bool		accept_subflow;
-	bool		add_addr_echo;
 	u8		add_addr_signaled;
 	u8		add_addr_accepted;
 	u8		local_addr_used;
@@ -516,7 +520,12 @@ int mptcp_pm_remove_subflow(struct mptcp_sock *msk, u8 local_id);
 
 static inline bool mptcp_pm_should_add_signal(struct mptcp_sock *msk)
 {
-	return READ_ONCE(msk->pm.add_addr_signal);
+	return READ_ONCE(msk->pm.add_addr_signal) & BIT(MPTCP_ADD_ADDR_SIGNAL);
+}
+
+static inline bool mptcp_pm_should_add_signal_echo(struct mptcp_sock *msk)
+{
+	return READ_ONCE(msk->pm.add_addr_signal) & BIT(MPTCP_ADD_ADDR_ECHO);
 }
 
 static inline bool mptcp_pm_should_rm_signal(struct mptcp_sock *msk)
-- 
2.29.2

