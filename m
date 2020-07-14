Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 5CD4B21E867
	for <lists+netdev@lfdr.de>; Tue, 14 Jul 2020 08:39:41 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1725977AbgGNGjj (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 14 Jul 2020 02:39:39 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:37778 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1725788AbgGNGji (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 14 Jul 2020 02:39:38 -0400
Received: from mail-pl1-x644.google.com (mail-pl1-x644.google.com [IPv6:2607:f8b0:4864:20::644])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id A262EC061755
        for <netdev@vger.kernel.org>; Mon, 13 Jul 2020 23:39:38 -0700 (PDT)
Received: by mail-pl1-x644.google.com with SMTP id q17so6609808pls.9
        for <netdev@vger.kernel.org>; Mon, 13 Jul 2020 23:39:38 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=from:to:cc:subject:date:message-id:in-reply-to:references;
        bh=NkRMPzDOPhwF4AMv+VfvaJWfNs8Xu8T4sYtwHMMp7iU=;
        b=rI+DLicRvtlt2cz/xoW1mXht+uynhgsvBzt6bR3zifJBjHhKWHapSOE4w3Yl1mri8j
         mZm2Ipc24WJW2UXDGsSm1spdRQgiPVmCcwEkmgKd77vN8jG+el29wP/Po6f0TRsP9HWW
         Rzh9PaAQHmXuyvLnD23jn1m1Xz9DIlejDSAbofRZHqfSB9p0h4WFnwUEaEAEuMqs6QlY
         McfkMuarxKLEmdoUqAq9SjZ+MrXIJEJrq793YP4CnwdX+Y1WCP8xKPZ/SIrn0egMjUqy
         K3fNIJOLaaaEnh6IaTmDVABPYSTTANWFI7NWZk0yjeNqLcwxEJyouTDYgAm59YpmdVn5
         zfLg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references;
        bh=NkRMPzDOPhwF4AMv+VfvaJWfNs8Xu8T4sYtwHMMp7iU=;
        b=mSyJlbsQhuJplPXckfAKSzaoXjPUci06FfOvi+wMfHuizkaGagQrWpZ6nTJ4NtvcOZ
         RTBpZdqX/qTQkG9B7ot+JqAcvKewdpdoYt6P/z25VEba3gq9SEI3CJI5JNNl7WQWYM/m
         hulm8JG6gmsTlvoTLRN0I16+zs05WmZrwsnZhEMnSyJcy08+d89TyDjRrDkW1DzY1Lr5
         ETPtt1v/9aHJUar86pq5V+srAgNv9FEiylWsaisYDUrCYVxDbwYbb/18DTG6QyT6Sm89
         Md2w7BDJ9w3zHd66LKm/JwP0QW4KLylpp9ziKFOF9UL49akEsotWBOfXJL13gphOoYM2
         2pDg==
X-Gm-Message-State: AOAM531XoIegsrbHJ5VuwEG5KtiixfRx4dVFsds+JY+UneHoDG1VI6za
        XRF0aGtRk2IoX8kQXy8yCGQ=
X-Google-Smtp-Source: ABdhPJyWoRC982iORrLuuVHFuvFPAhAw+ygTX02OjKxpyq7hrDPa2y88BYwY4HbqFnmihbaglTYAMA==
X-Received: by 2002:a17:90b:4a4e:: with SMTP id lb14mr3175139pjb.196.1594708778146;
        Mon, 13 Jul 2020 23:39:38 -0700 (PDT)
Received: from hyd1soter3.caveonetworks.com ([115.113.156.2])
        by smtp.googlemail.com with ESMTPSA id f29sm14620209pga.59.2020.07.13.23.39.35
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 13 Jul 2020 23:39:37 -0700 (PDT)
From:   rakeshs.lkm@gmail.com
To:     sbhatta@marvell.com, sgoutham@marvell.com, jerinj@marvell.com,
        rsaladi2@marvell.com, davem@davemloft.net, kuba@kernel.org,
        netdev@vger.kernel.org
Cc:     Sunil Kovvuri Goutham <Sunil.Goutham@cavium.com>
Subject: [net-next PATCH 1/2] octeontx2-af: add npa error af interrupt handlers
Date:   Tue, 14 Jul 2020 12:08:24 +0530
Message-Id: <20200714063825.24369-2-rakeshs.lkm@gmail.com>
X-Mailer: git-send-email 2.17.1
In-Reply-To: <20200714063825.24369-1-rakeshs.lkm@gmail.com>
References: <20200714063825.24369-1-rakeshs.lkm@gmail.com>
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Jerin Jacob <jerinj@marvell.com>

Added debug messages for NPA NPA_AF_RVU_INT, NPA_AF_GEN_INT, NPA_AF_ERR_INT
and NPA_AF_RAS error AF interrupts

Signed-off-by: Jerin Jacob <jerinj@marvell.com>
Signed-off-by: Sunil Kovvuri Goutham <Sunil.Goutham@cavium.com>
Signed-off-by: Rakesh Babu <rsaladi2@marvell.com>
Signed-off-by: Subbaraya Sundeep <sbhatta@marvell.com>
---
 .../net/ethernet/marvell/octeontx2/af/rvu.c   |   7 +
 .../net/ethernet/marvell/octeontx2/af/rvu.h   |   2 +
 .../ethernet/marvell/octeontx2/af/rvu_npa.c   | 230 ++++++++++++++++++
 .../marvell/octeontx2/af/rvu_struct.h         |  23 ++
 4 files changed, 262 insertions(+)

diff --git a/drivers/net/ethernet/marvell/octeontx2/af/rvu.c b/drivers/net/ethernet/marvell/octeontx2/af/rvu.c
index 557e4292c846..6c4027f04cfc 100644
--- a/drivers/net/ethernet/marvell/octeontx2/af/rvu.c
+++ b/drivers/net/ethernet/marvell/octeontx2/af/rvu.c
@@ -2130,6 +2130,8 @@ static void rvu_unregister_interrupts(struct rvu *rvu)
 {
 	int irq;

+	rvu_npa_unregister_interrupts(rvu);
+
 	/* Disable the Mbox interrupt */
 	rvu_write64(rvu, BLKADDR_RVUM, RVU_AF_PFAF_MBOX_INT_ENA_W1C,
 		    INTR_MASK(rvu->hw->total_pfs) & ~1ULL);
@@ -2337,6 +2339,11 @@ static int rvu_register_interrupts(struct rvu *rvu)
 		goto fail;
 	}
 	rvu->irq_allocated[offset] = true;
+
+	ret = rvu_npa_register_interrupts(rvu);
+	if (ret)
+		goto fail;
+
 	return 0;

 fail:
diff --git a/drivers/net/ethernet/marvell/octeontx2/af/rvu.h b/drivers/net/ethernet/marvell/octeontx2/af/rvu.h
index dcf25a092008..63c9f6049ad5 100644
--- a/drivers/net/ethernet/marvell/octeontx2/af/rvu.h
+++ b/drivers/net/ethernet/marvell/octeontx2/af/rvu.h
@@ -453,6 +453,8 @@ void rvu_npa_freemem(struct rvu *rvu);
 void rvu_npa_lf_teardown(struct rvu *rvu, u16 pcifunc, int npalf);
 int rvu_npa_aq_enq_inst(struct rvu *rvu, struct npa_aq_enq_req *req,
 			struct npa_aq_enq_rsp *rsp);
+int rvu_npa_register_interrupts(struct rvu *rvu);
+void rvu_npa_unregister_interrupts(struct rvu *rvu);

 /* NIX APIs */
 bool is_nixlf_attached(struct rvu *rvu, u16 pcifunc);
diff --git a/drivers/net/ethernet/marvell/octeontx2/af/rvu_npa.c b/drivers/net/ethernet/marvell/octeontx2/af/rvu_npa.c
index 67471cb2b129..2476d20280cb 100644
--- a/drivers/net/ethernet/marvell/octeontx2/af/rvu_npa.c
+++ b/drivers/net/ethernet/marvell/octeontx2/af/rvu_npa.c
@@ -8,8 +8,10 @@
  * published by the Free Software Foundation.
  */

+#include <linux/bitfield.h>
 #include <linux/module.h>
 #include <linux/pci.h>
+#include <linux/stringify.h>

 #include "rvu_struct.h"
 #include "rvu_reg.h"
@@ -541,3 +543,231 @@ void rvu_npa_lf_teardown(struct rvu *rvu, u16 pcifunc, int npalf)

 	npa_ctx_free(rvu, pfvf);
 }
+
+static irqreturn_t rvu_npa_af_rvu_intr_handler(int irq, void *rvu_irq)
+{
+	struct rvu *rvu = (struct rvu *)rvu_irq;
+	int blkaddr;
+	u64 intr;
+
+	blkaddr = rvu_get_blkaddr(rvu, BLKTYPE_NPA, 0);
+	if (blkaddr < 0)
+		return IRQ_NONE;
+
+	intr = rvu_read64(rvu, blkaddr, NPA_AF_RVU_INT);
+
+	if (intr & BIT_ULL(0))
+		dev_err(rvu->dev, "NPA: Unmapped slot error\n");
+
+	/* Clear interrupts */
+	rvu_write64(rvu, blkaddr, NPA_AF_RVU_INT, intr);
+	return IRQ_HANDLED;
+}
+
+static const char *rvu_npa_inpq_to_str(u16 in)
+{
+	switch (in) {
+	case 0:
+		return NULL;
+	case BIT(NPA_INPQ_NIX0_RX):
+		return __stringify(NPA_INPQ_NIX0_RX);
+	case BIT(NPA_INPQ_NIX0_TX):
+		return __stringify(NPA_INPQ_NIX0_TX);
+	case BIT(NPA_INPQ_NIX1_RX):
+		return __stringify(NPA_INPQ_NIX1_RX);
+	case BIT(NPA_INPQ_NIX1_TX):
+		return __stringify(NPA_INPQ_NIX1_TX);
+	case BIT(NPA_INPQ_SSO):
+		return __stringify(NPA_INPQ_SSO);
+	case BIT(NPA_INPQ_TIM):
+		return __stringify(NPA_INPQ_TIM);
+	case BIT(NPA_INPQ_DPI):
+		return __stringify(NPA_INPQ_DPI);
+	case BIT(NPA_INPQ_AURA_OP):
+		return __stringify(NPA_INPQ_AURA_OP);
+	case BIT(NPA_INPQ_INTERNAL_RSV):
+		return __stringify(NPA_INPQ_INTERNAL_RSV);
+	}
+
+	return "Reserved";
+}
+
+static irqreturn_t rvu_npa_af_gen_intr_handler(int irq, void *rvu_irq)
+{
+	struct rvu *rvu = (struct rvu *)rvu_irq;
+	const char *err_msg;
+	int blkaddr, val;
+	u64 intr;
+
+	blkaddr = rvu_get_blkaddr(rvu, BLKTYPE_NPA, 0);
+	if (blkaddr < 0)
+		return IRQ_NONE;
+
+	intr = rvu_read64(rvu, blkaddr, NPA_AF_GEN_INT);
+
+	if (intr & BIT_ULL(32))
+		dev_err(rvu->dev, "NPA: Unmapped PF func error\n");
+
+	val = FIELD_GET(GENMASK(31, 16), intr);
+	err_msg = rvu_npa_inpq_to_str(val);
+	if (err_msg)
+		dev_err(rvu->dev, "NPA: Alloc disabled for %s\n", err_msg);
+
+	val = FIELD_GET(GENMASK(15, 0), intr);
+	err_msg = rvu_npa_inpq_to_str(val);
+	if (err_msg)
+		dev_err(rvu->dev, "NPA: Free disabled for %s\n", err_msg);
+
+	/* Clear interrupts */
+	rvu_write64(rvu, blkaddr, NPA_AF_GEN_INT, intr);
+	return IRQ_HANDLED;
+}
+
+static irqreturn_t rvu_npa_af_err_intr_handler(int irq, void *rvu_irq)
+{
+	struct rvu *rvu = (struct rvu *)rvu_irq;
+	int blkaddr;
+	u64 intr;
+
+	blkaddr = rvu_get_blkaddr(rvu, BLKTYPE_NPA, 0);
+	if (blkaddr < 0)
+		return IRQ_NONE;
+
+	intr = rvu_read64(rvu, blkaddr, NPA_AF_ERR_INT);
+
+	if (intr & BIT_ULL(14))
+		dev_err(rvu->dev, "NPA: Memory fault on NPA_AQ_INST_S read\n");
+
+	if (intr & BIT_ULL(13))
+		dev_err(rvu->dev, "NPA: Memory fault on NPA_AQ_RES_S write\n");
+
+	if (intr & BIT_ULL(12))
+		dev_err(rvu->dev, "NPA: AQ doorbell error\n");
+
+	/* Clear interrupts */
+	rvu_write64(rvu, blkaddr, NPA_AF_ERR_INT, intr);
+	return IRQ_HANDLED;
+}
+
+static irqreturn_t rvu_npa_af_ras_intr_handler(int irq, void *rvu_irq)
+{
+	struct rvu *rvu = (struct rvu *)rvu_irq;
+	int blkaddr;
+	u64 intr;
+
+	blkaddr = rvu_get_blkaddr(rvu, BLKTYPE_NPA, 0);
+	if (blkaddr < 0)
+		return IRQ_NONE;
+
+	intr = rvu_read64(rvu, blkaddr, NPA_AF_RAS);
+
+	if (intr & BIT_ULL(34))
+		dev_err(rvu->dev, "NPA: Poisoned data on NPA_AQ_INST_S read\n");
+
+	if (intr & BIT_ULL(33))
+		dev_err(rvu->dev, "NPA: Poisoned data on NPA_AQ_RES_S write\n");
+
+	if (intr & BIT_ULL(32))
+		dev_err(rvu->dev, "NPA: Poisoned data on HW context read\n");
+
+	/* Clear interrupts */
+	rvu_write64(rvu, blkaddr, NPA_AF_RAS, intr);
+	return IRQ_HANDLED;
+}
+
+static bool rvu_npa_af_request_irq(struct rvu *rvu, int blkaddr, int offset,
+				   const char *name, irq_handler_t fn)
+{
+	int rc;
+
+	WARN_ON(rvu->irq_allocated[offset]);
+	rvu->irq_allocated[offset] = false;
+	sprintf(&rvu->irq_name[offset * NAME_SIZE], name);
+	rc = request_irq(pci_irq_vector(rvu->pdev, offset), fn, 0,
+			 &rvu->irq_name[offset * NAME_SIZE], rvu);
+	if (rc)
+		dev_warn(rvu->dev, "Failed to register %s irq\n", name);
+	else
+		rvu->irq_allocated[offset] = true;
+
+	return rvu->irq_allocated[offset];
+}
+
+int rvu_npa_register_interrupts(struct rvu *rvu)
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
+	rc = rvu_npa_af_request_irq(rvu, blkaddr, base +  NPA_AF_INT_VEC_RVU,
+				    "NPA_AF_RVU_INT",
+				    rvu_npa_af_rvu_intr_handler);
+	if (!rc)
+		goto err;
+	rvu_write64(rvu, blkaddr, NPA_AF_RVU_INT_ENA_W1S, ~0ULL);
+
+	/* Register and enable NPA_AF_GEN_INT interrupt */
+	rc = rvu_npa_af_request_irq(rvu, blkaddr, base + NPA_AF_INT_VEC_GEN,
+				    "NPA_AF_RVU_GEN",
+				    rvu_npa_af_gen_intr_handler);
+	if (!rc)
+		goto err;
+	rvu_write64(rvu, blkaddr, NPA_AF_GEN_INT_ENA_W1S, ~0ULL);
+
+	/* Register and enable NPA_AF_ERR_INT interrupt */
+	rc = rvu_npa_af_request_irq(rvu, blkaddr, base + NPA_AF_INT_VEC_AF_ERR,
+				    "NPA_AF_ERR_INT",
+				    rvu_npa_af_err_intr_handler);
+	if (!rc)
+		goto err;
+	rvu_write64(rvu, blkaddr, NPA_AF_ERR_INT_ENA_W1S, ~0ULL);
+
+	/* Register and enable NPA_AF_RAS interrupt */
+	rc = rvu_npa_af_request_irq(rvu, blkaddr, base + NPA_AF_INT_VEC_POISON,
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
+void rvu_npa_unregister_interrupts(struct rvu *rvu)
+{
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
+			free_irq(pci_irq_vector(rvu->pdev, offs + i), rvu);
+			rvu->irq_allocated[offs + i] = false;
+		}
+}
diff --git a/drivers/net/ethernet/marvell/octeontx2/af/rvu_struct.h b/drivers/net/ethernet/marvell/octeontx2/af/rvu_struct.h
index a3ecb5de9000..bf5f03aeb5f0 100644
--- a/drivers/net/ethernet/marvell/octeontx2/af/rvu_struct.h
+++ b/drivers/net/ethernet/marvell/octeontx2/af/rvu_struct.h
@@ -60,6 +60,16 @@ enum rvu_af_int_vec_e {
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
@@ -100,6 +110,19 @@ enum npa_aq_instop {
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
2.17.1
