Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 2E7DA480717
	for <lists+netdev@lfdr.de>; Tue, 28 Dec 2021 08:49:48 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S235397AbhL1Htq (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 28 Dec 2021 02:49:46 -0500
Received: from out30-45.freemail.mail.aliyun.com ([115.124.30.45]:57203 "EHLO
        out30-45.freemail.mail.aliyun.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S235393AbhL1Htq (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 28 Dec 2021 02:49:46 -0500
X-Alimail-AntiSpam: AC=PASS;BC=-1|-1;BR=01201311R101e4;CH=green;DM=||false|;DS=||;FP=0|-1|-1|-1|0|-1|-1|-1;HT=e01e04395;MF=guwen@linux.alibaba.com;NM=1;PH=DS;RN=6;SR=0;TI=SMTPD_---0V04IY3i_1640677771;
Received: from e02h04404.eu6sqa(mailfrom:guwen@linux.alibaba.com fp:SMTPD_---0V04IY3i_1640677771)
          by smtp.aliyun-inc.com(127.0.0.1);
          Tue, 28 Dec 2021 15:49:44 +0800
From:   Wen Gu <guwen@linux.alibaba.com>
To:     kgraul@linux.ibm.com, davem@davemloft.net, kuba@kernel.org
Cc:     linux-s390@vger.kernel.org, netdev@vger.kernel.org,
        linux-kernel@vger.kernel.org
Subject: [RFC PATCH net] net/smc: Reset conn->lgr when link group registration fails
Date:   Tue, 28 Dec 2021 15:49:30 +0800
Message-Id: <1640677770-112053-1-git-send-email-guwen@linux.alibaba.com>
X-Mailer: git-send-email 1.8.3.1
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

SMC connections might fail to be registered to a link group due to
things like unable to find a link to assign to in its creation. As
a result, connection creation will return a failure and most
resources related to the connection won't be applied or initialized,
such as conn->abort_work or conn->lnk.

If smc_conn_free() is invoked later, it will try to access the
resources related to the connection, which wasn't initialized, thus
causing a panic.

Here is an example, a SMC-R connection failed to be registered
to a link group and conn->lnk is NULL. The following crash will
happen if smc_conn_free() tries to access conn->lnk in
smc_cdc_tx_dismiss_slots().

 BUG: kernel NULL pointer dereference, address: 0000000000000168
 #PF: supervisor read access in kernel mode
 #PF: error_code(0x0000) - not-present page
 PGD 0 P4D 0
 Oops: 0000 [#1] PREEMPT SMP PTI
 CPU: 4 PID: 68 Comm: kworker/4:1 Kdump: loaded Tainted: G E     5.16.0-rc5+ #52
 Workqueue: smc_hs_wq smc_listen_work [smc]
 RIP: 0010:smc_wr_tx_dismiss_slots+0x1e/0xc0 [smc]
 Call Trace:
  <TASK>
  smc_conn_free+0xd8/0x100 [smc]
  smc_lgr_cleanup_early+0x15/0x90 [smc]
  smc_listen_work+0x302/0x1230 [smc]
  ? process_one_work+0x25c/0x600
  process_one_work+0x25c/0x600
  worker_thread+0x4f/0x3a0
  ? process_one_work+0x600/0x600
  kthread+0x15d/0x1a0
  ? set_kthread_struct+0x40/0x40
  ret_from_fork+0x1f/0x30
  </TASK>

This patch tries to fix this by resetting conn->lgr to NULL if an
abnormal exit due to lgr register failure occurs in smc_conn_create(),
thus avoiding the crash caused by accessing the uninitialized resources
in smc_conn_free().

Signed-off-by: Wen Gu <guwen@linux.alibaba.com>
---
 net/smc/smc_core.c | 10 ++++++++--
 1 file changed, 8 insertions(+), 2 deletions(-)

diff --git a/net/smc/smc_core.c b/net/smc/smc_core.c
index 412bc85..1f40b8e 100644
--- a/net/smc/smc_core.c
+++ b/net/smc/smc_core.c
@@ -1815,7 +1815,7 @@ int smc_conn_create(struct smc_sock *smc, struct smc_init_info *ini)
 	}
 	spin_unlock_bh(lgr_lock);
 	if (rc)
-		return rc;
+		goto out_unreg;
 
 	if (role == SMC_CLNT && !ini->first_contact_peer &&
 	    ini->first_contact_local) {
@@ -1836,7 +1836,7 @@ int smc_conn_create(struct smc_sock *smc, struct smc_init_info *ini)
 		rc = smc_lgr_register_conn(conn, true);
 		write_unlock_bh(&lgr->conns_lock);
 		if (rc)
-			goto out;
+			goto out_unreg;
 	}
 	conn->local_tx_ctrl.common.type = SMC_CDC_MSG_TYPE;
 	conn->local_tx_ctrl.len = SMC_WR_TX_SIZE;
@@ -1855,6 +1855,12 @@ int smc_conn_create(struct smc_sock *smc, struct smc_init_info *ini)
 
 out:
 	return rc;
+out_unreg:
+	/* fail to register connection into a link group */
+	if (!lgr->conns_num && !delayed_work_pending(&lgr->free_work))
+		smc_lgr_schedule_free_work(lgr);
+	conn->lgr = NULL;
+	return rc;
 }
 
 #define SMCD_DMBE_SIZES		6 /* 0 -> 16KB, 1 -> 32KB, .. 6 -> 1MB */
-- 
1.8.3.1

