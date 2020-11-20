Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id F06AA2BA253
	for <lists+netdev@lfdr.de>; Fri, 20 Nov 2020 07:30:00 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726281AbgKTG3P (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 20 Nov 2020 01:29:15 -0500
Received: from mx0a-0016f401.pphosted.com ([67.231.148.174]:45956 "EHLO
        mx0b-0016f401.pphosted.com" rhost-flags-OK-OK-OK-FAIL)
        by vger.kernel.org with ESMTP id S1725797AbgKTG3O (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 20 Nov 2020 01:29:14 -0500
Received: from pps.filterd (m0045849.ppops.net [127.0.0.1])
        by mx0a-0016f401.pphosted.com (8.16.0.42/8.16.0.42) with SMTP id 0AK6PAUS008245;
        Thu, 19 Nov 2020 22:28:19 -0800
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=marvell.com; h=from : to : cc :
 subject : date : message-id : in-reply-to : references : mime-version :
 content-transfer-encoding : content-type; s=pfpt0220;
 bh=G3e7sUeu0hu4liVgKC/Dv4fwtvYkXe0qfGaAJY58CSg=;
 b=GHRvYBQL7fKaNUlfxJzr6L6GmZn/LZUrUT3CxLePT0mEcabFcPmcVwjuU29o26jtTboN
 cAS8XTtFW9+cPM5T2QT8MAWaFJy2JPoCOQGYfh2lL079qIc3JpDbNrCM4qyyUHGhbUna
 XG79Rt+HfpOLnDElQGOA/7pTZFC3yyp6jjpzVboZz1xTDg2mfC0TS6Bxzp/KPuzcSBWq
 WyqabSuQLhWf+r1NxVvwJUT3BoBpNHoP2+h7+xLDlx/yfM88MdpE1EkL/Fzcv5lEqRH/
 FXTzXIfFhUiDpZQ+nH0LJwghoPAvQUp/5gsVUNPqf7+bbAMrGQrJJ7Z/qtQg5DnwUbxR Vg== 
Received: from sc-exch02.marvell.com ([199.233.58.182])
        by mx0a-0016f401.pphosted.com with ESMTP id 34vd2sne72-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-SHA384 bits=256 verify=NOT);
        Thu, 19 Nov 2020 22:28:19 -0800
Received: from DC5-EXCH01.marvell.com (10.69.176.38) by SC-EXCH02.marvell.com
 (10.93.176.82) with Microsoft SMTP Server (TLS) id 15.0.1497.2; Thu, 19 Nov
 2020 22:28:18 -0800
Received: from maili.marvell.com (10.69.176.80) by DC5-EXCH01.marvell.com
 (10.69.176.38) with Microsoft SMTP Server id 15.0.1497.2 via Frontend
 Transport; Thu, 19 Nov 2020 22:28:18 -0800
Received: from hyd1584.caveonetworks.com (unknown [10.29.37.82])
        by maili.marvell.com (Postfix) with ESMTP id E9FB53F7040;
        Thu, 19 Nov 2020 22:28:14 -0800 (PST)
From:   George Cherian <george.cherian@marvell.com>
To:     <netdev@vger.kernel.org>, <linux-kernel@vger.kernel.org>
CC:     <kuba@kernel.org>, <davem@davemloft.net>, <sgoutham@marvell.com>,
        <lcherian@marvell.com>, <gakula@marvell.com>,
        <masahiroy@kernel.org>, <george.cherian@marvell.com>,
        <willemdebruijn.kernel@gmail.com>, <saeed@kernel.org>
Subject: [PATCHv3 net-next 3/3] octeontx2-af: Add devlink health reporters for NIX
Date:   Fri, 20 Nov 2020 11:58:01 +0530
Message-ID: <20201120062801.2821502-4-george.cherian@marvell.com>
X-Mailer: git-send-email 2.25.1
In-Reply-To: <20201120062801.2821502-1-george.cherian@marvell.com>
References: <20201120062801.2821502-1-george.cherian@marvell.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-Proofpoint-Virus-Version: vendor=fsecure engine=2.50.10434:6.0.312,18.0.737
 definitions=2020-11-20_03:2020-11-19,2020-11-20 signatures=0
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Add health reporters for RVU NIX block.
NIX Health reporter handle following HW event groups
 - GENERAL events
 - RAS events
 - RVU event
An event counter per event is maintained in SW.

Output:
 # ./devlink health
 pci/0002:01:00.0:
   reporter npa
     state healthy error 0 recover 0
   reporter nix
     state healthy error 0 recover 0
 # ./devlink  health dump show pci/0002:01:00.0 reporter nix
  NIX_AF_GENERAL:
         Memory Fault on NIX_AQ_INST_S read: 0
         Memory Fault on NIX_AQ_RES_S write: 0
         AQ Doorbell error: 0
         Rx on unmapped PF_FUNC: 0
         Rx multicast replication error: 0
         Memory fault on NIX_RX_MCE_S read: 0
         Memory fault on multicast WQE read: 0
         Memory fault on mirror WQE read: 0
         Memory fault on mirror pkt write: 0
         Memory fault on multicast pkt write: 0
   NIX_AF_RAS:
         Poisoned data on NIX_AQ_INST_S read: 0
         Poisoned data on NIX_AQ_RES_S write: 0
         Poisoned data on HW context read: 0
         Poisoned data on packet read from mirror buffer: 0
         Poisoned data on packet read from mcast buffer: 0
         Poisoned data on WQE read from mirror buffer: 0
         Poisoned data on WQE read from multicast buffer: 0
         Poisoned data on NIX_RX_MCE_S read: 0
   NIX_AF_RVU:
         Unmap Slot Error: 0

Signed-off-by: Sunil Kovvuri Goutham <sgoutham@marvell.com>
Signed-off-by: Jerin Jacob <jerinj@marvell.com>
Signed-off-by: George Cherian <george.cherian@marvell.com>
---
 .../marvell/octeontx2/af/rvu_devlink.c        | 414 +++++++++++++++++-
 .../marvell/octeontx2/af/rvu_devlink.h        |  31 ++
 .../marvell/octeontx2/af/rvu_struct.h         |  10 +
 3 files changed, 453 insertions(+), 2 deletions(-)

diff --git a/drivers/net/ethernet/marvell/octeontx2/af/rvu_devlink.c b/drivers/net/ethernet/marvell/octeontx2/af/rvu_devlink.c
index b7f0691d86b0..c02d0f56ae7a 100644
--- a/drivers/net/ethernet/marvell/octeontx2/af/rvu_devlink.c
+++ b/drivers/net/ethernet/marvell/octeontx2/af/rvu_devlink.c
@@ -35,6 +35,131 @@ static int rvu_report_pair_end(struct devlink_fmsg *fmsg)
 	return devlink_fmsg_pair_nest_end(fmsg);
 }
 
+static irqreturn_t rvu_nix_af_rvu_intr_handler(int irq, void *rvu_irq)
+{
+	struct rvu_nix_event_ctx *nix_event_context;
+	struct rvu_nix_event_cnt *nix_event_count;
+	struct rvu_devlink *rvu_dl = rvu_irq;
+	struct rvu *rvu;
+	int blkaddr;
+	u64 intr;
+
+	rvu = rvu_dl->rvu;
+	blkaddr = rvu_get_blkaddr(rvu, BLKTYPE_NIX, 0);
+	if (blkaddr < 0)
+		return IRQ_NONE;
+
+	nix_event_context = rvu_dl->nix_event_ctx;
+	nix_event_count = &nix_event_context->nix_event_cnt;
+	intr = rvu_read64(rvu, blkaddr, NIX_AF_RVU_INT);
+	nix_event_context->nix_af_rvu_int = intr;
+
+	if (intr & BIT_ULL(0))
+		nix_event_count->unmap_slot_count++;
+
+	/* Clear interrupts */
+	rvu_write64(rvu, blkaddr, NIX_AF_RVU_INT, intr);
+	rvu_write64(rvu, blkaddr, NIX_AF_RVU_INT_ENA_W1C, ~0ULL);
+	devlink_health_report(rvu_dl->rvu_nix_health_reporter, "NIX_AF_RVU Error",
+			      nix_event_context);
+
+	return IRQ_HANDLED;
+}
+
+static irqreturn_t rvu_nix_af_err_intr_handler(int irq, void *rvu_irq)
+{
+	struct rvu_nix_event_ctx *nix_event_context;
+	struct rvu_nix_event_cnt *nix_event_count;
+	struct rvu_devlink *rvu_dl = rvu_irq;
+	struct rvu *rvu;
+	int blkaddr;
+	u64 intr;
+
+	rvu = rvu_dl->rvu;
+	blkaddr = rvu_get_blkaddr(rvu, BLKTYPE_NIX, 0);
+	if (blkaddr < 0)
+		return IRQ_NONE;
+
+	nix_event_context = rvu_dl->nix_event_ctx;
+	nix_event_count = &nix_event_context->nix_event_cnt;
+	intr = rvu_read64(rvu, blkaddr, NIX_AF_ERR_INT);
+	nix_event_context->nix_af_rvu_err = intr;
+
+	if (intr & BIT_ULL(14))
+		nix_event_count->aq_inst_count++;
+	if (intr & BIT_ULL(13))
+		nix_event_count->aq_res_count++;
+	if (intr & BIT_ULL(12))
+		nix_event_count->aq_db_count++;
+	if (intr & BIT_ULL(6))
+		nix_event_count->rx_on_unmap_pf_count++;
+	if (intr & BIT_ULL(5))
+		nix_event_count->rx_mcast_repl_count++;
+	if (intr & BIT_ULL(4))
+		nix_event_count->rx_mcast_memfault_count++;
+	if (intr & BIT_ULL(3))
+		nix_event_count->rx_mcast_wqe_memfault_count++;
+	if (intr & BIT_ULL(2))
+		nix_event_count->rx_mirror_wqe_memfault_count++;
+	if (intr & BIT_ULL(1))
+		nix_event_count->rx_mirror_pktw_memfault_count++;
+	if (intr & BIT_ULL(0))
+		nix_event_count->rx_mcast_pktw_memfault_count++;
+
+	/* Clear interrupts */
+	rvu_write64(rvu, blkaddr, NIX_AF_ERR_INT, intr);
+	rvu_write64(rvu, blkaddr, NIX_AF_ERR_INT_ENA_W1C, ~0ULL);
+	devlink_health_report(rvu_dl->rvu_nix_health_reporter, "NIX_AF_ERR Error",
+			      nix_event_context);
+
+	return IRQ_HANDLED;
+}
+
+static irqreturn_t rvu_nix_af_ras_intr_handler(int irq, void *rvu_irq)
+{
+	struct rvu_nix_event_ctx *nix_event_context;
+	struct rvu_nix_event_cnt *nix_event_count;
+	struct rvu_devlink *rvu_dl = rvu_irq;
+	struct rvu *rvu;
+	int blkaddr;
+	u64 intr;
+
+	rvu = rvu_dl->rvu;
+	blkaddr = rvu_get_blkaddr(rvu, BLKTYPE_NIX, 0);
+	if (blkaddr < 0)
+		return IRQ_NONE;
+
+	nix_event_context = rvu_dl->nix_event_ctx;
+	nix_event_count = &nix_event_context->nix_event_cnt;
+	intr = rvu_read64(rvu, blkaddr, NIX_AF_RAS);
+	nix_event_context->nix_af_rvu_ras = intr;
+
+	if (intr & BIT_ULL(34))
+		nix_event_count->poison_aq_inst_count++;
+	if (intr & BIT_ULL(33))
+		nix_event_count->poison_aq_res_count++;
+	if (intr & BIT_ULL(32))
+		nix_event_count->poison_aq_cxt_count++;
+	if (intr & BIT_ULL(4))
+		nix_event_count->rx_mirror_data_poison_count++;
+	if (intr & BIT_ULL(3))
+		nix_event_count->rx_mcast_data_poison_count++;
+	if (intr & BIT_ULL(2))
+		nix_event_count->rx_mirror_wqe_poison_count++;
+	if (intr & BIT_ULL(1))
+		nix_event_count->rx_mcast_wqe_poison_count++;
+	if (intr & BIT_ULL(0))
+		nix_event_count->rx_mce_poison_count++;
+
+	/* Clear interrupts */
+	rvu_write64(rvu, blkaddr, NIX_AF_RAS, intr);
+	rvu_write64(rvu, blkaddr, NIX_AF_RAS_ENA_W1C, ~0ULL);
+	devlink_health_report(rvu_dl->rvu_nix_health_reporter, "NIX_AF_RAS Error",
+			      nix_event_context);
+
+	return IRQ_HANDLED;
+}
+
 static bool rvu_common_request_irq(struct rvu *rvu, int offset,
 				   const char *name, irq_handler_t fn)
 {
@@ -52,6 +177,285 @@ static bool rvu_common_request_irq(struct rvu *rvu, int offset,
 	return rvu->irq_allocated[offset];
 }
 
+static void rvu_nix_blk_unregister_interrupts(struct rvu *rvu,
+					      int blkaddr)
+{
+	struct rvu_devlink *rvu_dl = rvu->rvu_dl;
+	int offs, i;
+
+	offs = rvu_read64(rvu, blkaddr, NIX_PRIV_AF_INT_CFG) & 0x3ff;
+	if (!offs)
+		return;
+
+	rvu_write64(rvu, blkaddr, NIX_AF_RVU_INT_ENA_W1C, ~0ULL);
+	rvu_write64(rvu, blkaddr, NIX_AF_ERR_INT_ENA_W1C, ~0ULL);
+	rvu_write64(rvu, blkaddr, NIX_AF_RAS_ENA_W1C, ~0ULL);
+
+	if (rvu->irq_allocated[offs + NIX_AF_INT_VEC_RVU]) {
+		free_irq(pci_irq_vector(rvu->pdev, offs + NIX_AF_INT_VEC_RVU),
+			 rvu_dl);
+		rvu->irq_allocated[offs + NIX_AF_INT_VEC_RVU] = false;
+	}
+
+	for (i = NIX_AF_INT_VEC_AF_ERR; i < NIX_AF_INT_VEC_CNT; i++)
+		if (rvu->irq_allocated[offs + i]) {
+			free_irq(pci_irq_vector(rvu->pdev, offs + i), rvu_dl);
+			rvu->irq_allocated[offs + i] = false;
+		}
+}
+
+static void rvu_nix_unregister_interrupts(struct rvu *rvu)
+{
+	int blkaddr = 0;
+
+	blkaddr = rvu_get_blkaddr(rvu, BLKTYPE_NIX, 0);
+	if (blkaddr < 0)
+		return;
+
+	rvu_nix_blk_unregister_interrupts(rvu, blkaddr);
+}
+
+static int rvu_nix_blk_register_interrupts(struct rvu *rvu,
+					   int blkaddr)
+{
+	int base;
+	bool rc;
+
+	/* Get NIX AF MSIX vectors offset. */
+	base = rvu_read64(rvu, blkaddr, NIX_PRIV_AF_INT_CFG) & 0x3ff;
+	if (!base) {
+		dev_warn(rvu->dev,
+			 "Failed to get NIX%d NIX_AF_INT vector offsets\n",
+			 blkaddr - BLKADDR_NIX0);
+		return 0;
+	}
+	/* Register and enable NIX_AF_RVU_INT interrupt */
+	rc = rvu_common_request_irq(rvu, base +  NIX_AF_INT_VEC_RVU,
+				    "NIX_AF_RVU_INT",
+				    rvu_nix_af_rvu_intr_handler);
+	if (!rc)
+		goto err;
+	rvu_write64(rvu, blkaddr, NIX_AF_RVU_INT_ENA_W1S, ~0ULL);
+
+	/* Register and enable NIX_AF_ERR_INT interrupt */
+	rc = rvu_common_request_irq(rvu, base + NIX_AF_INT_VEC_AF_ERR,
+				    "NIX_AF_ERR_INT",
+				    rvu_nix_af_err_intr_handler);
+	if (!rc)
+		goto err;
+	rvu_write64(rvu, blkaddr, NIX_AF_ERR_INT_ENA_W1S, ~0ULL);
+
+	/* Register and enable NIX_AF_RAS interrupt */
+	rc = rvu_common_request_irq(rvu, base + NIX_AF_INT_VEC_POISON,
+				    "NIX_AF_RAS",
+				    rvu_nix_af_ras_intr_handler);
+	if (!rc)
+		goto err;
+	rvu_write64(rvu, blkaddr, NIX_AF_RAS_ENA_W1S, ~0ULL);
+
+	return 0;
+err:
+	rvu_nix_unregister_interrupts(rvu);
+	return -1;
+}
+
+static int rvu_nix_register_interrupts(struct rvu *rvu)
+{
+	int blkaddr = 0;
+
+	blkaddr = rvu_get_blkaddr(rvu, BLKTYPE_NIX, 0);
+	if (blkaddr < 0)
+		return blkaddr;
+
+	rvu_nix_blk_register_interrupts(rvu, blkaddr);
+
+	return 0;
+}
+
+static int rvu_nix_report_show(struct devlink_fmsg *fmsg, struct rvu *rvu)
+{
+	struct rvu_nix_event_ctx *nix_event_context;
+	struct rvu_nix_event_cnt *nix_event_count;
+	struct rvu_devlink *rvu_dl = rvu->rvu_dl;
+	int err;
+
+	nix_event_context = rvu_dl->nix_event_ctx;
+	nix_event_count = &nix_event_context->nix_event_cnt;
+	err = rvu_report_pair_start(fmsg, "NIX_AF_GENERAL");
+	if (err)
+		return err;
+	err = devlink_fmsg_u64_pair_put(fmsg, "\tMemory Fault on NIX_AQ_INST_S read",
+					nix_event_count->aq_inst_count);
+	if (err)
+		return err;
+	err = devlink_fmsg_u64_pair_put(fmsg, "\n\tMemory Fault on NIX_AQ_RES_S write",
+					nix_event_count->aq_res_count);
+	if (err)
+		return err;
+	err = devlink_fmsg_u64_pair_put(fmsg, "\n\tAQ Doorbell error",
+					nix_event_count->aq_db_count);
+	if (err)
+		return err;
+	err = devlink_fmsg_u64_pair_put(fmsg, "\n\tRx on unmapped PF_FUNC",
+					nix_event_count->rx_on_unmap_pf_count);
+	if (err)
+		return err;
+	err = devlink_fmsg_u64_pair_put(fmsg, "\n\tRx multicast replication error",
+					nix_event_count->rx_mcast_repl_count);
+	if (err)
+		return err;
+	err = devlink_fmsg_u64_pair_put(fmsg, "\n\tMemory fault on NIX_RX_MCE_S read",
+					nix_event_count->rx_mcast_memfault_count);
+	if (err)
+		return err;
+	err = devlink_fmsg_u64_pair_put(fmsg, "\n\tMemory fault on multicast WQE read",
+					nix_event_count->rx_mcast_wqe_memfault_count);
+	if (err)
+		return err;
+	err = devlink_fmsg_u64_pair_put(fmsg, "\n\tMemory fault on mirror WQE read",
+					nix_event_count->rx_mirror_wqe_memfault_count);
+	if (err)
+		return err;
+	err = devlink_fmsg_u64_pair_put(fmsg, "\n\tMemory fault on mirror pkt write",
+					nix_event_count->rx_mirror_pktw_memfault_count);
+	if (err)
+		return err;
+	err = devlink_fmsg_u64_pair_put(fmsg, "\n\tMemory fault on multicast pkt write",
+					nix_event_count->rx_mcast_pktw_memfault_count);
+	if (err)
+		return err;
+	err = rvu_report_pair_end(fmsg);
+	if (err)
+		return err;
+	err = rvu_report_pair_start(fmsg, "NIX_AF_RAS");
+	if (err)
+		return err;
+	err = devlink_fmsg_u64_pair_put(fmsg, "\tPoisoned data on NIX_AQ_INST_S read",
+					nix_event_count->poison_aq_inst_count);
+	if (err)
+		return err;
+	err = devlink_fmsg_u64_pair_put(fmsg, "\n\tPoisoned data on NIX_AQ_RES_S write",
+					nix_event_count->poison_aq_res_count);
+	if (err)
+		return err;
+	err = devlink_fmsg_u64_pair_put(fmsg, "\n\tPoisoned data on HW context read",
+					nix_event_count->poison_aq_cxt_count);
+	if (err)
+		return err;
+	err = devlink_fmsg_u64_pair_put(fmsg, "\n\tPoisoned data on packet read from mirror buffer",
+					nix_event_count->rx_mirror_data_poison_count);
+	if (err)
+		return err;
+	err = devlink_fmsg_u64_pair_put(fmsg, "\n\tPoisoned data on packet read from mcast buffer",
+					nix_event_count->rx_mcast_data_poison_count);
+	if (err)
+		return err;
+	err = devlink_fmsg_u64_pair_put(fmsg, "\n\tPoisoned data on WQE read from mirror buffer",
+					nix_event_count->rx_mirror_wqe_poison_count);
+	if (err)
+		return err;
+	err = devlink_fmsg_u64_pair_put(fmsg, "\n\tPoisoned data on WQE read from multicast buffer",
+					nix_event_count->rx_mcast_wqe_poison_count);
+	if (err)
+		return err;
+	err = devlink_fmsg_u64_pair_put(fmsg, "\n\tPoisoned data on NIX_RX_MCE_S read",
+					nix_event_count->rx_mce_poison_count);
+	if (err)
+		return err;
+	err = rvu_report_pair_end(fmsg);
+	if (err)
+		return err;
+	err = rvu_report_pair_start(fmsg, "NIX_AF_RVU");
+	if (err)
+		return err;
+	err = devlink_fmsg_u64_pair_put(fmsg, "\tUnmap Slot Error",
+					nix_event_count->unmap_slot_count);
+	if (err)
+		return err;
+	err = rvu_report_pair_end(fmsg);
+	if (err)
+		return err;
+	return 0;
+}
+
+static int rvu_nix_reporter_dump(struct devlink_health_reporter *reporter,
+				 struct devlink_fmsg *fmsg, void *ctx,
+				 struct netlink_ext_ack *netlink_extack)
+{
+	struct rvu *rvu = devlink_health_reporter_priv(reporter);
+
+	return rvu_nix_report_show(fmsg, rvu);
+}
+
+static int rvu_nix_reporter_recover(struct devlink_health_reporter *reporter,
+				    void *ctx, struct netlink_ext_ack *netlink_extack)
+{
+	struct rvu *rvu = devlink_health_reporter_priv(reporter);
+	struct rvu_nix_event_ctx *nix_event_ctx = ctx;
+	int blkaddr;
+
+	blkaddr = rvu_get_blkaddr(rvu, BLKTYPE_NIX, 0);
+	if (blkaddr < 0)
+		return blkaddr;
+
+	if (nix_event_ctx->nix_af_rvu_int) {
+		rvu_write64(rvu, blkaddr, NIX_AF_RVU_INT_ENA_W1S, ~0ULL);
+		nix_event_ctx->nix_af_rvu_int = 0;
+	}
+	if (nix_event_ctx->nix_af_rvu_err) {
+		rvu_write64(rvu, blkaddr, NIX_AF_ERR_INT_ENA_W1S, ~0ULL);
+		nix_event_ctx->nix_af_rvu_err = 0;
+	}
+	if (nix_event_ctx->nix_af_rvu_ras) {
+		rvu_write64(rvu, blkaddr, NIX_AF_RAS_ENA_W1S, ~0ULL);
+		nix_event_ctx->nix_af_rvu_ras = 0;
+	}
+
+	return 0;
+}
+
+static const struct devlink_health_reporter_ops rvu_nix_fault_reporter_ops = {
+		.name = "hw_nix",
+		.dump = rvu_nix_reporter_dump,
+		.recover = rvu_nix_reporter_recover,
+};
+
+static int rvu_nix_health_reporters_create(struct rvu_devlink *rvu_dl)
+{
+	struct devlink_health_reporter *rvu_nix_health_reporter;
+	struct rvu_nix_event_ctx *nix_event_context;
+	struct rvu *rvu = rvu_dl->rvu;
+
+	nix_event_context = kzalloc(sizeof(*nix_event_context), GFP_KERNEL);
+	if (!nix_event_context)
+		return -ENOMEM;
+
+	rvu_dl->nix_event_ctx = nix_event_context;
+	rvu_nix_health_reporter = devlink_health_reporter_create(rvu_dl->dl,
+								 &rvu_nix_fault_reporter_ops,
+								 0, rvu);
+	if (IS_ERR(rvu_nix_health_reporter)) {
+		dev_warn(rvu->dev, "Failed to create nix reporter, err = %ld\n",
+			 PTR_ERR(rvu_nix_health_reporter));
+		return PTR_ERR(rvu_nix_health_reporter);
+	}
+
+	rvu_dl->rvu_nix_health_reporter = rvu_nix_health_reporter;
+	rvu_nix_register_interrupts(rvu);
+	return 0;
+}
+
+static void rvu_nix_health_reporters_destroy(struct rvu_devlink *rvu_dl)
+{
+	struct rvu *rvu = rvu_dl->rvu;
+
+	if (!rvu_dl->rvu_nix_health_reporter)
+		return;
+
+	devlink_health_reporter_destroy(rvu_dl->rvu_nix_health_reporter);
+	rvu_nix_unregister_interrupts(rvu);
+}
+
 static irqreturn_t rvu_npa_af_rvu_intr_handler(int irq, void *rvu_irq)
 {
 	struct rvu_npa_event_ctx *npa_event_context;
@@ -214,7 +618,7 @@ static irqreturn_t rvu_npa_af_ras_intr_handler(int irq, void *rvu_irq)
 	/* Clear interrupts */
 	rvu_write64(rvu, blkaddr, NPA_AF_RAS, intr);
 	rvu_write64(rvu, blkaddr, NPA_AF_RAS_ENA_W1C, ~0ULL);
-	devlink_health_report(rvu_dl->rvu_npa_health_reporter, "HW NPA_AF_RAS Error reported",
+	devlink_health_report(rvu_dl->rvu_npa_health_reporter, "NPA_AF_RAS Error",
 			      npa_event_context);
 	return IRQ_HANDLED;
 }
@@ -481,9 +885,14 @@ static void rvu_npa_health_reporters_destroy(struct rvu_devlink *rvu_dl)
 static int rvu_health_reporters_create(struct rvu *rvu)
 {
 	struct rvu_devlink *rvu_dl;
+	int err;
 
 	rvu_dl = rvu->rvu_dl;
-	return rvu_npa_health_reporters_create(rvu_dl);
+	err = rvu_npa_health_reporters_create(rvu_dl);
+	if (err)
+		return err;
+
+	return rvu_nix_health_reporters_create(rvu_dl);
 }
 
 static void rvu_health_reporters_destroy(struct rvu *rvu)
@@ -495,6 +904,7 @@ static void rvu_health_reporters_destroy(struct rvu *rvu)
 
 	rvu_dl = rvu->rvu_dl;
 	rvu_npa_health_reporters_destroy(rvu_dl);
+	rvu_nix_health_reporters_destroy(rvu_dl);
 }
 
 static int rvu_devlink_info_get(struct devlink *devlink, struct devlink_info_req *req,
diff --git a/drivers/net/ethernet/marvell/octeontx2/af/rvu_devlink.h b/drivers/net/ethernet/marvell/octeontx2/af/rvu_devlink.h
index e04603a9952c..cfc513d945a0 100644
--- a/drivers/net/ethernet/marvell/octeontx2/af/rvu_devlink.h
+++ b/drivers/net/ethernet/marvell/octeontx2/af/rvu_devlink.h
@@ -37,11 +37,42 @@ struct rvu_npa_event_ctx {
 	u64 npa_af_rvu_ras;
 };
 
+struct rvu_nix_event_cnt {
+	u64 unmap_slot_count;
+	u64 aq_inst_count;
+	u64 aq_res_count;
+	u64 aq_db_count;
+	u64 rx_on_unmap_pf_count;
+	u64 rx_mcast_repl_count;
+	u64 rx_mcast_memfault_count;
+	u64 rx_mcast_wqe_memfault_count;
+	u64 rx_mirror_wqe_memfault_count;
+	u64 rx_mirror_pktw_memfault_count;
+	u64 rx_mcast_pktw_memfault_count;
+	u64 poison_aq_inst_count;
+	u64 poison_aq_res_count;
+	u64 poison_aq_cxt_count;
+	u64 rx_mirror_data_poison_count;
+	u64 rx_mcast_data_poison_count;
+	u64 rx_mirror_wqe_poison_count;
+	u64 rx_mcast_wqe_poison_count;
+	u64 rx_mce_poison_count;
+};
+
+struct rvu_nix_event_ctx {
+	struct rvu_nix_event_cnt nix_event_cnt;
+	u64 nix_af_rvu_int;
+	u64 nix_af_rvu_err;
+	u64 nix_af_rvu_ras;
+};
+
 struct rvu_devlink {
 	struct devlink *dl;
 	struct rvu *rvu;
 	struct devlink_health_reporter *rvu_npa_health_reporter;
 	struct rvu_npa_event_ctx *npa_event_ctx;
+	struct devlink_health_reporter *rvu_nix_health_reporter;
+	struct rvu_nix_event_ctx *nix_event_ctx;
 };
 
 /* Devlink APIs */
diff --git a/drivers/net/ethernet/marvell/octeontx2/af/rvu_struct.h b/drivers/net/ethernet/marvell/octeontx2/af/rvu_struct.h
index 995add5d8bff..b5944199faf5 100644
--- a/drivers/net/ethernet/marvell/octeontx2/af/rvu_struct.h
+++ b/drivers/net/ethernet/marvell/octeontx2/af/rvu_struct.h
@@ -74,6 +74,16 @@ enum npa_af_int_vec_e {
 	NPA_AF_INT_VEC_CNT	= 0x5,
 };
 
+/* NIX Admin function Interrupt Vector Enumeration */
+enum nix_af_int_vec_e {
+	NIX_AF_INT_VEC_RVU	= 0x0,
+	NIX_AF_INT_VEC_GEN	= 0x1,
+	NIX_AF_INT_VEC_AQ_DONE	= 0x2,
+	NIX_AF_INT_VEC_AF_ERR	= 0x3,
+	NIX_AF_INT_VEC_POISON	= 0x4,
+	NIX_AF_INT_VEC_CNT	= 0x5,
+};
+
 /**
  * RVU PF Interrupt Vector Enumeration
  */
-- 
2.25.1

