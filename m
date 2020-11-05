Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id C0D872A85D0
	for <lists+netdev@lfdr.de>; Thu,  5 Nov 2020 19:14:24 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1731899AbgKESOS (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 5 Nov 2020 13:14:18 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:51782 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1731854AbgKESOR (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 5 Nov 2020 13:14:17 -0500
Received: from mail-io1-xd44.google.com (mail-io1-xd44.google.com [IPv6:2607:f8b0:4864:20::d44])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 6E3FAC0613D2
        for <netdev@vger.kernel.org>; Thu,  5 Nov 2020 10:14:15 -0800 (PST)
Received: by mail-io1-xd44.google.com with SMTP id j12so2774356iow.0
        for <netdev@vger.kernel.org>; Thu, 05 Nov 2020 10:14:15 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linaro.org; s=google;
        h=from:to:cc:subject:date:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=fUu7sKWdSjki+dpRGFaR0nfQ/Rc1Qs15VbQEFUw/DtI=;
        b=GsKgEgwylLEgA7T7KoT60uMQ03+eYRFgOHYfV8VxcUR8eYq+b8dtBvhPfI2GmiuHQq
         Xcj6Ls/ndhkZ3aI7CM+T8rrnJtI5SLazz7qc3KrAUBbm+2mbjZtctRSFCs0161bPoj6Z
         qB2BXH+kcLE8zb5KwlmyTfzA7uZ3Kk/rPHHTbQB9DBsbBELGRlmNa1eCfjjosf610qY/
         iHnyOp3RdHCJF3xnz0qWq0TfwdDqO7aNlMjvo6NQj6gF3bkn3EnuDJNAdofZ+lxVNzTQ
         5fWA910cNQ1QJeXtasSXviux5jQUX7Cjt7WFoprVC8lhMI2tvTVfqC/m2r4jHwoEp3Dv
         fq0w==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=fUu7sKWdSjki+dpRGFaR0nfQ/Rc1Qs15VbQEFUw/DtI=;
        b=r+GZsm6zmYXppb8FQyoKT4Z/ggCwAlMvm00I61T+QGA95LW8XJbtIRNIT/H9fgvKdo
         HuuI+IcclyMBThIbQgmHGQuBxccGv4D/gRRezGPiNLyM27BlIjRKuS/PNywW1QOMwWJb
         EZe/lCkawl01f2RSX0Sd/Ua9qXDnwL+J9aqpVUwUYn7ThLvo/G7KJv14z5NEkmx8zlVn
         CbHgxphpeejCpCJhekrUVcOSHxw8wo6CBvIHws+lTvAEFyTZbbEG1BoiZX8F1ymMHhKV
         TYO4KO8qXG3VVkjpKchntUFi5BKPSHIgLbXsIXzbYYc/CWwvYtNE5kvvrU8RnrirsK7x
         8Vgg==
X-Gm-Message-State: AOAM5313i8aDpeAFFAJrcqIo0MI7OtvMcSOUdzsP4YN8ammgtvHAFXfJ
        WaWo4LJpRg7YlLBtdC4V9CCZsg==
X-Google-Smtp-Source: ABdhPJxCzLFCOGscJoLlqoMzX/y0GjHW2uMvUjIpXDacr+UGlL1vwLkFF4e7sKCq4HTq6lkcaVPAxQ==
X-Received: by 2002:a6b:911:: with SMTP id t17mr2615746ioi.197.1604600054772;
        Thu, 05 Nov 2020 10:14:14 -0800 (PST)
Received: from beast.localdomain (c-73-185-129-58.hsd1.mn.comcast.net. [73.185.129.58])
        by smtp.gmail.com with ESMTPSA id o19sm1554136ilt.24.2020.11.05.10.14.13
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 05 Nov 2020 10:14:14 -0800 (PST)
From:   Alex Elder <elder@linaro.org>
To:     davem@davemloft.net, kuba@kernel.org
Cc:     evgreen@chromium.org, subashab@codeaurora.org,
        cpratapa@codeaurora.org, bjorn.andersson@linaro.org,
        netdev@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: [PATCH net-next 02/13] net: ipa: request GSI IRQ later
Date:   Thu,  5 Nov 2020 12:13:56 -0600
Message-Id: <20201105181407.8006-3-elder@linaro.org>
X-Mailer: git-send-email 2.20.1
In-Reply-To: <20201105181407.8006-1-elder@linaro.org>
References: <20201105181407.8006-1-elder@linaro.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Introduce gsi_irq_init() and gsi_irq_exit(), to encapsulate looking
up the GSI IRQ and registering its handler.  Call gsi_irq_init() a
little later in gsi_init(), and initialize the completion earlier.
The IRQ handler accesses both the GSI virtual memory pointer and the
completion, and this way these things will have been initialized
before the gsi_irq() can ever be called.

Signed-off-by: Alex Elder <elder@linaro.org>
---
 drivers/net/ipa/gsi.c | 67 ++++++++++++++++++++++++++-----------------
 1 file changed, 41 insertions(+), 26 deletions(-)

diff --git a/drivers/net/ipa/gsi.c b/drivers/net/ipa/gsi.c
index 12a2001ee1e9c..299791f9b94d0 100644
--- a/drivers/net/ipa/gsi.c
+++ b/drivers/net/ipa/gsi.c
@@ -1170,6 +1170,34 @@ static irqreturn_t gsi_isr(int irq, void *dev_id)
 	return IRQ_HANDLED;
 }
 
+static int gsi_irq_init(struct gsi *gsi, struct platform_device *pdev)
+{
+	struct device *dev = &pdev->dev;
+	unsigned int irq;
+	int ret;
+
+	ret = platform_get_irq_byname(pdev, "gsi");
+	if (ret <= 0) {
+		dev_err(dev, "DT error %d getting \"gsi\" IRQ property\n", ret);
+		return ret ? : -EINVAL;
+	}
+	irq = ret;
+
+	ret = request_irq(irq, gsi_isr, 0, "gsi", gsi);
+	if (ret) {
+		dev_err(dev, "error %d requesting \"gsi\" IRQ\n", ret);
+		return ret;
+	}
+	gsi->irq = irq;
+
+	return 0;
+}
+
+static void gsi_irq_exit(struct gsi *gsi)
+{
+	free_irq(gsi->irq, gsi);
+}
+
 /* Return the transaction associated with a transfer completion event */
 static struct gsi_trans *gsi_event_trans(struct gsi_channel *channel,
 					 struct gsi_event *event)
@@ -1962,7 +1990,6 @@ int gsi_init(struct gsi *gsi, struct platform_device *pdev,
 	struct device *dev = &pdev->dev;
 	struct resource *res;
 	resource_size_t size;
-	unsigned int irq;
 	int ret;
 
 	gsi_validate_build();
@@ -1976,55 +2003,43 @@ int gsi_init(struct gsi *gsi, struct platform_device *pdev,
 	 */
 	init_dummy_netdev(&gsi->dummy_dev);
 
-	ret = platform_get_irq_byname(pdev, "gsi");
-	if (ret <= 0) {
-		dev_err(dev, "DT error %d getting \"gsi\" IRQ property\n", ret);
-		return ret ? : -EINVAL;
-	}
-	irq = ret;
-
-	ret = request_irq(irq, gsi_isr, 0, "gsi", gsi);
-	if (ret) {
-		dev_err(dev, "error %d requesting \"gsi\" IRQ\n", ret);
-		return ret;
-	}
-	gsi->irq = irq;
-
 	/* Get GSI memory range and map it */
 	res = platform_get_resource_byname(pdev, IORESOURCE_MEM, "gsi");
 	if (!res) {
 		dev_err(dev, "DT error getting \"gsi\" memory property\n");
-		ret = -ENODEV;
-		goto err_free_irq;
+		return -ENODEV;
 	}
 
 	size = resource_size(res);
 	if (res->start > U32_MAX || size > U32_MAX - res->start) {
 		dev_err(dev, "DT memory resource \"gsi\" out of range\n");
-		ret = -EINVAL;
-		goto err_free_irq;
+		return -EINVAL;
 	}
 
 	gsi->virt = ioremap(res->start, size);
 	if (!gsi->virt) {
 		dev_err(dev, "unable to remap \"gsi\" memory\n");
-		ret = -ENOMEM;
-		goto err_free_irq;
+		return -ENOMEM;
 	}
 
-	ret = gsi_channel_init(gsi, count, data);
+	init_completion(&gsi->completion);
+
+	ret = gsi_irq_init(gsi, pdev);
 	if (ret)
 		goto err_iounmap;
 
+	ret = gsi_channel_init(gsi, count, data);
+	if (ret)
+		goto err_irq_exit;
+
 	mutex_init(&gsi->mutex);
-	init_completion(&gsi->completion);
 
 	return 0;
 
+err_irq_exit:
+	gsi_irq_exit(gsi);
 err_iounmap:
 	iounmap(gsi->virt);
-err_free_irq:
-	free_irq(gsi->irq, gsi);
 
 	return ret;
 }
@@ -2034,7 +2049,7 @@ void gsi_exit(struct gsi *gsi)
 {
 	mutex_destroy(&gsi->mutex);
 	gsi_channel_exit(gsi);
-	free_irq(gsi->irq, gsi);
+	gsi_irq_exit(gsi);
 	iounmap(gsi->virt);
 }
 
-- 
2.20.1

