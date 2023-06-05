Return-Path: <netdev+bounces-7847-lists+netdev=lfdr.de@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [IPv6:2604:1380:45e3:2400::1])
	by mail.lfdr.de (Postfix) with ESMTPS id BBC7D721C8A
	for <lists+netdev@lfdr.de>; Mon,  5 Jun 2023 05:27:13 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id 76B72281192
	for <lists+netdev@lfdr.de>; Mon,  5 Jun 2023 03:27:12 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 6B55A649;
	Mon,  5 Jun 2023 03:25:33 +0000 (UTC)
X-Original-To: netdev@vger.kernel.org
Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 1E5E117D7;
	Mon,  5 Jun 2023 03:25:31 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 9CC64C433AA;
	Mon,  5 Jun 2023 03:25:30 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1685935530;
	bh=BMOzYlJrGMhscXXovu7hjA/5a0KG42M+rDSsK0KVzaI=;
	h=From:Date:Subject:References:In-Reply-To:To:Cc:From;
	b=UXr72ugBXTv9mNpuOvno+4kgHZkDTUEpoE4+yK36KeIApVC15tFbFwc2RWUoUq1CV
	 7J7jk+rdd5612znNX/KvTIYWa0LGhacPFuxfaND1NDFbqOH9SoT0WFkrhNwbHqvLxZ
	 ZkTpi6Sm9yndrYPjeP17RPdCpAASykxJGkJp+M2cUH4tHXsG1qPhZLBLhA0mXXgfyb
	 wprgRcby1RATyMXxVFgmwCN5t4d597xbnHQ+/xZi4ca7vU+roHgN5QUHRuGeHdSWb3
	 bnkjBwRWiqTMwxoX83wIbJH8+PLAfJMtveKFnXc6M2bzt+2T1hkb44EZt2lvrMdD44
	 FSdBHXmizWGTA==
From: Mat Martineau <martineau@kernel.org>
Date: Sun, 04 Jun 2023 20:25:21 -0700
Subject: [PATCH net 5/5] mptcp: update userspace pm infos
Precedence: bulk
X-Mailing-List: netdev@vger.kernel.org
List-Id: <netdev.vger.kernel.org>
List-Subscribe: <mailto:netdev+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:netdev+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Message-Id: <20230602-send-net-20230602-v1-5-fe011dfa859d@kernel.org>
References: <20230602-send-net-20230602-v1-0-fe011dfa859d@kernel.org>
In-Reply-To: <20230602-send-net-20230602-v1-0-fe011dfa859d@kernel.org>
To: Matthieu Baerts <matthieu.baerts@tessares.net>, 
 "David S. Miller" <davem@davemloft.net>, Eric Dumazet <edumazet@google.com>, 
 Jakub Kicinski <kuba@kernel.org>, Paolo Abeni <pabeni@redhat.com>, 
 Kishen Maloor <kishen.maloor@intel.com>, 
 Geliang Tang <geliang.tang@suse.com>, Florian Westphal <fw@strlen.de>
Cc: netdev@vger.kernel.org, mptcp@lists.linux.dev, 
 Mat Martineau <martineau@kernel.org>, stable@vger.kernel.org
X-Mailer: b4 0.12.2

From: Geliang Tang <geliang.tang@suse.com>

Increase pm subflows counter on both server side and client side when
userspace pm creates a new subflow, and decrease the counter when it
closes a subflow.

Increase add_addr_signaled counter in mptcp_nl_cmd_announce() when the
address is announced by userspace PM.

This modification is similar to how the in-kernel PM is updating the
counter: when additional subflows are created/removed.

Fixes: 9ab4807c84a4 ("mptcp: netlink: Add MPTCP_PM_CMD_ANNOUNCE")
Fixes: 702c2f646d42 ("mptcp: netlink: allow userspace-driven subflow establishment")
Closes: https://github.com/multipath-tcp/mptcp_net-next/issues/329
Cc: stable@vger.kernel.org
Reviewed-by: Matthieu Baerts <matthieu.baerts@tessares.net>
Signed-off-by: Geliang Tang <geliang.tang@suse.com>
Signed-off-by: Mat Martineau <martineau@kernel.org>
---
 net/mptcp/pm.c           | 23 +++++++++++++++++++----
 net/mptcp/pm_userspace.c |  5 +++++
 2 files changed, 24 insertions(+), 4 deletions(-)

diff --git a/net/mptcp/pm.c b/net/mptcp/pm.c
index 78c924506e83..76612bca275a 100644
--- a/net/mptcp/pm.c
+++ b/net/mptcp/pm.c
@@ -87,8 +87,15 @@ bool mptcp_pm_allow_new_subflow(struct mptcp_sock *msk)
 	unsigned int subflows_max;
 	int ret = 0;
 
-	if (mptcp_pm_is_userspace(msk))
-		return mptcp_userspace_pm_active(msk);
+	if (mptcp_pm_is_userspace(msk)) {
+		if (mptcp_userspace_pm_active(msk)) {
+			spin_lock_bh(&pm->lock);
+			pm->subflows++;
+			spin_unlock_bh(&pm->lock);
+			return true;
+		}
+		return false;
+	}
 
 	subflows_max = mptcp_pm_get_subflows_max(msk);
 
@@ -181,8 +188,16 @@ void mptcp_pm_subflow_check_next(struct mptcp_sock *msk, const struct sock *ssk,
 	struct mptcp_pm_data *pm = &msk->pm;
 	bool update_subflows;
 
-	update_subflows = (subflow->request_join || subflow->mp_join) &&
-			  mptcp_pm_is_kernel(msk);
+	update_subflows = subflow->request_join || subflow->mp_join;
+	if (mptcp_pm_is_userspace(msk)) {
+		if (update_subflows) {
+			spin_lock_bh(&pm->lock);
+			pm->subflows--;
+			spin_unlock_bh(&pm->lock);
+		}
+		return;
+	}
+
 	if (!READ_ONCE(pm->work_pending) && !update_subflows)
 		return;
 
diff --git a/net/mptcp/pm_userspace.c b/net/mptcp/pm_userspace.c
index 114548b09f47..b06aa58dfcf2 100644
--- a/net/mptcp/pm_userspace.c
+++ b/net/mptcp/pm_userspace.c
@@ -69,6 +69,7 @@ static int mptcp_userspace_pm_append_new_local_addr(struct mptcp_sock *msk,
 							MPTCP_PM_MAX_ADDR_ID + 1,
 							1);
 		list_add_tail_rcu(&e->list, &msk->pm.userspace_pm_local_addr_list);
+		msk->pm.local_addr_used++;
 		ret = e->addr.id;
 	} else if (match) {
 		ret = entry->addr.id;
@@ -96,6 +97,7 @@ static int mptcp_userspace_pm_delete_local_addr(struct mptcp_sock *msk,
 			 */
 			list_del_rcu(&entry->list);
 			kfree(entry);
+			msk->pm.local_addr_used--;
 			return 0;
 		}
 	}
@@ -195,6 +197,7 @@ int mptcp_nl_cmd_announce(struct sk_buff *skb, struct genl_info *info)
 	spin_lock_bh(&msk->pm.lock);
 
 	if (mptcp_pm_alloc_anno_list(msk, &addr_val)) {
+		msk->pm.add_addr_signaled++;
 		mptcp_pm_announce_addr(msk, &addr_val.addr, false);
 		mptcp_pm_nl_addr_send_ack(msk);
 	}
@@ -343,6 +346,8 @@ int mptcp_nl_cmd_sf_create(struct sk_buff *skb, struct genl_info *info)
 	spin_lock_bh(&msk->pm.lock);
 	if (err)
 		mptcp_userspace_pm_delete_local_addr(msk, &local);
+	else
+		msk->pm.subflows++;
 	spin_unlock_bh(&msk->pm.lock);
 
  create_err:

-- 
2.40.1


