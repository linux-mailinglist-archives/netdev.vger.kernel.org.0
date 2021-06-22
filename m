Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 550A03B0D9F
	for <lists+netdev@lfdr.de>; Tue, 22 Jun 2021 21:25:40 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232693AbhFVT1t (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 22 Jun 2021 15:27:49 -0400
Received: from mga12.intel.com ([192.55.52.136]:32268 "EHLO mga12.intel.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S232418AbhFVT1q (ORCPT <rfc822;netdev@vger.kernel.org>);
        Tue, 22 Jun 2021 15:27:46 -0400
IronPort-SDR: aVhraIAvoRB0S+OHC1vO/BdKk7RrWttKHFyJoMZjscrYq/ee62HFcjJdir9A0ajNtFUwCp8/dK
 mnKXkHBsefQA==
X-IronPort-AV: E=McAfee;i="6200,9189,10023"; a="186818200"
X-IronPort-AV: E=Sophos;i="5.83,292,1616482800"; 
   d="scan'208";a="186818200"
Received: from fmsmga003.fm.intel.com ([10.253.24.29])
  by fmsmga106.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 22 Jun 2021 12:25:29 -0700
IronPort-SDR: w2GhLzl5kCPE21Xbz/oCmehhQ4aKAtLUm3EBgtWBijYG2eJX0ZiC5sfZc6YaopemXlLjhNaYaU
 84YVRSEfpB5A==
X-IronPort-AV: E=Sophos;i="5.83,292,1616482800"; 
   d="scan'208";a="480909721"
Received: from mjmartin-desk2.amr.corp.intel.com (HELO mjmartin-desk2.intel.com) ([10.212.237.182])
  by fmsmga003-auth.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 22 Jun 2021 12:25:29 -0700
From:   Mat Martineau <mathew.j.martineau@linux.intel.com>
To:     netdev@vger.kernel.org
Cc:     Geliang Tang <geliangtang@gmail.com>, davem@davemloft.net,
        kuba@kernel.org, matthieu.baerts@tessares.net,
        mptcp@lists.linux.dev, Florian Westphal <fw@strlen.de>,
        Paolo Abeni <pabeni@redhat.com>,
        Mat Martineau <mathew.j.martineau@linux.intel.com>
Subject: [PATCH net-next 3/6] mptcp: add deny_join_id0 in mptcp_options_received
Date:   Tue, 22 Jun 2021 12:25:20 -0700
Message-Id: <20210622192523.90117-4-mathew.j.martineau@linux.intel.com>
X-Mailer: git-send-email 2.32.0
In-Reply-To: <20210622192523.90117-1-mathew.j.martineau@linux.intel.com>
References: <20210622192523.90117-1-mathew.j.martineau@linux.intel.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Geliang Tang <geliangtang@gmail.com>

This patch added a new flag named deny_join_id0 in struct
mptcp_options_received. Set it when MP_CAPABLE with the flag
MPTCP_CAP_DENYJOIN_ID0 is received.

Also add a new flag remote_deny_join_id0 in struct mptcp_pm_data. When the
flag deny_join_id0 is set, set this remote_deny_join_id0 flag.

In mptcp_pm_create_subflow_or_signal_addr, if the remote_deny_join_id0 flag
is set, and the remote address id is zero, stop this connection.

Suggested-by: Florian Westphal <fw@strlen.de>
Acked-by: Paolo Abeni <pabeni@redhat.com>
Signed-off-by: Geliang Tang <geliangtang@gmail.com>
Signed-off-by: Mat Martineau <mathew.j.martineau@linux.intel.com>
---
 net/mptcp/options.c    | 7 +++++++
 net/mptcp/pm.c         | 1 +
 net/mptcp/pm_netlink.c | 3 ++-
 net/mptcp/protocol.h   | 4 +++-
 net/mptcp/subflow.c    | 2 ++
 5 files changed, 15 insertions(+), 2 deletions(-)

diff --git a/net/mptcp/options.c b/net/mptcp/options.c
index 7a4b6d0bf3f6..a05270996613 100644
--- a/net/mptcp/options.c
+++ b/net/mptcp/options.c
@@ -83,6 +83,9 @@ static void mptcp_parse_option(const struct sk_buff *skb,
 		if (flags & MPTCP_CAP_CHECKSUM_REQD)
 			mp_opt->csum_reqd = 1;
 
+		if (flags & MPTCP_CAP_DENY_JOIN_ID0)
+			mp_opt->deny_join_id0 = 1;
+
 		mp_opt->mp_capable = 1;
 		if (opsize >= TCPOLEN_MPTCP_MPC_SYNACK) {
 			mp_opt->sndr_key = get_unaligned_be64(ptr);
@@ -360,6 +363,7 @@ void mptcp_get_options(const struct sock *sk,
 	mp_opt->mp_prio = 0;
 	mp_opt->reset = 0;
 	mp_opt->csum_reqd = READ_ONCE(msk->csum_enabled);
+	mp_opt->deny_join_id0 = 0;
 
 	length = (th->doff * 4) - sizeof(struct tcphdr);
 	ptr = (const unsigned char *)(th + 1);
@@ -908,6 +912,9 @@ static bool check_fully_established(struct mptcp_sock *msk, struct sock *ssk,
 		return false;
 	}
 
+	if (mp_opt->deny_join_id0)
+		WRITE_ONCE(msk->pm.remote_deny_join_id0, true);
+
 	if (unlikely(!READ_ONCE(msk->pm.server_side)))
 		pr_warn_once("bogus mpc option on established client sk");
 	mptcp_subflow_fully_established(subflow, mp_opt);
diff --git a/net/mptcp/pm.c b/net/mptcp/pm.c
index 9d00fa6d22e9..639271e09604 100644
--- a/net/mptcp/pm.c
+++ b/net/mptcp/pm.c
@@ -320,6 +320,7 @@ void mptcp_pm_data_init(struct mptcp_sock *msk)
 	WRITE_ONCE(msk->pm.addr_signal, 0);
 	WRITE_ONCE(msk->pm.accept_addr, false);
 	WRITE_ONCE(msk->pm.accept_subflow, false);
+	WRITE_ONCE(msk->pm.remote_deny_join_id0, false);
 	msk->pm.status = 0;
 
 	spin_lock_init(&msk->pm.lock);
diff --git a/net/mptcp/pm_netlink.c b/net/mptcp/pm_netlink.c
index d4732a4f223e..d2591ebf01d9 100644
--- a/net/mptcp/pm_netlink.c
+++ b/net/mptcp/pm_netlink.c
@@ -451,7 +451,8 @@ static void mptcp_pm_create_subflow_or_signal_addr(struct mptcp_sock *msk)
 
 	/* check if should create a new subflow */
 	if (msk->pm.local_addr_used < local_addr_max &&
-	    msk->pm.subflows < subflows_max) {
+	    msk->pm.subflows < subflows_max &&
+	    !READ_ONCE(msk->pm.remote_deny_join_id0)) {
 		local = select_local_address(pernet, msk);
 		if (local) {
 			struct mptcp_addr_info remote = { 0 };
diff --git a/net/mptcp/protocol.h b/net/mptcp/protocol.h
index f2326f6074b9..f4eaa5f57e3f 100644
--- a/net/mptcp/protocol.h
+++ b/net/mptcp/protocol.h
@@ -138,7 +138,8 @@ struct mptcp_options_received {
 		mp_prio : 1,
 		echo : 1,
 		csum_reqd : 1,
-		backup : 1;
+		backup : 1,
+		deny_join_id0 : 1;
 	u32	token;
 	u32	nonce;
 	u64	thmac;
@@ -193,6 +194,7 @@ struct mptcp_pm_data {
 	bool		work_pending;
 	bool		accept_addr;
 	bool		accept_subflow;
+	bool		remote_deny_join_id0;
 	u8		add_addr_signaled;
 	u8		add_addr_accepted;
 	u8		local_addr_used;
diff --git a/net/mptcp/subflow.c b/net/mptcp/subflow.c
index e9e8ce862218..d55f4ef736a5 100644
--- a/net/mptcp/subflow.c
+++ b/net/mptcp/subflow.c
@@ -408,6 +408,8 @@ static void subflow_finish_connect(struct sock *sk, const struct sk_buff *skb)
 
 		if (mp_opt.csum_reqd)
 			WRITE_ONCE(mptcp_sk(parent)->csum_enabled, true);
+		if (mp_opt.deny_join_id0)
+			WRITE_ONCE(mptcp_sk(parent)->pm.remote_deny_join_id0, true);
 		subflow->mp_capable = 1;
 		subflow->can_ack = 1;
 		subflow->remote_key = mp_opt.sndr_key;
-- 
2.32.0

