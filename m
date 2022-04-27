Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id B9EE7512596
	for <lists+netdev@lfdr.de>; Thu, 28 Apr 2022 00:51:52 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232741AbiD0Wxr (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 27 Apr 2022 18:53:47 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:59876 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S237828AbiD0Wx1 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 27 Apr 2022 18:53:27 -0400
Received: from mga03.intel.com (mga03.intel.com [134.134.136.65])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 9E62B84EEF
        for <netdev@vger.kernel.org>; Wed, 27 Apr 2022 15:50:14 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1651099814; x=1682635814;
  h=from:to:cc:subject:date:message-id:in-reply-to:
   references:mime-version:content-transfer-encoding;
  bh=1dxqKj8jB6PC1cX01WR8FZdqdf7hC/30ayF8nyz7FU4=;
  b=dqAhZoH1jopRh37ZyD0LkRNPkE40cI3YfOp7PousYrF1En/4fkSJCwoj
   NKH9nfhshWH+LwuAB1FanNmkt4/w5ARKfOeGHr4ViSVDK/BhVEoNTPoVa
   HQ1KuhBSYwFOos+iMzkqyInkSN7PGoiUVTAKcr03kDU18857xrLp7Tkn0
   BQF9CJ/U3MW2MmX1FTacI78TpEMU5jR61gAtjI5GzENFU7a5yirRGVa++
   WOw5NMAZNxTCBiqe3T1IgW1hvW5OKvr/hX5m/c3cPokb0hkOYl8ShjRtH
   l8tntfi9Vl08J0FQ1YQM/JYVJHcLVfXv+06GYOd1pUINy+EUn1gMtUYsd
   g==;
X-IronPort-AV: E=McAfee;i="6400,9594,10330"; a="265907654"
X-IronPort-AV: E=Sophos;i="5.90,294,1643702400"; 
   d="scan'208";a="265907654"
Received: from orsmga005.jf.intel.com ([10.7.209.41])
  by orsmga103.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 27 Apr 2022 15:50:10 -0700
X-IronPort-AV: E=Sophos;i="5.90,294,1643702400"; 
   d="scan'208";a="731049122"
Received: from mjmartin-desk2.amr.corp.intel.com (HELO mjmartin-desk2.intel.com) ([10.212.233.139])
  by orsmga005-auth.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 27 Apr 2022 15:50:10 -0700
From:   Mat Martineau <mathew.j.martineau@linux.intel.com>
To:     netdev@vger.kernel.org
Cc:     Mat Martineau <mathew.j.martineau@linux.intel.com>,
        davem@davemloft.net, kuba@kernel.org, pabeni@redhat.com,
        matthieu.baerts@tessares.net, mptcp@lists.linux.dev
Subject: [PATCH net-next 5/6] mptcp: Add a per-namespace sysctl to set the default path manager type
Date:   Wed, 27 Apr 2022 15:50:01 -0700
Message-Id: <20220427225002.231996-6-mathew.j.martineau@linux.intel.com>
X-Mailer: git-send-email 2.36.0
In-Reply-To: <20220427225002.231996-1-mathew.j.martineau@linux.intel.com>
References: <20220427225002.231996-1-mathew.j.martineau@linux.intel.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-4.9 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_EF,RCVD_IN_DNSWL_MED,SPF_HELO_NONE,
        SPF_NONE autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

The new net.mptcp.pm_type sysctl determines which path manager will be
used by each newly-created MPTCP socket.

v2: Handle builds without CONFIG_SYSCTL
v3: Clarify logic for type-specific PM init (Geliang Tang and Paolo Abeni)

Acked-by: Paolo Abeni <pabeni@redhat.com>
Signed-off-by: Mat Martineau <mathew.j.martineau@linux.intel.com>
---
 Documentation/networking/mptcp-sysctl.rst | 18 ++++++++++++
 net/mptcp/ctrl.c                          | 21 ++++++++++++++
 net/mptcp/pm.c                            | 34 +++++++++++++++--------
 net/mptcp/protocol.h                      |  1 +
 4 files changed, 63 insertions(+), 11 deletions(-)

diff --git a/Documentation/networking/mptcp-sysctl.rst b/Documentation/networking/mptcp-sysctl.rst
index b0d4da71e68e..e263dfcc4b40 100644
--- a/Documentation/networking/mptcp-sysctl.rst
+++ b/Documentation/networking/mptcp-sysctl.rst
@@ -46,6 +46,24 @@ allow_join_initial_addr_port - BOOLEAN
 
 	Default: 1
 
+pm_type - INTEGER
+
+	Set the default path manager type to use for each new MPTCP
+	socket. In-kernel path management will control subflow
+	connections and address advertisements according to
+	per-namespace values configured over the MPTCP netlink
+	API. Userspace path management puts per-MPTCP-connection subflow
+	connection decisions and address advertisements under control of
+	a privileged userspace program, at the cost of more netlink
+	traffic to propagate all of the related events and commands.
+
+	This is a per-namespace sysctl.
+
+	* 0 - In-kernel path manager
+	* 1 - Userspace path manager
+
+	Default: 0
+
 stale_loss_cnt - INTEGER
 	The number of MPTCP-level retransmission intervals with no traffic and
 	pending outstanding data on a given subflow required to declare it stale.
diff --git a/net/mptcp/ctrl.c b/net/mptcp/ctrl.c
index 8b235468c88f..ae20b7d92e28 100644
--- a/net/mptcp/ctrl.c
+++ b/net/mptcp/ctrl.c
@@ -16,6 +16,11 @@
 #define MPTCP_SYSCTL_PATH "net/mptcp"
 
 static int mptcp_pernet_id;
+
+#ifdef CONFIG_SYSCTL
+static int mptcp_pm_type_max = __MPTCP_PM_TYPE_MAX;
+#endif
+
 struct mptcp_pernet {
 #ifdef CONFIG_SYSCTL
 	struct ctl_table_header *ctl_table_hdr;
@@ -26,6 +31,7 @@ struct mptcp_pernet {
 	u8 mptcp_enabled;
 	u8 checksum_enabled;
 	u8 allow_join_initial_addr_port;
+	u8 pm_type;
 };
 
 static struct mptcp_pernet *mptcp_get_pernet(const struct net *net)
@@ -58,6 +64,11 @@ unsigned int mptcp_stale_loss_cnt(const struct net *net)
 	return mptcp_get_pernet(net)->stale_loss_cnt;
 }
 
+int mptcp_get_pm_type(const struct net *net)
+{
+	return mptcp_get_pernet(net)->pm_type;
+}
+
 static void mptcp_pernet_set_defaults(struct mptcp_pernet *pernet)
 {
 	pernet->mptcp_enabled = 1;
@@ -65,6 +76,7 @@ static void mptcp_pernet_set_defaults(struct mptcp_pernet *pernet)
 	pernet->checksum_enabled = 0;
 	pernet->allow_join_initial_addr_port = 1;
 	pernet->stale_loss_cnt = 4;
+	pernet->pm_type = MPTCP_PM_TYPE_KERNEL;
 }
 
 #ifdef CONFIG_SYSCTL
@@ -108,6 +120,14 @@ static struct ctl_table mptcp_sysctl_table[] = {
 		.mode = 0644,
 		.proc_handler = proc_douintvec_minmax,
 	},
+	{
+		.procname = "pm_type",
+		.maxlen = sizeof(u8),
+		.mode = 0644,
+		.proc_handler = proc_dou8vec_minmax,
+		.extra1       = SYSCTL_ZERO,
+		.extra2       = &mptcp_pm_type_max
+	},
 	{}
 };
 
@@ -128,6 +148,7 @@ static int mptcp_pernet_new_table(struct net *net, struct mptcp_pernet *pernet)
 	table[2].data = &pernet->checksum_enabled;
 	table[3].data = &pernet->allow_join_initial_addr_port;
 	table[4].data = &pernet->stale_loss_cnt;
+	table[5].data = &pernet->pm_type;
 
 	hdr = register_net_sysctl(net, MPTCP_SYSCTL_PATH, table);
 	if (!hdr)
diff --git a/net/mptcp/pm.c b/net/mptcp/pm.c
index 5320270b3926..57f67578a47f 100644
--- a/net/mptcp/pm.c
+++ b/net/mptcp/pm.c
@@ -415,7 +415,7 @@ void mptcp_pm_subflow_chk_stale(const struct mptcp_sock *msk, struct sock *ssk)
 
 void mptcp_pm_data_reset(struct mptcp_sock *msk)
 {
-	bool subflows_allowed = !!mptcp_pm_get_subflows_max(msk);
+	u8 pm_type = mptcp_get_pm_type(sock_net((struct sock *)msk));
 	struct mptcp_pm_data *pm = &msk->pm;
 
 	pm->add_addr_signaled = 0;
@@ -424,17 +424,29 @@ void mptcp_pm_data_reset(struct mptcp_sock *msk)
 	pm->subflows = 0;
 	pm->rm_list_tx.nr = 0;
 	pm->rm_list_rx.nr = 0;
-	WRITE_ONCE(pm->pm_type, MPTCP_PM_TYPE_KERNEL);
-	/* pm->work_pending must be only be set to 'true' when
-	 * pm->pm_type is set to MPTCP_PM_TYPE_KERNEL
-	 */
-	WRITE_ONCE(pm->work_pending,
-		   (!!mptcp_pm_get_local_addr_max(msk) && subflows_allowed) ||
-		   !!mptcp_pm_get_add_addr_signal_max(msk));
+	WRITE_ONCE(pm->pm_type, pm_type);
+
+	if (pm_type == MPTCP_PM_TYPE_KERNEL) {
+		bool subflows_allowed = !!mptcp_pm_get_subflows_max(msk);
+
+		/* pm->work_pending must be only be set to 'true' when
+		 * pm->pm_type is set to MPTCP_PM_TYPE_KERNEL
+		 */
+		WRITE_ONCE(pm->work_pending,
+			   (!!mptcp_pm_get_local_addr_max(msk) &&
+			    subflows_allowed) ||
+			   !!mptcp_pm_get_add_addr_signal_max(msk));
+		WRITE_ONCE(pm->accept_addr,
+			   !!mptcp_pm_get_add_addr_accept_max(msk) &&
+			   subflows_allowed);
+		WRITE_ONCE(pm->accept_subflow, subflows_allowed);
+	} else {
+		WRITE_ONCE(pm->work_pending, 0);
+		WRITE_ONCE(pm->accept_addr, 0);
+		WRITE_ONCE(pm->accept_subflow, 0);
+	}
+
 	WRITE_ONCE(pm->addr_signal, 0);
-	WRITE_ONCE(pm->accept_addr,
-		   !!mptcp_pm_get_add_addr_accept_max(msk) && subflows_allowed);
-	WRITE_ONCE(pm->accept_subflow, subflows_allowed);
 	WRITE_ONCE(pm->remote_deny_join_id0, false);
 	pm->status = 0;
 	bitmap_fill(msk->pm.id_avail_bitmap, MPTCP_PM_MAX_ADDR_ID + 1);
diff --git a/net/mptcp/protocol.h b/net/mptcp/protocol.h
index 79606e9d3f2a..54d2b3b2d100 100644
--- a/net/mptcp/protocol.h
+++ b/net/mptcp/protocol.h
@@ -585,6 +585,7 @@ unsigned int mptcp_get_add_addr_timeout(const struct net *net);
 int mptcp_is_checksum_enabled(const struct net *net);
 int mptcp_allow_join_id0(const struct net *net);
 unsigned int mptcp_stale_loss_cnt(const struct net *net);
+int mptcp_get_pm_type(const struct net *net);
 void mptcp_subflow_fully_established(struct mptcp_subflow_context *subflow,
 				     struct mptcp_options_received *mp_opt);
 bool __mptcp_retransmit_pending_data(struct sock *sk);
-- 
2.36.0

