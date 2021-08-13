Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 887FE3EBE36
	for <lists+netdev@lfdr.de>; Sat, 14 Aug 2021 00:16:13 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S235337AbhHMWQh (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 13 Aug 2021 18:16:37 -0400
Received: from mga11.intel.com ([192.55.52.93]:29033 "EHLO mga11.intel.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S235098AbhHMWQY (ORCPT <rfc822;netdev@vger.kernel.org>);
        Fri, 13 Aug 2021 18:16:24 -0400
X-IronPort-AV: E=McAfee;i="6200,9189,10075"; a="212520905"
X-IronPort-AV: E=Sophos;i="5.84,320,1620716400"; 
   d="scan'208";a="212520905"
Received: from orsmga001.jf.intel.com ([10.7.209.18])
  by fmsmga102.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 13 Aug 2021 15:15:55 -0700
X-IronPort-AV: E=Sophos;i="5.84,320,1620716400"; 
   d="scan'208";a="504320457"
Received: from mjmartin-desk2.amr.corp.intel.com (HELO mjmartin-desk2.intel.com) ([10.209.69.245])
  by orsmga001-auth.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 13 Aug 2021 15:15:55 -0700
From:   Mat Martineau <mathew.j.martineau@linux.intel.com>
To:     netdev@vger.kernel.org
Cc:     Paolo Abeni <pabeni@redhat.com>, davem@davemloft.net,
        kuba@kernel.org, matthieu.baerts@tessares.net,
        mptcp@lists.linux.dev,
        Mat Martineau <mathew.j.martineau@linux.intel.com>
Subject: [PATCH net-next 6/8] mptcp: add mibs for stale subflows processing
Date:   Fri, 13 Aug 2021 15:15:46 -0700
Message-Id: <20210813221548.111990-7-mathew.j.martineau@linux.intel.com>
X-Mailer: git-send-email 2.32.0
In-Reply-To: <20210813221548.111990-1-mathew.j.martineau@linux.intel.com>
References: <20210813221548.111990-1-mathew.j.martineau@linux.intel.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Paolo Abeni <pabeni@redhat.com>

This allows monitoring exceptional events like
active backup scenarios.

Signed-off-by: Paolo Abeni <pabeni@redhat.com>
Signed-off-by: Mat Martineau <mathew.j.martineau@linux.intel.com>
---
 net/mptcp/mib.c        | 2 ++
 net/mptcp/mib.h        | 2 ++
 net/mptcp/pm.c         | 2 ++
 net/mptcp/pm_netlink.c | 1 +
 net/mptcp/protocol.c   | 1 +
 5 files changed, 8 insertions(+)

diff --git a/net/mptcp/mib.c b/net/mptcp/mib.c
index ff2cc0e3273d..3a7c4e7b2d79 100644
--- a/net/mptcp/mib.c
+++ b/net/mptcp/mib.c
@@ -45,6 +45,8 @@ static const struct snmp_mib mptcp_snmp_list[] = {
 	SNMP_MIB_ITEM("MPPrioTx", MPTCP_MIB_MPPRIOTX),
 	SNMP_MIB_ITEM("MPPrioRx", MPTCP_MIB_MPPRIORX),
 	SNMP_MIB_ITEM("RcvPruned", MPTCP_MIB_RCVPRUNED),
+	SNMP_MIB_ITEM("SubflowStale", MPTCP_MIB_SUBFLOWSTALE),
+	SNMP_MIB_ITEM("SubflowRecover", MPTCP_MIB_SUBFLOWRECOVER),
 	SNMP_MIB_SENTINEL
 };
 
diff --git a/net/mptcp/mib.h b/net/mptcp/mib.h
index 0663cb12b448..8ec16c991aac 100644
--- a/net/mptcp/mib.h
+++ b/net/mptcp/mib.h
@@ -38,6 +38,8 @@ enum linux_mptcp_mib_field {
 	MPTCP_MIB_MPPRIOTX,		/* Transmit a MP_PRIO */
 	MPTCP_MIB_MPPRIORX,		/* Received a MP_PRIO */
 	MPTCP_MIB_RCVPRUNED,		/* Incoming packet dropped due to memory limit */
+	MPTCP_MIB_SUBFLOWSTALE,		/* Subflows entered 'stale' status */
+	MPTCP_MIB_SUBFLOWRECOVER,	/* Subflows returned to active status after being stale */
 	__MPTCP_MIB_MAX
 };
 
diff --git a/net/mptcp/pm.c b/net/mptcp/pm.c
index d8a85fe92360..0ed3e565f8f8 100644
--- a/net/mptcp/pm.c
+++ b/net/mptcp/pm.c
@@ -10,6 +10,8 @@
 #include <net/mptcp.h>
 #include "protocol.h"
 
+#include "mib.h"
+
 /* path manager command handlers */
 
 int mptcp_pm_announce_addr(struct mptcp_sock *msk,
diff --git a/net/mptcp/pm_netlink.c b/net/mptcp/pm_netlink.c
index c0eb14e05bea..ac0aa6faacfa 100644
--- a/net/mptcp/pm_netlink.c
+++ b/net/mptcp/pm_netlink.c
@@ -923,6 +923,7 @@ void mptcp_pm_nl_subflow_chk_stale(const struct mptcp_sock *msk, struct sock *ss
 			if (!tcp_rtx_and_write_queues_empty(ssk)) {
 				subflow->stale = 1;
 				__mptcp_retransmit_pending_data(sk);
+				MPTCP_INC_STATS(sock_net(sk), MPTCP_MIB_SUBFLOWSTALE);
 			}
 			unlock_sock_fast(ssk, slow);
 
diff --git a/net/mptcp/protocol.c b/net/mptcp/protocol.c
index 18d3adccba5c..22214a58d892 100644
--- a/net/mptcp/protocol.c
+++ b/net/mptcp/protocol.c
@@ -1397,6 +1397,7 @@ void mptcp_subflow_set_active(struct mptcp_subflow_context *subflow)
 		return;
 
 	subflow->stale = 0;
+	MPTCP_INC_STATS(sock_net(mptcp_subflow_tcp_sock(subflow)), MPTCP_MIB_SUBFLOWRECOVER);
 }
 
 bool mptcp_subflow_active(struct mptcp_subflow_context *subflow)
-- 
2.32.0

