Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id E80F82D7029
	for <lists+netdev@lfdr.de>; Fri, 11 Dec 2020 07:28:27 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2436493AbgLKG07 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 11 Dec 2020 01:26:59 -0500
Received: from mx0b-0016f401.pphosted.com ([67.231.156.173]:42658 "EHLO
        mx0b-0016f401.pphosted.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S2390253AbgLKG0i (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 11 Dec 2020 01:26:38 -0500
Received: from pps.filterd (m0045851.ppops.net [127.0.0.1])
        by mx0b-0016f401.pphosted.com (8.16.0.43/8.16.0.43) with SMTP id 0BB6P8j5004877;
        Thu, 10 Dec 2020 22:25:48 -0800
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=marvell.com; h=from : to : cc :
 subject : date : message-id : in-reply-to : references : mime-version :
 content-transfer-encoding : content-type; s=pfpt0220;
 bh=cqTV//ujjKwuG5ZYHK2AeHFsNr5ywsGgThoA1X2ySNo=;
 b=k3m417rAPFeRgyp+wIzZ1ouvA/CkpF/GvJxaVMUQDzFpNfz0RgE94vJ7av7IPyTRl7UO
 G5BtXdyaSAjgK+f2PRbPkyH86c9DqBKd61y1N9YDL5EfUcWz5lmQes41AuoYcBdXp3l4
 kdVf8A1jeCfWQ2UfE0rpIDD3KHkLw2XhVHwd/9CSrm4xfmuoOmeYhSk2ughLQjOSRlR8
 Xn8Lbi4KCHRri0lkiyS5HNZm2G76gmkdFN8Wd5IpVV0P7t/qA9uhShhH2cUxzXRyrZb5
 j800IO1KM8I+nD39U5UVk4RXw5sSFRi9s2GuBL0hbX+WaxmRYP+6BjXCYiimDeGksK9h iw== 
Received: from sc-exch03.marvell.com ([199.233.58.183])
        by mx0b-0016f401.pphosted.com with ESMTP id 358akrhyvr-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-SHA384 bits=256 verify=NOT);
        Thu, 10 Dec 2020 22:25:47 -0800
Received: from SC-EXCH04.marvell.com (10.93.176.84) by SC-EXCH03.marvell.com
 (10.93.176.83) with Microsoft SMTP Server (TLS) id 15.0.1497.2; Thu, 10 Dec
 2020 22:25:46 -0800
Received: from DC5-EXCH02.marvell.com (10.69.176.39) by SC-EXCH04.marvell.com
 (10.93.176.84) with Microsoft SMTP Server (TLS) id 15.0.1497.2; Thu, 10 Dec
 2020 22:25:45 -0800
Received: from maili.marvell.com (10.69.176.80) by DC5-EXCH02.marvell.com
 (10.69.176.39) with Microsoft SMTP Server id 15.0.1497.2 via Frontend
 Transport; Thu, 10 Dec 2020 22:25:46 -0800
Received: from hyd1584.marvell.com (unknown [10.29.37.82])
        by maili.marvell.com (Postfix) with ESMTP id C7AAA3F703F;
        Thu, 10 Dec 2020 22:25:41 -0800 (PST)
From:   George Cherian <george.cherian@marvell.com>
To:     <netdev@vger.kernel.org>, <linux-kernel@vger.kernel.org>
CC:     <kuba@kernel.org>, <davem@davemloft.net>, <sgoutham@marvell.com>,
        <lcherian@marvell.com>, <gakula@marvell.com>,
        <george.cherian@marvell.com>, <willemdebruijn.kernel@gmail.com>,
        <saeed@kernel.org>, <jiri@resnulli.us>
Subject: [PATCH 2/3] octeontx2-af: Add devlink health reporters for NPA
Date:   Fri, 11 Dec 2020 11:55:25 +0530
Message-ID: <20201211062526.2302643-3-george.cherian@marvell.com>
X-Mailer: git-send-email 2.25.1
In-Reply-To: <20201211062526.2302643-1-george.cherian@marvell.com>
References: <20201211062526.2302643-1-george.cherian@marvell.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-Proofpoint-Virus-Version: vendor=fsecure engine=2.50.10434:6.0.343,18.0.737
 definitions=2020-12-11_01:2020-12-09,2020-12-11 signatures=0
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Add health reporters for RVU NPA block.
NPA Health reporters handle following HW event groups
 - GENERAL events
 - ERROR events
 - RAS events
 - RVU event

Output:
 #devlink health
 pci/0002:01:00.0:
   reporter hw_npa_intr
     state healthy error 0 recover 0 grace_period 0 auto_recover true
 auto_dump true
   reporter hw_npa_gen
     state healthy error 0 recover 0 grace_period 0 auto_recover true
 auto_dump true
   reporter hw_npa_err
     state healthy error 0 recover 0 grace_period 0 auto_recover true
 auto_dump true
   reporter hw_npa_ras
     state healthy error 0 recover 0 grace_period 0 auto_recover true
 auto_dump true

 #devlink health dump show  pci/0002:01:00.0 reporter hw_npa_err
 NPA_AF_ERR:
        NPA Error Interrupt Reg : 4096
        AQ Doorbell Error
 #devlink health dump show  pci/0002:01:00.0 reporter hw_npa_ras
 NPA_AF_RVU_RAS:
        NPA RAS Interrupt Reg : 0

 Each reporter dump shows the Register value and the description of the
cause.

Signed-off-by: Sunil Kovvuri Goutham <sgoutham@marvell.com>
Signed-off-by: Jerin Jacob <jerinj@marvell.com>
Signed-off-by: George Cherian <george.cherian@marvell.com>
---
 .../marvell/octeontx2/af/rvu_devlink.c        | 708 +++++++++++++++++-
 .../marvell/octeontx2/af/rvu_devlink.h        |  35 +
 .../marvell/octeontx2/af/rvu_struct.h         |  23 +
 3 files changed, 765 insertions(+), 1 deletion(-)

diff --git a/drivers/net/ethernet/marvell/octeontx2/af/rvu_devlink.c b/drivers/net/ethernet/marvell/octeontx2/af/rvu_devlink.c
index 5dabca04a34b..3f9d0ab6d5ae 100644
--- a/drivers/net/ethernet/marvell/octeontx2/af/rvu_devlink.c
+++ b/drivers/net/ethernet/marvell/octeontx2/af/rvu_devlink.c
@@ -5,10 +5,714 @@
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
+static void rvu_npa_intr_work(struct work_struct *work)
+{
+	struct rvu_npa_health_reporters *rvu_npa_health_reporter;
+
+	rvu_npa_health_reporter = container_of(work, struct rvu_npa_health_reporters, intr_work);
+	devlink_health_report(rvu_npa_health_reporter->rvu_hw_npa_intr_reporter,
+			      "NPA_AF_RVU Error",
+			      rvu_npa_health_reporter->npa_event_ctx);
+}
+
+static irqreturn_t rvu_npa_af_rvu_intr_handler(int irq, void *rvu_irq)
+{
+	struct rvu_npa_event_ctx *npa_event_context;
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
+	npa_event_context = rvu_dl->rvu_npa_health_reporter->npa_event_ctx;
+	intr = rvu_read64(rvu, blkaddr, NPA_AF_RVU_INT);
+	npa_event_context->npa_af_rvu_int = intr;
+
+	/* Clear interrupts */
+	rvu_write64(rvu, blkaddr, NPA_AF_RVU_INT, intr);
+	rvu_write64(rvu, blkaddr, NPA_AF_RVU_INT_ENA_W1C, ~0ULL);
+	queue_work(rvu_dl->devlink_wq, &rvu_dl->rvu_npa_health_reporter->intr_work);
+
+	return IRQ_HANDLED;
+}
+
+static void rvu_npa_gen_work(struct work_struct *work)
+{
+	struct rvu_npa_health_reporters *rvu_npa_health_reporter;
+
+	rvu_npa_health_reporter = container_of(work, struct rvu_npa_health_reporters, gen_work);
+	devlink_health_report(rvu_npa_health_reporter->rvu_hw_npa_gen_reporter,
+			      "NPA_AF_GEN Error",
+			      rvu_npa_health_reporter->npa_event_ctx);
+}
+
+static irqreturn_t rvu_npa_af_gen_intr_handler(int irq, void *rvu_irq)
+{
+	struct rvu_npa_event_ctx *npa_event_context;
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
+	npa_event_context = rvu_dl->rvu_npa_health_reporter->npa_event_ctx;
+	intr = rvu_read64(rvu, blkaddr, NPA_AF_GEN_INT);
+	npa_event_context->npa_af_rvu_gen = intr;
+
+	/* Clear interrupts */
+	rvu_write64(rvu, blkaddr, NPA_AF_GEN_INT, intr);
+	rvu_write64(rvu, blkaddr, NPA_AF_GEN_INT_ENA_W1C, ~0ULL);
+	queue_work(rvu_dl->devlink_wq, &rvu_dl->rvu_npa_health_reporter->gen_work);
+
+	return IRQ_HANDLED;
+}
+
+static void rvu_npa_err_work(struct work_struct *work)
+{
+	struct rvu_npa_health_reporters *rvu_npa_health_reporter;
+
+	rvu_npa_health_reporter = container_of(work, struct rvu_npa_health_reporters, err_work);
+	devlink_health_report(rvu_npa_health_reporter->rvu_hw_npa_err_reporter,
+			      "NPA_AF_ERR Error",
+			      rvu_npa_health_reporter->npa_event_ctx);
+}
+
+static irqreturn_t rvu_npa_af_err_intr_handler(int irq, void *rvu_irq)
+{
+	struct rvu_npa_event_ctx *npa_event_context;
+	struct rvu_devlink *rvu_dl = rvu_irq;
+	struct rvu *rvu;
+	int blkaddr;
+	u64 intr;
+
+	rvu = rvu_dl->rvu;
+	blkaddr = rvu_get_blkaddr(rvu, BLKTYPE_NPA, 0);
+	if (blkaddr < 0)
+		return IRQ_NONE;
+	npa_event_context = rvu_dl->rvu_npa_health_reporter->npa_event_ctx;
+	intr = rvu_read64(rvu, blkaddr, NPA_AF_ERR_INT);
+	npa_event_context->npa_af_rvu_err = intr;
+
+	/* Clear interrupts */
+	rvu_write64(rvu, blkaddr, NPA_AF_ERR_INT, intr);
+	rvu_write64(rvu, blkaddr, NPA_AF_ERR_INT_ENA_W1C, ~0ULL);
+	queue_work(rvu_dl->devlink_wq, &rvu_dl->rvu_npa_health_reporter->err_work);
+
+	return IRQ_HANDLED;
+}
+
+static void rvu_npa_ras_work(struct work_struct *work)
+{
+	struct rvu_npa_health_reporters *rvu_npa_health_reporter;
+
+	rvu_npa_health_reporter = container_of(work, struct rvu_npa_health_reporters, ras_work);
+	devlink_health_report(rvu_npa_health_reporter->rvu_hw_npa_ras_reporter,
+			      "HW NPA_AF_RAS Error reported",
+			      rvu_npa_health_reporter->npa_event_ctx);
+}
+
+static irqreturn_t rvu_npa_af_ras_intr_handler(int irq, void *rvu_irq)
+{
+	struct rvu_npa_event_ctx *npa_event_context;
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
+	npa_event_context = rvu_dl->rvu_npa_health_reporter->npa_event_ctx;
+	intr = rvu_read64(rvu, blkaddr, NPA_AF_RAS);
+	npa_event_context->npa_af_rvu_ras = intr;
+
+	/* Clear interrupts */
+	rvu_write64(rvu, blkaddr, NPA_AF_RAS, intr);
+	rvu_write64(rvu, blkaddr, NPA_AF_RAS_ENA_W1C, ~0ULL);
+	queue_work(rvu_dl->devlink_wq, &rvu_dl->rvu_npa_health_reporter->ras_work);
+
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
+static int rvu_npa_report_show(struct devlink_fmsg *fmsg, void *ctx,
+			       enum npa_af_rvu_health health_reporter)
+{
+	struct rvu_npa_event_ctx *npa_event_context;
+	unsigned int intr_val, alloc_dis, free_dis;
+	int err;
+
+	npa_event_context = ctx;
+	switch (health_reporter) {
+	case NPA_AF_RVU_GEN:
+		intr_val = npa_event_context->npa_af_rvu_gen;
+		err = rvu_report_pair_start(fmsg, "NPA_AF_GENERAL");
+		if (err)
+			return err;
+		err = devlink_fmsg_u64_pair_put(fmsg, "\tNPA General Interrupt Reg ",
+						npa_event_context->npa_af_rvu_gen);
+		if (err)
+			return err;
+		if (intr_val & BIT_ULL(32)) {
+			err = devlink_fmsg_string_put(fmsg, "\n\tUnmap PF Error");
+			if (err)
+				return err;
+		}
+
+		free_dis = FIELD_GET(GENMASK(15, 0), intr_val);
+		if (free_dis & BIT(NPA_INPQ_NIX0_RX)) {
+			err = devlink_fmsg_string_put(fmsg, "\n\tNIX0: free disabled RX");
+			if (err)
+				return err;
+		}
+		if (free_dis & BIT(NPA_INPQ_NIX0_TX)) {
+			err = devlink_fmsg_string_put(fmsg, "\n\tNIX0:free disabled TX");
+			if (err)
+				return err;
+		}
+		if (free_dis & BIT(NPA_INPQ_NIX1_RX)) {
+			err = devlink_fmsg_string_put(fmsg, "\n\tNIX1: free disabled RX");
+			if (err)
+				return err;
+		}
+		if (free_dis & BIT(NPA_INPQ_NIX1_TX)) {
+			err = devlink_fmsg_string_put(fmsg, "\n\tNIX1:free disabled TX");
+			if (err)
+				return err;
+		}
+		if (free_dis & BIT(NPA_INPQ_SSO)) {
+			err = devlink_fmsg_string_put(fmsg, "\n\tFree Disabled for SSO");
+			if (err)
+				return err;
+		}
+		if (free_dis & BIT(NPA_INPQ_TIM)) {
+			err = devlink_fmsg_string_put(fmsg, "\n\tFree Disabled for TIM");
+			if (err)
+				return err;
+		}
+		if (free_dis & BIT(NPA_INPQ_DPI)) {
+			err = devlink_fmsg_string_put(fmsg, "\n\tFree Disabled for DPI");
+			if (err)
+				return err;
+		}
+		if (free_dis & BIT(NPA_INPQ_AURA_OP)) {
+			err = devlink_fmsg_string_put(fmsg, "\n\tFree Disabled for AURA");
+			if (err)
+				return err;
+		}
+
+		alloc_dis = FIELD_GET(GENMASK(31, 16), intr_val);
+		if (alloc_dis & BIT(NPA_INPQ_NIX0_RX)) {
+			err = devlink_fmsg_string_put(fmsg, "\n\tNIX0: alloc disabled RX");
+			if (err)
+				return err;
+		}
+		if (alloc_dis & BIT(NPA_INPQ_NIX0_TX)) {
+			err = devlink_fmsg_string_put(fmsg, "\n\tNIX0:alloc disabled TX");
+			if (err)
+				return err;
+		}
+		if (alloc_dis & BIT(NPA_INPQ_NIX1_RX)) {
+			err = devlink_fmsg_string_put(fmsg, "\n\tNIX1: alloc disabled RX");
+			if (err)
+				return err;
+		}
+		if (alloc_dis & BIT(NPA_INPQ_NIX1_TX)) {
+			err = devlink_fmsg_string_put(fmsg, "\n\tNIX1:alloc disabled TX");
+			if (err)
+				return err;
+		}
+		if (alloc_dis & BIT(NPA_INPQ_SSO)) {
+			err = devlink_fmsg_string_put(fmsg, "\n\tAlloc Disabled for SSO");
+			if (err)
+				return err;
+		}
+		if (alloc_dis & BIT(NPA_INPQ_TIM)) {
+			err = devlink_fmsg_string_put(fmsg, "\n\tAlloc Disabled for TIM");
+			if (err)
+				return err;
+		}
+		if (alloc_dis & BIT(NPA_INPQ_DPI)) {
+			err = devlink_fmsg_string_put(fmsg, "\n\tAlloc Disabled for DPI");
+			if (err)
+				return err;
+		}
+		if (alloc_dis & BIT(NPA_INPQ_AURA_OP)) {
+			err = devlink_fmsg_string_put(fmsg, "\n\tAlloc Disabled for AURA");
+			if (err)
+				return err;
+		}
+		err = rvu_report_pair_end(fmsg);
+		if (err)
+			return err;
+		break;
+	case NPA_AF_RVU_ERR:
+		err = rvu_report_pair_start(fmsg, "NPA_AF_ERR");
+		if (err)
+			return err;
+		err = devlink_fmsg_u64_pair_put(fmsg, "\tNPA Error Interrupt Reg ",
+						npa_event_context->npa_af_rvu_err);
+		if (err)
+			return err;
+
+		if (npa_event_context->npa_af_rvu_err & BIT_ULL(14)) {
+			err = devlink_fmsg_string_put(fmsg, "\n\tFault on NPA_AQ_INST_S read");
+			if (err)
+				return err;
+		}
+		if (npa_event_context->npa_af_rvu_err & BIT_ULL(13)) {
+			err = devlink_fmsg_string_put(fmsg, "\n\tFault on NPA_AQ_RES_S write");
+			if (err)
+				return err;
+		}
+		if (npa_event_context->npa_af_rvu_err & BIT_ULL(12)) {
+			err = devlink_fmsg_string_put(fmsg, "\n\tAQ Doorbell Error");
+			if (err)
+				return err;
+		}
+		err = rvu_report_pair_end(fmsg);
+		if (err)
+			return err;
+		break;
+	case NPA_AF_RVU_RAS:
+		err = rvu_report_pair_start(fmsg, "NPA_AF_RVU_RAS");
+		if (err)
+			return err;
+		err = devlink_fmsg_u64_pair_put(fmsg, "\tNPA RAS Interrupt Reg ",
+						npa_event_context->npa_af_rvu_ras);
+		if (err)
+			return err;
+		if (npa_event_context->npa_af_rvu_ras & BIT_ULL(34)) {
+			err = devlink_fmsg_string_put(fmsg, "\n\tPoison data on NPA_AQ_INST_S");
+			if (err)
+				return err;
+		}
+		if (npa_event_context->npa_af_rvu_ras & BIT_ULL(33)) {
+			err = devlink_fmsg_string_put(fmsg, "\n\tPoison data on NPA_AQ_RES_S");
+			if (err)
+				return err;
+		}
+		if (npa_event_context->npa_af_rvu_ras & BIT_ULL(32)) {
+			err = devlink_fmsg_string_put(fmsg, "\n\tPoison data on HW context");
+			if (err)
+				return err;
+		}
+		err = rvu_report_pair_end(fmsg);
+		if (err)
+			return err;
+		break;
+	case NPA_AF_RVU_INTR:
+		err = rvu_report_pair_start(fmsg, "NPA_AF_RVU");
+		if (err)
+			return err;
+		err = devlink_fmsg_u64_pair_put(fmsg, "\tNPA RVU Interrupt Reg ",
+						npa_event_context->npa_af_rvu_int);
+		if (err)
+			return err;
+		if (npa_event_context->npa_af_rvu_int & BIT_ULL(0)) {
+			err = devlink_fmsg_string_put(fmsg, "\n\tUnmap Slot Error");
+			if (err)
+				return err;
+		}
+		return rvu_report_pair_end(fmsg);
+	default:
+		return -EINVAL;
+	}
+
+	return 0;
+}
+
+static int rvu_hw_npa_intr_dump(struct devlink_health_reporter *reporter,
+				struct devlink_fmsg *fmsg, void *ctx,
+				struct netlink_ext_ack *netlink_extack)
+{
+	struct rvu *rvu = devlink_health_reporter_priv(reporter);
+	struct rvu_devlink *rvu_dl = rvu->rvu_dl;
+	struct rvu_npa_event_ctx *npa_ctx;
+
+	npa_ctx = rvu_dl->rvu_npa_health_reporter->npa_event_ctx;
+
+	return ctx ? rvu_npa_report_show(fmsg, ctx, NPA_AF_RVU_INTR) :
+		     rvu_npa_report_show(fmsg, npa_ctx, NPA_AF_RVU_INTR);
+}
+
+static int rvu_hw_npa_intr_recover(struct devlink_health_reporter *reporter,
+				   void *ctx, struct netlink_ext_ack *netlink_extack)
+{
+	struct rvu *rvu = devlink_health_reporter_priv(reporter);
+	struct rvu_npa_event_ctx *npa_event_ctx = ctx;
+	int blkaddr;
+
+	blkaddr = rvu_get_blkaddr(rvu, BLKTYPE_NPA, 0);
+	if (blkaddr < 0)
+		return blkaddr;
+
+	if (npa_event_ctx->npa_af_rvu_int)
+		rvu_write64(rvu, blkaddr, NPA_AF_RVU_INT_ENA_W1S, ~0ULL);
+
+	return 0;
+}
+
+static int rvu_hw_npa_gen_dump(struct devlink_health_reporter *reporter,
+			       struct devlink_fmsg *fmsg, void *ctx,
+			       struct netlink_ext_ack *netlink_extack)
+{
+	struct rvu *rvu = devlink_health_reporter_priv(reporter);
+	struct rvu_devlink *rvu_dl = rvu->rvu_dl;
+	struct rvu_npa_event_ctx *npa_ctx;
+
+	npa_ctx = rvu_dl->rvu_npa_health_reporter->npa_event_ctx;
+
+	return ctx ? rvu_npa_report_show(fmsg, ctx, NPA_AF_RVU_GEN) :
+		     rvu_npa_report_show(fmsg, npa_ctx, NPA_AF_RVU_GEN);
+}
+
+static int rvu_hw_npa_gen_recover(struct devlink_health_reporter *reporter,
+				  void *ctx, struct netlink_ext_ack *netlink_extack)
+{
+	struct rvu *rvu = devlink_health_reporter_priv(reporter);
+	struct rvu_npa_event_ctx *npa_event_ctx = ctx;
+	int blkaddr;
+
+	blkaddr = rvu_get_blkaddr(rvu, BLKTYPE_NPA, 0);
+	if (blkaddr < 0)
+		return blkaddr;
+
+	if (npa_event_ctx->npa_af_rvu_gen)
+		rvu_write64(rvu, blkaddr, NPA_AF_GEN_INT_ENA_W1S, ~0ULL);
+
+	return 0;
+}
+
+static int rvu_hw_npa_err_dump(struct devlink_health_reporter *reporter,
+			       struct devlink_fmsg *fmsg, void *ctx,
+			       struct netlink_ext_ack *netlink_extack)
+{
+	struct rvu *rvu = devlink_health_reporter_priv(reporter);
+	struct rvu_devlink *rvu_dl = rvu->rvu_dl;
+	struct rvu_npa_event_ctx *npa_ctx;
+
+	npa_ctx = rvu_dl->rvu_npa_health_reporter->npa_event_ctx;
+
+	return ctx ? rvu_npa_report_show(fmsg, ctx, NPA_AF_RVU_ERR) :
+		     rvu_npa_report_show(fmsg, npa_ctx, NPA_AF_RVU_ERR);
+}
+
+static int rvu_hw_npa_err_recover(struct devlink_health_reporter *reporter,
+				  void *ctx, struct netlink_ext_ack *netlink_extack)
+{
+	struct rvu *rvu = devlink_health_reporter_priv(reporter);
+	struct rvu_npa_event_ctx *npa_event_ctx = ctx;
+	int blkaddr;
+
+	blkaddr = rvu_get_blkaddr(rvu, BLKTYPE_NPA, 0);
+	if (blkaddr < 0)
+		return blkaddr;
+
+	if (npa_event_ctx->npa_af_rvu_err)
+		rvu_write64(rvu, blkaddr, NPA_AF_ERR_INT_ENA_W1S, ~0ULL);
+
+	return 0;
+}
+
+static int rvu_hw_npa_ras_dump(struct devlink_health_reporter *reporter,
+			       struct devlink_fmsg *fmsg, void *ctx,
+			       struct netlink_ext_ack *netlink_extack)
+{
+	struct rvu *rvu = devlink_health_reporter_priv(reporter);
+	struct rvu_devlink *rvu_dl = rvu->rvu_dl;
+	struct rvu_npa_event_ctx *npa_ctx;
+
+	npa_ctx = rvu_dl->rvu_npa_health_reporter->npa_event_ctx;
+
+	return ctx ? rvu_npa_report_show(fmsg, ctx, NPA_AF_RVU_RAS) :
+		     rvu_npa_report_show(fmsg, npa_ctx, NPA_AF_RVU_RAS);
+}
+
+static int rvu_hw_npa_ras_recover(struct devlink_health_reporter *reporter,
+				  void *ctx, struct netlink_ext_ack *netlink_extack)
+{
+	struct rvu *rvu = devlink_health_reporter_priv(reporter);
+	struct rvu_npa_event_ctx *npa_event_ctx = ctx;
+	int blkaddr;
+
+	blkaddr = rvu_get_blkaddr(rvu, BLKTYPE_NPA, 0);
+	if (blkaddr < 0)
+		return blkaddr;
+
+	if (npa_event_ctx->npa_af_rvu_ras)
+		rvu_write64(rvu, blkaddr, NPA_AF_RAS_ENA_W1S, ~0ULL);
+
+	return 0;
+}
+
+RVU_REPORTERS(hw_npa_intr);
+RVU_REPORTERS(hw_npa_gen);
+RVU_REPORTERS(hw_npa_err);
+RVU_REPORTERS(hw_npa_ras);
+
+static void rvu_npa_health_reporters_destroy(struct rvu_devlink *rvu_dl);
+
+static int rvu_npa_register_reporters(struct rvu_devlink *rvu_dl)
+{
+	struct rvu_npa_health_reporters *rvu_reporters;
+	struct rvu_npa_event_ctx *npa_event_context;
+	struct rvu *rvu = rvu_dl->rvu;
+
+	rvu_reporters = kzalloc(sizeof(*rvu_reporters), GFP_KERNEL);
+	if (!rvu_reporters)
+		return -ENOMEM;
+
+	rvu_dl->rvu_npa_health_reporter = rvu_reporters;
+	npa_event_context = kzalloc(sizeof(*npa_event_context), GFP_KERNEL);
+	if (!npa_event_context)
+		return -ENOMEM;
+
+	rvu_reporters->npa_event_ctx = npa_event_context;
+	rvu_reporters->rvu_hw_npa_intr_reporter =
+		devlink_health_reporter_create(rvu_dl->dl, &rvu_hw_npa_intr_reporter_ops, 0, rvu);
+	if (IS_ERR(rvu_reporters->rvu_hw_npa_intr_reporter)) {
+		dev_warn(rvu->dev, "Failed to create hw_npa_intr reporter, err=%ld\n",
+			 PTR_ERR(rvu_reporters->rvu_hw_npa_intr_reporter));
+		return PTR_ERR(rvu_reporters->rvu_hw_npa_intr_reporter);
+	}
+
+	rvu_reporters->rvu_hw_npa_gen_reporter =
+		devlink_health_reporter_create(rvu_dl->dl, &rvu_hw_npa_gen_reporter_ops, 0, rvu);
+	if (IS_ERR(rvu_reporters->rvu_hw_npa_gen_reporter)) {
+		dev_warn(rvu->dev, "Failed to create hw_npa_gen reporter, err=%ld\n",
+			 PTR_ERR(rvu_reporters->rvu_hw_npa_gen_reporter));
+		return PTR_ERR(rvu_reporters->rvu_hw_npa_gen_reporter);
+	}
+
+	rvu_reporters->rvu_hw_npa_err_reporter =
+		devlink_health_reporter_create(rvu_dl->dl, &rvu_hw_npa_err_reporter_ops, 0, rvu);
+	if (IS_ERR(rvu_reporters->rvu_hw_npa_err_reporter)) {
+		dev_warn(rvu->dev, "Failed to create hw_npa_err reporter, err=%ld\n",
+			 PTR_ERR(rvu_reporters->rvu_hw_npa_err_reporter));
+		return PTR_ERR(rvu_reporters->rvu_hw_npa_err_reporter);
+	}
+
+	rvu_reporters->rvu_hw_npa_ras_reporter =
+		devlink_health_reporter_create(rvu_dl->dl, &rvu_hw_npa_ras_reporter_ops, 0, rvu);
+	if (IS_ERR(rvu_reporters->rvu_hw_npa_ras_reporter)) {
+		dev_warn(rvu->dev, "Failed to create hw_npa_ras reporter, err=%ld\n",
+			 PTR_ERR(rvu_reporters->rvu_hw_npa_ras_reporter));
+		return PTR_ERR(rvu_reporters->rvu_hw_npa_ras_reporter);
+	}
+
+	rvu_dl->devlink_wq = create_workqueue("rvu_devlink_wq");
+	if (!rvu_dl->devlink_wq)
+		goto err;
+
+	INIT_WORK(&rvu_reporters->intr_work, rvu_npa_intr_work);
+	INIT_WORK(&rvu_reporters->err_work, rvu_npa_err_work);
+	INIT_WORK(&rvu_reporters->gen_work, rvu_npa_gen_work);
+	INIT_WORK(&rvu_reporters->ras_work, rvu_npa_ras_work);
+
+	return 0;
+err:
+	rvu_npa_health_reporters_destroy(rvu_dl);
+	return -ENOMEM;
+}
+
+static int rvu_npa_health_reporters_create(struct rvu_devlink *rvu_dl)
+{
+	struct rvu *rvu = rvu_dl->rvu;
+	int err;
+
+	err = rvu_npa_register_reporters(rvu_dl);
+	if (err) {
+		dev_warn(rvu->dev, "Failed to create npa reporter, err =%d\n",
+			 err);
+		return err;
+	}
+	rvu_npa_register_interrupts(rvu);
+
+	return 0;
+}
+
+static void rvu_npa_health_reporters_destroy(struct rvu_devlink *rvu_dl)
+{
+	struct rvu_npa_health_reporters *npa_reporters;
+	struct rvu *rvu = rvu_dl->rvu;
+
+	npa_reporters = rvu_dl->rvu_npa_health_reporter;
+
+	if (!npa_reporters->rvu_hw_npa_ras_reporter)
+		return;
+	if (!IS_ERR_OR_NULL(npa_reporters->rvu_hw_npa_intr_reporter))
+		devlink_health_reporter_destroy(npa_reporters->rvu_hw_npa_intr_reporter);
+
+	if (!IS_ERR_OR_NULL(npa_reporters->rvu_hw_npa_gen_reporter))
+		devlink_health_reporter_destroy(npa_reporters->rvu_hw_npa_gen_reporter);
+
+	if (!IS_ERR_OR_NULL(npa_reporters->rvu_hw_npa_err_reporter))
+		devlink_health_reporter_destroy(npa_reporters->rvu_hw_npa_err_reporter);
+
+	if (!IS_ERR_OR_NULL(npa_reporters->rvu_hw_npa_ras_reporter))
+		devlink_health_reporter_destroy(npa_reporters->rvu_hw_npa_ras_reporter);
+
+	rvu_npa_unregister_interrupts(rvu);
+	kfree(rvu_dl->rvu_npa_health_reporter->npa_event_ctx);
+	kfree(rvu_dl->rvu_npa_health_reporter);
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
@@ -47,7 +751,8 @@ int rvu_register_dl(struct rvu *rvu)
 	rvu_dl->dl = dl;
 	rvu_dl->rvu = rvu;
 	rvu->rvu_dl = rvu_dl;
-	return 0;
+
+	return rvu_health_reporters_create(rvu);
 }
 
 void rvu_unregister_dl(struct rvu *rvu)
@@ -58,6 +763,7 @@ void rvu_unregister_dl(struct rvu *rvu)
 	if (!dl)
 		return;
 
+	rvu_health_reporters_destroy(rvu);
 	devlink_unregister(dl);
 	devlink_free(dl);
 	kfree(rvu_dl);
diff --git a/drivers/net/ethernet/marvell/octeontx2/af/rvu_devlink.h b/drivers/net/ethernet/marvell/octeontx2/af/rvu_devlink.h
index 1ed6dde79a4e..d7578fa92ac1 100644
--- a/drivers/net/ethernet/marvell/octeontx2/af/rvu_devlink.h
+++ b/drivers/net/ethernet/marvell/octeontx2/af/rvu_devlink.h
@@ -8,9 +8,44 @@
 #ifndef RVU_DEVLINK_H
 #define  RVU_DEVLINK_H
 
+#define RVU_REPORTERS(_name)  \
+static const struct devlink_health_reporter_ops  rvu_ ## _name ## _reporter_ops =  { \
+	.name = #_name, \
+	.recover = rvu_ ## _name ## _recover, \
+	.dump = rvu_ ## _name ## _dump, \
+}
+
+enum npa_af_rvu_health {
+	NPA_AF_RVU_INTR,
+	NPA_AF_RVU_GEN,
+	NPA_AF_RVU_ERR,
+	NPA_AF_RVU_RAS,
+};
+
+struct rvu_npa_event_ctx {
+	u64 npa_af_rvu_int;
+	u64 npa_af_rvu_gen;
+	u64 npa_af_rvu_err;
+	u64 npa_af_rvu_ras;
+};
+
+struct rvu_npa_health_reporters {
+	struct rvu_npa_event_ctx *npa_event_ctx;
+	struct devlink_health_reporter *rvu_hw_npa_intr_reporter;
+	struct work_struct              intr_work;
+	struct devlink_health_reporter *rvu_hw_npa_gen_reporter;
+	struct work_struct              gen_work;
+	struct devlink_health_reporter *rvu_hw_npa_err_reporter;
+	struct work_struct             err_work;
+	struct devlink_health_reporter *rvu_hw_npa_ras_reporter;
+	struct work_struct              ras_work;
+};
+
 struct rvu_devlink {
 	struct devlink *dl;
 	struct rvu *rvu;
+	struct workqueue_struct *devlink_wq;
+	struct rvu_npa_health_reporters *rvu_npa_health_reporter;
 };
 
 /* Devlink APIs */
diff --git a/drivers/net/ethernet/marvell/octeontx2/af/rvu_struct.h b/drivers/net/ethernet/marvell/octeontx2/af/rvu_struct.h
index 723643868589..e2153d47c373 100644
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

