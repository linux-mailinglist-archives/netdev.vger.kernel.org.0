Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 20B832A1114
	for <lists+netdev@lfdr.de>; Fri, 30 Oct 2020 23:45:22 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726128AbgJ3WpT (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 30 Oct 2020 18:45:19 -0400
Received: from mga11.intel.com ([192.55.52.93]:45959 "EHLO mga11.intel.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726070AbgJ3WpO (ORCPT <rfc822;netdev@vger.kernel.org>);
        Fri, 30 Oct 2020 18:45:14 -0400
IronPort-SDR: t7++ucT/0yKaeS7djikc8NyjwZ0nEGCFcgfma6JESe5ePqk4MO55NgNcUQZk11gTCd+AatI2pE
 9E00P46icliQ==
X-IronPort-AV: E=McAfee;i="6000,8403,9790"; a="165177399"
X-IronPort-AV: E=Sophos;i="5.77,434,1596524400"; 
   d="scan'208";a="165177399"
X-Amp-Result: SKIPPED(no attachment in message)
X-Amp-File-Uploaded: False
Received: from fmsmga003.fm.intel.com ([10.253.24.29])
  by fmsmga102.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 30 Oct 2020 15:45:14 -0700
IronPort-SDR: wg9DkpDG9ivpmchvRsyJUjaM74V/ucGlRGNQTAIddg8qZE2OXoLenfDnys1fV8J0/s4s+RglSi
 ykBosuvmMTYA==
X-IronPort-AV: E=Sophos;i="5.77,434,1596524400"; 
   d="scan'208";a="361983940"
Received: from mjmartin-nuc02.amr.corp.intel.com ([10.254.102.227])
  by fmsmga003-auth.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 30 Oct 2020 15:45:13 -0700
From:   Mat Martineau <mathew.j.martineau@linux.intel.com>
To:     netdev@vger.kernel.org
Cc:     Florian Westphal <fw@strlen.de>, mptcp@lists.01.org,
        kuba@kernel.org, davem@davemloft.net,
        Mat Martineau <mathew.j.martineau@linux.intel.com>
Subject: [PATCH net-next 4/6] mptcp: split mptcp_clean_una function
Date:   Fri, 30 Oct 2020 15:45:04 -0700
Message-Id: <20201030224506.108377-5-mathew.j.martineau@linux.intel.com>
X-Mailer: git-send-email 2.29.2
In-Reply-To: <20201030224506.108377-1-mathew.j.martineau@linux.intel.com>
References: <20201030224506.108377-1-mathew.j.martineau@linux.intel.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Florian Westphal <fw@strlen.de>

mptcp_clean_una() will wake writers in case memory could be reclaimed.
When called from mptcp_sendmsg the wakeup code isn't needed.

Move the wakeup to a new helper and then use that from the mptcp worker.

Reviewed-by: Mat Martineau <mathew.j.martineau@linux.intel.com>
Signed-off-by: Florian Westphal <fw@strlen.de>
---
 net/mptcp/protocol.c | 28 +++++++++++++++++-----------
 1 file changed, 17 insertions(+), 11 deletions(-)

diff --git a/net/mptcp/protocol.c b/net/mptcp/protocol.c
index 25d12183d1ca..b84b84adc9ad 100644
--- a/net/mptcp/protocol.c
+++ b/net/mptcp/protocol.c
@@ -853,19 +853,25 @@ static void mptcp_clean_una(struct sock *sk)
 	}
 
 out:
-	if (cleaned) {
+	if (cleaned)
 		sk_mem_reclaim_partial(sk);
+}
 
-		/* Only wake up writers if a subflow is ready */
-		if (mptcp_is_writeable(msk)) {
-			set_bit(MPTCP_SEND_SPACE, &mptcp_sk(sk)->flags);
-			smp_mb__after_atomic();
+static void mptcp_clean_una_wakeup(struct sock *sk)
+{
+	struct mptcp_sock *msk = mptcp_sk(sk);
 
-			/* set SEND_SPACE before sk_stream_write_space clears
-			 * NOSPACE
-			 */
-			sk_stream_write_space(sk);
-		}
+	mptcp_clean_una(sk);
+
+	/* Only wake up writers if a subflow is ready */
+	if (mptcp_is_writeable(msk)) {
+		set_bit(MPTCP_SEND_SPACE, &msk->flags);
+		smp_mb__after_atomic();
+
+		/* set SEND_SPACE before sk_stream_write_space clears
+		 * NOSPACE
+		 */
+		sk_stream_write_space(sk);
 	}
 }
 
@@ -1769,7 +1775,7 @@ static void mptcp_worker(struct work_struct *work)
 	long timeo = 0;
 
 	lock_sock(sk);
-	mptcp_clean_una(sk);
+	mptcp_clean_una_wakeup(sk);
 	mptcp_check_data_fin_ack(sk);
 	__mptcp_flush_join_list(msk);
 	if (test_and_clear_bit(MPTCP_WORK_CLOSE_SUBFLOW, &msk->flags))
-- 
2.29.2

