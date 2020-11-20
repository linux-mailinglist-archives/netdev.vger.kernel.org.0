Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id A00242BA255
	for <lists+netdev@lfdr.de>; Fri, 20 Nov 2020 07:30:01 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1725797AbgKTG3Q (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 20 Nov 2020 01:29:16 -0500
Received: from mx0a-0016f401.pphosted.com ([67.231.148.174]:41654 "EHLO
        mx0b-0016f401.pphosted.com" rhost-flags-OK-OK-OK-FAIL)
        by vger.kernel.org with ESMTP id S1725801AbgKTG3P (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 20 Nov 2020 01:29:15 -0500
Received: from pps.filterd (m0045849.ppops.net [127.0.0.1])
        by mx0a-0016f401.pphosted.com (8.16.0.42/8.16.0.42) with SMTP id 0AK6P8IC008192;
        Thu, 19 Nov 2020 22:28:16 -0800
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=marvell.com; h=from : to : cc :
 subject : date : message-id : in-reply-to : references : mime-version :
 content-transfer-encoding : content-type; s=pfpt0220;
 bh=i5E3IEDINS1YeVHjwz71y5/i86jEmQWqgcvkUWa5p+k=;
 b=i40z62uWdOJcANlFtzMXtbYPSGEhqOhy1e0g31J7oVCCMzUxCq3/o35vtxEHK7qQq/uR
 Cc0dPxa2Ccej27K/17b4JI+22A+eGzbgulW8up9xc/2Kgt+8EAlcvOagZGmVHJBKqzOU
 NAlMpuof4qmgxpAQxjrqCaTdj0+SKrTSKBUjYfJrXQSHCjGwOcSuUc8kvdtGrI4Pfvmm
 /ysa5dMBkC2W4Wc0vlvTrcSUSzsu94368ho85nf5pPunaPdbBMGUySLK+JfCnoURoJsS
 DFZ30QNCMfavRqi8OfmB4y2rPIovv95pJawwDnv/JXDBdohA9xTDNYj4yTzJZBl+/Q6h wg== 
Received: from sc-exch02.marvell.com ([199.233.58.182])
        by mx0a-0016f401.pphosted.com with ESMTP id 34vd2sne6x-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-SHA384 bits=256 verify=NOT);
        Thu, 19 Nov 2020 22:28:15 -0800
Received: from SC-EXCH04.marvell.com (10.93.176.84) by SC-EXCH02.marvell.com
 (10.93.176.82) with Microsoft SMTP Server (TLS) id 15.0.1497.2; Thu, 19 Nov
 2020 22:28:14 -0800
Received: from DC5-EXCH01.marvell.com (10.69.176.38) by SC-EXCH04.marvell.com
 (10.93.176.84) with Microsoft SMTP Server (TLS) id 15.0.1497.2; Thu, 19 Nov
 2020 22:28:14 -0800
Received: from maili.marvell.com (10.69.176.80) by DC5-EXCH01.marvell.com
 (10.69.176.38) with Microsoft SMTP Server id 15.0.1497.2 via Frontend
 Transport; Thu, 19 Nov 2020 22:28:14 -0800
Received: from hyd1584.caveonetworks.com (unknown [10.29.37.82])
        by maili.marvell.com (Postfix) with ESMTP id 82B873F7040;
        Thu, 19 Nov 2020 22:28:10 -0800 (PST)
From:   George Cherian <george.cherian@marvell.com>
To:     <netdev@vger.kernel.org>, <linux-kernel@vger.kernel.org>
CC:     <kuba@kernel.org>, <davem@davemloft.net>, <sgoutham@marvell.com>,
        <lcherian@marvell.com>, <gakula@marvell.com>,
        <masahiroy@kernel.org>, <george.cherian@marvell.com>,
        <willemdebruijn.kernel@gmail.com>, <saeed@kernel.org>
Subject: [PATCHv3 net-next 2/3] octeontx2-af: Add devlink health reporters for NPA
Date:   Fri, 20 Nov 2020 11:58:00 +0530
Message-ID: <20201120062801.2821502-3-george.cherian@marvell.com>
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

Add health reporters for RVU NPA block.
NPA Health reporters handle following HW event groups
 - GENERAL events
 - ERROR events
 - RAS events
 - RVU event
An event counter per event is maintained in SW.

Output:
 # devlink health
 pci/0002:01:00.0:
   reporter npa
     state healthy error 0 recover 0
 # devlink  health dump show pci/0002:01:00.0 reporter npa
 NPA_AF_GENERAL:
        Unmap PF Error: 0
        Free Disabled for NIX0 RX: 0
        Free Disabled for NIX0 TX: 0
        Free Disabled for NIX1 RX: 0
        Free Disabled for NIX1 TX: 0
        Free Disabled for SSO: 0
        Free Disabled for TIM: 0
        Free Disabled for DPI: 0
        Free Disabled for AURA: 0
        Alloc Disabled for Resvd: 0
  NPA_AF_ERR:
        Memory Fault on NPA_AQ_INST_S read: 0
        Memory Fault on NPA_AQ_RES_S write: 0
        AQ Doorbell Error: 0
        Poisoned data on NPA_AQ_INST_S read: 0
        Poisoned data on NPA_AQ_RES_S write: 0
        Poisoned data on HW context read: 0
  NPA_AF_RVU:
        Unmap Slot Error: 0

Signed-off-by: Sunil Kovvuri Goutham <sgoutham@marvell.com>
Signed-off-by: Jerin Jacob <jerinj@marvell.com>
Signed-off-by: George Cherian <george.cherian@marvell.com>
---
 .../marvell/octeontx2/af/rvu_devlink.c        | 492 +++++++++++++++++-
 .../marvell/octeontx2/af/rvu_devlink.h        |  31 ++
 .../marvell/octeontx2/af/rvu_struct.h         |  23 +
 3 files changed, 545 insertions(+), 1 deletion(-)

diff --git a/drivers/net/ethernet/marvell/octeontx2/af/rvu_devlink.c b/drivers/net/ethernet/marvell/octeontx2/af/rvu_devlink.c
index 04ef945e7e75..b7f0691d86b0 100644
--- a/drivers/net/ethernet/marvell/octeontx2/af/rvu_devlink.c
+++ b/drivers/net/ethernet/marvell/octeontx2/af/rvu_devlink.c
@@ -5,10 +5,498 @@
  *
  */
 
+#include<linux/bitfield.h>
+
 #include "rvu.h"
+#include "rvu_reg.h"
+#include "rvu_struct.h"
 
 #define DRV_NAME "octeontx2-af"
 
+static int rvu_report_pair_start(struct devlink_fmsg *fmsg, const char *name)
+{
+	int err;
+
+	err = devlink_fmsg_pair_nest_start(fmsg, name);
+	if (err)
+		return err;
+
+	return  devlink_fmsg_obj_nest_start(fmsg);
+}
+
+static int rvu_report_pair_end(struct devlink_fmsg *fmsg)
+{
+	int err;
+
+	err = devlink_fmsg_obj_nest_end(fmsg);
+	if (err)
+		return err;
+
+	return devlink_fmsg_pair_nest_end(fmsg);
+}
+
+static bool rvu_common_request_irq(struct rvu *rvu, int offset,
+				   const char *name, irq_handler_t fn)
+{
+	struct rvu_devlink *rvu_dl = rvu->rvu_dl;
+	int rc;
+
+	sprintf(&rvu->irq_name[offset * NAME_SIZE], name);
+	rc = request_irq(pci_irq_vector(rvu->pdev, offset), fn, 0,
+			 &rvu->irq_name[offset * NAME_SIZE], rvu_dl);
+	if (rc)
+		dev_warn(rvu->dev, "Failed to register %s irq\n", name);
+	else
+		rvu->irq_allocated[offset] = true;
+
+	return rvu->irq_allocated[offset];
+}
+
+static irqreturn_t rvu_npa_af_rvu_intr_handler(int irq, void *rvu_irq)
+{
+	struct rvu_npa_event_ctx *npa_event_context;
+	struct rvu_npa_event_cnt *npa_event_count;
+	struct rvu_devlink *rvu_dl = rvu_irq;
+	struct rvu *rvu;
+	int blkaddr;
+	u64 intr;
+
+	rvu = rvu_dl->rvu;
+	blkaddr = rvu_get_blkaddr(rvu, BLKTYPE_NPA, 0);
+	if (blkaddr < 0)
+		return IRQ_NONE;
+
+	npa_event_context = rvu_dl->npa_event_ctx;
+	npa_event_count = &npa_event_context->npa_event_cnt;
+	intr = rvu_read64(rvu, blkaddr, NPA_AF_RVU_INT);
+	npa_event_context->npa_af_rvu_int = intr;
+
+	if (intr & BIT_ULL(0))
+		npa_event_count->unmap_slot_count++;
+
+	/* Clear interrupts */
+	rvu_write64(rvu, blkaddr, NPA_AF_RVU_INT, intr);
+	rvu_write64(rvu, blkaddr, NPA_AF_RVU_INT_ENA_W1C, ~0ULL);
+	devlink_health_report(rvu_dl->rvu_npa_health_reporter, "NPA_AF_RVU Error",
+			      npa_event_context);
+
+	return IRQ_HANDLED;
+}
+
+static int rvu_npa_inpq_to_cnt(u16 in,
+			       struct rvu_npa_event_cnt *npa_event_count)
+{
+	switch (in) {
+	case 0:
+		return 0;
+	case BIT(NPA_INPQ_NIX0_RX):
+		return npa_event_count->free_dis_nix0_rx_count++;
+	case BIT(NPA_INPQ_NIX0_TX):
+		return npa_event_count->free_dis_nix0_tx_count++;
+	case BIT(NPA_INPQ_NIX1_RX):
+		return npa_event_count->free_dis_nix1_rx_count++;
+	case BIT(NPA_INPQ_NIX1_TX):
+		return npa_event_count->free_dis_nix1_tx_count++;
+	case BIT(NPA_INPQ_SSO):
+		return npa_event_count->free_dis_sso_count++;
+	case BIT(NPA_INPQ_TIM):
+		return npa_event_count->free_dis_tim_count++;
+	case BIT(NPA_INPQ_DPI):
+		return npa_event_count->free_dis_dpi_count++;
+	case BIT(NPA_INPQ_AURA_OP):
+		return npa_event_count->free_dis_aura_count++;
+	case BIT(NPA_INPQ_INTERNAL_RSV):
+		return npa_event_count->free_dis_rsvd_count++;
+	}
+
+	return npa_event_count->alloc_dis_rsvd_count++;
+}
+
+static irqreturn_t rvu_npa_af_gen_intr_handler(int irq, void *rvu_irq)
+{
+	struct rvu_npa_event_ctx *npa_event_context;
+	struct rvu_npa_event_cnt *npa_event_count;
+	struct rvu_devlink *rvu_dl = rvu_irq;
+	struct rvu *rvu;
+	int blkaddr, val;
+	u64 intr;
+
+	rvu = rvu_dl->rvu;
+	blkaddr = rvu_get_blkaddr(rvu, BLKTYPE_NPA, 0);
+	if (blkaddr < 0)
+		return IRQ_NONE;
+
+	npa_event_context = rvu_dl->npa_event_ctx;
+	npa_event_count = &npa_event_context->npa_event_cnt;
+	intr = rvu_read64(rvu, blkaddr, NPA_AF_GEN_INT);
+	npa_event_context->npa_af_rvu_gen = intr;
+
+	if (intr & BIT_ULL(32))
+		npa_event_count->unmap_pf_count++;
+
+	val = FIELD_GET(GENMASK(31, 16), intr);
+	rvu_npa_inpq_to_cnt(val, npa_event_count);
+
+	val = FIELD_GET(GENMASK(15, 0), intr);
+	rvu_npa_inpq_to_cnt(val, npa_event_count);
+
+	/* Clear interrupts */
+	rvu_write64(rvu, blkaddr, NPA_AF_GEN_INT, intr);
+	rvu_write64(rvu, blkaddr, NPA_AF_GEN_INT_ENA_W1C, ~0ULL);
+	devlink_health_report(rvu_dl->rvu_npa_health_reporter, "NPA_AF_GEN Error",
+			      npa_event_context);
+	return IRQ_HANDLED;
+}
+
+static irqreturn_t rvu_npa_af_err_intr_handler(int irq, void *rvu_irq)
+{
+	struct rvu_npa_event_ctx *npa_event_context;
+	struct rvu_npa_event_cnt *npa_event_count;
+	struct rvu_devlink *rvu_dl = rvu_irq;
+	struct rvu *rvu;
+	int blkaddr;
+	u64 intr;
+
+	rvu = rvu_dl->rvu;
+	blkaddr = rvu_get_blkaddr(rvu, BLKTYPE_NPA, 0);
+	if (blkaddr < 0)
+		return IRQ_NONE;
+	npa_event_context = rvu_dl->npa_event_ctx;
+	npa_event_count = &npa_event_context->npa_event_cnt;
+	intr = rvu_read64(rvu, blkaddr, NPA_AF_ERR_INT);
+	npa_event_context->npa_af_rvu_err = intr;
+
+	if (intr & BIT_ULL(14))
+		npa_event_count->aq_inst_count++;
+
+	if (intr & BIT_ULL(13))
+		npa_event_count->aq_res_count++;
+
+	if (intr & BIT_ULL(12))
+		npa_event_count->aq_db_count++;
+
+	/* Clear interrupts */
+	rvu_write64(rvu, blkaddr, NPA_AF_ERR_INT, intr);
+	rvu_write64(rvu, blkaddr, NPA_AF_ERR_INT_ENA_W1C, ~0ULL);
+	devlink_health_report(rvu_dl->rvu_npa_health_reporter, "NPA_AF_ERR Error",
+			      npa_event_context);
+	return IRQ_HANDLED;
+}
+
+static irqreturn_t rvu_npa_af_ras_intr_handler(int irq, void *rvu_irq)
+{
+	struct rvu_npa_event_ctx *npa_event_context;
+	struct rvu_npa_event_cnt *npa_event_count;
+	struct rvu_devlink *rvu_dl = rvu_irq;
+	struct rvu *rvu;
+	int blkaddr;
+	u64 intr;
+
+	rvu = rvu_dl->rvu;
+	blkaddr = rvu_get_blkaddr(rvu, BLKTYPE_NPA, 0);
+	if (blkaddr < 0)
+		return IRQ_NONE;
+
+	npa_event_context = rvu_dl->npa_event_ctx;
+	npa_event_count = &npa_event_context->npa_event_cnt;
+	intr = rvu_read64(rvu, blkaddr, NPA_AF_RAS);
+	npa_event_context->npa_af_rvu_ras = intr;
+
+	if (intr & BIT_ULL(34))
+		npa_event_count->poison_aq_inst_count++;
+
+	if (intr & BIT_ULL(33))
+		npa_event_count->poison_aq_res_count++;
+
+	if (intr & BIT_ULL(32))
+		npa_event_count->poison_aq_cxt_count++;
+
+	/* Clear interrupts */
+	rvu_write64(rvu, blkaddr, NPA_AF_RAS, intr);
+	rvu_write64(rvu, blkaddr, NPA_AF_RAS_ENA_W1C, ~0ULL);
+	devlink_health_report(rvu_dl->rvu_npa_health_reporter, "HW NPA_AF_RAS Error reported",
+			      npa_event_context);
+	return IRQ_HANDLED;
+}
+
+static void rvu_npa_unregister_interrupts(struct rvu *rvu)
+{
+	struct rvu_devlink *rvu_dl = rvu->rvu_dl;
+	int i, offs, blkaddr;
+	u64 reg;
+
+	blkaddr = rvu_get_blkaddr(rvu, BLKTYPE_NPA, 0);
+	if (blkaddr < 0)
+		return;
+
+	reg = rvu_read64(rvu, blkaddr, NPA_PRIV_AF_INT_CFG);
+	offs = reg & 0x3FF;
+
+	rvu_write64(rvu, blkaddr, NPA_AF_RVU_INT_ENA_W1C, ~0ULL);
+	rvu_write64(rvu, blkaddr, NPA_AF_GEN_INT_ENA_W1C, ~0ULL);
+	rvu_write64(rvu, blkaddr, NPA_AF_ERR_INT_ENA_W1C, ~0ULL);
+	rvu_write64(rvu, blkaddr, NPA_AF_RAS_ENA_W1C, ~0ULL);
+
+	for (i = 0; i < NPA_AF_INT_VEC_CNT; i++)
+		if (rvu->irq_allocated[offs + i]) {
+			free_irq(pci_irq_vector(rvu->pdev, offs + i), rvu_dl);
+			rvu->irq_allocated[offs + i] = false;
+		}
+}
+
+static int rvu_npa_register_interrupts(struct rvu *rvu)
+{
+	int blkaddr, base;
+	bool rc;
+
+	blkaddr = rvu_get_blkaddr(rvu, BLKTYPE_NPA, 0);
+	if (blkaddr < 0)
+		return blkaddr;
+
+	/* Get NPA AF MSIX vectors offset. */
+	base = rvu_read64(rvu, blkaddr, NPA_PRIV_AF_INT_CFG) & 0x3ff;
+	if (!base) {
+		dev_warn(rvu->dev,
+			 "Failed to get NPA_AF_INT vector offsets\n");
+		return 0;
+	}
+
+	/* Register and enable NPA_AF_RVU_INT interrupt */
+	rc = rvu_common_request_irq(rvu, base +  NPA_AF_INT_VEC_RVU,
+				    "NPA_AF_RVU_INT",
+				    rvu_npa_af_rvu_intr_handler);
+	if (!rc)
+		goto err;
+	rvu_write64(rvu, blkaddr, NPA_AF_RVU_INT_ENA_W1S, ~0ULL);
+
+	/* Register and enable NPA_AF_GEN_INT interrupt */
+	rc = rvu_common_request_irq(rvu, base + NPA_AF_INT_VEC_GEN,
+				    "NPA_AF_RVU_GEN",
+				    rvu_npa_af_gen_intr_handler);
+	if (!rc)
+		goto err;
+	rvu_write64(rvu, blkaddr, NPA_AF_GEN_INT_ENA_W1S, ~0ULL);
+
+	/* Register and enable NPA_AF_ERR_INT interrupt */
+	rc = rvu_common_request_irq(rvu, base + NPA_AF_INT_VEC_AF_ERR,
+				    "NPA_AF_ERR_INT",
+				    rvu_npa_af_err_intr_handler);
+	if (!rc)
+		goto err;
+	rvu_write64(rvu, blkaddr, NPA_AF_ERR_INT_ENA_W1S, ~0ULL);
+
+	/* Register and enable NPA_AF_RAS interrupt */
+	rc = rvu_common_request_irq(rvu, base + NPA_AF_INT_VEC_POISON,
+				    "NPA_AF_RAS",
+				    rvu_npa_af_ras_intr_handler);
+	if (!rc)
+		goto err;
+	rvu_write64(rvu, blkaddr, NPA_AF_RAS_ENA_W1S, ~0ULL);
+
+	return 0;
+err:
+	rvu_npa_unregister_interrupts(rvu);
+	return rc;
+}
+
+static int rvu_npa_report_show(struct devlink_fmsg *fmsg, struct rvu *rvu)
+{
+	struct rvu_npa_event_ctx *npa_event_context;
+	struct rvu_npa_event_cnt *npa_event_count;
+	struct rvu_devlink *rvu_dl = rvu->rvu_dl;
+	int err;
+
+	npa_event_context = rvu_dl->npa_event_ctx;
+	npa_event_count = &npa_event_context->npa_event_cnt;
+	err = rvu_report_pair_start(fmsg, "NPA_AF_GENERAL");
+	if (err)
+		return err;
+	err = devlink_fmsg_u64_pair_put(fmsg, "\tUnmap PF Error",
+					npa_event_count->unmap_pf_count);
+	if (err)
+		return err;
+	err = devlink_fmsg_u64_pair_put(fmsg, "\n\tFree Disabled for NIX0 RX",
+					npa_event_count->free_dis_nix0_rx_count);
+	if (err)
+		return err;
+	err = devlink_fmsg_u64_pair_put(fmsg, "\n\tFree Disabled for NIX0 TX",
+					npa_event_count->free_dis_nix0_tx_count);
+	if (err)
+		return err;
+	err = devlink_fmsg_u64_pair_put(fmsg, "\n\tFree Disabled for NIX1 RX",
+					npa_event_count->free_dis_nix1_rx_count);
+	if (err)
+		return err;
+	err = devlink_fmsg_u64_pair_put(fmsg, "\n\tFree Disabled for NIX1 TX",
+					npa_event_count->free_dis_nix1_tx_count);
+	if (err)
+		return err;
+	err = devlink_fmsg_u64_pair_put(fmsg, "\n\tFree Disabled for SSO",
+					npa_event_count->free_dis_sso_count);
+	if (err)
+		return err;
+	err = devlink_fmsg_u64_pair_put(fmsg, "\n\tFree Disabled for TIM",
+					npa_event_count->free_dis_tim_count);
+	if (err)
+		return err;
+	err = devlink_fmsg_u64_pair_put(fmsg, "\n\tFree Disabled for DPI",
+					npa_event_count->free_dis_dpi_count);
+	if (err)
+		return err;
+	err = devlink_fmsg_u64_pair_put(fmsg, "\n\tFree Disabled for AURA",
+					npa_event_count->free_dis_aura_count);
+	if (err)
+		return err;
+	err = devlink_fmsg_u64_pair_put(fmsg, "\n\tAlloc Disabled for Resvd",
+					npa_event_count->alloc_dis_rsvd_count);
+	if (err)
+		return err;
+	err = rvu_report_pair_end(fmsg);
+	if (err)
+		return err;
+	err = rvu_report_pair_start(fmsg, "NPA_AF_ERR");
+	if (err)
+		return err;
+	err = devlink_fmsg_u64_pair_put(fmsg, "\tMemory Fault on NPA_AQ_INST_S read",
+					npa_event_count->aq_inst_count);
+	if (err)
+		return err;
+	err = devlink_fmsg_u64_pair_put(fmsg, "\n\tMemory Fault on NPA_AQ_RES_S write",
+					npa_event_count->aq_res_count);
+	if (err)
+		return err;
+	err = devlink_fmsg_u64_pair_put(fmsg, "\n\tAQ Doorbell Error",
+					npa_event_count->aq_db_count);
+	if (err)
+		return err;
+	err = devlink_fmsg_u64_pair_put(fmsg, "\n\tPoisoned data on NPA_AQ_INST_S read",
+					npa_event_count->poison_aq_inst_count);
+	if (err)
+		return err;
+	err = devlink_fmsg_u64_pair_put(fmsg, "\n\tPoisoned data on NPA_AQ_RES_S write",
+					npa_event_count->poison_aq_res_count);
+	if (err)
+		return err;
+	err = devlink_fmsg_u64_pair_put(fmsg, "\n\tPoisoned data on HW context read",
+					npa_event_count->poison_aq_cxt_count);
+	if (err)
+		return err;
+	err = rvu_report_pair_end(fmsg);
+	if (err)
+		return err;
+	err = rvu_report_pair_start(fmsg, "NPA_AF_RVU");
+	if (err)
+		return err;
+	err = devlink_fmsg_u64_pair_put(fmsg, "\tUnmap Slot Error",
+					npa_event_count->unmap_slot_count);
+	if (err)
+		return err;
+	return rvu_report_pair_end(fmsg);
+}
+
+static int rvu_npa_reporter_dump(struct devlink_health_reporter *reporter,
+				 struct devlink_fmsg *fmsg, void *ctx,
+				 struct netlink_ext_ack *netlink_extack)
+{
+	struct rvu *rvu = devlink_health_reporter_priv(reporter);
+
+	return rvu_npa_report_show(fmsg, rvu);
+}
+
+static int rvu_npa_reporter_recover(struct devlink_health_reporter *reporter,
+				    void *ctx, struct netlink_ext_ack *netlink_extack)
+{
+	struct rvu *rvu = devlink_health_reporter_priv(reporter);
+	struct rvu_npa_event_ctx *npa_event_ctx = ctx;
+	int blkaddr;
+
+	blkaddr = rvu_get_blkaddr(rvu, BLKTYPE_NPA, 0);
+	if (blkaddr < 0)
+		return blkaddr;
+
+	if (npa_event_ctx->npa_af_rvu_int) {
+		rvu_write64(rvu, blkaddr, NPA_AF_RVU_INT_ENA_W1S, ~0ULL);
+		npa_event_ctx->npa_af_rvu_int = 0;
+	}
+	if (npa_event_ctx->npa_af_rvu_gen) {
+		rvu_write64(rvu, blkaddr, NPA_AF_GEN_INT_ENA_W1S, ~0ULL);
+		npa_event_ctx->npa_af_rvu_gen = 0;
+	}
+	if (npa_event_ctx->npa_af_rvu_err) {
+		rvu_write64(rvu, blkaddr, NPA_AF_ERR_INT_ENA_W1S, ~0ULL);
+		npa_event_ctx->npa_af_rvu_err = 0;
+	}
+	if (npa_event_ctx->npa_af_rvu_ras) {
+		rvu_write64(rvu, blkaddr, NPA_AF_RAS_ENA_W1S, ~0ULL);
+		npa_event_ctx->npa_af_rvu_ras = 0;
+	}
+
+	return 0;
+}
+
+static const struct devlink_health_reporter_ops rvu_npa_hw_fault_reporter_ops = {
+		.name = "hw_npa",
+		.recover = rvu_npa_reporter_recover,
+		.dump = rvu_npa_reporter_dump,
+};
+
+static int rvu_npa_health_reporters_create(struct rvu_devlink *rvu_dl)
+{
+	struct devlink_health_reporter *rvu_npa_health_reporter;
+	struct rvu_npa_event_ctx *npa_event_context;
+	struct rvu *rvu = rvu_dl->rvu;
+
+	npa_event_context = kzalloc(sizeof(*npa_event_context), GFP_KERNEL);
+	if (!npa_event_context)
+		return -ENOMEM;
+
+	rvu_dl->npa_event_ctx = npa_event_context;
+	rvu_npa_health_reporter = devlink_health_reporter_create(rvu_dl->dl,
+								 &rvu_npa_hw_fault_reporter_ops,
+								 0, rvu);
+	if (IS_ERR(rvu_npa_health_reporter)) {
+		dev_warn(rvu->dev, "Failed to create npa reporter, err =%ld\n",
+			 PTR_ERR(rvu_npa_health_reporter));
+		return PTR_ERR(rvu_npa_health_reporter);
+	}
+
+	rvu_dl->rvu_npa_health_reporter = rvu_npa_health_reporter;
+	rvu_npa_register_interrupts(rvu);
+
+	return 0;
+}
+
+static void rvu_npa_health_reporters_destroy(struct rvu_devlink *rvu_dl)
+{
+	struct rvu *rvu = rvu_dl->rvu;
+
+	if (!rvu_dl->rvu_npa_health_reporter)
+		return;
+
+	devlink_health_reporter_destroy(rvu_dl->rvu_npa_health_reporter);
+	rvu_npa_unregister_interrupts(rvu);
+	kfree(rvu_dl->npa_event_ctx);
+}
+
+static int rvu_health_reporters_create(struct rvu *rvu)
+{
+	struct rvu_devlink *rvu_dl;
+
+	rvu_dl = rvu->rvu_dl;
+	return rvu_npa_health_reporters_create(rvu_dl);
+}
+
+static void rvu_health_reporters_destroy(struct rvu *rvu)
+{
+	struct rvu_devlink *rvu_dl;
+
+	if (!rvu->rvu_dl)
+		return;
+
+	rvu_dl = rvu->rvu_dl;
+	rvu_npa_health_reporters_destroy(rvu_dl);
+}
+
 static int rvu_devlink_info_get(struct devlink *devlink, struct devlink_info_req *req,
 				struct netlink_ext_ack *extack)
 {
@@ -55,7 +543,8 @@ int rvu_register_dl(struct rvu *rvu)
 	rvu_dl->dl = dl;
 	rvu_dl->rvu = rvu;
 	rvu->rvu_dl = rvu_dl;
-	return 0;
+
+	return rvu_health_reporters_create(rvu);
 }
 
 void rvu_unregister_dl(struct rvu *rvu)
@@ -66,6 +555,7 @@ void rvu_unregister_dl(struct rvu *rvu)
 	if (!dl)
 		return;
 
+	rvu_health_reporters_destroy(rvu);
 	devlink_unregister(dl);
 	devlink_free(dl);
 	kfree(rvu_dl);
diff --git a/drivers/net/ethernet/marvell/octeontx2/af/rvu_devlink.h b/drivers/net/ethernet/marvell/octeontx2/af/rvu_devlink.h
index 1ed6dde79a4e..e04603a9952c 100644
--- a/drivers/net/ethernet/marvell/octeontx2/af/rvu_devlink.h
+++ b/drivers/net/ethernet/marvell/octeontx2/af/rvu_devlink.h
@@ -8,9 +8,40 @@
 #ifndef RVU_DEVLINK_H
 #define  RVU_DEVLINK_H
 
+struct rvu_npa_event_cnt {
+	u64 unmap_slot_count;
+	u64 unmap_pf_count;
+	u64 free_dis_nix0_rx_count;
+	u64 free_dis_nix0_tx_count;
+	u64 free_dis_nix1_rx_count;
+	u64 free_dis_nix1_tx_count;
+	u64 free_dis_sso_count;
+	u64 free_dis_tim_count;
+	u64 free_dis_dpi_count;
+	u64 free_dis_aura_count;
+	u64 free_dis_rsvd_count;
+	u64 alloc_dis_rsvd_count;
+	u64 aq_inst_count;
+	u64 aq_res_count;
+	u64 aq_db_count;
+	u64 poison_aq_inst_count;
+	u64 poison_aq_res_count;
+	u64 poison_aq_cxt_count;
+};
+
+struct rvu_npa_event_ctx {
+	struct rvu_npa_event_cnt npa_event_cnt;
+	u64 npa_af_rvu_int;
+	u64 npa_af_rvu_gen;
+	u64 npa_af_rvu_err;
+	u64 npa_af_rvu_ras;
+};
+
 struct rvu_devlink {
 	struct devlink *dl;
 	struct rvu *rvu;
+	struct devlink_health_reporter *rvu_npa_health_reporter;
+	struct rvu_npa_event_ctx *npa_event_ctx;
 };
 
 /* Devlink APIs */
diff --git a/drivers/net/ethernet/marvell/octeontx2/af/rvu_struct.h b/drivers/net/ethernet/marvell/octeontx2/af/rvu_struct.h
index 9a7eb074cdc2..995add5d8bff 100644
--- a/drivers/net/ethernet/marvell/octeontx2/af/rvu_struct.h
+++ b/drivers/net/ethernet/marvell/octeontx2/af/rvu_struct.h
@@ -64,6 +64,16 @@ enum rvu_af_int_vec_e {
 	RVU_AF_INT_VEC_CNT    = 0x5,
 };
 
+/* NPA Admin function Interrupt Vector Enumeration */
+enum npa_af_int_vec_e {
+	NPA_AF_INT_VEC_RVU	= 0x0,
+	NPA_AF_INT_VEC_GEN	= 0x1,
+	NPA_AF_INT_VEC_AQ_DONE	= 0x2,
+	NPA_AF_INT_VEC_AF_ERR	= 0x3,
+	NPA_AF_INT_VEC_POISON	= 0x4,
+	NPA_AF_INT_VEC_CNT	= 0x5,
+};
+
 /**
  * RVU PF Interrupt Vector Enumeration
  */
@@ -104,6 +114,19 @@ enum npa_aq_instop {
 	NPA_AQ_INSTOP_UNLOCK = 0x5,
 };
 
+/* ALLOC/FREE input queues Enumeration from coprocessors */
+enum npa_inpq {
+	NPA_INPQ_NIX0_RX       = 0x0,
+	NPA_INPQ_NIX0_TX       = 0x1,
+	NPA_INPQ_NIX1_RX       = 0x2,
+	NPA_INPQ_NIX1_TX       = 0x3,
+	NPA_INPQ_SSO           = 0x4,
+	NPA_INPQ_TIM           = 0x5,
+	NPA_INPQ_DPI           = 0x6,
+	NPA_INPQ_AURA_OP       = 0xe,
+	NPA_INPQ_INTERNAL_RSV  = 0xf,
+};
+
 /* NPA admin queue instruction structure */
 struct npa_aq_inst_s {
 #if defined(__BIG_ENDIAN_BITFIELD)
-- 
2.25.1

