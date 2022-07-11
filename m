Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id AB263570A7F
	for <lists+netdev@lfdr.de>; Mon, 11 Jul 2022 21:16:47 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231448AbiGKTQo (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 11 Jul 2022 15:16:44 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:56402 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229490AbiGKTQl (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 11 Jul 2022 15:16:41 -0400
Received: from mga11.intel.com (mga11.intel.com [192.55.52.93])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 9F7E2167E7
        for <netdev@vger.kernel.org>; Mon, 11 Jul 2022 12:16:40 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1657567000; x=1689103000;
  h=from:to:cc:subject:date:message-id:in-reply-to:
   references:mime-version:content-transfer-encoding;
  bh=NEiJvTKvSTMVTvV6Cif8kN1PwHk/e+jtjHvC50aicgs=;
  b=M7AZh0SCFAsIeJsK5VM9JgjNG5LidvvZjp9IxnfdQoIepBdxtgzCVvNd
   5PMWjvHSHYPeSct8q7jAz1sSTA2ZEiKhdr3F4VZKQ/25cPGR73Fti92SU
   amrCCtvgy+QhZ9+bNLyJFDvxaAbz8J1orPpKnd/+/IwjIDQfEtriJCjN4
   q/F/3MrbtKkGZnXXIDeESdNKvjVa59Y8YGA3RtFrygL4cgbCeyDc+9NUM
   E9/BML9afe3EufFcw2vEiMFQsbLIhZ7ikSlHIajbyFGNNiBUD6W7wKsmu
   To66mUPfCIxLoPIOBCV0amHvJW39GplSfZJxyiqFZpqZhuWTJNhG6IBSh
   A==;
X-IronPort-AV: E=McAfee;i="6400,9594,10405"; a="282300982"
X-IronPort-AV: E=Sophos;i="5.92,263,1650956400"; 
   d="scan'208";a="282300982"
Received: from fmsmga002.fm.intel.com ([10.253.24.26])
  by fmsmga102.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 11 Jul 2022 12:16:39 -0700
X-IronPort-AV: E=Sophos;i="5.92,263,1650956400"; 
   d="scan'208";a="697742714"
Received: from eedeets-mobl1.amr.corp.intel.com (HELO mjmartin-desk2.intel.com) ([10.251.2.111])
  by fmsmga002-auth.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 11 Jul 2022 12:16:39 -0700
From:   Mat Martineau <mathew.j.martineau@linux.intel.com>
To:     netdev@vger.kernel.org
Cc:     Paolo Abeni <pabeni@redhat.com>, davem@davemloft.net,
        kuba@kernel.org, edumazet@google.com, matthieu.baerts@tessares.net,
        mptcp@lists.linux.dev,
        Mat Martineau <mathew.j.martineau@linux.intel.com>
Subject: [PATCH net-next 3/5] mptcp: allow the in kernel PM to set MPC subflow priority
Date:   Mon, 11 Jul 2022 12:16:31 -0700
Message-Id: <20220711191633.80826-4-mathew.j.martineau@linux.intel.com>
X-Mailer: git-send-email 2.37.0
In-Reply-To: <20220711191633.80826-1-mathew.j.martineau@linux.intel.com>
References: <20220711191633.80826-1-mathew.j.martineau@linux.intel.com>
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

From: Paolo Abeni <pabeni@redhat.com>

Any local endpoints configured on the address matching the
MPC subflow are currently ignored.

Specifically, setting a backup flag on them has no effect
on the first subflow, as the MPC handshake can't carry such
info.

This change refactors the MPC endpoint id accounting to
additionally fetch the priority info from the relevant endpoint
and eventually trigger the MP_PRIO handshake as needed.

As a result, the MPC subflow now switches to backup priority
after that the MPTCP socket is fully established, according
to the local endpoint configuration.

Reviewed-by: Mat Martineau <mathew.j.martineau@linux.intel.com>
Signed-off-by: Paolo Abeni <pabeni@redhat.com>
Signed-off-by: Mat Martineau <mathew.j.martineau@linux.intel.com>
---
 net/mptcp/pm_netlink.c | 37 +++++++++++++++----------------------
 1 file changed, 15 insertions(+), 22 deletions(-)

diff --git a/net/mptcp/pm_netlink.c b/net/mptcp/pm_netlink.c
index fe8e22aff7d2..b767a336ad98 100644
--- a/net/mptcp/pm_netlink.c
+++ b/net/mptcp/pm_netlink.c
@@ -514,30 +514,14 @@ __lookup_addr(struct pm_nl_pernet *pernet, const struct mptcp_addr_info *info,
 	struct mptcp_pm_addr_entry *entry;
 
 	list_for_each_entry(entry, &pernet->local_addr_list, list) {
-		if ((!lookup_by_id && mptcp_addresses_equal(&entry->addr, info, true)) ||
+		if ((!lookup_by_id &&
+		     mptcp_addresses_equal(&entry->addr, info, entry->addr.port)) ||
 		    (lookup_by_id && entry->addr.id == info->id))
 			return entry;
 	}
 	return NULL;
 }
 
-static int
-lookup_id_by_addr(const struct pm_nl_pernet *pernet, const struct mptcp_addr_info *addr)
-{
-	const struct mptcp_pm_addr_entry *entry;
-	int ret = -1;
-
-	rcu_read_lock();
-	list_for_each_entry(entry, &pernet->local_addr_list, list) {
-		if (mptcp_addresses_equal(&entry->addr, addr, entry->addr.port)) {
-			ret = entry->addr.id;
-			break;
-		}
-	}
-	rcu_read_unlock();
-	return ret;
-}
-
 static void mptcp_pm_create_subflow_or_signal_addr(struct mptcp_sock *msk)
 {
 	struct sock *sk = (struct sock *)msk;
@@ -555,13 +539,22 @@ static void mptcp_pm_create_subflow_or_signal_addr(struct mptcp_sock *msk)
 
 	/* do lazy endpoint usage accounting for the MPC subflows */
 	if (unlikely(!(msk->pm.status & BIT(MPTCP_PM_MPC_ENDPOINT_ACCOUNTED))) && msk->first) {
+		struct mptcp_subflow_context *subflow = mptcp_subflow_ctx(msk->first);
+		struct mptcp_pm_addr_entry *entry;
 		struct mptcp_addr_info mpc_addr;
-		int mpc_id;
+		bool backup = false;
 
 		local_address((struct sock_common *)msk->first, &mpc_addr);
-		mpc_id = lookup_id_by_addr(pernet, &mpc_addr);
-		if (mpc_id >= 0)
-			__clear_bit(mpc_id, msk->pm.id_avail_bitmap);
+		rcu_read_lock();
+		entry = __lookup_addr(pernet, &mpc_addr, false);
+		if (entry) {
+			__clear_bit(entry->addr.id, msk->pm.id_avail_bitmap);
+			backup = !!(entry->flags & MPTCP_PM_ADDR_FLAG_BACKUP);
+		}
+		rcu_read_unlock();
+
+		if (backup)
+			mptcp_pm_send_ack(msk, subflow, true, backup);
 
 		msk->pm.status |= BIT(MPTCP_PM_MPC_ENDPOINT_ACCOUNTED);
 	}
-- 
2.37.0

