Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 1F3431B5DA0
	for <lists+netdev@lfdr.de>; Thu, 23 Apr 2020 16:22:56 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728891AbgDWOVz (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 23 Apr 2020 10:21:55 -0400
Received: from lelv0142.ext.ti.com ([198.47.23.249]:60064 "EHLO
        lelv0142.ext.ti.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1728863AbgDWOVw (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 23 Apr 2020 10:21:52 -0400
Received: from lelv0266.itg.ti.com ([10.180.67.225])
        by lelv0142.ext.ti.com (8.15.2/8.15.2) with ESMTP id 03NELltw078064;
        Thu, 23 Apr 2020 09:21:47 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=ti.com;
        s=ti-com-17Q1; t=1587651707;
        bh=EobPuUYa4yhwwo8CjMb08fT7mp5vL7a+KqjjG21JZv8=;
        h=From:To:CC:Subject:Date:In-Reply-To:References;
        b=JOGgmEHOUU65VWksgEeDw0VPqAimf1dgmQa3FgVwJo8ktTq/BorDdu1VacQR7FY3/
         ky281GbCUBPw66mtJCB3CVlEvF253wqpYK7+L6Lx88Ns8Z2gJcfoLMX+vDcYCXxaXS
         2U/EAObkURe65ImKKtuXY4om2PrhQY3l0BuUOLfU=
Received: from DFLE103.ent.ti.com (dfle103.ent.ti.com [10.64.6.24])
        by lelv0266.itg.ti.com (8.15.2/8.15.2) with ESMTPS id 03NELl5l123461
        (version=TLSv1.2 cipher=AES256-GCM-SHA384 bits=256 verify=FAIL);
        Thu, 23 Apr 2020 09:21:47 -0500
Received: from DFLE100.ent.ti.com (10.64.6.21) by DFLE103.ent.ti.com
 (10.64.6.24) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_128_CBC_SHA256_P256) id 15.1.1979.3; Thu, 23
 Apr 2020 09:21:47 -0500
Received: from lelv0326.itg.ti.com (10.180.67.84) by DFLE100.ent.ti.com
 (10.64.6.21) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_128_CBC_SHA256_P256) id 15.1.1979.3 via
 Frontend Transport; Thu, 23 Apr 2020 09:21:47 -0500
Received: from localhost (ileax41-snat.itg.ti.com [10.172.224.153])
        by lelv0326.itg.ti.com (8.15.2/8.15.2) with ESMTP id 03NELkr4097307;
        Thu, 23 Apr 2020 09:21:46 -0500
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
Subject: [PATCH net-next v5 10/10] net: ethernet: ti: cpsw: enable cpts irq
Date:   Thu, 23 Apr 2020 17:20:22 +0300
Message-ID: <20200423142022.10538-11-grygorii.strashko@ti.com>
X-Mailer: git-send-email 2.17.1
In-Reply-To: <20200423142022.10538-1-grygorii.strashko@ti.com>
References: <20200423142022.10538-1-grygorii.strashko@ti.com>
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

