Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 530C7308315
	for <lists+netdev@lfdr.de>; Fri, 29 Jan 2021 02:16:37 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229596AbhA2BOq (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 28 Jan 2021 20:14:46 -0500
Received: from mga07.intel.com ([134.134.136.100]:6700 "EHLO mga07.intel.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S231672AbhA2BOe (ORCPT <rfc822;netdev@vger.kernel.org>);
        Thu, 28 Jan 2021 20:14:34 -0500
IronPort-SDR: TxRmOJk7kPpWKE3nK9dYiyq1GReY/3QSGIso918sTLwqx9c0Lt9+/ASJ/IobKJUzTYuXrj7F67
 D1ceXAoyH1BQ==
X-IronPort-AV: E=McAfee;i="6000,8403,9878"; a="244430169"
X-IronPort-AV: E=Sophos;i="5.79,384,1602572400"; 
   d="scan'208";a="244430169"
Received: from orsmga004.jf.intel.com ([10.7.209.38])
  by orsmga105.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 28 Jan 2021 17:11:23 -0800
IronPort-SDR: doBJvxEzs7Rlw5T1w9pfw9NEVJSr25+EBbu4DPm0z8iopHQjYnYApFWz3r82eHEQS7uIoQB2g/
 jPUCVaa5H+bQ==
X-IronPort-AV: E=Sophos;i="5.79,384,1602572400"; 
   d="scan'208";a="505538328"
Received: from mjmartin-desk2.amr.corp.intel.com (HELO mjmartin-desk2.intel.com) ([10.254.96.46])
  by orsmga004-auth.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 28 Jan 2021 17:11:22 -0800
From:   Mat Martineau <mathew.j.martineau@linux.intel.com>
To:     netdev@vger.kernel.org
Cc:     Geliang Tang <geliangtang@gmail.com>, davem@davemloft.net,
        kuba@kernel.org, mptcp@lists.01.org,
        Paolo Abeni <pabeni@redhat.com>,
        Mat Martineau <mathew.j.martineau@linux.intel.com>
Subject: [PATCH net-next 04/16] mptcp: send ack for every add_addr
Date:   Thu, 28 Jan 2021 17:11:03 -0800
Message-Id: <20210129011115.133953-5-mathew.j.martineau@linux.intel.com>
X-Mailer: git-send-email 2.30.0
In-Reply-To: <20210129011115.133953-1-mathew.j.martineau@linux.intel.com>
References: <20210129011115.133953-1-mathew.j.martineau@linux.intel.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Geliang Tang <geliangtang@gmail.com>

This patch changes the sending ACK conditions for the ADD_ADDR, send an
ACK packet for any ADD_ADDR, not just when ipv6 addresses or port
numbers are included.

Closes: https://github.com/multipath-tcp/mptcp_net-next/issues/139
Acked-by: Paolo Abeni <pabeni@redhat.com>
Signed-off-by: Geliang Tang <geliangtang@gmail.com>
Signed-off-by: Mat Martineau <mathew.j.martineau@linux.intel.com>
---
 net/mptcp/pm.c         |  3 +--
 net/mptcp/pm_netlink.c | 10 ++++------
 2 files changed, 5 insertions(+), 8 deletions(-)

diff --git a/net/mptcp/pm.c b/net/mptcp/pm.c
index 01a846b25771..3a22e73220b9 100644
--- a/net/mptcp/pm.c
+++ b/net/mptcp/pm.c
@@ -191,8 +191,7 @@ void mptcp_pm_add_addr_received(struct mptcp_sock *msk,
 
 void mptcp_pm_add_addr_send_ack(struct mptcp_sock *msk)
 {
-	if (!mptcp_pm_should_add_signal_ipv6(msk) &&
-	    !mptcp_pm_should_add_signal_port(msk))
+	if (!mptcp_pm_should_add_signal(msk))
 		return;
 
 	mptcp_pm_schedule_work(msk, MPTCP_PM_ADD_ADDR_SEND_ACK);
diff --git a/net/mptcp/pm_netlink.c b/net/mptcp/pm_netlink.c
index d91ea0316a4f..78a157a30c68 100644
--- a/net/mptcp/pm_netlink.c
+++ b/net/mptcp/pm_netlink.c
@@ -474,8 +474,7 @@ void mptcp_pm_nl_add_addr_send_ack(struct mptcp_sock *msk)
 {
 	struct mptcp_subflow_context *subflow;
 
-	if (!mptcp_pm_should_add_signal_ipv6(msk) &&
-	    !mptcp_pm_should_add_signal_port(msk))
+	if (!mptcp_pm_should_add_signal(msk))
 		return;
 
 	__mptcp_flush_join_list(msk);
@@ -485,10 +484,9 @@ void mptcp_pm_nl_add_addr_send_ack(struct mptcp_sock *msk)
 		u8 add_addr;
 
 		spin_unlock_bh(&msk->pm.lock);
-		if (mptcp_pm_should_add_signal_ipv6(msk))
-			pr_debug("send ack for add_addr6");
-		if (mptcp_pm_should_add_signal_port(msk))
-			pr_debug("send ack for add_addr_port");
+		pr_debug("send ack for add_addr%s%s",
+			 mptcp_pm_should_add_signal_ipv6(msk) ? " [ipv6]" : "",
+			 mptcp_pm_should_add_signal_port(msk) ? " [port]" : "");
 
 		lock_sock(ssk);
 		tcp_send_ack(ssk);
-- 
2.30.0

