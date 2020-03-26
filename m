Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id F07BF194981
	for <lists+netdev@lfdr.de>; Thu, 26 Mar 2020 21:47:33 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727866AbgCZUra (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 26 Mar 2020 16:47:30 -0400
Received: from mga05.intel.com ([192.55.52.43]:47906 "EHLO mga05.intel.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1727711AbgCZUrC (ORCPT <rfc822;netdev@vger.kernel.org>);
        Thu, 26 Mar 2020 16:47:02 -0400
IronPort-SDR: xFvkfM/gimuu4Va/ebNhRTfwKALiA9j9N4pnNAvGiYyfpO+gY6LdpK2D9ecQYCVJ8jRcwYmyGr
 vAJfaSeOxwjg==
X-Amp-Result: SKIPPED(no attachment in message)
X-Amp-File-Uploaded: False
Received: from fmsmga007.fm.intel.com ([10.253.24.52])
  by fmsmga105.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 26 Mar 2020 13:47:00 -0700
IronPort-SDR: NIIeUa5NRD2gMiyrlWymv9fwO2RIxMUL1HmOsQtYmyB6/GEHuWA7w3c1xluw89h19PdtTcMZsO
 TH8JRgtdf7eQ==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="5.72,309,1580803200"; 
   d="scan'208";a="238911669"
Received: from mjmartin-nuc02.mjmartin-nuc02 (HELO mjmartin-nuc02.sea.intel.com) ([10.252.133.119])
  by fmsmga007.fm.intel.com with ESMTP; 26 Mar 2020 13:47:00 -0700
From:   Mat Martineau <mathew.j.martineau@linux.intel.com>
To:     netdev@vger.kernel.org
Cc:     Peter Krystad <peter.krystad@linux.intel.com>,
        eric.dumazet@gmail.com, Florian Westphal <fw@strlen.de>,
        Paolo Abeni <pabeni@redhat.com>,
        Mat Martineau <mathew.j.martineau@linux.intel.com>
Subject: [PATCH net-next v2 05/17] mptcp: Implement path manager interface commands
Date:   Thu, 26 Mar 2020 13:46:28 -0700
Message-Id: <20200326204640.67336-6-mathew.j.martineau@linux.intel.com>
X-Mailer: git-send-email 2.26.0
In-Reply-To: <20200326204640.67336-1-mathew.j.martineau@linux.intel.com>
References: <20200326204640.67336-1-mathew.j.martineau@linux.intel.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Peter Krystad <peter.krystad@linux.intel.com>

Fill in more path manager functionality by adding a worker function and
modifying the related stub functions to schedule the worker.

Co-developed-by: Florian Westphal <fw@strlen.de>
Signed-off-by: Florian Westphal <fw@strlen.de>
Co-developed-by: Paolo Abeni <pabeni@redhat.com>
Signed-off-by: Paolo Abeni <pabeni@redhat.com>
Signed-off-by: Peter Krystad <peter.krystad@linux.intel.com>
Signed-off-by: Mat Martineau <mathew.j.martineau@linux.intel.com>
---
 net/mptcp/pm.c       | 132 +++++++++++++++++++++++++++++++++++++++++--
 net/mptcp/protocol.c |   1 +
 net/mptcp/protocol.h |   1 +
 3 files changed, 129 insertions(+), 5 deletions(-)

diff --git a/net/mptcp/pm.c b/net/mptcp/pm.c
index ad837da0193d..3aedad58778c 100644
--- a/net/mptcp/pm.c
+++ b/net/mptcp/pm.c
@@ -15,7 +15,11 @@ static struct workqueue_struct *pm_wq;
 int mptcp_pm_announce_addr(struct mptcp_sock *msk,
 			   const struct mptcp_addr_info *addr)
 {
-	return -ENOTSUPP;
+	pr_debug("msk=%p, local_id=%d", msk, addr->id);
+
+	msk->pm.local = *addr;
+	WRITE_ONCE(msk->pm.addr_signal, true);
+	return 0;
 }
 
 int mptcp_pm_remove_addr(struct mptcp_sock *msk, u8 local_id)
@@ -41,13 +45,58 @@ void mptcp_pm_new_connection(struct mptcp_sock *msk, int server_side)
 
 bool mptcp_pm_allow_new_subflow(struct mptcp_sock *msk)
 {
-	pr_debug("msk=%p", msk);
-	return false;
+	struct mptcp_pm_data *pm = &msk->pm;
+	int ret;
+
+	pr_debug("msk=%p subflows=%d max=%d allow=%d", msk, pm->subflows,
+		 pm->subflows_max, READ_ONCE(pm->accept_subflow));
+
+	/* try to avoid acquiring the lock below */
+	if (!READ_ONCE(pm->accept_subflow))
+		return false;
+
+	spin_lock_bh(&pm->lock);
+	ret = pm->subflows < pm->subflows_max;
+	if (ret && ++pm->subflows == pm->subflows_max)
+		WRITE_ONCE(pm->accept_subflow, false);
+	spin_unlock_bh(&pm->lock);
+
+	return ret;
+}
+
+/* return true if the new status bit is currently cleared, that is, this event
+ * can be server, eventually by an already scheduled work
+ */
+static bool mptcp_pm_schedule_work(struct mptcp_sock *msk,
+				   enum mptcp_pm_status new_status)
+{
+	pr_debug("msk=%p status=%x new=%lx", msk, msk->pm.status,
+		 BIT(new_status));
+	if (msk->pm.status & BIT(new_status))
+		return false;
+
+	msk->pm.status |= BIT(new_status);
+	if (queue_work(pm_wq, &msk->pm.work))
+		sock_hold((struct sock *)msk);
+	return true;
 }
 
 void mptcp_pm_fully_established(struct mptcp_sock *msk)
 {
+	struct mptcp_pm_data *pm = &msk->pm;
+
 	pr_debug("msk=%p", msk);
+
+	/* try to avoid acquiring the lock below */
+	if (!READ_ONCE(pm->work_pending))
+		return;
+
+	spin_lock_bh(&pm->lock);
+
+	if (READ_ONCE(pm->work_pending))
+		mptcp_pm_schedule_work(msk, MPTCP_PM_ESTABLISHED);
+
+	spin_unlock_bh(&pm->lock);
 }
 
 void mptcp_pm_connection_closed(struct mptcp_sock *msk)
@@ -58,7 +107,19 @@ void mptcp_pm_connection_closed(struct mptcp_sock *msk)
 void mptcp_pm_subflow_established(struct mptcp_sock *msk,
 				  struct mptcp_subflow_context *subflow)
 {
+	struct mptcp_pm_data *pm = &msk->pm;
+
 	pr_debug("msk=%p", msk);
+
+	if (!READ_ONCE(pm->work_pending))
+		return;
+
+	spin_lock_bh(&pm->lock);
+
+	if (READ_ONCE(pm->work_pending))
+		mptcp_pm_schedule_work(msk, MPTCP_PM_SUBFLOW_ESTABLISHED);
+
+	spin_unlock_bh(&pm->lock);
 }
 
 void mptcp_pm_subflow_closed(struct mptcp_sock *msk, u8 id)
@@ -69,7 +130,23 @@ void mptcp_pm_subflow_closed(struct mptcp_sock *msk, u8 id)
 void mptcp_pm_add_addr_received(struct mptcp_sock *msk,
 				const struct mptcp_addr_info *addr)
 {
-	pr_debug("msk=%p, remote_id=%d", msk, addr->id);
+	struct mptcp_pm_data *pm = &msk->pm;
+
+	pr_debug("msk=%p remote_id=%d accept=%d", msk, addr->id,
+		 READ_ONCE(pm->accept_addr));
+
+	/* avoid acquiring the lock if there is no room for fouther addresses */
+	if (!READ_ONCE(pm->accept_addr))
+		return;
+
+	spin_lock_bh(&pm->lock);
+
+	/* be sure there is something to signal re-checking under PM lock */
+	if (READ_ONCE(pm->accept_addr) &&
+	    mptcp_pm_schedule_work(msk, MPTCP_PM_ADD_ADDR_RECEIVED))
+		pm->remote = *addr;
+
+	spin_unlock_bh(&pm->lock);
 }
 
 /* path manager helpers */
@@ -77,7 +154,24 @@ void mptcp_pm_add_addr_received(struct mptcp_sock *msk,
 bool mptcp_pm_addr_signal(struct mptcp_sock *msk, unsigned int remaining,
 			  struct mptcp_addr_info *saddr)
 {
-	return false;
+	int ret = false;
+
+	spin_lock_bh(&msk->pm.lock);
+
+	/* double check after the lock is acquired */
+	if (!mptcp_pm_should_signal(msk))
+		goto out_unlock;
+
+	if (remaining < mptcp_add_addr_len(msk->pm.local.family))
+		goto out_unlock;
+
+	*saddr = msk->pm.local;
+	WRITE_ONCE(msk->pm.addr_signal, false);
+	ret = true;
+
+out_unlock:
+	spin_unlock_bh(&msk->pm.lock);
+	return ret;
 }
 
 int mptcp_pm_get_local_id(struct mptcp_sock *msk, struct sock_common *skc)
@@ -87,6 +181,28 @@ int mptcp_pm_get_local_id(struct mptcp_sock *msk, struct sock_common *skc)
 
 static void pm_worker(struct work_struct *work)
 {
+	struct mptcp_pm_data *pm = container_of(work, struct mptcp_pm_data,
+						work);
+	struct mptcp_sock *msk = container_of(pm, struct mptcp_sock, pm);
+	struct sock *sk = (struct sock *)msk;
+
+	lock_sock(sk);
+	spin_lock_bh(&msk->pm.lock);
+
+	pr_debug("msk=%p status=%x", msk, pm->status);
+	if (pm->status & BIT(MPTCP_PM_ADD_ADDR_RECEIVED)) {
+		pm->status &= ~BIT(MPTCP_PM_ADD_ADDR_RECEIVED);
+	}
+	if (pm->status & BIT(MPTCP_PM_ESTABLISHED)) {
+		pm->status &= ~BIT(MPTCP_PM_ESTABLISHED);
+	}
+	if (pm->status & BIT(MPTCP_PM_SUBFLOW_ESTABLISHED)) {
+		pm->status &= ~BIT(MPTCP_PM_SUBFLOW_ESTABLISHED);
+	}
+
+	spin_unlock_bh(&msk->pm.lock);
+	release_sock(sk);
+	sock_put(sk);
 }
 
 void mptcp_pm_data_init(struct mptcp_sock *msk)
@@ -105,6 +221,12 @@ void mptcp_pm_data_init(struct mptcp_sock *msk)
 	INIT_WORK(&msk->pm.work, pm_worker);
 }
 
+void mptcp_pm_close(struct mptcp_sock *msk)
+{
+	if (cancel_work_sync(&msk->pm.work))
+		sock_put((struct sock *)msk);
+}
+
 void mptcp_pm_init(void)
 {
 	pm_wq = alloc_workqueue("pm_wq", WQ_UNBOUND | WQ_MEM_RECLAIM, 8);
diff --git a/net/mptcp/protocol.c b/net/mptcp/protocol.c
index 3d84e0b83c99..5c4560287bd2 100644
--- a/net/mptcp/protocol.c
+++ b/net/mptcp/protocol.c
@@ -833,6 +833,7 @@ static void mptcp_close(struct sock *sk, long timeout)
 	}
 
 	mptcp_cancel_work(sk);
+	mptcp_pm_close(msk);
 
 	__skb_queue_purge(&sk->sk_receive_queue);
 
diff --git a/net/mptcp/protocol.h b/net/mptcp/protocol.h
index df134ac91274..209bdaa43dda 100644
--- a/net/mptcp/protocol.h
+++ b/net/mptcp/protocol.h
@@ -330,6 +330,7 @@ void mptcp_crypto_hmac_sha(u64 key1, u64 key2, u8 *msg, int len, void *hmac);
 
 void mptcp_pm_init(void);
 void mptcp_pm_data_init(struct mptcp_sock *msk);
+void mptcp_pm_close(struct mptcp_sock *msk);
 void mptcp_pm_new_connection(struct mptcp_sock *msk, int server_side);
 void mptcp_pm_fully_established(struct mptcp_sock *msk);
 bool mptcp_pm_allow_new_subflow(struct mptcp_sock *msk);
-- 
2.26.0

