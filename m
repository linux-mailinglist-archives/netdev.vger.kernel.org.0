Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 07D9F34AE8D
	for <lists+netdev@lfdr.de>; Fri, 26 Mar 2021 19:28:29 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230292AbhCZS16 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 26 Mar 2021 14:27:58 -0400
Received: from mga05.intel.com ([192.55.52.43]:12666 "EHLO mga05.intel.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S230229AbhCZS1g (ORCPT <rfc822;netdev@vger.kernel.org>);
        Fri, 26 Mar 2021 14:27:36 -0400
IronPort-SDR: dHRhRBCb8uTxRrE2Puv1L+NEXhBeVg97/C6SqAiVs5sFIkWxvYQKfRJoRM1si4N+VIBWr85D3D
 /+ildHRGj9FQ==
X-IronPort-AV: E=McAfee;i="6000,8403,9935"; a="276343004"
X-IronPort-AV: E=Sophos;i="5.81,281,1610438400"; 
   d="scan'208";a="276343004"
Received: from fmsmga002.fm.intel.com ([10.253.24.26])
  by fmsmga105.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 26 Mar 2021 11:27:36 -0700
IronPort-SDR: YfBX/v9d2ghUqqTSLI5T3Tb37AtnafMYlsYEQ3FJc1V2j4zVylDbdKnY10bPxXyakO5a4dWdaB
 h38KU1/hwDfg==
X-IronPort-AV: E=Sophos;i="5.81,281,1610438400"; 
   d="scan'208";a="443456553"
Received: from mjmartin-desk2.amr.corp.intel.com (HELO mjmartin-desk2.intel.com) ([10.251.24.139])
  by fmsmga002-auth.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 26 Mar 2021 11:27:35 -0700
From:   Mat Martineau <mathew.j.martineau@linux.intel.com>
To:     netdev@vger.kernel.org
Cc:     Geliang Tang <geliangtang@gmail.com>, davem@davemloft.net,
        kuba@kernel.org, matthieu.baerts@tessares.net,
        mptcp@lists.linux.dev,
        Mat Martineau <mathew.j.martineau@linux.intel.com>
Subject: [PATCH net-next 08/13] mptcp: export lookup_anno_list_by_saddr
Date:   Fri, 26 Mar 2021 11:26:37 -0700
Message-Id: <20210326182642.136419-8-mathew.j.martineau@linux.intel.com>
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

This patch exported the static function lookup_anno_list_by_saddr, and
renamed it to mptcp_lookup_anno_list_by_saddr.

Signed-off-by: Geliang Tang <geliangtang@gmail.com>
Signed-off-by: Mat Martineau <mathew.j.martineau@linux.intel.com>
---
 net/mptcp/pm_netlink.c | 10 +++++-----
 net/mptcp/protocol.h   |  3 +++
 2 files changed, 8 insertions(+), 5 deletions(-)

diff --git a/net/mptcp/pm_netlink.c b/net/mptcp/pm_netlink.c
index c0c942c101cb..56d479b24803 100644
--- a/net/mptcp/pm_netlink.c
+++ b/net/mptcp/pm_netlink.c
@@ -263,9 +263,9 @@ static void check_work_pending(struct mptcp_sock *msk)
 		WRITE_ONCE(msk->pm.work_pending, false);
 }
 
-static struct mptcp_pm_add_entry *
-lookup_anno_list_by_saddr(struct mptcp_sock *msk,
-			  struct mptcp_addr_info *addr)
+struct mptcp_pm_add_entry *
+mptcp_lookup_anno_list_by_saddr(struct mptcp_sock *msk,
+				struct mptcp_addr_info *addr)
 {
 	struct mptcp_pm_add_entry *entry;
 
@@ -352,7 +352,7 @@ mptcp_pm_del_add_timer(struct mptcp_sock *msk,
 	struct sock *sk = (struct sock *)msk;
 
 	spin_lock_bh(&msk->pm.lock);
-	entry = lookup_anno_list_by_saddr(msk, addr);
+	entry = mptcp_lookup_anno_list_by_saddr(msk, addr);
 	if (entry)
 		entry->retrans_times = ADD_ADDR_RETRANS_MAX;
 	spin_unlock_bh(&msk->pm.lock);
@@ -372,7 +372,7 @@ static bool mptcp_pm_alloc_anno_list(struct mptcp_sock *msk,
 
 	lockdep_assert_held(&msk->pm.lock);
 
-	if (lookup_anno_list_by_saddr(msk, &entry->addr))
+	if (mptcp_lookup_anno_list_by_saddr(msk, &entry->addr))
 		return false;
 
 	add_entry = kmalloc(sizeof(*add_entry), GFP_ATOMIC);
diff --git a/net/mptcp/protocol.h b/net/mptcp/protocol.h
index d04161ec1cb2..9c51444b26cf 100644
--- a/net/mptcp/protocol.h
+++ b/net/mptcp/protocol.h
@@ -659,6 +659,9 @@ bool mptcp_pm_sport_in_anno_list(struct mptcp_sock *msk, const struct sock *sk);
 struct mptcp_pm_add_entry *
 mptcp_pm_del_add_timer(struct mptcp_sock *msk,
 		       struct mptcp_addr_info *addr);
+struct mptcp_pm_add_entry *
+mptcp_lookup_anno_list_by_saddr(struct mptcp_sock *msk,
+				struct mptcp_addr_info *addr);
 
 int mptcp_pm_announce_addr(struct mptcp_sock *msk,
 			   const struct mptcp_addr_info *addr,
-- 
2.31.0

