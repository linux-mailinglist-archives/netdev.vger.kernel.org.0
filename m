Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 0D63E512597
	for <lists+netdev@lfdr.de>; Thu, 28 Apr 2022 00:51:53 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S237989AbiD0Wxr (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 27 Apr 2022 18:53:47 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:59862 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S237774AbiD0Wx1 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 27 Apr 2022 18:53:27 -0400
Received: from mga03.intel.com (mga03.intel.com [134.134.136.65])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 9E46384EED
        for <netdev@vger.kernel.org>; Wed, 27 Apr 2022 15:50:14 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1651099814; x=1682635814;
  h=from:to:cc:subject:date:message-id:in-reply-to:
   references:mime-version:content-transfer-encoding;
  bh=og/Cz3rjL7z/H2kolHeUQ9uzXf19AIIeepdKPwATYKk=;
  b=nzU6YTpgxAZcsInzB5YOADuEj1vVSfICsvobB7mDGsicko9SazdsaCUk
   7icBytc1n2XpwZRQ3MNitlQEAY4rqrZOtlbGz2J6aD9daY3WWh/g9XHpg
   mUOCmwDiEn4S1T6lZuonmEyNfMp29MeWKZCZEe66MZC6gNX1x4bfvG0ml
   1SaLlZ51vTeceN++lQp5PZKH2WlvAfg8SWn9fouYyIO/UA4qjjPNn+AfE
   O7TQu7FuMHFskC+tQKs8PyOniFC0NJzJEpf8KgQNWn5oUZYV8nwCXLw9t
   76X/AibrdzQJflhBzsQ6gHgBiu8WugsjfGqVXUDB5TIu7urqcsOWPfgnj
   g==;
X-IronPort-AV: E=McAfee;i="6400,9594,10330"; a="265907651"
X-IronPort-AV: E=Sophos;i="5.90,294,1643702400"; 
   d="scan'208";a="265907651"
Received: from orsmga005.jf.intel.com ([10.7.209.41])
  by orsmga103.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 27 Apr 2022 15:50:10 -0700
X-IronPort-AV: E=Sophos;i="5.90,294,1643702400"; 
   d="scan'208";a="731049120"
Received: from mjmartin-desk2.amr.corp.intel.com (HELO mjmartin-desk2.intel.com) ([10.212.233.139])
  by orsmga005-auth.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 27 Apr 2022 15:50:10 -0700
From:   Mat Martineau <mathew.j.martineau@linux.intel.com>
To:     netdev@vger.kernel.org
Cc:     Mat Martineau <mathew.j.martineau@linux.intel.com>,
        davem@davemloft.net, kuba@kernel.org, pabeni@redhat.com,
        matthieu.baerts@tessares.net, mptcp@lists.linux.dev
Subject: [PATCH net-next 4/6] mptcp: Make kernel path manager check for userspace-managed sockets
Date:   Wed, 27 Apr 2022 15:50:00 -0700
Message-Id: <20220427225002.231996-5-mathew.j.martineau@linux.intel.com>
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

Userspace-managed sockets should not have their subflows or
advertisements changed by the kernel path manager.

v3: Use helper function for PM mode (Paolo Abeni)

Acked-by: Paolo Abeni <pabeni@redhat.com>
Signed-off-by: Mat Martineau <mathew.j.martineau@linux.intel.com>
---
 net/mptcp/pm_netlink.c | 18 ++++++++++++------
 1 file changed, 12 insertions(+), 6 deletions(-)

diff --git a/net/mptcp/pm_netlink.c b/net/mptcp/pm_netlink.c
index bbbbfb421eec..473e5aa7baf4 100644
--- a/net/mptcp/pm_netlink.c
+++ b/net/mptcp/pm_netlink.c
@@ -1220,7 +1220,8 @@ static int mptcp_nl_add_subflow_or_signal_addr(struct net *net)
 	while ((msk = mptcp_token_iter_next(net, &s_slot, &s_num)) != NULL) {
 		struct sock *sk = (struct sock *)msk;
 
-		if (!READ_ONCE(msk->fully_established))
+		if (!READ_ONCE(msk->fully_established) ||
+		    mptcp_pm_is_userspace(msk))
 			goto next;
 
 		lock_sock(sk);
@@ -1363,6 +1364,9 @@ static int mptcp_nl_remove_subflow_and_signal_addr(struct net *net,
 		struct sock *sk = (struct sock *)msk;
 		bool remove_subflow;
 
+		if (mptcp_pm_is_userspace(msk))
+			goto next;
+
 		if (list_empty(&msk->conn_list)) {
 			mptcp_pm_remove_anno_addr(msk, addr, false);
 			goto next;
@@ -1397,7 +1401,7 @@ static int mptcp_nl_remove_id_zero_address(struct net *net,
 		struct sock *sk = (struct sock *)msk;
 		struct mptcp_addr_info msk_local;
 
-		if (list_empty(&msk->conn_list))
+		if (list_empty(&msk->conn_list) || mptcp_pm_is_userspace(msk))
 			goto next;
 
 		local_address((struct sock_common *)msk, &msk_local);
@@ -1504,9 +1508,11 @@ static void mptcp_nl_remove_addrs_list(struct net *net,
 	while ((msk = mptcp_token_iter_next(net, &s_slot, &s_num)) != NULL) {
 		struct sock *sk = (struct sock *)msk;
 
-		lock_sock(sk);
-		mptcp_pm_remove_addrs_and_subflows(msk, rm_list);
-		release_sock(sk);
+		if (!mptcp_pm_is_userspace(msk)) {
+			lock_sock(sk);
+			mptcp_pm_remove_addrs_and_subflows(msk, rm_list);
+			release_sock(sk);
+		}
 
 		sock_put(sk);
 		cond_resched();
@@ -1779,7 +1785,7 @@ static int mptcp_nl_set_flags(struct net *net,
 	while ((msk = mptcp_token_iter_next(net, &s_slot, &s_num)) != NULL) {
 		struct sock *sk = (struct sock *)msk;
 
-		if (list_empty(&msk->conn_list))
+		if (list_empty(&msk->conn_list) || mptcp_pm_is_userspace(msk))
 			goto next;
 
 		lock_sock(sk);
-- 
2.36.0

