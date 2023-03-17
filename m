Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 035146BDF88
	for <lists+netdev@lfdr.de>; Fri, 17 Mar 2023 04:22:32 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229556AbjCQDW3 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 16 Mar 2023 23:22:29 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:51266 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229616AbjCQDWD (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 16 Mar 2023 23:22:03 -0400
Received: from out30-112.freemail.mail.aliyun.com (out30-112.freemail.mail.aliyun.com [115.124.30.112])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id B9FD45982C;
        Thu, 16 Mar 2023 20:21:36 -0700 (PDT)
X-Alimail-AntiSpam: AC=PASS;BC=-1|-1;BR=01201311R551e4;CH=green;DM=||false|;DS=||;FP=0|-1|-1|-1|0|-1|-1|-1;HT=ay29a033018045192;MF=kaishen@linux.alibaba.com;NM=1;PH=DS;RN=8;SR=0;TI=SMTPD_---0Ve1APCB_1679023293;
Received: from localhost(mailfrom:KaiShen@linux.alibaba.com fp:SMTPD_---0Ve1APCB_1679023293)
          by smtp.aliyun-inc.com;
          Fri, 17 Mar 2023 11:21:34 +0800
From:   Kai Shen <KaiShen@linux.alibaba.com>
To:     kgraul@linux.ibm.com, wenjia@linux.ibm.com, jaka@linux.ibm.com,
        kuba@kernel.org
Cc:     davem@davemloft.net, netdev@vger.kernel.org,
        linux-s390@vger.kernel.org, linux-rdma@vger.kernel.org
Subject: [PATCH net-next v5] net/smc: Use percpu ref for wr tx reference
Date:   Fri, 17 Mar 2023 03:21:32 +0000
Message-Id: <20230317032132.85206-1-KaiShen@linux.alibaba.com>
X-Mailer: git-send-email 2.31.1
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-9.9 required=5.0 tests=BAYES_00,
        ENV_AND_HDR_SPF_MATCH,RCVD_IN_MSPIKE_H2,SPF_HELO_NONE,SPF_PASS,
        UNPARSEABLE_RELAY,USER_IN_DEF_SPF_WL autolearn=ham autolearn_force=no
        version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

The refcount wr_tx_refcnt may cause cache thrashing problems among
cores and we can use percpu ref to mitigate this issue here. We
gain some performance improvement with percpu ref here on our
customized smc-r verion. Applying cache alignment may also mitigate
this problem but it seem more reasonable to use percpu ref here.
We can also replace wr_reg_refcnt with one percpu reference like
wr_tx_refcnt.

redis-benchmark on smc-r with atomic wr_tx_refcnt:
SET: 525707.06 requests per second, p50=0.087 msec
GET: 554877.38 requests per second, p50=0.087 msec

redis-benchmark on the percpu_ref version:
SET: 540482.06 requests per second, p50=0.087 msec
GET: 570711.12 requests per second, p50=0.079 msec

Cases are like "redis-benchmark -h x.x.x.x -q -t set,get -P 1 -n
5000000 -c 50 -d 10 --threads 4".

Signed-off-by: Kai Shen <KaiShen@linux.alibaba.com>
---
v1->v2:
- Modify patch prefix

v2->v3:
- Make wr_reg_refcnt a percpu one as well
- Init percpu ref with 0 flag instead of ALLOW_REINIT flag

v3->v4:
- Update performance data, this data may differ from previous data
  as I ran cases on other machines

v4->v5:
- Fix patch format
---
 net/smc/smc_core.h | 10 ++++++++--
 net/smc/smc_wr.c   | 35 ++++++++++++++++++++++++++++-------
 net/smc/smc_wr.h   |  5 ++---
 3 files changed, 38 insertions(+), 12 deletions(-)

diff --git a/net/smc/smc_core.h b/net/smc/smc_core.h
index 08b457c2d294..1645fba0d2d3 100644
--- a/net/smc/smc_core.h
+++ b/net/smc/smc_core.h
@@ -106,7 +106,10 @@ struct smc_link {
 	unsigned long		*wr_tx_mask;	/* bit mask of used indexes */
 	u32			wr_tx_cnt;	/* number of WR send buffers */
 	wait_queue_head_t	wr_tx_wait;	/* wait for free WR send buf */
-	atomic_t		wr_tx_refcnt;	/* tx refs to link */
+	struct {
+		struct percpu_ref	wr_tx_refs;
+	} ____cacheline_aligned_in_smp;
+	struct completion	tx_ref_comp;
 
 	struct smc_wr_buf	*wr_rx_bufs;	/* WR recv payload buffers */
 	struct ib_recv_wr	*wr_rx_ibs;	/* WR recv meta data */
@@ -122,7 +125,10 @@ struct smc_link {
 
 	struct ib_reg_wr	wr_reg;		/* WR register memory region */
 	wait_queue_head_t	wr_reg_wait;	/* wait for wr_reg result */
-	atomic_t		wr_reg_refcnt;	/* reg refs to link */
+	struct {
+		struct percpu_ref	wr_reg_refs;
+	} ____cacheline_aligned_in_smp;
+	struct completion	reg_ref_comp;
 	enum smc_wr_reg_state	wr_reg_state;	/* state of wr_reg request */
 
 	u8			gid[SMC_GID_SIZE];/* gid matching used vlan id*/
diff --git a/net/smc/smc_wr.c b/net/smc/smc_wr.c
index b0678a417e09..0021065a600a 100644
--- a/net/smc/smc_wr.c
+++ b/net/smc/smc_wr.c
@@ -377,12 +377,11 @@ int smc_wr_reg_send(struct smc_link *link, struct ib_mr *mr)
 	if (rc)
 		return rc;
 
-	atomic_inc(&link->wr_reg_refcnt);
+	percpu_ref_get(&link->wr_reg_refs);
 	rc = wait_event_interruptible_timeout(link->wr_reg_wait,
 					      (link->wr_reg_state != POSTED),
 					      SMC_WR_REG_MR_WAIT_TIME);
-	if (atomic_dec_and_test(&link->wr_reg_refcnt))
-		wake_up_all(&link->wr_reg_wait);
+	percpu_ref_put(&link->wr_reg_refs);
 	if (!rc) {
 		/* timeout - terminate link */
 		smcr_link_down_cond_sched(link);
@@ -647,8 +646,10 @@ void smc_wr_free_link(struct smc_link *lnk)
 	smc_wr_wakeup_tx_wait(lnk);
 
 	smc_wr_tx_wait_no_pending_sends(lnk);
-	wait_event(lnk->wr_reg_wait, (!atomic_read(&lnk->wr_reg_refcnt)));
-	wait_event(lnk->wr_tx_wait, (!atomic_read(&lnk->wr_tx_refcnt)));
+	percpu_ref_kill(&lnk->wr_reg_refs);
+	wait_for_completion(&lnk->reg_ref_comp);
+	percpu_ref_kill(&lnk->wr_tx_refs);
+	wait_for_completion(&lnk->tx_ref_comp);
 
 	if (lnk->wr_rx_dma_addr) {
 		ib_dma_unmap_single(ibdev, lnk->wr_rx_dma_addr,
@@ -847,6 +848,20 @@ void smc_wr_add_dev(struct smc_ib_device *smcibdev)
 	tasklet_setup(&smcibdev->send_tasklet, smc_wr_tx_tasklet_fn);
 }
 
+static void smcr_wr_tx_refs_free(struct percpu_ref *ref)
+{
+	struct smc_link *lnk = container_of(ref, struct smc_link, wr_tx_refs);
+
+	complete(&lnk->tx_ref_comp);
+}
+
+static void smcr_wr_reg_refs_free(struct percpu_ref *ref)
+{
+	struct smc_link *lnk = container_of(ref, struct smc_link, wr_reg_refs);
+
+	complete(&lnk->reg_ref_comp);
+}
+
 int smc_wr_create_link(struct smc_link *lnk)
 {
 	struct ib_device *ibdev = lnk->smcibdev->ibdev;
@@ -890,9 +905,15 @@ int smc_wr_create_link(struct smc_link *lnk)
 	smc_wr_init_sge(lnk);
 	bitmap_zero(lnk->wr_tx_mask, SMC_WR_BUF_CNT);
 	init_waitqueue_head(&lnk->wr_tx_wait);
-	atomic_set(&lnk->wr_tx_refcnt, 0);
+	rc = percpu_ref_init(&lnk->wr_tx_refs, smcr_wr_tx_refs_free, 0, GFP_KERNEL);
+	if (rc)
+		goto dma_unmap;
+	init_completion(&lnk->tx_ref_comp);
 	init_waitqueue_head(&lnk->wr_reg_wait);
-	atomic_set(&lnk->wr_reg_refcnt, 0);
+	rc = percpu_ref_init(&lnk->wr_reg_refs, smcr_wr_reg_refs_free, 0, GFP_KERNEL);
+	if (rc)
+		goto dma_unmap;
+	init_completion(&lnk->reg_ref_comp);
 	init_waitqueue_head(&lnk->wr_rx_empty_wait);
 	return rc;
 
diff --git a/net/smc/smc_wr.h b/net/smc/smc_wr.h
index 45e9b894d3f8..f3008dda222a 100644
--- a/net/smc/smc_wr.h
+++ b/net/smc/smc_wr.h
@@ -63,14 +63,13 @@ static inline bool smc_wr_tx_link_hold(struct smc_link *link)
 {
 	if (!smc_link_sendable(link))
 		return false;
-	atomic_inc(&link->wr_tx_refcnt);
+	percpu_ref_get(&link->wr_tx_refs);
 	return true;
 }
 
 static inline void smc_wr_tx_link_put(struct smc_link *link)
 {
-	if (atomic_dec_and_test(&link->wr_tx_refcnt))
-		wake_up_all(&link->wr_tx_wait);
+	percpu_ref_put(&link->wr_tx_refs);
 }
 
 static inline void smc_wr_drain_cq(struct smc_link *lnk)
-- 
2.31.1

