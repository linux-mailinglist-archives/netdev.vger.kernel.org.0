Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 438065ACC68
	for <lists+netdev@lfdr.de>; Mon,  5 Sep 2022 09:28:28 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S236658AbiIEHWd (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 5 Sep 2022 03:22:33 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:44702 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S236420AbiIEHVt (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 5 Sep 2022 03:21:49 -0400
Received: from corp-front07-corp.i.nease.net (corp-front07-corp.i.nease.net [59.111.134.157])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 6514B40BCA;
        Mon,  5 Sep 2022 00:18:32 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=corp.netease.com; s=s210401; h=Received:From:To:Cc:Subject:
        Date:Message-Id:In-Reply-To:References:MIME-Version:
        Content-Transfer-Encoding; bh=pgAPJwSQJ2munczLoGE8RAVrWa3OnIMrH9
        iDbcBO1dU=; b=RyRwkg3N5yNTuvzSosygEZ/4H22agQQEyYfIEw3aQkAY+mxZGA
        ngBTJSDWa2myFI2CUOtI/8R6skDqBKk5m0P87IWgtSBkCD3gk9NZhX3nm7GdAPs3
        BZiMuiUD/5vhsIukwGCi/zZPArlAIplEirKzzyAB4nAIuK070M6mpZYXM=
Received: from pubt1-k8s74.yq.163.org (unknown [115.238.122.38])
        by corp-front07-corp.i.nease.net (Coremail) with SMTP id nRDICgCX7OiyohVjhUwXAA--.50525S2;
        Mon, 05 Sep 2022 15:18:10 +0800 (HKT)
From:   liuyacan@corp.netease.com
To:     tonylu@linux.alibaba.com
Cc:     davem@davemloft.net, edumazet@google.com, kgraul@linux.ibm.com,
        kuba@kernel.org, linux-kernel@vger.kernel.org,
        linux-s390@vger.kernel.org, liuyacan@corp.netease.com,
        netdev@vger.kernel.org, pabeni@redhat.com,
        ubraun@linux.vnet.ibm.com, wenjia@linux.ibm.com,
        wintera@linux.ibm.com
Subject: Re: [PATCH net v4] net/smc: Fix possible access to freed memory in link clear
Date:   Mon,  5 Sep 2022 15:18:10 +0800
Message-Id: <20220905071810.2102474-1-liuyacan@corp.netease.com>
X-Mailer: git-send-email 2.20.1
In-Reply-To: <YxTLEakKhpge8T/3@TonyMac-Alibaba>
References: <YxTLEakKhpge8T/3@TonyMac-Alibaba>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-CM-TRANSID: nRDICgCX7OiyohVjhUwXAA--.50525S2
X-Coremail-Antispam: 1UD129KBjvJXoWxZF47GFWfCF4fur48GF4UJwb_yoWrAFy8pF
        WUKw47Cr4kXr1UXF4YyFyxAr1Uta1IyF48Grn2vr95CF15Gw1UJr1Igr17tFWkJr4qgryI
        yryvqw1xtrn8XaUanT9S1TB71UUUUUUqnTZGkaVYY2UrUUUUjbIjqfuFe4nvWSU5nxnvy2
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
X-CM-SenderInfo: 5olx5txfdqquhrush05hwht23hof0z/1tbiBQAACVt771KQnwAEsa
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
> >  BUG: unable to handle page fault for address: ffffffff8f220860
> >  #PF: supervisor write access in kernel mode
> >  #PF: error_code(0x0002) - not-present page
> >  PGD f7300e067 P4D f7300e067 PUD f7300f063 PMD 8c4e45063 PTE 800ffff08c9df060
> >  Oops: 0002 [#1] SMP PTI
> >  CPU: 1 PID: 0 Comm: swapper/1 Kdump: loaded Tainted: G S         OE     5.10.0-0607+ #23
> >  Hardware name: Inspur NF5280M4/YZMB-00689-101, BIOS 4.1.20 07/09/2018
> >  RIP: 0010:native_queued_spin_lock_slowpath+0x176/0x1b0
> >  Code: f3 90 48 8b 32 48 85 f6 74 f6 eb d5 c1 ee 12 83 e0 03 83 ee 01 48 c1 e0 05 48 63 f6 48 05 00 c8 02 00 48 03 04 f5 00 09 98 8e <48> 89 10 8b 42 08 85 c0 75 09 f3 90 8b 42 08 85 c0 74 f7 48 8b 32
> >  RSP: 0018:ffffb3b6c001ebd8 EFLAGS: 00010086
> >  RAX: ffffffff8f220860 RBX: 0000000000000246 RCX: 0000000000080000
> >  RDX: ffff91db1f86c800 RSI: 000000000000173c RDI: ffff91db62bace00
> >  RBP: ffff91db62bacc00 R08: 0000000000000000 R09: c00000010000028b
> >  R10: 0000000000055198 R11: ffffb3b6c001ea58 R12: ffff91db80e05010
> >  R13: 000000000000000a R14: 0000000000000006 R15: 0000000000000040
> >  FS:  0000000000000000(0000) GS:ffff91db1f840000(0000) knlGS:0000000000000000
> >  CS:  0010 DS: 0000 ES: 0000 CR0: 0000000080050033
> >  CR2: ffffffff8f220860 CR3: 00000001f9580004 CR4: 00000000003706e0
> >  DR0: 0000000000000000 DR1: 0000000000000000 DR2: 0000000000000000
> >  DR3: 0000000000000000 DR6: 00000000fffe0ff0 DR7: 0000000000000400
> >  Call Trace:
> >   <IRQ>
> >   _raw_spin_lock_irqsave+0x30/0x40
> >   mlx5_ib_poll_cq+0x4c/0xc50 [mlx5_ib]
> >   smc_wr_rx_tasklet_fn+0x56/0xa0 [smc]
> >   tasklet_action_common.isra.21+0x66/0x100
> >   __do_softirq+0xd5/0x29c
> >   asm_call_irq_on_stack+0x12/0x20
> >   </IRQ>
> >   do_softirq_own_stack+0x37/0x40
> >   irq_exit_rcu+0x9d/0xa0
> >   sysvec_call_function_single+0x34/0x80
> >   asm_sysvec_call_function_single+0x12/0x20
> > 
> > Fixes: bd4ad57718cc ("smc: initialize IB transport incl. PD, MR, QP, CQ, event, WR")
> > Signed-off-by: Yacan Liu <liuyacan@corp.netease.com>
> > 
> > ---
> > Chagen in v4:
> >   -- Remove the rx_drain flag because smc_wr_rx_post() may not have been called.
> >   -- Remove timeout.
> > Change in v3:
> >   -- Tune commit message (Signed-Off tag, Fixes tag).
> >      Tune code to avoid column length exceeding.
> > Change in v2:
> >   -- Fix some compile warnings and errors.
> > ---
> >  net/smc/smc_core.c | 2 ++
> >  net/smc/smc_core.h | 2 ++
> >  net/smc/smc_wr.c   | 9 +++++++++
> >  net/smc/smc_wr.h   | 1 +
> >  4 files changed, 14 insertions(+)
> > 
> > diff --git a/net/smc/smc_core.c b/net/smc/smc_core.c
> > index ff49a11f5..f92a916e9 100644
> > --- a/net/smc/smc_core.c
> > +++ b/net/smc/smc_core.c
> > @@ -757,6 +757,7 @@ int smcr_link_init(struct smc_link_group *lgr, struct smc_link *lnk,
> >  	lnk->lgr = lgr;
> >  	smc_lgr_hold(lgr); /* lgr_put in smcr_link_clear() */
> >  	lnk->link_idx = link_idx;
> > +	lnk->wr_rx_id_compl = 0;
> >  	smc_ibdev_cnt_inc(lnk);
> >  	smcr_copy_dev_info_to_link(lnk);
> >  	atomic_set(&lnk->conn_cnt, 0);
> > @@ -1269,6 +1270,7 @@ void smcr_link_clear(struct smc_link *lnk, bool log)
> >  	smcr_buf_unmap_lgr(lnk);
> >  	smcr_rtoken_clear_link(lnk);
> >  	smc_ib_modify_qp_error(lnk);
> > +	smc_wr_drain_cq(lnk);
> 
> smc_wr_drain_cq() can put into smc_wr_free_link(). Since
> smc_wr_free_link() do the same things together, such as waiting for
> resources cleaning up about wr.
> 
> >  	smc_wr_free_link(lnk);
> >  	smc_ib_destroy_queue_pair(lnk);
> >  	smc_ib_dealloc_protection_domain(lnk);
> 
> <snip>
> 
> The patch tested good in our environment. If you are going to send the
> v5 patch, you can go with my review.
> 
> Reviewed-by: Tony Lu <tonylu@linux.alibaba.com>
> 
> Cheers,
> Tony Lu

Thank you very much for your verification and suggestion!

Regards,
Yacan

