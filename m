Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 4C2D13AD4BD
	for <lists+netdev@lfdr.de>; Sat, 19 Jun 2021 00:02:35 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234730AbhFRWEm (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 18 Jun 2021 18:04:42 -0400
Received: from mga05.intel.com ([192.55.52.43]:53160 "EHLO mga05.intel.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S233684AbhFRWEi (ORCPT <rfc822;netdev@vger.kernel.org>);
        Fri, 18 Jun 2021 18:04:38 -0400
IronPort-SDR: fzZeEVHKrkx5QbdCifqPeCWZs7vpCstPzygn63BbG208PKtsBkP7r7tsibBMukTF845/zb09fn
 Cg8YqsG2Ws3A==
X-IronPort-AV: E=McAfee;i="6200,9189,10019"; a="292256528"
X-IronPort-AV: E=Sophos;i="5.83,284,1616482800"; 
   d="scan'208";a="292256528"
Received: from orsmga007.jf.intel.com ([10.7.209.58])
  by fmsmga105.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 18 Jun 2021 15:02:28 -0700
IronPort-SDR: tVjFpKOpZ/pHAiifudGovryrd8N7G9OkPnTsjG9KcPzhCT7xY9JQiecW3MnePRWq+TbRHb2tMO
 D3f/rMiz4eaw==
X-IronPort-AV: E=Sophos;i="5.83,284,1616482800"; 
   d="scan'208";a="443703683"
Received: from mjmartin-desk2.amr.corp.intel.com (HELO mjmartin-desk2.intel.com) ([10.209.26.218])
  by orsmga007-auth.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 18 Jun 2021 15:02:27 -0700
From:   Mat Martineau <mathew.j.martineau@linux.intel.com>
To:     netdev@vger.kernel.org
Cc:     Paolo Abeni <pabeni@redhat.com>, davem@davemloft.net,
        kuba@kernel.org, matthieu.baerts@tessares.net,
        mptcp@lists.linux.dev, fw@strlen.de,
        Mat Martineau <mathew.j.martineau@linux.intel.com>
Subject: [PATCH net 2/2] mptcp: fix 32 bit DSN expansion
Date:   Fri, 18 Jun 2021 15:02:21 -0700
Message-Id: <20210618220221.99172-3-mathew.j.martineau@linux.intel.com>
X-Mailer: git-send-email 2.32.0
In-Reply-To: <20210618220221.99172-1-mathew.j.martineau@linux.intel.com>
References: <20210618220221.99172-1-mathew.j.martineau@linux.intel.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Paolo Abeni <pabeni@redhat.com>

The current implementation of 32 bit DSN expansion is buggy.
After the previous patch, we can simply reuse the newly
introduced helper to do the expansion safely.

Closes: https://github.com/multipath-tcp/mptcp_net-next/issues/120
Fixes: 648ef4b88673 ("mptcp: Implement MPTCP receive path")
Reviewed-by: Mat Martineau <mathew.j.martineau@linux.intel.com>
Signed-off-by: Paolo Abeni <pabeni@redhat.com>
---
 net/mptcp/subflow.c | 17 +----------------
 1 file changed, 1 insertion(+), 16 deletions(-)

diff --git a/net/mptcp/subflow.c b/net/mptcp/subflow.c
index be1de4084196..037fba41e170 100644
--- a/net/mptcp/subflow.c
+++ b/net/mptcp/subflow.c
@@ -775,15 +775,6 @@ enum mapping_status {
 	MAPPING_DUMMY
 };
 
-static u64 expand_seq(u64 old_seq, u16 old_data_len, u64 seq)
-{
-	if ((u32)seq == (u32)old_seq)
-		return old_seq;
-
-	/* Assume map covers data not mapped yet. */
-	return seq | ((old_seq + old_data_len + 1) & GENMASK_ULL(63, 32));
-}
-
 static void dbg_bad_map(struct mptcp_subflow_context *subflow, u32 ssn)
 {
 	pr_debug("Bad mapping: ssn=%d map_seq=%d map_data_len=%d",
@@ -907,13 +898,7 @@ static enum mapping_status get_mapping_status(struct sock *ssk,
 		data_len--;
 	}
 
-	if (!mpext->dsn64) {
-		map_seq = expand_seq(subflow->map_seq, subflow->map_data_len,
-				     mpext->data_seq);
-		pr_debug("expanded seq=%llu", subflow->map_seq);
-	} else {
-		map_seq = mpext->data_seq;
-	}
+	map_seq = mptcp_expand_seq(READ_ONCE(msk->ack_seq), mpext->data_seq, mpext->dsn64);
 	WRITE_ONCE(mptcp_sk(subflow->conn)->use_64bit_ack, !!mpext->dsn64);
 
 	if (subflow->map_valid) {
-- 
2.32.0

