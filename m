Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 49CF06B75B2
	for <lists+netdev@lfdr.de>; Mon, 13 Mar 2023 12:16:11 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230444AbjCMLQI (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 13 Mar 2023 07:16:08 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:53536 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230449AbjCMLPo (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 13 Mar 2023 07:15:44 -0400
Received: from out30-130.freemail.mail.aliyun.com (out30-130.freemail.mail.aliyun.com [115.124.30.130])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id BAA5C2212C;
        Mon, 13 Mar 2023 04:14:52 -0700 (PDT)
X-Alimail-AntiSpam: AC=PASS;BC=-1|-1;BR=01201311R491e4;CH=green;DM=||false|;DS=||;FP=0|-1|-1|-1|0|-1|-1|-1;HT=ay29a033018045168;MF=tonylu@linux.alibaba.com;NM=1;PH=DS;RN=13;SR=0;TI=SMTPD_---0VdlpqRi_1678706060;
Received: from localhost(mailfrom:tonylu@linux.alibaba.com fp:SMTPD_---0VdlpqRi_1678706060)
          by smtp.aliyun-inc.com;
          Mon, 13 Mar 2023 19:14:20 +0800
Date:   Mon, 13 Mar 2023 19:14:19 +0800
From:   Tony Lu <tonylu@linux.alibaba.com>
To:     Wenjia Zhang <wenjia@linux.ibm.com>
Cc:     David Miller <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>, netdev@vger.kernel.org,
        linux-s390@vger.kernel.org, Eric Dumazet <edumazet@google.com>,
        Paolo Abeni <pabeni@redhat.com>,
        Heiko Carstens <hca@linux.ibm.com>,
        Karsten Graul <kgraul@linux.ibm.com>,
        Alexandra Winter <wintera@linux.ibm.com>,
        Jan Karcher <jaka@linux.ibm.com>,
        Stefan Raspl <raspl@linux.ibm.com>
Subject: Re: [PATCH net 1/2] net/smc: fix deadlock triggered by
 cancel_delayed_work_syn()
Message-ID: <ZA8Fizksovklmc+v@TONYMAC-ALIBABA.local>
Reply-To: Tony Lu <tonylu@linux.alibaba.com>
References: <20230313100829.13136-1-wenjia@linux.ibm.com>
 <20230313100829.13136-2-wenjia@linux.ibm.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20230313100829.13136-2-wenjia@linux.ibm.com>
X-Spam-Status: No, score=-9.9 required=5.0 tests=BAYES_00,
        ENV_AND_HDR_SPF_MATCH,RCVD_IN_DNSWL_NONE,RCVD_IN_MSPIKE_H2,
        SPF_HELO_NONE,SPF_PASS,UNPARSEABLE_RELAY,USER_IN_DEF_SPF_WL
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Mon, Mar 13, 2023 at 11:08:28AM +0100, Wenjia Zhang wrote:
> The following LOCKDEP was detected:
> 		Workqueue: events smc_lgr_free_work [smc]
> 		WARNING: possible circular locking dependency detected
> 		6.1.0-20221027.rc2.git8.56bc5b569087.300.fc36.s390x+debug #1 Not tainted
> 		------------------------------------------------------
> 		kworker/3:0/176251 is trying to acquire lock:
> 		00000000f1467148 ((wq_completion)smc_tx_wq-00000000#2){+.+.}-{0:0},
> 			at: __flush_workqueue+0x7a/0x4f0
> 		but task is already holding lock:
> 		0000037fffe97dc8 ((work_completion)(&(&lgr->free_work)->work)){+.+.}-{0:0},
> 			at: process_one_work+0x232/0x730
> 		which lock already depends on the new lock.
> 		the existing dependency chain (in reverse order) is:
> 		-> #4 ((work_completion)(&(&lgr->free_work)->work)){+.+.}-{0:0}:
> 		       __lock_acquire+0x58e/0xbd8
> 		       lock_acquire.part.0+0xe2/0x248
> 		       lock_acquire+0xac/0x1c8
> 		       __flush_work+0x76/0xf0
> 		       __cancel_work_timer+0x170/0x220
> 		       __smc_lgr_terminate.part.0+0x34/0x1c0 [smc]
> 		       smc_connect_rdma+0x15e/0x418 [smc]
> 		       __smc_connect+0x234/0x480 [smc]
> 		       smc_connect+0x1d6/0x230 [smc]
> 		       __sys_connect+0x90/0xc0
> 		       __do_sys_socketcall+0x186/0x370
> 		       __do_syscall+0x1da/0x208
> 		       system_call+0x82/0xb0
> 		-> #3 (smc_client_lgr_pending){+.+.}-{3:3}:
> 		       __lock_acquire+0x58e/0xbd8
> 		       lock_acquire.part.0+0xe2/0x248
> 		       lock_acquire+0xac/0x1c8
> 		       __mutex_lock+0x96/0x8e8
> 		       mutex_lock_nested+0x32/0x40
> 		       smc_connect_rdma+0xa4/0x418 [smc]
> 		       __smc_connect+0x234/0x480 [smc]
> 		       smc_connect+0x1d6/0x230 [smc]
> 		       __sys_connect+0x90/0xc0
> 		       __do_sys_socketcall+0x186/0x370
> 		       __do_syscall+0x1da/0x208
> 		       system_call+0x82/0xb0
> 		-> #2 (sk_lock-AF_SMC){+.+.}-{0:0}:
> 		       __lock_acquire+0x58e/0xbd8
> 		       lock_acquire.part.0+0xe2/0x248
> 		       lock_acquire+0xac/0x1c8
> 		       lock_sock_nested+0x46/0xa8
> 		       smc_tx_work+0x34/0x50 [smc]
> 		       process_one_work+0x30c/0x730
> 		       worker_thread+0x62/0x420
> 		       kthread+0x138/0x150
> 		       __ret_from_fork+0x3c/0x58
> 		       ret_from_fork+0xa/0x40
> 		-> #1 ((work_completion)(&(&smc->conn.tx_work)->work)){+.+.}-{0:0}:
> 		       __lock_acquire+0x58e/0xbd8
> 		       lock_acquire.part.0+0xe2/0x248
> 		       lock_acquire+0xac/0x1c8
> 		       process_one_work+0x2bc/0x730
> 		       worker_thread+0x62/0x420
> 		       kthread+0x138/0x150
> 		       __ret_from_fork+0x3c/0x58
> 		       ret_from_fork+0xa/0x40
> 		-> #0 ((wq_completion)smc_tx_wq-00000000#2){+.+.}-{0:0}:
> 		       check_prev_add+0xd8/0xe88
> 		       validate_chain+0x70c/0xb20
> 		       __lock_acquire+0x58e/0xbd8
> 		       lock_acquire.part.0+0xe2/0x248
> 		       lock_acquire+0xac/0x1c8
> 		       __flush_workqueue+0xaa/0x4f0
> 		       drain_workqueue+0xaa/0x158
> 		       destroy_workqueue+0x44/0x2d8
> 		       smc_lgr_free+0x9e/0xf8 [smc]
> 		       process_one_work+0x30c/0x730
> 		       worker_thread+0x62/0x420
> 		       kthread+0x138/0x150
> 		       __ret_from_fork+0x3c/0x58
> 		       ret_from_fork+0xa/0x40
> 		other info that might help us debug this:
> 		Chain exists of:
> 		  (wq_completion)smc_tx_wq-00000000#2
> 	  	  --> smc_client_lgr_pending
> 		  --> (work_completion)(&(&lgr->free_work)->work)
> 		 Possible unsafe locking scenario:
> 		       CPU0                    CPU1
> 		       ----                    ----
> 		  lock((work_completion)(&(&lgr->free_work)->work));
> 		                   lock(smc_client_lgr_pending);
> 		                   lock((work_completion)
> 					(&(&lgr->free_work)->work));
> 		  lock((wq_completion)smc_tx_wq-00000000#2);
> 		 *** DEADLOCK ***
> 		2 locks held by kworker/3:0/176251:
> 		 #0: 0000000080183548
> 			((wq_completion)events){+.+.}-{0:0},
> 				at: process_one_work+0x232/0x730
> 		 #1: 0000037fffe97dc8
> 			((work_completion)
> 			 (&(&lgr->free_work)->work)){+.+.}-{0:0},
> 				at: process_one_work+0x232/0x730
> 		stack backtrace:
> 		CPU: 3 PID: 176251 Comm: kworker/3:0 Not tainted
> 		Hardware name: IBM 8561 T01 701 (z/VM 7.2.0)
> 		Call Trace:
> 		 [<000000002983c3e4>] dump_stack_lvl+0xac/0x100
> 		 [<0000000028b477ae>] check_noncircular+0x13e/0x160
> 		 [<0000000028b48808>] check_prev_add+0xd8/0xe88
> 		 [<0000000028b49cc4>] validate_chain+0x70c/0xb20
> 		 [<0000000028b4bd26>] __lock_acquire+0x58e/0xbd8
> 		 [<0000000028b4cf6a>] lock_acquire.part.0+0xe2/0x248
> 		 [<0000000028b4d17c>] lock_acquire+0xac/0x1c8
> 		 [<0000000028addaaa>] __flush_workqueue+0xaa/0x4f0
> 		 [<0000000028addf9a>] drain_workqueue+0xaa/0x158
> 		 [<0000000028ae303c>] destroy_workqueue+0x44/0x2d8
> 		 [<000003ff8029af26>] smc_lgr_free+0x9e/0xf8 [smc]
> 		 [<0000000028adf3d4>] process_one_work+0x30c/0x730
> 		 [<0000000028adf85a>] worker_thread+0x62/0x420
> 		 [<0000000028aeac50>] kthread+0x138/0x150
> 		 [<0000000028a63914>] __ret_from_fork+0x3c/0x58
> 		 [<00000000298503da>] ret_from_fork+0xa/0x40
> 		INFO: lockdep is turned off.
> ===================================================================
> 
> This deadlock occurs because cancel_delayed_work_sync() waits for
> the work(&lgr->free_work) to finish, while the &lgr->free_work
> waits for the work(lgr->tx_wq), which needs the sk_lock-AF_SMC, that
> is already used under the mutex_lock.
> 
> The solution is to use cancel_delayed_work() instead, which kills
> off a pending work.
> 
> Fixes: a52bcc919b14 ("net/smc: improve termination processing")
> Signed-off-by: Wenjia Zhang <wenjia@linux.ibm.com>
> Reviewed-by: Jan Karcher <jaka@linux.ibm.com>
> Reviewed-by: Karsten Graul <kgraul@linux.ibm.com>

Thanks Wenjia, LGTM.

Reviewed-by: Tony Lu <tonylu@linux.alibaba.com>

> ---
>  net/smc/smc_core.c | 2 +-
>  1 file changed, 1 insertion(+), 1 deletion(-)
> 
> diff --git a/net/smc/smc_core.c b/net/smc/smc_core.c
> index d52060b2680c..454356771cda 100644
> --- a/net/smc/smc_core.c
> +++ b/net/smc/smc_core.c
> @@ -1464,7 +1464,7 @@ static void __smc_lgr_terminate(struct smc_link_group *lgr, bool soft)
>  	if (lgr->terminating)
>  		return;	/* lgr already terminating */
>  	/* cancel free_work sync, will terminate when lgr->freeing is set */
> -	cancel_delayed_work_sync(&lgr->free_work);
> +	cancel_delayed_work(&lgr->free_work);
>  	lgr->terminating = 1;
>  
>  	/* kill remaining link group connections */
> -- 
> 2.37.2
