Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id EA0923196AF
	for <lists+netdev@lfdr.de>; Fri, 12 Feb 2021 00:34:38 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230170AbhBKXeJ (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 11 Feb 2021 18:34:09 -0500
Received: from mga05.intel.com ([192.55.52.43]:55192 "EHLO mga05.intel.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S229944AbhBKXd5 (ORCPT <rfc822;netdev@vger.kernel.org>);
        Thu, 11 Feb 2021 18:33:57 -0500
IronPort-SDR: HrEWNYj0PNs8aeNKSxT2FnikzRfPtW9q7XQkhtTNeQxkUrgt3Dr2CDUXq3dB6mmvMM7B/eiWoC
 LPJuD2IF6EbQ==
X-IronPort-AV: E=McAfee;i="6000,8403,9892"; a="267177940"
X-IronPort-AV: E=Sophos;i="5.81,172,1610438400"; 
   d="scan'208";a="267177940"
Received: from fmsmga008.fm.intel.com ([10.253.24.58])
  by fmsmga105.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 11 Feb 2021 15:30:49 -0800
IronPort-SDR: yHXos0IgeVm3I1GERA7arw6xlOuvAK5osH+Jso8BgUEC0/bG9BGTEK9RlPYTj6WJ+LcF/NmpwS
 HVZDct8NOW6w==
X-IronPort-AV: E=Sophos;i="5.81,172,1610438400"; 
   d="scan'208";a="381226387"
Received: from mjmartin-desk2.amr.corp.intel.com (HELO mjmartin-desk2.intel.com) ([10.254.100.224])
  by fmsmga008-auth.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 11 Feb 2021 15:30:49 -0800
From:   Mat Martineau <mathew.j.martineau@linux.intel.com>
To:     netdev@vger.kernel.org
Cc:     Paolo Abeni <pabeni@redhat.com>, davem@davemloft.net,
        kuba@kernel.org, mptcp@lists.01.org, matthieu.baerts@tessares.net,
        Christoph Paasch <cpaasch@apple.com>,
        Mat Martineau <mathew.j.martineau@linux.intel.com>
Subject: [PATCH net 4/6] mptcp: init mptcp request socket earlier
Date:   Thu, 11 Feb 2021 15:30:40 -0800
Message-Id: <20210211233042.304878-5-mathew.j.martineau@linux.intel.com>
X-Mailer: git-send-email 2.30.1
In-Reply-To: <20210211233042.304878-1-mathew.j.martineau@linux.intel.com>
References: <20210211233042.304878-1-mathew.j.martineau@linux.intel.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Paolo Abeni <pabeni@redhat.com>

The mptcp subflow route_req() callback performs the subflow
req initialization after the route_req() check. If the latter
fails, mptcp-specific bits of the current request sockets
are left uninitialized.

The above causes bad things at req socket disposal time, when
the mptcp resources are cleared.

This change addresses the issue by splitting subflow_init_req()
into the actual initialization and the mptcp-specific checks.
The initialization is moved before any possibly failing check.

Reported-by: Christoph Paasch <cpaasch@apple.com>
Fixes: 7ea851d19b23 ("tcp: merge 'init_req' and 'route_req' functions")
Signed-off-by: Paolo Abeni <pabeni@redhat.com>
Signed-off-by: Mat Martineau <mathew.j.martineau@linux.intel.com>
---
 net/mptcp/subflow.c | 40 ++++++++++++++++------------------------
 1 file changed, 16 insertions(+), 24 deletions(-)

diff --git a/net/mptcp/subflow.c b/net/mptcp/subflow.c
index 0ec3ccac6bb4..8b2338dfdc80 100644
--- a/net/mptcp/subflow.c
+++ b/net/mptcp/subflow.c
@@ -92,7 +92,7 @@ static struct mptcp_sock *subflow_token_join_request(struct request_sock *req,
 	return msk;
 }
 
-static int __subflow_init_req(struct request_sock *req, const struct sock *sk_listener)
+static void subflow_init_req(struct request_sock *req, const struct sock *sk_listener)
 {
 	struct mptcp_subflow_request_sock *subflow_req = mptcp_subflow_rsk(req);
 
@@ -100,16 +100,6 @@ static int __subflow_init_req(struct request_sock *req, const struct sock *sk_li
 	subflow_req->mp_join = 0;
 	subflow_req->msk = NULL;
 	mptcp_token_init_request(req);
-
-#ifdef CONFIG_TCP_MD5SIG
-	/* no MPTCP if MD5SIG is enabled on this socket or we may run out of
-	 * TCP option space.
-	 */
-	if (rcu_access_pointer(tcp_sk(sk_listener)->md5sig_info))
-		return -EINVAL;
-#endif
-
-	return 0;
 }
 
 /* Init mptcp request socket.
@@ -117,20 +107,23 @@ static int __subflow_init_req(struct request_sock *req, const struct sock *sk_li
  * Returns an error code if a JOIN has failed and a TCP reset
  * should be sent.
  */
-static int subflow_init_req(struct request_sock *req,
-			    const struct sock *sk_listener,
-			    struct sk_buff *skb)
+static int subflow_check_req(struct request_sock *req,
+			     const struct sock *sk_listener,
+			     struct sk_buff *skb)
 {
 	struct mptcp_subflow_context *listener = mptcp_subflow_ctx(sk_listener);
 	struct mptcp_subflow_request_sock *subflow_req = mptcp_subflow_rsk(req);
 	struct mptcp_options_received mp_opt;
-	int ret;
 
 	pr_debug("subflow_req=%p, listener=%p", subflow_req, listener);
 
-	ret = __subflow_init_req(req, sk_listener);
-	if (ret)
-		return 0;
+#ifdef CONFIG_TCP_MD5SIG
+	/* no MPTCP if MD5SIG is enabled on this socket or we may run out of
+	 * TCP option space.
+	 */
+	if (rcu_access_pointer(tcp_sk(sk_listener)->md5sig_info))
+		return -EINVAL;
+#endif
 
 	mptcp_get_options(skb, &mp_opt);
 
@@ -205,10 +198,7 @@ int mptcp_subflow_init_cookie_req(struct request_sock *req,
 	struct mptcp_options_received mp_opt;
 	int err;
 
-	err = __subflow_init_req(req, sk_listener);
-	if (err)
-		return err;
-
+	subflow_init_req(req, sk_listener);
 	mptcp_get_options(skb, &mp_opt);
 
 	if (mp_opt.mp_capable && mp_opt.mp_join)
@@ -248,12 +238,13 @@ static struct dst_entry *subflow_v4_route_req(const struct sock *sk,
 	int err;
 
 	tcp_rsk(req)->is_mptcp = 1;
+	subflow_init_req(req, sk);
 
 	dst = tcp_request_sock_ipv4_ops.route_req(sk, skb, fl, req);
 	if (!dst)
 		return NULL;
 
-	err = subflow_init_req(req, sk, skb);
+	err = subflow_check_req(req, sk, skb);
 	if (err == 0)
 		return dst;
 
@@ -273,12 +264,13 @@ static struct dst_entry *subflow_v6_route_req(const struct sock *sk,
 	int err;
 
 	tcp_rsk(req)->is_mptcp = 1;
+	subflow_init_req(req, sk);
 
 	dst = tcp_request_sock_ipv6_ops.route_req(sk, skb, fl, req);
 	if (!dst)
 		return NULL;
 
-	err = subflow_init_req(req, sk, skb);
+	err = subflow_check_req(req, sk, skb);
 	if (err == 0)
 		return dst;
 
-- 
2.30.1

