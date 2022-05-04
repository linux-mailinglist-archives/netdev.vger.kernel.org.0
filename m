Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 83846519585
	for <lists+netdev@lfdr.de>; Wed,  4 May 2022 04:39:15 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1344064AbiEDCmr (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 3 May 2022 22:42:47 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:50232 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232041AbiEDCmn (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 3 May 2022 22:42:43 -0400
Received: from mga14.intel.com (mga14.intel.com [192.55.52.115])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id B52DC1902A
        for <netdev@vger.kernel.org>; Tue,  3 May 2022 19:39:08 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1651631948; x=1683167948;
  h=from:to:cc:subject:date:message-id:in-reply-to:
   references:mime-version:content-transfer-encoding;
  bh=op3ufkMsUw3X5mNCgmwsCaCzkYqkwQ6qdR+SQOk/NSM=;
  b=UhXu16jv3zc79w8g+ZwuhhIJ4ObSVRR72W+iwfryGjpqZ2ftS+QgmSti
   J/4fkZSjdOZoqqvVHA/jYrjxqOpHYSZ5ktop6vJR70A+lDdl3S781Xg2L
   vgKUc7KRrPHkTNhT2wMfrrin7m8LrsjC4nDf34tPhTGmmNwLEaLFPLI35
   jXsZB8iwmRG03MY9fMTOB5PZ1KOkppwX94z7+qtA7thHtPDS83/k9j+sB
   BX8vSyBlXw+gALEpZRM//lPgL2PeSSzY8tnzdZDlHW+l1StAEfBerh+76
   Gl0UE8zb/3OlDsSunBkvEdk4/KPm2UpT5Rb9UxeR4j/9CkXPGFRFdhJoR
   A==;
X-IronPort-AV: E=McAfee;i="6400,9594,10336"; a="267799834"
X-IronPort-AV: E=Sophos;i="5.91,196,1647327600"; 
   d="scan'208";a="267799834"
Received: from orsmga008.jf.intel.com ([10.7.209.65])
  by fmsmga103.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 03 May 2022 19:39:07 -0700
X-IronPort-AV: E=Sophos;i="5.91,196,1647327600"; 
   d="scan'208";a="584493370"
Received: from mjmartin-desk2.amr.corp.intel.com (HELO mjmartin-desk2.intel.com) ([10.251.20.240])
  by orsmga008-auth.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 03 May 2022 19:39:07 -0700
From:   Mat Martineau <mathew.j.martineau@linux.intel.com>
To:     netdev@vger.kernel.org
Cc:     Kishen Maloor <kishen.maloor@intel.com>, davem@davemloft.net,
        kuba@kernel.org, pabeni@redhat.com, edumazet@google.com,
        matthieu.baerts@tessares.net, mptcp@lists.linux.dev,
        Mat Martineau <mathew.j.martineau@linux.intel.com>
Subject: [PATCH net-next 02/13] mptcp: read attributes of addr entries managed by userspace PMs
Date:   Tue,  3 May 2022 19:38:50 -0700
Message-Id: <20220504023901.277012-3-mathew.j.martineau@linux.intel.com>
X-Mailer: git-send-email 2.36.0
In-Reply-To: <20220504023901.277012-1-mathew.j.martineau@linux.intel.com>
References: <20220504023901.277012-1-mathew.j.martineau@linux.intel.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-7.6 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,SPF_HELO_NONE,
        SPF_NONE,T_SCC_BODY_TEXT_LINE autolearn=ham autolearn_force=no
        version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Kishen Maloor <kishen.maloor@intel.com>

This change introduces a parallel path in the kernel for retrieving
the local id, flags, if_index for an addr entry in the context of
an MPTCP connection that's being managed by a userspace PM. The
userspace and in-kernel PM modes deviate in their procedures for
obtaining this information.

Acked-by: Paolo Abeni <pabeni@redhat.com>
Signed-off-by: Kishen Maloor <kishen.maloor@intel.com>
Signed-off-by: Mat Martineau <mathew.j.martineau@linux.intel.com>
---
 net/mptcp/pm_netlink.c   | 13 +++++++++++-
 net/mptcp/pm_userspace.c | 43 ++++++++++++++++++++++++++++++++++++++++
 net/mptcp/protocol.h     |  7 ++++++-
 net/mptcp/subflow.c      |  2 +-
 4 files changed, 62 insertions(+), 3 deletions(-)

diff --git a/net/mptcp/pm_netlink.c b/net/mptcp/pm_netlink.c
index 9d515c3e0b16..79f5e7197a06 100644
--- a/net/mptcp/pm_netlink.c
+++ b/net/mptcp/pm_netlink.c
@@ -1033,6 +1033,9 @@ int mptcp_pm_nl_get_local_id(struct mptcp_sock *msk, struct sock_common *skc)
 	if (mptcp_addresses_equal(&msk_local, &skc_local, false))
 		return 0;
 
+	if (mptcp_pm_is_userspace(msk))
+		return mptcp_userspace_pm_get_local_id(msk, &skc_local);
+
 	pernet = pm_nl_get_pernet_from_msk(msk);
 
 	rcu_read_lock();
@@ -1297,15 +1300,23 @@ static int mptcp_nl_cmd_add_addr(struct sk_buff *skb, struct genl_info *info)
 	return 0;
 }
 
-int mptcp_pm_get_flags_and_ifindex_by_id(struct net *net, unsigned int id,
+int mptcp_pm_get_flags_and_ifindex_by_id(struct mptcp_sock *msk, unsigned int id,
 					 u8 *flags, int *ifindex)
 {
 	struct mptcp_pm_addr_entry *entry;
+	struct sock *sk = (struct sock *)msk;
+	struct net *net = sock_net(sk);
 
 	*flags = 0;
 	*ifindex = 0;
 
 	if (id) {
+		if (mptcp_pm_is_userspace(msk))
+			return mptcp_userspace_pm_get_flags_and_ifindex_by_id(msk,
+									      id,
+									      flags,
+									      ifindex);
+
 		rcu_read_lock();
 		entry = __lookup_addr_by_id(pm_nl_get_pernet(net), id);
 		if (entry) {
diff --git a/net/mptcp/pm_userspace.c b/net/mptcp/pm_userspace.c
index c50f8900ffba..910116b0f5b9 100644
--- a/net/mptcp/pm_userspace.c
+++ b/net/mptcp/pm_userspace.c
@@ -76,3 +76,46 @@ int mptcp_userspace_pm_append_new_local_addr(struct mptcp_sock *msk,
 	spin_unlock_bh(&msk->pm.lock);
 	return ret;
 }
+
+int mptcp_userspace_pm_get_flags_and_ifindex_by_id(struct mptcp_sock *msk,
+						   unsigned int id,
+						   u8 *flags, int *ifindex)
+{
+	struct mptcp_pm_addr_entry *entry, *match = NULL;
+
+	*flags = 0;
+	*ifindex = 0;
+
+	spin_lock_bh(&msk->pm.lock);
+	list_for_each_entry(entry, &msk->pm.userspace_pm_local_addr_list, list) {
+		if (id == entry->addr.id) {
+			match = entry;
+			break;
+		}
+	}
+	spin_unlock_bh(&msk->pm.lock);
+	if (match) {
+		*flags = match->flags;
+		*ifindex = match->ifindex;
+	}
+
+	return 0;
+}
+
+int mptcp_userspace_pm_get_local_id(struct mptcp_sock *msk,
+				    struct mptcp_addr_info *skc)
+{
+	struct mptcp_pm_addr_entry new_entry;
+	__be16 msk_sport =  ((struct inet_sock *)
+			     inet_sk((struct sock *)msk))->inet_sport;
+
+	memset(&new_entry, 0, sizeof(struct mptcp_pm_addr_entry));
+	new_entry.addr = *skc;
+	new_entry.addr.id = 0;
+	new_entry.flags = MPTCP_PM_ADDR_FLAG_IMPLICIT;
+
+	if (new_entry.addr.port == msk_sport)
+		new_entry.addr.port = 0;
+
+	return mptcp_userspace_pm_append_new_local_addr(msk, &new_entry);
+}
diff --git a/net/mptcp/protocol.h b/net/mptcp/protocol.h
index f41089e54555..7257dc7aed43 100644
--- a/net/mptcp/protocol.h
+++ b/net/mptcp/protocol.h
@@ -783,8 +783,12 @@ mptcp_pm_del_add_timer(struct mptcp_sock *msk,
 struct mptcp_pm_add_entry *
 mptcp_lookup_anno_list_by_saddr(const struct mptcp_sock *msk,
 				const struct mptcp_addr_info *addr);
-int mptcp_pm_get_flags_and_ifindex_by_id(struct net *net, unsigned int id,
+int mptcp_pm_get_flags_and_ifindex_by_id(struct mptcp_sock *msk,
+					 unsigned int id,
 					 u8 *flags, int *ifindex);
+int mptcp_userspace_pm_get_flags_and_ifindex_by_id(struct mptcp_sock *msk,
+						   unsigned int id,
+						   u8 *flags, int *ifindex);
 
 int mptcp_pm_announce_addr(struct mptcp_sock *msk,
 			   const struct mptcp_addr_info *addr,
@@ -862,6 +866,7 @@ bool mptcp_pm_add_addr_signal(struct mptcp_sock *msk, const struct sk_buff *skb,
 bool mptcp_pm_rm_addr_signal(struct mptcp_sock *msk, unsigned int remaining,
 			     struct mptcp_rm_list *rm_list);
 int mptcp_pm_get_local_id(struct mptcp_sock *msk, struct sock_common *skc);
+int mptcp_userspace_pm_get_local_id(struct mptcp_sock *msk, struct mptcp_addr_info *skc);
 
 void __init mptcp_pm_nl_init(void);
 void mptcp_pm_nl_work(struct mptcp_sock *msk);
diff --git a/net/mptcp/subflow.c b/net/mptcp/subflow.c
index a0e7af33fb26..6d59336a8e1e 100644
--- a/net/mptcp/subflow.c
+++ b/net/mptcp/subflow.c
@@ -1468,7 +1468,7 @@ int __mptcp_subflow_connect(struct sock *sk, const struct mptcp_addr_info *loc,
 	if (local_id)
 		subflow_set_local_id(subflow, local_id);
 
-	mptcp_pm_get_flags_and_ifindex_by_id(sock_net(sk), local_id,
+	mptcp_pm_get_flags_and_ifindex_by_id(msk, local_id,
 					     &flags, &ifindex);
 	subflow->remote_key = msk->remote_key;
 	subflow->local_key = msk->local_key;
-- 
2.36.0

