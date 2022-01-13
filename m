Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 3700B48D3B5
	for <lists+netdev@lfdr.de>; Thu, 13 Jan 2022 09:37:58 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233090AbiAMIg4 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 13 Jan 2022 03:36:56 -0500
Received: from out30-131.freemail.mail.aliyun.com ([115.124.30.131]:45972 "EHLO
        out30-131.freemail.mail.aliyun.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S232784AbiAMIgz (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 13 Jan 2022 03:36:55 -0500
X-Alimail-AntiSpam: AC=PASS;BC=-1|-1;BR=01201311R211e4;CH=green;DM=||false|;DS=||;FP=0|-1|-1|-1|0|-1|-1|-1;HT=e01e04395;MF=guwen@linux.alibaba.com;NM=1;PH=DS;RN=6;SR=0;TI=SMTPD_---0V1imC6N_1642063002;
Received: from e02h04404.eu6sqa(mailfrom:guwen@linux.alibaba.com fp:SMTPD_---0V1imC6N_1642063002)
          by smtp.aliyun-inc.com(127.0.0.1);
          Thu, 13 Jan 2022 16:36:52 +0800
From:   Wen Gu <guwen@linux.alibaba.com>
To:     kgraul@linux.ibm.com, davem@davemloft.net, kuba@kernel.org
Cc:     linux-s390@vger.kernel.org, netdev@vger.kernel.org,
        linux-kernel@vger.kernel.org
Subject: [PATCH net v2 3/3] net/smc: Resolve the race between SMC-R link access and clear
Date:   Thu, 13 Jan 2022 16:36:42 +0800
Message-Id: <1642063002-45688-4-git-send-email-guwen@linux.alibaba.com>
X-Mailer: git-send-email 1.8.3.1
In-Reply-To: <1642063002-45688-1-git-send-email-guwen@linux.alibaba.com>
References: <1642063002-45688-1-git-send-email-guwen@linux.alibaba.com>
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

We encountered some crashes caused by the race between SMC-R
link access and link clear that triggered by abnormal link
group termination, such as port error.

Here is an example of this kind of crashes:

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

smc_listen_work()                     __smc_lgr_terminate()
---------------------------------------------------------------
                                    | smc_lgr_free()
                                    |  |- smcr_link_clear()
                                    |      |- memset(lnk, 0)
smc_listen_rdma_reg()               |
 |- smcr_lgr_reg_rmbs()             |
     |- smc_llc_flow_initiate()     |
         |- access lnk->lgr (panic) |

These crashes are similarly caused by clearing SMC-R link
resources when some functions is still accessing to them.
This patch tries to fix the issue by introducing reference
count of SMC-R links and ensuring that the sensitive resources
of links won't be cleared until reference count reaches zero.

The operation to the SMC-R link reference count can be concluded
as follows:

object          [hold or initialized as 1]         [put]
--------------------------------------------------------------------
links           smcr_link_init()                   smcr_link_clear()
connections     smc_conn_create()                  smc_conn_free()

Through this way, the clear of SMC-R links is later than the
free of all the smc connections above it, thus avoiding the
unsafe reference to SMC-R links.

Signed-off-by: Wen Gu <guwen@linux.alibaba.com>
---
 net/smc/smc_core.c | 52 ++++++++++++++++++++++++++++++++++++++++------------
 net/smc/smc_core.h |  4 ++++
 2 files changed, 44 insertions(+), 12 deletions(-)

diff --git a/net/smc/smc_core.c b/net/smc/smc_core.c
index bc4c615..4ceee96 100644
--- a/net/smc/smc_core.c
+++ b/net/smc/smc_core.c
@@ -745,6 +745,8 @@ int smcr_link_init(struct smc_link_group *lgr, struct smc_link *lnk,
 	}
 	get_device(&lnk->smcibdev->ibdev->dev);
 	atomic_inc(&lnk->smcibdev->lnk_cnt);
+	refcount_set(&lnk->refcnt, 1); /* link refcnt is set to 1 */
+	lnk->clearing = 0;
 	lnk->path_mtu = lnk->smcibdev->pattr[lnk->ibport - 1].active_mtu;
 	lnk->link_id = smcr_next_link_id(lgr);
 	lnk->lgr = lgr;
@@ -994,8 +996,12 @@ void smc_switch_link_and_count(struct smc_connection *conn,
 			       struct smc_link *to_lnk)
 {
 	atomic_dec(&conn->lnk->conn_cnt);
+	/* link_hold in smc_conn_create() */
+	smcr_link_put(conn->lnk);
 	conn->lnk = to_lnk;
 	atomic_inc(&conn->lnk->conn_cnt);
+	/* link_put in smc_conn_free() */
+	smcr_link_hold(conn->lnk);
 }
 
 struct smc_link *smc_switch_conns(struct smc_link_group *lgr,
@@ -1152,6 +1158,8 @@ void smc_conn_free(struct smc_connection *conn)
 	if (!lgr->conns_num)
 		smc_lgr_schedule_free_work(lgr);
 lgr_put:
+	if (!lgr->is_smcd)
+		smcr_link_put(conn->lnk); /* link_hold in smc_conn_create() */
 	smc_lgr_put(lgr); /* lgr_hold in smc_conn_create() */
 }
 
@@ -1208,22 +1216,11 @@ static void smcr_rtoken_clear_link(struct smc_link *lnk)
 	}
 }
 
-/* must be called under lgr->llc_conf_mutex lock */
-void smcr_link_clear(struct smc_link *lnk, bool log)
+static void __smcr_link_clear(struct smc_link *lnk)
 {
 	struct smc_link_group *lgr = lnk->lgr;
 	struct smc_ib_device *smcibdev;
 
-	if (!lgr || lnk->state == SMC_LNK_UNUSED)
-		return;
-	lnk->peer_qpn = 0;
-	smc_llc_link_clear(lnk, log);
-	smcr_buf_unmap_lgr(lnk);
-	smcr_rtoken_clear_link(lnk);
-	smc_ib_modify_qp_error(lnk);
-	smc_wr_free_link(lnk);
-	smc_ib_destroy_queue_pair(lnk);
-	smc_ib_dealloc_protection_domain(lnk);
 	smc_wr_free_link_mem(lnk);
 	smc_ibdev_cnt_dec(lnk);
 	put_device(&lnk->smcibdev->ibdev->dev);
@@ -1235,6 +1232,35 @@ void smcr_link_clear(struct smc_link *lnk, bool log)
 	smc_lgr_put(lgr); /* lgr_hold in smcr_link_init() */
 }
 
+/* must be called under lgr->llc_conf_mutex lock */
+void smcr_link_clear(struct smc_link *lnk, bool log)
+{
+	if (!lnk->lgr || lnk->clearing ||
+	    lnk->state == SMC_LNK_UNUSED)
+		return;
+	lnk->clearing = 1;
+	lnk->peer_qpn = 0;
+	smc_llc_link_clear(lnk, log);
+	smcr_buf_unmap_lgr(lnk);
+	smcr_rtoken_clear_link(lnk);
+	smc_ib_modify_qp_error(lnk);
+	smc_wr_free_link(lnk);
+	smc_ib_destroy_queue_pair(lnk);
+	smc_ib_dealloc_protection_domain(lnk);
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
+}
+
 static void smcr_buf_free(struct smc_link_group *lgr, bool is_rmb,
 			  struct smc_buf_desc *buf_desc)
 {
@@ -1877,6 +1903,8 @@ int smc_conn_create(struct smc_sock *smc, struct smc_init_info *ini)
 		}
 	}
 	smc_lgr_hold(conn->lgr); /* lgr_put in smc_conn_free() */
+	if (!conn->lgr->is_smcd)
+		smcr_link_hold(conn->lnk); /* link_put in smc_conn_free() */
 	conn->freed = 0;
 	conn->local_tx_ctrl.common.type = SMC_CDC_MSG_TYPE;
 	conn->local_tx_ctrl.len = SMC_WR_TX_SIZE;
diff --git a/net/smc/smc_core.h b/net/smc/smc_core.h
index 630298b..cbf0fc1 100644
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
@@ -509,6 +511,8 @@ void smc_rtoken_set2(struct smc_link_group *lgr, int rtok_idx, int link_id,
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

