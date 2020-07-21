Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 84BE92275C7
	for <lists+netdev@lfdr.de>; Tue, 21 Jul 2020 04:41:02 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728223AbgGUCk7 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 20 Jul 2020 22:40:59 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:56052 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726463AbgGUCk7 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 20 Jul 2020 22:40:59 -0400
Received: from mail-pl1-x643.google.com (mail-pl1-x643.google.com [IPv6:2607:f8b0:4864:20::643])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 11CB3C061794
        for <netdev@vger.kernel.org>; Mon, 20 Jul 2020 19:40:59 -0700 (PDT)
Received: by mail-pl1-x643.google.com with SMTP id q17so9580469pls.9
        for <netdev@vger.kernel.org>; Mon, 20 Jul 2020 19:40:59 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=from:to:subject:date:message-id:in-reply-to:references;
        bh=69iPMljMASeZhunj3Zl7cfMzQPbC4VDn8mm+UGhwkag=;
        b=e0Uij7+mLzZWpKqBJ8jZq5jz3MbL9KY3jZLlmVDeI+It5DJpxNVWk8z3PcsJZ0piOA
         UriZUR9a1/SyGSL9GKRgMM38lbXqf8yQUGgGoFsHjDyWebPQqx5csoUWZ7O7jkKkBqpt
         8JjXy80GQznXb3OOMWe+gQYPS9EDBqES1a/wVaVOaSWz8vm1YRMAY7iVIw/5AR9f+M3u
         dFj14euD3NlK+n0szMlw9aKbTx72Tjj5NnyfxqpRNxvUcZioVWGJFGBQ8rx/wOuqNj+z
         c7frXeNYnyboyQMyM0A1zA2g1bikdfvMOBTxzFW98Tx2IPRylyfUEEdcXJxh7q+FgipB
         4rvA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:subject:date:message-id:in-reply-to
         :references;
        bh=69iPMljMASeZhunj3Zl7cfMzQPbC4VDn8mm+UGhwkag=;
        b=PWTtDnLT7rZ5Q2d6lMh4ex7h4cPOhGzc5Cwh+RLlxRTSIuuOG9/hMU5kSQ5JDuCSJ8
         I2jwzA5L9/lee7LwCVLNBM3NRvjI0JybshAC2PVAONps2tP8EuV6QnWRVUjjuPsylgBz
         4LSt167f4j1gISrGyM1PVCamCDkW3Pq6pai+dNsg0he9WfnxAj06UYrWunzgWbstn4C3
         PhvCuMf6gebtXbHB5sI/+V9lIFjiUfFYiFyO6dLkZWBT0BH5j2nDPlAX3Kt1M5HlgXwv
         bJM9DA6wwo9bvz7bo3FdHo4CLueyq/caoDxt/sqroc54O/9grZLvHyHq8FaFy/Fj7Nxl
         z0nA==
X-Gm-Message-State: AOAM533nQ5K7VlyOgcxIfMvjMnvyH1dBIOYfUfXWaIsWQkVWiiTLlQIQ
        QtrPr8vIkq63cgfZ/5YY3lw=
X-Google-Smtp-Source: ABdhPJxIaRXHWButFrSABbx15q1Kv9Zh4xVFvSs3gjWmMKgqfNysQkz5qG0UTOguLdiO7t0cpNWGag==
X-Received: by 2002:a17:902:e903:: with SMTP id k3mr19202815pld.155.1595299258604;
        Mon, 20 Jul 2020 19:40:58 -0700 (PDT)
Received: from hyd1soter3.caveonetworks.com ([115.113.156.2])
        by smtp.googlemail.com with ESMTPSA id i21sm18499114pfa.18.2020.07.20.19.40.55
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 20 Jul 2020 19:40:57 -0700 (PDT)
From:   rakeshs.lkm@gmail.com
To:     sbhatta@marvell.com, sgoutham@marvell.com, jerinj@marvell.com,
        rsaladi2@marvell.com, davem@davemloft.net, kuba@kernel.org,
        netdev@vger.kernel.org
Subject: [PATCH v2 1/2] octeontx2-af: add npa error af interrupt handlers
Date:   Tue, 21 Jul 2020 08:08:46 +0530
Message-Id: <20200721023847.2567-2-rakeshs.lkm@gmail.com>
X-Mailer: git-send-email 2.17.1
In-Reply-To: <20200721023847.2567-1-rakeshs.lkm@gmail.com>
References: <20200721023847.2567-1-rakeshs.lkm@gmail.com>
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Jerin Jacob <jerinj@marvell.com>

Added debug messages for NPA NPA_AF_RVU_INT, NPA_AF_GEN_INT, NPA_AF_ERR_INT
and NPA_AF_RAS error AF interrupts

Signed-off-by: Jerin Jacob <jerinj@marvell.com>
Signed-off-by: Sunil Kovvuri Goutham <sgoutham@marvell.com>
Signed-off-by: Rakesh Babu <rsaladi2@marvell.com>
Signed-off-by: Subbaraya Sundeep <sbhatta@marvell.com>
---
 .../net/ethernet/marvell/octeontx2/af/rvu.c   |   7 +
 .../net/ethernet/marvell/octeontx2/af/rvu.h   |   2 +
 .../ethernet/marvell/octeontx2/af/rvu_npa.c   | 176 ++++++++++++++++++
 .../marvell/octeontx2/af/rvu_struct.h         |  10 +
 4 files changed, 195 insertions(+)

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
index 67471cb2b129..1d1043ce4378 100644
--- a/drivers/net/ethernet/marvell/octeontx2/af/rvu_npa.c
+++ b/drivers/net/ethernet/marvell/octeontx2/af/rvu_npa.c
@@ -8,6 +8,7 @@
  * published by the Free Software Foundation.
  */

+#include <linux/bitfield.h>
 #include <linux/module.h>
 #include <linux/pci.h>

@@ -541,3 +542,178 @@ void rvu_npa_lf_teardown(struct rvu *rvu, u16 pcifunc, int npalf)

 	npa_ctx_free(rvu, pfvf);
 }
+
+static irqreturn_t rvu_npa_af_rvu_intr_handler(int irq, void *rvu_irq)
+{
+	struct rvu *rvu = rvu_irq;
+	int blkaddr;
+	u64 intr;
+
+	blkaddr = rvu_get_blkaddr(rvu, BLKTYPE_NPA, 0);
+	if (blkaddr < 0)
+		return IRQ_NONE;
+
+	intr = rvu_read64(rvu, blkaddr, NPA_AF_RVU_INT);
+	dev_err(rvu->dev, "NPA: RVU Interrupt : 0x%llx\n", intr);
+
+	/* Clear interrupts */
+	rvu_write64(rvu, blkaddr, NPA_AF_RVU_INT, intr);
+	return IRQ_HANDLED;
+}
+
+static irqreturn_t rvu_npa_af_gen_intr_handler(int irq, void *rvu_irq)
+{
+	struct rvu *rvu = rvu_irq;
+	int blkaddr, val;
+	u64 intr;
+
+	blkaddr = rvu_get_blkaddr(rvu, BLKTYPE_NPA, 0);
+	if (blkaddr < 0)
+		return IRQ_NONE;
+
+	intr = rvu_read64(rvu, blkaddr, NPA_AF_GEN_INT);
+	dev_err(rvu->dev, "NPA: General Interrupt : 0x%llx\n", intr);
+
+	val = FIELD_GET(GENMASK(31, 16), intr);
+	dev_err(rvu->dev, "NPA: Alloc disabled interrupt : 0x%x\n", val);
+
+	val = FIELD_GET(GENMASK(15, 0), intr);
+	dev_err(rvu->dev, "NPA: Free disabled interrupt : 0x%x\n", val);
+
+	/* Clear interrupts */
+	rvu_write64(rvu, blkaddr, NPA_AF_GEN_INT, intr);
+	return IRQ_HANDLED;
+}
+
+static irqreturn_t rvu_npa_af_err_intr_handler(int irq, void *rvu_irq)
+{
+	struct rvu *rvu = rvu_irq;
+	int blkaddr;
+	u64 intr;
+
+	blkaddr = rvu_get_blkaddr(rvu, BLKTYPE_NPA, 0);
+	if (blkaddr < 0)
+		return IRQ_NONE;
+
+	intr = rvu_read64(rvu, blkaddr, NPA_AF_ERR_INT);
+	dev_err(rvu->dev, "NPA: Error Interrupt : 0x%llx\n", intr);
+
+	/* Clear interrupts */
+	rvu_write64(rvu, blkaddr, NPA_AF_ERR_INT, intr);
+	return IRQ_HANDLED;
+}
+
+static irqreturn_t rvu_npa_af_ras_intr_handler(int irq, void *rvu_irq)
+{
+	struct rvu *rvu = rvu_irq;
+	int blkaddr;
+	u64 intr;
+
+	blkaddr = rvu_get_blkaddr(rvu, BLKTYPE_NPA, 0);
+	if (blkaddr < 0)
+		return IRQ_NONE;
+
+	intr = rvu_read64(rvu, blkaddr, NPA_AF_RAS);
+	dev_err(rvu->dev, "NPA: RAS Interrupt : 0x%llx\n", intr);
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
index a3ecb5de9000..cc06a9242300 100644
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
--
2.17.1
