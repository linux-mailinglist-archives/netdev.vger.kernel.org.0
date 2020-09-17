Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 89EE326E301
	for <lists+netdev@lfdr.de>; Thu, 17 Sep 2020 19:55:55 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726440AbgIQRzu (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 17 Sep 2020 13:55:50 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:60500 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726582AbgIQRjm (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 17 Sep 2020 13:39:42 -0400
Received: from mail-il1-x134.google.com (mail-il1-x134.google.com [IPv6:2607:f8b0:4864:20::134])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 0ACBBC061221
        for <netdev@vger.kernel.org>; Thu, 17 Sep 2020 10:39:41 -0700 (PDT)
Received: by mail-il1-x134.google.com with SMTP id t18so3105936ilp.5
        for <netdev@vger.kernel.org>; Thu, 17 Sep 2020 10:39:41 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linaro.org; s=google;
        h=from:to:cc:subject:date:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=QtUWdu0boBZfHKiwa2SwHiBOCnpmKxcR3V7b9dhKC/U=;
        b=ZcH1VLRn9FP/6UN0owL7QxSHThCvJQxUHQ/eE5TwtAGhO+hOJlndEktTeRQunrxBqF
         XujShKHmGZZW9ptlkrTXO6Hy9Gv0zfnSAi7qLkXCBO3KEBsjAeF7VqMWzktTKAtyZPAH
         vclwSl1YMLKxdCW1prHwcBIvTDNclJjMLzAJbd8LS0N6kN1gcTM9plyaz19eD1ELf/oT
         OqrKX1cJE7YhmrtO/tsbOzWswzUWWlGItPyfINy8DeM5pvT4Z+RA+DVZKiq/RyNelDzY
         OuesX2lAGm0GbkgVP3hGoWdtAK6gZzIdUg1nb3H/HYF1lF1j5qKXrkdWwkAObTkkjSqy
         O2QA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=QtUWdu0boBZfHKiwa2SwHiBOCnpmKxcR3V7b9dhKC/U=;
        b=fYZ1GcaAT+VfvK/o2LyLF/+tzLwiizFnUJRrXr3EpOpbOVxRp+ncqSOmxgSttcNqfO
         DtHTbz01SvRj5UL6bSMFTKiLVi4J6rigf2JBat67AB07zoxhTVtRyYaChPIRh7Uw1uaQ
         n0Y/LwvxiFEhA7Tc4oTSkr8H/nydRHnFPXe/XJ/WfQpcuGUOlmZz6Vmb2DqeU/KYkW/s
         pjzLgKCnAGQDKgFVqhWbWwa1vMHKueB0U5yGDM8pyfi0F9sy8suAOTt83e+DimXcv2EM
         wFkP6PpGogGlmucloMO0LcmpFDSsVa79Y6uHz1ytuXn4iPNAon9AcjQBfCsPE0vx8sEU
         h8Ng==
X-Gm-Message-State: AOAM530tLeg3ImAwceaI2WjfQ1dAl2GglwVNwNNbfuhw5R7MrnY1Fvgj
        bIX0I0aICZ9gaaD+iXMsV3GH3oajLBuEfw==
X-Google-Smtp-Source: ABdhPJw2DwhHqg+4Nb9+pBU2XL2/aXqwHh8AAiTKPaykUKEtj11lqJV8gG45MXBObm5T/G3ifVjKGw==
X-Received: by 2002:a92:ca85:: with SMTP id t5mr9989407ilo.254.1600364379249;
        Thu, 17 Sep 2020 10:39:39 -0700 (PDT)
Received: from beast.localdomain (c-73-185-129-58.hsd1.mn.comcast.net. [73.185.129.58])
        by smtp.gmail.com with ESMTPSA id l6sm192725ilt.34.2020.09.17.10.39.38
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 17 Sep 2020 10:39:38 -0700 (PDT)
From:   Alex Elder <elder@linaro.org>
To:     davem@davemloft.net, kuba@kernel.org
Cc:     evgreen@chromium.org, subashab@codeaurora.org,
        cpratapa@codeaurora.org, bjorn.andersson@linaro.org,
        netdev@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: [PATCH net-next v3 7/7] net: ipa: do not enable GSI interrupt for wakeup
Date:   Thu, 17 Sep 2020 12:39:26 -0500
Message-Id: <20200917173926.24266-8-elder@linaro.org>
X-Mailer: git-send-email 2.20.1
In-Reply-To: <20200917173926.24266-1-elder@linaro.org>
References: <20200917173926.24266-1-elder@linaro.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

We now trigger a system resume when we receive an IPA SUSPEND
interrupt.  We should *not* wake up on GSI interrupts.

Signed-off-by: Alex Elder <elder@linaro.org>
Reviewed-by: Bjorn Andersson <bjorn.andersson@linaro.org>
---
v3: Added Bjorn's reviewed-by tag.

 drivers/net/ipa/gsi.c | 17 ++++-------------
 drivers/net/ipa/gsi.h |  1 -
 2 files changed, 4 insertions(+), 14 deletions(-)

diff --git a/drivers/net/ipa/gsi.c b/drivers/net/ipa/gsi.c
index 0e63d35320aaf..cb75f7d540571 100644
--- a/drivers/net/ipa/gsi.c
+++ b/drivers/net/ipa/gsi.c
@@ -1987,31 +1987,26 @@ int gsi_init(struct gsi *gsi, struct platform_device *pdev, bool prefetch,
 	}
 	gsi->irq = irq;
 
-	ret = enable_irq_wake(gsi->irq);
-	if (ret)
-		dev_warn(dev, "error %d enabling gsi wake irq\n", ret);
-	gsi->irq_wake_enabled = !ret;
-
 	/* Get GSI memory range and map it */
 	res = platform_get_resource_byname(pdev, IORESOURCE_MEM, "gsi");
 	if (!res) {
 		dev_err(dev, "DT error getting \"gsi\" memory property\n");
 		ret = -ENODEV;
-		goto err_disable_irq_wake;
+		goto err_free_irq;
 	}
 
 	size = resource_size(res);
 	if (res->start > U32_MAX || size > U32_MAX - res->start) {
 		dev_err(dev, "DT memory resource \"gsi\" out of range\n");
 		ret = -EINVAL;
-		goto err_disable_irq_wake;
+		goto err_free_irq;
 	}
 
 	gsi->virt = ioremap(res->start, size);
 	if (!gsi->virt) {
 		dev_err(dev, "unable to remap \"gsi\" memory\n");
 		ret = -ENOMEM;
-		goto err_disable_irq_wake;
+		goto err_free_irq;
 	}
 
 	ret = gsi_channel_init(gsi, prefetch, count, data, modem_alloc);
@@ -2025,9 +2020,7 @@ int gsi_init(struct gsi *gsi, struct platform_device *pdev, bool prefetch,
 
 err_iounmap:
 	iounmap(gsi->virt);
-err_disable_irq_wake:
-	if (gsi->irq_wake_enabled)
-		(void)disable_irq_wake(gsi->irq);
+err_free_irq:
 	free_irq(gsi->irq, gsi);
 
 	return ret;
@@ -2038,8 +2031,6 @@ void gsi_exit(struct gsi *gsi)
 {
 	mutex_destroy(&gsi->mutex);
 	gsi_channel_exit(gsi);
-	if (gsi->irq_wake_enabled)
-		(void)disable_irq_wake(gsi->irq);
 	free_irq(gsi->irq, gsi);
 	iounmap(gsi->virt);
 }
diff --git a/drivers/net/ipa/gsi.h b/drivers/net/ipa/gsi.h
index 061312773df09..3f9f29d531c43 100644
--- a/drivers/net/ipa/gsi.h
+++ b/drivers/net/ipa/gsi.h
@@ -150,7 +150,6 @@ struct gsi {
 	struct net_device dummy_dev;	/* needed for NAPI */
 	void __iomem *virt;
 	u32 irq;
-	bool irq_wake_enabled;
 	u32 channel_count;
 	u32 evt_ring_count;
 	struct gsi_channel channel[GSI_CHANNEL_COUNT_MAX];
-- 
2.20.1

