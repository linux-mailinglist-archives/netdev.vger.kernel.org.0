Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 49CB52D4F2F
	for <lists+netdev@lfdr.de>; Thu, 10 Dec 2020 01:00:33 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1730095AbgLIX7S (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 9 Dec 2020 18:59:18 -0500
Received: from mga06.intel.com ([134.134.136.31]:19498 "EHLO mga06.intel.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1730016AbgLIX7Q (ORCPT <rfc822;netdev@vger.kernel.org>);
        Wed, 9 Dec 2020 18:59:16 -0500
IronPort-SDR: GMDqV3rTm+KzEV1CkFz2uh62tT4GbPaC8Pv6MIRzHBkZJwm84K3O3iz/BHNBkaMXZf0yFuz1jE
 fpyQO91wdODQ==
X-IronPort-AV: E=McAfee;i="6000,8403,9830"; a="235763099"
X-IronPort-AV: E=Sophos;i="5.78,407,1599548400"; 
   d="scan'208";a="235763099"
Received: from fmsmga008.fm.intel.com ([10.253.24.58])
  by orsmga104.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 09 Dec 2020 15:51:40 -0800
IronPort-SDR: vQxT+e5bvnRJFEvjyI+nbxSgM0hVHg7PIWQQ3ic0Q/l8os5J4cJ1RzemehfuSBj9NwibwmZF/i
 1Pr0MdcA+1cg==
X-IronPort-AV: E=Sophos;i="5.78,407,1599548400"; 
   d="scan'208";a="318582196"
Received: from mjmartin-nuc02.amr.corp.intel.com ([10.254.111.12])
  by fmsmga008-auth.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 09 Dec 2020 15:51:40 -0800
From:   Mat Martineau <mathew.j.martineau@linux.intel.com>
To:     netdev@vger.kernel.org
Cc:     Geliang Tang <geliangtang@gmail.com>, davem@davemloft.net,
        kuba@kernel.org, mptcp@lists.01.org,
        Mat Martineau <mathew.j.martineau@linux.intel.com>
Subject: [PATCH net-next 10/11] mptcp: rename add_addr_signal and mptcp_add_addr_status
Date:   Wed,  9 Dec 2020 15:51:27 -0800
Message-Id: <20201209235128.175473-11-mathew.j.martineau@linux.intel.com>
X-Mailer: git-send-email 2.29.2
In-Reply-To: <20201209235128.175473-1-mathew.j.martineau@linux.intel.com>
References: <20201209235128.175473-1-mathew.j.martineau@linux.intel.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Geliang Tang <geliangtang@gmail.com>

Since the RM_ADDR signal had been reused with add_addr_signal, it's not
suitable to call it add_addr_signal or mptcp_add_addr_status. So this
patch renamed add_addr_signal to addr_signal, and renamed
mptcp_add_addr_status to mptcp_addr_signal_status.

Signed-off-by: Geliang Tang <geliangtang@gmail.com>
Signed-off-by: Mat Martineau <mathew.j.martineau@linux.intel.com>
---
 net/mptcp/pm.c         | 14 +++++++-------
 net/mptcp/pm_netlink.c |  4 ++--
 net/mptcp/protocol.h   | 14 +++++++-------
 3 files changed, 16 insertions(+), 16 deletions(-)

diff --git a/net/mptcp/pm.c b/net/mptcp/pm.c
index b5a0b8d231c6..da2ed576f289 100644
--- a/net/mptcp/pm.c
+++ b/net/mptcp/pm.c
@@ -16,7 +16,7 @@ int mptcp_pm_announce_addr(struct mptcp_sock *msk,
 			   const struct mptcp_addr_info *addr,
 			   bool echo, bool port)
 {
-	u8 add_addr = READ_ONCE(msk->pm.add_addr_signal);
+	u8 add_addr = READ_ONCE(msk->pm.addr_signal);
 
 	pr_debug("msk=%p, local_id=%d", msk, addr->id);
 
@@ -33,13 +33,13 @@ int mptcp_pm_announce_addr(struct mptcp_sock *msk,
 		add_addr |= BIT(MPTCP_ADD_ADDR_IPV6);
 	if (port)
 		add_addr |= BIT(MPTCP_ADD_ADDR_PORT);
-	WRITE_ONCE(msk->pm.add_addr_signal, add_addr);
+	WRITE_ONCE(msk->pm.addr_signal, add_addr);
 	return 0;
 }
 
 int mptcp_pm_remove_addr(struct mptcp_sock *msk, u8 local_id)
 {
-	u8 rm_addr = READ_ONCE(msk->pm.add_addr_signal);
+	u8 rm_addr = READ_ONCE(msk->pm.addr_signal);
 
 	pr_debug("msk=%p, local_id=%d", msk, local_id);
 
@@ -50,7 +50,7 @@ int mptcp_pm_remove_addr(struct mptcp_sock *msk, u8 local_id)
 
 	msk->pm.rm_id = local_id;
 	rm_addr |= BIT(MPTCP_RM_ADDR_SIGNAL);
-	WRITE_ONCE(msk->pm.add_addr_signal, rm_addr);
+	WRITE_ONCE(msk->pm.addr_signal, rm_addr);
 	return 0;
 }
 
@@ -227,7 +227,7 @@ bool mptcp_pm_add_addr_signal(struct mptcp_sock *msk, unsigned int remaining,
 		goto out_unlock;
 
 	*saddr = msk->pm.local;
-	WRITE_ONCE(msk->pm.add_addr_signal, 0);
+	WRITE_ONCE(msk->pm.addr_signal, 0);
 	ret = true;
 
 out_unlock:
@@ -250,7 +250,7 @@ bool mptcp_pm_rm_addr_signal(struct mptcp_sock *msk, unsigned int remaining,
 		goto out_unlock;
 
 	*rm_id = msk->pm.rm_id;
-	WRITE_ONCE(msk->pm.add_addr_signal, 0);
+	WRITE_ONCE(msk->pm.addr_signal, 0);
 	ret = true;
 
 out_unlock:
@@ -271,7 +271,7 @@ void mptcp_pm_data_init(struct mptcp_sock *msk)
 	msk->pm.subflows = 0;
 	msk->pm.rm_id = 0;
 	WRITE_ONCE(msk->pm.work_pending, false);
-	WRITE_ONCE(msk->pm.add_addr_signal, 0);
+	WRITE_ONCE(msk->pm.addr_signal, 0);
 	WRITE_ONCE(msk->pm.accept_addr, false);
 	WRITE_ONCE(msk->pm.accept_subflow, false);
 	msk->pm.status = 0;
diff --git a/net/mptcp/pm_netlink.c b/net/mptcp/pm_netlink.c
index 2560c502356b..46da9f8c9cba 100644
--- a/net/mptcp/pm_netlink.c
+++ b/net/mptcp/pm_netlink.c
@@ -431,12 +431,12 @@ void mptcp_pm_nl_add_addr_send_ack(struct mptcp_sock *msk)
 		release_sock(ssk);
 		spin_lock_bh(&msk->pm.lock);
 
-		add_addr = READ_ONCE(msk->pm.add_addr_signal);
+		add_addr = READ_ONCE(msk->pm.addr_signal);
 		if (mptcp_pm_should_add_signal_ipv6(msk))
 			add_addr &= ~BIT(MPTCP_ADD_ADDR_IPV6);
 		if (mptcp_pm_should_add_signal_port(msk))
 			add_addr &= ~BIT(MPTCP_ADD_ADDR_PORT);
-		WRITE_ONCE(msk->pm.add_addr_signal, add_addr);
+		WRITE_ONCE(msk->pm.addr_signal, add_addr);
 	}
 }
 
diff --git a/net/mptcp/protocol.h b/net/mptcp/protocol.h
index 4dbb75b8ee33..f6c3c686a34a 100644
--- a/net/mptcp/protocol.h
+++ b/net/mptcp/protocol.h
@@ -169,7 +169,7 @@ enum mptcp_pm_status {
 	MPTCP_PM_SUBFLOW_ESTABLISHED,
 };
 
-enum mptcp_add_addr_status {
+enum mptcp_addr_signal_status {
 	MPTCP_ADD_ADDR_SIGNAL,
 	MPTCP_ADD_ADDR_ECHO,
 	MPTCP_ADD_ADDR_IPV6,
@@ -184,7 +184,7 @@ struct mptcp_pm_data {
 
 	spinlock_t	lock;		/*protects the whole PM data */
 
-	u8		add_addr_signal;
+	u8		addr_signal;
 	bool		server_side;
 	bool		work_pending;
 	bool		accept_addr;
@@ -559,27 +559,27 @@ int mptcp_pm_remove_subflow(struct mptcp_sock *msk, u8 local_id);
 
 static inline bool mptcp_pm_should_add_signal(struct mptcp_sock *msk)
 {
-	return READ_ONCE(msk->pm.add_addr_signal) & BIT(MPTCP_ADD_ADDR_SIGNAL);
+	return READ_ONCE(msk->pm.addr_signal) & BIT(MPTCP_ADD_ADDR_SIGNAL);
 }
 
 static inline bool mptcp_pm_should_add_signal_echo(struct mptcp_sock *msk)
 {
-	return READ_ONCE(msk->pm.add_addr_signal) & BIT(MPTCP_ADD_ADDR_ECHO);
+	return READ_ONCE(msk->pm.addr_signal) & BIT(MPTCP_ADD_ADDR_ECHO);
 }
 
 static inline bool mptcp_pm_should_add_signal_ipv6(struct mptcp_sock *msk)
 {
-	return READ_ONCE(msk->pm.add_addr_signal) & BIT(MPTCP_ADD_ADDR_IPV6);
+	return READ_ONCE(msk->pm.addr_signal) & BIT(MPTCP_ADD_ADDR_IPV6);
 }
 
 static inline bool mptcp_pm_should_add_signal_port(struct mptcp_sock *msk)
 {
-	return READ_ONCE(msk->pm.add_addr_signal) & BIT(MPTCP_ADD_ADDR_PORT);
+	return READ_ONCE(msk->pm.addr_signal) & BIT(MPTCP_ADD_ADDR_PORT);
 }
 
 static inline bool mptcp_pm_should_rm_signal(struct mptcp_sock *msk)
 {
-	return READ_ONCE(msk->pm.add_addr_signal) & BIT(MPTCP_RM_ADDR_SIGNAL);
+	return READ_ONCE(msk->pm.addr_signal) & BIT(MPTCP_RM_ADDR_SIGNAL);
 }
 
 static inline unsigned int mptcp_add_addr_len(int family, bool echo, bool port)
-- 
2.29.2

