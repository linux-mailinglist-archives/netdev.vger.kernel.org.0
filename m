Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 848FDE0295
	for <lists+netdev@lfdr.de>; Tue, 22 Oct 2019 13:15:21 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2387571AbfJVLPH (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 22 Oct 2019 07:15:07 -0400
Received: from inva021.nxp.com ([92.121.34.21]:41920 "EHLO inva021.nxp.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S2387461AbfJVLPG (ORCPT <rfc822;netdev@vger.kernel.org>);
        Tue, 22 Oct 2019 07:15:06 -0400
Received: from inva021.nxp.com (localhost [127.0.0.1])
        by inva021.eu-rdc02.nxp.com (Postfix) with ESMTP id CD19F200631;
        Tue, 22 Oct 2019 13:15:04 +0200 (CEST)
Received: from inva024.eu-rdc02.nxp.com (inva024.eu-rdc02.nxp.com [134.27.226.22])
        by inva021.eu-rdc02.nxp.com (Postfix) with ESMTP id C03DE20064F;
        Tue, 22 Oct 2019 13:15:04 +0200 (CEST)
Received: from fsr-fed2164-101.ea.freescale.net (fsr-fed2164-101.ea.freescale.net [10.171.82.91])
        by inva024.eu-rdc02.nxp.com (Postfix) with ESMTP id 6AA972060F;
        Tue, 22 Oct 2019 13:15:04 +0200 (CEST)
From:   Madalin Bucur <madalin.bucur@nxp.com>
To:     davem@davemloft.net, netdev@vger.kernel.org
Cc:     roy.pledge@nxp.com, laurentiu.tudor@nxp.com,
        Madalin Bucur <madalin.bucur@nxp.com>
Subject: [PATCH net-next v2 1/6] fsl/fman: don't touch liodn base regs reserved on non-PAMU SoCs
Date:   Tue, 22 Oct 2019 14:14:56 +0300
Message-Id: <1571742901-22923-2-git-send-email-madalin.bucur@nxp.com>
X-Mailer: git-send-email 2.1.0
In-Reply-To: <1571742901-22923-1-git-send-email-madalin.bucur@nxp.com>
References: <1571742901-22923-1-git-send-email-madalin.bucur@nxp.com>
Content-Type: text/plain; charset="us-ascii"
Reply-to: madalin.bucur@nxp.com
X-Virus-Scanned: ClamAV using ClamSMTP
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Laurentiu Tudor <laurentiu.tudor@nxp.com>

The liodn base registers are specific to PAMU based NXP systems and are
reserved on SMMU based ones. Don't access them unless PAMU is compiled in.

Signed-off-by: Laurentiu Tudor <laurentiu.tudor@nxp.com>
Signed-off-by: Madalin Bucur <madalin.bucur@nxp.com>
---
 drivers/net/ethernet/freescale/fman/fman.c | 6 +++++-
 1 file changed, 5 insertions(+), 1 deletion(-)

diff --git a/drivers/net/ethernet/freescale/fman/fman.c b/drivers/net/ethernet/freescale/fman/fman.c
index 210749bf1eac..934111def0be 100644
--- a/drivers/net/ethernet/freescale/fman/fman.c
+++ b/drivers/net/ethernet/freescale/fman/fman.c
@@ -634,6 +634,9 @@ static void set_port_liodn(struct fman *fman, u8 port_id,
 {
 	u32 tmp;
 
+	iowrite32be(liodn_ofst, &fman->bmi_regs->fmbm_spliodn[port_id - 1]);
+	if (!IS_ENABLED(CONFIG_FSL_PAMU))
+		return;
 	/* set LIODN base for this port */
 	tmp = ioread32be(&fman->dma_regs->fmdmplr[port_id / 2]);
 	if (port_id % 2) {
@@ -644,7 +647,6 @@ static void set_port_liodn(struct fman *fman, u8 port_id,
 		tmp |= liodn_base << DMA_LIODN_SHIFT;
 	}
 	iowrite32be(tmp, &fman->dma_regs->fmdmplr[port_id / 2]);
-	iowrite32be(liodn_ofst, &fman->bmi_regs->fmbm_spliodn[port_id - 1]);
 }
 
 static void enable_rams_ecc(struct fman_fpm_regs __iomem *fpm_rg)
@@ -1942,6 +1944,8 @@ static int fman_init(struct fman *fman)
 
 		fman->liodn_offset[i] =
 			ioread32be(&fman->bmi_regs->fmbm_spliodn[i - 1]);
+		if (!IS_ENABLED(CONFIG_FSL_PAMU))
+			continue;
 		liodn_base = ioread32be(&fman->dma_regs->fmdmplr[i / 2]);
 		if (i % 2) {
 			/* FMDM_PLR LSB holds LIODN base for odd ports */
-- 
2.1.0

