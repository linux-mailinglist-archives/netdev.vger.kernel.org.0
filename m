Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 3B2FF104277
	for <lists+netdev@lfdr.de>; Wed, 20 Nov 2019 18:49:26 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728271AbfKTRtY (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 20 Nov 2019 12:49:24 -0500
Received: from mail-pl1-f194.google.com ([209.85.214.194]:32996 "EHLO
        mail-pl1-f194.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1727728AbfKTRtY (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 20 Nov 2019 12:49:24 -0500
Received: by mail-pl1-f194.google.com with SMTP id ay6so125117plb.0
        for <netdev@vger.kernel.org>; Wed, 20 Nov 2019 09:49:23 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=from:to:cc:subject:date:message-id:in-reply-to:references;
        bh=igRrLcsvvHINBHN3Du1QgjU8MaMaa8IpVYpX2ovsRN4=;
        b=Uc2Yh9M9lfu/j0MQOLRgHbBpDaQhlJHrHm/IJQI0DazZboQylDFARKToiohPzYYT+Y
         8oWevMKiKFDBi3estBOSD+T+AhoAprieia3PFaSYvTygQZ0z2vsp6oNXG1SH7Tr3PWek
         fy9bE01s+gbJm+uz7BYBC/qZVenfDS8BScnYFKMIWNQ53DMfMzg52ZCoxBcJTN8QYb87
         gKBCRzfhCN2yG/qWLGCT/GbZsvpRfDGWpB0EWrd32Dv5QkfIQzKW9W+f51nOel5O/rpp
         aYzUQr0C8mWAAKm2T/XRHzhXr3SHWG76Xn1c1LW/QPx/6n1v4NoyBPsQg6B5OJIvjkeD
         cL+w==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references;
        bh=igRrLcsvvHINBHN3Du1QgjU8MaMaa8IpVYpX2ovsRN4=;
        b=VcaEBe7JZMLqqlkLbjK2ayG1377adUFBN5TRzYVlvSnesCVkz8TMgo9z7MPnSGGB4a
         yCp94L0KfJdhIlUfi5rS5AmAVjWzlJIT9TIWDKOXH4Avicd7UiWDug52ukHE8d2g9V4Q
         VhM6Em4OUMTqVacb3ylcj6UGADI0zBAQuwLnGfuiuNKuJ5sMXW9QGf0EGxQjRLoNMp10
         V4sHk0+d3otdREM7XKwQ9IOX9U5jYbG0iLaK5afROtz2r6R8RtMDi5giZaYbekTMj8xi
         047f7TA+zT3Lo3GgvSsWDKJUM7a5PDdd4AuDZmW/Taw9rhEad9mhFEQVGIvfeiNnyCjY
         7h6Q==
X-Gm-Message-State: APjAAAWKM8SX3MIDLapJ71ut76IA0yKd+9zIwXB45xQZIjMFJPNQoIYk
        Wj7W206VmGhJ2yqB1mxrQRGfM2Fr
X-Google-Smtp-Source: APXvYqzvLUeY5Eb7qPHOCwFTLsPWvIPIqfVtk05yNvGg/obLSZ9ZctgCibIT4tZn3hclsccuLdT6pA==
X-Received: by 2002:a17:902:6e02:: with SMTP id u2mr4229276plk.234.1574272163001;
        Wed, 20 Nov 2019 09:49:23 -0800 (PST)
Received: from machine421.caveonetworks.com ([115.113.156.2])
        by smtp.googlemail.com with ESMTPSA id y24sm32230522pfr.116.2019.11.20.09.49.20
        (version=TLS1_2 cipher=ECDHE-RSA-AES128-SHA bits=128/128);
        Wed, 20 Nov 2019 09:49:22 -0800 (PST)
From:   sunil.kovvuri@gmail.com
To:     netdev@vger.kernel.org
Cc:     davem@davemloft.net, jakub.kicinski@netronome.com,
        Jerin Jacob <jerinj@marvell.com>,
        Pavan Nikhilesh <pbhagavatula@marvell.com>,
        Sunil Goutham <sgoutham@marvell.com>
Subject: [PATCH v3 07/16] octeontx2-af: add debug msgs for NIX block errors
Date:   Wed, 20 Nov 2019 23:17:57 +0530
Message-Id: <1574272086-21055-8-git-send-email-sunil.kovvuri@gmail.com>
X-Mailer: git-send-email 2.7.4
In-Reply-To: <1574272086-21055-1-git-send-email-sunil.kovvuri@gmail.com>
References: <1574272086-21055-1-git-send-email-sunil.kovvuri@gmail.com>
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Jerin Jacob <jerinj@marvell.com>

Added debug messages for NIX_AF_RVU_INT, NIX_AF_ERR_INT and NIX_AF_RAS
error AF interrupts.

These will help in detecting issues wrt AQ instruction faults,
LF misconfiguration, NPC MCAM entry trying to forward pkt to PF_FUNC
with no NIXLF mapped etc.

Signed-off-by: Jerin Jacob <jerinj@marvell.com>
Signed-off-by: Pavan Nikhilesh <pbhagavatula@marvell.com>
Signed-off-by: Sunil Goutham <sgoutham@marvell.com>
---
 drivers/net/ethernet/marvell/octeontx2/af/rvu.c    |   5 +
 drivers/net/ethernet/marvell/octeontx2/af/rvu.h    |   2 +
 .../net/ethernet/marvell/octeontx2/af/rvu_nix.c    | 202 +++++++++++++++++++++
 .../net/ethernet/marvell/octeontx2/af/rvu_struct.h |  10 +
 4 files changed, 219 insertions(+)

diff --git a/drivers/net/ethernet/marvell/octeontx2/af/rvu.c b/drivers/net/ethernet/marvell/octeontx2/af/rvu.c
index 68bccd6..e39aa02 100644
--- a/drivers/net/ethernet/marvell/octeontx2/af/rvu.c
+++ b/drivers/net/ethernet/marvell/octeontx2/af/rvu.c
@@ -2127,6 +2127,7 @@ static void rvu_unregister_interrupts(struct rvu *rvu)
 	int irq;
 
 	rvu_npa_unregister_interrupts(rvu);
+	rvu_nix_unregister_interrupts(rvu);
 
 	/* Disable the Mbox interrupt */
 	rvu_write64(rvu, BLKADDR_RVUM, RVU_AF_PFAF_MBOX_INT_ENA_W1C,
@@ -2340,6 +2341,10 @@ static int rvu_register_interrupts(struct rvu *rvu)
 	if (ret)
 		goto fail;
 
+	ret = rvu_nix_register_interrupts(rvu);
+	if (ret)
+		goto fail;
+
 	return 0;
 fail:
 	rvu_unregister_interrupts(rvu);
diff --git a/drivers/net/ethernet/marvell/octeontx2/af/rvu.h b/drivers/net/ethernet/marvell/octeontx2/af/rvu.h
index c6d1bb8..5936d8e 100644
--- a/drivers/net/ethernet/marvell/octeontx2/af/rvu.h
+++ b/drivers/net/ethernet/marvell/octeontx2/af/rvu.h
@@ -465,6 +465,8 @@ void rvu_nix_freemem(struct rvu *rvu);
 int rvu_get_nixlf_count(struct rvu *rvu);
 void rvu_nix_lf_teardown(struct rvu *rvu, u16 pcifunc, int blkaddr, int npalf);
 int nix_get_nixlf(struct rvu *rvu, u16 pcifunc, int *nixlf);
+int rvu_nix_register_interrupts(struct rvu *rvu);
+void rvu_nix_unregister_interrupts(struct rvu *rvu);
 
 /* NPC APIs */
 int rvu_npc_init(struct rvu *rvu);
diff --git a/drivers/net/ethernet/marvell/octeontx2/af/rvu_nix.c b/drivers/net/ethernet/marvell/octeontx2/af/rvu_nix.c
index 10b49e5..f1201e0 100644
--- a/drivers/net/ethernet/marvell/octeontx2/af/rvu_nix.c
+++ b/drivers/net/ethernet/marvell/octeontx2/af/rvu_nix.c
@@ -3407,3 +3407,205 @@ int rvu_mbox_handler_nix_lso_format_cfg(struct rvu *rvu,
 
 	return 0;
 }
+
+static irqreturn_t rvu_nix_af_rvu_intr_handler(int irq, void *rvu_irq)
+{
+	struct rvu *rvu = (struct rvu *)rvu_irq;
+	int blkaddr;
+	u64 intr;
+
+	blkaddr = rvu_get_blkaddr(rvu, BLKTYPE_NIX, 0);
+	if (blkaddr < 0)
+		return IRQ_NONE;
+
+	intr = rvu_read64(rvu, blkaddr, NIX_AF_RVU_INT);
+
+	if (intr & BIT_ULL(0))
+		dev_err(rvu->dev, "NIX: Unmapped slot error\n");
+
+	/* Clear interrupts */
+	rvu_write64(rvu, blkaddr, NIX_AF_RVU_INT, intr);
+	return IRQ_HANDLED;
+}
+
+static irqreturn_t rvu_nix_af_err_intr_handler(int irq, void *rvu_irq)
+{
+	struct rvu *rvu = (struct rvu *)rvu_irq;
+	int blkaddr;
+	u64 intr;
+
+	blkaddr = rvu_get_blkaddr(rvu, BLKTYPE_NIX, 0);
+	if (blkaddr < 0)
+		return IRQ_NONE;
+
+	intr = rvu_read64(rvu, blkaddr, NIX_AF_ERR_INT);
+
+	if (intr & BIT_ULL(14))
+		dev_err(rvu->dev, "NIX: Memory fault on NIX_AQ_INST_S read\n");
+
+	if (intr & BIT_ULL(13))
+		dev_err(rvu->dev, "NIX: Memory fault on NIX_AQ_RES_S write\n");
+
+	if (intr & BIT_ULL(12))
+		dev_err(rvu->dev, "NIX: AQ doorbell error\n");
+
+	if (intr & BIT_ULL(6))
+		dev_err(rvu->dev, "NIX: Rx on unmapped PF_FUNC\n");
+
+	if (intr & BIT_ULL(5))
+		dev_err(rvu->dev, "NIX: Rx multicast replication error\n");
+
+	if (intr & BIT_ULL(4))
+		dev_err(rvu->dev, "NIX: Memory fault on NIX_RX_MCE_S read\n");
+
+	if (intr & BIT_ULL(3))
+		dev_err(rvu->dev, "NIX: Memory fault on multicast WQE read\n");
+
+	if (intr & BIT_ULL(2))
+		dev_err(rvu->dev, "NIX: Memory fault on mirror WQE read\n");
+
+	if (intr & BIT_ULL(1))
+		dev_err(rvu->dev, "NIX: Memory fault on mirror pkt write\n");
+
+	if (intr & BIT_ULL(0))
+		dev_err(rvu->dev, "NIX: Memory fault on multicast pkt write\n");
+
+	/* Clear interrupts */
+	rvu_write64(rvu, blkaddr, NIX_AF_ERR_INT, intr);
+	return IRQ_HANDLED;
+}
+
+static irqreturn_t rvu_nix_af_ras_intr_handler(int irq, void *rvu_irq)
+{
+	struct rvu *rvu = (struct rvu *)rvu_irq;
+	int blkaddr;
+	u64 intr;
+
+	blkaddr = rvu_get_blkaddr(rvu, BLKTYPE_NIX, 0);
+	if (blkaddr < 0)
+		return IRQ_NONE;
+
+	intr = rvu_read64(rvu, blkaddr, NIX_AF_RAS);
+
+	if (intr & BIT_ULL(34))
+		dev_err(rvu->dev, "NIX: Poisoned data on NIX_AQ_INST_S read\n");
+
+	if (intr & BIT_ULL(33))
+		dev_err(rvu->dev, "NIX: Poisoned data on NIX_AQ_RES_S write\n");
+
+	if (intr & BIT_ULL(32))
+		dev_err(rvu->dev, "NIX: Poisoned data on HW context read\n");
+
+	if (intr & BIT_ULL(4))
+		dev_err(rvu->dev, "NIX: Poisoned data on packet read from mirror buffer\n");
+
+	if (intr & BIT_ULL(3))
+		dev_err(rvu->dev, "NIX: Poisoned data on packet read from multicast buffer\n");
+
+	if (intr & BIT_ULL(2))
+		dev_err(rvu->dev, "NIX: Poisoned data on WQE read from mirror buffer\n");
+
+	if (intr & BIT_ULL(1))
+		dev_err(rvu->dev, "NIX: Poisoned data on WQE read from multicast buffer\n");
+
+	if (intr & BIT_ULL(0))
+		dev_err(rvu->dev, "NIX: Poisoned data on NIX_RX_MCE_S read\n");
+
+	/* Clear interrupts */
+	rvu_write64(rvu, blkaddr, NIX_AF_RAS, intr);
+	return IRQ_HANDLED;
+}
+
+static bool rvu_nix_af_request_irq(struct rvu *rvu, int blkaddr, int offset,
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
+int rvu_nix_register_interrupts(struct rvu *rvu)
+{
+	int blkaddr, base;
+	bool rc;
+
+	blkaddr = rvu_get_blkaddr(rvu, BLKTYPE_NIX, 0);
+	if (blkaddr < 0)
+		return blkaddr;
+
+	/* Get NIX AF MSIX vectors offset. */
+	base = rvu_read64(rvu, blkaddr, NIX_PRIV_AF_INT_CFG) & 0x3ff;
+	if (!base) {
+		dev_warn(rvu->dev,
+			 "Failed to get NIX_AF_INT vector offsets\n");
+		return 0;
+	}
+
+	/* Register and enable NIX_AF_RVU_INT interrupt */
+	rc = rvu_nix_af_request_irq(rvu, blkaddr, base +  NIX_AF_INT_VEC_RVU,
+				    "NIX_AF_RVU_INT",
+				    rvu_nix_af_rvu_intr_handler);
+	if (!rc)
+		goto err;
+	rvu_write64(rvu, blkaddr, NIX_AF_RVU_INT_ENA_W1S, ~0ULL);
+
+	/* Register and enable NIX_AF_ERR_INT interrupt */
+	rc = rvu_nix_af_request_irq(rvu, blkaddr, base + NIX_AF_INT_VEC_AF_ERR,
+				    "NIX_AF_ERR_INT",
+				    rvu_nix_af_err_intr_handler);
+	if (!rc)
+		goto err;
+	rvu_write64(rvu, blkaddr, NIX_AF_ERR_INT_ENA_W1S, ~0ULL);
+
+	/* Register and enable NIX_AF_RAS interrupt */
+	rc = rvu_nix_af_request_irq(rvu, blkaddr, base + NIX_AF_INT_VEC_POISON,
+				    "NIX_AF_RAS",
+				    rvu_nix_af_ras_intr_handler);
+	if (!rc)
+		goto err;
+	rvu_write64(rvu, blkaddr, NIX_AF_RAS_ENA_W1S, ~0ULL);
+
+	return 0;
+err:
+	rvu_nix_unregister_interrupts(rvu);
+	return rc;
+}
+
+void rvu_nix_unregister_interrupts(struct rvu *rvu)
+{
+	int blkaddr, offs, i;
+
+	blkaddr = rvu_get_blkaddr(rvu, BLKTYPE_NIX, 0);
+	if (blkaddr < 0)
+		return;
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
+			 rvu);
+		rvu->irq_allocated[offs + NIX_AF_INT_VEC_RVU] = false;
+	}
+
+	for (i = NIX_AF_INT_VEC_AF_ERR; i < NIX_AF_INT_VEC_CNT; i++)
+		if (rvu->irq_allocated[offs + i]) {
+			free_irq(pci_irq_vector(rvu->pdev, offs + i), rvu);
+			rvu->irq_allocated[offs + i] = false;
+		}
+}
diff --git a/drivers/net/ethernet/marvell/octeontx2/af/rvu_struct.h b/drivers/net/ethernet/marvell/octeontx2/af/rvu_struct.h
index bf5f03a..a665fa2 100644
--- a/drivers/net/ethernet/marvell/octeontx2/af/rvu_struct.h
+++ b/drivers/net/ethernet/marvell/octeontx2/af/rvu_struct.h
@@ -70,6 +70,16 @@ enum npa_af_int_vec_e {
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
2.7.4

