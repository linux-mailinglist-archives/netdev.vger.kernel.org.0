Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 16E64567963
	for <lists+netdev@lfdr.de>; Tue,  5 Jul 2022 23:32:40 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232122AbiGEVce (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 5 Jul 2022 17:32:34 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:56980 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231304AbiGEVc1 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 5 Jul 2022 17:32:27 -0400
Received: from mga03.intel.com (mga03.intel.com [134.134.136.65])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id A29EA14D03
        for <netdev@vger.kernel.org>; Tue,  5 Jul 2022 14:32:24 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1657056744; x=1688592744;
  h=from:to:cc:subject:date:message-id:in-reply-to:
   references:mime-version:content-transfer-encoding;
  bh=xP1R2dfNPz3sq6+PHPca6seQip9vwHvi5wQWkEIwRBI=;
  b=NVTy01Fw0xCxOcSv+ZwE+wDzG25448XkTYhBXAV24RzIxaJeVIBEaeEF
   vpcYJy9ucuSQaexPX2GQ7lwqsIP8pnUWoDPC1CRpjkrjwT/Kt8bk0ujUh
   7vNiwJR8R1pk1W+iTc8WVrkccASTLsUs0pipBhB61/VYW/T53pxFqH69A
   J9notIlGUeNAChwKGCjf3MlJuCa3E5z3Q1MsONrqiVdLMlS5J42UDtDcV
   onKOpZXdLRcAaGQ8ZlmeX8t6Kxyk8bvs6YUHqP4ROWPuYG/K9yDesfiJR
   SqUvhYqZVuojuGUpU0oxaKx+6dgNx0Wlafbb0981Ndk7sHEeVUh9jJep/
   g==;
X-IronPort-AV: E=McAfee;i="6400,9594,10399"; a="284633932"
X-IronPort-AV: E=Sophos;i="5.92,247,1650956400"; 
   d="scan'208";a="284633932"
Received: from orsmga007.jf.intel.com ([10.7.209.58])
  by orsmga103.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 05 Jul 2022 14:32:22 -0700
X-IronPort-AV: E=Sophos;i="5.92,247,1650956400"; 
   d="scan'208";a="590558748"
Received: from rcenter-mobl.amr.corp.intel.com (HELO mjmartin-desk2.intel.com) ([10.209.17.169])
  by orsmga007-auth.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 05 Jul 2022 14:32:22 -0700
From:   Mat Martineau <mathew.j.martineau@linux.intel.com>
To:     netdev@vger.kernel.org
Cc:     Kishen Maloor <kishen.maloor@intel.com>, davem@davemloft.net,
        kuba@kernel.org, pabeni@redhat.com, edumazet@google.com,
        fw@strlen.de, geliang.tang@suse.com, matthieu.baerts@tessares.net,
        mptcp@lists.linux.dev,
        Mat Martineau <mathew.j.martineau@linux.intel.com>
Subject: [PATCH net 4/7] mptcp: netlink: issue MP_PRIO signals from userspace PMs
Date:   Tue,  5 Jul 2022 14:32:14 -0700
Message-Id: <20220705213217.146898-5-mathew.j.martineau@linux.intel.com>
X-Mailer: git-send-email 2.37.0
In-Reply-To: <20220705213217.146898-1-mathew.j.martineau@linux.intel.com>
References: <20220705213217.146898-1-mathew.j.martineau@linux.intel.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-5.0 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_EF,RCVD_IN_DNSWL_MED,SPF_HELO_NONE,
        SPF_NONE,T_SCC_BODY_TEXT_LINE autolearn=ham autolearn_force=no
        version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Kishen Maloor <kishen.maloor@intel.com>

This change updates MPTCP_PM_CMD_SET_FLAGS to allow userspace PMs
to issue MP_PRIO signals over a specific subflow selected by
the connection token, local and remote address+port.

Closes: https://github.com/multipath-tcp/mptcp_net-next/issues/286
Fixes: 702c2f646d42 ("mptcp: netlink: allow userspace-driven subflow establishment")
Acked-by: Paolo Abeni <pabeni@redhat.com>
Signed-off-by: Kishen Maloor <kishen.maloor@intel.com>
Signed-off-by: Mat Martineau <mathew.j.martineau@linux.intel.com>
---
 net/mptcp/pm_netlink.c   | 30 +++++++++++++++++++++++++-----
 net/mptcp/pm_userspace.c | 30 ++++++++++++++++++++++++++++++
 net/mptcp/protocol.h     |  8 +++++++-
 3 files changed, 62 insertions(+), 6 deletions(-)

diff --git a/net/mptcp/pm_netlink.c b/net/mptcp/pm_netlink.c
index ca86c88f89e0..2da251dd7c00 100644
--- a/net/mptcp/pm_netlink.c
+++ b/net/mptcp/pm_netlink.c
@@ -717,9 +717,10 @@ void mptcp_pm_nl_addr_send_ack(struct mptcp_sock *msk)
 	}
 }
 
-static int mptcp_pm_nl_mp_prio_send_ack(struct mptcp_sock *msk,
-					struct mptcp_addr_info *addr,
-					u8 bkup)
+int mptcp_pm_nl_mp_prio_send_ack(struct mptcp_sock *msk,
+				 struct mptcp_addr_info *addr,
+				 struct mptcp_addr_info *rem,
+				 u8 bkup)
 {
 	struct mptcp_subflow_context *subflow;
 
@@ -727,13 +728,19 @@ static int mptcp_pm_nl_mp_prio_send_ack(struct mptcp_sock *msk,
 
 	mptcp_for_each_subflow(msk, subflow) {
 		struct sock *ssk = mptcp_subflow_tcp_sock(subflow);
-		struct mptcp_addr_info local;
+		struct mptcp_addr_info local, remote;
 		bool slow;
 
 		local_address((struct sock_common *)ssk, &local);
 		if (!mptcp_addresses_equal(&local, addr, addr->port))
 			continue;
 
+		if (rem && rem->family != AF_UNSPEC) {
+			remote_address((struct sock_common *)ssk, &remote);
+			if (!mptcp_addresses_equal(&remote, rem, rem->port))
+				continue;
+		}
+
 		slow = lock_sock_fast(ssk);
 		if (subflow->backup != bkup)
 			msk->last_snd = NULL;
@@ -1837,7 +1844,7 @@ static int mptcp_nl_set_flags(struct net *net,
 
 		lock_sock(sk);
 		if (changed & MPTCP_PM_ADDR_FLAG_BACKUP)
-			ret = mptcp_pm_nl_mp_prio_send_ack(msk, addr, bkup);
+			ret = mptcp_pm_nl_mp_prio_send_ack(msk, addr, NULL, bkup);
 		if (changed & MPTCP_PM_ADDR_FLAG_FULLMESH)
 			mptcp_pm_nl_fullmesh(msk, addr);
 		release_sock(sk);
@@ -1853,6 +1860,9 @@ static int mptcp_nl_set_flags(struct net *net,
 static int mptcp_nl_cmd_set_flags(struct sk_buff *skb, struct genl_info *info)
 {
 	struct mptcp_pm_addr_entry addr = { .addr = { .family = AF_UNSPEC }, }, *entry;
+	struct mptcp_pm_addr_entry remote = { .addr = { .family = AF_UNSPEC }, };
+	struct nlattr *attr_rem = info->attrs[MPTCP_PM_ATTR_ADDR_REMOTE];
+	struct nlattr *token = info->attrs[MPTCP_PM_ATTR_TOKEN];
 	struct nlattr *attr = info->attrs[MPTCP_PM_ATTR_ADDR];
 	struct pm_nl_pernet *pernet = genl_info_pm_nl(info);
 	u8 changed, mask = MPTCP_PM_ADDR_FLAG_BACKUP |
@@ -1865,6 +1875,12 @@ static int mptcp_nl_cmd_set_flags(struct sk_buff *skb, struct genl_info *info)
 	if (ret < 0)
 		return ret;
 
+	if (attr_rem) {
+		ret = mptcp_pm_parse_entry(attr_rem, info, false, &remote);
+		if (ret < 0)
+			return ret;
+	}
+
 	if (addr.flags & MPTCP_PM_ADDR_FLAG_BACKUP)
 		bkup = 1;
 	if (addr.addr.family == AF_UNSPEC) {
@@ -1873,6 +1889,10 @@ static int mptcp_nl_cmd_set_flags(struct sk_buff *skb, struct genl_info *info)
 			return -EOPNOTSUPP;
 	}
 
+	if (token)
+		return mptcp_userspace_pm_set_flags(sock_net(skb->sk),
+						    token, &addr, &remote, bkup);
+
 	spin_lock_bh(&pernet->lock);
 	entry = __lookup_addr(pernet, &addr.addr, lookup_by_id);
 	if (!entry) {
diff --git a/net/mptcp/pm_userspace.c b/net/mptcp/pm_userspace.c
index 26212bebc5ed..51e2f066d54f 100644
--- a/net/mptcp/pm_userspace.c
+++ b/net/mptcp/pm_userspace.c
@@ -420,3 +420,33 @@ int mptcp_nl_cmd_sf_destroy(struct sk_buff *skb, struct genl_info *info)
 	sock_put((struct sock *)msk);
 	return err;
 }
+
+int mptcp_userspace_pm_set_flags(struct net *net, struct nlattr *token,
+				 struct mptcp_pm_addr_entry *loc,
+				 struct mptcp_pm_addr_entry *rem, u8 bkup)
+{
+	struct mptcp_sock *msk;
+	int ret = -EINVAL;
+	u32 token_val;
+
+	token_val = nla_get_u32(token);
+
+	msk = mptcp_token_get_sock(net, token_val);
+	if (!msk)
+		return ret;
+
+	if (!mptcp_pm_is_userspace(msk))
+		goto set_flags_err;
+
+	if (loc->addr.family == AF_UNSPEC ||
+	    rem->addr.family == AF_UNSPEC)
+		goto set_flags_err;
+
+	lock_sock((struct sock *)msk);
+	ret = mptcp_pm_nl_mp_prio_send_ack(msk, &loc->addr, &rem->addr, bkup);
+	release_sock((struct sock *)msk);
+
+set_flags_err:
+	sock_put((struct sock *)msk);
+	return ret;
+}
diff --git a/net/mptcp/protocol.h b/net/mptcp/protocol.h
index 033c995772dc..480c5320b86e 100644
--- a/net/mptcp/protocol.h
+++ b/net/mptcp/protocol.h
@@ -772,6 +772,10 @@ void mptcp_pm_rm_addr_received(struct mptcp_sock *msk,
 			       const struct mptcp_rm_list *rm_list);
 void mptcp_pm_mp_prio_received(struct sock *sk, u8 bkup);
 void mptcp_pm_mp_fail_received(struct sock *sk, u64 fail_seq);
+int mptcp_pm_nl_mp_prio_send_ack(struct mptcp_sock *msk,
+				 struct mptcp_addr_info *addr,
+				 struct mptcp_addr_info *rem,
+				 u8 bkup);
 bool mptcp_pm_alloc_anno_list(struct mptcp_sock *msk,
 			      const struct mptcp_pm_addr_entry *entry);
 void mptcp_pm_free_anno_list(struct mptcp_sock *msk);
@@ -788,7 +792,9 @@ int mptcp_pm_get_flags_and_ifindex_by_id(struct mptcp_sock *msk,
 int mptcp_userspace_pm_get_flags_and_ifindex_by_id(struct mptcp_sock *msk,
 						   unsigned int id,
 						   u8 *flags, int *ifindex);
-
+int mptcp_userspace_pm_set_flags(struct net *net, struct nlattr *token,
+				 struct mptcp_pm_addr_entry *loc,
+				 struct mptcp_pm_addr_entry *rem, u8 bkup);
 int mptcp_pm_announce_addr(struct mptcp_sock *msk,
 			   const struct mptcp_addr_info *addr,
 			   bool echo);
-- 
2.37.0

