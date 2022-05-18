Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 8FAE652C5F8
	for <lists+netdev@lfdr.de>; Thu, 19 May 2022 00:07:17 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229781AbiERWGs (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 18 May 2022 18:06:48 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:37774 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229773AbiERWG2 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 18 May 2022 18:06:28 -0400
Received: from mga04.intel.com (mga04.intel.com [192.55.52.120])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 02BD91B1763
        for <netdev@vger.kernel.org>; Wed, 18 May 2022 15:04:52 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1652911492; x=1684447492;
  h=from:to:cc:subject:date:message-id:in-reply-to:
   references:mime-version:content-transfer-encoding;
  bh=GVWGQpvg+UyEHqjI+bX3d9iFhUdLescrDXVKmRlkUj0=;
  b=Ai8iQ4WapdLML7tu+QZlHRlhfcjNuSAPWrAHEQ1bC5HU2oC7Um61BMMI
   kQ/6jz1NeKfzss27g7PziAm0qI1jzrchQ/MOxF57k4SfUhl1b1Re3DT3X
   W1a+FlwUT0FmpJMtjfGEcldKoVPB9Wf936QLWeJ6gJJQK6nTbWmCIY//Z
   lz+w/IjsYjI/YCuB2z8gmlpATNCwdyVGBKJyw8UCoVrDRuHS6lKYnV29M
   S0G/5/2+pjDK8poV11bQtaNJndxEZe519p6UQ0B8pSDLv+KmMiWSqA+Mg
   ww4AKdhCw957B1EMMbo43lAVa5kpP0GQDmxqBqkQ8Ei0vqoYpcamr3wtj
   g==;
X-IronPort-AV: E=McAfee;i="6400,9594,10351"; a="270734207"
X-IronPort-AV: E=Sophos;i="5.91,235,1647327600"; 
   d="scan'208";a="270734207"
Received: from orsmga008.jf.intel.com ([10.7.209.65])
  by fmsmga104.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 18 May 2022 15:04:51 -0700
X-IronPort-AV: E=Sophos;i="5.91,235,1647327600"; 
   d="scan'208";a="598075438"
Received: from mjmartin-desk2.amr.corp.intel.com (HELO mjmartin-desk2.intel.com) ([10.209.36.18])
  by orsmga008-auth.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 18 May 2022 15:04:51 -0700
From:   Mat Martineau <mathew.j.martineau@linux.intel.com>
To:     netdev@vger.kernel.org
Cc:     Mat Martineau <mathew.j.martineau@linux.intel.com>,
        davem@davemloft.net, kuba@kernel.org, pabeni@redhat.com,
        edumazet@google.com, matthieu.baerts@tessares.net,
        mptcp@lists.linux.dev
Subject: [PATCH net-next 2/4] mptcp: Check for orphaned subflow before handling MP_FAIL timer
Date:   Wed, 18 May 2022 15:04:44 -0700
Message-Id: <20220518220446.209750-3-mathew.j.martineau@linux.intel.com>
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

MP_FAIL timeout (waiting for a peer to respond to an MP_FAIL with
another MP_FAIL) is implemented using the MPTCP socket's sk_timer. That
timer is also used at MPTCP socket close, so it's important to not have
the two timer users interfere with each other.

At MPTCP socket close, all subflows are orphaned before sk_timer is
manipulated. By checking the SOCK_DEAD flag on the subflows, each
subflow can determine if the timer is safe to alter without acquiring
any MPTCP-level lock. This replaces code that was using the
mptcp_data_lock and MPTCP-level socket state checks that did not
correctly protect the timer.

Fixes: 49fa1919d6bc ("mptcp: reset subflow when MP_FAIL doesn't respond")
Reviewed-by: Paolo Abeni <pabeni@redhat.com>
Signed-off-by: Mat Martineau <mathew.j.martineau@linux.intel.com>
---
 net/mptcp/pm.c      |  7 ++-----
 net/mptcp/subflow.c | 12 ++++--------
 2 files changed, 6 insertions(+), 13 deletions(-)

diff --git a/net/mptcp/pm.c b/net/mptcp/pm.c
index a3f9bf8e8912..e4ce2bdd2b07 100644
--- a/net/mptcp/pm.c
+++ b/net/mptcp/pm.c
@@ -313,13 +313,10 @@ void mptcp_pm_mp_fail_received(struct sock *sk, u64 fail_seq)
 		subflow->send_mp_fail = 1;
 		MPTCP_INC_STATS(sock_net(sk), MPTCP_MIB_MPFAILTX);
 		subflow->send_infinite_map = 1;
-	} else if (s && inet_sk_state_load(s) != TCP_CLOSE) {
+	} else if (!sock_flag(sk, SOCK_DEAD)) {
 		pr_debug("MP_FAIL response received");
 
-		mptcp_data_lock(s);
-		if (inet_sk_state_load(s) != TCP_CLOSE)
-			sk_stop_timer(s, &s->sk_timer);
-		mptcp_data_unlock(s);
+		sk_stop_timer(s, &s->sk_timer);
 	}
 }
 
diff --git a/net/mptcp/subflow.c b/net/mptcp/subflow.c
index 1e07b4d7ee7b..cb6e54fd401e 100644
--- a/net/mptcp/subflow.c
+++ b/net/mptcp/subflow.c
@@ -1013,12 +1013,9 @@ static enum mapping_status get_mapping_status(struct sock *ssk,
 		pr_debug("infinite mapping received");
 		MPTCP_INC_STATS(sock_net(ssk), MPTCP_MIB_INFINITEMAPRX);
 		subflow->map_data_len = 0;
-		if (sk && inet_sk_state_load(sk) != TCP_CLOSE) {
-			mptcp_data_lock(sk);
-			if (inet_sk_state_load(sk) != TCP_CLOSE)
-				sk_stop_timer(sk, &sk->sk_timer);
-			mptcp_data_unlock(sk);
-		}
+		if (!sock_flag(ssk, SOCK_DEAD))
+			sk_stop_timer(sk, &sk->sk_timer);
+
 		return MAPPING_INVALID;
 	}
 
@@ -1226,9 +1223,8 @@ static bool subflow_check_data_avail(struct sock *ssk)
 				tcp_send_active_reset(ssk, GFP_ATOMIC);
 				while ((skb = skb_peek(&ssk->sk_receive_queue)))
 					sk_eat_skb(ssk, skb);
-			} else {
+			} else if (!sock_flag(ssk, SOCK_DEAD)) {
 				WRITE_ONCE(subflow->mp_fail_response_expect, true);
-				/* The data lock is acquired in __mptcp_move_skbs() */
 				sk_reset_timer((struct sock *)msk,
 					       &((struct sock *)msk)->sk_timer,
 					       jiffies + TCP_RTO_MAX);
-- 
2.36.1

