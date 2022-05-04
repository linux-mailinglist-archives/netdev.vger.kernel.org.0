Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 4B51851958A
	for <lists+netdev@lfdr.de>; Wed,  4 May 2022 04:39:22 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1344092AbiEDCmx (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 3 May 2022 22:42:53 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:50312 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1344053AbiEDCmq (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 3 May 2022 22:42:46 -0400
Received: from mga14.intel.com (mga14.intel.com [192.55.52.115])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 01E5D1F63D
        for <netdev@vger.kernel.org>; Tue,  3 May 2022 19:39:11 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1651631951; x=1683167951;
  h=from:to:cc:subject:date:message-id:in-reply-to:
   references:mime-version:content-transfer-encoding;
  bh=3ouXDUaXPlJuTvaTvTUptwOEPyKqWY9g1+x4mHYfDWY=;
  b=BVhd4rzw0MOIVJsPDgrlcMGIXz69XLjPHwMvmr0s2SbJlnme/ZDF9Bhm
   j9r/TV4Hu3ZpcxR3ojwRmR39Wo4s0cjo+MwkEm72QMzAUkPmvnSRIIM6r
   UdkHEbpUKPzqStbcnU6oc4ZRjMI/WFS6drdsA5nzqEvzGGvlemsGLsRlJ
   psS9xCFoy0oB4HthcnKF5i1HnLuHqM8PPaw4BltQ0X+PSYup4Lz3iW9ug
   fzSRiuFeB5v7BGRfATXTpX7ASKD9btMUBVtFcB+pDAlcM2ZbsocU9E4OY
   9Nua3/xcopLv5yr3NNwPO4U/3ghHvV8zbwjoNDa8x/5VB/fOkzVEBd78z
   w==;
X-IronPort-AV: E=McAfee;i="6400,9594,10336"; a="267799843"
X-IronPort-AV: E=Sophos;i="5.91,196,1647327600"; 
   d="scan'208";a="267799843"
Received: from orsmga008.jf.intel.com ([10.7.209.65])
  by fmsmga103.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 03 May 2022 19:39:07 -0700
X-IronPort-AV: E=Sophos;i="5.91,196,1647327600"; 
   d="scan'208";a="584493382"
Received: from mjmartin-desk2.amr.corp.intel.com (HELO mjmartin-desk2.intel.com) ([10.251.20.240])
  by orsmga008-auth.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 03 May 2022 19:39:07 -0700
From:   Mat Martineau <mathew.j.martineau@linux.intel.com>
To:     netdev@vger.kernel.org
Cc:     Kishen Maloor <kishen.maloor@intel.com>, davem@davemloft.net,
        kuba@kernel.org, pabeni@redhat.com, edumazet@google.com,
        matthieu.baerts@tessares.net, mptcp@lists.linux.dev,
        Mat Martineau <mathew.j.martineau@linux.intel.com>
Subject: [PATCH net-next 06/13] mptcp: netlink: Add MPTCP_PM_CMD_REMOVE
Date:   Tue,  3 May 2022 19:38:54 -0700
Message-Id: <20220504023901.277012-7-mathew.j.martineau@linux.intel.com>
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

This change adds a MPTCP netlink command for issuing a
REMOVE_ADDR signal for an address over the chosen MPTCP
connection from a userspace path manager.

The command requires the following parameters: {token, loc_id}.

Acked-by: Paolo Abeni <pabeni@redhat.com>
Signed-off-by: Kishen Maloor <kishen.maloor@intel.com>
Signed-off-by: Mat Martineau <mathew.j.martineau@linux.intel.com>
---
 include/uapi/linux/mptcp.h |  2 ++
 net/mptcp/pm_netlink.c     | 10 ++++--
 net/mptcp/pm_userspace.c   | 62 ++++++++++++++++++++++++++++++++++++++
 net/mptcp/protocol.h       |  4 +++
 4 files changed, 76 insertions(+), 2 deletions(-)

diff --git a/include/uapi/linux/mptcp.h b/include/uapi/linux/mptcp.h
index ac66c1263f02..11f9fa001a3c 100644
--- a/include/uapi/linux/mptcp.h
+++ b/include/uapi/linux/mptcp.h
@@ -56,6 +56,7 @@ enum {
 	MPTCP_PM_ATTR_RCV_ADD_ADDRS,			/* u32 */
 	MPTCP_PM_ATTR_SUBFLOWS,				/* u32 */
 	MPTCP_PM_ATTR_TOKEN,				/* u32 */
+	MPTCP_PM_ATTR_LOC_ID,				/* u8 */
 
 	__MPTCP_PM_ATTR_MAX
 };
@@ -95,6 +96,7 @@ enum {
 	MPTCP_PM_CMD_GET_LIMITS,
 	MPTCP_PM_CMD_SET_FLAGS,
 	MPTCP_PM_CMD_ANNOUNCE,
+	MPTCP_PM_CMD_REMOVE,
 
 	__MPTCP_PM_CMD_AFTER_LAST
 };
diff --git a/net/mptcp/pm_netlink.c b/net/mptcp/pm_netlink.c
index dbe5ccd95ac5..a26750f19f65 100644
--- a/net/mptcp/pm_netlink.c
+++ b/net/mptcp/pm_netlink.c
@@ -1095,6 +1095,7 @@ static const struct nla_policy mptcp_pm_policy[MPTCP_PM_ATTR_MAX + 1] = {
 	[MPTCP_PM_ATTR_RCV_ADD_ADDRS]	= { .type	= NLA_U32,	},
 	[MPTCP_PM_ATTR_SUBFLOWS]	= { .type	= NLA_U32,	},
 	[MPTCP_PM_ATTR_TOKEN]		= { .type	= NLA_U32,	},
+	[MPTCP_PM_ATTR_LOC_ID]		= { .type	= NLA_U8,	},
 };
 
 void mptcp_pm_nl_subflow_chk_stale(const struct mptcp_sock *msk, struct sock *ssk)
@@ -1504,8 +1505,8 @@ static int mptcp_nl_cmd_del_addr(struct sk_buff *skb, struct genl_info *info)
 	return ret;
 }
 
-static void mptcp_pm_remove_addrs_and_subflows(struct mptcp_sock *msk,
-					       struct list_head *rm_list)
+void mptcp_pm_remove_addrs_and_subflows(struct mptcp_sock *msk,
+					struct list_head *rm_list)
 {
 	struct mptcp_rm_list alist = { .nr = 0 }, slist = { .nr = 0 };
 	struct mptcp_pm_addr_entry *entry;
@@ -2204,6 +2205,11 @@ static const struct genl_small_ops mptcp_pm_ops[] = {
 		.doit   = mptcp_nl_cmd_announce,
 		.flags  = GENL_ADMIN_PERM,
 	},
+	{
+		.cmd    = MPTCP_PM_CMD_REMOVE,
+		.doit   = mptcp_nl_cmd_remove,
+		.flags  = GENL_ADMIN_PERM,
+	},
 };
 
 static struct genl_family mptcp_genl_family __ro_after_init = {
diff --git a/net/mptcp/pm_userspace.c b/net/mptcp/pm_userspace.c
index 347184a9157b..3a42c9e66126 100644
--- a/net/mptcp/pm_userspace.c
+++ b/net/mptcp/pm_userspace.c
@@ -180,3 +180,65 @@ int mptcp_nl_cmd_announce(struct sk_buff *skb, struct genl_info *info)
 	sock_put((struct sock *)msk);
 	return err;
 }
+
+int mptcp_nl_cmd_remove(struct sk_buff *skb, struct genl_info *info)
+{
+	struct nlattr *token = info->attrs[MPTCP_PM_ATTR_TOKEN];
+	struct nlattr *id = info->attrs[MPTCP_PM_ATTR_LOC_ID];
+	struct mptcp_pm_addr_entry *match = NULL;
+	struct mptcp_pm_addr_entry *entry;
+	struct mptcp_sock *msk;
+	LIST_HEAD(free_list);
+	int err = -EINVAL;
+	u32 token_val;
+	u8 id_val;
+
+	if (!id || !token) {
+		GENL_SET_ERR_MSG(info, "missing required inputs");
+		return err;
+	}
+
+	id_val = nla_get_u8(id);
+	token_val = nla_get_u32(token);
+
+	msk = mptcp_token_get_sock(sock_net(skb->sk), token_val);
+	if (!msk) {
+		NL_SET_ERR_MSG_ATTR(info->extack, token, "invalid token");
+		return err;
+	}
+
+	if (!mptcp_pm_is_userspace(msk)) {
+		GENL_SET_ERR_MSG(info, "invalid request; userspace PM not selected");
+		goto remove_err;
+	}
+
+	lock_sock((struct sock *)msk);
+
+	list_for_each_entry(entry, &msk->pm.userspace_pm_local_addr_list, list) {
+		if (entry->addr.id == id_val) {
+			match = entry;
+			break;
+		}
+	}
+
+	if (!match) {
+		GENL_SET_ERR_MSG(info, "address with specified id not found");
+		release_sock((struct sock *)msk);
+		goto remove_err;
+	}
+
+	list_move(&match->list, &free_list);
+
+	mptcp_pm_remove_addrs_and_subflows(msk, &free_list);
+
+	release_sock((struct sock *)msk);
+
+	list_for_each_entry_safe(match, entry, &free_list, list) {
+		sock_kfree_s((struct sock *)msk, match, sizeof(*match));
+	}
+
+	err = 0;
+ remove_err:
+	sock_put((struct sock *)msk);
+	return err;
+}
diff --git a/net/mptcp/protocol.h b/net/mptcp/protocol.h
index de645efbc806..4026aa3df7f4 100644
--- a/net/mptcp/protocol.h
+++ b/net/mptcp/protocol.h
@@ -801,10 +801,14 @@ int mptcp_pm_announce_addr(struct mptcp_sock *msk,
 			   bool echo);
 int mptcp_pm_remove_addr(struct mptcp_sock *msk, const struct mptcp_rm_list *rm_list);
 int mptcp_pm_remove_subflow(struct mptcp_sock *msk, const struct mptcp_rm_list *rm_list);
+void mptcp_pm_remove_addrs_and_subflows(struct mptcp_sock *msk,
+					struct list_head *rm_list);
+
 int mptcp_userspace_pm_append_new_local_addr(struct mptcp_sock *msk,
 					     struct mptcp_pm_addr_entry *entry);
 void mptcp_free_local_addr_list(struct mptcp_sock *msk);
 int mptcp_nl_cmd_announce(struct sk_buff *skb, struct genl_info *info);
+int mptcp_nl_cmd_remove(struct sk_buff *skb, struct genl_info *info);
 
 void mptcp_event(enum mptcp_event_type type, const struct mptcp_sock *msk,
 		 const struct sock *ssk, gfp_t gfp);
-- 
2.36.0

