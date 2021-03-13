Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 6141B339AC4
	for <lists+netdev@lfdr.de>; Sat, 13 Mar 2021 02:17:14 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232627AbhCMBQb (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 12 Mar 2021 20:16:31 -0500
Received: from mga17.intel.com ([192.55.52.151]:1166 "EHLO mga17.intel.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S229959AbhCMBQ1 (ORCPT <rfc822;netdev@vger.kernel.org>);
        Fri, 12 Mar 2021 20:16:27 -0500
IronPort-SDR: HAtZT/droN37n/69nxcfXzxWbSmZITEEYWbFzBnb+Ef3dAzry/GWgGGjr2wFfDaE+7FBXUoOrb
 2FEWxpCwSA5g==
X-IronPort-AV: E=McAfee;i="6000,8403,9921"; a="168828243"
X-IronPort-AV: E=Sophos;i="5.81,245,1610438400"; 
   d="scan'208";a="168828243"
Received: from orsmga008.jf.intel.com ([10.7.209.65])
  by fmsmga107.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 12 Mar 2021 17:16:27 -0800
IronPort-SDR: 4fmNedLqjaRusUsKdSn0wIR9RdvCkxuaA0RUBaNocP+GMtLgSUzKSOG6s/5UTQnZfNhgnL44xT
 VEOjCKZTV8fg==
X-IronPort-AV: E=Sophos;i="5.81,245,1610438400"; 
   d="scan'208";a="411197373"
Received: from mjmartin-desk2.amr.corp.intel.com (HELO mjmartin-desk2.intel.com) ([10.255.228.204])
  by orsmga008-auth.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 12 Mar 2021 17:16:26 -0800
From:   Mat Martineau <mathew.j.martineau@linux.intel.com>
To:     netdev@vger.kernel.org
Cc:     Geliang Tang <geliangtang@gmail.com>, davem@davemloft.net,
        kuba@kernel.org, matthieu.baerts@tessares.net, mptcp@lists.01.org,
        Mat Martineau <mathew.j.martineau@linux.intel.com>
Subject: [PATCH net-next 04/11] mptcp: add rm_list_rx in mptcp_pm_data
Date:   Fri, 12 Mar 2021 17:16:14 -0800
Message-Id: <20210313011621.211661-5-mathew.j.martineau@linux.intel.com>
X-Mailer: git-send-email 2.30.2
In-Reply-To: <20210313011621.211661-1-mathew.j.martineau@linux.intel.com>
References: <20210313011621.211661-1-mathew.j.martineau@linux.intel.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Geliang Tang <geliangtang@gmail.com>

This patch added a new member rm_list_rx for struct mptcp_pm_data as an
list of the removing address ids on the incoming direction. Initialized
its nr field to zero in mptcp_pm_data_init.

In mptcp_pm_rm_addr_received, set it as the input rm_list.

Signed-off-by: Geliang Tang <geliangtang@gmail.com>
Signed-off-by: Mat Martineau <mathew.j.martineau@linux.intel.com>
---
 net/mptcp/pm.c       | 3 ++-
 net/mptcp/protocol.h | 1 +
 2 files changed, 3 insertions(+), 1 deletion(-)

diff --git a/net/mptcp/pm.c b/net/mptcp/pm.c
index 7553f82076ca..a47436205d88 100644
--- a/net/mptcp/pm.c
+++ b/net/mptcp/pm.c
@@ -218,7 +218,7 @@ void mptcp_pm_rm_addr_received(struct mptcp_sock *msk,
 
 	spin_lock_bh(&pm->lock);
 	mptcp_pm_schedule_work(msk, MPTCP_PM_RM_ADDR_RECEIVED);
-	pm->rm_id = rm_list->ids[0];
+	pm->rm_list_rx = *rm_list;
 	spin_unlock_bh(&pm->lock);
 }
 
@@ -300,6 +300,7 @@ void mptcp_pm_data_init(struct mptcp_sock *msk)
 	msk->pm.local_addr_used = 0;
 	msk->pm.subflows = 0;
 	msk->pm.rm_list_tx.nr = 0;
+	msk->pm.rm_list_rx.nr = 0;
 	WRITE_ONCE(msk->pm.work_pending, false);
 	WRITE_ONCE(msk->pm.addr_signal, 0);
 	WRITE_ONCE(msk->pm.accept_addr, false);
diff --git a/net/mptcp/protocol.h b/net/mptcp/protocol.h
index d7daf7e0d5d2..82a63abf2c7e 100644
--- a/net/mptcp/protocol.h
+++ b/net/mptcp/protocol.h
@@ -208,6 +208,7 @@ struct mptcp_pm_data {
 	u8		subflows;
 	u8		status;
 	struct mptcp_rm_list rm_list_tx;
+	struct mptcp_rm_list rm_list_rx;
 	u8		rm_id;
 };
 
-- 
2.30.2

