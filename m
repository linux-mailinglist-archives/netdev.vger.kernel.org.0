Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 9ED3A1843FA
	for <lists+netdev@lfdr.de>; Fri, 13 Mar 2020 10:43:27 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726647AbgCMJn0 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 13 Mar 2020 05:43:26 -0400
Received: from mail-pj1-f67.google.com ([209.85.216.67]:39957 "EHLO
        mail-pj1-f67.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726216AbgCMJnZ (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 13 Mar 2020 05:43:25 -0400
Received: by mail-pj1-f67.google.com with SMTP id bo3so2621214pjb.5
        for <netdev@vger.kernel.org>; Fri, 13 Mar 2020 02:43:23 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=from:to:cc:subject:date:message-id:in-reply-to:references;
        bh=pEuzk5nHPaOuqkHNBKDDxj2niCpDxm6FgFh0QJdW1BE=;
        b=UoI7fQkQuD345QHVULyLcjAjjK9hVmt+FNpknjwdhIu8Xr2472gAHEHUFFJiLg+y08
         Vh0XfFBZaF4awKbrKCydkJtyI1avWBU5ZkBQgwyXUuV6ULB82s3AnNo8mKAp3j+mDCbP
         RYpXOWnWE+ojL6eKEnCjEevs4UP+ChtyN6aqGcduJZ3OoIX+3t1VYmqNmrYt7rShoxOI
         AtoLSsko4OioXdY4eps8OHlWdi0kOmV2mjF9RoDA3m9IDI1Xh1cGQEe0ndMg2yFwQ/AD
         96r01/qCSAeUjk72c8PsTbPg/ho4a2ojNnX7lo+2HsO7WKTDZDDF53fooOUzr2P5e2/t
         xP1A==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references;
        bh=pEuzk5nHPaOuqkHNBKDDxj2niCpDxm6FgFh0QJdW1BE=;
        b=tStRYrthjNeqBStT3XyHH2FFEh9tG8RV6YZ0jL27D/rgCeniC0HBOLNmbilTGIpFtd
         hmblJ8k4bfwCMGyckxlOVlbFwTa3T74UOSSCFZoM34lk477qGbOl+LjnKWfAu4OFwKiW
         aLeg4EgWX9HqDRTNcfzJRwNRWGoo0+6IMhVO3sZ6NulSFZ8X7RVSM/mP3WAgibWyg3Y7
         +MpIwTiJlE8J+BIq44mtfpjdhlObEvXbqsv/zHOpsU5Q/kaTZYolRpCqYifCOdaT02PJ
         +6QoefjEAWXoAukMTpN9xYBroFUtpav79KULY8IK/3bJ1FzPRpXpU9U9iefYOpbLHSWR
         ds6g==
X-Gm-Message-State: ANhLgQ0xZN7ifS2ZKhvSsyF7bLRrfvk98tku+iVj/5SPTyj9RUK0Wm0i
        xkhXQmOKfHi7jGjRitUj2989dgvyW9o=
X-Google-Smtp-Source: ADFU+vtDfjD1kakFLgtXPvPZOzo3myxEchsgcZrLjX/4XaiU4Eq6uHXlczHHidZ3HwtgZHTylDZNZA==
X-Received: by 2002:a17:90b:14c2:: with SMTP id jz2mr8680255pjb.152.1584092602174;
        Fri, 13 Mar 2020 02:43:22 -0700 (PDT)
Received: from machine421.marvell.com ([115.113.156.2])
        by smtp.googlemail.com with ESMTPSA id v67sm13896386pfc.120.2020.03.13.02.43.19
        (version=TLS1_2 cipher=ECDHE-RSA-AES128-SHA bits=128/128);
        Fri, 13 Mar 2020 02:43:21 -0700 (PDT)
From:   sunil.kovvuri@gmail.com
To:     netdev@vger.kernel.org
Cc:     davem@davemloft.net, kuba@kernel.org, leon@kernel.org,
        Geetha sowjanya <gakula@marvell.com>,
        Sunil Goutham <sgoutham@marvell.com>
Subject: [PATCH v2 net-next 6/7] octeontx2-pf: Cleanup all receive buffers in SG descriptor
Date:   Fri, 13 Mar 2020 15:12:45 +0530
Message-Id: <1584092566-4793-7-git-send-email-sunil.kovvuri@gmail.com>
X-Mailer: git-send-email 2.7.4
In-Reply-To: <1584092566-4793-1-git-send-email-sunil.kovvuri@gmail.com>
References: <1584092566-4793-1-git-send-email-sunil.kovvuri@gmail.com>
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Geetha sowjanya <gakula@marvell.com>

With MTU sized receive buffers it is not expected to have CQE_RX
with multiple receive buffer pointers. But since same physcial link
is shared by PF and it's VFs, the max receive packet configured
at link could be morethan MTU. Hence there is a chance of receiving
plts morethan MTU which then gets DMA'ed into multiple buffers
and notified in a single CQE_RX. This patch treats such pkts as errors
and frees up receive buffers pointers back to hardware.

Also on the transmit side this patch sets SMQ MAXLEN to max value to avoid
HW length errors for the packets whose size > MTU, eg due to path MTU.

Signed-off-by: Geetha sowjanya <gakula@marvell.com>
Signed-off-by: Sunil Goutham <sgoutham@marvell.com>
---
 .../ethernet/marvell/octeontx2/nic/otx2_common.c   |  9 +++---
 .../net/ethernet/marvell/octeontx2/nic/otx2_txrx.c | 34 ++++++++++++++++++----
 2 files changed, 34 insertions(+), 9 deletions(-)

diff --git a/drivers/net/ethernet/marvell/octeontx2/nic/otx2_common.c b/drivers/net/ethernet/marvell/octeontx2/nic/otx2_common.c
index 70d97c7..bac1922 100644
--- a/drivers/net/ethernet/marvell/octeontx2/nic/otx2_common.c
+++ b/drivers/net/ethernet/marvell/octeontx2/nic/otx2_common.c
@@ -212,8 +212,6 @@ int otx2_hw_set_mtu(struct otx2_nic *pfvf, int mtu)
 		return -ENOMEM;
 	}
 
-	/* SMQ config limits maximum pkt size that can be transmitted */
-	req->update_smq = true;
 	pfvf->max_frs = mtu +  OTX2_ETH_HLEN;
 	req->maxlen = pfvf->max_frs;
 
@@ -472,7 +470,7 @@ int otx2_txschq_config(struct otx2_nic *pfvf, int lvl)
 	/* Set topology e.t.c configuration */
 	if (lvl == NIX_TXSCH_LVL_SMQ) {
 		req->reg[0] = NIX_AF_SMQX_CFG(schq);
-		req->regval[0] = ((pfvf->netdev->mtu  + OTX2_ETH_HLEN) << 8) |
+		req->regval[0] = ((OTX2_MAX_MTU + OTX2_ETH_HLEN) << 8) |
 				   OTX2_MIN_MTU;
 
 		req->regval[0] |= (0x20ULL << 51) | (0x80ULL << 39) |
@@ -582,17 +580,19 @@ void otx2_sqb_flush(struct otx2_nic *pfvf)
 {
 	int qidx, sqe_tail, sqe_head;
 	u64 incr, *ptr, val;
+	int timeout = 1000;
 
 	ptr = (u64 *)otx2_get_regaddr(pfvf, NIX_LF_SQ_OP_STATUS);
 	for (qidx = 0; qidx < pfvf->hw.tx_queues; qidx++) {
 		incr = (u64)qidx << 32;
-		while (1) {
+		while (timeout) {
 			val = otx2_atomic64_add(incr, ptr);
 			sqe_head = (val >> 20) & 0x3F;
 			sqe_tail = (val >> 28) & 0x3F;
 			if (sqe_head == sqe_tail)
 				break;
 			usleep_range(1, 3);
+			timeout--;
 		}
 	}
 }
@@ -988,6 +988,7 @@ void otx2_aura_pool_free(struct otx2_nic *pfvf)
 		qmem_free(pfvf->dev, pool->fc_addr);
 	}
 	devm_kfree(pfvf->dev, pfvf->qset.pool);
+	pfvf->qset.pool = NULL;
 }
 
 static int otx2_aura_init(struct otx2_nic *pfvf, int aura_id,
diff --git a/drivers/net/ethernet/marvell/octeontx2/nic/otx2_txrx.c b/drivers/net/ethernet/marvell/octeontx2/nic/otx2_txrx.c
index 1865f16..b4d523a 100644
--- a/drivers/net/ethernet/marvell/octeontx2/nic/otx2_txrx.c
+++ b/drivers/net/ethernet/marvell/octeontx2/nic/otx2_txrx.c
@@ -138,6 +138,25 @@ static void otx2_set_rxhash(struct otx2_nic *pfvf,
 	skb_set_hash(skb, hash, hash_type);
 }
 
+static void otx2_free_rcv_seg(struct otx2_nic *pfvf, struct nix_cqe_rx_s *cqe,
+			      int qidx)
+{
+	struct nix_rx_sg_s *sg = &cqe->sg;
+	void *end, *start;
+	u64 *seg_addr;
+	int seg;
+
+	start = (void *)sg;
+	end = start + ((cqe->parse.desc_sizem1 + 1) * 16);
+	while (start < end) {
+		sg = (struct nix_rx_sg_s *)start;
+		seg_addr = &sg->seg_addr;
+		for (seg = 0; seg < sg->segs; seg++, seg_addr++)
+			otx2_aura_freeptr(pfvf, qidx, *seg_addr & ~0x07ULL);
+		start += sizeof(*sg);
+	}
+}
+
 static bool otx2_check_rcv_errors(struct otx2_nic *pfvf,
 				  struct nix_cqe_rx_s *cqe, int qidx)
 {
@@ -189,16 +208,17 @@ static bool otx2_check_rcv_errors(struct otx2_nic *pfvf,
 		/* For now ignore all the NPC parser errors and
 		 * pass the packets to stack.
 		 */
-		return false;
+		if (cqe->sg.segs == 1)
+			return false;
 	}
 
 	/* If RXALL is enabled pass on packets to stack. */
-	if (cqe->sg.segs && (pfvf->netdev->features & NETIF_F_RXALL))
+	if (cqe->sg.segs == 1 && (pfvf->netdev->features & NETIF_F_RXALL))
 		return false;
 
 	/* Free buffer back to pool */
 	if (cqe->sg.segs)
-		otx2_aura_freeptr(pfvf, qidx, cqe->sg.seg_addr & ~0x07ULL);
+		otx2_free_rcv_seg(pfvf, cqe, qidx);
 	return true;
 }
 
@@ -210,7 +230,7 @@ static void otx2_rcv_pkt_handler(struct otx2_nic *pfvf,
 	struct nix_rx_parse_s *parse = &cqe->parse;
 	struct sk_buff *skb = NULL;
 
-	if (unlikely(parse->errlev || parse->errcode)) {
+	if (unlikely(parse->errlev || parse->errcode || cqe->sg.segs > 1)) {
 		if (otx2_check_rcv_errors(pfvf, cqe, cq->cq_idx))
 			return;
 	}
@@ -789,11 +809,15 @@ void otx2_cleanup_rx_cqes(struct otx2_nic *pfvf, struct otx2_cq_queue *cq)
 	while ((cqe = (struct nix_cqe_rx_s *)otx2_get_next_cqe(cq))) {
 		if (!cqe->sg.subdc)
 			continue;
+		processed_cqe++;
+		if (cqe->sg.segs > 1) {
+			otx2_free_rcv_seg(pfvf, cqe, cq->cq_idx);
+			continue;
+		}
 		iova = cqe->sg.seg_addr - OTX2_HEAD_ROOM;
 		pa = otx2_iova_to_phys(pfvf->iommu_domain, iova);
 		otx2_dma_unmap_page(pfvf, iova, pfvf->rbsize, DMA_FROM_DEVICE);
 		put_page(virt_to_page(phys_to_virt(pa)));
-		processed_cqe++;
 	}
 
 	/* Free CQEs to HW */
-- 
2.7.4

