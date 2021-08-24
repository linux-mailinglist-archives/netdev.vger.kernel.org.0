Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id A62CD3F5558
	for <lists+netdev@lfdr.de>; Tue, 24 Aug 2021 03:06:07 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S235086AbhHXBGs (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 23 Aug 2021 21:06:48 -0400
Received: from mga18.intel.com ([134.134.136.126]:62120 "EHLO mga18.intel.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S234760AbhHXBGe (ORCPT <rfc822;netdev@vger.kernel.org>);
        Mon, 23 Aug 2021 21:06:34 -0400
X-IronPort-AV: E=McAfee;i="6200,9189,10085"; a="204346751"
X-IronPort-AV: E=Sophos;i="5.84,346,1620716400"; 
   d="scan'208";a="204346751"
Received: from fmsmga004.fm.intel.com ([10.253.24.48])
  by orsmga106.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 23 Aug 2021 18:05:50 -0700
X-IronPort-AV: E=Sophos;i="5.84,346,1620716400"; 
   d="scan'208";a="515224400"
Received: from mjmartin-desk2.amr.corp.intel.com (HELO mjmartin-desk2.intel.com) ([10.209.11.16])
  by fmsmga004-auth.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 23 Aug 2021 18:05:49 -0700
From:   Mat Martineau <mathew.j.martineau@linux.intel.com>
To:     netdev@vger.kernel.org
Cc:     Yonglong Li <liyonglong@chinatelecom.cn>, davem@davemloft.net,
        kuba@kernel.org, matthieu.baerts@tessares.net,
        mptcp@lists.linux.dev, Geliang Tang <geliangtang@gmail.com>,
        Mat Martineau <mathew.j.martineau@linux.intel.com>
Subject: [PATCH net-next 2/6] mptcp: make MPTCP_ADD_ADDR_SIGNAL and MPTCP_ADD_ADDR_ECHO separate
Date:   Mon, 23 Aug 2021 18:05:40 -0700
Message-Id: <20210824010544.68600-3-mathew.j.martineau@linux.intel.com>
X-Mailer: git-send-email 2.33.0
In-Reply-To: <20210824010544.68600-1-mathew.j.martineau@linux.intel.com>
References: <20210824010544.68600-1-mathew.j.martineau@linux.intel.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Yonglong Li <liyonglong@chinatelecom.cn>

Use MPTCP_ADD_ADDR_SIGNAL only for the action of sending ADD_ADDR, and
use MPTCP_ADD_ADDR_ECHO only for the action of sending ADD_ADDR echo.

Use msk->pm.local to save the announced ADD_ADDR address only, and reuse
msk->pm.remote to save the announced ADD_ADDR_ECHO address.

To prepare for the next patch.

Co-developed-by: Geliang Tang <geliangtang@gmail.com>
Signed-off-by: Geliang Tang <geliangtang@gmail.com>
Signed-off-by: Yonglong Li <liyonglong@chinatelecom.cn>
Signed-off-by: Mat Martineau <mathew.j.martineau@linux.intel.com>
---
 net/mptcp/pm.c         | 16 ++++++++++------
 net/mptcp/pm_netlink.c |  4 ++--
 net/mptcp/protocol.h   |  6 ++++++
 3 files changed, 18 insertions(+), 8 deletions(-)

diff --git a/net/mptcp/pm.c b/net/mptcp/pm.c
index 24e2f6f6178b..b1727cef1cfd 100644
--- a/net/mptcp/pm.c
+++ b/net/mptcp/pm.c
@@ -20,19 +20,23 @@ int mptcp_pm_announce_addr(struct mptcp_sock *msk,
 {
 	u8 add_addr = READ_ONCE(msk->pm.addr_signal);
 
-	pr_debug("msk=%p, local_id=%d", msk, addr->id);
+	pr_debug("msk=%p, local_id=%d, echo=%d", msk, addr->id, echo);
 
 	lockdep_assert_held(&msk->pm.lock);
 
-	if (add_addr) {
-		pr_warn("addr_signal error, add_addr=%d", add_addr);
+	if (add_addr &
+	    (echo ? BIT(MPTCP_ADD_ADDR_ECHO) : BIT(MPTCP_ADD_ADDR_SIGNAL))) {
+		pr_warn("addr_signal error, add_addr=%d, echo=%d", add_addr, echo);
 		return -EINVAL;
 	}
 
-	msk->pm.local = *addr;
-	add_addr |= BIT(MPTCP_ADD_ADDR_SIGNAL);
-	if (echo)
+	if (echo) {
+		msk->pm.remote = *addr;
 		add_addr |= BIT(MPTCP_ADD_ADDR_ECHO);
+	} else {
+		msk->pm.local = *addr;
+		add_addr |= BIT(MPTCP_ADD_ADDR_SIGNAL);
+	}
 	if (addr->family == AF_INET6)
 		add_addr |= BIT(MPTCP_ADD_ADDR_IPV6);
 	if (addr->port)
diff --git a/net/mptcp/pm_netlink.c b/net/mptcp/pm_netlink.c
index 480f43ec1bfb..d8dfd872a6dd 100644
--- a/net/mptcp/pm_netlink.c
+++ b/net/mptcp/pm_netlink.c
@@ -317,14 +317,14 @@ static void mptcp_pm_add_timer(struct timer_list *timer)
 	if (!entry->addr.id)
 		return;
 
-	if (mptcp_pm_should_add_signal(msk)) {
+	if (mptcp_pm_should_add_signal_addr(msk)) {
 		sk_reset_timer(sk, timer, jiffies + TCP_RTO_MAX / 8);
 		goto out;
 	}
 
 	spin_lock_bh(&msk->pm.lock);
 
-	if (!mptcp_pm_should_add_signal(msk)) {
+	if (!mptcp_pm_should_add_signal_addr(msk)) {
 		pr_debug("retransmit ADD_ADDR id=%d", entry->addr.id);
 		mptcp_pm_announce_addr(msk, &entry->addr, false);
 		mptcp_pm_add_addr_send_ack(msk);
diff --git a/net/mptcp/protocol.h b/net/mptcp/protocol.h
index 40bc9d31e1fa..3c388c1a9de4 100644
--- a/net/mptcp/protocol.h
+++ b/net/mptcp/protocol.h
@@ -747,6 +747,12 @@ void mptcp_event_addr_announced(const struct mptcp_sock *msk, const struct mptcp
 void mptcp_event_addr_removed(const struct mptcp_sock *msk, u8 id);
 
 static inline bool mptcp_pm_should_add_signal(struct mptcp_sock *msk)
+{
+	return READ_ONCE(msk->pm.addr_signal) &
+		(BIT(MPTCP_ADD_ADDR_SIGNAL) | BIT(MPTCP_ADD_ADDR_ECHO));
+}
+
+static inline bool mptcp_pm_should_add_signal_addr(struct mptcp_sock *msk)
 {
 	return READ_ONCE(msk->pm.addr_signal) & BIT(MPTCP_ADD_ADDR_SIGNAL);
 }
-- 
2.33.0

