Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id A60812676ED
	for <lists+netdev@lfdr.de>; Sat, 12 Sep 2020 02:48:05 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726003AbgILArs (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 11 Sep 2020 20:47:48 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:36098 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1725956AbgILApz (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 11 Sep 2020 20:45:55 -0400
Received: from mail-io1-xd31.google.com (mail-io1-xd31.google.com [IPv6:2607:f8b0:4864:20::d31])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 3B8BEC0617A0
        for <netdev@vger.kernel.org>; Fri, 11 Sep 2020 17:45:43 -0700 (PDT)
Received: by mail-io1-xd31.google.com with SMTP id j2so12938761ioj.7
        for <netdev@vger.kernel.org>; Fri, 11 Sep 2020 17:45:43 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linaro.org; s=google;
        h=from:to:cc:subject:date:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=GXt6HV+Ir2mOjyqv+jsDtLLXzMvpXAXcGItzvsZha8c=;
        b=col5BAuWHgufoYczLGg0c0uTkur7OT3fhzhEM2E4Yg1F1SZJ7iCmlUUdT/KWCFtdNO
         VjYKjvkzB8BBop24zMqOLP7RggE8CaaKS4k/0bkg4s63Gqb1D7m7gqfFs7TotA5UOxpZ
         uk8qO33Rqhx3keJuJ4FMcJ6WPFot+5dWJf//FMkXToqd2ohG8zg0K9ZQc269QDLGSx2X
         DFNTK1g4A2VWYztqJbFRkK8+IzKQtI5CYWpWvvD9a1fkcFcxmcrMxH5ndGHlQZyXNVmg
         0tykMnobVMtlDMuW20WnMc7bnQbuzvtgu2G4Ka3MtAwhfI4U0mLZiHbNUDDtCg25Btz+
         FYrw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=GXt6HV+Ir2mOjyqv+jsDtLLXzMvpXAXcGItzvsZha8c=;
        b=J4AnAt6YgXtR3M0IJeBIORK0qIyWqr78f1UkWYM2sMKy7KCbFYWLLs60qUJ64aqivR
         N90me6jyAmrnCoVylU9YbpoqZ80nJyHw+nHcQ+pSkC7KP3orShNJf2qNUZxK9uOApRvk
         fZ7nWAjR2WSqzDN1XF7P0GaMDg918fVweKrT81Dz1OKgrbI0wczI/TgcQTLqodcVRuWA
         1G4lWsrAj0BoIsWyBCVz6VXB88c5acI3rvEb75ycztFH079fwfzoOaliITrMldrlcN/i
         zqpB4+VFByYKflB2XsfyuejON8mly5NezJM+uX8U0IbGN1FfdXLvZrDyxoyAoRx1VwIR
         WmbQ==
X-Gm-Message-State: AOAM531kCyUmQ19fwlIM3GNGep7tYocCrdL9V1/VI6qJAxj/cm7ctCyq
        SXCGJ9aiR2Fjgcn/vbw0/KC/Lg==
X-Google-Smtp-Source: ABdhPJyzpx+Djdb8D8+nDOjBeFx02S6O6iIWzrGQWvaIlO5ReLG4c7iyTcqX4Ls+X/5gTT7empfg4g==
X-Received: by 2002:a05:6638:220c:: with SMTP id l12mr4269019jas.139.1599871542598;
        Fri, 11 Sep 2020 17:45:42 -0700 (PDT)
Received: from beast.localdomain (c-73-185-129-58.hsd1.mn.comcast.net. [73.185.129.58])
        by smtp.gmail.com with ESMTPSA id z4sm2107807ilh.45.2020.09.11.17.45.41
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 11 Sep 2020 17:45:42 -0700 (PDT)
From:   Alex Elder <elder@linaro.org>
To:     davem@davemloft.net, kuba@kernel.org
Cc:     evgreen@chromium.org, subashab@codeaurora.org,
        cpratapa@codeaurora.org, bjorn.andersson@linaro.org,
        netdev@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: [PATCH net-next v2 7/7] net: ipa: do not enable GSI interrupt for wakeup
Date:   Fri, 11 Sep 2020 19:45:32 -0500
Message-Id: <20200912004532.1386-8-elder@linaro.org>
X-Mailer: git-send-email 2.20.1
In-Reply-To: <20200912004532.1386-1-elder@linaro.org>
References: <20200912004532.1386-1-elder@linaro.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

We now trigger a system resume when we receive an IPA SUSPEND
interrupt.  We should *not* wake up on GSI interrupts.

Signed-off-by: Alex Elder <elder@linaro.org>
---
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

