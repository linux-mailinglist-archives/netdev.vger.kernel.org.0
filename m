Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id C0EA4216CFE
	for <lists+netdev@lfdr.de>; Tue,  7 Jul 2020 14:41:05 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727107AbgGGMk4 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 7 Jul 2020 08:40:56 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:35502 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1725944AbgGGMk4 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 7 Jul 2020 08:40:56 -0400
Received: from Chamillionaire.breakpoint.cc (Chamillionaire.breakpoint.cc [IPv6:2a0a:51c0:0:12e:520::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 4637FC061755
        for <netdev@vger.kernel.org>; Tue,  7 Jul 2020 05:40:56 -0700 (PDT)
Received: from fw by Chamillionaire.breakpoint.cc with local (Exim 4.92)
        (envelope-from <fw@breakpoint.cc>)
        id 1jsmu6-0007rh-Uk; Tue, 07 Jul 2020 14:40:54 +0200
From:   Florian Westphal <fw@strlen.de>
To:     <netdev@vger.kernel.org>
Cc:     Florian Westphal <fw@strlen.de>
Subject: [PATCH net-next] mptcp: use mptcp worker for path management
Date:   Tue,  7 Jul 2020 14:40:48 +0200
Message-Id: <20200707124048.2403-1-fw@strlen.de>
X-Mailer: git-send-email 2.26.2
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

We can re-use the existing work queue to handle path management
instead of a dedicated work queue.  Just move pm_worker to protocol.c,
call it from the mptcp worker and get rid of the msk lock (already held).

Signed-off-by: Florian Westphal <fw@strlen.de>
---
 net/mptcp/pm.c       | 44 +-------------------------------------------
 net/mptcp/protocol.c | 27 ++++++++++++++++++++++++++-
 net/mptcp/protocol.h |  3 ---
 3 files changed, 27 insertions(+), 47 deletions(-)

diff --git a/net/mptcp/pm.c b/net/mptcp/pm.c
index 7de09fdd42a3..a8ad20559aaa 100644
--- a/net/mptcp/pm.c
+++ b/net/mptcp/pm.c
@@ -10,8 +10,6 @@
 #include <net/mptcp.h>
 #include "protocol.h"
 
-static struct workqueue_struct *pm_wq;
-
 /* path manager command handlers */
 
 int mptcp_pm_announce_addr(struct mptcp_sock *msk,
@@ -78,7 +76,7 @@ static bool mptcp_pm_schedule_work(struct mptcp_sock *msk,
 		return false;
 
 	msk->pm.status |= BIT(new_status);
-	if (queue_work(pm_wq, &msk->pm.work))
+	if (schedule_work(&msk->work))
 		sock_hold((struct sock *)msk);
 	return true;
 }
@@ -181,35 +179,6 @@ int mptcp_pm_get_local_id(struct mptcp_sock *msk, struct sock_common *skc)
 	return mptcp_pm_nl_get_local_id(msk, skc);
 }
 
-static void pm_worker(struct work_struct *work)
-{
-	struct mptcp_pm_data *pm = container_of(work, struct mptcp_pm_data,
-						work);
-	struct mptcp_sock *msk = container_of(pm, struct mptcp_sock, pm);
-	struct sock *sk = (struct sock *)msk;
-
-	lock_sock(sk);
-	spin_lock_bh(&msk->pm.lock);
-
-	pr_debug("msk=%p status=%x", msk, pm->status);
-	if (pm->status & BIT(MPTCP_PM_ADD_ADDR_RECEIVED)) {
-		pm->status &= ~BIT(MPTCP_PM_ADD_ADDR_RECEIVED);
-		mptcp_pm_nl_add_addr_received(msk);
-	}
-	if (pm->status & BIT(MPTCP_PM_ESTABLISHED)) {
-		pm->status &= ~BIT(MPTCP_PM_ESTABLISHED);
-		mptcp_pm_nl_fully_established(msk);
-	}
-	if (pm->status & BIT(MPTCP_PM_SUBFLOW_ESTABLISHED)) {
-		pm->status &= ~BIT(MPTCP_PM_SUBFLOW_ESTABLISHED);
-		mptcp_pm_nl_subflow_established(msk);
-	}
-
-	spin_unlock_bh(&msk->pm.lock);
-	release_sock(sk);
-	sock_put(sk);
-}
-
 void mptcp_pm_data_init(struct mptcp_sock *msk)
 {
 	msk->pm.add_addr_signaled = 0;
@@ -223,22 +192,11 @@ void mptcp_pm_data_init(struct mptcp_sock *msk)
 	msk->pm.status = 0;
 
 	spin_lock_init(&msk->pm.lock);
-	INIT_WORK(&msk->pm.work, pm_worker);
 
 	mptcp_pm_nl_data_init(msk);
 }
 
-void mptcp_pm_close(struct mptcp_sock *msk)
-{
-	if (cancel_work_sync(&msk->pm.work))
-		sock_put((struct sock *)msk);
-}
-
 void __init mptcp_pm_init(void)
 {
-	pm_wq = alloc_workqueue("pm_wq", WQ_UNBOUND | WQ_MEM_RECLAIM, 8);
-	if (!pm_wq)
-		panic("Failed to allocate workqueue");
-
 	mptcp_pm_nl_init();
 }
diff --git a/net/mptcp/protocol.c b/net/mptcp/protocol.c
index 3ab060e30038..dbe43e0cd734 100644
--- a/net/mptcp/protocol.c
+++ b/net/mptcp/protocol.c
@@ -1214,6 +1214,29 @@ static unsigned int mptcp_sync_mss(struct sock *sk, u32 pmtu)
 	return 0;
 }
 
+static void pm_work(struct mptcp_sock *msk)
+{
+	struct mptcp_pm_data *pm = &msk->pm;
+
+	spin_lock_bh(&msk->pm.lock);
+
+	pr_debug("msk=%p status=%x", msk, pm->status);
+	if (pm->status & BIT(MPTCP_PM_ADD_ADDR_RECEIVED)) {
+		pm->status &= ~BIT(MPTCP_PM_ADD_ADDR_RECEIVED);
+		mptcp_pm_nl_add_addr_received(msk);
+	}
+	if (pm->status & BIT(MPTCP_PM_ESTABLISHED)) {
+		pm->status &= ~BIT(MPTCP_PM_ESTABLISHED);
+		mptcp_pm_nl_fully_established(msk);
+	}
+	if (pm->status & BIT(MPTCP_PM_SUBFLOW_ESTABLISHED)) {
+		pm->status &= ~BIT(MPTCP_PM_SUBFLOW_ESTABLISHED);
+		mptcp_pm_nl_subflow_established(msk);
+	}
+
+	spin_unlock_bh(&msk->pm.lock);
+}
+
 static void mptcp_worker(struct work_struct *work)
 {
 	struct mptcp_sock *msk = container_of(work, struct mptcp_sock, work);
@@ -1230,6 +1253,9 @@ static void mptcp_worker(struct work_struct *work)
 	__mptcp_flush_join_list(msk);
 	__mptcp_move_skbs(msk);
 
+	if (msk->pm.status)
+		pm_work(msk);
+
 	if (test_and_clear_bit(MPTCP_WORK_EOF, &msk->flags))
 		mptcp_check_for_eof(msk);
 
@@ -1420,7 +1446,6 @@ static void mptcp_close(struct sock *sk, long timeout)
 	}
 
 	mptcp_cancel_work(sk);
-	mptcp_pm_close(msk);
 
 	__skb_queue_purge(&sk->sk_receive_queue);
 
diff --git a/net/mptcp/protocol.h b/net/mptcp/protocol.h
index a6412ff0fddb..39bfec3f1586 100644
--- a/net/mptcp/protocol.h
+++ b/net/mptcp/protocol.h
@@ -174,8 +174,6 @@ struct mptcp_pm_data {
 	u8		local_addr_max;
 	u8		subflows_max;
 	u8		status;
-
-	struct		work_struct work;
 };
 
 struct mptcp_data_frag {
@@ -412,7 +410,6 @@ void mptcp_crypto_hmac_sha(u64 key1, u64 key2, u8 *msg, int len, void *hmac);
 
 void __init mptcp_pm_init(void);
 void mptcp_pm_data_init(struct mptcp_sock *msk);
-void mptcp_pm_close(struct mptcp_sock *msk);
 void mptcp_pm_new_connection(struct mptcp_sock *msk, int server_side);
 void mptcp_pm_fully_established(struct mptcp_sock *msk);
 bool mptcp_pm_allow_new_subflow(struct mptcp_sock *msk);
-- 
2.26.2

