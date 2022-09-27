Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 8D9B75ECCF7
	for <lists+netdev@lfdr.de>; Tue, 27 Sep 2022 21:34:11 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231899AbiI0Tdr (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 27 Sep 2022 15:33:47 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:60494 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231879AbiI0Tdi (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 27 Sep 2022 15:33:38 -0400
Received: from mga11.intel.com (mga11.intel.com [192.55.52.93])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 578E8F1628;
        Tue, 27 Sep 2022 12:33:37 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1664307217; x=1695843217;
  h=from:to:cc:subject:date:message-id:in-reply-to:
   references:mime-version:content-transfer-encoding;
  bh=lj5Dh5PktHR1/wBlmoRV33Y7KeYrd1UcvZO77ytT+sA=;
  b=XV8e4lokfL1iZBOV5HhSEDn8F9ik5w3UehRJHvGlqKuHDRcbJKJ1qyPq
   u+hbY+oi64xv8la0Ip7xzFQctmpOPGPr5ah8GrcHoXPVqohV/+5CXZSXs
   EYic/xEK6QnM4aBG4nUvePawCLyBJEjnHkqK178B1uDCy73zYN2NcCOgI
   FTWhSinSJtj7Q3jswfJWMkwuDfK4pN7i8DCa1LzLqcB3wfRNqFYsvyZMD
   lc9IKHjqDrXFH+oUavZAyu3N4r59AkcnoP4u2sqVaHvuBCTsBOqGGTcPF
   W/ZThRhnp4+jvfOrL961rKK3On1iIBBtjuPV8SwRaJex0fX8VtOJRZOdA
   Q==;
X-IronPort-AV: E=McAfee;i="6500,9779,10483"; a="299010396"
X-IronPort-AV: E=Sophos;i="5.93,350,1654585200"; 
   d="scan'208";a="299010396"
Received: from orsmga008.jf.intel.com ([10.7.209.65])
  by fmsmga102.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 27 Sep 2022 12:32:04 -0700
X-IronPort-AV: E=McAfee;i="6500,9779,10483"; a="652399449"
X-IronPort-AV: E=Sophos;i="5.93,350,1654585200"; 
   d="scan'208";a="652399449"
Received: from soumiban-mobl1.amr.corp.intel.com (HELO mjmartin-desk2.intel.com) ([10.209.81.98])
  by orsmga008-auth.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 27 Sep 2022 12:32:03 -0700
From:   Mat Martineau <mathew.j.martineau@linux.intel.com>
To:     netdev@vger.kernel.org
Cc:     Menglong Dong <imagedong@tencent.com>, davem@davemloft.net,
        kuba@kernel.org, pabeni@redhat.com, edumazet@google.com,
        fw@strlen.de, matthieu.baerts@tessares.net, mptcp@lists.linux.dev,
        stable@vger.kernel.org, Jiang Biao <benbjiang@tencent.com>,
        Mengen Sun <mengensun@tencent.com>,
        Mat Martineau <mathew.j.martineau@linux.intel.com>
Subject: [PATCH net 1/2] mptcp: factor out __mptcp_close() without socket lock
Date:   Tue, 27 Sep 2022 12:31:57 -0700
Message-Id: <20220927193158.195729-2-mathew.j.martineau@linux.intel.com>
X-Mailer: git-send-email 2.37.3
In-Reply-To: <20220927193158.195729-1-mathew.j.martineau@linux.intel.com>
References: <20220927193158.195729-1-mathew.j.martineau@linux.intel.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-7.1 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,SPF_HELO_NONE,
        SPF_NONE autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Menglong Dong <imagedong@tencent.com>

Factor out __mptcp_close() from mptcp_close(). The caller of
__mptcp_close() should hold the socket lock, and cancel mptcp work when
__mptcp_close() returns true.

This function will be used in the next commit.

Fixes: f296234c98a8 ("mptcp: Add handling of incoming MP_JOIN requests")
Fixes: 6aeed9045071 ("mptcp: fix race on unaccepted mptcp sockets")
Cc: stable@vger.kernel.org
Reviewed-by: Jiang Biao <benbjiang@tencent.com>
Reviewed-by: Mengen Sun <mengensun@tencent.com>
Acked-by: Paolo Abeni <pabeni@redhat.com>
Signed-off-by: Menglong Dong <imagedong@tencent.com>
Signed-off-by: Mat Martineau <mathew.j.martineau@linux.intel.com>
---
 net/mptcp/protocol.c | 14 ++++++++++++--
 net/mptcp/protocol.h |  1 +
 2 files changed, 13 insertions(+), 2 deletions(-)

diff --git a/net/mptcp/protocol.c b/net/mptcp/protocol.c
index 969b33a9dd64..f7690414320a 100644
--- a/net/mptcp/protocol.c
+++ b/net/mptcp/protocol.c
@@ -2802,13 +2802,12 @@ static void __mptcp_destroy_sock(struct sock *sk)
 	sock_put(sk);
 }
 
-static void mptcp_close(struct sock *sk, long timeout)
+bool __mptcp_close(struct sock *sk, long timeout)
 {
 	struct mptcp_subflow_context *subflow;
 	struct mptcp_sock *msk = mptcp_sk(sk);
 	bool do_cancel_work = false;
 
-	lock_sock(sk);
 	sk->sk_shutdown = SHUTDOWN_MASK;
 
 	if ((1 << sk->sk_state) & (TCPF_LISTEN | TCPF_CLOSE)) {
@@ -2850,6 +2849,17 @@ static void mptcp_close(struct sock *sk, long timeout)
 	} else {
 		mptcp_reset_timeout(msk, 0);
 	}
+
+	return do_cancel_work;
+}
+
+static void mptcp_close(struct sock *sk, long timeout)
+{
+	bool do_cancel_work;
+
+	lock_sock(sk);
+
+	do_cancel_work = __mptcp_close(sk, timeout);
 	release_sock(sk);
 	if (do_cancel_work)
 		mptcp_cancel_work(sk);
diff --git a/net/mptcp/protocol.h b/net/mptcp/protocol.h
index 132d50833df1..8f123d450c76 100644
--- a/net/mptcp/protocol.h
+++ b/net/mptcp/protocol.h
@@ -612,6 +612,7 @@ void mptcp_subflow_reset(struct sock *ssk);
 void mptcp_subflow_queue_clean(struct sock *ssk);
 void mptcp_sock_graft(struct sock *sk, struct socket *parent);
 struct socket *__mptcp_nmpc_socket(const struct mptcp_sock *msk);
+bool __mptcp_close(struct sock *sk, long timeout);
 
 bool mptcp_addresses_equal(const struct mptcp_addr_info *a,
 			   const struct mptcp_addr_info *b, bool use_port);
-- 
2.37.3

