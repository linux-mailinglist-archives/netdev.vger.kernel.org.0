Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 997D65625F5
	for <lists+netdev@lfdr.de>; Fri,  1 Jul 2022 00:18:50 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231207AbiF3WSO (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 30 Jun 2022 18:18:14 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:43806 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231168AbiF3WSE (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 30 Jun 2022 18:18:04 -0400
Received: from mga03.intel.com (mga03.intel.com [134.134.136.65])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id D325257256
        for <netdev@vger.kernel.org>; Thu, 30 Jun 2022 15:18:03 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1656627483; x=1688163483;
  h=from:to:cc:subject:date:message-id:in-reply-to:
   references:mime-version:content-transfer-encoding;
  bh=lZ5vKuw10oEXYHP9I4iPemj76N36tbCMGBq9V6tz1vw=;
  b=WcVgshoViUB9clIu40u54xYdYooNrBTPWwZ8xMqb/gyYNyOBfhMQFWqM
   29Aad5zOFjkPrA1Vz6lyex4GhqxoQSCmXgvpXw3jdaUlCICCcoeeGZBmw
   FPAhb04KFA8OK8YgtAbli5qLMWGv3TNAa6THAStk2+91c09LPyD8mOYUB
   unEtchn40+7mX6GWH+Iaoomm21Q2pwfd6POpkba+Ezwi2ycUB+T7V5akS
   7PhDeiLoscezxdzJIpWBRhj286PGuSmGFtp5SkCPtRMrebyFdHjpho+tz
   g3J9DbiwIm2o1hU8zbQ7YKqKrtvuNNdRCUinXe5StoxtvOYagjxSotnhT
   Q==;
X-IronPort-AV: E=McAfee;i="6400,9594,10394"; a="283583504"
X-IronPort-AV: E=Sophos;i="5.92,235,1650956400"; 
   d="scan'208";a="283583504"
Received: from fmsmga001.fm.intel.com ([10.253.24.23])
  by orsmga103.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 30 Jun 2022 15:18:02 -0700
X-IronPort-AV: E=Sophos;i="5.92,235,1650956400"; 
   d="scan'208";a="733804539"
Received: from mhtran-desk5.amr.corp.intel.com (HELO mjmartin-desk2.intel.com) ([10.212.176.78])
  by fmsmga001-auth.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 30 Jun 2022 15:18:01 -0700
From:   Mat Martineau <mathew.j.martineau@linux.intel.com>
To:     netdev@vger.kernel.org
Cc:     Paolo Abeni <pabeni@redhat.com>, davem@davemloft.net,
        kuba@kernel.org, edumazet@google.com, matthieu.baerts@tessares.net,
        mptcp@lists.linux.dev,
        Mat Martineau <mathew.j.martineau@linux.intel.com>
Subject: [PATCH net-next 1/4] mptcp: never fetch fwd memory from the subflow
Date:   Thu, 30 Jun 2022 15:17:54 -0700
Message-Id: <20220630221757.763751-2-mathew.j.martineau@linux.intel.com>
X-Mailer: git-send-email 2.37.0
In-Reply-To: <20220630221757.763751-1-mathew.j.martineau@linux.intel.com>
References: <20220630221757.763751-1-mathew.j.martineau@linux.intel.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-4.7 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_EF,RCVD_IN_DNSWL_MED,SPF_HELO_NONE,
        SPF_NONE,T_SCC_BODY_TEXT_LINE autolearn=ham autolearn_force=no
        version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Paolo Abeni <pabeni@redhat.com>

The memory accounting is broken in such exceptional code
path, and after commit 4890b686f408 ("net: keep sk->sk_forward_alloc
as small as possible") we can't find much help there.

Drop the broken code.

Signed-off-by: Paolo Abeni <pabeni@redhat.com>
Signed-off-by: Mat Martineau <mathew.j.martineau@linux.intel.com>
---
 net/mptcp/protocol.c | 11 +++--------
 1 file changed, 3 insertions(+), 8 deletions(-)

diff --git a/net/mptcp/protocol.c b/net/mptcp/protocol.c
index e0fb9f96c45c..c67c6fc1fe04 100644
--- a/net/mptcp/protocol.c
+++ b/net/mptcp/protocol.c
@@ -328,15 +328,10 @@ static bool mptcp_rmem_schedule(struct sock *sk, struct sock *ssk, int size)
 
 	amt = sk_mem_pages(size);
 	amount = amt << PAGE_SHIFT;
-	msk->rmem_fwd_alloc += amount;
-	if (!__sk_mem_raise_allocated(sk, size, amt, SK_MEM_RECV)) {
-		if (ssk->sk_forward_alloc < amount) {
-			msk->rmem_fwd_alloc -= amount;
-			return false;
-		}
+	if (!__sk_mem_raise_allocated(sk, size, amt, SK_MEM_RECV))
+		return false;
 
-		ssk->sk_forward_alloc -= amount;
-	}
+	msk->rmem_fwd_alloc += amount;
 	return true;
 }
 
-- 
2.37.0

