Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 53F7A34AE8E
	for <lists+netdev@lfdr.de>; Fri, 26 Mar 2021 19:28:29 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230319AbhCZS2A (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 26 Mar 2021 14:28:00 -0400
Received: from mga05.intel.com ([192.55.52.43]:12659 "EHLO mga05.intel.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S230209AbhCZS1f (ORCPT <rfc822;netdev@vger.kernel.org>);
        Fri, 26 Mar 2021 14:27:35 -0400
IronPort-SDR: blvmGlZwG9rHSV620zRvzbt6jeKTwSjVe+uwjphkFXWD7wWgGryIhQcuQhfpcSA7KwidzbjjPo
 sJ1/v3gvMQug==
X-IronPort-AV: E=McAfee;i="6000,8403,9935"; a="276342996"
X-IronPort-AV: E=Sophos;i="5.81,281,1610438400"; 
   d="scan'208";a="276342996"
Received: from fmsmga002.fm.intel.com ([10.253.24.26])
  by fmsmga105.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 26 Mar 2021 11:27:35 -0700
IronPort-SDR: PwtBh9T+P78TpV4D4zQRO4iEY87FKz3pOceG4yD+HJCWyKNziw/e1xewRSBo+Jpy3YZNp6zi4Q
 yDLFASCRy+UQ==
X-IronPort-AV: E=Sophos;i="5.81,281,1610438400"; 
   d="scan'208";a="443456549"
Received: from mjmartin-desk2.amr.corp.intel.com (HELO mjmartin-desk2.intel.com) ([10.251.24.139])
  by fmsmga002-auth.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 26 Mar 2021 11:27:34 -0700
From:   Mat Martineau <mathew.j.martineau@linux.intel.com>
To:     netdev@vger.kernel.org
Cc:     Geliang Tang <geliangtang@gmail.com>, davem@davemloft.net,
        kuba@kernel.org, matthieu.baerts@tessares.net,
        mptcp@lists.linux.dev,
        Mat Martineau <mathew.j.martineau@linux.intel.com>
Subject: [PATCH net-next 05/13] mptcp: move to next addr when timeout
Date:   Fri, 26 Mar 2021 11:26:34 -0700
Message-Id: <20210326182642.136419-5-mathew.j.martineau@linux.intel.com>
X-Mailer: git-send-email 2.31.0
In-Reply-To: <20210326182642.136419-1-mathew.j.martineau@linux.intel.com>
References: <20210326182307.136256-1-mathew.j.martineau@linux.intel.com>
 <20210326182642.136419-1-mathew.j.martineau@linux.intel.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Geliang Tang <geliangtang@gmail.com>

This patch called mptcp_pm_subflow_established to move to the next address
when an ADD_ADDR has been retransmitted the maximum number of times.

Signed-off-by: Geliang Tang <geliangtang@gmail.com>
Signed-off-by: Mat Martineau <mathew.j.martineau@linux.intel.com>
---
 net/mptcp/pm_netlink.c | 3 +++
 1 file changed, 3 insertions(+)

diff --git a/net/mptcp/pm_netlink.c b/net/mptcp/pm_netlink.c
index 4b4b87803f33..c0c942c101cb 100644
--- a/net/mptcp/pm_netlink.c
+++ b/net/mptcp/pm_netlink.c
@@ -337,6 +337,9 @@ static void mptcp_pm_add_timer(struct timer_list *timer)
 
 	spin_unlock_bh(&msk->pm.lock);
 
+	if (entry->retrans_times == ADD_ADDR_RETRANS_MAX)
+		mptcp_pm_subflow_established(msk);
+
 out:
 	__sock_put(sk);
 }
-- 
2.31.0

