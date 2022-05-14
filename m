Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id DC8CD526E86
	for <lists+netdev@lfdr.de>; Sat, 14 May 2022 09:14:22 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230380AbiENDA2 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 13 May 2022 23:00:28 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:33004 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230457AbiENC7k (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 13 May 2022 22:59:40 -0400
Received: from mga02.intel.com (mga02.intel.com [134.134.136.20])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 88DBC36AE36
        for <netdev@vger.kernel.org>; Fri, 13 May 2022 18:28:51 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1652491731; x=1684027731;
  h=from:to:cc:subject:date:message-id:in-reply-to:
   references:mime-version:content-transfer-encoding;
  bh=uGgFF3Eow8jiNYdNies67VwJuxXcoh+pEdlSM7stZoQ=;
  b=gUlATMrRJU3MvaTB8twBZE18Q8YF8VkjQ8B10H7Onr3zPYRSt9/8a9Kt
   8vaUa429AonpZobp44MWtMnjQfSNckS3Y8F2SoAp2BK1xiRbDdr7VHfSt
   Tz3GoMhs9xfShbUuOQhu4BeyRNCuXn0dF9+rOgLscxcbdL4AI6NDKeHkV
   tcaf7HfF0Lrpbo3VXHefI9SQrviCTDFdRcFA1CXpcnXq8MN6eaPi3EROo
   z+97iu+Ld6MWB+HVKJw03L+QoiV7mD9gibE58sWQi41WwFpQUichlDgW3
   sflTlabZ6NwF9r0PgQQ7NkKYQnVtMFDVRGkq7fQdphwH0Hr5GgPAPwgE6
   g==;
X-IronPort-AV: E=McAfee;i="6400,9594,10346"; a="257994310"
X-IronPort-AV: E=Sophos;i="5.91,223,1647327600"; 
   d="scan'208";a="257994310"
Received: from fmsmga008.fm.intel.com ([10.253.24.58])
  by orsmga101.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 13 May 2022 17:21:21 -0700
X-IronPort-AV: E=Sophos;i="5.91,223,1647327600"; 
   d="scan'208";a="625102786"
Received: from clakshma-mobl1.amr.corp.intel.com (HELO mjmartin-desk2.intel.com) ([10.212.160.121])
  by fmsmga008-auth.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 13 May 2022 17:21:20 -0700
From:   Mat Martineau <mathew.j.martineau@linux.intel.com>
To:     netdev@vger.kernel.org
Cc:     Paolo Abeni <pabeni@redhat.com>, davem@davemloft.net,
        kuba@kernel.org, edumazet@google.com, matthieu.baerts@tessares.net,
        mptcp@lists.linux.dev,
        Mat Martineau <mathew.j.martineau@linux.intel.com>
Subject: [PATCH net-next 2/3] Revert "mptcp: add data lock for sk timers"
Date:   Fri, 13 May 2022 17:21:14 -0700
Message-Id: <20220514002115.725976-3-mathew.j.martineau@linux.intel.com>
X-Mailer: git-send-email 2.36.1
In-Reply-To: <20220514002115.725976-1-mathew.j.martineau@linux.intel.com>
References: <20220514002115.725976-1-mathew.j.martineau@linux.intel.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-4.9 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_EF,RCVD_IN_DNSWL_MED,
        RCVD_IN_MSPIKE_H3,RCVD_IN_MSPIKE_WL,SPF_HELO_NONE,SPF_NONE,
        T_SCC_BODY_TEXT_LINE autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Paolo Abeni <pabeni@redhat.com>

This reverts commit 4293248c6704b854bf816aa1967e433402bee11c.

Additional locks are not needed, all the touched sections
are already under mptcp socket lock protection.

Fixes: 4293248c6704 ("mptcp: add data lock for sk timers")
Signed-off-by: Paolo Abeni <pabeni@redhat.com>
Signed-off-by: Mat Martineau <mathew.j.martineau@linux.intel.com>
---
 net/mptcp/protocol.c | 12 ------------
 1 file changed, 12 deletions(-)

diff --git a/net/mptcp/protocol.c b/net/mptcp/protocol.c
index 9e46cc89a8f7..921d67174e49 100644
--- a/net/mptcp/protocol.c
+++ b/net/mptcp/protocol.c
@@ -1613,10 +1613,8 @@ void __mptcp_push_pending(struct sock *sk, unsigned int flags)
 
 out:
 	/* ensure the rtx timer is running */
-	mptcp_data_lock(sk);
 	if (!mptcp_timer_pending(sk))
 		mptcp_reset_timer(sk);
-	mptcp_data_unlock(sk);
 	if (copied)
 		__mptcp_check_send_data_fin(sk);
 }
@@ -2529,10 +2527,8 @@ static void __mptcp_retrans(struct sock *sk)
 reset_timer:
 	mptcp_check_and_set_pending(sk);
 
-	mptcp_data_lock(sk);
 	if (!mptcp_timer_pending(sk))
 		mptcp_reset_timer(sk);
-	mptcp_data_unlock(sk);
 }
 
 static void mptcp_mp_fail_no_response(struct mptcp_sock *msk)
@@ -2711,10 +2707,8 @@ void mptcp_subflow_shutdown(struct sock *sk, struct sock *ssk, int how)
 		} else {
 			pr_debug("Sending DATA_FIN on subflow %p", ssk);
 			tcp_send_ack(ssk);
-			mptcp_data_lock(sk);
 			if (!mptcp_timer_pending(sk))
 				mptcp_reset_timer(sk);
-			mptcp_data_unlock(sk);
 		}
 		break;
 	}
@@ -2815,10 +2809,8 @@ static void __mptcp_destroy_sock(struct sock *sk)
 	/* join list will be eventually flushed (with rst) at sock lock release time*/
 	list_splice_init(&msk->conn_list, &conn_list);
 
-	mptcp_data_lock(sk);
 	mptcp_stop_timer(sk);
 	sk_stop_timer(sk, &sk->sk_timer);
-	mptcp_data_unlock(sk);
 	msk->pm.status = 0;
 
 	/* clears msk->subflow, allowing the following loop to close
@@ -2880,9 +2872,7 @@ static void mptcp_close(struct sock *sk, long timeout)
 		__mptcp_destroy_sock(sk);
 		do_cancel_work = true;
 	} else {
-		mptcp_data_lock(sk);
 		sk_reset_timer(sk, &sk->sk_timer, jiffies + TCP_TIMEWAIT_LEN);
-		mptcp_data_unlock(sk);
 	}
 	release_sock(sk);
 	if (do_cancel_work)
@@ -2927,10 +2917,8 @@ static int mptcp_disconnect(struct sock *sk, int flags)
 		__mptcp_close_ssk(sk, ssk, subflow, MPTCP_CF_FASTCLOSE);
 	}
 
-	mptcp_data_lock(sk);
 	mptcp_stop_timer(sk);
 	sk_stop_timer(sk, &sk->sk_timer);
-	mptcp_data_unlock(sk);
 
 	if (mptcp_sk(sk)->token)
 		mptcp_event(MPTCP_EVENT_CLOSED, mptcp_sk(sk), NULL, GFP_KERNEL);
-- 
2.36.1

