Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id EC5712D4F2C
	for <lists+netdev@lfdr.de>; Thu, 10 Dec 2020 01:00:31 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726954AbgLIX6L (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 9 Dec 2020 18:58:11 -0500
Received: from mga06.intel.com ([134.134.136.31]:19498 "EHLO mga06.intel.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726335AbgLIX5u (ORCPT <rfc822;netdev@vger.kernel.org>);
        Wed, 9 Dec 2020 18:57:50 -0500
IronPort-SDR: l+gM+A8e80Am7yryUKsZf6kWdmTOj0//IssgjNAUeQR3wcc9q7KTmUH6QuXw0Th45hyXE6ISy2
 79fY2Ref5H9A==
X-IronPort-AV: E=McAfee;i="6000,8403,9830"; a="235763096"
X-IronPort-AV: E=Sophos;i="5.78,407,1599548400"; 
   d="scan'208";a="235763096"
Received: from fmsmga008.fm.intel.com ([10.253.24.58])
  by orsmga104.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 09 Dec 2020 15:51:39 -0800
IronPort-SDR: 4fgS/Nyz52FKNyQo0qx9NAenjzCkaDwYJYYeeffipDqHOLZJSjV4E+sNb06ayAVp+70ISEwM5Z
 lIUZywlJ/zPg==
X-IronPort-AV: E=Sophos;i="5.78,407,1599548400"; 
   d="scan'208";a="318582191"
Received: from mjmartin-nuc02.amr.corp.intel.com ([10.254.111.12])
  by fmsmga008-auth.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 09 Dec 2020 15:51:39 -0800
From:   Mat Martineau <mathew.j.martineau@linux.intel.com>
To:     netdev@vger.kernel.org
Cc:     Geliang Tang <geliangtang@gmail.com>, davem@davemloft.net,
        kuba@kernel.org, mptcp@lists.01.org,
        Mat Martineau <mathew.j.martineau@linux.intel.com>
Subject: [PATCH net-next 07/11] mptcp: add port parameter for mptcp_pm_announce_addr
Date:   Wed,  9 Dec 2020 15:51:24 -0800
Message-Id: <20201209235128.175473-8-mathew.j.martineau@linux.intel.com>
X-Mailer: git-send-email 2.29.2
In-Reply-To: <20201209235128.175473-1-mathew.j.martineau@linux.intel.com>
References: <20201209235128.175473-1-mathew.j.martineau@linux.intel.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Geliang Tang <geliangtang@gmail.com>

This patch added a new parameter 'port' for mptcp_pm_announce_addr. If
this parameter is true, we set the MPTCP_ADD_ADDR_PORT bit of the
add_addr_signal. That means the announced address is added with a port
number.

Signed-off-by: Geliang Tang <geliangtang@gmail.com>
Signed-off-by: Mat Martineau <mathew.j.martineau@linux.intel.com>
---
 net/mptcp/pm.c         | 6 ++++--
 net/mptcp/pm_netlink.c | 9 ++++++---
 net/mptcp/protocol.h   | 2 +-
 3 files changed, 11 insertions(+), 6 deletions(-)

diff --git a/net/mptcp/pm.c b/net/mptcp/pm.c
index d20637860851..ac590274b048 100644
--- a/net/mptcp/pm.c
+++ b/net/mptcp/pm.c
@@ -14,7 +14,7 @@
 
 int mptcp_pm_announce_addr(struct mptcp_sock *msk,
 			   const struct mptcp_addr_info *addr,
-			   bool echo)
+			   bool echo, bool port)
 {
 	u8 add_addr = READ_ONCE(msk->pm.add_addr_signal);
 
@@ -26,6 +26,8 @@ int mptcp_pm_announce_addr(struct mptcp_sock *msk,
 		add_addr |= BIT(MPTCP_ADD_ADDR_ECHO);
 	if (addr->family == AF_INET6)
 		add_addr |= BIT(MPTCP_ADD_ADDR_IPV6);
+	if (port)
+		add_addr |= BIT(MPTCP_ADD_ADDR_PORT);
 	WRITE_ONCE(msk->pm.add_addr_signal, add_addr);
 	return 0;
 }
@@ -162,7 +164,7 @@ void mptcp_pm_add_addr_received(struct mptcp_sock *msk,
 	spin_lock_bh(&pm->lock);
 
 	if (!READ_ONCE(pm->accept_addr)) {
-		mptcp_pm_announce_addr(msk, addr, true);
+		mptcp_pm_announce_addr(msk, addr, true, addr->port);
 		mptcp_pm_add_addr_send_ack(msk);
 	} else if (mptcp_pm_schedule_work(msk, MPTCP_PM_ADD_ADDR_RECEIVED)) {
 		pm->remote = *addr;
diff --git a/net/mptcp/pm_netlink.c b/net/mptcp/pm_netlink.c
index 7a0f700e34bb..2560c502356b 100644
--- a/net/mptcp/pm_netlink.c
+++ b/net/mptcp/pm_netlink.c
@@ -227,7 +227,7 @@ static void mptcp_pm_add_timer(struct timer_list *timer)
 
 	if (!mptcp_pm_should_add_signal(msk)) {
 		pr_debug("retransmit ADD_ADDR id=%d", entry->addr.id);
-		mptcp_pm_announce_addr(msk, &entry->addr, false);
+		mptcp_pm_announce_addr(msk, &entry->addr, false, entry->addr.port);
 		mptcp_pm_add_addr_send_ack(msk);
 		entry->retrans_times++;
 	}
@@ -328,7 +328,7 @@ static void mptcp_pm_create_subflow_or_signal_addr(struct mptcp_sock *msk)
 		if (local) {
 			if (mptcp_pm_alloc_anno_list(msk, local)) {
 				msk->pm.add_addr_signaled++;
-				mptcp_pm_announce_addr(msk, &local->addr, false);
+				mptcp_pm_announce_addr(msk, &local->addr, false, local->addr.port);
 				mptcp_pm_nl_add_addr_send_ack(msk);
 			}
 		} else {
@@ -376,6 +376,7 @@ void mptcp_pm_nl_add_addr_received(struct mptcp_sock *msk)
 	struct sock *sk = (struct sock *)msk;
 	struct mptcp_addr_info remote;
 	struct mptcp_addr_info local;
+	bool use_port = false;
 
 	pr_debug("accepted %d:%d remote family %d",
 		 msk->pm.add_addr_accepted, msk->pm.add_addr_accept_max,
@@ -392,6 +393,8 @@ void mptcp_pm_nl_add_addr_received(struct mptcp_sock *msk)
 	remote = msk->pm.remote;
 	if (!remote.port)
 		remote.port = sk->sk_dport;
+	else
+		use_port = true;
 	memset(&local, 0, sizeof(local));
 	local.family = remote.family;
 
@@ -399,7 +402,7 @@ void mptcp_pm_nl_add_addr_received(struct mptcp_sock *msk)
 	__mptcp_subflow_connect((struct sock *)msk, &local, &remote);
 	spin_lock_bh(&msk->pm.lock);
 
-	mptcp_pm_announce_addr(msk, &remote, true);
+	mptcp_pm_announce_addr(msk, &remote, true, use_port);
 	mptcp_pm_nl_add_addr_send_ack(msk);
 }
 
diff --git a/net/mptcp/protocol.h b/net/mptcp/protocol.h
index 8e8f1f770a8e..cda84b892182 100644
--- a/net/mptcp/protocol.h
+++ b/net/mptcp/protocol.h
@@ -553,7 +553,7 @@ mptcp_pm_del_add_timer(struct mptcp_sock *msk,
 
 int mptcp_pm_announce_addr(struct mptcp_sock *msk,
 			   const struct mptcp_addr_info *addr,
-			   bool echo);
+			   bool echo, bool port);
 int mptcp_pm_remove_addr(struct mptcp_sock *msk, u8 local_id);
 int mptcp_pm_remove_subflow(struct mptcp_sock *msk, u8 local_id);
 
-- 
2.29.2

