Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 713966606CF
	for <lists+netdev@lfdr.de>; Fri,  6 Jan 2023 19:58:46 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S235797AbjAFS6C (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 6 Jan 2023 13:58:02 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:42448 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S235942AbjAFS5h (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 6 Jan 2023 13:57:37 -0500
Received: from mga14.intel.com (mga14.intel.com [192.55.52.115])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id B000781D4B
        for <netdev@vger.kernel.org>; Fri,  6 Jan 2023 10:57:35 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1673031455; x=1704567455;
  h=from:to:cc:subject:date:message-id:in-reply-to:
   references:mime-version:content-transfer-encoding;
  bh=VzJfVlQ571v6VdgLesu+EKplLE34E99sLdGCS/UkJ/k=;
  b=Tci68WgBLbhCrXJ4rwPO5NP78l/aT1mDBabAzWr7EstVUUuuyaMvk6Kj
   rivauUme+dTjsczCQjCpR8lI5ExDXJHMvfsIg9B/zut10YEQZuuWG6PvK
   11XjNPpBj7cfTCNc0hEEnOpo4aHSauGXSG0Yc1lCEbyoKtcGBbU1Ze4nt
   CFdpa9g1FGRLWi3H428+q0iFrSYDbfVWqPFYklIFO9MicI0tw78tgTryV
   OMPSa+q2+3VXhZkoRNOkNbBgrGduXbXuElhVE9U9mmt14oaF8I85iz6Yg
   h6Xlw5jbEiJuKEbChIVIF73DGDTKY45pACRJvbW56OfTlQDFXR8g/M7ss
   w==;
X-IronPort-AV: E=McAfee;i="6500,9779,10582"; a="322611204"
X-IronPort-AV: E=Sophos;i="5.96,306,1665471600"; 
   d="scan'208";a="322611204"
Received: from orsmga001.jf.intel.com ([10.7.209.18])
  by fmsmga103.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 06 Jan 2023 10:57:33 -0800
X-IronPort-AV: E=McAfee;i="6500,9779,10582"; a="688383427"
X-IronPort-AV: E=Sophos;i="5.96,306,1665471600"; 
   d="scan'208";a="688383427"
Received: from mechevar-mobl.amr.corp.intel.com (HELO mjmartin-desk2.intel.com) ([10.209.66.63])
  by orsmga001-auth.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 06 Jan 2023 10:57:33 -0800
From:   Mat Martineau <mathew.j.martineau@linux.intel.com>
To:     netdev@vger.kernel.org
Cc:     Geliang Tang <geliang.tang@suse.com>, davem@davemloft.net,
        kuba@kernel.org, pabeni@redhat.com, edumazet@google.com,
        matthieu.baerts@tessares.net, mptcp@lists.linux.dev,
        Mat Martineau <mathew.j.martineau@linux.intel.com>
Subject: [PATCH net-next 1/9] mptcp: use msk_owned_by_me helper
Date:   Fri,  6 Jan 2023 10:57:17 -0800
Message-Id: <20230106185725.299977-2-mathew.j.martineau@linux.intel.com>
X-Mailer: git-send-email 2.39.0
In-Reply-To: <20230106185725.299977-1-mathew.j.martineau@linux.intel.com>
References: <20230106185725.299977-1-mathew.j.martineau@linux.intel.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-4.3 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_EF,RCVD_IN_DNSWL_MED,SPF_HELO_NONE,
        SPF_NONE autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Geliang Tang <geliang.tang@suse.com>

The helper msk_owned_by_me() is defined in protocol.h, so use it instead
of sock_owned_by_me().

Reviewed-by: Mat Martineau <mathew.j.martineau@linux.intel.com>
Signed-off-by: Geliang Tang <geliang.tang@suse.com>
Signed-off-by: Mat Martineau <mathew.j.martineau@linux.intel.com>
---
 net/mptcp/protocol.c | 9 ++++-----
 net/mptcp/sockopt.c  | 2 +-
 2 files changed, 5 insertions(+), 6 deletions(-)

diff --git a/net/mptcp/protocol.c b/net/mptcp/protocol.c
index b7ad030dfe89..c533b4647fbe 100644
--- a/net/mptcp/protocol.c
+++ b/net/mptcp/protocol.c
@@ -923,9 +923,8 @@ static void mptcp_check_for_eof(struct mptcp_sock *msk)
 static struct sock *mptcp_subflow_recv_lookup(const struct mptcp_sock *msk)
 {
 	struct mptcp_subflow_context *subflow;
-	struct sock *sk = (struct sock *)msk;
 
-	sock_owned_by_me(sk);
+	msk_owned_by_me(msk);
 
 	mptcp_for_each_subflow(msk, subflow) {
 		if (READ_ONCE(subflow->data_avail))
@@ -1408,7 +1407,7 @@ static struct sock *mptcp_subflow_get_send(struct mptcp_sock *msk)
 	u64 linger_time;
 	long tout = 0;
 
-	sock_owned_by_me(sk);
+	msk_owned_by_me(msk);
 
 	if (__mptcp_check_fallback(msk)) {
 		if (!msk->first)
@@ -1890,7 +1889,7 @@ static void mptcp_rcv_space_adjust(struct mptcp_sock *msk, int copied)
 	u32 time, advmss = 1;
 	u64 rtt_us, mstamp;
 
-	sock_owned_by_me(sk);
+	msk_owned_by_me(msk);
 
 	if (copied <= 0)
 		return;
@@ -2217,7 +2216,7 @@ static struct sock *mptcp_subflow_get_retrans(struct mptcp_sock *msk)
 	struct mptcp_subflow_context *subflow;
 	int min_stale_count = INT_MAX;
 
-	sock_owned_by_me((const struct sock *)msk);
+	msk_owned_by_me(msk);
 
 	if (__mptcp_check_fallback(msk))
 		return NULL;
diff --git a/net/mptcp/sockopt.c b/net/mptcp/sockopt.c
index d4b1e6ec1b36..582ed93bcc8a 100644
--- a/net/mptcp/sockopt.c
+++ b/net/mptcp/sockopt.c
@@ -18,7 +18,7 @@
 
 static struct sock *__mptcp_tcp_fallback(struct mptcp_sock *msk)
 {
-	sock_owned_by_me((const struct sock *)msk);
+	msk_owned_by_me(msk);
 
 	if (likely(!__mptcp_check_fallback(msk)))
 		return NULL;
-- 
2.39.0

