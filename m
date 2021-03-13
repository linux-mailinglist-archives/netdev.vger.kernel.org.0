Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id B9A57339AC2
	for <lists+netdev@lfdr.de>; Sat, 13 Mar 2021 02:17:13 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232583AbhCMBQa (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 12 Mar 2021 20:16:30 -0500
Received: from mga17.intel.com ([192.55.52.151]:1166 "EHLO mga17.intel.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S231392AbhCMBQ1 (ORCPT <rfc822;netdev@vger.kernel.org>);
        Fri, 12 Mar 2021 20:16:27 -0500
IronPort-SDR: Ohcvwv6D6ZxucIhL3Os/WZH/XB0dEiDeo8tLyGqWoVNrfD/rDDfKCETmctR5E+2Ewvxp9ffvjy
 x7K9v9rp9q8Q==
X-IronPort-AV: E=McAfee;i="6000,8403,9921"; a="168828240"
X-IronPort-AV: E=Sophos;i="5.81,245,1610438400"; 
   d="scan'208";a="168828240"
Received: from orsmga008.jf.intel.com ([10.7.209.65])
  by fmsmga107.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 12 Mar 2021 17:16:26 -0800
IronPort-SDR: xJH1GIwp8ZocoDaJIdRiWc56T49Ax7NG2gww+1+WuurldCY3UsVX4CRJuVnuH4oG9sPV+5UnCP
 h5GWgIHFEZVQ==
X-IronPort-AV: E=Sophos;i="5.81,245,1610438400"; 
   d="scan'208";a="411197371"
Received: from mjmartin-desk2.amr.corp.intel.com (HELO mjmartin-desk2.intel.com) ([10.255.228.204])
  by orsmga008-auth.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 12 Mar 2021 17:16:26 -0800
From:   Mat Martineau <mathew.j.martineau@linux.intel.com>
To:     netdev@vger.kernel.org
Cc:     Geliang Tang <geliangtang@gmail.com>, davem@davemloft.net,
        kuba@kernel.org, matthieu.baerts@tessares.net, mptcp@lists.01.org,
        Mat Martineau <mathew.j.martineau@linux.intel.com>
Subject: [PATCH net-next 02/11] mptcp: add rm_list_tx in mptcp_pm_data
Date:   Fri, 12 Mar 2021 17:16:12 -0800
Message-Id: <20210313011621.211661-3-mathew.j.martineau@linux.intel.com>
X-Mailer: git-send-email 2.30.2
In-Reply-To: <20210313011621.211661-1-mathew.j.martineau@linux.intel.com>
References: <20210313011621.211661-1-mathew.j.martineau@linux.intel.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Geliang Tang <geliangtang@gmail.com>

This patch added a new member rm_list_tx for struct mptcp_pm_data as the
removing address list on the outgoing direction. Initialize its nr field
to zero in mptcp_pm_data_init.

In mptcp_pm_remove_anno_addr, put the single address id into an removing
list, and passed it to mptcp_pm_remove_addr.

In mptcp_pm_remove_addr, save the input rm_list to rm_list_tx in struct
mptcp_pm_data.

Signed-off-by: Geliang Tang <geliangtang@gmail.com>
Signed-off-by: Mat Martineau <mathew.j.martineau@linux.intel.com>
---
 net/mptcp/pm.c         | 20 ++++++++++++--------
 net/mptcp/pm_netlink.c |  5 ++++-
 net/mptcp/protocol.h   |  3 ++-
 3 files changed, 18 insertions(+), 10 deletions(-)

diff --git a/net/mptcp/pm.c b/net/mptcp/pm.c
index 0654c86cd5ff..9a91605885bb 100644
--- a/net/mptcp/pm.c
+++ b/net/mptcp/pm.c
@@ -39,18 +39,18 @@ int mptcp_pm_announce_addr(struct mptcp_sock *msk,
 	return 0;
 }
 
-int mptcp_pm_remove_addr(struct mptcp_sock *msk, u8 local_id)
+int mptcp_pm_remove_addr(struct mptcp_sock *msk, const struct mptcp_rm_list *rm_list)
 {
 	u8 rm_addr = READ_ONCE(msk->pm.addr_signal);
 
-	pr_debug("msk=%p, local_id=%d", msk, local_id);
+	pr_debug("msk=%p, rm_list_nr=%d", msk, rm_list->nr);
 
 	if (rm_addr) {
 		pr_warn("addr_signal error, rm_addr=%d", rm_addr);
 		return -EINVAL;
 	}
 
-	msk->pm.rm_id = local_id;
+	msk->pm.rm_list_tx = *rm_list;
 	rm_addr |= BIT(MPTCP_RM_ADDR_SIGNAL);
 	WRITE_ONCE(msk->pm.addr_signal, rm_addr);
 	return 0;
@@ -260,7 +260,7 @@ bool mptcp_pm_add_addr_signal(struct mptcp_sock *msk, unsigned int remaining,
 bool mptcp_pm_rm_addr_signal(struct mptcp_sock *msk, unsigned int remaining,
 			     struct mptcp_rm_list *rm_list)
 {
-	int ret = false;
+	int ret = false, len;
 
 	spin_lock_bh(&msk->pm.lock);
 
@@ -268,11 +268,15 @@ bool mptcp_pm_rm_addr_signal(struct mptcp_sock *msk, unsigned int remaining,
 	if (!mptcp_pm_should_rm_signal(msk))
 		goto out_unlock;
 
-	if (remaining < TCPOLEN_MPTCP_RM_ADDR_BASE)
+	len = mptcp_rm_addr_len(&msk->pm.rm_list_tx);
+	if (len < 0) {
+		WRITE_ONCE(msk->pm.addr_signal, 0);
+		goto out_unlock;
+	}
+	if (remaining < len)
 		goto out_unlock;
 
-	rm_list->ids[0] = msk->pm.rm_id;
-	rm_list->nr = 1;
+	*rm_list = msk->pm.rm_list_tx;
 	WRITE_ONCE(msk->pm.addr_signal, 0);
 	ret = true;
 
@@ -292,7 +296,7 @@ void mptcp_pm_data_init(struct mptcp_sock *msk)
 	msk->pm.add_addr_accepted = 0;
 	msk->pm.local_addr_used = 0;
 	msk->pm.subflows = 0;
-	msk->pm.rm_id = 0;
+	msk->pm.rm_list_tx.nr = 0;
 	WRITE_ONCE(msk->pm.work_pending, false);
 	WRITE_ONCE(msk->pm.addr_signal, 0);
 	WRITE_ONCE(msk->pm.accept_addr, false);
diff --git a/net/mptcp/pm_netlink.c b/net/mptcp/pm_netlink.c
index 8e8e35fa4002..1eb9d0139267 100644
--- a/net/mptcp/pm_netlink.c
+++ b/net/mptcp/pm_netlink.c
@@ -1071,12 +1071,15 @@ static bool mptcp_pm_remove_anno_addr(struct mptcp_sock *msk,
 				      struct mptcp_addr_info *addr,
 				      bool force)
 {
+	struct mptcp_rm_list list = { .nr = 0 };
 	bool ret;
 
+	list.ids[list.nr++] = addr->id;
+
 	ret = remove_anno_list_by_saddr(msk, addr);
 	if (ret || force) {
 		spin_lock_bh(&msk->pm.lock);
-		mptcp_pm_remove_addr(msk, addr->id);
+		mptcp_pm_remove_addr(msk, &list);
 		spin_unlock_bh(&msk->pm.lock);
 	}
 	return ret;
diff --git a/net/mptcp/protocol.h b/net/mptcp/protocol.h
index c896bcf3e70f..ac15be7cf06b 100644
--- a/net/mptcp/protocol.h
+++ b/net/mptcp/protocol.h
@@ -207,6 +207,7 @@ struct mptcp_pm_data {
 	u8		local_addr_used;
 	u8		subflows;
 	u8		status;
+	struct mptcp_rm_list rm_list_tx;
 	u8		rm_id;
 };
 
@@ -661,7 +662,7 @@ mptcp_pm_del_add_timer(struct mptcp_sock *msk,
 int mptcp_pm_announce_addr(struct mptcp_sock *msk,
 			   const struct mptcp_addr_info *addr,
 			   bool echo, bool port);
-int mptcp_pm_remove_addr(struct mptcp_sock *msk, u8 local_id);
+int mptcp_pm_remove_addr(struct mptcp_sock *msk, const struct mptcp_rm_list *rm_list);
 int mptcp_pm_remove_subflow(struct mptcp_sock *msk, u8 local_id);
 
 void mptcp_event(enum mptcp_event_type type, const struct mptcp_sock *msk,
-- 
2.30.2

