Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id B858F5178A0
	for <lists+netdev@lfdr.de>; Mon,  2 May 2022 22:53:23 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1387535AbiEBU40 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 2 May 2022 16:56:26 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:43266 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1387524AbiEBU4P (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 2 May 2022 16:56:15 -0400
Received: from mga05.intel.com (mga05.intel.com [192.55.52.43])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id DB59F65A5
        for <netdev@vger.kernel.org>; Mon,  2 May 2022 13:52:45 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1651524765; x=1683060765;
  h=from:to:cc:subject:date:message-id:in-reply-to:
   references:mime-version:content-transfer-encoding;
  bh=eAce9c3mqUkERzSO2pr1Yle5fx831jjiezcbospqV1Y=;
  b=mL52lTCJsncXb8LJOmsVk9up3hy7O9lCi8MKKtlammPTwD575r7Wx4R8
   Coh+CiH6iKnWVSs4ZBPmFcsLDrBGFWZqjUH2YR4P6OAGlf6jkNMECzXfH
   s071oO0U3X3TjBNiGfyZFL5X6npB5HwPyVWALFl/nDJ1xnPlY86H2Fo8x
   aTy/9+sy0629hv2/Kf2Z0CE/jPmqt5eJ53a0TYMgCgWMKvs8MHEuNvUfQ
   N5EgV+GytgNum8U78n/OyXYvhB4xhVO5uyKPtFmCU5VeSkSOKmrMs45fU
   9GJjsgN46+ycrM6tZtntY1NnFNUuzXQu1gdL5fpiRx9fn8pX6tfk2SnsD
   Q==;
X-IronPort-AV: E=McAfee;i="6400,9594,10335"; a="353761114"
X-IronPort-AV: E=Sophos;i="5.91,193,1647327600"; 
   d="scan'208";a="353761114"
Received: from orsmga005.jf.intel.com ([10.7.209.41])
  by fmsmga105.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 02 May 2022 13:52:44 -0700
X-IronPort-AV: E=Sophos;i="5.91,193,1647327600"; 
   d="scan'208";a="733619578"
Received: from mjmartin-desk2.amr.corp.intel.com (HELO mjmartin-desk2.intel.com) ([10.212.141.55])
  by orsmga005-auth.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 02 May 2022 13:52:43 -0700
From:   Mat Martineau <mathew.j.martineau@linux.intel.com>
To:     netdev@vger.kernel.org
Cc:     Kishen Maloor <kishen.maloor@intel.com>, davem@davemloft.net,
        kuba@kernel.org, pabeni@redhat.com, matthieu.baerts@tessares.net,
        mptcp@lists.linux.dev,
        Mat Martineau <mathew.j.martineau@linux.intel.com>
Subject: [PATCH net-next 4/7] mptcp: reflect remote port (not 0) in ANNOUNCED events
Date:   Mon,  2 May 2022 13:52:34 -0700
Message-Id: <20220502205237.129297-5-mathew.j.martineau@linux.intel.com>
X-Mailer: git-send-email 2.36.0
In-Reply-To: <20220502205237.129297-1-mathew.j.martineau@linux.intel.com>
References: <20220502205237.129297-1-mathew.j.martineau@linux.intel.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-4.9 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_EF,RCVD_IN_DNSWL_MED,SPF_HELO_NONE,
        SPF_NONE,T_SCC_BODY_TEXT_LINE autolearn=ham autolearn_force=no
        version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Kishen Maloor <kishen.maloor@intel.com>

Per RFC 8684, if no port is specified in an ADD_ADDR message, MPTCP
SHOULD attempt to connect to the specified address on the same port
as the port that is already in use by the subflow on which the
ADD_ADDR signal was sent.

To facilitate that, this change reflects the specific remote port in
use by that subflow in MPTCP_EVENT_ANNOUNCED events.

Acked-by: Paolo Abeni <pabeni@redhat.com>
Signed-off-by: Kishen Maloor <kishen.maloor@intel.com>
Signed-off-by: Mat Martineau <mathew.j.martineau@linux.intel.com>
---
 net/mptcp/options.c    |  2 +-
 net/mptcp/pm.c         |  6 ++++--
 net/mptcp/pm_netlink.c | 11 ++++++++---
 net/mptcp/protocol.h   |  4 ++--
 4 files changed, 15 insertions(+), 8 deletions(-)

diff --git a/net/mptcp/options.c b/net/mptcp/options.c
index 88f4ebbd6515..c9625fea3ef9 100644
--- a/net/mptcp/options.c
+++ b/net/mptcp/options.c
@@ -1133,7 +1133,7 @@ bool mptcp_incoming_options(struct sock *sk, struct sk_buff *skb)
 		if ((mp_opt.suboptions & OPTION_MPTCP_ADD_ADDR) &&
 		    add_addr_hmac_valid(msk, &mp_opt)) {
 			if (!mp_opt.echo) {
-				mptcp_pm_add_addr_received(msk, &mp_opt.addr);
+				mptcp_pm_add_addr_received(sk, &mp_opt.addr);
 				MPTCP_INC_STATS(sock_net(sk), MPTCP_MIB_ADDADDR);
 			} else {
 				mptcp_pm_add_addr_echoed(msk, &mp_opt.addr);
diff --git a/net/mptcp/pm.c b/net/mptcp/pm.c
index 8df9cb28d970..5d6832c4d9f2 100644
--- a/net/mptcp/pm.c
+++ b/net/mptcp/pm.c
@@ -200,15 +200,17 @@ void mptcp_pm_subflow_check_next(struct mptcp_sock *msk, const struct sock *ssk,
 	spin_unlock_bh(&pm->lock);
 }
 
-void mptcp_pm_add_addr_received(struct mptcp_sock *msk,
+void mptcp_pm_add_addr_received(const struct sock *ssk,
 				const struct mptcp_addr_info *addr)
 {
+	struct mptcp_subflow_context *subflow = mptcp_subflow_ctx(ssk);
+	struct mptcp_sock *msk = mptcp_sk(subflow->conn);
 	struct mptcp_pm_data *pm = &msk->pm;
 
 	pr_debug("msk=%p remote_id=%d accept=%d", msk, addr->id,
 		 READ_ONCE(pm->accept_addr));
 
-	mptcp_event_addr_announced(msk, addr);
+	mptcp_event_addr_announced(ssk, addr);
 
 	spin_lock_bh(&pm->lock);
 
diff --git a/net/mptcp/pm_netlink.c b/net/mptcp/pm_netlink.c
index d2b63529bfee..eeaa96bcae6c 100644
--- a/net/mptcp/pm_netlink.c
+++ b/net/mptcp/pm_netlink.c
@@ -2019,10 +2019,12 @@ void mptcp_event_addr_removed(const struct mptcp_sock *msk, uint8_t id)
 	kfree_skb(skb);
 }
 
-void mptcp_event_addr_announced(const struct mptcp_sock *msk,
+void mptcp_event_addr_announced(const struct sock *ssk,
 				const struct mptcp_addr_info *info)
 {
-	struct net *net = sock_net((const struct sock *)msk);
+	struct mptcp_subflow_context *subflow = mptcp_subflow_ctx(ssk);
+	struct mptcp_sock *msk = mptcp_sk(subflow->conn);
+	struct net *net = sock_net(ssk);
 	struct nlmsghdr *nlh;
 	struct sk_buff *skb;
 
@@ -2044,7 +2046,10 @@ void mptcp_event_addr_announced(const struct mptcp_sock *msk,
 	if (nla_put_u8(skb, MPTCP_ATTR_REM_ID, info->id))
 		goto nla_put_failure;
 
-	if (nla_put_be16(skb, MPTCP_ATTR_DPORT, info->port))
+	if (nla_put_be16(skb, MPTCP_ATTR_DPORT,
+			 info->port == 0 ?
+			 inet_sk(ssk)->inet_dport :
+			 info->port))
 		goto nla_put_failure;
 
 	switch (info->family) {
diff --git a/net/mptcp/protocol.h b/net/mptcp/protocol.h
index 85390146944d..a762b789f5ab 100644
--- a/net/mptcp/protocol.h
+++ b/net/mptcp/protocol.h
@@ -753,7 +753,7 @@ void mptcp_pm_subflow_established(struct mptcp_sock *msk);
 bool mptcp_pm_nl_check_work_pending(struct mptcp_sock *msk);
 void mptcp_pm_subflow_check_next(struct mptcp_sock *msk, const struct sock *ssk,
 				 const struct mptcp_subflow_context *subflow);
-void mptcp_pm_add_addr_received(struct mptcp_sock *msk,
+void mptcp_pm_add_addr_received(const struct sock *ssk,
 				const struct mptcp_addr_info *addr);
 void mptcp_pm_add_addr_echoed(struct mptcp_sock *msk,
 			      const struct mptcp_addr_info *addr);
@@ -782,7 +782,7 @@ int mptcp_pm_remove_subflow(struct mptcp_sock *msk, const struct mptcp_rm_list *
 
 void mptcp_event(enum mptcp_event_type type, const struct mptcp_sock *msk,
 		 const struct sock *ssk, gfp_t gfp);
-void mptcp_event_addr_announced(const struct mptcp_sock *msk, const struct mptcp_addr_info *info);
+void mptcp_event_addr_announced(const struct sock *ssk, const struct mptcp_addr_info *info);
 void mptcp_event_addr_removed(const struct mptcp_sock *msk, u8 id);
 bool mptcp_userspace_pm_active(const struct mptcp_sock *msk);
 
-- 
2.36.0

