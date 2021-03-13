Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 88DA2339ACB
	for <lists+netdev@lfdr.de>; Sat, 13 Mar 2021 02:17:17 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233020AbhCMBQi (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 12 Mar 2021 20:16:38 -0500
Received: from mga17.intel.com ([192.55.52.151]:1166 "EHLO mga17.intel.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S231789AbhCMBQ2 (ORCPT <rfc822;netdev@vger.kernel.org>);
        Fri, 12 Mar 2021 20:16:28 -0500
IronPort-SDR: 1fN+IpKjPahaUc5EiWb9vc5yjdKUqMpu7IHknEYwEtRkzA5LK0sf5WIi4yXaXw4lbVt2u0hleK
 ho3D1G/fUwwQ==
X-IronPort-AV: E=McAfee;i="6000,8403,9921"; a="168828241"
X-IronPort-AV: E=Sophos;i="5.81,245,1610438400"; 
   d="scan'208";a="168828241"
Received: from orsmga008.jf.intel.com ([10.7.209.65])
  by fmsmga107.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 12 Mar 2021 17:16:26 -0800
IronPort-SDR: m226NuyM1pUbl53xeZcwKXG+3ReH73cUgHV2jhKDT7BGZVtq1A/0Uyxl475FdMJcVcOvPEqfuv
 ASYXw9uLEprQ==
X-IronPort-AV: E=Sophos;i="5.81,245,1610438400"; 
   d="scan'208";a="411197372"
Received: from mjmartin-desk2.amr.corp.intel.com (HELO mjmartin-desk2.intel.com) ([10.255.228.204])
  by orsmga008-auth.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 12 Mar 2021 17:16:26 -0800
From:   Mat Martineau <mathew.j.martineau@linux.intel.com>
To:     netdev@vger.kernel.org
Cc:     Geliang Tang <geliangtang@gmail.com>, davem@davemloft.net,
        kuba@kernel.org, matthieu.baerts@tessares.net, mptcp@lists.01.org,
        Mat Martineau <mathew.j.martineau@linux.intel.com>
Subject: [PATCH net-next 03/11] mptcp: add rm_list in mptcp_options_received
Date:   Fri, 12 Mar 2021 17:16:13 -0800
Message-Id: <20210313011621.211661-4-mathew.j.martineau@linux.intel.com>
X-Mailer: git-send-email 2.30.2
In-Reply-To: <20210313011621.211661-1-mathew.j.martineau@linux.intel.com>
References: <20210313011621.211661-1-mathew.j.martineau@linux.intel.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Geliang Tang <geliangtang@gmail.com>

This patch changed the member rm_id in struct mptcp_options_received as a
list of the removing address ids, and renamed it to rm_list.

In mptcp_parse_option, parsed the RM_ADDR suboption and filled them into
the rm_list in struct mptcp_options_received.

In mptcp_incoming_options, passed this rm_list to the function
mptcp_pm_rm_addr_received.

It also changed the parameter type of mptcp_pm_rm_addr_received.

Signed-off-by: Geliang Tang <geliangtang@gmail.com>
Signed-off-by: Mat Martineau <mathew.j.martineau@linux.intel.com>
---
 net/mptcp/options.c  | 12 ++++++++----
 net/mptcp/pm.c       | 11 +++++++----
 net/mptcp/protocol.h |  5 +++--
 3 files changed, 18 insertions(+), 10 deletions(-)

diff --git a/net/mptcp/options.c b/net/mptcp/options.c
index e74d0513187f..5fabf3e9a38d 100644
--- a/net/mptcp/options.c
+++ b/net/mptcp/options.c
@@ -26,6 +26,7 @@ static void mptcp_parse_option(const struct sk_buff *skb,
 	int expected_opsize;
 	u8 version;
 	u8 flags;
+	u8 i;
 
 	switch (subtype) {
 	case MPTCPOPT_MP_CAPABLE:
@@ -272,14 +273,17 @@ static void mptcp_parse_option(const struct sk_buff *skb,
 		break;
 
 	case MPTCPOPT_RM_ADDR:
-		if (opsize != TCPOLEN_MPTCP_RM_ADDR_BASE)
+		if (opsize < TCPOLEN_MPTCP_RM_ADDR_BASE + 1 ||
+		    opsize > TCPOLEN_MPTCP_RM_ADDR_BASE + MPTCP_RM_IDS_MAX)
 			break;
 
 		ptr++;
 
 		mp_opt->rm_addr = 1;
-		mp_opt->rm_id = *ptr++;
-		pr_debug("RM_ADDR: id=%d", mp_opt->rm_id);
+		mp_opt->rm_list.nr = opsize - TCPOLEN_MPTCP_RM_ADDR_BASE;
+		for (i = 0; i < mp_opt->rm_list.nr; i++)
+			mp_opt->rm_list.ids[i] = *ptr++;
+		pr_debug("RM_ADDR: rm_list_nr=%d", mp_opt->rm_list.nr);
 		break;
 
 	case MPTCPOPT_MP_PRIO:
@@ -1043,7 +1047,7 @@ void mptcp_incoming_options(struct sock *sk, struct sk_buff *skb)
 	}
 
 	if (mp_opt.rm_addr) {
-		mptcp_pm_rm_addr_received(msk, mp_opt.rm_id);
+		mptcp_pm_rm_addr_received(msk, &mp_opt.rm_list);
 		mp_opt.rm_addr = 0;
 	}
 
diff --git a/net/mptcp/pm.c b/net/mptcp/pm.c
index 9a91605885bb..7553f82076ca 100644
--- a/net/mptcp/pm.c
+++ b/net/mptcp/pm.c
@@ -205,17 +205,20 @@ void mptcp_pm_add_addr_send_ack(struct mptcp_sock *msk)
 	mptcp_pm_schedule_work(msk, MPTCP_PM_ADD_ADDR_SEND_ACK);
 }
 
-void mptcp_pm_rm_addr_received(struct mptcp_sock *msk, u8 rm_id)
+void mptcp_pm_rm_addr_received(struct mptcp_sock *msk,
+			       const struct mptcp_rm_list *rm_list)
 {
 	struct mptcp_pm_data *pm = &msk->pm;
+	u8 i;
 
-	pr_debug("msk=%p remote_id=%d", msk, rm_id);
+	pr_debug("msk=%p remote_ids_nr=%d", msk, rm_list->nr);
 
-	mptcp_event_addr_removed(msk, rm_id);
+	for (i = 0; i < rm_list->nr; i++)
+		mptcp_event_addr_removed(msk, rm_list->ids[i]);
 
 	spin_lock_bh(&pm->lock);
 	mptcp_pm_schedule_work(msk, MPTCP_PM_RM_ADDR_RECEIVED);
-	pm->rm_id = rm_id;
+	pm->rm_id = rm_list->ids[0];
 	spin_unlock_bh(&pm->lock);
 }
 
diff --git a/net/mptcp/protocol.h b/net/mptcp/protocol.h
index ac15be7cf06b..d7daf7e0d5d2 100644
--- a/net/mptcp/protocol.h
+++ b/net/mptcp/protocol.h
@@ -142,7 +142,7 @@ struct mptcp_options_received {
 		mpc_map:1,
 		__unused:2;
 	u8	addr_id;
-	u8	rm_id;
+	struct mptcp_rm_list rm_list;
 	union {
 		struct in_addr	addr;
 #if IS_ENABLED(CONFIG_MPTCP_IPV6)
@@ -648,7 +648,8 @@ void mptcp_pm_subflow_closed(struct mptcp_sock *msk, u8 id);
 void mptcp_pm_add_addr_received(struct mptcp_sock *msk,
 				const struct mptcp_addr_info *addr);
 void mptcp_pm_add_addr_send_ack(struct mptcp_sock *msk);
-void mptcp_pm_rm_addr_received(struct mptcp_sock *msk, u8 rm_id);
+void mptcp_pm_rm_addr_received(struct mptcp_sock *msk,
+			       const struct mptcp_rm_list *rm_list);
 void mptcp_pm_mp_prio_received(struct sock *sk, u8 bkup);
 int mptcp_pm_nl_mp_prio_send_ack(struct mptcp_sock *msk,
 				 struct mptcp_addr_info *addr,
-- 
2.30.2

