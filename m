Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id E032252C5F9
	for <lists+netdev@lfdr.de>; Thu, 19 May 2022 00:07:17 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229471AbiERWGw (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 18 May 2022 18:06:52 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:38102 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229785AbiERWG2 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 18 May 2022 18:06:28 -0400
Received: from mga04.intel.com (mga04.intel.com [192.55.52.120])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 440551B1CC8
        for <netdev@vger.kernel.org>; Wed, 18 May 2022 15:04:54 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1652911494; x=1684447494;
  h=from:to:cc:subject:date:message-id:in-reply-to:
   references:mime-version:content-transfer-encoding;
  bh=hIRxRCdZVwJzOTRyToBDC8wOrpXFZqS/+AneHQ5JYEA=;
  b=bxYICvfSszbGSMmULaS73D6cuEXQIG//rubXf47I7oj5bI7amblQFJkx
   j4Lqw45XUlvLJnX1x0CukZvO3+a5+EnEnPINhIBn8d0NjwPgf0UIRhW0q
   N/CZSLGcUkcMFNikEih8jDi8B1HWXNxN47MaBpCUSrLjcYgEQGmpt6DN3
   0yZtaCigFk2vz6YcoBuBYpqzB3fyimK24Z7H/ofu5aWxkvW7OOu0mLmJD
   ePh3SPU1nofFxrZFzemIix7q+6Lt8XXw13F47agR5a3wpDHrybTk1e8nQ
   cpDAT9NYn36tXq85AtiMHR8tG1e/vHIZ+aTgiM4im1St9/fRpkdDfX33Y
   A==;
X-IronPort-AV: E=McAfee;i="6400,9594,10351"; a="270734208"
X-IronPort-AV: E=Sophos;i="5.91,235,1647327600"; 
   d="scan'208";a="270734208"
Received: from orsmga008.jf.intel.com ([10.7.209.65])
  by fmsmga104.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 18 May 2022 15:04:51 -0700
X-IronPort-AV: E=Sophos;i="5.91,235,1647327600"; 
   d="scan'208";a="598075440"
Received: from mjmartin-desk2.amr.corp.intel.com (HELO mjmartin-desk2.intel.com) ([10.209.36.18])
  by orsmga008-auth.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 18 May 2022 15:04:51 -0700
From:   Mat Martineau <mathew.j.martineau@linux.intel.com>
To:     netdev@vger.kernel.org
Cc:     Mat Martineau <mathew.j.martineau@linux.intel.com>,
        davem@davemloft.net, kuba@kernel.org, pabeni@redhat.com,
        edumazet@google.com, matthieu.baerts@tessares.net,
        mptcp@lists.linux.dev
Subject: [PATCH net-next 3/4] mptcp: Do not traverse the subflow connection list without lock
Date:   Wed, 18 May 2022 15:04:45 -0700
Message-Id: <20220518220446.209750-4-mathew.j.martineau@linux.intel.com>
X-Mailer: git-send-email 2.36.1
In-Reply-To: <20220518220446.209750-1-mathew.j.martineau@linux.intel.com>
References: <20220518220446.209750-1-mathew.j.martineau@linux.intel.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-4.6 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_EF,RCVD_IN_DNSWL_MED,SPF_HELO_NONE,
        SPF_NONE,T_SCC_BODY_TEXT_LINE autolearn=ham autolearn_force=no
        version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

The MPTCP socket's conn_list (list of subflows) requires the socket lock
to access. The MP_FAIL timeout code added such an access, where it would
check the list of subflows both in timer context and (later) in workqueue
context where the socket lock is held.

Rather than check the list twice, remove the check in the timeout
handler and only depend on the check in the workqueue. Also remove the
MPTCP_FAIL_NO_RESPONSE flag, since mptcp_mp_fail_no_response() has
insignificant overhead and can be checked on each worker run.

Fixes: 49fa1919d6bc ("mptcp: reset subflow when MP_FAIL doesn't respond")
Reported-by: Paolo Abeni <pabeni@redhat.com>
Reviewed-by: Paolo Abeni <pabeni@redhat.com>
Signed-off-by: Mat Martineau <mathew.j.martineau@linux.intel.com>
---
 net/mptcp/protocol.c | 16 +---------------
 net/mptcp/protocol.h |  1 -
 2 files changed, 1 insertion(+), 16 deletions(-)

diff --git a/net/mptcp/protocol.c b/net/mptcp/protocol.c
index 921d67174e49..17e13396024a 100644
--- a/net/mptcp/protocol.c
+++ b/net/mptcp/protocol.c
@@ -2190,23 +2190,10 @@ mp_fail_response_expect_subflow(struct mptcp_sock *msk)
 	return ret;
 }
 
-static void mptcp_check_mp_fail_response(struct mptcp_sock *msk)
-{
-	struct mptcp_subflow_context *subflow;
-	struct sock *sk = (struct sock *)msk;
-
-	bh_lock_sock(sk);
-	subflow = mp_fail_response_expect_subflow(msk);
-	if (subflow)
-		__set_bit(MPTCP_FAIL_NO_RESPONSE, &msk->flags);
-	bh_unlock_sock(sk);
-}
-
 static void mptcp_timeout_timer(struct timer_list *t)
 {
 	struct sock *sk = from_timer(sk, t, sk_timer);
 
-	mptcp_check_mp_fail_response(mptcp_sk(sk));
 	mptcp_schedule_work(sk);
 	sock_put(sk);
 }
@@ -2588,8 +2575,7 @@ static void mptcp_worker(struct work_struct *work)
 	if (test_and_clear_bit(MPTCP_WORK_RTX, &msk->flags))
 		__mptcp_retrans(sk);
 
-	if (test_and_clear_bit(MPTCP_FAIL_NO_RESPONSE, &msk->flags))
-		mptcp_mp_fail_no_response(msk);
+	mptcp_mp_fail_no_response(msk);
 
 unlock:
 	release_sock(sk);
diff --git a/net/mptcp/protocol.h b/net/mptcp/protocol.h
index 91f7ef6e6c56..5e371b278252 100644
--- a/net/mptcp/protocol.h
+++ b/net/mptcp/protocol.h
@@ -117,7 +117,6 @@
 #define MPTCP_WORK_EOF		3
 #define MPTCP_FALLBACK_DONE	4
 #define MPTCP_WORK_CLOSE_SUBFLOW 5
-#define MPTCP_FAIL_NO_RESPONSE	6
 
 /* MPTCP socket release cb flags */
 #define MPTCP_PUSH_PENDING	1
-- 
2.36.1

