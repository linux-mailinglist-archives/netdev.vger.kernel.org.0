Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 5D8AB34AE8B
	for <lists+netdev@lfdr.de>; Fri, 26 Mar 2021 19:28:28 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230254AbhCZS14 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 26 Mar 2021 14:27:56 -0400
Received: from mga05.intel.com ([192.55.52.43]:12659 "EHLO mga05.intel.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S230196AbhCZS1e (ORCPT <rfc822;netdev@vger.kernel.org>);
        Fri, 26 Mar 2021 14:27:34 -0400
IronPort-SDR: Qq6Caip8UN/Gxb5lyjhRcBC0aqoUaJ0KD7GYbf07j9qGueq6iU3e8eZEoW2084ROIQfVpq8BNq
 JOYkK/BnyQTQ==
X-IronPort-AV: E=McAfee;i="6000,8403,9935"; a="276342985"
X-IronPort-AV: E=Sophos;i="5.81,281,1610438400"; 
   d="scan'208";a="276342985"
Received: from fmsmga002.fm.intel.com ([10.253.24.26])
  by fmsmga105.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 26 Mar 2021 11:27:34 -0700
IronPort-SDR: kfgo00D5qr3yQ1b3CiuuEJ7zq/mOjaoiEjaw0ekAraQRCJcsXXwzf3ZpmTSSSByZpQJt5YjpsU
 G8pC8N767u5g==
X-IronPort-AV: E=Sophos;i="5.81,281,1610438400"; 
   d="scan'208";a="443456541"
Received: from mjmartin-desk2.amr.corp.intel.com (HELO mjmartin-desk2.intel.com) ([10.251.24.139])
  by fmsmga002-auth.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 26 Mar 2021 11:27:33 -0700
From:   Mat Martineau <mathew.j.martineau@linux.intel.com>
To:     netdev@vger.kernel.org
Cc:     Geliang Tang <geliangtang@gmail.com>, davem@davemloft.net,
        kuba@kernel.org, matthieu.baerts@tessares.net,
        mptcp@lists.linux.dev,
        Mat Martineau <mathew.j.martineau@linux.intel.com>
Subject: [PATCH net-next 02/13] mptcp: drop argument port from mptcp_pm_announce_addr
Date:   Fri, 26 Mar 2021 11:26:31 -0700
Message-Id: <20210326182642.136419-2-mathew.j.martineau@linux.intel.com>
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

Drop the redundant argument 'port' from mptcp_pm_announce_addr, use the
port field of another argument 'addr' instead.

Fixes: 0f5c9e3f079f ("mptcp: add port parameter for mptcp_pm_announce_addr")
Signed-off-by: Geliang Tang <geliangtang@gmail.com>
Signed-off-by: Mat Martineau <mathew.j.martineau@linux.intel.com>
---
 net/mptcp/pm.c         | 6 +++---
 net/mptcp/pm_netlink.c | 9 +++------
 net/mptcp/protocol.h   | 2 +-
 3 files changed, 7 insertions(+), 10 deletions(-)

diff --git a/net/mptcp/pm.c b/net/mptcp/pm.c
index 4cfd80f90003..51e60582b408 100644
--- a/net/mptcp/pm.c
+++ b/net/mptcp/pm.c
@@ -14,7 +14,7 @@
 
 int mptcp_pm_announce_addr(struct mptcp_sock *msk,
 			   const struct mptcp_addr_info *addr,
-			   bool echo, bool port)
+			   bool echo)
 {
 	u8 add_addr = READ_ONCE(msk->pm.addr_signal);
 
@@ -33,7 +33,7 @@ int mptcp_pm_announce_addr(struct mptcp_sock *msk,
 		add_addr |= BIT(MPTCP_ADD_ADDR_ECHO);
 	if (addr->family == AF_INET6)
 		add_addr |= BIT(MPTCP_ADD_ADDR_IPV6);
-	if (port)
+	if (addr->port)
 		add_addr |= BIT(MPTCP_ADD_ADDR_PORT);
 	WRITE_ONCE(msk->pm.addr_signal, add_addr);
 	return 0;
@@ -188,7 +188,7 @@ void mptcp_pm_add_addr_received(struct mptcp_sock *msk,
 	spin_lock_bh(&pm->lock);
 
 	if (!READ_ONCE(pm->accept_addr)) {
-		mptcp_pm_announce_addr(msk, addr, true, addr->port);
+		mptcp_pm_announce_addr(msk, addr, true);
 		mptcp_pm_add_addr_send_ack(msk);
 	} else if (mptcp_pm_schedule_work(msk, MPTCP_PM_ADD_ADDR_RECEIVED)) {
 		pm->remote = *addr;
diff --git a/net/mptcp/pm_netlink.c b/net/mptcp/pm_netlink.c
index 5857b82c88bf..53c09db08058 100644
--- a/net/mptcp/pm_netlink.c
+++ b/net/mptcp/pm_netlink.c
@@ -308,7 +308,7 @@ static void mptcp_pm_add_timer(struct timer_list *timer)
 
 	if (!mptcp_pm_should_add_signal(msk)) {
 		pr_debug("retransmit ADD_ADDR id=%d", entry->addr.id);
-		mptcp_pm_announce_addr(msk, &entry->addr, false, entry->addr.port);
+		mptcp_pm_announce_addr(msk, &entry->addr, false);
 		mptcp_pm_add_addr_send_ack(msk);
 		entry->retrans_times++;
 	}
@@ -417,7 +417,7 @@ static void mptcp_pm_create_subflow_or_signal_addr(struct mptcp_sock *msk)
 		if (local) {
 			if (mptcp_pm_alloc_anno_list(msk, local)) {
 				msk->pm.add_addr_signaled++;
-				mptcp_pm_announce_addr(msk, &local->addr, false, local->addr.port);
+				mptcp_pm_announce_addr(msk, &local->addr, false);
 				mptcp_pm_nl_add_addr_send_ack(msk);
 			}
 		} else {
@@ -468,7 +468,6 @@ static void mptcp_pm_nl_add_addr_received(struct mptcp_sock *msk)
 	struct mptcp_addr_info remote;
 	struct mptcp_addr_info local;
 	unsigned int subflows_max;
-	bool use_port = false;
 
 	add_addr_accept_max = mptcp_pm_get_add_addr_accept_max(msk);
 	subflows_max = mptcp_pm_get_subflows_max(msk);
@@ -488,8 +487,6 @@ static void mptcp_pm_nl_add_addr_received(struct mptcp_sock *msk)
 	remote = msk->pm.remote;
 	if (!remote.port)
 		remote.port = sk->sk_dport;
-	else
-		use_port = true;
 	memset(&local, 0, sizeof(local));
 	local.family = remote.family;
 
@@ -497,7 +494,7 @@ static void mptcp_pm_nl_add_addr_received(struct mptcp_sock *msk)
 	__mptcp_subflow_connect(sk, &local, &remote);
 	spin_lock_bh(&msk->pm.lock);
 
-	mptcp_pm_announce_addr(msk, &remote, true, use_port);
+	mptcp_pm_announce_addr(msk, &msk->pm.remote, true);
 	mptcp_pm_nl_add_addr_send_ack(msk);
 }
 
diff --git a/net/mptcp/protocol.h b/net/mptcp/protocol.h
index 0116308f5f69..2bcd6897ea7d 100644
--- a/net/mptcp/protocol.h
+++ b/net/mptcp/protocol.h
@@ -663,7 +663,7 @@ mptcp_pm_del_add_timer(struct mptcp_sock *msk,
 
 int mptcp_pm_announce_addr(struct mptcp_sock *msk,
 			   const struct mptcp_addr_info *addr,
-			   bool echo, bool port);
+			   bool echo);
 int mptcp_pm_remove_addr(struct mptcp_sock *msk, const struct mptcp_rm_list *rm_list);
 int mptcp_pm_remove_subflow(struct mptcp_sock *msk, const struct mptcp_rm_list *rm_list);
 
-- 
2.31.0

