Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 1D3DA4B7D53
	for <lists+netdev@lfdr.de>; Wed, 16 Feb 2022 03:21:16 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1343624AbiBPCMN (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 15 Feb 2022 21:12:13 -0500
Received: from mxb-00190b01.gslb.pphosted.com ([23.128.96.19]:52148 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1343574AbiBPCMB (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 15 Feb 2022 21:12:01 -0500
Received: from mga02.intel.com (mga02.intel.com [134.134.136.20])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 86ED625C6F
        for <netdev@vger.kernel.org>; Tue, 15 Feb 2022 18:11:44 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1644977504; x=1676513504;
  h=from:to:cc:subject:date:message-id:in-reply-to:
   references:mime-version:content-transfer-encoding;
  bh=n2nXdu5nNJkPcDV95CNUS45peiEoulnhateBofGFB04=;
  b=XGUu3spTfDsYxq41+ZI3mTuvm04pYudsJdY7FfCrm6oFIztFYOp5FLPL
   7KJoTTl2rhauNzOU+7M3AQWdgaG1PSXW6+m108TXiXRSBvA8oQ++3xKsI
   7L9b9EuqwLSQ76kEmcbdXQ7WsDRI7ATt6hCrsv8WgAhDUEUDbbZj0qBqE
   QmUsSfbmrL29jQu0YmlzC332s+fpvfihXog/kpTwc97EsYSSt10g1PjB3
   UaOozxgsdvxLvOqkBJEKq+qySSI9Oq1ZdVp/CMTjRnEKi5ugUcPRL2wGc
   bcjAO3gBzJfxtT+KNut3CFxlcapjrG5gJlFEtFJatHZZmoyxR4mI0TGoP
   g==;
X-IronPort-AV: E=McAfee;i="6200,9189,10259"; a="237909085"
X-IronPort-AV: E=Sophos;i="5.88,371,1635231600"; 
   d="scan'208";a="237909085"
Received: from orsmga001.jf.intel.com ([10.7.209.18])
  by orsmga101.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 15 Feb 2022 18:11:37 -0800
X-IronPort-AV: E=Sophos;i="5.88,371,1635231600"; 
   d="scan'208";a="571088827"
Received: from mjmartin-desk2.amr.corp.intel.com (HELO mjmartin-desk2.intel.com) ([10.209.9.181])
  by orsmga001-auth.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 15 Feb 2022 18:11:37 -0800
From:   Mat Martineau <mathew.j.martineau@linux.intel.com>
To:     netdev@vger.kernel.org
Cc:     Florian Westphal <fw@strlen.de>, davem@davemloft.net,
        kuba@kernel.org, matthieu.baerts@tessares.net,
        mptcp@lists.linux.dev,
        Mat Martineau <mathew.j.martineau@linux.intel.com>
Subject: [PATCH net-next 8/8] mptcp: don't save tcp data_ready and write space callbacks
Date:   Tue, 15 Feb 2022 18:11:30 -0800
Message-Id: <20220216021130.171786-9-mathew.j.martineau@linux.intel.com>
X-Mailer: git-send-email 2.35.1
In-Reply-To: <20220216021130.171786-1-mathew.j.martineau@linux.intel.com>
References: <20220216021130.171786-1-mathew.j.martineau@linux.intel.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-4.4 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_EF,RCVD_IN_DNSWL_MED,
        RCVD_IN_MSPIKE_H3,RCVD_IN_MSPIKE_WL,SPF_HELO_NONE,SPF_NONE,
        T_SCC_BODY_TEXT_LINE autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Florian Westphal <fw@strlen.de>

Assign the helpers directly rather than save/restore in the context
structure.

Signed-off-by: Florian Westphal <fw@strlen.de>
Signed-off-by: Mat Martineau <mathew.j.martineau@linux.intel.com>
---
 net/mptcp/protocol.h | 6 ++----
 net/mptcp/subflow.c  | 8 ++++----
 2 files changed, 6 insertions(+), 8 deletions(-)

diff --git a/net/mptcp/protocol.h b/net/mptcp/protocol.h
index 86910f20486a..9d0ee6cee07f 100644
--- a/net/mptcp/protocol.h
+++ b/net/mptcp/protocol.h
@@ -468,9 +468,7 @@ struct mptcp_subflow_context {
 	struct	sock *tcp_sock;	    /* tcp sk backpointer */
 	struct	sock *conn;	    /* parent mptcp_sock */
 	const	struct inet_connection_sock_af_ops *icsk_af_ops;
-	void	(*tcp_data_ready)(struct sock *sk);
 	void	(*tcp_state_change)(struct sock *sk);
-	void	(*tcp_write_space)(struct sock *sk);
 	void	(*tcp_error_report)(struct sock *sk);
 
 	struct	rcu_head rcu;
@@ -614,9 +612,9 @@ bool mptcp_subflow_active(struct mptcp_subflow_context *subflow);
 static inline void mptcp_subflow_tcp_fallback(struct sock *sk,
 					      struct mptcp_subflow_context *ctx)
 {
-	sk->sk_data_ready = ctx->tcp_data_ready;
+	sk->sk_data_ready = sock_def_readable;
 	sk->sk_state_change = ctx->tcp_state_change;
-	sk->sk_write_space = ctx->tcp_write_space;
+	sk->sk_write_space = sk_stream_write_space;
 	sk->sk_error_report = ctx->tcp_error_report;
 
 	inet_csk(sk)->icsk_af_ops = ctx->icsk_af_ops;
diff --git a/net/mptcp/subflow.c b/net/mptcp/subflow.c
index 740cb4763461..45c004f87f5a 100644
--- a/net/mptcp/subflow.c
+++ b/net/mptcp/subflow.c
@@ -1654,10 +1654,12 @@ static int subflow_ulp_init(struct sock *sk)
 	tp->is_mptcp = 1;
 	ctx->icsk_af_ops = icsk->icsk_af_ops;
 	icsk->icsk_af_ops = subflow_default_af_ops(sk);
-	ctx->tcp_data_ready = sk->sk_data_ready;
 	ctx->tcp_state_change = sk->sk_state_change;
-	ctx->tcp_write_space = sk->sk_write_space;
 	ctx->tcp_error_report = sk->sk_error_report;
+
+	WARN_ON_ONCE(sk->sk_data_ready != sock_def_readable);
+	WARN_ON_ONCE(sk->sk_write_space != sk_stream_write_space);
+
 	sk->sk_data_ready = subflow_data_ready;
 	sk->sk_write_space = subflow_write_space;
 	sk->sk_state_change = subflow_state_change;
@@ -1712,9 +1714,7 @@ static void subflow_ulp_clone(const struct request_sock *req,
 
 	new_ctx->conn_finished = 1;
 	new_ctx->icsk_af_ops = old_ctx->icsk_af_ops;
-	new_ctx->tcp_data_ready = old_ctx->tcp_data_ready;
 	new_ctx->tcp_state_change = old_ctx->tcp_state_change;
-	new_ctx->tcp_write_space = old_ctx->tcp_write_space;
 	new_ctx->tcp_error_report = old_ctx->tcp_error_report;
 	new_ctx->rel_write_seq = 1;
 	new_ctx->tcp_sock = newsk;
-- 
2.35.1

