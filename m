Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 71B252685DE
	for <lists+netdev@lfdr.de>; Mon, 14 Sep 2020 09:30:12 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726012AbgINHaG (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 14 Sep 2020 03:30:06 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:57526 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1725992AbgINHaB (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 14 Sep 2020 03:30:01 -0400
Received: from mail-pj1-x1041.google.com (mail-pj1-x1041.google.com [IPv6:2607:f8b0:4864:20::1041])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 0EDDFC06174A
        for <netdev@vger.kernel.org>; Mon, 14 Sep 2020 00:30:01 -0700 (PDT)
Received: by mail-pj1-x1041.google.com with SMTP id v14so3566805pjd.4
        for <netdev@vger.kernel.org>; Mon, 14 Sep 2020 00:30:01 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=from:to:cc:subject:date:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=ENDIM6dnvSAiFtaN1D3BYH8eMYv3Y8ssamdogUTlFwI=;
        b=UlWNs8HeAReRuUxmTmSQgFZV3smy3z0lgDpSze0qzC+0954LOBP18VlteG4/8DNwtT
         ZhIVJ4D5aiT7rOCrc3aMiqTR5m+z0NufFtUgKXYlbyxmYQSkQH+e4iP6d+By+ebe7qMD
         FPrj1Kz8aKbkGVHUZXaOezJT0gcvJVBIOXtEAPe/oTh8dAxvAItXL8sJaCS64mhqkbFd
         2Kj6aNmTMubgzHniC2dkq9s7wQXVkBujfjZZwvBXCiABHUN2j1nKzykt1kC/AhnMSkjg
         /o2EGEVY50OEtsf5et4LQJYQRIoy3zxBibdrxeTAsir0lnUbRyGeBqxunnqYBcH7iKS3
         OVhw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=ENDIM6dnvSAiFtaN1D3BYH8eMYv3Y8ssamdogUTlFwI=;
        b=udKpECw+mqtBiJOVIfASAHFUZiyatSEWa7pqeYnLXETYXtn+ut5HD3HTImWgmPy2gp
         7Vp/6yBJhHjoDELOR7dESsYk3KsCVOeUaNPdKuFipCBZmEr9BUi3WmjBLl4J2UDIq0gx
         8kUFwqS9KNdQIsID5KpjlSVCZAKKkm7pn05oFnrMDuWIkl4Elt766yQDCfyYKWE3LiEm
         TIZpvBPIiMnd7d2DQSd4AD8bTDWasMPDlEb6XLx/LpJUcLYGJePMhqIqHoo/iBGVNIp5
         dV+gfEPTaOgyKHs5t1R+jhBoHw6sW3XZnC+bjQaowHrVAwuxsjw2jTBq+k01nQ+RxYIR
         6YAQ==
X-Gm-Message-State: AOAM531sUGo7bMWnpOgYGCS6+Fl/z6BIUS+69/SBz3qlKdpIGBVsNpBy
        TahAskQc637WwSbjzN+5aSw=
X-Google-Smtp-Source: ABdhPJxuon8x+XNgQZJGew0diVAHTFmXcRG3ceOCegYsDCksytqapfuPJKP1fR3UdXyYkrSZ1y9NoQ==
X-Received: by 2002:a17:90a:d704:: with SMTP id y4mr13393876pju.159.1600068600629;
        Mon, 14 Sep 2020 00:30:00 -0700 (PDT)
Received: from localhost.localdomain ([49.207.192.250])
        by smtp.gmail.com with ESMTPSA id a16sm7609057pgh.48.2020.09.14.00.29.56
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 14 Sep 2020 00:30:00 -0700 (PDT)
From:   Allen Pais <allen.lkml@gmail.com>
To:     davem@davemloft.net
Cc:     jes@trained-monkey.org, kuba@kernel.org, dougmill@linux.ibm.com,
        cooldavid@cooldavid.org, mlindner@marvell.com,
        stephen@networkplumber.org, borisp@mellanox.com,
        netdev@vger.kernel.org, Allen Pais <apais@linux.microsoft.com>,
        Romain Perier <romain.perier@gmail.com>
Subject: [net-next v3 02/20] net: amd-xgbe: convert tasklets to use new tasklet_setup() API
Date:   Mon, 14 Sep 2020 12:59:21 +0530
Message-Id: <20200914072939.803280-3-allen.lkml@gmail.com>
X-Mailer: git-send-email 2.25.1
In-Reply-To: <20200914072939.803280-1-allen.lkml@gmail.com>
References: <20200914072939.803280-1-allen.lkml@gmail.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Allen Pais <apais@linux.microsoft.com>

In preparation for unconditionally passing the
struct tasklet_struct pointer to all tasklet
callbacks, switch to using the new tasklet_setup()
and from_tasklet() to pass the tasklet pointer explicitly.

Signed-off-by: Romain Perier <romain.perier@gmail.com>
Signed-off-by: Allen Pais <apais@linux.microsoft.com>
---
 drivers/net/ethernet/amd/xgbe/xgbe-drv.c  | 19 +++++++++----------
 drivers/net/ethernet/amd/xgbe/xgbe-i2c.c  | 11 +++++------
 drivers/net/ethernet/amd/xgbe/xgbe-mdio.c | 11 +++++------
 3 files changed, 19 insertions(+), 22 deletions(-)

diff --git a/drivers/net/ethernet/amd/xgbe/xgbe-drv.c b/drivers/net/ethernet/amd/xgbe/xgbe-drv.c
index 4ba75551cb17..2709a2db5657 100644
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
2.25.1

