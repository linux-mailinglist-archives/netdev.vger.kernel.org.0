Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id B3EED484EE5
	for <lists+netdev@lfdr.de>; Wed,  5 Jan 2022 08:54:14 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S238231AbiAEHyM (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 5 Jan 2022 02:54:12 -0500
Received: from out30-132.freemail.mail.aliyun.com ([115.124.30.132]:35058 "EHLO
        out30-132.freemail.mail.aliyun.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S229880AbiAEHyL (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 5 Jan 2022 02:54:11 -0500
X-Alimail-AntiSpam: AC=PASS;BC=-1|-1;BR=01201311R271e4;CH=green;DM=||false|;DS=||;FP=0|-1|-1|-1|0|-1|-1|-1;HT=e01e04423;MF=dust.li@linux.alibaba.com;NM=1;PH=DS;RN=7;SR=0;TI=SMTPD_---0V10FZ4X_1641369249;
Received: from localhost(mailfrom:dust.li@linux.alibaba.com fp:SMTPD_---0V10FZ4X_1641369249)
          by smtp.aliyun-inc.com(127.0.0.1);
          Wed, 05 Jan 2022 15:54:09 +0800
Date:   Wed, 5 Jan 2022 15:54:08 +0800
From:   "dust.li" <dust.li@linux.alibaba.com>
To:     Wen Gu <guwen@linux.alibaba.com>, kgraul@linux.ibm.com,
        davem@davemloft.net, kuba@kernel.org
Cc:     linux-s390@vger.kernel.org, netdev@vger.kernel.org,
        linux-kernel@vger.kernel.org
Subject: Re: [PATCH net v3] net/smc: Reset conn->lgr when link group
 registration fails
Message-ID: <20220105075408.GC31579@linux.alibaba.com>
Reply-To: dust.li@linux.alibaba.com
References: <1641364133-61284-1-git-send-email-guwen@linux.alibaba.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1641364133-61284-1-git-send-email-guwen@linux.alibaba.com>
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Wed, Jan 05, 2022 at 02:28:53PM +0800, Wen Gu wrote:
>SMC connections might fail to be registered to a link group due to
>things like unable to find a link to assign to in its creation. As
>a result, connection creation will return a failure and most
>resources related to the connection won't be applied or initialized,
>such as conn->abort_work or conn->lnk.
>
>If smc_conn_free() is invoked later, it will try to access the
>resources related to the connection, which wasn't initialized, thus
>causing a panic.
>
>Here is an example, a SMC-R connection failed to be registered
>to a link group and conn->lnk is NULL. The following crash will
>happen if smc_conn_free() tries to access conn->lnk in
>smc_cdc_tx_dismiss_slots().
>
> BUG: kernel NULL pointer dereference, address: 0000000000000168
> #PF: supervisor read access in kernel mode
> #PF: error_code(0x0000) - not-present page
> PGD 0 P4D 0
> Oops: 0000 [#1] PREEMPT SMP PTI
> CPU: 4 PID: 68 Comm: kworker/4:1 Kdump: loaded Tainted: G E     5.16.0-rc5+ #52
> Workqueue: smc_hs_wq smc_listen_work [smc]
> RIP: 0010:smc_wr_tx_dismiss_slots+0x1e/0xc0 [smc]
> Call Trace:
>  <TASK>
>  smc_conn_free+0xd8/0x100 [smc]
>  smc_lgr_cleanup_early+0x15/0x90 [smc]
>  smc_listen_work+0x302/0x1230 [smc]
>  ? process_one_work+0x25c/0x600
>  process_one_work+0x25c/0x600
>  worker_thread+0x4f/0x3a0
>  ? process_one_work+0x600/0x600
>  kthread+0x15d/0x1a0
>  ? set_kthread_struct+0x40/0x40
>  ret_from_fork+0x1f/0x30
>  </TASK>
>
>This patch tries to fix this by resetting conn->lgr to NULL if an
>abnormal exit occurs in smc_lgr_register_conn(), thus avoiding the
>crash caused by accessing the uninitialized resources in smc_conn_free().
>And the new created link group will be terminated if smc connections
>can't be registered to it.
>
>Fixes: 56bc3b2094b4 ("net/smc: assign link to a new connection")
>Signed-off-by: Wen Gu <guwen@linux.alibaba.com>
>---
>v1->v2:
>- Reset conn->lgr to NULL in smc_lgr_register_conn().
>- Only free new created link group.
>v2->v3:
>- Using __smc_lgr_terminate() instead of smc_lgr_schedule_free_work()
>  for an immediate free.
>---
> net/smc/smc_core.c | 12 ++++++++++--
> 1 file changed, 10 insertions(+), 2 deletions(-)
>
>diff --git a/net/smc/smc_core.c b/net/smc/smc_core.c
>index 412bc85..0201f99 100644
>--- a/net/smc/smc_core.c
>+++ b/net/smc/smc_core.c
>@@ -171,8 +171,10 @@ static int smc_lgr_register_conn(struct smc_connection *conn, bool first)
> 
> 	if (!conn->lgr->is_smcd) {
> 		rc = smcr_lgr_conn_assign_link(conn, first);
>-		if (rc)
>+		if (rc) {
>+			conn->lgr = NULL;
> 			return rc;
>+		}
> 	}
> 	/* find a new alert_token_local value not yet used by some connection
> 	 * in this link group
>@@ -1835,8 +1837,14 @@ int smc_conn_create(struct smc_sock *smc, struct smc_init_info *ini)
> 		write_lock_bh(&lgr->conns_lock);
> 		rc = smc_lgr_register_conn(conn, true);
> 		write_unlock_bh(&lgr->conns_lock);
>-		if (rc)
>+		if (rc) {
>+			spin_lock_bh(lgr_lock);
>+			if (!list_empty(&lgr->list))
>+				list_del_init(&lgr->list);
>+			spin_unlock_bh(lgr_lock);
>+			__smc_lgr_terminate(lgr, true);

What about adding a smc_lgr_terminate() wrapper and put list_del_init()
and __smc_lgr_terminate() into it ?

> 			goto out;
>+		}
> 	}
> 	conn->local_tx_ctrl.common.type = SMC_CDC_MSG_TYPE;
> 	conn->local_tx_ctrl.len = SMC_WR_TX_SIZE;
>-- 
>1.8.3.1
