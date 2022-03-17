Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 52C294DD095
	for <lists+netdev@lfdr.de>; Thu, 17 Mar 2022 23:14:50 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229666AbiCQWQE (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 17 Mar 2022 18:16:04 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:36478 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229469AbiCQWQD (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 17 Mar 2022 18:16:03 -0400
Received: from mga02.intel.com (mga02.intel.com [134.134.136.20])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id AD55F36E29
        for <netdev@vger.kernel.org>; Thu, 17 Mar 2022 15:14:46 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1647555286; x=1679091286;
  h=from:to:cc:subject:date:message-id:mime-version:
   content-transfer-encoding;
  bh=LBH3oVPpZUWhACuFbLsRx6LPCOq5e55Un5nLgYAZFN8=;
  b=CuPgix/IsZWuQETBVlu6l+B+HKEVOAR/V30xqH8MxWeJSvXW8kySWWKr
   hKRh3BwJ6XZnbbYgWqGUeBCtnfTA8lBJJmKtb0Fu8OAT16EcOMn47eRyw
   72CYoLtp7CHysJIWkWsloEpUpyV1qkCAM1axQXGD346m4ODylHMn0WQ3g
   uN1iDt7MJqY94RGC/IC2QdD6OnqOx4GBaNvDHhfMmwexm8hBrrQuViwnm
   UDdAlBIdhTW2qSMvSbyS9VVkLyAlvm4M+dLHO8nkbJ1DOn65uX3mtNvQ8
   ouPSv/z1+ODf5L4vX1iyNSTKrug0OHGJsZ/hKTf0HImvu1WH/KMneesjB
   A==;
X-IronPort-AV: E=McAfee;i="6200,9189,10289"; a="244449382"
X-IronPort-AV: E=Sophos;i="5.90,190,1643702400"; 
   d="scan'208";a="244449382"
Received: from orsmga003.jf.intel.com ([10.7.209.27])
  by orsmga101.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 17 Mar 2022 15:14:46 -0700
X-IronPort-AV: E=Sophos;i="5.90,190,1643702400"; 
   d="scan'208";a="499002728"
Received: from mjmartin-desk2.amr.corp.intel.com (HELO mjmartin-desk2.intel.com) ([10.251.9.212])
  by orsmga003-auth.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 17 Mar 2022 15:14:46 -0700
From:   Mat Martineau <mathew.j.martineau@linux.intel.com>
To:     netdev@vger.kernel.org
Cc:     Yonglong Li <liyonglong@chinatelecom.cn>, davem@davemloft.net,
        kuba@kernel.org, matthieu.baerts@tessares.net,
        mptcp@lists.linux.dev, Paolo Abeni <pabeni@redhat.com>,
        Mat Martineau <mathew.j.martineau@linux.intel.com>
Subject: [PATCH net-next] mptcp: send ADD_ADDR echo before create subflows
Date:   Thu, 17 Mar 2022 15:14:44 -0700
Message-Id: <20220317221444.426335-1-mathew.j.martineau@linux.intel.com>
X-Mailer: git-send-email 2.35.1
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-4.2 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_EF,RCVD_IN_DNSWL_LOW,
        RCVD_IN_MSPIKE_H3,RCVD_IN_MSPIKE_WL,SPF_HELO_NONE,SPF_NONE,
        T_SCC_BODY_TEXT_LINE autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Yonglong Li <liyonglong@chinatelecom.cn>

In some corner cases, the peer handing an incoming ADD_ADDR option, can
receive a retransmitted ADD_ADDR for the same address before the subflow
creation completes.

We can avoid the above issue by generating and sending the ADD_ADDR echo
before starting the MPJ subflow connection.

This slightly changes the behaviour of the packetdrill tests as the
ADD_ADDR echo packet is sent earlier.

Acked-by: Paolo Abeni <pabeni@redhat.com>
Signed-off-by: Yonglong Li <liyonglong@chinatelecom.cn>
Signed-off-by: Mat Martineau <mathew.j.martineau@linux.intel.com>
---
 net/mptcp/pm_netlink.c | 18 +++++-------------
 1 file changed, 5 insertions(+), 13 deletions(-)

diff --git a/net/mptcp/pm_netlink.c b/net/mptcp/pm_netlink.c
index 800515fe5e1d..b5e8de6f7507 100644
--- a/net/mptcp/pm_netlink.c
+++ b/net/mptcp/pm_netlink.c
@@ -650,7 +650,6 @@ static void mptcp_pm_nl_add_addr_received(struct mptcp_sock *msk)
 	unsigned int add_addr_accept_max;
 	struct mptcp_addr_info remote;
 	unsigned int subflows_max;
-	bool reset_port = false;
 	int i, nr;
 
 	add_addr_accept_max = mptcp_pm_get_add_addr_accept_max(msk);
@@ -661,14 +660,15 @@ static void mptcp_pm_nl_add_addr_received(struct mptcp_sock *msk)
 		 msk->pm.remote.family);
 
 	remote = msk->pm.remote;
+	mptcp_pm_announce_addr(msk, &remote, true);
+	mptcp_pm_nl_addr_send_ack(msk);
+
 	if (lookup_subflow_by_daddr(&msk->conn_list, &remote))
-		goto add_addr_echo;
+		return;
 
 	/* pick id 0 port, if none is provided the remote address */
-	if (!remote.port) {
-		reset_port = true;
+	if (!remote.port)
 		remote.port = sk->sk_dport;
-	}
 
 	/* connect to the specified remote address, using whatever
 	 * local address the routing configuration will pick.
@@ -684,14 +684,6 @@ static void mptcp_pm_nl_add_addr_received(struct mptcp_sock *msk)
 	for (i = 0; i < nr; i++)
 		__mptcp_subflow_connect(sk, &addrs[i], &remote);
 	spin_lock_bh(&msk->pm.lock);
-
-	/* be sure to echo exactly the received address */
-	if (reset_port)
-		remote.port = 0;
-
-add_addr_echo:
-	mptcp_pm_announce_addr(msk, &remote, true);
-	mptcp_pm_nl_addr_send_ack(msk);
 }
 
 void mptcp_pm_nl_addr_send_ack(struct mptcp_sock *msk)

base-commit: 1abea24af42c35c6eb537e4402836e2cde2a5b13
-- 
2.35.1

