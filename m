Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 533F0519587
	for <lists+netdev@lfdr.de>; Wed,  4 May 2022 04:39:21 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1344081AbiEDCmu (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 3 May 2022 22:42:50 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:50288 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S245677AbiEDCmp (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 3 May 2022 22:42:45 -0400
Received: from mga14.intel.com (mga14.intel.com [192.55.52.115])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 584DC1FA46
        for <netdev@vger.kernel.org>; Tue,  3 May 2022 19:39:10 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1651631950; x=1683167950;
  h=from:to:cc:subject:date:message-id:in-reply-to:
   references:mime-version:content-transfer-encoding;
  bh=1ddyKnkf+iGRfpWf9YNzEch91XJ2FQwqn6hbUF3WEUg=;
  b=QpGW6yu7swSYE3p9Fhd5EJwsRvOznD3Co/NOrfuo46uHyzs2dTSdaIBj
   43ubXFgKKKGJHYGKd22wveu+Az7TylmKtGCsoiCbqixTTb0kPiutGZ/cy
   gRIiENlgheZ2iFh61ipyhjdRJ4Ni4LOSIHBiJ/K7rVk0YKaQLjr0bcJK9
   cpPqGhSc8MbTXUlcPzY3knxtBWunhTla1x6JrNdu4HE1fKFusd2IW+n1g
   zpohvMitljPgeiVCGBvcJkWmOxbVrijgEf6I23OrxrqpVjKL5AUmojUgy
   xReV7IpJ0RHLd3E5Y61nevyAep+fypiEHQ7ZpAV4QqzJJcTT2JXiFDq1S
   Q==;
X-IronPort-AV: E=McAfee;i="6400,9594,10336"; a="267799839"
X-IronPort-AV: E=Sophos;i="5.91,196,1647327600"; 
   d="scan'208";a="267799839"
Received: from orsmga008.jf.intel.com ([10.7.209.65])
  by fmsmga103.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 03 May 2022 19:39:07 -0700
X-IronPort-AV: E=Sophos;i="5.91,196,1647327600"; 
   d="scan'208";a="584493375"
Received: from mjmartin-desk2.amr.corp.intel.com (HELO mjmartin-desk2.intel.com) ([10.251.20.240])
  by orsmga008-auth.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 03 May 2022 19:39:07 -0700
From:   Mat Martineau <mathew.j.martineau@linux.intel.com>
To:     netdev@vger.kernel.org
Cc:     Kishen Maloor <kishen.maloor@intel.com>, davem@davemloft.net,
        kuba@kernel.org, pabeni@redhat.com, edumazet@google.com,
        matthieu.baerts@tessares.net, mptcp@lists.linux.dev,
        Mat Martineau <mathew.j.martineau@linux.intel.com>
Subject: [PATCH net-next 04/13] mptcp: netlink: Add MPTCP_PM_CMD_ANNOUNCE
Date:   Tue,  3 May 2022 19:38:52 -0700
Message-Id: <20220504023901.277012-5-mathew.j.martineau@linux.intel.com>
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

This change adds a MPTCP netlink interface for issuing
ADD_ADDR advertisements over the chosen MPTCP connection from a
userspace path manager.

The command requires the following parameters:
{ token, { loc_id, family, daddr4 | daddr6 [, dport] } [, if_idx],
flags[signal] }.

Acked-by: Paolo Abeni <pabeni@redhat.com>
Signed-off-by: Kishen Maloor <kishen.maloor@intel.com>
Signed-off-by: Mat Martineau <mathew.j.martineau@linux.intel.com>
---
 include/uapi/linux/mptcp.h |  2 ++
 net/mptcp/pm_netlink.c     | 16 ++++++----
 net/mptcp/pm_userspace.c   | 61 ++++++++++++++++++++++++++++++++++++++
 net/mptcp/protocol.h       |  7 +++++
 4 files changed, 81 insertions(+), 5 deletions(-)

diff --git a/include/uapi/linux/mptcp.h b/include/uapi/linux/mptcp.h
index e41ea01a94bb..ac66c1263f02 100644
--- a/include/uapi/linux/mptcp.h
+++ b/include/uapi/linux/mptcp.h
@@ -55,6 +55,7 @@ enum {
 	MPTCP_PM_ATTR_ADDR,				/* nested address */
 	MPTCP_PM_ATTR_RCV_ADD_ADDRS,			/* u32 */
 	MPTCP_PM_ATTR_SUBFLOWS,				/* u32 */
+	MPTCP_PM_ATTR_TOKEN,				/* u32 */
 
 	__MPTCP_PM_ATTR_MAX
 };
@@ -93,6 +94,7 @@ enum {
 	MPTCP_PM_CMD_SET_LIMITS,
 	MPTCP_PM_CMD_GET_LIMITS,
 	MPTCP_PM_CMD_SET_FLAGS,
+	MPTCP_PM_CMD_ANNOUNCE,
 
 	__MPTCP_PM_CMD_AFTER_LAST
 };
diff --git a/net/mptcp/pm_netlink.c b/net/mptcp/pm_netlink.c
index 7d9bed536966..dbe5ccd95ac5 100644
--- a/net/mptcp/pm_netlink.c
+++ b/net/mptcp/pm_netlink.c
@@ -352,8 +352,8 @@ mptcp_pm_del_add_timer(struct mptcp_sock *msk,
 	return entry;
 }
 
-static bool mptcp_pm_alloc_anno_list(struct mptcp_sock *msk,
-				     const struct mptcp_pm_addr_entry *entry)
+bool mptcp_pm_alloc_anno_list(struct mptcp_sock *msk,
+			      const struct mptcp_pm_addr_entry *entry)
 {
 	struct mptcp_pm_add_entry *add_entry = NULL;
 	struct sock *sk = (struct sock *)msk;
@@ -1094,6 +1094,7 @@ static const struct nla_policy mptcp_pm_policy[MPTCP_PM_ATTR_MAX + 1] = {
 					NLA_POLICY_NESTED(mptcp_pm_addr_policy),
 	[MPTCP_PM_ATTR_RCV_ADD_ADDRS]	= { .type	= NLA_U32,	},
 	[MPTCP_PM_ATTR_SUBFLOWS]	= { .type	= NLA_U32,	},
+	[MPTCP_PM_ATTR_TOKEN]		= { .type	= NLA_U32,	},
 };
 
 void mptcp_pm_nl_subflow_chk_stale(const struct mptcp_sock *msk, struct sock *ssk)
@@ -1203,9 +1204,9 @@ static int mptcp_pm_parse_pm_addr_attr(struct nlattr *tb[],
 	return err;
 }
 
-static int mptcp_pm_parse_entry(struct nlattr *attr, struct genl_info *info,
-				bool require_family,
-				struct mptcp_pm_addr_entry *entry)
+int mptcp_pm_parse_entry(struct nlattr *attr, struct genl_info *info,
+			 bool require_family,
+			 struct mptcp_pm_addr_entry *entry)
 {
 	struct nlattr *tb[MPTCP_PM_ADDR_ATTR_MAX + 1];
 	int err;
@@ -2198,6 +2199,11 @@ static const struct genl_small_ops mptcp_pm_ops[] = {
 		.doit   = mptcp_nl_cmd_set_flags,
 		.flags  = GENL_ADMIN_PERM,
 	},
+	{
+		.cmd    = MPTCP_PM_CMD_ANNOUNCE,
+		.doit   = mptcp_nl_cmd_announce,
+		.flags  = GENL_ADMIN_PERM,
+	},
 };
 
 static struct genl_family mptcp_genl_family __ro_after_init = {
diff --git a/net/mptcp/pm_userspace.c b/net/mptcp/pm_userspace.c
index 910116b0f5b9..347184a9157b 100644
--- a/net/mptcp/pm_userspace.c
+++ b/net/mptcp/pm_userspace.c
@@ -119,3 +119,64 @@ int mptcp_userspace_pm_get_local_id(struct mptcp_sock *msk,
 
 	return mptcp_userspace_pm_append_new_local_addr(msk, &new_entry);
 }
+
+int mptcp_nl_cmd_announce(struct sk_buff *skb, struct genl_info *info)
+{
+	struct nlattr *token = info->attrs[MPTCP_PM_ATTR_TOKEN];
+	struct nlattr *addr = info->attrs[MPTCP_PM_ATTR_ADDR];
+	struct mptcp_pm_addr_entry addr_val;
+	struct mptcp_sock *msk;
+	int err = -EINVAL;
+	u32 token_val;
+
+	if (!addr || !token) {
+		GENL_SET_ERR_MSG(info, "missing required inputs");
+		return err;
+	}
+
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
+		goto announce_err;
+	}
+
+	err = mptcp_pm_parse_entry(addr, info, true, &addr_val);
+	if (err < 0) {
+		GENL_SET_ERR_MSG(info, "error parsing local address");
+		goto announce_err;
+	}
+
+	if (addr_val.addr.id == 0 || !(addr_val.flags & MPTCP_PM_ADDR_FLAG_SIGNAL)) {
+		GENL_SET_ERR_MSG(info, "invalid addr id or flags");
+		goto announce_err;
+	}
+
+	err = mptcp_userspace_pm_append_new_local_addr(msk, &addr_val);
+	if (err < 0) {
+		GENL_SET_ERR_MSG(info, "did not match address and id");
+		goto announce_err;
+	}
+
+	lock_sock((struct sock *)msk);
+	spin_lock_bh(&msk->pm.lock);
+
+	if (mptcp_pm_alloc_anno_list(msk, &addr_val)) {
+		mptcp_pm_announce_addr(msk, &addr_val.addr, false);
+		mptcp_pm_nl_addr_send_ack(msk);
+	}
+
+	spin_unlock_bh(&msk->pm.lock);
+	release_sock((struct sock *)msk);
+
+	err = 0;
+ announce_err:
+	sock_put((struct sock *)msk);
+	return err;
+}
diff --git a/net/mptcp/protocol.h b/net/mptcp/protocol.h
index 7257dc7aed43..de645efbc806 100644
--- a/net/mptcp/protocol.h
+++ b/net/mptcp/protocol.h
@@ -11,6 +11,7 @@
 #include <net/tcp.h>
 #include <net/inet_connection_sock.h>
 #include <uapi/linux/mptcp.h>
+#include <net/genetlink.h>
 
 #define MPTCP_SUPPORTED_VERSION	1
 
@@ -755,6 +756,9 @@ u16 __mptcp_make_csum(u64 data_seq, u32 subflow_seq, u16 data_len, __wsum sum);
 void __init mptcp_pm_init(void);
 void mptcp_pm_data_init(struct mptcp_sock *msk);
 void mptcp_pm_data_reset(struct mptcp_sock *msk);
+int mptcp_pm_parse_entry(struct nlattr *attr, struct genl_info *info,
+			 bool require_family,
+			 struct mptcp_pm_addr_entry *entry);
 void mptcp_pm_subflow_chk_stale(const struct mptcp_sock *msk, struct sock *ssk);
 void mptcp_pm_nl_subflow_chk_stale(const struct mptcp_sock *msk, struct sock *ssk);
 void mptcp_pm_new_connection(struct mptcp_sock *msk, const struct sock *ssk, int server_side);
@@ -775,6 +779,8 @@ void mptcp_pm_rm_addr_received(struct mptcp_sock *msk,
 			       const struct mptcp_rm_list *rm_list);
 void mptcp_pm_mp_prio_received(struct sock *sk, u8 bkup);
 void mptcp_pm_mp_fail_received(struct sock *sk, u64 fail_seq);
+bool mptcp_pm_alloc_anno_list(struct mptcp_sock *msk,
+			      const struct mptcp_pm_addr_entry *entry);
 void mptcp_pm_free_anno_list(struct mptcp_sock *msk);
 bool mptcp_pm_sport_in_anno_list(struct mptcp_sock *msk, const struct sock *sk);
 struct mptcp_pm_add_entry *
@@ -798,6 +804,7 @@ int mptcp_pm_remove_subflow(struct mptcp_sock *msk, const struct mptcp_rm_list *
 int mptcp_userspace_pm_append_new_local_addr(struct mptcp_sock *msk,
 					     struct mptcp_pm_addr_entry *entry);
 void mptcp_free_local_addr_list(struct mptcp_sock *msk);
+int mptcp_nl_cmd_announce(struct sk_buff *skb, struct genl_info *info);
 
 void mptcp_event(enum mptcp_event_type type, const struct mptcp_sock *msk,
 		 const struct sock *ssk, gfp_t gfp);
-- 
2.36.0

