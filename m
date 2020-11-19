Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 8AD002B9BAA
	for <lists+netdev@lfdr.de>; Thu, 19 Nov 2020 20:49:56 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727778AbgKSTqK (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 19 Nov 2020 14:46:10 -0500
Received: from mga04.intel.com ([192.55.52.120]:13142 "EHLO mga04.intel.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1727151AbgKSTqJ (ORCPT <rfc822;netdev@vger.kernel.org>);
        Thu, 19 Nov 2020 14:46:09 -0500
IronPort-SDR: yiuCZIvFcbIQmX9vVBqdoyJXVSyEsBVJ0Usk92RQN7fhcVlVDUKRN5A7d+08p2/UQUgkP1cGqv
 /BuSVdJi1aHw==
X-IronPort-AV: E=McAfee;i="6000,8403,9810"; a="168780890"
X-IronPort-AV: E=Sophos;i="5.78,354,1599548400"; 
   d="scan'208";a="168780890"
X-Amp-Result: SKIPPED(no attachment in message)
X-Amp-File-Uploaded: False
Received: from orsmga004.jf.intel.com ([10.7.209.38])
  by fmsmga104.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 19 Nov 2020 11:46:09 -0800
IronPort-SDR: s0Yi0Ox1OzClBoqXSc93CBzYUnwz+0pCpPaJMUVTT7R+RNB2zmStOewcO9wWkffQWVpHLJgZ+g
 lydTXfeU15gA==
X-IronPort-AV: E=Sophos;i="5.78,354,1599548400"; 
   d="scan'208";a="476940474"
Received: from mjmartin-nuc02.amr.corp.intel.com ([10.255.229.232])
  by orsmga004-auth.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 19 Nov 2020 11:46:08 -0800
From:   Mat Martineau <mathew.j.martineau@linux.intel.com>
To:     netdev@vger.kernel.org
Cc:     Paolo Abeni <pabeni@redhat.com>, kuba@kernel.org,
        mptcp@lists.01.org, Matthieu Baerts <matthieu.baerts@tessares.net>,
        Mat Martineau <mathew.j.martineau@linux.intel.com>
Subject: [PATCH net-next 01/10] mptcp: drop WORKER_RUNNING status bit
Date:   Thu, 19 Nov 2020 11:45:54 -0800
Message-Id: <20201119194603.103158-2-mathew.j.martineau@linux.intel.com>
X-Mailer: git-send-email 2.29.2
In-Reply-To: <20201119194603.103158-1-mathew.j.martineau@linux.intel.com>
References: <20201119194603.103158-1-mathew.j.martineau@linux.intel.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Paolo Abeni <pabeni@redhat.com>

Only mptcp_close() can actually cancel the workqueue,
no need to add and use this flag.

Reviewed-by: Matthieu Baerts <matthieu.baerts@tessares.net>
Signed-off-by: Paolo Abeni <pabeni@redhat.com>
Signed-off-by: Mat Martineau <mathew.j.martineau@linux.intel.com>
---
 net/mptcp/protocol.c | 8 +-------
 net/mptcp/protocol.h | 1 -
 2 files changed, 1 insertion(+), 8 deletions(-)

diff --git a/net/mptcp/protocol.c b/net/mptcp/protocol.c
index 8df013daea88..749c00fffff5 100644
--- a/net/mptcp/protocol.c
+++ b/net/mptcp/protocol.c
@@ -1861,7 +1861,6 @@ static void mptcp_worker(struct work_struct *work)
 	int state, ret;
 
 	lock_sock(sk);
-	set_bit(MPTCP_WORKER_RUNNING, &msk->flags);
 	state = sk->sk_state;
 	if (unlikely(state == TCP_CLOSE))
 		goto unlock;
@@ -1939,7 +1938,6 @@ static void mptcp_worker(struct work_struct *work)
 		mptcp_reset_timer(sk);
 
 unlock:
-	clear_bit(MPTCP_WORKER_RUNNING, &msk->flags);
 	release_sock(sk);
 	sock_put(sk);
 }
@@ -2010,11 +2008,7 @@ static void mptcp_cancel_work(struct sock *sk)
 {
 	struct mptcp_sock *msk = mptcp_sk(sk);
 
-	/* if called by the work itself, do not try to cancel the work, or
-	 * we will hang.
-	 */
-	if (!test_bit(MPTCP_WORKER_RUNNING, &msk->flags) &&
-	    cancel_work_sync(&msk->work))
+	if (cancel_work_sync(&msk->work))
 		__sock_put(sk);
 }
 
diff --git a/net/mptcp/protocol.h b/net/mptcp/protocol.h
index b4c8dbe9236b..10fffc5de9e4 100644
--- a/net/mptcp/protocol.h
+++ b/net/mptcp/protocol.h
@@ -91,7 +91,6 @@
 #define MPTCP_WORK_EOF		3
 #define MPTCP_FALLBACK_DONE	4
 #define MPTCP_WORK_CLOSE_SUBFLOW 5
-#define MPTCP_WORKER_RUNNING	6
 
 static inline bool before64(__u64 seq1, __u64 seq2)
 {
-- 
2.29.2

