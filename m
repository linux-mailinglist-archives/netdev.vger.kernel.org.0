Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 9F2482FD81
	for <lists+netdev@lfdr.de>; Thu, 30 May 2019 16:20:31 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726933AbfE3OT4 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 30 May 2019 10:19:56 -0400
Received: from inva020.nxp.com ([92.121.34.13]:48968 "EHLO inva020.nxp.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726065AbfE3OT4 (ORCPT <rfc822;netdev@vger.kernel.org>);
        Thu, 30 May 2019 10:19:56 -0400
Received: from inva020.nxp.com (localhost [127.0.0.1])
        by inva020.eu-rdc02.nxp.com (Postfix) with ESMTP id 28A251A0650;
        Thu, 30 May 2019 16:19:54 +0200 (CEST)
Received: from inva024.eu-rdc02.nxp.com (inva024.eu-rdc02.nxp.com [134.27.226.22])
        by inva020.eu-rdc02.nxp.com (Postfix) with ESMTP id 1C93E1A016B;
        Thu, 30 May 2019 16:19:54 +0200 (CEST)
Received: from fsr-ub1864-101.ea.freescale.net (fsr-ub1864-101.ea.freescale.net [10.171.82.13])
        by inva024.eu-rdc02.nxp.com (Postfix) with ESMTP id 883732061C;
        Thu, 30 May 2019 16:19:53 +0200 (CEST)
From:   laurentiu.tudor@nxp.com
To:     netdev@vger.kernel.org, madalin.bucur@nxp.com, roy.pledge@nxp.com,
        camelia.groza@nxp.com, leoyang.li@nxp.com
Cc:     Joakim.Tjernlund@infinera.com, davem@davemloft.net,
        iommu@lists.linux-foundation.org,
        linux-arm-kernel@lists.infradead.org,
        linuxppc-dev@lists.ozlabs.org, linux-kernel@vger.kernel.org,
        Laurentiu Tudor <laurentiu.tudor@nxp.com>
Subject: [PATCH v3 1/6] fsl/fman: don't touch liodn base regs reserved on non-PAMU SoCs
Date:   Thu, 30 May 2019 17:19:46 +0300
Message-Id: <20190530141951.6704-2-laurentiu.tudor@nxp.com>
X-Mailer: git-send-email 2.17.1
In-Reply-To: <20190530141951.6704-1-laurentiu.tudor@nxp.com>
References: <20190530141951.6704-1-laurentiu.tudor@nxp.com>
X-Virus-Scanned: ClamAV using ClamSMTP
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Laurentiu Tudor <laurentiu.tudor@nxp.com>

liodn base registers are specific to PAMU based NXP systems and on SMMU
based ones are reserved. Don't access them if PAMU is compiled in.

Signed-off-by: Laurentiu Tudor <laurentiu.tudor@nxp.com>
---
 drivers/net/ethernet/freescale/fman/fman.c | 6 +++++-
 1 file changed, 5 insertions(+), 1 deletion(-)

diff --git a/drivers/net/ethernet/freescale/fman/fman.c b/drivers/net/ethernet/freescale/fman/fman.c
index e80fedb27cee..cce6636b1763 100644
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
2.17.1

