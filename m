Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 6557A2CD836
	for <lists+netdev@lfdr.de>; Thu,  3 Dec 2020 14:55:09 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2387663AbgLCNvk (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 3 Dec 2020 08:51:40 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:34184 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1727555AbgLCNvk (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 3 Dec 2020 08:51:40 -0500
Received: from mail-ed1-x541.google.com (mail-ed1-x541.google.com [IPv6:2a00:1450:4864:20::541])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 4DD2DC061A53
        for <netdev@vger.kernel.org>; Thu,  3 Dec 2020 05:50:54 -0800 (PST)
Received: by mail-ed1-x541.google.com with SMTP id d18so2136407edt.7
        for <netdev@vger.kernel.org>; Thu, 03 Dec 2020 05:50:54 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=essensium.com; s=google;
        h=from:to:cc:subject:date:message-id:in-reply-to:references;
        bh=Hu9KgoIfbByheWddhHSVotGIyHUSFkyJms4K0ds5aD0=;
        b=Oi/n0knrwImSI4CEBam8QT0IbtCLWeBEXgD68WJD64bfEHTfoDlB8EpgWv0XH6nEsK
         nkjOZTH8z65mXjMBxj4+B1ZLT39XcmQSqukqiJO5LpFkA42FAmn6ONe12WmoIYtmE7OI
         cbbND+9GCGcsc1gROCFrVQDtR0uvr4FKJHjmQJpQW7r1y3EdE82JuM0aEGqS7L8/sT0V
         pI+pLVfESdFmIO3EfayPzGX+CLQFAJZ6j2ilqTY+ZVoVWtjPnugrPG9y9VoEzCCpoyrS
         rBnOdvCq++y3Ic1sroxeIb1VvwkITEIM4vPsKFVREboCNxurFjgkiC2ahHY9BCk59vYh
         zYIQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references;
        bh=Hu9KgoIfbByheWddhHSVotGIyHUSFkyJms4K0ds5aD0=;
        b=maKPXsty9pexwtXTtwp58KamL3925Zz4XR8EbAmNQ+EEhK4rcqZApYUC/s/PDNZ1+f
         MIwymQNtRXo/m+ScBHzkQ/kxMhmN9Mm2/2f0w7UvaoOcFBLaXTcY3VTJogew+bSrBtss
         ThsuzkFoeiDVtj58cl2BM0vuvsmjRxUImSTQi2RVZFMBL3XSs+JnS3HAPoWqaQDBBxdy
         rPYddhjofusNjCB13sJgZL/63zXRC2ndR/N9bqLI6tuf96nF5srfu++A5xQQxK9SKuQK
         tOsDDrhZ1oEPMd04uriCE4NUs7X35egnhiCx1mzDF1/fk5F/2c2T/hfrpAySFY20Aa+K
         TZqg==
X-Gm-Message-State: AOAM533fNnGo4xOQC4OwQvT8yRNwuvbFmgpIoaqG19pccVOh8AcafxW+
        EPYUh217mofydfrImjfpY883QA==
X-Google-Smtp-Source: ABdhPJwBmWi7KNWvH8FypVlA0zQ0mVIrxylTLr76VUWW3/nnN6q4QcfqhToxcbVBPavllXn7a1Rd2Q==
X-Received: by 2002:a50:8a8b:: with SMTP id j11mr3015431edj.19.1607003452929;
        Thu, 03 Dec 2020 05:50:52 -0800 (PST)
Received: from belels006.local.ess-mail.com (ip-188-118-3-185.reverse.destiny.be. [188.118.3.185])
        by smtp.gmail.com with ESMTPSA id t19sm903192eje.86.2020.12.03.05.50.52
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 03 Dec 2020 05:50:52 -0800 (PST)
From:   Patrick Havelange <patrick.havelange@essensium.com>
To:     Madalin Bucur <madalin.bucur@nxp.com>,
        "David S. Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>, netdev@vger.kernel.org,
        linux-kernel@vger.kernel.org
Cc:     Patrick Havelange <patrick.havelange@essensium.com>
Subject: [PATCH net 1/4] net: freescale/fman: Split the main resource region reservation
Date:   Thu,  3 Dec 2020 14:50:36 +0100
Message-Id: <20201203135039.31474-2-patrick.havelange@essensium.com>
X-Mailer: git-send-email 2.17.1
In-Reply-To: <20201203135039.31474-1-patrick.havelange@essensium.com>
References: <20201203135039.31474-1-patrick.havelange@essensium.com>
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

The main fman driver is only using some parts of the fman memory
region.
Split the reservation of the main region in 2, so that the other
regions that will be used by fman-port and fman-mac drivers can
be reserved properly and not be in conflict with the main fman
reservation.

Signed-off-by: Patrick Havelange <patrick.havelange@essensium.com>
---
 drivers/net/ethernet/freescale/fman/fman.c | 103 +++++++++++++--------
 drivers/net/ethernet/freescale/fman/fman.h |   9 +-
 2 files changed, 69 insertions(+), 43 deletions(-)

diff --git a/drivers/net/ethernet/freescale/fman/fman.c b/drivers/net/ethernet/freescale/fman/fman.c
index ce0a121580f6..2e85209d560d 100644
--- a/drivers/net/ethernet/freescale/fman/fman.c
+++ b/drivers/net/ethernet/freescale/fman/fman.c
@@ -58,12 +58,15 @@
 /* Modules registers offsets */
 #define BMI_OFFSET		0x00080000
 #define QMI_OFFSET		0x00080400
-#define KG_OFFSET		0x000C1000
-#define DMA_OFFSET		0x000C2000
-#define FPM_OFFSET		0x000C3000
-#define IMEM_OFFSET		0x000C4000
-#define HWP_OFFSET		0x000C7000
-#define CGP_OFFSET		0x000DB000
+#define SIZE_REGION_0		0x00081000
+#define POL_OFFSET		0x000C0000
+#define KG_OFFSET_FROM_POL	0x00001000
+#define DMA_OFFSET_FROM_POL	0x00002000
+#define FPM_OFFSET_FROM_POL	0x00003000
+#define IMEM_OFFSET_FROM_POL	0x00004000
+#define HWP_OFFSET_FROM_POL	0x00007000
+#define CGP_OFFSET_FROM_POL	0x0001B000
+#define SIZE_REGION_FROM_POL	0x00020000
 
 /* Exceptions bit map */
 #define EX_DMA_BUS_ERROR		0x80000000
@@ -1433,7 +1436,7 @@ static int clear_iram(struct fman *fman)
 	struct fman_iram_regs __iomem *iram;
 	int i, count;
 
-	iram = fman->base_addr + IMEM_OFFSET;
+	iram = fman->base_addr_pol + IMEM_OFFSET_FROM_POL;
 
 	/* Enable the auto-increment */
 	iowrite32be(IRAM_IADD_AIE, &iram->iadd);
@@ -1710,11 +1713,8 @@ static int set_num_of_open_dmas(struct fman *fman, u8 port_id,
 
 static int fman_config(struct fman *fman)
 {
-	void __iomem *base_addr;
 	int err;
 
-	base_addr = fman->dts_params.base_addr;
-
 	fman->state = kzalloc(sizeof(*fman->state), GFP_KERNEL);
 	if (!fman->state)
 		goto err_fm_state;
@@ -1740,13 +1740,14 @@ static int fman_config(struct fman *fman)
 	fman->state->res = fman->dts_params.res;
 	fman->exception_cb = fman_exceptions;
 	fman->bus_error_cb = fman_bus_error;
-	fman->fpm_regs = base_addr + FPM_OFFSET;
-	fman->bmi_regs = base_addr + BMI_OFFSET;
-	fman->qmi_regs = base_addr + QMI_OFFSET;
-	fman->dma_regs = base_addr + DMA_OFFSET;
-	fman->hwp_regs = base_addr + HWP_OFFSET;
-	fman->kg_regs = base_addr + KG_OFFSET;
-	fman->base_addr = base_addr;
+	fman->fpm_regs = fman->dts_params.base_addr_pol + FPM_OFFSET_FROM_POL;
+	fman->bmi_regs = fman->dts_params.base_addr_0 + BMI_OFFSET;
+	fman->qmi_regs = fman->dts_params.base_addr_0 + QMI_OFFSET;
+	fman->dma_regs = fman->dts_params.base_addr_pol + DMA_OFFSET_FROM_POL;
+	fman->hwp_regs = fman->dts_params.base_addr_pol + HWP_OFFSET_FROM_POL;
+	fman->kg_regs = fman->dts_params.base_addr_pol + KG_OFFSET_FROM_POL;
+	fman->base_addr_0 = fman->dts_params.base_addr_0;
+	fman->base_addr_pol = fman->dts_params.base_addr_pol;
 
 	spin_lock_init(&fman->spinlock);
 	fman_defconfig(fman->cfg);
@@ -1937,8 +1938,8 @@ static int fman_init(struct fman *fman)
 		fman->state->exceptions &= ~FMAN_EX_QMI_SINGLE_ECC;
 
 	/* clear CPG */
-	memset_io((void __iomem *)(fman->base_addr + CGP_OFFSET), 0,
-		  fman->state->fm_port_num_of_cg);
+	memset_io((void __iomem *)(fman->base_addr_pol + CGP_OFFSET_FROM_POL),
+		  0, fman->state->fm_port_num_of_cg);
 
 	/* Save LIODN info before FMan reset
 	 * Skipping non-existent port 0 (i = 1)
@@ -2717,13 +2718,11 @@ static struct fman *read_dts_node(struct platform_device *of_dev)
 {
 	struct fman *fman;
 	struct device_node *fm_node, *muram_node;
-	struct resource *res;
+	struct resource *tmp_res, *main_res;
 	u32 val, range[2];
 	int err, irq;
 	struct clk *clk;
 	u32 clk_rate;
-	phys_addr_t phys_base_addr;
-	resource_size_t mem_size;
 
 	fman = kzalloc(sizeof(*fman), GFP_KERNEL);
 	if (!fman)
@@ -2740,34 +2739,31 @@ static struct fman *read_dts_node(struct platform_device *of_dev)
 	fman->dts_params.id = (u8)val;
 
 	/* Get the FM interrupt */
-	res = platform_get_resource(of_dev, IORESOURCE_IRQ, 0);
-	if (!res) {
+	tmp_res = platform_get_resource(of_dev, IORESOURCE_IRQ, 0);
+	if (!tmp_res) {
 		dev_err(&of_dev->dev, "%s: Can't get FMan IRQ resource\n",
 			__func__);
 		goto fman_node_put;
 	}
-	irq = res->start;
+	irq = tmp_res->start;
 
 	/* Get the FM error interrupt */
-	res = platform_get_resource(of_dev, IORESOURCE_IRQ, 1);
-	if (!res) {
+	tmp_res = platform_get_resource(of_dev, IORESOURCE_IRQ, 1);
+	if (!tmp_res) {
 		dev_err(&of_dev->dev, "%s: Can't get FMan Error IRQ resource\n",
 			__func__);
 		goto fman_node_put;
 	}
-	fman->dts_params.err_irq = res->start;
+	fman->dts_params.err_irq = tmp_res->start;
 
 	/* Get the FM address */
-	res = platform_get_resource(of_dev, IORESOURCE_MEM, 0);
-	if (!res) {
+	main_res = platform_get_resource(of_dev, IORESOURCE_MEM, 0);
+	if (!main_res) {
 		dev_err(&of_dev->dev, "%s: Can't get FMan memory resource\n",
 			__func__);
 		goto fman_node_put;
 	}
 
-	phys_base_addr = res->start;
-	mem_size = resource_size(res);
-
 	clk = of_clk_get(fm_node, 0);
 	if (IS_ERR(clk)) {
 		dev_err(&of_dev->dev, "%s: Failed to get FM%d clock structure\n",
@@ -2832,22 +2828,47 @@ static struct fman *read_dts_node(struct platform_device *of_dev)
 		}
 	}
 
-	fman->dts_params.res =
-		devm_request_mem_region(&of_dev->dev, phys_base_addr,
-					mem_size, "fman");
-	if (!fman->dts_params.res) {
-		dev_err(&of_dev->dev, "%s: request_mem_region() failed\n",
+	err = devm_request_resource(&of_dev->dev, &iomem_resource, main_res);
+	if (err) {
+		dev_err(&of_dev->dev, "%s: devm_request_resource() failed\n",
+			__func__);
+		goto fman_free;
+	}
+
+	fman->dts_params.res = main_res;
+
+	tmp_res = devm_request_mem_region(&of_dev->dev, main_res->start,
+					  SIZE_REGION_0, "fman");
+	if (!tmp_res) {
+		dev_err(&of_dev->dev, "%s: devm_request_mem_region() failed\n",
 			__func__);
 		goto fman_free;
 	}
 
-	fman->dts_params.base_addr =
-		devm_ioremap(&of_dev->dev, phys_base_addr, mem_size);
-	if (!fman->dts_params.base_addr) {
+	fman->dts_params.base_addr_0 =
+		devm_ioremap(&of_dev->dev, tmp_res->start,
+			     resource_size(tmp_res));
+	if (!fman->dts_params.base_addr_0) {
 		dev_err(&of_dev->dev, "%s: devm_ioremap() failed\n", __func__);
 		goto fman_free;
 	}
 
+	tmp_res = devm_request_mem_region(&of_dev->dev,
+					  main_res->start + POL_OFFSET,
+					  SIZE_REGION_FROM_POL, "fman");
+	if (!tmp_res) {
+		dev_err(&of_dev->dev, "%s: devm_request_mem_region() failed\n",
+			__func__);
+		goto fman_free;
+	}
+
+	fman->dts_params.base_addr_pol =
+		devm_ioremap(&of_dev->dev, tmp_res->start,
+			     resource_size(tmp_res));
+	if (!fman->dts_params.base_addr_pol) {
+		dev_err(&of_dev->dev, "%s: devm_ioremap() failed\n", __func__);
+		goto fman_free;
+	}
 	fman->dev = &of_dev->dev;
 
 	err = of_platform_populate(fm_node, NULL, NULL, &of_dev->dev);
diff --git a/drivers/net/ethernet/freescale/fman/fman.h b/drivers/net/ethernet/freescale/fman/fman.h
index f2ede1360f03..e6b339c57230 100644
--- a/drivers/net/ethernet/freescale/fman/fman.h
+++ b/drivers/net/ethernet/freescale/fman/fman.h
@@ -306,7 +306,11 @@ typedef irqreturn_t (fman_bus_error_cb)(struct fman *fman, u8 port_id,
 
 /* Structure that holds information received from device tree */
 struct fman_dts_params {
-	void __iomem *base_addr;                /* FMan virtual address */
+	void __iomem *base_addr_0;              /* FMan virtual address */
+	void __iomem *base_addr_pol;            /* FMan virtual address
+						 * second region starting at
+						 * policer offset
+						 */
 	struct resource *res;                   /* FMan memory resource */
 	u8 id;                                  /* FMan ID */
 
@@ -322,7 +326,8 @@ struct fman_dts_params {
 
 struct fman {
 	struct device *dev;
-	void __iomem *base_addr;
+	void __iomem *base_addr_0;
+	void __iomem *base_addr_pol;
 	struct fman_intr_src intr_mng[FMAN_EV_CNT];
 
 	struct fman_fpm_regs __iomem *fpm_regs;
-- 
2.17.1

