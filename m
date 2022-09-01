Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id D4B565A96BF
	for <lists+netdev@lfdr.de>; Thu,  1 Sep 2022 14:27:48 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233550AbiIAM1i (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 1 Sep 2022 08:27:38 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:45440 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233542AbiIAM1L (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 1 Sep 2022 08:27:11 -0400
Received: from corp-front10-corp.i.nease.net (corp-front10-corp.i.nease.net [42.186.62.104])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 6BE361299E6;
        Thu,  1 Sep 2022 05:26:56 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=corp.netease.com; s=s210401; h=Received:From:To:Cc:Subject:
        Date:Message-Id:In-Reply-To:References:MIME-Version:
        Content-Transfer-Encoding; bh=dsgO1pTu9V7tw3lv2GpNyG8eLdMIvx7w+4
        467mn+OLA=; b=Yg8vihwjRltNbFq4Jf+1fU/nf2ydsOzZhBEeXfnqzBWvszmrT7
        2smHvwnjcId61VSlflRmGAbjM9q+ZNuYhQXo+d1tLkaI6qtqJ1RhHC3FugQHSGIK
        iiiFm7diRA/fcH0YbOw5Y0N8mHmOQ7u/sQ9MW5U+rGvHJcRMSqh9dqghw=
Received: from pubt1-k8s74.yq.163.org (unknown [115.238.122.38])
        by corp-front10-corp.i.nease.net (Coremail) with SMTP id aIG_CgCn9ef5pBBjilwiAA--.40527S2;
        Thu, 01 Sep 2022 20:26:33 +0800 (HKT)
From:   liuyacan@corp.netease.com
To:     wenjia@linux.ibm.com, alibuda@linux.alibaba.com
Cc:     davem@davemloft.net, edumazet@google.com, kgraul@linux.ibm.com,
        kuba@kernel.org, linux-kernel@vger.kernel.org,
        linux-s390@vger.kernel.org, liuyacan@corp.netease.com,
        netdev@vger.kernel.org, pabeni@redhat.com,
        tonylu@linux.alibaba.com, ubraun@linux.vnet.ibm.com,
        wintera@linux.ibm.com
Subject: Re: [PATCH net v4] net/smc: Fix possible access to freed memory in link clear
Date:   Thu,  1 Sep 2022 20:26:33 +0800
Message-Id: <20220901122633.1657859-1-liuyacan@corp.netease.com>
X-Mailer: git-send-email 2.20.1
In-Reply-To: <04dbfe8a-a023-c6cf-8d20-965859c1d33a@linux.ibm.com>
References: <04dbfe8a-a023-c6cf-8d20-965859c1d33a@linux.ibm.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-CM-TRANSID: aIG_CgCn9ef5pBBjilwiAA--.40527S2
X-Coremail-Antispam: 1UD129KBjvJXoW3ArW8Ww18WFW7uFy7Kw4kZwb_yoW3Gw1fpF
        s7WF47CF48Xr1UXFn5AF1xZF1Yq3W2yFy8Gr929F9YyFnxJw18JF1Sgry2vFyDAr4qg3WI
        v348Xw1Ikrs8XaDanT9S1TB71UUUUUUqnTZGkaVYY2UrUUUUjbIjqfuFe4nvWSU5nxnvy2
        9KBjDU0xBIdaVrnRJUUUXab7IF0VCFI7km07C26c804VAKzcIF0wAFF20E14v26r4j6ryU
        M7CY07I20VC2zVCF04k26cxKx2IYs7xG6rWj6s0DM7CIcVAFz4kK6r1j6r18M28lY4IEw2
        IIxxk0rwA2F7IY1VAKz4vEj48ve4kI8wA2z4x0Y4vE2Ix0cI8IcVAFwI0_tr0E3s1l84AC
        jcxK6xIIjxv20xvEc7CjxVAFwI0_Cr1j6rxdM28EF7xvwVC2z280aVAFwI0_GcCE3s1l84
        ACjcxK6I8E87Iv6xkF7I0E14v26rxl6s0DM2kK67ZEXf0FJ3sC6x9vy-n0Xa0_Xr1Utr1k
        JwI_Jr4ln4vEF7Iv6F18KVAqrcv_GVWUtr1rJF1ln4vEF7Iv6F18KVAqrcv_XVWUtr1rJF
        1ln4vE4IxY62xKV4CY8xCE548m6r4UJryUGwAa7VCY0VAaVVAqrcv_Jw1UWr13M2AIxVAI
        cxkEcVAq07x20xvEncxIr21l57IF6s8CjcxG0xyl5I8CrVACY4xI64kE6c02F40Ex7xfMc
        Ij6xIIjxv20xvE14v26r1j6r18McIj6I8E87Iv67AKxVWUJVW8JwAm72CE4IkC6x0Yz7v_
        Jr0_Gr1lF7xvr2IYc2Ij64vIr41lF7I21c0EjII2zVCS5cI20VAGYxC7M4IIrI8v6xkF7I
        0E8cxan2IY04v7M4kE6xkIj40Ew7xC0wCjxxvEw4Wlc2IjII80xcxEwVAKI48JMxAIw28I
        cxkI7VAKI48JMxCjnVAK0II2c7xJMxC20s026xCaFVCjc4AY6r1j6r4UMxCIbVAxMI8I3I
        0E5I8CrVAFwI0_Jr0_Jr4lx2IqxVCjr7xvwVAFwI0_JrI_JrWlx4CE17CEb7AF67AKxVWU
        tVW8ZwCIc40Y0x0EwIxGrwCI42IY6xIIjxv20xvE14v26r1j6r1xMIIF0xvE2Ix0cI8IcV
        CY1x0267AKxVW8JVWxJwCI42IY6xAIw20EY4v20xvaj40_Jr0_JF4lIxAIcVC2z280aVAF
        wI0_Jr0_Gr1lIxAIcVC2z280aVCY1x0267AKxVW8JVW8JrUvcSsGvfC2KfnxnUUI43ZEXa
        7sRiE_M7UUUUU==
X-CM-SenderInfo: 5olx5txfdqquhrush05hwht23hof0z/1tbiBQAQCVt77zCWdAATsS
X-Spam-Status: No, score=-2.0 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_PASS,
        T_SCC_BODY_TEXT_LINE autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

> > From: Yacan Liu <liuyacan@corp.netease.com>
> > 
> > After modifying the QP to the Error state, all RX WR would be completed
> > with WC in IB_WC_WR_FLUSH_ERR status. Current implementation does not
> > wait for it is done, but destroy the QP and free the link group directly.
> > So there is a risk that accessing the freed memory in tasklet context.
> > 
> > Here is a crash example:
> > 
> >   BUG: unable to handle page fault for address: ffffffff8f220860
> >   #PF: supervisor write access in kernel mode
> >   #PF: error_code(0x0002) - not-present page
> >   PGD f7300e067 P4D f7300e067 PUD f7300f063 PMD 8c4e45063 PTE 800ffff08c9df060
> >   Oops: 0002 [#1] SMP PTI
> >   CPU: 1 PID: 0 Comm: swapper/1 Kdump: loaded Tainted: G S         OE     5.10.0-0607+ #23
> >   Hardware name: Inspur NF5280M4/YZMB-00689-101, BIOS 4.1.20 07/09/2018
> >   RIP: 0010:native_queued_spin_lock_slowpath+0x176/0x1b0
> >   Code: f3 90 48 8b 32 48 85 f6 74 f6 eb d5 c1 ee 12 83 e0 03 83 ee 01 48 c1 e0 05 48 63 f6 48 05 00 c8 02 00 48 03 04 f5 00 09 98 8e <48> 89 10 8b 42 08 85 c0 75 09 f3 90 8b 42 08 85 c0 74 f7 48 8b 32
> >   RSP: 0018:ffffb3b6c001ebd8 EFLAGS: 00010086
> >   RAX: ffffffff8f220860 RBX: 0000000000000246 RCX: 0000000000080000
> >   RDX: ffff91db1f86c800 RSI: 000000000000173c RDI: ffff91db62bace00
> >   RBP: ffff91db62bacc00 R08: 0000000000000000 R09: c00000010000028b
> >   R10: 0000000000055198 R11: ffffb3b6c001ea58 R12: ffff91db80e05010
> >   R13: 000000000000000a R14: 0000000000000006 R15: 0000000000000040
> >   FS:  0000000000000000(0000) GS:ffff91db1f840000(0000) knlGS:0000000000000000
> >   CS:  0010 DS: 0000 ES: 0000 CR0: 0000000080050033
> >   CR2: ffffffff8f220860 CR3: 00000001f9580004 CR4: 00000000003706e0
> >   DR0: 0000000000000000 DR1: 0000000000000000 DR2: 0000000000000000
> >   DR3: 0000000000000000 DR6: 00000000fffe0ff0 DR7: 0000000000000400
> >   Call Trace:
> >    <IRQ>
> >    _raw_spin_lock_irqsave+0x30/0x40
> >    mlx5_ib_poll_cq+0x4c/0xc50 [mlx5_ib]
> >    smc_wr_rx_tasklet_fn+0x56/0xa0 [smc]
> >    tasklet_action_common.isra.21+0x66/0x100
> >    __do_softirq+0xd5/0x29c
> >    asm_call_irq_on_stack+0x12/0x20
> >    </IRQ>
> >    do_softirq_own_stack+0x37/0x40
> >    irq_exit_rcu+0x9d/0xa0
> >    sysvec_call_function_single+0x34/0x80
> >    asm_sysvec_call_function_single+0x12/0x20
> > 
> > Fixes: bd4ad57718cc ("smc: initialize IB transport incl. PD, MR, QP, CQ, event, WR")
> > Signed-off-by: Yacan Liu <liuyacan@corp.netease.com>
> > 
> > ---
> > Chagen in v4:
> >    -- Remove the rx_drain flag because smc_wr_rx_post() may not have been called.
> >    -- Remove timeout.
> > Change in v3:
> >    -- Tune commit message (Signed-Off tag, Fixes tag).
> >       Tune code to avoid column length exceeding.
> > Change in v2:
> >    -- Fix some compile warnings and errors.
> > ---
> >   net/smc/smc_core.c | 2 ++
> >   net/smc/smc_core.h | 2 ++
> >   net/smc/smc_wr.c   | 9 +++++++++
> >   net/smc/smc_wr.h   | 1 +
> >   4 files changed, 14 insertions(+)
> > 
> > diff --git a/net/smc/smc_core.c b/net/smc/smc_core.c
> > index ff49a11f5..f92a916e9 100644
> > --- a/net/smc/smc_core.c
> > +++ b/net/smc/smc_core.c
> > @@ -757,6 +757,7 @@ int smcr_link_init(struct smc_link_group *lgr, struct smc_link *lnk,
> >   	lnk->lgr = lgr;
> >   	smc_lgr_hold(lgr); /* lgr_put in smcr_link_clear() */
> >   	lnk->link_idx = link_idx;
> > +	lnk->wr_rx_id_compl = 0;
> >   	smc_ibdev_cnt_inc(lnk);
> >   	smcr_copy_dev_info_to_link(lnk);
> >   	atomic_set(&lnk->conn_cnt, 0);
> > @@ -1269,6 +1270,7 @@ void smcr_link_clear(struct smc_link *lnk, bool log)
> >   	smcr_buf_unmap_lgr(lnk);
> >   	smcr_rtoken_clear_link(lnk);
> >   	smc_ib_modify_qp_error(lnk);
> > +	smc_wr_drain_cq(lnk);
> >   	smc_wr_free_link(lnk);
> >   	smc_ib_destroy_queue_pair(lnk);
> >   	smc_ib_dealloc_protection_domain(lnk);
> > diff --git a/net/smc/smc_core.h b/net/smc/smc_core.h
> > index fe8b524ad..285f9bd8e 100644
> > --- a/net/smc/smc_core.h
> > +++ b/net/smc/smc_core.h
> > @@ -115,8 +115,10 @@ struct smc_link {
> >   	dma_addr_t		wr_rx_dma_addr;	/* DMA address of wr_rx_bufs */
> >   	dma_addr_t		wr_rx_v2_dma_addr; /* DMA address of v2 rx buf*/
> >   	u64			wr_rx_id;	/* seq # of last recv WR */
> > +	u64			wr_rx_id_compl; /* seq # of last completed WR */
> >   	u32			wr_rx_cnt;	/* number of WR recv buffers */
> >   	unsigned long		wr_rx_tstamp;	/* jiffies when last buf rx */
> > +	wait_queue_head_t       wr_rx_empty_wait; /* wait for RQ empty */
> >   
> >   	struct ib_reg_wr	wr_reg;		/* WR register memory region */
> >   	wait_queue_head_t	wr_reg_wait;	/* wait for wr_reg result */
> > diff --git a/net/smc/smc_wr.c b/net/smc/smc_wr.c
> > index 26f8f240d..bc8793803 100644
> > --- a/net/smc/smc_wr.c
> > +++ b/net/smc/smc_wr.c
> > @@ -454,6 +454,7 @@ static inline void smc_wr_rx_process_cqes(struct ib_wc wc[], int num)
> >   
> >   	for (i = 0; i < num; i++) {
> >   		link = wc[i].qp->qp_context;
> > +		link->wr_rx_id_compl = wc[i].wr_id;
> >   		if (wc[i].status == IB_WC_SUCCESS) {
> >   			link->wr_rx_tstamp = jiffies;
> >   			smc_wr_rx_demultiplex(&wc[i]);
> > @@ -465,6 +466,8 @@ static inline void smc_wr_rx_process_cqes(struct ib_wc wc[], int num)
> >   			case IB_WC_RNR_RETRY_EXC_ERR:
> >   			case IB_WC_WR_FLUSH_ERR:
> >   				smcr_link_down_cond_sched(link);
> > +				if (link->wr_rx_id_compl == link->wr_rx_id)
> > +					wake_up(&link->wr_rx_empty_wait);
> >   				break;
> >   			default:
> >   				smc_wr_rx_post(link); /* refill WR RX */
> > @@ -631,6 +634,11 @@ static void smc_wr_init_sge(struct smc_link *lnk)
> >   	lnk->wr_reg.access = IB_ACCESS_LOCAL_WRITE | IB_ACCESS_REMOTE_WRITE;
> >   }
> >   
> > +void smc_wr_drain_cq(struct smc_link *lnk)
> > +{
> > +	wait_event(lnk->wr_rx_empty_wait, lnk->wr_rx_id_compl == lnk->wr_rx_id);
> > +}
> > +
> >   void smc_wr_free_link(struct smc_link *lnk)
> >   {
> >   	struct ib_device *ibdev;
> > @@ -889,6 +897,7 @@ int smc_wr_create_link(struct smc_link *lnk)
> >   	atomic_set(&lnk->wr_tx_refcnt, 0);
> >   	init_waitqueue_head(&lnk->wr_reg_wait);
> >   	atomic_set(&lnk->wr_reg_refcnt, 0);
> > +	init_waitqueue_head(&lnk->wr_rx_empty_wait);
> >   	return rc;
> >   
> >   dma_unmap:
> > diff --git a/net/smc/smc_wr.h b/net/smc/smc_wr.h
> > index a54e90a11..5ca5086ae 100644
> > --- a/net/smc/smc_wr.h
> > +++ b/net/smc/smc_wr.h
> > @@ -101,6 +101,7 @@ static inline int smc_wr_rx_post(struct smc_link *link)
> >   int smc_wr_create_link(struct smc_link *lnk);
> >   int smc_wr_alloc_link_mem(struct smc_link *lnk);
> >   int smc_wr_alloc_lgr_mem(struct smc_link_group *lgr);
> > +void smc_wr_drain_cq(struct smc_link *lnk);
> >   void smc_wr_free_link(struct smc_link *lnk);
> >   void smc_wr_free_link_mem(struct smc_link *lnk);
> >   void smc_wr_free_lgr_mem(struct smc_link_group *lgr);
> 
> Thank you @Yacan for the effort to improve our code! And Thank you @Tony 
> for such valuable suggestions and testing!
> I like the modification of this version. However, this is not a fix 
> patch to upstream, since the patches "[PATCH net-next v2 00/10] optimize 
> the parallelism of SMC-R connections" are still not applied. My 
> sugguestions:
> - Please talk to the author (D. Wythe <alibuda@linux.alibaba.com>) of 
> those patches I mentioned above, and ask if he can take your patch as a 
> part of the patch serie
> - Fix patches should go to net-next
> - Please send always send your new version separately, rather than as 
> reply to your previous version. That makes people confused.

@Wenjia, Thanks a lot for your suggestions and guidance ! 

@D. Wythe, Can you include this patch in your series of patches if it is 
convenient?

Regards,
Yacan

