Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id C3CDF567962
	for <lists+netdev@lfdr.de>; Tue,  5 Jul 2022 23:32:39 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231658AbiGEVcb (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 5 Jul 2022 17:32:31 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:56946 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230371AbiGEVcY (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 5 Jul 2022 17:32:24 -0400
Received: from mga03.intel.com (mga03.intel.com [134.134.136.65])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 035E2140DB
        for <netdev@vger.kernel.org>; Tue,  5 Jul 2022 14:32:23 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1657056744; x=1688592744;
  h=from:to:cc:subject:date:message-id:in-reply-to:
   references:mime-version:content-transfer-encoding;
  bh=VGowfovHTl4ZRFaVkmsMlCq8hTCDwyKbc/2OXbZp9PI=;
  b=iFE5BByxCm/vk5rZ8gC1/mjj2lWqvZeSkYcvEPm6saaDcU8viMcXoliu
   g1yEgRBPIUCRrs5GWzDUijBfuzJZr+amRw2I0pMfrqTpDAfuP4Hjt5B3y
   iIOfy6lzoV8WRCTVHubvSUe7qpbZeCe/TOTm4nbSbA15BrqCKRJAHU7KQ
   a8+PCyTHUqo8y7Wa7jL3LiGnLSRi5GsR0oSS/eiQridtonPvkR3FYWiGI
   KyxSaOb7INPHdKvH8uoGlv5bTvOuwLLnZQfQwdOQ/r97kGWPEym6QcuSt
   PQbmExntE7TpFPiqA7QDDfbDx64Zly3KK66esFGgvLFYetS8DA4YGesrL
   A==;
X-IronPort-AV: E=McAfee;i="6400,9594,10399"; a="284633925"
X-IronPort-AV: E=Sophos;i="5.92,247,1650956400"; 
   d="scan'208";a="284633925"
Received: from orsmga007.jf.intel.com ([10.7.209.58])
  by orsmga103.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 05 Jul 2022 14:32:22 -0700
X-IronPort-AV: E=Sophos;i="5.92,247,1650956400"; 
   d="scan'208";a="590558742"
Received: from rcenter-mobl.amr.corp.intel.com (HELO mjmartin-desk2.intel.com) ([10.209.17.169])
  by orsmga007-auth.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 05 Jul 2022 14:32:22 -0700
From:   Mat Martineau <mathew.j.martineau@linux.intel.com>
To:     netdev@vger.kernel.org
Cc:     Mat Martineau <mathew.j.martineau@linux.intel.com>,
        davem@davemloft.net, kuba@kernel.org, pabeni@redhat.com,
        edumazet@google.com, fw@strlen.de, geliang.tang@suse.com,
        matthieu.baerts@tessares.net, mptcp@lists.linux.dev
Subject: [PATCH net 2/7] mptcp: Avoid acquiring PM lock for subflow priority changes
Date:   Tue,  5 Jul 2022 14:32:12 -0700
Message-Id: <20220705213217.146898-3-mathew.j.martineau@linux.intel.com>
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

The in-kernel path manager code for changing subflow flags acquired both
the msk socket lock and the PM lock when possibly changing the "backup"
and "fullmesh" flags. mptcp_pm_nl_mp_prio_send_ack() does not access
anything protected by the PM lock, and it must release and reacquire
the PM lock.

By pushing the PM lock to where it is needed in mptcp_pm_nl_fullmesh(),
the lock is only acquired when the fullmesh flag is changed and the
backup flag code no longer has to release and reacquire the PM lock. The
change in locking context requires the MIB update to be modified - move
that to a better location instead.

This change also makes it possible to call
mptcp_pm_nl_mp_prio_send_ack() for the userspace PM commands without
manipulating the in-kernel PM lock.

Fixes: 0f9f696a502e ("mptcp: add set_flags command in PM netlink")
Acked-by: Paolo Abeni <pabeni@redhat.com>
Signed-off-by: Mat Martineau <mathew.j.martineau@linux.intel.com>
---
 net/mptcp/options.c    | 3 +++
 net/mptcp/pm_netlink.c | 8 ++------
 2 files changed, 5 insertions(+), 6 deletions(-)

diff --git a/net/mptcp/options.c b/net/mptcp/options.c
index aead331866a0..bd8f0f425be4 100644
--- a/net/mptcp/options.c
+++ b/net/mptcp/options.c
@@ -1584,6 +1584,9 @@ void mptcp_write_options(struct tcphdr *th, __be32 *ptr, struct tcp_sock *tp,
 		*ptr++ = mptcp_option(MPTCPOPT_MP_PRIO,
 				      TCPOLEN_MPTCP_PRIO,
 				      opts->backup, TCPOPT_NOP);
+
+		MPTCP_INC_STATS(sock_net((const struct sock *)tp),
+				MPTCP_MIB_MPPRIOTX);
 	}
 
 mp_capable_done:
diff --git a/net/mptcp/pm_netlink.c b/net/mptcp/pm_netlink.c
index e099f2a12504..5ff93b73f33d 100644
--- a/net/mptcp/pm_netlink.c
+++ b/net/mptcp/pm_netlink.c
@@ -727,7 +727,6 @@ static int mptcp_pm_nl_mp_prio_send_ack(struct mptcp_sock *msk,
 
 	mptcp_for_each_subflow(msk, subflow) {
 		struct sock *ssk = mptcp_subflow_tcp_sock(subflow);
-		struct sock *sk = (struct sock *)msk;
 		struct mptcp_addr_info local;
 
 		local_address((struct sock_common *)ssk, &local);
@@ -739,12 +738,9 @@ static int mptcp_pm_nl_mp_prio_send_ack(struct mptcp_sock *msk,
 		subflow->backup = bkup;
 		subflow->send_mp_prio = 1;
 		subflow->request_bkup = bkup;
-		__MPTCP_INC_STATS(sock_net(sk), MPTCP_MIB_MPPRIOTX);
 
-		spin_unlock_bh(&msk->pm.lock);
 		pr_debug("send ack for mp_prio");
 		mptcp_subflow_send_ack(ssk);
-		spin_lock_bh(&msk->pm.lock);
 
 		return 0;
 	}
@@ -1816,8 +1812,10 @@ static void mptcp_pm_nl_fullmesh(struct mptcp_sock *msk,
 
 	list.ids[list.nr++] = addr->id;
 
+	spin_lock_bh(&msk->pm.lock);
 	mptcp_pm_nl_rm_subflow_received(msk, &list);
 	mptcp_pm_create_subflow_or_signal_addr(msk);
+	spin_unlock_bh(&msk->pm.lock);
 }
 
 static int mptcp_nl_set_flags(struct net *net,
@@ -1835,12 +1833,10 @@ static int mptcp_nl_set_flags(struct net *net,
 			goto next;
 
 		lock_sock(sk);
-		spin_lock_bh(&msk->pm.lock);
 		if (changed & MPTCP_PM_ADDR_FLAG_BACKUP)
 			ret = mptcp_pm_nl_mp_prio_send_ack(msk, addr, bkup);
 		if (changed & MPTCP_PM_ADDR_FLAG_FULLMESH)
 			mptcp_pm_nl_fullmesh(msk, addr);
-		spin_unlock_bh(&msk->pm.lock);
 		release_sock(sk);
 
 next:
-- 
2.37.0

