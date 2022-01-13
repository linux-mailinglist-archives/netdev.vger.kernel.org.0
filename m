Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 4F4BD48D3B2
	for <lists+netdev@lfdr.de>; Thu, 13 Jan 2022 09:37:57 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233002AbiAMIgy (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 13 Jan 2022 03:36:54 -0500
Received: from out30-132.freemail.mail.aliyun.com ([115.124.30.132]:34237 "EHLO
        out30-132.freemail.mail.aliyun.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S231990AbiAMIgy (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 13 Jan 2022 03:36:54 -0500
X-Alimail-AntiSpam: AC=PASS;BC=-1|-1;BR=01201311R391e4;CH=green;DM=||false|;DS=||;FP=0|-1|-1|-1|0|-1|-1|-1;HT=e01e01424;MF=guwen@linux.alibaba.com;NM=1;PH=DS;RN=6;SR=0;TI=SMTPD_---0V1imC6N_1642063002;
Received: from e02h04404.eu6sqa(mailfrom:guwen@linux.alibaba.com fp:SMTPD_---0V1imC6N_1642063002)
          by smtp.aliyun-inc.com(127.0.0.1);
          Thu, 13 Jan 2022 16:36:51 +0800
From:   Wen Gu <guwen@linux.alibaba.com>
To:     kgraul@linux.ibm.com, davem@davemloft.net, kuba@kernel.org
Cc:     linux-s390@vger.kernel.org, netdev@vger.kernel.org,
        linux-kernel@vger.kernel.org
Subject: [PATCH net v2 1/3] net/smc: Resolve the race between link group access and termination
Date:   Thu, 13 Jan 2022 16:36:40 +0800
Message-Id: <1642063002-45688-2-git-send-email-guwen@linux.alibaba.com>
X-Mailer: git-send-email 1.8.3.1
In-Reply-To: <1642063002-45688-1-git-send-email-guwen@linux.alibaba.com>
References: <1642063002-45688-1-git-send-email-guwen@linux.alibaba.com>
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

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
---
 net/smc/smc.h      |  1 +
 net/smc/smc_core.c | 60 ++++++++++++++++++++++++++++++++++++++++++++----------
 net/smc/smc_core.h |  3 +++
 3 files changed, 53 insertions(+), 11 deletions(-)

diff --git a/net/smc/smc.h b/net/smc/smc.h
index 1a4fc1c..3d0b8e3 100644
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
index cd3c3b8..d90e0af 100644
--- a/net/smc/smc_core.c
+++ b/net/smc/smc_core.c
@@ -218,7 +218,6 @@ static void smc_lgr_unregister_conn(struct smc_connection *conn)
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
@@ -1283,6 +1300,21 @@ static void smc_lgr_free_bufs(struct smc_link_group *lgr)
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
@@ -1298,19 +1330,23 @@ static void smc_lgr_free(struct smc_link_group *lgr)
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
@@ -1840,6 +1876,8 @@ int smc_conn_create(struct smc_sock *smc, struct smc_init_info *ini)
 			goto out;
 		}
 	}
+	smc_lgr_hold(conn->lgr); /* lgr_put in smc_conn_free() */
+	conn->freed = 0;
 	conn->local_tx_ctrl.common.type = SMC_CDC_MSG_TYPE;
 	conn->local_tx_ctrl.len = SMC_WR_TX_SIZE;
 	conn->urg_state = SMC_URG_READ;
diff --git a/net/smc/smc_core.h b/net/smc/smc_core.h
index 73d0c35..edbd401 100644
--- a/net/smc/smc_core.h
+++ b/net/smc/smc_core.h
@@ -249,6 +249,7 @@ struct smc_link_group {
 	u8			terminating : 1;/* lgr is terminating */
 	u8			freeing : 1;	/* lgr is being freed */
 
+	refcount_t		refcnt;		/* lgr reference count */
 	bool			is_smcd;	/* SMC-R or SMC-D */
 	u8			smc_version;
 	u8			negotiated_eid[SMC_MAX_EID_LEN];
@@ -470,6 +471,8 @@ static inline void smc_set_pci_values(struct pci_dev *pci_dev,
 
 void smc_lgr_cleanup_early(struct smc_link_group *lgr);
 void smc_lgr_terminate_sched(struct smc_link_group *lgr);
+void smc_lgr_hold(struct smc_link_group *lgr);
+void smc_lgr_put(struct smc_link_group *lgr);
 void smcr_port_add(struct smc_ib_device *smcibdev, u8 ibport);
 void smcr_port_err(struct smc_ib_device *smcibdev, u8 ibport);
 void smc_smcd_terminate(struct smcd_dev *dev, u64 peer_gid,
-- 
1.8.3.1

