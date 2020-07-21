Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 9C6A4228A06
	for <lists+netdev@lfdr.de>; Tue, 21 Jul 2020 22:37:21 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1731013AbgGUUhU (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 21 Jul 2020 16:37:20 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:55348 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726506AbgGUUhU (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 21 Jul 2020 16:37:20 -0400
Received: from Chamillionaire.breakpoint.cc (Chamillionaire.breakpoint.cc [IPv6:2a0a:51c0:0:12e:520::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id D5F87C061794
        for <netdev@vger.kernel.org>; Tue, 21 Jul 2020 13:37:19 -0700 (PDT)
Received: from fw by Chamillionaire.breakpoint.cc with local (Exim 4.92)
        (envelope-from <fw@breakpoint.cc>)
        id 1jxz0o-0003vk-ET; Tue, 21 Jul 2020 22:37:18 +0200
From:   Florian Westphal <fw@strlen.de>
To:     <netdev@vger.kernel.org>
Cc:     mathew.j.martineau@linux.intel.com, edumazet@google.com,
        mptcp@lists.01.org, matthieu.baerts@tessares.net,
        Florian Westphal <fw@strlen.de>
Subject: [RFC v2 mptcp-next 04/12] mptcp: subflow: split subflow_init_req into helpers
Date:   Tue, 21 Jul 2020 22:36:34 +0200
Message-Id: <20200721203642.32753-5-fw@strlen.de>
X-Mailer: git-send-email 2.26.2
In-Reply-To: <20200721203642.32753-1-fw@strlen.de>
References: <20200721203642.32753-1-fw@strlen.de>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

When syncookie support is added, we will need to add a variant of
subflow_init_req() helper.  It will do almost same thing except
that it will not compute/add a token to the mptcp token tree.

To avoid excess copy&paste, this commit splits away part of the
code into helpers that can then be re-used from the 'no insert'
function added in a followup change.

Signed-off-by: Florian Westphal <fw@strlen.de>
---
 net/mptcp/subflow.c | 49 ++++++++++++++++++++++++++++++++-------------
 1 file changed, 35 insertions(+), 14 deletions(-)

diff --git a/net/mptcp/subflow.c b/net/mptcp/subflow.c
index 9526566ec153..800e7d472dcd 100644
--- a/net/mptcp/subflow.c
+++ b/net/mptcp/subflow.c
@@ -91,17 +91,9 @@ static struct mptcp_sock *subflow_token_join_request(struct request_sock *req,
 	return msk;
 }
 
-static void subflow_init_req(struct request_sock *req,
-			     const struct sock *sk_listener,
-			     struct sk_buff *skb)
+static int __subflow_init_req(struct request_sock *req, const struct sock *sk_listener)
 {
-	struct mptcp_subflow_context *listener = mptcp_subflow_ctx(sk_listener);
 	struct mptcp_subflow_request_sock *subflow_req = mptcp_subflow_rsk(req);
-	struct mptcp_options_received mp_opt;
-
-	pr_debug("subflow_req=%p, listener=%p", subflow_req, listener);
-
-	mptcp_get_options(skb, &mp_opt);
 
 	subflow_req->mp_capable = 0;
 	subflow_req->mp_join = 0;
@@ -113,18 +105,47 @@ static void subflow_init_req(struct request_sock *req,
 	 * TCP option space.
 	 */
 	if (rcu_access_pointer(tcp_sk(sk_listener)->md5sig_info))
-		return;
+		return -EINVAL;
 #endif
 
-	if (mp_opt.mp_capable) {
+	return 0;
+}
+
+static int __subflow_check_options(const struct mptcp_options_received *mp_opt,
+				   struct request_sock *req)
+{
+	if (mp_opt->mp_capable) {
 		SUBFLOW_REQ_INC_STATS(req, MPTCP_MIB_MPCAPABLEPASSIVE);
 
-		if (mp_opt.mp_join)
-			return;
-	} else if (mp_opt.mp_join) {
+		if (mp_opt->mp_join)
+			return -EINVAL;
+	} else if (mp_opt->mp_join) {
 		SUBFLOW_REQ_INC_STATS(req, MPTCP_MIB_JOINSYNRX);
 	}
 
+	return 0;
+}
+
+static void subflow_init_req(struct request_sock *req,
+			     const struct sock *sk_listener,
+			     struct sk_buff *skb)
+{
+	struct mptcp_subflow_context *listener = mptcp_subflow_ctx(sk_listener);
+	struct mptcp_subflow_request_sock *subflow_req = mptcp_subflow_rsk(req);
+	struct mptcp_options_received mp_opt;
+	int ret;
+
+	pr_debug("subflow_req=%p, listener=%p", subflow_req, listener);
+
+	ret = __subflow_init_req(req, sk_listener);
+	if (ret)
+		return;
+
+	mptcp_get_options(skb, &mp_opt);
+	ret = __subflow_check_options(&mp_opt, req);
+	if (ret)
+		return;
+
 	if (mp_opt.mp_capable && listener->request_mptcp) {
 		int err, retries = 4;
 
-- 
2.26.2

