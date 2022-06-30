Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 628D45625F7
	for <lists+netdev@lfdr.de>; Fri,  1 Jul 2022 00:18:51 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231283AbiF3WSP (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 30 Jun 2022 18:18:15 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:43742 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231172AbiF3WSF (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 30 Jun 2022 18:18:05 -0400
Received: from mga03.intel.com (mga03.intel.com [134.134.136.65])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 1FAE357257
        for <netdev@vger.kernel.org>; Thu, 30 Jun 2022 15:18:04 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1656627484; x=1688163484;
  h=from:to:cc:subject:date:message-id:in-reply-to:
   references:mime-version:content-transfer-encoding;
  bh=+nXFSZV6auwwe5r6EZ7dcssoTkxwua1fREwHRzORSDY=;
  b=G4/BPWtbKTeToUyIcmYStDxe8KdQxHozGFy89IN5HvP7fawuXk2jHFPD
   Kw8iMjYckLYragD9+h439Jv+LeKsJ3ja9PyHiHBpBA8W8kncINEw2CtuQ
   OhtccGNiMcHlMs6kCp02aupEkshKcLronFQsBRAr36OQfW8VPvEmfTtt2
   HvHcTLAHDbEsaAnAMIeNPSyBhTwrQky8OUMb6RbMHl5qYJ23U1P060Q1o
   2NWPdRbthfAjGhxK3sTr2G4Drdwi1S7vfH+FUrbkH1uUaoE+vN7JJYwJF
   1MjiB6XTtQQqUNK1fjMjVRVI5LiGTW3eSjaqW+ZatyuQYMwT9643nNhzm
   Q==;
X-IronPort-AV: E=McAfee;i="6400,9594,10394"; a="283583506"
X-IronPort-AV: E=Sophos;i="5.92,235,1650956400"; 
   d="scan'208";a="283583506"
Received: from fmsmga001.fm.intel.com ([10.253.24.23])
  by orsmga103.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 30 Jun 2022 15:18:02 -0700
X-IronPort-AV: E=Sophos;i="5.92,235,1650956400"; 
   d="scan'208";a="733804540"
Received: from mhtran-desk5.amr.corp.intel.com (HELO mjmartin-desk2.intel.com) ([10.212.176.78])
  by fmsmga001-auth.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 30 Jun 2022 15:18:02 -0700
From:   Mat Martineau <mathew.j.martineau@linux.intel.com>
To:     netdev@vger.kernel.org
Cc:     Paolo Abeni <pabeni@redhat.com>, davem@davemloft.net,
        kuba@kernel.org, edumazet@google.com, matthieu.baerts@tessares.net,
        mptcp@lists.linux.dev,
        Mat Martineau <mathew.j.martineau@linux.intel.com>
Subject: [PATCH net-next 2/4] mptcp: drop SK_RECLAIM_* macros
Date:   Thu, 30 Jun 2022 15:17:55 -0700
Message-Id: <20220630221757.763751-3-mathew.j.martineau@linux.intel.com>
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

After commit 4890b686f408 ("net: keep sk->sk_forward_alloc as small as
possible"), the MPTCP protocol is the last SK_RECLAIM_CHUNK and
SK_RECLAIM_THRESHOLD users.

Update the MPTCP reclaim schema to match the core/TCP one and drop the
mentioned macros. This additionally clean the MPTCP code a bit.

Signed-off-by: Paolo Abeni <pabeni@redhat.com>
Signed-off-by: Mat Martineau <mathew.j.martineau@linux.intel.com>
---
 net/mptcp/protocol.c | 35 ++---------------------------------
 1 file changed, 2 insertions(+), 33 deletions(-)

diff --git a/net/mptcp/protocol.c b/net/mptcp/protocol.c
index c67c6fc1fe04..e89a0124023f 100644
--- a/net/mptcp/protocol.c
+++ b/net/mptcp/protocol.c
@@ -181,8 +181,8 @@ static void mptcp_rmem_uncharge(struct sock *sk, int size)
 	reclaimable = msk->rmem_fwd_alloc - sk_unused_reserved_mem(sk);
 
 	/* see sk_mem_uncharge() for the rationale behind the following schema */
-	if (unlikely(reclaimable >= SK_RECLAIM_THRESHOLD))
-		__mptcp_rmem_reclaim(sk, SK_RECLAIM_CHUNK);
+	if (unlikely(reclaimable >= PAGE_SIZE))
+		__mptcp_rmem_reclaim(sk, reclaimable);
 }
 
 static void mptcp_rfree(struct sk_buff *skb)
@@ -961,25 +961,6 @@ static bool mptcp_frag_can_collapse_to(const struct mptcp_sock *msk,
 		df->data_seq + df->data_len == msk->write_seq;
 }
 
-static void __mptcp_mem_reclaim_partial(struct sock *sk)
-{
-	int reclaimable = mptcp_sk(sk)->rmem_fwd_alloc - sk_unused_reserved_mem(sk);
-
-	lockdep_assert_held_once(&sk->sk_lock.slock);
-
-	if (reclaimable > (int)PAGE_SIZE)
-		__mptcp_rmem_reclaim(sk, reclaimable - 1);
-
-	sk_mem_reclaim(sk);
-}
-
-static void mptcp_mem_reclaim_partial(struct sock *sk)
-{
-	mptcp_data_lock(sk);
-	__mptcp_mem_reclaim_partial(sk);
-	mptcp_data_unlock(sk);
-}
-
 static void dfrag_uncharge(struct sock *sk, int len)
 {
 	sk_mem_uncharge(sk, len);
@@ -999,7 +980,6 @@ static void __mptcp_clean_una(struct sock *sk)
 {
 	struct mptcp_sock *msk = mptcp_sk(sk);
 	struct mptcp_data_frag *dtmp, *dfrag;
-	bool cleaned = false;
 	u64 snd_una;
 
 	/* on fallback we just need to ignore snd_una, as this is really
@@ -1022,7 +1002,6 @@ static void __mptcp_clean_una(struct sock *sk)
 		}
 
 		dfrag_clear(sk, dfrag);
-		cleaned = true;
 	}
 
 	dfrag = mptcp_rtx_head(sk);
@@ -1044,7 +1023,6 @@ static void __mptcp_clean_una(struct sock *sk)
 		dfrag->already_sent -= delta;
 
 		dfrag_uncharge(sk, delta);
-		cleaned = true;
 	}
 
 	/* all retransmitted data acked, recovery completed */
@@ -1052,9 +1030,6 @@ static void __mptcp_clean_una(struct sock *sk)
 		msk->recovery = false;
 
 out:
-	if (cleaned && tcp_under_memory_pressure(sk))
-		__mptcp_mem_reclaim_partial(sk);
-
 	if (snd_una == READ_ONCE(msk->snd_nxt) &&
 	    snd_una == READ_ONCE(msk->write_seq)) {
 		if (mptcp_timer_pending(sk) && !mptcp_data_fin_enabled(msk))
@@ -1206,12 +1181,6 @@ static struct sk_buff *mptcp_alloc_tx_skb(struct sock *sk, struct sock *ssk, boo
 {
 	gfp_t gfp = data_lock_held ? GFP_ATOMIC : sk->sk_allocation;
 
-	if (unlikely(tcp_under_memory_pressure(sk))) {
-		if (data_lock_held)
-			__mptcp_mem_reclaim_partial(sk);
-		else
-			mptcp_mem_reclaim_partial(sk);
-	}
 	return __mptcp_alloc_tx_skb(sk, ssk, gfp);
 }
 
-- 
2.37.0

