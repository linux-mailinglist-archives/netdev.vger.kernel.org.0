Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 30B9156C534
	for <lists+netdev@lfdr.de>; Sat,  9 Jul 2022 02:29:47 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S238526AbiGHXgS (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 8 Jul 2022 19:36:18 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:37060 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230367AbiGHXgR (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 8 Jul 2022 19:36:17 -0400
Received: from mga06.intel.com (mga06b.intel.com [134.134.136.31])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id E637171BCD
        for <netdev@vger.kernel.org>; Fri,  8 Jul 2022 16:36:16 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1657323376; x=1688859376;
  h=from:to:cc:subject:date:message-id:in-reply-to:
   references:mime-version:content-transfer-encoding;
  bh=cNc661S3iimevezDyva1ssvcfT/UsrE7h/xgcUHLZHg=;
  b=RxGIsFZ0dBGja6E8uXkbg4NcKKRCoB7WX6GPE5Q/xUTIcYjRAPbA/3D/
   Q4q/9QnnVCEBXTLsQVJZaeWiqmSsFHBq8n2fvHnvYu5i8OXuCZo8I7HEQ
   6MfbpapyhlJ0TlmxDbFVBLQouUNelGHfqQ3vl4co5Tj5zecnsAbwy/SRj
   3ECxnPMo94EDuB7+/p8sC9ocCEcf6RY5dlj/FIJop/oRWY4OH4odLoA8v
   UWio1rpiOhXp5JjLRaDh+RfmlKn0KEuxd+VTYWNek6O+TyT2NfDzroCzW
   O9O7++NNVfY1ZjwqfA2JTAD/FagOdPZfxhhQeG6p2+WjJH8wZVwemWlll
   A==;
X-IronPort-AV: E=McAfee;i="6400,9594,10402"; a="346071656"
X-IronPort-AV: E=Sophos;i="5.92,256,1650956400"; 
   d="scan'208";a="346071656"
Received: from orsmga005.jf.intel.com ([10.7.209.41])
  by orsmga104.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 08 Jul 2022 16:36:14 -0700
X-IronPort-AV: E=Sophos;i="5.92,256,1650956400"; 
   d="scan'208";a="770933079"
Received: from aroras-mobl.amr.corp.intel.com (HELO mjmartin-desk2.intel.com) ([10.209.1.203])
  by orsmga005-auth.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 08 Jul 2022 16:36:14 -0700
From:   Mat Martineau <mathew.j.martineau@linux.intel.com>
To:     netdev@vger.kernel.org
Cc:     Paolo Abeni <pabeni@redhat.com>, davem@davemloft.net,
        kuba@kernel.org, edumazet@google.com, kishen.maloor@intel.com,
        matthieu.baerts@tessares.net, mptcp@lists.linux.dev,
        van fantasy <g1042620637@gmail.com>,
        Mat Martineau <mathew.j.martineau@linux.intel.com>
Subject: [PATCH net 1/2] mptcp: fix subflow traversal at disconnect time
Date:   Fri,  8 Jul 2022 16:36:09 -0700
Message-Id: <20220708233610.410786-2-mathew.j.martineau@linux.intel.com>
X-Mailer: git-send-email 2.37.0
In-Reply-To: <20220708233610.410786-1-mathew.j.martineau@linux.intel.com>
References: <20220708233610.410786-1-mathew.j.martineau@linux.intel.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-5.0 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_EF,RCVD_IN_DNSWL_MED,SPF_HELO_NONE,
        SPF_NONE,T_SCC_BODY_TEXT_LINE autolearn=ham autolearn_force=no
        version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Paolo Abeni <pabeni@redhat.com>

At disconnect time the MPTCP protocol traverse the subflows
list closing each of them. In some circumstances - MPJ subflow,
passive MPTCP socket, the latter operation can remove the
subflow from the list, invalidating the current iterator.

Address the issue using the safe list traversing helper
variant.

Reported-by: van fantasy <g1042620637@gmail.com>
Fixes: b29fcfb54cd7 ("mptcp: full disconnect implementation")
Tested-by: Matthieu Baerts <matthieu.baerts@tessares.net>
Reviewed-by: Mat Martineau <mathew.j.martineau@linux.intel.com>
Signed-off-by: Paolo Abeni <pabeni@redhat.com>
Signed-off-by: Mat Martineau <mathew.j.martineau@linux.intel.com>
---
 net/mptcp/protocol.c | 4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

diff --git a/net/mptcp/protocol.c b/net/mptcp/protocol.c
index cc21fafd9726..21a3ed64226e 100644
--- a/net/mptcp/protocol.c
+++ b/net/mptcp/protocol.c
@@ -2919,12 +2919,12 @@ static void mptcp_copy_inaddrs(struct sock *msk, const struct sock *ssk)
 
 static int mptcp_disconnect(struct sock *sk, int flags)
 {
-	struct mptcp_subflow_context *subflow;
+	struct mptcp_subflow_context *subflow, *tmp;
 	struct mptcp_sock *msk = mptcp_sk(sk);
 
 	inet_sk_state_store(sk, TCP_CLOSE);
 
-	mptcp_for_each_subflow(msk, subflow) {
+	list_for_each_entry_safe(subflow, tmp, &msk->conn_list, node) {
 		struct sock *ssk = mptcp_subflow_tcp_sock(subflow);
 
 		__mptcp_close_ssk(sk, ssk, subflow, MPTCP_CF_FASTCLOSE);
-- 
2.37.0

