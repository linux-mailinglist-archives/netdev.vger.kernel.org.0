Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 9389B180750
	for <lists+netdev@lfdr.de>; Tue, 10 Mar 2020 19:47:58 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727368AbgCJSrz (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 10 Mar 2020 14:47:55 -0400
Received: from mail-pf1-f195.google.com ([209.85.210.195]:34304 "EHLO
        mail-pf1-f195.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1727228AbgCJSrx (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 10 Mar 2020 14:47:53 -0400
Received: by mail-pf1-f195.google.com with SMTP id 23so5115780pfj.1
        for <netdev@vger.kernel.org>; Tue, 10 Mar 2020 11:47:52 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=from:to:cc:subject:date:message-id:in-reply-to:references;
        bh=karau37/iVbbQdOh1uB66piGE1r4/7zvhFgkICK6jT4=;
        b=eEULKDgHAc5aLMLsTKiTWtlF323vKTYvJnWsSubgDNjzdvt3BH8Lk8adxzC1BpX32N
         HAsfxOZ3HWnr6e1+ERsO0YOSqUSQx81nKBgvO5tx6afo2TimdGoS/YVSD2Ik14E2a3dA
         oyblojXREU71L9r5S5ao8ywbfkJrpUoTlQhHc+0lGdy63QGDm+rgnerhxVYU8l7Ij6ue
         KIsy7QzXPE+NUygIHJq4dY9hXqGLGWUcKO5ei9Tm6ErHfZt4JWB8Gi7GGqn4Cs8f4xef
         Wq4oDDHssZjBnHWkTun0koQZsJKgzSzmD2eTFwCpvVpMyKPBo3opcG68uQy360PyCXsY
         Pi0w==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references;
        bh=karau37/iVbbQdOh1uB66piGE1r4/7zvhFgkICK6jT4=;
        b=owPgPBTIGM1TGN5JmogoV7qjmy8zroqZp/1++fNgtc0mptgRxu0TiuVMmpbegQCdrW
         N1dlp3is+RiNI8yT/oLgO8mDAArMi7LZUryuczBQoYH7+ZmDCRTsmB7Vm00LQR/k7yH3
         YHAiA3nRPay9s82wj4JnHvHuXZUNXJoIyCMocJvYenk+WZDL5VRjnHMntDJi57dg3tSK
         GCPNlMEyd4WbAtugn9yHpxcR+z3HRCBc+r2ReoZvU7jzDHaWuLsep5VGTOV+TA3dnH7+
         IrT6HWEIE48+UWODLl92/cWk7WiKmCIylHGtDHUp1E22Yn4gzDmtPv9tZVpmWzod8VMX
         hwpw==
X-Gm-Message-State: ANhLgQ2wNCXSGp7oi+o2hgRuwb1Y8hizkp44J25UcP+mLb8wWBZNfRfq
        p/AzlxApM3xpvppRrmBNd4xqs2tnr2E=
X-Google-Smtp-Source: ADFU+vvvpEpLIcXYCkcIygL3dAlLdsh4pHWuujTVNoGRHpITOHY7LNyVZUAEzZGZGG/FedU3ouOIkA==
X-Received: by 2002:a63:309:: with SMTP id 9mr22119337pgd.193.1583866071537;
        Tue, 10 Mar 2020 11:47:51 -0700 (PDT)
Received: from machine421.marvell.com ([115.113.156.2])
        by smtp.googlemail.com with ESMTPSA id v67sm4240490pfc.120.2020.03.10.11.47.49
        (version=TLS1_2 cipher=ECDHE-RSA-AES128-SHA bits=128/128);
        Tue, 10 Mar 2020 11:47:50 -0700 (PDT)
From:   sunil.kovvuri@gmail.com
To:     netdev@vger.kernel.org
Cc:     davem@davemloft.net, Geetha sowjanya <gakula@marvell.com>,
        Sunil Goutham <sgoutham@marvell.com>
Subject: [PATCH net-next 6/6] octeontx2-pf: Cleanup all receive buffers in SG descriptor
Date:   Wed, 11 Mar 2020 00:17:25 +0530
Message-Id: <1583866045-7129-7-git-send-email-sunil.kovvuri@gmail.com>
X-Mailer: git-send-email 2.7.4
In-Reply-To: <1583866045-7129-1-git-send-email-sunil.kovvuri@gmail.com>
References: <1583866045-7129-1-git-send-email-sunil.kovvuri@gmail.com>
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
index 3d95dbc..475d9ea 100644
--- a/drivers/net/ethernet/marvell/octeontx2/nic/otx2_common.c
+++ b/drivers/net/ethernet/marvell/octeontx2/nic/otx2_common.c
@@ -212,8 +212,6 @@ int otx2_hw_set_mtu(struct otx2_nic *pfvf, int mtu)
 		return -ENOMEM;
 	}
 
-	/* SMQ config limits maximum pkt size that can be transmitted */
-	req->update_smq = true;
 	pfvf->max_frs = mtu +  OTX2_ETH_HLEN;
 	req->maxlen = pfvf->max_frs;
 
@@ -469,7 +467,7 @@ int otx2_txschq_config(struct otx2_nic *pfvf, int lvl)
 	/* Set topology e.t.c configuration */
 	if (lvl == NIX_TXSCH_LVL_SMQ) {
 		req->reg[0] = NIX_AF_SMQX_CFG(schq);
-		req->regval[0] = ((pfvf->netdev->mtu  + OTX2_ETH_HLEN) << 8) |
+		req->regval[0] = ((OTX2_MAX_MTU + OTX2_ETH_HLEN) << 8) |
 				   OTX2_MIN_MTU;
 
 		req->regval[0] |= (0x20ULL << 51) | (0x80ULL << 39) |
@@ -579,17 +577,19 @@ void otx2_sqb_flush(struct otx2_nic *pfvf)
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
@@ -985,6 +985,7 @@ void otx2_aura_pool_free(struct otx2_nic *pfvf)
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

