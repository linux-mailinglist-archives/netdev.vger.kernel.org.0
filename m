Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 607E8519590
	for <lists+netdev@lfdr.de>; Wed,  4 May 2022 04:39:38 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1344117AbiEDCm5 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 3 May 2022 22:42:57 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:50332 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1344057AbiEDCmq (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 3 May 2022 22:42:46 -0400
Received: from mga14.intel.com (mga14.intel.com [192.55.52.115])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 072291FCDB
        for <netdev@vger.kernel.org>; Tue,  3 May 2022 19:39:12 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1651631951; x=1683167951;
  h=from:to:cc:subject:date:message-id:in-reply-to:
   references:mime-version:content-transfer-encoding;
  bh=0aroYytyngXIMB8Yt7q+wNPFeHzHcQa3q5lptV09EWE=;
  b=kejeX0acMb0KFqX02StXqvTH4ViAHKD8EH0Vrr8pegEhvY8ykAh4JivI
   HHXUYWE0IstVFUSnqBK1e33K8tGpONDq1YPzbg1CKwKnTFtVOsl4b72JT
   UkR9jPxjJRyXRdu3+eqfhkxSS1IfZ1dJN2DfxLxsHl74VElSge7U3GZmV
   +UXVEfzWfqwgfOeFUvdHU0hu4Fzq249Uj+B7gHiFDYOPjQtZ7JuDsIs2L
   gRFL91AiDXwB3Ks5jaueqqQOLLfIMKerGWq5AlrE1EI4eweRQKCx4a1Eo
   OpQS+rawSr1kISgfe2cZxGE5q6riyGYK1RtnpJZRMpTX0ekFW/SxjjGcH
   A==;
X-IronPort-AV: E=McAfee;i="6400,9594,10336"; a="267799847"
X-IronPort-AV: E=Sophos;i="5.91,196,1647327600"; 
   d="scan'208";a="267799847"
Received: from orsmga008.jf.intel.com ([10.7.209.65])
  by fmsmga103.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 03 May 2022 19:39:08 -0700
X-IronPort-AV: E=Sophos;i="5.91,196,1647327600"; 
   d="scan'208";a="584493390"
Received: from mjmartin-desk2.amr.corp.intel.com (HELO mjmartin-desk2.intel.com) ([10.251.20.240])
  by orsmga008-auth.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 03 May 2022 19:39:08 -0700
From:   Mat Martineau <mathew.j.martineau@linux.intel.com>
To:     netdev@vger.kernel.org
Cc:     Florian Westphal <fw@strlen.de>, davem@davemloft.net,
        kuba@kernel.org, pabeni@redhat.com, edumazet@google.com,
        matthieu.baerts@tessares.net, mptcp@lists.linux.dev,
        Kishen Maloor <kishen.maloor@intel.com>,
        Mat Martineau <mathew.j.martineau@linux.intel.com>
Subject: [PATCH net-next 08/13] mptcp: netlink: allow userspace-driven subflow establishment
Date:   Tue,  3 May 2022 19:38:56 -0700
Message-Id: <20220504023901.277012-9-mathew.j.martineau@linux.intel.com>
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

From: Florian Westphal <fw@strlen.de>

This allows userspace to tell kernel to add a new subflow to an existing
mptcp connection.

Userspace provides the token to identify the mptcp-level connection
that needs a change in active subflows and the local and remote
addresses of the new or the to-be-removed subflow.

MPTCP_PM_CMD_SUBFLOW_CREATE requires the following parameters:
{ token, { loc_id, family, loc_addr4 | loc_addr6 }, { family, rem_addr4 |
rem_addr6, rem_port }

MPTCP_PM_CMD_SUBFLOW_DESTROY requires the following parameters:
{ token, { family, loc_addr4 | loc_addr6, loc_port }, { family, rem_addr4 |
rem_addr6, rem_port }

Acked-by: Paolo Abeni <pabeni@redhat.com>
Co-developed-by: Kishen Maloor <kishen.maloor@intel.com>
Signed-off-by: Kishen Maloor <kishen.maloor@intel.com>
Signed-off-by: Florian Westphal <fw@strlen.de>
Signed-off-by: Mat Martineau <mathew.j.martineau@linux.intel.com>
---
 include/uapi/linux/mptcp.h |   3 +
 net/mptcp/pm_netlink.c     |  22 +++++
 net/mptcp/pm_userspace.c   | 185 +++++++++++++++++++++++++++++++++++++
 net/mptcp/protocol.h       |   4 +
 4 files changed, 214 insertions(+)

diff --git a/include/uapi/linux/mptcp.h b/include/uapi/linux/mptcp.h
index 11f9fa001a3c..921963589904 100644
--- a/include/uapi/linux/mptcp.h
+++ b/include/uapi/linux/mptcp.h
@@ -57,6 +57,7 @@ enum {
 	MPTCP_PM_ATTR_SUBFLOWS,				/* u32 */
 	MPTCP_PM_ATTR_TOKEN,				/* u32 */
 	MPTCP_PM_ATTR_LOC_ID,				/* u8 */
+	MPTCP_PM_ATTR_ADDR_REMOTE,			/* nested address */
 
 	__MPTCP_PM_ATTR_MAX
 };
@@ -97,6 +98,8 @@ enum {
 	MPTCP_PM_CMD_SET_FLAGS,
 	MPTCP_PM_CMD_ANNOUNCE,
 	MPTCP_PM_CMD_REMOVE,
+	MPTCP_PM_CMD_SUBFLOW_CREATE,
+	MPTCP_PM_CMD_SUBFLOW_DESTROY,
 
 	__MPTCP_PM_CMD_AFTER_LAST
 };
diff --git a/net/mptcp/pm_netlink.c b/net/mptcp/pm_netlink.c
index a26750f19f65..e099f2a12504 100644
--- a/net/mptcp/pm_netlink.c
+++ b/net/mptcp/pm_netlink.c
@@ -1096,6 +1096,8 @@ static const struct nla_policy mptcp_pm_policy[MPTCP_PM_ATTR_MAX + 1] = {
 	[MPTCP_PM_ATTR_SUBFLOWS]	= { .type	= NLA_U32,	},
 	[MPTCP_PM_ATTR_TOKEN]		= { .type	= NLA_U32,	},
 	[MPTCP_PM_ATTR_LOC_ID]		= { .type	= NLA_U8,	},
+	[MPTCP_PM_ATTR_ADDR_REMOTE]	=
+					NLA_POLICY_NESTED(mptcp_pm_addr_policy),
 };
 
 void mptcp_pm_nl_subflow_chk_stale(const struct mptcp_sock *msk, struct sock *ssk)
@@ -1205,6 +1207,16 @@ static int mptcp_pm_parse_pm_addr_attr(struct nlattr *tb[],
 	return err;
 }
 
+int mptcp_pm_parse_addr(struct nlattr *attr, struct genl_info *info,
+			struct mptcp_addr_info *addr)
+{
+	struct nlattr *tb[MPTCP_PM_ADDR_ATTR_MAX + 1];
+
+	memset(addr, 0, sizeof(*addr));
+
+	return mptcp_pm_parse_pm_addr_attr(tb, attr, info, addr, true);
+}
+
 int mptcp_pm_parse_entry(struct nlattr *attr, struct genl_info *info,
 			 bool require_family,
 			 struct mptcp_pm_addr_entry *entry)
@@ -2210,6 +2222,16 @@ static const struct genl_small_ops mptcp_pm_ops[] = {
 		.doit   = mptcp_nl_cmd_remove,
 		.flags  = GENL_ADMIN_PERM,
 	},
+	{
+		.cmd    = MPTCP_PM_CMD_SUBFLOW_CREATE,
+		.doit   = mptcp_nl_cmd_sf_create,
+		.flags  = GENL_ADMIN_PERM,
+	},
+	{
+		.cmd    = MPTCP_PM_CMD_SUBFLOW_DESTROY,
+		.doit   = mptcp_nl_cmd_sf_destroy,
+		.flags  = GENL_ADMIN_PERM,
+	},
 };
 
 static struct genl_family mptcp_genl_family __ro_after_init = {
diff --git a/net/mptcp/pm_userspace.c b/net/mptcp/pm_userspace.c
index 3a42c9e66126..f56378e4f597 100644
--- a/net/mptcp/pm_userspace.c
+++ b/net/mptcp/pm_userspace.c
@@ -242,3 +242,188 @@ int mptcp_nl_cmd_remove(struct sk_buff *skb, struct genl_info *info)
 	sock_put((struct sock *)msk);
 	return err;
 }
+
+int mptcp_nl_cmd_sf_create(struct sk_buff *skb, struct genl_info *info)
+{
+	struct nlattr *raddr = info->attrs[MPTCP_PM_ATTR_ADDR_REMOTE];
+	struct nlattr *token = info->attrs[MPTCP_PM_ATTR_TOKEN];
+	struct nlattr *laddr = info->attrs[MPTCP_PM_ATTR_ADDR];
+	struct mptcp_addr_info addr_r;
+	struct mptcp_addr_info addr_l;
+	struct mptcp_sock *msk;
+	int err = -EINVAL;
+	struct sock *sk;
+	u32 token_val;
+
+	if (!laddr || !raddr || !token) {
+		GENL_SET_ERR_MSG(info, "missing required inputs");
+		return err;
+	}
+
+	token_val = nla_get_u32(token);
+
+	msk = mptcp_token_get_sock(genl_info_net(info), token_val);
+	if (!msk) {
+		NL_SET_ERR_MSG_ATTR(info->extack, token, "invalid token");
+		return err;
+	}
+
+	if (!mptcp_pm_is_userspace(msk)) {
+		GENL_SET_ERR_MSG(info, "invalid request; userspace PM not selected");
+		goto create_err;
+	}
+
+	err = mptcp_pm_parse_addr(laddr, info, &addr_l);
+	if (err < 0) {
+		NL_SET_ERR_MSG_ATTR(info->extack, laddr, "error parsing local addr");
+		goto create_err;
+	}
+
+	if (addr_l.id == 0) {
+		NL_SET_ERR_MSG_ATTR(info->extack, laddr, "missing local addr id");
+		goto create_err;
+	}
+
+	err = mptcp_pm_parse_addr(raddr, info, &addr_r);
+	if (err < 0) {
+		NL_SET_ERR_MSG_ATTR(info->extack, raddr, "error parsing remote addr");
+		goto create_err;
+	}
+
+	sk = &msk->sk.icsk_inet.sk;
+	lock_sock(sk);
+
+	err = __mptcp_subflow_connect(sk, &addr_l, &addr_r);
+
+	release_sock(sk);
+
+ create_err:
+	sock_put((struct sock *)msk);
+	return err;
+}
+
+static struct sock *mptcp_nl_find_ssk(struct mptcp_sock *msk,
+				      const struct mptcp_addr_info *local,
+				      const struct mptcp_addr_info *remote)
+{
+	struct sock *sk = &msk->sk.icsk_inet.sk;
+	struct mptcp_subflow_context *subflow;
+	struct sock *found = NULL;
+
+	if (local->family != remote->family)
+		return NULL;
+
+	lock_sock(sk);
+
+	mptcp_for_each_subflow(msk, subflow) {
+		const struct inet_sock *issk;
+		struct sock *ssk;
+
+		ssk = mptcp_subflow_tcp_sock(subflow);
+
+		if (local->family != ssk->sk_family)
+			continue;
+
+		issk = inet_sk(ssk);
+
+		switch (ssk->sk_family) {
+		case AF_INET:
+			if (issk->inet_saddr != local->addr.s_addr ||
+			    issk->inet_daddr != remote->addr.s_addr)
+				continue;
+			break;
+#if IS_ENABLED(CONFIG_MPTCP_IPV6)
+		case AF_INET6: {
+			const struct ipv6_pinfo *pinfo = inet6_sk(ssk);
+
+			if (!ipv6_addr_equal(&local->addr6, &pinfo->saddr) ||
+			    !ipv6_addr_equal(&remote->addr6, &ssk->sk_v6_daddr))
+				continue;
+			break;
+		}
+#endif
+		default:
+			continue;
+		}
+
+		if (issk->inet_sport == local->port &&
+		    issk->inet_dport == remote->port) {
+			found = ssk;
+			goto found;
+		}
+	}
+
+found:
+	release_sock(sk);
+
+	return found;
+}
+
+int mptcp_nl_cmd_sf_destroy(struct sk_buff *skb, struct genl_info *info)
+{
+	struct nlattr *raddr = info->attrs[MPTCP_PM_ATTR_ADDR_REMOTE];
+	struct nlattr *token = info->attrs[MPTCP_PM_ATTR_TOKEN];
+	struct nlattr *laddr = info->attrs[MPTCP_PM_ATTR_ADDR];
+	struct mptcp_addr_info addr_l;
+	struct mptcp_addr_info addr_r;
+	struct mptcp_sock *msk;
+	struct sock *sk, *ssk;
+	int err = -EINVAL;
+	u32 token_val;
+
+	if (!laddr || !raddr || !token) {
+		GENL_SET_ERR_MSG(info, "missing required inputs");
+		return err;
+	}
+
+	token_val = nla_get_u32(token);
+
+	msk = mptcp_token_get_sock(genl_info_net(info), token_val);
+	if (!msk) {
+		NL_SET_ERR_MSG_ATTR(info->extack, token, "invalid token");
+		return err;
+	}
+
+	if (!mptcp_pm_is_userspace(msk)) {
+		GENL_SET_ERR_MSG(info, "invalid request; userspace PM not selected");
+		goto destroy_err;
+	}
+
+	err = mptcp_pm_parse_addr(laddr, info, &addr_l);
+	if (err < 0) {
+		NL_SET_ERR_MSG_ATTR(info->extack, laddr, "error parsing local addr");
+		goto destroy_err;
+	}
+
+	err = mptcp_pm_parse_addr(raddr, info, &addr_r);
+	if (err < 0) {
+		NL_SET_ERR_MSG_ATTR(info->extack, raddr, "error parsing remote addr");
+		goto destroy_err;
+	}
+
+	if (addr_l.family != addr_r.family) {
+		GENL_SET_ERR_MSG(info, "address families do not match");
+		goto destroy_err;
+	}
+
+	if (!addr_l.port || !addr_r.port) {
+		GENL_SET_ERR_MSG(info, "missing local or remote port");
+		goto destroy_err;
+	}
+
+	sk = &msk->sk.icsk_inet.sk;
+	ssk = mptcp_nl_find_ssk(msk, &addr_l, &addr_r);
+	if (ssk) {
+		struct mptcp_subflow_context *subflow = mptcp_subflow_ctx(ssk);
+
+		mptcp_subflow_shutdown(sk, ssk, RCV_SHUTDOWN | SEND_SHUTDOWN);
+		mptcp_close_ssk(sk, ssk, subflow);
+		err = 0;
+	} else {
+		err = -ESRCH;
+	}
+
+ destroy_err:
+	sock_put((struct sock *)msk);
+	return err;
+}
diff --git a/net/mptcp/protocol.h b/net/mptcp/protocol.h
index 4026aa3df7f4..f542aeaa5b09 100644
--- a/net/mptcp/protocol.h
+++ b/net/mptcp/protocol.h
@@ -756,6 +756,8 @@ u16 __mptcp_make_csum(u64 data_seq, u32 subflow_seq, u16 data_len, __wsum sum);
 void __init mptcp_pm_init(void);
 void mptcp_pm_data_init(struct mptcp_sock *msk);
 void mptcp_pm_data_reset(struct mptcp_sock *msk);
+int mptcp_pm_parse_addr(struct nlattr *attr, struct genl_info *info,
+			struct mptcp_addr_info *addr);
 int mptcp_pm_parse_entry(struct nlattr *attr, struct genl_info *info,
 			 bool require_family,
 			 struct mptcp_pm_addr_entry *entry);
@@ -809,6 +811,8 @@ int mptcp_userspace_pm_append_new_local_addr(struct mptcp_sock *msk,
 void mptcp_free_local_addr_list(struct mptcp_sock *msk);
 int mptcp_nl_cmd_announce(struct sk_buff *skb, struct genl_info *info);
 int mptcp_nl_cmd_remove(struct sk_buff *skb, struct genl_info *info);
+int mptcp_nl_cmd_sf_create(struct sk_buff *skb, struct genl_info *info);
+int mptcp_nl_cmd_sf_destroy(struct sk_buff *skb, struct genl_info *info);
 
 void mptcp_event(enum mptcp_event_type type, const struct mptcp_sock *msk,
 		 const struct sock *ssk, gfp_t gfp);
-- 
2.36.0

