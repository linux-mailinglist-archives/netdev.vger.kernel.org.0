Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 3B5294BC236
	for <lists+netdev@lfdr.de>; Fri, 18 Feb 2022 22:36:10 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S239799AbiBRVgM (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 18 Feb 2022 16:36:12 -0500
Received: from mxb-00190b01.gslb.pphosted.com ([23.128.96.19]:40624 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S236814AbiBRVgK (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 18 Feb 2022 16:36:10 -0500
Received: from mga03.intel.com (mga03.intel.com [134.134.136.65])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 4D35B377C0
        for <netdev@vger.kernel.org>; Fri, 18 Feb 2022 13:35:53 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1645220153; x=1676756153;
  h=from:to:cc:subject:date:message-id:in-reply-to:
   references:mime-version:content-transfer-encoding;
  bh=d8l5H47MHhe5BUeljIGKZzmWZdlEJw5PRfTCL4x7u9o=;
  b=n+vFTi8Eb06jrTUNYsRWfzv/pI8kK1+/2KhtA4f4Q8nGil/5+QQ6KzxL
   C6m23nyrKtx2HnHhnqbaEAtFiuU7+2OAlKIchsTLZX4f+dRrBhGlfoxiv
   yT3LkOXKTWEMOjCDR6QaoYjsU6K8eIitGGOGfBepAHkVEfrRQ424bI1n3
   qTJtBALxCWh6xdR4J8bjv20RFkCoS5Bxr9h4OAA2XMWfVzDVhNSLXxSRd
   ZbV8IfFNWrIotdbSU5UXlQ8p220gI+M6eXtu4vC66O/3SjWxdiTMYpzc9
   O1FIPQUNiZ7QdTAJRRSsJSEbpOpebMW8BZz74SU/TkvGqrFV0Qk+Ucc+0
   g==;
X-IronPort-AV: E=McAfee;i="6200,9189,10262"; a="251176197"
X-IronPort-AV: E=Sophos;i="5.88,379,1635231600"; 
   d="scan'208";a="251176197"
Received: from fmsmga004.fm.intel.com ([10.253.24.48])
  by orsmga103.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 18 Feb 2022 13:35:52 -0800
X-IronPort-AV: E=Sophos;i="5.88,379,1635231600"; 
   d="scan'208";a="605664073"
Received: from mjmartin-desk2.amr.corp.intel.com (HELO mjmartin-desk2.intel.com) ([10.209.65.242])
  by fmsmga004-auth.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 18 Feb 2022 13:35:51 -0800
From:   Mat Martineau <mathew.j.martineau@linux.intel.com>
To:     netdev@vger.kernel.org
Cc:     Paolo Abeni <pabeni@redhat.com>, davem@davemloft.net,
        kuba@kernel.org, matthieu.baerts@tessares.net,
        geliang.tang@suse.com, mptcp@lists.linux.dev,
        Mat Martineau <mathew.j.martineau@linux.intel.com>
Subject: [PATCH net 3/7] mptcp: fix race in overlapping signal events
Date:   Fri, 18 Feb 2022 13:35:40 -0800
Message-Id: <20220218213544.70285-4-mathew.j.martineau@linux.intel.com>
X-Mailer: git-send-email 2.35.1
In-Reply-To: <20220218213544.70285-1-mathew.j.martineau@linux.intel.com>
References: <20220218213544.70285-1-mathew.j.martineau@linux.intel.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-4.4 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_EF,RCVD_IN_DNSWL_MED,SPF_HELO_NONE,
        SPF_NONE,T_SCC_BODY_TEXT_LINE autolearn=ham autolearn_force=no
        version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Paolo Abeni <pabeni@redhat.com>

After commit a88c9e496937 ("mptcp: do not block subflows
creation on errors"), if a signal address races with a failing
subflow creation, the subflow creation failure control path
can trigger the selection of the next address to be announced
while the current announced is still pending.

The above will cause the unintended suppression of the ADD_ADDR
announce.

Fix the issue skipping the to-be-suppressed announce before it
will mark an endpoint as already used. The relevant announce
will be triggered again when the current one will complete.

Fixes: a88c9e496937 ("mptcp: do not block subflows creation on errors")
Reviewed-by: Matthieu Baerts <matthieu.baerts@tessares.net>
Signed-off-by: Paolo Abeni <pabeni@redhat.com>
Signed-off-by: Mat Martineau <mathew.j.martineau@linux.intel.com>
---
 net/mptcp/pm_netlink.c | 10 ++++++++++
 1 file changed, 10 insertions(+)

diff --git a/net/mptcp/pm_netlink.c b/net/mptcp/pm_netlink.c
index 356f596e2032..82f82a513f5b 100644
--- a/net/mptcp/pm_netlink.c
+++ b/net/mptcp/pm_netlink.c
@@ -546,6 +546,16 @@ static void mptcp_pm_create_subflow_or_signal_addr(struct mptcp_sock *msk)
 	if (msk->pm.add_addr_signaled < add_addr_signal_max) {
 		local = select_signal_address(pernet, msk);
 
+		/* due to racing events on both ends we can reach here while
+		 * previous add address is still running: if we invoke now
+		 * mptcp_pm_announce_addr(), that will fail and the
+		 * corresponding id will be marked as used.
+		 * Instead let the PM machinery reschedule us when the
+		 * current address announce will be completed.
+		 */
+		if (msk->pm.addr_signal & BIT(MPTCP_ADD_ADDR_SIGNAL))
+			return;
+
 		if (local) {
 			if (mptcp_pm_alloc_anno_list(msk, local)) {
 				__clear_bit(local->addr.id, msk->pm.id_avail_bitmap);
-- 
2.35.1

