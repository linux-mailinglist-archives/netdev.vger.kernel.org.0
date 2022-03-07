Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 736804D08B6
	for <lists+netdev@lfdr.de>; Mon,  7 Mar 2022 21:45:07 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S240616AbiCGUpy (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 7 Mar 2022 15:45:54 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:52514 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S239612AbiCGUpm (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 7 Mar 2022 15:45:42 -0500
Received: from mga03.intel.com (mga03.intel.com [134.134.136.65])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id DD02582D0D
        for <netdev@vger.kernel.org>; Mon,  7 Mar 2022 12:44:47 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1646685887; x=1678221887;
  h=from:to:cc:subject:date:message-id:in-reply-to:
   references:mime-version:content-transfer-encoding;
  bh=CpbSltr7vLpV0VAH0lgwZDuE0U+mKzxZCbR1mYGKECY=;
  b=R9+/dVI/8Auv2EEdZSZ7QbcWCxF9ohjJjEODIpg48u5CI/4agSzBrPFB
   OonVIzhxolgp6Pm0JQigKuba6V1jpC8XJxrgBfFUjC1c0hkrHU2CGDaKc
   KTwyN6WhLS8BaynG1MU4paxJIMFIBX3CHM1+Flc2CJefa2sXCq3JdFslr
   yV+fTT8PYC9rAT+XGczwjaG17PybBFpttujW25uJgEWB34dAGadxDSjbB
   TLdxtRoWA9zC2Fyj7H2CfvBYFUpew17r7GmW76wz0wmw499nTDf0h6fc6
   dynEMLOEGic9cIbbACgBCiILJdJgU/L9Eln5TO7IgRphtZFsS2Y4Yrr/w
   g==;
X-IronPort-AV: E=McAfee;i="6200,9189,10279"; a="254440167"
X-IronPort-AV: E=Sophos;i="5.90,163,1643702400"; 
   d="scan'208";a="254440167"
Received: from orsmga008.jf.intel.com ([10.7.209.65])
  by orsmga103.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 07 Mar 2022 12:44:45 -0800
X-IronPort-AV: E=Sophos;i="5.90,163,1643702400"; 
   d="scan'208";a="553320489"
Received: from mjmartin-desk2.amr.corp.intel.com (HELO mjmartin-desk2.intel.com) ([10.212.192.43])
  by orsmga008-auth.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 07 Mar 2022 12:44:45 -0800
From:   Mat Martineau <mathew.j.martineau@linux.intel.com>
To:     netdev@vger.kernel.org
Cc:     Paolo Abeni <pabeni@redhat.com>, davem@davemloft.net,
        kuba@kernel.org, matthieu.baerts@tessares.net,
        mptcp@lists.linux.dev,
        Mat Martineau <mathew.j.martineau@linux.intel.com>
Subject: [PATCH net-next 6/9] mptcp: introduce implicit endpoints
Date:   Mon,  7 Mar 2022 12:44:36 -0800
Message-Id: <20220307204439.65164-7-mathew.j.martineau@linux.intel.com>
X-Mailer: git-send-email 2.35.1
In-Reply-To: <20220307204439.65164-1-mathew.j.martineau@linux.intel.com>
References: <20220307204439.65164-1-mathew.j.martineau@linux.intel.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-4.8 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_EF,RCVD_IN_DNSWL_MED,SPF_HELO_NONE,
        SPF_NONE,T_SCC_BODY_TEXT_LINE autolearn=ham autolearn_force=no
        version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Paolo Abeni <pabeni@redhat.com>

In some edge scenarios, an MPTCP subflows can use a local address
mapped by a "implicit" endpoint created by the in-kernel path manager.

Such endpoints presence can be confusing, as it's creation is hard
to track and will prevent the later endpoint creation from the user-space
using the same address.

Define a new endpoint flag to mark implicit endpoints and allow the
user-space to replace implicit them with user-provided data at endpoint
creation time.

Signed-off-by: Paolo Abeni <pabeni@redhat.com>
Signed-off-by: Mat Martineau <mathew.j.martineau@linux.intel.com>
---
 include/uapi/linux/mptcp.h                    |  1 +
 net/mptcp/pm_netlink.c                        | 61 +++++++++++++------
 .../testing/selftests/net/mptcp/mptcp_join.sh |  4 +-
 3 files changed, 47 insertions(+), 19 deletions(-)

diff --git a/include/uapi/linux/mptcp.h b/include/uapi/linux/mptcp.h
index f106a3941cdf..9690efedb5fa 100644
--- a/include/uapi/linux/mptcp.h
+++ b/include/uapi/linux/mptcp.h
@@ -81,6 +81,7 @@ enum {
 #define MPTCP_PM_ADDR_FLAG_SUBFLOW			(1 << 1)
 #define MPTCP_PM_ADDR_FLAG_BACKUP			(1 << 2)
 #define MPTCP_PM_ADDR_FLAG_FULLMESH			(1 << 3)
+#define MPTCP_PM_ADDR_FLAG_IMPLICIT			(1 << 4)
 
 enum {
 	MPTCP_PM_CMD_UNSPEC,
diff --git a/net/mptcp/pm_netlink.c b/net/mptcp/pm_netlink.c
index 91b77d1162cf..10368a4f1c4a 100644
--- a/net/mptcp/pm_netlink.c
+++ b/net/mptcp/pm_netlink.c
@@ -877,10 +877,18 @@ static bool address_use_port(struct mptcp_pm_addr_entry *entry)
 		MPTCP_PM_ADDR_FLAG_SIGNAL;
 }
 
+/* caller must ensure the RCU grace period is already elapsed */
+static void __mptcp_pm_release_addr_entry(struct mptcp_pm_addr_entry *entry)
+{
+	if (entry->lsk)
+		sock_release(entry->lsk);
+	kfree(entry);
+}
+
 static int mptcp_pm_nl_append_new_local_addr(struct pm_nl_pernet *pernet,
 					     struct mptcp_pm_addr_entry *entry)
 {
-	struct mptcp_pm_addr_entry *cur;
+	struct mptcp_pm_addr_entry *cur, *del_entry = NULL;
 	unsigned int addr_max;
 	int ret = -EINVAL;
 
@@ -901,8 +909,22 @@ static int mptcp_pm_nl_append_new_local_addr(struct pm_nl_pernet *pernet,
 	list_for_each_entry(cur, &pernet->local_addr_list, list) {
 		if (addresses_equal(&cur->addr, &entry->addr,
 				    address_use_port(entry) &&
-				    address_use_port(cur)))
-			goto out;
+				    address_use_port(cur))) {
+			/* allow replacing the exiting endpoint only if such
+			 * endpoint is an implicit one and the user-space
+			 * did not provide an endpoint id
+			 */
+			if (!(cur->flags & MPTCP_PM_ADDR_FLAG_IMPLICIT))
+				goto out;
+			if (entry->addr.id)
+				goto out;
+
+			pernet->addrs--;
+			entry->addr.id = cur->addr.id;
+			list_del_rcu(&cur->list);
+			del_entry = cur;
+			break;
+		}
 	}
 
 	if (!entry->addr.id) {
@@ -938,6 +960,12 @@ static int mptcp_pm_nl_append_new_local_addr(struct pm_nl_pernet *pernet,
 
 out:
 	spin_unlock_bh(&pernet->lock);
+
+	/* just replaced an existing entry, free it */
+	if (del_entry) {
+		synchronize_rcu();
+		__mptcp_pm_release_addr_entry(del_entry);
+	}
 	return ret;
 }
 
@@ -1036,7 +1064,7 @@ int mptcp_pm_nl_get_local_id(struct mptcp_sock *msk, struct sock_common *skc)
 	entry->addr.id = 0;
 	entry->addr.port = 0;
 	entry->ifindex = 0;
-	entry->flags = 0;
+	entry->flags = MPTCP_PM_ADDR_FLAG_IMPLICIT;
 	entry->lsk = NULL;
 	ret = mptcp_pm_nl_append_new_local_addr(pernet, entry);
 	if (ret < 0)
@@ -1249,6 +1277,11 @@ static int mptcp_nl_cmd_add_addr(struct sk_buff *skb, struct genl_info *info)
 		return -EINVAL;
 	}
 
+	if (addr.flags & MPTCP_PM_ADDR_FLAG_IMPLICIT) {
+		GENL_SET_ERR_MSG(info, "can't create IMPLICIT endpoint");
+		return -EINVAL;
+	}
+
 	entry = kmalloc(sizeof(*entry), GFP_KERNEL);
 	if (!entry) {
 		GENL_SET_ERR_MSG(info, "can't allocate addr");
@@ -1333,11 +1366,12 @@ static bool mptcp_pm_remove_anno_addr(struct mptcp_sock *msk,
 }
 
 static int mptcp_nl_remove_subflow_and_signal_addr(struct net *net,
-						   struct mptcp_addr_info *addr)
+						   const struct mptcp_pm_addr_entry *entry)
 {
-	struct mptcp_sock *msk;
-	long s_slot = 0, s_num = 0;
+	const struct mptcp_addr_info *addr = &entry->addr;
 	struct mptcp_rm_list list = { .nr = 0 };
+	long s_slot = 0, s_num = 0;
+	struct mptcp_sock *msk;
 
 	pr_debug("remove_id=%d", addr->id);
 
@@ -1354,7 +1388,8 @@ static int mptcp_nl_remove_subflow_and_signal_addr(struct net *net,
 
 		lock_sock(sk);
 		remove_subflow = lookup_subflow_by_saddr(&msk->conn_list, addr);
-		mptcp_pm_remove_anno_addr(msk, addr, remove_subflow);
+		mptcp_pm_remove_anno_addr(msk, addr, remove_subflow &&
+					  !(entry->flags & MPTCP_PM_ADDR_FLAG_IMPLICIT));
 		if (remove_subflow)
 			mptcp_pm_remove_subflow(msk, &list);
 		release_sock(sk);
@@ -1367,14 +1402,6 @@ static int mptcp_nl_remove_subflow_and_signal_addr(struct net *net,
 	return 0;
 }
 
-/* caller must ensure the RCU grace period is already elapsed */
-static void __mptcp_pm_release_addr_entry(struct mptcp_pm_addr_entry *entry)
-{
-	if (entry->lsk)
-		sock_release(entry->lsk);
-	kfree(entry);
-}
-
 static int mptcp_nl_remove_id_zero_address(struct net *net,
 					   struct mptcp_addr_info *addr)
 {
@@ -1451,7 +1478,7 @@ static int mptcp_nl_cmd_del_addr(struct sk_buff *skb, struct genl_info *info)
 	__clear_bit(entry->addr.id, pernet->id_bitmap);
 	spin_unlock_bh(&pernet->lock);
 
-	mptcp_nl_remove_subflow_and_signal_addr(sock_net(skb->sk), &entry->addr);
+	mptcp_nl_remove_subflow_and_signal_addr(sock_net(skb->sk), entry);
 	synchronize_rcu();
 	__mptcp_pm_release_addr_entry(entry);
 
diff --git a/tools/testing/selftests/net/mptcp/mptcp_join.sh b/tools/testing/selftests/net/mptcp/mptcp_join.sh
index 02bab8a2d5a5..1e2e8dd9f0d6 100755
--- a/tools/testing/selftests/net/mptcp/mptcp_join.sh
+++ b/tools/testing/selftests/net/mptcp/mptcp_join.sh
@@ -1938,7 +1938,7 @@ backup_tests()
 	run_tests $ns1 $ns2 10.0.1.1 0 0 0 slow backup
 	chk_join_nr "single address, backup" 1 1 1
 	chk_add_nr 1 1
-	chk_prio_nr 1 0
+	chk_prio_nr 1 1
 
 	# single address with port, backup
 	reset
@@ -1948,7 +1948,7 @@ backup_tests()
 	run_tests $ns1 $ns2 10.0.1.1 0 0 0 slow backup
 	chk_join_nr "single address with port, backup" 1 1 1
 	chk_add_nr 1 1
-	chk_prio_nr 1 0
+	chk_prio_nr 1 1
 }
 
 add_addr_ports_tests()
-- 
2.35.1

