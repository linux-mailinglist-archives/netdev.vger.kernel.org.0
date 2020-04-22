Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 1FD881B4E34
	for <lists+netdev@lfdr.de>; Wed, 22 Apr 2020 22:15:26 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727019AbgDVUOM (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 22 Apr 2020 16:14:12 -0400
Received: from lelv0143.ext.ti.com ([198.47.23.248]:45442 "EHLO
        lelv0143.ext.ti.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726109AbgDVUOK (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 22 Apr 2020 16:14:10 -0400
Received: from fllv0035.itg.ti.com ([10.64.41.0])
        by lelv0143.ext.ti.com (8.15.2/8.15.2) with ESMTP id 03MKE5EA066948;
        Wed, 22 Apr 2020 15:14:05 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=ti.com;
        s=ti-com-17Q1; t=1587586445;
        bh=EobPuUYa4yhwwo8CjMb08fT7mp5vL7a+KqjjG21JZv8=;
        h=From:To:CC:Subject:Date:In-Reply-To:References;
        b=IRp3NZ5+soBtdUCaSUkKdBesLmH2lRAZJskPU4fVuVfwwWyg/6DTslcsLXHLE5rGd
         i9PqidSta1KWUav/kGg7mfIav7pTUrd6xxlewU1gO+OMzNjIhqEBu2iFuqIxOAzyvB
         +4zLNKtVHi4cTdXsXLDohDMCMcfISgQo7NWAWHVg=
Received: from DFLE112.ent.ti.com (dfle112.ent.ti.com [10.64.6.33])
        by fllv0035.itg.ti.com (8.15.2/8.15.2) with ESMTP id 03MKE53M086527;
        Wed, 22 Apr 2020 15:14:05 -0500
Received: from DFLE107.ent.ti.com (10.64.6.28) by DFLE112.ent.ti.com
 (10.64.6.33) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_128_CBC_SHA256_P256) id 15.1.1979.3; Wed, 22
 Apr 2020 15:14:05 -0500
Received: from fllv0039.itg.ti.com (10.64.41.19) by DFLE107.ent.ti.com
 (10.64.6.28) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_128_CBC_SHA256_P256) id 15.1.1847.3 via
 Frontend Transport; Wed, 22 Apr 2020 15:14:05 -0500
Received: from localhost (ileax41-snat.itg.ti.com [10.172.224.153])
        by fllv0039.itg.ti.com (8.15.2/8.15.2) with ESMTP id 03MKE4jj062851;
        Wed, 22 Apr 2020 15:14:05 -0500
From:   Grygorii Strashko <grygorii.strashko@ti.com>
To:     Richard Cochran <richardcochran@gmail.com>,
        Lokesh Vutla <lokeshvutla@ti.com>,
        Tony Lindgren <tony@atomide.com>,
        "David S. Miller" <davem@davemloft.net>
CC:     <netdev@vger.kernel.org>, Sekhar Nori <nsekhar@ti.com>,
        <linux-kernel@vger.kernel.org>,
        Murali Karicheri <m-karicheri2@ti.com>,
        <linux-omap@vger.kernel.org>,
        Grygorii Strashko <grygorii.strashko@ti.com>
Subject: [PATCH net-next v4 10/10] net: ethernet: ti: cpsw: enable cpts irq
Date:   Wed, 22 Apr 2020 23:12:54 +0300
Message-ID: <20200422201254.15232-11-grygorii.strashko@ti.com>
X-Mailer: git-send-email 2.17.1
In-Reply-To: <20200422201254.15232-1-grygorii.strashko@ti.com>
References: <20200422201254.15232-1-grygorii.strashko@ti.com>
MIME-Version: 1.0
Content-Type: text/plain
X-EXCLAIMER-MD-CONFIG: e1e8a2fd-e40a-4ac6-ac9b-f7e9cc9ee180
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

The CPSW misc IRQ need be enabled for CPTS event_pend IRQs processing. This
patch adds corresponding support to CPSW driver.

Signed-off-by: Grygorii Strashko <grygorii.strashko@ti.com>
Acked-by: Richard Cochran <richardcochran@gmail.com>
---
 drivers/net/ethernet/ti/cpsw.c      | 21 +++++++++++++++++++++
 drivers/net/ethernet/ti/cpsw_new.c  | 20 ++++++++++++++++++++
 drivers/net/ethernet/ti/cpsw_priv.c | 12 ++++++++++++
 drivers/net/ethernet/ti/cpsw_priv.h |  2 ++
 4 files changed, 55 insertions(+)

diff --git a/drivers/net/ethernet/ti/cpsw.c b/drivers/net/ethernet/ti/cpsw.c
index c2c5bf87da01..09f98fa2fb4e 100644
--- a/drivers/net/ethernet/ti/cpsw.c
+++ b/drivers/net/ethernet/ti/cpsw.c
@@ -1569,6 +1569,12 @@ static int cpsw_probe(struct platform_device *pdev)
 		return irq;
 	cpsw->irqs_table[1] = irq;
 
+	/* get misc irq*/
+	irq = platform_get_irq(pdev, 3);
+	if (irq <= 0)
+		return irq;
+	cpsw->misc_irq = irq;
+
 	/*
 	 * This may be required here for child devices.
 	 */
@@ -1703,6 +1709,21 @@ static int cpsw_probe(struct platform_device *pdev)
 		goto clean_unregister_netdev_ret;
 	}
 
+	if (!cpsw->cpts)
+		goto skip_cpts;
+
+	ret = devm_request_irq(&pdev->dev, cpsw->misc_irq, cpsw_misc_interrupt,
+			       0, dev_name(&pdev->dev), cpsw);
+	if (ret < 0) {
+		dev_err(dev, "error attaching misc irq (%d)\n", ret);
+		goto clean_unregister_netdev_ret;
+	}
+
+	/* Enable misc CPTS evnt_pend IRQ */
+	cpts_set_irqpoll(cpsw->cpts, false);
+	writel(0x10, &cpsw->wr_regs->misc_en);
+
+skip_cpts:
 	cpsw_notice(priv, probe,
 		    "initialized device (regs %pa, irq %d, pool size %d)\n",
 		    &ss_res->start, cpsw->irqs_table[0], descs_pool_size);
diff --git a/drivers/net/ethernet/ti/cpsw_new.c b/drivers/net/ethernet/ti/cpsw_new.c
index 9209e613257d..33c8dd686206 100644
--- a/drivers/net/ethernet/ti/cpsw_new.c
+++ b/drivers/net/ethernet/ti/cpsw_new.c
@@ -1896,6 +1896,11 @@ static int cpsw_probe(struct platform_device *pdev)
 		return irq;
 	cpsw->irqs_table[1] = irq;
 
+	irq = platform_get_irq_byname(pdev, "misc");
+	if (irq <= 0)
+		return irq;
+	cpsw->misc_irq = irq;
+
 	platform_set_drvdata(pdev, cpsw);
 	/* This may be required here for child devices. */
 	pm_runtime_enable(dev);
@@ -1975,6 +1980,21 @@ static int cpsw_probe(struct platform_device *pdev)
 		goto clean_unregister_netdev;
 	}
 
+	if (!cpsw->cpts)
+		goto skip_cpts;
+
+	ret = devm_request_irq(dev, cpsw->misc_irq, cpsw_misc_interrupt,
+			       0, dev_name(&pdev->dev), cpsw);
+	if (ret < 0) {
+		dev_err(dev, "error attaching misc irq (%d)\n", ret);
+		goto clean_unregister_netdev;
+	}
+
+	/* Enable misc CPTS evnt_pend IRQ */
+	cpts_set_irqpoll(cpsw->cpts, false);
+	writel(0x10, &cpsw->wr_regs->misc_en);
+
+skip_cpts:
 	ret = cpsw_register_notifiers(cpsw);
 	if (ret)
 		goto clean_unregister_netdev;
diff --git a/drivers/net/ethernet/ti/cpsw_priv.c b/drivers/net/ethernet/ti/cpsw_priv.c
index 099208927400..9d098c802c6d 100644
--- a/drivers/net/ethernet/ti/cpsw_priv.c
+++ b/drivers/net/ethernet/ti/cpsw_priv.c
@@ -114,6 +114,18 @@ irqreturn_t cpsw_rx_interrupt(int irq, void *dev_id)
 	return IRQ_HANDLED;
 }
 
+irqreturn_t cpsw_misc_interrupt(int irq, void *dev_id)
+{
+	struct cpsw_common *cpsw = dev_id;
+
+	writel(0, &cpsw->wr_regs->misc_en);
+	cpdma_ctlr_eoi(cpsw->dma, CPDMA_EOI_MISC);
+	cpts_misc_interrupt(cpsw->cpts);
+	writel(0x10, &cpsw->wr_regs->misc_en);
+
+	return IRQ_HANDLED;
+}
+
 int cpsw_tx_mq_poll(struct napi_struct *napi_tx, int budget)
 {
 	struct cpsw_common	*cpsw = napi_to_cpsw(napi_tx);
diff --git a/drivers/net/ethernet/ti/cpsw_priv.h b/drivers/net/ethernet/ti/cpsw_priv.h
index b8d7b924ee3d..bf4e179b4ca4 100644
--- a/drivers/net/ethernet/ti/cpsw_priv.h
+++ b/drivers/net/ethernet/ti/cpsw_priv.h
@@ -350,6 +350,7 @@ struct cpsw_common {
 	bool				rx_irq_disabled;
 	bool				tx_irq_disabled;
 	u32 irqs_table[IRQ_NUM];
+	int misc_irq;
 	struct cpts			*cpts;
 	struct devlink *devlink;
 	int				rx_ch_num, tx_ch_num;
@@ -442,6 +443,7 @@ int cpsw_run_xdp(struct cpsw_priv *priv, int ch, struct xdp_buff *xdp,
 		 struct page *page, int port);
 irqreturn_t cpsw_tx_interrupt(int irq, void *dev_id);
 irqreturn_t cpsw_rx_interrupt(int irq, void *dev_id);
+irqreturn_t cpsw_misc_interrupt(int irq, void *dev_id);
 int cpsw_tx_mq_poll(struct napi_struct *napi_tx, int budget);
 int cpsw_tx_poll(struct napi_struct *napi_tx, int budget);
 int cpsw_rx_mq_poll(struct napi_struct *napi_rx, int budget);
-- 
2.17.1

