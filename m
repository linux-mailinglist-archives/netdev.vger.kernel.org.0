Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id AECEB3ABFB3
	for <lists+netdev@lfdr.de>; Fri, 18 Jun 2021 01:46:56 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233161AbhFQXst (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 17 Jun 2021 19:48:49 -0400
Received: from mga03.intel.com ([134.134.136.65]:13474 "EHLO mga03.intel.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S233024AbhFQXsj (ORCPT <rfc822;netdev@vger.kernel.org>);
        Thu, 17 Jun 2021 19:48:39 -0400
IronPort-SDR: LgAizZDk3LvyPEyqMWB81Gzlai7pxulqo/Rxkf6+cR0ohHqkb+E8xdCYjYl1klpFBTMkPmSsj1
 6DzCX7IimFPA==
X-IronPort-AV: E=McAfee;i="6200,9189,10018"; a="206506639"
X-IronPort-AV: E=Sophos;i="5.83,281,1616482800"; 
   d="scan'208";a="206506639"
Received: from fmsmga008.fm.intel.com ([10.253.24.58])
  by orsmga103.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 17 Jun 2021 16:46:30 -0700
IronPort-SDR: edsxzSDGOalpX0SeGuQtJqVVqXBZnUtoYmHToyDKaSjUD98Fm7lmWB0Nsy9L2pTp6XFf85C1j1
 jT7ERRXvA2Bw==
X-IronPort-AV: E=Sophos;i="5.83,281,1616482800"; 
   d="scan'208";a="452943906"
Received: from mjmartin-desk2.amr.corp.intel.com (HELO mjmartin-desk2.intel.com) ([10.212.250.143])
  by fmsmga008-auth.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 17 Jun 2021 16:46:30 -0700
From:   Mat Martineau <mathew.j.martineau@linux.intel.com>
To:     netdev@vger.kernel.org
Cc:     Geliang Tang <geliangtang@gmail.com>, davem@davemloft.net,
        kuba@kernel.org, matthieu.baerts@tessares.net,
        mptcp@lists.linux.dev, pabeni@redhat.com,
        Mat Martineau <mathew.j.martineau@linux.intel.com>
Subject: [PATCH net-next 06/16] mptcp: add sk parameter for mptcp_get_options
Date:   Thu, 17 Jun 2021 16:46:12 -0700
Message-Id: <20210617234622.472030-7-mathew.j.martineau@linux.intel.com>
X-Mailer: git-send-email 2.32.0
In-Reply-To: <20210617234622.472030-1-mathew.j.martineau@linux.intel.com>
References: <20210617234622.472030-1-mathew.j.martineau@linux.intel.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Geliang Tang <geliangtang@gmail.com>

This patch added a new parameter name sk in mptcp_get_options().

Acked-by: Paolo Abeni <pabeni@redhat.com>
Signed-off-by: Geliang Tang <geliangtang@gmail.com>
Signed-off-by: Mat Martineau <mathew.j.martineau@linux.intel.com>
---
 net/mptcp/options.c  |  5 +++--
 net/mptcp/protocol.h |  3 ++-
 net/mptcp/subflow.c  | 10 +++++-----
 3 files changed, 10 insertions(+), 8 deletions(-)

diff --git a/net/mptcp/options.c b/net/mptcp/options.c
index 1468774f1f87..ae69059583a7 100644
--- a/net/mptcp/options.c
+++ b/net/mptcp/options.c
@@ -323,7 +323,8 @@ static void mptcp_parse_option(const struct sk_buff *skb,
 	}
 }
 
-void mptcp_get_options(const struct sk_buff *skb,
+void mptcp_get_options(const struct sock *sk,
+		       const struct sk_buff *skb,
 		       struct mptcp_options_received *mp_opt)
 {
 	const struct tcphdr *th = tcp_hdr(skb);
@@ -1024,7 +1025,7 @@ void mptcp_incoming_options(struct sock *sk, struct sk_buff *skb)
 		return;
 	}
 
-	mptcp_get_options(skb, &mp_opt);
+	mptcp_get_options(sk, skb, &mp_opt);
 	if (!check_fully_established(msk, sk, subflow, skb, &mp_opt))
 		return;
 
diff --git a/net/mptcp/protocol.h b/net/mptcp/protocol.h
index 09e94726e030..a7ed0b8eb9bc 100644
--- a/net/mptcp/protocol.h
+++ b/net/mptcp/protocol.h
@@ -586,7 +586,8 @@ int __init mptcp_proto_v6_init(void);
 struct sock *mptcp_sk_clone(const struct sock *sk,
 			    const struct mptcp_options_received *mp_opt,
 			    struct request_sock *req);
-void mptcp_get_options(const struct sk_buff *skb,
+void mptcp_get_options(const struct sock *sk,
+		       const struct sk_buff *skb,
 		       struct mptcp_options_received *mp_opt);
 
 void mptcp_finish_connect(struct sock *sk);
diff --git a/net/mptcp/subflow.c b/net/mptcp/subflow.c
index 45acab63c387..aa6b307b27c8 100644
--- a/net/mptcp/subflow.c
+++ b/net/mptcp/subflow.c
@@ -151,7 +151,7 @@ static int subflow_check_req(struct request_sock *req,
 		return -EINVAL;
 #endif
 
-	mptcp_get_options(skb, &mp_opt);
+	mptcp_get_options(sk_listener, skb, &mp_opt);
 
 	if (mp_opt.mp_capable) {
 		SUBFLOW_REQ_INC_STATS(req, MPTCP_MIB_MPCAPABLEPASSIVE);
@@ -248,7 +248,7 @@ int mptcp_subflow_init_cookie_req(struct request_sock *req,
 	int err;
 
 	subflow_init_req(req, sk_listener);
-	mptcp_get_options(skb, &mp_opt);
+	mptcp_get_options(sk_listener, skb, &mp_opt);
 
 	if (mp_opt.mp_capable && mp_opt.mp_join)
 		return -EINVAL;
@@ -395,7 +395,7 @@ static void subflow_finish_connect(struct sock *sk, const struct sk_buff *skb)
 	subflow->ssn_offset = TCP_SKB_CB(skb)->seq;
 	pr_debug("subflow=%p synack seq=%x", subflow, subflow->ssn_offset);
 
-	mptcp_get_options(skb, &mp_opt);
+	mptcp_get_options(sk, skb, &mp_opt);
 	if (subflow->request_mptcp) {
 		if (!mp_opt.mp_capable) {
 			MPTCP_INC_STATS(sock_net(sk),
@@ -639,7 +639,7 @@ static struct sock *subflow_syn_recv_sock(const struct sock *sk,
 		 * reordered MPC will cause fallback, but we don't have other
 		 * options.
 		 */
-		mptcp_get_options(skb, &mp_opt);
+		mptcp_get_options(sk, skb, &mp_opt);
 		if (!mp_opt.mp_capable) {
 			fallback = true;
 			goto create_child;
@@ -649,7 +649,7 @@ static struct sock *subflow_syn_recv_sock(const struct sock *sk,
 		if (!new_msk)
 			fallback = true;
 	} else if (subflow_req->mp_join) {
-		mptcp_get_options(skb, &mp_opt);
+		mptcp_get_options(sk, skb, &mp_opt);
 		if (!mp_opt.mp_join || !subflow_hmac_valid(req, &mp_opt) ||
 		    !mptcp_can_accept_new_subflow(subflow_req->msk)) {
 			SUBFLOW_REQ_INC_STATS(req, MPTCP_MIB_JOINACKMAC);
-- 
2.32.0

