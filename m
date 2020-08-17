Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 39120245FC8
	for <lists+netdev@lfdr.de>; Mon, 17 Aug 2020 10:25:41 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728124AbgHQIZO (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 17 Aug 2020 04:25:14 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:52500 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1728072AbgHQIZG (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 17 Aug 2020 04:25:06 -0400
Received: from mail-pj1-x1041.google.com (mail-pj1-x1041.google.com [IPv6:2607:f8b0:4864:20::1041])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 8A417C061388;
        Mon, 17 Aug 2020 01:25:06 -0700 (PDT)
Received: by mail-pj1-x1041.google.com with SMTP id e4so7465784pjd.0;
        Mon, 17 Aug 2020 01:25:06 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=from:to:cc:subject:date:message-id:in-reply-to:references;
        bh=iS/I7F7iLH4P7XaKsE2RuxyA++Ynk+63kexjhzrgu3g=;
        b=f//x7xuv0lBVzdaFReczKgvFf3Jv08BNDHs3X9r445HEBf6fBDmsh3ZbuOpCfcIuOR
         0VTxXVgw/TPEVcLo0iZ96JXY+ZC9FWCuCBtBqHOZ+DrMhD/UZSieOgFiKfUE7fcUL+1s
         Kp6nZjaR2KuT1DcEr/+JmtRKCZfYEz+u8X6o5390pIaKnD/w9tYrNmRZFmnFYKAcInFM
         MM7ts+zXVcia6hGMYhqGWGGXzUcJ/0y0KGROR+zgPH9jlEU7ATbmICNRvASqiNl2b9x3
         DYzKOqJBu+SZmg2K7Vav4/toPy72kNLIHsS/L2prHKFmUi8E5bqPRZ8WiRCWotM1jyhM
         Z65g==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references;
        bh=iS/I7F7iLH4P7XaKsE2RuxyA++Ynk+63kexjhzrgu3g=;
        b=uPaw1mwujhOVdaQaT/0lVp3jBl7xquBZhjpUlkdtS3oilr2WsQXLq8jFIZ7WVc/Lto
         u3P74DNoexXyApGJLmabpnjnZiG/F5g0IrY/9GiJl70vFdQKKJLjFPF2LaugGfWidXsd
         alHGoMHMOcnEVpSo2BRmH/unzB57NnVznL6Pcukd7x0kUnTZG16+ekspHcypMq/c0ehy
         OatuewTFiEMnrdj6kDGseGxmAiP2M9MsExZ+ZYi+sye+7gGP4WHC4Y0H40Nh/t6MSc+6
         N3g4Yg2JV12ZIFaqrfuH+kHhdA/yB97x5Snl0nJYP7n3cFn8xQhucSi+tXnsf1NPjRDZ
         Ps8Q==
X-Gm-Message-State: AOAM530sIVSJRjy5MXwZ9pKmWEtUvu0N4Ml5xqDPzsnPpv9rtGjKTFDF
        8gnMxh5FKG2Uxiq5bxzGW55NZDPlaJ2P/Q==
X-Google-Smtp-Source: ABdhPJwwhSw/ROxYTyacDvKXgkj0MEKilrfJDG0UEI8CrqFUmCZzhDtmibnMhMazL0vVNFnR/N6zvQ==
X-Received: by 2002:a17:90a:d901:: with SMTP id c1mr11690123pjv.175.1597652706152;
        Mon, 17 Aug 2020 01:25:06 -0700 (PDT)
Received: from localhost.localdomain ([49.207.202.98])
        by smtp.gmail.com with ESMTPSA id r186sm19928482pfr.162.2020.08.17.01.25.01
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 17 Aug 2020 01:25:05 -0700 (PDT)
From:   Allen Pais <allen.lkml@gmail.com>
To:     jes@trained-monkey.org, davem@davemloft.net, kuba@kernel.org,
        kda@linux-powerpc.org, dougmill@linux.ibm.com,
        cooldavid@cooldavid.org, mlindner@marvell.com, borisp@mellanox.com
Cc:     keescook@chromium.org, linux-acenic@sunsite.dk,
        netdev@vger.kernel.org, linux-kernel@vger.kernel.org,
        linux-arm-kernel@lists.infradead.org,
        linuxppc-dev@lists.ozlabs.org, linux-rdma@vger.kernel.org,
        oss-drivers@netronome.com, Allen Pais <allen.lkml@gmail.com>,
        Romain Perier <romain.perier@gmail.com>
Subject: [PATCH 02/20] ethernet: amd: convert tasklets to use new tasklet_setup() API
Date:   Mon, 17 Aug 2020 13:54:16 +0530
Message-Id: <20200817082434.21176-4-allen.lkml@gmail.com>
X-Mailer: git-send-email 2.17.1
In-Reply-To: <20200817082434.21176-1-allen.lkml@gmail.com>
References: <20200817082434.21176-1-allen.lkml@gmail.com>
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

In preparation for unconditionally passing the
struct tasklet_struct pointer to all tasklet
callbacks, switch to using the new tasklet_setup()
and from_tasklet() to pass the tasklet pointer explicitly.

Signed-off-by: Romain Perier <romain.perier@gmail.com>
Signed-off-by: Allen Pais <allen.lkml@gmail.com>
---
 drivers/net/ethernet/amd/xgbe/xgbe-drv.c  | 19 +++++++++----------
 drivers/net/ethernet/amd/xgbe/xgbe-i2c.c  | 11 +++++------
 drivers/net/ethernet/amd/xgbe/xgbe-mdio.c | 11 +++++------
 3 files changed, 19 insertions(+), 22 deletions(-)

diff --git a/drivers/net/ethernet/amd/xgbe/xgbe-drv.c b/drivers/net/ethernet/amd/xgbe/xgbe-drv.c
index 43294a148f8a..cc56086b7c51 100644
--- a/drivers/net/ethernet/amd/xgbe/xgbe-drv.c
+++ b/drivers/net/ethernet/amd/xgbe/xgbe-drv.c
@@ -403,9 +403,9 @@ static bool xgbe_ecc_ded(struct xgbe_prv_data *pdata, unsigned long *period,
 	return false;
 }
 
-static void xgbe_ecc_isr_task(unsigned long data)
+static void xgbe_ecc_isr_task(struct tasklet_struct *t)
 {
-	struct xgbe_prv_data *pdata = (struct xgbe_prv_data *)data;
+	struct xgbe_prv_data *pdata = from_tasklet(pdata, t, tasklet_ecc);
 	unsigned int ecc_isr;
 	bool stop = false;
 
@@ -468,14 +468,14 @@ static irqreturn_t xgbe_ecc_isr(int irq, void *data)
 	if (pdata->isr_as_tasklet)
 		tasklet_schedule(&pdata->tasklet_ecc);
 	else
-		xgbe_ecc_isr_task((unsigned long)pdata);
+		xgbe_ecc_isr_task(&pdata->tasklet_ecc);
 
 	return IRQ_HANDLED;
 }
 
-static void xgbe_isr_task(unsigned long data)
+static void xgbe_isr_task(struct tasklet_struct *t)
 {
-	struct xgbe_prv_data *pdata = (struct xgbe_prv_data *)data;
+	struct xgbe_prv_data *pdata = from_tasklet(pdata, t, tasklet_dev);
 	struct xgbe_hw_if *hw_if = &pdata->hw_if;
 	struct xgbe_channel *channel;
 	unsigned int dma_isr, dma_ch_isr;
@@ -582,7 +582,7 @@ static void xgbe_isr_task(unsigned long data)
 
 	/* If there is not a separate ECC irq, handle it here */
 	if (pdata->vdata->ecc_support && (pdata->dev_irq == pdata->ecc_irq))
-		xgbe_ecc_isr_task((unsigned long)pdata);
+		xgbe_ecc_isr_task(&pdata->tasklet_ecc);
 
 	/* If there is not a separate I2C irq, handle it here */
 	if (pdata->vdata->i2c_support && (pdata->dev_irq == pdata->i2c_irq))
@@ -607,7 +607,7 @@ static irqreturn_t xgbe_isr(int irq, void *data)
 	if (pdata->isr_as_tasklet)
 		tasklet_schedule(&pdata->tasklet_dev);
 	else
-		xgbe_isr_task((unsigned long)pdata);
+		xgbe_isr_task(&pdata->tasklet_dev);
 
 	return IRQ_HANDLED;
 }
@@ -991,9 +991,8 @@ static int xgbe_request_irqs(struct xgbe_prv_data *pdata)
 	unsigned int i;
 	int ret;
 
-	tasklet_init(&pdata->tasklet_dev, xgbe_isr_task, (unsigned long)pdata);
-	tasklet_init(&pdata->tasklet_ecc, xgbe_ecc_isr_task,
-		     (unsigned long)pdata);
+	tasklet_setup(&pdata->tasklet_dev, xgbe_isr_task);
+	tasklet_setup(&pdata->tasklet_ecc, xgbe_ecc_isr_task);
 
 	ret = devm_request_irq(pdata->dev, pdata->dev_irq, xgbe_isr, 0,
 			       netdev_name(netdev), pdata);
diff --git a/drivers/net/ethernet/amd/xgbe/xgbe-i2c.c b/drivers/net/ethernet/amd/xgbe/xgbe-i2c.c
index 4d9062d35930..22d4fc547a0a 100644
--- a/drivers/net/ethernet/amd/xgbe/xgbe-i2c.c
+++ b/drivers/net/ethernet/amd/xgbe/xgbe-i2c.c
@@ -274,9 +274,9 @@ static void xgbe_i2c_clear_isr_interrupts(struct xgbe_prv_data *pdata,
 		XI2C_IOREAD(pdata, IC_CLR_STOP_DET);
 }
 
-static void xgbe_i2c_isr_task(unsigned long data)
+static void xgbe_i2c_isr_task(struct tasklet_struct *t)
 {
-	struct xgbe_prv_data *pdata = (struct xgbe_prv_data *)data;
+	struct xgbe_prv_data *pdata = from_tasklet(pdata, t, tasklet_i2c);
 	struct xgbe_i2c_op_state *state = &pdata->i2c.op_state;
 	unsigned int isr;
 
@@ -324,7 +324,7 @@ static irqreturn_t xgbe_i2c_isr(int irq, void *data)
 	if (pdata->isr_as_tasklet)
 		tasklet_schedule(&pdata->tasklet_i2c);
 	else
-		xgbe_i2c_isr_task((unsigned long)pdata);
+		xgbe_i2c_isr_task(&pdata->tasklet_i2c);
 
 	return IRQ_HANDLED;
 }
@@ -369,7 +369,7 @@ static void xgbe_i2c_set_target(struct xgbe_prv_data *pdata, unsigned int addr)
 
 static irqreturn_t xgbe_i2c_combined_isr(struct xgbe_prv_data *pdata)
 {
-	xgbe_i2c_isr_task((unsigned long)pdata);
+	xgbe_i2c_isr_task(&pdata->tasklet_i2c);
 
 	return IRQ_HANDLED;
 }
@@ -462,8 +462,7 @@ static int xgbe_i2c_start(struct xgbe_prv_data *pdata)
 
 	/* If we have a separate I2C irq, enable it */
 	if (pdata->dev_irq != pdata->i2c_irq) {
-		tasklet_init(&pdata->tasklet_i2c, xgbe_i2c_isr_task,
-			     (unsigned long)pdata);
+		tasklet_setup(&pdata->tasklet_i2c, xgbe_i2c_isr_task);
 
 		ret = devm_request_irq(pdata->dev, pdata->i2c_irq,
 				       xgbe_i2c_isr, 0, pdata->i2c_name,
diff --git a/drivers/net/ethernet/amd/xgbe/xgbe-mdio.c b/drivers/net/ethernet/amd/xgbe/xgbe-mdio.c
index 8a3a60bb2688..93ef5a30cb8d 100644
--- a/drivers/net/ethernet/amd/xgbe/xgbe-mdio.c
+++ b/drivers/net/ethernet/amd/xgbe/xgbe-mdio.c
@@ -688,9 +688,9 @@ static void xgbe_an73_isr(struct xgbe_prv_data *pdata)
 	}
 }
 
-static void xgbe_an_isr_task(unsigned long data)
+static void xgbe_an_isr_task(struct tasklet_struct *t)
 {
-	struct xgbe_prv_data *pdata = (struct xgbe_prv_data *)data;
+	struct xgbe_prv_data *pdata = from_tasklet(pdata, t, tasklet_an);
 
 	netif_dbg(pdata, intr, pdata->netdev, "AN interrupt received\n");
 
@@ -715,14 +715,14 @@ static irqreturn_t xgbe_an_isr(int irq, void *data)
 	if (pdata->isr_as_tasklet)
 		tasklet_schedule(&pdata->tasklet_an);
 	else
-		xgbe_an_isr_task((unsigned long)pdata);
+		xgbe_an_isr_task(&pdata->tasklet_an);
 
 	return IRQ_HANDLED;
 }
 
 static irqreturn_t xgbe_an_combined_isr(struct xgbe_prv_data *pdata)
 {
-	xgbe_an_isr_task((unsigned long)pdata);
+	xgbe_an_isr_task(&pdata->tasklet_an);
 
 	return IRQ_HANDLED;
 }
@@ -1414,8 +1414,7 @@ static int xgbe_phy_start(struct xgbe_prv_data *pdata)
 
 	/* If we have a separate AN irq, enable it */
 	if (pdata->dev_irq != pdata->an_irq) {
-		tasklet_init(&pdata->tasklet_an, xgbe_an_isr_task,
-			     (unsigned long)pdata);
+		tasklet_setup(&pdata->tasklet_an, xgbe_an_isr_task);
 
 		ret = devm_request_irq(pdata->dev, pdata->an_irq,
 				       xgbe_an_isr, 0, pdata->an_name,
-- 
2.17.1

