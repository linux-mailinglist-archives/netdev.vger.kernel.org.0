Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 9F79347F0B0
	for <lists+netdev@lfdr.de>; Fri, 24 Dec 2021 20:28:00 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1344274AbhLXT0p (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 24 Dec 2021 14:26:45 -0500
Received: from relmlor1.renesas.com ([210.160.252.171]:13679 "EHLO
        relmlie5.idc.renesas.com" rhost-flags-OK-OK-OK-FAIL)
        by vger.kernel.org with ESMTP id S1344225AbhLXT0l (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 24 Dec 2021 14:26:41 -0500
X-IronPort-AV: E=Sophos;i="5.88,233,1635174000"; 
   d="scan'208";a="104635851"
Received: from unknown (HELO relmlir6.idc.renesas.com) ([10.200.68.152])
  by relmlie5.idc.renesas.com with ESMTP; 25 Dec 2021 04:26:40 +0900
Received: from localhost.localdomain (unknown [10.226.36.204])
        by relmlir6.idc.renesas.com (Postfix) with ESMTP id 32A8740F521F;
        Sat, 25 Dec 2021 04:26:39 +0900 (JST)
From:   Lad Prabhakar <prabhakar.mahadev-lad.rj@bp.renesas.com>
To:     netdev@vger.kernel.org, Madalin Bucur <madalin.bucur@nxp.com>,
        "David S. Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>
Cc:     Rob Herring <robh+dt@kernel.org>, linux-kernel@vger.kernel.org,
        Prabhakar <prabhakar.csengg@gmail.com>,
        Lad Prabhakar <prabhakar.mahadev-lad.rj@bp.renesas.com>
Subject: [PATCH 3/8] fsl/fman: Use platform_get_irq() to get the interrupt
Date:   Fri, 24 Dec 2021 19:26:21 +0000
Message-Id: <20211224192626.15843-4-prabhakar.mahadev-lad.rj@bp.renesas.com>
X-Mailer: git-send-email 2.17.1
In-Reply-To: <20211224192626.15843-1-prabhakar.mahadev-lad.rj@bp.renesas.com>
References: <20211224192626.15843-1-prabhakar.mahadev-lad.rj@bp.renesas.com>
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

platform_get_resource(pdev, IORESOURCE_IRQ, ..) relies on static
allocation of IRQ resources in DT core code, this causes an issue
when using hierarchical interrupt domains using "interrupts" property
in the node as this bypasses the hierarchical setup and messes up the
irq chaining.

In preparation for removal of static setup of IRQ resource from DT core
code use platform_get_irq(). While doing so return error pointer
from read_dts_node() as platform_get_irq() may return -EPROBE_DEFER.

Signed-off-by: Lad Prabhakar <prabhakar.mahadev-lad.rj@bp.renesas.com>
---
 drivers/net/ethernet/freescale/fman/fman.c | 32 +++++++++++-----------
 1 file changed, 16 insertions(+), 16 deletions(-)

diff --git a/drivers/net/ethernet/freescale/fman/fman.c b/drivers/net/ethernet/freescale/fman/fman.c
index ce0a121580f6..8f0db61cb1f6 100644
--- a/drivers/net/ethernet/freescale/fman/fman.c
+++ b/drivers/net/ethernet/freescale/fman/fman.c
@@ -2727,7 +2727,7 @@ static struct fman *read_dts_node(struct platform_device *of_dev)
 
 	fman = kzalloc(sizeof(*fman), GFP_KERNEL);
 	if (!fman)
-		return NULL;
+		return ERR_PTR(-ENOMEM);
 
 	fm_node = of_node_get(of_dev->dev.of_node);
 
@@ -2740,26 +2740,21 @@ static struct fman *read_dts_node(struct platform_device *of_dev)
 	fman->dts_params.id = (u8)val;
 
 	/* Get the FM interrupt */
-	res = platform_get_resource(of_dev, IORESOURCE_IRQ, 0);
-	if (!res) {
-		dev_err(&of_dev->dev, "%s: Can't get FMan IRQ resource\n",
-			__func__);
+	err = platform_get_irq(of_dev, 0);
+	if (err < 0)
 		goto fman_node_put;
-	}
-	irq = res->start;
+	irq = err;
 
 	/* Get the FM error interrupt */
-	res = platform_get_resource(of_dev, IORESOURCE_IRQ, 1);
-	if (!res) {
-		dev_err(&of_dev->dev, "%s: Can't get FMan Error IRQ resource\n",
-			__func__);
+	err = platform_get_irq(of_dev, 1);
+	if (err < 0)
 		goto fman_node_put;
-	}
-	fman->dts_params.err_irq = res->start;
+	fman->dts_params.err_irq = err;
 
 	/* Get the FM address */
 	res = platform_get_resource(of_dev, IORESOURCE_MEM, 0);
 	if (!res) {
+		err = -EINVAL;
 		dev_err(&of_dev->dev, "%s: Can't get FMan memory resource\n",
 			__func__);
 		goto fman_node_put;
@@ -2770,6 +2765,7 @@ static struct fman *read_dts_node(struct platform_device *of_dev)
 
 	clk = of_clk_get(fm_node, 0);
 	if (IS_ERR(clk)) {
+		err = PTR_ERR(clk);
 		dev_err(&of_dev->dev, "%s: Failed to get FM%d clock structure\n",
 			__func__, fman->dts_params.id);
 		goto fman_node_put;
@@ -2777,6 +2773,7 @@ static struct fman *read_dts_node(struct platform_device *of_dev)
 
 	clk_rate = clk_get_rate(clk);
 	if (!clk_rate) {
+		err = -EINVAL;
 		dev_err(&of_dev->dev, "%s: Failed to determine FM%d clock rate\n",
 			__func__, fman->dts_params.id);
 		goto fman_node_put;
@@ -2797,6 +2794,7 @@ static struct fman *read_dts_node(struct platform_device *of_dev)
 	/* Get the MURAM base address and size */
 	muram_node = of_find_matching_node(fm_node, fman_muram_match);
 	if (!muram_node) {
+		err = -EINVAL;
 		dev_err(&of_dev->dev, "%s: could not find MURAM node\n",
 			__func__);
 		goto fman_free;
@@ -2836,6 +2834,7 @@ static struct fman *read_dts_node(struct platform_device *of_dev)
 		devm_request_mem_region(&of_dev->dev, phys_base_addr,
 					mem_size, "fman");
 	if (!fman->dts_params.res) {
+		err = -EBUSY;
 		dev_err(&of_dev->dev, "%s: request_mem_region() failed\n",
 			__func__);
 		goto fman_free;
@@ -2844,6 +2843,7 @@ static struct fman *read_dts_node(struct platform_device *of_dev)
 	fman->dts_params.base_addr =
 		devm_ioremap(&of_dev->dev, phys_base_addr, mem_size);
 	if (!fman->dts_params.base_addr) {
+		err = -ENOMEM;
 		dev_err(&of_dev->dev, "%s: devm_ioremap() failed\n", __func__);
 		goto fman_free;
 	}
@@ -2868,7 +2868,7 @@ static struct fman *read_dts_node(struct platform_device *of_dev)
 	of_node_put(fm_node);
 fman_free:
 	kfree(fman);
-	return NULL;
+	return ERR_PTR(err);
 }
 
 static int fman_probe(struct platform_device *of_dev)
@@ -2880,8 +2880,8 @@ static int fman_probe(struct platform_device *of_dev)
 	dev = &of_dev->dev;
 
 	fman = read_dts_node(of_dev);
-	if (!fman)
-		return -EIO;
+	if (IS_ERR(fman))
+		return PTR_ERR(fman);
 
 	err = fman_config(fman);
 	if (err) {
-- 
2.17.1

