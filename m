Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 143375AC52A
	for <lists+netdev@lfdr.de>; Sun,  4 Sep 2022 17:58:27 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234697AbiIDP6Z (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sun, 4 Sep 2022 11:58:25 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:51036 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S234631AbiIDP6X (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sun, 4 Sep 2022 11:58:23 -0400
Received: from out30-130.freemail.mail.aliyun.com (out30-130.freemail.mail.aliyun.com [115.124.30.130])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id DB1642F38E;
        Sun,  4 Sep 2022 08:58:15 -0700 (PDT)
X-Alimail-AntiSpam: AC=PASS;BC=-1|-1;BR=01201311R101e4;CH=green;DM=||false|;DS=||;FP=0|-1|-1|-1|0|-1|-1|-1;HT=ay29a033018045192;MF=tonylu@linux.alibaba.com;NM=1;PH=DS;RN=12;SR=0;TI=SMTPD_---0VOGfxpk_1662307089;
Received: from localhost(mailfrom:tonylu@linux.alibaba.com fp:SMTPD_---0VOGfxpk_1662307089)
          by smtp.aliyun-inc.com;
          Sun, 04 Sep 2022 23:58:10 +0800
Date:   Sun, 4 Sep 2022 23:58:09 +0800
From:   Tony Lu <tonylu@linux.alibaba.com>
To:     liuyacan@corp.netease.com
Cc:     davem@davemloft.net, edumazet@google.com, kgraul@linux.ibm.com,
        kuba@kernel.org, linux-kernel@vger.kernel.org,
        linux-s390@vger.kernel.org, netdev@vger.kernel.org,
        ubraun@linux.vnet.ibm.com, pabeni@redhat.com, wenjia@linux.ibm.com,
        wintera@linux.ibm.com
Subject: Re: [PATCH net v4] net/smc: Fix possible access to freed memory in
 link clear
Message-ID: <YxTLEakKhpge8T/3@TonyMac-Alibaba>
Reply-To: Tony Lu <tonylu@linux.alibaba.com>
References: <Yw4bgV6c0LQ6reMc@TonyMac-Alibaba>
 <20220831155303.1758868-1-liuyacan@corp.netease.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20220831155303.1758868-1-liuyacan@corp.netease.com>
X-Spam-Status: No, score=-9.9 required=5.0 tests=BAYES_00,
        ENV_AND_HDR_SPF_MATCH,RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_PASS,
        T_SCC_BODY_TEXT_LINE,UNPARSEABLE_RELAY,USER_IN_DEF_SPF_WL
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Wed, Aug 31, 2022 at 11:53:03PM +0800, liuyacan@corp.netease.com wrote:
> From: Yacan Liu <liuyacan@corp.netease.com>
> 
> After modifying the QP to the Error state, all RX WR would be completed
> with WC in IB_WC_WR_FLUSH_ERR status. Current implementation does not
> wait for it is done, but destroy the QP and free the link group directly.
> So there is a risk that accessing the freed memory in tasklet context.
> 
> Here is a crash example:
> 
>  BUG: unable to handle page fault for address: ffffffff8f220860
>  #PF: supervisor write access in kernel mode
>  #PF: error_code(0x0002) - not-present page
>  PGD f7300e067 P4D f7300e067 PUD f7300f063 PMD 8c4e45063 PTE 800ffff08c9df060
>  Oops: 0002 [#1] SMP PTI
>  CPU: 1 PID: 0 Comm: swapper/1 Kdump: loaded Tainted: G S         OE     5.10.0-0607+ #23
>  Hardware name: Inspur NF5280M4/YZMB-00689-101, BIOS 4.1.20 07/09/2018
>  RIP: 0010:native_queued_spin_lock_slowpath+0x176/0x1b0
>  Code: f3 90 48 8b 32 48 85 f6 74 f6 eb d5 c1 ee 12 83 e0 03 83 ee 01 48 c1 e0 05 48 63 f6 48 05 00 c8 02 00 48 03 04 f5 00 09 98 8e <48> 89 10 8b 42 08 85 c0 75 09 f3 90 8b 42 08 85 c0 74 f7 48 8b 32
>  RSP: 0018:ffffb3b6c001ebd8 EFLAGS: 00010086
>  RAX: ffffffff8f220860 RBX: 0000000000000246 RCX: 0000000000080000
>  RDX: ffff91db1f86c800 RSI: 000000000000173c RDI: ffff91db62bace00
>  RBP: ffff91db62bacc00 R08: 0000000000000000 R09: c00000010000028b
>  R10: 0000000000055198 R11: ffffb3b6c001ea58 R12: ffff91db80e05010
>  R13: 000000000000000a R14: 0000000000000006 R15: 0000000000000040
>  FS:  0000000000000000(0000) GS:ffff91db1f840000(0000) knlGS:0000000000000000
>  CS:  0010 DS: 0000 ES: 0000 CR0: 0000000080050033
>  CR2: ffffffff8f220860 CR3: 00000001f9580004 CR4: 00000000003706e0
>  DR0: 0000000000000000 DR1: 0000000000000000 DR2: 0000000000000000
>  DR3: 0000000000000000 DR6: 00000000fffe0ff0 DR7: 0000000000000400
>  Call Trace:
>   <IRQ>
>   _raw_spin_lock_irqsave+0x30/0x40
>   mlx5_ib_poll_cq+0x4c/0xc50 [mlx5_ib]
>   smc_wr_rx_tasklet_fn+0x56/0xa0 [smc]
>   tasklet_action_common.isra.21+0x66/0x100
>   __do_softirq+0xd5/0x29c
>   asm_call_irq_on_stack+0x12/0x20
>   </IRQ>
>   do_softirq_own_stack+0x37/0x40
>   irq_exit_rcu+0x9d/0xa0
>   sysvec_call_function_single+0x34/0x80
>   asm_sysvec_call_function_single+0x12/0x20
> 
> Fixes: bd4ad57718cc ("smc: initialize IB transport incl. PD, MR, QP, CQ, event, WR")
> Signed-off-by: Yacan Liu <liuyacan@corp.netease.com>
> 
> ---
> Chagen in v4:
>   -- Remove the rx_drain flag because smc_wr_rx_post() may not have been called.
>   -- Remove timeout.
> Change in v3:
>   -- Tune commit message (Signed-Off tag, Fixes tag).
>      Tune code to avoid column length exceeding.
> Change in v2:
>   -- Fix some compile warnings and errors.
> ---
>  net/smc/smc_core.c | 2 ++
>  net/smc/smc_core.h | 2 ++
>  net/smc/smc_wr.c   | 9 +++++++++
>  net/smc/smc_wr.h   | 1 +
>  4 files changed, 14 insertions(+)
> 
> diff --git a/net/smc/smc_core.c b/net/smc/smc_core.c
> index ff49a11f5..f92a916e9 100644
> --- a/net/smc/smc_core.c
> +++ b/net/smc/smc_core.c
> @@ -757,6 +757,7 @@ int smcr_link_init(struct smc_link_group *lgr, struct smc_link *lnk,
>  	lnk->lgr = lgr;
>  	smc_lgr_hold(lgr); /* lgr_put in smcr_link_clear() */
>  	lnk->link_idx = link_idx;
> +	lnk->wr_rx_id_compl = 0;
>  	smc_ibdev_cnt_inc(lnk);
>  	smcr_copy_dev_info_to_link(lnk);
>  	atomic_set(&lnk->conn_cnt, 0);
> @@ -1269,6 +1270,7 @@ void smcr_link_clear(struct smc_link *lnk, bool log)
>  	smcr_buf_unmap_lgr(lnk);
>  	smcr_rtoken_clear_link(lnk);
>  	smc_ib_modify_qp_error(lnk);
> +	smc_wr_drain_cq(lnk);

smc_wr_drain_cq() can put into smc_wr_free_link(). Since
smc_wr_free_link() do the same things together, such as waiting for
resources cleaning up about wr.

>  	smc_wr_free_link(lnk);
>  	smc_ib_destroy_queue_pair(lnk);
>  	smc_ib_dealloc_protection_domain(lnk);

<snip>

The patch tested good in our environment. If you are going to send the
v5 patch, you can go with my review.

Reviewed-by: Tony Lu <tonylu@linux.alibaba.com>

Cheers,
Tony Lu
