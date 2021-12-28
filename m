Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 40D4B480AC3
	for <lists+netdev@lfdr.de>; Tue, 28 Dec 2021 16:14:24 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S235026AbhL1POW (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 28 Dec 2021 10:14:22 -0500
Received: from out30-132.freemail.mail.aliyun.com ([115.124.30.132]:33904 "EHLO
        out30-132.freemail.mail.aliyun.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S234965AbhL1POU (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 28 Dec 2021 10:14:20 -0500
X-Alimail-AntiSpam: AC=PASS;BC=-1|-1;BR=01201311R171e4;CH=green;DM=||false|;DS=||;FP=0|-1|-1|-1|0|-1|-1|-1;HT=e01e04407;MF=guwen@linux.alibaba.com;NM=1;PH=DS;RN=8;SR=0;TI=SMTPD_---0V07rdMJ_1640704434;
Received: from e02h04404.eu6sqa(mailfrom:guwen@linux.alibaba.com fp:SMTPD_---0V07rdMJ_1640704434)
          by smtp.aliyun-inc.com(127.0.0.1);
          Tue, 28 Dec 2021 23:14:18 +0800
From:   Wen Gu <guwen@linux.alibaba.com>
To:     kgraul@linux.ibm.com, davem@davemloft.net, kuba@kernel.org
Cc:     linux-s390@vger.kernel.org, netdev@vger.kernel.org,
        linux-kernel@vger.kernel.org, dust.li@linux.alibaba.com,
        tonylu@linux.alibaba.com
Subject: [RFC PATCH net v2 2/2] net/smc: Resolve the race between SMC-R link access and clear
Date:   Tue, 28 Dec 2021 23:13:52 +0800
Message-Id: <1640704432-76825-3-git-send-email-guwen@linux.alibaba.com>
X-Mailer: git-send-email 1.8.3.1
In-Reply-To: <1640704432-76825-1-git-send-email-guwen@linux.alibaba.com>
References: <1640704432-76825-1-git-send-email-guwen@linux.alibaba.com>
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

We encountered some crashes caused by the race between SMC-R
link access and link clear triggered by link group termination
in abnormal case, like port error.

Here are some of panic stacks we met:

1) Race between smc_llc_flow_initiate() and smcr_link_clear()

 BUG: kernel NULL pointer dereference, address: 0000000000000000
 Workqueue: smc_hs_wq smc_listen_work [smc]
 RIP: 0010:smc_llc_flow_initiate+0x44/0x190 [smc]
 Call Trace:
  <TASK>
  ? __smc_buf_create+0x75a/0x950 [smc]
  smcr_lgr_reg_rmbs+0x2a/0xbf [smc]
  smc_listen_work+0xf72/0x1230 [smc]
  ? process_one_work+0x25c/0x600
  process_one_work+0x25c/0x600
  worker_thread+0x4f/0x3a0
  ? process_one_work+0x600/0x600
  kthread+0x15d/0x1a0
  ? set_kthread_struct+0x40/0x40
  ret_from_fork+0x1f/0x30
  </TASK>

smc_listen_work()                       __smc_lgr_terminate()
---------------------------------------------------------------
                                       | smc_lgr_free()
                                       |     |- smcr_link_clear()
                                       |            |- memset(lnk, 0)
smc_listen_rdma_reg()                  |
  |- smcr_lgr_reg_rmbs()               |
       |- smc_llc_flow_initiate()      |
            |- access lnk->lgr (panic) |

2) Race between smc_wr_tx_dismiss_slots() and smcr_link_clear()

 BUG: kernel NULL pointer dereference, address: 0000000000000000
 RIP: 0010:_find_first_bit+0x8/0x50
 Call Trace:
  <TASK>
  smc_wr_tx_dismiss_slots+0x34/0xc0 [smc]
  ? smc_cdc_tx_filter+0x10/0x10 [smc]
  smc_conn_free+0xd8/0x100 [smc]
  __smc_release+0xf1/0x140 [smc]
  smc_release+0x89/0x1b0 [smc]
  __sock_release+0x37/0xb0
  sock_close+0x14/0x20
  __fput+0xa9/0x260
  task_work_run+0x6b/0xb0
  do_exit+0x3ef/0xd40
  do_group_exit+0x47/0xb0
  __x64_sys_exit_group+0x14/0x20
  do_syscall_64+0x34/0x90
  entry_SYSCALL_64_after_hwframe+0x44/0xae
  </TASK>

smc_conn_free()                           __smc_lgr_terminate()
----------------------------------------------------------------
                                         | smc_lgr_free()
                                         |  |- smcr_link_clear()
                                         |      |- smc_wr_free_link_mem()
                                         |          |- lnk->wr_tx_mask = NULL;
smc_wr_tx_dismiss_slots()                |
  |- for_each_set_bit(link->wr_tx_mask)  |
            |- (panic)                   |

These crashes are caused by clearing SMC-R link resources
when someone is still accessing to them. So this patch tries
to fix it by introducing reference count of SMC-R links and
ensuring that the sensitive resources of links are not
cleared until reference count is zero.

The operation to the SMC-R link reference count can be concluded
as follows:

object          [hold or initialized as 1]         [put]
--------------------------------------------------------------------
links           smcr_link_init()                   smcr_link_clear()
connections     smcr_lgr_conn_assign_link()        smc_conn_free()

Through this way, the clear of SMC-R links is later than the
free of all the smc connections above it, thus avoiding the
unsafe reference to SMC-R links.

Signed-off-by: Wen Gu <guwen@linux.alibaba.com>
---
 net/smc/smc_core.c | 43 +++++++++++++++++++++++++++++++++++--------
 net/smc/smc_core.h |  4 ++++
 2 files changed, 39 insertions(+), 8 deletions(-)

diff --git a/net/smc/smc_core.c b/net/smc/smc_core.c
index d72eb13..a64d394 100644
--- a/net/smc/smc_core.c
+++ b/net/smc/smc_core.c
@@ -155,6 +155,7 @@ static int smcr_lgr_conn_assign_link(struct smc_connection *conn, bool first)
 	if (!conn->lnk)
 		return SMC_CLC_DECL_NOACTLINK;
 	atomic_inc(&conn->lnk->conn_cnt);
+	smcr_link_hold(conn->lnk); /* link_put in smc_conn_free() */
 	return 0;
 }
 
@@ -746,6 +747,8 @@ int smcr_link_init(struct smc_link_group *lgr, struct smc_link *lnk,
 	}
 	get_device(&lnk->smcibdev->ibdev->dev);
 	atomic_inc(&lnk->smcibdev->lnk_cnt);
+	refcount_set(&lnk->refcnt, 1); /* link refcnt is set to 1 */
+	lnk->clearing = 0;
 	lnk->path_mtu = lnk->smcibdev->pattr[lnk->ibport - 1].active_mtu;
 	lnk->link_id = smcr_next_link_id(lgr);
 	lnk->lgr = lgr;
@@ -994,8 +997,12 @@ void smc_switch_link_and_count(struct smc_connection *conn,
 			       struct smc_link *to_lnk)
 {
 	atomic_dec(&conn->lnk->conn_cnt);
+	/* put old link, hold in smcr_lgr_conn_assign_link() */
+	smcr_link_put(conn->lnk);
 	conn->lnk = to_lnk;
 	atomic_inc(&conn->lnk->conn_cnt);
+	/* hold new link, put in smc_conn_free() */
+	smcr_link_hold(conn->lnk);
 }
 
 struct smc_link *smc_switch_conns(struct smc_link_group *lgr,
@@ -1126,9 +1133,9 @@ void smc_conn_free(struct smc_connection *conn)
 		/* smc connection wasn't registered to a link group
 		 * or has already been freed before.
 		 *
-		 * Judge these to ensure that lgr refcnt will be put
-		 * only once if connection has been registered to a
-		 * link group successfully.
+		 * Judge these to ensure that lgr/link refcnt will be
+		 * put only once if connection has been registered to
+		 * a link group successfully.
 		 */
 		return;
 
@@ -1153,6 +1160,8 @@ void smc_conn_free(struct smc_connection *conn)
 	if (!lgr->conns_num)
 		smc_lgr_schedule_free_work(lgr);
 lgr_put:
+	if (!lgr->is_smcd)
+		smcr_link_put(conn->lnk); /* link_hold in smcr_lgr_conn_assign_link() */
 	smc_lgr_put(lgr); /* lgr_hold in smc_lgr_register_conn() */
 }
 
@@ -1209,13 +1218,23 @@ static void smcr_rtoken_clear_link(struct smc_link *lnk)
 	}
 }
 
+static void __smcr_link_clear(struct smc_link *lnk)
+{
+	smc_wr_free_link_mem(lnk);
+	smc_lgr_put(lnk->lgr);	/* lgr_hold in smcr_link_init() */
+	memset(lnk, 0, sizeof(struct smc_link));
+	lnk->state = SMC_LNK_UNUSED;
+}
+
 /* must be called under lgr->llc_conf_mutex lock */
 void smcr_link_clear(struct smc_link *lnk, bool log)
 {
 	struct smc_ib_device *smcibdev;
 
-	if (!lnk->lgr || lnk->state == SMC_LNK_UNUSED)
+	if (lnk->clearing || !lnk->lgr ||
+	    lnk->state == SMC_LNK_UNUSED)
 		return;
+	lnk->clearing = 1;
 	lnk->peer_qpn = 0;
 	smc_llc_link_clear(lnk, log);
 	smcr_buf_unmap_lgr(lnk);
@@ -1224,15 +1243,23 @@ void smcr_link_clear(struct smc_link *lnk, bool log)
 	smc_wr_free_link(lnk);
 	smc_ib_destroy_queue_pair(lnk);
 	smc_ib_dealloc_protection_domain(lnk);
-	smc_wr_free_link_mem(lnk);
-	smc_lgr_put(lnk->lgr); /* lgr_hold in smcr_link_init() */
 	smc_ibdev_cnt_dec(lnk);
 	put_device(&lnk->smcibdev->ibdev->dev);
 	smcibdev = lnk->smcibdev;
-	memset(lnk, 0, sizeof(struct smc_link));
-	lnk->state = SMC_LNK_UNUSED;
 	if (!atomic_dec_return(&smcibdev->lnk_cnt))
 		wake_up(&smcibdev->lnks_deleted);
+	smcr_link_put(lnk); /* theoretically last link_put */
+}
+
+void smcr_link_hold(struct smc_link *lnk)
+{
+	refcount_inc(&lnk->refcnt);
+}
+
+void smcr_link_put(struct smc_link *lnk)
+{
+	if (refcount_dec_and_test(&lnk->refcnt))
+		__smcr_link_clear(lnk);
 }
 
 static void smcr_buf_free(struct smc_link_group *lgr, bool is_rmb,
diff --git a/net/smc/smc_core.h b/net/smc/smc_core.h
index 51203b1..e73217f 100644
--- a/net/smc/smc_core.h
+++ b/net/smc/smc_core.h
@@ -137,6 +137,8 @@ struct smc_link {
 	u8			peer_link_uid[SMC_LGR_ID_SIZE]; /* peer uid */
 	u8			link_idx;	/* index in lgr link array */
 	u8			link_is_asym;	/* is link asymmetric? */
+	u8			clearing : 1;	/* link is being cleared */
+	refcount_t		refcnt;		/* link reference count */
 	struct smc_link_group	*lgr;		/* parent link group */
 	struct work_struct	link_down_wrk;	/* wrk to bring link down */
 	char			ibname[IB_DEVICE_NAME_MAX]; /* ib device name */
@@ -504,6 +506,8 @@ void smc_rtoken_set2(struct smc_link_group *lgr, int rtok_idx, int link_id,
 int smcr_link_init(struct smc_link_group *lgr, struct smc_link *lnk,
 		   u8 link_idx, struct smc_init_info *ini);
 void smcr_link_clear(struct smc_link *lnk, bool log);
+void smcr_link_hold(struct smc_link *lnk);
+void smcr_link_put(struct smc_link *lnk);
 void smc_switch_link_and_count(struct smc_connection *conn,
 			       struct smc_link *to_lnk);
 int smcr_buf_map_lgr(struct smc_link *lnk);
-- 
1.8.3.1

