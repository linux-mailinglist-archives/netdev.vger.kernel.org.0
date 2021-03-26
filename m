Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 150FF34AE94
	for <lists+netdev@lfdr.de>; Fri, 26 Mar 2021 19:28:32 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230411AbhCZS2E (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 26 Mar 2021 14:28:04 -0400
Received: from mga05.intel.com ([192.55.52.43]:12666 "EHLO mga05.intel.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S230231AbhCZS1h (ORCPT <rfc822;netdev@vger.kernel.org>);
        Fri, 26 Mar 2021 14:27:37 -0400
IronPort-SDR: oaY3J8qA5DP9Pb//GcigRm/TpET3GoHnRRxa0s/UJWgmiBYgOGmfljdx79LddXlP5/vxWb3qYH
 WX4kcJx5uHOg==
X-IronPort-AV: E=McAfee;i="6000,8403,9935"; a="276343006"
X-IronPort-AV: E=Sophos;i="5.81,281,1610438400"; 
   d="scan'208";a="276343006"
Received: from fmsmga002.fm.intel.com ([10.253.24.26])
  by fmsmga105.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 26 Mar 2021 11:27:36 -0700
IronPort-SDR: Ajb0OvmyjbwZ6oBZZSMTh9ct36WjRHPyYCsvJCTq5qcC01QGisf+ywv2d1mHqF2tEaMat+smkG
 8XT4JjWiic5Q==
X-IronPort-AV: E=Sophos;i="5.81,281,1610438400"; 
   d="scan'208";a="443456563"
Received: from mjmartin-desk2.amr.corp.intel.com (HELO mjmartin-desk2.intel.com) ([10.251.24.139])
  by fmsmga002-auth.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 26 Mar 2021 11:27:36 -0700
From:   Mat Martineau <mathew.j.martineau@linux.intel.com>
To:     netdev@vger.kernel.org
Cc:     Geliang Tang <geliangtang@gmail.com>, davem@davemloft.net,
        kuba@kernel.org, matthieu.baerts@tessares.net,
        mptcp@lists.linux.dev,
        Mat Martineau <mathew.j.martineau@linux.intel.com>
Subject: [PATCH net-next 10/13] mptcp: drop useless addr_signal clear
Date:   Fri, 26 Mar 2021 11:26:39 -0700
Message-Id: <20210326182642.136419-10-mathew.j.martineau@linux.intel.com>
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

msk->pm.addr_signal is cleared in mptcp_pm_add_addr_signal, no need to
clear it in mptcp_pm_nl_add_addr_send_ack again. Drop it.

Signed-off-by: Geliang Tang <geliangtang@gmail.com>
Signed-off-by: Mat Martineau <mathew.j.martineau@linux.intel.com>
---
 net/mptcp/pm_netlink.c | 8 --------
 1 file changed, 8 deletions(-)

diff --git a/net/mptcp/pm_netlink.c b/net/mptcp/pm_netlink.c
index 56d479b24803..743bd23b1f78 100644
--- a/net/mptcp/pm_netlink.c
+++ b/net/mptcp/pm_netlink.c
@@ -538,7 +538,6 @@ static void mptcp_pm_nl_add_addr_send_ack(struct mptcp_sock *msk)
 	subflow = list_first_entry_or_null(&msk->conn_list, typeof(*subflow), node);
 	if (subflow) {
 		struct sock *ssk = mptcp_subflow_tcp_sock(subflow);
-		u8 add_addr;
 
 		spin_unlock_bh(&msk->pm.lock);
 		pr_debug("send ack for add_addr%s%s",
@@ -549,13 +548,6 @@ static void mptcp_pm_nl_add_addr_send_ack(struct mptcp_sock *msk)
 		tcp_send_ack(ssk);
 		release_sock(ssk);
 		spin_lock_bh(&msk->pm.lock);
-
-		add_addr = READ_ONCE(msk->pm.addr_signal);
-		if (mptcp_pm_should_add_signal_ipv6(msk))
-			add_addr &= ~BIT(MPTCP_ADD_ADDR_IPV6);
-		if (mptcp_pm_should_add_signal_port(msk))
-			add_addr &= ~BIT(MPTCP_ADD_ADDR_PORT);
-		WRITE_ONCE(msk->pm.addr_signal, add_addr);
 	}
 }
 
-- 
2.31.0

