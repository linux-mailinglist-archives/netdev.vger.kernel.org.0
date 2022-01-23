Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 17620496E75
	for <lists+netdev@lfdr.de>; Sun, 23 Jan 2022 01:12:21 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S235216AbiAWAMI (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sat, 22 Jan 2022 19:12:08 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:36596 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S235160AbiAWAL4 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sat, 22 Jan 2022 19:11:56 -0500
Received: from ams.source.kernel.org (ams.source.kernel.org [IPv6:2604:1380:4601:e00::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id B6DE2C061744;
        Sat, 22 Jan 2022 16:11:55 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id 57EF9B80AB1;
        Sun, 23 Jan 2022 00:11:54 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 1AB49C36AE7;
        Sun, 23 Jan 2022 00:11:52 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1642896713;
        bh=JNisxRfei9m4NnvzKTq3L3CEJBbv2R5zSIfl/bLX5Hg=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=TSueYz6gzOsDq9HNGpLoJpGlhZdhNlqoR7xP1+mtpsezSpb0Og/V4CaiLuX6qW2Ho
         fA3NZDP0I7z4K7x9R895tPAlclavlaG6lTSDspNn/xUfUPq0iX81+AfRb6PngzC8cG
         TMY1kDZpNMQkRFlSdBufvWARSQYKwLQvKsarVLBhG92PdG8sPsQ4ozGzhAh/dq6ESi
         bZWYL0I5bG12D1RPx2HY7vLwCJUbikfd/P9/y6qeMU6rCX9TwEkklBrJ8D9jyiQQwp
         ROibQbDM8D4LIuVyzliCNTgxfev7BAnsUpMWdP4pTO9UC0FyQtGL6YyNv/LGeHsXb+
         WO70douGwJP/A==
From:   Sasha Levin <sashal@kernel.org>
To:     linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc:     Wen Gu <guwen@linux.alibaba.com>,
        "David S . Miller" <davem@davemloft.net>,
        Sasha Levin <sashal@kernel.org>, kgraul@linux.ibm.com,
        kuba@kernel.org, linux-s390@vger.kernel.org, netdev@vger.kernel.org
Subject: [PATCH AUTOSEL 5.16 10/19] net/smc: Resolve the race between SMC-R link access and clear
Date:   Sat, 22 Jan 2022 19:11:03 -0500
Message-Id: <20220123001113.2460140-10-sashal@kernel.org>
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

[ Upstream commit 20c9398d3309d170300d67643b851fd26783af24 ]

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
Signed-off-by: David S. Miller <davem@davemloft.net>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 net/smc/smc_core.c | 52 +++++++++++++++++++++++++++++++++++-----------
 net/smc/smc_core.h |  4 ++++
 2 files changed, 44 insertions(+), 12 deletions(-)

diff --git a/net/smc/smc_core.c b/net/smc/smc_core.c
index 84b89d13c3359..f4de45ac88189 100644
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
@@ -1872,6 +1898,8 @@ int smc_conn_create(struct smc_sock *smc, struct smc_init_info *ini)
 			goto out;
 	}
 	smc_lgr_hold(conn->lgr); /* lgr_put in smc_conn_free() */
+	if (!conn->lgr->is_smcd)
+		smcr_link_hold(conn->lnk); /* link_put in smc_conn_free() */
 	conn->freed = 0;
 	conn->local_tx_ctrl.common.type = SMC_CDC_MSG_TYPE;
 	conn->local_tx_ctrl.len = SMC_WR_TX_SIZE;
diff --git a/net/smc/smc_core.h b/net/smc/smc_core.h
index 51203b16307be..e73217f52f3dd 100644
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
@@ -504,6 +506,8 @@ void smc_core_exit(void);
 int smcr_link_init(struct smc_link_group *lgr, struct smc_link *lnk,
 		   u8 link_idx, struct smc_init_info *ini);
 void smcr_link_clear(struct smc_link *lnk, bool log);
+void smcr_link_hold(struct smc_link *lnk);
+void smcr_link_put(struct smc_link *lnk);
 void smc_switch_link_and_count(struct smc_connection *conn,
 			       struct smc_link *to_lnk);
 int smcr_buf_map_lgr(struct smc_link *lnk);
-- 
2.34.1

