Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 106CB4F9DBD
	for <lists+netdev@lfdr.de>; Fri,  8 Apr 2022 21:46:30 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232580AbiDHTsW (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 8 Apr 2022 15:48:22 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:48642 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232596AbiDHTsQ (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 8 Apr 2022 15:48:16 -0400
Received: from mga06.intel.com (mga06.intel.com [134.134.136.31])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 33813114
        for <netdev@vger.kernel.org>; Fri,  8 Apr 2022 12:46:12 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1649447172; x=1680983172;
  h=from:to:cc:subject:date:message-id:in-reply-to:
   references:mime-version:content-transfer-encoding;
  bh=t6VdNUbE9ZxhADIvxQwrdlpYEV9mOXXWVZlnKfEDQU8=;
  b=MUpfpAD1yGuFvT1y7QgZx5VjFMwIxPtEvqvHHZGfV0Biu8Podz/IBmx5
   bdJ3uS5otUXdw2wVOo7QDc5iEyDEQATGn0kzpUXAOwKj37V3U++J7I6oN
   AHq6l5fRDKebDWZQJpSJI2z0qQeDKuBUNGDv5zuK6ELCDmGAzsfA6zN+N
   ZxMtM0HeJ6y8YNleQM+/gJeYCTKpXPzS/DFmdpB/6tRDLChaSGPsMiCGi
   brqJfInjpNTkKtDE/NtcguN6xY08E4QrOp01xBAWeSZCSjP3UGH1xUp5H
   up5nI5RgWfWoegTpmnOQyzumrhLCqAVfbBc3I7o/ciA53QAqvAooRw9uT
   g==;
X-IronPort-AV: E=McAfee;i="6400,9594,10311"; a="322365305"
X-IronPort-AV: E=Sophos;i="5.90,245,1643702400"; 
   d="scan'208";a="322365305"
Received: from orsmga004.jf.intel.com ([10.7.209.38])
  by orsmga104.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 08 Apr 2022 12:46:10 -0700
X-IronPort-AV: E=Sophos;i="5.90,245,1643702400"; 
   d="scan'208";a="659602162"
Received: from mjmartin-desk2.amr.corp.intel.com (HELO mjmartin-desk2.intel.com) ([10.134.75.99])
  by orsmga004-auth.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 08 Apr 2022 12:46:09 -0700
From:   Mat Martineau <mathew.j.martineau@linux.intel.com>
To:     netdev@vger.kernel.org
Cc:     Florian Westphal <fw@strlen.de>, davem@davemloft.net,
        kuba@kernel.org, pabeni@redhat.com, matthieu.baerts@tessares.net,
        mptcp@lists.linux.dev,
        Mat Martineau <mathew.j.martineau@linux.intel.com>
Subject: [PATCH net-next 5/8] mptcp: diag: switch to context structure
Date:   Fri,  8 Apr 2022 12:45:58 -0700
Message-Id: <20220408194601.305969-6-mathew.j.martineau@linux.intel.com>
X-Mailer: git-send-email 2.35.1
In-Reply-To: <20220408194601.305969-1-mathew.j.martineau@linux.intel.com>
References: <20220408194601.305969-1-mathew.j.martineau@linux.intel.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-2.7 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_EF,RCVD_IN_DNSWL_LOW,SPF_HELO_NONE,
        SPF_NONE,T_SCC_BODY_TEXT_LINE,URIBL_BLOCKED autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Florian Westphal <fw@strlen.de>

Raw access to cb->arg[] is deprecated, use a context structure.

Signed-off-by: Florian Westphal <fw@strlen.de>
Signed-off-by: Mat Martineau <mathew.j.martineau@linux.intel.com>
---
 net/mptcp/mptcp_diag.c | 14 +++++++++++---
 1 file changed, 11 insertions(+), 3 deletions(-)

diff --git a/net/mptcp/mptcp_diag.c b/net/mptcp/mptcp_diag.c
index f44125dd6697..c4992eeb67d8 100644
--- a/net/mptcp/mptcp_diag.c
+++ b/net/mptcp/mptcp_diag.c
@@ -66,20 +66,28 @@ static int mptcp_diag_dump_one(struct netlink_callback *cb,
 	return err;
 }
 
+struct mptcp_diag_ctx {
+	long s_slot;
+	long s_num;
+};
+
 static void mptcp_diag_dump(struct sk_buff *skb, struct netlink_callback *cb,
 			    const struct inet_diag_req_v2 *r)
 {
 	bool net_admin = netlink_net_capable(cb->skb, CAP_NET_ADMIN);
+	struct mptcp_diag_ctx *diag_ctx = (void *)cb->ctx;
 	struct net *net = sock_net(skb->sk);
 	struct inet_diag_dump_data *cb_data;
 	struct mptcp_sock *msk;
 	struct nlattr *bc;
 
+	BUILD_BUG_ON(sizeof(cb->ctx) < sizeof(*diag_ctx));
+
 	cb_data = cb->data;
 	bc = cb_data->inet_diag_nla_bc;
 
-	while ((msk = mptcp_token_iter_next(net, &cb->args[0], &cb->args[1])) !=
-	       NULL) {
+	while ((msk = mptcp_token_iter_next(net, &diag_ctx->s_slot,
+					    &diag_ctx->s_num)) != NULL) {
 		struct inet_sock *inet = (struct inet_sock *)msk;
 		struct sock *sk = (struct sock *)msk;
 		int ret = 0;
@@ -101,7 +109,7 @@ static void mptcp_diag_dump(struct sk_buff *skb, struct netlink_callback *cb,
 		sock_put(sk);
 		if (ret < 0) {
 			/* will retry on the same position */
-			cb->args[1]--;
+			diag_ctx->s_num--;
 			break;
 		}
 		cond_resched();
-- 
2.35.1

