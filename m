Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 5009F5A4FF4
	for <lists+netdev@lfdr.de>; Mon, 29 Aug 2022 17:13:57 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229706AbiH2PNz (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 29 Aug 2022 11:13:55 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:33358 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229923AbiH2PNx (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 29 Aug 2022 11:13:53 -0400
X-Greylist: delayed 720 seconds by postgrey-1.37 at lindbergh.monkeyblade.net; Mon, 29 Aug 2022 08:13:48 PDT
Received: from corp-front07-corp.i.nease.net (corp-front07-corp.i.nease.net [59.111.134.157])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 61C4E7A752;
        Mon, 29 Aug 2022 08:13:47 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=corp.netease.com; s=s210401; h=Received:From:To:Cc:Subject:
        Date:Message-Id:MIME-Version:Content-Transfer-Encoding; bh=11Nt4
        YkIPwUsdwK/Aux7DPfD9nzeq/s4EcjBDdFsQjk=; b=i1uGcl6xYXwQoUPSlYZlm
        LjyGeU2Ijim44paQfYDZ85zf3QkJQbVu9ItU1NJDGa+ZAu11GDpakB3ITlpddtzw
        235keJ+VjFpCskaXhyamKjDGlOIc0xM0+gOovQTSg7JvoNis/NpQ6JeyVMuU5sXA
        /XxDBiezfZPcgIHw/eD+Xo=
Received: from pubt1-k8s74.yq.163.org (unknown [115.238.122.38])
        by corp-front07-corp.i.nease.net (Coremail) with SMTP id nRDICgBnu+cu0wxjm6sUAA--.36701S2;
        Mon, 29 Aug 2022 22:54:38 +0800 (HKT)
From:   liuyacan@corp.netease.com
To:     kgraul@linux.ibm.com, davem@davemloft.net, wenjia@linux.ibm.com,
        edumazet@google.com, kuba@kernel.org, pabeni@redhat.com
Cc:     linux-s390@vger.kernel.org, netdev@vger.kernel.org,
        linux-kernel@vger.kernel.org, liuyacan <liuyacan@corp.netease.com>
Subject: [PATCH net] net/smc: Fix possible access to freed memory in link clear
Date:   Mon, 29 Aug 2022 22:54:35 +0800
Message-Id: <20220829145435.2756430-1-liuyacan@corp.netease.com>
X-Mailer: git-send-email 2.20.1
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-CM-TRANSID: nRDICgBnu+cu0wxjm6sUAA--.36701S2
X-Coremail-Antispam: 1UD129KBjvJXoW3ArWUXrWDuF4rtr4kAr45Awb_yoWxJF15pF
        W7Gr1xCr48Jr1kWF1kCFyUZ3W3t3W2kF1rG34avr95ZFnxGw18tF1Sqr12vFW5JF4qga4I
        vrW8Xw1Ikrn8JaUanT9S1TB71UUUUUUqnTZGkaVYY2UrUUUUjbIjqfuFe4nvWSU5nxnvy2
        9KBjDU0xBIdaVrnRJUUULFb7IF0VCFI7km07C26c804VAKzcIF0wAFF20E14v26r4j6ryU
        M7CY07I20VC2zVCF04k26cxKx2IYs7xG6rWj6s0DM7CIcVAFz4kK6r1j6r18M28lY4IEw2
        IIxxk0rwA2F7IY1VAKz4vEj48ve4kI8wA2z4x0Y4vE2Ix0cI8IcVAFwI0_tr0E3s1l84AC
        jcxK6xIIjxv20xvEc7CjxVAFwI0_Gr1j6F4UJwA2z4x0Y4vEx4A2jsIE14v26rxl6s0DM2
        8EF7xvwVC2z280aVCY1x0267AKxVW0oVCq3wAawVAFpfBj4fn0lVCYm3Zqqf926ryUJw1U
        Kr1v6r18M2kK6xCIbVAIwIAEc20F6c8GOVW8Jr15Jr4le2I262IYc4CY6c8Ij28IcVAaY2
        xG8wAqjxCE34x0Y48IcwAqx4xG64xvF2IEw4CE5I8CrVC2j2WlYx0E2Ix0cI8IcVAFwI0_
        JrI_JrylYx0Ex4A2jsIE14v26r1j6r4UMcvjeVCFs4IE7xkEbVWUJVW8JwACjcxG0xvY0x
        0EwIxGrwACjI8F5VA0II8E6IAqYI8I648v4I1lFIxGxcIEc7CjxVA2Y2ka0xkIwI1lw4CE
        c2x0rVAKj4xxMx02cVAKzwCY0x0Ix7I2Y4AK64vIr41l42xK82IYc2Ij64vIr41l4x8a64
        kIII0Yj41l4I8I3I0E4IkC6x0Yz7v_Jr0_Gr1l4IxY624lx2IqxVAqx4xG67AKxVWUJVWU
        GwC20s026x8GjcxK67AKxVWUGVWUWwC2zVAF1VAY17CE14v26r1q6r43MIIYrxkI7VAKI4
        8JMIIF0xvE2Ix0cI8IcVAFwI0_Jr0_JF4lIxAIcVC0I7IYx2IY6xkF7I0E14v26r4j6F4U
        MIIF0xvE42xK8VAvwI8IcIk0rVWUJVWUCwCI42IY6I8E87Iv67AKxVWUJVW8JwCI42IY6I
        8E87Iv6xkF7I0E14v26r4j6r4UJbIYCTnIWIevJa73UjIFyTuYvjTREKZWUUUUU
X-CM-SenderInfo: 5olx5txfdqquhrush05hwht23hof0z/1tbiBQANCVt77wtWlgAEsB
X-Spam-Status: No, score=-2.0 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_PASS,
        T_SCC_BODY_TEXT_LINE autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: liuyacan <liuyacan@corp.netease.com>

After modifying the QP to the Error state, all RX WR would be
completed with WC in IB_WC_WR_FLUSH_ERR status. Current
implementation does not wait for it is done, but free the link
directly. So there is a risk that accessing the freed link in
tasklet context.

Here is a crash example:

 BUG: unable to handle page fault for address: ffffffff8f220860
 #PF: supervisor write access in kernel mode
 #PF: error_code(0x0002) - not-present page
 PGD f7300e067 P4D f7300e067 PUD f7300f063 PMD 8c4e45063 PTE 800ffff08c9df060
 Oops: 0002 [#1] SMP PTI
 CPU: 1 PID: 0 Comm: swapper/1 Kdump: loaded Tainted: G S         OE     5.10.0-0607+ #23
 Hardware name: Inspur NF5280M4/YZMB-00689-101, BIOS 4.1.20 07/09/2018
 RIP: 0010:native_queued_spin_lock_slowpath+0x176/0x1b0
 Code: f3 90 48 8b 32 48 85 f6 74 f6 eb d5 c1 ee 12 83 e0 03 83 ee 01 48 c1 e0 05 48 63 f6 48 05 00 c8 02 00 48 03 04 f5 00 09 98 8e <48> 89 10 8b 42 08 85 c0 75 09 f3 90 8b 42 08 85 c0 74 f7 48 8b 32
 RSP: 0018:ffffb3b6c001ebd8 EFLAGS: 00010086
 RAX: ffffffff8f220860 RBX: 0000000000000246 RCX: 0000000000080000
 RDX: ffff91db1f86c800 RSI: 000000000000173c RDI: ffff91db62bace00
 RBP: ffff91db62bacc00 R08: 0000000000000000 R09: c00000010000028b
 R10: 0000000000055198 R11: ffffb3b6c001ea58 R12: ffff91db80e05010
 R13: 000000000000000a R14: 0000000000000006 R15: 0000000000000040
 FS:  0000000000000000(0000) GS:ffff91db1f840000(0000) knlGS:0000000000000000
 CS:  0010 DS: 0000 ES: 0000 CR0: 0000000080050033
 CR2: ffffffff8f220860 CR3: 00000001f9580004 CR4: 00000000003706e0
 DR0: 0000000000000000 DR1: 0000000000000000 DR2: 0000000000000000
 DR3: 0000000000000000 DR6: 00000000fffe0ff0 DR7: 0000000000000400
 Call Trace:
  <IRQ>
  _raw_spin_lock_irqsave+0x30/0x40
  mlx5_ib_poll_cq+0x4c/0xc50 [mlx5_ib]
  smc_wr_rx_tasklet_fn+0x56/0xa0 [smc]
  tasklet_action_common.isra.21+0x66/0x100
  __do_softirq+0xd5/0x29c
  asm_call_irq_on_stack+0x12/0x20
  </IRQ>
  do_softirq_own_stack+0x37/0x40
  irq_exit_rcu+0x9d/0xa0
  sysvec_call_function_single+0x34/0x80
  asm_sysvec_call_function_single+0x12/0x20

Signed-off-by: liuyacan <liuyacan@corp.netease.com>
---
 net/smc/smc_core.c |  2 ++
 net/smc/smc_core.h |  2 ++
 net/smc/smc_wr.c   | 12 ++++++++++++
 net/smc/smc_wr.h   |  3 +++
 4 files changed, 19 insertions(+)

diff --git a/net/smc/smc_core.c b/net/smc/smc_core.c
index ff49a11f5..b632a33f1 100644
--- a/net/smc/smc_core.c
+++ b/net/smc/smc_core.c
@@ -752,6 +752,7 @@ int smcr_link_init(struct smc_link_group *lgr, struct smc_link *lnk,
 	atomic_inc(&lnk->smcibdev->lnk_cnt);
 	refcount_set(&lnk->refcnt, 1); /* link refcnt is set to 1 */
 	lnk->clearing = 0;
+	lnk->rx_drained = 0;
 	lnk->path_mtu = lnk->smcibdev->pattr[lnk->ibport - 1].active_mtu;
 	lnk->link_id = smcr_next_link_id(lgr);
 	lnk->lgr = lgr;
@@ -1269,6 +1270,7 @@ void smcr_link_clear(struct smc_link *lnk, bool log)
 	smcr_buf_unmap_lgr(lnk);
 	smcr_rtoken_clear_link(lnk);
 	smc_ib_modify_qp_error(lnk);
+	smc_wr_drain_cq(lnk);
 	smc_wr_free_link(lnk);
 	smc_ib_destroy_queue_pair(lnk);
 	smc_ib_dealloc_protection_domain(lnk);
diff --git a/net/smc/smc_core.h b/net/smc/smc_core.h
index fe8b524ad..0a469a3e7 100644
--- a/net/smc/smc_core.h
+++ b/net/smc/smc_core.h
@@ -117,6 +117,7 @@ struct smc_link {
 	u64			wr_rx_id;	/* seq # of last recv WR */
 	u32			wr_rx_cnt;	/* number of WR recv buffers */
 	unsigned long		wr_rx_tstamp;	/* jiffies when last buf rx */
+	wait_queue_head_t       wr_rx_drain_wait; /* wait for WR drain */
 
 	struct ib_reg_wr	wr_reg;		/* WR register memory region */
 	wait_queue_head_t	wr_reg_wait;	/* wait for wr_reg result */
@@ -138,6 +139,7 @@ struct smc_link {
 	u8			link_idx;	/* index in lgr link array */
 	u8			link_is_asym;	/* is link asymmetric? */
 	u8			clearing : 1;	/* link is being cleared */
+	u8                      rx_drained : 1; /* link is drained */
 	refcount_t		refcnt;		/* link reference count */
 	struct smc_link_group	*lgr;		/* parent link group */
 	struct work_struct	link_down_wrk;	/* wrk to bring link down */
diff --git a/net/smc/smc_wr.c b/net/smc/smc_wr.c
index 26f8f240d..f9992896a 100644
--- a/net/smc/smc_wr.c
+++ b/net/smc/smc_wr.c
@@ -465,6 +465,10 @@ static inline void smc_wr_rx_process_cqes(struct ib_wc wc[], int num)
 			case IB_WC_RNR_RETRY_EXC_ERR:
 			case IB_WC_WR_FLUSH_ERR:
 				smcr_link_down_cond_sched(link);
+				if (link->clearing && wc[i]->wr_id == link->wr_rx_id) {
+					link->rx_drained = 1;
+					wake_up(&link->wr_rx_drain_wait);
+				}
 				break;
 			default:
 				smc_wr_rx_post(link); /* refill WR RX */
@@ -631,6 +635,13 @@ static void smc_wr_init_sge(struct smc_link *lnk)
 	lnk->wr_reg.access = IB_ACCESS_LOCAL_WRITE | IB_ACCESS_REMOTE_WRITE;
 }
 
+void smc_wr_drain_cq(struct smc_link *lnk)
+{
+	wait_event_interruptible_timeout(lnk->wr_rx_drain_wait,
+					 (lnk->drained == 1),
+					 SMC_WR_RX_WAIT_DRAIN_TIME);
+}
+
 void smc_wr_free_link(struct smc_link *lnk)
 {
 	struct ib_device *ibdev;
@@ -889,6 +900,7 @@ int smc_wr_create_link(struct smc_link *lnk)
 	atomic_set(&lnk->wr_tx_refcnt, 0);
 	init_waitqueue_head(&lnk->wr_reg_wait);
 	atomic_set(&lnk->wr_reg_refcnt, 0);
+	init_waitqueue_head(&lnk->wr_rx_drain_wait);
 	return rc;
 
 dma_unmap:
diff --git a/net/smc/smc_wr.h b/net/smc/smc_wr.h
index a54e90a11..2a7ebdba3 100644
--- a/net/smc/smc_wr.h
+++ b/net/smc/smc_wr.h
@@ -27,6 +27,8 @@
 
 #define SMC_WR_TX_PEND_PRIV_SIZE 32
 
+#define SMC_WR_RX_WAIT_DRAIN_TIME       (2 * HZ)
+
 struct smc_wr_tx_pend_priv {
 	u8			priv[SMC_WR_TX_PEND_PRIV_SIZE];
 };
@@ -101,6 +103,7 @@ static inline int smc_wr_rx_post(struct smc_link *link)
 int smc_wr_create_link(struct smc_link *lnk);
 int smc_wr_alloc_link_mem(struct smc_link *lnk);
 int smc_wr_alloc_lgr_mem(struct smc_link_group *lgr);
+void smc_wr_drain_cq(struct smc_link *lnk);
 void smc_wr_free_link(struct smc_link *lnk);
 void smc_wr_free_link_mem(struct smc_link *lnk);
 void smc_wr_free_lgr_mem(struct smc_link_group *lgr);
-- 
2.20.1

