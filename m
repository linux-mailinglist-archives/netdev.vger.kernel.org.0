Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 6800A4BC231
	for <lists+netdev@lfdr.de>; Fri, 18 Feb 2022 22:36:08 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S239958AbiBRVgM (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 18 Feb 2022 16:36:12 -0500
Received: from mxb-00190b01.gslb.pphosted.com ([23.128.96.19]:40632 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S239942AbiBRVgK (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 18 Feb 2022 16:36:10 -0500
Received: from mga03.intel.com (mga03.intel.com [134.134.136.65])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 62B83104A46
        for <netdev@vger.kernel.org>; Fri, 18 Feb 2022 13:35:53 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1645220153; x=1676756153;
  h=from:to:cc:subject:date:message-id:in-reply-to:
   references:mime-version:content-transfer-encoding;
  bh=moHVowhDn1CfmxXUlrwilDVUp0OxXTgQQgTmooJVCp0=;
  b=j/l3CYK2HOpJZcYfBnNWsakZjZnsmN6r0T8ZwAT9re5gaqoFD0Zz+Jma
   l93TQ9f5FhhhJdYtIseP2ua9Q3VjJZ4WJXsh8ocRE1zwKWXkRvLBieUtz
   /oiCPiiWHEgl1/eaqxUO601GrHgq/tmn9pLNW/5XtJvhfIfsjEuY/yCpO
   3ewYZ+t28Cdx4svkP7CiEShAZmSeueIXQhcO6o9s17h5vvx3ri1Tzw9wO
   Y7l84LQE3FRf8ndKMgKo3T+YbEW+Y/nQeAIwoNN0yEnGCxlVHp6xSHuZA
   jmDrONY7EdLnY3DsEufQR4Ig3WAgRFRRHcjoXVY2AQFSEsYOmGFm1AtWO
   g==;
X-IronPort-AV: E=McAfee;i="6200,9189,10262"; a="251176200"
X-IronPort-AV: E=Sophos;i="5.88,379,1635231600"; 
   d="scan'208";a="251176200"
Received: from fmsmga004.fm.intel.com ([10.253.24.48])
  by orsmga103.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 18 Feb 2022 13:35:52 -0800
X-IronPort-AV: E=Sophos;i="5.88,379,1635231600"; 
   d="scan'208";a="605664077"
Received: from mjmartin-desk2.amr.corp.intel.com (HELO mjmartin-desk2.intel.com) ([10.209.65.242])
  by fmsmga004-auth.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 18 Feb 2022 13:35:52 -0800
From:   Mat Martineau <mathew.j.martineau@linux.intel.com>
To:     netdev@vger.kernel.org
Cc:     Paolo Abeni <pabeni@redhat.com>, davem@davemloft.net,
        kuba@kernel.org, matthieu.baerts@tessares.net,
        geliang.tang@suse.com, mptcp@lists.linux.dev,
        Mat Martineau <mathew.j.martineau@linux.intel.com>
Subject: [PATCH net 4/7] mptcp: fix race in incoming ADD_ADDR option processing
Date:   Fri, 18 Feb 2022 13:35:41 -0800
Message-Id: <20220218213544.70285-5-mathew.j.martineau@linux.intel.com>
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

If an MPTCP endpoint received multiple consecutive incoming
ADD_ADDR options, mptcp_pm_add_addr_received() can overwrite
the current remote address value after the PM lock is released
in mptcp_pm_nl_add_addr_received() and before such address
is echoed.

Fix the issue caching the remote address value a little earlier
and always using the cached value after releasing the PM lock.

Fixes: f7efc7771eac ("mptcp: drop argument port from mptcp_pm_announce_addr")
Reviewed-by: Matthieu Baerts <matthieu.baerts@tessares.net>
Signed-off-by: Paolo Abeni <pabeni@redhat.com>
Signed-off-by: Mat Martineau <mathew.j.martineau@linux.intel.com>
---
 net/mptcp/pm_netlink.c | 19 ++++++++++++++-----
 1 file changed, 14 insertions(+), 5 deletions(-)

diff --git a/net/mptcp/pm_netlink.c b/net/mptcp/pm_netlink.c
index 82f82a513f5b..4b5d795383cd 100644
--- a/net/mptcp/pm_netlink.c
+++ b/net/mptcp/pm_netlink.c
@@ -660,6 +660,7 @@ static void mptcp_pm_nl_add_addr_received(struct mptcp_sock *msk)
 	unsigned int add_addr_accept_max;
 	struct mptcp_addr_info remote;
 	unsigned int subflows_max;
+	bool reset_port = false;
 	int i, nr;
 
 	add_addr_accept_max = mptcp_pm_get_add_addr_accept_max(msk);
@@ -669,15 +670,19 @@ static void mptcp_pm_nl_add_addr_received(struct mptcp_sock *msk)
 		 msk->pm.add_addr_accepted, add_addr_accept_max,
 		 msk->pm.remote.family);
 
-	if (lookup_subflow_by_daddr(&msk->conn_list, &msk->pm.remote))
+	remote = msk->pm.remote;
+	if (lookup_subflow_by_daddr(&msk->conn_list, &remote))
 		goto add_addr_echo;
 
+	/* pick id 0 port, if none is provided the remote address */
+	if (!remote.port) {
+		reset_port = true;
+		remote.port = sk->sk_dport;
+	}
+
 	/* connect to the specified remote address, using whatever
 	 * local address the routing configuration will pick.
 	 */
-	remote = msk->pm.remote;
-	if (!remote.port)
-		remote.port = sk->sk_dport;
 	nr = fill_local_addresses_vec(msk, addrs);
 
 	msk->pm.add_addr_accepted++;
@@ -690,8 +695,12 @@ static void mptcp_pm_nl_add_addr_received(struct mptcp_sock *msk)
 		__mptcp_subflow_connect(sk, &addrs[i], &remote);
 	spin_lock_bh(&msk->pm.lock);
 
+	/* be sure to echo exactly the received address */
+	if (reset_port)
+		remote.port = 0;
+
 add_addr_echo:
-	mptcp_pm_announce_addr(msk, &msk->pm.remote, true);
+	mptcp_pm_announce_addr(msk, &remote, true);
 	mptcp_pm_nl_addr_send_ack(msk);
 }
 
-- 
2.35.1

