Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 51E92496E73
	for <lists+netdev@lfdr.de>; Sun, 23 Jan 2022 01:12:20 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S235270AbiAWAME (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sat, 22 Jan 2022 19:12:04 -0500
Received: from dfw.source.kernel.org ([139.178.84.217]:36148 "EHLO
        dfw.source.kernel.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S235218AbiAWALw (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sat, 22 Jan 2022 19:11:52 -0500
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 0C74760F7E;
        Sun, 23 Jan 2022 00:11:52 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 7A0ADC36AE3;
        Sun, 23 Jan 2022 00:11:50 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1642896711;
        bh=7UAPTkV0urGhLDTQJG9m11asbKxY0EICkzPqPow8mXE=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=SaVOJJIuwWY8Z+nTIpJScnRK8oNzU0Cb14aOPtE7/GgZdSrViPaIaUZcgW3W9Xbu5
         JitHrlqcN7uwSjEW6YaF9pHVzPLZbvoguna93HTE5FD7Kl5s/zq9RZRjfqszIuut2x
         9yH8XVwaSUPW/XmQ+84XVWfA6RUiCCtbe0quTTOAMFEyaby/UbFRQfzxW3HqHBPDbi
         e7ckT+jget+koO+9yo/wDCpOHHh/gJgQx+BwcOsB0QLdwzYzKz+vmhHh1h75ITbxSa
         R7fLPii0OUZo1xgDKSmAX8FX9yrcnV5e3fSkugW5Y54uufo2ZXcx43OlYjHrAv72cB
         0DP5tKvmwEubQ==
From:   Sasha Levin <sashal@kernel.org>
To:     linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc:     Wen Gu <guwen@linux.alibaba.com>,
        "David S . Miller" <davem@davemloft.net>,
        Sasha Levin <sashal@kernel.org>, kgraul@linux.ibm.com,
        kuba@kernel.org, linux-s390@vger.kernel.org, netdev@vger.kernel.org
Subject: [PATCH AUTOSEL 5.16 09/19] net/smc: Resolve the race between link group access and termination
Date:   Sat, 22 Jan 2022 19:11:02 -0500
Message-Id: <20220123001113.2460140-9-sashal@kernel.org>
X-Mailer: git-send-email 2.34.1
In-Reply-To: <20220123001113.2460140-1-sashal@kernel.org>
References: <20220123001113.2460140-1-sashal@kernel.org>
MIME-Version: 1.0
X-stable: review
X-Patchwork-Hint: Ignore
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Wen Gu <guwen@linux.alibaba.com>

[ Upstream commit 61f434b0280ed65495831f1b6e1a5c21a90f47c6 ]

We encountered some crashes caused by the race between the access
and the termination of link groups.

Here are some of panic stacks we met:

1) Race between smc_clc_wait_msg() and __smc_lgr_terminate()

 BUG: kernel NULL pointer dereference, address: 00000000000002f0
 Workqueue: smc_hs_wq smc_listen_work [smc]
 RIP: 0010:smc_clc_wait_msg+0x3eb/0x5c0 [smc]
 Call Trace:
  <TASK>
  ? smc_clc_send_accept+0x45/0xa0 [smc]
  ? smc_clc_send_accept+0x45/0xa0 [smc]
  smc_listen_work+0x783/0x1220 [smc]
  ? finish_task_switch+0xc4/0x2e0
  ? process_one_work+0x1ad/0x3c0
  process_one_work+0x1ad/0x3c0
  worker_thread+0x4c/0x390
  ? rescuer_thread+0x320/0x320
  kthread+0x149/0x190
  ? set_kthread_struct+0x40/0x40
  ret_from_fork+0x1f/0x30
  </TASK>

smc_listen_work()                abnormal case like port error
---------------------------------------------------------------
                                | __smc_lgr_terminate()
                                |  |- smc_conn_kill()
                                |      |- smc_lgr_unregister_conn()
                                |          |- set conn->lgr = NULL
smc_clc_wait_msg()              |
 |- access conn->lgr (panic)    |

2) Race between smc_setsockopt() and __smc_lgr_terminate()

 BUG: kernel NULL pointer dereference, address: 00000000000002e8
 RIP: 0010:smc_setsockopt+0x17a/0x280 [smc]
 Call Trace:
  <TASK>
  __sys_setsockopt+0xfc/0x190
  __x64_sys_setsockopt+0x20/0x30
  do_syscall_64+0x34/0x90
  entry_SYSCALL_64_after_hwframe+0x44/0xae
  </TASK>

smc_setsockopt()                 abnormal case like port error
--------------------------------------------------------------
                                | __smc_lgr_terminate()
                                |  |- smc_conn_kill()
                                |      |- smc_lgr_unregister_conn()
                                |          |- set conn->lgr = NULL
mod_delayed_work()              |
 |- access conn->lgr (panic)    |

There are some other panic places and they are caused by the
similar reason as described above, which is accessing link
group after termination, thus getting a NULL pointer or invalid
resource.

Currently, there seems to be no synchronization between the
link group access and a sudden termination of it. This patch
tries to fix this by introducing reference count of link group
and not freeing link group until reference count is zero.

Link group might be referred to by links or smc connections. So
the operation to the link group reference count can be concluded
as follows:

object          [hold or initialized as 1]       [put]
-------------------------------------------------------------------
link group      smc_lgr_create()                 smc_lgr_free()
connections     smc_conn_create()                smc_conn_free()
links           smcr_link_init()                 smcr_link_clear()

Througth this way, we extend the life cycle of link group and
ensure it is longer than the life cycle of connections and links
above it, so that avoid invalid access to link group after its
termination.

Signed-off-by: Wen Gu <guwen@linux.alibaba.com>
Signed-off-by: David S. Miller <davem@davemloft.net>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 net/smc/smc.h      |  1 +
 net/smc/smc_core.c | 60 +++++++++++++++++++++++++++++++++++++---------
 net/smc/smc_core.h |  3 +++
 3 files changed, 53 insertions(+), 11 deletions(-)

diff --git a/net/smc/smc.h b/net/smc/smc.h
index 1a4fc1c6c4ab6..3d0b8e300deb3 100644
--- a/net/smc/smc.h
+++ b/net/smc/smc.h
@@ -221,6 +221,7 @@ struct smc_connection {
 						 */
 	u64			peer_token;	/* SMC-D token of peer */
 	u8			killed : 1;	/* abnormal termination */
+	u8			freed : 1;	/* normal termiation */
 	u8			out_of_sync : 1; /* out of sync with peer */
 };
 
diff --git a/net/smc/smc_core.c b/net/smc/smc_core.c
index a6849362f4ddd..84b89d13c3359 100644
--- a/net/smc/smc_core.c
+++ b/net/smc/smc_core.c
@@ -216,7 +216,6 @@ static void smc_lgr_unregister_conn(struct smc_connection *conn)
 		__smc_lgr_unregister_conn(conn);
 	}
 	write_unlock_bh(&lgr->conns_lock);
-	conn->lgr = NULL;
 }
 
 int smc_nl_get_sys_info(struct sk_buff *skb, struct netlink_callback *cb)
@@ -749,6 +748,7 @@ int smcr_link_init(struct smc_link_group *lgr, struct smc_link *lnk,
 	lnk->path_mtu = lnk->smcibdev->pattr[lnk->ibport - 1].active_mtu;
 	lnk->link_id = smcr_next_link_id(lgr);
 	lnk->lgr = lgr;
+	smc_lgr_hold(lgr); /* lgr_put in smcr_link_clear() */
 	lnk->link_idx = link_idx;
 	smc_ibdev_cnt_inc(lnk);
 	smcr_copy_dev_info_to_link(lnk);
@@ -803,6 +803,7 @@ int smcr_link_init(struct smc_link_group *lgr, struct smc_link *lnk,
 	lnk->state = SMC_LNK_UNUSED;
 	if (!atomic_dec_return(&smcibdev->lnk_cnt))
 		wake_up(&smcibdev->lnks_deleted);
+	smc_lgr_put(lgr); /* lgr_hold above */
 	return rc;
 }
 
@@ -841,6 +842,7 @@ static int smc_lgr_create(struct smc_sock *smc, struct smc_init_info *ini)
 	lgr->terminating = 0;
 	lgr->freeing = 0;
 	lgr->vlan_id = ini->vlan_id;
+	refcount_set(&lgr->refcnt, 1); /* set lgr refcnt to 1 */
 	mutex_init(&lgr->sndbufs_lock);
 	mutex_init(&lgr->rmbs_lock);
 	rwlock_init(&lgr->conns_lock);
@@ -1120,8 +1122,19 @@ void smc_conn_free(struct smc_connection *conn)
 {
 	struct smc_link_group *lgr = conn->lgr;
 
-	if (!lgr)
+	if (!lgr || conn->freed)
+		/* Connection has never been registered in a
+		 * link group, or has already been freed.
+		 */
 		return;
+
+	conn->freed = 1;
+	if (!conn->alert_token_local)
+		/* Connection has already unregistered from
+		 * link group.
+		 */
+		goto lgr_put;
+
 	if (lgr->is_smcd) {
 		if (!list_empty(&lgr->list))
 			smc_ism_unset_conn(conn);
@@ -1138,6 +1151,8 @@ void smc_conn_free(struct smc_connection *conn)
 
 	if (!lgr->conns_num)
 		smc_lgr_schedule_free_work(lgr);
+lgr_put:
+	smc_lgr_put(lgr); /* lgr_hold in smc_conn_create() */
 }
 
 /* unregister a link from a buf_desc */
@@ -1196,9 +1211,10 @@ static void smcr_rtoken_clear_link(struct smc_link *lnk)
 /* must be called under lgr->llc_conf_mutex lock */
 void smcr_link_clear(struct smc_link *lnk, bool log)
 {
+	struct smc_link_group *lgr = lnk->lgr;
 	struct smc_ib_device *smcibdev;
 
-	if (!lnk->lgr || lnk->state == SMC_LNK_UNUSED)
+	if (!lgr || lnk->state == SMC_LNK_UNUSED)
 		return;
 	lnk->peer_qpn = 0;
 	smc_llc_link_clear(lnk, log);
@@ -1216,6 +1232,7 @@ void smcr_link_clear(struct smc_link *lnk, bool log)
 	lnk->state = SMC_LNK_UNUSED;
 	if (!atomic_dec_return(&smcibdev->lnk_cnt))
 		wake_up(&smcibdev->lnks_deleted);
+	smc_lgr_put(lgr); /* lgr_hold in smcr_link_init() */
 }
 
 static void smcr_buf_free(struct smc_link_group *lgr, bool is_rmb,
@@ -1280,6 +1297,21 @@ static void smc_lgr_free_bufs(struct smc_link_group *lgr)
 	__smc_lgr_free_bufs(lgr, true);
 }
 
+/* won't be freed until no one accesses to lgr anymore */
+static void __smc_lgr_free(struct smc_link_group *lgr)
+{
+	smc_lgr_free_bufs(lgr);
+	if (lgr->is_smcd) {
+		if (!atomic_dec_return(&lgr->smcd->lgr_cnt))
+			wake_up(&lgr->smcd->lgrs_deleted);
+	} else {
+		smc_wr_free_lgr_mem(lgr);
+		if (!atomic_dec_return(&lgr_cnt))
+			wake_up(&lgrs_deleted);
+	}
+	kfree(lgr);
+}
+
 /* remove a link group */
 static void smc_lgr_free(struct smc_link_group *lgr)
 {
@@ -1295,19 +1327,23 @@ static void smc_lgr_free(struct smc_link_group *lgr)
 		smc_llc_lgr_clear(lgr);
 	}
 
-	smc_lgr_free_bufs(lgr);
 	destroy_workqueue(lgr->tx_wq);
 	if (lgr->is_smcd) {
 		smc_ism_put_vlan(lgr->smcd, lgr->vlan_id);
 		put_device(&lgr->smcd->dev);
-		if (!atomic_dec_return(&lgr->smcd->lgr_cnt))
-			wake_up(&lgr->smcd->lgrs_deleted);
-	} else {
-		smc_wr_free_lgr_mem(lgr);
-		if (!atomic_dec_return(&lgr_cnt))
-			wake_up(&lgrs_deleted);
 	}
-	kfree(lgr);
+	smc_lgr_put(lgr); /* theoretically last lgr_put */
+}
+
+void smc_lgr_hold(struct smc_link_group *lgr)
+{
+	refcount_inc(&lgr->refcnt);
+}
+
+void smc_lgr_put(struct smc_link_group *lgr)
+{
+	if (refcount_dec_and_test(&lgr->refcnt))
+		__smc_lgr_free(lgr);
 }
 
 static void smc_sk_wake_ups(struct smc_sock *smc)
@@ -1835,6 +1871,8 @@ int smc_conn_create(struct smc_sock *smc, struct smc_init_info *ini)
 		if (rc)
 			goto out;
 	}
+	smc_lgr_hold(conn->lgr); /* lgr_put in smc_conn_free() */
+	conn->freed = 0;
 	conn->local_tx_ctrl.common.type = SMC_CDC_MSG_TYPE;
 	conn->local_tx_ctrl.len = SMC_WR_TX_SIZE;
 	conn->urg_state = SMC_URG_READ;
diff --git a/net/smc/smc_core.h b/net/smc/smc_core.h
index d63b08274197e..51203b16307be 100644
--- a/net/smc/smc_core.h
+++ b/net/smc/smc_core.h
@@ -249,6 +249,7 @@ struct smc_link_group {
 	u8			terminating : 1;/* lgr is terminating */
 	u8			freeing : 1;	/* lgr is being freed */
 
+	refcount_t		refcnt;		/* lgr reference count */
 	bool			is_smcd;	/* SMC-R or SMC-D */
 	u8			smc_version;
 	u8			negotiated_eid[SMC_MAX_EID_LEN];
@@ -470,6 +471,8 @@ struct smc_clc_msg_accept_confirm;
 
 void smc_lgr_cleanup_early(struct smc_connection *conn);
 void smc_lgr_terminate_sched(struct smc_link_group *lgr);
+void smc_lgr_hold(struct smc_link_group *lgr);
+void smc_lgr_put(struct smc_link_group *lgr);
 void smcr_port_add(struct smc_ib_device *smcibdev, u8 ibport);
 void smcr_port_err(struct smc_ib_device *smcibdev, u8 ibport);
 void smc_smcd_terminate(struct smcd_dev *dev, u64 peer_gid,
-- 
2.34.1

