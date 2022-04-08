Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 677B34F9DC1
	for <lists+netdev@lfdr.de>; Fri,  8 Apr 2022 21:46:31 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S238043AbiDHTsY (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 8 Apr 2022 15:48:24 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:48692 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230264AbiDHTsQ (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 8 Apr 2022 15:48:16 -0400
Received: from mga06.intel.com (mga06.intel.com [134.134.136.31])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 76B8CB06
        for <netdev@vger.kernel.org>; Fri,  8 Apr 2022 12:46:12 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1649447172; x=1680983172;
  h=from:to:cc:subject:date:message-id:in-reply-to:
   references:mime-version:content-transfer-encoding;
  bh=/4vjDVJ7ph3o8sUs30XSct9CMH0dy4bXdz1/3w7fzo0=;
  b=KN7ztfRbXFjdSg0/44cboc26hh1Ic/fFTQcoBkxrrqz1NrYF+gC8n9IW
   Zddi6T+E/YFaQoHNVvvPbg+t+pG/7qmz92DczDprdxQSl5kyVCd1VyJzn
   I/vjpmtbEsaAogQH3k4aV2y7wJPYSps7WxB/Zt0TRClnq9UOoKBsCqn1s
   mpE1HaI/szSRD7cC/KfkaoUBicqgYCK++obU86auPcjzyEmxJj1PizYHE
   y0KxF6RG7zPT2kiTDb58SZoV1/VLT58/peqFCjPwpQJVxbhztYSw/Pzl4
   He2+Jw/eX3EmQOo4rpUf9Hl8zXtFiOUp1AMtJBY6rHdZ2tdHVK6c/7qVT
   w==;
X-IronPort-AV: E=McAfee;i="6400,9594,10311"; a="322365308"
X-IronPort-AV: E=Sophos;i="5.90,245,1643702400"; 
   d="scan'208";a="322365308"
Received: from orsmga004.jf.intel.com ([10.7.209.38])
  by orsmga104.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 08 Apr 2022 12:46:10 -0700
X-IronPort-AV: E=Sophos;i="5.90,245,1643702400"; 
   d="scan'208";a="659602172"
Received: from mjmartin-desk2.amr.corp.intel.com (HELO mjmartin-desk2.intel.com) ([10.134.75.99])
  by orsmga004-auth.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 08 Apr 2022 12:46:10 -0700
From:   Mat Martineau <mathew.j.martineau@linux.intel.com>
To:     netdev@vger.kernel.org
Cc:     Florian Westphal <fw@strlen.de>, davem@davemloft.net,
        kuba@kernel.org, pabeni@redhat.com, matthieu.baerts@tessares.net,
        mptcp@lists.linux.dev,
        Mat Martineau <mathew.j.martineau@linux.intel.com>
Subject: [PATCH net-next 6/8] mptcp: remove locking in mptcp_diag_fill_info
Date:   Fri,  8 Apr 2022 12:45:59 -0700
Message-Id: <20220408194601.305969-7-mathew.j.martineau@linux.intel.com>
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

Problem is that listener iteration would call this from atomic context
so this locking is not allowed.

One way is to drop locks before calling the helper, but afaics the lock
isn't really needed, all values are fetched via READ_ONCE().

Signed-off-by: Florian Westphal <fw@strlen.de>
Signed-off-by: Mat Martineau <mathew.j.martineau@linux.intel.com>
---
 net/mptcp/sockopt.c | 6 ------
 1 file changed, 6 deletions(-)

diff --git a/net/mptcp/sockopt.c b/net/mptcp/sockopt.c
index f949d22f52bd..826b0c1dae98 100644
--- a/net/mptcp/sockopt.c
+++ b/net/mptcp/sockopt.c
@@ -853,15 +853,11 @@ static int mptcp_getsockopt_first_sf_only(struct mptcp_sock *msk, int level, int
 
 void mptcp_diag_fill_info(struct mptcp_sock *msk, struct mptcp_info *info)
 {
-	struct sock *sk = &msk->sk.icsk_inet.sk;
 	u32 flags = 0;
-	bool slow;
 	u8 val;
 
 	memset(info, 0, sizeof(*info));
 
-	slow = lock_sock_fast(sk);
-
 	info->mptcpi_subflows = READ_ONCE(msk->pm.subflows);
 	info->mptcpi_add_addr_signal = READ_ONCE(msk->pm.add_addr_signaled);
 	info->mptcpi_add_addr_accepted = READ_ONCE(msk->pm.add_addr_accepted);
@@ -882,8 +878,6 @@ void mptcp_diag_fill_info(struct mptcp_sock *msk, struct mptcp_info *info)
 	info->mptcpi_snd_una = READ_ONCE(msk->snd_una);
 	info->mptcpi_rcv_nxt = READ_ONCE(msk->ack_seq);
 	info->mptcpi_csum_enabled = READ_ONCE(msk->csum_enabled);
-
-	unlock_sock_fast(sk, slow);
 }
 EXPORT_SYMBOL_GPL(mptcp_diag_fill_info);
 
-- 
2.35.1

