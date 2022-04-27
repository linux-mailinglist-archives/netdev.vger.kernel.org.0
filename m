Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 66C7351258B
	for <lists+netdev@lfdr.de>; Thu, 28 Apr 2022 00:50:24 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S237760AbiD0Wx0 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 27 Apr 2022 18:53:26 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:59632 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S237776AbiD0WxZ (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 27 Apr 2022 18:53:25 -0400
Received: from mga03.intel.com (mga03.intel.com [134.134.136.65])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id E4D057DE17
        for <netdev@vger.kernel.org>; Wed, 27 Apr 2022 15:50:12 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1651099812; x=1682635812;
  h=from:to:cc:subject:date:message-id:in-reply-to:
   references:mime-version:content-transfer-encoding;
  bh=ritax1ucyi7/s2oghgHR+QF0LFx3Zqi4UHvJPq/tudU=;
  b=PNrJd6c2My8Yq2V2CL3ULui4as5qirUWiHtktMXh+mXibLa6RU3akpYO
   zUseqEjk8+u6OFQTWW6RfTmeIfYBq4dbYQHQNmNZU8LELj5LhJbRg2yAq
   qpzXIKeHbsI/brjl1dZEQMyg86N4o12Nb0p7XjOivc5k+8dK/vWooh3as
   Iskj9fm2gU+/y5JzQmpBCaT/fQ1wxyPek1Jf/dcQe3aoFqZNyvMwBNLxW
   FHagZgA5937hL8SwUGo4IF7YP6xUchzlbFOxgbtX4uw53ncmSiFePS4z4
   YKhmw6t6hWJcFQlDcTZFnBrv4d4XlmQk/aGHCdAGASeELIDO/cwbgHIBv
   g==;
X-IronPort-AV: E=McAfee;i="6400,9594,10330"; a="265907644"
X-IronPort-AV: E=Sophos;i="5.90,294,1643702400"; 
   d="scan'208";a="265907644"
Received: from orsmga005.jf.intel.com ([10.7.209.41])
  by orsmga103.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 27 Apr 2022 15:50:10 -0700
X-IronPort-AV: E=Sophos;i="5.90,294,1643702400"; 
   d="scan'208";a="731049115"
Received: from mjmartin-desk2.amr.corp.intel.com (HELO mjmartin-desk2.intel.com) ([10.212.233.139])
  by orsmga005-auth.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 27 Apr 2022 15:50:10 -0700
From:   Mat Martineau <mathew.j.martineau@linux.intel.com>
To:     netdev@vger.kernel.org
Cc:     Mat Martineau <mathew.j.martineau@linux.intel.com>,
        davem@davemloft.net, kuba@kernel.org, pabeni@redhat.com,
        matthieu.baerts@tessares.net, mptcp@lists.linux.dev
Subject: [PATCH net-next 1/6] mptcp: Remove redundant assignments in path manager init
Date:   Wed, 27 Apr 2022 15:49:57 -0700
Message-Id: <20220427225002.231996-2-mathew.j.martineau@linux.intel.com>
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

A few members of the mptcp_pm_data struct were assigned to hard-coded
values in mptcp_pm_data_reset(), and then immediately changed in
mptcp_pm_nl_data_init().

Instead, flatten all the assignments in to mptcp_pm_data_reset().

v2: Resolve conflicts due to rename of mptcp_pm_data_reset()
v4: Resolve conflict in mptcp_pm_data_reset()

Acked-by: Paolo Abeni <pabeni@redhat.com>
Signed-off-by: Mat Martineau <mathew.j.martineau@linux.intel.com>
---
 net/mptcp/pm.c         | 32 ++++++++++++++++++--------------
 net/mptcp/pm_netlink.c | 12 ------------
 net/mptcp/protocol.h   |  1 -
 3 files changed, 18 insertions(+), 27 deletions(-)

diff --git a/net/mptcp/pm.c b/net/mptcp/pm.c
index 14f448d82bb2..4de90e618be3 100644
--- a/net/mptcp/pm.c
+++ b/net/mptcp/pm.c
@@ -415,21 +415,25 @@ void mptcp_pm_subflow_chk_stale(const struct mptcp_sock *msk, struct sock *ssk)
 
 void mptcp_pm_data_reset(struct mptcp_sock *msk)
 {
-	msk->pm.add_addr_signaled = 0;
-	msk->pm.add_addr_accepted = 0;
-	msk->pm.local_addr_used = 0;
-	msk->pm.subflows = 0;
-	msk->pm.rm_list_tx.nr = 0;
-	msk->pm.rm_list_rx.nr = 0;
-	WRITE_ONCE(msk->pm.work_pending, false);
-	WRITE_ONCE(msk->pm.addr_signal, 0);
-	WRITE_ONCE(msk->pm.accept_addr, false);
-	WRITE_ONCE(msk->pm.accept_subflow, false);
-	WRITE_ONCE(msk->pm.remote_deny_join_id0, false);
-	msk->pm.status = 0;
-	bitmap_fill(msk->pm.id_avail_bitmap, MPTCP_PM_MAX_ADDR_ID + 1);
+	bool subflows_allowed = !!mptcp_pm_get_subflows_max(msk);
+	struct mptcp_pm_data *pm = &msk->pm;
 
-	mptcp_pm_nl_data_init(msk);
+	pm->add_addr_signaled = 0;
+	pm->add_addr_accepted = 0;
+	pm->local_addr_used = 0;
+	pm->subflows = 0;
+	pm->rm_list_tx.nr = 0;
+	pm->rm_list_rx.nr = 0;
+	WRITE_ONCE(pm->work_pending,
+		   (!!mptcp_pm_get_local_addr_max(msk) && subflows_allowed) ||
+		   !!mptcp_pm_get_add_addr_signal_max(msk));
+	WRITE_ONCE(pm->addr_signal, 0);
+	WRITE_ONCE(pm->accept_addr,
+		   !!mptcp_pm_get_add_addr_accept_max(msk) && subflows_allowed);
+	WRITE_ONCE(pm->accept_subflow, subflows_allowed);
+	WRITE_ONCE(pm->remote_deny_join_id0, false);
+	pm->status = 0;
+	bitmap_fill(msk->pm.id_avail_bitmap, MPTCP_PM_MAX_ADDR_ID + 1);
 }
 
 void mptcp_pm_data_init(struct mptcp_sock *msk)
diff --git a/net/mptcp/pm_netlink.c b/net/mptcp/pm_netlink.c
index c20261b612e9..bbbbfb421eec 100644
--- a/net/mptcp/pm_netlink.c
+++ b/net/mptcp/pm_netlink.c
@@ -1061,18 +1061,6 @@ int mptcp_pm_nl_get_local_id(struct mptcp_sock *msk, struct sock_common *skc)
 	return ret;
 }
 
-void mptcp_pm_nl_data_init(struct mptcp_sock *msk)
-{
-	struct mptcp_pm_data *pm = &msk->pm;
-	bool subflows;
-
-	subflows = !!mptcp_pm_get_subflows_max(msk);
-	WRITE_ONCE(pm->work_pending, (!!mptcp_pm_get_local_addr_max(msk) && subflows) ||
-		   !!mptcp_pm_get_add_addr_signal_max(msk));
-	WRITE_ONCE(pm->accept_addr, !!mptcp_pm_get_add_addr_accept_max(msk) && subflows);
-	WRITE_ONCE(pm->accept_subflow, subflows);
-}
-
 #define MPTCP_PM_CMD_GRP_OFFSET       0
 #define MPTCP_PM_EV_GRP_OFFSET        1
 
diff --git a/net/mptcp/protocol.h b/net/mptcp/protocol.h
index 3a8740fef918..0316605de559 100644
--- a/net/mptcp/protocol.h
+++ b/net/mptcp/protocol.h
@@ -828,7 +828,6 @@ bool mptcp_pm_rm_addr_signal(struct mptcp_sock *msk, unsigned int remaining,
 int mptcp_pm_get_local_id(struct mptcp_sock *msk, struct sock_common *skc);
 
 void __init mptcp_pm_nl_init(void);
-void mptcp_pm_nl_data_init(struct mptcp_sock *msk);
 void mptcp_pm_nl_work(struct mptcp_sock *msk);
 void mptcp_pm_nl_rm_subflow_received(struct mptcp_sock *msk,
 				     const struct mptcp_rm_list *rm_list);
-- 
2.36.0

