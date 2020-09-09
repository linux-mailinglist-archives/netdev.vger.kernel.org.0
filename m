Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id AF5A4262ABE
	for <lists+netdev@lfdr.de>; Wed,  9 Sep 2020 10:45:39 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727900AbgIIIpi (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 9 Sep 2020 04:45:38 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:41130 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1728709AbgIIIpa (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 9 Sep 2020 04:45:30 -0400
Received: from mail-pj1-x1043.google.com (mail-pj1-x1043.google.com [IPv6:2607:f8b0:4864:20::1043])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id B6982C061573
        for <netdev@vger.kernel.org>; Wed,  9 Sep 2020 01:45:29 -0700 (PDT)
Received: by mail-pj1-x1043.google.com with SMTP id kk9so1007334pjb.2
        for <netdev@vger.kernel.org>; Wed, 09 Sep 2020 01:45:29 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=from:to:cc:subject:date:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=x7Vwja9AnAU5nx8ZBRln4BzqYHOkEQZbgXp9zYv0IAE=;
        b=XE0FgPFVcWB17N8+JvUjOfRnr1qnv91VxxRA1va0NuTgJbMr4bkiyWUrAMZhnqw4g+
         /QAoR5KaUaYzkvJ8qPwLhZsg405TgbzMTLH9O/2mtRMH0wnI/ZD621WzosW6rlmZHeM/
         j42lcZENvnHtqQTRp5Ds4yqPfEsk1/5tLYpma3gmNAYop1RPGQ0Q1J+irO54kAH88hys
         h5MgdpLneLy7196fwZnhDTs1/OF81NOq3Ni4t7nBmuZMqvm4QJWadzyaL0UxBiEMm4e/
         PdkvmH0dxvEd26igRglEEfpW4nPVXxjDOeox4trIA+7TQEHzrfMnuesgpBXcMuG1oAkK
         agyw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=x7Vwja9AnAU5nx8ZBRln4BzqYHOkEQZbgXp9zYv0IAE=;
        b=Plh2ZQ/oBnXhZGdxM2dC5ICDLhJ3nxTzMhdqZtsHF9SonAwoUfVjwtW6yzzVdG5LT/
         /dhrvwV3NE1y5KgUt1xNurScvoUIfOQzAFanoXngdKlQ9NwCY2VC0LVAhMroW1NJzNkt
         ts01O0jIq3iO7bjQtPDMKtWPhtQQk4L2uacC0ss+Dh6e0ahoMid1SZ8YS5F8gh6XXuck
         BYsZctV329QInWZFOykXwpiPrkG+ubM6LTuaALxbi6juQlTLmgVAspBRTwv6ovJaPToW
         uCrCd7ZfYivuCIwvzlvk2lkX6KGK/OdkfFzK8D95oBAK1R7K6ol5cq0Lw9ChuPg1q2Kb
         jqXw==
X-Gm-Message-State: AOAM532Ke+Sw4dskj4WP53BJxRNT4PGXveHfLWM+Z9LNAJOFOCY1ShIb
        C23wsNISe4Ng8v1FPHKArBg=
X-Google-Smtp-Source: ABdhPJx0hMnGl/0gxIxglqKDenYGKxlKyadxNDyRA5abSIOT2JOVO4eCTdPXnvYCQ+8+4pS+pLQ5ow==
X-Received: by 2002:a17:90b:3708:: with SMTP id mg8mr2637808pjb.39.1599641129260;
        Wed, 09 Sep 2020 01:45:29 -0700 (PDT)
Received: from localhost.localdomain ([49.207.214.52])
        by smtp.gmail.com with ESMTPSA id u21sm1468355pjn.27.2020.09.09.01.45.25
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 09 Sep 2020 01:45:28 -0700 (PDT)
From:   Allen Pais <allen.lkml@gmail.com>
To:     davem@davemloft.net
Cc:     jes@trained-monkey.org, kuba@kernel.org, dougmill@linux.ibm.com,
        cooldavid@cooldavid.org, mlindner@marvell.com,
        stephen@networkplumber.org, borisp@mellanox.com,
        netdev@vger.kernel.org, Allen Pais <allen.lkml@gmail.com>,
        Romain Perier <romain.perier@gmail.com>
Subject: [PATCH v2 02/20] ethernet: amd: convert tasklets to use new tasklet_setup() API
Date:   Wed,  9 Sep 2020 14:14:52 +0530
Message-Id: <20200909084510.648706-3-allen.lkml@gmail.com>
X-Mailer: git-send-email 2.25.1
In-Reply-To: <20200909084510.648706-1-allen.lkml@gmail.com>
References: <20200909084510.648706-1-allen.lkml@gmail.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
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

