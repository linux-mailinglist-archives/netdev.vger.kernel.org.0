Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 7137723377A
	for <lists+netdev@lfdr.de>; Thu, 30 Jul 2020 19:15:55 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1730146AbgG3RPt (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 30 Jul 2020 13:15:49 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:52632 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1730106AbgG3RPs (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 30 Jul 2020 13:15:48 -0400
Received: from Chamillionaire.breakpoint.cc (Chamillionaire.breakpoint.cc [IPv6:2a0a:51c0:0:12e:520::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 39A45C061574
        for <netdev@vger.kernel.org>; Thu, 30 Jul 2020 10:15:48 -0700 (PDT)
Received: from fw by Chamillionaire.breakpoint.cc with local (Exim 4.92)
        (envelope-from <fw@breakpoint.cc>)
        id 1k1C9i-0002vp-Nb; Thu, 30 Jul 2020 19:15:46 +0200
From:   Florian Westphal <fw@strlen.de>
To:     <netdev@vger.kernel.org>
Cc:     edumazet@google.com, mathew.j.martineau@linux.intel.com,
        matthieu.baerts@tessares.net, pabeni@redhat.com,
        Florian Westphal <fw@strlen.de>
Subject: [PATCH net-next 03/10] mptcp: subflow: split subflow_init_req
Date:   Thu, 30 Jul 2020 19:15:22 +0200
Message-Id: <20200730171529.22582-4-fw@strlen.de>
X-Mailer: git-send-email 2.26.2
In-Reply-To: <20200730171529.22582-1-fw@strlen.de>
References: <20200730171529.22582-1-fw@strlen.de>
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
code into a new helper, __subflow_init_req, that can then be re-used
from the 'no insert' function added in a followup change.

Signed-off-by: Florian Westphal <fw@strlen.de>
---
 net/mptcp/subflow.c | 32 ++++++++++++++++++++++----------
 1 file changed, 22 insertions(+), 10 deletions(-)

diff --git a/net/mptcp/subflow.c b/net/mptcp/subflow.c
index 9feb87880d1c..091e305a81c8 100644
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
@@ -113,9 +105,29 @@ static void subflow_init_req(struct request_sock *req,
 	 * TCP option space.
 	 */
 	if (rcu_access_pointer(tcp_sk(sk_listener)->md5sig_info))
-		return;
+		return -EINVAL;
 #endif
 
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
+
 	if (mp_opt.mp_capable) {
 		SUBFLOW_REQ_INC_STATS(req, MPTCP_MIB_MPCAPABLEPASSIVE);
 
-- 
2.26.2

