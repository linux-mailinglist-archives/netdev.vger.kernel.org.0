Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 2EE2F34AE97
	for <lists+netdev@lfdr.de>; Fri, 26 Mar 2021 19:28:33 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230445AbhCZS2G (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 26 Mar 2021 14:28:06 -0400
Received: from mga05.intel.com ([192.55.52.43]:12666 "EHLO mga05.intel.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S230249AbhCZS1i (ORCPT <rfc822;netdev@vger.kernel.org>);
        Fri, 26 Mar 2021 14:27:38 -0400
IronPort-SDR: 12MINc3dPGz5Qg8bjfdmYv1wOArrjRgIM438Z6XTioZwzj5d9XlGEjc1+Wx5kBLiCN/fxxsmh2
 UVQQfyZdI16w==
X-IronPort-AV: E=McAfee;i="6000,8403,9935"; a="276343010"
X-IronPort-AV: E=Sophos;i="5.81,281,1610438400"; 
   d="scan'208";a="276343010"
Received: from fmsmga002.fm.intel.com ([10.253.24.26])
  by fmsmga105.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 26 Mar 2021 11:27:38 -0700
IronPort-SDR: tghsuYtJHTlaNJ58nrjgPnecVhkCoVG9aDCtjQ6YXx/hWopvcCoP05JmaEZveolWwJEr8w8MKq
 +2ip5rHvQV2w==
X-IronPort-AV: E=Sophos;i="5.81,281,1610438400"; 
   d="scan'208";a="443456575"
Received: from mjmartin-desk2.amr.corp.intel.com (HELO mjmartin-desk2.intel.com) ([10.251.24.139])
  by fmsmga002-auth.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 26 Mar 2021 11:27:37 -0700
From:   Mat Martineau <mathew.j.martineau@linux.intel.com>
To:     netdev@vger.kernel.org
Cc:     Geliang Tang <geliangtang@gmail.com>, davem@davemloft.net,
        kuba@kernel.org, matthieu.baerts@tessares.net,
        mptcp@lists.linux.dev,
        Mat Martineau <mathew.j.martineau@linux.intel.com>
Subject: [PATCH net-next 12/13] mptcp: rename mptcp_pm_nl_add_addr_send_ack
Date:   Fri, 26 Mar 2021 11:26:41 -0700
Message-Id: <20210326182642.136419-12-mathew.j.martineau@linux.intel.com>
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

Since mptcp_pm_nl_add_addr_send_ack is now used for both ADD_ADDR and
RM_ADDR cases, rename it to mptcp_pm_nl_addr_send_ack.

Signed-off-by: Geliang Tang <geliangtang@gmail.com>
Signed-off-by: Mat Martineau <mathew.j.martineau@linux.intel.com>
---
 net/mptcp/pm.c         | 2 +-
 net/mptcp/pm_netlink.c | 8 ++++----
 net/mptcp/protocol.h   | 2 +-
 3 files changed, 6 insertions(+), 6 deletions(-)

diff --git a/net/mptcp/pm.c b/net/mptcp/pm.c
index efa7deb96139..9d00fa6d22e9 100644
--- a/net/mptcp/pm.c
+++ b/net/mptcp/pm.c
@@ -53,7 +53,7 @@ int mptcp_pm_remove_addr(struct mptcp_sock *msk, const struct mptcp_rm_list *rm_
 	msk->pm.rm_list_tx = *rm_list;
 	rm_addr |= BIT(MPTCP_RM_ADDR_SIGNAL);
 	WRITE_ONCE(msk->pm.addr_signal, rm_addr);
-	mptcp_pm_nl_add_addr_send_ack(msk);
+	mptcp_pm_nl_addr_send_ack(msk);
 	return 0;
 }
 
diff --git a/net/mptcp/pm_netlink.c b/net/mptcp/pm_netlink.c
index f71e910670bf..73b9245c87b2 100644
--- a/net/mptcp/pm_netlink.c
+++ b/net/mptcp/pm_netlink.c
@@ -437,7 +437,7 @@ static void mptcp_pm_create_subflow_or_signal_addr(struct mptcp_sock *msk)
 			if (mptcp_pm_alloc_anno_list(msk, local)) {
 				msk->pm.add_addr_signaled++;
 				mptcp_pm_announce_addr(msk, &local->addr, false);
-				mptcp_pm_nl_add_addr_send_ack(msk);
+				mptcp_pm_nl_addr_send_ack(msk);
 			}
 		} else {
 			/* pick failed, avoid fourther attempts later */
@@ -519,10 +519,10 @@ static void mptcp_pm_nl_add_addr_received(struct mptcp_sock *msk)
 
 add_addr_echo:
 	mptcp_pm_announce_addr(msk, &msk->pm.remote, true);
-	mptcp_pm_nl_add_addr_send_ack(msk);
+	mptcp_pm_nl_addr_send_ack(msk);
 }
 
-void mptcp_pm_nl_add_addr_send_ack(struct mptcp_sock *msk)
+void mptcp_pm_nl_addr_send_ack(struct mptcp_sock *msk)
 {
 	struct mptcp_subflow_context *subflow;
 
@@ -642,7 +642,7 @@ void mptcp_pm_nl_work(struct mptcp_sock *msk)
 	}
 	if (pm->status & BIT(MPTCP_PM_ADD_ADDR_SEND_ACK)) {
 		pm->status &= ~BIT(MPTCP_PM_ADD_ADDR_SEND_ACK);
-		mptcp_pm_nl_add_addr_send_ack(msk);
+		mptcp_pm_nl_addr_send_ack(msk);
 	}
 	if (pm->status & BIT(MPTCP_PM_RM_ADDR_RECEIVED)) {
 		pm->status &= ~BIT(MPTCP_PM_RM_ADDR_RECEIVED);
diff --git a/net/mptcp/protocol.h b/net/mptcp/protocol.h
index 6ce6ef58f092..e8c5ff2b8ace 100644
--- a/net/mptcp/protocol.h
+++ b/net/mptcp/protocol.h
@@ -650,7 +650,7 @@ void mptcp_pm_add_addr_received(struct mptcp_sock *msk,
 void mptcp_pm_add_addr_echoed(struct mptcp_sock *msk,
 			      struct mptcp_addr_info *addr);
 void mptcp_pm_add_addr_send_ack(struct mptcp_sock *msk);
-void mptcp_pm_nl_add_addr_send_ack(struct mptcp_sock *msk);
+void mptcp_pm_nl_addr_send_ack(struct mptcp_sock *msk);
 void mptcp_pm_rm_addr_received(struct mptcp_sock *msk,
 			       const struct mptcp_rm_list *rm_list);
 void mptcp_pm_mp_prio_received(struct sock *sk, u8 bkup);
-- 
2.31.0

