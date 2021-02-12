Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id C32F431A886
	for <lists+netdev@lfdr.de>; Sat, 13 Feb 2021 01:02:19 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231337AbhBMACF (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 12 Feb 2021 19:02:05 -0500
Received: from mga04.intel.com ([192.55.52.120]:41405 "EHLO mga04.intel.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S229497AbhBMACA (ORCPT <rfc822;netdev@vger.kernel.org>);
        Fri, 12 Feb 2021 19:02:00 -0500
IronPort-SDR: IttxS3TRRGqOnAIDDEuUnl8K+dfewh/5wywnOS7l6jS6yWuEbJaKtbjrfCOAjf08Pj8wmWFSh6
 pfEzMa82u/mQ==
X-IronPort-AV: E=McAfee;i="6000,8403,9893"; a="179937486"
X-IronPort-AV: E=Sophos;i="5.81,175,1610438400"; 
   d="scan'208";a="179937486"
Received: from fmsmga002.fm.intel.com ([10.253.24.26])
  by fmsmga104.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 12 Feb 2021 16:00:14 -0800
IronPort-SDR: Uf+LybOO9FuKyXKbLTP6hYul5xB/05WjioSB+OEhEPaWUOnrQqjXJwK9dx9sbs6OuOlm3MLGDJ
 cEYwReQ+fUug==
X-IronPort-AV: E=Sophos;i="5.81,175,1610438400"; 
   d="scan'208";a="423381132"
Received: from mjmartin-desk2.amr.corp.intel.com (HELO mjmartin-desk2.intel.com) ([10.254.85.171])
  by fmsmga002-auth.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 12 Feb 2021 16:00:13 -0800
From:   Mat Martineau <mathew.j.martineau@linux.intel.com>
To:     netdev@vger.kernel.org
Cc:     Florian Westphal <fw@strlen.de>, davem@davemloft.net,
        kuba@kernel.org, mptcp@lists.01.org, matthieu.baerts@tessares.net,
        Mat Martineau <mathew.j.martineau@linux.intel.com>
Subject: [PATCH net-next 5/8] mptcp: pass subflow socket to a few helpers
Date:   Fri, 12 Feb 2021 15:59:58 -0800
Message-Id: <20210213000001.379332-6-mathew.j.martineau@linux.intel.com>
X-Mailer: git-send-email 2.30.1
In-Reply-To: <20210213000001.379332-1-mathew.j.martineau@linux.intel.com>
References: <20210213000001.379332-1-mathew.j.martineau@linux.intel.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Florian Westphal <fw@strlen.de>

Pass the first/initial subflow to the existing functions so they can
pass this on to the notification handler that is added later in the
series.

Signed-off-by: Florian Westphal <fw@strlen.de>
Signed-off-by: Mat Martineau <mathew.j.martineau@linux.intel.com>
---
 net/mptcp/options.c  | 2 +-
 net/mptcp/pm.c       | 4 ++--
 net/mptcp/protocol.c | 4 ++--
 net/mptcp/protocol.h | 4 ++--
 net/mptcp/subflow.c  | 2 +-
 5 files changed, 8 insertions(+), 8 deletions(-)

diff --git a/net/mptcp/options.c b/net/mptcp/options.c
index 3b71d68b3863..bb874c5d663a 100644
--- a/net/mptcp/options.c
+++ b/net/mptcp/options.c
@@ -867,7 +867,7 @@ static bool check_fully_established(struct mptcp_sock *msk, struct sock *ssk,
 		clear_3rdack_retransmission(ssk);
 		mptcp_pm_subflow_established(msk, subflow);
 	} else {
-		mptcp_pm_fully_established(msk);
+		mptcp_pm_fully_established(msk, ssk, GFP_ATOMIC);
 	}
 	return true;
 
diff --git a/net/mptcp/pm.c b/net/mptcp/pm.c
index 1a25003fd8e3..1dd0e9d7ed06 100644
--- a/net/mptcp/pm.c
+++ b/net/mptcp/pm.c
@@ -68,7 +68,7 @@ int mptcp_pm_remove_subflow(struct mptcp_sock *msk, u8 local_id)
 
 /* path manager event handlers */
 
-void mptcp_pm_new_connection(struct mptcp_sock *msk, int server_side)
+void mptcp_pm_new_connection(struct mptcp_sock *msk, const struct sock *ssk, int server_side)
 {
 	struct mptcp_pm_data *pm = &msk->pm;
 
@@ -119,7 +119,7 @@ static bool mptcp_pm_schedule_work(struct mptcp_sock *msk,
 	return true;
 }
 
-void mptcp_pm_fully_established(struct mptcp_sock *msk)
+void mptcp_pm_fully_established(struct mptcp_sock *msk, const struct sock *ssk, gfp_t gfp)
 {
 	struct mptcp_pm_data *pm = &msk->pm;
 
diff --git a/net/mptcp/protocol.c b/net/mptcp/protocol.c
index 1b8be2bf6b43..56240b87d464 100644
--- a/net/mptcp/protocol.c
+++ b/net/mptcp/protocol.c
@@ -3028,7 +3028,7 @@ void mptcp_finish_connect(struct sock *ssk)
 	WRITE_ONCE(msk->can_ack, 1);
 	WRITE_ONCE(msk->snd_una, msk->write_seq);
 
-	mptcp_pm_new_connection(msk, 0);
+	mptcp_pm_new_connection(msk, ssk, 0);
 
 	mptcp_rcv_space_init(msk, ssk);
 }
@@ -3272,7 +3272,7 @@ static int mptcp_stream_accept(struct socket *sock, struct socket *newsock,
 		list_add(&subflow->node, &msk->conn_list);
 		sock_hold(msk->first);
 		if (mptcp_is_fully_established(newsk))
-			mptcp_pm_fully_established(msk);
+			mptcp_pm_fully_established(msk, msk->first, GFP_KERNEL);
 
 		mptcp_copy_inaddrs(newsk, msk->first);
 		mptcp_rcv_space_init(msk, msk->first);
diff --git a/net/mptcp/protocol.h b/net/mptcp/protocol.h
index 3081294dca6c..f620e2f98d19 100644
--- a/net/mptcp/protocol.h
+++ b/net/mptcp/protocol.h
@@ -639,8 +639,8 @@ void mptcp_crypto_hmac_sha(u64 key1, u64 key2, u8 *msg, int len, void *hmac);
 
 void __init mptcp_pm_init(void);
 void mptcp_pm_data_init(struct mptcp_sock *msk);
-void mptcp_pm_new_connection(struct mptcp_sock *msk, int server_side);
-void mptcp_pm_fully_established(struct mptcp_sock *msk);
+void mptcp_pm_new_connection(struct mptcp_sock *msk, const struct sock *ssk, int server_side);
+void mptcp_pm_fully_established(struct mptcp_sock *msk, const struct sock *ssk, gfp_t gfp);
 bool mptcp_pm_allow_new_subflow(struct mptcp_sock *msk);
 void mptcp_pm_connection_closed(struct mptcp_sock *msk);
 void mptcp_pm_subflow_established(struct mptcp_sock *msk,
diff --git a/net/mptcp/subflow.c b/net/mptcp/subflow.c
index 36b15726f851..ce2dea2a6e0a 100644
--- a/net/mptcp/subflow.c
+++ b/net/mptcp/subflow.c
@@ -675,7 +675,7 @@ static struct sock *subflow_syn_recv_sock(const struct sock *sk,
 			 * created mptcp socket
 			 */
 			new_msk->sk_destruct = mptcp_sock_destruct;
-			mptcp_pm_new_connection(mptcp_sk(new_msk), 1);
+			mptcp_pm_new_connection(mptcp_sk(new_msk), child, 1);
 			mptcp_token_accept(subflow_req, mptcp_sk(new_msk));
 			ctx->conn = new_msk;
 			new_msk = NULL;
-- 
2.30.1

