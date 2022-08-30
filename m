Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 0DE575A59B8
	for <lists+netdev@lfdr.de>; Tue, 30 Aug 2022 05:06:29 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229914AbiH3DGU (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 29 Aug 2022 23:06:20 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:36476 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229616AbiH3DGO (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 29 Aug 2022 23:06:14 -0400
Received: from corp-front10-corp.i.nease.net (corp-front10-corp.i.nease.net [42.186.62.104])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 34D49719AE;
        Mon, 29 Aug 2022 20:06:10 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=corp.netease.com; s=s210401; h=Received:From:To:Cc:Subject:
        Date:Message-Id:In-Reply-To:References:MIME-Version:
        Content-Transfer-Encoding; bh=t3d3QDx9C7aIcp4M1C7MLhQ4SK+SUL7FV2
        hnpYAOk3I=; b=LR30vbc5BZnNsZru+Flv7CXkxEW2W5qYavspG3psLJsF6z6aEk
        2O4eVRaEBxVhGn6Ze2AjX1wiviFMzoDGPwKdTlnFfBP5hZCfl3tiFb59yiasPHaQ
        F87ZxQYgdWgoIkGulSsJWfmEeontRp+clrJAbnrv5t8eAvNV6Nr38k5v0=
Received: from pubt1-k8s74.yq.163.org (unknown [115.238.122.38])
        by corp-front10-corp.i.nease.net (Coremail) with SMTP id aIG_CgDn0eSVfg1jEmwgAA--.1668S2;
        Tue, 30 Aug 2022 11:05:57 +0800 (HKT)
From:   liuyacan@corp.netease.com
To:     tonylu@linux.alibaba.com
Cc:     davem@davemloft.net, edumazet@google.com, kgraul@linux.ibm.com,
        kuba@kernel.org, linux-kernel@vger.kernel.org,
        linux-s390@vger.kernel.org, liuyacan@corp.netease.com,
        netdev@vger.kernel.org, pabeni@redhat.com, wenjia@linux.ibm.com
Subject: [PATCH net v2] net/smc: Fix possible access to freed memory in link clear
Date:   Tue, 30 Aug 2022 11:05:55 +0800
Message-Id: <20220830030555.373860-1-liuyacan@corp.netease.com>
X-Mailer: git-send-email 2.20.1
In-Reply-To: <Ywzrljbl7uV8Ay8y@TonyMac-Alibaba>
References: <Ywzrljbl7uV8Ay8y@TonyMac-Alibaba>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-CM-TRANSID: aIG_CgDn0eSVfg1jEmwgAA--.1668S2
X-Coremail-Antispam: 1UD129KBjvJXoW3ArWUXrWDuF4rtr4kAr45Awb_yoWxJF17pF
        W7Gr1xCr48Xr1kWF1kCFyUZ3W5t3W2kF1rG34avr95ZFnrGw18tF1Sqr12vFW5JF4qga4I
        vrW8Xw1Ikrn8JaUanT9S1TB71UUUUUUqnTZGkaVYY2UrUUUUjbIjqfuFe4nvWSU5nxnvy2
        9KBjDU0xBIdaVrnRJUUUL0b7IF0VCFI7km07C26c804VAKzcIF0wAFF20E14v26r4j6ryU
        M7CY07I20VC2zVCF04k26cxKx2IYs7xG6rWj6s0DM7CIcVAFz4kK6r1j6r18M28lY4IEw2
        IIxxk0rwA2F7IY1VAKz4vEj48ve4kI8wA2z4x0Y4vE2Ix0cI8IcVAFwI0_tr0E3s1l84AC
        jcxK6xIIjxv20xvEc7CjxVAFwI0_GcCE3s1l84ACjcxK6I8E87Iv67AKxVW0oVCq3wA2z4
        x0Y4vEx4A2jsIEc7CjxVAFwI0_GcCE3s1ln4vE1TuYJxujqTIEc-sFP3VYkVW5Jr1DJw4U
        KVWUGwAawVCFI7vE04vSzxk24VAqrcv_Gr1UXr18M2AIxVAIcxkEcVAq07x20xvEncxIr2
        1l57IF6s8CjcxG0xyl5I8CrVACY4xI64kE6c02F40Ex7xfMcIj6xIIjxv20xvE14v26r1j
        6r18McIj6I8E87Iv67AKxVWUJVW8JwAm72CE4IkC6x0Yz7v_Jr0_Gr1lF7xvr2IYc2Ij64
        vIr41lF7I21c0EjII2zVCS5cI20VAGYxC7M4IIrI8v6xkF7I0E8cxan2IY04v7M4kE6xkI
        j40Ew7xC0wCjxxvEw4Wlc2IjII80xcxEwVAKI48JMxAIw28IcxkI7VAKI48JMxCjnVAK0I
        I2c7xJMxC20s026xCaFVCjc4AY6r1j6r4UMxCIbVAxMI8I3I0E5I8CrVAFwI0_Jr0_Jr4l
        x2IqxVCjr7xvwVAFwI0_JrI_JrWlx4CE17CEb7AF67AKxVWUtVW8ZwCIc40Y0x0EwIxGrw
        CI42IY6xIIjxv20xvE14v26r1j6r1xMIIF0xvE2Ix0cI8IcVCY1x0267AKxVW8JVWxJwCI
        42IY6xAIw20EY4v20xvaj40_Jr0_JF4lIxAIcVC2z280aVAFwI0_Jr0_Gr1lIxAIcVC2z2
        80aVCY1x0267AKxVW8JVW8JrUvcSsGvfC2KfnxnUUI43ZEXa7sRiE_M7UUUUU==
X-CM-SenderInfo: 5olx5txfdqquhrush05hwht23hof0z/1tbiBQAOCVt77xBV+AACsy
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
index 26f8f240d..3f782837b 100644
--- a/net/smc/smc_wr.c
+++ b/net/smc/smc_wr.c
@@ -465,6 +465,10 @@ static inline void smc_wr_rx_process_cqes(struct ib_wc wc[], int num)
 			case IB_WC_RNR_RETRY_EXC_ERR:
 			case IB_WC_WR_FLUSH_ERR:
 				smcr_link_down_cond_sched(link);
+				if (link->clearing && wc[i].wr_id == link->wr_rx_id) {
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
+					 (lnk->rx_drained == 1),
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

