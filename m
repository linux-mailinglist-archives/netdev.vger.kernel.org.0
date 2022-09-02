Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 993EE5AA583
	for <lists+netdev@lfdr.de>; Fri,  2 Sep 2022 04:17:21 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233170AbiIBCRT (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 1 Sep 2022 22:17:19 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:58728 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229804AbiIBCRR (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 1 Sep 2022 22:17:17 -0400
Received: from corp-front10-corp.i.nease.net (corp-front11-corp.i.nease.net [42.186.62.105])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 2B7C66B147;
        Thu,  1 Sep 2022 19:17:13 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=corp.netease.com; s=s210401; h=Received:From:To:Cc:Subject:
        Date:Message-Id:In-Reply-To:References:MIME-Version:
        Content-Transfer-Encoding; bh=Xv0tpbjR+TGeMaQAbbbttwx5JVaK+IeIer
        tlgfgd9eA=; b=AtPsxkfjjceA6pEx0gR5dGc072fi21RYg+g6M6If0cnL7Oeu4V
        E3XJYgnShZkvw9pgOGRz7F9JnShqGkMCpWsQrp4XmS+dxBZEMA/ynwo4STuGDp1b
        b4zqW6TMwXKSZaRxPG8bfvEn1wnjAyRq6lR7vUYguD7bY6z/m2S/2fYAI=
Received: from pubt1-k8s74.yq.163.org (unknown [115.238.122.38])
        by corp-front11-corp.i.nease.net (Coremail) with SMTP id aYG_CgCnvDWTZxFj+L0iAA--.52995S2;
        Fri, 02 Sep 2022 10:16:51 +0800 (HKT)
From:   liuyacan@corp.netease.com
To:     wenjia@linux.ibm.com
Cc:     alibuda@linux.alibaba.com, davem@davemloft.net,
        edumazet@google.com, kgraul@linux.ibm.com, kuba@kernel.org,
        linux-kernel@vger.kernel.org, linux-s390@vger.kernel.org,
        liuyacan@corp.netease.com, netdev@vger.kernel.org,
        pabeni@redhat.com, tonylu@linux.alibaba.com,
        ubraun@linux.vnet.ibm.com, wintera@linux.ibm.com
Subject: Re: [PATCH net v4] net/smc: Fix possible access to freed memory in link clear
Date:   Fri,  2 Sep 2022 10:16:51 +0800
Message-Id: <20220902021651.2552128-1-liuyacan@corp.netease.com>
X-Mailer: git-send-email 2.20.1
In-Reply-To: <5b65eb6b-5ab2-1e6c-10d6-c25e66fa82f4@linux.ibm.com>
References: <5b65eb6b-5ab2-1e6c-10d6-c25e66fa82f4@linux.ibm.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-CM-TRANSID: aYG_CgCnvDWTZxFj+L0iAA--.52995S2
X-Coremail-Antispam: 1UD129KBjvJXoW3ArWUKrWkGr1kuryxury3urg_yoWfAr18pF
        WUJF42kr48Xr1UXF1jvF10vFn8tw12yF1kWr97KF1rAFn8t3WUJF1Sqr1j9FyDJr4qg3WI
        vry8Jw1Skrn8J3DanT9S1TB71UUUUUUqnTZGkaVYY2UrUUUUjbIjqfuFe4nvWSU5nxnvy2
        9KBjDU0xBIdaVrnRJUUUXIb7IF0VCFI7km07C26c804VAKzcIF0wAFF20E14v26r4j6ryU
        M7CY07I20VC2zVCF04k26cxKx2IYs7xG6rWj6s0DM7CIcVAFz4kK6r1j6r18M28lY4IEw2
        IIxxk0rwA2F7IY1VAKz4vEj48ve4kI8wA2z4x0Y4vE2Ix0cI8IcVAFwI0_tr0E3s1l84AC
        jcxK6xIIjxv20xvEc7CjxVAFwI0_GcCE3s1l84ACjcxK6I8E87Iv67AKxVW0oVCq3wA2z4
        x0Y4vEx4A2jsIEc7CjxVAFwI0_GcCE3s1ln4vE1TuYJxujqTIEc-sFP3VYkVW5Jr1DJw4U
        KVWUGwAawVACjsI_Ar4v6c8GOVW06r1DJrWUAwAawVACjsI_Ar4v6c8GOVWY6r1DJrWUAw
        AawVCFI7vE04vSzxk24VAqrcv_Gr1UXr18M2vj6xkI62vS6c8GOVWUtr1rJFyle2I262IY
        c4CY6c8Ij28IcVAaY2xG8wAqjxCE34x0Y48IcwAqx4xG64xvF2IEw4CE5I8CrVC2j2WlYx
        0E2Ix0cI8IcVAFwI0_Jr0_Jr4lYx0Ex4A2jsIE14v26r1j6r4UMcvjeVCFs4IE7xkEbVWU
        JVW8JwACjcxG0xvY0x0EwIxGrwACjI8F5VA0II8E6IAqYI8I648v4I1lFIxGxcIEc7CjxV
        A2Y2ka0xkIwI1lw4CEc2x0rVAKj4xxMx02cVAKzwCY0x0Ix7I2Y4AK64vIr41l42xK82IY
        c2Ij64vIr41l4x8a64kIII0Yj41l4I8I3I0E4IkC6x0Yz7v_Jr0_Gr1l4IxY624lx2IqxV
        Aqx4xG67AKxVWUJVWUGwC20s026x8GjcxK67AKxVWUGVWUWwC2zVAF1VAY17CE14v26r1q
        6r43MIIYrxkI7VAKI48JMIIF0xvE2Ix0cI8IcVAFwI0_Jr0_JF4lIxAIcVC0I7IYx2IY6x
        kF7I0E14v26r4j6F4UMIIF0xvE42xK8VAvwI8IcIk0rVWUJVWUCwCI42IY6I8E87Iv67AK
        xVWUJVW8JwCI42IY6I8E87Iv6xkF7I0E14v26r4j6r4UJbIYCTnIWIevJa73UjIFyTuYvj
        TRMuWlUUUUU
X-CM-SenderInfo: 5olx5txfdqquhrush05hwht23hof0z/1tbiBQARCVt77zbapwADsa
X-Spam-Status: No, score=-2.0 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_PASS,
        T_SCC_BODY_TEXT_LINE autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

> >>>>> From: Yacan Liu <liuyacan@corp.netease.com>
> >>>>>
> >>>>> After modifying the QP to the Error state, all RX WR would be completed
> >>>>> with WC in IB_WC_WR_FLUSH_ERR status. Current implementation does not
> >>>>> wait for it is done, but destroy the QP and free the link group directly.
> >>>>> So there is a risk that accessing the freed memory in tasklet context.
> >>>>>
> >>>>> Here is a crash example:
> >>>>>
> >>>>>     BUG: unable to handle page fault for address: ffffffff8f220860
> >>>>>     #PF: supervisor write access in kernel mode
> >>>>>     #PF: error_code(0x0002) - not-present page
> >>>>>     PGD f7300e067 P4D f7300e067 PUD f7300f063 PMD 8c4e45063 PTE 800ffff08c9df060
> >>>>>     Oops: 0002 [#1] SMP PTI
> >>>>>     CPU: 1 PID: 0 Comm: swapper/1 Kdump: loaded Tainted: G S         OE     5.10.0-0607+ #23
> >>>>>     Hardware name: Inspur NF5280M4/YZMB-00689-101, BIOS 4.1.20 07/09/2018
> >>>>>     RIP: 0010:native_queued_spin_lock_slowpath+0x176/0x1b0
> >>>>>     Code: f3 90 48 8b 32 48 85 f6 74 f6 eb d5 c1 ee 12 83 e0 03 83 ee 01 48 c1 e0 05 48 63 f6 48 05 00 c8 02 00 48 03 04 f5 00 09 98 8e <48> 89 10 8b 42 08 85 c0 75 09 f3 90 8b 42 08 85 c0 74 f7 48 8b 32
> >>>>>     RSP: 0018:ffffb3b6c001ebd8 EFLAGS: 00010086
> >>>>>     RAX: ffffffff8f220860 RBX: 0000000000000246 RCX: 0000000000080000
> >>>>>     RDX: ffff91db1f86c800 RSI: 000000000000173c RDI: ffff91db62bace00
> >>>>>     RBP: ffff91db62bacc00 R08: 0000000000000000 R09: c00000010000028b
> >>>>>     R10: 0000000000055198 R11: ffffb3b6c001ea58 R12: ffff91db80e05010
> >>>>>     R13: 000000000000000a R14: 0000000000000006 R15: 0000000000000040
> >>>>>     FS:  0000000000000000(0000) GS:ffff91db1f840000(0000) knlGS:0000000000000000
> >>>>>     CS:  0010 DS: 0000 ES: 0000 CR0: 0000000080050033
> >>>>>     CR2: ffffffff8f220860 CR3: 00000001f9580004 CR4: 00000000003706e0
> >>>>>     DR0: 0000000000000000 DR1: 0000000000000000 DR2: 0000000000000000
> >>>>>     DR3: 0000000000000000 DR6: 00000000fffe0ff0 DR7: 0000000000000400
> >>>>>     Call Trace:
> >>>>>      <IRQ>
> >>>>>      _raw_spin_lock_irqsave+0x30/0x40
> >>>>>      mlx5_ib_poll_cq+0x4c/0xc50 [mlx5_ib]
> >>>>>      smc_wr_rx_tasklet_fn+0x56/0xa0 [smc]
> >>>>>      tasklet_action_common.isra.21+0x66/0x100
> >>>>>      __do_softirq+0xd5/0x29c
> >>>>>      asm_call_irq_on_stack+0x12/0x20
> >>>>>      </IRQ>
> >>>>>      do_softirq_own_stack+0x37/0x40
> >>>>>      irq_exit_rcu+0x9d/0xa0
> >>>>>      sysvec_call_function_single+0x34/0x80
> >>>>>      asm_sysvec_call_function_single+0x12/0x20
> >>>>>
> >>>>> Fixes: bd4ad57718cc ("smc: initialize IB transport incl. PD, MR, QP, CQ, event, WR")
> >>>>> Signed-off-by: Yacan Liu <liuyacan@corp.netease.com>
> >>>>>
> >>>>> ---
> >>>>> Chagen in v4:
> >>>>>      -- Remove the rx_drain flag because smc_wr_rx_post() may not have been called.
> >>>>>      -- Remove timeout.
> >>>>> Change in v3:
> >>>>>      -- Tune commit message (Signed-Off tag, Fixes tag).
> >>>>>         Tune code to avoid column length exceeding.
> >>>>> Change in v2:
> >>>>>      -- Fix some compile warnings and errors.
> >>>>> ---
> >>>>>     net/smc/smc_core.c | 2 ++
> >>>>>     net/smc/smc_core.h | 2 ++
> >>>>>     net/smc/smc_wr.c   | 9 +++++++++
> >>>>>     net/smc/smc_wr.h   | 1 +
> >>>>>     4 files changed, 14 insertions(+)
> >>>>>
> >>>>> diff --git a/net/smc/smc_core.c b/net/smc/smc_core.c
> >>>>> index ff49a11f5..f92a916e9 100644
> >>>>> --- a/net/smc/smc_core.c
> >>>>> +++ b/net/smc/smc_core.c
> >>>>> @@ -757,6 +757,7 @@ int smcr_link_init(struct smc_link_group *lgr, struct smc_link *lnk,
> >>>>>     	lnk->lgr = lgr;
> >>>>>     	smc_lgr_hold(lgr); /* lgr_put in smcr_link_clear() */
> >>>>>     	lnk->link_idx = link_idx;
> >>>>> +	lnk->wr_rx_id_compl = 0;
> >>>>>     	smc_ibdev_cnt_inc(lnk);
> >>>>>     	smcr_copy_dev_info_to_link(lnk);
> >>>>>     	atomic_set(&lnk->conn_cnt, 0);
> >>>>> @@ -1269,6 +1270,7 @@ void smcr_link_clear(struct smc_link *lnk, bool log)
> >>>>>     	smcr_buf_unmap_lgr(lnk);
> >>>>>     	smcr_rtoken_clear_link(lnk);
> >>>>>     	smc_ib_modify_qp_error(lnk);
> >>>>> +	smc_wr_drain_cq(lnk);
> >>>>>     	smc_wr_free_link(lnk);
> >>>>>     	smc_ib_destroy_queue_pair(lnk);
> >>>>>     	smc_ib_dealloc_protection_domain(lnk);
> >>>>> diff --git a/net/smc/smc_core.h b/net/smc/smc_core.h
> >>>>> index fe8b524ad..285f9bd8e 100644
> >>>>> --- a/net/smc/smc_core.h
> >>>>> +++ b/net/smc/smc_core.h
> >>>>> @@ -115,8 +115,10 @@ struct smc_link {
> >>>>>     	dma_addr_t		wr_rx_dma_addr;	/* DMA address of wr_rx_bufs */
> >>>>>     	dma_addr_t		wr_rx_v2_dma_addr; /* DMA address of v2 rx buf*/
> >>>>>     	u64			wr_rx_id;	/* seq # of last recv WR */
> >>>>> +	u64			wr_rx_id_compl; /* seq # of last completed WR */
> >>>>>     	u32			wr_rx_cnt;	/* number of WR recv buffers */
> >>>>>     	unsigned long		wr_rx_tstamp;	/* jiffies when last buf rx */
> >>>>> +	wait_queue_head_t       wr_rx_empty_wait; /* wait for RQ empty */
> >>>>>     
> >>>>>     	struct ib_reg_wr	wr_reg;		/* WR register memory region */
> >>>>>     	wait_queue_head_t	wr_reg_wait;	/* wait for wr_reg result */
> >>>>> diff --git a/net/smc/smc_wr.c b/net/smc/smc_wr.c
> >>>>> index 26f8f240d..bc8793803 100644
> >>>>> --- a/net/smc/smc_wr.c
> >>>>> +++ b/net/smc/smc_wr.c
> >>>>> @@ -454,6 +454,7 @@ static inline void smc_wr_rx_process_cqes(struct ib_wc wc[], int num)
> >>>>>     
> >>>>>     	for (i = 0; i < num; i++) {
> >>>>>     		link = wc[i].qp->qp_context;
> >>>>> +		link->wr_rx_id_compl = wc[i].wr_id;
> >>>>>     		if (wc[i].status == IB_WC_SUCCESS) {
> >>>>>     			link->wr_rx_tstamp = jiffies;
> >>>>>     			smc_wr_rx_demultiplex(&wc[i]);
> >>>>> @@ -465,6 +466,8 @@ static inline void smc_wr_rx_process_cqes(struct ib_wc wc[], int num)
> >>>>>     			case IB_WC_RNR_RETRY_EXC_ERR:
> >>>>>     			case IB_WC_WR_FLUSH_ERR:
> >>>>>     				smcr_link_down_cond_sched(link);
> >>>>> +				if (link->wr_rx_id_compl == link->wr_rx_id)
> >>>>> +					wake_up(&link->wr_rx_empty_wait);
> >>>>>     				break;
> >>>>>     			default:
> >>>>>     				smc_wr_rx_post(link); /* refill WR RX */
> >>>>> @@ -631,6 +634,11 @@ static void smc_wr_init_sge(struct smc_link *lnk)
> >>>>>     	lnk->wr_reg.access = IB_ACCESS_LOCAL_WRITE | IB_ACCESS_REMOTE_WRITE;
> >>>>>     }
> >>>>>     
> >>>>> +void smc_wr_drain_cq(struct smc_link *lnk)
> >>>>> +{
> >>>>> +	wait_event(lnk->wr_rx_empty_wait, lnk->wr_rx_id_compl == lnk->wr_rx_id);
> >>>>> +}
> >>>>> +
> >>>>>     void smc_wr_free_link(struct smc_link *lnk)
> >>>>>     {
> >>>>>     	struct ib_device *ibdev;
> >>>>> @@ -889,6 +897,7 @@ int smc_wr_create_link(struct smc_link *lnk)
> >>>>>     	atomic_set(&lnk->wr_tx_refcnt, 0);
> >>>>>     	init_waitqueue_head(&lnk->wr_reg_wait);
> >>>>>     	atomic_set(&lnk->wr_reg_refcnt, 0);
> >>>>> +	init_waitqueue_head(&lnk->wr_rx_empty_wait);
> >>>>>     	return rc;
> >>>>>     
> >>>>>     dma_unmap:
> >>>>> diff --git a/net/smc/smc_wr.h b/net/smc/smc_wr.h
> >>>>> index a54e90a11..5ca5086ae 100644
> >>>>> --- a/net/smc/smc_wr.h
> >>>>> +++ b/net/smc/smc_wr.h
> >>>>> @@ -101,6 +101,7 @@ static inline int smc_wr_rx_post(struct smc_link *link)
> >>>>>     int smc_wr_create_link(struct smc_link *lnk);
> >>>>>     int smc_wr_alloc_link_mem(struct smc_link *lnk);
> >>>>>     int smc_wr_alloc_lgr_mem(struct smc_link_group *lgr);
> >>>>> +void smc_wr_drain_cq(struct smc_link *lnk);
> >>>>>     void smc_wr_free_link(struct smc_link *lnk);
> >>>>>     void smc_wr_free_link_mem(struct smc_link *lnk);
> >>>>>     void smc_wr_free_lgr_mem(struct smc_link_group *lgr);
> >>>>
> >>>> Thank you @Yacan for the effort to improve our code! And Thank you @Tony
> >>>> for such valuable suggestions and testing!
> >>>> I like the modification of this version. However, this is not a fix
> >>>> patch to upstream, since the patches "[PATCH net-next v2 00/10] optimize
> >>>> the parallelism of SMC-R connections" are still not applied. My
> >>>> sugguestions:
> >>>> - Please talk to the author (D. Wythe <alibuda@linux.alibaba.com>) of
> >>>> those patches I mentioned above, and ask if he can take your patch as a
> >>>> part of the patch serie
> >>>> - Fix patches should go to net-next
> >>>> - Please send always send your new version separately, rather than as
> >>>> reply to your previous version. That makes people confused.
> >>>
> >>> @Wenjia, Thanks a lot for your suggestions and guidance !
> >>>
> >>> @D. Wythe, Can you include this patch in your series of patches if it is
> >>> convenient?
> >>>
> >>> Regards,
> >>> Yacan
> >>>
> >> One point I was confused, fixes should goto net, sorry!
> > 
> > Well, @D. Wythe, please ignore the above emails, sorry!
> > 
> > Regards,
> > Yacan
> > 
> oh no, I didn't mean that. I think I didn't say clearly. What I mean is 
> that the patch should go to net as a seperate patch if the patch serie 
> from D. Wythe is already applied. But now the patch serie is still not 
> applied, so you can still ask D. Wythe to take your patch as a part of 
> this serie. (Just a suggestion)

Well, I misunderstood. What I'm not sure about is that the patch serie 
from D. Wythe is going to the net-next tree, but mine is going to the net. 
Will this be a problem ?

Regards,
Yacan

