Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id B15CB30831A
	for <lists+netdev@lfdr.de>; Fri, 29 Jan 2021 02:16:39 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231716AbhA2BQW (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 28 Jan 2021 20:16:22 -0500
Received: from mga07.intel.com ([134.134.136.100]:6700 "EHLO mga07.intel.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S231259AbhA2BQG (ORCPT <rfc822;netdev@vger.kernel.org>);
        Thu, 28 Jan 2021 20:16:06 -0500
IronPort-SDR: XYur0xRKMWHgLChYqDbpVW3HdjOsm7aoZjxtvV0q6opoltiCmMOiZnTyN7GJt5hDI2qUeG8kiG
 Id+HeLac8Ysw==
X-IronPort-AV: E=McAfee;i="6000,8403,9878"; a="244430168"
X-IronPort-AV: E=Sophos;i="5.79,384,1602572400"; 
   d="scan'208";a="244430168"
Received: from orsmga004.jf.intel.com ([10.7.209.38])
  by orsmga105.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 28 Jan 2021 17:11:22 -0800
IronPort-SDR: 4ExCq6Lo7I4cfhIfdJrD8kEy/twCS5wRjkCXxt62KCKk+/lOaw0aar7HqdHDQs80lKgGxohrwD
 5TRYC7saGG0g==
X-IronPort-AV: E=Sophos;i="5.79,384,1602572400"; 
   d="scan'208";a="505538326"
Received: from mjmartin-desk2.amr.corp.intel.com (HELO mjmartin-desk2.intel.com) ([10.254.96.46])
  by orsmga004-auth.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 28 Jan 2021 17:11:22 -0800
From:   Mat Martineau <mathew.j.martineau@linux.intel.com>
To:     netdev@vger.kernel.org
Cc:     Geliang Tang <geliangtang@gmail.com>, davem@davemloft.net,
        kuba@kernel.org, mptcp@lists.01.org,
        Mat Martineau <mathew.j.martineau@linux.intel.com>
Subject: [PATCH net-next 03/16] mptcp: create subflow or signal addr for newly added address
Date:   Thu, 28 Jan 2021 17:11:02 -0800
Message-Id: <20210129011115.133953-4-mathew.j.martineau@linux.intel.com>
X-Mailer: git-send-email 2.30.0
In-Reply-To: <20210129011115.133953-1-mathew.j.martineau@linux.intel.com>
References: <20210129011115.133953-1-mathew.j.martineau@linux.intel.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Geliang Tang <geliangtang@gmail.com>

Currently, when a new MPTCP endpoint is added, the existing MPTCP
sockets are not affected.

This patch implements a new function mptcp_nl_add_subflow_or_signal_addr,
invoked when an address is added from PM netlink. This function traverses
the MPTCP sockets list and invokes mptcp_pm_create_subflow_or_signal_addr
to try to create a subflow or signal an address for the newly added
address, if local constraint allows that.

Closes: https://github.com/multipath-tcp/mptcp_net-next/issues/19
Signed-off-by: Geliang Tang <geliangtang@gmail.com>
Signed-off-by: Mat Martineau <mathew.j.martineau@linux.intel.com>
---
 net/mptcp/pm_netlink.c | 27 +++++++++++++++++++++++++++
 1 file changed, 27 insertions(+)

diff --git a/net/mptcp/pm_netlink.c b/net/mptcp/pm_netlink.c
index 793f74cd0d47..d91ea0316a4f 100644
--- a/net/mptcp/pm_netlink.c
+++ b/net/mptcp/pm_netlink.c
@@ -850,6 +850,31 @@ static struct pm_nl_pernet *genl_info_pm_nl(struct genl_info *info)
 	return net_generic(genl_info_net(info), pm_nl_pernet_id);
 }
 
+static int mptcp_nl_add_subflow_or_signal_addr(struct net *net)
+{
+	struct mptcp_sock *msk;
+	long s_slot = 0, s_num = 0;
+
+	while ((msk = mptcp_token_iter_next(net, &s_slot, &s_num)) != NULL) {
+		struct sock *sk = (struct sock *)msk;
+
+		if (!READ_ONCE(msk->fully_established))
+			goto next;
+
+		lock_sock(sk);
+		spin_lock_bh(&msk->pm.lock);
+		mptcp_pm_create_subflow_or_signal_addr(msk);
+		spin_unlock_bh(&msk->pm.lock);
+		release_sock(sk);
+
+next:
+		sock_put(sk);
+		cond_resched();
+	}
+
+	return 0;
+}
+
 static int mptcp_nl_cmd_add_addr(struct sk_buff *skb, struct genl_info *info)
 {
 	struct nlattr *attr = info->attrs[MPTCP_PM_ATTR_ADDR];
@@ -875,6 +900,8 @@ static int mptcp_nl_cmd_add_addr(struct sk_buff *skb, struct genl_info *info)
 		return ret;
 	}
 
+	mptcp_nl_add_subflow_or_signal_addr(sock_net(skb->sk));
+
 	return 0;
 }
 
-- 
2.30.0

