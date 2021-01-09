Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id F13992EFC72
	for <lists+netdev@lfdr.de>; Sat,  9 Jan 2021 01:52:31 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727056AbhAIAuD (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 8 Jan 2021 19:50:03 -0500
Received: from mga03.intel.com ([134.134.136.65]:32288 "EHLO mga03.intel.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726959AbhAIAuC (ORCPT <rfc822;netdev@vger.kernel.org>);
        Fri, 8 Jan 2021 19:50:02 -0500
IronPort-SDR: eUzf3F4lYO0Hbpu/OV9NmtBZX+1fELHhd/r7EPP/2Wa4fkAhI/nXLoJE4eEXm10jNwwQUEPu5C
 0tye0Ij6aJXg==
X-IronPort-AV: E=McAfee;i="6000,8403,9858"; a="177771955"
X-IronPort-AV: E=Sophos;i="5.79,333,1602572400"; 
   d="scan'208";a="177771955"
Received: from orsmga001.jf.intel.com ([10.7.209.18])
  by orsmga103.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 08 Jan 2021 16:48:09 -0800
IronPort-SDR: RVD89VmOV0H6+V18iFJTsjH1SWVPo3vDBFJgsKJbOJH4S6Pw4wtj0Ho6Bv3lulAz2gtGesSZkb
 CRUWd+N5olKQ==
X-IronPort-AV: E=Sophos;i="5.79,333,1602572400"; 
   d="scan'208";a="423124501"
Received: from mjmartin-nuc02.amr.corp.intel.com ([10.251.4.171])
  by orsmga001-auth.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 08 Jan 2021 16:48:09 -0800
From:   Mat Martineau <mathew.j.martineau@linux.intel.com>
To:     netdev@vger.kernel.org
Cc:     Geliang Tang <geliangtang@gmail.com>, davem@davemloft.net,
        kuba@kernel.org, mptcp@lists.01.org,
        Mat Martineau <mathew.j.martineau@linux.intel.com>
Subject: [PATCH net-next 4/8] mptcp: add the incoming MP_PRIO support
Date:   Fri,  8 Jan 2021 16:47:58 -0800
Message-Id: <20210109004802.341602-5-mathew.j.martineau@linux.intel.com>
X-Mailer: git-send-email 2.30.0
In-Reply-To: <20210109004802.341602-1-mathew.j.martineau@linux.intel.com>
References: <20210109004802.341602-1-mathew.j.martineau@linux.intel.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Geliang Tang <geliangtang@gmail.com>

This patch added the incoming MP_PRIO logic:

Added a flag named mp_prio in struct mptcp_options_received, to mark the
MP_PRIO is received, and save the priority value to struct
mptcp_options_received's backup member. Then invoke
mptcp_pm_mp_prio_received with the receiving subsocket and the backup
value.

In mptcp_pm_mp_prio_received, get the subflow context according the input
subsocket, and change the subflow's backup as the incoming priority value.

Signed-off-by: Geliang Tang <geliangtang@gmail.com>
Signed-off-by: Mat Martineau <mathew.j.martineau@linux.intel.com>
---
 net/mptcp/options.c  | 15 +++++++++++++++
 net/mptcp/pm.c       |  8 ++++++++
 net/mptcp/protocol.h |  5 +++++
 3 files changed, 28 insertions(+)

diff --git a/net/mptcp/options.c b/net/mptcp/options.c
index ef50a8628d77..adfa96dd991c 100644
--- a/net/mptcp/options.c
+++ b/net/mptcp/options.c
@@ -282,6 +282,15 @@ static void mptcp_parse_option(const struct sk_buff *skb,
 		pr_debug("RM_ADDR: id=%d", mp_opt->rm_id);
 		break;
 
+	case MPTCPOPT_MP_PRIO:
+		if (opsize != TCPOLEN_MPTCP_PRIO)
+			break;
+
+		mp_opt->mp_prio = 1;
+		mp_opt->backup = *ptr++ & MPTCP_PRIO_BKUP;
+		pr_debug("MP_PRIO: prio=%d", mp_opt->backup);
+		break;
+
 	case MPTCPOPT_MP_FASTCLOSE:
 		if (opsize != TCPOLEN_MPTCP_FASTCLOSE)
 			break;
@@ -313,6 +322,7 @@ void mptcp_get_options(const struct sk_buff *skb,
 	mp_opt->port = 0;
 	mp_opt->rm_addr = 0;
 	mp_opt->dss = 0;
+	mp_opt->mp_prio = 0;
 
 	length = (th->doff * 4) - sizeof(struct tcphdr);
 	ptr = (const unsigned char *)(th + 1);
@@ -1022,6 +1032,11 @@ void mptcp_incoming_options(struct sock *sk, struct sk_buff *skb)
 		mp_opt.rm_addr = 0;
 	}
 
+	if (mp_opt.mp_prio) {
+		mptcp_pm_mp_prio_received(sk, mp_opt.backup);
+		mp_opt.mp_prio = 0;
+	}
+
 	if (!mp_opt.dss)
 		return;
 
diff --git a/net/mptcp/pm.c b/net/mptcp/pm.c
index da2ed576f289..0a6ebd0642ec 100644
--- a/net/mptcp/pm.c
+++ b/net/mptcp/pm.c
@@ -207,6 +207,14 @@ void mptcp_pm_rm_addr_received(struct mptcp_sock *msk, u8 rm_id)
 	spin_unlock_bh(&pm->lock);
 }
 
+void mptcp_pm_mp_prio_received(struct sock *sk, u8 bkup)
+{
+	struct mptcp_subflow_context *subflow = mptcp_subflow_ctx(sk);
+
+	pr_debug("subflow->backup=%d, bkup=%d\n", subflow->backup, bkup);
+	subflow->backup = bkup;
+}
+
 /* path manager helpers */
 
 bool mptcp_pm_add_addr_signal(struct mptcp_sock *msk, unsigned int remaining,
diff --git a/net/mptcp/protocol.h b/net/mptcp/protocol.h
index 21763e00d990..d6400ad2d615 100644
--- a/net/mptcp/protocol.h
+++ b/net/mptcp/protocol.h
@@ -88,6 +88,9 @@
 #define MPTCP_ADDR_IPVERSION_4	4
 #define MPTCP_ADDR_IPVERSION_6	6
 
+/* MPTCP MP_PRIO flags */
+#define MPTCP_PRIO_BKUP		BIT(0)
+
 /* MPTCP socket flags */
 #define MPTCP_DATA_READY	0
 #define MPTCP_NOSPACE		1
@@ -118,6 +121,7 @@ struct mptcp_options_received {
 		dss : 1,
 		add_addr : 1,
 		rm_addr : 1,
+		mp_prio : 1,
 		family : 4,
 		echo : 1,
 		backup : 1;
@@ -553,6 +557,7 @@ void mptcp_pm_add_addr_received(struct mptcp_sock *msk,
 				const struct mptcp_addr_info *addr);
 void mptcp_pm_add_addr_send_ack(struct mptcp_sock *msk);
 void mptcp_pm_rm_addr_received(struct mptcp_sock *msk, u8 rm_id);
+void mptcp_pm_mp_prio_received(struct sock *sk, u8 bkup);
 int mptcp_pm_nl_mp_prio_send_ack(struct mptcp_sock *msk,
 				 struct mptcp_addr_info *addr,
 				 u8 bkup);
-- 
2.30.0

