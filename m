Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id DCB794A7D2F
	for <lists+netdev@lfdr.de>; Thu,  3 Feb 2022 02:05:01 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1348734AbiBCBD4 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 2 Feb 2022 20:03:56 -0500
Received: from mga06.intel.com ([134.134.136.31]:6288 "EHLO mga06.intel.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1348704AbiBCBDu (ORCPT <rfc822;netdev@vger.kernel.org>);
        Wed, 2 Feb 2022 20:03:50 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1643850230; x=1675386230;
  h=from:to:cc:subject:date:message-id:in-reply-to:
   references:mime-version:content-transfer-encoding;
  bh=FC2LolPe1mWrv7RSaMwzaULMsfbrfUJRBuphqssZXwY=;
  b=K/z0lM44rWT8roh/DlMiVmD0Hrd96lyyFMVqx9z7qBmjAfH6h/aYAq5Y
   uz7FAEjRWztL3Tt29QXF2W5skg+1H++dCvRAb5Xq3srKE2qGkwlLy02OJ
   YoGPk+CmKmOtGk7eiwfkO2gu19VYGpnakfRy9v1n121y4sPLVADYETsgT
   o72A3K9AtR3/HeH4ES+AF4ni9HepKT8+4VzcOw21P7KFJzXJXR3XkvCsj
   OCd8N7ojDlvpJ5KfXhnid7S18jrTXVAEDfjggXwRxPoK+EhW2VzTAWXm8
   wKHazTZW0Jc4kQst+NQy9BhRwfOAz3dlQS7j+N2OVp5HSY/G7Vv0uBnw1
   Q==;
X-IronPort-AV: E=McAfee;i="6200,9189,10246"; a="308782833"
X-IronPort-AV: E=Sophos;i="5.88,338,1635231600"; 
   d="scan'208";a="308782833"
Received: from orsmga006.jf.intel.com ([10.7.209.51])
  by orsmga104.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 02 Feb 2022 17:03:49 -0800
X-IronPort-AV: E=Sophos;i="5.88,338,1635231600"; 
   d="scan'208";a="483070832"
Received: from mjmartin-desk2.amr.corp.intel.com (HELO mjmartin-desk2.intel.com) ([10.251.1.6])
  by orsmga006-auth.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 02 Feb 2022 17:03:49 -0800
From:   Mat Martineau <mathew.j.martineau@linux.intel.com>
To:     netdev@vger.kernel.org
Cc:     Geliang Tang <geliang.tang@suse.com>, davem@davemloft.net,
        kuba@kernel.org, matthieu.baerts@tessares.net,
        mptcp@lists.linux.dev, Paolo Abeni <pabeni@redhat.com>,
        Mat Martineau <mathew.j.martineau@linux.intel.com>
Subject: [PATCH net-next 5/7] mptcp: set fullmesh flag in pm_netlink
Date:   Wed,  2 Feb 2022 17:03:41 -0800
Message-Id: <20220203010343.113421-6-mathew.j.martineau@linux.intel.com>
X-Mailer: git-send-email 2.35.1
In-Reply-To: <20220203010343.113421-1-mathew.j.martineau@linux.intel.com>
References: <20220203010343.113421-1-mathew.j.martineau@linux.intel.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Geliang Tang <geliang.tang@suse.com>

This patch added the fullmesh flag setting support in pm_netlink.

If the fullmesh flag of the address is changed, remove all the related
subflows, update the fullmesh flag and create subflows again.

Acked-by: Paolo Abeni <pabeni@redhat.com>
Signed-off-by: Geliang Tang <geliang.tang@suse.com>
Signed-off-by: Mat Martineau <mathew.j.martineau@linux.intel.com>
---
 net/mptcp/pm_netlink.c | 37 ++++++++++++++++++++++++++++---------
 1 file changed, 28 insertions(+), 9 deletions(-)

diff --git a/net/mptcp/pm_netlink.c b/net/mptcp/pm_netlink.c
index 782b1d452269..d47795748ad7 100644
--- a/net/mptcp/pm_netlink.c
+++ b/net/mptcp/pm_netlink.c
@@ -1728,9 +1728,20 @@ mptcp_nl_cmd_get_limits(struct sk_buff *skb, struct genl_info *info)
 	return -EMSGSIZE;
 }
 
-static int mptcp_nl_addr_backup(struct net *net,
-				struct mptcp_addr_info *addr,
-				u8 bkup)
+static void mptcp_pm_nl_fullmesh(struct mptcp_sock *msk,
+				 struct mptcp_addr_info *addr)
+{
+	struct mptcp_rm_list list = { .nr = 0 };
+
+	list.ids[list.nr++] = addr->id;
+
+	mptcp_pm_nl_rm_subflow_received(msk, &list);
+	mptcp_pm_create_subflow_or_signal_addr(msk);
+}
+
+static int mptcp_nl_set_flags(struct net *net,
+			      struct mptcp_addr_info *addr,
+			      u8 bkup, u8 changed)
 {
 	long s_slot = 0, s_num = 0;
 	struct mptcp_sock *msk;
@@ -1744,7 +1755,10 @@ static int mptcp_nl_addr_backup(struct net *net,
 
 		lock_sock(sk);
 		spin_lock_bh(&msk->pm.lock);
-		ret = mptcp_pm_nl_mp_prio_send_ack(msk, addr, bkup);
+		if (changed & MPTCP_PM_ADDR_FLAG_BACKUP)
+			ret = mptcp_pm_nl_mp_prio_send_ack(msk, addr, bkup);
+		if (changed & MPTCP_PM_ADDR_FLAG_FULLMESH)
+			mptcp_pm_nl_fullmesh(msk, addr);
 		spin_unlock_bh(&msk->pm.lock);
 		release_sock(sk);
 
@@ -1761,6 +1775,8 @@ static int mptcp_nl_cmd_set_flags(struct sk_buff *skb, struct genl_info *info)
 	struct mptcp_pm_addr_entry addr = { .addr = { .family = AF_UNSPEC }, }, *entry;
 	struct nlattr *attr = info->attrs[MPTCP_PM_ATTR_ADDR];
 	struct pm_nl_pernet *pernet = genl_info_pm_nl(info);
+	u8 changed, mask = MPTCP_PM_ADDR_FLAG_BACKUP |
+			   MPTCP_PM_ADDR_FLAG_FULLMESH;
 	struct net *net = sock_net(skb->sk);
 	u8 bkup = 0, lookup_by_id = 0;
 	int ret;
@@ -1783,15 +1799,18 @@ static int mptcp_nl_cmd_set_flags(struct sk_buff *skb, struct genl_info *info)
 		spin_unlock_bh(&pernet->lock);
 		return -EINVAL;
 	}
+	if ((addr.flags & MPTCP_PM_ADDR_FLAG_FULLMESH) &&
+	    (entry->flags & MPTCP_PM_ADDR_FLAG_SIGNAL)) {
+		spin_unlock_bh(&pernet->lock);
+		return -EINVAL;
+	}
 
-	if (bkup)
-		entry->flags |= MPTCP_PM_ADDR_FLAG_BACKUP;
-	else
-		entry->flags &= ~MPTCP_PM_ADDR_FLAG_BACKUP;
+	changed = (addr.flags ^ entry->flags) & mask;
+	entry->flags = (entry->flags & ~mask) | (addr.flags & mask);
 	addr = *entry;
 	spin_unlock_bh(&pernet->lock);
 
-	mptcp_nl_addr_backup(net, &addr.addr, bkup);
+	mptcp_nl_set_flags(net, &addr.addr, bkup, changed);
 	return 0;
 }
 
-- 
2.35.1

