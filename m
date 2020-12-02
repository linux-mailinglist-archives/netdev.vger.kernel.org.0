Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 4020C2CC1EE
	for <lists+netdev@lfdr.de>; Wed,  2 Dec 2020 17:18:25 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2389040AbgLBQQ7 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 2 Dec 2020 11:16:59 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:59220 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S2389028AbgLBQQ6 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 2 Dec 2020 11:16:58 -0500
Received: from mail-wr1-x442.google.com (mail-wr1-x442.google.com [IPv6:2a00:1450:4864:20::442])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id D3637C0613D4
        for <netdev@vger.kernel.org>; Wed,  2 Dec 2020 08:16:17 -0800 (PST)
Received: by mail-wr1-x442.google.com with SMTP id s8so4591818wrw.10
        for <netdev@vger.kernel.org>; Wed, 02 Dec 2020 08:16:17 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=essensium.com; s=google;
        h=from:to:cc:subject:date:message-id;
        bh=Hu9KgoIfbByheWddhHSVotGIyHUSFkyJms4K0ds5aD0=;
        b=duHzaQafKzr5OTS8xQc4UKF+O16r6//Zkv/JpJsy0o7VxwEEUT8+IWj4TO10nqgswF
         Ih+P38JSJtHoTW0zzQOL/9cc1Cacsd7o+DpWNh97yoJ6D4OJrmVyY+kUy1Y6cVchMinw
         HcjwTwAIrjWU24ATr2uePZ1ZyApOexopLIHGU8u2GGUdbxM3H1LfEkIbQT/EnAIMZGYI
         4vUndHy7anJ0b/ZbhRxVs2858+BmhrLaMoZlKZt2zI0NPDiVw/doq0VTLXR1Ic2ODuR1
         1LBJp+VQN+7tzrkeKHCpPG3ex+swrUCU17OY4P+FeP49NwPnX3QDEtXTXiKqcqzNXXVh
         TE0A==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id;
        bh=Hu9KgoIfbByheWddhHSVotGIyHUSFkyJms4K0ds5aD0=;
        b=U9L33QfchzlmTS7ImhR7vVJdFxeA4Axjdp3eirialbWAfIrnRpPCyQtcIUb/ZxaBYX
         x2elX7IwszXBQl5ZmOSpJwAZLR5QAB1m/Mt7dq455mlf2JEq0aT4bdcawIv8kXGdWuDZ
         uSSpjJAbzWF4LSQVx+4G+RyXHlCG6BGYle42P7WHquGv4QGOfGt6TeLLSP4BBXaFdPv5
         UHNXHasLr1Tve8tQFvz4UJURapWpk2xfJf1iWA/vRLrdKnIAPboPeMMSJzatXI6za236
         dTIw0JffbG9344t3Qrdshcs0uF2k3L+CLUFT7A6wabu+sMkRerWucIrrrDYn5ms4uYSo
         FExw==
X-Gm-Message-State: AOAM532ik2AqavZAvJvv4txAPhZY915zvMV5kbw/WmP7tTAh680h/DFW
        HNQ2QqlcG9jRVDnAXRoEAN/U3A==
X-Google-Smtp-Source: ABdhPJxzSnB7af/+kMCcoZgVsY0bVgy+9L0dUEwD440EDyJGJnNdc8d/Ao73PBYXXUa/4hPZ486dVg==
X-Received: by 2002:a5d:620a:: with SMTP id y10mr4403497wru.236.1606925776527;
        Wed, 02 Dec 2020 08:16:16 -0800 (PST)
Received: from belels006.local.ess-mail.com (ip-188-118-3-185.reverse.destiny.be. [188.118.3.185])
        by smtp.gmail.com with ESMTPSA id s4sm2644505wru.56.2020.12.02.08.16.15
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 02 Dec 2020 08:16:15 -0800 (PST)
From:   Patrick Havelange <patrick.havelange@essensium.com>
To:     Madalin Bucur <madalin.bucur@nxp.com>,
        "David S. Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>, netdev@vger.kernel.org,
        linux-kernel@vger.kernel.org
Cc:     Patrick Havelange <patrick.havelange@essensium.com>
Subject: [PATCH 1/4] net: freescale/fman: Split the main resource region reservation
Date:   Wed,  2 Dec 2020 17:15:57 +0100
Message-Id: <20201202161600.23738-1-patrick.havelange@essensium.com>
X-Mailer: git-send-email 2.17.1
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

