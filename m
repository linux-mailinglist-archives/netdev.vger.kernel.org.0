Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 9F8FE2D4F29
	for <lists+netdev@lfdr.de>; Thu, 10 Dec 2020 01:00:30 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1725914AbgLIX5n (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 9 Dec 2020 18:57:43 -0500
Received: from mga06.intel.com ([134.134.136.31]:19330 "EHLO mga06.intel.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1728452AbgLIX53 (ORCPT <rfc822;netdev@vger.kernel.org>);
        Wed, 9 Dec 2020 18:57:29 -0500
IronPort-SDR: RdApFxJG7jBrMAIqZ2Yc7smCWLDwrkni0+1RIiwpX1sJXovX+ePW8pwS8GrZAyrosivQFWM33S
 NEsqp/UvsUJA==
X-IronPort-AV: E=McAfee;i="6000,8403,9830"; a="235763093"
X-IronPort-AV: E=Sophos;i="5.78,407,1599548400"; 
   d="scan'208";a="235763093"
Received: from fmsmga008.fm.intel.com ([10.253.24.58])
  by orsmga104.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 09 Dec 2020 15:51:39 -0800
IronPort-SDR: 6bWp2vpEeCKfRktJEji6QfWFj8vavqMw6XZVSyFtesm890HXFXy4aKirevHTkkZdvba354lyrk
 yNdza2SL+7fA==
X-IronPort-AV: E=Sophos;i="5.78,407,1599548400"; 
   d="scan'208";a="318582190"
Received: from mjmartin-nuc02.amr.corp.intel.com ([10.254.111.12])
  by fmsmga008-auth.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 09 Dec 2020 15:51:39 -0800
From:   Mat Martineau <mathew.j.martineau@linux.intel.com>
To:     netdev@vger.kernel.org
Cc:     Geliang Tang <geliangtang@gmail.com>, davem@davemloft.net,
        kuba@kernel.org, mptcp@lists.01.org,
        Mat Martineau <mathew.j.martineau@linux.intel.com>
Subject: [PATCH net-next 06/11] mptcp: send out dedicated packet for ADD_ADDR using port
Date:   Wed,  9 Dec 2020 15:51:23 -0800
Message-Id: <20201209235128.175473-7-mathew.j.martineau@linux.intel.com>
X-Mailer: git-send-email 2.29.2
In-Reply-To: <20201209235128.175473-1-mathew.j.martineau@linux.intel.com>
References: <20201209235128.175473-1-mathew.j.martineau@linux.intel.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Geliang Tang <geliangtang@gmail.com>

The process is similar to that of the ADD_ADDR IPv6, this patch also sent
out a pure ack for the ADD_ADDR using port.

Signed-off-by: Geliang Tang <geliangtang@gmail.com>
Signed-off-by: Mat Martineau <mathew.j.martineau@linux.intel.com>
---
 net/mptcp/options.c    |  3 ++-
 net/mptcp/pm.c         |  3 ++-
 net/mptcp/pm_netlink.c | 14 +++++++++++---
 3 files changed, 15 insertions(+), 5 deletions(-)

diff --git a/net/mptcp/options.c b/net/mptcp/options.c
index 9d3b49254d38..6a290c622ccf 100644
--- a/net/mptcp/options.c
+++ b/net/mptcp/options.c
@@ -590,7 +590,8 @@ static bool mptcp_established_options_add_addr(struct sock *sk, struct sk_buff *
 	bool port;
 	int len;
 
-	if (mptcp_pm_should_add_signal_ipv6(msk) &&
+	if ((mptcp_pm_should_add_signal_ipv6(msk) ||
+	     mptcp_pm_should_add_signal_port(msk)) &&
 	    skb && skb_is_tcp_pure_ack(skb)) {
 		pr_debug("drop other suboptions");
 		opts->suboptions = 0;
diff --git a/net/mptcp/pm.c b/net/mptcp/pm.c
index 2c517046e2b5..d20637860851 100644
--- a/net/mptcp/pm.c
+++ b/net/mptcp/pm.c
@@ -173,7 +173,8 @@ void mptcp_pm_add_addr_received(struct mptcp_sock *msk,
 
 void mptcp_pm_add_addr_send_ack(struct mptcp_sock *msk)
 {
-	if (!mptcp_pm_should_add_signal_ipv6(msk))
+	if (!mptcp_pm_should_add_signal_ipv6(msk) &&
+	    !mptcp_pm_should_add_signal_port(msk))
 		return;
 
 	mptcp_pm_schedule_work(msk, MPTCP_PM_ADD_ADDR_SEND_ACK);
diff --git a/net/mptcp/pm_netlink.c b/net/mptcp/pm_netlink.c
index 03f2c28f11f5..7a0f700e34bb 100644
--- a/net/mptcp/pm_netlink.c
+++ b/net/mptcp/pm_netlink.c
@@ -407,7 +407,8 @@ void mptcp_pm_nl_add_addr_send_ack(struct mptcp_sock *msk)
 {
 	struct mptcp_subflow_context *subflow;
 
-	if (!mptcp_pm_should_add_signal_ipv6(msk))
+	if (!mptcp_pm_should_add_signal_ipv6(msk) &&
+	    !mptcp_pm_should_add_signal_port(msk))
 		return;
 
 	__mptcp_flush_join_list(msk);
@@ -417,14 +418,21 @@ void mptcp_pm_nl_add_addr_send_ack(struct mptcp_sock *msk)
 		u8 add_addr;
 
 		spin_unlock_bh(&msk->pm.lock);
-		pr_debug("send ack for add_addr6");
+		if (mptcp_pm_should_add_signal_ipv6(msk))
+			pr_debug("send ack for add_addr6");
+		if (mptcp_pm_should_add_signal_port(msk))
+			pr_debug("send ack for add_addr_port");
+
 		lock_sock(ssk);
 		tcp_send_ack(ssk);
 		release_sock(ssk);
 		spin_lock_bh(&msk->pm.lock);
 
 		add_addr = READ_ONCE(msk->pm.add_addr_signal);
-		add_addr &= ~BIT(MPTCP_ADD_ADDR_IPV6);
+		if (mptcp_pm_should_add_signal_ipv6(msk))
+			add_addr &= ~BIT(MPTCP_ADD_ADDR_IPV6);
+		if (mptcp_pm_should_add_signal_port(msk))
+			add_addr &= ~BIT(MPTCP_ADD_ADDR_PORT);
 		WRITE_ONCE(msk->pm.add_addr_signal, add_addr);
 	}
 }
-- 
2.29.2

